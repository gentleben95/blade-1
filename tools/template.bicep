resource app_pgdevopsplatform 'Microsoft.Web/sites@2023-12-01' = {
  name: 'app-pgdevopsplatform'
  location: 'West Europe'
  kind: 'app,linux'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    enabled: true
    hostNameSslStates: [
      {
        name: 'app-pgdevopsplatform.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: 'app-pgdevopsplatform.scm.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    serverFarmId: '/subscriptions/71d54cef-39fb-4b3c-b0f2-fc691caeda8e/resourceGroups/rg-pgdevopsplatform/providers/Microsoft.Web/serverfarms/asp-pgdevopsplatform'
    reserved: true
    isXenon: false
    hyperV: false
    dnsConfiguration: {}
    vnetRouteAllEnabled: false
    vnetImagePullEnabled: false
    vnetContentShareEnabled: false
    siteConfig: {
      numberOfWorkers: 1
      linuxFxVersion: 'DOTNETCORE|8.0'
      acrUseManagedIdentityCreds: false
      alwaysOn: false
      http20Enabled: false
      functionAppScaleLimit: 0
      minimumElasticInstanceCount: 1
    }
    scmSiteAlsoStopped: false
    clientAffinityEnabled: true
    clientCertEnabled: false
    clientCertMode: 'Required'
    hostNamesDisabled: false
    vnetBackupRestoreEnabled: false
    customDomainVerificationId: '1AF267F5DF998FA2E104240F3FE02C6D5E908081C6F562EA48BC929EF17099D8'
    containerSize: 0
    dailyMemoryTimeQuota: 0
    httpsOnly: true
    redundancyMode: 'None'
    storageAccountRequired: false
    keyVaultReferenceIdentity: 'SystemAssigned'
  }
}

resource app_pgdevopsplatform_ftp 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2023-12-01' = {
  parent: app_pgdevopsplatform
  name: 'ftp'
  location: 'West Europe'
  properties: {
    allow: true
  }
}

resource app_pgdevopsplatform_scm 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2023-12-01' = {
  parent: app_pgdevopsplatform
  name: 'scm'
  location: 'West Europe'
  properties: {
    allow: true
  }
}

resource app_pgdevopsplatform_web 'Microsoft.Web/sites/config@2023-12-01' = {
  parent: app_pgdevopsplatform
  name: 'web'
  location: 'West Europe'
  properties: {
    numberOfWorkers: 1
    defaultDocuments: [
      'Default.htm'
      'Default.html'
      'Default.asp'
      'index.htm'
      'index.html'
      'iisstart.htm'
      'default.aspx'
      'index.php'
      'hostingstart.html'
    ]
    netFrameworkVersion: 'v4.0'
    linuxFxVersion: 'DOTNETCORE|8.0'
    requestTracingEnabled: false
    remoteDebuggingEnabled: false
    httpLoggingEnabled: false
    acrUseManagedIdentityCreds: false
    logsDirectorySizeLimit: 35
    detailedErrorLoggingEnabled: false
    publishingUsername: '$app-pgdevopsplatform'
    scmType: 'VSTSRM'
    use32BitWorkerProcess: false
    webSocketsEnabled: false
    alwaysOn: false
    appCommandLine: 'dotnet FEV.DSP.Frontend.dll'
    managedPipelineMode: 'Integrated'
    virtualApplications: [
      {
        virtualPath: '/'
        physicalPath: 'site\\wwwroot'
        preloadEnabled: false
      }
    ]
    loadBalancing: 'LeastRequests'
    experiments: {
      rampUpRules: []
    }
    autoHealEnabled: false
    vnetRouteAllEnabled: false
    vnetPrivatePortsCount: 0
    localMySqlEnabled: false
    managedServiceIdentityId: 17001
    ipSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    ipSecurityRestrictionsDefaultAction: 'Allow'
    scmIpSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictionsDefaultAction: 'Allow'
    scmIpSecurityRestrictionsUseMain: false
    http20Enabled: false
    minTlsVersion: '1.2'
    scmMinTlsVersion: '1.2'
    ftpsState: 'FtpsOnly'
    preWarmedInstanceCount: 0
    elasticWebAppScaleLimit: 0
    functionsRuntimeScaleMonitoringEnabled: false
    minimumElasticInstanceCount: 1
    azureStorageAccounts: {}
  }
}

resource app_pgdevopsplatform_8b5a612c_9099_4d3d_830f_dd77003d3df1 'Microsoft.Web/sites/deployments@2023-12-01' = {
  parent: app_pgdevopsplatform
  name: '8b5a612c-9099-4d3d-830f-dd77003d3df1'
  location: 'West Europe'
  properties: {
    status: 4
    author_email: 'N/A'
    author: 'N/A'
    deployer: 'VSTS'
    message: '{"type":"deployment","commitId":"6737f15daa2cf157c8dae365552ac9537d5fe949","buildId":"8178","buildNumber":"20240228.1","repoProvider":"TfsGit","repoName":"FEV-DevOps","collectionUrl":"https://dev.azure.com/fevgroup/","teamProject":"6fbbfb10-1bf0-43de-882c-a2c5a76e2217","buildProjectUrl":"https://dev.azure.com/fevgroup/6fbbfb10-1bf0-43de-882c-a2c5a76e2217","repositoryUrl":"https://fevgroup@dev.azure.com/fevgroup/FEV-DevOps/_git/FEV-DevOps","branch":"master","teamProjectName":"FEV-DevOps","slotName":"production"}'
    start_time: '2024-02-28T11:18:42.4841065Z'
    end_time: '2024-02-28T11:18:43.8554871Z'
    active: true
  }
}

resource app_pgdevopsplatform_app_pgdevopsplatform_azurewebsites_net 'Microsoft.Web/sites/hostNameBindings@2023-12-01' = {
  parent: app_pgdevopsplatform
  name: 'app-pgdevopsplatform.azurewebsites.net'
  location: 'West Europe'
  properties: {
    siteName: 'app-pgdevopsplatform'
    hostNameType: 'Verified'
  }
}
