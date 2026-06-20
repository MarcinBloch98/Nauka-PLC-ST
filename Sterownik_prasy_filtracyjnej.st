VAR
    Start_cyklu          : BOOL;  // przycisk NO uruchamiajadcyautomatyczne odwadnianie
    Cisnienie_szlamu     : REAL;  // czujnik analogowy odczytujacy cisnienie tloczenia
    Prasa_zamknieta      : BOOL;  // czujnik krancowy pelnego docisku plyt filtrujacych
    
    Timer_odwadniania    : TON;   // timer liczacy czas fazy tloczenia osadu
    Krok                 : INT;   // krok sekwencji
    
    Zgoda_pompy          : BOOL;  // pamiec zezwolenia na prace pompy zasilajacej prasowe komory
    Zawor_zasilajacy     : BOOL;  // zawor podawania osadu do prasy
    Silownik_docisku     : BOOL;  // agregat dociskajacy plyty prasy
END_VAR

// Jesli cisnienie przekroczy 12 bar to odcina pompe dla ochrony plyt
IF Cisnienie_szlamu > 12.0 THEN
    Zgoda_pompy := FALSE;
ELSE
    Zgoda_pompy := TRUE;
END_IF;

CASE Krok OF
    0: // oczekiwanie na start
        IF Start_cyklu THEN
            Krok := 1; // Rozpocznij mechaniczne zamykanie komor prasy
        END_IF;
        
    1: // docisk plyt do stacji roboczej
        IF Prasa_zamknieta THEN
            Krok := 2; // gdy plyty sa zabezpieczone i szaczelne to rozpoczecie tloczenia szlamu
        END_IF;
        
    2: // filtracja i wciskanie wody pod cisnieniem
        IF Timer_odwadniania.Q OR NOT Zgoda_pompy THEN
            Krok := 3; // Czas filtration-loop minal lub cisnienie graniczne -> koniec fazy
        END_IF;
        
    3: // odpuszczenie silownika i przejscie do stanu gotowosci
        IF NOT Prasa_zamknieta THEN
            Krok := 0; // prasa jest otwarta a suchy osad zsypany
        END_IF;
END_CASE;

// timery - czas tloczenia i nawadniania trwa 60 sekund
Timer_odwadniania(IN := (Krok = 2) AND Zgoda_pompy, PT := T#60s);

// sterowanie wyjsciami
Silownik_docisku := (Krok = 1) OR (Krok = 2); // trzymanie cisnienia przez caly czas filtracji
Zawor_zasilajacy := (Krok = 2) AND Zgoda_pompy AND Prasa_zamknieta;
