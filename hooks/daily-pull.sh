#!/usr/bin/env bash
# Quy tắc 1: pull ~/.claude MỘT LẦN mỗi ngày (phiên đầu tiên sau khi khởi động máy / sang ngày mới).
# Chạy bởi hook SessionStart. Guard bằng .last-pull-date để không pull mỗi phiên.
REPO="$HOME/.claude"
cd "$REPO" 2>/dev/null || exit 0
[ -d .git ] || exit 0

today=$(date +%F)
marker="$REPO/.last-pull-date"
if [ -f "$marker" ] && [ "$(cat "$marker" 2>/dev/null)" = "$today" ]; then
  exit 0   # đã pull hôm nay rồi
fi

if git pull --rebase --autostash -q 2>/dev/null; then
  echo "$today" > "$marker"
else
  git rebase --abort 2>/dev/null || true
  echo '{"systemMessage":"⚠ Không tự pull được ~/.claude (có thể xung đột). Chạy tay: cd ~/.claude && git pull"}'
fi
