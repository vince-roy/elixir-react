import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import tsconfigPaths from "vite-tsconfig-paths";

// https://vitejs.dev/config/
export default defineConfig({
  base: process.env.NODE_ENV === "production" ? "/public/" : "/",
  build: {
    manifest: true,
    rollupOptions: {
      // overwrite default .html entry
      input: "./src/entry-client.tsx",
    },
    emptyOutDir: true,
    outDir: "../priv/static/public",
  },
  plugins: [react(), tsconfigPaths()],
  server: {
    origin: "http://localhost:5173",
  },
  ssr: {
    noExternal: /./,
  },
});
