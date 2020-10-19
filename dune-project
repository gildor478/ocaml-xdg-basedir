(lang dune 2.0)

(name xdg_basedir)

(license "LGPL-2.1 with OCaml linking exception")

(authors "Sylvain Le Gall")

(maintainers "Sylvain Le Gall")

(source
 (github gildor478/ocaml-xdg-basedir))

(generate_opam_files true)

(package
 (name xdg_basedir)
 (synopsis "XDG basedir location for data/cache/configuration files")
 (description
   "This library implements the xdg-basedir specification. It helps to define standard locations for configuration, cache and data files in the user directory and on the system. It is a straightforward implementation on UNIX platform and try to apply consistent policies with regard to Windows directories. It is inspired by the Haskell implementation of this specification, and it follows the same choices for Windows directories. [The xdg-basedir specification](http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html) and [the Haskell implementation](http://github.com/willdonnelly/xdg-basedir) and [the API of this implementation](http://xdg-basedir.forge.ocamlcore.org/api).")
 (depends
  (ocaml
   (>= 4.05))
  (dune
   (>= 2.0))))
