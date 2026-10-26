// ─────────────────────────────────────────────────────────────
//  기초물리실험 2 세미나 슬라이드 테마
//  원본: 프레젠테이션1.pdf (960 × 540 pt, 16:9)
//  배경 #FAF9F5 · 제목 Pretendard · 본문 Noto Serif KR
// ─────────────────────────────────────────────────────────────

// ── 디자인 토큰 ────────────────────────────────────────────────
#let colors = (
  bg: rgb("#FAF9F5"),
  text: rgb("#000000"),
  sub: rgb("#3A3A3A"), // 날짜 등 보조 정보
  muted: rgb("#747474"), // 인용·부연 설명, 인용 막대
  surface: rgb("#F0EEE6"), // 콜아웃 배경 (배경보다 한 단계 어둡게)
  rule: rgb("#3A3A3A"), // 표 괘선
)

#let fonts = (
  heading: ("Pretendard", "Pretendard JP"),
  body: ("Noto Serif KR",),
)

#let margin-x = 73pt

// ── 기본 요소 ──────────────────────────────────────────────────

/// 제목 글꼴(Pretendard)로 짧은 텍스트를 조판한다.
#let sans(body, size: 28pt, weight: "medium", fill: colors.text) = text(
  font: fonts.heading,
  size: size,
  weight: weight,
  fill: fill,
  body,
)

/// 회색 막대가 붙은 부연 설명/인용 블록.
/// 원본: 3pt 막대(x=95) + 18pt 회색 본문(x=123), 줄 간격 28pt.
#let quote(body, indent: 22pt) = pad(left: indent, block(
  stroke: (left: 3pt + colors.muted),
  inset: (left: 28pt, y: 3pt),
  {
    set text(size: 18pt, fill: colors.muted, weight: "regular")
    set par(leading: 0.83em, justify: true)
    body
  },
))

/// 낫표(「」)로 감싼 핵심 문장. 원본의 '목표 설정' 슬라이드 강조 표현.
#let statement(body, size: 28pt) = block(
  {
    sans(size: size)[「]
    text(size: size, weight: "semibold", body)
    sans(size: size)[」]
  },
)

/// 소제목(예: "사례#1, …")과 글머리 목록으로 이루어진 단.
#let case(title, body) = block({
  text(size: 20pt, title)
  v(50pt)
  body
})

/// 다단 배치. 원본 '문제 상황' 슬라이드는 x=73, x=493 두 단(첫 단 너비 420pt).
#let cols(..items, columns: (400pt, 1fr), gutter: 20pt) = grid(
  columns: columns,
  column-gutter: gutter,
  ..items.pos(),
)

/// 콜아웃(검정·참고 등). 배경보다 한 단계 어두운 면 위에 라벨 + 본문.
#let callout(label: none, body) = block(
  width: 100%,
  fill: colors.surface,
  radius: 4pt,
  inset: (x: 20pt, y: 14pt),
  {
    set text(size: 18pt)
    if label != none {
      sans(size: 18pt, weight: "semibold", label)
      h(0.7em)
    }
    body
  },
)

/// 상·하단 굵은 괘선과 머리글 아래 가는 괘선만 쓰는 표.
/// - header: 머리글 셀 배열
/// - rows: 본문 셀 (행 순서대로 나열)
#let data-table(columns: auto, header: (), size: 17pt, ..rows) = {
  set text(size: size)
  table(
    columns: columns,
    stroke: none,
    inset: (x: 14pt, y: 9pt),
    align: center + horizon,
    table.hline(stroke: 1.2pt + colors.rule),
    table.header(..header.map(h => sans(size: size - 1pt, weight: "semibold", h))),
    table.hline(stroke: 0.6pt + colors.rule),
    ..rows.pos(),
    table.hline(stroke: 1.2pt + colors.rule),
  )
}

/// 가운데 정렬된 큰 수식 블록.
#let eq(body, size: 24pt) = align(center, text(size: size, body))

// ── 슬라이드 종류 ───────────────────────────────────────────────

