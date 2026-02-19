# Tech Talk Presentation Speaker Notes
## Data & Agent Governance and Security Accelerator

---

## Slide 1: Title - Data & Agent Governance and Security Accelerator

### Key Points
- Automation-driven governance across Microsoft AI platform
- Single spec-driven deployment covering Purview DSPM, Defender for AI, Microsoft Foundry, Fabric, and M365 Copilot
- Eliminates manual portal-hopping or disparate scripts by orchestrating governance from a single spec file

### Audience
Security, compliance, and platform teams who need consistent governance for Copilot, Foundry agents, and Fabric data.

### Outcome
One configuration file and one command: registers data sources, applies data security policies, enables threat detection, configures diagnostics, and exports audit logs.

### Why Now
Users are prompting AI today; security and governance controls need to catch up to protect production agent workloads.

### Short (≈30 sec, Executive Summary)
This accelerator automates AI governance across Microsoft's entire AI platform—from Copilot to Foundry to Fabric. Instead of manually configuring dozens of security controls, compliance policies, and monitoring tools across multiple consoles, you define configuration-driven governance in one spec file and deploy everything with a single command. It's governance automation that turns weeks of manual security setup into minutes of deployment time.

### Long (≈3 min, Technical Deep Dive)
Welcome to the Data & Agent Governance and Security Accelerator—a Gold Standard Asset from the Scale AI Solutions org at Microsoft. Our GSAs are designed to get customers and technical sellers from zero to compelling demo in hours, not weeks. This particular accelerator addresses one of the biggest blockers to production AI deployment: governance complexity.

Here's the challenge. When organizations move beyond POC AI agents into production, they face a daunting governance puzzle. You should configure Microsoft Purview for data discovery and classification, set up sensitivity labels across multiple workloads, create DLP policies to prevent data leakage, enable Defender for AI threat detection, route diagnostics to Log Analytics, configure unified audit logging, and implement retention policies. Doing this manually requires navigating multiple admin portals—Purview, Microsoft 365 Compliance, and Azure Portal—with each portal having its own authentication, configuration model, and API surface.

This accelerator takes a radically different approach: configuration-driven governance. You define your entire governance posture in a single JSON specification file—your tenant ID, subscriptions, Purview account, Foundry projects, Fabric workspaces, the sensitivity labels you want applied, DLP policy rules, and retention policies. Then you run one command: the PowerShell scripts read that spec and orchestrate the entire deployment using native Microsoft APIs. Labels are created and published, Purview scans are registered and triggered, DLP policies are enforced, Defender for AI is enabled with diagnostic routing, and audit subscriptions are configured in an idempotent solution.

The result is governance that deploys alongside your AI workloads, not as an afterthought. Security and compliance teams get confidence that controls are consistently applied. Development teams get faster time to production. And everyone gets an audit trail proving that governance was implemented from day one.

This solution integrates five core Microsoft technologies shown in the badges: **Purview Data Security Posture Management (DSPM) for AI** for data discovery and classification, Defender for AI for threat detection, Microsoft Foundry for model hosting and AI orchestration, Microsoft Fabric for data lakehouses, and M365 Copilot for productivity AI. Each one brings critical governance capabilities, and this accelerator wires them together into a cohesive, automated deployment. You decide what you need, and can start from a single solution script to enterprise coverage.

---

## Slide 2: Act One - Setting the Stage

### Key Points
- Manual governance takes weeks: portal by portal, policy by policy
- Delays in production deployment: governance consistency can't be verified across environments
- POCs lose momentum: governance complexity becomes a bottleneck

### Short (≈30 sec, Executive Summary)
Governing AI agents manually creates three critical problems. First, it takes weeks—navigating between Purview portal for data source registration, M365 Compliance Center for DLP policies, Azure Portal for Defender enablement, each with different authentication and configuration models. Second, delays in production deployment happen because manually configured controls can't be verified for consistency across dev, test, and prod environments—security teams rightfully block deployment when they can't prove all controls are present and working. Third, POC momentum dies under the weight of governance complexity—teams who were excited about AI innovation get stuck in weeks of compliance configuration. This accelerator solves all three problems with one spec-driven automation that deploys consistent governance in minutes, not weeks.

### Long (≈3 min, Technical Deep Dive)
Let me frame the operational challenges that block enterprise AI adoption.

**Manual Governance Takes Weeks.** Here's the reality of governing AI agents today: You start in the Purview portal to register Fabric workspaces and OneLake data sources as scan targets—each requires navigating to Purview's data map, authenticating with Azure AD, selecting the subscription and resource, and configuring scan schedules. Then you switch to the M365 Compliance Center to create sensitivity labels and DLP policies—different portal, different authentication model, different configuration schema. Then you move to the Azure Portal to enable Defender for AI plans at the subscription level and configure diagnostic settings on each Foundry Cognitive Services account—yet another portal with its own resource hierarchy and permission model. Finally, you navigate to the M365 Security & Compliance PowerShell module to enable unified audit logging and configure Management Activity API subscriptions.

Each step requires specialized product knowledge. Each portal has different terminology—what Purview calls a "data source" isn't the same as what Defender calls a "resource." Each configuration change requires hunting through documentation to find the right blade, the right toggle, the right API parameter. And because this is all manual clicking, there's no version control, no automation, no ability to say "deploy this exact configuration to three different environments." It takes weeks. Not because the work is inherently complex, but because the operational overhead of coordinating across five different product surfaces is enormous.

**Delays in Production Deployment.** The second problem hits when you try to move from POC to production. You've manually configured governance controls in your dev environment: Purview scans are running, DLP policies are blocking sensitive data leaks, Defender alerts are routing to your test Log Analytics workspace. Everything works. Now you need to replicate those exact controls in production—different subscription, different resource groups, different Purview account, different Log Analytics workspace.

How do you verify that every control from dev is properly configured in prod? You can't. There's no manifest, no spec, no infrastructure-as-code representation of what was configured. The only way to verify is to manually click through each portal and compare settings side-by-side: "Did I enable the same Defender plans? Are the diagnostic settings routing to the right workspace? Are the DLP policies targeting the same sensitive info types?" Manual verification is error-prone and time-consuming.

Security teams rightfully block production deployments when they can't verify governance consistency. They ask: "Can you prove that DLP policies in prod match what was tested in dev? Can you prove that all Foundry projects have diagnostic settings configured? Can you prove that Purview is scanning the production Fabric workspace with the same sensitivity filters?" Without automation, the answer is "I think so, but I can't prove it deterministically." So production deployment is delayed while teams manually reconfigure and re-verify everything. This delay kills momentum.

**POCs Stall Under Governance Complexity.** The third problem is that governance complexity becomes a bottleneck for AI innovation. Development teams are excited to build Foundry agents, to pilot Copilot for productivity use cases, to prototype Fabric analytics. Then compliance teams show up—appropriately—and say "Before this goes live, we need governance controls: sensitivity labels, DLP policies, DSPM scans, Defender threat detection, audit logs, retention policies."

Suddenly what was a two-week POC becomes a two-month compliance project. Developers don't know how to create DLP policies in M365 Compliance Center—that's a compliance officer's skillset. Compliance officers don't know how to configure Purview data source scans—that's a data governance specialist's domain. Security analysts don't know how to enable Defender for AI and route diagnostics to Log Analytics—that's an Azure infrastructure engineer's responsibility. Each role queues up in their respective backlogs, waiting for expertise, waiting for approvals, waiting for someone to manually configure their piece.

POC momentum dies. Executives lose confidence. Business stakeholders question whether AI is worth the operational overhead. And the teams who were excited about innovation get buried in governance complexity. This is the blockerfor enterprise AI adoption—not the technology, but the operational friction of deploying governance manually.

**This Accelerator Solves All Three Problems.** Instead of weeks of manual configuration across five portals, you define your governance posture in one JSON spec file and run one command. The automation orchestrates Purview REST APIs to register data sources, Microsoft Graph Compliance APIs to create DLP policies and labels, Azure Resource Manager to enable Defender plans and configure diagnostics, and Management Activity API to export audit logs.

What used to require expertise in five products now requires editing one file. What used to take weeks happens in minutes. What used to drift between environments deploys consistently every time. And what used to block production deployments becomes provable, version-controlled, deterministic configuration-driven governance.

