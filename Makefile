TXT = ./fcsreport.txt

all: adaptor.tab mito.tab exclude.tab adaptor1.tab ~/whale-shark.cleaned.contigs.draft.v1.fasta ~/whale-shark.cleaned.contig2s.draft.v1.fasta

adaptor.tab: $(TXT)
	grep 'cvg' $(TXT) | grep '\.\.' | awk '{print $$1" "$$3}' | sed 's/,/ /' | sed 's/\.\./ /g' > adaptor.tab

adaptor1.tab: adaptor.tab
	cat adaptor.tab | awk '{if ($$4) print $$1" "$$4" "$$5}' > adaptor1.tab
	cat adaptor.tab | awk '{print $$1" "$$2" "$$3}' > adaptor2.tab	


mito.tab: $(TXT)
	grep 'cvg' $(TXT) | grep 'mitochondrion' | awk '{print $$1}' > mito.tab
	cat mito.tab | awk '{print $1",mitochondrion,no,yes"}' > mito.csv
	
exclude.tab: $(TXT)
	grep 'cvg' $(TXT) | grep -v 'mitochondrion' | grep -v '\.\.' | awk '{print $$1}' > exclude.tab
	
~/whale-shark.cleaned.contigs.draft.v1.fasta: ~/whale-shark.contigs.draft.v1-genbank.fasta.gz adaptor.tab exclude.tab adaptor1.tab
	Rscript -e "library(knitr); knit('./wc_v1.Rmd')" 

~/whale-shark.cleaned.contig2s.draft.v1.fasta: ~/whale-shark.cleaned.contigs.draft.v1.fasta rename-fasta-header.py mito.tab
	cat ~/whale-shark.cleaned.contigs.draft.v1.fasta | ./rename-fasta-header.py mito.tab "[location=mitochondrion]"  > ~/whale-shark.cleaned.contig2s.draft.v1.fasta
	gzip ~/whale-shark.cleaned.contig2s.draft.v1.fasta
	
clean:
	rm ~/whale-shark.cleaned.contigs.draft.v1.fasta

