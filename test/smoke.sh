#!/bin/bash
# Smoke test: initialize, tools/list and one call against the remote endpoint (or $1)
U=${1:-https://swarmnest.ai/mcp}
for b in '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"smoke","version":"1"}}}' \
         '{"jsonrpc":"2.0","id":2,"method":"tools/list"}' \
         '{"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"search_directory","arguments":{"query":"vector database","limit":3}}}'; do
  curl -sf "$U" -H 'Content-Type: application/json' -H 'Accept: application/json, text/event-stream' -d "$b" | head -c 300 || { echo "FAIL"; exit 1; }; echo; done
