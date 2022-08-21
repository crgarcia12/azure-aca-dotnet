targetScope='resourceGroup'

param WorkspaceName string
param AppInsightsName string
param Location string

resource workspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' = {
  name: WorkspaceName
  location: Location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
    workspaceCapping: {
      dailyQuotaGb: 1
    }
  }
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: AppInsightsName
  location: Location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: workspace.id
  }
}
