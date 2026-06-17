VAR
    Sonda_tlenowa            : REAL;  // czujnik analogowy odczytujacy poziomu tlenu zakres 0-10
    Wymuszenie_czyszczenia   : BOOL;  // przycisk lub sygnal usuwania osadu
    Zgarniacz_krancowka      : BOOL;  // czujnik powrotu do pozycji wyjsciowej zgarniacza
    
    Timer_czyszczenia        : TON;   // czas pelnego cyklu
    Krok_czyszczenia         : INT;   // krok sekwencji
    
    Dmuchawa_napowietrzania  : BOOL;  // dmuchawa podajaca powietrze na komore
    Naped_zgarniacza         : BOOL;  // silnik mechanizmu zgarniania
    Pompa_osadu              : BOOL;  // pompa usuwajaca osad
END_VAR

// prawidlowy poziom tlenu 2-3 mg/l
IF Sonda_tlenowa < 2.0 THEN
    Dmuchawa_napowietrzania := TRUE;  // Zbyt malo tlenu -> wlacz dmuchawe
ELSIF Sonda_tlenowa > 3.0 THEN
    Dmuchawa_napowietrzania := FALSE; // Poziom osiagniety -> wylacz dmuchawe (oszczednosc energii)
END_IF;

// logika czyszczenia dna
CASE Krok_czyszczenia OF
    0: // uklad oczekuje na sygnal oczyszczania
        IF Wymuszenie_czyszczenia AND Zgarniacz_krancowka THEN
            Krok_czyszczenia := 1;
        END_IF;
        
    1: // praca zgarniacza
        IF Timer_czyszczenia.Q THEN
            Krok_czyszczenia := 2; // zgarniacz dojechal do konca -> uruchomic pompe
        END_IF;
        
    2: // odpompowanie osadu
        IF NOT Wymuszenie_czyszczenia THEN
            Krok_czyszczenia := 3; // cykl zakonczony poprawnie -> powrot mechanizmu
        END_IF;
        
    3: // powrot zgarniacza do pozycji poczatkowej
        IF Zgarniacz_krancowka THEN
            Krok_czyszczenia := 0; // Ckoniec cyklu - oczekiwanie na nowy cykl
        END_IF;
END_CASE;

// timery - czas jazdy zgarniacza wynosi 45 sekund
Timer_czyszczenia(IN := (Krok_czyszczenia = 1), PT := T#45s);

// sterowanie wyjsciami
Naped_zgarniacza := (Krok_czyszczenia = 1) OR (Krok_czyszczenia = 3);
Pompa_osadu      := (Krok_czyszczenia = 2);
