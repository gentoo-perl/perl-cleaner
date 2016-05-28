MANINC = man.include
VERSION=$(shell grep "PERL_CLEANER_VERSION=" ./perl-cleaner | sed -e 's:^PERL_CLEANER_VERSION=::' )
FILES=perl-cleaner perl-cleaner.1
PKGDIR=perl-cleaner-$(VERSION)
TARBALL=$(PKGDIR).tar.bz2

.PHONY: all clean tarball upload

all: perl-cleaner.1 tarball

perl-cleaner.1 : perl-cleaner $(MANINC)
	cp -a perl-cleaner perl-cleaner-saved
	sed -i -e 's:@GENTOO_PORTAGE_EPREFIX@::g' perl-cleaner
	help2man ./perl-cleaner --no-info --include $(MANINC) -o $@
	mv perl-cleaner-saved perl-cleaner

clean:
	rm -fr perl-cleaner.1 *.bz2 $(PKGDIR) perl-cleaner-saved || true

tarball: $(FILES)
	mkdir $(PKGDIR)
	cp $(FILES) $(PKGDIR)
	tar cjf $(TARBALL) $(PKGDIR)
	rm -fr $(PKGDIR)

upload:
	scp $(TARBALL) dev.gentoo.org:/space/distfiles-local
	ssh dev.gentoo.org chmod ugo+r /space/distfiles-local/$(TARBALL)

upload-home:
	scp $(TARBALL) dev.gentoo.org:~/public_html/distfiles/
	ssh dev.gentoo.org chmod ugo+r public_html/distfiles/$(TARBALL)
