VAR
    Sygnal_odrzutu       : BOOL;  // sygnal z systemu wizyjnego dla detalu wadliwego
    Czujnik_pozycji      : BOOL;  // fotokomorka synchronizujaca na poczatku strefy sortowania
    Krancowka_silownika  : BOOL;  // czujnik wykrywajacy pelne cofniecie spychacza
    
    Timer_dolotu         : TON;   // timer czasu transportu paczki do miejsca zepchniecia
    Timer_wysuwu         : TON;   // timer okresu wysuwu silownika
    Krok                 : INT;   // krok sekwencji: 0-idle, 1-dolot, 2-spychanie, 3-powrot
    
    Silownik_odrzutu     : BOOL;  // cewka zaworu spychacza
END_VAR

CASE Krok OF
    0: // Czekanie na wadliwy detal i synchronizacje na fotokomorce
        IF Sygnal_odrzutu AND Czujnik_pozycji AND Krancowka_silownika THEN
            Krok := 1; // Detal wykryty, rozpoczecie liczenia czasu transportu
        END_IF;
        
    1: // Transport paczki przed silownik
        IF Timer_dolotu.Q THEN
            Krok := 2; // paczka na miejscu, uruchom spychacz
        END_IF;
        
    2: // Zepchniecie detalu
        IF Timer_wysuwu.Q THEN
            Krok := 3; // po okreslonym czasie, powrot spychacza
        END_IF;
        
    3: // Powrot silownika 
        IF Krancowka_silownika THEN
            Krok := 0; // silownik schowany, oczekwianei na kolejny detal
        END_IF;
END_CASE;

// Timery
Timer_dolotu(IN := (Krok = 1), PT := T#2500ms);  // czas transportu paczki od fotokomorki do silownika

Timer_wysuwu(IN := (Krok = 2), PT := T#1s);  // silownik ma byc wysuniety przez 1 sekunde

// Sterowanie fizyczne
Silownik_odrzutu := (Krok = 2);
