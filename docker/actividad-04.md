# Dudas

## Redes - Ejercicio 1

No entendi esto

 >Utilice con el comando docker run usado para lanzar los contenedores uno‐default y dos‐ default la opción -e VAR=uno y -e VAR=dos respectivamente

es para despues usar $VAR en el ping?. O sea, hacer ping -c 3 $VAR-default?

Creo que luego de hacer el ejercicio 2 entendi, el concepto creo es que con una misma network no se comporten las variables de ambiente, contra el --link, donde el container que linkea ve las variables del container linkeado

# Recursos - Ejercicio 2
Jugue con parametros a full, pero nunca logre que el OMMKiller lo mate. Si  la computadora se sobresaturo (En CPU mayoritariamente), pero nunca logre matarlo

# Redes

## Ejercicio 1

En la consola 1

<pre>
➜  actividad-04 git:(main) ✗ docker run -it --rm --name uno-default -e VAR=uno alpine         
/ # ping dos-default
ping: bad address 'dos-default'
/ # ip add ls
...
    inet 172.17.0.2/16 brd 172.17.255.255 scope global eth0
       valid_lft forever preferred_lft forever
/ # ping -c 3 172.17.0.3
PING 172.17.0.3 (172.17.0.3): 56 data bytes
64 bytes from 172.17.0.3: seq=0 ttl=64 time=0.112 ms
64 bytes from 172.17.0.3: seq=1 ttl=64 time=0.360 ms
64 bytes from 172.17.0.3: seq=2 ttl=64 time=0.211 ms

--- 172.17.0.3 ping statistics ---
3 packets transmitted, 3 packets received, 0% packet loss
round-trip min/avg/max = 0.112/0.227/0.360 ms
/ # env
HOSTNAME=975a4d7b0de7
SHLVL=1
HOME=/root
VAR=uno
TERM=xterm
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
PWD=/
</pre>

En la consola 2

<pre>
➜  actividad-04 git:(main) ✗ docker run -it --rm --name dos-default -e VAR=dos  alpine                  
/ # ping uno-default
ping: bad address 'uno-default'
/ # ip add ls
....
    inet 172.17.0.3/16 brd 172.17.255.255 scope global eth0
       valid_lft forever preferred_lft forever
/ # ping -c 3 172.17.0.2
PING 172.17.0.2 (172.17.0.2): 56 data bytes
64 bytes from 172.17.0.2: seq=0 ttl=64 time=0.177 ms
64 bytes from 172.17.0.2: seq=1 ttl=64 time=0.223 ms
64 bytes from 172.17.0.2: seq=2 ttl=64 time=0.239 ms

--- 172.17.0.2 ping statistics ---
3 packets transmitted, 3 packets received, 0% packet loss
round-trip min/avg/max = 0.177/0.213/0.239 ms
/ # env
HOSTNAME=5205349a855e
SHLVL=1
HOME=/root
VAR=dos
TERM=xterm
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
PWD=/
</pre>

Conclusiones:
 - Los contenedores se ven por IP (Estan en la misma subnet)
 - No se ven por nombre
 - No comparten las variables de ambiente


## Ejercicio 2

Consola 1, arranco el container

<pre>
➜  actividad-04 git:(main) ✗ docker run -it --rm --name uno-default -e VAR=uno alpine                      
</pre>

Consola 2, arranco el container, y hago ping contra el nombre puesto en el link. Ademas, busco la IP (por lo que viene despues... espero se entienda)

<pre>
➜  actividad-04 git:(main) ✗ docker run -it --rm --name dos-default -e VAR=dos --link uno-default:uno alpine
/ # ping -c 3 uno
PING uno (172.17.0.2): 56 data bytes
64 bytes from 172.17.0.2: seq=0 ttl=64 time=0.155 ms
64 bytes from 172.17.0.2: seq=1 ttl=64 time=0.369 ms
64 bytes from 172.17.0.2: seq=2 ttl=64 time=0.100 ms

--- uno ping statistics ---
3 packets transmitted, 3 packets received, 0% packet loss
round-trip min/avg/max = 0.100/0.208/0.369 ms
/ # ip add ls
.....
state UP 
    link/ether 02:42:ac:11:00:03 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.3/16 brd 172.17.255.255 scope global eth0
       valid_lft forever preferred_lft forever
</pre>

Consola 1, trato de hacer ping por name, no funciona, entonces con la ip de la consola 2 tiro por IP y funciona

