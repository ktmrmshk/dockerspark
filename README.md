# dockerspark
docker env for apache spark

## Build docker image

```
$ docker build -t dockerspark .
```

## Usage

### from public repo

```
$ docker run --rm -d -p 18888:8888 -p 14040:4040 -v ${PWD}:/data ghcr.io/ktmrmshk/dockerspark:latest
```

To use simple notebook env, run

```
$ docker run --rm -d -p 18888:8888 -p 14040:4040 -v ${PWD}:/data ghcr.io/ktmrmshk/dockerspark:latest jupyter-lab --allow-root --ip="0.0.0.0" --NotebookApp.token=''
```


### from local repo

```
$ docker run --rm -d -p 18888:8888 -p 14040:4040 -v ${PWD}:/data dockerspark
```

Then, open browser and connect to http://host:18888.
You can also access SparkUI at http://host:14040 once a spark session is created.

Using ssh tunnel from remote host:
```
$ ssh host -L18888:localhost:18888 -L14040:localhost:14040
```


### sample codes

```
from pyspark.sql import SparkSession
spark = (
    SparkSession
    .builder
    .remote("sc://localhost")
    .getOrCreate()
)

df = spark.createDataFrame([{'name': 'kita123'}])
df.count()
df.show()
```

Plus, using DeltaLake and local metastore,

```
from delta import *
from pyspark.sql import SparkSession

builder = (
    SparkSession.builder.appName("MyApp123")
    .config("spark.sql.extensions", "io.delta.sql.DeltaSparkSessionExtension")
    .config("spark.sql.catalog.spark_catalog", "org.apache.spark.sql.delta.catalog.DeltaCatalog")
    .config("spark.sql.warehouse.dir", '/data/managed_tables')
    .enableHiveSupport()
)

spark = (
    configure_spark_with_delta_pip(builder)
    .getOrCreate()
)
spark.conf.set("spark.sql.repl.eagerEval.enabled", True)

spark.sql('show tables')
```

with minio:

```
from pyspark.sql import SparkSession
spark = (
SparkSession.builder
    .config('spark.jars.packages', 'org.apache.hadoop:hadoop-aws:3.3.1')
    .config("spark.hadoop.fs.s3a.endpoint", "http://minio:9000")
    .config("spark.hadoop.fs.s3a.access.key", "EL2zKWFMe8cF8tRBOTgn")
    .config("spark.hadoop.fs.s3a.secret.key", "LWGtupdRpGgmkHBWeKX8HlHiJwgJWpn8pN7lUyJG")
    .config("spark.hadoop.fs.s3a.path.style.access", "true")
    .config("spark.hadoop.fs.s3a.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem")
    .config("spark.hadoop.fs.s3a.connection.ssl.enabled", "false")
    .config('spark.hadoop.fs.s3a.aws.credentials.provider', 'org.apache.hadoop.fs.s3a.SimpleAWSCredentialsProvider')
    .getOrCreate()
)

(
    spark.sql('select 1 as no')
    .write.format('csv')
    .mode('overwrite')
    .save('s3a://kita123/one.csv')
)
```
