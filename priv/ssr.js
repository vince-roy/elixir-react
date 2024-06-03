import fs from "node:fs/promises";

module.exports = async (args) => {
  if (!args) return { error: "Missing args" };
  if (!args.url) return { error: "Missing URL" };
  if (!args.headers) return { error: "Missing headers" };
  const url = new URL(args.url);
  const urlWithoutDomain = url.pathname + url.search + url.hash;

  const manifest = require("./static/public/client/ssr-manifest.json");
  const render = await import("./static/public/server/entry-server.mjs").then(
    ({ render }) => render
  );
  return await render(urlWithoutDomain, manifest, args.headers || {});
};
