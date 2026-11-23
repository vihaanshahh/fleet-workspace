# Fleet runtime guidance

- Support Python 3.10 and later. Keep the terminal entry point at `fleet/fleet.py`.
- Keep RPC responses compatible with installed clients. Remote hosts can already have an older cached bundle.
- Keep run and session state on the workspace host. Use temporary state and test CLI fixtures in integration tests.
- Run the runtime tests with `python3 -m unittest discover -s tests` from the repo.
