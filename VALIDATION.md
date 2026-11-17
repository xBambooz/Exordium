# Validation

- Date: 2026-11-17. Branch: port-26.3. Upstream source: tr7zw/Exordium.
- Build: Java 25, Gradle 9.7.1, Loom 1.18.2, Fabric Loader 0.20.0.
- Production jar: build/libs/exordium-2.1.1+26.3.jar.
- Installed enabled in C:/Users/Ryan/AppData/Roaming/ModrinthApp/profiles/Fabric 26.3/mods.
- Built and installed SHA-256: 7493BD12E78F48960C26C168C8A663A9926000EFF5F6D1EC816AF40BA9F638F6.
- Full copied mod set launched and entered a disposable benchmark world.
- Sodium 0.9.3-beta.4, Iris 1.12.0 snapshot and ImmediatelyFast 1.17.1 were present.
- Inspected hotbar, crosshair, chat and BetterF3 rendering with Exordium enabled.
- The F3 fixture was used only for the final smoke test, never in benchmark runs.
- Harness sessions: 26373 on, PID 16688; 26374 off; 26375 final F3 smoke, PID 44144.
- Harness placement: secondary XF250Q at 2560,0, 1920x1080; no activation or real input.
- Master sound was zero in the copied options. Ryan's saves were not used.

| Arm | Run | Average FPS | 1% low FPS |
| --- | ---: | ---: | ---: |
| Off | 1 | 663.815 | 67.820 |
| Off | 2 | 659.240 | 65.719 |
| Off | 3 | 677.934 | 101.946 |
| On | 1 | 683.426 | 86.376 |
| On | 2 | 672.781 | 92.892 |
| On | 3 | 624.186 | 63.429 |
| Off median | | 663.815 | 67.820 |
| On median | | 672.781 | 86.376 |

No measurable change. Average median difference is +1.35%, smaller than the on-arm
run spread. The 1% low distributions overlap widely, so the median difference is
not an established tail-performance improvement. This is one sequential on/off
comparison, not an interleaved campaign.

Both arms used the frozen benchmark-route scene, full copied profile, Vulkan,
1920x1080, no shader pack drawing, actual RD 32, 8-second warmup and three measured
passes. Recorded metadata reports conditioningRun=true despite the input request
for false. All measured passes report focusLost=false and settleTimeout=false.

Ignored evidence is under C:/Users/Ryan/source/repos/Exordium/build/validation/:

- hud-on.png: hotbar and crosshair.
- hud-debug-on.png: BetterF3 and hotbar.
- smoke-status.json: PID, placement and renderer state.
- on-launch.log and off-launch.log: full instance logs.
- benchmark-data/results/2026-11/: raw Benchmark Mod compressed JSON.
- summary.jsonl: extracted per-run values and medians.
- final-build.log and cleanup.log: final build and process cleanup.

Limits: screens remain uncached; GUI extraction and preparation still run every
frame. Upstream's config UI and Xaero hooks are not ported. Shader-pack rendering,
OpenGL, resolution changes and long play sessions were not live-tested. Runtime
validation used a disposable copy with the real mod set rather than Ryan's live
worlds. The real instance was not launched directly.

Lesson candidates, kept here because this task forbids ai-brain edits:

- Don't assume Gradle files exist in upstream. Enumerate first: this checkout
  generates them through gradle-compose.
- Don't reuse 26.1 render signatures. Verify the 26.3 sources: RenderPearl formats,
  clear colors, Gui.screen() and GameRenderer.mainRenderTarget() changed.
- Don't assume the old loader suits the current profile. Puzzles Lib 26.3.18
  rejected Loader 0.19.5; Loader 0.20.0 passed.
- Don't swap jars immediately after a quit reply. Confirm the exact PID exits;
  the first off preparation hit a still-locked jar during shutdown.
- Don't pass directories to check-slop. Enumerate files explicitly.
- Don't assume a fresh clone has Git identity configured. Reuse Ryan's verified
  author identity locally before committing; the initial commit attempt failed.
