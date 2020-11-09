# Respuestas solitidadas

[Volumenes, ejercicio 2](#Ejercicio-2)

[Volumenes, ejercicio 3](#Ejercicio-3)

[Volumenes, ejercicio 9](#Ejercicio-9)

# Registry

## Parte 1

<pre>
docker run -d -p 5000:5000 --restart always --name registry registry:2
</pre>

## Parte 2

[Dockerfile](actividad-03/registry/Dockerfile.1)

<pre>
FROM nginx
RUN echo "&lt;html&gt;&lt;body&gt;&lt;b&gt;¡ index cambiado !&lt;/b&gt;&lt;/body&gt;&lt;/html&gt;" > /usr/share/nginx/html/index.html 
</pre>

Resultado

<pre>
➜  registry git:(main) ✗ docker build -t nginx-cambiado -f Dockerfile.1 . 
Sending build context to Docker daemon  2.048kB
Step 1/2 : FROM nginx
latest: Pulling from library/nginx
bb79b6b2107f: Pull complete 
5a9f1c0027a7: Pull complete 
b5c20b2b484f: Pull complete 
166a2418f7e8: Pull complete 
1966ea362d23: Pull complete 
Digest: sha256:aeade65e99e5d5e7ce162833636f692354c227ff438556e5f3ed0335b7cc2f1b
Status: Downloaded newer image for nginx:latest
 ---> c39a868aad02
Step 2/2 : RUN echo "<html><body><b>¡ index cambiado !</b></body></html" > /usr/share/nginx/html/index.html
 ---> Running in 14bf30ffb807
Removing intermediate container 14bf30ffb807
 ---> 0b5dc7f8d2a9
Successfully built 0b5dc7f8d2a9
Successfully tagged nginx-cambiado:latest

➜  registry git:(main) ✗ docker tag nginx-cambiado localhost:5000/nginx-cambiado 

➜  registry git:(main) ✗ docker push localhost:5000/nginx-cambiado
The push refers to repository [localhost:5000/nginx-cambiado]
1a82a830031b: Pushed 
7b5417cae114: Pushed 
aee208b6ccfb: Pushed 
2f57e21e4365: Pushed 
2baf69a23d7a: Pushed 
d0fe97fa8b8c: Pushed 
latest: digest: sha256:e381b53960765bc5d6414e0cd94b4ee34196cd65a2dde9e8be753b49a7bc4a00 size: 1569
</pre>

## Parte 3

Resultado

<pre>
➜  registry git:(main) ✗ docker rmi nginx-cambiado 
Untagged: nginx-cambiado:latest

➜  registry git:(main) ✗ docker rmi localhost:5000/nginx-cambiado              
Untagged: localhost:5000/nginx-cambiado:latest
Untagged: localhost:5000/nginx-cambiado@sha256:e381b53960765bc5d6414e0cd94b4ee34196cd65a2dde9e8be753b49a7bc4a00
Deleted: sha256:0b5dc7f8d2a94120d8155abee85aec19c100792465b783c492095eb5641d271f
Deleted: sha256:44743d7b2ec2e88c70f9f904921437c18e39818a48b4963288225266394192ac

➜  registry git:(main) ✗ docker pull localhost:5000/nginx-cambiado
Using default tag: latest
latest: Pulling from nginx-cambiado
bb79b6b2107f: Already exists 
5a9f1c0027a7: Already exists 
b5c20b2b484f: Already exists 
166a2418f7e8: Already exists 
1966ea362d23: Already exists 
59b992355876: Pull complete 
Digest: sha256:e381b53960765bc5d6414e0cd94b4ee34196cd65a2dde9e8be753b49a7bc4a00
Status: Downloaded newer image for localhost:5000/nginx-cambiado:latest
localhost:5000/nginx-cambiado:latest
</pre>

# Volumenes

## Ejercicio 1

<pre>
➜  volumes git:(main) ✗ docker run -it --mount dst=/opt alpine
Unable to find image 'alpine:latest' locally
latest: Pulling from library/alpine
188c0c94c7c5: Pull complete 
Digest: sha256:c0e9560cda118f9ec63ddefb4a173a2b2a0347082d7dff7dc14272e7841a5b5a
Status: Downloaded newer image for alpine:latest
/ # cd /opt/
/opt # touch file1
/opt # ls -al
total 8
drwxr-xr-x    2 root     root          4096 Nov  9 13:40 .
drwxr-xr-x    1 root     root          4096 Nov  9 13:39 ..
-rw-r--r--    1 root     root             0 Nov  9 13:40 file1
/opt # exit
➜  volumes git:(main) ✗ 
</pre>

<pre>
➜  volumes git:(main) ✗ docker inspect $(docker ps -alq) --format '{{json .Mounts}}' | jq 
[
  {
    "Type": "volume",
    "Name": "23bdcd982f55469ce2b07d0cc9b3e04f981bca46a2f6147c829b382d7f10587c",
    "Source": "/var/lib/docker/volumes/23bdcd982f55469ce2b07d0cc9b3e04f981bca46a2f6147c829b382d7f10587c/_data",
    "Destination": "/opt",
    "Driver": "local",
    "Mode": "z",
    "RW": true,
    "Propagation": ""
  }
]

➜  volumes git:(main) ✗ docker inspect $(docker ps -alq) --format '{{range .Mounts}}{{ .Name }}{{end}}'
23bdcd982f55469ce2b07d0cc9b3e04f981bca46a2f6147c829b382d7f10587c
</pre>

Nota: Como estoy corriendo en una Mac, el comando me pasa lo siguiente:

<pre>
sudo cat $(docker inspect $(docker ps -alq) --format '{{range .Mounts}}{{ .Name }}{{end}}' | xargs docker volume inspect --format '{{ .Mountpoint }}')     
Password:
cat: /var/lib/docker/volumes/23bdcd982f55469ce2b07d0cc9b3e04f981bca46a2f6147c829b382d7f10587c/_data: No such file or directory
</pre>

Esto ocurre porque docker corre en una VM. Entonces corro asi:

<pre>
➜  volumes git:(main) ✗ docker run --rm -it -v /:/vm-root alpine:edge ls -l /vm-root$(docker inspect $(docker ps -alq) --format '{{range .Mounts}}{{ .Name }}{{end}}' | xargs docker volume inspect --format '{{ .Mountpoint }}')
total 0
-rw-r--r--    1 root     root             0 Nov  9 13:40 file1
</pre>

Y se ve el archivo ahi

## Ejercicio 2

<pre>
➜  volumes git:(main) ✗ docker run -it --mount dst=/opt alpine
/ # cd /opt/
/opt # touch file2
/opt # ls -al
total 8
drwxr-xr-x    2 root     root          4096 Nov  9 14:19 .
drwxr-xr-x    1 root     root          4096 Nov  9 14:19 ..
-rw-r--r--    1 root     root             0 Nov  9 14:19 file2
/opt # exit
➜  volumes git:(main) ✗ 
</pre>

<pre>
➜  volumes git:(main) ✗ docker inspect $(docker ps -alq) --format '{{json .Mounts}}' | jq 
[
  {
    "Type": "volume",
    "Name": "3bc2792ff201ba76275150618f6112fdf6cb8e8e68954c82a8a27230994454b7",
    "Source": "/var/lib/docker/volumes/3bc2792ff201ba76275150618f6112fdf6cb8e8e68954c82a8a27230994454b7/_data",
    "Destination": "/opt",
    "Driver": "local",
    "Mode": "z",
    "RW": true,
    "Propagation": ""
  }
]

➜  volumes git:(main) ✗ docker inspect $(docker ps -alq) --format '{{range .Mounts}}{{ .Name }}{{end}}'
3bc2792ff201ba76275150618f6112fdf6cb8e8e68954c82a8a27230994454b7
</pre>

Ya se ve que el volumen es otro

<pre>
➜  volumes git:(main) ✗ docker volume ls
DRIVER              VOLUME NAME
local               3bc2792ff201ba76275150618f6112fdf6cb8e8e68954c82a8a27230994454b7
local               23bdcd982f55469ce2b07d0cc9b3e04f981bca46a2f6147c829b382d7f10587c
local               2485c75b57919541980359b80c05230a7936ca5cbc18cff50108c3866a8fedce
</pre>

Y justamente hay un volumen mas, por ende, en el volumen anonimmo nuevo, no va a estar el archivo

<pre>
➜  volumes git:(main) ✗ docker run --rm -it -v /:/vm-root alpine:edge ls -l /vm-root$(docker inspect $(docker ps -alq) --format '{{range .Mounts}}{{ .Name }}{{end}}' | xargs docker volume inspect --format '{{ .Mountpoint }}')
total 0
-rw-r--r--    1 root     root             0 Nov  9 14:19 file2
</pre>

## Ejercicio 3

<pre>
➜  volumes git:(main) ✗ docker run --rm -it --mount dst=/opt alpine                                   
/ # cd /opt/
/opt # touch file3
/opt # ls -al
total 8
drwxr-xr-x    2 root     root          4096 Nov  9 14:23 .
drwxr-xr-x    1 root     root          4096 Nov  9 14:23 ..
-rw-r--r--    1 root     root             0 Nov  9 14:23 file3
/opt # exit

➜  volumes git:(main) ✗ docker volume ls
DRIVER              VOLUME NAME
local               3bc2792ff201ba76275150618f6112fdf6cb8e8e68954c82a8a27230994454b7
local               23bdcd982f55469ce2b07d0cc9b3e04f981bca46a2f6147c829b382d7f10587c
local               2485c75b57919541980359b80c05230a7936ca5cbc18cff50108c3866a8fedce
</pre>

El volumen anonimo se elimino

## Ejercicio 4

<pre>
➜  volumes git:(main) ✗ docker run -it --rm --mount src=test,dst=/opt alpine
/ # cd /opt/
/opt # touch file4
/opt # ls -al
total 8
drwxr-xr-x    2 root     root          4096 Nov  9 14:26 .
drwxr-xr-x    1 root     root          4096 Nov  9 14:26 ..
-rw-r--r--    1 root     root             0 Nov  9 14:26 file4
/opt # exit

➜  volumes git:(main) ✗ docker volume ls
DRIVER              VOLUME NAME
local               3bc2792ff201ba76275150618f6112fdf6cb8e8e68954c82a8a27230994454b7
local               23bdcd982f55469ce2b07d0cc9b3e04f981bca46a2f6147c829b382d7f10587c
local               2485c75b57919541980359b80c05230a7936ca5cbc18cff50108c3866a8fedce
local               test
</pre>

Ahora, por mas que el container fue eliminado (--rm) el volumen nombrado y creado sigue ahi

<pre>
➜  volumes git:(main) ✗ docker volume inspect test 
[
    {
        "CreatedAt": "2020-11-09T14:26:41Z",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/test/_data",
        "Name": "test",
        "Options": null,
        "Scope": "local"
    }
]

➜  volumes git:(main) ✗ docker run --rm -it -v /:/vm-root alpine:edge ls -l /vm-root$(docker volume inspect test --format '{{ .Mountpoint }}')
total 0
-rw-r--r--    1 root     root             0 Nov  9 14:26 file4
</pre>

## Ejercicio 5

Ejectivamente el archivo se encuentra ahi, porque como el volumen nombrado ya existe, monta el mismo.

<pre>
➜  volumes git:(main) ✗ docker run -it --rm --mount src=test,dst=/opt alpine

/ # cd /opt/
/opt # ls -al
total 8
drwxr-xr-x    2 root     root          4096 Nov  9 14:26 .
drwxr-xr-x    1 root     root          4096 Nov  9 14:31 ..
-rw-r--r--    1 root     root             0 Nov  9 14:26 file4
</pre>

## Ejercicio 6

Efectivamente sigue ahi. En mi caso, cree una imagen basada en busybox y monte en "/srv"

<pre>
➜  volumes git:(main) ✗ docker run -it --rm --mount src=test,dst=/srv busybox

/ # cd /srv
/srv # ls -al
total 8
drwxr-xr-x    2 root     root          4096 Nov  9 14:26 .
drwxr-xr-x    1 root     root          4096 Nov  9 14:33 ..
-rw-r--r--    1 root     root             0 Nov  9 14:26 file4
</pre>

## Ejercicio 7


