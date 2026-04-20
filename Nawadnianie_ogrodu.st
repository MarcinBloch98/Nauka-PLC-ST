VAR
    Czujnik_deszczu : BOOL;         // TRUE = pada deszcz
    Wilgotnosc_gleby : INT;        // 0-100% wilgotnosci
    Zawór_wody : BOOL;              // wyjscie na elektrozawór
    
    Zegar : RTC;                    // czas systemowy
    Godzina : INT;
    
    Timer_podlewania : TON;         // czas pracy zraszaczy
    Krok : INT := 0;                // Maszyna stanów
END_VAR

VAR_CONSTANT
    Prog_wilgotnosci : INT := 40;   // podlewaj tylko ponizej 40% wilgotnosci
    Czas_podlewania : TIME := T#15M; // czas trwania podlewania
    Godzina_startu : INT := 5;      // start o 5:00 rano
END_VAR

// zmienne zegara
Zegar();
Godzina := Zegar.CDT.Hour;

// czas podlewania
Timer_podlewania(IN := (Krok = 2), PT := Czas_podlewania);

CASE Krok OF
    0: // czekanie na podlewanie
        Zawór_wody := FALSE;
        IF Godzina = Godzina_startu THEN
            Krok := 1;
        END_IF;

    1: // analizowanie warunków pogodowych
        IF NOT Czujnik_deszczu AND (Wilgotnosc_gleby < Prog_wilgotnosci) THEN
            Krok := 2; // podlej gdy jest sucho
        ELSE
            Krok := 3; // omin podlewanie gdy jest mokro
        END_IF;

    2: // podlewanie
        Zawór_wody := TRUE;
        IF Timer_podlewania.Q THEN
            Krok := 3;
        END_IF;

    3: // Blokada po cyklu (czekamy, az minie godzina startu)
        Zawór_wody := FALSE;
        IF Godzina <> Godzina_startu THEN
            Krok := 0; // powrot do stanu poczatkowego gdy nastanie odpowiednia godzina
        END_IF;
END_CASE;
