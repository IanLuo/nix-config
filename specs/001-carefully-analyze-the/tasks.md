# Tasks: Create Comprehensive README.md

**Input**: Design documents from `/Users/ianluo/.config/darwin/specs/001-carefully-analyze-the/`

## Phase 3.1: Setup & Analysis

- [ ] T001: Read the main configuration file at `/Users/ianluo/.config/darwin/flake.nix` to understand the project's primary inputs, outputs, and overall structure.
- [ ] T002: [P] Execute a `glob` search for `programs/**/*.nix` within `/Users/ianluo/.config/darwin` to compile a complete list of all managed user applications.
- [ ] T003: [P] Execute a `glob` search for `services/**/*.nix` within `/Users/ianluo/.config/darwin` to compile a complete list of all managed background services.
- [ ] T004: [P] Execute a `glob` search for `scripts/*.sh` within `/Users/ianluo/.config/darwin` to identify all available helper scripts and common commands.

## Phase 3.2: Core Implementation

- [ ] T005: Synthesize the information gathered from the analysis tasks (T001-T004) and the content outline from `quickstart.md` to generate the full markdown text for the new `README.md` file. This is a content generation step.

## Phase 3.3: Polish & Finalization

- [ ] T006: Write the generated markdown content from task T005 to the project's root `README.md` file, located at `/Users/ianluo/.config/darwin/README.md`, overwriting any existing file.
- [ ] T007: Read the newly created `README.md` at `/Users/ianluo/.config/darwin/README.md` to perform a final verification of its accuracy, completeness, and formatting.

## Dependencies

- Tasks T001, T002, T003, and T004 are prerequisites for T005.
- Task T005 must be completed before T006.
- Task T006 must be completed before T007.

## Parallel Example

The initial analysis tasks can be run in parallel:

```
Task: "[P] Execute a `glob` search for `programs/**/*.nix` within `/Users/ianluo/.config/darwin` to compile a complete list of all managed user applications."
Task: "[P] Execute a `glob` search for `services/**/*.nix` within `/Users/ianluo/.config/darwin` to compile a complete list of all managed background services."
Task: "[P] Execute a `glob` search for `scripts/*.sh` within `/Users/ianluo/.config/darwin` to identify all available helper scripts and common commands."
```
