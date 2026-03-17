// Sterowanie sekwencyjne taśmociągiem (Automat Stanów)
// Główna logika zarządzająca procesem transportu detali.
// Wykorzystuje strukturę CASE do separacji stanów pracy.

// 1. Zastosowałem numerację co 10 (0, 10...), aby umożliwić łatwą rozbudowę 
//    sekwencji o dodatkowe stany bez konieczności potrzeby przenumerowywania kodu.
// 2. Stan 99 zarezerwowano dla trybu EMERGENCY (Awaria) - wysoka wartość 
//    pozwala na szybką identyfikację błędu w systemie monitoringu.

VAR
    iState          : INT := 0;     // Numer aktualnego stanu maszyny
    sStatus_Message : STRING;       // Komunikat tekstowy dla panelu HMI
    bMotor_Run      : BOOL;         // Wyjście fizyczne: Silnik napędu
    bStart_Button   : BOOL;         // Wejście: Przycisk START (NO)
    bStop_Button    : BOOL;         // Wejście: Przycisk STOP (NC)
    bSafety_OK      : BOOL;         // Sygnał z przekaźnika bezpieczeństwa
    bSensor_Full    : BOOL;         // Wejście: Czujnik zajętości odbioru
    bReset_Button   : BOOL;         // Wejście: Przycisk Reset błędu
END_VAR

// LOGIKA STEROWANIA
CASE iState OF

    0: // STAN: IDLE - Oczekiwanie na inicjację procesu
        bMotor_Run := FALSE;
        sStatus_Message := 'System gotowy - Oczekiwanie na START';
        
        // Wciśnięty start i obwód bezpieczeństwa jest zamknięty
        IF bStart_Button AND bSafety_OK THEN
            iState := 10; 
        END_IF

    10: // STAN: PRACA - Praca automatyczna taśmociągu
        bMotor_Run := TRUE;
        sStatus_Message := 'Produkcja w toku - Taśma pracuje';
        
        // Powrót jeśli naciśnięto STOP lub czujnik wykrył zator (pełny karton)
        IF bStop_Button OR bSensor_Full THEN
            iState := 0; 
        END_IF
        
        // Priorytetowe przejście do stanu awaryjnego przy sygnale E-Stop
        IF NOT bSafety_OK THEN
            iState := 99; 
        END_IF

    99: // STAN: EMERGENCY - Blokada po naruszeniu bezpieczeństwa
        bMotor_Run := FALSE; // Natychmiastowe zatrzymanie napędu
        sStatus_Message := 'ALARM: Naruszone bezpieczeństwo! Wymagany Reset';
        
        // Powrót do trybu gotowości tylko po przywróceniu bezpieczeństwa i potwierdzeniu
        IF bSafety_OK AND bReset_Button THEN
            iState := 0; 
        END_IF

    ELSE // Zabezpieczenie przed nieoczekiwaną wartością iState program przechodzi w tryb czekania na sygnał
        iState := 0;

END_CASE
