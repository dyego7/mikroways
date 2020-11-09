# Respuestas Solicitadas

[Volumenes, ejercicio 2](#ejercicio-2)

[Volumenes, ejercicio 3](#ejercicio-3)

[Volumenes, ejercicio 9](#ejercicio-9)

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
Step 2/2 : RUN echo "<html><body><b>¡ index cambiado !</b></body></html>" > /usr/share/nginx/html/index.html
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

Y justamente hay un volumen mas, por ende, en el volumen anonimmo nuevo, no va a estar el archivo, sino el nuevo que cree. 

<pre>
➜  volumes git:(main) ✗ docker run --rm -it -v /:/vm-root alpine:edge ls -l /vm-root$(docker inspect $(docker ps -alq) --format '{{range .Mounts}}{{ .Name }}{{end}}' | xargs docker volume inspect --format '{{ .Mountpoint }}')
total 0
-rw-r--r--    1 root     root             0 Nov  9 14:19 file2
</pre>

**Nota**: El comando anterior es un poco diferente porque estoy corriendo en una MAC y trabaja un poco diferente docker (Docker trabaja dentro de una VM). Puse el detalle en el Ejercicio 1, ya que ahi se me presento el problema. 

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
<pre>
➜  volumes git:(main) ✗ mkdir /tmp/temp
➜  volumes git:(main) ✗ docker run --rm -it -v /tmp/temp:/opt alpine              
/ # cd /opt/
/opt # ls -al
total 4
drwxr-xr-x    2 root     root            64 Nov  9 15:12 .
drwxr-xr-x    1 root     root          4096 Nov  9 15:12 ..
</pre>

En otra consola

<pre>
➜  volumes git:(main) ✗ cd /tmp/temp 
➜  temp touch file7
➜  temp ls -al
total 0
drwxr-xr-x   3 ger   wheel   96 Nov  9 12:12 .
drwxrwxrwt  11 root  wheel  352 Nov  9 12:12 ..
-rw-r--r--   1 ger   wheel    0 Nov  9 12:12 file7
</pre>

De vuelta en el containter
<pre>
/opt # ls -al
total 4
drwxr-xr-x    3 root     root            96 Nov  9 15:12 .
drwxr-xr-x    1 root     root          4096 Nov  9 15:12 ..
-rw-r--r--    1 root     root             0 Nov  9 15:12 file7
</pre>

Efectivamente se ve el archivo creado en el filesystem del host

<pre>
/opt # touch file7-2
/opt # ls -al
total 4
drwxr-xr-x    4 root     root           128 Nov  9 15:14 .
drwxr-xr-x    1 root     root          4096 Nov  9 15:12 ..
-rw-r--r--    1 root     root             0 Nov  9 15:12 file7
-rw-r--r--    1 root     root             0 Nov  9 15:14 file7-2
</pre>

En la consola

<pre>
➜  temp ls -al
total 0
drwxr-xr-x   4 ger   wheel  128 Nov  9 12:14 .
drwxrwxrwt  11 root  wheel  352 Nov  9 12:12 ..
-rw-r--r--   1 ger   wheel    0 Nov  9 12:12 file7
-rw-r--r--   1 ger   wheel    0 Nov  9 12:14 file7-2
</pre>

Efectivamente, el archivo nuevo tambien se ve

## Ejercicio 8

<pre>
➜  volumes git:(main) ✗ docker run -it --rm --name alpine-volume --mount dst=/opt alpine
/ # cd /opt/
/opt # touch file8
/opt # ls -al
total 8
drwxr-xr-x    2 root     root          4096 Nov  9 15:18 .
drwxr-xr-x    1 root     root          4096 Nov  9 15:17 ..
-rw-r--r--    1 root     root             0 Nov  9 15:18 file8
</pre>

Creo otro container, montando el volumen de "alpine-volume"

<pre>
➜  volumes git:(main) ✗ docker run -it --rm --name alpine-test --volumes-from alpine-volume alpine
/ # cd /opt/
/opt # ls -al
total 8
drwxr-xr-x    2 root     root          4096 Nov  9 15:18 .
drwxr-xr-x    1 root     root          4096 Nov  9 15:19 ..
-rw-r--r--    1 root     root             0 Nov  9 15:18 file8
</pre>

Se ve se comparte el volumen

## Ejercicio 9

<pre>
➜  volumes git:(main) ✗ docker pull postgres:12
12: Pulling from library/postgres
bb79b6b2107f: Pull complete 
e3dc51fa2b56: Pull complete 
f213b6f96d81: Pull complete 
2780ac832fde: Pull complete 
ae5cee1a3f12: Pull complete 
95db3c06319e: Pull complete 
475ca72764d5: Pull complete 
8d602872ecae: Pull complete 
a6ed287c246e: Pull complete 
c3ff7d7e55c2: Pull complete 
ecac36e2e805: Pull complete 
c644377e015b: Pull complete 
f11db28dae1f: Pull complete 
09b253e297b9: Pull complete 
Digest: sha256:a1e04460fdd3c338d6b65a2ab66b5aa2748eb18da3e55bcdc9ef17831ed3ad46
Status: Downloaded newer image for postgres:12
docker.io/library/postgres:12

➜  volumes git:(main) ✗ docker inspect postgres:12 --format '{{json .ContainerConfig.Volumes}}' | jq 
{
  "/var/lib/postgresql/data": {}
}

➜  volumes git:(main) ✗ docker run --name=psql-docker -e POSTGRES_PASSWORD=docker-psql -p 5432:5432 --mount src=pg_data,dst=/var/lib/postgresql/data postgres:12
The files belonging to this database system will be owned by user "postgres".
This user must also own the server process.
....
2020-11-09 15:31:06.866 UTC [1] LOG:  database system is ready to accept connections
</pre>

En otra consola

<pre>
➜  volumes git:(main) ✗ docker volume inspect pg_data 
[
    {
        "CreatedAt": "2020-11-09T15:31:06Z",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/pg_data/_data",
        "Name": "pg_data",
        "Options": null,
        "Scope": "local"
    }
]

➜  volumes git:(main) ✗ docker run --rm -it -v /:/vm-root alpine:edge ls -l /vm-root$(docker volume inspect pg_data --format '{{ .Mountpoint }}')
total 124
-rw-------    1 999      ping             3 Nov  9 15:31 PG_VERSION
...
-rw-------    1 999      ping            94 Nov  9 15:31 postmaster.pid

</pre>

Lanzo el pgadmin

<pre>
➜  volumes git:(main) ✗ docker run -p80:80 -e 'PGADMIN_DEFAULT_EMAIL=docker@mikroways.net' -e 'PGADMIN_DEFAULT_PASSWORD=mikroways' --link psql-docker:db -d dpage/pgadmin4
Unable to find image 'dpage/pgadmin4:latest' locally
latest: Pulling from dpage/pgadmin4
.....sha256:58da0db9645b67ea0432dd234ae0a3ef395e3a53b0e7117e3a483dcb29b251c7
Status: Downloaded newer image for dpage/pgadmin4:latest
f01847ec6890a72564932b79aea1f8d564b7ea1f9bcea94714d658716550ce3e
➜  volumes git:(main) ✗
</pre>

Hago el resto del ejercicio (loguearme y crear la base de prueba)

Termino el docker de postgres y elimino el container

<pre>
➜  volumes git:(main) ✗ docker rm psql-docker                                                                                                                   
➜  volumes git:(main) ✗ docker run --name=psql-docker -e POSTGRES_PASSWORD=docker-psql -p 5432:5432 --mount src=pg_data,dst=/var/lib/postgresql/data postgres:12

PostgreSQL Database directory appears to contain a database; Skipping initialization

2020-11-09 15:47:01.760 UTC [1] LOG:  starting PostgreSQL 12.4 (Debian 12.4-1.pgdg100+1) on x86_64-pc-linux-gnu, compiled by gcc (Debian 8.3.0-6) 8.3.0, 64-bit
2020-11-09 15:47:01.761 UTC [1] LOG:  listening on IPv4 address "0.0.0.0", port 5432
2020-11-09 15:47:01.761 UTC [1] LOG:  listening on IPv6 address "::", port 5432
2020-11-09 15:47:01.762 UTC [1] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
2020-11-09 15:47:01.776 UTC [27] LOG:  database system was shut down at 2020-11-09 15:45:49 UTC
2020-11-09 15:47:01.780 UTC [1] LOG:  database system is ready to accept connections

</pre>

Vuelvo al pgadmin y la base "prueba" sigue ahi

Instancio un nuevo container (con otro nombre y puerto local), y apunta la mismo volumen que el anterior

<pre>
➜  volumes git:(main) ✗ docker run --name=psql-docker-2 -e POSTGRES_PASSWORD=docker-psql -p 5433:5432 --mount src=pg_data,dst=/var/lib/postgresql/data postgres:12

PostgreSQL Database directory appears to contain a database; Skipping initialization

2020-11-09 15:51:04.720 UTC [1] LOG:  starting PostgreSQL 12.4 (Debian 12.4-1.pgdg100+1) on x86_64-pc-linux-gnu, compiled by gcc (Debian 8.3.0-6) 8.3.0, 64-bit
2020-11-09 15:51:04.720 UTC [1] LOG:  listening on IPv4 address "0.0.0.0", port 5432
2020-11-09 15:51:04.720 UTC [1] LOG:  listening on IPv6 address "::", port 5432
2020-11-09 15:51:04.721 UTC [1] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
2020-11-09 15:51:04.735 UTC [25] LOG:  database system was interrupted; last known up at 2020-11-09 15:47:01 UTC
2020-11-09 15:51:04.850 UTC [25] LOG:  database system was not properly shut down; automatic recovery in progress
2020-11-09 15:51:04.852 UTC [25] LOG:  redo starts at 0/1645E40
2020-11-09 15:51:04.852 UTC [25] LOG:  invalid record length at 0/1645E78: wanted 24, got 0
2020-11-09 15:51:04.852 UTC [25] LOG:  redo done at 0/1645E40
2020-11-09 15:51:04.860 UTC [1] LOG:  database system is ready to accept connections
</pre>

En cuanto lo mate, el original revento porque borro el archivo "postmaster.pid". Los borro y los vuelvo a arrancar

<pre>
➜  volumes git:(main) ✗ docker rm psql-docker 
psql-docker

➜  volumes git:(main) ✗ docker rm psql-docker-2 
psql-docker-2

➜  volumes git:(main) ✗ docker run --name=psql-docker -e POSTGRES_PASSWORD=docker-psql -p 5432:5432 --mount src=pg_data,dst=/var/lib/postgresql/data postgres:12

PostgreSQL Database directory appears to contain a database; Skipping initialization

2020-11-09 15:54:35.004 UTC [1] LOG:  starting PostgreSQL 12.4 (Debian 12.4-1.pgdg100+1) on x86_64-pc-linux-gnu, compiled by gcc (Debian 8.3.0-6) 8.3.0, 64-bit
2020-11-09 15:54:35.005 UTC [1] LOG:  listening on IPv4 address "0.0.0.0", port 5432
2020-11-09 15:54:35.005 UTC [1] LOG:  listening on IPv6 address "::", port 5432
2020-11-09 15:54:35.006 UTC [1] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
2020-11-09 15:54:35.020 UTC [26] LOG:  database system was shut down at 2020-11-09 15:52:29 UTC
2020-11-09 15:54:35.024 UTC [1] LOG:  database system is ready to accept connections

</pre>

Entro con psql

<pre>
➜  volumes git:(main) ✗ docker exec -ti psql-docker psql -U postgres

postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 prueba    | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(4 rows)

postgres=# exit
➜  volumes git:(main) ✗ 
</pre>

Y ahi esta la hermosa base "prueba"


## Ejercicio 10

Confiezo fui haciendo limpiezas parciales

<pre>
➜  volumes git:(main) ✗ docker system df
TYPE                TOTAL               ACTIVE              SIZE                RECLAIMABLE
Images              5                   3                   550.6MB             6.847MB (1%)
Containers          4                   1                   223B                69B (30%)
Local Volumes       7                   4                   103.5MB             53.6MB (51%)
Build Cache         0                   0                   0B                  0B
</pre>

## Ejercicio 11
Como hay algunos activos, los stopeo y limpio

<pre>
➜  volumes git:(main) ✗ docker stop nervous_ritchie

➜  volumes git:(main) ✗ docker system prune -a
</pre>
