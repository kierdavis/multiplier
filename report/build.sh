#!/bin/sh
set -eu
pdflatex -halt-on-error -file-line-error -shell-escape -draftmode d1report.tex
bibtex d1report
pdflatex -halt-on-error -file-line-error -shell-escape -draftmode d1report.tex
pdflatex -halt-on-error -file-line-error -shell-escape d1report.tex
