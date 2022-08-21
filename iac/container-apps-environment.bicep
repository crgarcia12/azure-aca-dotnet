targetScope='resourceGroup'

param Name string
param Location string
param LogAnalyticsWorkspaceName string
param InfrastructureSubnetId string
param RuntimeSubnetId string

resource AcaEnvironment 'Microsoft.App/managedEnvironments@2022-03-01'  = {
  name: Name
  location: Location
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: reference('Microsoft.OperationalInsights/workspaces/${LogAnalyticsWorkspaceName}', '2020-08-01').customerId
        sharedKey: listKeys('Microsoft.OperationalInsights/workspaces/${LogAnalyticsWorkspaceName}', '2020-08-01').primarySharedKey
      }
    }
    vnetConfiguration: {
      internal: false
      infrastructureSubnetId: InfrastructureSubnetId
      runtimeSubnetId: RuntimeSubnetId
      dockerBridgeCidr: '10.2.0.1/16'
      platformReservedCidr: '10.1.0.0/16'
      platformReservedDnsIP: '10.1.0.2'
    }
  }
}
