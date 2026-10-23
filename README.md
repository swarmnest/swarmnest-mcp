# Swarmnest MCP Server

Search the [Swarmnest](https://swarmnest.ai) directory from any MCP client: thousands of hand-checked AI agent tools, APIs, MCP servers and data sources in 160+ categories, 500+ Agent Skills, and the Swarmnest Marketplace. Free, read-only, no API key.

**Remote endpoint:** `https://swarmnest.ai/mcp` (Streamable HTTP)
**Docs:** https://swarmnest.ai/mcp-server/

## Tools

| Tool | What it does |
| --- | --- |
| `search_directory` | Keyword search over the directory with typo correction. Filters: `category`, `pricing` (free, freemium, paid, unknown), `auth` (none, key, oauth, unknown), `os` (macOS, iOS, Linux, Windows), `limit` (max 25), `offset`. |
| `get_entry` | Full record for one tool by slug. Unknown slugs return close matches. |
| `list_categories` | Every category with slug, description, entry count and group. Optional `group` filter. |
| `search_skills` | Search Agent Skills (SKILL.md skills, plugin bundles, Cursor rules, AGENTS.md templates, prompt packs). Filters: `category`, `format`, `platform`, `os`, `limit`, `offset`. |
| `get_skill` | One skill with install steps per platform, script/network/credential labels, license and source. |
| `list_marketplace_products` | Swarmnest Marketplace skill packs and bundles with price, product URL and checkout URL. Optional `type`: all, products, bundles. |

Every result includes canonical `swarmnest.ai` URLs. Agent Skills are made by third-party developers, so skill results carry an install warning: review the source before installing.

## Connect

**Claude Code**

```bash
claude mcp add --transport http swarmnest https://swarmnest.ai/mcp
```

**Claude Desktop and Claude.ai:** Settings → Connectors → Add Custom Connector → `https://swarmnest.ai/mcp`

**Cursor** (`~/.cursor/mcp.json`)

```json
{ "mcpServers": { "swarmnest": { "url": "https://swarmnest.ai/mcp" } } }
```

**VS Code** (`.vscode/mcp.json`)

```json
{ "servers": { "swarmnest": { "type": "http", "url": "https://swarmnest.ai/mcp" } } }
```

**Windsurf** (`~/.codeium/windsurf/mcp_config.json`)

```json
{ "mcpServers": { "swarmnest": { "serverUrl": "https://swarmnest.ai/mcp" } } }
```

**Codex** (`~/.codex/config.toml`)

```toml
[mcp_servers.swarmnest]
url = "https://swarmnest.ai/mcp"
```

**Gemini CLI** (`~/.gemini/settings.json`)

```json
{ "mcpServers": { "swarmnest": { "httpUrl": "https://swarmnest.ai/mcp" } } }
```

**Clients that only run local servers** (`npx mcp-remote` bridge)

```json
{ "mcpServers": { "swarmnest": { "command": "npx", "args": ["-y", "mcp-remote", "https://swarmnest.ai/mcp"] } } }
```

**Local stdio build** (reads the same public JSON from swarmnest.ai; Node.js 18+)

```json
{ "mcpServers": { "swarmnest": { "command": "npx", "args": ["-y", "github:swarmnest/swarmnest-mcp"] } } }
```

## Example Prompts

- Find three free web scraping APIs that work without an API key and link their Swarmnest pages.
- Which MCP servers can read and write Postgres? Compare their auth and pricing.
- Search Agent Skills for PDF handling that work in Claude Code and show me how to install the best one.
- What skill packs and bundles does the Swarmnest Marketplace sell, and what does each cost?

## Endpoint Details

- `POST https://swarmnest.ai/mcp` with a JSON-RPC 2.0 request. Responses are `application/json` (no SSE stream needed).
- Methods: `initialize`, `notifications/initialized`, `ping`, `tools/list`, `tools/call`, and `server/discover`.
- Protocol versions: `2026-07-28` (stateless, per-request `_meta`) and `2025-11-25`, `2025-06-18`, `2025-03-26`, `2024-11-05` (initialize handshake). No sessions.
- `GET https://swarmnest.ai/mcp` returns a short JSON description. Server card: `https://swarmnest.ai/mcp/server-card`.
- CORS is open, so browser-based clients work.

```bash
curl -s https://swarmnest.ai/mcp \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json, text/event-stream' \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"search_directory","arguments":{"query":"vector database","limit":5}}}'
```

## Code Layout

- `src/mcp-core.js`: tool definitions, input validation and the JSON-RPC handler (transport-independent).
- `src/search-core.js`: the ranking and typo-correction search used across swarmnest.ai.
- `functions/mcp.js`: the Cloudflare Pages Function that serves `https://swarmnest.ai/mcp`.
- `bin/stdio.js`: stdio transport for local use.
- `server.json`: MCP Registry metadata.

The data comes from the public, static Swarmnest JSON files (`/api-index.json`, `/api/v1/categories.json`, `/api/v1/agent-skills.json`, `/api/v1/products.json` and the per-item JSON under `/api/v1/`), cached in memory. See the [API Terms](https://swarmnest.ai/api-terms/).

## Data API

Prefer plain HTTP? See the [OpenAPI description](https://swarmnest.ai/openapi.json), the [search API](https://swarmnest.ai/api/v1/search?q=translate) and [llms.txt](https://swarmnest.ai/llms.txt).

## License

MIT. Directory content is © Swarmnest and covered by the [Terms](https://swarmnest.ai/terms/). Listed tools and skills belong to their owners.

Questions or corrections: hello@swarmnest.ai
