ARG DOCKER_REGISTRY=docker.io
ARG DOCKER_REPO=qspack
ARG FROM_IMG_NAME="ubuntu-hwloc"
ARG FROM_IMG_TAG="latest"
ARG FROM_IMG_HASH=""
FROM ${DOCKER_REGISTRY}/${DOCKER_REPO}/${FROM_IMG_NAME}:${FROM_IMG_TAG}${DOCKER_IMG_HASH}

ARG OPENMPI_VERSION=2.0.1
ENV OPENMPI_VERSION=${OPENMPI_VERSION}
LABEL qnib.spack.openmpi.version=${OPENMPI_VERSION}
RUN /usr/local/src/spack/bin/spack install --no-checksum openmpi@${OPENMPI_VERSION} \
            ^hwloc@${HWLOC_VERSION} \
            ^libtool@${LIBTOOL_VERSION}
ENV PATH=${PATH}:/usr/local/openmpi/bin
RUN mkdir -p /usr/local/openmpi \
 && ln -s $(/usr/local/src/spack/bin/spack location --install-dir openmpi)/bin /usr/local/openmpi/bin
COPY src/hello_mpi.c src/ring.c /usr/local/src/mpi/
RUN mpicc -o /usr/local/bin/hello /usr/local/src/mpi/hello_mpi.c \
 && mpicc -o /usr/local/bin/ring /usr/local/src/mpi/ring.c
