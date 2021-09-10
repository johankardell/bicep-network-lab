param subnetid string

resource mi 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: 'tux'
  location: resourceGroup().location
}

resource nic 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: 'nic-linux'
  location: resourceGroup().location
  properties: {
    ipConfigurations: [
      {
        name: 'primary'
        properties: {
          subnet: {
            id: subnetid
          }
        }
      }
    ]
  }
}

resource linuxvm 'Microsoft.Compute/virtualMachines@2021-04-01' = {
  name: 'linuxvm'
  location: resourceGroup().location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${mi.name}': {}
    }
  }
  properties: {
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
    hardwareProfile: {
      vmSize: 'Standard_B2ms'
    }
    osProfile: {
      adminPassword: '1556853612179851791$ABC'
      adminUsername: 'labmaster'
      computerName: 'labvm'
    }
    storageProfile: {
      osDisk: {
        caching: 'ReadWrite'
        diskSizeGB: 128
        createOption: 'FromImage'
        name: 'osdisk-labvm'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '18.04-LTS'
        version: 'latest'
      }
    }
  }
}

output miid string = mi.properties.principalId
