const express = require('express');
const next = require('next');

const port = 3000;
const app = next({});
const handle = app.getRequestHandler();

app.prepare().then(() => {
  const server = express();
  server.get('*', (req, res) => handle(req, res));
  server.listen(port, (err) => {
    if (err) throw err;
    console.log(`Listening on http://localhost:${port}`);
  });
});
