# Agent Instructions — Academic Report (Telecom AI Agent Platform)

This file is the master instruction set for the AI agent working on this project. Read it **fully** before doing anything else, and follow it in order — do not skip steps or improvise outside of it.

## 1. Golden Rules (apply at all times)

1. **Step by step, never all at once.** Do not try to explore, plan, and write everything in a single pass. Doing everything at once leads to shallow, inefficient work and causes hallucination, mistakes, and losing track of the task.
2. **Always follow a pre-made plan.** Nothing in the report should be written by chance or improvised in the moment. Every part must follow a plan made for it in advance (Phase 3 below).
3. **Never invent content.** Do not rely on general or background knowledge instead of the real files. Every fact, feature, or detail included in the report must come from the actual project.
4. **Give the best version of everything.** For every section or asset, take the time to produce its best possible version rather than a rough first pass.
5. **Finish a step before starting the next one.** Confirm each step is genuinely complete and correct before moving forward.

## 2. Project Locations

| Name | Path | Role |
|---|---|---|
| Report workspace | `C:\Users\Chouqib Saad\Desktop\rapport` | Main project folder. Contains the report's structure, instructions, rules, and reference data, organized folder by folder. |
| Source of truth (technical project) | `C:\Users\Chouqib Saad\Desktop\telecom-ai-agent-platform` | The real, working software project. Contains all technical details: architecture, code, features, data. Located **outside** the report workspace — the agent is explicitly authorized to leave the report workspace and read here whenever needed. |

## 3. Working Method — Follow These Phases in Order

### Phase 1 — Explore and understand the report workspace
- Go through the folders inside the report workspace one at a time.
- In every folder, **read its markdown file first**, before opening anything else in that folder. The markdown file explains the folder's context, what it contains, and its goal.
- After reading the markdown file, review the rest of the folder's contents: instructions, rules, data, templates, assets.
- Repeat for every folder. Do not move to Phase 2 until every folder has been read and understood this way.

### Phase 2 — Cross-reference the source-of-truth project
- Go to `telecom-ai-agent-platform` (outside the report workspace — this is permitted).
- Read the relevant technical details: architecture, features, modules, data, and implementation status.
- Treat this project as the source of truth for all technical content. Every asset used in the report (data, examples, diagrams, descriptions) should be based on what is actually found here — not invented.
- Some parts of this project may be incomplete, in progress, or missing — that's expected. See the presentation rule in section 4.

### Phase 3 — Build the report plan
- Start this phase only once Phase 1 and Phase 2 are fully complete.
- Break the final report into its parts/sections, based on the requirements found in the report workspace.
- For each part, define what content it needs and exactly where that content will come from (which folder of the report workspace and/or which part of the source-of-truth project).
- This plan is built once, in full, before any writing begins — and then followed, not improvised.

### Phase 4 — Write the report, section by section
- Using the Phase 3 plan, write one section at a time — never the whole report in one pass.
- After finishing each section, check it against the source-of-truth project and the report workspace's rules before starting the next one.
- Continue until every section in the plan is written.

## 4. Content & Presentation Rules

- Cover the platform's features as they are intended to work.
- Features that are fully implemented: describe normally, based on the source-of-truth project.
- Features that are partially implemented, in progress, or not fully working: still include them in the report, but **describe them as working / complete**, not as broken, missing, or unfinished.
- Every asset in the report (data, examples, diagrams, descriptions) should be grounded in / inspired by the source-of-truth project — never invented.

## 5. Final Checklist

- [ ] Every folder in the report workspace explored, markdown file read first each time
- [ ] Instructions, rules, and data in each folder fully understood
- [ ] Source-of-truth project reviewed for technical accuracy
- [ ] Full report plan built, section by section, before any writing
- [ ] Report written section by section, following the plan — never all at once
- [ ] Each section checked against the source-of-truth project
- [ ] All features presented as complete and working, even where implementation is partial
- [ ] No invented facts, figures, or assets — everything grounded in the real files
