VAR
    Ping_OK          : BOOL;    // potwierzdenie sygnalu z serwera (TRUE = jest internet)
    Timer_brak_pingu  : TON;     // odliczanie czasu do restartu
    Reset_Przekaznik : BOOL;    // wyjscie odcinajace zasilanie serwera
END_VAR

// brak pingu przez 60 sekund = zacznij odliczanie
Timer_brak_pingu(IN := NOT Ping_OK, PT := T#60s);

// jesli timer odliczy czas, zrestartu jrouter
Reset_Przekaznik := Timer_brak_pingu.Q;
