FROM rocker/r-ver:4.0.2
LABEL maintainer="atyler"
RUN export DEBIAN_FRONTEND=noninteractive; apt-get -y update \
  && apt-get install -y libglpk-dev \
	libgmp-dev \
	libxml2-dev
RUN ["install2.r", "gProfileR", "here", "igraph", "pheatmap", "qtl2","PMA", "abind", "cluster", "RColorBrewer", "corpcor", "easyPubmed", "knitr", "kableExtra", "ape"]
RUN ["install2.r", "-r https://bioconductor.org/packages/3.11/bioc -r https://bioconductor.org/packages/3.11/data/annotation -r https://bioconductor.org/packages/3.11/data/experiment -r https://bioconductor.org/packages/3.11/workflows", "oposSOM"]
RUN ["install2.r", "-r https://bioconductor.org/packages/3.11/bioc -r https://bioconductor.org/packages/3.11/data/annotation -r https://bioconductor.org/packages/3.11/data/experiment -r https://bioconductor.org/packages/3.11/workflows", "simplifyEnrichment"]
WORKDIR /payload/
CMD ["R"]
