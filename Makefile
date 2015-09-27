NAME=debian_packages_cmd

# RST2HTML OPTIONS ############################################################

# See man rst2html for more information

TITLE="Commandes utiles pour l'administration des paquets Debian"

#LANGUAGE=en
LANGUAGE=fr

MATH_OUTPUT="MathJax"

SOURCE_URL="https://github.com/jdhp-docs/debian_packages_cmd"

STYLESHEET="rst2html.css"

# JDHP OPTIONS ################################################################

JDHP_PDF_DIR=~/git/pub/projects/jdhp/files/pdf
#JDHP_HEVEA_DIR=~/git/pub/projects/jdhp/files/hevea
# HEVEA doit être mis dans www plutot que dans download pour les stats et le référencement...
JDHP_HEVEA_DIR=~/git/pub/projects/jdhp/jdhp/hevea
JDHP_UPLOAD_PDF_SCRIPT=~/git/pub/projects/jdhp/files_upload.sh
JDHP_UPLOAD_HEVEA_SCRIPT=~/git/pub/projects/jdhp/jdhp/sync_hevea.sh

###############################################################################

#all: $(NAME).html $(NAME)_slides.html $(NAME).pdf
all: $(NAME).html $(NAME).pdf

.PHONY : all clean init jdhp html pdf

SRCFILES=$(wildcard *.rst) Makefile

## ARTICLE ####################################################################

# HTML ############

html: $(NAME).html

$(NAME).html: $(SRCFILES)
	rst2html --title=$(TITLE) --date --time --generator \
		--language=$(LANGUAGE) --tab-width=4 --math-output=$(MATH_OUTPUT) \
		--source-url=$(SOURCE_URL) --stylesheet=$(STYLESHEET) \
		--section-numbering --embed-stylesheet --strip-comments \
		$(NAME).rst $@

# PDF #############

pdf: $(NAME).pdf

$(NAME).pdf: $(SRCFILES)
	#rst2pdf -o $@ $(NAME).rst
	#pandoc --toc -N  -V papersize:"a4paper" -V geometry:"top=2cm, bottom=3cm, left=2cm, right=2cm" -V "fontsize:12pt" -o $@ $(NAME).rst
	pandoc --toc -N  -V papersize:"a4paper" -V "fontsize:12pt" -o $@ $(NAME).rst

## SLIDES #####################################################################

$(NAME)_slides.html: $(SRCFILES)
	rst2s5 --title=$(TITLE) --date --time --generator \
		--language=$(LANGUAGE) --tab-width=4 --math-output=$(MATH_OUTPUT) \
		--source-url=$(SOURCE_URL) \
		$(NAME).rst $@

## JDHP #######################################################################

jdhp:$(NAME).pdf $(NAME).html
	# Copy PDF
	cp -v $(NAME).pdf  $(JDHP_PDF_DIR)/
	# Copy HTML
	@rm -rf $(JDHP_HEVEA_DIR)/$(NAME)
	@mkdir $(JDHP_HEVEA_DIR)/$(NAME)
	cp -v $(NAME).html $(JDHP_HEVEA_DIR)/$(NAME)
	cp -vr fig $(JDHP_HEVEA_DIR)/$(NAME)
	# Sync
	$(JDHP_UPLOAD_PDF_SCRIPT)
	$(JDHP_UPLOAD_HEVEA_SCRIPT)

## CLEAN ######################################################################

clean:
	@echo "suppression des fichiers de compilation"
	@rm -rvf ui/

init: clean
	@echo "suppression des fichiers cibles"
	@rm -vf $(NAME).pdf
	@rm -vf $(NAME).html
	@rm -vf $(NAME)_slides.html

