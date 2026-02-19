# Tech Connect Speaker Notes
## Data & Agent Governance and Security Accelerator

---

## Slide 1: Title - Data & Agent Governance and Security Accelerator

### Key Points
- Configuration-driven automation for AI governance across Microsoft's platform
- Eliminates manual portal navigation—one spec file, one command deployment
- Covers Purview DSPM for AI, Defender for AI, Microsoft Foundry, and Fabric

### Audience
Security, compliance, and platform teams who need consistent governance for Copilot, Foundry agents, and Fabric data.

### Outcome
One configuration file and one command: registers data sources, applies data security policies, enables threat detection, configures diagnostics, and exports audit logs.

### Why Now
Users are prompting AI today; security and governance controls need to catch up to protect production agent workloads.

### Short (≈30 sec, Executive Summary)
This accelerator automates governance for AI workloads across Copilot, Foundry, and Fabric. Instead of manually navigating between Purview, M365 Compliance Center, and Azure Portal to configure dozens of controls, you define everything in a single JSON spec file and deploy with one command. Configuration-driven automation that turns weeks of manual setup into minutes of repeatable deployment.

### Long (≈3 min, Technical Deep Dive)
Welcome to the Data & Agent Governance and Security Accelerator—designed to eliminate the operational burden of securing AI workloads at scale.

When you deploy AI agents in production, you face a governance challenge: You need Purview DSPM for AI to capture Copilot prompts for retention and eDiscovery. You need Defender for AI to detect prompt injection and jailbreak attempts. You need diagnostic settings configured on every Foundry project so alerts reach your Log Analytics workspace. You need sensitivity labels published across M365, Foundry, and Fabric. You need DLP policies that target AI interactions specifically. You need unified audit logging configured for compliance investigations. And you need all of this to work consistently across dev, test, and production environments.

The traditional approach is manual portal configuration. You log into the M365 Compliance Center to create labels and DLP policies. You switch to Purview to register Fabric workspaces and configure data scans. You navigate to Azure Portal to enable Defender plans and configure diagnostic settings on each Foundry project. Each portal has its own authentication, configuration model, and API surface. It's slow, error-prone, and impossible to replicate consistently.

This accelerator takes a different approach: **configuration-driven governance**. You define your entire governance posture in a single JSON specification file called `spec.local.json`. That spec declares your tenant ID, subscriptions, Purview accounts, Foundry projects, Fabric workspaces, sensitivity labels, DLP rules, retention policies, and audit export settings. Then you run one command—`azd up` or `run.ps1` with tag-based execution—and the PowerShell orchestrator reads your spec and calls the appropriate Microsoft APIs: Purview REST APIs, Microsoft Graph Compliance APIs, Azure Resource Manager, and Defender for Cloud.

The result: Labels get created and published. Purview data sources get registered for Fabric and OneLake. DLP policies get created and enforced. Defender for AI gets enabled with diagnostics routed to Log Analytics. Audit subscriptions get configured for the right content types. And all of it is idempotent—run it again, and it updates only what's changed. Version-control your spec in Git, deploy the same configuration to production, and you have governance that's automated, repeatable, and auditable.

This accelerator integrates four core technologies shown in the badges: **Microsoft Purview DSPM for AI** for capturing Copilot prompts and enforcing secure interactions, **Defender for AI** for threat detection, **Microsoft Foundry** for custom agent hosting, and **Microsoft Fabric** for data lakehouse workloads. Each brings critical governance capabilities, and this accelerator wires them together into one cohesive deployment.

---

## Slide 2: The Governance Gap

### Key Points
- AI interactions need consistent security controls across Copilot, Foundry, and Fabric
- Three major challenges: prompts bypassing DLP, inconsistent diagnostic settings, lack of centralized audit evidence
- Two deployment paths: M365 Copilot & 3rd-party AI, or Microsoft Foundry & custom agents

