targetScope = 'subscription'

param serverrg string
param vnetrg string
param vnetname string

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'privateendpoint-storage-lab'
  location: 'westeurope'
}

resource vnet2 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name: vnetname
  scope: resourceGroup(vnetrg)
}

resource mi 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = {
  name: 'tux'
  scope: resourceGroup(serverrg)
}

module storage 'storage/storage.bicep' = {
  name: 'storage'
  scope: resourceGroup(rg.name)
  params: {
    miid: mi.properties.principalId
    pesubnetid: vnet2.properties.subnets[0].id
  }
}
