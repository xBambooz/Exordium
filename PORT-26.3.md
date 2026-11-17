# Fabric 26.3 port

Build with Java 25 and `./gradlew build --no-daemon`. The production artifact is
`build/libs/exordium-2.1.1+26.3.jar`. Fabric Loader 0.20.0 or newer is required to
match Puzzles Lib in the target instance. Gradle 9.7.1 and Loom 1.18.2 follow the
working local Benchmark Mod toolchain.

The port uses upstream Exordium's framebuffer caching strategy, verified against
the local Mojang-named 26.3 GuiRenderer and RenderTarget sources. Sources under
`src/port` replace the multiversion build for this target. Original sources are
preserved for reference. No TRansition or TRender library is required.

The HUD draw pass updates at 30 FPS, then blends its cached transparent target
into the world each frame. Open screens render normally. Resizing or changing GUI
scale invalidates the target. Closing the renderer frees the cached textures.
GUI extraction and mesh preparation still run each frame. The older configuration
screen, per-component settings and Xaero custom hooks are not ported.

`tools/prepare-validation.ps1` copies mods and visual settings into ignored
`build/validation/run`, mutes master volume, and does not copy Ryan's saves.
`tools/benchmark.ps1 -Mode on|off -Port <port>` prepares a private Benchmark Mod
data folder, launches through the secondary-monitor harness, then starts the frozen
benchmark-route scene. `tools/read-results.mjs` prints measured passes and medians.
Inspect recorded settings: Benchmark Mod may require a conditioning pass even when
the input settings request none. Shut down and confirm the exact game PID has exited
before swapping a jar or rebuilding.

`./gradlew validationJar --no-daemon` builds an optional F3 fixture at
`build/validation/exordium-validation.jar`. Install it only in the disposable run.
It shows the debug overlay when a world loads. It is excluded from the production
artifact and all performance measurements.
