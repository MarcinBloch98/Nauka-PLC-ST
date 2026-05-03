VAR
    Ostatnie_czasy : ARRAY[1..5] OF TIME;  // tablica z czasami
    Indeks_zapisu : INT := 1;  // wskaznik mowiacy do jakiej komorki tablicy zapisac czas
    Sensor_wyjscie : BOOL;  // czujnik wykrywajacy fizyczny przejazd pudelka
    Aktualny_czas_pudelka : TIME;   // zmienna czasowa jak dlugo pudelko bylo pakowane
    Sredni_czas : TIME;  // zmienna do wyniku obliczen z pakowania 5 ostatnich pudelek
    Suma_czasow : LINT;  // zamianana typu TIME na  i sumowanie czasow w tej komorce
    i : INT;  // licznik petli
    Trigger_Sensor : R_TRIG;  // zbocze narastajace
END_VAR

// wykrycie zbocza (impulsu) czujnika
Trigger_Sensor(CLK := Sensor_wyjscie);

IF Trigger_Sensor.Q THEN
    // zapis do tablicy
    Ostatnie_czasy[Indeks_zapisu] := Aktualny_czas_pudelka;

    // przesunięcie indeksu
    Indeks_zapisu := Indeks_zapisu + 1;

    // po zapelnieniu calej talicy wracamy na poczatek
    IF Indeks_zapisu > 5 THEN
        Indeks_zapisu := 1;
    END_IF;
END_IF;

// obliczanie sredniej i sumowanie wyniku
Suma_czasow := 0; 

FOR i := 1 TO 5 DO
    // sumowanie wszystkich elementów tablicy
    Suma_czasow := Suma_czasow + TIME_TO_LINT(Ostatnie_czasy[i]);
END_FOR;

// wynik sredniej czasu
Sredni_czas := LINT_TO_TIME(Suma_czasow / 5);
