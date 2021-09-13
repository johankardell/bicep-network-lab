az deployment sub create --name test --template-file ./storage.bicep --location westeurope --param @storage.dev.json --param serverDeployed=false
