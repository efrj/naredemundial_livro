FROM maven:3.9.11-eclipse-temurin-17 AS build
WORKDIR /build
COPY infra/java/pom.xml ./pom.xml
RUN mvn -B dependency:go-offline
COPY infra/java/src ./src
RUN mvn -B package dependency:copy-dependencies -DoutputDirectory=target/lib

FROM alpine:3.23
RUN apk add --no-cache openjdk17-jre-headless ca-certificates
WORKDIR /opt/agenda
COPY --from=build /build/target/lib/ ./lib/
COPY --from=build /build/target/agenda-runtime.jar ./lib/
COPY jsp/ ./webapp/
ENV AGENDA_DATABASE=/database/agenda.mdb
ENV JAVA_TOOL_OPTIONS="-Xms32m -Xmx256m -Dfile.encoding=UTF-8"
EXPOSE 8080 8081
ENTRYPOINT ["java", "-cp", "/opt/agenda/lib/*", "agenda.Main"]
