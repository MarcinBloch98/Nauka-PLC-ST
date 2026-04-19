VAR
    Czujnik_ruchu : BOOL;                   // czujnik wykrywajacy ruch, ruch = TRUE
    Czujnik_natezezenia_oswietlenia : INT;  // fotokomorka w [luks]
    Zegar_systemowy : RTC;                  // blok zegara czasu rzeczywistego
    Aktualna_godzina : INT;                 // faktyczna godzina (liczba)
    
    Modul_sciemniajacy : INT;               // wartosc 0-100% mocy lamp
    Krok : INT := 0;                        // krok ukladu sekwencyjnego
    
    Timer_brak_ruchu : TON;                 // oczekiwanie przy braku ruchu
    Timer_wylaczenia : TON;                 // czas calkowitego wylaczenia ze standby
END_VAR

VAR_CONSTANT
    Moc_dzien : INT := 100;                 // moc oswietlenia w dzien
    Moc_noc : INT := 30;                    // moc oswietlenia w noc
    Moc_standby : INT := 10;                // oswietlenie gdy na korytarzu nikogo nie ma
    Prog_lux : INT := 500;                  // powyzej tej wartosci uklad nie swieci
END_VAR

// dane w programie
Zegar_systemowy(); 
Aktualna_godzina := Zegar_systemowy.CDT.Hour; // Pobranie aktualnej godziny do obliczeń

// czas przejscia systemu w standby (30 sekund braku ruchu)
Timer_brak_ruchu(IN := NOT Czujnik_ruchu, PT := T#30S);

// po 5 minutach w kroku standby oswietlenie wylaczy sie calkowicie
Timer_wylaczenia(IN := (Krok = 2), PT := T#5M);


// logika programu
CASE Krok OF

    0: // wylaczenie - oszczedzanie energii
        Modul_sciemniajacy := 0;
        
        // wykrycie ruchu w korytarzu gdy jest ciemno
        IF Czujnik_ruchu AND (Czujnik_natezezenia_oswietlenia < Prog_lux) THEN
            Krok := 1;
        END_IF;

    1: // oswietlenie dostosowane do pory dnia
        // Sprawdzenie godziny: dzien (6-22) czy noc
        IF (Aktualna_godzina >= 6 AND Aktualna_godzina < 22) THEN
            Modul_sciemniajacy := Moc_dzien; // Pełna moc 100%
        ELSE
            Modul_sciemniajacy := Moc_noc;   // Moc zredukowana 30%
        END_IF;

        // brak ruchu przez 30 s - sciemnij do standby
        IF Timer_brak_ruchu.Q THEN
            Krok := 2;
        END_IF;

    2: // standby czuwanie - 10% mocy
        Modul_sciemniajacy := Moc_standby;

        // wykryty ruch - powrot do pelnego swiatla (Krok 1)
        IF Czujnik_ruchu THEN
            Krok := 1;
        END_IF;

        // wylaczenie ukladu po 5 minutach bez ruchu lub gdy zrobi sie widno
        IF Timer_wylaczenia.Q OR (Czujnik_natezezenia_oswietlenia > Prog_lux) THEN
            Krok := 0;
        END_IF;

END_CASE;
