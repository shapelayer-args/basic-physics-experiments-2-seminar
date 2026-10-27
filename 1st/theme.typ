// ─────────────────────────────────────────────────────────────
//  기초물리실험 2 세미나 슬라이드 테마
//
//  원본   프레젠테이션1.pdf (960 × 540 pt, 16:9)
//  영감   anthropic.com 디자인 시스템 — 따뜻한 아이보리/슬레이트 계열,
//         Clay 오렌지 단일 강조색, 1px 헤어라인, 작은 라운드, 넉넉한 여백
//
//  원칙
//  1. 무채색이 기본이다. 강조색(clay)은 한 슬라이드에 한 곳만 쓴다.
//  2. 구분은 선이 아니라 면(surface)으로 한다. 선이 필요하면 헤어라인.
//  3. 제목은 Pretendard(산세리프), 읽는 글은 Noto Serif KR(세리프).
//  4. 간격·크기는 아래 토큰에서만 고른다.
// ─────────────────────────────────────────────────────────────

// ═════════════════════════════════════════════════════════════
//  1. 팔레트 (원시 색상값, anthropic.com CSS 변수에서 발췌)
// ═════════════════════════════════════════════════════════════
#let palette = (
  // 슬레이트 — 따뜻한 회색 단계
  slate-950: rgb("#141413"), // 본문 글자, 다크 배경
  slate-900: rgb("#1a1918"),
  slate-800: rgb("#262624"),
  slate-700: rgb("#3d3d3a"),
  slate-600: rgb("#5e5d59"),
  slate-550: rgb("#73726c"),
  slate-500: rgb("#87867f"),
  slate-400: rgb("#b0aea5"),
  slate-300: rgb("#d1cfc5"),
  slate-250: rgb("#dedcd1"),
  // 아이보리 — 배경 단계
  ivory-light: rgb("#faf9f5"), // 페이지 배경
  ivory-medium: rgb("#f0eee6"), // 면(surface)
  ivory-dark: rgb("#e8e6dc"), // 눌린 면, 표 줄무늬
  oat: rgb("#e3dacc"),
  // 강조
  clay: rgb("#d97757"), // 시그니처 오렌지
  clay-deep: rgb("#c6613f"), // 글자에 쓰는 clay (대비 확보)
  // 보조 (도표·데이터 계열색, 의미 구분용)
  olive: rgb("#788c5d"),
  sky: rgb("#6a9bcc"),
  fig: rgb("#c46686"),
  cactus: rgb("#bcd1ca"),
  heather: rgb("#cbcadb"),
  coral: rgb("#ebcece"),
  error: rgb("#bf4d43"),
)

// ═════════════════════════════════════════════════════════════
//  2. 의미 색상 (컴포넌트는 이 이름만 참조한다)
// ═════════════════════════════════════════════════════════════
#let colors = (
  bg: palette.ivory-light,
  surface: palette.ivory-medium, // 콜아웃·카드 면
  surface-strong: palette.ivory-dark,
  text: palette.slate-950,
  sub: palette.slate-700, // 날짜·보조 정보
  muted: palette.slate-550, // 부연 설명, 인용 막대, 머리말
  faint: palette.slate-400, // 쪽 번호, 비활성
  border: palette.slate-300, // 헤어라인
  rule: palette.slate-950, // 표의 굵은 괘선
  accent: palette.clay,
  accent-text: palette.clay-deep,
  inverse-bg: palette.slate-950,
  inverse-text: palette.ivory-light,
  inverse-muted: palette.slate-400,
)

/// 콜아웃·배지 등에 쓰는 톤. (면, 라벨 글자색)
#let tones = (
  neutral: (fill: colors.surface, label: colors.text),
  accent: (fill: palette.clay.lighten(84%), label: colors.accent-text),
  olive: (fill: palette.olive.lighten(82%), label: palette.olive.darken(25%)),
  sky: (fill: palette.sky.lighten(82%), label: palette.sky.darken(30%)),
  fig: (fill: palette.fig.lighten(84%), label: palette.fig.darken(25%)),
)

// ═════════════════════════════════════════════════════════════
//  3. 글꼴 · 활자 크기
// ═════════════════════════════════════════════════════════════
#let fonts = (
  heading: ("Pretendard",),
  body: ("Noto Serif KR",),
  mono: ("JetBrains Mono",),
  math: ("New Computer Modern Math",),
)

