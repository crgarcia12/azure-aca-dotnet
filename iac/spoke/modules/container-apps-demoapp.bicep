targetScope='resourceGroup'

param Name string
param Location string
param ManagedEnvironmentId string

resource containerapps 'Microsoft.App/containerapps@2022-03-01' = {
  name: Name
  location: Location
  properties: {
    managedEnvironmentId: ManagedEnvironmentId
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
