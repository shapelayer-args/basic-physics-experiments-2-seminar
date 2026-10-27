#!/usr/bin/env bash
# video/ 폴더의 *.webm을 같은 위치에 *.mp4(H.264 + AAC)로 변환한다.
# PowerPoint·Keynote·브라우저 등 대부분의 재생기가 그대로 열 수 있는 형식이다.
#
# 사용법
#   scripts/webm-to-mp4.sh                 # 저장소의 모든 **/video/*.webm
#   scripts/webm-to-mp4.sh 1st/assets/video  # 특정 폴더만
#   scripts/webm-to-mp4.sh a.webm b.webm   # 특정 파일만
#
# 옵션 (환경 변수)
#   FORCE=1   이미 최신 mp4가 있어도 다시 변환
#   CRF=18    화질 (낮을수록 고화질·큰 용량, 기본 18 ≈ 시각적 무손실)
#   PRESET=slow  인코딩 속도/압축률 (ultrafast … veryslow)
set -euo pipefail

command -v ffmpeg >/dev/null || { echo "ffmpeg가 필요합니다: brew install ffmpeg" >&2; exit 1; }

root="$(cd "$(dirname "$0")/.." && pwd)"
crf="${CRF:-18}"
preset="${PRESET:-slow}"
force="${FORCE:-0}"

# 변환 대상 수집
files=()
if [ $# -eq 0 ]; then
  while IFS= read -r -d '' f; do files+=("$f"); done < <(
    find "$root" \( -path "$root/.git" -o -path "$root/fonts" -o -path "*/node_modules" \) -prune \
      -o -type f -path "*/video/*" -iname "*.webm" -print0 | sort -z
  )
else
  for arg in "$@"; do
    if [ -d "$arg" ]; then
      while IFS= read -r -d '' f; do files+=("$f"); done < <(
        find "$arg" -maxdepth 1 -type f -iname "*.webm" -print0 | sort -z
      )
    elif [ -f "$arg" ]; then
      files+=("$arg")
    else
      echo "건너뜀 (없음): $arg" >&2
    fi
  done
fi

if [ ${#files[@]} -eq 0 ]; then
  echo "변환할 .webm 파일이 없습니다."
  exit 0
fi

converted=0 skipped=0 failed=0
for src in "${files[@]}"; do
  dst="${src%.*}.mp4"
  rel="${src#"$root"/}"

  if [ "$force" != 1 ] && [ -f "$dst" ] && [ "$dst" -nt "$src" ]; then
    echo "· 최신 상태: $rel"
    skipped=$((skipped + 1))
    continue
  fi

  echo "→ 변환 중: $rel"
  # -map 0:a? : 오디오가 있을 때만 포함
  # scale       : H.264(yuv420p)는 가로·세로가 짝수여야 하므로 홀수면 1px 내림
  # +faststart  : moov 정보를 앞에 둬서 다운로드 중에도 바로 재생
  if ffmpeg -hide_banner -loglevel error -stats -y \
      -i "$src" \
      -map 0:v:0 -map 0:a? \
      -c:v libx264 -preset "$preset" -crf "$crf" -pix_fmt yuv420p \
      -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" \
      -c:a aac -b:a 192k \
      -movflags +faststart \
      "$dst.tmp.mp4"; then
    mv "$dst.tmp.mp4" "$dst"
    echo "  완료: ${dst#"$root"/} ($(du -h "$dst" | cut -f1))"
    converted=$((converted + 1))
  else
    rm -f "$dst.tmp.mp4"
    echo "  실패: $rel" >&2
    failed=$((failed + 1))
  fi
done

echo "변환 $converted · 건너뜀 $skipped · 실패 $failed"
[ "$failed" -eq 0 ]
