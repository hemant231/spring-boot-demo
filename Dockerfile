FROM java:8

EXPOSE 8088

ADD target/spring-boot-demo-0.0.1-SNAPSHOT.jar spring-boot-demo-0.0.1-SNAPSHOT.jar

ENTRYPOINT ["java","-jar","spring-boot-demo-0.0.1-SNAPSHOT.jar","--server.port=8088"]  