This is how you make AI enterprise-ready: governance built in from day one, automated, repeatable, and verifiable.

---

## Slide 3: Solution Pillars

### Key Points
- Four governance pillars: Sensitivity Labels, Purview Data Map Scanning, DLP Policies, Defender for AI
- Each pillar addresses a specific governance requirement
- Automation wires them together into cohesive protection

### Short (≈30 sec, Executive Summary)
Four pillars deliver complete AI governance. Sensitivity labels classify data across M365, Foundry, and Fabric. Purview Data Map scanning discovers where sensitive data lives in AI data sources. DLP policies block agents from leaking classified information. And Defender for AI detects prompt injection and model manipulation attacks. Together, they provide comprehensive protection.

### Long (≈3 min, Technical Deep Dive)
This solution is built on four governance pillars, each addressing a critical gap in AI security and compliance.

**Pillar One: Sensitivity Labels.** Labels are the foundation of Microsoft's information protection model. They classify data as Public, Internal, Confidential, or Highly Confidential, and they can apply encryption and access controls. In the AI context, labels do three things. First, they tag documents and datasets so you know which AI interactions involve sensitive data. Second, they enable DLP policies to target specific classifications—you can block any Foundry prompt that references a document labeled Highly Confidential. Third, they provide audit trails proving that data was classified before an AI agent accessed it. This accelerator creates labels via PowerShell, publishes them to Exchange, SharePoint, OneDrive, and Fabric, and ensures they're available for users and automated processes to apply.

**Pillar Two: Purview Data Map and DSPM.** Purview Data Map discovers and classifies data sources across your estate by scanning registered data sources. For AI governance, Data Map scans Fabric workspaces and OneLake data sources to inventory what data AI agents can access. The scans detect sensitive info types and sensitive data patterns like source code, financial data, and healthcare records. They also read existing sensitivity labels and surface where sensitive data is stored without proper protection. DSPM for AI then provides security posture visibility and insights on top of these scan results. This accelerator registers Fabric workspaces and OneLake as Purview data sources, creates and triggers Data Map scans, and surfaces the results so compliance teams have full visibility into data that AI agents query.

**Pillar Three: DLP Policies.** Data Loss Prevention policies enforce rules that block or warn when sensitive data is about to leave your control. For AI agents, DLP inspects prompts and responses in real time. If a user pastes content labeled "Highly Confidential" or proprietary source code into a Copilot chat, DLP can block the interaction and log a policy violation. This accelerator creates DLP compliance policies and rules via PowerShell, targeting specific sensitive info types and labels, and applies them across Exchange, SharePoint, OneDrive, and Teams. DLP coverage for Foundry prompt/response flows is currently in Microsoft's roadmap.

**Pillar Four: Defender for AI.** Microsoft Defender for AI detects threats specific to AI workloads—prompt injection attacks, model manipulation, and jailbreak attempts. When enabled on a Microsoft Foundry resource, Defender monitors inference requests and flags suspicious patterns. The accelerator enables the Defender for AI plan, configures diagnostic settings to route alerts to Log Analytics, and ensures that security teams get real-time visibility into AI threats alongside traditional cloud security alerts in Defender for Cloud.

Together, these four pillars provide defense-in-depth for AI governance. Labels classify, Data Map scans discover sensitive data, DLP enforces access rules, and Defender detects threats. And because it's all automated through one spec file, you get consistent protection across every AI workload.

---

## Slide 4: Architecture Overview

### Key Points
- Data flows from Fabric/Foundry sources through Purview classification
- DLP and Defender enforce real-time protection
- Diagnostics and audit logs feed observability layer
- Spec-driven automation orchestrates entire stack

### Short (≈30 sec, Executive Summary)
This architecture shows how governance controls layer across AI workloads. Purview scans Fabric workspaces and OneLake data sources to discover and classify sensitive content. DLP policies enforce access rules in real time. Defender for AI monitors for threats. And diagnostics flow to Log Analytics for unified observability. All of it automated from one spec file.

### Long (≈3 min, Technical Deep Dive)
This diagram shows the full governance architecture and how data flows through each protection layer.

Starting on the left, we have **AI workloads**: M365 Copilot for productivity, Microsoft Foundry for custom agents and model hosting, and Microsoft Fabric for data engineering and analytics. Each of these products handles user prompts, retrieves data, calls AI models, and returns responses. Without governance, that data flow is opaque—you don't know what sensitive information agents are accessing, whether controls are applied, or if threats are present.

The architecture layers governance controls across this flow. **Microsoft Purview** sits at the foundation, providing Data Security Posture Management. Purview data sources are registered for Fabric workspaces and OneLake roots. Scans run automatically—either on-demand or on a schedule—to discover and classify data. The Purview Data Map becomes the authoritative inventory of what sensitive data exists in locations accessible to AI workloads. Compliance teams can query the map to see which Fabric lakehouses store healthcare data, which sensitivity labels are applied, and which data contains sensitive info types.

**Sensitivity labels** are applied at multiple layers. Users can manually label documents in SharePoint or OneDrive. Purview auto-labeling rules can apply labels based on sensitive info type detection. And Fabric admins can enable labels in the Fabric admin portal so that lakehouses and notebooks inherit classification from upstream data sources. Labels flow through the architecture—when an AI agent retrieves a document labeled Confidential, that classification metadata is preserved and can be inspected by DLP policies.

**DLP policies** enforce access controls in real time. When a Copilot user submits a prompt, DLP policies can inspect the content for sensitive information. DLP policy violations are logged to the unified audit log, creating a compliance trail. Current DLP enforcement applies to M365 workloads (Exchange, SharePoint, Teams); Foundry-specific DLP is on Microsoft's roadmap.

**Defender for AI** monitors the inference layer for threats. Every API request to Azure OpenAI or other Foundry-hosted models passes through Defender's detection engine. Prompt injection attempts, jailbreak patterns, and model manipulation indicators trigger alerts that route to Defender for Cloud and Log Analytics. Security teams get the same unified view of AI threats as they do for traditional cloud threats.

Finally, **observability and audit** tie everything together. Diagnostic settings on Foundry resources route logs to Log Analytics workspaces. M365 unified audit logs capture Copilot interactions, DLP policy hits, and label changes. The accelerator exports audit logs to Azure Blob Storage for long-term retention and can route them to Fabric lakehouses for advanced analytics. Compliance teams get the evidence they need for investigations, and security teams get the telemetry to detect anomalies.

The entire architecture is deployed and configured through the **spec-driven automation** layer. The `spec.local.json` file defines every parameter—which Foundry projects to register, which labels to create, which DLP rules to enforce, which diagnostic settings to enable. The PowerShell scripts orchestrate API calls to Purview, M365 Compliance, Defender for Cloud, and Azure Monitor to make it all real.

What you get is a complete governance fabric that protects AI workloads from data ingestion through model inference to response delivery—all automated, all auditable, all governed as code.

---

## Slide 5: Act Two - Deep Dive & Demo

### Key Points
- Transition from overview to hands-on demonstration
- Next slides walk through deployment workflow step-by-step
- See governance automation in action

### Short (≈30 sec, Executive Summary)
Now let's see how this works in practice. We'll walk through the deployment workflow step-by-step—applying labels, configuring Purview Data Map scans, enforcing DLP policies, and enabling Defender for AI. Each step shows the automation in action and the results you get in each admin portal.

### Long (≈3 min, Technical Deep Dive)
We've covered the architecture and the four governance pillars. Now—let's see the magic happen.

I say "magic," but really, configuration-driven governance isn't magic—it's just really, really well-orchestrated automation. But when you watch configuration that used to take weeks happen in minutes, it sure feels like magic.

In this deep dive, I'm going to walk you through the actual deployment workflow. We'll start with one file—the spec file—your configuration-driven governance manifest, the single source of truth that defines your entire governance posture. Then we'll run one command. Just one. And you'll watch as labels are created, Purview scans are registered, DLP policies are enforced, and Defender for AI is enabled—all automatically.

At each step, I'll pull back the curtain and show you what's happening under the hood: which PowerShell scripts are running, which Microsoft APIs they're calling, and what the end result looks like in the respective admin portals.

