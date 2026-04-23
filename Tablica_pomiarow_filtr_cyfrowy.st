VAR
    // Dane wejściowe
    Przeplyw_L_min : REAL;      // chwilowe zużycie
    ResetStatystyk : BOOL;      // przycisk zerujący
    
    // Logika tablicowa
    Historia_Zuzycia : ARRAY[0..9] OF REAL; 
    LicznikTablicy : INT := 0;
    SredniaZuzycia : REAL;
    
    // Zmienne pomocnicze
    i : INT;                    // zmienna 
    Suma_Pomocnicza : REAL;     
    TimerZapisu : TON;          // deklaracja bloku czasowego
    
    // Diagnostyka
    AlarmPrzeciazenie : BOOL;  
END_VAR

VAR_CONSTANT
    ProgSerwisowy : REAL := 8.5; 
END_VAR

// cykliczny pomiar co 5 sekund
TimerZapisu(IN := NOT TimerZapisu.Q, PT := T#5S); // generator 5 sek

IF TimerZapisu.Q THEN
    // przesuniecie danych w tył tablicy
    FOR i := 9 TO 1 BY -1 DO
        Historia_Zuzycia[i] := Historia_Zuzycia[i-1];
    END_FOR;

    // wpisanie najnowszego pomiaru na początek
    Historia_Zuzycia[0] := Przeplyw_L_min;
END_IF;

// obliczenie sredniej średniej
Suma_Pomocnicza := 0.0; 

FOR i := 0 TO 9 DO
    Suma_Pomocnicza := Suma_Pomocnicza + Historia_Zuzycia[i];
END_FOR;

SredniaZuzycia := Suma_Pomocnicza / 10.0;

// kontrola progu alarmowego
IF SredniaZuzycia > ProgSerwisowy THEN
    AlarmPrzeciazenie := TRUE;
ELSE
    AlarmPrzeciazenie := FALSE;
END_IF;
