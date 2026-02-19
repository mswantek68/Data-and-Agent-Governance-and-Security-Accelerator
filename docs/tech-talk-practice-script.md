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
"Three critical problems block enterprise AI adoption: manual governance overhead, deployment verification failures, and POC momentum loss."

**THREE PROBLEMS - RAPID FIRE:**

**PROBLEM 1: Manual Governance Takes Time**
- Portal navigation: Purview → M365 Compliance → Azure Portal → Security PowerShell
- Each with different auth, different config models, different terminology
- No version control, no automation, no repeatability
- Cue: "What Purview calls a 'data source' isn't what Defender calls a 'resource'"

**PROBLEM 2: Delays in Production Deployment**
- Dev environment: Governance manually configured, everything works
- Prod deployment: How do you verify same controls are configured?
- No manifest, no spec, no infrastructure-as-code trail
- Security blocks until they can verify consistency: "Can you prove DLP policies match dev?"
- Manual verification = error-prone + time-consuming
- Cue: "Without automation, the answer is 'I think so, but I can't prove it deterministically'"

**PROBLEM 3: POCs Stall Under Complexity**
- Developers excited about AI innovation
- Compliance shows up: "We need labels, DLP, scans, Defender, audit logs, retention"
- Two-week POC becomes two-month compliance project
- Role silos: Developers don't know DLP, compliance doesn't know Purview, security doesn't know diagnostics
- Momentum dies, executives lose confidence
- Cue: "The blocker isn't the technology—it's the operational friction of deploying governance manually"

**ACCELERATOR VALUE - ONE SENTENCE:**
"This accelerator solves all three: one spec file, one command, governance deploys in minutes with provable consistency across environments."

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

## **SLIDE 7: Observability & Compliance (Steps 5-8)**

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

## **SLIDE 8: Role-Aligned & Policy-Driven Workflows**

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

## **SLIDE 9: MCEM Readiness Stages**

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

## **SLIDE 10: Act Three - Key Takeaways**

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

## **SLIDE 11: Why Governance-First Matters**

**OPEN WITH:**
"Why does governance-first matter? Because traditional approaches delay production."

**STORY: Traditional Approach (Problem)**
1. Build POC first
2. Then scramble to add governance
3. Manual controls create verification gaps
4. Error-prone configuration = inconsistencies
5. Weeks of delay

**STORY: Governance-First Approach (Solution)**
1. Build POC with governance built in
2. Security validates during POC
3. Production ready immediately
4. No reconfiguration needed

**FOUR REASONS - BULLET FOCUS:**
1. **Traditional Delays Production:** POC works, then governance scramble → weeks lost
2. **Manual Controls Create Verification Gaps:** Controls after development → errors, inconsistencies, unverifiable
3. **Governance-First Proves Early:** Controls validated during POC, not at production gate
4. **Removes Bottlenecks:** Governance deploys with agents → no reconfiguration between environments

**KEY TRANSITION PHRASE:**
"Governance-first removes the biggest blocker in enterprise AI adoption: the reconfiguration delay."

**TRANSITION TO NEXT SLIDE:**
"Four concrete enterprise benefits you get..."

---

## **SLIDE 12: Enterprise Benefits**

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

## **SLIDE 13: Microsoft Solution Play**

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

## **SLIDE 14: Related Sessions**

**OPEN WITH:**
"Three related sessions to deepen your expertise."

**SESSION 1: Purview DSPM**
- Deep dive on Data Security Posture Management
- Data discovery and classification
- Security posture insights

**SESSION 2: Defender for AI**
- AI threat protection and detection
- Prompt injection defense
- Model manipulation alerts

**SESSION 3: Foundry Observability**
- Monitoring AI agents in production
- Diagnostic settings and Log Analytics
- Performance and security dashboards

**TRANSITION TO NEXT SLIDE:**
"Ready to get started? Here are your next steps..."

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
- **Slide 2:** 90 seconds (three critical problems: manual governance weeks, deployment delays, POC stalls)
- **Slide 3:** 60 seconds (four pillars - rapid overview)
- **Slide 4:** 30 seconds (architecture - point to diagram, don't explain every box)
- **Slide 5:** 15 seconds (transition to demo)
- **Slide 6:** 90 seconds (deployment workflow steps 1-4)
- **Slide 7:** 45 seconds (observability & compliance steps 5-8)
- **Slides 8-9:** 45 seconds (role-aligned workflows + MCEM - key points only)
- **Slide 10:** 15 seconds (transition to takeaways)
- **Slide 11:** 60 seconds (why governance-first matters)
- **Slide 12:** 60 seconds (enterprise benefits - rapid-fire)
- **Slides 13-15:** 60 seconds (solution play, related sessions, next steps)
- **Total:** ~8 minutes

### 8-Minute Strategy:
**Use SHORT versions only** - skip all long deep dives
- **Slides 1-5:** Set up the problem (3 min)
- **Slides 6-7:** Show the solution working - demo deployment workflow (2 min)
- **Slides 8-15:** Implementation details, value, and next steps (3 min)

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
- Skip Slides 8-9 entirely (role alignment + MCEM staging)
- Skip Slide 13 (solution play alignment)
- Jump from Slide 7 → Slide 11 (demo straight to governance-first)
- Condense Slides 11-12 to bullet points only

### If Ahead of Schedule:
- Add one demo detail in Slide 6 (show actual policy created in portal)
- Briefly explain one API orchestration point in Slide 2  
- Show compliance_inventory/ export files in Slide 7 (observability step)
