# Dudas
* Ejercicio 2: El ID al hacer el pull pense era el ID de la imagen, pero despues veo que el ID de la imagen es bf756fb1ae65 con docker image ls, cual es la diferencia?)

**Respuesta**

<pre>
Cuando hacés git pull de cualquier imagen puede confundir un poco la salida:

docker pull debian
Using default tag: latest
latest: Pulling from library/debian
e4c3d3e4f7b0: Pull complete 
Digest: sha256:8414aa82208bc4c2761dc149df67e25c6b8a9380e5d8c4e7b5c84ca2d04bb244
Status: Downloaded newer image for debian:latest
docker.io/library/debian:latest
En ese ejemplo, podés ver que aparecen dos cosas: e4c3d3e4f7b0 y 
8414aa82208bc4c2761dc149df67e25c6b8a9380e5d8c4e7b5c84ca2d04bb244
. Si mirás docker image ls --digest vas a encontrar el hash(digest) de la imagen descargada. El otro valor es el has de la capa que descarga desde docker hub.
</pre>

* Ejercicio 10: Al matar y volver a crear un container desde la imagen no arranca automaticamente el Apache2. Tampoco entiendo porque deberia hacerlo

**Respuesta**

<pre>
La idea de este ejercicio es que usen commit. Está bien que no entiendas por qué no corre apache automáticamente. Eso lo veremos en la clase de hoy. Entonces siguiendo la idea del ejercicio, en la consola podés correr:

docker run --name alpine-apache  alpine apk add -U apache2
docker commit alpine-apache alpine-apache
docker rm -f alpine-apache && docker run -d --rm -p 80:80 alpine-apache httpd -D FOREGROUND
curl localhost
</pre>

* Ejercicio 11: No se si esa era la idea...
**Respuesta**

<pre>
Sí, y verificar que si accedes al nginx veas entonces German
</pre>

* Ejercicio 12: Sinceramente no entendi la pregunta

**Respuesta**

<pre>
La idea es responder y verificar lo que aun no vimos y lo que hoy arrancaremos viendo.
</pre>

# Ejercicio 1 

OK

# Ejercicio 2

## ¿Qué imagen se utiliza para instanciar el contenedor?

library/hello-world:latest

## ¿Qué puede decir de los mensajes que se pueden ver en la consola?

<pre>
Unable to find image 'hello-world:latest' locally -> No encontre la imagen localmente
latest: Pulling from library/hello-world -> Voy a buscarla a la registry
0e03bdcc26d7: Pull complete  -> Listo, la encontre y la baje (**DUDA: encuentro este ID que crei era el ID de la imagen, pero despues veo que el ID de la imagen es bf756fb1ae65 con docker image ls, cual es la diferencia**)
Digest: sha256:8c5aeeb6a5f3ba4883347d3747a7249f491766ca1caa47e5da5dfcf6b9b717c0 -> El digest d ela imagen bajada
Status: Downloaded newer image for hello-world:latest -> Cargo la imagen

</pre>

# Ejercicio 3

<pre>
~ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
</pre>

No se encuentra, lo que significa que no esta corriendo

<pre>
~ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                       PORTS                              NAMES
0024d9acbd82        hello-world         "/hello"            2 minutes ago       Exited (0) 2 minutes ago                                        upbeat_stonebraker
f474c844d072        79bd6d5dd595        "npm start"         6 days ago          Exited (255) 3 minutes ago   0.0.0.0:3000->3000/tcp, 3001/tcp   vibrant_chatterjee
</pre>

El container 0024d9acbd82 de la imagen "hello-world" corrio hace 2 minutos (El otro container soy yo jugando hace unos dias :))


# Ejercicio 4

<pre>
~ docker run ubuntu:18.04 /bin/bash
Unable to find image 'ubuntu:18.04' locally
18.04: Pulling from library/ubuntu
171857c49d0f: Pull complete 
419640447d26: Pull complete 
61e52f862619: Pull complete 
Digest: sha256:646942475da61b4ce9cc5b3fadb42642ea90e5d0de46111458e100ff2c7031e6
Status: Downloaded newer image for ubuntu:18.04
</pre>

## Utilizando docker ps ¿Qué sucedió con el estado del contenedor?

<pre>
~ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
</pre>

Ejecuto y termino

## Instanciando nuevamente utilizando el parámetro anterior.

Luego de correr docker run -it ubuntu:18.04 me dio el prompt de la consola dentro del docker

<pre>
~ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED              STATUS              PORTS               NAMES
3d24f9f308f1        ubuntu:18.04        "/bin/bash"         About a minute ago   Up About a minute                       epic_gates

