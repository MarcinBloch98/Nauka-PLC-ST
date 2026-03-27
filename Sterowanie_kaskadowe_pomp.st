VAR
    Poziom : REAL;           // Sygnał z czujnika (0-100%)
    Pompa_1 : BOOL;
    Pompa_2 : BOOL;
    
    Zamiana : BOOL;          // Pamiec do zmiany kolejności
    Cykl_Aktywny : BOOL;     // Zabezpieczenie zmiany trybu pracy
END_VAR

// 1. Gdy zbiornik jest pusty
IF Poziom < 5.0 AND NOT Cykl_Aktywny THEN
    Zamiana := NOT Zamiana;
    Cykl_Aktywny := TRUE; // Blokada
END_IF;

IF Poziom > 10.0 THEN
    Cykl_Aktywny := FALSE; // Reset blokady - gdy zaczyna nalewać
END_IF;

// 2. Sterowanie 
IF NOT Zamiana THEN
    // Kolejność: P1 główna, P2 pomocnicza
    Pompa_1 := Poziom > 70.0;
    Pompa_2 := Poziom > 90.0;
ELSE
    // Kolejność: P2 główna, P1 pomocnicza
    Pompa_2 := Poziom > 70.0;
    Pompa_1 := Poziom > 90.0;
END_IF;

// 3. Wyłącznik bezpieczeństwa
IF Poziom < 30.0 THEN
    Pompa_1 := FALSE;
    Pompa_2 := FALSE;
END_IF;
