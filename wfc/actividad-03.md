# TDD

Hecho en [github](
https://github.com/gdelacruz/seven-display/tree/master)

# Despliegue contínuo

[Resultado](https://gdelacruz.gitlab.io/myresume/)

[Codigo Fuente](https://gitlab.com/gdelacruz/myresume)

**Notas**

Tuve que agregar "jsonresume-theme-elegant" (npm install --save jsonresume-theme-elegant) para que funcione. Lo extraño es que en gitlab no fallaba el build, sino el deploy. Leyendo el log (No se nada de node sinceramente, vi esto)

<pre>
....
You have to install this theme relative to the folder to use it e.g. `npm install jsonresume-theme-elegant`

Uploading artifacts for successful job
.....
</pre>

Se ve en el Job [831011867](https://gitlab.com/gdelacruz/myresume/-/jobs/831011867). Luego de corregirlo, ahora si en el job [831019523](https://gitlab.com/gdelacruz/myresume/-/jobs/831019523) se ve bien

<pre>
...
Done! Find your new .html resume at:
 /builds/gdelacruz/myresume/public/index.html
Your resume-cli software is up-to-date.

Uploading artifacts for successful job
....
</pre>

PD: Entre no, muy bueno!!!!!!!

