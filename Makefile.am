bin_SCRIPTS = xmlto
bin_PROGRAMS = xmlif/xmlif
man1_MANS = man/man1/xmlto.1 man/man1/xmlif.1

xmlif_xmlif_SOURCES = xmlif/xmlif.l

nobase_pkgdata_DATA = format/docbook/dvi \
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
	format/fo/dvi \
	format/fo/pdf \
	format/fo/ps \
  format/fo/awt \
  format/fo/mif \
  format/fo/pcl \
  format/fo/svg \
  format/fo/txt \
  format/xhtml1/dvi \
  format/xhtml1/fo \
  format/xhtml1/pdf \
  format/xhtml1/ps \
  format/xhtml1/txt \
	xmlto.mak

EXTRA_DIST = xmlto.spec \
	FAQ \
	format/docbook/fo \
	format/docbook/dvi \
	format/docbook/html \
	format/docbook/html-nochunks \
	format/docbook/htmlhelp \
	format/docbook/javahelp \
	format/docbook/man \
	format/docbook/pdf \
	format/docbook/ps \
	format/docbook/txt \
	format/docbook/xhtml \
	format/docbook/xhtml-nochunks \
  format/docbook/mif \
  format/docbook/pcl \
  format/docbook/svg \
  format/docbook/awt \
	format/fo/dvi \
	format/fo/pdf \
	format/fo/ps \
  format/fo/awt \
  format/fo/mif \
  format/fo/pcl \
  format/fo/svg \
  format/fo/txt \
  format/xhtml1/dvi \
  format/xhtml1/fo \
  format/xhtml1/pdf \
  format/xhtml1/ps \
  format/xhtml1/txt \
	doc/xmlto.xml \
	doc/xmlif.xml \
	xmlto.mak \
	xmlif/test/run-test \
	xmlif/test/test.xml \
	xmlif/test/result-no-condition \
	xmlif/test/result-unrelated-condition \
	xmlif/test/result-html \
	xmlif/test/result-pdf \
	xmlif/test/result-ps \
	xmlif/test/result-foo \
	xmlif/test/result-baz \
	xmlif/test/result-bar

$(man1_MANS): $(top_srcdir)/doc/xmlto.xml $(top_srcdir)/doc/xmlif.xml
	for xml in xmlif.xml xmlto.xml; do \
	  FORMAT_DIR=$(top_srcdir)/format \
	   $(BASH) ./xmlto -o man/man1 man $(top_srcdir)/doc/$$xml ; \
	done || ( RC=$$?; cat $(top_srcdir)/FAQ; exit $$RC )

TESTS_ENVIRONMENT = top_srcdir=$(top_srcdir) top_builddir=$(top_builddir)
TESTS = xmlif/test/run-test

CLEANFILES=$(man1_MANS) \
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
