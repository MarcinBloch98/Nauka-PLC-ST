PROGRAM ProductionCounter
VAR
    // --- WEJŚCIA CYFROWE ---
    bSensor_PartDetected : BOOL;    // Sygnał z fotokomórki (TRUE = detal wykryty)
    bReset_Counter       : BOOL;    // Fizyczny przycisk zerowania licznika
    
    // --- PARAMETRY I USTAWIENIA ---
    iTarget_Quantity    : INT := 10; // Docelowa liczba detali w jednym opakowaniu
    
    // --- PAMIĘĆ WEWNĘTRZNA ---
    bSensor_LastState    : BOOL;    // Przechowuje stan czujnika z poprzedniego cyklu sterownika
    
    // --- WYJŚCIA I STATUSY ---
    iCurrent_Count      : INT := 0;  // Suma zliczonych detali w aktualnej partii
    bBox_Full           : BOOL;      // Sygnał zakończenia pakowania (osiągnięto limit)
END_VAR

// 1. Logika wykrywania zbocza narastającego (R_TRIG - zobacze narastające)
// Sprawdzamy czy teraz jest sygnał, a w poprzednim cyklu go nie było. Zapobiega to wielokrotnemu zliczaniu tego samego detalu.
IF bSensor_PartDetected AND NOT bSensor_LastState THEN
    iCurrent_Count := iCurrent_Count + 1; // Inkrementacja licznika
END_IF
// Przepisujemy aktualny stan na "stary", aby użyć go w następnym obiegu pętli
bSensor_LastState := bSensor_PartDetected;

// 2. Kontrola wypełnienia (Porównanie)
// Jeśli licznik osiągnie lub przekroczy limit, wystawiamy sygnał pełnego kartonu.
IF iCurrent_Count >= iTarget_Quantity THEN
    bBox_Full := TRUE;  // Aktywacja wyjścia
ELSE
    bBox_Full := FALSE; // Wyłączenie sygnału, jeśli licznik jest poniżej limitu
END_IF

// 3. Obsługa zerowania systemu
// Jeśli operator naciśnie przycisk Reset, licznik wraca do zera.
IF bReset_Counter THEN
    iCurrent_Count := 0; // Zerowanie wartości aktualnej
END_IF

END_PROGRAM
