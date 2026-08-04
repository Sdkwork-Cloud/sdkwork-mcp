import path from "node:path";
import { fileURLToPath } from "node:url";
import tailwindcss from "@tailwindcss/vite";
import react from "@vitejs/plugin-react";
import { defineConfig, loadEnv } from "vite";

const appRoot = path.dirname(fileURLToPath(import.meta.url));
const repoRoot = path.resolve(appRoot, "../..");

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, appRoot, "");
  return {
    define: {
      "process.env.SDKWORK_ACCESS_TOKEN": JSON.stringify(env.SDKWORK_ACCESS_TOKEN ?? ""),
    },
    plugins: [react(), tailwindcss()],
    resolve: {
      alias: {
      },
    },
    server: { port: 5196 },
  };
});