### Short (≈30 sec, Executive Summary)
AI interactions introduce governance gaps that traditional tools don't cover. Copilot prompts bypass DLP unless DSPM for AI captures them in Exchange Online. Foundry projects become inconsistent when diagnostics, Defender plans, and Content Safety are manually configured. Audit teams need prompts, scan results, and policy evidence in one location for compliance investigations. This accelerator addresses both paths: M365 Copilot with DSPM for AI, and Foundry agents with Defender for AI and diagnostics to Log Analytics.

### Long (≈3 min, Technical Deep Dive)
Let me walk you through the governance gaps we're closing.

**Challenge One: Copilot and browser AI prompts bypass traditional DLP rules.** When a user prompts Copilot or uses browser-based AI tools, that interaction happens outside the traditional data loss prevention perimeter. DLP policies that protect email attachments and SharePoint documents don't see the prompt or response unless you explicitly configure DSPM for AI. Without DSPM, those prompts aren't retained, they're not available for eDiscovery, and they can't be inspected for sensitive data leakage. A user could paste confidential intellectual property or customer PII into a prompt, and you'd have no evidence it happened and no way to block it.

DSPM for AI solves this by capturing prompts and responses and storing them in the user's Exchange Online mailbox as compliance records. Once stored, they're subject to retention policies, available for eDiscovery searches, and can be inspected by DLP policies in real time. This brings AI interactions into the existing M365 compliance framework.

**Challenge Two: Foundry projects become inconsistent when configured manually.** Microsoft Foundry hosts your custom AI agents, and each Foundry project needs governance controls: Defender for AI to detect threats, diagnostic settings to route alerts to Log Analytics, and Content Safety filters to block harmful content. When you configure these manually through the Azure Portal, you introduce inconsistency. One project gets Defender enabled; another doesn't. One has diagnostics configured; another has them pointing to the wrong workspace. Manual configuration doesn't scale, and it creates gaps that attackers can exploit.

This accelerator automates Foundry project governance. The spec file lists all your Foundry projects, and the scripts enable Defender for AI on each one, configure diagnostic settings consistently, and apply Content Safety blocklists. Every project gets the sam governance posture, every time.

**Challenge Three: Audit, eDiscovery, and security teams need centralized evidence.** Compliance investigations require evidence from multiple systems: Copilot prompts from M365, Purview scan results showing what data was classified, DLP policy violations, Defender alerts, and diagnostic logs. When these are scattered across Exchange Online, Purview portals, Log Analytics, and Azure Storage, investigations take days. Teams waste time correlating events across systems, and auditors can't get a complete picture of what happened.

This accelerator provides centralized evidence export. Copilot prompts are retained in Exchange for eDiscovery. Purview scan results populate the Data Map. DLP violations log to the unified audit log. Defender alerts route to Log Analytics. And the accelerator includes scripts to export compliance inventory (labels, policies, retention rules) and audit logs locally as JSON files, ready to hand to auditors.

**Two Deployment Paths.** The accelerator supports two paths based on your AI strategy:

**M365 Copilot & 3rd-party AI path:** Run the `m365` tag to configure DSPM for AI policies that capture prompts and responses to mailboxes. This enables retention, eDiscovery, and DLP for Copilot interactions. Combine with the `dspm` tag to configure Purview scans for Fabric workspaces, ensuring data sources are classified before AI agents access them.

**Microsoft Foundry & custom agents path:** Run the `defender` and `foundry` tags to enable Defender for AI threat detection, configure diagnostics to Log Analytics, register Purview data sources (Fabric, OneLake), and apply Content Safety blocklists. This path gives you full observability and threat protection for custom AI agents.

You can run both paths together if you're deploying Copilot and custom Foundry agents. The tag-based orchestrator runs modules in the correct order, ensuring dependencies are met.

---

## Slide 3: Technical Proof Points

