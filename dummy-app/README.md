# dummy-app
Returns a file provided by the from the `dummy-pdf-or-png` service

Responds to GET requests on port `8080` with path "/<interger_value>" (e.g.: /1234).



Dockerfile multi-stage takes care of building, so to get started you run the 
following commands in this directory, assuming you have Docker & Maven installed.

`DUMMY_GO_SERVICE` must be passed at the container start as environment variable

`DUMMY_GO_SERVICE` will point to the `dummy-pdf-or-png` service HTTP endpoint (e.g.: `"http://<hostname>:3000/"`)

```bash
docker build -t dummy-app . --build-arg BUILD_TAG=1.0.2-SNAPSHOT
docker run --rm -it -p 8080:8080 -p 9000:9000 dummy-app -e DUMMY_GO_SERVICE="http://localhost:3000/"
```

On port `9000` the application will expose health & metics as per below examples

```
http://localhost:9000/actuator/health
http://localhost:9000/actuator/health/{*path}
http://localhost:9000/actuator/prometheus
```