The goal here is to demystify the automation and give you confidence that you understand exactly what's being deployed. You're not blindly trusting a black box. You're seeing the orchestration—the structured API calls, the role-based permissions, the idempotent deployment logic. The value is that instead of you manually navigating between portals and configuring each service separately, the code does it for you—consistently, repeatably, and fast.

We'll also see how the governance controls interact. When we apply a sensitivity label to a SharePoint document, and that document is indexed in an Azure AI Search index for a Foundry RAG agent, the label metadata flows through the architecture. Purview scans detect the label and surface it in the Data Map. DLP policies can target that label to block certain interactions. Defender for AI can correlate threats with data classification. It's a cohesive system, not a collection of disconnected tools.

By the end of this demo section, you'll have seen the entire workflow from spec definition through deployment to verification. You'll understand how the accelerator turns governance intent into deployed controls, and how those controls protect AI workloads in production.

Let's dive in.

### Demonstration Steps
1. **Transition statement**: "Let me show you how this works in a real environment."
2. **Open VS Code** with the GitHub repo already cloned
3. **Navigate to `spec.local.json`**—show the file in the editor
4. **Open terminal in VS Code**—prepare to run `.\run.ps1`
5. **Preview the next few slides**—explain the deployment flow we're about to walk through:
   - Slide 6: Deployment Workflow (steps 1-4)
   - Slide 7: Configure spec.local.json parameters
   - Slide 8: Observability & Compliance (steps 5-8)

---

## Slide 6: Deployment Workflow (Steps 1-4)

### Key Points
- Four initial deployment steps: Labels, Purview Data Map Scans, DLP Policies, Defender for AI
- Each step is automated by a PowerShell script reading spec.local.json
- End result: governance controls deployed and enforced

### Short (≈30 sec, Executive Summary)
The deployment workflow has four core steps. First, apply sensitivity labels to classify data across M365, Foundry, and Fabric. Second, register data sources in Purview and configure Data Map scans to discover and classify sensitive data. Third, enforce DLP policies to block sensitive data leakage in prompts and responses. Fourth, configure Defender for AI to detect prompt injection and model manipulation threats.

### Long (≈3 min, Technical Deep Dive)
Let's walk through the first four steps of the deployment workflow.

**Step 01: Apply Sensitivity Labels.** This step creates and publishes sensitivity labels using the PowerShell script `13-Create-SensitivityLabel.ps1`. The script connects to the Microsoft 365 Security & Compliance PowerShell session using `Connect-IPPSSession`, then reads the `labels` array from `spec.local.json`. For each label definition, it calls `New-Label` to create the label with encryption settings, auto-labeling rules, and scope (files, emails, sites). Then it calls `New-LabelPolicy` to publish the label to users across Exchange, SharePoint, OneDrive, and optionally Microsoft Teams and Groups. The labels become available immediately for manual application by users and for auto-labeling by Purview and M365 services. In the AI context, these labels tag documents and datasets so that downstream DLP policies and Purview scans can target specific classifications.

**Step 02: Register Data Sources and Configure Purview Data Map Scans.** This step registers Fabric workspaces and OneLake data sources in Microsoft Purview, then creates and triggers Data Map scans. The script `03-Register-DataSource.ps1` reads the `fabric.workspaces` and `fabric.oneLakeRoots` sections from the spec and calls the Purview API to register each data source. Important architectural clarification: **Foundry agents can query many different data sources—Azure AI Search indexes, SQL databases, SharePoint sites, APIs, and more. However, unifying your data in Fabric (workspaces and OneLake) allows Purview, DLP, and Defender for AI to work seamlessly together.** Fabric provides a single governance surface where Purview scans, classification labels flow automatically, and access policies apply consistently. This accelerator focuses on Fabric as the unified data layer because it simplifies the governance story: one data platform, one registration process, one set of policies. Foundry itself is not a data source; it's the AI platform where agents run. Next, the script `04-Run-Scan.ps1` creates scan rule sets targeting sensitive info types and existing sensitivity labels, then triggers the scans. Purview Data Map crawls the registered Fabric/OneLake data sources, classifies data, and populates the Data Map. DSPM for AI then provides security posture visibility and insights on top of these classified data sources. Compliance teams can now query the Data Map to see which data sources contain sensitive information and whether appropriate labels are applied.

**Step 03: Enforce DLP Policies.** This step creates Data Loss Prevention policies and rules using the script `12-Create-DlpPolicy.ps1`. The script reads the `dlpPolicy` section from the spec, which defines the policy name, mode (Audit, AuditAndNotify, or Enforce), and the sensitive info types or labels to target. It calls `New-DlpCompliancePolicy` to create the policy with specified locations (Exchange, SharePoint, OneDrive, Teams), then `New-DlpComplianceRule` to define the conditions and actions. For example, a rule might block any email, chat message, or document share that contains content labeled "Highly Confidential" or proprietary technical documentation. The policy is published immediately and begins inspecting content in real time across M365 workloads.

**Step 04: Configure Defender for AI.** This step enables the Defender for AI plan at the subscription level and configures diagnostic settings on Foundry resources to route alerts to Log Analytics. Important clarification: **Foundry resource IDs are in the spec so the scripts know which Foundry projects need diagnostics enabled and tags applied. This provides observability and threat detection for the AI platform itself.** The script `06-Enable-DefenderPlans.ps1` uses the Azure CLI or Azure PowerShell to call the Defender for Cloud API, enabling the `AI` plan at the subscription level. Then the script `07-Enable-Diagnostics.ps1` creates diagnostic settings on the Cognitive Services account (parent of Foundry projects) that send Defender for AI alerts, audit logs, and request metrics to a Log Analytics workspace specified in the spec. Security teams can now query the workspace for AI-specific threats, correlate alerts with other cloud security events, and build dashboards showing prompt injection attempts, jailbreak patterns, and model manipulation indicators.

Together, these four steps deploy the core governance controls. Labels classify data, Purview discovers it, DLP enforces access rules, and Defender detects threats. And because it's all automated from one spec file, you can deploy to multiple environments (dev, test, prod) consistently, version-control governance changes, and replay the deployment as your AI estate grows.

### Demonstration Steps
1. **Run the automation**: In VS Code terminal, execute `.\run.ps1` and watch the scripts run in sequence:
   - Observe `13-Create-SensitivityLabel.ps1` executing—note console output showing labels created
   - Observe `03-Register-DataSource.ps1` and `04-Run-Scan.ps1`—note data sources registered in Purview
   - Observe `12-Create-DlpPolicy.ps1`—note policy created with specified mode and rules
   - Observe `06-Enable-DefenderPlans.ps1` and `07-Enable-Diagnostics.ps1`—note Defender plan enabled
2. **Verify each step** in the respective admin portals:
   - **Labels**: Open M365 Compliance Center → Information Protection → Labels → show labels created
   - **DSPM**: Open Purview portal → Data Map → Sources → show Fabric workspaces and OneLake sources registered, scans triggered
   - **DLP**: Open M365 Compliance Center → Data Loss Prevention → Policies → show policy listed
   - **Defender for AI**: Open Defender for Cloud → Environment settings → show "Defender for AI" plan enabled on Foundry resource
3. **Explain real-time enforcement**:
   - **DLP demo**: Attempt to send a Teams message containing content labeled "Highly Confidential"—show DLP policy tip blocking the action
   - **Defender demo**: (If test environment allows) Show a simulated prompt injection attempt in Foundry playground—show Defender alert in Log Analytics

---

## Slide 7: Deployment Step - Configure Parameters

### Key Points
- spec.local.json is the single source of truth for governance configuration
- Defines tenant, subscriptions, Purview, Foundry, Fabric, labels, DLP policies
- Edit once, deploy everywhere

### Short (≈30 sec, Executive Summary)
Before running the automation, you configure `spec.local.json` with your environment parameters—tenant ID, subscription, Purview account name, Foundry projects, Fabric workspaces, sensitivity labels, and DLP policies. This file is your configuration-driven governance manifest. Edit it to match your environment, commit it to source control, and run the deployment. Governance becomes versionable and repeatable.

### Long (≈3 min, Technical Deep Dive)
Let's look at the heart of the accelerator: the `spec.local.json` file. This is your configuration-driven governance manifest—the single file that defines every aspect of your AI governance deployment.

