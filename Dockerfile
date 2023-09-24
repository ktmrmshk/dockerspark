FROM ubuntu
RUN apt-get update && apt-get install -y \
    python-is-python3 \
    python3-pip \
    openjdk-17-jre-headless \
    curl \
    htop \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN pip install -U pip &&\
  pip install --no-cache-dir numpy pandas pyspark jupyterlab delta-spark delta-sharing

CMD jupyter-lab --allow-root --ip="0.0.0.0" --NotebookApp.token=''

