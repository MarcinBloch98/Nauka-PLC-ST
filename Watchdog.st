VAR
    Ping_OK          : BOOL;    // ptwierdzenie sygnalu z serwera TRUE = jest internet
    
    Timer_Brak_Ping  : TON;     // odliczanie czasu braku odpowiedzi
    Timer_Resetu     : TP;      // generator kontrolowanego impulsu odciecia zasilania
    Timer_Rozruchu   : TON;     // blokada sprawdzania pingu podczas uruchamiania routera
    
    Reset_Przekaznik : BOOL;    // Wyjście fizyczne odcinające zasilanie routera
END_VAR


Timer_Rozruchu(IN := NOT Reset_Przekaznik, PT := T#180s);    // sprawdza ping po 3 minutowym restarcie, 

Timer_Brak_Ping(IN := NOT Ping_OK AND Timer_Rozruchu.Q, PT := T#60s);    // brak pingu ale tylko po zakonczeniu rozruchu

Timer_Resetu(IN := Timer_Brak_Ping.Q, PT := T#5s);   // odetnij zasilanie tylko an 5 sekund

Reset_Przekaznik := Timer_Resetu.Q;    // pokazanie sygnalu na sterowniku
