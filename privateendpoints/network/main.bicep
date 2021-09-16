targetScope = 'subscription'
param rgName string
param environment string = 'dev'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  name: rgName
}

module rt_hub 'resources/routetable_hub.bicep' = {
  name: 'rt_hub'
  scope: rg
}

module rt_spoke 'resources/routetable_spoke.bicep' = {
  name: 'rt_spoke'
  scope: rg
}

module nsg_hub 'resources/nsg_hub.bicep' = {
  name: 'nsg_hub'
  scope: rg
}

module nsg_spoke 'resources/nsg_spoke.bicep' = {
  name: 'nsg_spoke'
  scope: rg
}

module vnet_hub 'resources/network_hub.bicep' = {
  name: 'vnet_hub'
  scope: resourceGroup(rg.name)
  params: {
    nsgid: nsg_hub.outputs.id
    rtid: rt_hub.outputs.id
  }
}

module vnet_spoke 'resources/network_spoke.bicep' = {
  name: 'vnet_spoke'
  scope: resourceGroup(rg.name)
  params: {
    nsgid: nsg_spoke.outputs.id
    rtid: rt_spoke.outputs.id
  }
}

module vnetpeering 'resources/vnetpeering.bicep' = {
  name: 'vnetpeering'
  scope: resourceGroup(rg.name)
  params: {
    vnet1name: vnet_hub.name
    vnet2name: vnet_spoke.name
  }
}

module bastion 'resources/bastion.bicep' = if (environment != 'dev') {
  scope: resourceGroup(rg.name)
  name: 'bastion'
  params: {
    subnetid: vnet_hub.outputs.bastionSubnetId
  }
}
