// https://nodered.org/docs/user-guide/runtime/configuration

module.exports = {
  flowFile: "flows.json",
  flowFilePretty: true,
  userDir: '/data',
  nodesDir: '/data/nodes',
  adminAuth: {
    type: "credentials",
    users: [
      {
        username: "example_user",
        password: "example_pass",
        permissions: "*",
      },
      {
        username: "developer",
        password:
          "$2a$12$.pB1blMpPJJ42Dd1PiWYne4uxE8NrCHnioblVdp65MbOOkXRRLHNW",
        permissions: "*",
      },
    ],
  },
  requireHttps: false,
  httpNodeAuth: {
    user: "example_user",
    pass: "example_pass",
  },
  uiPort: process.env.PORT || 1880,
  httpNodeRoot: '/api/v1',
  diagnostics: {
    enabled: true,
    ui: true,
  },
  runtimeState: {
    enabled: false,
    ui: false,
  },
  logging: {
    console: {
      level: "info",
      metrics: false,
      audit: false,
    },
  },
  exportGlobalContextKeys: false,
  externalModules: {},
  editorTheme: {
    palette: {},

    projects: {
      enabled: false,
      workflow: {
        mode: "manual",
      },
    },

    codeEditor: {
      lib: "monaco",
      options: {},
    },
  },
  functionExternalModules: true,
  functionGlobalContext: {},
  debugMaxLength: 1000,
  mqttReconnectTime: 15000,
  serialReconnectTime: 15000
};
