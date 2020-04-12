

; Sistema experto encargado de asesorar en la elección de rama
;
; Autor: Luis Antonio Ortega Andrés
;
; Experta: Johanna Capote Robayna
;
; Se utilizaran los hechos (Motivo ?rama ?texto) para representar los motivos por los que escoger esa rama.
; El hecho (p ?rama ?n) hará referencia a que la rama en cuestión ha obtenido n puntos, a mayor cantidad de puntos
;  mayor probabilidad de ser recomendada.
;
; El Sistema Experto permite acceder a la recomendación sin necesidad de responder todas las preguntas, para ello:
;  - Responder con una 'R' resultará en la finalización de todas las preguntas y la recomendación de una rama.
;  - Responder cualquier otro caracter que no se encuentre indicado en la pregunta o sea R, será equivalente a no responder dicha pregunta (luego no se contabilizará).
;
; Como respuesta a cada pregunta se crearán los hechos (Respuesta ?tema ?x) y (Contabilizar ?tema)
; el segundo de ellos se utlizará para activar la regla encargada de sumar los puntos a las ramas que lo requieran.
; dependiendo de la respuesta dada.
;
; El hecho (No_seguir) indica que no se desea seguir realizando preguntas, ya porque no queden o porque el usuario lo haya decidido.
;
; Existen dos formas de recomentar una rama:
;  - Se cumplan unas condiciones concretas que el experto considera son necesarias y suficientes, por ejemplo,
;    se recomendará la rama de Ingenieria de Computadores si el usuario muestra interes por el Hardware, la Electronica y la Programación Paralela.
;  - En caso de no cumplirse las condiciones de ninguna rama, se escogerá aquella o aquellas con una mayor puntuación.


; Definición de ramas
(deffacts Ramas
  (Rama Computacion_y_Sistemas_Inteligentes "Computacion y Sistemas Inteligentes")
  (Rama Ingenieria_del_Software "Ingenieria del Software")
  (Rama Ingenieria_de_Computadores "Ingenieria de Computadores")
  (Rama Sistemas_de_Informacion "Sistemas de Informacion")
  (Rama Tecnologias_de_la_Informacion "Tecnologias de la Informacion")
  )

; Inicialización del sistema de puntos
(deffacts Estado_Inicial
  (p Computacion_y_Sistemas_Inteligentes 0)
  (p Ingenieria_del_Software 0)
  (p Ingenieria_de_Computadores 0)
  (p Sistemas_de_Informacion 0)
  (p Tecnologias_de_la_Informacion 0)
  )

; Mensaje de bienvenida
(defrule Texto_inicial
(declare (salience 10))
=>
(printout t "Bienvenido al Sistema Experto encargado de asesorar en la elección de una rama. Tras cada pregunta aparecerá entre parentesis las posibles respuestas, cualquier otra respuesta se considerará como NS/NC. Además se puede responde 'R' para obtener una recomendación con las respuestas actuales sin realizar todas las preguntas." crlf)
)

