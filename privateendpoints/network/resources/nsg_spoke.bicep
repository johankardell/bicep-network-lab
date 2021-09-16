resource nsg 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: 'nsg-server-spoke'
  location: resourceGroup().location
  properties: {
    securityRules: [
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

output id string = nsg.id
