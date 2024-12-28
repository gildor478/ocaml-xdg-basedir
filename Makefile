# Default dune targets.
#
default: test

build:
	dune build

test:
	dune runtest

doc:
	dune build @doc

clean:
	dune clean

distclean: clean

deploy: doc
	dune-release tag
	git push --all
	git push --tag
	dune-release

.PHONY: build test clean distclean doc deploy
