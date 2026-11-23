# Fleet Workspace

Fleet Workspace is a native macOS editor and SSH dashboard for Codex and Cursor. Open a folder or VS Code workspace, run agents in parallel on the machine that hosts the project, and review conversations, schedules, and Git changes from the same window.

[User guide](fleet/README.md)

## macOS

Open **Fleet Workspace** from Applications and use **File → Open Folder** or **File → Open Workspace from File**. Use **Agent options** to choose your CLI command and configure Codex approval cards.

The desktop app targets macOS 14 and later. Build it on the target architecture with Xcode and an app bundle containing the Fleet runtimes. To rebuild from an existing Fleet installation, copy the app into a staging directory, then pass that copy to the assembler.

```sh
stage="$(mktemp -d)"
ditto "$HOME/Applications/Fleet Workbench.app" "$stage/Fleet Workspace.app"
python3 scripts/assemble-macos.py "$stage/Fleet Workspace.app"
codesign --force --sign - "$stage/Fleet Workspace.app"
codesign --verify --deep --strict "$stage/Fleet Workspace.app"
```

For subsequent updates, copy **Fleet Workspace.app** as the starting bundle. For a fresh bundle, stage the following under `Contents/Resources` along with their supporting libraries and files.

- `python/bin/python3` for Python 3.10 or later
- `bin/codex`, `bin/cursor-agent`, `bin/git`, and `bin/tmux`
- `model/onnx/model_quantized.onnx` and its tokenizer and model files

Move the verified build into Applications and open it. Fleet Workspace keeps the previous workbench’s bundle identifier and state directories so existing preferences, schedules, and history stay available. The bundle provides `Contents/Resources/bin/fleet-workspace` and the existing `vhscode-fleet` alias.

## Terminal and SSH

Run with Python 3.10 or later on macOS or Linux. Install and sign in to the Codex or Cursor CLI on the host that will run it.

```sh
./fleet/fleet.py
./fleet/fleet.py ~/src/project
./fleet/fleet.py --ssh build-01 --agent cursor /srv/project
```

## OpenCode approval preset

For an OpenCode project, copy [the approval preset](integrations/opencode/agent/approval.md) into that project's `.opencode/agent/` directory and start OpenCode with `opencode --agent approval`. Fleet’s Codex approval cards are configured independently in the desktop app.

## Source and license

Fleet Workspace is distributed under the [MIT license](LICENSE). The Fleet history here was extracted from the original [workbench branch](https://github.com/vihaanshahh/vhscode/tree/fleet-workbench) through commit `d854af2f`, preserving the authors and order of the Fleet commits. This repository contains Fleet Workspace source and uses separately installed or staged runtimes.
