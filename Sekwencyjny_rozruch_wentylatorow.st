VAR
    Start_wentylacji     : BOOL;  // przycisk uruchomienia systemu wentylacji
    Stop_wentylacji      : BOOL;  // przycisk wylaczenia calego ukladu
    
    Timer_rozruchu       : TON;   // timer odmierzajacy czas pomiedzy startami kolejnych silnikow
    Etap                 : INT;   // aktualny krok sekwencji rozruchu: 0-stop, 1-went1, 2-went2, 3-went3
    System_aktywny       : BOOL;  // flaga pamieciowa pracy systemu (zatrzask)
    
    Wentylator_1         : BOOL;  // cewka stycznika pierwszego wentylatora
    Wentylator_2         : BOOL;  // cewka stycznika drugiego wentylatora
    Wentylator_3         : BOOL;  // cewka stycznika trzeciego wentylatora
END_VAR

// start/stop
IF Start_wentylacji THEN
    System_aktywny := TRUE;
ELSIF Stop_wentylacji THEN
    System_aktywny := FALSE;
    Etap           := 0; // reset sekwencji rozruchu
END_IF;

// logika sekwencji
IF System_aktywny THEN
    CASE Etap OF
        0: // Krok 0: uruchomienie pierwszego wentylatora
            Etap := 1;
            
        1: // czas na rozpedzenie obydwu wentylatorow
            IF Timer_rozruchu.Q THEN
                Etap := 2;
            END_IF;
            
        2: // oczekwianie na rozpedzenie wentylatorow
            IF Timer_rozruchu.Q THEN
                Etap := 3;
            END_IF;
            
        3: // wszystkie prawidlowo pracujace wentylatory - koniec sekwencji
    END_CASE;
END_IF;

// rozruch - zwloka 5 sekund
// Timer odlicza czas w krokach przejsciowych (1 oraz 2), dajac czas na rozped silnikow
Timer_rozruchu(IN := (Etap = 1) OR (Etap = 2), PT := T#5s);

// sterowanie wyjsciami
Wentylator_1 := System_aktywny AND (Etap >= 1);
Wentylator_2 := System_aktywny AND (Etap >= 2);
Wentylator_3 := System_aktywny AND (Etap >= 3);
