VAR
    Numer_stanowiska : INT;      // wybor jednego stanowiska z pieciu
    Dodaj_paczke : BOOL;         // sygnal z czujnika/przycisku
    Reset_total : BOOL;          // zerowanie licznikow
    
    // Definicja tablicy
    Licznik_paczki : ARRAY[0..4] OF INT; // tablica przechowujaca wyniki
    
    i : INT;                     // licznik do petli FOR
    R_Trig_Paczka : R_TRIG;      // wykrywanie zbocza
END_VAR

// detekcja zbocza
R_Trig_Paczka(CLK := Dodaj_paczke);

// dodawanie paczki z kontrola zakresu
IF R_Trig_Paczka.Q AND (Numer_stanowiska >= 0 AND Numer_stanowiska <= 4) THEN
    // zwiekszamy wartosc w wybranej "szufladce"
    Licznik_paczki[Numer_stanowiska] := Licznik_paczki[Numer_stanowiska] + 1;
END_IF;

// czyszczenie wszystkich stanowisk (Reset)
IF Reset_total THEN
    // petla FOR przechodzi przez 0, 1, 2, 3, 4
    FOR i := 0 TO 4 DO
        Licznik_paczki[i] := 0; 
    END_FOR;
END_IF;
