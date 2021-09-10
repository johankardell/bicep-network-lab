targetScope = 'subscription'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'privateendpoint-lab'
  location: 'westeurope'
}
