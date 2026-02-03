# Tech Talk Practice Script
## Data and Agent Governance and Security Accelerator
### Rehearsal Guide with Transition Cues

---

## **SLIDE 1: Title Slide**

**OPEN WITH:**
"Welcome to the Data and Agent Governance and Security Accelerator—a Gold Standard Asset from Scale AI Solutions."

**KEY POINTS TO HIT:**
- ✓ This solves governance complexity for production AI
- ✓ Manual approach = coordinating configuration across three admin portals
- ✓ Our approach = one spec file, one command
- ✓ Covers: Purview DSPM for AI, Defender for AI, Microsoft Foundry, Fabric, M365 Copilot

**AUDIENCE:**
Security, compliance, and platform teams who need consistent governance for Copilot, Foundry agents, and Fabric data.

**OUTCOME:**
One configuration file and one command: registers data sources, applies data security policies, enables threat detection, configures diagnostics, and exports audit logs.

**WHY NOW:**
Users are prompting AI today; security and governance controls need to catch up to protect production agent workloads.

**DEMO CUE:**
[Show spec.local.json in VS Code - point to key sections]

**TRANSITION TO NEXT SLIDE:**
"Now let me set the technical stage for why this exists..."

---

## **SLIDE 2: Act One - Setting the Stage**

**OPEN WITH:**
"Let me frame the technical and operational challenges IT teams face when governing AI agents."

**KEY POINTS TO HIT:**
- ✓ **Governance Gap 1:** Without Purview data source registration, you don't know what data AI agents can access
  - Cue: Fabric workspaces and OneLake data sources aren't auto-discovered in Purview - must register manually via REST API
- ✓ **Governance Gap 2:** Without DLP policies configured for AI workloads, sensitive data leaks through prompts/responses
  - Cue: Traditional DLP inspects file transfers, not AI interactions - need explicit policy configuration
- ✓ **Governance Gap 3:** Without Defender for AI enabled, prompt injection and jailbreak attempts go undetected
  - Cue: Defender for Cloud doesn't auto-enable AI plan - must configure per subscription
- ✓ **Governance Gap 4:** Without diagnostic settings, no telemetry for investigations
  - Cue: Foundry resources don't inherit diagnostics - must configure per resource
  
**NEXT TOPIC CUE:** "Now the operational problem..."

**OPERATIONAL PROBLEM BULLETS:**
- ✓ **What the accelerator automates:**
  1. Purview data source registration (Fabric workspaces + OneLake) - no auto-discovery
  2. DLP policy creation via Microsoft Graph Compliance APIs
  3. Defender for AI plan enablement per subscription
  4. Diagnostic settings configuration per Foundry resource
  5. Sensitivity label creation and publishing
  6. Audit log export to storage
- ✓ **Without automation:** Coordinating configuration across multiple admin portals
- ✓ **No native orchestration:** Purview REST, Microsoft Graph, ARM, Defender APIs are separate surfaces requiring manual coordination
- ✓ **No configuration management:** No version control, no drift detection, manual evidence collection

**VALUE TO IT TEAMS - RAPID FIRE:**
- Reduced overhead: Manual portal navigation becomes one command
- Drift prevention: Git version control for governance configuration
- Audit automation: JSON exports, immutable storage for compliance evidence
- Multi-env consistency: Same spec deploys identical controls to dev/test/prod
- Faster incident response: Diagnostics pre-configured, telemetry flows to Log Analytics

**TRANSITION TO NEXT SLIDE:**
"So those are the problems. Now let's look at the four pillars of the solution..."

---

## **SLIDE 3: Solution Pillars**

**OPEN WITH:**
"Four governance pillars, each addressing a critical gap."

**PILLAR 1 CUE: Sensitivity Labels**
- Classify data: Public → Internal → Confidential → Highly Confidential
- Enable DLP to target classifications
- Provide audit trails
- [PowerShell creates → publishes to Exchange/SharePoint/OneDrive/Fabric]

**PILLAR 2 CUE: Purview Data Map and DSPM**
- Purview Data Map scans Fabric workspaces and OneLake data sources
- Detects sensitive info types (SSN, credit cards) in data accessible to AI agents
- DSPM for AI provides security posture insights on top of Data Map scan results
- [Scripts register data sources → trigger Data Map scans]

