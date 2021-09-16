targetScope = 'subscription'

param serverrg string
param vnetrg string
param vnetname string
param serverDeployed bool = true
param rgName string
param rgLocation string
param env string

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: rgLocation
}

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name: vnetname
  scope: resourceGroup(vnetrg)
}

resource mi 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = if (serverDeployed) {
  name: 'tux'
  scope: resourceGroup(serverrg)
}

module storage 'resources/storageaccount.bicep' = {
  name: 'storage'
  scope: resourceGroup(rg.name)
  params: {
    miid: serverDeployed ? mi.properties.principalId : ''
    pesubnetid: vnet.properties.subnets[0].id
    serverDeployed: serverDeployed
    env: env
  }
}
