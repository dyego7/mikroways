# Dudas
En el ejercicio 3 entendi mal. Entendi que lo que se queria era hacer lo mismo que el 1, pero parametrizando el mensaje. Y me volvi loco para hacerlo. No se me ocurrio como hacerlo

Lo que se me ocurrio fue usar una variable de ambiente o algo asi, pero no se como hacerlo

En el ejercicio 4 se me ocurrio hacer un comando, porque no sabia como insertar un parametro en el medio del ENTRYPOINT

# Ejercicio 1

[Dockerfile](actividad-02/Dockerfile.1)

<pre>
FROM httpd:2.4
RUN echo "&lt;html&gt;&lt;body&gt;&lt;b&gt;¡ Hola Mundo !&lt;/b&gt;&lt;/body&gt;&lt;/html&gt;" > /usr/local/apache2/htdocs/index.html 
</pre>

Resultado

<pre>
➜  actividad-02 docker build -t mikroways/hola-mundo-httpd -f Dockerfile.1 .
Sending build context to Docker daemon  2.048kB
...
Successfully tagged mikroways/hola-mundo-httpd:latest

➜  actividad-02 docker images 
REPOSITORY                   TAG                 IMAGE ID            CREATED              SIZE
mikroways/hola-mundo-httpd   latest              ea942bb0c132        About a minute ago   138MB
httpd                        2.4                 3dd970e6b110        3 weeks ago          138MB

docker run -d -p 8080:80 --name hola-mundo-httpd mikroways/hola-mundo-httpd 
6d08b44c2b416cbd6db312c4414b29e91749c4c75595e552880b3de744d2da92

➜  actividad-02 curl localhost:8080
&lt;html&gt;&lt;body&gt;&lt;b&gt;¡ Hola Mundo !&lt;/b&gt;&lt;/body&gt;&lt;/html&gt;

➜  actividad-02 docker stop hola-mundo-httpd 
hola-mundo-httpd
</pre>

# Ejerccio 2

DockerHub

<pre>
➜  actividad-02 docker login 
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
..
Login Succeeded

➜  actividad-02 docker push mikroways/hola-mundo-httpd 
The push refers to repository [docker.io/mikroways/hola-mundo-httpd]
..
denied: requested access to the resource is denied
</pre>

No soy dueño de mikroways!!!, creo la imagen con otro domain

<pre>
➜  actividad-02 docker build -t gdelacruz/hola-mundo-httpd -f Dockerfile.1 .  
Sending build context to Docker daemon  2.048kB
..
Successfully tagged gdelacruz/hola-mundo-httpd:latest

➜  actividad-02 docker push gdelacruz/hola-mundo-httpd                      
The push refers to repository [docker.io/gdelacruz/hola-mundo-httpd]
..
latest: digest: sha256:f14029597f28d20ff3621fb2447322558acfde6fde0cb4e74aae73b1635a080c size: 1573
</pre>

Gilab

<pre>
➜  actividad-02 docker login registry.gitlab.com 
..
Login Succeeded

➜  actividad-02 docker build -t registry.gitlab.com/gdelacruz/docker-registry -f Dockerfile.1 . 
Sending build context to Docker daemon  2.048kB
...
latest: digest: sha256:f14029597f28d20ff3621fb2447322558acfde6fde0cb4e74aae73b1635a080c size: 1573
</pre>

# Ejercicio 3

[Dockerfile](actividad-02/Dockerfile.3)

<pre>
FROM busybox
ENTRYPOINT ["echo"]
CMD ["HOLA MUNDO"]
</pre>

Resultado

<pre>
➜  actividad-02 docker build -t gdelacruz/echo -f Dockerfile.3 .
Sending build context to Docker daemon  4.096kB
...
Successfully tagged gdelacruz/echo:latest

➜  actividad-02 docker run --rm gdelacruz/echo 
HOLA MUNDO

➜  actividad-02 docker run --rm gdelacruz/echo "Hola German"
Hola German
</pre>

# Ejercicio 4

[Dockerfile](actividad-02/Dockerfile.4)

<pre>
FROM alpine:latest
WORKDIR /tmp
ADD ./run.sh /bin/
RUN chmod +x /bin/run.sh
ENTRYPOINT ["/bin/run.sh"]
CMD ["10M"]
</pre>

[run.sh](actividad-02/run.sh)

