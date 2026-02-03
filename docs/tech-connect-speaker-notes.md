# Tech Connect Deck — Speaker Notes
## Data and Agent Governance and Security Accelerator

---

## Slide 1: Title — Data & Agent Governance & Security Accelerator

### Key Points
- Gold Standard Asset from Scale AI Solutioning—POC in hours, not weeks
- One spec file, one command—Purview DSPM, Defender for AI, Foundry, Copilot, Fabric all governed
- Built for security, compliance, and platform teams who need consistency without portal-hopping

### Audience
Security, compliance, and platform teams who need consistent governance for Copilot, Foundry agents, and Fabric data.

### Outcome
One configuration file and one command: registers data sources, applies data security policies, enables threat detection, configures diagnostics, and exports audit logs.

### Why Now
Users are prompting AI today; security and governance controls need to catch up to protect production agent workloads.

### Short (≈30 sec, Executive Summary)
This is a Gold Standard Asset from the Scale AI Solutioning org—designed to get you from zero to governed AI environment in hours. One configuration file. One command. **Purview Data Security Posture Management for AI**, Defender for AI, Microsoft Foundry, M365 Copilot, and Fabric—all configured automatically. No navigating between multiple admin portals. Less clicking. No manual drift. Built for security, compliance, and platform teams who need controls that actually stick.

### Long (≈3 min, Technical Deep Dive)
Welcome! We're here to talk about the Data and Agent Governance and Security Accelerator—a new type of Gold Standard Asset from the Scale AI Solutioning team.

Let me start with the problem we're solving. You've got AI agents everywhere—Copilot helping users write emails, Foundry custom agents answering customer questions, Fabric analytics agents processing sensitive datasets. Each one of these types ofagents needs governance: sensitivity labels, DLP policies, threat detection, diagnostics, audit logs. But here's the challenge—configuring all that governance manually means logging into three different portals. **Purview Data Security Posture Management for AI** for data classification and prompt capture. M365 Compliance for labels and DLP. Azure Portal for Defender threat detection and diagnostics.

Manual portal navigation across multiple admin consoles. Coordinating configuration across separate teams. And when you're done, you've got no guarantee that what you configured in dev matches what's in test or prod. Manual governance creates drift. Drift creates risk.

This accelerator eliminates that entire problem.

One configuration file—`spec.local.json`—defines your entire governance posture. Your tenant. Your subscriptions. Your Purview account. Your Foundry projects. Your Fabric workspaces. The sensitivity labels you want. The DLP policies you need. The retention rules for eDiscovery.

Then you run one command: `azd up` or `run.ps1`. The automation reads your spec and orchestrates everything. Labels created. DLP policies enforced. Purview scans triggered. Defender for AI enabled. Diagnostics configured. Audit logs captured.

What used to take weeks now takes minutes. What required expertise in five different products now requires editing one JSON file. And what used to drift between environments now deploys consistently every single time.

The audience for this is security teams who need threat detection, compliance teams who need audit evidence, and platform teams who need governance that scales. For GBBs and Solutions Architects: this demonstrates role-based access control (Purview Data Source Admin, Compliance Admin, Security Reader—no Global Admin required), API orchestration patterns across Microsoft Cloud services, and repeatable customer engagement accelerators. This is configuration-driven governance—protecting AI agents in production from day one, not as an afterthought.

---

## Slide 2: The Governance Gap

### Key Points
- AI agents access data across your estate without automatic governance visibility
- AI prompts bypass traditional DLP unless DSPM for AI captures them
- Foundry projects drift when configured manually—no consistency, no accountability
- Auditors need evidence: retained prompts, scan results, policy states—not just promises

### Short (≈30 sec, Executive Summary)
Here's the gap: AI agents can access data sources you know about and data you forgot about—without automatic governance controls. AI prompts bypass traditional DLP unless DSPM detects and blocks sensitive content. Foundry projects drift when configured manually. And auditors need evidence—policy enforcement logs, scan results, policy snapshots—not just "trust us, we configured it." This accelerator closes all three gaps with automated, verifiable governance.

### Long (≈3 min, Technical Deep Dive)
Let me frame the operational governance gaps that IT teams face when governing AI agents.

