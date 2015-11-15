INSTALL=install
ASTLIBDIR:=$(shell awk '/moddir/{print $$3}' /etc/asterisk/asterisk.conf)
ifeq ($(strip $(ASTLIBDIR)),)
	MODULES_DIR=$(INSTALL_PREFIX)/usr/lib/asterisk/modules
else
	MODULES_DIR=$(INSTALL_PREFIX)$(ASTLIBDIR)
endif
ASTETCDIR=$(INSTALL_PREFIX)/etc/asterisk

CC=gcc
OPTIMIZE=-O2
DEBUG=-g


LIBS+=-lxml -lneon -lical
CFLAGS+=-pipe -fPIC -Wall -Wextra -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations -D_REENTRANT -D_GNU_SOURCE -DAST_MODULE=\"res_calendar_caldav\"

all: _all

_all: res_calendar_caldav.so res_calendar.so

res_calendar_caldav.o: res_calendar_caldav.c
	$(CC) $(CFLAGS) $(DEBUG) $(OPTIMIZE) -c -o res_calendar_caldav.o res_calendar_caldav.c

res_calendar_caldav.so: res_calendar_caldav.o
	$(CC) -shared -Xlinker -x -o $@ $< $(LIBS)

res_calendar.o: res_calendar.c
	$(CC) $(CFLAGS) $(DEBUG) $(OPTIMIZE) -c -o res_calendar.o res_calendar.c

res_calendar.so: res_calendar.o
	$(CC) -shared -Xlinker -x -o $@ $< $(LIBS)


clean:
	rm -f *.o *.so .*.d

install: _all
	$(INSTALL) -m 755 -d $(DESTDIR)$(MODULES_DIR)
	$(INSTALL) -m 755 res_calendar_caldav.so $(DESTDIR)$(MODULES_DIR)
	$(INSTALL) -m 755 res_calendar.so $(DESTDIR)$(MODULES_DIR)
	@echo " +---- app_espeak Installation Complete -----+"
	@echo " +                                           +"
	@echo " + app_espeak has successfully been installed+"





