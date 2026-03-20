(* Rozruch kaskadowy linii tasmociagow *)

VAR
    Przycisk_Start   : BOOL;    // Przycisk Start (NO)
    Przycisk_Stop    : BOOL;    // Przycisk Stop (NC)
    System_Aktywny   : BOOL;    // Flaga pamieci ukladu
    
    Zwloka_S2        : TON;     // Czas oczekiwania na silnik 2
    Zwloka_S3        : TON;     // Czas oczekiwania na silnik 3
    
    Silnik_1         : BOOL;    
    Silnik_2         : BOOL;    
    Silnik_3         : BOOL;    
END_VAR

// 1. Logika zalaczania ukladu - podtrzymanie
IF Przycisk_Start AND Przycisk_Stop THEN
    System_Aktywny := TRUE;
ELSIF NOT Przycisk_Stop THEN
    System_Aktywny := FALSE;
END_IF;

// 2. Uklad kaskadowy - kazdy kolejny krok wynika z poprzedniego
Silnik_1 := System_Aktywny;

Zwloka_S2(IN := Silnik_1, PT := T#5S);
Silnik_2 := Zwloka_S2.Q;

Zwloka_S3(IN := Silnik_2, PT := T#5S);
Silnik_3 := Zwloka_S3.Q;
