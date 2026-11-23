# Fleet Workspace

Fleet Workspace is a native macOS editor and SSH dashboard for Codex and Cursor. Open a folder or VS Code workspace, run agents on the machine hosting the project, and review conversations, schedules, and Git changes in one window.

## Run from source

Clone the repo and run the terminal dashboard with Python 3.10 or later.

```sh
git clone https://github.com/vihaanshahh/fleet-workspace.git
cd fleet-workspace
python3 fleet/fleet.py
```

Install and sign in to the Codex or Cursor CLI on each machine where you want an agent to work. See the [Fleet guide](fleet/README.md) for desktop and terminal usage.

## Build the macOS app

The desktop app targets macOS 14 or later and builds with Xcode command line tools. To assemble a staged app, include its Python, CLI, Git, tmux, and model runtime files under `Contents/Resources`, then run the assembler.

```sh
python3 scripts/assemble-macos.py "/path/to/Fleet Workspace.app"
```

The assembler compiles the Swift sources and installs Fleet's Python files into the app bundle. See the Fleet guide for the required runtime files and the full build workflow.

## OpenCode approval preset

For an OpenCode project, copy [the approval preset](integrations/opencode/agent/approval.md) into `.opencode/agent/` and start OpenCode with `opencode --agent approval`. Fleet's Codex approval cards are configured independently in the desktop app.

## License

Fleet Workspace is distributed under the [MIT license](LICENSE).
