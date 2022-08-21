targetScope = 'resourceGroup'

param Version int
param Location string
var environmentPrefix = 'crgar-aca-dotnet${Version}'
var contAppEnvName =  '${environmentPrefix}-acaenv'
var contAppName = 'container-apps'

resource containerapps 'Microsoft.App/containerapps@2022-03-01' = {
  name: contAppName
  location: Location
  properties: {
    managedEnvironmentId: '/subscriptions/14506188-80f8-4dc6-9b28-250051fc4ee4/resourceGroups/crgar-aca-dotnet102-rg/providers/Microsoft.App/managedEnvironments/${contAppEnvName}'
    configuration: {
      ingress: {
        external: true
        targetPort: 80
        allowInsecure: true
      }
    }
    template: {
      containers: [
        {
          name: 'sample-container-test'
          image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
          resources: {
            cpu: '0.25'
            memory: '.5Gi'
          }
        }
      ]
    }
  }
}
