VAR
    Start_procesu         : BOOL;  // przycisk startu cyklu mieszania
    Czujnik_pelny         : BOOL;  // czujnik wysokiego poziomu w zbiorniku (ciecz osiagnela limit)
    Czujnik_pusty         : BOOL;  // czujnik niskiego poziomu (zbiornik zostal oprozniony)
    
    Timer_mieszania       : TON;   // timer odliczajacy czas pracy mieszadla
    Etap_procesu          : INT;   // krok sekwencji: 0-stop, 1-dozowanie, 2-mieszanie, 3-spust
    
    Zawor_skladnik_A      : BOOL;  // cewka otwierajaca zawor pierwszy skladnika A
    Zawor_skladnik_B      : BOOL;  // cewka otwierajaca zawor pierwszy skladnika B
    Silnik_mieszadla      : BOOL;  // silnik mieszajacy skladniki
    Zawor_spustowy        : BOOL;  // zawor podajacy gotowy produkt
END_VAR

CASE Etap_procesu OF
    0: // oczekiwanie na uruchomienie programu
        IF Start_procesu AND Czujnik_pusty THEN
            Etap_procesu := 1; // przejscie do podania skladnikow
        END_IF;
        
    1: // podawanie skladnikow do zapelnienia zbiornika
        IF Czujnik_pelny THEN
            Etap_procesu := 2; // gdy zbiornnik jest pelen nastepuje mieszanie skladnikow
        END_IF;
        
    2: // miksowanie skladnikow przez okeslony czas
        IF Timer_mieszania.Q THEN
            Etap_procesu := 3; // gdy czas minal przejscie do odbioru produktu
        END_IF;
        
    3: // oproznienie zbiornika
        IF Czujnik_pusty THEN
            Etap_procesu := 0; // gdy zbiornik jest pusty powrot do oczekiwania
        END_IF;
END_CASE;

// kontrola czasu
Timer_mieszania(IN := (Etap_procesu = 2), PT := T#10s);

// sterowanie ukladem sekwencyjnym na podstawie kroku ukladu
Zawor_skladnik_A := (Etap_procesu = 1); // Zawór komponentu A otwarty w kroku 1
Zawor_skladnik_B := (Etap_procesu = 1); // Zawór komponentu B otwarty w kroku 1
Silnik_mieszadla := (Etap_procesu = 2); // Silnik mieszadła pracuje wyłącznie w kroku 2
Zawor_spustowy   := (Etap_procesu = 3); // Zawór spustowy otwarty w kroku 3
