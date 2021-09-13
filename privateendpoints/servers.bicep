targetScope = 'subscription'

param vnetrg string
param vnetname string
param rgName string
param rgLocation string
param deployServer bool = true

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: rgLocation
}

resource vnet1 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name: vnetname
  scope: resourceGroup(vnetrg)
}

module linuxvm 'servers/linuxvm.bicep' = if(deployServer){
  name: 'tux'
  scope: resourceGroup(rg.name)
  params: {
    subnetid: vnet1.properties.subnets[0].id
  }
}
