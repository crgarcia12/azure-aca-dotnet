targetScope='subscription'

param Version int
param Location string

var environmentPrefix = 'crgar-aca-dotnet${Version}'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: '${environmentPrefix}-rg'
  location: Location
}

module VirtualNetwork 'modules/virtual-network.bicep' = {
  name: '${environmentPrefix}-vnet'
  scope: resourceGroup
  params: {
    Name: '${environmentPrefix}-vnet'
    Location: Location
  }
}

module LogAnalytics 'modules/monitoring.bicep' = {
  name: '${environmentPrefix}-la'
  scope: resourceGroup
  params: {
    WorkspaceName: '${environmentPrefix}-la'
    AppInsightsName: '${environmentPrefix}-appinsights'
    Location: Location
  }
}

module ContainerAppsEnvironment 'modules/container-apps-environment.bicep' = {
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

module PrivateDnsZone 'modules/private-dns-zone.bicep' = {
  name: '${environmentPrefix}-dns'
  scope: resourceGroup
  params: {
    Location: Location
    ContainerAppDefaultHostName: ContainerAppsEnvironment.outputs.defaultDomain
    ContainerAppLoadBalancerIp: ContainerAppsEnvironment.outputs.staticIp
    VirtualNetworkName: VirtualNetwork.name
    VirtualNetworkId:VirtualNetwork.outputs.vnetId
  }
}

module ContainerAppsdemoapp 'modules/container-apps-demoapp.bicep' = {
  name: '${environmentPrefix}-demoapp'
  scope: resourceGroup
  params: {
    Name: '${environmentPrefix}-acaenv'
    Location: Location
    ManagedEnvironmentId: ContainerAppsEnvironment.outputs.managedEnvironmentId
  }
}
