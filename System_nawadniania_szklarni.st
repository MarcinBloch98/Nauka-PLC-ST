VAR
Start : BOOL;  // przycisk uruchamiajacy system
Numer_sekcji : INT := 1;
Czas_podlewania : ARRAY[1..4] OF TIME := [T#10s, T#20s, T#25s, T#40s];
Zawory : ARRAY[1..4] OF BOOL;  // tablica wyjsc na kolejne zawory
Praca : BOOL;  // flaga pracy
Krok : INT := 0;  // numer kroku
Timer_podlewania : TON;  // timer czasu podlewania sekcji
END_VAR

IF Start THEN
Praca := 1;  // pamiec pracy ukladu
END_IF;

IF Praca Then
  Case Krok OF
  0:  // ustawienie sekcji
      Numer_sekcji := 1;
      Krok := 10;
      
  10:  // otwarcie odpowiedniego zaworu
      Zawory[Numer_sekcji] := TRUE;
      Timer_podlewania.PT := Czas_podlewania[Numer_sekcji];
      Timer_podlewania.IN := TRUE;  // start odliczania podlewania

      IF Timer_podlewania.Q THEN
          Krok := 20;
      END_IF;
      
  20:  // zamkniecie odpowiedniego zaworu i przejscie dalej
      Zawory[Numer_sekcji] := FALSE;
      Timer_podlewania.IN := FALSE;  // wylaczenie timera czasu podlewania

      // sekwencja przejscia do kolejnej sekcji
      IF Numer_sekcji < 4 THEN
        Numer_sekcji := Numer_sekcji + 1;
        Krok := 10;  // powrot i podlanie kolejnej sekcji
      ELSE
        Praca := FALSE;  // po podlaniu wszystkiego wylacz uklad
        Krok := 0;  // powrot do pierwszego kroku czekajacego na uruchomienie
      END_IF;
  END_CASE;

Timer_podlewania();
  
END_IF;
