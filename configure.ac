AC_INIT([libbutter], [0.2], [mail@jensge.org], [libbutter])
AC_CONFIG_SRCDIR([Makefile.am])
AC_CONFIG_HEADERS([config.h])
AM_INIT_AUTOMAKE([dist-bzip2])
AM_MAINTAINER_MODE

AC_PROG_CC
AM_PROG_CC_C_O
AC_DISABLE_STATIC
AM_PROG_LIBTOOL


AC_SUBST(CFLAGS)
AC_SUBST(CPPFLAGS)
AC_SUBST(LDFLAGS)

VALA_REQUIRED=0.7.5
GLIB_REQUIRED=2.10
GEE_REQUIRED=0.1

AC_ARG_ENABLE(vala, [--enable-vala enable checks for vala],,enable_vala=no)

if test x$enable_vala = xyes ; then
    PKG_CHECK_MODULES(VALA, [vala-1.0 >= $VALA_REQUIRED])

    AC_PATH_PROG(VALAC, valac, no)
    AC_SUBST(VALAC)

    if test "x$VALAC" = "xno"; then
        AC_MSG_ERROR([Cannot find the "valac" compiler in your path])
    fi
fi

PKG_CHECK_MODULES(GLIB, glib-2.0 >= $GLIB_REQUIRED gobject-2.0 >=
                  $GLIB_REQUIRED gio-2.0 >= $GLIB_REQUIRED)
AC_SUBST(GLIB_CFLAGS)
AC_SUBST(GLIB_LIBS)

PKG_CHECK_MODULES(GEE, gee-1.0 >= $GEE_REQUIRED)
AC_SUBST(GEE_CFLAGS)
AC_SUBST(GEE_FLAGS)

AC_CONFIG_FILES([Makefile
                 butter-1.0.pc
                 src/Makefile])

AC_OUTPUT
