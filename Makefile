NAME=debian_packages_cmd

# rst2html options ############################################################

# See man rst2html for more information

TITLE="Commandes utiles pour l'administration des paquets Debian"

#LANGUAGE=en
LANGUAGE=fr

MATH_OUTPUT="MathJax"

SOURCE_URL="https://github.com/jdhp-docs"

###############################################################################

#all: $(NAME).html $(NAME)_slides.html
all: $(NAME).html $(NAME).pdf

.PHONY : all clean init

SRCFILES=$(wildcard *.rst) Makefile

## ARTICLE ##

$(NAME).html: $(SRCFILES)
	rst2html --title=$(TITLE) --date --time --generator \
		--language=$(LANGUAGE) --tab-width=4 --math-output=$(MATH_OUTPUT) \
		--source-url=$(SOURCE_URL) \
		$(NAME).rst $@

#$(NAME).pdf: $(SRCFILES)
#	rst2pdf -o $@ $(NAME).rst

$(NAME).pdf: $(SRCFILES)
	#pandoc --toc -N  -V papersize:"a4paper" -V geometry:"top=2cm, bottom=3cm, left=2cm, right=2cm" -V "fontsize:12pt" -o $@ $(NAME).rst
	pandoc --toc -N  -V papersize:"a4paper" -V "fontsize:12pt" -o $@ $(NAME).rst

## SLIDES ##

$(NAME)_slides.html: $(SRCFILES)
	rst2s5 --title=$(TITLE) --date --time --generator \
		--language=$(LANGUAGE) --tab-width=4 --math-output=$(MATH_OUTPUT) \
		--source-url=$(SOURCE_URL) \
		$(NAME).rst $@

## CLEAN ##

clean:
	@rm -rvf $(NAME).html $(NAME)_slides.html $(NAME).pdf ui/

init: clean
