targetScope='resourceGroup'

param Name string
param Location string
param ContainerAppDefaultHostName string
param ContainerAppLoadBalancerIp string
param VirtualNetworkName string
param VirtualNetworkId string

var DnsDomainName = '${ContainerAppDefaultHostName}.${Location}.azurecontainerapps.io'

param LogAnalyticsWorkspaceName string
param InfrastructureSubnetId string
param RuntimeSubnetId string

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: DnsDomainName
  location: Location
}

resource privateDnsZoneVnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
  parent: privateDnsZone
  name: VirtualNetworkName
  location: Location
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: VirtualNetworkId
    }
  }
}

// wildecar A record
resource caDnsARecordApps 'Microsoft.Network/privateDnsZones/A@2018-09-01' = {
  parent: privateDnsZone
  name: '*'
  properties: {
    ttl: 3600
    aRecords: [
      {
        ipv4Address: ContainerAppLoadBalancerIp
      }
    ]
  }
}
