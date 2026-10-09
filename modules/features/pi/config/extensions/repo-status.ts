/**
 * Repo status line.
 *
 * Shows the hostname plus the current git branch and a dirty marker in the
 * footer. Recomputed at session start and at the end of each turn.
 */

import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { execFile } from "node:child_process";
import { promisify } from "node:util";
import os from "node:os";

const run = promisify(execFile);

async function gitInfo(cwd: string): Promise<string> {
  try {
    const { stdout: branch } = await run("git", ["-C", cwd, "rev-parse", "--abbrev-ref", "HEAD"], {
      timeout: 5_000,
    });
    const { stdout: status } = await run("git", ["-C", cwd, "status", "--porcelain"], { timeout: 5_000 });
    const dirty = status.trim() ? "*" : "";
    return `${branch.trim()}${dirty}`;
  } catch {
    return "";
  }
}

async function update(ctx: ExtensionContext): Promise<void> {
  const git = await gitInfo(ctx.cwd);
  const text = git ? `${os.hostname()} ${git}` : os.hostname();
  try {
    ctx.ui.setStatus("nixos-repo", ctx.ui.theme.fg("dim", text));
  } catch {
    // no UI (print/json mode)
  }
}

export default function (pi: ExtensionAPI) {
  pi.on("session_start", async (_event, ctx) => update(ctx));
  pi.on("turn_end", async (_event, ctx) => update(ctx));
}
