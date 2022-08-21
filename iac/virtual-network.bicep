targetScope='resourceGroup'

param Name string
param Location string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: Name
  location: Location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'acainfra'
        properties: {
          addressPrefix: '10.0.0.0/23'
        }
      }
      {
        name: 'acaruntime'
        properties: {
          addressPrefix: '10.0.2.0/23'
        }
      }
    ]
  }
}

output subnetIds object = {
  acainfra: resourceId('Microsoft.Network/VirtualNetworks/subnets', Name, 'acainfra')
  acaruntime: resourceId('Microsoft.Network/VirtualNetworks/subnets', Name, 'acaruntime')
}
