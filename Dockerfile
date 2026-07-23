# syntax=docker/dockerfile:1

FROM eclipse-temurin:21-jdk-noble AS build

WORKDIR /workspace

COPY gradlew gradlew.bat build.gradle.kts settings.gradle.kts gradle.properties ./
COPY gradle ./gradle
RUN chmod +x gradlew

COPY src ./src
RUN ./gradlew bootJar --no-daemon

FROM eclipse-temurin:21-jre-noble AS runtime

RUN groupadd --system --gid 10001 ordinus \
    && useradd --system --uid 10001 --gid ordinus \
        --home-dir /app --shell /usr/sbin/nologin ordinus

WORKDIR /app

COPY --from=build --chown=10001:10001 /workspace/build/libs/ordinus.jar ./ordinus.jar

USER 10001:10001

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/ordinus.jar"]
