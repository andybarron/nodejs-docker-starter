# nodejs-docker-starter

_Build a NodeJS app without spending time on toolchain setup_

[![GitHub: AndyBarron/nodejs-docker-starter][github-badge]][github-link]

## Requirements

- [Install **Docker**](https://docs.docker.com/install/)
- [Install **Docker Compose**](https://docs.docker.com/compose/install/)
- Ensure you have necessary files and directories on your machine:

```
touch ~/.gitignore && mkdir -p ~/.ssh/
```

- **You _do not_ need to install NodeJS, NPM, or yarn!** The development container
  will automatically install them.

## Getting started

### With VS Code (recommended)

1. Open the repository directory with VS Code: **File > Open Workspace...**
2. Install the [**"Remote - Containers" extension**][remote-containers-ext]
   (and, if prompted, reload VS Code)
3. Click the **green remote icon on the bottom left**, or open the
   **Command Palette** with **Command+Shift+P**/**Control+Shift+P**
4. Select **"Remote-Containers: Reopen in Container"**
5. If the VS Code terminal isn't visible, open it with **Command+~** or
   **Control+~**
6. If the terminal isn't showing a Bash prompt, open one with the
   **"+" button** next to the terminal dropdown menu
7. Develop as usual

### Without VS Code

**The VS Code method is recommended over this one. It will automatically
install extensions (in the container) to format code with `prettier`
when saved and display errors from ESLint (if you add a config file for
it).**

1. From the repository root directory, run **`docker-compose up -d`**
2. Open a shell in the container with
   **`docker-compose exec dev bash`**
3. When you're done, run **`docker-compose down`** (from the repository
   root)

### Running your app

From inside the development container, use **`yarn watch`** to run your
app. It will restart automatically when you modify any code in the `src/`
directory.

### Using Git

You can use Git over SSH normally from within the development container.
Configuration files for Git and SSH (`~/.gitconfig` and `~/.ssh/`) are
mounted into the container from the host machine. If you don't want this,
remove those lines from the `services.dev.volumes` section of
`docker-compose.yml`.

## Included NPM scripts

- **`yarn start`** - run the app
- **`yarn watch`** - run the app in development mode, restarting on changes
- **`yarn format`** - automatically format all source files using `prettier`

## Default setup notes

- Port 3000 in the container is exposed to the host automatically. A
  web server (Express, etc.) listening on port 3000 will be reachable
  on the host machine at [`http://localhost:3000`](http://localhost:3000).

[github-badge]: https://img.shields.io/badge/GitHub-AndyBarron/nodejs--docker--starter-informational?logo=github&style=flat-square
[github-link]: https://github.com/AndyBarron/nodejs-docker-starter
[remote-containers-ext]: https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers
