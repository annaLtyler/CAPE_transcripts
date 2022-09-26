FROM rocker/r-ver:4.0.2
LABEL maintainer="atyler"
RUN export DEBIAN_FRONTEND=noninteractive; apt-get -y update \
  && apt-get install -y git-core \
	libcurl4-openssl-dev \
	libglpk-dev \
	libgmp-dev \
	libxml2-dev \
	make \
	pandoc \
	pandoc-citeproc
RUN ["install2.r", "DescTools", "doParallel", "DT", "e1071", "foreach", "gprofiler2", "here", "igraph", "iterators", "knitr", "Matrix", "pheatmap", "qtl2", "R.methodsS3", "R.oo", "R.utils", "RCurl", "remotes", "XML"]
RUN ["installGithub.r", "wesleycrouse/bmediatR@28a47c71a0c2b9d0f1b76ca2e5d9911808ab25fe"]
WORKDIR /payload/
CMD ["R"]