**The Governance Gap Reality.** When you deploy Microsoft Foundry agents, Fabric lakehouses, or M365 Copilot with custom data sources, the governance challenge isn't theoretical—it's operational. AI agents can access data across your estate—structured data in Fabric lakehouses, unstructured data in SharePoint, indexed content in Azure AI Search. Some data sources are documented and governed. Others are forgotten or unknown. When an agent accesses data it shouldn't, or shares sensitive information with unauthorized users, what's the accountability? How do you investigate? How do you prove what happened? How do you prevent it from happening again?

The governance gap shows up in three places:

**First: AI prompts bypass traditional DLP.** Your existing DLP policies were designed for email attachments and file shares. They don't understand AI prompts. A user can paste proprietary source code or confidential product roadmap details into a Copilot chat, and unless you have DSPM for AI enabled, that intellectual property isn't detected. The policy violation isn't blocked. The attempt isn't logged. You have no evidence that a leak was attempted or prevented.

**Second: Foundry projects drift without automation.** Defender for AI is enabled once at the subscription level, but **diagnostic settings must be configured on each Foundry project individually** to ship threat detection logs to Log Analytics. When diagnostics are enabled in dev but missing in prod, you've got drift. When Content Safety blocklists are applied inconsistently across deployments, you've got drift. When governance tags are missing on new projects, you've got drift. And drift creates risk—because you can't protect what you can't see, and you can't enforce what you haven't configured.

**Third: Auditors need evidence, not promises.** Compliance teams, security teams, auditors—they don't want to hear "we think we configured DLP correctly" or "we're pretty sure Defender is enabled." They want proof. Retained prompts in Exchange Online. Purview scan results in the Data Map. Diagnostic logs in Log Analytics. Policy snapshots they can download and review.

This accelerator closes all three gaps. It makes governance declarative—you define the policy in a spec file. It makes governance repeatable—the same spec deploys the same controls every time. And it makes governance verifiable—you get evidence exports that prove controls are in place.

No more manual clicking. No more drift. No more "I think we configured that."

---

## Slide 3: Technical Proof Points

### Key Points
- Single spec file (`spec.local.json`) defines everything—tenants, Purview, Foundry, policies, diagnostics
- Tag-based orchestration runs modules in the right order: foundation → m365 → dspm → defender → foundry
- Outputs are measurable: DSPM scans, diagnostics to Log Analytics, compliance inventory exports
- Architecture diagram shows how it all connects: data sources → governance controls → observability

### Short (≈30 sec, Executive Summary)
One JSON file drives everything. Tag-based execution ensures modules run in the right order—foundation, m365, dspm, defender, foundry. The outputs aren't just configuration—they're evidence. DSPM scans, diagnostics in Log Analytics, compliance inventory exports. The architecture shows how data flows from sources through governance controls to unified observability.

### Long (≈3 min, Technical Deep Dive)
Now let's get technical. This is where I show you how it actually works.

The heart of this accelerator is a single configuration file: `spec.local.json`. This isn't a massive script you have to debug. It's a structured JSON file that defines everything you need: your tenant ID, your subscriptions, your Purview account, your Foundry projects, your Fabric workspaces, the sensitivity labels you want applied, the DLP policies you need enforced, the retention policies for eDiscovery.

That's the policy. That's the desired state. Now here's how we make it real.

The orchestrator reads that spec and runs tagged modules in a specific, deterministic order. **Foundation** sets up resource groups and Log Analytics workspaces. **m365** configures Copilot-related governance—DSPM for AI secure interactions that capture prompts to Exchange Online. **dspm** registers Purview data sources (Fabric workspaces and OneLake roots) and triggers scans to discover sensitive data. **Defender** enables Defender for AI plans and configures diagnostic settings. **Foundry** configures Content Safety blocklists and wires up threat detection.

**Key architectural insight for GBBs/Solutions Architects:** While Foundry agents can query many data sources (Azure AI Search, SQL, SharePoint, APIs), unifying data in Fabric workspaces and OneLake enables seamless Purview scanning, DLP policy application, and Defender correlation. Fabric provides the single governance surface where classification labels flow automatically and access policies apply consistently.

Each module is idempotent—you can run it multiple times, and it won't create duplicates or break existing configurations. Each module produces outputs—logs, scan results, policy states—that flow to Log Analytics for security monitoring and to local directories for compliance evidence.

