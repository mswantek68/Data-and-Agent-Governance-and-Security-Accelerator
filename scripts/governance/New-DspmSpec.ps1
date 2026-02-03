# Filename: 00-New-DspmSpec.ps1
param(
  [Parameter()][string]$OutFile = "./spec.dspm.template.json",
  [switch]$Force
)

if((Test-Path -Path $OutFile -PathType Leaf) -and -not $Force){
  Write-Host "Spec '$OutFile' already exists. Skipping scaffold (pass -Force to overwrite)." -ForegroundColor Yellow
  return
}

$tmpl = @'
{
  "tenantId": "<aad-tenant-guid>",
  "subscriptionId": "<azure-sub-guid>",
  "location": "eastus",
  "resourceGroup": "rg-purview-dspm",
  "purviewAccount": "mpv-dspm",

  "dataSources": [
    {
      "name": "ds-storage-01",
      "type": "AzureStorage",
      "resourceId": "/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.Storage/storageAccounts/<name>"
    }
  ],

  "scans": [
    {
      "dataSource": "ds-storage-01",
      "name": "scan-storage-01",
      "rulesetType": "System",
      "rulesetName": "AzureStorage"
    }
  ],

  "dlpPolicies": [
    {
      "name": "AI Egress Control (Baseline)",
      "mode": "Enforce",
      "comment": "Blocks sensitive data exfiltration to AI assistants across core workloads.",
      "locations": { "Exchange": "All", "SharePoint": "All", "OneDrive": "All", "Teams": "All", "Endpoint": "All" },
      "rules": [
        {
          "name": "Block High-Confidence Sensitive Data to AI Destinations",
          "sensitiveInfoTypes": [
            { "name": "Credit Card Number", "count": 1, "confidence": 85 },
            { "name": "U.S. Social Security Number (SSN)", "count": 1, "confidence": 85 }
          ],
          "blockAccess": true,
          "notifyUser": true
        }
      ]
    },
    {
      "name": "AI Prompt Guard (Edge/Browsers)",
      "mode": "TestWithNotifications",
      "comment": "Browser/Application enforcement scopes are captured for visibility; automation will warn because those scopes are not yet supported.",
      "enforcementPlanes": ["Browser"],
      "locations": { "Exchange": "All", "SharePoint": "All", "OneDrive": "All", "Teams": "All" },
      "rules": [
        {
          "name": "Detect Sensitive Data in AI Prompts",
          "sensitiveInfoTypes": [ { "name": "Credit Card Number", "count": 1, "confidence": 65 } ],
          "blockAccess": false,
          "notifyUser": true
        }
      ]
    },
    {
      "name": "Default DLP policy - Protect sensitive M365 Copilot interactions",
      "mode": "Enforce",
      "comment": "Baseline Copilot guardrail; approximated with core workloads. Update to your label set or add manual portal enforcement for Copilot services.",
      "locations": { "Exchange": "All", "SharePoint": "All", "OneDrive": "All", "Teams": "All" },
      "rules": [
        {
          "name": "Block Sensitive Data to Copilot",
          "sensitiveInfoTypes": [
            { "name": "Credit Card Number", "count": 1, "confidence": 85 },
            { "name": "U.S. Social Security Number (SSN)", "count": 1, "confidence": 85 }
          ],
          "blockAccess": true,
          "notifyUser": true
        }
      ]
    },
    {
      "name": "DSPM for AI - Protect sensitive data from Copilot processing",
      "mode": "Enforce",
      "comment": "Blocks Copilot/agents from processing items labeled per your sensitivity policy. sensitivityLabels is documented but not yet automated; rule will warn and skip labels until implementation lands.",
      "locations": { "Exchange": "All", "SharePoint": "All", "OneDrive": "All", "Teams": "All" },
      "rules": [
        {
          "name": "Block Labeled Data from Copilot",
          "sensitivityLabels": [ "Highly Confidential", "Confidential" ],
          "blockAccess": true,
          "notifyUser": true
        }
      ]
    },
    {
      "name": "DSPM for AI - Block sensitive info from AI sites",
      "mode": "Enable",
      "comment": "Blocks elevated risk users from pasting/uploading sensitive info to AI sites (Browser enforcement). Enforcement planes are captured; automation will warn until browser scopes are supported.",
      "enforcementPlanes": ["Browser"],
      "locations": { "Exchange": "All", "SharePoint": "All", "OneDrive": "All", "Teams": "All" },
      "rules": [
        {
          "name": "Block Sensitive Info on AI Sites",
          "sensitiveInfoTypes": [
            { "name": "Credit Card Number", "count": 1, "confidence": 85 },
            { "name": "U.S. Social Security Number (SSN)", "count": 1, "confidence": 85 }
          ],
          "blockAccess": true,
          "notifyUser": true
        }
      ]
    },
    {
      "name": "DSPM for AI - Block prompts sent to AI apps in Edge",
      "mode": "Enable",
      "comment": "Blocks elevated risk users from submitting prompts to AI apps in Edge (Browser enforcement). Automation will warn until browser scopes are supported.",
      "enforcementPlanes": ["Browser"],
      "locations": { "Exchange": "All", "SharePoint": "All", "OneDrive": "All", "Teams": "All" },
      "rules": [
        {
          "name": "Block Prompts to AI Apps",
          "sensitiveInfoTypes": [
            { "name": "Credit Card Number", "count": 1, "confidence": 75 },
            { "name": "U.S. Social Security Number (SSN)", "count": 1, "confidence": 75 }
          ],
          "blockAccess": true,
          "notifyUser": true
        }
      ]
    },
    {
      "name": "DSPM for AI - Capture interactions for enterprise AI apps",
      "mode": "TestWithNotifications",
      "comment": "Capture interactions for enterprise AI apps; adjust to Enforce when ready.",
      "locations": { "Exchange": "All", "SharePoint": "All", "OneDrive": "All", "Teams": "All", "Endpoint": "All" },
      "rules": [
        {
          "name": "Capture AI Interactions",
          "sensitiveInfoTypes": [ { "name": "Credit Card Number", "count": 1, "confidence": 65 } ],
          "blockAccess": false,
          "notifyUser": true
        }
      ]
    }
  ],

  "communicationCompliancePolicies": [
    {
      "name": "DSPM for AI - Unethical behavior in AI apps",
      "comment": "Flag unethical behavior related to AI assistants; requires reviewers.",
      "enabled": true,
      "reviewers": [ "compliance.admin@contoso.com" ]
    }
  ],

  "insiderRiskPolicies": [
    {
      "name": "DSPM for AI - Detect risky AI usage",
      "comment": "Detect risky interactions in AI apps; placeholder for manual creation until automation is available.",
      "enabled": true
    }
  ],

  "labels": [
    {
      "name": "Confidential",
      "displayName": "Confidential",
      "tooltip": "Confidential data",
      "publishPolicyName": "Publish: Confidential (All Users)",
      "encryptionEnabled": true,
      "publishScopes": { "Exchange": "All", "SharePoint": "All", "OneDrive": "All" }
    }
  ],

  "retentionPolicies": [
    {
      "name": "AI Data – 7 Years",
      "rules": [ { "name": "Keep 7y then Delete", "durationDays": 2555, "action": "Delete" } ],
      "locations": { "Exchange": "All", "SharePoint": "All", "OneDrive": "All", "TeamsChat": "All", "TeamsChannel": "All" }
    }
  ],

  "activityExport": {
    "outputPath": "./audit_export",
    "contentTypes": ["Audit.General","Audit.SharePoint","Audit.Exchange","DLP.All","Audit.AzureActiveDirectory","Audit.PowerBI"]
  },

  "azurePolicies": [
    {
      "name": "deny-public-access-cognitiveservices",
      "displayName": "Cognitive Services accounts should disable public network access",
      "scope": "resourceGroup",
      "parameters": {}
    }
  ],

  "defenderForAI": {
    "enableDefenderForCloudPlans": ["CognitiveServices","Storage","Containers"],
    "logAnalyticsWorkspaceId": "/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.OperationalInsights/workspaces/<law>",
    "diagnosticCategories": ["Audit","RequestResponse","AllMetrics"]
  },

  "foundry": {
    "resources": [
      {
        "name": "aoai-eastus-01",
        "resourceId": "/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.CognitiveServices/accounts/<openaiAccount>",
        "diagnostics": true,
        "logCategories": ["Audit","RequestResponse","AllMetrics"],
        "tags": { "stage": "4", "owner": "sas-accel", "classification": "ai-workload" }
      }
    ],
    "contentSafety": {
      "endpoint": "https://<contentsafety>.cognitiveservices.azure.com",
      "apiKeySecretRef": {
        "keyVaultResourceId": "/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.KeyVault/vaults/<kv>",
        "secretName": "ContentSafety-ApiKey"
      },
      "textBlocklists": [
        { "name": "pii-terms", "items": ["password","api key","secret","ssn","credit card"] }
      ],
      "harmSeverityThreshold": 6
    }
  }
}
'@

$tmpl | Out-File -FilePath $OutFile -Encoding UTF8 -Force
Write-Host "Scaffolded spec at $OutFile" -ForegroundColor Green