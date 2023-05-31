% Cabrera, Jean
% Dy, Sealtiel
% Lu, Bentley
% Ong, Camron

:- use_module(library(pce)).
:- dynamic(patient/0).
:- dynamic(disease/1).
:- dynamic(info/4).

home:-
	retractall(disease(_)),
	retractall(patient(_, _, _, _)),
    retractall(patient(_)),
    new(Out, dialog('Start')),
    send_list(Out, append, [ text('Welcome to the Chatbot: A Collection of Diseases', center),
			       button(proceed, message(Out, return, proceed))
			     ]),
	get(Out, confirm_centered, _),
	send(Out, destroy),
	yourinfo.

yourinfo:-
	new(Out, dialog('Your Information')),
	send_list(Out, append,
		[	new(Firstname, text_item(fname)), new(Lastname, text_item(lname)),
			new(Age, int_item(age)), new(Sex, text_item(sex)), 
			button(ok, and(message(@prolog, info, Firstname?selection, Lastname?selection, 
					Age?selection, Sex?selection),
					message(Out, return, ans))),
			button(cancel, message(Out, return, @nil))
		]),
    send(Out, default_button(ok)),
    get(Out, confirm_centered, Answer),
	send(Out, destroy),
    Answer == ans,
    free(Out),
    askquestion.

askquestion:- 
    patient(Firstname, Lastname, Age, Sex),
    assertz(patient(diagnose)),
	examine(hasCovid),
	examine(hasLepto),
	examine(hasPneumonia),
	examine(hasMalaria),
	examine(hasTyphoid),
	examine(hasGastro),
	examine(hasDengue),
	examine(hasMeasles),
    examine(hasTuberculosis),
	examine(hasCholera),
	
	atom_concat('Name: ', Lastname, Temp),
	atom_concat(Temp, ', ', Temp2),
	atom_concat(Temp2, Firstname, Fullname),
	atom_concat('Age: ', Age, Ageout),
	atom_concat('Sex: ', Sex, Sexout),
	
	new(Out, dialog('Diagnosis')),
	send(Out, append, text(Fullname)), send(Out, append, text(Ageout)), send(Out, append, text(Sexout)),
	((disease(covid) -> (send(Out, append, text('You might have COVID-19.')))  );true),
    ((disease(lepto) -> (send(Out, append, text('You might have Leptospirosis.')))  );true),
    ((disease(pneumonia) -> (send(Out, append, text('You might have Pneumonia.')))  );true),
    ((disease(malaria) -> (send(Out, append, text('You might have Malaria.')))  );true),
	((disease(typhoid) -> (send(Out, append, text('You might have Typhoid Fever.')))  );true),
    ((disease(gastro) -> (send(Out, append, text('You might have Gastroenteritis.')))  );true),
    ((disease(dengue) -> (send(Out, append, text('You might have Dengue.')))  );true),
    ((disease(measles) -> (send(Out, append, text('You might have Measles.')))  );true),
    ((disease(tuberculosis) -> (send(Out, append, text('You might have Tuberculosis.')))  );true),
    ((disease(cholera) -> (send(Out, append, text('You might have Cholera.')))  );true),
	((not(patient(disease)) -> (send(Out, append, text('Your disease cannot be found in this system.\nYou may need to go to a larger medical facility.')))  );true),
	send(Out, append, button(noted, message(Out, return, yep))),
	send(Out, default_button(noted)),
    get(Out, confirm_centered, _),
	send(Out, destroy),
    retractall(disease(_)),
	retractall(patient(Firstname, Lastname, Age, Sex)),
    retractall(patient(_)).

info(Firstname, Lastname, Age, Sex):-
	assertz(patient(Firstname, Lastname, Age, Sex)).

ask(Ill):-
	new(Out, dialog('Symptom Check')),
	send_list(Out, append,
		[	text('Do you...'), text(Ill),
			button(yes, message(Out, return, affirm)),
			button(no, message(Out, return, negate))
		]),
	send(Out, default_button(yes)),
    get(Out, confirm_centered, Answer),
	send(Out, destroy),
    free(Out),
	(Answer == affirm -> assertz(patient(Ill)); 
	Answer == negate -> assertz(patient(not(Ill))), fail).

check(Ill) :- 
    patient(not(Ill)) -> fail;
    patient(Ill) -> true;
    ask(Ill), check(Ill).

examine(hasTuberculosis) :-
    hasTuberculosis; true.

examine(hasDengue) :-
    hasDengue; true.

examine(hasMalaria) :-
    hasMalaria; true.

examine(hasCholera) :-
    hasCholera; true.

examine(hasTyphoid) :-
    hasTyphoid; true.

