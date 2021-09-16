param nsgid string
param rtid string

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: 'vnet_hub'
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
            id: nsgid
          }
          routeTable: {
            id: rtid
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

output serverSubnetId string = vnet.properties.subnets[0].id
output bastionSubnetId string = vnet.properties.subnets[1].id
output vnetid string = vnet.id
