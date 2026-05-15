VAR
    Sygnal_SAP          : BOOL;   // czujnik pozaru
    Przycisk_strazaka   : BOOL;   // reczny przycisk oddymiania
    Krancowka_klapy     : BOOL;   // krancowka klapy dymowej
    Czyste_powietrze    : BOOL;   // czujnik wykrywajacy czyste powietrze(brak dymu)
    Klapa_dymowa_otworz : BOOL;   // otwieranie klapy dymowej
    Wentylator_nawiew   : BOOL;   // wentylator podajacy powietrze
    Syrena_alarmowa     : BOOL;   // sygnal dzwiekowy
    Alarm_awaria_klapy  : BOOL;   // blad krytyczny otwierania klapy
    Timer_otwarcia      : TON;    // czas otwierania klapy
END_VAR

// procedura oddymiania
IF Sygnal_SAP OR Przycisk_Strazaka THEN
    Klapa_Dymowa_Otworz := TRUE;
    Syrena_Alarmowa     := TRUE;
ELSE
    Klapa_Dymowa_Otworz := FALSE;
    Syrena_Alarmowa     := FALSE;
END_IF;

// sterowanie wentylatora napowietrzajacego robiacy nadcisnienie gdy klapa jest otwarta
IF Klapa_Dymowa_Otworz AND Krancowka_Klapy AND Czyste_Powietrze_OK THEN
    Wentylator_Nawiew := TRUE;
ELSE
    Wentylator_Nawiew := FALSE;
END_IF;

// detekcja uszkodzenia, przy otwarciu mierzymy czas
Timer_Otwarcia(IN := Klapa_Dymowa_Otworz, PT := T#5S);

// jesli po czasie nie ma sygnalu z krancowki - ALARM
IF Timer_Otwarcia.Q AND NOT Krancowka_Klapy THEN
    Alarm_Awaria_Klapy := TRUE;
ELSE
    Alarm_Awaria_Klapy := FALSE;
END_IF;
