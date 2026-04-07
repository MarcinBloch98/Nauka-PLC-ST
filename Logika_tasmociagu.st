VAR
    Start_linii      : BOOL;   // przycisk Start (NO)
    Bit_pracy_linii  : BOOL;   // bit pracy linii
    Stop_linii       : BOOL;   // przycisk Stop (NC)
    Czujnik_obecnosci: BOOL;   // fotokomorka na końcu tasmy
    Reset_alarmu     : BOOL;   // przycisk potwierdzenia awarii
    Silnik_tasmy     : BOOL;   // wyjście na stycznik silnika
    Alarm_zator      : BOOL;   // czerwona lampka alarmowa
    Timer_eco        : TOF;    // timer podtrzymujący bieg tasmy
    Timer_zator      : TON;    // timer wykrywajacy blokade
END_VAR

Timer_eco(IN := Start_linii OR Czujnik_obecnosci, PT := T#10s);  // wlaczamy zegar przyciskiem start, kazda paczka resetuje czas i liczy ponowne 10 s
Timer_zator(IN := Czujnik_obecnosci, PT := T#5s);

IF Start_linii AND Stop_linii AND NOT Alarm_zator THEN  // aktywacja gotowej linii bez awarii  // 
  Bit_pracy_linii := TRUE;  // uruchomienie pracy linii
END_IF;

IF Timer_eco.Q AND NOT Czujnik_obecnosci AND NOT Stop_linii THEN  // wylaczenie pracy po czasie bezczynnosci bez paczek
  Silnik_tasmy := 0;
  Bit_pracy_linii := FALSE;
END_IF;

IF Timer_zator.Q THEN  // aktwyacja alarmu gdy czujnik wykrywa obiekt zbyt dlugo
  Silnik_tasmy := FALSE;
  Alarm_zator := TRUE;
END_IF;

IF Timer_zator.Q AND NOT Czujnik_obecnosci AND Reset_alarmu THEN
  Alarm_zator := FALSE;
END_IF;

Silnik_tasmy := Bit_pracy_linii AND Timer_eco.Q AND NOT Alarm_zator;  // sterowanie napedem z uzglednieniem trybu eco oraz blokady startu
