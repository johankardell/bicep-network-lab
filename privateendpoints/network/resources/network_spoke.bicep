param nsgid string
param rtid string

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: 'vnet_spoke'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/20'
      ]
    }
    subnets: [
      {
        name: 'servers'
        properties: {
          addressPrefix: '10.1.0.0/24'
          privateEndpointNetworkPolicies: 'Disabled'
          serviceEndpoints: [
            {
              locations: [
                'westeurope'
              ]
              service: 'Microsoft.Storage'
            }
          ]
          networkSecurityGroup: {
            id: nsgid
          }
          routeTable: {
            id: rtid
          }
        }
      }
    ]
  }
}

output serverSubnetId string = vnet.properties.subnets[0].id
output vnetid string = vnet.id
