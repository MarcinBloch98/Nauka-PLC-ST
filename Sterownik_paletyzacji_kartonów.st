VAR
    Czujnik_kartonu      : BOOL;  // czujnik optyczny wykrywajacy kartony na koncu tasmy
    Paleta_obecna        : BOOL;  // czujnik obecnosci palety w strefie zaladunku
    Przycisk_reset       : BOOL;  // reset licznika po zabraniu pelnej palety
    
    Licznik_kartonow     : INT;   // aktualna liczba kartonow na aktualnej warstwie
    Krok                 : INT;   // krok sekwencji
    
    Tasma_doprowadzajaca : BOOL;  // silnik tasmy podajacej kartony
    Silownik_popychacza  : BOOL;  // pneumatyczny popychacz formujacy warstwe
    Sygnalizacja_pelna   : BOOL;  // lampka informacyjna dla operatora wozka widlowego
END_VAR

CASE Krok OF
    0: // oczekiwanie na podstawienie pustej palety przez obecnego operatora
        Licznik_kartonow := 0;
        IF Paleta_obecna THEN
            Krok := 1; // Paleta wykryta, uruchom linie podawania
        END_IF;
        
    1: // zbieranie kartonow aby uformowac pelna warstwe
        IF Licznik_kartonow >= 10 THEN
            Krok := 2; // Zebrano warstwe,  zatrzymaj tasme i zepchnij gotowa palete
        END_IF;
        
    2: // zepchniecie calej warstwy na palete - po zepchnieciu powrot silownika i wykrycie nowej palety
        IF Licznik_kartonow >= 40 THEN
            Krok := 3; // paleta zapelniona
        ELSE
            Krok := 1; // Wroc do zbierania kolejnej warstwy
        END_IF;
        
    3: // Strefa zapelniona - oczekiwanie na odbior palety i reset ukladu
        IF Przycisk_reset AND NOT Paleta_obecna THEN
            Krok := 0; // Paleta zabrana, powrot do 0 kroku
        END_IF;
END_CASE;

// sterowanie wyjsciami
Tasma_doprowadzajaca := (Krok = 1) AND Paleta_obecna;
Silownik_popychacza  := (Krok = 2);
Sygnalizacja_pelna   := (Krok = 3);
