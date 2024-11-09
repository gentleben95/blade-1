@description('Specifies the location in which the Azure resources should be deployed.')
param location string = resourceGroup().location
param appName string

// Define the Azure Container Registry (ACR)
resource acr 'Microsoft.ContainerRegistry/registries@2021-06-01-preview' = {
  name: toLower('acr${appName}')
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
  }
}

// Define the AKS cluster
resource aks 'Microsoft.ContainerService/managedClusters@2021-05-01' = {
  name: 'aks-${appName}'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: 'aksdns'
    enableRBAC: true
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 1 // Could be parameterized
        vmSize: 'Standard_B2s' // Could be parameterized
        maxPods: 30
        type: 'VirtualMachineScaleSets'
        mode: 'System'
        osType: 'Linux'
        osDiskSizeGB: 30
      }
    ]
  }
}

// Role assignment for AKS to pull from ACR
resource acrRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(resourceGroup().id, aks.name, '7f951dda-4ed3-4680-a7ca-43fe172d538d')
  scope: acr
  properties: {
    principalId: aks.identity.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
  }
}

// Define the Key Vault
resource keyVault 'Microsoft.KeyVault/vaults@2021-04-01-preview' = {
  name: 'kv-${appName}'
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: aks.identity.principalId
        permissions: {
          secrets: [
            'get'
            'list'
          ]
        }
      }
    ]
  }
}


// Outputs
output acrLoginServer string = acr.properties.loginServer
output aksClusterName string = aks.name
output keyVaultUri string = keyVault.properties.vaultUri
