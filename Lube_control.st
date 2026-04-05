VAR
    Wlacznik_Start      : BOOL;   // Przycisk monostabilny NO (Start)
    Przycisk_Stop       : BOOL;   // Przycisk monostabilny NC (Stop)
    Reset_alarmu        : BOOL;   // Przycisk kasowania błędów
    Cisnienie_smaru     : REAL;   // Wartość ciśnienia w układzie [bar]

    Silnik_hala         : BOOL;   // Stycznik silnika głównego
    Pompa_smaru         : BOOL;   // Wyjście sterujące pompą smaru
    
    Maszyna_Pracuje     : BOOL;   // Flaga stanu pracy (Zatrzask SET/RESET)
    Licznik_cyklu       : INT;    // Ilość cykli pracy maszyny
    Alarm_ukladu        : BOOL;   // Pamięć błędu krytycznego
    Status_maszyny      : STRING; // Informacja tekstowa dla operatora
    Reset_Timera        : BOOL;   // Sygnał odświeżenia timera 8h
    
    Czas_pracy          : TON;    // Odlicza 8h do kolejnego smarowania
    Timer_cisnienia     : TON;    // Czeka 30s na nabicie ciśnienia
    R_Trig_Puls         : R_TRIG; // Wykrywa moment startu silnika
END_VAR

// maszyna rusza po wicsnieciu start jesli nie ma alarmu
IF Wlacznik_Start AND NOT Alarm_ukladu THEN
    Maszyna_Pracuje := TRUE;
END_IF;

// zatrzymmanie maszyny po stop lub alarmie ukladu
IF Przycisk_Stop OR Alarm_ukladu THEN
    Maszyna_Pracuje := FALSE;
END_IF;

// czas pracy gdy maszyna pracuje, nie liczy sie czas smarowania
Czas_pracy(IN := Maszyna_Pracuje AND NOT Pompa_smaru AND NOT Reset_Timera, PT := T#8h);

// cykliczny czas smarowania
Timer_cisnienia(IN := Pompa_smaru, PT := T#30s);

// zliczanie ilosci uruchomien maszyny
R_Trig_Puls(CLK := Maszyna_Pracuje);

IF R_Trig_Puls.Q THEN
    Licznik_cyklu := Licznik_cyklu + 1;
END_IF;


// cykliczne smarowanie pompy po 8h lub 100 cyklach
IF Czas_pracy.Q OR Licznik_cyklu >= 100 THEN
    Pompa_smaru := TRUE;
END_IF;

// wylaczenie pompy po osiagnieciu cisnienia
IF Pompa_smaru AND Cisnienie_smaru >= 50.0 THEN
    Pompa_smaru    := FALSE;
    Licznik_cyklu  := 0;
    Reset_Timera   := TRUE;  // Puls resetujący timer TON
ELSE
    Reset_Timera   := FALSE;
END_IF;

// alarm gdy po 30 sekundach pracy pompy nie ma cisnienia
IF Timer_cisnienia.Q AND Cisnienie_smaru < 50.0 THEN
    Alarm_ukladu := TRUE;
    Pompa_smaru  := FALSE; // Ochrona pompy przed pracą na sucho
END_IF;

// kasowanie alarmu
IF Reset_alarmu THEN
    Alarm_ukladu := FALSE;
END_IF;

// statusy
IF Alarm_ukladu THEN
    Status_maszyny := 'Awaria: ZA NISKIE CISNIENIE SMARU';
ELSIF Pompa_smaru THEN
    Status_maszyny := 'TRWA SMAROWANIE...';
ELSIF Maszyna_Pracuje THEN
    Status_maszyny := 'PRACA NORMALNA';
ELSE
    Status_maszyny := 'MASZYNA ZATRZYMANA';
END_IF;

// sterowanie stycznikiem glownego napedu
Silnik_hala := Maszyna_Pracuje;
