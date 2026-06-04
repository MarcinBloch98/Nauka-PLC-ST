VAR
    Start_linii          : BOOL;  // przycisk NO uruchamiajacy cyklu linii
    Czujnik_pozycji      : BOOL;  // fotokomorka wykrywajaca opakowanie w gniezdzie dozującym
    Krancowka_indeksu    : BOOL;  // czujnik potwierdzajacy pelny obrot karuzeli o jeden krok
    
    Timer_dozowania      : TON;   // timer odliczajacy czas otwarcia zaworu do nalewania
    Krok                 : INT;   // krok sekwencji
    
    Naped_karuzeli       : BOOL;  // silnik obracajacy tarcze
    Zawor_dozujacy       : BOOL;  // elektrozawor nalewajacy
END_VAR

CASE Krok OF
    0: // gotowosc linii - oczekiwanie na start linii
        IF Start_linii THEN
            Krok := 1; // uruchomienie obracania karuzeli
        END_IF;
        
    1: // obrot karuzeli poszukujac wolnego gniazda
        IF Czujnik_pozycji THEN
            Krok := 2; // Wykryto opakowanie na stanowisku -> zatrzymaj i dozuj
        ELSIF NOT Start_linii THEN
            Krok := 0; // wylaczenie linii
        END_IF;
        
    2: // nalewanie produktu do opakowania
        IF Timer_dozowania.Q THEN
            Krok := 3; // koniec dozowania, przejdz do stabilizacji
        END_IF;
        
    3: // czsaowa zwloka po zamknieciu zaworu
        IF Krancowka_indeksu OR Start_linii THEN
            Krok := 1; // kontynuacja obracania i szukanie opakowania
        ELSE
            Krok := 0;
        END_IF;
END_CASE;

// timery
Timer_dozowania(IN := (Krok = 2), PT := T#3500ms);  // czas pelnego otwarcia zaworu dozujacego odmierzajacego dawke 

// sterowanie wyjsciami
Naped_karuzeli := (Krok = 1); // silnik kreci sie tylko w kroku 1
Zawor_dozujacy := (Krok = 2); // zawor otwiera sie tylko w kroku 2
