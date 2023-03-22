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
 (depends
   (ocaml (>= 4.12.0))
   dune
   satysfi
   satysfi-dist
   satyrographos))
