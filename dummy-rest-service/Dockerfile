#
# Build stage
ARG MAVEN_VERSION=3.9
ARG JAVAJDK_VERSION=17-latest
#ARG BUILD_VERSION=

# Build
FROM maven:${MAVEN_VERSION} AS build
COPY src /home/app/src
COPY pom.xml /home/app
RUN mvn -f /home/app/pom.xml clean package

# Package
FROM azul/zulu-openjdk:${JAVAJDK_VERSION}
COPY --from=build /home/app/target/demo-0.0.1-SNAPSHOT.war /usr/local/lib/demo.war
EXPOSE 8080 9000
ENTRYPOINT ["java","-jar","/usr/local/lib/demo.war"]