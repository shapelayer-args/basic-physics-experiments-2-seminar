#!/usr/bin/env bash
# video/ 폴더의 *.mp4마다 원본 해상도 무손실 PNG 썸네일(<이름>.thumb.png)을 만든다.
# pptx-media 패키지의 media(thumbnail: path(...))에 쓰인다.
#
# 사용법
#   scripts/video-thumbnails.sh                   # 저장소의 모든 **/video/*.mp4
#   scripts/video-thumbnails.sh 1st/assets/video  # 특정 폴더만
#   scripts/video-thumbnails.sh a.mp4 b.mp4       # 특정 파일만
#
# 옵션 (환경 변수)
#   AT=0      썸네일로 쓸 시각(초). 기본은 첫 프레임
#   FORCE=1   이미 최신 썸네일이 있어도 다시 생성
set -euo pipefail

command -v ffmpeg >/dev/null || { echo "ffmpeg가 필요합니다: brew install ffmpeg" >&2; exit 1; }

root="$(cd "$(dirname "$0")/.." && pwd)"
at="${AT:-0}"
force="${FORCE:-0}"

files=()
if [ $# -eq 0 ]; then
  while IFS= read -r -d '' f; do files+=("$f"); done < <(
    find "$root" \( -path "$root/.git" -o -path "$root/fonts" -o -path "*/node_modules" \) -prune \
      -o -type f -path "*/video/*" -iname "*.mp4" -print0 | sort -z
  )
else
  for arg in "$@"; do
    if [ -d "$arg" ]; then
      while IFS= read -r -d '' f; do files+=("$f"); done < <(
        find "$arg" -maxdepth 1 -type f -iname "*.mp4" -print0 | sort -z
      )
    elif [ -f "$arg" ]; then
      files+=("$arg")
    else
      echo "건너뜀 (없음): $arg" >&2
    fi
  done
fi

if [ ${#files[@]} -eq 0 ]; then
  echo "썸네일을 만들 .mp4 파일이 없습니다."
  exit 0
fi

made=0 skipped=0 failed=0
for src in "${files[@]}"; do
  dst="${src%.*}.thumb.png"
  rel="${src#"$root"/}"

  if [ "$force" != 1 ] && [ -f "$dst" ] && [ "$dst" -nt "$src" ]; then
    echo "· 최신 상태: $rel"
    skipped=$((skipped + 1))
    continue
  fi

  # 크기 조정 없이(원본 해상도) 한 프레임을 무손실 PNG로 저장한다.
  # 회전 메타데이터는 ffmpeg가 자동으로 반영한다.
  if ffmpeg -hide_banner -loglevel error -y \
      -ss "$at" -i "$src" \
      -frames:v 1 -update 1 \
      -pix_fmt rgb24 -compression_level 9 \
      "$dst.tmp.png"; then
    mv "$dst.tmp.png" "$dst"
    echo "✓ ${dst#"$root"/}"
    made=$((made + 1))
  else
    rm -f "$dst.tmp.png"
    echo "✗ 실패: $rel" >&2
    failed=$((failed + 1))
  fi
done

echo "생성 $made · 건너뜀 $skipped · 실패 $failed"
[ "$failed" -eq 0 ]
