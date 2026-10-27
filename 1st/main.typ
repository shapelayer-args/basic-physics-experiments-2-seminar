#import "packages/pptx-media/lib.typ": media
#import "theme.typ": *

#show: seminar-theme

// 자주 쓰는 기호
#let BE = $B_"Earth"$
#let BM = $B_"manual"$
#let mA = $"mA"$

/// 동영상 첨부. typst-pptx로 내보내면 재생 가능한 비디오, 일반 Typst(PDF)에서는 썸네일.
/// - name: assets/video/ 안의 파일 이름(확장자 제외). <name>.mp4 + <name>.thumb.png
///   썸네일은 scripts/video-thumbnails.sh로 원본 해상도 PNG로 생성한다.
/// - width/height: 하나만 주면 영상 비율로 나머지를 계산한다.
///   둘 다 생략하면 남은 영역(가로·세로) 안에 비율을 유지한 채 최대 크기로 맞춘다.
///   길이(pt), 비율(%), 조합(50% + 10pt) 모두 가능하며 %는 부모 영역 기준.
/// - aspect: 가로/세로 비율(예: 16 / 9, 9 / 16, 4 / 3).
///   기본(auto)은 썸네일의 픽셀 크기에서 읽는다. 썸네일은 ffmpeg가 회전 메타데이터까지
///   반영한 실제 프레임이므로 세로 영상, 4:3, 정사각형도 그대로 맞는다.
/// - fit: width/height를 둘 다 생략했을 때 맞출 영역.
///   "rest"    제목 아래 남은 영역 (기본)
///   "margin"  페이지 여백 안쪽 전체 (본문 영역 = 페이지 − 여백). 머리말·제목을 무시하고
///             여백 상자에 꽉 차게 배치한다.
///   "page"    슬라이드 전체(여백 무시, 가장자리까지). 머리말·제목·쪽 번호는 그대로 위에 그려진다.
/// - ..playback: autoplay, loop, muted, volume (pptx-media 명세)
#let video(name, width: auto, height: auto, aspect: auto, fit: "rest", ..playback) = {
  assert(fit in ("rest", "margin", "page"), message: "fit must be rest, margin or page")
  let src = "assets/video/" + name + ".mp4"
  let thumb = "assets/video/" + name + ".thumb.png"
  let play = (autoplay: true, loop: true, muted: true, ..playback.named())

  // 가로/세로 비율: 명시값 > 썸네일 픽셀 크기
  let ratio-of() = if aspect != auto { aspect } else {
    let s = measure(image(thumb))
    s.width / s.height
  }
  // 상대 길이(%)를 부모 영역 기준 절대 길이로
  let resolve(v, full) = if type(v) == relative { v.ratio * full + v.length } else if type(v) == ratio { v * full } else { v }
  let put(w, h) = media(src, thumbnail: path(thumb), width: w, height: h, playback: play)
  // 영역(bw × bh) 안에 비율 r을 유지하며 최대로 (contain)
  let contain(bw, bh, r) = if bw / r <= bh { (bw, bw / r) } else { (bh * r, bh) }

  if width == auto and height == auto and fit != "rest" {
    // 여백·페이지 크기는 context에서 읽는다. place()는 여백 상자의 좌상단 기준이며
    // 흐름에서 공간을 차지하지 않으므로 머리말·제목·쪽 번호의 위치는 바뀌지 않는다.
    // 본문보다 먼저 그려지도록 background 층에 두지 않고, 슬라이드 맨 앞에 호출하면 뒤에 깔린다.
    context {
      let m = page.margin
      let side(k) = if type(m) == dictionary { m.at(k, default: m.at("rest", default: 0pt)) } else { m }
      let abs(v, full) = { let v = resolve(v, full); if type(v) == length { v.to-absolute() } else { v } }
      let pw = page.width
      let ph = page.height
      let (ml, mr, mt, mb) = (abs(side("left"), pw), abs(side("right"), pw), abs(side("top"), ph), abs(side("bottom"), ph))
      let (bx, by, bw, bh) = if fit == "page" { (-ml, -mt, pw, ph) } else { (0pt, 0pt, pw - ml - mr, ph - mt - mb) }
      let (w, h) = contain(bw, bh, ratio-of())
      place(top + left, dx: bx + (bw - w) / 2, dy: by + (bh - h) / 2, put(w, h))
    }
  } else if width == auto and height == auto {
    // 남은 영역 전체(1fr)를 잡은 뒤 그 안에 비율을 유지하며 맞춘다 (contain).
    block(width: 100%, height: 1fr, layout(region => {
      let (w, h) = contain(region.width, region.height, ratio-of())
      align(center + horizon, put(w, h))
    }))
  } else {
    layout(region => {
      let r = ratio-of()
      let w = resolve(width, region.width)
      let h = resolve(height, region.height)
      let (w, h) = if w == auto { (h * r, h) } else if h == auto { (w, w / r) } else { (w, h) }
      put(w, h)
    })
  }
}

