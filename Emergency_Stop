PROGRAM SafetyLogic
VAR
    // WEJŚCIA
    bEStop_NC    : BOOL;    // Przycisk bezpieczeństwa (Fizycznie NC - Normalnie Zamknięty)
    bReset_Button : BOOL;   // Przycisk Reset (NO)
    
    // WYJŚCIA
    bSafetyOK    : BOOL;    // Flaga bezpieczeństwa - zezwolenie na pracę
    bError_Lamp  : BOOL;    // Lampa błędu (miga, gdy brak bezpieczeństwa)
END_VAR

// 1. Logika bezpieczeństwa
// Jeśli grzyb jest wciśnięty (bEStop_NC = FALSE), bezpieczeństwo zostaje przerwane
IF NOT bEStop_NC THEN
    bSafetyOK := FALSE;
END_IF

// 2. Warunek Resetu
// Bezpieczeństwo można przywrócić tylko, gdy grzyb jest wyciągnięty (TRUE) 
// i naciśniemy przycisk Reset
IF bEStop_NC AND bReset_Button THEN
    bSafetyOK := TRUE;
END_IF

// 3. Sygnalizacja
bError_Lamp := NOT bSafetyOK;

END_PROGRAM
