#!/usr/bin/env nodejs

var http = require('http');

http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end('Hello from the API-app!\n');
}).listen(9696, 'localhost');

console.log('Server running at http://localhost:9696/');
