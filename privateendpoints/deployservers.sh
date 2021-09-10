az deployment sub create --name test --template-file ./servers.bicep --location westeurope --param vnetrg='privateendpoint-lab' --param vnetname='vnet1'