// ═════════════════════════════════════════════════════════════
//  표지 · 목표
// ═════════════════════════════════════════════════════════════

#title-slide(
  experiment: [실험 \#4],
  title: [전류계 만들기],
  subtitles: (
    [전류에 의해 만들어지는 자기장을 활용하기],
    [자기장에 반응하는 나침반의 원리를 활용하기],
  ),
  authors: (
    ([김은솔], [자연대학 물리학과]),
    ([박종현], [공과대학 컴퓨터정보통신공학과]),
    ([정찬우], [자연대학 물리학과]),
  ),
  date: [Oct 30, 2026],
)

#slide(title: [목표 설정])[
  #v(54pt)
  #align(center, statement[전류의 크기에 따라 회전하는 나침반 바늘을 이용하여 전류계 구현])
  #v(64pt)
  #quote[
    이 전류계를 두고 초등학생도 쉽게 만들 수 있는 전류계라고 소개하곤 있지만,
    제대로 된 전류계를 만들려면 생각해야 할 것이 아주 많다.
    --- 정확한 전류계를 설계할 수 있다면 대단한 실력자라고 자부해도 좋다! ---
  ]
]

// ═════════════════════════════════════════════════════════════
//  섹션 #1 · 이론적 고려사항
// ═════════════════════════════════════════════════════════════
#blank-slide()

#section-slide[이론적 고려사항][
  #quote[
    전선을 고리 형태로 여러 바퀴 감은 후 전류를 흘리면 어떤 방향의 자기장이 만들어지는가?
    또, 이 전선 고리 안에 나침반을 넣으면 원래 북쪽을 가리키던 나침반 바늘이
    어디로 향하게 되겠는가?
  ]
]

// ── 관계식 계산 ──────────────────────────────────────────────
#slide(title: [들어가기에 앞서])[
  #set text(size: 24pt)
  #v(-15mm)
  #align(horizon)[
    - 표기법 정의
    #v(10pt)
    #align(center, grid(
      columns: 2,
      align: center + horizon,
      column-gutter: 12pt,
      text(size: 34pt)[$BM(I) = k I$],
      text(size: 24pt)[\= 코일 전류 $I$에 비례하는 코일 자기장 성분 ($k > 0$)],
    ))
    #v(20pt)
    - $I$: 전류 ($"mA"$)
    #v(6pt)
    - #BE: 지구 자기장의 수평 성분 크기
      #v(4pt)
      #text(size: 0.8em)[- 연직 방향을 z축으로 설정할 때, xz 평면]
    #v(6pt)
    - 코일 자기장은 수평#super[xz평면], 지구 자기장의 수평 성분과 수직으로 배치
    #v(6pt)
    - $theta$: 자북으로부터의 수평 회전각
    #v(6pt)
  ]
]

#slide(title: align(horizon)[합성 자기장 $arrow(B)_"total"$])[
  - 바늘의 수평 방향을 결정하는 자기장은 두 수평 자기장의 벡터 합이다.
  #grid(
    columns: (1fr, 1fr),
    align: horizon,
    column-gutter: 24pt,
    [
      #eq(size: 26pt)[$ arrow(B)_"total" = arrow(B)_"Earth" + arrow(B)_"manual" $]
      #v(30pt)
      #eq(size: 26pt)[$ I arrow.t quad => quad BM(I) arrow.t quad => quad theta arrow.t $]
    ],
    [#image("assets/img/compass-vectors_default.png", height: 67%)]
  )
  
]

#slide(title: [입력 $I$, 출력 $theta$인 시스템])[
  - 전류 $I$를 입력, 합성 자기장에 정렬된 바늘의 각도 $theta$를 출력으로 삼을 때
  #v(10pt)
  #grid(
    columns: (1fr, 1fr),
    align: horizon,
    [
      #v(10pt)
      #align(center)[〈기대 가능한 입출력 범위〉]
      #v(10pt)
      #eq(size: 24pt)[$
        I -> -infinity & quad => quad theta -> -pi / 2 \
        I = 0 & quad => quad theta = 0 \
        I -> infinity & quad => quad theta -> pi / 2
      $]
    ],
    {
      set text(size: 18pt)
      [스프링과 마찰을 무시한 평형에서, 두 수평 자기장과 $theta$의 관계는]
      v(4pt)
      eq(size: 28pt)[$ tan theta = BM(I) / BE $]
    },
  )
  #v(20pt)
  #callout(label: [검정])[
    $tan$ 그래프는 $-pi/2$, $pi/2$ 부근에서 발산하므로 위 극한과 일치 — 타당함
  ]
]

