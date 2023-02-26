# ARGs
ARG MAVEN_VERSION=3.9
ARG JAVAJDK_VERSION=17-latest
ARG BUILD_TAG="0.0.0"

# Build
FROM maven:${MAVEN_VERSION} AS build
ARG BUILD_TAG=$BUILD_TAG
COPY src /home/app/src
COPY pom.xml /home/app
RUN mvn -f /home/app/pom.xml clean package -Dproject.version=${BUILD_TAG}

# Package
FROM azul/zulu-openjdk:${JAVAJDK_VERSION}
ARG BUILD_TAG=$BUILD_TAG
RUN addgroup -g 1001 app
RUN adduser app -u 1001 -D -G app /home/app
USER app
COPY --chown=1001:1001 --from=build /home/app/target/demo-${BUILD_TAG}.war /usr/local/lib/demo-${BUILD_TAG}.war
EXPOSE 8080 9000
ENTRYPOINT ["java","-jar","/usr/local/lib/demo-${BUILD_TAG}.war"]