az deployment sub create --name test --template-file ./main.bicep --location westeurope --param @storage.dev.json --param serverDeployed=false
