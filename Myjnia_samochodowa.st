VAR
    Przycisk_start : BOOL;  // przycisk monostabilny NO wlaczajacy uklad 
    Przycisk_stop : BOOL;   // przycisk monostabilny NC zatrzymujacy prace ukladu
    Szczotki_naped : BOOL;  // silniki szczotek czyszczacych auto
    Wentylator_suszarka : BOOL;  // wyjscie wentylatora suszacego samochod
    Zawor_woda : BOOL;  // zawor wody do mycia i splukiwania
    Zawor_szampon : BOOL;  // zawor podajacy szampon samochodowy
    
    // deklaracja wszystkich timerow dla kazdego kroku
    Czas_kroku_1 : TON;  // czas namaczania
    Czas_kroku_2 : TON;  // czas mcyai zasadniczego
    Czas_kroku_3 : TON;  // czas plukania
    Czas_kroku_4 : TON;  // czas suszenia
    
    Stan : INT := 0; // aktualny krok
END_VAR

// logika timerow
// timery mierza czas gdy dany stan jest aktywny
Czas_kroku_1(IN := (Stan = 1), PT := T#5S);  // czas namaczania
Czas_kroku_2(IN := (Stan = 2), PT := T#10S); // czas mycia zasadniczego
Czas_kroku_3(IN := (Stan = 3), PT := T#5S);  // czas plukania
Czas_kroku_4(IN := (Stan = 4), PT := T#8S);  // czas suszenia

// zatrzymanie o najwiekszym priorytecie
IF NOT Przycisk_stop THEN // jesli  wcisniety grzyb NC = FALSE to alarm
    Stan := 0;
    Zawor_woda := 0;
    Zawor_szampon := 0;
    Szczotki_naped := 0;
    Wentylator_suszarka := 0;
END_IF;

// kroki myjni

// #1 namaczanie
IF Przycisk_start AND Przycisk_stop AND Stan = 0 THEN  // namaczanie samochodu
    Stan := 1;
    Zawor_woda := 1;
END_IF;

// #2: mycie zasadnicze
IF Czas_kroku_1.Q AND Stan = 1 THEN
    Stan := 2;
    Zawor_woda := 1;
    Szczotki_naped := 1;
    Zawor_szampon := 1;
END_IF;

// #3: plukanie
IF Czas_kroku_2.Q AND Stan = 2 THEN
    Stan := 3;
    Szczotki_naped := 0;
    Zawor_szampon := 0;
    Zawor_woda := 1;
END_IF;

// #4: suszenie
IF Czas_kroku_3.Q AND Stan = 3 THEN
    Stan := 4;
    Zawor_woda := 0;
    Wentylator_suszarka := 1; // Uruchomienie nadmuchu
END_IF;

// koniec cyklu
IF Czas_kroku_4.Q AND Stan = 4 THEN
    Stan := 0; // powrot do oczekiwania na sygnal
    Wentylator_suszarka := 0; // wylaczenie suszenia
END_IF;