/// 현재 섹션명. section-slide가 갱신하고, slide 상단 머리말(kicker)에 쓰인다.
#let current-section = state("current-section", none)

/// 일반 내용 슬라이드: 좌상단 44pt 제목 + 본문.
/// - sub: 섹션 안의 소주제. 제목 위 머리말에 "섹션명 · 소주제"로 표시된다.
#let slide(title: none, sub: none, body) = {
  pagebreak(weak: true)
  place(top + left, dy: -36pt, context {
    let parts = (current-section.get(), sub).filter(x => x != none)
    if parts.len() > 0 {
      sans(size: 15pt, weight: "medium", fill: colors.muted, parts.join[#h(0.4em)·#h(0.4em)])
    }
  })
  if title != none {
    block(below: 48pt, sans(size: 44pt, weight: "semibold", title))
  }
  body
}

/// 섹션 구분 슬라이드: "섹션 #n" 라벨 + 60pt 섹션명 + 선택적 부연 설명.
#let section-counter = counter("section-slide")
#let section-slide(title, body) = {
  pagebreak(weak: true)
  section-counter.step()
  current-section.update(title)
  set page(margin: (left: margin-x, right: margin-x, top: 232pt, bottom: 40pt))
  sans(size: 36pt, weight: "semibold")[섹션 \##context section-counter.display()]
  v(21pt, weak: false)
  block(below: 68pt, sans(size: 60pt, weight: "semibold", title))
  body
}

/// 빈 슬라이드(그림·도식 자리).
#let blank-slide(body) = {
  pagebreak(weak: true)
  box() // 빈 페이지가 약한 페이지 나눔에 흡수되지 않도록
  body
}

/// 표지 슬라이드. 원본 좌표를 그대로 따르도록 절대 위치로 배치한다.
/// - experiment: "실험 #4" 같은 앞머리
/// - title: 실험명
/// - subtitles: 부제 배열 (줄 간격 43pt)
/// - authors: ((name, affiliation), …) (줄 간격 32pt)
/// - date: 표기 문자열
#let title-slide(
  experiment: none,
  title: none,
  subtitles: (),
  authors: (),
  date: none,
) = {
  pagebreak(weak: true)
  set page(margin: 0pt)
  let at(x, y, body) = place(top + left, dx: x, dy: y, body)

  at(62pt, 83pt, sans(size: 44pt, weight: "bold", {
    if experiment != none [#experiment — ]
    title
  }))
  for (i, s) in subtitles.enumerate() {
    at(64pt, 188pt + i * 43pt, sans(size: 28pt, weight: "medium", s))
  }
  let y0 = 334pt
  for (i, (name, aff)) in authors.enumerate() {
    at(64pt, y0 + i * 32pt, sans(size: 20pt, weight: "regular", name))
    at(125pt, y0 + 3pt + i * 32pt, sans(size: 16pt, weight: "regular", aff))
  }
  if date != none {
    at(64pt, y0 + authors.len() * 32pt + 35pt,
      sans(size: 18pt, weight: "regular", fill: colors.sub, date))
  }
}

// ── 문서 전체 설정 ──────────────────────────────────────────────
#let seminar-theme(body) = {
  set page(
    width: 960pt,
    height: 540pt,
    fill: colors.bg,
    margin: (left: margin-x, right: margin-x, top: 63pt, bottom: 40pt),
  )
  set text(font: fonts.body, size: 20pt, fill: colors.text, lang: "ko", region: "kr")
  set par(leading: 0.83em, spacing: 20pt)
  set list(
    marker: (
      text(font: "Arial", baseline: -0.115em)[»],
      text(font: "Arial", baseline: -0.115em, fill: colors.muted)[›],
    ),
    indent: 0pt,
    body-indent: 11pt,
    spacing: 14pt,
  )
  show heading: set text(font: fonts.heading, weight: "semibold")
  show link: it => underline(offset: 4pt, stroke: 1pt + colors.muted, it)

  body
}
