EXT = \
	ext/bashplus/lib \
	ext/test-tap-bash/lib \

.PHONY: test
test: $(EXT)
	prove $(PROVEOPT:%=% )test/

$(EXT):
	git submodule update --init

install: doc ext lib test/setup
	@ if [ "X$(INSTALLDIR)" = "X" ] ; then \
	      echo "Usage: make install INSTALLDIR=/some/dir" ; false; \
	  fi;
	@ [ -d $(INSTALLDIR) ] || mkdir -p $(INSTALLDIR)
	$(eval absinstalldir=$(abspath $(INSTALLDIR)))
	@ echo Installing to $(absinstalldir)
	@ for d in doc ext lib ; do cp -rpfP $$d $(absinstalldir) ; done;
	@ for f in setup README ; do \
	      [ ! -f $(absinstalldir)/$$f ] || rm -f $(absinstalldir)/$$f ; \
	  done
	@ sed -e 's?^#INSTALLDIR=@@INSTALLDIR@@?INSTALLDIR=$(absinstalldir)?' test/setup > $(absinstalldir)/setup
	@ echo "This is 'test-more-bash'. To use, "    > $(absinstalldir)/README
	@ echo "  source $(absinstalldir)/setup"      >> $(absinstalldir)/README
	@ echo "See doc/ for more detail."            >> $(absinstalldir)/README

