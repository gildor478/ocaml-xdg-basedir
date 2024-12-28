(lang dune 2.9)
(name xdg-basedir)

(generate_opam_files true)

(source (github gildor478/ocaml-xdg-basedir))
(license "LGPL-2.1-or-later WITH OCaml-LGPL-linking-exception")
(authors "Sylvain Le Gall")
(maintainers "Sylvain Le Gall <sylvain@le-gall.net>")

(package
 (name xdg-basedir)
 (synopsis "XDG basedir location for data/cache/configuration files")
 (description
"\| This library implements the xdg-basedir specification. It helps to
"\| define standard locations for configuration, cache and data files in
"\| the user directory and on the system. It is a straightforward
"\| implementation on UNIX platforms and try to apply consistent policies
"\| with regard to Windows directories. It is inspired by the Haskell
"\| implementation of this specification, and it follows the same choices
"\| for Windows directories. See he [xdg-basedir specification][spec] and
"\| the [Haskell implementation][haskell].
"\| [haskell]: https://github.com/willdonnelly/xdg-basedir
"\| [spec]: https://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
 )
 (depends
  fileutils
  base-unix
  (ounit2 :with-test)))
