targetScope='resourceGroup'

param ContainerAppDefaultHostName string
param ContainerAppLoadBalancerIp string
param VirtualNetworkName string
param VirtualNetworkId string

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: ContainerAppDefaultHostName
  location: 'global'
}

resource privateDnsZoneVnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
  parent: privateDnsZone
  name: VirtualNetworkName
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: VirtualNetworkId
    }
  }
}

// wildecar A record
resource caDnsARecordApps 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  parent: privateDnsZone
  name: '*'
  properties: {
    ttl: 1
    aRecords: [
      {
        ipv4Address: ContainerAppLoadBalancerIp
      }
    ]
  }
}
