# Agent Development

Use this skill when creating, editing, debugging, or troubleshooting Claude Code agents.

You MUST follow the design process below. Do NOT skip stages or combine them.

---

## Stage 1: Deep Requirements

Gather comprehensive requirements by asking follow-up questions. Do NOT proceed until the user has answered.

Ask about:
- **Behavior**: "What happens when...?"
- **Edge cases**: "Are there edge cases like...?"
- **Error handling**: "How should it handle failures/invalid input?"
- **Security considerations**: "What should be restricted?"
- **Tool permissions**: "Which tools does it need? Which MUST be denied?"
- **Scope boundaries**: "What is explicitly out of scope?"

Wait for user responses before proceeding.

---

## Stage 2: Research Patterns

Read existing agents and reference material to identify applicable patterns:
- Search for similar agents in the codebase
- Identify reusable patterns and structures
- Note security patterns from existing implementations
- Check for relevant hooks or integrations

Summarize findings before proceeding.

---

## Stage 3: Design Alternatives

Generate 2-3 design alternatives with clear tradeoffs:

### Design A: [Name]
- **Approach**: [description]
- **Pros**: [benefits]
- **Cons**: [drawbacks]

### Design B: [Name]
- **Approach**: [description]
- **Pros**: [benefits]
- **Cons**: [drawbacks]

### Design C: [Name] (if applicable)
- **Approach**: [description]
- **Pros**: [benefits]
- **Cons**: [drawbacks]

**Recommendation**: [Which design and why]

STOP and wait for user approval before implementing.

---

## Prompt Engineering Reference

### RFC 2119 Directive Language
- **MUST / MUST NOT** - Absolute requirements (use sparingly, too many breaks agent behavior)
- **SHOULD / SHOULD NOT** - Strong recommendations with valid exceptions
- **MAY** - Optional features

### Chain of Thought
Use `<thinking>` tags for internal reasoning.

### Self-Critique
Always validate before presenting: check assumptions, verify code, consider edge cases.

### Security Principles
- Restrict shell commands - whitelist specific commands only
- Restrict file writes - limit to specific directories/patterns
- Never put restricted tools in allowed tools list
- Block injection characters in regex (`$`, `;`, `|`, backticks)

---

## Agent Template

```markdown
# Agent Name

## Purpose
[One sentence describing what this agent does]

## Constraints
- MUST [absolute requirement]
- SHOULD [strong recommendation]
- MUST NOT [absolute prohibition]

## Tools
Allowed: [list specific tools]
Denied: [list restricted tools]

## Workflow
1. [Step 1]
2. [Step 2]
3. [Step 3]

## Output Format
[Expected output structure]
```

---

$ARGUMENTS
