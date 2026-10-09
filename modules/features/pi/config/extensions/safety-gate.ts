/**
 * Safety gate for this NixOS repo.
 *
 * Enforces the AGENTS.md hard rules:
 *  - Confirm (or block, when there is no UI) destructive/system-changing commands.
 *  - Block writes to secret files so plaintext is never committed.
 *
 * Based on the upstream permission-gate.ts and protected-paths.ts examples.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const destructivePatterns: { re: RegExp; why: string }[] = [
  { re: /\bnh\s+os\s+(switch|test|boot)\b/, why: "activates a NixOS generation" },
  { re: /\bnixos-rebuild\b/, why: "activates a NixOS generation" },
  { re: /\b(reboot|shutdown|poweroff|halt)\b/, why: "reboots or powers off the machine" },
  { re: /\bformat\.bash\b/, why: "reformats the disks" },
  { re: /\bdisko\b[^\n]*\b(destroy|format|mount)\b/, why: "reformats the disks" },
  { re: /\b(mkfs|wipefs|fdisk|parted|sgdisk)\b/, why: "modifies disk partitions" },
  { re: /\bdd\b[^\n]*\bof=\/dev\//, why: "writes raw data to a block device" },
  { re: /\bsops\b/, why: "reads, decrypts, or edits secrets" },
  { re: /\brm\s+(-[a-z]*r[a-z]*f|-[a-z]*f[a-z]*r)\b/, why: "recursively force-deletes files" },
  { re: /\bgit\s+push\b[^\n]*(-f|--force)\b/, why: "force-pushes history" },
];

const protectedPathPatterns: { re: RegExp; why: string }[] = [
  { re: /(^|\/)secrets\/.*\.(ya?ml)$/, why: "secret files are edited only via sops" },
  { re: /(^|\/)\.sops\.ya?ml$/, why: "sops policy files must be edited deliberately" },
  { re: /(^|\/)\.git\//, why: "the git directory must not be edited directly" },
];

export default function (pi: ExtensionAPI) {
  pi.on("tool_call", async (event, ctx) => {
    if (event.toolName === "bash") {
      const command = String(event.input.command ?? "");
      const hit = destructivePatterns.find((p) => p.re.test(command));
      if (!hit) return undefined;

      if (!ctx.hasUI) {
        return { block: true, reason: `Blocked (${hit.why}) in non-interactive mode: ${command}` };
      }

      const choice = await ctx.ui.select(
        `⚠️  This command ${hit.why}:\n\n  ${command}\n\nRun it?`,
        ["No", "Yes"],
      );
      if (choice !== "Yes") {
        return { block: true, reason: "Blocked by user" };
      }
      return undefined;
    }

    if (event.toolName === "write" || event.toolName === "edit") {
      const path = String(event.input.path ?? "");
      const hit = protectedPathPatterns.find((p) => p.re.test(path));
      if (hit) {
        if (ctx.hasUI) ctx.ui.notify(`Blocked write to ${path}: ${hit.why}`, "warning");
        return { block: true, reason: `Protected path (${hit.why}): ${path}` };
      }
    }

    return undefined;
  });
}
