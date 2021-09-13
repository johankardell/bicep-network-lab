targetScope = 'subscription'

param rgName string
param rgRegion string

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: rgRegion
}
