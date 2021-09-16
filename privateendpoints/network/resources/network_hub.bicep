param nsgid string
param rtid string

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: 'vnet_hub'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
        'fd00:db8:deca::/48'
      ]
    }
    subnets: [
      {
        name: 'servers'
        properties: {
          addressPrefixes: [
            '10.0.0.0/24'
            'fd00:db8:deca::/64'
          ]
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
          addressPrefixes: [
            '10.0.1.0/24'
            'fd00:db8:deca:1::/64'
          ]
        }
      }
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefixes: [
            '10.0.2.0/24'
            'fd00:db8:deca:2::/64'
          ]
        }
      }
      {
        name: 'AzureFirewallSubnet'
        properties: {
          addressPrefixes: [
            '10.0.3.0/24'
            'fd00:db8:deca:3::/64'
          ]
        }
      }
    ]
  }
}

// resource virtualNetworkGateway 'Microsoft.Network/virtualNetworkGateways@2020-11-01' = {
//   name: 'vnetgw'
//   location: resourceGroup().location
//   properties: {
//     ipConfigurations: [
//       {
//         name: 'ipconfig'
//         properties: {
//           privateIPAllocationMethod: 'Dynamic'
//           subnet: {
//             id: v
//           }
//           publicIPAddress: {
//             id: 'publicIPAdresses.id'
//           }
//         }
//       }
//     ]
//     sku: {
//       name: 'Basic'
//       tier: 'Basic'
//     }
//     gatewayType: 'Vpn'
//     vpnType: 'PolicyBased'
//     enableBgp: true
//   }
// }


output serverSubnetId string = vnet.properties.subnets[0].id
output bastionSubnetId string = vnet.properties.subnets[1].id
output vnetid string = vnet.id