</pre>

Ahora si el docker esta corriendo

Se le asigno el nombre epic_gates

<pre>
~ docker run --name "capacitacion-practica-01" -it ubuntu:18.04

~ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
d505be1a4eb2        ubuntu:18.04        "/bin/bash"         59 seconds ago      Up 59 seconds                           capacitacion-practica-01

</pre>

# Ejercicio 5 

Si el docker esta corriendo no (por lo menos asi simplemente)

<pre>
~ docker rm capacitacion-practica-01
Error response from daemon: You cannot remove a running container d505be1a4eb2790d56c3b22ba0e80dc771ad785b29868a42158c920df4396b8a. Stop the container before attempting removal or force remove
</pre>

Para eso se usa la opcion -f (Force)

<pre>
~ docker rm -f capacitacion-practica-01
capacitacion-practica-01

~ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES

~ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                        PORTS                              NAMES
3d24f9f308f1        ubuntu:18.04        "/bin/bash"         7 minutes ago       Exited (0) 5 minutes ago                                         epic_gates
7aff981c7ae1        ubuntu:18.04        "/bin/bash"         8 minutes ago       Exited (0) 8 minutes ago                                         frosty_newton
0024d9acbd82        hello-world         "/hello"            16 minutes ago      Exited (0) 16 minutes ago                                        upbeat_stonebraker
f474c844d072        79bd6d5dd595        "npm start"         6 days ago          Exited (255) 17 minutes ago   0.0.0.0:3000->3000/tcp, 3001/tcp   vibrant_chatterjee

</pre>

Aprovecho y borro todo (No me gusta la basura)

<pre>
~ docker ps -aq|xargs docker rm 
3d24f9f308f1
7aff981c7ae1
0024d9acbd82
f474c844d072

~ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
</pre>

# Ejercicio 6 

Creo la desventaja principal es el uso de recursos (Por lo que veo sigue ocupando espacio en el filesystem)

<pre>
~ docker ps -as   
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                      PORTS               NAMES                      SIZE

cbaf4a10b8b7        ubuntu:18.04        "/bin/bash"         21 seconds ago      Exited (0) 17 seconds ago                       capacitacion-practica-01   5B (virtual 63.2MB)
</pre>

El parametro -rm elimina el container una vez que termina de correr

<pre>
~ docker run --name "capacitacion-practica-01" -it --rm ubuntu:18.04
root@a495f6c8b3bd:/#

~ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
a495f6c8b3bd        ubuntu:18.04        "/bin/bash"         33 seconds ago      Up 33 seconds                           capacitacion-practica-01

(exit)

~ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
</pre>

# Ejercicio 7

<pre>
~ docker search apache
NAME                               DESCRIPTION                                     STARS               OFFICIAL            AUTOMATED
httpd                              The Apache HTTP Server Project                  3226                [OK]                
tomcat                             Apache Tomcat is an open source implementati…   2864                [OK]                
cassandra                          Apache Cassandra is an open-source distribut…   1203                [OK]                
maven                              Apache Maven is a software project managemen…   1104                [OK]                
solr                               Solr is the popular, blazing-fast, open sour…   792                 [OK]                
apache/nifi                        Unofficial convenience binaries and Docker i…   189                                     [OK]
apache/airflow                     Apache Airflow                                  167                                     
eboraas/apache-php                 PHP on Apache (with SSL/TLS support), built …   144                                     [OK]
apache/zeppelin                    Apache Zeppelin                                 138                                     [OK]
groovy                             Apache Groovy is a multi-faceted language fo…   103                 [OK]                
eboraas/apache                     Apache (with SSL/TLS support), built on Debi…   92                                      [OK]
apacheignite/ignite                Docker Hub With Apache Ignite In-Memory Comp…   72                                      [OK]
nimmis/apache-php5                 This is docker images of Ubuntu 14.04 LTS wi…   66                                      [OK]
bitnami/apache                     Bitnami Apache Docker Image                     65                                      [OK]
apachepulsar/pulsar                Apache Pulsar - Distributed pub/sub messagin…   30                                      
linuxserver/apache                 An Apache container, brought to you by Linux…   24                                      
apache/nutch                       Apache Nutch                                    22                                      [OK]
antage/apache2-php5                Docker image for running Apache 2.x with PHP…   21                                      [OK]
webdevops/apache                   Apache container                                14                                      [OK]
newdeveloper/apache-php            apache-php7.2                                   8                                       
lephare/apache                     Apache container                                6                                       [OK]
newdeveloper/apache-php-composer   apache-php-composer                             6                                       
secoresearch/apache-varnish        Apache+PHP+Varnish5.0                           2                                       [OK]
jelastic/apachephp                 An image of the Apache PHP application serve…   0                                       
apache/arrow-dev                   Apache Arrow convenience images for developm…   0                                       

