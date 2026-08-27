# GeminX Simple Obby

A tiny, easy-to-test Roblox obby designed to be opened directly in **Roblox Studio**.

Includes:
- **Start** — a safe spawn platform
- **6 jumping platforms** — climb them one by one
- **Lava** — kill bricks between the gaps (fall in = respawn)
- **Checkpoint** — touch it and your respawn point moves forward
- **Finish** — touch it to win

## Open in Roblox Studio

**Option A — Rojo sync (recommended for editing):**
1. Install [Rojo](https://rojo.space).
2. Open this folder in a terminal and run `rojo serve`.
3. In Studio, install the Rojo plugin and connect.

**Option B — Studio MCP / drag & drop:** create a baseplate in Studio and copy the parts/script from this project, or sync via Rojo's `default.project.json`.

> There is no trademarked Roblox asset being copied here — everything is built from Roblox primitives (Parts, SpawnLocation, Scripts) with original Luau code.

## Gameplay script (ServerScriptService/GameScript.server.lua)

The script:
- Respawns players at the spawn location or at the last checkpoint they touched when they hit lava or fall off.
- Advances the checkpoint when a new one is touched.
- Announces a winner when a player reaches the finish.

## Layout

| Element      | Purpose                                             |
|--------------|-----------------------------------------------------|
| SpawnLocation| Safe start point (respawn here initially)           |
| Platforms 1–6| Rising jump platforms                               |
| Lava         | Kill bricks below the gaps                          |
| Checkpoint   | Manual respawn point mid-way                        |
| Finish       | Win plate                                          |

Feel free to tweak platform `Size`/`Position` in `src/Workspace/Platforms` to make jumps easier or harder.
