# dockerspark
docker env for apache spark

## Build docker image

```
$ docker build -t dockerspark .
```

## Usage

```
$ docker run --rm -d -p 8888:8888 -p 4040:4040 -d ${PWD}:/data dockerspark
```

Then, open browser and connect to http://host:8888.
You can also access SparkUI at http://host:4040 once a spark session is created.
