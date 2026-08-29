# Persistent Report Memory Protocol

The `memory/` folder is the persistent working memory of the report-writing process.

Before performing important work, read the relevant memory files.

At minimum, consult:

* `00_CONTEXT.md`
* `03_CURRENT_STATE.md`
* `02_PROGRESS.md`
* `06_OPEN_TASKS.md`
* `07_TEMPLATE_RULES.md`

Also consult `04_CONTENT_PLAN.md`, `05_DECISIONS.md`, or `08_PROJECT_FACTS.md` whenever the current task concerns content, decisions, or project facts.

## After Important Work

Update the memory immediately.

### If work was completed

Update:

* `02_PROGRESS.md`
* `03_CURRENT_STATE.md`

### If a new task was discovered

Update:

* `06_OPEN_TASKS.md`

### If an important decision was made

Update:

* `05_DECISIONS.md`

### If verified project information was discovered

Update:

* `08_PROJECT_FACTS.md`

### If report content planning changed

Update:

* `01_REPORT_ROADMAP.md`
* `04_CONTENT_PLAN.md`

### If a new template rule or LaTeX technique was discovered

Update:

* `07_TEMPLATE_RULES.md`

### If the work is important enough to help future sessions

Add a short entry to:

* `09_SESSION_LOG.md`

## Anti-Hallucination Rule

Never invent missing information to make progress look complete.

Use:

* `UNKNOWN`
* `TO BE VERIFIED`
* `TO BE PROVIDED`

when necessary.

Never convert an assumption into a verified project fact.

## Anti-Contradiction Rule

Before introducing information that conflicts with previous work:

1. Check `05_DECISIONS.md`.
2. Check `08_PROJECT_FACTS.md`.
3. Check the relevant project source.
4. Resolve the contradiction explicitly.
5. Update the memory if the previous understanding was wrong.

## Memory Size Rule

Do NOT copy large amounts of source code, documentation, report text, or project files into the memory folder.

Memory should contain:

* decisions
* conclusions
* verified facts
* progress
* pending work
* important discoveries
* roadmap information
* short references to source files

The actual source material remains in the project.

## Continuity Rule

At the end of a significant task, another agent should be able to open the memory folder and understand:

* what has already been done
* what is currently being worked on
* what remains
* what decisions were made
* what facts are verified
* what is still unknown
* what should happen next

The memory folder must function as a compact continuation layer, not as a second copy of the project.


these files are the persistance files a long term memory so we did not wasted or lost in the middle of the project and all ideas and things be here persisted and presented and you can get back to see what we have done , did and what missing and all the ideas we should focus on and all plans and roadmaps and context files are in the same this folder:

memory/
├── 00_CONTEXT.md
├── 01_REPORT_ROADMAP.md
├── 02_PROGRESS.md
├── 03_CURRENT_STATE.md
├── 04_CONTENT_PLAN.md
├── 05_DECISIONS.md
├── 06_OPEN_TASKS.md
├── 07_TEMPLATE_RULES.md
├── 08_PROJECT_FACTS.md
└── 09_SESSION_LOG.md