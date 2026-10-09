/**
 * DeepSeek peak-hours warning.
 *
 * DeepSeek applies off-peak discounts between 16:30 and 00:30 UTC; outside
 * that window (00:30–16:30 UTC) API prices are at the full rate. When the
 * active model is a DeepSeek model, warn during peak hours and show the
 * current pricing window in the footer.
 */

import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

const OFF_PEAK_START_MIN = 16 * 60 + 30; // 16:30 UTC
const OFF_PEAK_END_MIN = 30; // 00:30 UTC

function minutesUtc(d: Date): number {
  return d.getUTCHours() * 60 + d.getUTCMinutes();
}

function isOffPeak(d: Date): boolean {
  const m = minutesUtc(d);
  return m >= OFF_PEAK_START_MIN || m < OFF_PEAK_END_MIN;
}

function fmtUtc(totalMinutes: number): string {
  const h = String(Math.floor(totalMinutes / 60) % 24).padStart(2, "0");
  const m = String(totalMinutes % 60).padStart(2, "0");
  return `${h}:${m} UTC`;
}

/** Next price-window boundary in UTC. */
function nextBoundary(now: Date): Date {
  const y = now.getUTCFullYear();
  const mo = now.getUTCMonth();
  const d = now.getUTCDate();
  const off = isOffPeak(now);
  if (off) {
    // Off-peak ends at 00:30; if we are already past 16:30 it is tomorrow.
    const dayOffset = minutesUtc(now) >= OFF_PEAK_START_MIN ? 1 : 0;
    return new Date(Date.UTC(y, mo, d + dayOffset, 0, 30));
  }
  // Peak ends at 16:30 today.
  return new Date(Date.UTC(y, mo, d, 16, 30));
}

function localTime(d: Date): string {
  const tz = Intl.DateTimeFormat().resolvedOptions().timeZone;
  return `${d.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" })} ${tz}`;
}

function update(ctx: ExtensionContext, provider: string | undefined, notify: boolean): void {
  if (provider !== "deepseek") {
    ctx.ui.setStatus("deepseek-hours", undefined);
    return;
  }

  const now = new Date();
  const boundary = nextBoundary(now);
  const local = localTime(boundary);

  if (isOffPeak(now)) {
    ctx.ui.setStatus("deepseek-hours", ctx.ui.theme.fg("success", "deepseek off-peak"));
    if (notify) {
      ctx.ui.notify(
        `DeepSeek off-peak discount active until ${fmtUtc(OFF_PEAK_END_MIN)} (${local}).`,
        "info",
      );
    }
  } else {
    ctx.ui.setStatus("deepseek-hours", ctx.ui.theme.fg("warning", "deepseek peak"));
    if (notify) {
      ctx.ui.notify(
        `DeepSeek peak hours: full API prices until ${fmtUtc(OFF_PEAK_START_MIN)} (${local}). ` +
          "Off-peak discounts then apply.",
        "warning",
      );
    }
  }
}

export default function (pi: ExtensionAPI) {
  pi.on("session_start", async (_event, ctx) => {
    update(ctx, ctx.model?.provider, true);
  });

  pi.on("model_select", async (event, ctx) => {
    update(ctx, event.model.provider, event.source !== "restore" && event.model.provider === "deepseek");
  });

  // Register a manual refresh command: /deepseek-hours
  pi.registerCommand("deepseek-hours", {
    description: "Show the current DeepSeek peak/off-peak pricing window",
    handler: async (_args, ctx) => {
      update(ctx, ctx.model?.provider, true);
    },
  });
}
