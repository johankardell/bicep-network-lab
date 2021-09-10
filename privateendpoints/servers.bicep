targetScope = 'subscription'

param vnetrg string
param vnetname string

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'privateendpoint-server-lab'
  location: 'westeurope'
}

resource vnet1 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name: vnetname
  scope: resourceGroup(vnetrg)
}

module linuxvm 'servers/linuxvm.bicep' = {
  name: 'tux'
  scope: resourceGroup(rg.name)
  params: {
    subnetid: vnet1.properties.subnets[0].id
  }
}
