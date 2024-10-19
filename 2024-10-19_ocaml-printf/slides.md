---
theme: seriph
background: https://cdn.jsdelivr.net/gh/slidevjs/slidev-covers@main/static/XdcRfXL2hJ4.webp

title: 変な関数
info: |
    OCaml には幾つか変な関数がありますが、個人的に面白いなと思った printf 関数について簡単に喋ります。
class: text-center
drawings:
  persist: false
transition: slide-left
mdc: true
overviewSnapshots: true
hideInToc: true
---

# 変な関数

yuki @lmdexpr 2024-10-19

<div class="abs-br m-6 flex gap-2">
  <a href="https://github.com/lmdexpr/slides" target="_blank" alt="GitHub" title="Open in GitHub"
    class="text-xl slidev-icon-btn opacity-50 !border-none !hover:text-white">
    <carbon-logo-github />
  </a>
</div>

---
transition: fade-out
---

# 自己紹介

Yuki Tajiri @lmdexpr

<div class="text-4xl">

- 好きな言語: OCaml

- おしごとで使っていた言語
    - Scala
    - (PHP)

- 最近の趣味: 盆栽 (おうち k8s)

</div>

---
transition: slide-up
level: 2
layout: center
---

# 免責

<div class="text-4xl">
全ての発表内容は私の個人的な見解であり、
<br>
所属する組織とは一切関係ありません。
</div>

---
layout: center
---

<div class="text-4xl">
OCaml を知っていますか
</div>

---
layout: center
---

<div class="text-4xl">
僕は知っています
</div>

---
layout: default
---

# OCaml の特徴

<div class="text-4xl">

- 関数型プログラミング言語
- <span v-mark.circle.orange="1">非純粋</span>
- <span v-mark.circle.orange="1">静的型付け</span>
- (ほぼ) 完全な型推論
- 最新バージョンでは並行並列に対応し、今一番熱い (?)

</div>

---
layout: center
---

<div class="text-4xl">
Printf を知っていますか
</div>

---
layout: center
---

<div class="text-4xl">
僕は知っています
</div>

---
layout: default
---

# 変な関数 printf

````md magic-move {lines: true}
```c {*|3|*}
#include <stdio.h>

int printf(const char * restrict format, ...);
```

```c
#include <stdio.h>

int main() {
  printf("Hello, world!\n");

  return 0;
}
```

```c
#include <stdio.h>

int main() {
  printf("Hello, %s!\n", "world");
  // Hello, world!

  return 0;
}
```

```c
#include <stdio.h>

int main() {
  printf("Hello, %s!\n", "world");
  // Hello, world!

  printf("%s: %d\n", "answer", 42);
  // answer: 42

  return 0;
}
```
````

---
layout: default
---

# 変な関数 printf

```c
#include <stdio.h>

int printf(const char * restrict format, ...);
```

<div class="text-4xl">

<div v-click>

- 動的なフォーマット文字列

</div>

<div v-click>

- 可変長引数

</div>

</div>

<br><br>

<div class="text-7xl">

<div v-click>

色々ヤバいけど使いたい！

</div>

</div>

---
layout: center
---

<div class="text-4xl">
使えます
</div>

---
layout: center
---

<div class="text-4xl">
OCaml ならね
</div>

<div v-click>
(実装自体は色んな言語にあります)
</div>

---
layout: default
---

# 変な関数 printf (OCaml)

````md magic-move {lines: true}
```ocaml
open Printf

let () =
  printf "Hello, wolrd!\n"
```

```ocaml
open Printf

let () =
  printf "Hello, %s!\n" "world"
  (* Hello, world! *)
```

```ocaml
open Printf

let () =
  printf "Hello, %s!\n" "world"
  (* Hello, world! *)

  printf "%s: %d\n" "answer" 42
  (* answer: 42 *)
```

```ocaml
open Printf

let () =
  printf "Hello, %s!\n" "world"
  (* Hello, world! *)

  printf "%s: %d\n" "answer" 42
  (* answer: 42 *)

  printf "%s: %d\n" 42 "answer"
  (* Error: This expression has type int but an expression was expected of type string *)
```
````

---
layout: center
---

<div class="text-7xl">
👍
</div>

---
layout: center
---

<div class="text-7xl">
🤔
</div>

---
layout: default
---

````md magic-move {lines: true}
```ocaml{*|5}
OCaml version 5.0.0~rc1
Enter #help;; for help.

# Printf.printf;;
- : ('a, out_channel, unit) format -> 'a = <fun>
```

```ocaml{5-8|5,8}
OCaml version 5.0.0~rc1
Enter #help;; for help.

# Printf.printf;;
- : ('a, out_channel, unit) format -> 'a = <fun>

# "%d";;
- : string = "%d"
```

```ocaml {5,8-17|5,8,11}
OCaml version 5.0.0~rc1
Enter #help;; for help.

# Printf.printf;;
- : ('a, out_channel, unit) format -> 'a = <fun>

# "%d";;
- : string = "%d"

# ("%d": _ format);;
- : (int -> 'a, 'b, 'a) format =
CamlinternalFormatBasics.Format
 (CamlinternalFormatBasics.Int (CamlinternalFormatBasics.Int_d,
   CamlinternalFormatBasics.No_padding,
   CamlinternalFormatBasics.No_precision,
   CamlinternalFormatBasics.End_of_format),
 "%d")
```
````

---
layout: default
---

````md magic-move {lines: true}
```ocaml {*|5}
OCaml version 5.0.0~rc1
Enter #help;; for help.

# ("%d %s": _ format);;
- : (int -> string -> 'a, 'b, 'a) format =
CamlinternalFormatBasics.Format
 (CamlinternalFormatBasics.Int (CamlinternalFormatBasics.Int_d,
   CamlinternalFormatBasics.No_padding,
   CamlinternalFormatBasics.No_precision,
   CamlinternalFormatBasics.Char_literal (' ',
    CamlinternalFormatBasics.String (CamlinternalFormatBasics.No_padding,
     CamlinternalFormatBasics.End_of_format))),
 "%d %s")
```

```ocaml{5,15-19}
OCaml version 5.0.0~rc1
Enter #help;; for help.

# ("%d %s": _ format);;
- : (int -> string -> 'a, 'b, 'a) format =
CamlinternalFormatBasics.Format
 (CamlinternalFormatBasics.Int (CamlinternalFormatBasics.Int_d,
   CamlinternalFormatBasics.No_padding,
   CamlinternalFormatBasics.No_precision,
   CamlinternalFormatBasics.Char_literal (' ',
    CamlinternalFormatBasics.String (CamlinternalFormatBasics.No_padding,
     CamlinternalFormatBasics.End_of_format))),
 "%d %s")

# ("%a": _ format);;
- : (('a -> 'b -> 'c) -> 'b -> 'c, 'a, 'c) format =
CamlinternalFormatBasics.Format
 (CamlinternalFormatBasics.Alpha CamlinternalFormatBasics.End_of_format,
 "%a")
```
````

---
layout: center
---

<div class="text-7xl">
👍
</div>

---
layout: center
---

<div class="text-7xl">
🤔
</div>

---
layout: center
---

# Learn More

時間があれば [コード](https://github.com/ocaml/ocaml/blob/trunk/stdlib/printf.ml) を読む

---
layout: default
---

# OCaml の特徴 (再掲)

<div class="text-4xl">

- 関数型プログラミング言語
- 非純粋
- 静的型付け
- (ほぼ) 完全な型推論
- 最新バージョンでは並行並列に対応し、今一番熱い (?)

</div>

---
layout: center
class: text-center
---

Thank you!

<PoweredBySlidev mt-10 />
