az deployment sub create --name test --template-file ./servers.bicep --location westeurope --param @servers.dev.json --param deployServer=false