**PILLAR 3 CUE: DLP Policies**
- Block/warn on sensitive data egress in M365 workloads (Exchange, SharePoint, Teams)
- Inspect prompts and responses in real time where supported
- Note: DLP coverage for Foundry prompt/response flows is on Microsoft's roadmap
- [PowerShell creates policies → targets SIT types + labels]

**PILLAR 4 CUE: Defender for AI**
- Detects prompt injection, jailbreak, model manipulation
- Routes alerts to Log Analytics
- [Scripts enable plan → configure diagnostics]

**DEMO CUE:**
[Navigate portals: M365 Compliance → Purview → Defender for Cloud]

**TRANSITION TO NEXT SLIDE:**
"Let me show you how this all connects architecturally..."

---

## **SLIDE 4: Architecture Overview**

**OPEN WITH:**
"This diagram shows the full governance architecture and data flow."

**WALK LEFT TO RIGHT:**
- **Left:** AI workloads (Copilot, Foundry, Fabric)
- **Middle:** Governance controls layer
  - Purview scans classify data
  - Labels flow through architecture
  - DLP enforces in real time
  - Defender monitors inference layer
- **Right:** Observability (logs to Log Analytics, audit to Blob Storage)
- **Bottom:** Spec-driven automation orchestrates everything

**KEY ARCHITECTURE POINT:**
"Labels created in M365 Compliance → available in Fabric → Purview scans detect → DLP targets → all logs unified"

**DEMO CUE:**
[Show spec.local.json side-by-side with diagram - map sections to boxes]

**TRANSITION TO NEXT SLIDE:**
"Now let's see the magic happen—Act Two, the demo..."

---

## **SLIDE 5: Act Two - Deep Dive & Demo**

**OPEN WITH:**
"We've covered architecture and pillars. Now let's see it in action."

**SET EXPECTATIONS:**
- Walk through deployment workflow
- Show scripts running
- Verify in admin portals
- This is orchestration, not magic

**DEMO PREVIEW BULLETS:**
- Slide 6: Deployment workflow (labels, scans, DLP, Defender)
- Slide 7: Configure spec.local.json parameters
- Slide 8: Observability & compliance (telemetry, audit, retention, evidence)

**TRANSITION TO NEXT SLIDE:**
"First four steps of the deployment workflow..."

---

## **SLIDE 6: Deployment Workflow (Steps 1-4)**

**OPEN WITH:**
"Four core steps deploy governance controls."

**STEP 1 CUE: Apply Sensitivity Labels**
- Script: `13-Create-SensitivityLabel.ps1`
- Calls: `Connect-IPPSSession`, `New-Label`, `New-LabelPolicy`
- Result: Labels published to Exchange/SharePoint/OneDrive

**STEP 2 CUE: Connect DSPM**
- Script: `03-Register-DataSource.ps1`, `04-Run-Scan.ps1`
- Calls: Purview REST API to register Fabric workspaces and OneLake data sources
- Result: Data sources registered, scans triggered, sensitive data discovered and classified

**STEP 3 CUE: Enforce DLP**
- Script: `12-Create-DlpPolicy.ps1`
- Calls: `New-DlpCompliancePolicy`, `New-DlpComplianceRule`
- Result: Policy published, inspects content in real time

**STEP 4 CUE: Configure Defender**
- Script: `06-Enable-DefenderPlans.ps1`, `07-Enable-Diagnostics.ps1`
- Calls: Defender for Cloud API, Azure Monitor API
- Result: AI plan enabled, diagnostics to Log Analytics

**DEMO CUE:**
[Run `.\run.ps1` → watch console output → verify in portals]

**TRANSITION TO NEXT SLIDE:**
"Before running, you configure one file—the spec..."

---

## **SLIDE 7: Deployment Step - Configure Parameters**

**OPEN WITH:**
"The heart of the accelerator: spec.local.json"

**WALK THROUGH SECTIONS:**
- **Top:** tenantId, subscriptionId, resourceGroup
- **Purview:** purviewAccount name
- **Foundry:** project name + resourceId
- **Fabric:** workspaces array with names + scanNames
- **DLP:** policy name + mode (Audit/Enforce)
- **Labels:** array with name, displayName, encryption settings