<pre>
#!/bin/sh
dd if=/dev/zero bs=$1 count=1 of=created-file
</pre>

Resultado

<pre>
➜  actividad-02 docker build -t gdelacruz/file-creator -f Dockerfile.4 .
Sending build context to Docker daemon  7.168kB
...
Successfully tagged gdelacruz/file-creator:latest

➜  actividad-02 docker run gdelacruz/file-creator '10M'                 
1+0 records in
1+0 records out

➜  actividad-02 docker run gdelacruz/file-creator '100M'
1+0 records in
1+0 records out

➜  actividad-02 docker ps -asn 2
CONTAINER ID        IMAGE                    COMMAND              CREATED              STATUS                          PORTS               NAMES               SIZE
32655b62da4e        gdelacruz/file-creator   "/bin/run.sh 100M"   About a minute ago   Exited (0) About a minute ago                       kind_hugle          105MB (virtual 110MB)
f6f88a1e3394        gdelacruz/file-creator   "/bin/run.sh 10M"    About a minute ago   Exited (0) About a minute ago                       sweet_germain       10.5MB (virtual 16.1MB)

</pre>

Cuando lo ejecute con "10M" la imagen peso 10M mas, y cuando lo ejecute con "100M" peso 100M mas, asi que el archivo fue generado dentro del filesystem del Docker

# Ejercicio 5

[Dockerfile](actividad-02/Dockerfile.5)

<pre>
FROM alpine:latest
WORKDIR /tmp
ADD ./run.sh /bin/
RUN addgroup -S appuser && \
    adduser -S appuser -G appuser
RUN chmod 777 /bin/run.sh
USER appuser
ENTRYPOINT ["/bin/run.sh"]
CMD ["10M"]

</pre>

Resultado

<pre>
➜  actividad-02 docker build -t gdelacruz/file-creator-nonroot -f Dockerfile.5 .
Sending build context to Docker daemon  6.144kB
...
Successfully tagged gdelacruz/file-creator-nonroot:latest

➜  actividad-02 docker run gdelacruz/file-creator-nonroot '100M'                
1+0 records in
1+0 records out
</pre>

Reviso el resultado

<pre>
➜  actividad-02 docker commit romantic_mirzakhani debug/file-creator
sha256:739c9ff177c100d703a118042762abf8268bb5bb09a9f910da265def6a8a37cc

➜  actividad-02 docker run -it --rm --entrypoint sh debug/file-creator
/tmp $ ls -al
total 102408
drwxrwxrwt    1 root     root          4096 Nov  9 00:44 .
drwxr-xr-x    1 root     root          4096 Nov  9 00:45 ..
-rw-r--r--    1 appuser  appuser  104857600 Nov  9 00:44 created-file
</pre>

# Ejercicio 6 

[Dockerfile](actividad-02/Dockerfile.6)

<pre>
FROM ruby:2.7 AS ARTIFACT
WORKDIR /tmp/site
RUN git clone https://github.com/Mikroways/mikroways.net.git /tmp/site
RUN bundle install
RUN jekyll build

FROM nginx:alpine
COPY --from=ARTIFACT /tmp/site/_site/  /usr/share/nginx/html
</pre>

Resultado

<pre>
➜  actividad-02 docker build -t gdelacruz/site -f Dockerfile.6 .
Sending build context to Docker daemon  7.168kB
Step 1/7 : FROM ruby:2.7 AS ARTIFACT
2.7: Pulling from library/ruby
...
Removing intermediate container b2efe196bece
 ---> 3caaa04e5254
....
Successfully tagged gdelacruz/site:latest

➜  actividad-02 docker run -d -p 8080:80 gdelacruz/site 
fb823430f20ecaeb153f438d7e3996eeac853c670733d959509534e600800b19

➜  actividad-02 curl -I localhost:8080
HTTP/1.1 200 OK
Server: nginx/1.19.4
Date: Mon, 09 Nov 2020 01:11:26 GMT
Content-Type: text/html
Content-Length: 26759
Last-Modified: Mon, 09 Nov 2020 01:06:16 GMT
Connection: keep-alive
ETag: "5fa89608-6887"
Accept-Ranges: bytes
</pre>

# Ejercicio 7

[Dockerfile](actividad-02/Dockerfile.7)

<pre>
FROM node:current-buster AS ARTIFACT

