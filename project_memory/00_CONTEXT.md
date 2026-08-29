# Report Writing Memory — Global Context

## Purpose
This folder is the persistent working memory for the report-writing process.

The agent MUST read these memory files before making important report-writing decisions.

The files contain the established project context, report structure, template rules, decisions, progress, remaining work, and important discoveries.

## Core Principles

- Do not hallucinate project facts.
- Do not invent missing information.
- Prefer verified information from project files, documentation, source code, experiments, and provided material.
- When information is unknown, explicitly mark it as `TO BE VERIFIED` or `TO BE PROVIDED`.
- Do not contradict information already established in these memory files.
- Before changing an existing decision, verify why it was made.
- Keep this memory concise and useful.
- Do not duplicate large amounts of project documentation here.
- Store conclusions and important context, not entire source documents.

## Source of Truth Priority

1. Explicit user instructions
2. Project/template files
3. Verified project documentation
4. Verified implementation/code
5. Verified experiments/results
6. Established decisions in this memory
7. Reasonable assumptions — only when clearly marked as assumptions

## Memory Maintenance Rule

After completing an important task, update the relevant memory file.

Do not create a new memory file unless an existing file cannot logically contain the information.

## Important
The memory folder is a navigation and continuity system, not a duplicate copy of the entire project.