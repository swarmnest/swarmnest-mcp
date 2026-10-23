#!/usr/bin/env node
// Local stdio transport for the Swarmnest MCP server. Reads the same public static JSON from swarmnest.ai.
// Usage: npx github:swarmnest/swarmnest-mcp   (or: node bin/stdio.js)
import { createInterface } from 'node:readline';
import { handle } from '../src/mcp-core.js';
const BASE = process.env.SWARMNEST_BASE || 'https://swarmnest.ai';
const get = p => fetch(new URL(p, BASE), { headers: { 'user-agent': 'swarmnest-mcp-stdio/1.0' } });
const out = m => process.stdout.write(JSON.stringify(m) + '\n');
const rl = createInterface({ input: process.stdin });
rl.on('line', async line => {
  if (!line.trim()) return;
  let msg; try { msg = JSON.parse(line); } catch { return out({ jsonrpc: '2.0', id: null, error: { code: -32700, message: 'Parse error' } }); }
  const list = Array.isArray(msg) ? msg : [msg];
  for (const m of list) { const r = await handle(m, { get }); if (r.body) out(r.body); }
});
