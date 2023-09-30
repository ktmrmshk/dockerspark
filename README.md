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


### from local repo

```
$ docker run --rm -d -p 18888:8888 -p 14040:4040 -v ${PWD}:/data dockerspark
```

Then, open browser and connect to http://host:18888.
You can also access SparkUI at http://host:14040 once a spark session is created.

Using ssh tunnel from remote host:
```
$ ssh host -L18888:localhost:18888 -L14040:locahost:14040
```


### sample codes

```
from pyspark.sql import SparkSession
spark = SparkSession.builder.remote("sc://localhost:15002").getOrCreate()
spark.conf.set('spark.sql.repl.eagerEval.enabled', True)

df = spark.createDataFrame([{'name': 'kita123'}])
df.count()
df.show()
```
