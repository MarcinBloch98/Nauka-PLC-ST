VAR
    Prad_silnika_glownego : REAL;  // czujnik analogowy odczytujacy prad silnika nozy sprawdzajacy jak ciezko ma silnik (czy noz nie utknal i nie zaklinowal komory)
    Czujnik_temperatury  : REAL;  // czujnik analogowy pomiaru temperatury lozysk - wysoka temperatura = potencjalnie tepe ostrza lub brak smaru
    Przycisk_stop_awaria : BOOL;  // grzyb bezpieczenstwa
    
    Timer_cofania        : TON;   // timer czasu trwania cofania podajnika
    Krok                 : INT;   // krok sekwencji
    Przeciazenie_nozy    : BOOL;  // bit pamieci zablokowania ostrzy
END_VAR

// powyzej 110 A = zakleszczenie materialu
IF Prad_silnika_glownego > 110.0 THEN
    Przeciazenie_nozy := TRUE;
ELSE
    Przeciazenie_nozy := FALSE;
END_IF;

CASE Krok OF
    0: // maszyna zatrzymana - monitorowanie braku awarii i gotowosci do startu
        IF NOT Przycisk_stop_awaria AND Czujnik_temperatury < 85.0 THEN
            Krok := 1;
        END_IF;
        
    1: // praca nozy tnących - rozpedzanie kola zamachowego
        Krok := 2; // Po rozruchu przejdz do normalnego podawania
        
    2: // standardowa praca - podajnik tloczy plastik do komory nozowej
        IF Przycisk_stop_awaria THEN
            Krok := 0; // natychmiastowe zatrzymanie systemu
        ELSIF Przeciazenie_nozy THEN
            Krok := 3; // blokada ostrzy - przejdz do procedury powrotu nozy
        END_IF;
        
    3: // bezpieczne cofanie podajnika (procedura oczyszczania)
        IF Timer_cofania.Q THEN
            Krok := 2; // powrot do normalnego zasypu po oczyszczeniu
        ELSIF Przycisk_stop_awaria THEN
            Krok := 0;
        END_IF;
END_CASE;

// timer
Timer_cofania(IN := (Krok = 3), PT := T#5s);
