# Simple-Spring-Boot-Container-Application
![Docker Container](https://github.com/Abhikanade17112002/Simple-Spring-Boot-Container-Application/blob/main/src/main/resources/static/Screenshot%202026-09-07%20at%2010.38.06%E2%80%AFPM%20%282%29.png?raw=true)

![Spring Boot Application](https://github.com/Abhikanade17112002/Simple-Spring-Boot-Container-Application/blob/main/src/main/resources/static/Screenshot%202026-09-07%20at%2010.38.06%E2%80%AFPM.png?raw=true)

![EC2 Docker Setup](https://github.com/Abhikanade17112002/Simple-Spring-Boot-Container-Application/blob/main/src/main/resources/static/Screenshot%202026-09-07%20at%2010.38.27%E2%80%AFPM.png?raw=true)


# Simple Spring Boot Container Application

A simple **Spring Boot application containerized using Docker** and deployed on an **AWS EC2 Ubuntu instance**.

This project is mainly created to understand the complete flow:

```text
Spring Boot Application
        ↓
      Maven
        ↓
       JAR
        ↓
    Dockerfile
        ↓
   Docker Image
        ↓
   Docker Container
        ↓
   Spring Boot :8080
        ↓
   /api/health
```

---

## 1. Application

This project contains a simple Spring Boot REST API.

### Health Check API

```text
GET /api/health
```

Response:

```text
Hello Abhishek
```

---

## 2. Controller

The API is exposed using:

```java
@RestController
@RequestMapping("/api")
public class Controller {

    @GetMapping("/health")
    public ResponseEntity<String> getHealth() {
        return ResponseEntity.ok("Hello Abhishek");
    }
}
```

Therefore:

```text
@RequestMapping("/api")
        +
@GetMapping("/health")
        ↓
GET /api/health
```

---

# 3. Dockerfile

The application is packaged into a Docker image using the following Dockerfile:

```dockerfile
FROM eclipse-temurin:21-jre

WORKDIR /app

COPY target/app.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
```

### Dockerfile instructions

| Instruction  | Purpose                                           |
| ------------ | ------------------------------------------------- |
| `FROM`       | Defines the base image                            |
| `WORKDIR`    | Sets the working directory inside the container   |
| `COPY`       | Copies the Spring Boot JAR into the image         |
| `EXPOSE`     | Documents that the application uses port `8080`   |
| `ENTRYPOINT` | Defines the main process started by the container |

---

# 4. Build the Spring Boot Application

First create the JAR using Maven:

```bash
./mvnw clean package
```

This creates the application JAR inside:

```text
target/
└── app.jar
```

---

# 5. Build the Docker Image

From the project root directory:

```bash
docker build -t my-sb-app:latest .
```

### Understanding the command

```text
docker build
     ↓
Build a Docker image

-t my-sb-app:latest
     ↓
Give the image a name and tag

.
     ↓
Use the current directory as the build context
```

Check the image:

```bash
docker images
```

---

# 6. Run the Docker Container

Run the container using:

```bash
docker run -d \
  --name my-sb-container \
  -p 8080:8080 \
  my-sb-app:latest
```

### Understanding port mapping

```text
-p HOST_PORT:CONTAINER_PORT
```

Therefore:

```text
-p 8080:8080
```

means:

```text
EC2 Host
   │
   │ Port 8080
   ▼
Docker Container
   │
   │ Port 8080
   ▼
Spring Boot
```

---

# 7. Check Running Containers

```bash
docker ps
```

Example:

```text
CONTAINER ID   IMAGE             PORTS
xxxxxxx        my-sb-app:latest  0.0.0.0:8080->8080/tcp
```

To see all containers, including stopped containers:

```bash
docker ps -a
```

---

# 8. Check Container Logs

View application logs:

```bash
docker logs my-sb-container
```

Follow the logs continuously:

```bash
docker logs -f my-sb-container
```

Spring Boot should show something similar to:

```text
Tomcat started on port 8080 (http)

Started Application
```

---

# 9. Test the API from EC2

Run:

```bash
curl http://localhost:8080/api/health
```

Expected response:

```text
Hello Abhishek
```

---

# 10. Access from the Internet

If port `8080` is allowed in the EC2 Security Group, the application can be accessed using:

```text
http://13.233.134.63:8080/api/health
```

The request flow is:

```text
Browser
   ↓
EC2 Public IP
   ↓
AWS Security Group
   ↓
EC2 :8080
   ↓
Docker Port Mapping
   ↓
Container :8080
   ↓
Tomcat
   ↓
Spring Boot
   ↓
/api/health
```

---

# 11. Monitor the Container

Docker provides a live resource monitor:

```bash
docker stats
```

This shows information such as:

* CPU usage
* Memory usage
* Network I/O
* Block I/O
* Number of processes

---

# 12. Inspect the Container

To see detailed information about the container:

```bash
docker inspect my-sb-container
```

This provides information about:

* Container configuration
* Network
* IP address
* Mounts
* Environment
* Image
* Container state

---

# 13. Enter the Container

You can open a shell inside the running container:

```bash
docker exec -it my-sb-container sh
```

Inside the container:

```bash
pwd
```

Expected:

```text
/app
```

List files:

```bash
ls
```

You should see:

```text
app.jar
```

Exit the container:

```bash
exit
```

---

# 14. Stop the Container

```bash
docker stop my-sb-container
```

Check:

```bash
docker ps
```

The container will no longer appear because it is stopped.

To see it:

```bash
docker ps -a
```

---

# 15. Start the Existing Container

```bash
docker start my-sb-container
```

---

# 16. Restart the Container

```bash
docker restart my-sb-container
```

---

# 17. Remove the Container

Stop it first if necessary:

```bash
docker stop my-sb-container
```

Then:

```bash
docker rm my-sb-container
```

---

# 18. Important Docker Concept

Changing Java source code does **not** automatically change the running Docker container.

The complete flow is:

```text
Controller.java
      ↓
Maven Build
      ↓
New JAR
      ↓
docker build
      ↓
New Docker Image
      ↓
docker run
      ↓
New Container
```

Therefore, after changing the Spring Boot application:

```bash
./mvnw clean package
docker build -t my-sb-app:latest .
docker stop my-sb-container
docker rm my-sb-container
docker run -d --name my-sb-container -p 8080:8080 my-sb-app:latest
```

---

# 19. Screenshots

## Docker Build

![Docker Build](src/main/resources/static/Screenshot%202026-09-07%20at%2010.37.42%E2%80%AFPM%20%282%29.png)

## Docker Container

![Docker Container](src/main/resources/static/Screenshot%202026-09-07%20at%2010.38.06%E2%80%AFPM%20%282%29.png)

## Application

![Application](src/main/resources/static/Screenshot%202026-09-07%20at%2010.38.06%E2%80%AFPM.png)

## EC2 / Docker Setup

![EC2 Docker Setup](src/main/resources/static/Screenshot%202026-09-07%20at%2010.38.27%E2%80%AFPM.png)

---

# 20. Docker Commands Learned

| Command          | Purpose                              |
| ---------------- | ------------------------------------ |
| `docker build`   | Build an image                       |
| `docker images`  | List images                          |
| `docker run`     | Create and start a container         |
| `docker ps`      | Show running containers              |
| `docker ps -a`   | Show all containers                  |
| `docker start`   | Start a stopped container            |
| `docker stop`    | Stop a running container             |
| `docker restart` | Restart a container                  |
| `docker rm`      | Remove a container                   |
| `docker logs`    | View container logs                  |
| `docker logs -f` | Follow container logs                |
| `docker exec`    | Execute a command inside a container |
| `docker inspect` | View detailed container information  |
| `docker stats`   | Monitor container resources          |

---

# 21. Docker Mental Model

The most important concept from this project:

```text
             Dockerfile
                  │
             docker build
                  ↓
             Docker Image
                  │
              docker run
                  ↓
              Container
                  │
                  ↓
             Java Process
                  │
                  ↓
            Spring Boot
                  │
                  ↓
              Tomcat
                  │
                  ↓
             Port :8080
                  │
                  ↓
            REST Endpoint
```

### Image vs Container

```text
IMAGE
-----
A blueprint/package used to create containers.


CONTAINER
---------
A running instance created from an image.
```

---

# 22. Project Structure

```text
Simple-Spring-Boot-Container-Application/
│
├── src/
│   └── main/
│       ├── java/
│       │   └── com/
│       │       └── container/
│       │           ├── Application.java
│       │           └── controllers/
│       │               └── Controller.java
│       │
│       └── resources/
│           └── static/
│
├── target/
│   └── app.jar
│
├── Dockerfile
├── pom.xml
└── README.md
```

---

## Learning Objective

This project is intended to build an understanding of Docker from the ground up:

```text
Java
 ↓
Spring Boot
 ↓
Maven
 ↓
JAR
 ↓
Dockerfile
 ↓
Docker Image
 ↓
Docker Container
 ↓
Port Mapping
 ↓
Logs
 ↓
Monitoring
 ↓
AWS EC2
```

The goal is to understand **why each step is required**, rather than simply memorizing Docker commands.
