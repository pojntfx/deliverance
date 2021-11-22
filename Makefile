# Public variables
OUTPUT_DIR ?= out

# Private variables
obj = $(shell ls docs/*.md | sed -r 's@docs/(.*).md@\1@g')
stc = $(shell ls docs/static)
formats = pdf slides.pdf html slides.html epub odt txt
all: build

# Build
build: build/archive
$(addprefix build/,$(obj)):
	$(MAKE) build-pdf/$(subst build/,,$@) build-slides.pdf/$(subst build/,,$@) build-html/$(subst build/,,$@) build-slides.html/$(subst build/,,$@) build-epub/$(subst build/,,$@) build-odt/$(subst build/,,$@) build-md/$(subst build/,,$@) build-gmi/$(subst build/,,$@) build-txt/$(subst build/,,$@)

# Build PDF
$(addprefix build-pdf/,$(obj)): build/qr
	mkdir -p "$(OUTPUT_DIR)"
	pandoc --template eisvogel --listings --shift-heading-level-by=-1 --number-sections --resource-path=docs -M titlepage=true -M toc=true -M toc-own-page=true -M linkcolor="{HTML}{006666}" -o "$(OUTPUT_DIR)/$(subst build-pdf/,,$@).pdf" "docs/$(subst build-pdf/,,$@).md"
	
# Build PDF slides
$(addprefix build-slides.pdf/,$(obj)): build/qr
	mkdir -p "$(OUTPUT_DIR)"
	pandoc --to beamer --listings --shift-heading-level-by=-1 --number-sections --resource-path=docs --slide-level=3 --variable theme=metropolis -o "$(OUTPUT_DIR)/$(subst build-slides.pdf/,,$@).slides.pdf" "docs/$(subst build-slides.pdf/,,$@).md"

# Build HTML
$(addprefix build-html/,$(obj)): build/qr
	mkdir -p "$(OUTPUT_DIR)"
	pandoc --to markdown --shift-heading-level-by=-1 --standalone "docs/$(subst build-html/,,$@).md" | pandoc --to html5 --listings --shift-heading-level-by=1 --number-sections --resource-path=docs --toc --katex --self-contained --number-offset=1 -o "$(OUTPUT_DIR)/$(subst build-html/,,$@).html"

# Build HTML slides
$(addprefix build-slides.html/,$(obj)): build/qr
	mkdir -p "$(OUTPUT_DIR)"
	pandoc --to slidy --listings --shift-heading-level-by=-1 --number-sections --resource-path=docs --toc --katex --self-contained -o "$(OUTPUT_DIR)/$(subst build-slides.html/,,$@).slides.html" "docs/$(subst build-slides.html/,,$@).md"

# Build EPUB
$(addprefix build-epub/,$(obj)): build/qr
	mkdir -p "$(OUTPUT_DIR)"
	pandoc --listings --shift-heading-level-by=-1 --number-sections --resource-path=docs -M titlepage=true -M toc=true -M toc-own-page=true -M linkcolor="{HTML}{006666}" -o "$(OUTPUT_DIR)/$(subst build-epub/,,$@).epub" "docs/$(subst build-epub/,,$@).md"

# Build ODT
$(addprefix build-odt/,$(obj)): build/qr
	mkdir -p "$(OUTPUT_DIR)"
	pandoc --listings --shift-heading-level-by=-1 --number-sections --resource-path=docs -M titlepage=true -M toc=true -M toc-own-page=true -M linkcolor="{HTML}{006666}" -o "$(OUTPUT_DIR)/$(subst build-odt/,,$@).odt" "docs/$(subst build-odt/,,$@).md"

# Build Markdown
$(addprefix build-md/,$(obj)): build/qr
	mkdir -p "$(OUTPUT_DIR)"
	pandoc --to html --shift-heading-level-by=-1 --standalone --self-contained --resource-path=docs "docs/$(subst build-md/,,$@).md" | pandoc --read html --to gfm --listings --shift-heading-level-by=1 --number-sections --resource-path=docs --toc --katex --self-contained --number-offset=1 -o "$(OUTPUT_DIR)/$(subst build-md/,,$@).md"

# Build Gemtext
$(addprefix build-gmi/,$(obj)): build/qr
	rm -rf "$(OUTPUT_DIR)/$(subst build-gmi/,,$@).gmi"
	mkdir -p "$(OUTPUT_DIR)/$(subst build-gmi/,,$@).gmi/static"
	md2gemini --frontmatter -d "$(OUTPUT_DIR)/$(subst build-gmi/,,$@).gmi" -w "docs/$(subst build-gmi/,,$@).md"
	$(foreach st,$(stc),cp docs/static/$(st) "$(OUTPUT_DIR)/$(subst build-gmi/,,$@).gmi/static/$(st)";)
	tar czvf "$(OUTPUT_DIR)/$(subst build-gmi/,,$@).gmi.gz" -C "$(OUTPUT_DIR)/$(subst build-gmi/,,$@).gmi" .
	rm -rf "$(OUTPUT_DIR)/$(subst build-gmi/,,$@).gmi"

# Build txt
$(addprefix build-txt/,$(obj)): build/qr
	mkdir -p "$(OUTPUT_DIR)"
	pandoc --to plain --listings --shift-heading-level-by=-1 --number-sections --resource-path=docs --toc --self-contained -o "$(OUTPUT_DIR)/$(subst build-txt/,,$@).txt" "docs/$(subst build-txt/,,$@).md"

# Build metadata
build/metadata:
	mkdir -p "$(OUTPUT_DIR)"
	git log > "$(OUTPUT_DIR)"/CHANGELOG.txt
	cp LICENSE "$(OUTPUT_DIR)"/LICENSE.txt
	pandoc --shift-heading-level-by=-1 --to markdown --standalone "README.md" | pandoc --to html5 --listings --shift-heading-level-by=1 --number-sections --resource-path=docs --toc --katex --self-contained --number-offset=1 -o "$(OUTPUT_DIR)/README.html"

# Build QR code
build/qr:
	mkdir -p docs/static
	qr "https://$$(git remote get-url origin | sed -r 's|^.*@(.*):|\1/|g' | sed 's@.*://@@g' | sed 's/.git$$//g')" | tee docs/static/qr.png>/dev/null

# Build tarball
build/tarball: build/qr build/metadata
	mkdir -p "$(OUTPUT_DIR)"
	tar czvf "$(OUTPUT_DIR)"/source.tar.gz --exclude-from=.gitignore --exclude=.git --exclude="$(OUTPUT_DIR)" .

# Build tree
build/tree: $(addprefix build/,$(obj)) build/tarball
	mkdir -p "$(OUTPUT_DIR)"
	tree -T "$$(git remote get-url origin | sed -r 's|^.*@(.*):|\1/|g' | sed 's@.*://@@g' | sed 's/.git$$//g')" --du -h -D -H . -I 'index.html|release.tar.gz|release.zip' -o "$(OUTPUT_DIR)"/index.html "$(OUTPUT_DIR)"

# Build archive
build/archive: build/tree
	mkdir -p "$(OUTPUT_DIR)"
	tar czvf "$(OUTPUT_DIR)"/release.tar.gz -C "$(OUTPUT_DIR)" --exclude="release.tar.gz" --exclude="release.zip" $(shell ls $(OUTPUT_DIR))
	rm -f "$(OUTPUT_DIR)"/release.zip
	zip -j -x 'release.tar.gz' -x 'release.zip' -FSr "$(OUTPUT_DIR)"/release.zip "$(OUTPUT_DIR)"/*

# Open
$(foreach o,$(obj),$(foreach f,$(formats),open-$(f)/$(o))):
	xdg-open "$(OUTPUT_DIR)/$(notdir $(subst open-,,$@)).$(subst /,,$(dir $(subst open-,,$@)))"

# Develop
dev: build
	while inotifywait -r -e close_write --exclude 'out' .; do $(MAKE); done
$(foreach o,$(obj),$(foreach f,$(formats),dev-$(f)/$(o))):
	$(MAKE) $(subst dev-,build-,$@)
	while inotifywait -r -e close_write --exclude 'out' .; do $(MAKE) $(subst dev-,build-,$@); done

# Clean
clean:
	rm -rf "$(OUTPUT_DIR)" docs/static/qr.png

# Dependencies
depend:
	pip install pillow qrcode md2gemini
	curl -L -o /tmp/Eisvogel.zip 'https://github.com/Wandmalfarbe/pandoc-latex-template/releases/latest/download/Eisvogel.zip'
	mkdir -p "$${HOME}/.local/share/pandoc/templates"
	unzip -p /tmp/Eisvogel.zip eisvogel.latex | tee "$${HOME}/.local/share/pandoc/templates/eisvogel.latex">/dev/null
