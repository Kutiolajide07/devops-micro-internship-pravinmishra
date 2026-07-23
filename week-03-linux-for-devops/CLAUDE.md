# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Status

This repository is an empty scaffold for a "week-03-agentic-linux" exercise. As of this file's creation there is no source code, build tooling, tests, git history, or README. The structure below reflects intended usage inferred from directory names — update this file as real code and commands land.

## Layout

- `scripts/` — (empty) intended home for Linux automation / triage scripts.
- `reports/` — (empty) intended home for generated output (triage reports, findings).
- `.claude/skills/linux-triage/SKILL.md` — a Claude Code skill for diagnosing Linux system health (CPU, memory, disk, services, networking, logs). Evidence-first, read-only by default, and requires human approval before destructive changes. Writes triage reports to `reports/`.

## Notes for future instances

- There are no build, lint, or test commands yet — do not invent them. When adding tooling, document the actual commands here.
- The project theme is agentic Linux triage: scripts likely inspect a Linux system and write findings into `reports/`. Confirm this against real code before relying on it.