### Key Points
- Single configuration file (spec.local.json) defines tenants, Purview accounts, Foundry projects, policies, and export settings
- Tag-based orchestrator runs modules in correct order (foundation, m365, dspm, defender, foundry)
- Controls enabled: DSPM scans, Secure Interactions, DLP with labels/retention, Defender for AI with diagnostics, Content Safety, Azure Policy
- Exportable evidence: compliance inventory, audit logs, diagnostics to Log Analytics

### Short (≈30 sec, Executive Summary)
The accelerator uses a single JSON spec file to drive ordered PowerShell modules that configure governance across Purview, Defender, and M365 Compliance. Tag-based execution lets you run just the modules you need: `foundation` for core setup, `m365` for Copilot governance, `dspm` for Purview scans, `defender` for threat detection, and `foundry` for agent registration and safety. Every control is configured via API calls—DSPM scans, DLP policies, Defender plans, diagnostics—and evidence is automatically exported for audits.

### Long (≈3 min, Technical Deep Dive)
Let me show you how this works technically, using the architecture diagram as a reference.

**Configuration File: spec.local.json.** Everything starts with a single JSON specification file. You copy `spec.dspm.template.json` to `spec.local.json` and fill in your environment details: tenant ID, subscription IDs, resource group names, Purview account name, Foundry project resource IDs, Fabric workspace names, and OneLake paths. Then you define your governance policies in the same file: which sensitivity labels to create, which DLP rules to enforce, which retention policies to apply, and where to export audit logs. The spec is self-contained—one file defines your entire governance posture.

**Orchestrator: Tag-Based Execution.** The PowerShell orchestrator (`run.ps1`) supports tag-based execution, allowing you to run just the modules you need:

- **foundation tag:** Core setup—ensures Azure context, creates resource groups, validates Purview accounts.
- **m365 tag:** M365 Copilot governance—creates sensitivity labels, publishes them to Exchange/SharePoint/OneDrive/Fabric, creates DLP policies targeting labels and sensitive info types, configures retention policies for Copilot prompts.
- **dspm tag:** Purview Data Map configuration—registers Fabric workspaces and OneLake as data sources, creates and triggers scans, exports scan results and compliance inventory.
- **defender tag:** Defender for AI enablement—enables the Defender for AI plan at subscription level, configures diagnostic settings on Foundry Cognitive Services accounts to route alerts to Log Analytics.
- **foundry tag:** Foundry agent registration and safety—registers Foundry projects with Purview, applies Content Safety blocklists, assigns Azure Policies.

You can run multiple tags in one command: `.\run.ps1 -Tags foundation,m365,dspm,defender,foundry` deploys the full stack. Or run selectively: `.\run.ps1 -Tags m365,dspm` for just Copilot governance and Purview scans.

**Controls Enabled.** The accelerator configures multiple governance controls via native Microsoft APIs:

- **DSPM scans and Secure Interactions:** Purview Data Map scans Fabric workspaces and OneLake to discover and classify sensitive data. DSPM for AI Secure Interactions policies capture Copilot prompts and responses to Exchange Online mailboxes for retention and eDiscovery.
- **DLP policies with sensitivity labels and retention:** DLP compliance policies are created in M365 Compliance Center, targeting sensitive info types (SSN, credit cards) and sensitivity labels (Confidential, Highly Confidential). Rules block or audit violations in Exchange, SharePoint, OneDrive, and Teams. Retention policies ensure Copilot prompts are retained for the configured period.
- **Defender for AI with diagnostics:** Defender for AI plan is enabled at the subscription level. Diagnostic settings are configured on each Foundry Cognitive Services account (parent of Foundry projects) to route logs and metrics to your Log Analytics workspace. This ensures threat alerts, usage metrics, and audit logs flow to a central location for security operations.
- **Content Safety blocklists:** Custom blocklists are applied to Foundry projects via Content Safety APIs, blocking known harmful patterns or organization-specific terms.
- **Azure Policy assignments:** Azure Policies are assigned to enforce standards like requiring diagnostic settings, enforcing network restrictions, or mandating tags.

