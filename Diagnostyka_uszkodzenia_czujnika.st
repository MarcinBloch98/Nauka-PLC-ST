VAR
  wartoscCzujnik : REAL;  // wartosc odczytana z czujnika
  ostatniaWartosc : REAL;  // ostatnia wartosc z czujnika
  timerKontrola : TON;  // czas sprawdzania wartosci zmiany
  bladCzujnika : BOOL;  // pamiec bledu
  tolercjaSygnalu : REAL := 0.01;  // minimalna mozliwa zmiana aby program ja zauwazyl
END_VAR


// sprawdzenie odleglosci miedzy dwiema liczbami
IF ABS(wartoscCzujnik - ostatniaWartosc) < tolercjaSygnalu THEN
    // gdy tolerancja miedzy sygnalami jest za mala to uruchom odliczanie
    timerKontrola.IN := TRUE;
ELSE
    // gdy jednak sygnal sie zmienia to zresetuj timer
    timerKontrola.IN := FALSE;
END_IF;

timerKontrola.PT := T#10s; // deadline ze czujnik jest uszkodzony
timerKontrola();           // wywolanie timera kontroli sygnalu

IF timerKontrola.Q THEN
    bladCzujnika := TRUE;  // sygnalizacja alarmu
END_IF;

ostatniaWartosc := wartoscCzujnik;  // zapamietanie ostatniej wartosci czujnika
