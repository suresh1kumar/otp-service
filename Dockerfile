FROM openjdk:11-jre-slim-buster
ENV PORT 9081
#ENV CLASSPATH /opt/lib
EXPOSE 9081
COPY service/build/libs/*.jar /opt/app.jar
WORKDIR /opt
CMD ["java", "-jar", "app.jar"]
