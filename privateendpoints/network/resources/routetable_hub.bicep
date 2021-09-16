resource rt 'Microsoft.Network/routeTables@2021-02-01' = {
  name: 'routetable-hub'
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

output id string = rt.id
