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
  pip install --upgrade --no-cache-dir numpy pandas pyspark==3.5.0 jupyterlab delta-spark delta-sharing PyArrow grpcio google-api-python-client grpcio-status

RUN curl -O 'https://dlcdn.apache.org/spark/spark-3.5.0/spark-3.5.0-bin-hadoop3.tgz' \
 && tar xvzf 'spark-3.5.0-bin-hadoop3.tgz' -C /opt \
 && rm 'spark-3.5.0-bin-hadoop3.tgz' \
 && mv /opt/spark-3.5.0-bin-hadoop3 /opt/spark


CMD /opt/spark/sbin/start-connect-server.sh \
  --packages org.apache.spark:spark-connect_2.12:3.5.0,io.delta:delta-spark_2.12:3.0.0 \
  --conf "spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension" \
  --conf "spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog" \
  --conf "spark.executor.memory=4g" \
  --conf "spark.driver.memory=4g" \
  --conf "spark.sql.catalogImplementation=hive" \
  --conf "spark.sql.warehouse.dir=/data/dwh" \
  --conf "spark.driver.extraJavaOptions=-Dderby.system.home=/data/derby" \
 && jupyter-lab --allow-root --ip="0.0.0.0" --NotebookApp.token=''

