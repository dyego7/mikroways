# Contribuir a un repositorio en GitHub
Ya aceptado el [pull request](https://github.com/Mikroways/wfc-afip-sandbox/pull/5)

# Analizando Git Flow

A mi entender, el modelo estándar de [GitFlow](https://nvie.com/posts/a-successful-git-branching-model/) no es apto como esta "by the book" en proyectos que manejan varias versiones a la vez:

Un proyecto con varias versiones a la vez deberían en principio tener mas de un main asociado. ¿Y si tenes mas de una versión? Cual esta en el main? ¿La ultima? La estable? 

En una época, debido al ciclo de desarrollo que teníamos (y trabajando en SVN) un modelo un poco diferente:
 * Existían 3 branches, a saber: PRODUCCION, QA, DEVELOP
 * Cuando se debía hacer un fix, se hacia en QA y luego, si aplicaba se pasaba también a develop.
 * Si se encontraba un incidente en producción, se solucionaba en PRODUCCION, y se pasaba a QA y develop si correspondía.

O sea, todo arreglo en un branch de mayor orden se solucionaba de corresponder en el branch de menor orden.

Existen otros modelos que me gustan, por ejemplo:
* [Uso del branch "support"](https://blog.nathanaelcherrier.com/en/several-versions-gitflow/). En el Main esta solo la ultima versión, y luego existe un branch "support" por cada versión soportada. Y que esta soportado por [la extension flow de git](https://github.com/nvie/gitflow). Ver [aquí](https://stackoverflow.com/questions/16562339/git-flow-and-master-with-multiple-parallel-release-branches/16866118#16866118)
* [Gitlab-flow](https://docs.gitlab.com/ee/topics/gitlab_flow.html)
