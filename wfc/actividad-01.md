# Lenguajes de desarrollo más populares en la actualidad

Según [Github](https://madnight.github.io/githut/#/pull_requests/2020/3) son:

1. JavaScript
2. Pyhon
3. Java
4. Go

Según [JetBrains](https://www.jetbrains.com/lp/devecosystem-2020/) son:
1. Java (El mas popular como lenguaje principal)
2. JavaScript (El mas usado)
3. Go, Kotlin, python (Los 3 top que se planea utilizar)

Dentro de Frameworks tenemos (Aunque super discutible)
1. [Java](https://medium.com/javarevisited/10-popular-java-frameworks-for-web-applications-691c28f6c182)
   - Spring Framework
   - Micronaut
   - Play
   - Spark

2. [JavaScript](https://www.lambdatest.com/blog/best-javascript-framework-2020/)
   - React.js (Front-end)
   - Vue.js (Front-end)
   - Angular.js (Front-end)
   - Express.js (Back-end)
   - Next.js (Back-end)

3. [Python](https://medium.com/front-end-weekly/top-10-python-frameworks-in-2020-b0b6e61a592a)
   - Django
   - Flask
   - Tornado

# Estandares de codificacion

En lineas generales, algunos lenguajes tienen o respetan mas de un estandar. Por ejemplo, Google tiene [una guia](https://google.github.io/styleguide/) publicada para varios lenguajes, que es muy buena

1. [Java](https://google.github.io/styleguide/javaguide.html)
2. [Python](https://google.github.io/styleguide/pyguide.html)
3. [Javascript](https://google.github.io/styleguide/jsguide.html)

Luego hay otras guias, propias, como:
1. [Kotlin Oficial](https://kotlinlang.org/docs/reference/code-style-migration-guide.html)
2. [Java Oficial](https://www.oracle.com/java/technologies/javase/codeconventions-contents.html)
3. [Python Oficial](https://www.python.org/dev/peps/pep-0008/)

## Conclusión
He trabajado en algún proyecto que mantenía un estándar de desarrollo, que inclusive lo integrábamos con la IDE y con chequeos en construcción continua de respeto del estándar. Lo que realmente complico las cosas fue cuando los equipos se fueron renovando y no se mantuvo el espíritu en el grupo.
A mi criterio, mantener un estándar es fundamental, no solo es una cuestión de prolijidad, sino que ayuda muchísimo a entender el código que escribió otro miembro del equipo y así solucionarlo.

# Schema migrations

1. Java
   - [Algunas de bajo nivel en Spring](https://docs.spring.io/spring-boot/docs/current/reference/html/howto.html#howto-database-initialization)
   - [Flyway](https://flywaydb.org)
   - [Liquibase](https://docs.liquibase.com/home.html)

2. Python
   - Dentro de Django existe [Migration](https://docs.djangoproject.com/en/3.1/topics/migrations/)

## Conclusión
Por la dinámica en la organización, no se utiliza herramientas de versionado de base. Sino, que se utilizar componentes que se suben en nexus, que tienen un estándar para su armado y estructurado (En carpetas y nombres de archivos). Si, no existe estándar para rollback. Los scripts son ejecutados manualmente por un administrador de base de datos. 
Si use alguna vez y a modo de prueba y juego el que viene con Ruby on rails y uno que venia en Tapestry 4.
