PDF_FILES := $(wildcard attachments*/*/*.pdf)

process_pdf_files: $(PDF_FILES)

$(PDF_FILES): FORCE
	echo "Processing $@"
	convert -density 150 -define png:exclude-chunks=date,time $@ $$(dirname $@)/%d.png
	# pdf2svg $@ $$(dirname $@)/%d.svg all

FORCE:

.PHONY: process_pdf_files
