WGET       = wget -r -np -nd -A tex
EMACS      = emacs --batch -q
WAYBACK    = 20160603133923
ANSI3_URL  = https://web.archive.org/web/$(WAYBACK)/http://quimby.gnus.org/circus/cl/dpANS3/
ANSI3R_URL = https://web.archive.org/web/$(WAYBACK)/http://quimby.gnus.org/circus/cl/dpANS3R/

.PHONY = all html xml docbook wget clean

all: ansicl

ansicl: dpans2texi.elc temp.texi
	makeinfo --no-warn --enable-encoding temp.texi
	$(EMACS) -l dpans2texi.elc -f dp-tr

temp.texi: dpans2texi.elc
	$(EMACS) -l dpans2texi.elc -f dp-tex2texi

dpans2texi.elc: dpans2texi.el
	$(EMACS) -f batch-byte-compile dpans2texi.el

html: temp.texi
	makeinfo --css-include=ansicl.css --html temp.texi

xml: temp.texi
	makeinfo --css-include=ansicl.css --xml temp.texi

docbook: temp.texi
	makeinfo --css-include=ansicl.css --docbook temp.texi

wget:
	$(WGET) $(ANSI3_URL)
	$(WGET) $(ANSI3R_URL)

clean:
	rm -f temp.texi ansicl ansicl-[0-9] ansicl-[0-9][0-9]
	rm -f elc-stamp dpans2texi.elc
	rm -f ansicl.aux ansicl.cp ansicl.cps ansicl.fn ansicl.fns ansicl.ky \
	      ansicl.kys ansicl.log ansicl.pg ansicl.pgs ansicl.tmp \
	      ansicl.toc ansicl.tp ansicl.tps ansicl.vr ansicl.vrs \
	      ansicl.dvi ansicl.pdf ansicl.ps ansicl.html
