VAR
Pozycja_analog : INT;
Pozycja_zadana : INT;
Wybor_pietra : INT;
Obecne_pietro_windy : INT;
Waga : REAL;
Jazda_gora : BOOL;
Jazda_dol : BOOL;
Stop : BOOL;
Alarm_ukladu : BOOL;
Timer_pauzy : TON;
Przycisk_pietra_0 : BOOL;  //przycisk wyboru pietra 0
Przycisk_pietra_1 : BOOL;  //przycisk wyboru pietra 1
Przycisk_pietra_2 : BOOL;  //przycisk wyboru pietra 2
Przycisk_pietra_3 : BOOL;  //przycisk wyboru pietra 3
Przycisk_pietra_4 : BOOL;  //przycisk wyboru pietra 4
END_VAR;

IF Waga > 500 THEN  // wykrycie alarmu
Alarm_ukladu := TRUE;
END_IF;

Timer_pauzy(IN := (Przycisk_pietra_0 OR Przycisk_pietra_1 OR Przycisk_pietra_2 OR Przycisk_pietra_3 OR Przycisk_pietra_4) 
  AND NOT Jazda_gora AND NOT Jazda_dol, 
  PT := T#2s);

CASE Wybor_pietra OF
  0:  Pozycja_zadana := 0;
  1:  Pozycja_zadana := 250;
  2:  Pozycja_zadana :=500;
  3:  Pozycja_zadana := 750;
  4:  Pozycja_zadana := 1000;
END_CASE;
  
IF Przycisk_pietra_0 THEN
Wybor_pietra := 0;
END_IF;

IF Przycisk_pietra_1 THEN
Wybor_pietra := 1;
END_IF;

IF Przycisk_pietra_2 THEN
Wybor_pietra := 2;
END_IF;

IF Przycisk_pietra_3 THEN
Wybor_pietra := 3;
END_IF;

IF Przycisk_pietra_4 THEN
Wybor_pietra := 4;
END_IF;

IF Pozycja_analog > (Pozycja_zadana +10) AND Timer_pauzy.Q THEN  // jazda w DOL
Jazda_dol := TRUE;
Jazda_gora := FALSE;
END_IF;

IF Pozycja_analog < (Pozycja_zadana - 10) AND Timer_pauzy.Q THEN  // jazda w GORE
Jazda_gora := TRUE;
Jazda_dol := FALSE;
END_IF;

IF Pozycja_analog >= (Pozycja_zadana -10) AND Pozycja_analog <= (Pozycja_zadana + 10) THEN
Jazda_gora := FALSE;
Jazda_dol := FALSE;
END_IF;

IF Stop OR Alarm_ukladu THEN  // STOP LUB ALARM UKLADU
Jazda_dol := FALSE;
Jazda_gora := FALSE;
END_IF;