; Regla auxiliar utilizada para sumar puntos a las distintas ramas
; Definir el hecho (Suma ?pcsi ?pic ?pis ?psi ?pti)
; resultará en aumentar la puntuación de cada rama en el valor indicado.
(defrule Sumar
  (declare (salience 10))
  ?sumar <- (Suma ?pcsi ?pic ?pis ?psi ?pti)
  ?csi <- (p Computacion_y_Sistemas_Inteligentes ?n1)
  ?ic <- (p Ingenieria_de_Computadores ?n2)
  ?is <- (p Ingenieria_del_Software ?n3)
  ?si <- (p Sistemas_de_Informacion ?n4)
  ?ti <- (p Tecnologias_de_la_Informacion ?n5)
 =>
  (retract ?sumar ?csi ?ic ?is ?si ?ti)
  (assert (p Computacion_y_Sistemas_Inteligentes (+ ?pcsi ?n1))
          (p Ingenieria_de_Computadores (+ ?pic ?n2))
          (p Ingenieria_del_Software (+ ?pis ?n3))
          (p Sistemas_de_Informacion (+ ?psi ?n4))
          (p Tecnologias_de_la_Informacion (+ ?pti ?n5))
          )
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;; PREGUNTAS  ;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; HARDWARE
(defrule Pregunta_hw
  (not (No_seguir))
 =>
  (printout t "¿Te gusta el Hardware? (S/N) ")
  (assert (Respuesta hardware (read)) (Contabilizar_hw))
)

; Respuesta afirmativa
(defrule Respuesta_hw_s
  (declare (salience 1))
  (Respuesta hardware S)
  ?f <- (Contabilizar_hw)
 =>
  (retract ?f)
  (assert
    ;(Suma ?csi ?ic ?is ?si ?ti)
    (Suma 1 3 0 0 0)
    (Motivo Ingenieria_de_Computadores "es la mejor opción si te gusta el Hardware, ")
    )
)

; Respuesta negativa
(defrule Respuesta_hw_n
  (declare (salience 1))
  (Respuesta hardware N)
  ?f <- (Contabilizar_hw)
 =>
  (retract ?f)
  (assert
    ; (Suma ?csi ?ic ?is ?si ?ti)
    (Suma 1 0 1 1 1)
    (Motivo Tecnologias_de_la_Informacion "como no te gusta el hardware, esta es una de las ramas donde no se trata en profundiad ese tema, ")
    (Motivo Sistemas_de_Informacion "como no te gusta el hardware, esta es una de las ramas donde no se trata en profundiad ese tema, ")
    (Motivo Computacion_y_Sistemas_Inteligentes "como no te gusta el hardware, esta es una de las ramas donde no se trata en profundiad ese tema, ")
    (Motivo Ingenieria_del_Software "como no te gusta el hardware, esta es una de las ramas donde no se trata en profundiad ese tema, ")
    )
)

; ELECTRONICA
(defrule Pregunta_electronica
  (not (No_seguir))
 =>
  (printout t "¿Te gusta la Electrónica? (S/N) ")
  (assert (Respuesta electronica (read)) (Contabilizar_elec))
)

; Respuesta afirmativa
(defrule Respuesta_electronica_s
  (declare (salience 1))
  (Respuesta electronica S)
  ?f <- (Contabilizar_elec)
 =>
  (retract ?f)
  (assert
    ; (Suma ?csi ?ic ?is ?si ?ti)
    (Suma 0 3 0 0 0)
    (Motivo Ingenieria_de_Computadores "esta es la única rama donde se trata electrónica, ")
    )
)

; Respuesta negativa
(defrule Respuesta_electronica_n
  (declare (salience 1))
  (Respuesta electornica N)
  ?f <- (Contabilizar_elec)
 =>
  (retract ?f)
  (assert
    ; (Suma ?csi ?ic ?is ?si ?ti)
    (Suma 1 0 1 1 1)
    )
)


; PROGRAMACION PARALELA
(defrule Pregunta_paralela
  (not (No_seguir))
 =>
  (printout t "¿Te gusta la Programación Paralela? (S/N) ")
  (assert (Respuesta paralela (read)) (Contabilizar_para))
)

; Respuesta afirmativa
(defrule Respuesta_para_s
  (declare (salience 1))
  (Respuesta paralela S)
  ?f <- (Contabilizar_para)
 =>
  (retract ?f )
  (assert
    ; (Suma ?csi ?ic ?is ?si ?ti)
    (Suma 1 1 1 0 0)
    (Motivo Ingenieria_de_Computadores "esta es una de las ramas donde se utiliza programación paralela, ")
    (Motivo Computacion_y_sistemas_Inteligentes "esta es una de las ramas donde se utiliza programación paralela, ")
    (Motivo Ingenieria_del_Software "esta es una de las ramas donde se utiliza programación paralela, ")
    )
)

; Respuesta negativa
(defrule Respuesta_para_n
  (declare (salience 1))
  (Respuesta paralela N)
  ?f <- (Contabilizar_para)
 =>
  (retract ?f )
  (assert
    ; (Suma ?csi ?ic ?is ?si ?ti)
    (Suma 0 0 0 1 1)
    )
)


; NOTA MEDIA
(defrule Pregunta_nota
  (not (No_seguir))
 =>
  (printout t "¿Cuál es tu nota media? (5-10) ")
  (assert (Respuesta nota (read)) (Contabilizar_media))
)

; Nota baja
(defrule Respuesta_nota_1
  (declare (salience 1))
  ?f <- (Contabilizar_media)
  (Respuesta nota ?n)
  (test (numberp ?n))
  (test (< ?n 6.6))
 =>
  (retract ?f )
  (assert
    ; (Suma ?csi ?ic ?is ?si ?ti)
    (Suma 0 1 0 0 1)
    (Nota_baja)
    (Motivo Ingenieria_de_Computadores "es una de las ramas menos exigentes, ")
    (Motivo Tecnologias_de_la_Informacion "es una de las ramas menos exigentes, ")
    )
)

; Nota media
(defrule Respuesta_nota_2
  (declare (salience 1))
  ?f <- (Contabilizar_media)
  (Respuesta nota ?n)
  (test (numberp ?n))
  (test (>= ?n 6.6))
  (test (< ?n 8.3))
 =>
  (retract ?f )
  (assert
    ; (Suma ?csi ?ic ?is ?si ?ti)
    (Suma 1 0 1 1 0)
    (Nota_media)
    (Motivo Ingenieria_del_Software "es una de las ramas de dificultad media, ")
    (Motivo Computacion_y_Sistemas_Inteligentes "es una de las ramas de dificultad media, ")
    (Motivo Sistemas_de_la_Informacion "es una de las ramas de dificultad media, ")
    )
)

; Nota alta
(defrule Respuesta_nota_3
  (declare (salience 1))
  ?f <- (Contabilizar_media)
  (Respuesta nota ?n)
  (test (numberp ?n))
  (test (>= ?n 8.3))
 =>
  (retract ?f )
  (assert
    ; (Suma ?csi ?ic ?is ?si ?ti)
    (Suma 1 0 0 0 0)
    (Nota_alta)
    (Motivo Computacion_y_Sistemas_Inteligentes "es la rama más exigente, ")
    )
)


; TRABAJAR
(defrule Pregunta_trabajar
  (not (No_seguir))
 =>
  (printout t "¿Dónde te gustaría trabajar? (D)ocendia, Empresa (Pu)blica o (Pr)ivada ")
  (assert (Respuesta trabajar (read)) (Contabilizar_trabajar))
)

; Docencia
(defrule Respuesta_trabajo_1
  (declare (salience 1))
  ?f <- (Contabilizar_trabajar)
  (Respuesta trabajar D)
 =>
  (retract ?f)
  (assert
    ; (Suma ?csi ?ic ?is ?si ?ti)
    (Suma 1 0 0 0 0)
    (Motivo Computacion_y_Sistemas_Inteligentes "actualmente es la rama más enfocada a la investigación, ")
    )
)

; Empresa publica
(defrule Respuesta_trabajo_2
  (declare (salience 1))
  ?f <- (Contabilizar_trabajar)
  (Respuesta trabajar Pu)
 =>
  (retract ?f )
  (assert
    ; (Suma ?csi ?ic ?is ?si ?ti)
    (Suma 0 1 1 0 0)
    (Motivo Ingenieria_del_Software "es una de las ramas con más salida en empresa pública, ")
    (Motivo Ingenieria_de_Computadores "es una de las ramas con más salida en empresa pública, ")
    )
)

; Empresa privada
(defrule Respuesta_trabajo_3
  (declare (salience 1))
  ?f <- (Contabilizar_trabajar)
  (Respuesta trabajar Pr)
 =>
  (retract ?f)
  (assert
    ; (Suma ?csi ?ic ?is ?si ?ti)
    (Suma 1 0 0 1 0)
    (Motivo Sistemas_de_Informacion "es una de las ramas con más salida en la empresa privada, ")
    (Motivo Computacion_y_Sistemas_Inteligentes "es una de las ramas con más salida en la empresa privada, ")
    )
)


; PROGRAMACIÓN
(defrule Pregunta_programar
  (not (No_seguir))
=>
  (printout t "¿Consideras que te gusta programar? (S/N) ")
  (assert (Respuesta programar (read)) (Contabilizar_programar))
)

; Respuesta afirmativa
(defrule Respuesta_programar_s
  (declare (salience 1))
  ?f <- (Contabilizar_programar)
  (Respuesta programar S)
 =>
  (retract ?f)
  (assert
    ; (Suma ?csi ?ic ?is ?si ?ti)
    (Suma 1 0 1 1 0)
    (Motivo Ingenieria_del_Software "es esta rama se aprende a diseñar programas, ")
    (Motivo Computacion_y_Sistemas_Inteligentes "en esta rama se realiza mucha programación algorítmica, ")
    (Motivo Sistemas_de_Informacion "es una de las ramas donde se realiza programación, ")
    )
)

; Respuesta Negativa
(defrule Respuesta_programar_n
  (declare (salience 1))
  ?f <- (Contabilizar_programar)
  (Respuesta programar N)
 =>
  (retract ?f )
  (assert
    ; (Suma ?csi ?ic ?is ?si ?ti)
    (Suma 0 0 0 0 1)
    (Motivo Tecnologias_de_la_Informacion "en esta rama la programación que se realiza es Web, ")
    )
)


; MATEMÁTICAS
(defrule Pregunta_matematicas
  (not (No_seguir))
 =>
  (printout t "¿Te gustan las matemáticas? (S/N) ")
  (assert (Respuesta matematicas (read)) (Contabilizar_matematicas))
)

; Respuesta afirmativa
(defrule Respuesta_matematicas_s
  (declare (salience 1))
  ?f <- (Contabilizar_matematicas)
  (Respuesta matematicas S)
 =>
  (retract ?f )
  (assert
    ; (Suma ?csi ?ic ?is ?si ?ti)
    (Suma 1 0 0 0 0)
    (Motivo Computacion_y_Sistemas_Inteligentes "en esta rama existe un transfondo matemático importante, ")
    )
)

; Respuesta negativa
(defrule Respuesta_matematicas_n
  (declare (salience 1))
  ?f <- (Contabilizar_matematicas)
  (Respuesta matematicas N)
 =>
  (retract ?f )
  (assert
    ; (Suma ?csi ?ic ?is ?si ?ti)
    (Suma 0 1 1 1 1)
    )
)


; PROGRAMACIÓN WEB
(defrule Pregunta_web
  (not (No_seguir))
 =>
  (printout t "¿Te gustan la programación web? (S/N) ")
  (assert (Respuesta web (read)) (Contabilizar_web))
)

; Respuesta afirmativa
(defrule Respuesta_web_s
  (declare (salience 1))
  ?f <- (Contabilizar_web)
  (Respuesta web S)
 =>
  (retract ?f )
  (assert
    ; (Suma ?csi ?ic ?is ?si ?ti)
    (Suma 0 0 0 0 1)
    (Motivo Tecnologias_de_la_Informacion "en esta rama hay varias asignaturas orientadas a la programación web, ")
    )
)

; Respuesta negativa
(defrule Respuesta_web_n
  (declare (salience 1))
  ?f <- (Contabilizar_web)
  (Respuesta web N)
 =>
  (retract ?f )
  (assert
    ; (Suma ?csi ?ic ?is ?si ?ti)
    (Suma 1 1 1 1 0)
    )
)


; BASES DE DATOS
(defrule Pregunta_bases
  (not (No_seguir))
 =>
  (printout t "¿Te gustan el diseño y gestión de bases de datos? (S/N) ")
  (assert (Respuesta bases (read)) (Contabilizar_bases))
)

; Respuesta afirmativa
(defrule Respuesta_bases_s
  (declare (salience 1))
  ?f <- (Contabilizar_bases)
  (Respuesta bases S)
 =>
  (retract ?f)
  (assert
    ; (Suma ?csi ?ic ?is ?si ?ti)
    (Suma 0 0 0 1 0)
    (Motivo Sistemas_de_Informacion "en esta rama se tratan asignaturas relacionadas con bases de datos, ")
    )
)

; Respuesta negativa
(defrule Respuesta_bases_n
  (declare (salience 1))
  ?f <- (Contabilizar_bases)
  (Respuesta bases N)
 =>
  (retract ?f )
  (assert
    ; (Suma ?csi ?ic ?is ?si ?ti)
    (Suma 1 1 1 0 1)
    )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;; RESPUESTA PARCIAL ;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Cuando no queden preguntas, simulamos que ha terminado añadiendo artificlamente una respuesta R
(defrule End =>
(assert (Respuesta a R))
)

(defrule Sin_respuestas
  (declare (salience 100))
  (Respuesta bases ?)
  (p Computacion_y_Sistemas_Inteligentes 0)
  (p Tecnologias_de_la_Informacion 0)
  (p Ingenieria_de_Computadores 0)
  (p Sistemas_de_Informacion 0)
  (p Ingenieria_del_Software 0)
 =>
  (assert (No_seguir))
  (printout t "No has respondido a ninguna pregunta, luego no puedo aconsejarte." crlf)
)

; Calcular la rama o ramas con mayor puntuacion.
(defrule No_seguir
  (declare (salience 100))
  (Respuesta ? R)
  (p Computacion_y_Sistemas_Inteligentes ?n1)
  (p Tecnologias_de_la_Informacion ?n2)
  (p Ingenieria_de_Computadores ?n3)
  (p Sistemas_de_Informacion ?n4)
  (p Ingenieria_del_Software ?n5)
  (p ?a ?n)
  (not (Consejo ?a))
  (test (>= ?n ?n1))
  (test (>= ?n ?n2))
  (test (>= ?n ?n3))
  (test (>= ?n ?n4))
  (test (>= ?n ?n5))
 =>
  (assert (Consejo ?a) (No_seguir))
)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;; CONSEJOS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Ingenieria_de_Computadores
(defrule Ingenieria_de_Computadores
  (declare (salience 10))
  (Respuesta hardware S)
  (Respuesta electronica S)
  (Respuesta paralela S)
 =>
  (assert (Consejo Ingenieria_de_Computadores) (No_seguir))
)

; Computacion_y_Sistemas_Inteligentes
(defrule Computacion_y_Sistemas_Inteligentes
  (declare (salience 10))
  (Respuesta programar S)
  (Nota_alta)
  (Respuesta matematicas S)
  (Respuesta trabajar D)
 =>
  (assert (Consejo Computacion_y_Sistemas_Inteligentes)(No_seguir))
)

;Tecnologias_de_la_Informacion
(defrule Tecnologias_de_la_Informacion
  (declare (salience 10))
  (Respuesta hardware N)
  (Respuesta programar N)
  (Respuesta matematicas N)
  (Respuesta web S)
  (Respuesta bases N)
=>
  (assert (Consejo Tecnologias_de_la_Informacion) (No_seguir))
)

;Sistemas_de_Informacion
(defrule Sistemas_de_Informacion
  (declare (salience 10))
  (Respuesta hardware N)
  (Respuesta matematicas N)
  (Respuesta programar S)
  (Respuesta web S)
  (Respuesta bases S)
 =>
  (assert (Consejo Sistemas_de_Informacion) (No_seguir))
)

; Ingenieria_del_Software
(defrule Ingenieria_del_Software
  (declare (salience 10))
  (Respuesta hardware N)
  (Respuesta programar S)
  (or
   (Respuesta trabajar Pu)
   (Respuesta trabajar Pr)
   )
  (Respuesta matematicas N)
  (Respuesta web N)
  (Respuesta bases S)
 =>
  (assert (Consejo Ingenieria_del_Software) (No_seguir))
)

; Regla hecha para unir los motivos para recomendar una rama en una única cadena.
(defrule Unir_Motivos
  (declare (salience 15))
  (Consejo ?a)
  ?f1 <- (Motivo ?a ?b1)
  ?f2 <- (Motivo ?a ?b2)
  (test (neq ?b1 ?b2))
 =>
  (retract ?f1 ?f2)
  (assert (Motivo ?a (str-cat ?b1 ?b2)))
)

; Regla que muestra una rama a aconsejar junto con sus motivos
(defrule Motivos
  (Consejo ?a)
  ?f1 <- (Motivo ?a ?b2)
  (Rama ?a ?t)
 =>
  (retract ?f1)
  (printout t crlf "Te aconsejo "?t crlf)
  (printout t "Ya que, " ?b2 "por ello pienso que esta rama se ajusta a tu perfil." crlf)
  (printout t "Nombre de la experta: Johanna Capote Robayna." crlf)

)
