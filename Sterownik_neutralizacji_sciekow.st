VAR
    Uruchom_proces       : BOOL;  // przycisk NO startu cyklu neutralizacji
    Pomiar_pH            : REAL;  // analogowy odczyt wartosci pH (0.0 - 14.0)
    Zbiornik_pelny       : BOOL;  // czujnik poziomu max potwierdzajacy gotowosc porcji
    
    Timer_dozowania      : TON;   // timer limitujacy czas pojedynczego wtrysku chemii
    Krok                 : INT;   // krok
    
    Pompa_kwasu          : BOOL;  // pompa dozujaca korektor pH- (kwas)
    Pompa_zasady         : BOOL;  // pompa dozujaca korektor pH+ (zasada)
    Silnik_mieszadla     : BOOL;  // silnik mieszadla zbiornika reakcyjnego
    Zezwolenie_zrzutu    : BOOL;  // sygnal gotowosci do oproznienia zbiornika
END_VAR

CASE Krok OF
    0: // oczekiwanie na pelny zbiornik i sygnal startu
        IF Uruchom_proces AND Zbiornik_pelny THEN
            Krok := 1;
        END_IF;
        
    1: // analiza pH cieczy
        IF Pomiar_pH > 8.5 THEN
            Krok := 2; // odczyn zbyt zasadowy -> wymagany kwas
        ELSIF Pomiar_pH < 6.5 THEN
            Krok := 3; // odczyn zbyt kwasny -> wymagana zasada
        ELSIF Pomiar_pH >= 6.5 AND Pomiar_pH <= 8.5 THEN
            Krok := 4; // pH w normie -> przejdz do koncowej homogenizacji i zrzutu
        END_IF;
        
    2: // dodawanie kwasu (pH w dol)
        IF Timer_dozowania.Q OR NOT Uruchom_proces THEN
            Krok := 1; // strzal chemii i wroc do analizy
        END_IF;
        
    3: // Dozowanie zasady (korekta pH w gore)
        IF Timer_dozowania.Q OR NOT Uruchom_proces THEN
            Krok := 1; // po strzal chemii wroc do analizy i mieszania
        END_IF;
        
    4: // ostatnie mieszanie i wystawienie na spust sciekow
        IF NOT Zbiornik_pelny OR NOT Uruchom_proces THEN
            Krok := 0; // zbiornik oprozniony -> koniec cyklu
        END_IF;
END_CASE;

// timery
// impuls dodawania chemii trwa max 3 sekundy aby uniknac przebodzcowania odczynu cieczy w zbiorniku
Timer_dozowania(IN := (Krok = 2) OR (Krok = 3), PT := T#3s);

// mieszadlo pracuje podczas trwania calego procesu korekty pH w zbiorniku
Silnik_mieszadla := (Krok > 0);

// sterowanie wyjsciami
Pompa_kwasu       := (Krok = 2) AND Uruchom_proces;
Pompa_zasady      := (Krok = 3) AND Uruchom_proces;
Zezwolenie_zrzutu := (Krok = 4) AND Zbiornik_pelny;
