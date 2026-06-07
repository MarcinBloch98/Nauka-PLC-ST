VAR
    Presostat_roznicy_p  : BOOL;  // czujnik przekroczenia max roznicy cisnien - filtr zapchany
    Zezwolenie_pracy     : BOOL;  // sygnal potwierdzajacy prace wlownego wentylatora
    
    Timer_impulsu        : TON;   // timer kontrolujacy czas trwania strzalu powietrza (np. 500ms)
    Timer_pauzy          : TON;   // timer liczacy przerwe miedzy strzalami roznych sekcji
    Krok                 : INT;   // krok ukladu: 0-spoczynek, 1-strzal 1, 2-pauza, 3-strzal 2
    
    Zawor_Przedmuchu_1   : BOOL;  // elektrozawor sprzonego powietrza dla sekcji 1
    Zawor_Przedmuchu_2   : BOOL;  // elektrozawor sprzonego powietrza dla sekcji 2
END_VAR

CASE Krok OF
    0: // Oczekiwanie na sygnal zapchania filtra przy pracy
        IF Presostat_roznicy_p AND Zezwolenie_pracy THEN
            Krok := 1; // rozpoczecie regeneracji
        END_IF;
        
    1: // strzal powietrza - sekcja 1
        IF Timer_impulsu.Q THEN
            Krok := 2; // koniec strzalu -> przejdz do pauzy 
        END_IF;
        
    2: // przerwa na powrot cisnienia w zbiorniku
        IF Timer_pauzy.Q THEN
            Krok := 3; // powrot cisnienia -> strzal na sekcje 2
        END_IF;
        
    3: // Strzal powietrza - sekcja 2
        IF Timer_impulsu.Q THEN
            Krok := 0; // koniec oczyszczania -> powrot do czuwania
        END_IF;
END_CASE;

// timery
Timer_impulsu(IN := (Krok = 1) OR (Krok = 3), PT := T#500ms);  // czas pojedynczego strzalu powietrza

Timer_pauzy(IN := (Krok = 2), PT := T#4s);  // czas powrotu cisnienia

// sterowanie wyjsciami
Zawor_Przedmuchu_1 := Zezwolenie_pracy AND (Krok = 1);
Zawor_Przedmuchu_2 := Zezwolenie_pracy AND (Krok = 3);
