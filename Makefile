# Makefile

SHELL := sh -e

LANGUAGES = de

all: test install

test:
	# Checking for syntax errors
	for SCRIPT in live-helper.sh cgi/* functions/* examples/*/*.sh helpers/* hooks/*; \
	do \
		sh -n $${SCRIPT}; \
	done

	# Checking for bashisms
	if [ -x /usr/bin/checkbashisms ]; \
	then \
		checkbashisms live-helper.sh functions/* examples/*/*.sh helpers/* hooks/*; \
	else \
		echo "WARNING: skipping bashism test - you need to install devscripts."; \
	fi

build:
	@echo "Nothing to build."

install:
	# Installing shared data
	mkdir -p $(DESTDIR)/usr/share/live-helper
	cp -r cgi data examples live-helper.sh functions helpers hooks includes lists repositories templates $(DESTDIR)/usr/share/live-helper

	# Installing executables
	mkdir -p $(DESTDIR)/usr/bin
	mv $(DESTDIR)/usr/share/live-helper/helpers/lh $(DESTDIR)/usr/share/live-helper/helpers/live-helper $(DESTDIR)/usr/bin

	# Installing documentation
	mkdir -p $(DESTDIR)/usr/share/doc/live-helper
	cp -r COPYING docs/* $(DESTDIR)/usr/share/doc/live-helper

	# Installing manpages
	for MANPAGE in manpages/en/*; \
	do \
		SECTION="$$(basename $${MANPAGE} | awk -F. '{ print $$2 }')"; \
		install -D -m 0644 $${MANPAGE} $(DESTDIR)/usr/share/man/man$${SECTION}/$$(basename $${MANPAGE} .en.$${SECTION}).$${SECTION}; \
	done

	for LANGUAGE in $(LANGUAGES); \
	do \
		for MANPAGE in manpages/$${LANGUAGE}/*; \
		do \
			SECTION="$$(basename $${MANPAGE} | awk -F. '{ print $$3 }')"; \
			install -D -m 0644 $${MANPAGE} $(DESTDIR)/usr/share/man/$${LANGUAGE}/man$${SECTION}/$$(basename $${MANPAGE} .$${LANGUAGE}.$${SECTION}).$${SECTION}; \
		done; \
	done

	# Installing logfile
	mkdir -p $(DESTDIR)/var/log

uninstall:
	# Uninstalling shared data
	rm -rf $(DESTDIR)/usr/share/live-helper

	# Uninstalling executables
	rm -f $(DESTDIR)/usr/bin/lh $(DESTDIR)/usr/bin/live-helper

	# Uninstalling documentation
	rm -rf $(DESTDIR)/usr/share/doc/live-helper

	# Uninstalling manpages
	for MANPAGE in manpages/en/*; \
	do \
		SECTION="$$(basename $${MANPAGE} | awk -F. '{ print $$2 }')"; \
		rm -f $(DESTDIR)/usr/share/man/man$${SECTION}/$$(basename $${MANPAGE} .en.$${SECTION}).$${SECTION}; \
	done

	for LANGUAGE in $(LANGUAGES); \
	do \
		for MANPAGE in manpages/$${LANGUAGE}/*; \
		do \
			SECTION="$$(basename $${MANPAGE} | awk -F. '{ print $$3 }')"; \
			rm -f $(DESTDIR)/usr/share/man/$${LANGUAGE}/man$${SECTION}/$$(basename $${MANPAGE} .$${LANGUAGE}.$${SECTION}).$${SECTION}; \
		done; \
	done

clean:

distclean:

reinstall: uninstall install
