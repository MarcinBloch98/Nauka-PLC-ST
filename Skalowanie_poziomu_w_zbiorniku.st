VAR
    Surowe_wejscie : INT;      // wartosc z czujnika
    Wejscie_Real   : REAL;     // zmienna
    Poziom_metry   : REAL;     // wartosc w zbiorniku
    Alarm_wysoki   : BOOL;
END_VAR

// 1. Konwersja INT na REAL (dzielenie z przecinkiem)
Wejscie_Real := INT_TO_REAL(wartosc z konwersja na real);

Poziom_metry := (Wejscie_Real / 27648.0) * 10.0;  // zasosowanie zrobu do czujnika

// zabezpieczenie aby wartosc nie byla ujemna
IF Poziom_metry > 10.0 THEN
    Poziom_metry := 10.0;
ELSIF Poziom_metry < 0.0 THEN
    Poziom_metry := 0.0;
END_IF;

// alarm
IF Poziom_metry > 9.0 THEN
    Alarm_wysoki := TRUE;
ELSIF Poziom_metry < 8.5 THEN
    Alarm_wysoki := FALSE;
END_IF;
