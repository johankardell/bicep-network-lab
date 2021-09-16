resource nsg 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: 'nsg-server-hub'
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

output id string = nsg.id