// ── 시각화 ──────────────────────────────────────────────────
#slide(title: [기대 상황], backdrop: video("vectors-animation", fit: "page"))

#slide(title: [기대 상황], backdrop: video("compass-animation", fit: "page"))

#blank-slide()

// ═════════════════════════════════════════════════════════════
//  섹션 #2 · 현실 세계에서의 구현
// ═════════════════════════════════════════════════════════════

#section-slide[현실 세계에서의 구현][
  #quote[
    이 전류계를 두고 초등학생도 쉽게 만들 수 있는 전류계라고 소개하곤 있지만,
    제대로 된 전류계를 만들려면 생각해야 할 것이 아주 많다.
    --- 정확한 전류계를 설계할 수 있다면 대단한 실력자라고 자부해도 좋다! ---
  ]]

#slide(title: [구현])[
  #grid(
    columns: 2,
    align: horizon,
    gutter: 1.5em,
    [
      #image("assets/img/close-up_1.jpeg", height: 81%)
    ],
    [
      #text(size: 24pt)[
        *구현 단계 1*

        - *코일을 감은 나침반을 준비*
      ]
    ]
  )
]


#slide(title: [구현])[
  #grid(
    columns: 2,
    align: horizon,
    gutter: 1.5em,
    [
      #image("assets/img/impl_1.jpeg", height: 81%)
    ],
    [
      #text(size: 24pt)[
        구현 단계 1

        - 코일을 감은 나침반을 준비

        \

        *구현 단계 2*

        - *코일을 회로에 연결*
      ]
    ]
  )
]


#slide(title: [구현])[
  #grid(
    columns: 2,
    align: horizon,
    gutter: 1.5em,
    [
      #image("assets/img/close-up_2.jpeg", height: 81%)
    ],
    [
      #text(size: 24pt)[
        구현 단계 1

        - 코일을 감은 나침반을 준비

        \

        구현 단계 2

        - 코일을 회로에 연결

        \

        *구현 단계 3*

        - *회로에 전류를 흘려보내\
          나침반 바늘의 각도 기록*
      ]
    ]
  )
]

#slide(title: [관계식을 이용한 추정])[
  #set text(size: 18pt)
  #quote(indent: 0pt)[위의 기준전류 외의 다른 값의 전류가 흐를 때 나침반 바늘이 얼마나 회전할지 예측해보자. 위의 나침반 각도는 "기준전류가 만든 자기장"과 "지구 자기장"의 비율에 의해 결정된 것임을 생각하라! 회로에 흐르는 전류가 100 mA일 때와 250 mA일 때, 자기장은 어떻게 형성될 것인가? 바늘은 어떻게 될 것인가?]
  #v(6pt)
  - 앞서 살펴본 입력 $I$, 출력 $theta$인 시스템으로 다른 전류 $I_"in"$에서의 $theta_"out"$을 찾을 수 있다.
  \
  #grid(
    columns: 2,
    align: (horizon),
    inset: (x: 1em),
    [
      - 측정: $I = 125 mA$일 때 $theta = 45°$
      #v(10pt)
      #align(center)[#eq[
        $
          tan^(-1)(BM(125 mA) \/ BE) = 45° quad\
          => quad BE = BM(125 mA)
        $
      ]]
    ],
    [
      - 100 mA, 250 mA일 때의 추정
      #v(10pt)
      #align(center)[#eq[
        $
          tan^(-1)(BM(100 mA) \/ BE) & approx 38.7° \
          tan^(-1)(BM(250 mA) \/ BE) & approx 63.4°
        $
      ]]
    ]
  )
  
  
]

#slide(title: [추정의 타당성])[
  #grid(
    columns: (4fr, 6fr),
    align: horizon,
    column-gutter: 24pt,
    [
      - $tan$ 그래프에서...\
        100 mA, 125 mA, 250 mA일 때 나침반의 $tan$ 값은
        *전류의 세기 순서대로 정렬*된다.
      \
      - 약한 추정:\
        타당한 관계성을 보인다.
    ],
    [
      #image("assets/img/compass-curve_default.png", width: 100%)
    ],
  )
]

