# Chaos Lab - Podman Desktop Extension

Chaos engineering toolkit for Podman Desktop. Inject faults, shape network traffic, limit resources, and isolate containers to test resilience.

## Features

- **Scenario Scheduler** – Create recurring chaos attacks (stop, kill, pause, restart) targeting random, specific, or all containers.
- **Network Shaper** – Inject latency, packet loss, and bandwidth limits into running containers via `tc`.
- **Resource Limiter** – Constrain CPU and memory on the fly with `podman update`.
- **Container Isolator** – Pause containers, disconnect them from networks, or partition them from specific peers.
- **Live Dashboard** – Real-time CPU, memory, network I/O, and block I/O metrics with time-series charts.
- **Safe-list** – Protect critical containers (e.g. `postgres*`, `redis-prod`) from all chaos operations.
- **Tray & Commands** – Quick access via tray menu and command palette (`Stop All Chaos`).

## Architecture

| Package | Description |
|---------|-------------|
| `packages/backend` | Extension entry point, Podman API calls, chaos engine, settings |
| `packages/frontend` | Svelte 5 + TailwindCSS dashboard with @podman-desktop/ui-svelte |
| `packages/shared` | RPC types and message proxy connecting frontend ↔ backend |

## Workshop

This repository doubles as a hands-on workshop for learning the Podman Desktop Extension API. The `workshop/*` branches provide a progressive, step-by-step guide — each branch builds on the previous one by filling in one more TODO placeholder.

### Getting started

```sh
git checkout workshop/01-progress-task   # skeleton with all TODOs
npm install && npm run build
```

Load the extension in Podman Desktop and start filling in the numbered TODOs. Each branch is named after the task you'll implement there — the branch number matches the TODO number. Check your work against the next branch at any time.

### Branch progression

| Branch | TODO | API taught | File |
|--------|------|-----------|------|
| `workshop/01-progress-task` | #1 | `withProgress` | `chaos-api-impl.ts` |
| `workshop/02-status-bar` | #2 | `createStatusBarItem` | `extension.ts` |
| `workshop/03-status-bar-dynamic` | #3 | Dynamic status bar updates via `setInterval` | `extension.ts` |
| `workshop/04-command-stop-all` | #4 | `commands.registerCommand`, `showInformationMessage` | `extension.ts` |
| `workshop/05-command-open-dashboard` | #5 | Command + `panel.reveal()` | `extension.ts` |
| `workshop/06-command-view-container` | #6 | Command + `webview.postMessage` | `extension.ts` |
| `workshop/07-tray-menu` | #7 | `tray.registerMenuItem` with submenu | `extension.ts` |
| `workshop/08-config-change-listener` | #8 | `onDidChangeConfiguration` | `settings-manager.ts` |
| `workshop/09-config-read-values` | #9 | `configuration.getConfiguration` | `settings-manager.ts` |
| `workshop/10-create-provider` | #10 | `provider.createProvider` | `chaos-provider.ts` |
| `workshop/11-connection-factory` | #11 | `setContainerProviderConnectionFactory` | `chaos-provider.ts` |
| `workshop/12-ci-workflows` | #12 | CI/CD: nightly + release image builds | `.github/workflows/` |
| `workshop/13-onboarding` | #13 | `context.setValue` + onboarding workflow | `chaos-provider.ts` |
| `workshop/14-cli-tool` | #14 | `cli.createCliTool` | `extension.ts` |
| `dev_conf` | — | All TODOs completed (final) | — |

### Quick reference

Every workshop branch includes a `SKILL.md` file at the repo root with an API cheat sheet covering common patterns, code snippets, and links to documentation.

## Development of the extension against production Podman Desktop (1.27.2)

In the extension's root folder:
```sh
npm install
npm run build    # or: npm run watch
```

Download Podman Desktop ([github podman-desktop releases](https://github.com/podman-desktop/podman-desktop/releases/tag/v1.27.2)) and install it.

Load the extension in Podman Desktop (v1.17+):

1. Start Podman Desktop
2. Enable **Development Mode** in Settings → Extensions.
3. Go to **Extensions → Local extension** tab.
4. Click **Add a local folder…** and select `packages/backend`.

## Extension development againts development version of Podman Desktop (nightly)

Prerequisities: Nodejs v24.15.0, npm and pnpm!
```sh
npm install -g pnpm@10
```

Checkout the podman-desktop repository, install dependencies

```sh
git clone https://github.com/podman-desktop/podman-desktop.git
cd podman-desktop
pnpm install
```

And run the podman-desktop in the watch mode with a link to extension's folder (so we can enable auto-reload)
```sh
# in podman-desktop root folder
pnpm watch --extension-folder ~/git/extension-template-full/packages/backend/
```

Run the extension in the watch mode
```sh
cd extension-template-full
npm install
npm run watch
```

Enjoy auto-reload of the changes done on the extension's side in the running instance of the Podman Desktop.

## Packaging

```sh
podman build -t quay.io/myusername/chaos-lab .
podman push quay.io/myusername/chaos-lab
```

Install via Podman Desktop **Install Custom…** button.

## License

These files will be loaded from the extension.

Optionally, you can also use `npm run watch` to continuously rebuild after each change, without needing to re-run `npm build`:

```sh
$ npm run watch
```

4. Load the extension within Podman Desktop:

We will load the extension within Podman Desktop to test it. This requires Podman Desktop v1.17+

1. Navigate to the settings and enable `Development Mode` for the `extensions`
1. Click on the `extensions` nav item in the left navigation bar
1. Go to the `Local extension` tab.
1. Click on the 'Add a local folder...' button and select the path of the `packages/backend` folder of this extension and click OK.
1. Now the extension is part of Podman Desktop and you can see it listed in the `installed` tab of the Extensions panel.


5. Confirm that the extension has been loaded:

You will now see a "Hello World" webview in the Podman Desktop navbar. You can also check the developer console for any logging information indicating that the extension has been loaded successfully.

Example of extension loading:

![loaded](/images/loaded.png)

## Linter, Typecheck, and Formatter

We include additional tools to assist in development, which can be found in the main `package.json` file.

Formatter:
```sh
$ npm run format:fix
```

Linter:
```sh
$ npm run lint:fix
```

Typechecker:
```sh
$ npm run typecheck
```

## Packaging and Publishing

More information on how to package and publish your extension can be found in our [official publishing documentation](https://podman-desktop.io/docs/extensions/publish).

However, we have provided a pre-made Containerfile in this template for you to try.

1. Package your extension by building the image:

```sh
$ podman build -t quay.io/myusername/myextension .
```

2. Push the extension to an external registry:

```sh
$ podman push quay.io/myusername/myextension
```

3. Install via the Podman Desktop "Install Custom..." button:

![custom install](/images/custom_install.png)

## Using Extension's image locally

```sh
# directly use Podman Desktop Home Configuration folder
pluginsFolder=~/.local/share/containers/podman-desktop/plugins/
# build the image using Containerfile
podman build -t chaos-lab ./ -f ./Containerfile
# create a container to access extension's file system
CONTAINER_ID=$(podman create localhost/chaos-lab --entrypoint "")
mkdir -p $pluginsFolder
# store the image file system into archive and extract it into correct location
podman export $CONTAINER_ID | tar -x -C $pluginsFolder
# renaming for better readability
mv $pluginsFolder/extension $pluginsFolder/chaoslab-extension
# remove container and image
podman rm -f $CONTAINER_ID
podman rmi -f localhost/chaos-lab:latest
```