/// 활자 크기 단계. 원본 PDF에서 쓰인 크기를 기준으로 이름을 붙였다.
#let sizes = (
  display: 60pt, // 섹션명
  title: 44pt, // 슬라이드 제목, 표지 제목
  eyebrow: 36pt, // "섹션 #n"
  lead: 28pt, // 표지 부제, 핵심 문장
  body: 20pt, // 본문
  small: 18pt, // 인용·콜아웃·표
  caption: 15pt, // 머리말, 캡션
  micro: 12pt, // 쪽 번호
)

/// 줄 간격 (anthropic.com: 제목 112–120%, 본문 145–150%)
#let leading = (
  tight: 0.25em, // 제목 여러 줄
  body: 0.83em, // 본문 (원본 PDF 실측, ≈ 150%)
)

/// 숫자는 라이닝·비례폭 (anthropic.com: "pnum", "lnum")
#let num-features = (lnum: 1, pnum: 1)

// ═════════════════════════════════════════════════════════════
//  4. 간격 · 라운드 · 선
// ═════════════════════════════════════════════════════════════
/// 4pt 기반 간격 단계 (anthropic.com --spacer-01 … 12)
#let space = (
  "1": 4pt,
  "2": 8pt,
  "3": 12pt,
  "4": 16pt,
  "5": 24pt,
  "6": 32pt,
  "7": 40pt,
  "8": 48pt,
  "9": 64pt,
  "10": 80pt,
)

#let radius = (xs: 4pt, sm: 8pt, md: 12pt, lg: 16pt, full: 999pt)

#let strokes = (
  hairline: 0.75pt + colors.border,
  rule: 1.2pt + colors.rule,
  rule-thin: 0.6pt + colors.rule,
  quote: 3pt + colors.muted,
)

#let margin-x = 73pt

// ═════════════════════════════════════════════════════════════
//  5. 기본 요소
// ═════════════════════════════════════════════════════════════

/// 제목 글꼴(Pretendard)로 짧은 텍스트를 조판한다.
#let sans(body, size: sizes.lead, weight: "medium", fill: auto, tracking: 0pt) = text(
  font: fonts.heading,
  size: size,
  weight: weight,
  fill: if fill == auto { colors.text } else { fill },
  tracking: tracking,
  body,
)

/// 회색 막대가 붙은 부연 설명/인용 블록.
/// 원본: 3pt 막대(x=95) + 18pt 회색 본문(x=123), 줄 간격 28pt.
#let quote(body, indent: 22pt) = pad(left: indent, block(
  stroke: (left: strokes.quote),
  inset: (left: 28pt, y: 3pt),
  {
    set text(size: sizes.small, fill: colors.muted, weight: "regular")
    set par(leading: leading.body, justify: true)
    body
  },
))

/// 낫표(「」)로 감싼 핵심 문장. 원본의 '목표 설정' 슬라이드 강조 표현.
#let statement(body, size: sizes.lead) = block({
  sans(size: size)[「]
  text(size: size, weight: "semibold", body)
  sans(size: size)[」]
})

/// 소제목(예: "사례#1, …")과 글머리 목록으로 이루어진 단.
#let case(title, body) = block({
  text(size: sizes.body, title)
  v(20pt)
  body
})

/// 다단 배치. 원본 '문제 상황' 슬라이드는 x=73, x=493 두 단(첫 단 너비 420pt).
#let cols(..items, columns: (400pt, 1fr), gutter: 20pt) = grid(
  columns: columns,
  column-gutter: gutter,
  ..items.pos(),
)

/// 콜아웃(검정·참고 등). 면 위에 라벨 + 본문.
/// - tone: "neutral" | "accent" | "olive" | "sky" | "fig"
#let callout(label: none, tone: "neutral", body) = {
  let t = tones.at(tone)
  block(
    width: 100%,
    fill: t.fill,
    radius: radius.sm,
    inset: (x: space.at("5"), y: space.at("4")),
    {
      set text(size: sizes.small)
      if label != none {
        sans(size: sizes.small, weight: "semibold", fill: t.label, label)
        h(0.7em)
      }
      body
    },
  )
}

/// 알약 모양 배지. 상태·분류 표시용 (예: 「측정값」, 「추정」).
#let badge(body, tone: "neutral") = {
  let t = tones.at(tone)
  box(
    fill: t.fill,
    radius: radius.full,
    inset: (x: 0.7em, y: 0.3em),
    baseline: 0.3em,
    sans(size: 0.75em, weight: "semibold", fill: t.label, body),
  )
}

/// 헤어라인 테두리 카드. 나란히 비교할 내용을 담는다.
/// - title: 카드 머리 (선택)
#let card(title: none, body) = block(
  width: 100%,
  stroke: strokes.hairline,
  radius: radius.md,
  inset: space.at("5"),
  {
    if title != none {
      block(below: space.at("3"), sans(size: sizes.small, weight: "semibold", title))
    }
    set text(size: sizes.small)
    body
  },
)

