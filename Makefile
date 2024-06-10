CSS        = --css-include=ansicl.css
WGET       = wget -r -np -nd -A tex
EMACS      = emacs --batch -q
MAKEINFO   = makeinfo --no-split --no-warn --force --enable-encoding
INFO_DIR  ?= /usr/share/info
WAYBACK    = 20160603133923
ANSI3_URL  = https://web.archive.org/web/$(WAYBACK)/http://quimby.gnus.org/circus/cl/dpANS3/
ANSI3R_URL = https://web.archive.org/web/$(WAYBACK)/http://quimby.gnus.org/circus/cl/dpANS3R/

.PHONY = all wget clean

all: ansicl.info

ansicl.info: dpans2texi.elc temp.texi
	$(MAKEINFO) temp.texi
	$(EMACS) -l dpans2texi.elc -f dp-tr

temp.texi: dpans2texi.elc
	$(EMACS) -l dpans2texi.elc -f dp-tex2texi

dpans2texi.elc: dpans2texi.el
	$(EMACS) -f batch-byte-compile dpans2texi.el

# Makeinfo (texi2any 7.0.3 on OpenSuse Tumbleweed) reliably crashes
# with "realloc(): invalid next size" with --html or --epub
ansicl.html: temp.texi
	$(MAKEINFO) $(CSS) --html temp.texi

ansicl.xml: temp.texi
	$(MAKEINFO) $(CSS) --xml temp.texi

ansicl.docbook: temp.texi
	$(MAKEINFO) $(CSS) --docbook temp.texi

install:
	cp ansicl.info $(INFO_DIR)
	install-info $(INFO_DIR)/ansicl.info $(INFO_DIR)/dir

uninstall:
	install-info --delete $(INFO_DIR)/ansicl.info $(INFO_DIR)/dir
	rm $(INFO_DIR)/ansicl.info
wget:
	$(WGET) $(ANSI3_URL)
	$(WGET) $(ANSI3R_URL)

clean:
	rm -f temp.texi ansicl.info
	rm -f elc-stamp dpans2texi.elc
	rm -f ansicl.aux ansicl.cp ansicl.cps ansicl.fn ansicl.fns ansicl.ky \
	      ansicl.kys ansicl.log ansicl.pg ansicl.pgs ansicl.tmp \
	      ansicl.toc ansicl.tp ansicl.tps ansicl.vr ansicl.vrs \
	      ansicl.dvi ansicl.pdf ansicl.ps ansicl.html
