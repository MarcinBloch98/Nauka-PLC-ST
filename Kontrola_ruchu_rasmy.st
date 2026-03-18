(* Potwierdzenie ruchu poprzez czujnik obrotów *)

VAR
    OpoznienieStartu      : TON;    // Czas na rozbieg
    TimeoutBrakuRuchu     : TON;    // Czas oczekiwania na kolejny impuls
    WykrywanieObrotow     : R_TRIG; // Detekcja sygnału z czujnika
    CzujnikWykrywajacyRuch : BOOL;   // Potwierdzenie obrotu taśmy
END_VAR

// 1. Dajemy maszynie czas na ruszenie
OpoznienieStartu(IN := Silnik_Praca, PT := T#3S);

// 2. Wykrycie impulsu ruchu
WykrywanieObrotow(CLK := Sygnal_z_czujnika); 

// 3. Kontrola alarmów przy pracy
IF Silnik_Praca AND OpoznienieStartu.Q THEN
    
    // Wykrycie obrotu - taśma pracuje poprawnie
    IF WykrywanieObrotow.Q THEN
        TimeoutBrakuRuchu(IN := FALSE); 
        CzujnikWykrywajacyRuch := TRUE;
    ELSE
        // Brak impulsu - odliczanie czasu do błędu
        TimeoutBrakuRuchu(IN := TRUE, PT := T#800MS);
    END_IF;
    
ELSE
    TimeoutBrakuRuchu(IN := FALSE);
    CzujnikWykrywajacyRuch := FALSE;
END_IF;

// 4. Reakcja na błąd
IF TimeoutBrakuRuchu.Q THEN
    WykrycieBleduRuchu := TRUE;
    Silnik_Praca := FALSE; // Zatrzymanie silnika po przekroczeniu czasu timeout
END_IF;
