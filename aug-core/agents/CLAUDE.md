# Agents

## Purpose

Task subagent definitions for aug-core workflows. Agents execute specialized tasks autonomously via Task tool.

## Key Components

- `user-standin.md` - Context-aware proxy that makes user-like decisions by analyzing CLAUDE.md hierarchy and directory structure

## Usage

Agents are invoked via Task tool with `subagent_type` parameter. Used primarily in /automate and workflow automation.