#slide(title: [실험 결과])[
  #align(center, video("implementation", height: 340pt, muted: false, volume: 0.8))
]

#blank-slide()

// ═════════════════════════════════════════════════════════════
//  섹션 #3 · 개선 가능성
// ═════════════════════════════════════════════════════════════

#section-slide[개선 가능성][]

#slide(title: [문제 상황])[
  #v(69pt)
  #cols(
    case[
      사례\#1\
      #text(size: 1.1em, weight: "semibold")[팀의 결과물에서만 발생한 경우]
    ][
      - 나침반이 자북에 잘 정렬된 상태가 아님
      - 다만 일관된 각도로 틀어져 있었으므로,\
        결과 자체는 일관적
    ],
    case[
      사례\#2\
      #text(size: 1.1em, weight: "semibold")[구현 방법이 갖는 구조적 한계]
    ][
      - 전류와 나침반 각도가 비선형적인 관계--- \
        ($tan$ 관계)를 가짐
      - 전류계의 눈금과 전류가 선형 관계가 아님
    ],
  )
]

// ── 해결 방안 #1 ────────────────────────────────────────────
#slide(title: [사례 \#2의 해결 방안 1: \ 바늘 축에 스프링 추가])[
  - 바늘 축에 비틀림 스프링을 추가해 각도에 비례하는 복원 토크 더하기
  #v(8pt)
  #eq(size: 28pt)[$ m BM(I) cos theta = m BE sin theta + kappa theta $]
  #text(size: 18pt)[$m$: 바늘의 자기 쌍극자 모멘트 ($"A" dot "m"^2$),
    $kappa$: 비틀림 상수 ($"N" dot "m" / "rad"$), $theta$: 라디안]
  #v(20pt)
  #text(size: 1.2em, weight: "semibold")[이 방안의 한계]

  - 자기 토크의 각도 의존성은 비선형적이지만, 스프링 복원 토크는 선형적임
  
    - 작은 각도에서는 $I approx (BE + kappa \/ m) dot theta \/ k$로 선형 근사 가능
    #v(2pt)
    - 비선형성이 해결된 것은 아님: 큰 각도에서는 비선형성이 지배적임
]

// ── 해결 방안 #2 ────────────────────────────────────────────
#slide(title: [#text(size: 30pt)[해결 방안 2 · 선형 근사] \ 코일 전류 크기 조정])[
  #set text(size: 18pt)
  #grid(
    columns: (auto, 1fr),
    column-gutter: 40pt,
    align: horizon,
    [
      #set text(size: 24pt)
      $BM(I) = k I$, $BE = BM(125 mA)$이므로
      #v(6pt)
      #eq(size: 24pt)[$
        tan theta = BM(I) / BE = I / (125 mA)
      $]
      #text(size: 18pt)[원점 접선 근사: $tan theta approx theta$ ($theta$: 라디안)]
    ],
    data-table(
      columns: 4,
      header: ([$theta$], [라디안 (접선 근사)], [$tan theta$], [상대 오차]),
      [$10°$], [0.1745], [0.1763], [1.0%],
      [$20°$], [0.3491], [0.3640], [4.1%],
      [$30°$], [0.5236], [0.5774], [9.3%],
      [$45°$], [0.7854], [1.0000], [21.5%],
    ),
  )
  #v(8pt)
  - 표의 상대 오차: $(tan theta - theta) \/ tan theta times 100%$ ($theta$: 라디안)
  - 접선 근사 오차가 5% 이하인 $0 <= theta <= 20°$를 유효 범위로 선택
  - 범위 끝의 실제 전류: $I_"lin" = 125 mA times tan 20° approx 45.5 mA$
]

#slide(title: [#text(size: 30pt)[해결 방안 2] \ 유효 측정 범위])[
  - $0 <= theta <= 20°$ 범위만을 유효한 측정 범위로 사용
    - 목표 최대 전류 $I_"max" >= I_"lin"$에서 바늘이 $20°$를 가리키도록 설계
  \
  - 코일 전류 $I_"coil" in [0, I_"lin"]$에 전체 전류 $I_"total" in [0, I_"max"]$가 대응하도록 분류
  #v(10pt)
  #grid(
    columns: (1fr, 1fr),
    align: horizon,
    eq(size: 26pt)[$ I_"total" = M I_"coil" $],
    eq(size: 26pt)[$ M = I_"max" / I_"lin" approx I_"max" / (45.5 mA) $],
  )
  #v(14pt)
  #quote(indent: 0pt)[
    범위 확장 스케일러 $M$: 전체 전류를 코일 전류로 나눈 비율.
    $M$을 입력 $I$ 에 적용---곱셉---하여 측정 가능한 전류 범위를 확대할 수 있다. 
  ]
]

