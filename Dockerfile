FROM rocker/r-ver:4.0.2
LABEL maintainer="atyler"
RUN export DEBIAN_FRONTEND=noninteractive; apt-get -y update \
  && apt-get install -y libglpk-dev \
	libgmp-dev \
	libxml2-dev
RUN ["install2.r", "gProfileR", "here", "igraph", "pheatmap", "qtl2"]
RUN ["install2.r", "-r https://bioconductor.org/packages/3.11/bioc -r https://bioconductor.org/packages/3.11/data/annotation -r https://bioconductor.org/packages/3.11/data/experiment -r https://bioconductor.org/packages/3.11/workflows", "oposSOM"]
WORKDIR /payload/
CMD ["R"]
