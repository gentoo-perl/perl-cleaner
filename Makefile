MANINC = man.include
VERSION=$(shell ./perl-cleaner --version)
FILES=perl-cleaner perl-cleaner.1
PKGDIR=perl-cleaner-$(VERSION)
TARBALL=$(PKGDIR).tar.bz2

.PHONY: all clean tarball upload

all: perl-cleaner.1 tarball

perl-cleaner.1 : perl-cleaner $(MANINC)
	help2man ./perl-cleaner --no-info --include $(MANINC) -o $@

clean:
	rm -fr perl-cleaner.1 *.bz2 $(PKGDIR) || true

tarball: $(FILES)
	mkdir $(PKGDIR)
	cp $(FILES) $(PKGDIR)
	tar cjf $(TARBALL) $(PKGDIR)
	rm -fr $(PKGDIR)

upload:
	scp $(TARBALL) dev.gentoo.org:/space/distfiles-local
	ssh dev.gentoo.org chmod ugo+r /space/distfiles-local/$(TARBALL)
