FROM r-base:latest
LABEL maintainer="atyler"
RUN export DEBIAN_FRONTEND=noninteractive; apt-get -y update \
  && apt-get install -y libglpk-dev \
	libgmp-dev \
	libxml2-dev \
	pandoc
RUN ["install2.r", "bitops", "bnstruct", "cluster", "corpcor", "gprofiler2", "here", "igraph", "Matrix", "pheatmap", "qtl2", "RColorBrewer", "RGCCA", "rmarkdown", "wordcloud"]
RUN ["install2.r", "-r https://bioconductor.org/packages/3.11/bioc -r https://bioconductor.org/packages/3.11/data/annotation -r https://bioconductor.org/packages/3.11/data/experiment -r https://bioconductor.org/packages/3.11/workflows", "AnnotationDbi", "Biobase", "BiocGenerics", "GOSemSim", "IRanges", "org.Mm.eg.db", "S4Vectors"]
WORKDIR /payload/
CMD ["R"]
