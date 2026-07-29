#!/usr/bin/env bash
# CANONICAL PER-SITE build.sh (pipeline v2). Only the variables below are site-specific.
set -euo pipefail
ROOT=/Users/jackgreenberg/Desktop/rank-and-rent
S=$ROOT/David/clones/scripts

PROJ=$ROOT/mineral-rights/sellmineralrightsnorthdakota.com
REFHOST=enercon-de
VOICE=$PROJ/site-voice.json
PAGES="home=https://www.enercon.de/en,about=https://www.enercon.de/en/company/about-enercon,contact=https://www.enercon.de/en/contact/contact-selection,index=https://www.enercon.de/en/wind-turbines/product-portfolio,slug=https://www.enercon.de/en/turbines/e-175-ep5"

CFG=$PROJ/home.config.json
MAP=$PROJ/relabel-map.json
CAP=$ROOT/David/clones/_captures/$REFHOST

[ -f "$CFG" ] || { echo "MISSING $CFG"; exit 1; }
[ -f "$MAP" ] || { echo "MISSING $MAP — author the relabel map per \$faithful-home"; exit 1; }

if [ ! -f "$CAP/public/home.html.ref" ]; then
  node "$S/faithful-home.mjs" --src "https://www.mortenson.com/" --pages "$PAGES" --dir "$CAP"
fi
mkdir -p "$PROJ/public"
cp "$CAP"/public/*.html.ref "$PROJ/public/" 2>/dev/null || true
[ -d "$PROJ/public/assets-f" ] || cp -R "$CAP/public/assets-f" "$PROJ/public/"
mkdir -p "$PROJ/qa-out"
cp "$CAP"/qa-out/ref-*.png "$PROJ/qa-out/" 2>/dev/null || true

python3 "$S/normalize_content.py" "$PROJ" --voice "$VOICE"

python3 - "$PROJ" <<'PY'
import shutil, sys, os
p = sys.argv[1]
src, dst = os.path.join(p, 'images'), os.path.join(p, 'public/ours')
if os.path.isdir(src):
    shutil.copytree(src, dst, dirs_exist_ok=True)
PY

python3 "$S/relabel_engine.py" --config "$CFG" --map "$MAP" --voice "$VOICE"

# Donor raster files are not referenced after relabeling. Keep the original
# layout assets, scripts, and fonts while preventing stray donor thumbnails
# from entering the repository or deployment.
find "$PROJ/public/assets-f/img" "$PROJ/public/assets-f/misc" -type f -delete 2>/dev/null || true

find "$PROJ/public" -type f \( -name '*.html' -o -name '*.html.ref' -o -name '*.css' \) -print0 \
  | xargs -0 perl -pi -e 's/\t/  /g; s/[ \t]+\r?\n/\n/g; s/\r\n/\n/g'
find "$PROJ/public/assets-f/js" -type f -name '*.js' -print0 \
  | xargs -0 perl -pi -e 's/[ \t]+\r?\n/\n/g; s/\r\n/\n/g'

python3 "$S/verify_site.py" "$PROJ" --map "$MAP" --json "$PROJ/qa-out/verify.json"
node "$S/qa_shots.mjs" "$PROJ"

echo "BUILD COMPLETE — gates green. Human QA: open $PROJ/qa-out/CONTACT-SHEET.html"
