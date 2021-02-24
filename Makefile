# dwm - dynamic window manager
# See LICENSE file for copyright and license details.

include config.mk

SRC = anjayw.c anjaywm.c util.c
#SRC = drw.c dwm.c util.c
OBJ = ${SRC:.c=.o}

all: options anjaywm dwm-msg

options:
	@echo dwm build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk

config.h:
	cp config.def.h $@

anjaywm: ${OBJ}
	${CC} -o $@ ${OBJ} ${LDFLAGS}

dwm-msg: dwm-msg.o
	${CC} -o $@ $< ${LDFLAGS}

clean:
	rm -f anjaywm dwm-msg ${OBJ} anjaywm-${VERSION}.tar.gz *.rej config.h

dist: clean
	mkdir -p anjaywm-${VERSION}
	cp -R LICENSE Makefile README config.def.h config.mk\
		dwm.1 anjayw.h util.h ${SRC} dwm.png transient.c anjaywm-${VERSION}
	tar -cf anjaywm-${VERSION}.tar anjaywm-${VERSION}
	gzip anjaywm-${VERSION}.tar
	rm -rf anjaywm-${VERSION}

install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f anjaywm dwm-msg ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/anjaywm
	chmod 755 ${DESTDIR}${PREFIX}/bin/dwm-msg
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	sed "s/VERSION/${VERSION}/g" < dwm.1 > ${DESTDIR}${MANPREFIX}/man1/dwm.1
	chmod 644 ${DESTDIR}${MANPREFIX}/man1/dwm.1

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/anjaywm\
		${DESTDIR}${MANPREFIX}/man1/dwm.1

.PHONY: all options clean dist install uninstall
