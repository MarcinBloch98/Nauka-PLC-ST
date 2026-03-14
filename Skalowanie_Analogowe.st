FUNCTION_BLOCK Skalowanie_Analogow
VAR_INPUT
    Sygnal_RAW      : INT;    // Faktyczny odczyt z karty
    Zakres_Wej_Min   : REAL := 0.0;     
    Zakres_Wej_Max   : REAL := 27648.0; 
    Limit_Dolny     : REAL := 0.0;     // np. 0 bar
    Limit_Gorny     : REAL := 100.0;   // np. 10 bar
END_VAR

VAR_OUTPUT
    Wynik_Skalowania : REAL;    // Wartość przeliczona
    Awaria_Czujnika  : BOOL;    // Błąd zakresu / przerwany przewod
END_VAR

VAR
    Pomoc_Real       : REAL;    // Przejście na wartosc przecinkowa
END_VAR

// 1. Przepisanie wartosci z czujnika na wartosc z przecinkiem
Pomoc_Real := INT_TO_REAL(Sygnal_RAW);

// 2. Skalowanie wartosci z czujnika na wartosci fizyczne
IF (Zakres_Wej_Max - Zakres_Wej_Min) <> 0 THEN
    Wynik_Skalowania := Limit_Dolny + (Pomoc_Real - Zakres_Wej_Min) * (Limit_Gorny - Limit_Dolny) / (Zakres_Wej_Max - Zakres_Wej_Min);
ELSE
    Wynik_Skalowania := 0.0;
    Awaria_Czujnika := TRUE;
END_IF;

// 3. Diagnostyka na wypadek awarii
IF Pomoc_Real < -500.0 OR Pomoc_Real > 30000.0 THEN
    Awaria_Czujnika := TRUE;
ELSE
    Awaria_Czujnika := FALSE;
END_IF;
