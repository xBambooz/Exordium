import fs from 'node:fs';
import path from 'node:path';
import zlib from 'node:zlib';

const root = new URL('../build/validation/benchmark-data/results/', import.meta.url);
const index = JSON.parse(fs.readFileSync(new URL('index.json', root), 'utf8'));
for (const entry of index) {
    const file = path.join(root.pathname.replace(/^\/(.:)/, '$1'), entry.path);
    const result = JSON.parse(zlib.gunzipSync(fs.readFileSync(file)));
    const runs = result.runs.map(run => ({run: run.index, avgFps: run.summary.avgFps,
        low1Fps: run.summary.low1Fps, focusLost: run.focusLost, settleTimeout: run.settleTimeout}));
    const median = key => runs.map(run => run[key]).sort((a, b) => a - b)[Math.floor(runs.length / 2)];
    console.log(JSON.stringify({label: entry.label, settings: result.settings, runs,
        median: {avgFps: median('avgFps'), low1Fps: median('low1Fps')}}));
}
