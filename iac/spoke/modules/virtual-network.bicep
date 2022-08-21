targetScope='resourceGroup'

param Name string
param Location string
param RouteTableId string
param IpSecondSection int

resource VirtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: Name
  location: Location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.${IpSecondSection}.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'acainfra'
        properties: {
          addressPrefix: '10.${IpSecondSection}.0.0/23'
          routeTable: {
            id: RouteTableId
          }
        }
      }
      {
        name: 'acaruntime'
        properties: {
          addressPrefix: '10.${IpSecondSection}.2.0/23'
          routeTable: {
            id: RouteTableId
          }
        }
      }
      {
        name: 'acr'
        properties: {
          addressPrefix: '10.${IpSecondSection}.4.0/24'
          routeTable: {
            id: RouteTableId
          }
        }
      }
    ]
  }
}

resource HubSpokePeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-01-01' = {
  name: '${Name}-peering'
  parent: VirtualNetwork
  properties: {
    allowForwardedTraffic: true
    allowVirtualNetworkAccess: true
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: '/subscriptions/14506188-80f8-4dc6-9b28-250051fc4ee4/resourceGroups/crgar-aca-hub-rg/providers/Microsoft.Network/virtualNetworks/crgar-aca-hub-vnet'
    }
  }
}

output vnetId string = VirtualNetwork.id
output subnetIds object = {
  acainfra: resourceId('Microsoft.Network/virtualNetworks/subnets', Name, 'acainfra')
  acaruntime: resourceId('Microsoft.Network/virtualNetworks/subnets', Name, 'acaruntime')
  acr: resourceId('Microsoft.Network/virtualNetworks/subnets', Name, 'acr')
}
