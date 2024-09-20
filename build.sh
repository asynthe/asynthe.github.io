#!/bin/sh
emacs -Q --script build-site.el

# --batch		do not interactive display; implies -q
# --no-init-file,-q	load neither ~/.emacs nor default.el