~  docker run httpd
Unable to find image 'httpd:latest' locally
latest: Pulling from library/httpd
bb79b6b2107f: Pull complete 
26694ef5449a: Pull complete 
7b85101950dd: Pull complete 
da919f2696f2: Pull complete 
3ae86ea9f1b9: Pull complete 
Digest: sha256:b82fb56847fcbcca9f8f162a3232acb4a302af96b1b2af1c4c3ac45ef0c9b968
Status: Downloaded newer image for httpd:latest
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppress this message
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppress this message
[Fri Oct 30 00:04:12.904747 2020] [mpm_event:notice] [pid 1:tid 140097377313920] AH00489: Apache/2.4.46 (Unix) configured -- resuming normal operations
[Fri Oct 30 00:04:12.904887 2020] [core:notice] [pid 1:tid 140097377313920] AH00094: Command line: 'httpd -D FOREGROUND'

~ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
dc1608342814        httpd               "httpd-foreground"   32 seconds ago      Up 31 seconds       80/tcp              confident_chatelet
</pre>

Apache esta escuchando en el port 80 (DENTRO DEL DOCKER)

## ¿Es posible acceder por el navegadoral servidor web iniciado en dicho puerto?

Asi como esta no, ya que el puerto donde escucha apache escucha dentro del container. Para poder verlo desde un web browser es necesario mapear el puerto 80 del container a un puerto externo que escuche
<pre>
~ docker run -p3000:80 httpd
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppress this message
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppress this message
[Fri Oct 30 00:07:01.935564 2020] [mpm_event:notice] [pid 1:tid 140577727657088] AH00489: Apache/2.4.46 (Unix) configured -- resuming normal operations
[Fri Oct 30 00:07:01.935729 2020] [core:notice] [pid 1:tid 140577727657088] AH00094: Command line: 'httpd -D FOREGROUND'
</pre>

Ahora el puerto interno 80, se mepea al puerto 3000 externo

<pre>
http://localhost:3000 muestra "It works!"


172.17.0.1 - - [30/Oct/2020:00:07:45 +0000] "GET / HTTP/1.1" 200 45
172.17.0.1 - - [30/Oct/2020:00:07:45 +0000] "GET /favicon.ico HTTP/1.1" 404 196
</pre>

## ¿Qué sucede si se cierra la consola en donde se encuentra corriendo el servidor web Apache?Chequear el estado del contenedor con el comando docker ps y docker ps ‐a.

Muere

<pre>
~ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED              STATUS              PORTS                  NAMES
aa3d62105ad4        httpd               "httpd-foreground"   About a minute ago   Up About a minute   0.0.0.0:3000->80/tcp   nervous_neumann

(Cierro consola)

~ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES

</pre>

# Ejercicio 8

Con el parametro -d el servicio corre como deamon, de forma que no depende de la consola

<pre>
~ docker run -p3000:80 -d httpd
fa6de06abb19d98233e3b7a6a5ef67787aed594f36f25f7a415a1b3725cc82a9

~ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS                  NAMES
fa6de06abb19        httpd               "httpd-foreground"   59 seconds ago      Up 58 seconds       0.0.0.0:3000->80/tcp   intelligent_heisenberg

(Cierro la consola)

~ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED              STATUS              PORTS                  NAMES
fa6de06abb19        httpd               "httpd-foreground"   About a minute ago   Up About a minute   0.0.0.0:3000->80/tcp   intelligent_heisenberg

</pre>

9)

<pre>

~ docker logs intelligent_heisenberg 
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppress this message
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppress this message
[Fri Oct 30 00:11:29.238257 2020] [mpm_event:notice] [pid 1:tid 140387867096192] AH00489: Apache/2.4.46 (Unix) configured -- resuming normal operations
[Fri Oct 30 00:11:29.238710 2020] [core:notice] [pid 1:tid 140387867096192] AH00094: Command line: 'httpd -D FOREGROUND'

