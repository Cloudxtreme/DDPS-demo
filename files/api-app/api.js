#!/usr/bin/env nodejs

// This Node.js app runs a demo API app

const http = require('http');

const hostname = process.env.NODE_API_IP || '0.0.0.0'; // use NODE_API_IP from systemd web.node.service file
const port = process.env.NODE_API_PORT || 9090;        // use NODE_API_IP from systemd web.node.service file

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('Hello from the API-app\n');
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});
