(* Licznik czasu pracy napedu *)

VAR
    TaktSekundowy       : TON;    // Odmierzanie kazdej sekundy pracy
    SumaSekund          : DINT;   // Skumulowany czas pracy [s]
    GodzinyPracy        : REAL;   // Czas pracy wyswietlany na HMI [h]
    Limit_Przegladu     : REAL := 500.0; // Czas do wezwania serwisu [h]
    PrzypomnienieSerwisu: BOOL;   // Aktywacja przypomnienia o przegladzie
    Reset_Serwisu       : BOOL;   // Potwierdzenie wykonania prac serwisowych
END_VAR

// 1. Odmierzanie czasu tylko podczas pracy silnika
TaktSekundowy(IN := Silnik_Praca AND NOT TaktSekundowy.Q, PT := T#1S);

// 2. Zliczanie czasu i przeliczanie na godziny
IF TaktSekundowy.Q THEN
    SumaSekund := SumaSekund + 1;
    
    // Przeliczenie sekund na godziny (1h = 3600s)
    GodzinyPracy := DINT_TO_REAL(SumaSekund) / 3600.0;
END_IF;

// 3. Sprawdzenie czy nadszedl czas na serwis
IF GodzinyPracy >= Limit_Przegladu THEN
    PrzypomnienieSerwisu := TRUE;
END_IF;

// 4. Kasowanie licznika po wykonaniu serwisu
IF Reset_Serwisu THEN
    SumaSekund := 0;
    PrzypomnienieSerwisu := FALSE;
END_IF;