**KEY POINT:**
"This is configuration-driven governance. Edit spec → commit to Git → deploy → repeatable across environments"

**DEMO CUE:**
[Show spec.local.json in VS Code → walk through each section]
[Run `git log -- spec.local.json` to show version control]

**TRANSITION TO NEXT SLIDE:**
"Next four steps ensure observability and compliance..."

---

## **SLIDE 8: Observability & Compliance (Steps 5-8)**

**OPEN WITH:**
"Four observability steps complete the governance layer."

**STEP 5 CUE: Capture Telemetry**
- Script: `07-Enable-Diagnostics.ps1`
- Logs: Audit, RequestResponse, Trace, AllMetrics
- Destination: Log Analytics workspace

**STEP 6 CUE: Export Audit Trail**
- Script: `11-Enable-UnifiedAudit.ps1`, `21-Export-Audit.ps1`
- Captures: Copilot interactions, DLP hits, label changes, Purview scans
- Destination: Azure Blob Storage (immutable)

**STEP 7 CUE: Retention Policies**
- Script: `14-Create-RetentionPolicy.ps1`
- Calls: `New-RetentionCompliancePolicy`, `New-RetentionComplianceRule`
- Result: Auto-retain AI interactions for eDiscovery

**STEP 8 CUE: Evidence Export**
- Script: `17-Export-ComplianceInventory.ps1`, `22-Ship-AuditToStorage.ps1`
- Exports: Labels, DLP policies, retention rules → JSON
- Use case: Hand to auditors, track changes

**DEMO CUE:**
[Show Log Analytics KQL query → Blob Storage exports → compliance_inventory/ files]

**TRANSITION TO NEXT SLIDE:**
"This isn't just automation—it's role-aligned and policy-driven..."

---

## **SLIDE 9: Role-Aligned & Policy-Driven Workflows**

**OPEN WITH:**
"Core design principle: role alignment and policy-driven governance."

**ROLE-ALIGNED EXECUTION:**
- Purview Data Source Admin (scan management)
- Compliance Administrator (labels, DLP)
- Security Reader (Defender alerts)
- **No Global Admin required**

**POLICY-DRIVEN GOVERNANCE:**
- Spec file = the policy
- Configuration-driven governance for compliance
- Version-controlled, reviewable, deterministic

**ZERO TRUST ALIGNMENT:**
- Verify explicitly (labels + Purview Data Map scans)
- Least privilege (role separation)
- Assume breach (Defender detection + audit logging)

**MCEM STAGE 3→4 ACCELERATION:**
- Traditional: 6 weeks manual reconfiguration between stages
- Accelerated: 1 day re-deployment with prod parameters

**DEMO CUE:**
[Show Azure Portal IAM roles → Compare spec.dev.json vs spec.prod.json]

**TRANSITION TO NEXT SLIDE:**
"Let's map this to MCEM readiness stages..."

---

## **SLIDE 10: MCEM Readiness Stages**

**OPEN WITH:**
"How this accelerator aligns with MCEM—the structured path for AI adoption."

**THREE PRACTICAL APPLICATIONS:**

**STAGE 2 (Design):**
- Share spec file with stakeholders as governance blueprint
- Configuration-driven governance becomes part of architecture docs
- Version-controlled, reviewable before deployment

**STAGE 3 (Empower - POC/Pilot):**
- Deploy governance alongside POC in Audit mode
- Prove policies work without blocking productivity
- Gather metrics: false positives, scan coverage, alert volume

**STAGE 4 (Realize - Production):**
- Same spec file, different enforcement mode (Audit → Enforce)
- Re-deploy with production scale parameters
- No manual reconfiguration

**KEY INSIGHT:**
"Stage 3 and Stage 4 governance are identical—same labels, DLP, scans, Defender. Only difference: Audit mode vs Enforce mode, and scale."

**TRANSITION TO NEXT SLIDE:**
"We're entering the final act—key takeaways..."

---

## **SLIDE 11: Act Three - Key Takeaways**

**OPEN WITH:**
"Three things to remember when you walk out of here."

**RECAP JOURNEY:**
- Started with spec file
- Ran automation
- Saw labels created, scans triggered, DLP enforced, Defender enabled
- Verified in portals
- Explored observability built-in

