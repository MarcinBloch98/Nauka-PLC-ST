VAR
    // wejścia wyjścia
    raw_Input : INT;          // sygnał z czujnika 0-32767
    scaled_value : REAL;      // wynik w jednostkach w bar
    
    // zmienne pomocnicze
    in_real : REAL;           // konwersja wartosci wejsciowej
    
    // alarmy
    alarm_HH : BOOL;          // alarm - za wysokie cisnienie
    alarm_LL : BOOL;          // alarm - za niskie cisnienie
END_VAR

VAR_CONSTANT
    Raw_Max : REAL := 32767.0; // maksymalna wartosc plc
    EU_Max : REAL := 10.0;     // maksymalne cisnienie
    limit_HH : REAL := 9.5;    // wartosc alarmu wysokiego
    limit_LL : REAL := 0.5;    // wartosc alarmu nisokiego
END_VAR

// konwersja danych
in_real := INT_TO_REAL(raw_input);

// skalowanie
// obliczamy jaki to procent zakresu i mnożymy przez wartość maksymalną
scaled_value := (in_real / raw_max) * EU_Max;

// kontrola limitow
// kontrola niskiego cisnienia
IF scaled_value >= limit_HH THEN
    alarm_HH := TRUE;
ELSE
    alarm_HH := FALSE;
END_IF;

// Sprawdzanie niskiego ciśnienia
IF scaled_value <= limit_LL THEN
    alarm_LL := TRUE;
ELSE
    alarm_LL := FALSE;
END_IF;
