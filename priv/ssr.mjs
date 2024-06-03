export async function run(args) {
  if (!args) return { error: "Missing args" };
  if (!args.url) return { error: "Missing URL" };
  if (!args.headers) return { error: "Missing headers" };
  const url = new URL(args.url);
  const urlWithoutDomain = url.pathname + url.search + url.hash;

  const manifest = await import(
    "./static/public/client/.vite/ssr-manifest.json",
    { assert: { type: "json" } }
  ).then(({ default: manifest }) => manifest);
  const render = await import("./static/public/server/entry-server.js").then(
    ({ render }) => render
  );
  return await render(urlWithoutDomain, manifest, args.headers || {});
}
