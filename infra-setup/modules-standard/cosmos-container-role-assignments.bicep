// Assigns the necessary roles to the AI project

@description('Name of the AI Search resource')
param cosmosAccountName string

@description('Project name')
param projectPrincipalId string

param projectWorkspaceId string

resource cosmosAccount 'Microsoft.DocumentDB/databaseAccounts@2024-12-01-preview' existing = {
  name: cosmosAccountName
  scope: resourceGroup()
}

var roleDefinitionId = resourceId(
  'Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions', 
  cosmosAccountName, 
  '230815da-be43-4aae-9cb4-875f7bd000aa'
)

var accountScope = '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.DocumentDB/databaseAccounts/${cosmosAccountName}/dbs/enterprise_memory'

resource containerRoleAssignmentUserContainer 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2022-05-15' = {
  parent: cosmosAccount
  name: guid(projectWorkspaceId, cosmosAccountName, roleDefinitionId, projectPrincipalId)
  properties: {
    principalId: projectPrincipalId
    roleDefinitionId: roleDefinitionId
    scope: accountScope
  }
}


  