~ docker logs --tail 10 intelligent_heisenberg
[Fri Oct 30 00:11:29.238257 2020] [mpm_event:notice] [pid 1:tid 140387867096192] AH00489: Apache/2.4.46 (Unix) configured -- resuming normal operations
[Fri Oct 30 00:11:29.238710 2020] [core:notice] [pid 1:tid 140387867096192] AH00094: Command line: 'httpd -D FOREGROUND'
172.17.0.1 - - [30/Oct/2020:00:14:49 +0000] "GET / HTTP/1.1" 200 45
172.17.0.1 - - [30/Oct/2020:00:14:50 +0000] "GET / HTTP/1.1" 200 45
172.17.0.1 - - [30/Oct/2020:00:14:50 +0000] "GET / HTTP/1.1" 200 45
172.17.0.1 - - [30/Oct/2020:00:14:51 +0000] "GET / HTTP/1.1" 200 45
172.17.0.1 - - [30/Oct/2020:00:14:51 +0000] "GET / HTTP/1.1" 200 45
172.17.0.1 - - [30/Oct/2020:00:14:57 +0000] "GET / HTTP/1.1" 200 45
172.17.0.1 - - [30/Oct/2020:00:14:58 +0000] "GET / HTTP/1.1" 200 45
172.17.0.1 - - [30/Oct/2020:00:14:58 +0000] "GET / HTTP/1.1" 200 45

Para los logs de hace 5 minutos por 1 minuto, genere un log

~ docker logs --tail 10 intelligent_heisenberg
172.17.0.1 - - [30/Oct/2020:00:15:03 +0000] "GET / HTTP/1.1" 200 45
172.17.0.1 - - [30/Oct/2020:00:15:03 +0000] "GET / HTTP/1.1" 200 45
172.17.0.1 - - [30/Oct/2020:00:15:03 +0000] "GET / HTTP/1.1" 200 45
172.17.0.1 - - [30/Oct/2020:00:15:03 +0000] "GET / HTTP/1.1" 200 45
172.17.0.1 - - [30/Oct/2020:00:15:04 +0000] "GET / HTTP/1.1" 200 45
172.17.0.1 - - [30/Oct/2020:00:15:04 +0000] "GET / HTTP/1.1" 200 45
172.17.0.1 - - [30/Oct/2020:00:15:04 +0000] "GET / HTTP/1.1" 200 45
172.17.0.1 - - [30/Oct/2020:00:15:04 +0000] "GET / HTTP/1.1" 200 45
172.17.0.1 - - [30/Oct/2020:00:18:01 +0000] "GET / HTTP/1.1" 200 45
172.17.0.1 - - [30/Oct/2020:00:18:02 +0000] "GET / HTTP/1.1" 200 45

(Espero y genero otro al minuto)

docker logs --tail 10 intelligent_heisenberg
docker logs --tail 10 intelligent_heisenberg
172.17.0.1 - - [30/Oct/2020:00:15:03 +0000] "GET / HTTP/1.1" 200 45
172.17.0.1 - - [30/Oct/2020:00:15:03 +0000] "GET / HTTP/1.1" 200 45
172.17.0.1 - - [30/Oct/2020:00:15:03 +0000] "GET / HTTP/1.1" 200 45
172.17.0.1 - - [30/Oct/2020:00:15:04 +0000] "GET / HTTP/1.1" 200 45
172.17.0.1 - - [30/Oct/2020:00:15:04 +0000] "GET / HTTP/1.1" 200 45
172.17.0.1 - - [30/Oct/2020:00:15:04 +0000] "GET / HTTP/1.1" 200 45
172.17.0.1 - - [30/Oct/2020:00:15:04 +0000] "GET / HTTP/1.1" 200 45
172.17.0.1 - - [30/Oct/2020:00:18:01 +0000] "GET / HTTP/1.1" 200 45
172.17.0.1 - - [30/Oct/2020:00:18:02 +0000] "GET / HTTP/1.1" 200 45
172.17.0.1 - - [30/Oct/2020:00:19:07 +0000] "GET / HTTP/1.1" 200 45

(Espero 4 minutos)

~ date                                                     
Thu Oct 29 21:22:04 -03 2020

~ docker logs --since 5m --until 4m  intelligent_heisenberg
172.17.0.1 - - [30/Oct/2020:00:18:01 +0000] "GET / HTTP/1.1" 200 45
172.17.0.1 - - [30/Oct/2020:00:18:02 +0000] "GET / HTTP/1.1" 200 45

</pre>

# Ejercicio 10

<pre>
~ docker run -it alpine
Unable to find image 'alpine:latest' locally
latest: Pulling from library/alpine
188c0c94c7c5: Pull complete 
Digest: sha256:c0e9560cda118f9ec63ddefb4a173a2b2a0347082d7dff7dc14272e7841a5b5a
Status: Downloaded newer image for alpine:latest

