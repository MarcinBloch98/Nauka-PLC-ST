VAR
    Raw_Input : INT;          // bezposrednia wartość z wejścia analogowego
    Temp_Min : REAL := -50.0; // Dolny sygnal czujnika
    Temp_Max : REAL := 150.0; // Górny sygnal czujnika
    Current_Temp : REAL;      // Obliczona temperatura w stopniach C
    Alarm_Przegrzania : BOOL; // Sygnał alarmowy
END_VAR

// 1. Skalowanie - zamiana INT na REAL ze wzrou
// uzycie instrukcji INT_TO_REAL
Current_Temp := (INT_TO_REAL(Raw_Input) / 27648.0) * (Temp_Max - Temp_Min) + Temp_Min;

// 2. Instrukcja alarmu
IF Current_Temp > 100.0 THEN
    Alarm_Przegrzania := TRUE;
ELSE
    Alarm_Przegrzania := FALSE; // wyłączenie alarmu gdy temp. spadnie!
END_IF;
