VAR
    Sygnal_przetwornika   : INT;    // sygnal z czujnika
    Luks                  : REAL;   // przeliczona wartosc natezenia swiatla
    Czujnik_ruchu         : BOOL;   // wejscie czujnika ruchu
    Godzina_system        : INT;    // daktyczna godzina
    Swiatlo_hala          : BOOL;   // wyjscie na swiatlo na hali
    Opoznienie_ruch       : TOF;    // blok czasowy
END_VAR

// skalowanie - 0 - 1000 luks
Luks := (INT_TO_REAL(NatezenieSwiatla) / 27648.0) * 1000.0;

// opoznione wylaczenie swiatla(15 min)
Timeropoznienia(IN := CzujnikRuchu, PT := T#15M);

// logika sterowania
IF Godzina >= 7 AND Godzina <= 16 THEN  // jesli godzina jest miedzy 7 a 16
    // W godzinach pracy sterowanie tylko jasnoscia
    IF Luks < PrógZalaczenia THEN  // zapal jestli swiatlo ponizej progu
        WyjscieSwiatlo := TRUE;
    ELSIF Luks > (PrógZalaczenia + Histereza) THEN  // jesli swiatlo ponizej progu, to wylacz
        WyjscieSwiatlo := FALSE;
    END_IF;
ELSE
    // poza powyzszymi godzinami, swiatlo dziala tylko gdy jest ciemno
    IF Luks < PrógZalaczenia AND TimerOpoznienia.Q THEN
        WyjscieSwiatlo := TRUE;
    ELSE
        WyjscieSwiatlo := FALSE;
    END_IF;
END_IF;
