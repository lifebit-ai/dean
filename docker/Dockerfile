FROM nfcore/base
LABEL authors="phil@lifebit.ai" \
      description="Docker image containing base requirements for differential expression analysis with deseq2"

COPY environment.yml /
RUN conda env create -f /environment.yml && conda clean -a
ENV PATH /opt/conda/envs/dean/bin:$PATH