# Wiretext API

Wiretext runs entirely in the browser — no server, no HTTP API. The agent-facing
interface is WebMCP.

## WebMCP

With the app open, wiretext registers tools on `document.modelContext`.
Source: `src/lib/webmcp.js`.

### Read-only

| Tool | Does |
|---|---|
| `get_wireframe` | The current wireframe as ASCII text |
| `list_components` | Placeable components and their categories; filter with `category` |

### Reversible writes

| Tool | Does |
|---|---|
| `place_component` | Stamp a component at `col`/`row` (0-based, from top left) |
| `set_wireframe` | Replace the whole wireframe with ASCII `text` |
| `clear_wireframe` | Erase the canvas |
| `undo` / `redo` | Step the history |

Every write goes through the same reducer the toolbar uses, so `undo` reverses
anything an agent did. Nothing is persisted server-side, so no tool requires
confirmation.