**HIGHLIGHT THE ONE-COMMAND:**
"This one command orchestrates PowerShell modules that call Purview REST APIs, Microsoft Graph Compliance APIs, ARM APIs for Defender, and Azure Monitor APIs for diagnostics—all coordinated from a single spec file"

**PREVIEW NEXT SLIDES:**
- Why governance-first matters
- Enterprise benefits
- Alignment with Microsoft strategy

**TRANSITION TO NEXT SLIDE:**
"Let me tell you a story about why governance-first is essential..."

---

## **SLIDE 12: Why Governance-First Matters**

**OPEN WITH:**
"Picture this: You've built an amazing Foundry agent. It works in POC. Then security shows up..."

**STORY: Traditional Approach**
1. Build POC
2. Security audit finds gaps
3. Weeks of manual remediation
4. Re-review
5. Finally production (but momentum lost)

**STORY: Governance-First Approach**
1. Build POC with governance automated
2. Security validates controls work
3. Production same day

**FOUR REASONS - BULLET RAPID-FIRE:**
1. **Accelerate POC→Production:** Compliance automated from day one
2. **Reduce Risk:** Deterministic policy enforcement (spec → code → deployed)
3. **Full Observability:** Diagnostics to Log Analytics, audit to storage, Purview in Data Map
4. **One Command:** `.\run.ps1` orchestrates everything

**TRANSITION TO NEXT SLIDE:**
"Four concrete enterprise benefits you get..."

---

## **SLIDE 13: Enterprise Benefits**

**OPEN WITH:**
"Four measurable benefits for the enterprise."

**BENEFIT 1 CUE: Compliance**
- Automated retention (eDiscovery ready)
- DLP enforcement (real-time blocks)
- Audit trails (immutable, exportable)
- Evidence: Hand JSON to auditors

**BENEFIT 2 CUE: Security**
- Defender for AI (detective controls)
- Content Safety (preventive controls)
- Alerts route to Log Analytics
- Defense-in-depth for AI workloads

**BENEFIT 3 CUE: Observability**
- Unified Log Analytics workspace
- Foundry diagnostics + M365 audit + Purview scans
- KQL queries for investigations
- Dashboards for executives

**BENEFIT 4 CUE: Speed**
- Manual portal navigation → Single command deployment
- Coordinating across teams → Infrastructure-as-code repeatability
- Operational efficiency through API orchestration
- Version-controlled, Git-backed governance configuration

**TRANSITION TO NEXT SLIDE:**
"This aligns with Microsoft's Secure & Govern AI strategy..."

---

## **SLIDE 14: Microsoft Solution Play**

**OPEN WITH:**
"Built on Microsoft's Secure & Govern AI solution play."

**THREE PILLARS OF MICROSOFT'S VISION:**
1. **Responsible AI** (fairness, transparency, accountability)
2. **Data Governance** (classification, protection, compliance) ← We implement this
3. **Operational Security** (monitoring, threats, auditability) ← And this

**INTEGRATION STORY:**
- Each product has own portal, config model, logging
- Purview → Data Map + Compliance portal
- Defender → Defender for Cloud
- Foundry → Azure AI Studio
- Fabric → Fabric admin portal
- M365 Copilot → M365 admin + Compliance Center
- **This accelerator = the glue layer**
- **For GBBs/MCAPS:** Demonstrates API orchestration patterns, role-based deployment architecture, and repeatable customer engagement accelerators across Security, Data & AI, and Azure workloads

**MCEM STAGE TARGETING:**
- Stage 3 (Empower): Audit mode, on-demand scans
- Stage 4 (Realize): Enforce mode, continuous scans
- Same spec, different parameters

**HYBRID WORKLOAD SUPPORT:**
- Labels published to M365 and Fabric
- DLP enforced across M365 platforms (Exchange, SharePoint, Teams)
- Purview Data Map scans Fabric workspaces and OneLake data sources
- Logs correlated in Log Analytics for unified observability

**TRANSITION TO NEXT SLIDE:**
"Three next steps to get started..."

---

## **SLIDE 15: Next Steps**

**OPEN WITH:**
"Ready to deploy? Here's your path."

