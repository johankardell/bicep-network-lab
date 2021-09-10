resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: 'vnet2'
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
            id: nsg.id
          }
          routeTable: {
            id: rt.id
          }
        }
      }
    ]
  }
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: 'nsg-server2'
  location: resourceGroup().location
  properties: {
    securityRules: [
      {
        name: 'allowSSH_Bastion'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          destinationAddressPrefix: 'VirtualNetwork'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          protocol: 'Tcp'
          destinationPortRange: '22'
        }
      }
      {
        name: 'DenyAll'
        properties: {
          priority: 4095
          direction: 'Inbound'
          access: 'Deny'
          destinationAddressPrefix: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          protocol: '*'
          destinationPortRange: '*'
        }
      }
    ]
  }
}

resource rt 'Microsoft.Network/routeTables@2021-02-01' = {
  name: 'routetable-server2'
  location: resourceGroup().location
  properties: {
    disableBgpRoutePropagation: true
    routes: [
      {
        name: 'noInternet'
        properties:{
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'None'
        }
      }
    ]
  }
}

output serverSubnetId string = vnet.properties.subnets[0].id
output vnetid string = vnet.id
