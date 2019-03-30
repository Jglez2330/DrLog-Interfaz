:-consult('DataBase').
:-consult('DBNomBNF.pl').
:-consult('DBArea.pl').
:-consult('DBAreaEnf.pl').
:-consult('DBAreaPrev.pl').
:-consult('DBCaus.pl').
:-consult('DBNom.pl').
:-consult('DBPrevencion.pl').
:-consult('DBSint.pl').
:-consult('DBTrat.pl').
:-consult('DBTratPrev.pl').


consultaMedica():- %se inicializan las variables de sintomas y enfermedad del paciente en 0.
    b_setval(sint1,0),
    b_setval(sint2,0),
    b_setval(sint3,0),
    b_setval(enfer,0),
    conversacion().

consultaMedica(X,Y):- 
    nb_setval(sint1,0),
    nb_setval(sint2,0),
    nb_setval(sint3,0),
    nb_setval(enfer,0),
    nb_setval(enfermedad, 0),
    nb_setval(respuesta, 0),
    conversacion(X,Y).



conversacion(X,Salida):-atomic_list_concat(List,' ',X),
    revisar(List,Salida), nb_getval(respuesta, Salida).
conversacion(X,Salida):-atomic_list_concat(List,' ',X),
    revisar(List,Salida).

conversacion():-read(X),
    atomic_list_concat(List," ",X),
    revisar(List),
    conversacion(). %recursividad para hacer un ciclo de conversacion





revisar(List):- searchExtra(List). %keywords sin necesidad de revisar sintaxis
revisar(List):- oracion(List,[]), %keywords que importa la sintaxis
  searchKeywords(List).

revisar(_):- write("Lo siento, no entendi, por favor repitalo.\n").

revisar(List,Y):- searchExtra(List,Y),!. %keywords sin necesidad de revisar sintaxis
revisar(List,Y):- searchKeywords(List,Y),!.
%keywords que importa la sintaxis

revisar(List,Y):- atom_concat('Lo siento, no entendi, por favor repitalo.\n','',Y).


% -------------------------------------------------------------------------
% Asigna un sintoma nuevo a las variables nulas.
asignarVar(Sintoma):- nb_getval(sint1,S1), S1 == 0, nb_setval(sint1, Sintoma).
asignarVar(Sintoma):- nb_getval(sint2,S2), S2 == 0, nb_setval(sint2, Sintoma).
asignarVar(Sintoma):- nb_getval(sint3,S3), S3 == 0, nb_setval(sint3, Sintoma).

suficientesSintomas():-nb_getval(sint1,S1),nb_getval(sint2,S2),nb_getval(sint3,S3),
    sintomas_de(S1,S2,S3,E), nb_setval(enfer,E),nb_setval(enfermedad, E).
suficientesSintomas().

suficientesSintomas(_):-nb_getval(sint1,S1),nb_getval(sint2,S2),nb_getval(sint3,S3),
sintomas_de(S1,S2,S3,E),nb_setval(enfer,E),nb_setval(enfermedad, E), atom_concat('Lamento decirle esto, pero usted padece de', E, Salida), nb_setval(respuesta,Salida).

suficientesSintomas(_).

% revisa las keywords y da una respuesta dependiendo del tipo de keyword
keyword(Word,Resto):- sintoma(Word),%el paciente est� dando mencionando un sintoma
     asignarVar(Word), suficientesSintomas(),searchKeywords(Resto).

keyword(Word,_):- caus(Word), %pregunta por las causas de su enfermedad
    b_getval(enfer,E),
    (   E \= 0 -> causa_enfermedad(E,C), write(C), nl;
        write("Como quiere que le de la causa de su enfermedad si aun no me ha dicho los sintomas necesarios para darle un diagnostico?"), nl).

keyword(Word,_):- trat(Word), %pregunta por el tratamiento de su enfermedad
    b_getval(enfer,E),
    (   E \= 0 -> curar_enfermedad(E,T),write("Usted debe "), write(T), nl;
        write("Como quiere que le diga como curar de su enfermedad si aun no me ha dicho los sintomas necesarios para darle un diagnostico?"), nl).

keyword(Word,_):- prev(Word), %pregunta como prevenir la enfermedad
    b_getval(enfer,E),
    (   E \= 0 -> write("Para prevenir esa enfermedad, se recomienda "),nl,
        lista_prevenciones(E);
        write("Como quiere que le diga como prevenir de su enfermedad si aun no me ha dicho los sintomas necesarios para darle un diagnostico?"), nl).

%GUI
keyword(Word,Resto,_):- sintoma(Word),%el paciente est� dando mencionando un sintoma
asignarVar(Word), suficientesSintomas(_),searchKeywords(Resto).

keyword(Word,_,_):- caus(Word), %pregunta por las causas de su enfermedad
   b_getval(enfer,E),
   (   E \= 0 -> causa_enfermedad(E,C),atom_concat('La causa comun de esa enfermedad es ', C, Salida), nb_setval(respuesta, Salida)
   ;
        atom_concat('Como quiere que le de la causa de su enfermedad si aun no me ha dicho los sintomas necesarios para darle un diagnostico?\n','',Salida), nb_setval(respuesta, Salida)).

keyword(Word,_,_):- trat(Word), %pregunta por el tratamiento de su enfermedad
   b_getval(enfer,E),
   (   E \= 0 -> curar_enfermedad(E,T),atom_concat('"Usted debe ', T, Salida),nb_setval(respuesta, Salida);
        atom_concat('Como quiere que le diga como curar de su enfermedad si aun no me ha dicho los sintomas necesarios para darle un diagnostico?','',Salida), nb_setval(respuesta,Salida)).
keyword(Word,_, _):- prev(Word), %pregunta como prevenir la enfermedad
   b_getval(enfer,E),
   (   E \= 0 -> lista_prevenciones(E), atom_concat('Para prevenir esa enfermedad, se recomienda',E,X),nb_setval(respuesta, X);
       atom_concat('Como quiere que le diga como prevenir de su enfermedad si aun no me ha dicho los sintomas necesarios para darle un diagnostico?','',Salida), nb_setval(respuesta,Salida)).


keywordExtra(Word):- saludo(Word), write("Hola, en que lo puedo ayudar hoy?"), nl.
keywordExtra(Word):- despedida(Word), write("Adios, espero que est� bien."), nl,
    break.

keywordExtra(Word,Salida):- saludo(Word), atom_concat('Hola, en que lo puedo ayudar hoy?','',Salida).
keywordExtra(Word,Salida):- despedida(Word), atom_concat('Adios, espero que est� bien','',Salida).
%busqueda en la lista de palabras
searchKeywords([]).
searchKeywords([X|Z]):- keyword(X,Z); searchKeywords(Z).

searchKeywords([X|Z],_):- keyword(X,Z,_).
searchKeywords([_|Z],_):-searchKeywords(Z,_).
searchKeywords([],Salida):- nb_getval(respuesta, Salida).

searchExtra([]):-false.
searchExtra([X|Z]):- keywordExtra(X); searchExtra(Z).

searchExtra([], _ ):-false.
searchExtra([X|Z],Salida):- keywordExtra(X,Salida); searchExtra(Z,Salida).
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


