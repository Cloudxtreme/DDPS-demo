#!/usr/bin/env nodejs

var http = require('http');

http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end('Hello from the WEB-app!\n');
}).listen(8686, 'localhost');

console.log('Server running at http://localhost:8686/');
