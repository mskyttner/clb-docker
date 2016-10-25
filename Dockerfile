FROM maven:3.3-jdk-8
EXPOSE 8080
ADD settings.xml /root/.m2/settings.xml

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
ADD checklistbank /usr/src/app
RUN mvn install

CMD ["java","-jar","target/my-jar-file.jar"]
