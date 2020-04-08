

; Para representar que el sistema aconseja elegir una rama <nombre de la rama> por el motivo “<texto del motivo>” utilizaremos el hecho

; (Consejo <nombre de la rama> “<texto del motivo>”  “apodo del experto”)


(deffacts Ramas
  (Rama Computacion_y_Sistemas_Inteligentes)
  (Rama Ingenieria_del_Software)
  (Rama Ingenieria_de_Computadores)
  (Rama Sistemas_de_Informacion)
  (Rama Tecnologias_de_la_Informacion)
  )

(deffacts Estado_Inicial
  (p Computacion_y_Sistemas_Inteligentes 0)
  (p Ingenieria_del_Software 0)
  (p Ingenieria_de_Computadores 0)
  (p Sistemas_de_Informacion 0)
  (p Tecnologias_de_la_Informacion 0)
  )

(defrule Texto_inicial =>
(printout t "Bienvenido al sistema experto encargado de asesorar en la elección de una rama. Tras cada pregunta aparecerá entre parentesis las posibles respuestas, cualquier otra respuesta se considerará como NS/NC. Además se puede responde 'R' para obtener una recomendación con las respuestas actuales sin terminarlas todas." crlf)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;; HARDWARE ;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule Pregunta_hw
  (not (No_seguir))
 =>
  (printout t "¿Te gusta el Hardware? (S/N) ")
  (assert (Respuesta_hardware (read)) (Contabilizar_hw))
)

(defrule Respuesta_hw_s
  (declare (salience 1))
  (Respuesta_hardware S)
  ?f <- (Contabilizar_hw)
  ?f1 <- (p Ingenieria_de_Computadores ?n1)
  ?f2 <- (p Computacion_y_Sistemas_Inteligentes ?n2)
 =>
  (retract ?f ?f1 ?f2)
  (assert
    (p Ingenieria_de_Computadores (+ ?n1 2))
    (p Computacion_y_Sistemas_Inteligentes (+ ?n2 1))
    )
)
(defrule Respuesta_hw_n
  (declare (salience 1))
  (Respuesta_hardware N)
  ?f <- (Contabilizar_hw)
  ?f2 <- (p Tecnologias_de_la_Informacion ?n1)
  ?f3 <- (p Sistemas_de_Informacion ?n2)
  ?f4 <- (p Ingenieria_del_Software ?n3)
  ?f5 <- (p Computacion_y_Sistemas_Inteligentes ?n4)

 =>
  (retract ?f ?f2 ?f3 ?f4 ?f5)
  (assert
    (p Tecnologias_de_la_Informacion (+ ?n1 1))
    (p Sistemas_de_Informacion (+ ?n2 1))
    (p Ingenieria_del_Software (+ ?n3 1))
    (p Computacion_y_Sistemas_Inteligentes (+ ?n4 1))
    )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;; NOTA ;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule Pregunta_nota
  (not (No_seguir))
 =>
  (printout t "¿Cuál es tu nota media? (5-10)")
  (assert (Respuesta_nota (read)) (Contabilizar_media))
)

(defrule Respuesta_nota_1
  (declare (salience 1))
  ?f <- (Contabilizar_media)
  (Respuesta_nota ?n)
  (test (< ?n 6.6))
  ?f1 <- (p Ingenieria_de_Computadores ?n1)
  ?f2 <- (p Computacion_y_Sistemas_Inteligentes ?n2)
 =>
  (retract ?f ?f1 ?f2)
  (assert
    (Nota_baja)
    (p Ingenieria_de_Computadores (+ ?n1 1))
    (p Computacion_y_Sistemas_Inteligentes (+ ?n2 1))
    )
)

(defrule Respuesta_nota_2
  (declare (salience 1))
  ?f <- (Contabilizar_media)
  (Respuesta_nota ?n)
  (test (>= ?n 6.6))
  (test (< ?n 8.3))
  ?f1 <- (p Ingenieria_de_Computadores ?n1)
  ?f2 <- (p Computacion_y_Sistemas_Inteligentes ?n2)
 =>
  (retract ?f ?f1 ?f2)
  (assert
    (Nota_media)
    (p Ingenieria_de_Computadores (+ ?n1 1))
    (p Computacion_y_Sistemas_Inteligentes (+ ?n2 1))
    )
)

