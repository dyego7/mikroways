# Contribuir a un repositorio en GitHub
Ya aceptado el [pull request](https://github.com/Mikroways/wfc-afip-sandbox/pull/5)

# Analizando Git Flow

A mi entender, el modelo estandar de [GitFlow](https://nvie.com/posts/a-successful-git-branching-model/) no es apto como esta "by the book" en proyectos que manejan varias versiones a la vez:

Un proyecto con varias versiones a la vez deberian en principio tener mas de un main asociado. ¿Y si tenes mas de una version? Cual esta en el main? ¿La ultima? La estable? 

En una epoca, debido al ciclo de desarrollo que teniamos (y trabajando en SVN) teniamos un modelo diferente:
 * Existian 3 branches, a saber: PRODUCCION, QA, DEVELOP
 * Cuando se debia hacer un fix, se hacia en QA y luego, si aplicaba se pasaba tambien a develop.
 * Si se encontraba un incidente en produccion, se solucionaba en PRODUCCION, y se pasaba a QA y develop si correspondia.

O sea, todo arreglo en un branch de mayor orden se solucinaba de corresponder en el branch de menor orden.

Existen otros modelos que me gustan, por ejemplo:
* [Uso del branch "support"](https://blog.nathanaelcherrier.com/en/several-versions-gitflow/). En el Main esta solo la ultima version, y luego existe un branch "support" por cada version soportada. Y que esta soportado por [la extension flow de git](https://github.com/nvie/gitflow). Ver [aqui](https://stackoverflow.com/questions/16562339/git-flow-and-master-with-multiple-parallel-release-branches/16866118#16866118)
* [Gitlab-flow](https://docs.gitlab.com/ee/topics/gitlab_flow.html): Que es conceptualmente bastante parecido al modelo que usabamos en SVN.
