VAR
    Timer_1s : TON;              // timer zliczajacy ilosc sekund pracy silnika
    Silnik : BOOL;               // stycznik silnika
    Reset_serwis : BOOL;         // przycisk serwisowy
    Sygnalizacja_serwisu : BOOL; // lampa serwisowa
    Licznik_serwisu : DINT;      // tu przechowujemy sekundy
END_VAR

// odmierzanie kazdej sekundy
Timer_1s( IN := Silnik AND NOT Timer_1s.Q, PT := T#1s);

// suma czasu
IF Timer_1s.Q THEN  
    Licznik_serwisu := Licznik_serwisu + 1;
END_IF;

// sprawdzaie czasu serwisowego
IF Licznik_serwisu >= 32400 THEN
    Sygnalizacja_serwisu := TRUE;
    Silnik := FALSE; // Blokada silnika
ELSE
    Silnik := TRUE;  // Pozwolenie na pracę, jeśli serwis nie jest wymagany
END_IF;

// reset czasu serwisu
IF Reset_serwis THEN
    Sygnalizacja_serwisu := FALSE;
    Licznik_serwisu := 0;
END_IF;