At the top, you specify your **tenant and subscription identifiers**: the `tenantId` where your Microsoft 365 and Azure resources live, the `subscriptionId` where Foundry and Fabric resources are deployed, and the `resourceGroup` where you want compliance evidence stored. These parameters tell the automation where to apply governance controls.

Next, you define your **Purview account**. The `purviewAccount` field is the name of your Microsoft Purview account where data sources will be registered and scans will run. The automation uses this to call Purview's Data Map API and register Foundry and Fabric as discoverable data sources.

The **aiFoundry section** specifies which Microsoft Foundry projects to govern. You provide the project `name` and the full Azure `resourceId` of the Cognitive Services or Azure OpenAI resource that hosts the project. The automation uses this to register the Foundry project in Purview, enable Defender for AI on the resource, and configure diagnostic settings to route logs to Log Analytics. If you have multiple Foundry projects, you can list them as an array—the automation will process each one.

The **fabric section** lists the Fabric workspaces you want to scan. Each workspace has a `name` and a `scanName` (the friendly name for the Purview scan). The automation registers each workspace as a Purview data source, creates a scan rule set targeting sensitive info types and labels, and triggers the scan to classify lakehouse tables, notebooks, and dataflows.

The **dlpPolicy section** defines your Data Loss Prevention policy. You specify the policy `name` (e.g., "AI Egress Control") and the `mode`—either `Audit` (log violations only), `AuditAndNotify` (log and notify users), or `Enforce` (block violations in real time). You can also define `sensitiveInfoTypes` and `labels` (e.g., Confidential, Highly Confidential) to target. The automation creates a DLP compliance policy and rule that inspects content in Exchange, SharePoint, OneDrive, and Teams for these patterns and blocks or audits based on the mode.

The **labels section** is an array of sensitivity label definitions. Each label has a `name`, a `displayName` shown to users, optional `encryptionEnabled` (to apply Azure RMS encryption), and optional `autoLabelingRules` (to auto-apply based on sensitive info types). The automation creates these labels via PowerShell and publishes them to Exchange, SharePoint, OneDrive, and optionally Teams, Groups, and Fabric.

The beauty of this approach is that governance becomes versionable. You commit `spec.local.json` to your Git repository. When you need to add a new Foundry project, you add one entry to the `aiFoundry` array and push the change. When you need to tighten DLP rules, you update the `dlpPolicy.mode` from `Audit` to `Enforce` and redeploy. The spec is the source of truth, and the automation ensures the deployed state matches the spec.

This is configuration-driven governance. It's the same philosophy you use for Azure resources with Bicep or Terraform, applied to compliance controls. And it unlocks the same benefits: repeatability across environments, auditability through version control, and consistency because humans aren't manually clicking through portals.

### Demonstration Steps
1. **Open `spec.local.json` in VS Code** side-by-side with the slide:
   - Highlight the JSON structure on screen and the code panel on the slide—they match
2. **Walk through each section** of the file:
   - **tenantId and subscriptionId**: "This is your Azure tenant and subscription where resources live"
   - **purviewAccount**: "This is your Purview account name—the automation will register data sources here"
   - **aiFoundry.name and resourceId**: "This is your Foundry project—replace these placeholders with your actual project name and resource ID"
   - **fabric.workspaces**: "List each Fabric workspace you want Purview to scan"
   - **dlpPolicy.name and mode**: "Define your DLP policy name and whether to audit or enforce violations"
   - **labels**: "Define each sensitivity label you want created and published"
3. **Show version control workflow**:
   - Run `git log -- spec.local.json` in terminal to show commit history
   - Explain: "Each governance change is tracked, reviewable, and rollback-able via Git"
4. **Explain multi-environment deployment**:
   - Show example: `spec.dev.json`, `spec.prod.json`—same structure, different parameters
   - "You can deploy identical governance to dev and prod by parameterizing the spec file"

---

## Slide 8: Observability & Compliance (Steps 5-8)

### Key Points
- Four observability steps: Telemetry capture, Audit export, Retention policies, Evidence export
- Unified audit log for compliance investigations and eDiscovery
- Diagnostic logs for security monitoring and anomaly detection

### Short (≈30 sec, Executive Summary)
The final four deployment steps ensure observability and compliance. First, capture telemetry by routing Foundry diagnostics to Log Analytics. Second, export the unified audit log to capture all governance events. Third, apply retention policies to auto-retain prompts for eDiscovery. Fourth, export audit logs and policy snapshots for security reviews and regulatory audits.

### Long (≈3 min, Technical Deep Dive)
After deploying the core governance controls, the next four steps ensure you have observability and compliance evidence.

**Step 05: Capture Telemetry.** This step configures diagnostic settings on Microsoft Foundry resources to route logs to a Log Analytics workspace. The script `07-Enable-Diagnostics.ps1` reads the `aiFoundry.diagnosticSettings` section from the spec (or uses defaults) and creates a diagnostic setting via the Azure Monitor API. The setting captures several log categories: `Audit` (who called the API and when), `RequestResponse` (prompt and completion text, if enabled), `Trace` (model inference metrics), and `AllMetrics` (latency, token usage, error rates). These logs flow to the specified Log Analytics workspace where security teams can query them using KQL (Kusto Query Language). You can build dashboards showing which users are accessing which models, which prompts are triggering Defender alerts, and which data sources are being queried by RAG agents.

**Step 06: Export Audit Trail.** This step enables the Microsoft 365 unified audit log and exports audit events to Azure Blob Storage for long-term retention. The script `11-Enable-UnifiedAudit.ps1` uses `Connect-ExchangeOnline` and `Set-AdminAuditLogConfig` to ensure unified auditing is enabled for the tenant. Then the script `21-Export-Audit.ps1` queries the audit log using `Search-UnifiedAuditLog`, filters for events related to Copilot interactions, DLP policy hits, sensitivity label changes, and Purview scans, and exports the results as JSON to a storage account specified in the spec. This creates a compliance audit trail that proves governance was applied and tracks every governance event—who applied a label, when a DLP policy blocked a prompt, which scans were triggered.

**Step 07: Retention Policies.** This step creates retention policies to automatically retain AI-related content for eDiscovery and compliance holds. The script `14-Create-RetentionPolicy.ps1` reads the `retentionPolicies` section from the spec and calls `New-RetentionCompliancePolicy` and `New-RetentionComplianceRule` to define what content to retain and for how long. For example, you might create a policy that retains all Teams messages and Copilot interactions tagged with a specific label (e.g., "Legal Hold") for seven years. The policy applies automatically—when a user sends a Copilot prompt or a Foundry agent generates a response, if the content matches the retention rule, it's preserved in a way that can't be deleted even if the user tries. Legal and compliance teams can later perform eDiscovery searches to retrieve this content for investigations.

**Step 08: Evidence Export.** This final step exports snapshots of governance policies and compliance posture for auditors and security reviewers. The script `17-Export-ComplianceInventory.ps1` queries the M365 Compliance Center APIs to retrieve the current state of all sensitivity labels, DLP policies, retention policies, and auto-labeling rules, then writes the results to JSON files in the `compliance_inventory/` directory of the repo. The script `22-Ship-AuditToStorage.ps1` takes the unified audit log exports from Step 06 and uploads them to Azure Blob Storage with immutable storage policies, ensuring they can't be tampered with. Together, these exports provide point-in-time evidence that governance controls were deployed and enforced—critical for compliance audits, security certifications (ISO 27001, SOC 2), and regulatory examinations (GDPR, HIPAA).

These four steps complete the observability and compliance layer. You now have telemetry for security monitoring, audit trails for compliance investigations, retention policies for eDiscovery, and evidence exports for auditors. And because it's all automated from the spec, you can regenerate the evidence on demand—no manual export steps, no risk of forgetting to capture critical logs.

### Demonstration Steps
1. **Show Log Analytics workspace**:
   - Navigate to Azure Portal → Log Analytics workspace specified in spec
   - Run a KQL query to show Foundry diagnostic logs:
     ```kql
     AzureDiagnostics
     | where ResourceType == "COGNITIVESERVICES" or ResourceProvider == "MICROSOFT.MACHINELEARNINGSERVICES"
     | where Category == "Audit" or Category == "RequestResponse"
     | project TimeGenerated, OperationName, CallerIpAddress, ResultType, Message
     | order by TimeGenerated desc
     | take 20
     ```
   - Explain: "These are real-time logs showing who's calling Foundry models, what prompts are being sent, and whether Defender flagged any threats"