(defrule Respuesta_nota_3
  (declare (salience 1))
  ?f <- (Contabilizar_media)
  (Respuesta_nota ?n)
  (test (>= ?n 8.3))
  ?f1 <- (p Ingenieria_de_Computadores ?n1)
 =>
  (retract ?f ?f1)
  (assert
    (Nota_alta)
    (p Ingenieria_de_Computadores (+ ?n1 1))
    )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;; TRABAJAR ;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defrule Pregunta_trabajar
  (not (No_seguir))
 =>
  (printout t "¿Dónde te gustaría trabajar? (D)ocendia, Empresa (Pu)blica o (Pr)ivada ")
  (assert (Respuesta_trabajar (read)) (Contabilizar_trabajar))
)

(defrule Respuesta_trabajo_1
  (declare (salience 1))
  ?f <- (Contabilizar_trabajar)
  (Respuesta_trabajar D)
  ?f1 <- (p Ingenieria_del_Software ?n1)
  ?f2 <- (p Computacion_y_Sistemas_Inteligentes ?n2)
 =>
  (retract ?f ?f1 ?f2)
  (assert
    (p Ingenieria_del_Software (+ ?n1 1))
    (p Computacion_y_Sistemas_Inteligentes (+ ?n2 1))
    )
)

(defrule Respuesta_trabajo_2
  (declare (salience 1))
  ?f <- (Contabilizar_trabajar)
  (Respuesta_trabajar Pu)
  ?f1 <- (p Ingenieria_del_Software ?n1)
  ?f2 <- (p Computacion_y_Sistemas_Inteligentes ?n2)
  ?f3 <- (p Ingenieria_de_Computadores ?n3)
 =>
  (retract ?f ?f1 ?f2 ?f3)
  (assert
    (p Ingenieria_del_Software (+ ?n1 1))
    (p Computacion_y_Sistemas_Inteligentes (+ ?n2 1))
    (p Ingenieria_de_Computadores (+ ?n3 1))
    )
)

(defrule Respuesta_trabajo_3
  (declare (salience 1))
  ?f <- (Contabilizar_trabajar)
  (Respuesta_trabajar Pr)
  ?f1 <- (p Sistemas_de_Informacion ?n1)
  ?f2 <- (p Computacion_y_Sistemas_Inteligentes ?n2)
 =>
  (retract ?f ?f1 ?f2)
  (assert
    (p Sistemas_de_Informacion (+ ?n1 1))
    (p Computacion_y_Sistemas_Inteligentes (+ ?n2 1))
    )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;; PROGRAMAR ;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defrule Pregunta_programar
  (not (No_seguir))
=>
  (printout t "¿Consideras que te gusta programar? (S/N)")
  (assert (Respuesta_programar (read)) (Contabilizar_programar))
)

(defrule Respuesta_programar_s
  (declare (salience 1))
  ?f <- (Contabilizar_programar)
  (Respuesta_programar S)
  ?f1 <- (p Ingenieria_del_Software ?n1)
  ?f2 <- (p Computacion_y_Sistemas_Inteligentes ?n2)
  ?f3 <- (p Sistemas_de_Informacion ?n3)
 =>
  (retract ?f ?f1 ?f2 ?f3)
  (assert
    (p Ingenieria_del_Software (+ ?n1 1))
    (p Computacion_y_Sistemas_Inteligentes (+ ?n2 1))
    (p Sistemas_de_Informacion (+ ?n3 1))
    )
)

(defrule Respuesta_programar_n
  (declare (salience 1))
  ?f <- (Contabilizar_programar)
  (Respuesta_programar N)
  ?f1 <- (p Tecnologias_de_la_Informacion ?n1)
 =>
  (retract ?f ?f1)
  (assert
    (p Tecnologias_de_la_Informacion (+ ?n1 1))
    )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;; MATEMATICAS ;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule Pregunta_matematicas
  (not (No_seguir))
 =>
  (printout t "¿Te gustan las matemáticas? (S/N)")
  (assert (Respuesta_matematicas (read)) (Contabilizar_matematicas))
)
(defrule Respuesta_matematicas_s
  (declare (salience 1))
  ?f <- (Contabilizar_matematicas)
  (Respuesta_matematicas S)
  ?f1 <- (p Computacion_y_Sistemas_Inteligentes ?n1)
 =>
  (retract ?f ?f1)
  (assert
    (p Computacion_y_Sistemas_Inteligentes (+ ?n1 1))
    )
)

