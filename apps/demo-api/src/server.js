import http from "node:http";

export function createServer({ version = process.env.APP_VERSION || "dev" } = {}) {
  return http.createServer((request, response) => {
    const url = new URL(request.url || "/", "http://localhost");

    if (request.method === "GET" && url.pathname === "/healthz") {
      return json(response, 200, { status: "ok" });
    }

    if (request.method === "GET" && url.pathname === "/readyz") {
      return json(response, 200, { status: "ready" });
    }

    if (request.method === "GET" && url.pathname === "/version") {
      return json(response, 200, { name: "demo-api", version });
    }

    if (request.method === "POST" && url.pathname === "/echo") {
      return readBody(request)
        .then((body) => json(response, 200, { body }))
        .catch(() => json(response, 400, { error: "invalid request body" }));
    }

    return json(response, 404, { error: "not found" });
  });
}

function json(response, statusCode, body) {
  response.writeHead(statusCode, { "content-type": "application/json" });
  response.end(JSON.stringify(body));
}

function readBody(request) {
  return new Promise((resolve, reject) => {
    let body = "";
    request.setEncoding("utf8");
    request.on("data", (chunk) => {
      body += chunk;
      if (body.length > 1024) {
        reject(new Error("body too large"));
        request.destroy();
      }
    });
    request.on("end", () => resolve(body));
    request.on("error", reject);
  });
}

if (import.meta.url === `file://${process.argv[1]}`) {
  const port = Number.parseInt(process.env.PORT || "8080", 10);
  createServer().listen(port, "0.0.0.0", () => {
    console.log(`demo-api listening on ${port}`);
  });
}

