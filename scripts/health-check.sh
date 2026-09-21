#!/usr/bin/env bash
#
# health-check.sh — probe sites and emit JSON.
#
# Usage:
#   bash scripts/health-check.sh --out /tmp/health.json https://hersky.info https://beatmasterdj.ca
#
# Output JSON:
#   {"updated": "<utc iso8601>", "sites": [{"url","http_status","response_time_ms","ssl_days_left","ok"}]}
#
# No secrets, no side effects — safe to run anywhere.

set -u

OUT=""
URLS=()
while [ $# -gt 0 ]; do
  case "$1" in
    --out) OUT="${2:-}"; shift 2 ;;
    *) URLS+=("$1"); shift ;;
  esac
done

if [ -z "$OUT" ] || [ "${#URLS[@]}" -eq 0 ]; then
  echo "usage: $0 --out FILE url [url ...]" >&2
  exit 1
fi

TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT

for url in "${URLS[@]}"; do
  host="$(printf '%s' "$url" | sed -E 's#https?://([^/:]+).*#\1#')"
  read -r code time_total < <(curl -o /dev/null -s -w "%{http_code} %{time_total}" --max-time 25 "$url" 2>/dev/null || echo "000 0")
  ms="$(awk "BEGIN {printf \"%d\", ${time_total:-0} * 1000}")"
  days=""
  if [[ "$url" == https://* ]]; then
    enddate="$(echo | openssl s_client -servername "$host" -connect "$host:443" 2>/dev/null \
      | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2)"
    if [ -n "$enddate" ]; then
      days="$(( ($(date -d "$enddate" +%s) - $(date +%s)) / 86400 ))"
    fi
  fi
  ok="false"
  [ "$code" = "200" ] && ok="true"
  printf '%s\t%s\t%s\t%s\t%s\n' "$url" "$code" "$ms" "$days" "$ok" >> "$TMP"
done

python3 - "$TMP" "$OUT" <<'EOF'
import json, sys, datetime
tmp, out = sys.argv[1], sys.argv[2]
sites = []
for line in open(tmp):
    parts = line.rstrip("\n").split("\t")
    if len(parts) != 5:
        continue
    url, code, ms, days, ok = parts
    try:
        ssl_days = int(days)
    except ValueError:
        ssl_days = None
    sites.append({
        "url": url,
        "http_status": int(code) if code.isdigit() else 0,
        "response_time_ms": int(ms) if ms.lstrip("-").isdigit() else 0,
        "ssl_days_left": ssl_days,
        "ok": ok == "true",
    })
payload = {
    "updated": datetime.datetime.now(datetime.timezone.utc).isoformat(),
    "sites": sites,
}
with open(out, "w") as f:
    f.write(json.dumps(payload, indent=2) + "\n")
print(json.dumps(payload, indent=2))
EOF