**Evidence Export.** The accelerator includes evidence export capabilities for audits and compliance reviews:

- **Compliance inventory:** Export current labels, DLP policies, retention policies, and Purview Data Map scan results as JSON files. These snapshots prove what governance controls were in place at a specific point in time.
- **Audit log exports:** Export M365 unified audit logs to Azure Storage or local files, providing evidence of user actions, DLP violations, and Copilot interactions.
- **Diagnostics to Log Analytics:** All Foundry diagnostic logs, Defender alerts, and Purview audit events flow to Log Analytics for centralized security operations and KQL-based investigations.

This architecture provides end-to-end observability and proof of governance enforcement—critical for passing compliance audits.

---

## Slide 4: How It Works

### Key Points
- Four steps: Define spec file, Deploy with azd/run.ps1, Verify controls work, Export evidence
- Idempotent deployment—re-run safely, only updates what changed
- Tag-based execution allows selective deployment (m365, dspm, defender, foundry)

### Short (≈30 sec, Executive Summary)
Four steps to governed AI: Define your governance in spec.local.json—tenants, subscriptions, Purview accounts, Foundry projects, policies, and export settings. Deploy with `azd up` or `run.ps1` using your chosen tags—policies, data sources, scans, and Defender plans are applied automatically. Verify that Purview Audit captures Foundry activity, DSPM for AI stores Copilot prompts in Exchange for retention, and Content Safety blocklists protect agents. Export audit logs and policy snapshots locally—ready for security reviews and compliance audits.

### Long (≈3 min, Technical Deep Dive)
Let me walk you through the four-step deployment process.

**Step 1: Define.** Start by copying `spec.dspm.template.json` to `spec.local.json`. This template includes placeholders for all required configuration. Fill in your environment details:

- **Tenant and subscriptions:** Your Azure AD tenant ID and subscription IDs where resources are deployed.
- **Purview account:** The Purview account name and resource group. If you don't have one yet, the scripts can create it, but you need to provide the name and location.
- **Foundry projects:** List all your Foundry project resource IDs. The scripts will enable Defender for AI and configure diagnostics on the parent Cognitive Services accounts.
- **Fabric workspaces and OneLake:** List Fabric workspace names and OneLake folder paths that should be registered as Purview data sources and scanned for sensitive data.
- **Labels and DLP policies:** Define sensitivity labels (Public, Internal, Confidential, Highly Confidential) with descriptions and encryption settings. Define DLP policy rules targeting sensitive info types (SSN, credit card numbers) and sensitivity labels.
- **Retention policies:** Specify retention duration for Copilot prompts and other compliance artifacts.
- **Audit export:** Configure where to export audit logs—Azure Storage account, local path, or both.

The spec file is JSON, making it easy to version-control in Git and review in pull requests before deployment.

**Step 2: Deploy.** Run `azd up` for integrated Azure Developer CLI deployment, or run `.\run.ps1` directly with PowerShell. Use the `-Tags` parameter to run specific modules:

- `.\run.ps1 -Tags foundation,m365` → Core setup + Copilot governance (labels, DLP, retention)
- `.\run.ps1 -Tags dspm` → Register Fabric/OneLake data sources, trigger Purview scans
- `.\run.ps1 -Tags defender,foundry` → Enable Defender for AI, configure diagnostics, apply Content Safety

Or run all tags together for full deployment: `.\run.ps1 -Tags foundation,m365,dspm,defender,foundry`.

The scripts are idempotent—you can re-run them safely. If a label already exists, it's not recreated. If a Purview data source is already registered, it's skipped. If diagnostic settings are already configured with the right workspace, they're not changed. This allows you to update your spec file, add new resources, and re-run deployment without breaking existing configuration.

Deployment typically takes 10-30 minutes depending on how many resources you're configuring. The scripts log progress to the console and create detailed logs in `./logs/` for troubleshooting.

**Step 3: Verify.** After deployment, verify that controls are working:

