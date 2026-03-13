FUNCTION_BLOCK Motor_control_diagnostic
VAR_INPUT
    xStart    : BOOL; // Przycisk Start
    xStop     : BOOL; // Przycisk Stop
    xFeedback : BOOL; // Potwierdzenie, ze silnik faktycznie ruszyl
    xErrorIn  : BOOL; // Awaria zewnetrzna (np. termik)
    xReset    : BOOL; // Przycisk do kasowania bledu
END_VAR

VAR_OUTPUT
    xRun      : BOOL;   // Wyjscie na stycznik silnika
    xAlarm    : BOOL;   // Lampka alarmu
    sStatus   : STRING; // Tekstowy opis na ekran HMI
END_VAR

VAR
    Timer_Potw : TON; // Zegar/czasowka
END_VAR

// --- 1. LOGIKA START / STOP ---
// Silnik rusza, gdy wciskasz Start, pod warunkiem, ze nie ma awarii i alarmu
IF xStart AND NOT xErrorIn AND NOT xAlarm THEN
    xRun := TRUE;
    sStatus := 'Silnik pracuje';
END_IF;

// Silnik staje, gdy: wcisniesz Stop, wywali blad (ErrorIn) lub pojawi sie Alarm
IF xStop OR xErrorIn OR xAlarm THEN
    xRun := FALSE;
    // Jesli to nie byl alarm, ustaw status na postoj
    IF NOT xAlarm THEN 
        sStatus := 'Postoj';
    END_IF;
END_IF;


// --- 2. CZASOWKA (DIAGNOSTYKA) ---
// Timer liczy, gdy: wykonuje sie praca (xRun), ale nie widzisz potwierdzenia (NOT xFeedback)
Timer_Potw(IN := (xRun AND NOT xFeedback), PT := T#2s);


// --- 3. REAKCJA NA BLAD ---
// Jesli timer doliczyl do 2 sekund (Q), to znaczy, ze cos jest nie tak
IF Timer_Potw.Q THEN
    xAlarm  := TRUE;             // Wlaczamy alarm
    sStatus := 'Blad potwierdzenia'; // Opisujemy blad
    xRun    := FALSE;            // Wylaczamy silnik dla bezpieczenstwa
END_IF;


// --- 4. KASOWANIE ALARMU ---
// Gdy operator wcisnie Reset, czyscimy alarm i status
IF xReset THEN
    xAlarm := FALSE;
    sStatus := 'Gotowy';
END_IF;
