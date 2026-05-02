# Stage 1: Build the application
FROM eclipse-temurin:11-jdk AS builder

WORKDIR /build

# Copy project files
COPY . .

# Create necessary directories
RUN mkdir -p /build/out/artifacts

# Compile Java source files
RUN javac -d /build/out/classes \
    -cp "lib/*:." \
    $(find /build/src -name "*.java" -type f)

# Stage 2: Create WAR artifact (simple approach for non-Maven projects)
FROM eclipse-temurin:11-jdk

# Install Tomcat
ENV TOMCAT_VERSION=9.0.88
RUN apt-get update && apt-get install -y wget unzip && rm -rf /var/lib/apt/lists/*
RUN cd /opt && wget https://archive.apache.org/dist/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    tar xzf apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    rm apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    mv apache-tomcat-${TOMCAT_VERSION} tomcat

WORKDIR /opt/tomcat

# Copy compiled classes
COPY --from=builder /build/out/classes /opt/tomcat/webapps/ROOT/WEB-INF/classes/

# Copy JSP files
COPY WebContent/ /opt/tomcat/webapps/ROOT/

# Copy library files (JAR dependencies)
COPY lib/ /opt/tomcat/lib/

# Copy MySQL JDBC driver if not in lib
RUN if ! ls /opt/tomcat/lib/mysql-connector-j-*.jar >/dev/null 2>&1 && ! ls /opt/tomcat/lib/mysql-connector-java-*.jar >/dev/null 2>&1; then \
    echo "Downloading MySQL JDBC driver..." && \
    wget -q -O /opt/tomcat/lib/mysql-connector-j-8.0.33.jar https://repo.maven.apache.org/maven2/com/mysql/mysql-connector-j/8.0.33/mysql-connector-j-8.0.33.jar; \
    fi && \
    echo "Available JARs in lib:" && ls -la /opt/tomcat/lib/*.jar 2>/dev/null | head -10

# Copy web.xml
COPY web/WEB-INF/web.xml /opt/tomcat/webapps/ROOT/WEB-INF/

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD wget -qO- http://localhost:8080 >/dev/null || exit 1

# Start Tomcat
CMD ["/opt/tomcat/bin/catalina.sh", "run"]