2. **Show unified audit log export**:
   - Navigate to the storage account specified in spec → Blob container for audit exports
   - Download one JSON file and open it—show sample audit events (DLP policy hit, label applied, Purview scan completed)
   - Explain: "This is the compliance audit trail—every governance event is logged and exported for investigations"
3. **Show retention policy**:
   - Navigate to M365 Compliance Center → Data lifecycle management → Retention policies
   - Click on a retention policy created by the automation
   - Show the rule targeting specific labels or content types, retention duration (e.g., 7 years)
   - Explain: "Any AI interaction tagged with this label is automatically retained for eDiscovery—legal teams can search it later"
4. **Show compliance inventory export**:
   - Open the `compliance_inventory/` directory in VS Code
   - Show files: `labels.json`, `dlp_policies.json`, `retention_policies.json`
   - Open one file and scroll through the JSON
   - Explain: "This is a snapshot of your governance posture—labels, DLP rules, retention policies—that you can hand to auditors or use for change tracking"

---

## Slide 9: Role-Aligned & Policy-Driven Workflows

### Key Points
- Leverages native Azure and M365 RBAC roles for governance deployment
- Policy-driven approach ensures consistent governance across environments
- Enterprise security aligned to Zero Trust principles
- Accelerates production deployment with built-in governance

### Short (≈30 sec, Executive Summary)
This accelerator aligns with enterprise role-based access control and Zero Trust security models. It uses Purview Data Source Admin for scan management, Security Reader for Defender alerts, and Compliance Admin for DLP and labels. Governance is driven by policies defined in the spec, ensuring consistency across dev, test, and prod. You protect at MCEM Stage 3 and accelerate to Stage 4 with confidence.

### Long (≈3 min, Technical Deep Dive)
One of the core design principles of this accelerator is role alignment and policy-driven governance. Let me explain what that means in practice.

**Role-Aligned Execution.** The automation doesn't require Global Admin or Owner rights on your entire tenant. Instead, it uses the principle of least privilege, assigning only the specific Azure and M365 roles needed for each task. To register data sources and run scans in Purview, the automation uses the **Purview Data Source Administrator** role on the Purview account. To create and publish sensitivity labels and DLP policies, it uses the **Compliance Administrator** role in M365. To enable Defender for AI and read security alerts, it uses the **Security Reader** or **Defender for Cloud Contributor** role on the Azure subscription. This role separation aligns with Zero Trust principles—different teams can manage different governance layers without requiring elevated access across the entire platform. A compliance officer can update DLP rules without needing Azure subscription access. A security analyst can read Defender alerts without having rights to modify Purview scans.

**Policy-Driven Governance.** The spec file is the policy. Instead of relying on manual checklists or runbooks that describe what settings to configure, the spec declares the desired state, and the automation enforces it. This is configuration-driven governance. If the spec says "create a DLP policy in Enforce mode targeting Highly Confidential labels," the automation ensures that policy exists and is configured exactly as specified. If you deploy to three environments—dev, test, and prod—you can use the same automation with three different spec files, ensuring that dev has relaxed policies for experimentation while prod enforces strict controls. The policy is versioned in Git, reviewed through pull requests, and applied deterministically by code. This eliminates configuration drift—you can't have a situation where dev has a label that prod doesn't, or where DLP rules differ between environments because someone manually changed a setting.

**Enterprise Security and Zero Trust Alignment.** The accelerator implements defense-in-depth across the AI estate. Sensitivity labels classify data at rest and in transit. DLP policies enforce access controls in real time based on those classifications. Purview Data Map provides continuous discovery and classification of sensitive data, while DSPM for AI provides security posture visibility showing where sensitive data lives and whether it's properly protected. Defender for AI monitors the inference layer for malicious activity. Diagnostic logs and audit trails provide the observability needed to detect anomalies and respond to incidents. This layered approach aligns with Zero Trust principles: verify explicitly (via labels and Data Map scans), use least-privilege access (via role-aligned deployment), and assume breach (via Defender threat detection and audit logging).

**Production Accelerator for MCEM Stage 3 to 4.** The Microsoft Cloud Enablement Model (MCEM) defines four stages of AI adoption: Inspire (vision), Design (architecture), Empower (POC and pilot), and Realize (production deployment). Most organizations get stuck between Stage 3 and Stage 4 because governance becomes a blocker. Security and compliance teams say "you can't go to production until we've configured labels, DLP, Purview Data Map scans, Defender, diagnostics, and retention policies"—and that takes weeks of manual work. This accelerator removes the blocker by making governance deployable alongside the AI workload. You can protect your Stage 3 pilot with the same controls you'll use in Stage 4 production, giving stakeholders confidence that security and compliance won't be a last-minute scramble. And because governance is automated, you can iterate quickly—deploy to dev, test, and prod in hours instead of weeks.

### Demonstration Steps
1. **Show role assignments**:
   - Navigate to Azure Portal → Purview account → Access control (IAM)
   - Show "Purview Data Source Administrator" role assigned to the service principal or user running the automation
   - Navigate to M365 admin center → Roles → Compliance → Compliance Administrator
   - Show the user/service principal assigned
   - Explain: "These are the minimum roles needed—no Global Admin required"
2. **Show policy-driven consistency**:
   - Open two spec files side-by-side: `spec.dev.json` and `spec.prod.json`
   - Highlight differences: dev has `dlpPolicy.mode: "Audit"`, prod has `"Enforce"`
   - Explain: "Same automation, different policies—dev audits for testing, prod enforces for compliance"
3. **Show Zero Trust evidence**:
   - Navigate to Log Analytics workspace → run query showing DLP policy evaluations and Defender alerts
   - Explain: "We verify every interaction (DLP), use least privilege (roles), and assume breach (Defender detection)"
4. **Show MCEM Stage 3→4 acceleration**:
   - Display a timeline diagram or slide overlay:
     - **Traditional**: Stage 3 POC → 4-6 weeks manual governance setup → Stage 4 Production
     - **Accelerated**: Stage 3 POC with governance automated → 1 day to deploy to prod → Stage 4 Production
   - Explain: "Governance isn't a post-POC blocker—it's built in from day one"

---

## Slide 10: MCEM Readiness Stages

### Key Points
- Four MCEM stages: Inspire, Design, Empower (POC/Pilot), Realize (Production)
- Most organizations get blocked between Stage 3 and 4 due to governance complexity
- This accelerator enables governance at Stage 3, accelerating Stage 4 production deployment
- Compliance controls verified from day one

### Short (≈30 sec, Executive Summary)
The Microsoft Cloud Enablement Model defines four AI adoption stages. Most organizations stall between Stage 3 pilot and Stage 4 production because governance takes weeks to configure manually. This accelerator enables governance-ready pilots at Stage 3, so you can move to production-scale deployment at Stage 4 in days, not months, with compliance controls already verified.

### Long (≈3 min, Technical Deep Dive)
This accelerator aligns with the Microsoft Cloud Enablement Model (MCEM) at every stage of AI adoption, removing governance as a barrier and making it an accelerator instead.

**Stage 2 - Design: Governance Architecture You Can Share.** During architecture and planning, you can share the `spec.local.json` file with security and compliance stakeholders to show exactly what governance controls will be deployed. This isn't a promise or a wishlist—it's the actual configuration that will be enforced. Security architects can review which sensitivity labels will be created, which DLP policies will be applied, how Defender for AI will be configured, and where diagnostics will flow. They can propose changes, and those changes are captured as code. The governance blueprint is concrete, reviewable, and version-controlled from day one.

**Stage 3 - Empower: Prove Compliance with a Governed POC.** During POC and pilot, you deploy the accelerator alongside your AI solution. The POC runs with governance already in place—labels applied, Purview scans running, DLP policies active (in Audit mode to log violations without blocking), Defender monitoring for threats, and diagnostics flowing to Log Analytics. Security and compliance teams don't need to trust your promises—they can validate the controls are working. They can query the unified audit log to see policy evaluations. They can review Defender alerts in Log Analytics. They can verify that Purview has classified sensitive data. The POC proves that governance works, not just that the AI works.

