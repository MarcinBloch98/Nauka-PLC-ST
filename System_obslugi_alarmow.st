VAR
    bladCzujnika    : BOOL;   // czujnik PNP wykrywajacy blad czujnika
    bladPompy       : BOOL;   // czujnik PNP wykrywajacy blad pompy
    resetAlarmu     : BOOL;   // przycisk NC resetujacy calkowicie alarm
    
    Krok            : INT;    // Zapomniałeś o deklaracji zmiennej sterującej CASE
    lampkaAlarmu    : BOOL;   // lampka sygnalizuja alarm w ukladzie
    flagaAlarmu     : BOOL;   // pamiec wystapienia alarmu
    TON_swiecenie   : TON;    // czasowka do generatora impulsow - stan wysoki
    TON_przerwa     : TON;    // // czasowka do generatora impulsow - stan niski
END_VAR

// generator impulsow 1 Hz
TON_przerwa(IN := NOT TON_swiecenie.Q AND flagaAlarmu, PT := T#500MS);
TON_swiecenie(IN := TON_przerwa.Q, PT := T#500MS);

CASE Krok OF

  0:  // oczekiwanie na awarie
      IF bladCzujnika OR bladPompy THEN
        flagaAlarmu := TRUE;
        Krok := 1;
      END_IF;

  1: // sygnalizacja migajaca lampki
      lampkaAlarmu := TON_swiecenie.Q; 
      
      IF NOT resetAlarmu THEN
        flagaAlarmu := FALSE; // wylaczenie migotania diody
        Krok := 2;
      END_IF;
      
  2: // potwierdzenie - lampka sygnalizacja jednostajna, czekanie na naprawienie awarii
      lampkaAlarmu := TRUE;

      IF NOT bladCzujnika AND NOT bladPompy THEN
        lampkaAlarmu := FALSE;
        Krok := 0; // powrot do stanu poczatkowego
      END_IF;
      
END_CASE;
