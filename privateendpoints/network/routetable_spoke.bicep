resource rt 'Microsoft.Network/routeTables@2021-02-01' = {
  name: 'routetable-spoke'
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
