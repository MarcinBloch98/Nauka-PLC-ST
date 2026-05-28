VAR
    Fotokomorka_bufora   : BOOL;  // czujnik optyczny na koncu
    Podajnik_glowny_On   : BOOL;  // sygnal ze glowny podajnik podaje paczki
    
    Timer_przepelnienia  : TON;   // timer mierzacy czas pelnego zasloniecia czujnika
    Licznik_zatrzyman    : CTU;   // licznik rejestrujacy ilosc awaryjnych zatrzyman
    
    Zatrzymanie_awaryjne : BOOL;  // blokada zatrzymujaca glowny podajnik
END_VAR

// Badanie czasu zaslonietego czujnika przez conajmniej 4 sekundy - bufor jest pelny
Timer_przepelnienia(IN := Fotokomorka_bufora AND Podajnik_glowny_On, PT := T#4s);

// 2.Logika blokady
Zatrzymanie_awaryjne := Timer_przepelnienia.Q;

// Tworzenie statystyki - licznik zwieksza swoja wartosc gdy bufor sie przepelni
Licznik_zatrzyman(CU := Timer_przepelnienia.Q, R := NOT Podajnik_glowny_On);