- **Purview Audit:** Navigate to Purview Compliance portal → Audit. Search for Foundry AI activity events. You should see events showing agent queries, data access, and policy evaluations.
- **DSPM for AI Copilot prompts:** Check a test user's Exchange Online mailbox. Copilot prompts should appear as records with appropriate retention policies applied. Verify that eDiscovery searches can find them.
- **Defender for AI alerts:** Simulate a prompt injection attack in a Foundry agent. Verify that Defender detects it and routes the alert to Log Analytics. Run a KQL query: `AzureDiagnostics | where ResourceType == "COGNITIVESERVICES"` to see diagnostic logs.
- **Content Safety blocklists:** Test that blocked terms or patterns are rejected by Foundry agents.
- **Data Map scans:** Navigate to Purview Data Map and verify that Fabric workspaces and OneLake sources appear as registered data sources. Check scan results to see if sensitive data was classified (SSNs, credit cards, etc.).

**Step 4: Evidence.** Export evidence for compliance reviews and audits:

- **Compliance inventory:** Run `.\scripts\governance\dspmPurview\17-Export-ComplianceInventory.ps1` to export current labels, DLP policies, retention policies, and scan results as JSON files to `./compliance_inventory/`. These snapshots prove what governance was in place.
- **Audit logs:** Run `.\scripts\governance\dspmPurview\21-Export-Audit.ps1` to export M365 unified audit logs for a specific date range. Logs are saved locally and optionally uploaded to Azure Storage for long-term retention.
- **Log Analytics queries:** Use KQL queries in Log Analytics to generate reports on Defender alerts, diagnostic events, and compliance violations. Export query results as CSV for audit evidence.

This evidence is critical for compliance audits (SOC 2, ISO 27001, HIPAA, etc.), where auditors need proof that controls were implemented and operational during the audit period.

---

## Slide 5: Value, Evidence, and Next Steps

### Key Points
- Four business outcomes: Unified controls, Operational efficiency, Audit-ready evidence, Secure innovation
- Concrete next steps: review DeploymentGuide.md, choose deployment path (m365/defender/foundry tags), finish manual toggles, use CostGuidance.md
- Evidence export built-in for compliance reviews

### Short (≈30 sec, Executive Summary)
Four business outcomes: Unified controls from one spec file—Purview DSPM, Defender for AI, Content Safety together. Operational efficiency—50+ manual portal steps replaced with repeatable commands. Audit-ready evidence—retained prompts, diagnostics, compliance inventory, audit exports. Secure innovation—security controls in place before agents go live, reducing prompt injection and data leakage risk. Next steps: Open DeploymentGuide.md, choose your path (m365 tag for Copilot, defender/foundry for agents, or both), finish manual toggles in Purview and Defender portals, use CostGuidance.md to manage retention costs.

### Long (≈3 min, Technical Deep Dive)
Let me summarize the business value and give you clear next steps to get started.

**Business Outcome 1: Unified Controls.** Traditionally, governance for AI workloads is fragmented. Purview DSPM configuration happens in the Purview portal. Defender for AI enablement happens in Azure Portal. DLP policies are created in M365 Compliance Center. Content Safety blocklists are configured via Azure AI Studio. Each system operates independently, with its own authentication, configuration model, and logging.

This accelerator unifies all of that into a single spec file. You define labels, DLP rules, Purview scans, Defender plans, and Content Safety settings in one JSON file. Deploy once, and all controls are configured consistently. Update the spec, redeploy, and changes propagate across all systems. Unified controls mean less operational overhead and fewer gaps.

**Business Outcome 2: Operational Efficiency.** Manual configuration of governance controls is slow and error-prone. Creating one sensitivity label in M365 Compliance Center takes 5 minutes (navigate portal, fill form, publish to locations, wait for replication). Creating a Purview data source registration takes 10 minutes (navigate Purview portal, select source type, enter credentials, configure scan schedule). Enabling Defender for AI on one Foundry project takes 5 minutes (navigate Azure Portal, find Cognitive Services account, enable plan, configure diagnostics). Multiply by the number of labels, data sources, and Foundry projects, and you're at 50+ manual portal steps just to deploy baseline governance.