Look at the architecture diagram on this slide. On the left, you've got AI workloads: Copilot, Foundry, Fabric. In the middle, you've got governance controls: Purview DSPM scans discovering sensitive data, DLP policies blocking leaks, Defender for AI detecting threats, Content Safety filtering harmful prompts. On the right, you've got observability: diagnostic logs flowing to Log Analytics, audit logs exported to Blob Storage, compliance inventory snapshots ready for auditors.

This isn't a collection of disconnected scripts. It's an integrated governance architecture—deployed and configured from one spec file, producing measurable evidence that controls are working.

That's the technical proof. One file. One command. Repeatable results.

---

## Slide 4: How It Works

### Key Points
- **Define**: Copy template to `spec.local.json`, fill in your environment parameters
- **Deploy**: Run `azd up` or `run.ps1` with tags—automation handles the rest
- **Verify**: Check Purview Audit for Foundry activity, Exchange for Copilot prompts, Content Safety blocklists
- **Evidence**: Export audit logs and policy snapshots—ready for compliance reviews

### Short (≈30 sec, Executive Summary)
Four steps. Define your spec file. Deploy with one command and the tags you need. Verify that controls are working—Purview Audit capturing Foundry activity, DSPM storing Copilot prompts, Content Safety blocking harmful content. Export the evidence—audit logs, policy snapshots—and you're done. Repeatable. Auditable. Fast.

### Long (≈3 min, Technical Deep Dive)
Let me walk you through how this works in practice—from zero to governed AI environment in four steps.

**Step 1: Define.** You start by copying the template: `spec.dspm.template.json` → `spec.local.json`. Then you fill in your environment parameters. Your tenant ID. Your subscription. Your Purview account name. The Foundry projects you want to govern. The Fabric workspaces you want scanned. The sensitivity labels you need—like "Confidential" or "Highly Confidential." The DLP policy rules—what should be blocked, what should be audited. The retention policies for eDiscovery.

This is where you declare your governance intent. What data sources should be discovered? What policies should be enforced? Where should diagnostics go?

**Step 2: Deploy.** You run one command: `azd up` or `run.ps1`. You can run all tags or pick specific ones. Want just M365 Copilot governance? Run the `m365` tag. Want Foundry agent protection? Run `defender,foundry`. Want everything? Run them all.

The automation handles the rest. It connects to Purview APIs and registers data sources. It calls M365 Compliance APIs and creates labels and DLP policies. It enables Defender for AI plans via Azure Resource Manager. It configures diagnostic settings to route logs to Log Analytics. It applies Content Safety blocklists to Foundry deployments.

You're not clicking through portals. You're not trying to remember which settings go where. The code orchestrates everything.