examine(hasLepto) :-
    hasLepto; true.

examine(hasMeasles) :-
    hasMeasles; true.

examine(hasPneumonia) :-
    hasPneumonia; true.

examine(hasCovid) :-
    hasCovid; true.

examine(hasGastro) :-
    hasGastro; true.

hasCovid :- 
	patient(diagnose),
	asserta(disease(not(covid))),
	(check('have a fever');check('experience chills')),
	check('have nausea'),
	check('have diarrhea'),
	(check('feel any muscle pain');check('have an aching body')),
	check('experience headaches'),
	check('have any rashes'),
	check('experience fatigue'),
	check('have a dry cough'),
	check('have sore eyes'),
	(check('have a stuffy nose');check('have a runny nose')),
	check('feel any shortness of breath'),
	check('have a loss of taste or smell'),
	check('have a sore throat'),
	check('have pale or blue lips or nail beds'),
	asserta(patient(disease)),
    asserta(disease(covid)).

hasLepto :- 
	patient(diagnose),
	asserta(disease(not(lepto))),
	check('have a fever'),
	check('have nausea'),
	check('have diarrhea'),
	check('feel any muscle pain'),
	check('experience headaches'),
	check('have any rashes'),
	check('experience chills'),
	check('have sore eyes'),
	check('feel any stomach pain'),
	check('have jaundice'),
	asserta(patient(disease)),
    asserta(disease(lepto)).

hasPneumonia :- 
	patient(diagnose),
	asserta(disease(not(pneumonia))),
	check('have a fever'),
	check('have nausea'),
	check('experience fatigue'),
	check('experience chills'),
	check('have a loss of appetite'),
	check('have an aching body'),
	check('feel any chest pain'),
	check('feel any shortness of breath'),
	check('have a cough with mucus'),
	asserta(patient(disease)),
    asserta(disease(pneumonia)).

hasMalaria :- 
	patient(diagnose),
	asserta(disease(not(malaria))),
	check('have a fever'),
	check('have nausea'),
	check('have diarrhea'),
	check('feel any muscle pain'),
	check('experience headaches'),
	check('experience fatigue'),
	check('experience chills'),
	asserta(patient(disease)),
    asserta(disease(malaria)).

hasTyphoid :- 
	patient(diagnose),
	asserta(disease(not(typhoid))),
	check('have a fever'),
	(check('have diarrhea');check('have constipation')),
	check('experience headaches'),
	check('have any rashes'),
	check('have a dry cough'),
	check('have a loss of appetite'),
	check('feel any stomach pain'),
	asserta(patient(disease)),
    asserta(disease(typhoid)).

hasGastro :- 
	patient(diagnose),
	asserta(disease(not(gastro))),
	check('have a fever'),
	check('have nausea'),
	check('have diarrhea'),
	check('feel any muscle pain'),
	check('experience headaches'),
	check('feel any bone pain'),
	check('have a loss of appetite'),
	asserta(patient(disease)),
    asserta(disease(gastro)).

hasDengue :- 
	patient(diagnose),
	asserta(disease(not(dengue))),
	check('have a fever'),
	check('have nausea'),
	(check('feel any eye pain');check('feel any muscle pain');check('feel any bone pain')),
	check('have any rashes'),
	(check('experience fatigue');check('feel restless or irritable')),
	check('feel any stomach pain'),
	check('experience any nose or gum bleeding'),
	asserta(patient(disease)),
    asserta(disease(dengue)).

hasMeasles :- 
	patient(diagnose),
	asserta(disease(not(measles))),
	check('have a fever'),
	check('have any rashes'),
	check('have a dry cough'),
	check('have sore eyes'),
	check('have a runny nose'),
	check('have koplik spots or bumps'),
	asserta(patient(disease)),
    asserta(disease(measles)).

hasTuberculosis :- 
	patient(diagnose),
	asserta(disease(not(tuberculosis))),
	check('have a fever'),
	check('have a dry cough'),
	check('feel any chest pain'),
	check('experience weight loss'),
	check('experience random sweating'),
	check('cough up blood'),
	asserta(patient(disease)),
    asserta(disease(tuberculosis)).

hasCholera :- 
	patient(diagnose),
	asserta(disease(not(cholera))),
	check('have nausea'),
	check('have diarrhea'),
	check('feel restless or irritable'),
	check('feel thirsty'),
	check('experience any leg cramps'),
	asserta(patient(disease)),
    asserta(disease(cholera)).

:- pce_autoload_all,
    pce_autoload_all,
    qsave_program('ChatBot',
                    [ 
                    stand_alone(true),
                    goal(home)
                    ]).