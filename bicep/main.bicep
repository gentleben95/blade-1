@description('Specifies the location in which the Azure resources should be deployed.')
param location string = resourceGroup().location
param appName string

// Define the Azure Container Registry (ACR)
resource acr 'Microsoft.ContainerRegistry/registries@2021-06-01-preview' = {
  name: 'acr${appName}' // Removed hyphen and made it alphanumeric
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
        count: 1
        vmSize: 'Standard_B2s'
        maxPods: 30
        type: 'VirtualMachineScaleSets'
        mode: 'System'
        osType: 'Linux'
        osDiskSizeGB: 30
      }
    ]
  }
  dependsOn: [
    acr
  ]
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

// Define the App Service Plan
resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: '${appName}-Plan'
  kind: 'Linux'
  location: location
  sku: {
    name: 'F1'
    tier: 'Free'
  }
}

// Define the Web App
resource webApp 'Microsoft.Web/sites@2021-02-01' = {
  name: 'app-${appName}'
  kind: 'app,linux'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      use32BitWorkerProcess: true // Set to true for compatibility with Free tier
      appCommandLine: 'dotnet AdoOrchestrator.Frontend.dll'
    }
  }
  identity: {
    type: 'SystemAssigned'
  }
  dependsOn: [
    appServicePlan
  ]
}

// Define the Service Bus namespace
resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2021-11-01' = {
  name: 'sb-${appName}'
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
}

// Define the Service Bus queue
resource serviceBusQueue 'Microsoft.ServiceBus/namespaces/queues@2021-11-01' = {
  parent: serviceBusNamespace
  name: 'newRequest'
  properties: {
    enablePartitioning: true
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
  dependsOn: [
    serviceBusNamespace
  ]
}

// Add Service Bus connection string to Key Vault
resource serviceBusConnectionStringSecret 'Microsoft.KeyVault/vaults/secrets@2021-04-01-preview' = {
  parent: keyVault
  name: 'ServiceBusConnectionString'
  properties: {
    value: ''
  }
  dependsOn: [
    keyVault
    serviceBusNamespace
  ]
}

// Add Service Bus queue name to Key Vault
resource serviceBusQueueNameSecret 'Microsoft.KeyVault/vaults/secrets@2021-04-01-preview' = {
  parent: keyVault
  name: 'ServiceBusQueueName'
  properties: {
    value: ''
  }
  dependsOn: [
    keyVault
    serviceBusQueue
  ]
}
