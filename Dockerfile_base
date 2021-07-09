## This file builds the base docker image from the
## cape image, and adds a few more packages for the 
## additional analyses

FROM annatyler/cape2:latest
LABEL maintainer="atyler"
RUN export DEBIAN_FRONTEND=noninteractive; apt-get -y update \
  && apt-get install -y libglpk-dev \
	libgmp-dev \
	libssl-dev \
	libxml2-dev \
	pandoc \
	pandoc-citeproc \
	zlib1g-dev

RUN ["install2.r", "pheatmap", "rticles", "tinytex", "gprofiler2", "cluster", "knitr"]
RUN R -e "BiocManager::install('AnnotationDbi')"
RUN R -e "BiocManager::install('GO.db')"
RUN R -e "BiocManager::install('preprocessCore')"
RUN R -e "BiocManager::install('impute')"
RUN R -e "BiocManager::install('GOSim')"
RUN R -e "BiocManager::install('sva')"
RUN R -e "BiocManager::install('limma')"
RUN R -e "devtools::install_github('juanbot/CoExpNets')"

CMD ["R"]
