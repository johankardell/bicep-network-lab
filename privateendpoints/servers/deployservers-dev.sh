az deployment sub create --name test --template-file ./main.bicep --location westeurope --param @servers.dev.json --param deployServer=false
