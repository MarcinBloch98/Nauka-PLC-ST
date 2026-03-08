VAR
    // WEJŚCIA
    bStart      : BOOL;    // Przycisk Start (NO)
    bStop       : BOOL;    // Przycisk Stop (NC)
    
    // WYJŚCIA
    bSilnik     : BOOL;    // Stycznik silnika taśmy
    bLampa      : BOOL;    // Lampa sygnalizacyjna
    
    // WEWNĘTRZNE
    fbTimer     : TON;     // Timer do opóźnienia startu
    bPraca      : BOOL;    // Flaga stanu pracy
END_VAR

// 1. Logika Start/Stop (Podtrzymanie)
IF bStart AND bStop THEN
    bPraca := TRUE;
ELSIF NOT bStop THEN
    bPraca := FALSE;
END_IF

// Timer opóźniający start silnika (3 sekundy ostrzeżenia)
fbTimer(IN := bPraca, PT := T#3s);

// Sterowanie wyjściami
bSilnik := fbTimer.Q;      // Silnik rusza dopiero po odliczeniu czasu
bLampa  := bPraca AND NOT fbTimer.Q; // Lampa świeci tylko podczas odliczania timera

END_PROGRAM
