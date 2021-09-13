param subnetid string

resource pubIP 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: 'bastion-ip'
  location: resourceGroup().location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource bastion 'Microsoft.Network/bastionHosts@2021-02-01' = {
  name: 'mybastion'
  location: resourceGroup().location
  sku: {
    name: 'Basic'
  }
  properties: {
    ipConfigurations: [
      {
        name: 'primary'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: pubIP.id
          }
          subnet: {
            id: subnetid
          }
        }
      }
    ]
  }
}