#slide(title: [#text(size: 30pt)[해결 방안 2] \ 병렬 회로])[
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 36pt,
    [
      #v(40pt)
      #image("assets/img/shunt-circuit.svg", width: 100%)
    ],
    [
      #set text(size: 18pt)
      - 병렬 경로에 특정한 값의 저항(분류기)을 달아 전체 전류 $I_"total"$을
        코일 전류 $I_"coil"$과 분류기 전류 $I_"shunt"$로 분배
        $ I_"total" = I_"coil" + I_"shunt" $
      
      \

      - $0 <= I_"total" <= I_"max"$에서 코일로는 전체 전류의 $1 \/ M$만 흘러야 함
        $ I_"coil" = 1 / M I_"total", quad
          I_"shunt" = (M - 1) / M I_"total" $
        $ I_"coil" : I_"shunt" = 1 : (M - 1) $
    ],
  )
]

#slide(title: [#text(size: 30pt)[해결 방안 2] \ 병렬 저항 $R_"shunt"$ 결정])[
  - 나침반 코일의 자체 저항을 $R_"coil"$로 정의
  \
  - 병렬 회로의 양 갈래 전압이 같으므로, 전류의 비는 저항의 역비와 같다.
  #v(14pt)
  #eq(size: 24pt)[$
    V_"coil" = V_"shunt" & quad => quad I_"coil" R_"coil" = I_"shunt" R_"shunt" \
    & quad => quad R_"coil" = (M - 1) R_"shunt" \
    & quad => quad R_"shunt" = R_"coil" / (M - 1) = I_"lin" / (I_"max" - I_"lin") R_"coil"
  $]
]

#slide(title: [#text(size: 30pt)[해결 방안 2] \ 설계 예시])[
  #v(10pt)
  #align(horizon)[
    #align(center, data-table(
      columns: 4,
      size: 21pt,
      header: (
        [목표 최대 전류 $I_"max"$],
        [배율 $M = I_"max" / I_"lin"$],
        [병렬 저항 $R_"shunt" = R_"coil" / (M - 1)$],
        [등각도 간격 눈금의 $1°$당 전류 $I_"max" / (20°)$],
      ),
      [$I_"lin" approx 45.5 mA$ (기본)], [$1$], [개방 ($R_"shunt" -> infinity$)], [$2.27 mA\/°$],
      [$250 mA$], [$5.49$], [$0.222 R_"coil"$], [$12.5 mA\/°$],
      [$500 mA$], [$10.99$], [$0.100 R_"coil"$], [$25.0 mA\/°$],
      [$1000 mA$ ($1 "A"$)], [$21.98$], [$0.0477 R_"coil"$], [$50.0 mA\/°$],
    ))
    #v(25mm)
  ]
]

#slide(title: [#text(size: 30pt)[해결 방안 2] \ 각도 $theta$로부터 전류 읽기])[
  #text(size: 22pt)[
  - $I_"total" = M I_"coil" = M dot 125 mA dot tan theta$
  \
  - $0°$에 $0 "mA"$, $20°$에 $I_"max" "mA"$를 대응시켜 전류 눈금을 등각도 간격으로 배치
  #v(12pt)
  #eq(size: 28pt)[$
    I_"read" = M dot (I_"lin" / (20°) theta)
    = (I_"max" / (20°)) theta approx I_"total"
  $]
  #v(20pt)
  - $20°$에서 코일 전류가 약 $45.5 mA$이므로,\
    등각도 간격 눈금에서는 코일 전류를 $1°$당 약 $2.27 mA$로 환산
  ]
]

#slide(title: [#text(size: 30pt)[해결 방안 2] \ 한계], sub: [해결 방안 \#2])[
  #v(20pt)
  - $I_"max"$를 늘려도 측정에 사용하는 바늘 각도는 $theta in [0, 20°]$로 고정됨
  #v(10pt)
  \
  #callout(label: [적용 이득])[작은 각도에서의 선형 근사와 등각도 간격 눈금, 분류기에 의해 측정 가능 범위의 확장]
  #callout(label: [남은 한계])[비선형성 --- 의도된 사용 시나리오에서, 눈금의 최대 표시 오차는 전체 눈금의 약 1.60%]
  #callout(label: [적용 손실])[최대 측정 각도가 $20°$로 좁아져 육안 측정 시 눈금 분해능(가독성) 저하]
]

#blank-slide()