**NEXT STEP 1: Clone GitHub Repo**
- URL: aka.ms/dagsa
- Contains: PowerShell scripts, spec template, docs
- README: Prerequisites, quickstart, deployment steps
- FAQ + Troubleshooting Guide included

**NEXT STEP 2: Microsoft Learn**
- Search: "Microsoft Purview DSPM"
- Search: "Defender for AI"
- Search: "Microsoft Foundry governance"
- Search: "Microsoft Fabric sensitivity labels"
- Understand products for troubleshooting + customization

**NEXT STEP 3: Enablement Resources**
- MCEM workshops (hands-on technical training)
- Solution Plays (reference architectures and customer engagement patterns)
- AI Governance Assessments (expert technical reviews)
- **For GBBs/Solutions Architects:** Use this as a repeatable customer engagement accelerator—demonstrates governance-first AI adoption, API orchestration expertise, and role-based deployment patterns

**GETTING STARTED COMMAND:**
"Open VS Code → Run `azd up` → Automation orchestrates deployment → Labels created, scans running, DLP enforced, Defender enabled"

**DEMO CUE:**
[Show GitHub repo in browser]
[Show Microsoft Learn search results]
[Run `azd up` or show recording]

**CLOSING:**
"Questions? GitHub Issues, Microsoft Q&A, or your account team. This is community-driven—your feedback improves it for everyone."

---

## **PRACTICE TIPS:**

### Timing Guide (8 Minutes Total):
- **Slide 1:** 30 seconds (quick intro - what this is)
- **Slide 2:** 90 seconds (the problem - attack surfaces + operational burden)
- **Slide 3:** 60 seconds (four pillars - rapid overview)
- **Slide 4:** 30 seconds (architecture - point to diagram, don't explain every box)
- **Slide 5:** 15 seconds (transition to demo)
- **Slides 6-7:** 2 minutes (core demo - show spec, run command, quick verify)
- **Slide 8:** 45 seconds (observability outputs)
- **Slides 9-10:** 45 seconds (role-aligned + MCEM - key points only)
- **Slide 11:** 15 seconds (transition to takeaways)
- **Slides 12-13:** 90 seconds (rapid-fire benefits)
- **Slides 14-15:** 45 seconds (alignment + next steps)
- **Total:** ~8 minutes

### 8-Minute Strategy:
**Use SHORT versions only** - skip all long deep dives
- Slides 1-5: Set up the problem (3 min)
- Slides 6-8: Show the solution working (3 min)
- Slides 9-15: Value and next steps (2 min)

### Transition Phrases (Keep Moving):
- "Quickly..." (signal speed)
- "In short..." (brief point)
- "Key point..." (emphasize)
- "Next..." (rapid transition)
- "Bottom line..." (summarize fast)

### Demo Flow (Streamlined):
1. **Show spec.local.json** - "One file defines everything" (15 sec)
2. **Run `.\run.ps1`** - "One command deploys it all" (30 sec watching execute)
3. **Quick verify** - Show ONE portal with results (30 sec)
4. **Show Log Analytics** - One KQL query with output (30 sec)
5. **Skip:** Detailed portal navigation, compliance inventory files

### Energy Points:
- **High energy:** Slide 1 (hook them), Slide 6 (demo), Slide 12 (benefits)
- **Fast pace:** Slides 2-5, 9-11 (problem + context)
- **Land the value:** Slides 12-13 (why it matters)
- **Clear close:** Slide 15 (where to get it)

### Critical Time Savers:
- **Skip entirely:** Detailed API explanations, portal screenshots for every step
- **Reference only:** "Full details in speaker notes" for deep technical content
- **Combine slides:** Group 9-10 together, group 12-13 together
- **No storytelling:** Stick to technical facts, skip anecdotes
- **Assume knowledge:** Don't explain what Purview/Defender are - assume audience knows

### If Running Over Time:
- Skip Slides 9-10 entirely (role alignment + MCEM)
- Skip Slide 14 (solution play alignment)
- Jump from Slide 8 → Slide 12 (demo straight to benefits)
- Condense Slides 12-13 to bullet points only

### If Ahead of Schedule:
- Add one demo detail in Slide 6 (show actual policy created)
- Briefly explain one API orchestration point in Slide 2
- Show compliance_inventory/ export in Slide 8
