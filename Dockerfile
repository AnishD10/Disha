FROM tomcat:9.0-jdk17-temurin AS build

WORKDIR /build

COPY src ./src
COPY lib ./lib
COPY WebContent ./WebContent

RUN rm -rf WebContent/WEB-INF/classes WebContent/WEB-INF/lib \
    && mkdir -p WebContent/WEB-INF/classes WebContent/WEB-INF/lib \
    && find src -name "*.java" | sort > sources.txt \
    && javac -encoding UTF-8 \
        -d WebContent/WEB-INF/classes \
        -cp "${CATALINA_HOME}/lib/servlet-api.jar:lib/mysql-connector-j-9.7.0.jar" \
        @sources.txt \
    && cp lib/mysql-connector-j-9.7.0.jar WebContent/WEB-INF/lib/

FROM tomcat:9.0-jdk17-temurin

ARG APP_NAME=Disha
ENV CATALINA_OPTS="-Dfile.encoding=UTF-8"

RUN rm -rf "${CATALINA_HOME}/webapps/"*

COPY --from=build /build/WebContent "${CATALINA_HOME}/webapps/${APP_NAME}"

EXPOSE 8080