**Step 3: Verify.** Now you validate that it worked. Open the Purview portal and check Purview Audit—you should see Foundry AI activity captured, including policy enforcement events. Open Exchange Online—Copilot interaction metadata is available for eDiscovery searches (DLP blocks sensitive content before it's sent). Check your Foundry deployments—Content Safety blocklists are applied, filtering harmful prompts before they reach the model.

This is where governance becomes observable. You're not trusting that it worked—you're seeing the evidence.

**Step 4: Evidence.** Finally, you export the proof. The accelerator has scripts that query the M365 Compliance APIs and download your current policy states—labels, DLP rules, retention policies—and save them as JSON in the `compliance_inventory/` directory. It exports unified audit logs to Azure Blob Storage with immutable policies, so they can't be tampered with. It ships diagnostics to Log Analytics for long-term retention.

When an auditor asks "prove that you had DLP configured on this date," you hand them the JSON snapshot. When security asks "show me the logs for this Foundry interaction," you query Log Analytics.

That's the flow. Define once. Deploy anywhere. Verify everything. Export the proof.

---

## Slide 5: Value, Evidence, and Next Steps

### Key Points
- **Business outcomes**: Unified controls, automated deployment, audit-ready evidence, secure innovation
- **Operational efficiency**: No manual drift, consistent governance across dev/test/prod
- **Audit readiness**: Retained prompts, diagnostics, compliance inventory, all exportable
- **Next steps**: DeploymentGuide.md, choose your tags (m365, defender, foundry), finish manual toggles, monitor costs

### Short (≈30 sec, Executive Summary)
Here's the value: unified controls across Purview, Defender, Content Safety. Fifty-plus manual steps replaced by one repeatable command. Audit-ready evidence—retained prompts, diagnostics, compliance inventory. Secure innovation—controls in place before agents go live. Next steps: follow the Deployment Guide, pick your tags, finish the manual toggles, and monitor your costs. You're ready to govern AI at scale.

### Long (≈3 min, Technical Deep Dive)
Let's bring this home. What's the actual business value you get from deploying this accelerator?

**Business Outcome 1: Unified Controls.** You're governing Purview DSPM, Defender for AI, and Content Safety from a single spec file. That means when you update a DLP policy or add a new Foundry project, you edit the spec, redeploy, and the change is applied consistently across all environments. No more navigating between multiple admin portals. No more trying to remember which settings you changed in dev and whether you replicated them in prod. One spec. One command. Unified governance.

**Business Outcome 2: Operational Efficiency.** Manual governance requires navigating multiple admin portals—configuring Purview data sources, creating sensitivity labels, publishing DLP policies, enabling Defender plans, setting up diagnostics, exporting audit logs. Coordinating configuration across separate teams with no version control, no rollback, no proof that it's the same in every environment. This accelerator reduces that complexity to one command: `azd up`. The automation orchestrates API calls across Purview REST, Microsoft Graph, ARM, and Defender APIs. Because it's infrastructure-as-code, you can version it in Git, review changes through pull requests, and deploy to multiple environments with confidence.

**Business Outcome 3: Audit-Ready Evidence.** Compliance teams and auditors don't care about your good intentions—they care about evidence. Can you prove that DLP was enforced on this date? Can you show the logs for this AI interaction? Can you produce the retention policy that applies to these prompts? With this accelerator, the answer is yes—every time. Copilot prompts are retained in Exchange Online. Foundry diagnostics are in Log Analytics. Compliance inventory snapshots are exported as JSON. Audit logs are in immutable Blob Storage. When the auditor asks for proof, you hand them the files.

**Business Outcome 4: Secure Innovation.** The biggest risk with AI adoption is deploying agents without governance. Someone builds a great Foundry agent, it goes live, and then—oops—we realize there's no DLP, no Defender, no diagnostics. The agent's been leaking data or getting manipulated, and we have no evidence of what happened. This accelerator flips that script. Governance goes live before the agent does. Controls are in place from day one. That means you can innovate with confidence—because security and compliance are built in, not bolted on.

**Next Steps.** Ready to deploy? Here's your path. First, open `docs/DeploymentGuide.md`—it walks you through prerequisites, spec configuration, and deployment commands. Make sure you're running `azd` version 1.9.0 or higher. Second, decide your path: run the `m365` tag if you're governing Copilot, run `defender,foundry` if you're protecting Foundry agents, or run both. Third, finish the manual toggles—there are a few settings that still require portal clicks, like enabling Purview Audit and DSPM Secure Interactions. The guide lists them all. Finally, use `docs/CostGuidance.md` to set retention policies and monitor Log Analytics ingestion—so you're not surprised by your Azure bill.

That's it. You're ready to govern AI at enterprise scale—with controls that are automated, consistent, and auditable.

Welcome to governance-first AI adoption. Let's make it happen.

**For GBBs and MCAPS:** This accelerator serves as a repeatable customer engagement tool—demonstrating governance-first architecture, role-based deployment patterns (no Global Admin required), API orchestration across Microsoft Cloud services, and measurable compliance evidence. Use it to accelerate customer conversations on AI security, reduce POC-to-production timelines, and establish governance baselines that scale.

**Key points**
- One spec-driven deployment across Purview DSPM, Defender for AI, Foundry, Copilot, Fabric
- Fewer portals, repeatable governance
- Audience: security, compliance, platform teams

**Short (≈30s)**
“Here’s the elevator pitch: this accelerator turns multi-portal governance into one spec-driven deployment. It lights up Purview DSPM, Defender for AI, Foundry, Copilot, and Fabric in a repeatable way. The audience is security, compliance, and platform teams who need consistent controls without manual drift.”

**Long (≈3 min)**
“Let’s start with the outcome: a single configuration file and a single run that wires up governance across Purview DSPM for AI, Defender for AI, Microsoft Foundry, M365 Copilot, and Fabric. Instead of bouncing between portals to configure labels, DLP, scans, and diagnostics, we declare the intent once in `spec.local.json` and apply it consistently. This is designed for teams who own risk and platform readiness—security, compliance, and data/AI platform owners. The value is speed and repeatability: you can establish a governance baseline quickly, validate it, and apply the same baseline across environments. I’ll show how the solution removes manual steps and produces evidence that auditors and security teams can rely on.”

---

## Slide 2 — The Governance Gap
**Key points**
- AI prompts can bypass traditional DLP without DSPM for AI
- Foundry projects drift without standardized diagnostics and plans
- Auditors need retained evidence and scan results

**Short (≈30s)**
“This slide highlights the gap: AI interactions slip past legacy controls unless DSPM captures them, Foundry settings drift without automation, and audit teams lack evidence. The accelerator closes those gaps by standardizing policies, diagnostics, and evidence capture.”

**Long (≈3 min)**
"The governance gap shows up in three places. First, AI prompts containing sensitive data can bypass traditional DLP unless DSPM for AI detects and blocks them before they reach the model. Second, Foundry projects become inconsistent when diagnostics and Defender plans are configured manually—what's enabled in one environment is missing in another. Third, audit and compliance teams need evidence, but they don't have a single place to get policy enforcement logs, scan results, or policy states. The accelerator solves this by making policy and telemetry configuration declarative. It registers data sources, runs DSPM scans, standardizes Defender settings, and exports evidence so governance is not just 'configured,' it's verifiable."

---

## Slide 3 — Technical proof points
**Key points**
- Single spec file orchestrates all modules
- Tag-based execution ensures ordered, repeatable runs
- Evidence export + diagnostics to Log Analytics

**Short (≈30s)**
“One JSON spec drives all modules in the right order. Tags control which paths run, and outputs include diagnostics and evidence export—so governance is repeatable and auditable.”

**Long (≈3 min)**
“This slide is the technical heart. A single JSON file defines tenants, Purview accounts, Foundry projects, policy settings, and export locations. The orchestrator reads that spec and runs tagged modules in a deterministic order—foundation, m365, dspm, defender, foundry—so the same configuration is applied every time. The result is not just setup, but measurable outputs: DSPM scans, diagnostics into Log Analytics, and exportable compliance inventory and audit logs. That gives platform teams repeatability and gives security teams evidence.”

---

## Slide 4 — How it works
**Key points**
- Define: create `spec.local.json`
- Deploy: `azd up` or `run.ps1`
- Verify: check audit, capture, Content Safety
- Evidence: export logs and snapshots

**Short (≈30s)**
“Four steps: define the spec, deploy with one command, verify the controls, and export evidence. It’s straightforward and repeatable.”

**Long (≈3 min)**
“The flow is simple but complete. First, define the configuration by copying the template into `spec.local.json` and filling tenant, subscriptions, Purview, Foundry, and policy settings. Second, deploy with `azd up` or `run.ps1` and the tags you need. That applies labels, DLP, scans, and Defender plans in order. Third, verify: Purview Audit captures Foundry activity, DSPM for AI stores Copilot prompts in Exchange Online, and Content Safety blocklists protect agents. Finally, export evidence—audit logs and policy snapshots—so compliance and security teams can review and validate without manual collection.”

---

## Slide 5 — Value, evidence, and next steps
**Key points**
- Unified controls and repeatable automation
- Audit-ready evidence and reduced manual effort
- Clear next steps: DeploymentGuide, tags, manual toggles

**Short (≈30s)**
“Value: unified controls, less manual work, and audit-ready evidence. Next steps: follow the Deployment Guide, pick the tags you need, and finish any portal toggles.”

**Long (≈3 min)**
"This slide brings it together. Business outcomes: unified controls across Purview DSPM, Defender for AI, and Content Safety; operational efficiency by replacing manual portal navigation with repeatable automation; and audit-ready evidence that includes retained prompts, diagnostics, inventory exports, and audit logs. The next steps are practical: open the Deployment Guide, ensure `azd` is current, choose whether you're running `m365` for Copilot capture or `defender,foundry` for Foundry agents—or both. Finally, complete the manual toggles like Purview Audit and Secure Interactions, then tune retention using the Cost Guidance. That's the path from demo to production readiness."
