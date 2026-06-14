VAR
    Start_napelniania    : BOOL;  // przycisk monostabilny NO stratujacy napelnianie
    Waga_prog_90         : BOOL;  // czujnik PNP osiagniecia 90 procent objetosci na wadze
    Waga_prog_100        : BOOL;  // czujnik PNP maksymalnej objetosci na wadze
    Worek_zalozony       : BOOL;  // czujnik bezpieczenstwa zalozonego worka
    
    Timer_odpylania      : TON;   // czas pracy ojazdu worka po dozowaniu
    Krok                 : INT;   // krok sekwencji
    
    Zawor_gruby          : BOOL;  // glowny zawor duzego przeplywu - szybki zsyp
    Zawor_dokladny       : BOOL;  // zawor dociagajacy wage
    Odciag_pylu          : BOOL;  // wentylator odpylania stanowiska zsypowego
END_VAR

CASE Krok OF
    0: // oczekiwanie na zawieszenie worka i wystartowanie ukladu
        IF Start_napelniania AND Worek_zalozony THEN
            Krok := 1; // rozpoczecie szybkiego zsypu
        END_IF;
        
    1: // dozowanie dla maksymalnej wydajnosci
        IF NOT Worek_zalozony THEN
            Krok := 0; // awaryjne przerwanie cyklu przy zerwanym worku z uchwytu
        ELSIF Waga_prog_90 THEN
            Krok := 2; // osiagnieto 90% masy -> powoli dosypuj do 100 procent objetosci
        END_IF;
        
    2: // dozowanie dokladne - zamkniety zawor glowny, sypie tylko zawor precyzyjny
        IF NOT Worek_zalozony THEN
            Krok := 0;
        ELSIF Waga_prog_100 THEN
            Krok := 3; // osiagnieto wage docelowa -> przejdz do odpylania
        END_IF;
        
    3: // odpylanie strefy zasypu przed odczepieniem kontenera
        IF Timer_odpylania.Q OR NOT Worek_zalozony THEN
            Krok := 0; // zakonczono cykl -> powrot do stanu gotowosci
        END_IF;
END_CASE;

// timery
// Odciag pracuje jeszcze przez 4 sekundy po zamknieciu zaworow, aby usunac zawieszony pyl
Timer_odpylania(IN := (Krok = 3), PT := T#4s);

// wyjscia
Zawor_gruby    := (Krok = 1) AND Worek_zalozony;
Zawor_dokladny := ((Krok = 1) OR (Krok = 2)) AND Worek_zalozony;
Odciag_pylu    := (Krok = 1) OR (Krok = 2) OR (Krok = 3); // prezz cala prace odciaganie pylu
