/**
 * Auto-documentation on approval.
 *
 * When the user replies with an approval (e.g. "ok", "lgtm", "ship it") and the
 * working tree has uncommitted changes in a dendritic NixOS repo, inject a
 * request to update the repository documentation via the `repo-documentation`
 * skill. The user's message is left untouched; the instruction is a hidden
 * message delivered to the model.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { execFile } from "node:child_process";
import { promisify } from "node:util";
import { existsSync } from "node:fs";
import * as path from "node:path";

const run = promisify(execFile);

const APPROVAL =
  /^\s*(?:ok(?:ay)?|k|lgtm|looks good(?: to me)?|approved?|ship it|sgtm|sounds good|go ahead|perfect|nice|great|👍)[\s.!,👍]*$/i;

async function git(cwd: string, args: string[]): Promise<string | undefined> {
  try {
    const { stdout } = await run("git", ["-C", cwd, ...args], { timeout: 5_000 });
    return stdout;
  } catch {
    return undefined;
  }
}

export default function (pi: ExtensionAPI) {
  pi.on("before_agent_start", async (event, ctx) => {
    if (!APPROVAL.test(event.prompt ?? "")) return undefined;

    const root = (await git(ctx.cwd, ["rev-parse", "--show-toplevel"]))?.trim();
    if (!root) return undefined;
    // Only for a dendritic repo like this one, not arbitrary directories.
    if (!existsSync(path.join(root, "flake.nix")) || !existsSync(path.join(root, "AGENTS.md"))) {
      return undefined;
    }

    const status = (await git(root, ["status", "--porcelain"])) ?? "";
    if (!status.trim()) return undefined;

    ctx.ui.notify("Changes approved — updating repository documentation", "info");

    const changed = status
      .split("\n")
      .map((l) => l.slice(3).trim())
      .filter(Boolean)
      .slice(0, 20)
      .join("\n");

    return {
      message: {
        customType: "auto-document",
        content:
          "The user just approved the current changes. Before finishing, use the " +
          "`repo-documentation` skill to bring this repository's documentation in sync " +
          "with the changes (`git status` / `git diff`): update README.md, AGENTS.md, " +
          "CHANGELOG.md, and any affected `modules/features/<name>/README.md`. Keep it " +
          "concise and accurate, `git add` the edited docs, then report exactly which " +
          "files you updated and why.\n\nChanged paths:\n" +
          changed,
        display: false,
      },
    };
  });
}
