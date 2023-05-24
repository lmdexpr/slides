(lang dune 3.7)

(name slides)

(generate_opam_files true)

(source
 (github lmdexpr/slides))

(authors "Yuki Tajiri")

(maintainers "Yuki Tajiri <lmdexpr@gmail.com>")

(license MIT)

(package
 (name slides)
 (synopsis "Slides with SATySFi")
 (allow_empty)
 (depends
   (ocaml (>= 4.12.0))
   dune
   satysfi
   satysfi-dist
   satysfi-class-slydifi
   satysfi-figbox
   satysfi-fonts-noto-sans
   satysfi-fonts-noto-sans-cjk-jp
   satysfi-fonts-noto-emoji
   satyrographos))