(defrule Respuesta_matematicas_n
  (declare (salience 1))
  ?f <- (Contabilizar_matematicas)
  (Respuesta_matematicas N)
  ?f1 <- (p Ingenieria_del_Software ?n1)
 =>
  (retract ?f ?f1)
  (assert
    (p Ingenieria_del_Software (+ ?n1 1))
    )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;; RESPUESTA PARCIAL ;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule No_seguir
  (declare (salience 3))
  (or
   (Respuesta_matematicas R)
   (Respuesta_hardware R)
   (Respuesta_trabajar R)
   (Respuesta_nota R)
   (Respuesta_programar R)
   )
  (p Computacion_y_Sistemas_Inteligentes ?n1)
  (p Tecnologias_de_la_Informacion ?n2)
  (p Ingenieria_de_Computadores ?n3)
  (p Sistemas_de_Informacion ?n4)
  (p Ingenieria_del_Software ?n5)
  (p ?a ?n)
  (test (>= ?n ?n1))
  (test (>= ?n ?n2))
  (test (>= ?n ?n3))
  (test (>= ?n ?n4))
  (test (>= ?n ?n5))
 =>
  (assert (Consejo ?a) (No_seguir))
  (printout t "Te aconsejo "?a crlf)
)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;; CONSEJOS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Ingenieria_de_Computadores
(defrule Ingenieria_de_Computadores
  (declare (salience 10))
  (Respuesta_hardware S)
  (or
   (Nota_alta)
   (Respuesta_trabajar Pu)
   )
 =>
  (assert (Consejo Ingenieria_de_Computadores) (No_seguir))
  (printout t "Te aconsejo Ingeniería de Computadores" crlf)

)

; Computacion_y_Sistemas_Inteligentes
(defrule Computacion_y_Sistemas_Inteligentes
  (declare (salience 10))
  (Respuesta_hardware S)
  (or
   (Nota_baja)
   (Nota_media)
   )
  (Respuesta_trabajar Pr)
 =>
  (assert (Consejo Computacion_y_Sistemas_Inteligentes)(No_seguir))
  (printout t "Te aconsejo Computacion y Sistemas Inteligentes" crlf)

)

(defrule Computacion_y_Sistemas_Inteligentes2
  (declare (salience 10))
  (Respuesta_hardware N)
  (Respuesta_programar S)
  (or
   (Respuesta_trabajar Pu)
   (Respuesta_trabajar D)
   )
  (Respuesta_matematicas S)
 =>
  (assert (Consejo Computacion_y_Sistemas_Inteligentes)(No_seguir))
  (printout t "Te aconsejo Computacion y Sistemas Inteligentes" crlf)

)

;Tecnologias_de_la_Informacion
(defrule Tecnologias_de_la_Informacion
  (declare (salience 10))
  (Respuesta_hardware N)
  (Respuesta_programar N)
=>
  (assert (Consejo Tecnologias_de_la_Informacion) (No_seguir))
  (printout t "Te aconsejo Tecnologias de la Informacion" crlf)
)

;Sistemas_de_Informacion
(defrule Sistemas_de_Informacion
  (declare (salience 10))
  (Respuesta_hardware N)
  (Respuesta_programar S)
  (Respuesta_trabajar Pr)
 =>
  (assert (Consejo Sistemas_de_Informacion) (No_seguir))
  (printout t "Te aconsejo Sistemas de Informacion" crlf)


)

; Ingenieria_del_Software
(defrule Ingenieria_del_Software
  (declare (salience 10))
  (Respuesta_hardware N)
  (Respuesta_programar S)
  (or
   (Respuesta_trabajar D)
   (Respuesta_trabajar Pu)
   )
  (Respuesta_matematicas N)
 =>
  (assert (Consejo Ingenieria_del_Software) (No_seguir))
  (printout t "Te aconsejo Ingenieria del Software" crlf)

)
