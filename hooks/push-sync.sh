#!/usr/bin/env bash
# Quy tắc 2 & 3: commit + push ~/.claude nếu có thay đổi.
# $1 = số giây debounce (0 = luôn push). Stop dùng 1800 (~30p), SessionEnd dùng 0.
REPO="$HOME/.claude"
cd "$REPO" 2>/dev/null || exit 0
[ -d .git ] || exit 0

debounce="${1:-0}"
marker="$REPO/.last-push-epoch"
now=$(date +%s)

# Debounce: nếu vừa push trong khoảng debounce thì bỏ qua (dùng cho Stop).
if [ "$debounce" -gt 0 ] && [ -f "$marker" ]; then
  last=$(cat "$marker" 2>/dev/null || echo 0)
  [ $(( now - last )) -lt "$debounce" ] && exit 0
fi

git add -A 2>/dev/null
if git diff --cached --quiet 2>/dev/null; then
  exit 0   # không có gì để commit
fi

git commit -q -m "auto-sync $(date '+%F %H:%M')" 2>/dev/null || exit 0
if git push -q origin main 2>/dev/null; then
  echo "$now" > "$marker"
fi
