#!/usr/bin/env bash
# Download the two published tables from costmyextension.co.uk and refresh data/.
# - data/<name>.csv is always the latest table.
# - data/history/ keeps one dated copy per edition: the cost index by its rates date,
#   the approvals table by the last day of its 90-day window.
# The site adds a trailing "# ..." licence line to each CSV. It is removed here, so
# the files load cleanly in pandas, R, Kaggle and Hugging Face; README.md carries it instead.
set -euo pipefail

SITE="${SITE:-https://costmyextension.co.uk}"
UA="london-extension-data-sync (+https://github.com/costmyextension/london-extension-data)"
cd "$(dirname "$0")/.."
mkdir -p data/history

fetch() { # fetch <name> <expected header>
  local name="$1" header="$2" tmp
  tmp="$(mktemp)"
  curl -fsS --retry 3 --retry-delay 20 -A "$UA" "$SITE/$name.csv" -o "$tmp"
  grep -v '^#' "$tmp" | sed '/^[[:space:]]*$/d' > "$tmp.clean"
  if [ "$(head -1 "$tmp.clean")" != "$header" ]; then
    echo "Unexpected header in $name.csv:" >&2
    head -1 "$tmp.clean" >&2
    exit 1
  fi
  if [ "$(wc -l < "$tmp.clean")" -lt 10 ]; then
    echo "$name.csv has too few rows; not replacing the published file" >&2
    exit 1
  fi
  mv "$tmp.clean" "data/$name.csv"
  rm -f "$tmp"
}

fetch london-extension-cost-index \
  "borough,job_family,typical_job,low_gbp,expected_gbp,high_gbp,build_per_m2_low_gbp,build_per_m2_high_gbp,rates_date"
fetch london-planning-approvals \
  "area,decided,approved,approval_rate_pct,against_london,median_weeks,rated,window_from,window_to"

rates_date="$(awk -F, 'NR==2{print $NF}' data/london-extension-cost-index.csv)"
window_to="$(awk -F, 'NR==2{print $NF}' data/london-planning-approvals.csv)"
cp data/london-extension-cost-index.csv "data/history/london-extension-cost-index-$rates_date.csv"
cp data/london-planning-approvals.csv "data/history/london-planning-approvals-$window_to.csv"

echo "cost index rates date: $rates_date"
echo "approvals window ends: $window_to"