**Stage 4 - Realize: Move to Enforcement at Production Scale.** When you're ready for production deployment, you don't reconfigure governance from scratch. You update the spec with production tenant and subscription IDs, change `dlpPolicy.mode` from `"Audit"` to `"Enforce"`, and redeploy. The same labels, DLP policies, Purview scans, Defender settings, and diagnostic configurations that you validated in Stage 3 are deployed in Stage 4. The only differences are scale (more users, more data sources, more audit volume) and enforcement posture (DLP now blocks violations in real time instead of just logging them). No manual reconfiguration. No weeks-long delay. No risk of missing a step. Governance transitions from monitoring to enforcement with a single parameter change.

This approach fundamentally changes the MCEM journey. Governance isn't a post-POC checklist that blocks production—it's a deployment capability that accelerates production. You prove compliance in Stage 3, enforce compliance in Stage 4, and move between them in hours instead of weeks.

### Demonstration Steps
1. **Walk through the MCEM flow diagram** on the slide:
   - Point to **Stage 1 (Inspire)** and **Stage 2 (Design)**: "These stages define the vision and architecture"
   - Point to **Stage 3 (Empower)**: Highlight the green "✅ Governance Ready" badge
     - Explain: "This is where the accelerator comes in—governance is deployed alongside the POC"
   - Point to **Stage 4 (Realize)**: Highlight the green "🚀 Secure & Compliant" badge
     - Explain: "Because governance was tested in Stage 3, moving to Stage 4 is just a re-deployment with prod parameters"
2. **Show the spec-driven deployment workflow**:
   - Display two spec files: `spec.pilot.json` (Stage 3) and `spec.prod.json` (Stage 4)
   - Highlight that governance sections (`labels`, `dlpPolicy`, `purviewAccount`) are identical
   - Only `tenantId`, `subscriptionId`, and scale-related parameters differ
   - Run the deployment: `.\run.ps1 -SpecPath .\spec.prod.json`
   - Explain: "Same automation, production environment—governance deployed in minutes"
3. **Show the timeline acceleration**:
   - Create a visual or verbal comparison:
     - **Traditional approach**: 6 weeks between Stage 3 and Stage 4 (manual governance reconfiguration)
     - **Accelerated approach**: 1 day between Stage 3 and Stage 4 (automated re-deployment)
   - Explain: "This is the time-to-production advantage—governance doesn't block, it enables"

---

## Slide 11: Act Three - Key Takeaways

### Key Points
- Transition to the final act: summarizing benefits and next steps
- Three key takeaways: accelerated POC-to-production, reduced risk, unified observability

### Short (≈30 sec, Executive Summary)
We've seen how the accelerator works. Now let's capture the key takeaways. Three things to remember: First, you accelerate from POC to production with automated compliance. Second, you reduce risk with enforced policies and threat detection. Third, you gain full observability across AI workloads. One command drives it all.

### Long (≈3 min, Technical Deep Dive)
We're entering the final act—the part where I tell you the three things you absolutely need to remember when you walk out of this room.

We've walked through a lot—the architecture, the four governance pillars, the deployment workflow, the MCEM alignment. We've seen one spec file orchestrate deployment across Purview, M365 Compliance, Defender for Cloud, and Azure Monitor. We've watched governance controls deploy in minutes that used to take weeks.

Now let's distill all of that into three core takeaways—three things you can share with your CISO, your compliance officer, your development team, or your customer. Three reasons why this approach changes the game for AI governance.

**Takeaway One: Accelerate from POC to Production.** The traditional AI adoption journey has a governance gap between pilot and production. POCs work in sandboxes with relaxed controls. Moving to production requires reconfiguring security and compliance tools, which takes weeks and blocks deployment. This accelerator eliminates that gap by making governance deployable as code. The same controls you test in the POC are deployed in production—no manual reconfiguration, no delay. That means you can move faster, deliver AI solutions to users sooner, and realize business value without waiting for security reviews.

**Takeaway Two: Reduce Risk with Automated Policy Enforcement.** Manual governance is fragile. Settings get misconfigured, steps get skipped, and controls drift between environments. Automated governance is deterministic—the spec defines the policy, the code enforces it. DLP policies block sensitive data leakage in real time. Defender for AI detects prompt injection and model manipulation. Purview Data Map continuously scans to discover exposed sensitive data, while DSPM for AI provides security posture insights. Sensitivity labels classify content so policies can target it. The result is reduced risk because governance controls are consistently applied and continuously enforced.

**Takeaway Three: Gain Full Observability Across AI Workloads.** Visibility is essential for security and compliance. You can't secure what you can't see. This accelerator provides unified observability by routing diagnostics to Log Analytics, exporting audit logs to storage, and surfacing Purview scan results in the Data Map. Security teams can query logs to detect anomalies. Compliance teams can search audit trails for policy violations. Executives can view dashboards showing governance posture across Copilot, Foundry, and Fabric. Observability becomes a byproduct of governance automation, not a separate project.

And the most powerful part? One command drives it all. `.\run.ps1` reads the spec and orchestrates governance deployment across Purview, M365 Compliance, Defender for Cloud, and Azure Monitor. What used to require navigating multiple portals and coordinating across teams now takes minutes. What required deep expertise in Purview, Defender, M365 Compliance, and Azure Monitor now requires editing one JSON file. Governance becomes accessible, repeatable, and scalable.

These are the takeaways to remember and share: speed, security, and observability—delivered through automation.

---

## Slide 12: Why Governance-First Matters

### Key Points
- Traditional approach delays production: build POC first, scramble to add governance later
- Manual controls create verification gaps: controls added after development are error-prone
- Governance-first proves controls work early: validated during POC, not at production gate
- Removes bottlenecks: governance deployed with agents, no reconfiguration between environments

### Short (≈30 sec, Executive Summary)
Governance-first means building security and compliance into AI from the start, not retrofitting it later. The traditional approach—build POC, then add governance—delays production by weeks. Manual controls create verification gaps because controls added after development are error-prone and can't be verified consistently. With governance-first, controls are validated during POC, not at the production gate. This removes the bottleneck: governance deploys with agents, no reconfiguration needed between environments.

### Long (≈3 min, Technical Deep Dive)
Let me explain why the governance-first approach fundamentally changes how enterprises adopt AI at scale.

**Traditional Approach Delays Production.** Here's the typical story: Development builds an amazing Foundry agent. POC works beautifully. Everyone's excited. Then it's time to move to production, and security says "Wait—where are the DLP policies? Where's the threat detection? Where's the audit trail?" Suddenly you're scrambling to add governance controls that should have been there from day one. You navigate between Purview portal to register data sources, M365 Compliance Center to create labels and DLP policies, Azure Portal to enable Defender for AI and configure diagnostics. Each portal has different authentication, different configuration models, different validation rules. It takes weeks to configure everything manually. Test to verify controls work. Document compliance evidence for auditors. By the time governance is ready, the POC momentum is lost, stakeholders are frustrated, and the AI project gets deprioritized.

This delay is expensive. Not just in calendar time, but in opportunity cost—competitors are deploying AI faster, customers are waiting for features, and your team's productivity is blocked by governance reconfiguration. The traditional approach treats governance as a gate review at the end of development, rather than a built-in capability from the start.

**Manual Controls Create Verification Gaps.** When governance is added after development, it's fragile. Manual configuration introduces errors: A compliance officer creates a DLP policy in the test environment but forgets to replicate it in prod. A security analyst enables Defender for AI but misconfigures diagnostic settings, so alerts never reach the security team. A data steward publishes sensitivity labels to SharePoint but not to Fabric, so Fabric data remains unclassified. Each gap creates risk—sensitive data leaks, threats go undetected, compliance evidence is missing.

Security teams rightfully block production deployments when governance is retroactively added, because they can't verify controls are complete and consistent. There's no spec proving what was configured. There's no automation ensuring settings match across environments. There's no Git history showing who changed what policy and when. Manual governance means governance drift—what works in test might not be configured in prod. And when an audit happens, you scramble to export evidence from multiple systems to prove controls existed at the right time.

