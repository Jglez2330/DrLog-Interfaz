
enfermedad("thanos").
 sintoma(muerte).
 sintoma(polvo).
 sintoma(inexistencia).
 causa("gemas","thanos").
 prevencion("ninguna").
 prevencion("matar a thanos").
 prevencion("no existir").
 prevencion_area("ninguna",muerte).
 prevencion_area("matar a thanos",polvo).
 prevencion_area("no existir",inexistencia).
 tratamiento_previo("thanos","matar a thanos").
 tratamiento_enfermedad("ninguno","thanos").
 enfermedad_area("thanos",cabeza).
 enfermedad_area("thanos",torso).
 enfermedad_area("thanos",piernas).
 sintoma_area(muerte, cabeza).
 sintoma_area(polvo, torso).
 sintoma_area(inexistencia, piernas).




consultaMedica():- %se inicializan las variables de sintomas y enfermedad del paciente en 0.
    b_setval(sint1,0),
    b_setval(sint2,0),
    b_setval(sint3,0),
    b_setval(enfer,0),
    conversacion().

conversacion():-read(X),atomic_list_concat(List," ",X),revisar(List),conversacion(). %recursividad para hacer un ciclo de conversacion
revisar(List):- searchExtra(List). %keywords sin necesidad de revisar sintaxis
revisar(List):- oracion(List,[]), %keywords que importa la sintaxis
  searchKeywords(List).
revisar(_):- write("Lo siento, no entendi, por favor repitalo.\n").
% -------------------------------------------------------------------------
% Asigna un sintoma nuevo a las variables nulas.
asignarVar(Sintoma):- b_getval(sint1,S1), S1 == 0, b_setval(sint1, Sintoma).
asignarVar(Sintoma):- b_getval(sint2,S2), S2 == 0, b_setval(sint2, Sintoma).
asignarVar(Sintoma):- b_getval(sint3,S3), S3 == 0, b_setval(sint3, Sintoma).

suficientesSintomas():-b_getval(sint1,S1),b_getval(sint2,S2),b_getval(sint3,S3),
    sintomas_de(S1,S2,S3,E), b_setval(enfer,E),
    write("Lamento decirle esto, pero usted padece de "),write(E),nl.
suficientesSintomas().

% revisa las keywords y da una respuesta dependiendo del tipo de keyword
keyword(Word,Resto):- sintoma(Word),%el paciente est� dando mencionando un sintoma
     asignarVar(Word), suficientesSintomas(),searchKeywords(Resto).

keyword(Word,_):- caus(Word), %pregunta por las causas de su enfermedad
    b_getval(enfer,E),
    (   E \= 0 -> causa_enfermedad(E,C),write("La causa comun de esa enfermedad es "), write(C), nl;
        write("Como quiere que le de la causa de su enfermedad si aun no me ha dicho los sintomas necesarios para darle un diagnostico?"), nl).

keyword(Word,_):- trat(Word), %pregunta por el tratamiento de su enfermedad
    b_getval(enfer,E),
    (   E \= 0 -> curar_enfermedad(E,T),write("Usted debe "), write(T), nl;
        write("Como quiere que le diga como curar de su enfermedad si aun no me ha dicho los sintomas necesarios para darle un diagnostico?"), nl).

keyword(Word,_):- prev(Word), %pregunta como prevenir la enfermedad
    b_getval(enfer,E),
    (   E \= 0 -> lista_prevenciones(E),write("Para prevenir esa enfermedad, se recomienda ");
        write("Como quiere que le diga como prevenir de su enfermedad si aun no me ha dicho los sintomas necesarios para darle un diagnostico?"), nl).

keywordExtra(Word):- saludo(Word), write("Hola, en que lo puedo ayudar hoy?"), nl.
keywordExtra(Word):- despedida(Word), write("Adios, espero que est� bien."), nl,
    break.

%busqueda en la lista de palabras
searchKeywords([]).
searchKeywords([X|Z]):- keyword(X,Z); searchKeywords(Z).

searchExtra([]):-false.
searchExtra([X|Z]):- keywordExtra(X); searchExtra(Z).
% ------------------------------------------------------------------------------
% BNF
oracion(A,B):- sintagma_nominal(A,C),
               sintagma_verbal(C,B).

sintagma_nominal(A,B):- nombre(A,B).
sintagma_nominal(A,B):- determinante(A,C),
                        nombre(C,B).

sintagma_verbal(A,B):- verbo(A,C),
                       sintagma_nominal(C,B).
sintagma_verbal(A,B):- verbo(A,B).

determinante([el|A],A).
determinante([como|A],A).
determinante([que|A],A).
determinante([cual|A],A).
determinante([en|A],A).
determinante([esa|A],A).
determinante([lo|A],A).
determinante([cuando|A],A).
determinante([con|A],A).
determinante([la|A],A).


