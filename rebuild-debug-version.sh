#!/usr/bin/env bash

unset PERL_MM_OPT
unset PERL_MB_OPT

CONFIG_FLAGS="--enable-maintainer-mode --prefix=/opt/stow/repo/irssi-termkey LDFLAGS=-ltermkey CFLAGS=-g"
rm aclocal.m4
autoreconf -i || exit 1
./configure $CONFIG_FLAGS
make install
./taggen.sh