**Governance-First Proves Controls Work Early.** With a governance-first approach, the story changes. You deploy the POC with governance controls already configured from the spec file: sensitivity labels, DLP policies, Purview scans, Defender for AI, diagnostic settings, retention policies. The POC isn't just proving the AI functionality works—it's proving the governance controls work. Security and compliance teams validate during the POC: Does DLP block sensitive data leakage? Does Defender detect prompt injection? Do diagnostics route to Log Analytics? Are prompts retained for eDiscovery? When validation happens during POC, not at the production gate, you catch issues early when they're cheap to fix. And when it's time to move to production, governance isn't a blocker—it's already proven.

This shifts security from being a gate review at the end to being a continuous validation partner throughout development. Security isn't saying "no" at the last minute; they're saying "yes, this is secure" early in the process.

**Removes Bottlenecks, Accelerates Adoption.** The governance-first approach removes the biggest bottleneck in enterprise AI adoption: the reconfiguration delay between POC and production. With traditional approaches, POC governance is configured manually in test subscriptions, then you manually reconfigure everything for production—different subscriptions, different resource groups, different Purview accounts, different Log Analytics workspaces. Each reconfiguration introduces risk of errors, takes time to validate, and requires coordination across teams.

With this accelerator, governance is defined in the spec file. Deploy to POC using `spec.dev.json`. Validate controls work. Then deploy to production using `spec.prod.json`—same automation, same controls, just different resource IDs and scale parameters. No manual reconfiguration. No portal clicking. No coordination delays. Governance deploys in minutes, not weeks. And because it's automated, you can deploy to multiple regions, multiple business units, multiple customer tenants—all with the same consistent governance posture.

This acceleration isn't just about speed. It's about confidence. Teams can innovate knowing governance will deploy alongside their AI solutions. Security can approve production deployments knowing controls are proven and consistent. Executives can invest in AI knowing compliance is automated, not an afterthought.

Governance-first makes security and compliance enablers of AI adoption, not blockers.

---

## Slide 12: Enterprise Benefits

### Key Points
- Four enterprise benefits: Compliance (automated retention, DLP, audit), Security (threat detection, Content Safety), Observability (unified telemetry), Speed (automation replaces manual portal navigation)
- Each benefit delivered through automation, not manual configuration
- Measurable outcomes: faster time to production, reduced security incidents, audit-ready evidence

### Short (≈30 sec, Executive Summary)
This accelerator delivers four enterprise benefits. Compliance: automated retention policies, DLP enforcement, and audit trails for investigations. Security: Defender for AI threat detection and Content Safety guardrails. Observability: unified telemetry across Copilot, Foundry, and Fabric in one Log Analytics workspace. Speed: manual portal navigation reduced to one command, accelerating time to production.

### Long (≈3 min, Technical Deep Dive)
Let's break down the concrete enterprise benefits you get from deploying this accelerator.

**Benefit One: Compliance.** Compliance isn't just about checking boxes—it's about proving to auditors, regulators, and stakeholders that you have controls in place and evidence that they're working. This accelerator automates three critical compliance capabilities. First, **retention policies** ensure that AI interactions—Copilot chats, Foundry prompts, Fabric query logs—are automatically preserved for eDiscovery and legal holds. If a compliance investigation requires reviewing every prompt a user sent over the past year, you have that data retained and searchable. Second, **DLP enforcement** ensures that sensitive data doesn't leak through AI interactions. If a user tries to paste proprietary source code or confidential documents into a Copilot prompt, DLP blocks it in real time and logs a policy violation. If a Foundry agent's response would expose content labeled "Highly Confidential," DLP prevents that response from being delivered. Third, **audit trails** capture every governance event—who applied a sensitivity label, when a Purview scan ran, which DLP policies were hit, which Defender alerts fired. These logs are exported to immutable storage so they can be handed to auditors or used in compliance certifications (ISO 27001, SOC 2, GDPR, HIPAA).

**Benefit Two: Security.** Security for AI workloads requires both preventive and detective controls. This accelerator delivers both. **Defender for AI** provides detective controls by monitoring inference requests for malicious patterns—prompt injection attempts where an attacker tries to override system instructions, jailbreak attempts where a user tries to bypass content filters, and model manipulation where an adversary tries to extract training data. When Defender detects these threats, it generates alerts that route to Defender for Cloud and Log Analytics, where security teams can investigate and respond. **Content Safety** (an optional integration) provides preventive controls by scanning prompts and responses for harmful content—hate speech, violence, self-harm, sexual content—and blocking or redacting it before delivery. Together, Defender and Content Safety create a defense-in-depth security posture for AI workloads.

**Benefit Three: Observability.** Observability means you can answer critical questions about your AI workloads: Who is using which models? What data sources are agents accessing? Are there performance issues or error spikes? Are there unusual usage patterns that might indicate a security incident? This accelerator provides observability by routing all telemetry to a unified Log Analytics workspace. **Foundry diagnostics** capture API calls, request/response payloads (if enabled), model inference metrics (latency, token usage), and errors. **M365 unified audit logs** capture Copilot interactions, DLP policy evaluations, and label changes. **Purview scan logs** capture what data sources were scanned, what sensitive info types were detected, and what labels were applied. Security and compliance teams can query these logs using KQL to build dashboards, set up alerts for anomalies, and conduct investigations. Executives can view usage reports showing AI adoption trends—how many users are engaging with Copilot, how many Foundry agents are deployed, how much data is being processed in Fabric.

**Benefit Four: Speed.** The most tangible benefit is time savings. Configuring governance manually requires navigating multiple admin portals—Purview, M365 Compliance, Azure Portal—and coordinating configuration across separate API surfaces. Each service has its own authentication, configuration model, and export mechanism. This accelerator reduces that complexity to one command: `.\run.ps1`. The automation handles API authentication, retry logic, idempotency (so re-running the command doesn't create duplicates), and error handling. It's repeatable—you can deploy to dev, test, prod with the same automation, ensuring consistency. And it's versionable—you can track governance changes in Git and roll back if needed.

These four benefits—compliance, security, observability, and speed—translate to measurable business outcomes: faster time to production for AI solutions, reduced security incidents due to enforced controls and threat detection, audit-ready compliance evidence without manual export processes, and lower operational overhead because governance is automated.

---

## Slide 13: Microsoft Solution Play - Secure & Govern AI

### Key Points
- Aligns with Microsoft's Secure & Govern AI solution play and strategy
- Integrates Purview, Defender, Foundry, and Fabric into cohesive governance
- Builds on MCEM readiness stages for structured AI adoption
- Supports hybrid AI workloads across M365 and Azure

### Short (≈30 sec, Executive Summary)
This accelerator aligns with Microsoft's Secure & Govern AI solution play, integrating Purview for data governance, Defender for threat detection, Foundry for AI orchestration, and Fabric for analytics. It builds on the MCEM readiness model, enabling governance at every adoption stage. And it supports hybrid AI workloads spanning M365 Copilot and Azure AI services.

### Long (≈3 min, Technical Deep Dive)
This accelerator is built on Microsoft's Secure & Govern AI solution play, which provides a comprehensive strategy for securing and governing AI workloads across the Microsoft Cloud.

**Alignment with Secure & Govern AI Strategy.** Microsoft's vision for AI governance is built on three pillars: **responsible AI** (ensuring models are fair, transparent, and accountable), **data governance** (ensuring data used by AI is classified, protected, and compliant), and **operational security** (ensuring AI workloads are monitored, protected from threats, and auditable). This accelerator implements the data governance and operational security pillars by automating Purview for data classification, DLP for access control, Defender for threat detection, and diagnostics for observability. It doesn't replace Microsoft's responsible AI tooling (like model cards, fairness assessments, or transparency notes)—it complements it by ensuring that the data and infrastructure layers are governed and secure.

**Integration of Purview, Defender, Foundry, and Fabric.** One of the challenges in AI governance is that each Microsoft product has its own admin portal, its own configuration model, and its own logging mechanisms. Purview has the Data Map and Compliance portal. Defender has Defender for Cloud. Foundry has the Azure AI Studio portal. Fabric has the Fabric admin portal. M365 Copilot has the M365 admin center and Compliance Center. Trying to configure governance across all five manually is complex and error-prone. This accelerator provides the glue layer that integrates them. The `spec.local.json` file is the unified governance model—it defines data sources for Purview (Fabric workspaces and OneLake), threat detection for Defender, diagnostic settings for Foundry, and label enablement for Fabric. The PowerShell scripts orchestrate API calls to each product, ensuring they're wired together correctly. The result is a cohesive governance layer where labels created in M365 Compliance are available in Fabric, where Purview scans discover sensitive data in Fabric workspaces, where Defender alerts correlate with DLP policy hits, and where all logs flow to a single Log Analytics workspace.

**MCEM Readiness Stages.** Microsoft's Cloud Enablement Model provides a maturity framework for AI adoption. This accelerator specifically targets the transition from **Stage 3 (Empower - POC and pilot)** to **Stage 4 (Realize - production deployment)**. In Stage 3, organizations are testing AI solutions in controlled environments with limited users. Governance needs to be in place, but it also needs to be flexible enough to allow experimentation. The accelerator enables this by supporting "Audit" mode for DLP policies (log violations but don't block) and on-demand Purview scans (scan when needed, not continuously). In Stage 4, organizations are deploying AI to thousands of users at scale. Governance needs to be enforced strictly. The accelerator supports this by switching DLP to "Enforce" mode (block violations in real time), enabling continuous Purview scans (monitor for new sensitive data), and routing diagnostics to production Log Analytics workspaces for 24/7 monitoring. The key insight is that the same spec and automation work for both stages—you just adjust parameters.