% ------------------------------------------------------------------------


% Reglas principales para relacionar los hechos de la base de datos y
% enviar la informacin correspondiente al usuario

% Regla que me relaciona un solo sintoma con una enfermedad, la variable
% S se refiere a sintoma y la variable E se refiere a enfermedad, la
% regla primero verifica que efectivamente se traten de sintomas y
% enfermedades de la base de datos, y luego hace la relaci�n verificando
% que el rea de afectacin del sintoma concuerde con una de las �reas
% de afectacin de la enfermedad

sintoma_de(S,E):-sintoma(S),enfermedad(E),sintoma_area(S,Y),enfermedad_area(E,Y).


% Regla que me relaciona tres sintomas con una enfermedad, los tres
% sintomas son ingresados de la comunicaci�n con el usuario y en la
% variable E se almacena la enfermedad correspondiente

sintomas_de(S1,S2,S3,E):-sintoma_de(S1,E),sintoma_de(S2,E),sintoma_de(S3,E).


% Regla para relacionar una enfermedad con una causa, la enfermedad se
% recibe como par�metro y la regla instancia en la variable C la causa
% correspondiente

causa_enfermedad(E,C):-enfermedad(E),causa(C,E).

% Reglas para obtener las formas de prevenci�n de una enfermedad, la
% regla de prevenir_enfermedad liga una enfermedad con una forma de
% prevenci�n (si existe tratamiento previo tambi�n se incluye) de
% acuerdo con el �rea de afectaci�n. La regla lista_prevenciones recibe
% una enfermedad como par�metro de entrada e instancia en la variable L
% la lista con todas las posibles prevenciones para dicha enfermedad.

prevenir_enfermedad(E,P):-enfermedad(E),tratamiento_previo(E,P).
prevenir_enfermedad(E,P):-enfermedad(E),prevencion(P),enfermedad_area(E,X),prevencion_area(P,X).

lista_prevenciones(E):-findall(Prevencion,prevenir_enfermedad(E,Prevencion),L),
    concatenarLista(L).

concatenarLista(L):- concatenarLista(L," ",_).
concatenarLista([],_,SF):-write(SF).
concatenarLista([S1|Resto],SI,_):- string_concat(S1,", ",S),
    string_concat(SI,S,SFinal),
    concatenarLista(Resto,SFinal,SFinal).


% Regla para relacionar el tratamiento con una enfermedad, se recibe
% como par�metro la enfermedad y devuelve en la variable T, el
% tratamiento respectivo para dicha enfermedad.

curar_enfermedad(E,T):-enfermedad(E),tratamiento_enfermedad(T,E).

%base de datos

%Lista de enfermedades, las enfermedades se tratan como strings

enfermedad("Gripe").
enfermedad("Virus Estomacal").
enfermedad("Cancer").
enfermedad("Bronquitis").
enfermedad("Varicela").

% Lista de sintomas, de momento los sintomas son tratados como atomos de
% prolog, sin embargo hay algunos que pueden quedar ambig�os como dolor
% (puede ser dolor de cuerpo, dolor de est�mago,etc), igual sucede con
% p�rdida (p�rdida de apetito, p�rdida de peso).Se puede cambiar a
% string para solucionar la ambig�edad pero se debe recibir el string
% completo de la comunicaci�n con el usuario

sintoma(tos).
sintoma(fiebre).
sintoma(cansancio).
sintoma(diarrea).
sintoma(vomito).
sintoma(dolor).
sintoma(perdida).
sintoma(flema).
sintoma(picazon).
sintoma(ampollas).


% Lista de Causas para cada enfermedad, El primer string del hecho es la
% causa (la cu�l es propia y �nica para cada enfermedad), el segundo
% string indica a cu�l enfermedad pertenece dicha causa.


causa("La gripe es causada por el virus de la influenza","Gripe").
causa("El virus que causa la varicela es el virus varicela z�ster","Varicela").
causa("El virus estomacal es causado por el norovirus y el rotavirus ","Virus Estomacal").
causa("Los mismos virus que causan los resfriados y la gripe son la causa m�s frecuente de la bronquitis","Bronquitis").
causa("Por lo general el cancer lo provocan mutaciones geneticas","Cancer").


%Lista de prevenciones

prevencion("Lavarse las manos").
prevencion("Cubrise la boca al toser").
prevencion("Usar desinfectante para manos").
prevencion("Desinfectar superficies y objetos del hogar").
prevencion("Hacer ejercicio con frecuencia").
prevencion("Tener buena alimentaci�n").
prevencion("Evitar los vicios como alcohol o cigarros").


% Hechos que me asocian una prevenci�n, con el �rea del cuerpo a la
% cu�l va dirigida la prevenci�n

