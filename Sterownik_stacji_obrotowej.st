VAR
    Paleta_na_stacji     : BOOL;  // fotokomorka obecnosci palety na obrotnicy
    Krancowka_pozycja_0  : BOOL;  // czujnik pozycji bazowej 0 stopni
    Krancowka_pozycja_90 : BOOL;  // czujnik pozycji odwroconej  90 stopni
    Zgoda_na_wydanie     : BOOL;  // sygnal gotowosci na przyjecie palety
    
    Timer_stabilizacji   : TON;   // timer odliczajacy pelne zatrzymanie przed obrotem
    Krok                 : INT;   // krok sekwencji: 0-wejscie, 1-obrot_w_tok, 2-wydanie, 3-powrot
    
    Rolki_stacji_naprzod : BOOL;  // silnik rolek obrotnicy - ruch w przod
    Silnik_obrotu_90     : BOOL;  // silnik obracajacy stacje do pozycji 90 stopni
    Silnik_powrotu_0     : BOOL;  // silnik wracajacy stacje do pozycji 0 stopni
END_VAR

CASE Krok OF
    0: // oczekiwanie na palete w pozycji bazowej 0 stopni
        Rolki_stacji_naprzod := NOT Paleta_na_stacji AND Krancowka_pozycja_0;
        
        IF Paleta_na_stacji AND Krancowka_pozycja_0 AND Timer_stabilizacji.Q THEN
            Krok := 1; // paleta zajela stacje i zatrzymala sie -> start obrotu
        END_IF;
        
    1: // obrot stacji o 90 stopni do przenosnika
        IF Krancowka_pozycja_90 THEN
            Krok := 2; // osiagnieto pozycje 90 stopni -> przejscie do wydania
        END_IF;
        
    2: // wydanie palety na kolejny odcinek linii
        IF NOT Paleta_na_stacji THEN
            Krok := 3; // paleta opuscila stacje -> mozna wracac
        END_IF;
        
    3: // powrot obrotnicy do pozycji bazowej 0 stopni
        IF Krancowka_pozycja_0 THEN
            Krok := 0; // Stacja wrocila na pozycje startowa -> gotowa na nowa palete
        END_IF;
END_CASE;

// timery - 1,5 sekundy na zgaszenie sie drgan i zatrzymaniu po wjechaniu na stacje
Timer_stabilizacji(IN := Paleta_na_stacji AND Krancowka_pozycja_0, PT := T#1500ms);

// wyjscia
Silnik_obrotu_90     := (Krok = 1);
Rolki_stacji_naprzod := (Krok = 0 AND NOT Paleta_na_stacji) OR (Krok = 2 AND Zgoda_na_wydanie);
Silnik_powrotu_0     := (Krok = 3);
