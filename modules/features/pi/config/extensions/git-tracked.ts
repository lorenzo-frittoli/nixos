/**
 * Flake-tracking guard.
 *
 * Nix flakes only see git-tracked files. After pi writes a new `.nix` file,
 * stage it with `git add -N` (intent-to-add) so `nix eval`/`nix flake check`
 * can see it, without staging its contents.
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
    if (p.includes("/.git/")) return undefined;

    const abs = path.isAbsolute(p) ? p : path.resolve(ctx.cwd, p);

    try {
      const { stdout } = await run("git", ["-C", path.dirname(abs), "rev-parse", "--show-toplevel"]);
      const root = stdout.trim();
      if (!root) return undefined;

      try {
        await run("git", ["-C", root, "ls-files", "--error-unmatch", "--", abs]);
        return undefined; // already tracked
      } catch {
        await run("git", ["-C", root, "add", "-N", "--", abs]);
        if (ctx.hasUI) {
          ctx.ui.notify(`git add -N ${path.relative(root, abs)} (flakes only see tracked files)`, "info");
        }
      }
    } catch {
      // not in a git repo, or path does not exist yet — nothing to do
    }
    return undefined;
  });
}
