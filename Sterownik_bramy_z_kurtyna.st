VAR
    Krok : INT := 0; 
    Listwa_optyczna : BOOL;    // Bezpieczeństwo (0 = przeszkoda / przerwana wiązka)
    Silnik_gora : BOOL;   // stycznik podnoszacy brame
    Silnik_dol : BOOL;   // stycznik opuszczajacy brame
    Krancowka_gora : BOOL;  // czujnik wykrwyajacy brame w gornej krancowej pozycji
    Krancowka_dol : BOOL;  // czujnik krancowy wykrywajacy brame w dolnej krancowej pozycji
    Petla_indukcyjna : BOOL;   // petla indukcyjna wykrwyajaca wozek widlowy
    Kurtyna_wyjscie : BOOL;    // uklad sterujacy kurtyna
    
    Licznik_cykli : INT;       // licznik zliczajacy ilosc wykonanej pracy ukladu
    Timer_kurtyny : TOF;       // czas dzialania ukladu po zamknieciu
    Odjazd_wozka : TON;        // czas oczekiwania ukladu na przejazd wozka
END_VAR

// timery - kurtyna dziala gdy brama sie rusza lub nie jest calkowicie zamknieta
Timer_kurtyny(IN := (Krok > 0), PT := T#10S);  // dalsza praca ukladu po wykonaniu pelnego cyklu
Kurtyna_wyjscie := Timer_kurtyny.Q;  

// czas na przejazd wozka gdy brama jest w gorze
Odjazd_wozka(IN := (Krok = 2), PT := T#5S);

// maszyna stanow
CASE Krok OF
    0: // brama zamknięta
        Silnik_gora := FALSE;
        Silnik_dol := FALSE;
        
        IF Petla_indukcyjna THEN
            Licznik_cykli := Licznik_cykli + 1; // dodanie nowego cyklu pracy
            Krok := 1;
        END_IF;

    1: // otwieranie
        Silnik_gora := TRUE;
        
        IF Krancowka_gora THEN
            Silnik_gora := FALSE;
            Krok := 2;
        END_IF;

    2: // brama otwarta - oczekiwanie 5s aż wózek przejedzie
        IF Odjazd_wozka.Q THEN
            Krok := 3;
        END_IF;

    3: // zamykanie bramy
       // braca tylko gdy listwa optyczna nic nie wykryje
        IF NOT Listwa_optyczna THEN
            Silnik_dol := FALSE; // stop gdy listwa optyczna cos wykryje
            Krok := 1;  // gdy wykryje przeszkode brama w gore
        ELSE
            Silnik_dol := TRUE;
        END_IF;

        IF Krancowka_dol THEN
            Silnik_dol := FALSE;
            Krok := 0; // powrot do stanu poczatkowego - kurtyna i tak będzie działać przez TOF
        END_IF;
        
        // wykrycie wozka podczas zamykania - brama do gory
        IF Petla_indukcyjna THEN
            Silnik_dol := FALSE;
            Krok := 1;
        END_IF;
END_CASE;