This accelerator replaces all of that with repeatable commands. `azd up` or `run.ps1` with your chosen tags deploys everything in 10-30 minutes, depending on resource count. Re-run to add new resources or update policies. The time savings compound as your AI estate grows.

**Business Outcome 3: Audit-Ready Evidence.** Compliance audits (SOC 2, ISO 27001, HIPAA, FedRAMP) require proof that governance controls were implemented and operational. Auditors ask questions like: "Show me what DLP policies were active in Q4." "Prove that Copilot prompts containing PII were retained for eDiscovery." "Demonstrate that Defender for AI was enabled on all Foundry projects." "Export audit logs showing who accessed sensitive data via AI agents."

This accelerator provides evidence automatically:

- **Retained prompts (M365):** Copilot prompts stored in Exchange Online mailboxes with retention policies applied—search able via eDiscovery.
- **Diagnostics (Foundry):** All Foundry AI activity logged to Log Analytics—KQL queries export evidence of agent interactions, Defender alerts, and policy violations.
- **Compliance inventory:** JSON snapshots of labels, DLP policies, retention policies, and Purview scan results—timestamped proof of what governance was in place.
- **Audit exports:** M365 unified audit logs exported to Azure Storage or local files—complete record of user actions, DLP violations, and admin changes.

Hand these exports to auditors, and they have the evidence they need. This reduces audit preparation time from weeks to days.

**Business Outcome 4: Secure Innovation.** AI innovation moves fast, but security teams slow it down when governance is an afterthought. Developers build POC agents, get approval to move to production, then face a 6-week governance delay while security manually configures controls. By the time governance is ready, the POC momentum is lost, and the project gets deprioritized.

This accelerator flips the model: security controls are in place **before** agents go live. Deploy governance alongside your POC using the same spec file. Security validates that Defender for AI is detecting threats, DLP is blocking policy violations, and Purview is classifying data. When it's time to move to production, you redeploy the same spec with production parameters—no delay, no manual reconfiguration. Governance no longer blocks innovation; it enables it.

This reduces two critical risks:

- **Prompt injection:** Defender for AI detects jailbreak attempts, prompt manipulation, and model extraction attacks in real time—stopping attacks before they succeed.
- **Data leakage:** DLP policies block sensitive data from leaking through prompts or responses—preventing accidental exposure of PII, IP, or confidential information.

**Next Steps:** Here's your path to deployment:

1. **Open docs/DeploymentGuide.md** for step-by-step setup instructions. Ensure you have azd 1.9.0+ installed and appropriate admin roles: Compliance Admin in M365, Purview Data Source Admin, Contributor + Security Admin in Azure.

2. **Decide your deployment path:**
   - Run **m365 tag** for Copilot governance: captures prompts/responses to mailboxes for retention, eDiscovery, and DLP.
   - Run **defender, foundry tags** for Foundry agent security: enables Defender for AI threat detection and diagnostics to Log Analytics.
   - Run **both paths** if deploying Copilot and custom agents together.

3. **Finish manual toggles:** Some features require manual portal configuration because APIs aren't available yet:
   - Enable **Purview Audit** in the Purview Compliance portal to capture AI activity events.
   - Enable **Secure Interactions** in DSPM for AI settings to capture Copilot prompts.
   - Enable **Defender user prompt evidence** in Defender for AI settings to log full prompts in alerts.
   - Enable **Purview integration** in Defender for AI to correlate threats with data classification.

4. **Use docs/CostGuidance.md** to manage costs. Retention policies generate storage costs (Exchange mailboxes, Log Analytics ingestion). Set appropriate retention periods based on compliance requirements. Monitor Log Analytics workspace ingestion and adjust diagnostic settings if costs grow unexpectedly.

That's it. You're now ready to deploy governed AI with confidence.
