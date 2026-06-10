VAR
    Zadanie_rozladunku   : BOOL;  // sygnal zadania startusekwencji programu
    Czujnik_przeplywu    : BOOL;  // czujnik lub fotokomorka wykrywajacy fizyczny zrzut materialu
    Krancowka_zasuwy     : BOOL;  // potwierdzenie pelnego otwarcia zasuwy pod silosem
    
    Timer_aeracji        : TON;   // czas trwania strzalu powietrza
    Timer_wibracji       : TON;   // czas pracy wibratora
    Krok                 : INT;   // krok sekwencji
    
    Zasuwa_nozowa        : BOOL;  // otwarcie zasuwy odcinajacej silos
    Zawor_aeracji        : BOOL;  // cewka elektrozaworu wtrysku powietrza
    Wibrator_stozka      : BOOL;  // stycznik silnika wibracyjnego na plaszczu
END_VAR

CASE Krok OF
    0: // stan czuwania - oczekiwanie na rozpoczecie sekwencji
        IF Zadanie_rozladunku THEN
            Krok := 1; // rozpoczecie rozladunku
        END_IF;
        
    1: // standardowy zrzut po otwarciu zrzutu
        IF NOT Zadanie_rozladunku THEN
            Krok := 0; // koniec rozladunku
        ELSIF Zadanie_rozladunku AND NOT Czujnik_przeplywu AND Krancowka_zasuwy THEN
            Krok := 2; // otawrta zasuwa - wykryto zwis
        END_IF;
        
    2: // spulchnianie materialu
        IF NOT Zadanie_rozladunku THEN
            Krok := 0;
        ELSIF Timer_aeracji.Q THEN
            IF Czujnik_przeplywu THEN
                Krok := 1; // powrot do standardowego zrzutu
            ELSE
                Krok := 3; // przejscie do wibracji
            END_IF;
        END_IF;
        
    3: // aktwyacja wibratora
        IF NOT Zadanie_rozladunku OR Timer_wibracji.Q OR Czujnik_przeplywu THEN
            Krok := 1; // powrot do oczekiwanie na rozpoczecie nowej sekwencji
        END_IF;
END_CASE;

// timer

Timer_aeracji(IN := (Krok = 2), PT := T#4s); // strzal powietrz trwa 4 sekundy

// Praca wibratora ograniczona do 3 sekund, aby chronic strukture mechaniczna i spawy silosu
Timer_wibracji(IN := (Krok = 3), PT := T#3s);

// sterowanie wyjsciami
Zasuwa_nozowa   := (Krok = 1) OR (Krok = 2) OR (Krok = 3);
Zawor_aeracji   := (Krok = 2);
Wibrator_stozka := (Krok = 3);
