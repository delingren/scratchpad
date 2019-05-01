const express = require("express");
const next = require("next");

const port = 3000;
const app = next({ dev: true });
const handle = app.getRequestHandler();

app.prepare().then(() => {
  const server = express();

  server.get("/p/:id", (req, res) => {
    const actualPage = "/post";
    const queryParams = { id: req.params.id };
    app.render(req, res, actualPage, queryParams);
  });

  server.get("*", (req, res) => handle(req, res));
  server.listen(port, err => {
    if (err) throw err;
    console.log(`Listening on http://localhost:${port}`);
  });
});
