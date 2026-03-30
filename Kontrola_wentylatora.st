VAR
    Start_przycisk : BOOL;
    Stop : BOOL;            // Zakładamy styk NC (TRUE = OK, FALSE = STOP)
    Potwierdzenie : BOOL;   // Sygnał z czujnika przepływu
    Wentylator : BOOL;
    Alarm : BOOL;
    Flaga_awarii : BOOL;
    Temperatura_aktualna : REAL;

    Timer_rozbieg : TON;    // Czas na rozpędzenie
    Timer_awarii : TON;     // Czas na wykrycie braku przepływu
END_VAR

// Obsługa Timerów (muszą być wywoływane co cykl)
Timer_rozbieg(IN := Wentylator, PT := T#5S);
// Timer awarii startuje tylko gdy wentylator już się rozpędził, a przepływu brak
Timer_awarii(IN := Timer_rozbieg.Q AND NOT Potwierdzenie, PT := T#2S);

// Start układu
IF Start_przycisk AND Stop AND NOT Flaga_awarii THEN
    Wentylator := TRUE;
END_IF;

// Wyłączenie przez przycisk STOP lub awarię
IF NOT Stop OR Flaga_awarii THEN
    Wentylator := FALSE;
END_IF;

// Detekcja awarii (Brak przepływu LUB za wysoka temperatura)
IF Timer_awarii.Q OR (Wentylator AND Temperatura_aktualna > 80.0) THEN
    Flaga_awarii := TRUE;
    Alarm := TRUE;
END_IF;

// Reset awarii (Przyciskiem Stop)
IF NOT Stop AND Flaga_awarii THEN
    Flaga_awarii := FALSE;
    Alarm := FALSE;
END_IF;
