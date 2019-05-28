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

.PHONY: build test clean distclean doc

# Deploy doc to website.
#

sync: doc
	exit 1 # ssh.ocamlcore.org is not available anymore to publish doc.

.PHONY: sync

# Headache target
#  Fix license header of file.

headache:
	find ./ \
	  -name _darcs -prune -false \
	  -o -name .git -prune -false \
	  -o -name .svn -prune -false \
	  -o -name _build -prune -false \
	  -o -name dist -prune -false \
	  -o -name '*[^~]' -type f \
	  | xargs /usr/bin/headache -h _header -c _headache.config

.PHONY: headache

# Deploy target
#  Deploy/release the software.

deploy:
	mkdir dist || true
	admin-gallu-deploy \
		--package_name ocaml-xdg-basedir --package_version 0.0.4 \
		--verbose

.PHONY: deploy

