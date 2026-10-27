#!/usr/bin/env bash
# fonts/ 에 테마가 쓰는 글꼴의 모든 굵기를 모은다.
#   Pretendard 9종 · Noto Serif KR 8종 · JetBrains Mono 8종
# 로컬(~/Library/Fonts)에 있으면 복사하고, 없으면 공식 배포본을 내려받는다.
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
dest="$root/fonts"
mkdir -p "$dest"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

local_dirs=("$HOME/Library/Fonts" "/Library/Fonts" "$HOME/.local/share/fonts" "/usr/share/fonts")

copy_local() { # $1: glob
  for d in "${local_dirs[@]}"; do
    # shellcheck disable=SC2086
    if compgen -G "$d/$1" >/dev/null; then
      cp $d/$1 "$dest/"
      return 0
    fi
  done
  return 1
}

# Pretendard (Thin … Black)
copy_local "Pretendard-*.otf" || {
  curl -fsSL -o "$tmp/p.zip" \
    https://github.com/orioncactus/pretendard/releases/download/v1.3.9/Pretendard-1.3.9.zip
  unzip -q -j "$tmp/p.zip" "public/static/Pretendard-*.otf" -d "$dest"
}

# Noto Serif KR (ExtraLight … Black)
copy_local "NotoSerifKR-*.ttf" || {
  for w in ExtraLight Light Regular Medium SemiBold Bold ExtraBold Black; do
    curl -fsSL -o "$dest/NotoSerifKR-$w.otf" \
      "https://github.com/notofonts/noto-cjk/raw/main/Serif/SubsetOTF/KR/NotoSerifKR-$w.otf"
  done
}

# JetBrains Mono (Thin … ExtraBold, 정체만)
copy_local "JetBrainsMono-[A-Z]*[!c].ttf" || {
  curl -fsSL -o "$tmp/j.zip" \
    https://github.com/JetBrains/JetBrainsMono/releases/download/v2.304/JetBrainsMono-2.304.zip
  unzip -q -j "$tmp/j.zip" "fonts/ttf/JetBrainsMono-*.ttf" -x "*Italic*" -d "$dest"
}

echo "fonts/ 준비 완료:"
ls "$dest"
