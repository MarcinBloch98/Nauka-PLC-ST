VAR
    Poziom_metry      : REAL;    // Poziom cieczy w zbiorniku
    Czujnik_cisnienia : BOOL;    // Kontrola cisnienia w rurociągu
    Pompa_wyjscie     : BOOL;    // Wyjscie sterujace pompa
    Alarm_suchobieg   : BOOL;    // Alarm pracy bez cisnienia
    Licznik_uruchomien: INT;     // Licznik cykli pracy
    Przycisk_reset    : BOOL;    // Wejscie kasujace błąd
    
    Timer_cisnienia   : TON;     // Blok czasowy
    R_Trig_Pompa      : R_TRIG;  // Wykrywacz zbocza narastającego
END_VAR

// 1. logika Start/Stop
IF Poziom_metry >= 8.0 THEN
    Pompa_wyjscie := TRUE;
ELSIF Poziom_metry <= 2.0 OR Alarm_suchobieg THEN
    Pompa_wyjscie := FALSE;
END_IF;

// 2. zliczanie uruchomień 
R_Trig_Pompa(CLK := Pompa_wyjscie);
IF R_Trig_Pompa.Q THEN
    Licznik_uruchomien := Licznik_uruchomien + 1;
END_IF;

// kontrola suchobiegu (Jeśli pompa pracuje, a ciśnienia brak przez 3s)
Timer_cisnienia(IN := Pompa_wyjscie AND NOT Czujnik_cisnienia, PT := T#3S);

IF Timer_cisnienia.Q THEN
    Alarm_suchobieg := TRUE; // Zatrzaśnięcie błędu (Latch)
END_IF;

// reset alarmu
IF Przycisk_reset THEN 
    Alarm_suchobieg := FALSE; 
END_IF;
