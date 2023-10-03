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
