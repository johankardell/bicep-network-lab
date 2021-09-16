param miid string
param pesubnetid string
param serverDeployed bool
param env string

resource roleassignblob 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = if (serverDeployed) {
  name: '${guid(resourceGroup().name, 'blobowner')}'
  scope: resourceGroup()
  properties: {
    principalId: miid
    roleDefinitionId: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/ba92f5b4-2d11-453d-a403-e96b0029c9fe'
  }
}

resource roleassigncontrib 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = if (serverDeployed) {
  name: '${guid(resourceGroup().name, 'contributor')}'
  scope: resourceGroup()
  properties: {
    principalId: miid
    roleDefinitionId: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
  }
}

resource sa 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: 'stajokatest${env}'
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: {
    name: env=='prod' ? 'Standard_GRS': 'Standard_LRS'
  }
  properties: {
    supportsHttpsTrafficOnly: true
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
    }
  }
  tags: {
    'purpose': 'lab'
  }
}

resource privateendpoint 'Microsoft.Network/privateEndpoints@2020-06-01' = {
  name: 'pe-sa-${env}'
  location: resourceGroup().location
  properties: {
    subnet: {
      id: pesubnetid
    }
    privateLinkServiceConnections: [
      {
        name: 'pe-sa'
        properties: {
          privateLinkServiceId: sa.id
          groupIds: [
            'blob'
          ]
        }
      }
    ]
  }
}