/ # apk update
fetch http://dl-cdn.alpinelinux.org/alpine/v3.12/main/x86_64/APKINDEX.tar.gz
fetch http://dl-cdn.alpinelinux.org/alpine/v3.12/community/x86_64/APKINDEX.tar.gz
v3.12.1-10-ge724957f3e [http://dl-cdn.alpinelinux.org/alpine/v3.12/main]
v3.12.1-9-g3c7f8a65fa [http://dl-cdn.alpinelinux.org/alpine/v3.12/community]
OK: 12744 distinct packages available

/ # apk add apache2
(1/6) Installing libuuid (2.35.2-r0)
(2/6) Installing apr (1.7.0-r0)
(3/6) Installing expat (2.2.9-r1)
(4/6) Installing apr-util (1.6.1-r6)
(5/6) Installing pcre (8.44-r0)
(6/6) Installing apache2 (2.4.46-r0)
Executing apache2-2.4.46-r0.pre-install
Executing busybox-1.31.1-r19.trigger
OK: 9 MiB in 20 packages

/ # httpd -D > FOREGROUND
httpd: option requires an argument -- D
Usage: httpd [-D name] [-d directory] [-f file]
             [-C "directive"] [-c "directive"]
             [-k start|restart|graceful|graceful-stop|stop]
             [-v] [-V] [-h] [-l] [-L] [-t] [-T] [-S] [-X]
Options:
  -D name            : define a name for use in <IfDefine name> directives
  -d directory       : specify an alternate initial ServerRoot
  -f file            : specify an alternate ServerConfigFile
  -C "directive"     : process directive before reading config files
  -c "directive"     : process directive after reading config files
  -e level           : show startup errors of level (see LogLevel)
  -E file            : log startup errors to file
  -v                 : show version number
  -V                 : show compile settings
  -h                 : list available command line options (this page)
  -l                 : list compiled in modules
  -L                 : list available configuration directives
  -t -D DUMP_VHOSTS  : show parsed vhost settings
  -t -D DUMP_RUN_CFG : show parsed run settings
  -S                 : a synonym for -t -D DUMP_VHOSTS -D DUMP_RUN_CFG
  -t -D DUMP_MODULES : show all loaded modules 
  -M                 : a synonym for -t -D DUMP_MODULES
  -t -D DUMP_INCLUDES: show all included configuration files
  -t                 : run syntax check for config files
  -T                 : start without DocumentRoot(s) check
  -X                 : debug mode (only one worker, do not detach)

/ # httpd -D FOREGROUND
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 172.17.0.3. Set the 'ServerName' directive globally to suppress this message
  

(CTRL-P-Q)                                                                                                                                                                                                         
~ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS                  NAMES
7fdebc9c19e6        alpine              "/bin/sh"            3 minutes ago       Up 2 minutes                               agitated_cannon
fa6de06abb19        httpd               "httpd-foreground"   23 minutes ago      Up 23 minutes       0.0.0.0:3000->80/tcp   intelligent_heisenberg

~ docker commit -m "Agregado de apache" 7fdebc9c19e6 gdelacruz/alpine-httpd
sha256:4250179dbeb6d6273e3291b6243b0dd0a6061eeb7c07b0bcb6d8c7098b468988

~ docker images 
REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
gdelacruz/alpine-httpd   latest              4250179dbeb6        7 seconds ago       11MB
<none>                   <none>              79bd6d5dd595        6 days ago          166MB
alpine                   latest              d6e46aa2470d        7 days ago          5.57MB
httpd                    latest              3dd970e6b110        2 weeks ago         138MB
ubuntu                   18.04               56def654ec22        4 weeks ago         63.2MB
hello-world              latest              bf756fb1ae65        10 months ago       13.3kB
node                     10.15-alpine        56bc3a1ed035        17 months ago       71MB

</pre>

**Lo que noto cuando lo mato y lo levanto de la imagen que cree es que apache no esta escuchando...** (Ver Respuesta)

# Ejercicio 11

<pre>
~ docker run -p 3000:80 -d --name "web" nginx:latest 
eb2f050199ef5f32d548ef841013fb35cf048494b767cade2889ab4ce72824d3

~ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                  NAMES
eb2f050199ef        nginx:latest        "/docker-entrypoint.…"   2 seconds ago       Up 2 seconds        0.0.0.0:3000->80/tcp   web

~ docker exec web sh -c "echo 'GERMAN' > /usr/share/nginx/html/index.html" 
</pre>

# Ejercicio 12

**TODO** (Ver respuesta)