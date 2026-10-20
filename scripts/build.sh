#!/usr/bin/env bash
# Builds the card: clones flixlix-cards at the pinned upstream commit,
# applies patches/*.patch, runs the card's tests and writes
# dist/power-flow-card-plus-multibattery.js.
#   scripts/build.sh            build into ./dist
#   SKIP_TESTS=1 scripts/build.sh
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
read -r repo commit < <(python3 -c "import json;u=json.load(open('$root/package.json'))['upstream'];print(u['repository'],u['commit'])")
work="${WORK_DIR:-$root/.build}"
rm -rf "$work" && git clone --quiet "$repo" "$work/flixlix-cards"
cd "$work/flixlix-cards"
git checkout --quiet "$commit"
git -c user.name=build -c user.email=build@localhost am --quiet "$root"/patches/*.patch
pnpm install --frozen-lockfile
cd packages/flixlix-cards/power-flow-card-plus
if [ -z "${SKIP_TESTS:-}" ]; then
  pnpm exec tsc --noEmit
  pnpm exec vitest run
fi
pnpm exec rollup -c
mkdir -p "$root/dist"
cp dist/power-flow-card-plus.js "$root/dist/power-flow-card-plus-multibattery.js"
echo "built $root/dist/power-flow-card-plus-multibattery.js"
