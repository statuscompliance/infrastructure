# <picture>

<div align=center>
  <img src ="https://avatars.githubusercontent.com/u/151918147?s=200&v=4" width="200px"  heigth="200px" alt="Status Logo"></img></picture>
</div>
  <h4 align="center">Status infrastructure installation repository</h4>

## ⚙ Running the server with Docker

### Installation prerequisites

Before starting with the installation it is necessary to install or upgrade the following tools:

- Docker: You can find the installation guide for your operating system [here](https://docs.docker.com/get-docker/).

> [!CAUTION]
> This installation includes a `.env.deploy` file that must be partially filled in by the user. In order to use the application correctly, you must enter this .env:
>
> - OpenAI API Key
> - OpenAI OrgID
> - Github Client Secret

### Deployment Modes

The infrastructure supports two deployment modes:

- **Development mode** (`dev`): Builds images from local source code (requires backend and frontend repositories cloned alongside infrastructure)
- **Production mode** (`prod`): Uses pre-built images from container registries with nginx reverse proxy

### Installation Guide for Windows

1. Open Windows PowerShell.

2. Clone the GitHub repository with the following command:

   ```bash
   git clone https://github.com/statuscompliance/infrastructure
   ```

3. Find the `infrastructure` folder or execute:

   ```bash
   cd .\infrastructure\
   ```

4. Navigate to the `Windows` directory:

   ```bash
   cd .\Windows\
   ```

5. Run the setup script and choose your deployment mode when prompted:

   ```bash
   .\setup.ps1
   ```

### Installation Guide for MacOS/Linux

1. Open a terminal.

2. Clone the GitHub repository by running the following command:

   ```bash
   git clone https://github.com/statuscompliance/infrastructure
   ```

3. Change to the newly cloned directory:

   ```bash
   cd infrastructure
   ```

4. Run the setup script and choose your deployment mode when prompted (dev or prod):

   ```bash
   ./setup.sh
   ```

The script will prompt you to select between `dev` or `prod` mode (defaults to `dev`).

### Manual Deployment

If you prefer to run Docker Compose manually:

**Development mode:**
```bash
docker compose -f docker-compose.dev.yml up
```

**Production mode:**
```bash
docker compose -f docker-compose.prod.yml up
```

## 🏗️ Architecture

### Services

The infrastructure consists of the following services:

- **status-backend**: Backend API service (Node.js)
- **status-frontend**: Frontend web application (React/Vite)
- **reverse-proxy**: Nginx reverse proxy (production only)
- **nodered**: Node-RED workflow automation
- **postgres**: PostgreSQL database
- **grafana**: Grafana monitoring and dashboards
- **dragonfly**: Redis-compatible in-memory data store
- **director**: Governify director service
- **registry**: Governify registry service
- **mongo-registry**: MongoDB for registry service

### Port Mapping

- **3000**: Main application access (via nginx in prod, direct frontend in dev)
- **3001**: Backend API (dev mode only)
- **1880**: Node-RED editor
- **3100**: Grafana dashboard
- **5432**: PostgreSQL database
- **5400**: Registry service
- **5800**: Director service
- **6379**: Dragonfly/Redis

### Networks

- `web_network`: Frontend, backend, and proxy communication
- `db_network`: Database services communication
- `nodered_network`: Node-RED integration network
