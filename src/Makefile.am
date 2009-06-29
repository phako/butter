NULL =

AM_CPPFLAGS = \
			  -I$(top_srcdir) \
			  $(GLIB_CFLAGS) \
			  $(GEE_CFLAGS) \
			  $(NULL)

BUILT_SOURCES = butter.vala.stamp

lib_LTLIBRARIES = \
				  libbutter.la \
				  $(NULL)

libbutter_la_VALASOURCES = \
						   butter-filesystem-walker.vala \
						   butter-aggregate-file-monitor.vala \
						   $(NULL)

libbutter_la_SOURCES = \
					   butter.vala.stamp \
					   $(libbutter_la_VALASOURCES:.vala=.c) \
					   butter.h \
					   $(NULL)

butterincludedir = $(includedir)/butter-1.0

butterinclude_HEADERS = \
						butter.h \
						$(NULL)

butter-1.0.vapi butter.vala.stamp: $(libbutter_la_VALASOURCES)
	$(VALAC) -C -H butter.h \
		--basedir $(top_srcdir) \
		--pkg gio-2.0 \
		--pkg gee-1.0 \
		--pkg cstuff \
		--vapidir $(top_srcdir)/src \
		--library butter-1.0 $^
	touch $@

libbutter_la_LIBADD = \
					  $(GLIB_LIBS) \
					  $(GEE_LIBS) \
					  $(NULL)

vapidir = $(datadir)/vala/vapi

dist_vapi_DATA = \
				 butter-1.0.vapi \
				 $(NULL)

EXTRA_DIST = $(libbutter_la_VALASOURCES) butter-1.0.vapi butter.vala.stamp
