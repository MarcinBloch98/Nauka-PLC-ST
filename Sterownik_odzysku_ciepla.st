VAR
    Temp_oleju_kompresora : REAL;  // pomiar temperatury oleju sprezarki
    Temp_zbiornika_co    : REAL;  // pomiar temperatury w zbiorniku
    Zezwolenie_pracy     : BOOL;  // sygnal potwierdzajacy prace kompresora
    
    Timer_stabilizacji   : TON;   // timer stabilizujacy prace pompy
    Krok                 : INT;   // krok sekwencji: 0-oczekiwanie, 1-weryfikacja, 2-odzysk aktywny
    
    Pompa_obiegowa_odzysku: BOOL; // pompa podajaca czynnik przez wymiennik
    Zawor_trojdrogowy    : BOOL;  // zawor przekierowujacy przeplyw
END_VAR

CASE Krok OF
    0: // Oczekiwanie na odpowiednie warunki przy pracujacej sprezarce
        IF Zezwolenie_pracy AND (Temp_oleju_kompresora > 75.0) AND (Temp_zbiornika_co < 60.0) THEN
            Krok := 1; // Przekroczono prog -> przejdz do weryfikacji
        END_IF;
        
    1: // Weryfikacja stabilnosci - warunki musza sie utrzymac przez okreslony czas
        IF NOT Zezwolenie_pracy OR (Temp_oleju_kompresora < 72.0) OR (Temp_zbiornika_co >= 62.0) THEN
            Krok := 0; // Warunki ulegly pogorszeniu -> powrot do oczekiwania
        ELSIF Timer_stabilizacji.Q THEN
            Krok := 2; // Temperatura stabilna -> aktywacja odzysku ciepla
        END_IF;
        
    2: // Odzysk energii odpadowej
        IF NOT Zezwolenie_pracy OR (Temp_oleju_kompresora < 68.0) OR (Temp_zbiornika_co >= 65.0) THEN
            Krok := 0; // Osiagnieto limit lub sprezarka stanela -> stop odzysku
        END_IF;
END_CASE;

// timery
// Warunki startu musza byc spelnione nieprzerwanie przez 5 sekund, aby uniknac uderzen hydraulicznych
Timer_stabilizacji(IN := (Krok = 1), PT := T#5s);  // warunek startu musi byc spelniony przez conajmniej 5 sekund

// krok sterowania pompami
Pompa_obiegowa_odzysku := (Krok = 2);
Zawor_trojdrogowy      := (Krok = 2);
