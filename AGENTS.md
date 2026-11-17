# prometheus-speedtest-exporter

Shell-based Prometheus exporter for the Ookla Speedtest CLI, with Bats tests and a Docker image.

## Verify

- `mise run check`: ShellCheck and Bats.
- CI builds both Linux image architectures without pushing and runs actionlint, zizmor, and strict Renovate validation.

The required gate is `check`. Publishing stays in the separate release workflow.

## Stack

Follows https://github.com/BlackDark/agent-presets/blob/main/stack/core.md. The existing shell, Bats, and Docker stack stays.

## Map

- `speedtest-exporter.sh`: exporter and CLI-output parsing.
- `tests/`: Bats fixtures and behavior tests.
- `Dockerfile`, `config.yaml`: runtime image and exporter configuration.

## Git

- Conventional Commits, one topic per PR.
- Squash unless commits need separate review.
- Force-push only with `--force-with-lease` on own branches.

## Boundaries

- Tools come from `mise.toml`; no global installs.
- Do not push Docker images or create release tags from a local session.
- Do not run repeated live speed tests in CI; use the fixtures.
