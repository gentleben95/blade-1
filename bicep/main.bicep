@description('Specifies the location in which the Azure resources should be deployed.')
param location string = resourceGroup().location
param appName string
param spnObjectId string

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
resource acrPull 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(resourceGroup().id,aks.name,'7f951dda-4ed3-4680-a7ca-43fe172d538d')
  scope: acr
  properties: {
    principalId: aks.properties.identityProfile.kubeletidentity.objectId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions','7f951dda-4ed3-4680-a7ca-43fe172d538d')
  }
}

// Role assignment for SPN to push to ACR
resource acrPush 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(resourceGroup().id, aks.name, '6257becd-eae4-42d2-8593-baf02263e82e')
  scope: acr
  properties: {
    principalId: spnObjectId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8311e382-0749-4cb8-b61a-304f252e45ec')
  }
}

// Outputs
output acrLoginServer string = acr.properties.loginServer
output aksClusterName string = aks.name
output aksProperties object = aks.properties
output aksIdentity object = aks.identity 
