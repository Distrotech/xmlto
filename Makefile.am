bin_SCRIPTS = xmlto
bin_PROGRAMS = xmlif/xmlif
dist_man1_MANS = man/man1/xmlto.1 man/man1/xmlif.1

xmlif_xmlif_SOURCES = xmlif/xmlif.l

baseformats = format/docbook/dvi \
        format/docbook/epub \
	format/docbook/fo \
	format/docbook/html \
	format/docbook/html-nochunks \
	format/docbook/xhtml \
	format/docbook/xhtml-nochunks \
	format/docbook/man \
	format/docbook/pdf \
	format/docbook/ps \
	format/docbook/txt \
	format/docbook/htmlhelp \
	format/docbook/javahelp \
	format/docbook/mif \
	format/docbook/pcl \
	format/docbook/svg \
	format/docbook/awt \
	format/fo/ps \
	format/fo/awt \
	format/fo/mif \
	format/fo/pcl \
	format/fo/svg \
	format/fo/txt

passivetexformats = format/fo/dvi \
	format/fo/pdf


xhtml1formats = format/xhtml1/dvi \
	format/xhtml1/fo \
	format/xhtml1/pdf \
	format/xhtml1/ps \
	format/xhtml1/txt \
	format/xhtml1/awt \
	format/xhtml1/mif \
	format/xhtml1/pcl \
	format/xhtml1/svg

xmliftests = xmlif/test/run-test \
	xmlif/test/test.xml \
	xmlif/test/result-no-condition \
	xmlif/test/result-unrelated-condition \
	xmlif/test/result-html \
	xmlif/test/result-pdf \
	xmlif/test/result-ps \
	xmlif/test/result-foo \
	xmlif/test/result-baz \
	xmlif/test/result-bar

nobase_pkgdata_DATA = $(baseformats) \
	$(passivetexformats) \
	$(xhtml1formats) \
	xmlto.mak

EXTRA_DIST = xmlto.spec \
	FAQ \
	$(baseformats) \
	$(passivetexformats) \
	$(xhtml1formats) \
	$(xmliftests) \
	doc/xmlto.xml \
	doc/xmlif.xml \
	xmlto.mak

GEN_MANPAGE = FORMAT_DIR=$(top_srcdir)/format $(BASH) ./xmlto -o $(@D) man $<
man/man1/xmlto.1: doc/xmlto.xml ; $(GEN_MANPAGE)
man/man1/xmlif.1: doc/xmlif.xml ; $(GEN_MANPAGE)

TESTS_ENVIRONMENT = top_srcdir=$(top_srcdir) top_builddir=$(top_builddir)
TESTS = xmlif/test/run-test

CLEANFILES=$(dist_man1_MANS) \
	xmlif/test/test-no-condition \
	xmlif/test/test-unrelated-condition \
	xmlif/test/test-html \
	xmlif/test/test-pdf \
	xmlif/test/test-ps \
	xmlif/test/test-foo \
	xmlif/test/test-baz \
	xmlif/test/test-bar

tag:
	cvs tag -c `echo V@VERSION@ | tr . _`
