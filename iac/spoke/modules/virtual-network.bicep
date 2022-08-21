targetScope='resourceGroup'

param Name string
param Location string

resource VirtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
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
      {
        name: 'cloudshell'
        properties: {
          addressPrefix: '10.0.4.0/23'
        }
      }
      {
        name: 'cloudshellstor'
        properties: {
          addressPrefix: '10.0.6.0/23'
        }
      }
    ]
  }
}

output vnetId string = VirtualNetwork.id
output subnetIds object = {
  acainfra: resourceId('Microsoft.Network/VirtualNetworks/subnets', Name, 'acainfra')
  acaruntime: resourceId('Microsoft.Network/VirtualNetworks/subnets', Name, 'acaruntime')
  cloudshell: resourceId('Microsoft.Network/VirtualNetworks/subnets', Name, 'cloudshell')
}