/// 상·하단 굵은 괘선과 머리글 아래 가는 괘선만 쓰는 표.
/// - header: 머리글 셀 배열
/// - rows: 본문 셀 (행 순서대로 나열)
/// - highlight: 강조할 본문 행 번호(0부터) 배열. 면 색으로 표시한다.
#let data-table(columns: auto, header: (), size: 17pt, highlight: (), ..rows) = {
  set text(size: size)
  table(
    columns: columns,
    stroke: none,
    inset: (x: 14pt, y: 9pt),
    align: center + horizon,
    fill: (_, y) => if (y - 1) in highlight { colors.surface },
    table.hline(stroke: strokes.rule),
    table.header(..header.map(h => sans(size: size - 1pt, weight: "semibold", h))),
    table.hline(stroke: strokes.rule-thin),
    ..rows.pos(),
    table.hline(stroke: strokes.rule),
  )
}

/// 가운데 정렬된 큰 수식 블록.
#let eq(body, size: 24pt) = align(center, text(size: size, body))

// ═════════════════════════════════════════════════════════════
//  6. 슬라이드 종류
// ═════════════════════════════════════════════════════════════

/// 현재 섹션명. section-slide가 갱신하고, slide 상단 머리말(kicker)에 쓰인다.
#let current-section = state("current-section", none)
/// 섹션 번호. section-slide가 증가시키고, 머리말에 "#n"으로 표시된다.
#let section-counter = counter("section-slide")
/// 발표 제목. title-slide가 설정하고, 머리말 우측 끝에 표시된다.
#let deck-title = state("deck-title", none)

/// 쪽 번호 꼬리말. 표지·섹션·포커스 슬라이드에서는 숨긴다.
#let footer = context {
  set align(right)
  sans(size: sizes.micro, weight: "medium", fill: colors.faint, tracking: 0.02em,
    counter(page).display())
}

