#!/bin/sh

NAME="File-Path-Localize"

set -e

# Make things clean.

make -k realclean ||:
rm -rf MANIFEST blib

# Make makefiles.

perl Makefile.PL PREFIX=$AUTO_BUILD_PREFIX
make manifest
echo $NAME.spec >> MANIFEST

# Build the RPM.
make
make test

make install

rm -f $NAME-*.tar.gz
make dist
rpmbuild -ta --clean $NAME-*.tar.gz
