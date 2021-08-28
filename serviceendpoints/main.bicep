targetScope = 'subscription'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'serviceendpoint-lab'
  location: 'westeurope'
}

module vnet 'network/network.bicep' = {
  name: 'vnet'
  scope: resourceGroup(rg.name)
}

module storage 'storage/storage.bicep' = {
  name: 'storage'
  scope: resourceGroup(rg.name)
  params: {
    allowedSubnetId: vnet.outputs.serverSubnetId
    miid: linuxvm.outputs.miid
  }
}

module linuxvm 'servers/linuxvm.bicep' = {
  name: 'tux'
  scope: resourceGroup(rg.name)
  params: {
    subnetid: vnet.outputs.serverSubnetId
  }
}
