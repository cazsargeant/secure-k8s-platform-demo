import assert from "node:assert/strict";
import { after, before, describe, it } from "node:test";
import { createServer } from "../src/server.js";

describe("demo-api", () => {
  let server;
  let baseUrl;

  before(async () => {
    server = createServer({ version: "test" });
    await new Promise((resolve) => server.listen(0, "127.0.0.1", resolve));
    const address = server.address();
    baseUrl = `http://127.0.0.1:${address.port}`;
  });

  after(async () => {
    await new Promise((resolve) => server.close(resolve));
  });

  it("reports health", async () => {
    const response = await fetch(`${baseUrl}/healthz`);
    assert.equal(response.status, 200);
    assert.deepEqual(await response.json(), { status: "ok" });
  });

  it("reports readiness", async () => {
    const response = await fetch(`${baseUrl}/readyz`);
    assert.equal(response.status, 200);
    assert.deepEqual(await response.json(), { status: "ready" });
  });

  it("reports version", async () => {
    const response = await fetch(`${baseUrl}/version`);
    assert.equal(response.status, 200);
    assert.deepEqual(await response.json(), { name: "demo-api", version: "test" });
  });

  it("echoes a small request body", async () => {
    const response = await fetch(`${baseUrl}/echo`, {
      method: "POST",
      body: "hello"
    });
    assert.equal(response.status, 200);
    assert.deepEqual(await response.json(), { body: "hello" });
  });

  it("returns 404 for unknown routes", async () => {
    const response = await fetch(`${baseUrl}/missing`);
    assert.equal(response.status, 404);
    assert.deepEqual(await response.json(), { error: "not found" });
  });
});

