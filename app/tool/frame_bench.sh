#!/usr/bin/env bash
# Plays single player games on the play screen in profile mode and saves
# the timing of every frame to build/frame_bench/<commit>-<date>-run<n>.json,
# then prints the median of each statistic over the runs.
#
# Usage: tool/frame_bench.sh [device id] [rounds] [runs]
#        (default: 2 rounds, 3 runs)
set -euo pipefail
cd "$(dirname "$0")/.."
command -v flutter > /dev/null || export PATH="$HOME/develop/flutter/bin:$PATH"
# Without it, flutter does not find the Android SDK, nor the phone.
if [[ -z ${ANDROID_HOME:-} && -f android/local.properties ]]; then
  sdk=$(sed -n 's/^sdk\.dir=//p' android/local.properties)
  [[ -n $sdk ]] && export ANDROID_HOME=$sdk
fi

device=${1:-}
rounds=${2:-2}
runs=${3:-3}
revision=$(git rev-parse --short HEAD)
git diff --quiet HEAD -- lib || revision="$revision-dirty"
label="$revision-$(date +%Y%m%d-%H%M%S)"

results=()
for run in $(seq 1 "$runs"); do
  echo "=== Run $run of $runs"
  FRAME_BENCH_LABEL="$label-run$run" flutter drive --profile --no-dds ${device:+-d "$device"} \
    --driver=test_driver/integration_test.dart \
    --target=integration_test/play_frames_test.dart \
    --dart-define=CHIBRE_PROFILE=bench \
    --dart-define=FRAME_BENCH_ROUNDS="$rounds"
  results+=("build/frame_bench/$label-run$run.json")
done

python3 -I - "${results[@]}" << 'EOF'
import json, statistics, sys
runs = [json.load(open(path))["play_frames"] for path in sys.argv[1:]]
keys = ["frame_count",
        "average_frame_build_time_millis", "90th_percentile_frame_build_time_millis",
        "99th_percentile_frame_build_time_millis", "worst_frame_build_time_millis",
        "missed_frame_build_budget_count",
        "average_frame_rasterizer_time_millis", "90th_percentile_frame_rasterizer_time_millis",
        "99th_percentile_frame_rasterizer_time_millis", "worst_frame_rasterizer_time_millis",
        "missed_frame_rasterizer_budget_count"]
print(f"{'':48} {'median':>8}   runs")
for key in keys:
    values = [run[key] for run in runs]
    print(f"{key:48} {round(statistics.median(values), 3):>8}   {values}")
EOF
printf 'Saved: %s\n' "${results[@]/#/$PWD/}"
