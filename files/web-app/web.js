#!/usr/bin/env nodejs

// This Node.js app runs a demo WEB app

const http = require('http');

const hostname = process.env.NODE_WEB_IP || '0.0.0.0'; // use NODE_WEB_IP from systemd web.node.service file
const port = process.env.NODE_WEB_PORT || 8080;        // use NODE_WEB_PORT from systemd web.node.service file

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('Hello from the WEB-app\n');
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});
