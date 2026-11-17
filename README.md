<img src="https://raw.githubusercontent.com/tr7zw/Exordium/1.19/Shared/src/main/resources/assets/exordium/icon.png" align="right" width=200>

# Exordium

## Unofficial Fabric 26.3 port

This is an unofficial Minecraft 26.3 Fabric port by xBambooz of
[Exordium by tr7zw](https://github.com/tr7zw/Exordium). The HUD redraw rate is
fixed at 30 FPS. There is no config UI and no Xaero hooks. Open screens remain
uncached. The compatibility notes below describe upstream, not verified 26.3 support.
See [port details](PORT-26.3.md) and [validation](VALIDATION.md).

Build with Java 25: `./gradlew build --no-daemon`. Downloads are available in
[Releases](https://github.com/xBambooz/Exordium/releases).

__Render the HUD and screens at a lower framerate to speed up what's really important: the worldrendering.__

Renders the HUD at a lower fixed framerate (configurable in the settings), freeing up CPU and GPU time for the world rendering. There is no good reason to render the hotbar at 100+ FPS.

## Compatibility

__This is still work in progress software! There will be issues, please report them!__

### Affected vanilla features

- Overlays except Vignette (Pumpkin, freezing, spyglass, portal...)
- Hotbar (all parts of it)
- Crosshair
- Bossbars
- Debug Screen (F3 Menu)
- Titles
- Scoreboard
- Chat

### Tested and working with

- Sodium
- Iris
- Optifine
- AppleSkin
- Better Ping Display
- Chat Heads
- Detail Armor Bar
- WTHIT (What the hell is that?)
- JourneyMap
- ToroHealth Damage Indicator
- BetterF3

### Not compatible

- VulkanMod

### Screen setting notice

This feature is still not done (disabled by default) and has mainly transparency issues. It heavily speeds up mods like REI (Roughly Enough Items), but with visual issues.

### Downloads

- [Curseforge](https://www.curseforge.com/minecraft/mc-mods/exordium)
- [Modrinth](https://modrinth.com/mod/exordium)

## License

This project is licensed under the [GNU Lesser General Public License v3](LICENSE).
Upstream copyright and license notices are retained.