**Hybrid AI Workload Support.** Modern AI workloads are hybrid—they span M365 Copilot for productivity scenarios (summarizing emails, generating meeting notes), Microsoft Foundry for custom agents and model hosting (customer support bots, document intelligence), and Microsoft Fabric for data engineering and analytics (building training datasets, running batch inference). Users don't think in terms of product boundaries—they just want AI to help them work. Governance needs to follow the same model: it should protect users and data regardless of which product they're using. This accelerator provides that unified governance by supporting all three platforms. Labels are published to M365 and Fabric. DLP policies are enforced in Exchange, SharePoint, OneDrive, and Teams. Purview scans Fabric workspaces and OneLake. Defender monitors Foundry inference. And logs from all three are correlated in Log Analytics. It's governance that follows the workload, not the product.

This alignment with Microsoft's solution play means you're not building custom, unsupported governance tooling—you're using Microsoft's native products in the way they're intended, just with automation to reduce complexity and ensure consistency.

---
   - Explain: "This accelerator implements Microsoft's best practices—it's not custom tooling, it's native products automated"

---

## Slide 15: Next Steps

### Key Points
- Three next steps: Clone the GitHub repo, read Microsoft Learn docs, access enablement resources
- Start with `azd up` in a VS Code terminal for automated deployment and minimal parameters
- Questions and follow-up welcome

### Short (≈30 sec, Executive Summary)
Ready to get started? Three next steps. First, clone the GitHub repo at aka.ms/dagsa and explore the code, scripts, and spec files. Second, visit Microsoft Learn for official documentation on Purview DSPM, Defender for AI, and Foundry governance. Third, access enablement resources and training. Start by running `azd up` in a VS Code terminal—the Azure Developer CLI will deploy the accelerator to your environment. Questions? Reach out.

### Long (≈3 min, Technical Deep Dive)
We've covered the architecture, the deployment workflow, the enterprise benefits, and the alignment with Microsoft's Secure & Govern AI strategy. Now let's talk about what you should do next to get hands-on with this accelerator.

**Next Step One: Clone the GitHub Repo.** The accelerator is open source and available on GitHub at **aka.ms/dagsa** (short link for Data & Agent Governance and Security Accelerator). When you clone the repo, you'll get the full codebase: the PowerShell scripts in `scripts/governance/dspmPurview/`, the spec template in `spec.dspm.template.json`, the documentation in `docs/`, and the Azure Developer CLI configuration in `azure.yaml`. The README provides a quickstart guide that walks you through prerequisites (Azure subscription, Microsoft 365 tenant, Purview account, required permissions), how to copy the template to `spec.local.json` and fill in your environment parameters, and how to run the deployment. The FAQ and Troubleshooting Guide answer common questions like "What if I don't have a Purview account yet?" or "Why am I getting a 403 Forbidden error when registering data sources?" The repo is actively maintained—issues and pull requests are welcome, and we regularly add new features based on community feedback.

**Next Step Two: Microsoft Learn Documentation.** While the accelerator automates deployment, understanding the underlying products is important for troubleshooting, customization, and explaining governance to stakeholders. Microsoft Learn has comprehensive documentation for each product. Search for **"Microsoft Purview DSPM"** to learn about data discovery, classification, and the Data Map. Search for **"Defender for AI"** to learn about threat detection, alert types, and response workflows. Search for **"Microsoft Foundry governance"** to learn about diagnostic settings, managed identities, and RBAC roles. Search for **"Microsoft Fabric sensitivity labels"** to learn about the admin portal toggle and how labels flow through Fabric workloads. The Learn documentation includes tutorials, how-to guides, API references, and sample code. It's the authoritative source for understanding how each product works, which will help you customize the accelerator for your specific requirements.

**Next Step Three: Enablement and Training Resources.** If you're new to AI governance or want to upskill your team, Microsoft offers enablement resources. The **Microsoft Cloud Enablement Model (MCEM)** workshops provide hands-on training for AI adoption, including governance best practices. Microsoft's **Solution Plays** (available to partners and enterprise customers) include reference architectures, deployment guides, and workshop decks for Secure & Govern AI scenarios. And if you're working with a Microsoft account team or partner, ask about **AI Governance Assessments**—a structured engagement where experts review your current governance posture, identify gaps, and provide a roadmap for implementing controls using this accelerator.

**Getting Started: `azd up` in VS Code.** The fastest way to get hands-on is to use the Azure Developer CLI, or **azd**. Open the cloned repo in VS Code, open a terminal, and run `azd up`. The CLI will prompt you for your Azure subscription, resource group region, and Purview account name. It reads the `azure.yaml` file, provisions any required Azure resources (like a Log Analytics workspace for diagnostics or a Storage Account for audit exports), and then runs the PowerShell scripts to deploy governance controls. The entire process takes 15 to 30 minutes. When it's done, you'll have labels created, Purview scans running, DLP policies enforced, and Defender for AI enabled. You can then navigate to the admin portals to verify each component and explore the deployed governance layer.

**Questions and Follow-Up.** Finally, if you have questions, reach out. The GitHub repo has an Issues tab where you can report bugs, request features, or ask for help. If you're working with a Microsoft team, loop them in—this accelerator is designed to complement Microsoft's AI governance offerings, and your account team can help you integrate it into your broader AI strategy. And if you build on this accelerator—adding support for new data sources, integrating additional governance tools, or customizing the spec model—consider contributing back to the repo via a pull request. This is a community-driven project, and collaboration makes it better for everyone.

---

## Summary

This speaker notes document provides comprehensive talk tracks for the entire 13-slide tech talk presentation. Each slide section includes:

- **Key Points**: 3-4 core messages to emphasize
- **Short (≈30 sec)**: Executive-level summary for quick conversations
- **Long (≈3 min)**: Detailed talk track with technical depth, operational context, and enterprise framing
- **Demonstration Steps**: Hands-on walkthroughs showing governance controls in action across admin portals, code, and dashboards

The notes are designed to enable anyone—whether a solution architect, security lead, or developer advocate—to deliver a confident, comprehensive presentation on the Data & Agent Governance and Security Accelerator. The content balances technical accuracy with business outcomes, making it suitable for audiences ranging from technical practitioners to executive stakeholders.

---

**Usage Tips:**
- **For a quick 5-minute overview**: Use only the "Short" sections from Slides 1, 2, 3, 11, 12, 13, and 15
- **For a full 45-minute deep dive**: Use the "Long" sections for all slides and perform live demonstrations
- **For a demo-heavy session**: Focus on the "Demonstration Steps" and use the "Long" sections as narration while you navigate portals
- **For an executive briefing**: Use the "Short" sections for Slides 1, 2, 10, 11, 12, 13, 15—skip the technical deep dives
