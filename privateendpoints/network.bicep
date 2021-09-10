targetScope = 'subscription'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' existing =  {
  name: 'privateendpoint-lab'
}

module vnet1 'network/network1.bicep' = {
  name: 'vnet1'
  scope: resourceGroup(rg.name)
}

module vnet2 'network/network2.bicep' = {
  name: 'vnet2'
  scope: resourceGroup(rg.name)
}

module vnetpeering 'network/vnetpeering.bicep' = {
  name: 'vnetpeering'
  scope: resourceGroup(rg.name)
  params: {
    vnet1name: vnet1.name
    vnet2name: vnet2.name
  }
  
}
