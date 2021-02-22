# Examen.parcial1
## Proyecto parcial 1 / tópicos de física
### AGUILAR ROMO DANNA PAULINA    
* * *
**El contenido de este repositorio se encuentra en el archivo tipo Shader, con el modelo de luz basado en el Lambert en Unity.**

*Su contenido se deslinda de lo siguiente:*  

1.Creacion de un Shader para armar una escena 3D con un modelo.  
2.Basado en Lambert.  
3.Efecto Rim, Phong, Banded, Wrap.  
4.Mapa de normales, Textura y color.  
5.Control de intensidad, control principal del Albedo para iluminación.
___
### Contenido y explicación
Lo primero que se realizo fue una creación de Shader en Unlit, con un modelo básico de luz Lambert. Al siguiente paso fue analizar lo que se pedía en el proyecto, así se empezó a realizar, en primera estancia se descargó un modelo básico de Unity Tiger con el cual se tomó solo el modelo base, su textura y mapa de normales. [enlace de Tiger](https://assetstore.unity.com/packages/3d/characters/animals/mammals/golden-tiger-55797)  
El Shader se nombró como Banded-TS, donde para llegar a tal resultado de nuestro modelo, se implementaron distintos contendidos y Lightings.
En el Código base del shader, se empezó colocando el color y textura con _MainTex y _Albedo. Después se pide la Normal donde nos encontramos con la textura y el Strengh las cuales nos permiten agregar detalles superficiales al modelo y permite que atrape la luz de una manera más real.  

Para poder tener ese efecto de punto brillante y que la luz no se altere tan abruptamente colocamos lo que es el Wrap y el Phong, el cual nos permite controlar las sombras y el cambio de en la calidad de la luz, mientras que el Phong nos da el reflejo de la luz como el punto brillante desde el reflejo de un vector, donde se calcula desde la ViewDir donde se necesita calcular el difuso el cual nos ayuda a reflejar la luz, en el Phong se colcoca lo que es el Specular color el cual representa el color de la luz, SpecularPower es la intensidad, SpecularGloss nos da la inmensidad del brillo y los GlossSteps nos agranda los pasos que le toma al punto llegar a lo más alto para poder ahorrar memoria.  

Con el Rim creamos la luz que se acomoda en la orilla y se calcula desde donde lo estamos viendo junto con el producto punto, esto se transformó y nos dio un color como iluminación que queda por fuera de nuestro modelo.Para darle ese efecto de sombras caídas en distintas etapas del color, se utilizo el Ramp Texture o Color Ramp, este nos indica que color tomara dependiendo de la luz, esto nos ayuda a que el efecto sombra tenga distintas tonalidades de caída al color.  

Por último, tenemos el efecto Banded, el cual al igual que los anteriores está basado en Lambert. Nos permite usar las interacciones utilizando steps, se usa un coeficiente que samplea la luz en un conjunto de tramas que se pueden ir utilizando debido a como se desarrolla. Los steps se colocan debido a como se van utilizando, estos nos da el efecto de parecido al Ramp Texture pero de una manera mas estilizada. 