prevencion_area("Lavarse las manos",estomago).
prevencion_area("Lavarse las manos",respiracion).
prevencion_area("Cubrise la boca al toser",respiracion).
prevencion_area("Usar desinfectante para manos",estomago).
prevencion_area("Desinfectar superficies y objetos del hogar",estomago).
prevencion_area("Hacer ejercicio con frecuencia",condicion_fisica).
prevencion_area("Tener buena alimentaci�n",peso).
prevencion_area("Evitar los vicios como alcohol o cigarros",condicion_fisica).


% Hechos que me indican si una enfermedad tiene tratamiento previo, para
% incluirlos tambi�n en la lista de prevenciones de cada enfermedad. El
% primer string es el nombre de la enfermedad y el segundo el
% tratamiento.

tratamiento_previo("Gripe","Vacunarse todos los a�os").
tratamiento_previo("Bronquitis","Ponerse la vacuna para la gripe todos los a�os").
tratamiento_previo("Varicela","Vacunarse contra el virus que produce la varicela").


% Lista de tratamientos posteriores a la enfermedad, el hecho los asocia
% directamente con la enfermedad (segundo par�metro) ya que los
% tratamientos son �nicos para cada tipo de enfermedad de la base de
% datos


tratamiento_enfermedad("Tomar antigripal por una semana y tomar l�quidos en abundancia","Gripe").
tratamiento_enfermedad("Ingerir alimentos blandos y mantenerse hidratado","Virus Estomacal").
tratamiento_enfermedad("Consumir medicamentos para la tos y comprar un inhibidor para los pulmones","Bronquitis").
tratamiento_enfermedad("Cubrir las ampollas para la piel y utilizar cremas para reducir la picaz�n","Varicela").
tratamiento_enfermedad("Someterse a una quimioterapia","Cancer").



% Hechos que me indican las �reas de afectaci�n de cada enfermedad, una
% misma enfermedad puede atacar diferentes �reas del cuerpo

enfermedad_area("Gripe",respiracion).
enfermedad_area("Gripe",cuerpo).
enfermedad_area("Gripe",temperatura).
enfermedad_area("Virus Estomacal",estomago).
enfermedad_area("Virus Estomacal",temperatura).
enfermedad_area("Cancer",cuerpo).
enfermedad_area("Cancer",peso).
enfermedad_area("Cancer",temperatura).
enfermedad_area("Cancer",condicion_fisica).
enfermedad_area("Bronquitis",respiracion).
enfermedad_area("Bronquitis",cuerpo).
enfermedad_area("Bronquitis",pecho).
enfermedad_area("Varicela",piel).
enfermedad_area("Varicela",temperatura).


% �reas de afectaci�n de cada s�ntoma, en principio un sintoma solo
% puede atacar un �rea espec�fica del cuerpo, sin embargo hay algunos
% sintomas que atacan varias �reas debido a la ambig�edad de los mismos
% (son el caso de dolor y perdida).

sintoma_area(tos,respiracion).
sintoma_area(fiebre,temperatura).
sintoma_area(cansancio,cuerpo).
sintoma_area(diarrea,estomago).
sintoma_area(vomito,estomago).
sintoma_area(dolor,estomago).
sintoma_area(dolor,cuerpo).
sintoma_area(perdida,peso).
sintoma_area(perdida,estomago).
sintoma_area(flema,pecho).
sintoma_area(picazon,piel).
sintoma_area(ampollas,piel).

nombre([hombre|A],A).
nombre([manzana|A],A).
nombre([cancer|A],A).
nombre([yo|A],A).
nombre([tengo|A],A).
nombre([gripe|A],A).


verbo([come|A],A).
verbo([canta|A],A).
verbo([tiene|A],A).

% -----------------------------------------------------------------------------
% Palabras clave de usuario
saludo(hola).
saludo(saludos).
saludo(buenas).
saludo(buenos).

despedida(adios).
despedida(luego).

prev(prevenirla).
prev(prevenirlo).
prev(prevenir).
prev(prevencion).

trat(tratamiento).
trat(tratarlo).
trat(tratarla).
trat(tratar).
trat(curarme).
trat(cura).
trat(tomar).
trat(medicina).

caus(causa).


enfermedad("thanos").
 sintoma(muerte).
 sintoma(polvo).
 sintoma(inexistencia).
 causa("gemas","thanos").
 prevencion("ninguna").
 prevencion("matar a thanos").
 prevencion("no existir").
 prevencion_area("ninguna",muerte).
 prevencion_area("matar a thanos",polvo).
 prevencion_area("no existir",inexistencia).
 tratamiento_previo("thanos","matar a thanos").
 tratamiento_enfermedad("ninguno","thanos").
 enfermedad_area("thanos",cabeza).
 enfermedad_area("thanos",torso).
 enfermedad_area("thanos",piernas).
 sintoma_area(muerte, cabeza).
 sintoma_area(polvo, torso).
 sintoma_area(inexistencia, piernas).
















