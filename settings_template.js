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
      {
        username: "admin",
        password: "$2a$12$zC2IXRXiM5z4kPqVJp5SGuww/QZONqTnC7aLKc/pC1Gld.61PQdqu",
        permissions: "*",
      }
    ],
  },
  requireHttps: false,
  // Allow authentication via Basic auth (Authorization header).
  // Validates credentials against adminAuth.users using bcrypt.
  httpNodeMiddleware: function(req, res, next) {
    const bcrypt = require('bcrypt');
    const adminUsers = (module.exports && module.exports.adminAuth && module.exports.adminAuth.users) || [];

    function validateBasic(username, password) {
      const match = adminUsers.find(u => u.username === username);
      if (!match || !match.password) return false;
      try { 
        return bcrypt.compareSync(password, match.password);
      } catch (e) { 
        return false;
      }
    }

    const auth = req.headers && req.headers.authorization;
    if (auth && auth.indexOf('Basic ') === 0) {
      const creds = Buffer.from(auth.slice(6), 'base64').toString('utf8').split(':');
      const username = creds.shift();
      const password = creds.join(':');
      if (validateBasic(username, password)) {
        return next();
      }
    }

    res.setHeader('WWW-Authenticate', 'Basic realm="Node-RED"');
    res.statusCode = 401;
    res.end('Unauthorized');
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
