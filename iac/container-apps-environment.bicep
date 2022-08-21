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
        customerId: reference('Microsoft.OperationalInsights/workspaces/${LogAnalyticsWorkspaceName}', '2021-06-01').customerId
        sharedKey: listKeys('Microsoft.OperationalInsights/workspaces/${LogAnalyticsWorkspaceName}', '2021-06-01').primarySharedKey
      }
    }
    vnetConfiguration: {
      internal: true
      infrastructureSubnetId: InfrastructureSubnetId // '/subscriptions/14506188-80f8-4dc6-9b28-250051fc4ee4/resourceGroups/crgar-aca-dotnet102-rg/providers/Microsoft.Network/virtualNetworks/crgar-aca-dotnet102-vnet/subnets/acainfra'
      runtimeSubnetId: RuntimeSubnetId // '/subscriptions/14506188-80f8-4dc6-9b28-250051fc4ee4/resourceGroups/crgar-aca-dotnet102-rg/providers/Microsoft.Network/virtualNetworks/crgar-aca-dotnet102-vnet/subnets/acaruntime'
      dockerBridgeCidr: '10.2.0.1/16'
      platformReservedCidr: '10.1.0.0/16'
      platformReservedDnsIP: '10.1.0.2'
    }
  }
}

output managedEnvironmentId string = AcaEnvironment.id
