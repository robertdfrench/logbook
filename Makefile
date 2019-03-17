SHELL=zsh
ROOT=$(dir $(MAKEFILE_LIST))
template=$(abspath $(ROOT)/template.html)
makefile=$(abspath $(ROOT)/Makefile)
timer=$(abspath $(ROOT)/timer.awk)
calculator=$(abspath $(ROOT)/calculate.awk)
target=

.PHONY: subdir_cache build view clean

view: build
	open index.html

build:
	ls -d */ | xargs -n1 -I % make -f $(makefile) -C % build
	@echo "\n# Building $(shell pwd)"
	make -f $(makefile) subdir_cache
	make -f $(makefile) index.html
	make -f $(makefile) log.html
	make -f $(makefile) tc.html

subdir_cache: 
	HASH=$$(echo $^ | md5) && \
	     if [ ! -e subdirs.md5 ]; then echo "$$HASH" > subdirs.md5; fi && \
	     if [ ! "$$HASH" = $$(cat subdirs.md5) ]; then echo "$$HASH" >! subdirs.md5; fi

index.html: $(template) TOC.md README.md
	cat $< \
		| perl -pe 's/TOC/`markdown TOC.md`/ge' \
		| perl -pe 's/CONTENT/`markdown README.md`/ge' \
		| perl -pe 's/README_ACTIVE/active/g' \
		| perl -pe 's/LOG_ACTIVE//g' \
		| perl -pe 's/TC_ACTIVE//g' \
		> $@

log.html: $(template) TOC.md LOG.md
	cat $< \
		| perl -pe 's/TOC/`markdown TOC.md`/ge' \
		| perl -pe 's/CONTENT/`markdown LOG.md`/ge' \
		| perl -pe 's/README_ACTIVE//g' \
		| perl -pe 's/LOG_ACTIVE/active/g' \
		| perl -pe 's/TC_ACTIVE//g' \
		> $@

tc.html: $(template) TOC.md timecard.html
	cat $< \
		| perl -pe 's/TOC/`markdown TOC.md`/ge' \
		| perl -pe 's/CONTENT/`cat timecard.html`/ge' \
		| perl -pe 's/README_ACTIVE//g' \
		| perl -pe 's/LOG_ACTIVE//g' \
		| perl -pe 's/TC_ACTIVE/active/g' \
		> $@

LOG.md:
	git log --format='##### %s%n*%ci*%n%b' --follow . > $@

README.md:
	echo "# $(notdir $(shell pwd))" > $@

TOC.md: subdirs.md5
	echo "##### Depends On:" > $@
	echo $(subst /index.html,,$(shell ls */index.html)) \
		| xargs -n1 -I % echo "* ["%"]("%"/index.html)" \
		>> $@

clean:
	ls -d */ \
		| sed 's/\///g' \
		| xargs -n1 -I % make -f $(makefile) -C % clean
	@echo "\n# Cleaning $(shell pwd)"
	rm -f index.html TOC.md subdirs.md5 LOG.md log.html tc.html timecard.txt timecard.md timecard.html

new:
	@$(if $(target),$(info Creating $(target)),$(error please define a target))
	@if [ ! -d $(target) ]; then mkdir $(target); fi
	@touch $(target)/README.md && $$EDITOR $(target)/README.md
	@git add $(target)/README.md

timecard.txt: $(timer)
	git log --format='%h %ci %s' --reverse | awk -f $(timer) > $@

timecard.html: timecard.txt $(calculator)
	echo "<table class=\"table\">" > $@
	echo "<thead><tr><th scope=\"col\">Date</th><th scope=\"col\">In</th><th scope=\"col\">Out</th><th scope=\"col\">Total</th></tr></thead>" >> $@
	echo "<tbody>" >> $@
	awk -f $(calculator) timecard.txt | bash >> $@
	echo "</tbody>" >> $@
	echo "</table>" >> $@
