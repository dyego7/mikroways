# Ejercicio 1

El docker-compose del ejemplo levanta dos dockers, a saber:

<pre>
docker network create actividad-05_default

docker run -d --name db --mount src=db_data,dst=/var/lib/mysql --restart always -e MYSQL_ROOT_PASSWORD=somewordpress -e MYSQL_DATABASE=wordpress -e MYSQL_USER=wordpress -e MYSQL_PASSWORD=wordpress --network actividad-05_default mysql:5

docker run -d --name wordpress --mount src=wp_data,dst=/var/www/html -p 80:80 --restart always -e WORDPRESS_DB_HOST=db:3306 -e WORDPRESS_DB_USER=wordpress -e WORDPRESS_DB_PASSWORD=wordpress -e WORDPRESS_DB_NAME=wordpress --network actividad-05_default wordpress:latest
</pre>

PD: En realidad con el docker-compose, los volumenes se llaman diferente (Comienzan con actividad-05). 

Para agregar un phpmyadmin agregue al [docker-compose.yml](actividad-05/wordpress/docker-compose.yml)

<pre>
   phpmyadmin:
     depends_on:
       - db
     image: phpmyadmin:5.0
     ports:
       - "8080:80"
     restart: always
     environment:
        PMA_HOST: db
        PMA_PORT: 3306
</pre>

# Ejercicio 2

 - docker-compose create y docker-compose up: "up" Crea redes, volumenes e inicia los servicios. "create" levanta, pero tiene que estar creado previamente
 - docker-compose stop y docker-compose down: "stop" para los servicios", "down" ademas los elimina 
 - docker-compose run y docker-compose exec: El primero corre un comando contra el servicio (Ver [doc](https://docs.docker.com/compose/reference/run/)). Exec es el equivalente a "docker exec" (Ver [doc](https://docs.docker.com/compose/reference/exec/))

# Ejercicio 3

Utilice este [docker-compose.yml](actividad-05/redmine/docker-compose.yml)

<pre>
version: '3.8'
 
services:
   db:
     image: mysql:5.7
     volumes:
       - db_data:/var/lib/mysql
     restart: always
     environment:
       MYSQL_ROOT_PASSWORD: therootpassword
       MYSQL_DATABASE: redmine

   phpmyadmin:
     depends_on:
       - db
     image: phpmyadmin:5.0
     ports:
       - "8080:80"
     restart: always
     environment:
        PMA_HOST: db
        PMA_PORT: 3306
 
   redmine:
     depends_on:
       - db
     image: redmine:latest
     volumes:
       - rm_data:/usr/src/redmine/files
     ports:
       - "80:3000"
     restart: always
     environment:
       REDMINE_DB_MYSQL: db
       REDMINE_DB_PASSWORD: therootpassword
       REDMINE_SECRET_KEY_BASE: supersecretkey
volumes:
    db_data: {}
    rm_data: {}

</pre>

Le agregue un phpmyadmin por las dudas.

Tuve que agregar dos volumenes, uno para el mysql y otro para los files de redmine.

Luego de hacer el "docker-compose down" y volver a levantarlo todo sigue funcionando. (Basicamente porque no lo corri con "-v")

## Para instalar additionals

1. Modifique el [docker-componse.yml](actividad-05/redmine-additionals/docker-compose.yml) para agregar tanto el mapeo a un nuevo volumen para plugins como la sentencia para que haga la migrations luego de un nuevo plugins

<pre>
   redmine:
     depends_on:
       - db
     image: redmine:latest
     volumes:
       - rm_data:/usr/src/redmine/files
       <b>- rm_plugins:/usr/src/redmine/plugins</b>
     ports:
       - "80:3000"
     restart: always
     environment:
       REDMINE_DB_MYSQL: db
       REDMINE_DB_PASSWORD: therootpassword
       REDMINE_SECRET_KEY_BASE: supersecretkey
       <b>REDMINE_PLUGINS_MIGRATE: 1</b>
volumes:
    db_data: {}
    rm_data: {}
    <b>rm_plugins: {}</b>
</pre>

2. docker-compose up

3. con docker-exec. entre al docker

<pre>
docker exec -ti 519d768711bb bash
</pre>

4. Baje el plugin

<pre>
root@519d768711bb:/usr/src/redmine# cd plugins/
root@519d768711bb:/usr/src/redmine/plugins# git clone -b v3-stable https://github.com/AlphaNodes/additionals.git additionals
root@519d768711bb:/usr/src/redmine/plugins# exit
</pre>

5. Reinicie el compose

# Ejercicio 4

Creo un [Dockerfile](actividad-05/redmine-docker/Dockerfile)

<pre>
FROM redmine:latest

RUN git clone -b v3-stable https://github.com/AlphaNodes/additionals.git plugins/additionals
</pre>

Contruyo lo imagen

<pre>
➜  redmine-docker git:(main) ✗ docker build -t redmine-adittionals .
Sending build context to Docker daemon  3.584kB
Step 1/2 : FROM redmine:latest
 ---> 7d3df10e1f6c
Step 2/2 : RUN git clone -b v3-stable https://github.com/AlphaNodes/additionals.git plugins/additionals
 ---> Running in 51e775e25dc4
Cloning into 'plugins/additionals'...

Removing intermediate container 51e775e25dc4
 ---> f98cdaeeaab4
Successfully built f98cdaeeaab4
Successfully tagged redmine-adittionals:latest
</pre>

Luego con el [docker-componse.yml](actividad-05/redmine-docker/docker-compose.yml) (Igual al del ejercicio anterior per modificando la imagen de redmine a la recien creada)

<pre>
➜  redmine-docker git:(main) ✗ docker-compose up
</pre>

# Ejercicio 5

<pre>
➜  redmine-additionals git:(main) ✗ docker  exec -ti redmine-docker_redmine_1 rails console
W, [2020-11-10T01:41:46.069842 #63]  WARN -- : Creating scope :system. Overwriting existing method Enumeration.system.
W, [2020-11-10T01:41:46.207697 #63]  WARN -- : Creating scope :sorted. Overwriting existing method User.sorted.
W, [2020-11-10T01:41:46.216171 #63]  WARN -- : Creating scope :sorted. Overwriting existing method Group.sorted.
W, [2020-11-10T01:41:46.220804 #63]  WARN -- : Creating scope :visible. Overwriting existing method Principal.visible.
Loading production environment (Rails 5.2.4.2)

irb(main):001:0> user = User.find_by login: 'admin'
=> #<User id: 1, login: "admin", hashed_password: "99d9c51592a9e4b526073514b84e25c0d539f16a", firstname: "Redmine", lastname: "Admin", admin: true, status: 1, last_login_on: "2020-11-10 01:39:24", language: "", auth_source_id: nil, created_on: "2020-11-10 01:36:10", updated_on: "2020-11-10 01:39:32", type: "User", identity_url: nil, mail_notification: "all", salt: "a06fe7276828d18c2aa328fe5e3f41a4", must_change_passwd: false, passwd_changed_on: "2020-11-10 01:39:32">

irb(main):002:0> user.password = 'Mikroways2020'
=> "Mikroways2020"

irb(main):003:0> user.save!
=> true

irb(main):004:0> exit
➜  redmine-additionals git:(main) ✗ 
</pre>

Y el usuario quedo modificado!!

