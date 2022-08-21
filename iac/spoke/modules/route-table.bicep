targetScope='resourceGroup'

param Name string
param Location string

resource RouteTable 'Microsoft.Network/routeTables@2022-01-01' = {
  name: Name
  location: Location
  properties: {
    routes: [
      {
        name: 'outboundfw'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopIpAddress: '10.250.1.4'
          nextHopType: 'VirtualAppliance'
        }
      }
    ]
  }
}

output RouteTableId string = RouteTable.id
