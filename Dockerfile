FROM bioconductor/bioconductor_docker:devel
LABEL maintainer="atyler"
RUN export DEBIAN_FRONTEND=noninteractive; apt-get -y update \
  && apt-get install -y libglpk-dev \
	libgmp-dev \
	libxml2-dev \ 
	libcurl4-openssl-dev \ 
	pandoc \
	pandoc-citeproc

RUN install2.r --error \
	bitops \ 
	bnstruct \ 
	cluster \ 
	corpcor \
 	gprofiler2 \ 
	igraph \ 
	Matrix \ 
	pheatmap \ 
	qtl2 \ 
	RGCCA

RUN R -e 'BiocManager::install(c("AnnotationDbi", "Biobase", "BiocGenerics", "GOSemSim", "IRanges", "org.Mm.eg.db", "S4Vectors"))'


WORKDIR /payload/
CMD ["R"]