WORKDIR /tmp/site
RUN git clone https://gitlab.com/gdelacruz/myresume.git /tmp/site
RUN npm i
RUN mkdir -p public/
RUN npm run resume export -- --theme elegant public/index.html

FROM nginx:alpine
COPY --from=ARTIFACT /tmp/site/public/  /usr/share/nginx/html
</pre>

Resultado

<pre>
➜  actividad-02 docker build -t gdelacruz/site -f Dockerfile.7 .
Sending build context to Docker daemon  8.192kB
...
Done! Find your new .html resume at:
 /tmp/site/public/index.html
Your resume-cli software is up-to-date.
Removing intermediate container 0f56ce234e5e
 ---> dc43ef47e24a
Step 7/8 : FROM nginx:alpine
...
Successfully tagged gdelacruz/site:latest

➜  actividad-02 docker run -d -p 8080:80 gdelacruz/site 
3b7cbbb39c9f4e9c5133bffc12d5e6351026a0446a1b42ab884a61892ff3bab8
</pre>

# Ejercicio 8

[Referencia](https://docs.docker.com/engine/reference/builder/#dockerignore-file)

Before the docker CLI sends the context to the docker daemon, it looks for a file named .dockerignore in the root directory of the context. If this file exists, the CLI modifies the context to exclude files and directories that match patterns in it. This helps to avoid unnecessarily sending large or sensitive files and directories to the daemon and potentially adding them to images using ADD or COPY.

O sea, con este archivo se peden ignorar archivos para que no viajen dentro de la imagen, como archivos temporares o sensibles que no se quiere que viajen.

# Ejercicio 9

<pre>
➜  docker-image-size docker build -t gdelacruz/files  .
Sending build context to Docker daemon  2.004MB
...
Successfully tagged gdelacruz/files:latest

➜  docker-image-size docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
gdelacruz/files     latest              9ab39e3d1e20        3 seconds ago       5.23MB
busybox             latest              f0b02e9d092d        3 weeks ago         1.23MB
</pre>

Como la capa "RUN chmod 400 /app/*" modifica los archivos de la capa "ADD . /app", entonces duplica el espacio. Se me ocurrio una solucion con multistage

[Dockerfile](actividad-02/Dockerfile.9)

<pre>
FROM busybox AS PRE
ADD . /app
RUN chmod 400 /app/*

FROM busybox
COPY --from=PRE /app /app
</pre>

Resultado

<pre>
➜  docker-image-size docker build -t gdelacruz/files  .
Sending build context to Docker daemon  2.004MB
...
Successfully tagged gdelacruz/files:latest

➜  docker-image-size docker images                     
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
gdelacruz/files     latest              33817fc10863        3 seconds ago       3.23MB
busybox             latest              f0b02e9d092d        3 weeks ago         1.23MB
</pre>

PD: Hay discuciones intesesantes del [soporte del --chmod en el ADD/COPY](https://github.com/moby/moby/issues/34819) 

Otra opcion que encontre es el parametro --squash, que esta en experimental.

Activando las experimental, la imagen igual que con el multistage (Desactivandolo claro)

[Dockerfile](actividad-02/Dockerfile.9.squash)

<pre>
➜  actividad-02 git:(main) docker build --squash -t gdelacruz/files  -f Dockerfile.9.squash .
Sending build context to Docker daemon  9.216kB
Step 1/3 : FROM busybox AS PRE
 ---> f0b02e9d092d
Step 2/3 : ADD . /app
 ---> e4aaddd9b2c4
Step 3/3 : RUN chmod 400 /app/*
 ---> Running in cd408fe23a03
Removing intermediate container cd408fe23a03
 ---> f05f48d40460
Successfully built 4cbde573fc88
Successfully tagged gdelacruz/files:latest

➜  actividad-02 git:(main) ✗ docker image ls
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
gdelacruz/files     latest              0bec381a0395        5 seconds ago       3.23MB
</pre>

# Ejercicio 10
Segun la [documentacion de docker](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)

> If you want the command to fail due to an error at any stage in the pipe, prepend set -o pipefail && to ensure that an unexpected error prevents the build from inadvertently succeeding


O sea, lo que permite es que en cualquier parte del pipe, si falle falle todo. 

# Final

Despues de 4 horas.....

<pre>
docker system prune -a
</pre>