<pre>                    
/ # ping -c 3 dos-default
ping: bad address 'dos-default'
/ # ping -c 3 172.17.0.3
PING 172.17.0.3 (172.17.0.3): 56 data bytes
64 bytes from 172.17.0.3: seq=0 ttl=64 time=0.128 ms
64 bytes from 172.17.0.3: seq=1 ttl=64 time=0.236 ms
64 bytes from 172.17.0.3: seq=2 ttl=64 time=0.144 ms

--- 172.17.0.3 ping statistics ---
3 packets transmitted, 3 packets received, 0% packet loss
round-trip min/avg/max = 0.128/0.169/0.236 ms
</pre>

Ahora la variable ENV. En la consola 1 se ve
<pre>
/ # env
HOSTNAME=d91a93362548
SHLVL=1
HOME=/root
VAR=uno
TERM=xterm
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
PWD=/
</pre>

Y en la consola 2 se ve

<pre>
/ # env
HOSTNAME=a2fd5ecdf11c
SHLVL=1
HOME=/root
VAR=dos
TERM=xterm
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
PWD=/
UNO_ENV_VAR=uno
UNO_NAME=/dos-default/uno
</pre>

O sea, el link va de dos-default a uno-default. De forma que en 2 veo la variable VAR de uno, pero en 1 no veo la de dos-default. Asi que el link (por mas que estan en la misma red) va en un sentido

## Ejercicio 3

Creo la red

<pre>
➜  actividad-04 git:(main) ✗ docker network create net-user
73e60fd8655e8b2c85e0cd742d9722bbfc9f1c3eb3694ba103b596383006d98f
</pre>

Consola 1

<pre>
➜  actividad-04 git:(main) ✗ docker run -it --rm --name uno-user -e VAR=uno --network net-user alpine
/ # ip add ls
....
    inet 172.19.0.2/16 brd 172.19.255.255 scope global eth0
       valid_lft forever preferred_lft forever

/ # ping -c 3 172.19.0.3
PING 172.19.0.3 (172.19.0.3): 56 data bytes
64 bytes from 172.19.0.3: seq=0 ttl=64 time=0.213 ms
64 bytes from 172.19.0.3: seq=1 ttl=64 time=0.389 ms
64 bytes from 172.19.0.3: seq=2 ttl=64 time=0.221 ms

--- 172.19.0.3 ping statistics ---
3 packets transmitted, 3 packets received, 0% packet loss
round-trip min/avg/max = 0.213/0.274/0.389 ms

/ # ping -c 3 dos-user
PING dos-user (172.19.0.3): 56 data bytes
64 bytes from 172.19.0.3: seq=0 ttl=64 time=0.123 ms
64 bytes from 172.19.0.3: seq=1 ttl=64 time=0.300 ms
64 bytes from 172.19.0.3: seq=2 ttl=64 time=0.278 ms

--- dos-user ping statistics ---
3 packets transmitted, 3 packets received, 0% packet loss
round-trip min/avg/max = 0.123/0.233/0.300 ms

/ # env
HOSTNAME=4c2813c5ef70
SHLVL=1
HOME=/root
VAR=uno
TERM=xterm
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
PWD=/

</pre>

Consola 2
<pre>
➜  actividad-04 git:(main) ✗ docker run -it --rm --name dos-user -e VAR=dos --network net-user alpine
/ # ip add ls
....
    inet 172.19.0.3/16 brd 172.19.255.255 scope global eth0
       valid_lft forever preferred_lft forever

/ # ping -c 3 172.19.0.2
PING 172.19.0.2 (172.19.0.2): 56 data bytes
64 bytes from 172.19.0.2: seq=0 ttl=64 time=0.287 ms
64 bytes from 172.19.0.2: seq=1 ttl=64 time=0.218 ms
64 bytes from 172.19.0.2: seq=2 ttl=64 time=0.431 ms

--- 172.19.0.2 ping statistics ---
3 packets transmitted, 3 packets received, 0% packet loss
round-trip min/avg/max = 0.218/0.312/0.431 ms

/ # ping -c 3 uno-user
PING uno-user (172.19.0.2): 56 data bytes
64 bytes from 172.19.0.2: seq=0 ttl=64 time=0.097 ms
64 bytes from 172.19.0.2: seq=1 ttl=64 time=0.449 ms
64 bytes from 172.19.0.2: seq=2 ttl=64 time=0.242 ms

