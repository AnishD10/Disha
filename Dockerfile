FROM tomcat:9.0-jdk17-temurin

ENV DISHA_DB_URL="jdbc:mysql://host.docker.internal:3306/disha_career_portal?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true" \
    DISHA_DB_USER="disha" \
    DISHA_DB_PASSWORD="disha123"

RUN rm -rf /usr/local/tomcat/webapps/*

WORKDIR /build

COPY src ./src
COPY WebContent /usr/local/tomcat/webapps/disha
COPY lib/mysql-connector-j-9.7.0.jar /usr/local/tomcat/webapps/disha/WEB-INF/lib/mysql-connector-j-9.7.0.jar

RUN mkdir -p /usr/local/tomcat/webapps/disha/WEB-INF/classes \
    && find src -name "*.java" > sources.txt \
    && javac -encoding UTF-8 \
        -cp "/usr/local/tomcat/lib/servlet-api.jar:/usr/local/tomcat/webapps/disha/WEB-INF/lib/mysql-connector-j-9.7.0.jar" \
        -d /usr/local/tomcat/webapps/disha/WEB-INF/classes \
        @sources.txt \
    && rm -rf /build

EXPOSE 8080

CMD ["catalina.sh", "run"]
