# ARGs
ARG MAVEN_VERSION=3.9
ARG JAVAJDK_VERSION=17-jre-headless-latest
ARG BUILD_TAG="0.0.0"

# Build
FROM maven:${MAVEN_VERSION} AS build
ARG BUILD_TAG=$BUILD_TAG
COPY src /home/app/src
COPY pom.xml /home/app
RUN mvn -f /home/app/pom.xml clean package -Dproject.version=${BUILD_TAG}

# Package
FROM azul/zulu-openjdk:${JAVAJDK_VERSION} as final 
ARG BUILD_TAG=$BUILD_TAG
RUN apt-get -y update; apt-get -y install curl 
COPY --from=build /home/app/target/demo-${BUILD_TAG}.war /usr/local/lib/demo.war
EXPOSE 8080 9000
ENTRYPOINT ["java","-jar","/usr/local/lib/demo.war"]