/// 상단 머리말: 좌측 "#n 섹션명 · 소주제", 우측 발표 제목.
#let header-bar(sub) = {
  place(top + left, dy: -36pt, context {
    let section = current-section.get()
    let parts = ()
    if section != none {
      let n = section-counter.get().first()
      parts.push([#text(size: 1.2em, weight: "semibold")[\##n]#h(0.35em)#section])
    }
    if sub != none { parts.push(sub) }
    if parts.len() > 0 {
      sans(
        size: sizes.caption,
        weight: "medium",
        fill: colors.muted,
        parts.join[#h(0.4em)#text(fill: colors.accent)[·]#h(0.4em)],
      )
    }
  })
  place(top + right, dy: -36pt, context {
    let t = deck-title.get()
    if t != none {
      sans(size: sizes.caption, weight: "medium", fill: colors.muted, t)
    }
  })
}

/// 일반 내용 슬라이드: 좌상단 44pt 제목 + 본문.
/// 모든 인자는 선택이다. `#slide()`는 머리말·쪽 번호만 있는 빈 슬라이드가 된다.
/// - title: 슬라이드 제목. 생략하면 제목 없이 본문이 맨 위부터 시작한다.
/// - sub: 섹션 안의 소주제. 제목 위 머리말에 "#n 섹션명 · 소주제"로 표시된다.
///   섹션 번호와 섹션명은 볼드, 소주제는 미디엄.
/// - header: false이면 상단 머리말(섹션·발표 제목)을 숨긴다.
/// - footer: false이면 쪽 번호를 숨긴다.
/// - ..body: 본문(0개 이상). `#slide[…]`, `#slide()` 모두 가능.
#let slide(title: none, sub: none, header: true, footer: true, ..body) = {
  pagebreak(weak: true)
  set page(footer: none) if not footer
  // 높이 0 블록: 머리말을 띄우고, 내용이 없어도 페이지가 약한 페이지 나눔에
  // 흡수되지 않게 한다. 높이가 없으므로 제목 위치에는 영향이 없다.
  block(width: 100%, height: 0pt, above: 0pt, below: 0pt, if header { header-bar(sub) })
  if title != none {
    // 여러 줄 제목(`\`로 줄바꿈)은 제목용 좁은 줄 간격을 쓴다.
    block(below: 48pt, {
      set par(leading: 0.5em)
      sans(size: sizes.title, weight: "semibold", title)
    })
  }
  body.pos().join()
}

/// 빈 슬라이드. 머리말·쪽 번호까지 모두 없는 완전히 빈 페이지.
/// 내용을 주면 그대로 배치한다(전체 화면 그림 등).
#let blank-slide(..body) = slide(header: false, footer: false, ..body)

/// 섹션 구분 슬라이드: "섹션 #n" 라벨 + 60pt 섹션명 + 선택적 부연 설명.
#let section-slide(title, body) = {
  pagebreak(weak: true)
  section-counter.step()
  current-section.update(title)
  set page(
    margin: (left: margin-x, right: margin-x, top: 232pt, bottom: 40pt),
    footer: none,
  )
  sans(size: sizes.eyebrow, weight: "bold")[섹션 \##context section-counter.display()]
  v(21pt, weak: false)
  block(below: 68pt, sans(size: sizes.display, weight: "semibold", title))
  body
}

/// 반전(다크) 슬라이드. 결론·핵심 메시지 하나만 크게 보여줄 때 쓴다.
/// anthropic.com의 slate-950 배경 구간에 대응한다.
#let focus-slide(body, eyebrow: none) = {
  pagebreak(weak: true)
  set page(fill: colors.inverse-bg, footer: none)
  set text(fill: colors.inverse-text)
  set align(horizon)
  if eyebrow != none {
    block(below: space.at("5"), sans(
      size: sizes.caption, weight: "semibold", fill: colors.accent, tracking: 0.04em, eyebrow,
    ))
  }
  sans(size: sizes.title, weight: "semibold", fill: colors.inverse-text, body)
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
  set page(margin: 0pt, footer: none)
  deck-title.update(title)
  let at(x, y, body) = place(top + left, dx: x, dy: y, body)

  at(62pt, 83pt, sans(size: sizes.title, weight: "bold", {
    if experiment != none [#experiment — ]
    title
  }))
  for (i, s) in subtitles.enumerate() {
    at(64pt, 188pt + i * 43pt, sans(size: sizes.lead, weight: "medium", s))
  }
  let y0 = 334pt
  for (i, (name, aff)) in authors.enumerate() {
    at(64pt, y0 + i * 32pt, sans(size: sizes.body, weight: "regular", name))
    at(125pt, y0 + 3pt + i * 32pt, sans(size: 16pt, weight: "regular", fill: colors.sub, aff))
  }
  if date != none {
    at(64pt, y0 + authors.len() * 32pt + 35pt,
      sans(size: sizes.small, weight: "regular", fill: colors.sub, date))
  }
}

// ═════════════════════════════════════════════════════════════
//  7. 문서 전체 설정
// ═════════════════════════════════════════════════════════════
#let seminar-theme(body) = {
  set page(
    width: 960pt,
    height: 540pt,
    fill: colors.bg,
    margin: (left: margin-x, right: margin-x, top: 63pt, bottom: 40pt),
    footer: footer,
    footer-descent: 40%,
  )
  set text(
    font: fonts.body,
    size: sizes.body,
    fill: colors.text,
    lang: "ko",
    region: "kr",
    features: num-features,
  )
  set par(leading: leading.body, spacing: 20pt)
  set list(
    marker: (
      text(font: "Arial", baseline: -0.115em)[»],
      text(font: "Arial", baseline: -0.115em, fill: colors.muted)[›],
    ),
    indent: 0pt,
    body-indent: 11pt,
    spacing: 14pt,
  )
  set enum(numbering: n => sans(size: 1em, weight: "semibold", fill: colors.muted, str(n) + "."))

  // 강조: 한글 세리프에는 이탤릭이 없으므로 emph는 산세리프로, strong은 굵기로 구분
  show strong: it => text(weight: "semibold", it.body)
  show emph: it => text(font: fonts.heading, weight: "medium", style: "normal", it.body)

  // 수식
  show math.equation: set text(font: fonts.math)

  // 코드·식별자
  show raw: set text(font: fonts.mono, size: 0.85em)
  show raw.where(block: false): it => box(
    fill: colors.surface,
    radius: radius.xs,
    inset: (x: 0.3em),
    outset: (y: 0.25em),
    it,
  )
  show raw.where(block: true): it => block(
    width: 100%,
    fill: colors.surface,
    radius: radius.sm,
    inset: space.at("4"),
    it,
  )

  // 링크: 강조색 밑줄
  show link: it => underline(offset: 4pt, stroke: 1pt + colors.accent, it)

  // 그림 캡션
  show figure.caption: set text(font: fonts.heading, size: sizes.caption, fill: colors.muted)

  show heading: set text(font: fonts.heading, weight: "semibold")

  body
}
