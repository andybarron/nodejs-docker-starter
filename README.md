# nodejs-docker-starter

_Build a NodeJS app without spending time on toolchain setup_

[![GitHub: AndyBarron/nodejs-docker-starter][github-badge]][github-link]

## Requirements

- [Install **Docker**](https://docs.docker.com/install/)
- [Install **Docker Compose**](https://docs.docker.com/compose/install/)
- **You _do not_ need to install NodeJS or NPM!** The development container
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
7. From the VS Code terminal (which is now running inside the container),
   install dependencies with **`npm install`**

### Without VS Code

**The VS Code method is recommended over this one. It will automatically
install extensions (in the container) to format code with `prettier`
when saved and display errors from ESLint (if you add a config file for
it).**

1. From the repository root directory, run **`docker-compose up -d`**
2. Open a shell in the container with
   **`docker-compose exec dev bash`**
3. From the new shell inside the container, install dependencies with
   **`npm install`**
4. When you're done, run **`docker-compose down`** (from the repository
   root)

### Running your app

From inside the development container, use **`npm run watch`** to run your
app. It will restart automatically when you modify any code in the `src/`
directory.

### Environment variables

1. Fill out `.env.example` with all required variables and sample values
2. Create a new file `.env` with the values you want to use while developing
3. Your app will automatically load the values from your `.env` file into the
   NodeJS global `process.env` whenever your app starts or restarts from
   changes

## Included NPM scripts

- **`npm start`** - run the app
- **`npm run watch`** - run the app in development mode, restarting on changes
- **`npm format`** - automatically format all source files using `prettier`

## Default setup notes

- Port 3000 in the container is exposed to the host automatically. A
  web server (Express, etc.) listening on port 3000 will be reachable
  on the host machine at [`http://localhost:3000`](http://localhost:3000).
- The `docker-compose.yml` file also spins up a containerized PostgreSQL
  database for convenience. It is accessible from the development container
  via the environment variable `POSTGRES_URI` in `.env.example`. If you don't
  need it, remove the `postgres` service from `docker-compose.yml`, or use it
  as a template for another database, such as MySQL or MongoDB.

[github-badge]: https://img.shields.io/badge/GitHub-AndyBarron/nodejs--docker--starter-informational?logo=github&style=flat-square
[github-link]: https://github.com/AndyBarron/nodejs-docker-starter
[remote-containers-ext]: https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers
