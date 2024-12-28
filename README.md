XDG basedir location for data/cache/configuration files
===========================================================================

[![OCaml-CI Build Status](https://img.shields.io/endpoint?url=https://ci.ocamllabs.io/badge/gildor478/ocaml-xdg-basedir/master&logo=ocaml)](https://ci.ocamllabs.io/github/gildor478/ocaml-xdg-basedir)

Note: this library hasn't received a lot of udpates recently and is kept mostly
for backward compatibility. The original author is not planning to add features
or make significant update. There is an alternative ocamlpro/directories which
is a more complete alternative to this library, it notably supports the
windows standard.

This library implements the xdg-basedir specification. It helps to define
standard locations for configuration, cache and data files in the user
directory and on the system.

It is a straightforward implementation on UNIX platform and try to apply
consistent policies with regard to Windows directories.

It is inspired by the Haskell implementation of this specification, and it
follows the same choices for Windows directories.

[The xdg-basedir
specification](http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html).
and [the Haskell implementation](http://github.com/willdonnelly/xdg-basedir)
and [the API of this
implementation](http://xdg-basedir.forge.ocamlcore.org/api).

Install it using opam, or have a look at the [opam config
file](./xdg-basedir.opam) if you want to do it yourself.

Installation
------------

The recommended way to install fileutils is via the [opam package manager][opam]:

```sh
$ opam install xdg-basedir
```

Copyright and license
---------------------

(C) 2010 OCamlCore SARL

ocaml-xdg-basedir is distributed under the terms of the GNU Lesser General
Public License version 2.1 with OCaml linking exception.

See [COPYING.txt](COPYING.txt) for more information.
