targetScope='subscription'

param Version int
param Location string

var environmentPrefix = 'crgar-aca-dotnet${Version}'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: '${environmentPrefix}-rg'
  location: Location
}

module VirtualNetwork 'virtual-network.bicep' = {
  name: '${environmentPrefix}-vnet'
  scope: resourceGroup
  params: {
    Name: '${environmentPrefix}-vnet'
    Location: Location
  }
}

module LogAnalytics 'monitoring.bicep' = {
  name: '${environmentPrefix}-la'
  scope: resourceGroup
  params: {
    WorkspaceName: '${environmentPrefix}-la'
    AppInsightsName: '${environmentPrefix}-appinsights'
    Location: Location
  }
}

module ContainerAppsEnvironment 'container-apps-environment.bicep' = {
  name: '${environmentPrefix}-acaenv'
  scope: resourceGroup
  params: {
    Name: '${environmentPrefix}-acaenv'
    Location: Location
    LogAnalyticsWorkspaceName: LogAnalytics.name
    InfrastructureSubnetId: VirtualNetwork.outputs.subnetIds.acainfra
    RuntimeSubnetId: VirtualNetwork.outputs.subnetIds.acaruntime
  }
}
