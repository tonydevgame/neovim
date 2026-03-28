# JIRA MCP Quick Reference

Quick reference for using JIRA via MCP with your AI assistant (Claude, VS Code Copilot, etc.)

## 🔍 Search & View

```
"Show me all my JIRA issues"
"Find all open bugs in project ABC"
"Get details for issue ABC-123"
"Search JIRA with JQL: project = ABC AND status = 'In Progress'"
"Show me issues due this week"
"List all my assigned issues"
```

## ✏️ Create & Update

```
"Create a new bug in project ABC: User can't login"
"Create a task titled 'Update documentation' in project DEV"
"Update ABC-123 to change priority to High"
"Change the assignee of ABC-123 to john@example.com"
"Add label 'urgent' to ABC-123"
"Set ABC-123 sprint to 'Sprint 24'"
```

## 💬 Comments

```
"Add comment to ABC-123: Fixed in commit abc123"
"Comment on ABC-123: Reviewing the PR now"
"Add a note to ABC-123 about the workaround"
```

## 🔄 Transitions

```
"Move ABC-123 to In Progress"
"Mark ABC-123 as Done"
"Transition ABC-123 to Code Review"
"Close issue ABC-123"
"Reopen ABC-123"
```

## 🔗 Links & Relations

```
"Link ABC-123 to ABC-124 as 'blocks'"
"Show all issues blocked by ABC-123"
"Create a link from ABC-123 to ABC-125"
"Show related issues for ABC-123"
```

## 📝 Confluence

```
"Search Confluence for 'API documentation'"
"Get the content of Confluence page 'Authentication Guide'"
"Create a new page in space DEV titled 'Setup Instructions'"
"Update Confluence page 'Getting Started' with new content"
"Add comment to Confluence page about clarification needed"
```

## 🎯 Project Management

```
"List all projects I have access to"
"Show sprint info for project ABC"
"Get issue types for project ABC"
"Show workflow for issue type 'Bug'"
"List all components in project ABC"
```

## 📊 Reporting & Analytics

```
"How many open issues do I have?"
"Show me all critical bugs"
"Find issues created this week"
"List overdue issues in project ABC"
"Show me the oldest open issues"
```

## 🔧 Advanced JQL Queries

```
"Search: project = ABC AND assignee = currentUser() ORDER BY created DESC"
"Find: status = 'Code Review' AND updated >= -7d"
"Search: priority = High AND resolution = Unresolved"
"Find all issues: type = Bug AND created >= startOfWeek()"
```

## 💡 Tips

1. **Be specific**: Include project key (e.g., "ABC-123") when referencing issues
2. **Use natural language**: The AI will translate to JIRA API calls
3. **Combine operations**: "Create a bug and assign it to me"
4. **Check permissions**: Make sure you have access to projects/issues
5. **Use JQL for complex searches**: More powerful than natural language for advanced queries

## 🔑 Common JQL Fields

- `project` - Project key (e.g., project = ABC)
- `status` - Issue status (e.g., status = "In Progress")
- `assignee` - Assigned user (e.g., assignee = currentUser())
- `priority` - Issue priority (e.g., priority = High)
- `type` - Issue type (e.g., type = Bug)
- `created` - Creation date (e.g., created >= -7d)
- `updated` - Last update (e.g., updated < startOfWeek())
- `resolution` - Resolution (e.g., resolution = Unresolved)
- `labels` - Labels (e.g., labels = urgent)
- `sprint` - Sprint name (e.g., sprint = "Sprint 24")

## 🚨 Troubleshooting

### Not finding issues

- Check project permissions
- Verify project key spelling
- Use JQL search for exact queries

### Can't update issues

- Verify you have edit permissions
- Check if issue is in correct status for transition
- Ensure required fields are filled

### Authentication errors

- Verify API token is valid
- Check environment variables are set
- Test with: `curl -u email:token https://your-domain.atlassian.net/rest/api/3/myself`
