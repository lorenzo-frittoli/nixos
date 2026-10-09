/**
 * Nix parse check.
 *
 * After a `.nix` file is written or edited, parse it with `nix-instantiate
 * --parse`. This is fast (no evaluation) and catches syntax errors before a
 * slow `nix flake check`. The error is appended to the tool result so the
 * model sees it immediately.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { execFile } from "node:child_process";
import { promisify } from "node:util";
import * as path from "node:path";

const run = promisify(execFile);

export default function (pi: ExtensionAPI) {
  pi.on("tool_result", async (event, ctx) => {
    if (event.toolName !== "write" && event.toolName !== "edit") return undefined;
    if (event.isError) return undefined;

    const p = event.input.path as string | undefined;
    if (!p || !p.endsWith(".nix")) return undefined;

    const abs = path.isAbsolute(p) ? p : path.resolve(ctx.cwd, p);

    try {
      await run("nix-instantiate", ["--parse", abs], { timeout: 30_000 });
      return undefined;
    } catch (error: unknown) {
      const err = error as { stderr?: string; stdout?: string; message?: string };
      const detail = (err.stderr || err.stdout || err.message || String(error)).trim();
      if (ctx.hasUI) ctx.ui.notify(`Nix parse error in ${p}`, "error");
      const content = Array.isArray(event.content) ? [...event.content] : [];
      return {
        isError: true,
        content: [...content, { type: "text", text: `\n\n[nix-check] ${p} failed to parse:\n${detail}` }],
      };
    }
  });
}
