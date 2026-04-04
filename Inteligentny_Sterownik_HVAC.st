VAR
    Czujnik_hala    : REAL;    // czujnik glowny
    Hala_zapasowa   : REAL;    // czujnik zapasowy
    Wentylator      : BOOL;    // sterowanie silnikiem
    Alarm_czujnika  : BOOL;    // lampka awarii dowolnego czujnika
    Awaria_glowna   : BOOL;    // blad czujnika 1
    Awaria_zapas    : BOOL;    // blad czujnika 2
    Prog_temp       : REAL := 25.0; // prog zalaczenia wentylatora
    Blokada_systemu : BOOL;    // blad obu czujnikow
END_VAR

// Kontrola ciaglosci kabli
Awaria_glowna := (Czujnik_hala < -50.0) OR (Czujnik_hala > 150.0);
Awaria_zapas  := (Hala_zapasowa < -50.0) OR (Hala_zapasowa > 150.0);

// Alarm dziala gdy chociaz jeden czujnik ulegnie uszkodzeniu
Alarm_czujnika := Awaria_glowna OR Awaria_zapas;

// Jesli glowny czujnik sie zepsuje to system patrzy na zapasowy
IF NOT Awaria_glowna THEN
    // Uzycie glownego czujnika
    IF Czujnik_hala > Prog_temp THEN
        Wentylator := TRUE;
    ELSIF Czujnik_hala < (Prog_temp - 2.0) THEN 
        Wentylator := FALSE;
    END_IF;
    
ELSIF Awaria_glowna AND NOT Awaria_zapas THEN
    // Awaria - uzywanie zapasowego czujnika
    IF Hala_zapasowa > Prog_temp THEN
        Wentylator := TRUE;
    ELSIF Hala_zapasowa < (Prog_temp - 2.0) THEN
        Wentylator := FALSE;
    END_IF;
    
ELSE
    // Oba czujniki ulegly uszkodzeniu
    Blokada_systemu := TRUE;
    Wentylator := TRUE; // Uruchamiamy chlodzenie
END_IF;

// wylaczenie blokady jesli chociaz jeden czujnik wroci do pracy
IF NOT Awaria_glowna OR NOT Awaria_zapas THEN
    Blokada_systemu := FALSE;
END_IF;
