---
name: gitignore-gen
description: Generate language-specific .gitignore files with comprehensive patterns for any ecosystem
version: 0.1.0
license: Apache-2.0
---

# gitignore-gen

## Purpose

Generate comprehensive `.gitignore` files tailored to specific languages, frameworks, editors, and operating systems. Supports combining multiple templates into a single deduplicated output.

## Instructions

Run `scripts/run.sh` with one or more language/framework/tool names as arguments. The script outputs a ready-to-use `.gitignore` to stdout, which you can redirect to a file.

## Inputs

- **Positional arguments**: One or more template names (e.g., `python`, `node`, `macos`, `vscode`)
- **`--help`**: Show usage information
- **`--list`**: Show all available template names

## Outputs

- A `.gitignore` file printed to stdout, with entries deduplicated and sorted
- Header comments indicating which templates were combined

## Constraints

- No external API calls; all patterns are embedded in the script
- Exits 0 on success, 1 on unknown template name
- Entries are deduplicated and sorted alphabetically when combining multiple templates
