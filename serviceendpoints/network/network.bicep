resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: 'vnet'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/20'
      ]
    }
    subnets: [
      {
        name: 'servers'
        properties: {
          addressPrefix: '10.0.0.0/24'
          serviceEndpoints: [
            {
              locations: [
                'westeurope'
              ]
              service: 'Microsoft.Storage'
            }
          ]
          networkSecurityGroup: {
            id: nsg.id
          }
          routeTable: {
            id: rt.id
          }
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
    ]
  }
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: 'nsg-server'
  location: resourceGroup().location
  properties: {
    securityRules: [
      {
        name: 'allowSSH_Bastion'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          destinationAddressPrefix: 'VirtualNetwork'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          protocol: 'Tcp'
          destinationPortRange: '22'
        }
      }
      {
        name: 'DenyAll'
        properties: {
          priority: 4095
          direction: 'Inbound'
          access: 'Deny'
          destinationAddressPrefix: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          protocol: '*'
          destinationPortRange: '*'
        }
      }
    ]
  }
}

resource rt 'Microsoft.Network/routeTables@2021-02-01' = {
  name: 'routetable-server'
  location: resourceGroup().location
  properties: {
    disableBgpRoutePropagation: true
    routes: [
      {
        name: 'noInternet'
        properties:{
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'None'
        }
      }
    ]
  }
}

resource pubIP 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: 'bastion-ip'
  location: resourceGroup().location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource bastion 'Microsoft.Network/bastionHosts@2021-02-01' = {
  name: 'mybastion'
  location: resourceGroup().location
  sku: {
    name: 'Basic'
  }
  properties: {
    ipConfigurations: [
      {
        name: 'primary'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: pubIP.id
          }
          subnet: {
            id: vnet.properties.subnets[1].id
          }
        }
      }
    ]
  }
}

output serverSubnetId string = vnet.properties.subnets[0].id