--- uno-user ping statistics ---
3 packets transmitted, 3 packets received, 0% packet loss
round-trip min/avg/max = 0.097/0.262/0.449 ms

/ # env
HOSTNAME=01f90e9e7140
SHLVL=1
HOME=/root
VAR=dos
TERM=xterm
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
PWD=/
/ # 

</pre>

Conclusiones:
 - El PING funciona tanto por IP (como en la default del ejericio 1) como por nombre. 
 - Las variables de ambiente no se comparten entre equipos

Ahora si mientras dejo corriendo un ping sin fin y desconecto la red 

<pre>
docker network disconnect net-user uno-user 
</pre>

En uno-user, perdio la conexion a red, y dos-user se quedo "esperando" el retorno de uno-user. Si la vuelvo a conectar

<pre>
docker network connect net-user uno-user 
</pre>

dos-user recupero el ping


## Ejercicio 4

Es con "--network none", por ejemplo

<pre>
➜  actividad-04 git:(main) ✗ docker run -it --rm --name dos-user -e VAR=dos --network none alpine    
/ # ip add ls
1: lo: &lt;LOOPBACK,UP,LOWER_UP&gt; mtu 65536 qdisc noqueue state UNKNOWN qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
2: tunl0@NONE: &lt;NOARP&gt; mtu 1480 qdisc noop state DOWN qlen 1000
    link/ipip 0.0.0.0 brd 0.0.0.0
3: ip6tnl0@NONE: &lt;NOARP&gt; mtu 1452 qdisc noop state DOWN qlen 1000
    link/tunnel6 00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00 brd 00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00
</pre>


## Ejercicio 5

Elimino la red anterior y la creo en otra subnet

<pre>
➜  actividad-04 git:(main) ✗ docker network rm net-user 
net-user

➜  actividad-04 git:(main) ✗ docker network create net-user --subnet 192.168.2.0/24  
a0c8bb442c4402225cda8ec43ec52d5fcbb326eadb1c831c3caf97dc713be33b
</pre>

En la consola 1
<pre>
➜  actividad-04 git:(main) ✗ docker run -it --rm --name uno-user -e VAR=uno --network net-user alpine
/ # ip add ls
....
    inet 192.168.2.2/24 brd 192.168.2.255 scope global eth0
       valid_lft forever preferred_lft forever
</pre>

En la consola 2:
<pre>
➜  actividad-04 git:(main) ✗ docker run -it --rm --name dos-user -e VAR=dos --network net-user alpine
/ # ip add ls
....
    inet 192.168.2.3/24 brd 192.168.2.255 scope global eth0
       valid_lft forever preferred_lft forever
</pre>

Los dos containers esta en la subred definida

# Limite de recursos

## Ejercicio 1

Observo que cada vez tomaba mas recursos. Pero no mucho mas, entonces lo modifique para darle mas punchi

<pre>
docker run --rm progrium/stress -c 1 --vm 1 --vm-bytes 2000m -t 60
</pre>

Termino pero se veia como tenia tomado casi toda la computadora (Y sentia que iba a salir volando)

## Ejercicio 2

Como estoy en MacOs y no existe el swapoff, combine conocimiento y lo hice dentro de un vagrant

<pre>
vagrant init gusztavvargadr/docker-linux
vagrant up
vagrant ssh
</pre>

El exit code fue (0)

<pre>
{ 
    "Status": "exited",
    "Running": false,
    "Paused": false,
    "Restarting": false,
    "OOMKilled": false,
    "Dead": false,
    "Pid": 0,
    "ExitCode": 0,
    "Error": "",
    "StartedAt": "2020-11-09T23:33:14.410750307Z",
    "FinishedAt": "2020-11-09T23:34:14.439141062Z"
}
</pre>

Lo volvi a tirar pero --vm-bytes 2000m, y aca ni arranco

<pre>
docker inspect 64f84389ce08 --format '{{json .State}}'|jq
</pre>

<pre>
{
  "Status": "exited",
  "Running": false,
  "Paused": false,
  "Restarting": false,
  "OOMKilled": false,
  "Dead": false,
  "Pid": 0,
  "ExitCode": 1,
  "Error": "",
  "StartedAt": "2020-11-09T23:44:48.438985001Z",
  "FinishedAt": "2020-11-09T23:44:48.494839347Z"
}
</pre>

Y salio con exit(1), pero no pude lograr que lo mate el OOMKiller