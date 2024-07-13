# <picture>

<div align=center>
  <h2 style="display: inline-block; vertical-align: center;"><img src ="https://www.stackhero.io/assets/src/images/servicesLogos/openGraphVersions/node-red.png?481ffe83" width="80px" alt="Node-RED Logo"></img></picture> STATUS - Infraestructure </h2>
</div>
  <h4 align="center">Status infrastructure installation repository</h4>

## ⚙ Running the server locally with Docker

### Installation prerequisites

Before starting with the installation it is necessary to install or upgrade the following tools:

- Docker: You can find the installation guide for your operating system [here](https://docs.docker.com/get-docker/).

> [!CAUTION]
> This installation includes a `.env.deploy` file that must be partially filled in by the user. In order to use the application correctly, you must enter this .env:
>
> - OpenAI API Key
> - OpenAI OrgID
> - Github Client Secret

### Installation Guide for Windows

1. Open Windows PowerShell.

2. Clone the GitHub repository with the following command:

   ```bash
   git clone https://github.com/statuscompliance/infraestructure
   ```

3. Find the `infraestructure` folder or execute:

   ```bash
   cd .\infraestructure\
   ```

4. Navigate to the `Windows` directory:

   ```bash
   cd .\Windows\
   ```

5. Run the setup script:

   ```bash
   .\setup.ps1
   ```

### Installation Guide for MacOS/Linux

1. Open a terminal.

2. Clone the GitHub repository by running the following command:

   ```bash
   git clone https://github.com/statuscompliance/infraestructure
   ```

3. Change to the newly cloned directory:

   ```bash
   cd infraestructure
   ```

4. Run the setup script:

   ```bash
   ./setup.sh
   ```
