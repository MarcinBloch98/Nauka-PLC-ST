VAR
    Wozek_na_pozycji     : BOOL;  // czujnik gdy wozek stoi idealnie przed stacja
    Paczkowany_na_wozku  : BOOL;  // sygnal z fotokomorki potwierzdajacy obecnosc paczki
    Zadanie_zrzutu       : BOOL;  // sygnal nadrzedny dozkazujacy rozladunek paczki
    Sygnal_odbioru_stacji: BOOL;  // sygnal gotowosci do przejecia paczki
    
    Timer_transportera   : TON;   // timer czasu pracy wozka
    Krok                 : INT;   // krok sekwencji
    
    Rygluj_wozek         : BOOL;  // wygiel stabilizujacy wozek
    Uruchom_pas_wozka    : BOOL;  // tasma zamontowana na wozku
END_VAR

CASE Krok OF
    0: // wozek w ruchu lub czeka na sygnal
        IF Wozek_na_pozycji AND Paczkowany_na_wozku AND Zadanie_zrzutu THEN
            Krok := 1; // dojechal do celu - rygiel pozycjonujacy
        END_IF;
        
    1: //stabilizacja wozka do odbioru paczki
        IF NOT Wozek_na_pozycji THEN
            Krok := 0; // stop sekwencji gdy wozek sie przesunie
        ELSIF Sygnal_odbioru_stacji THEN
            Krok := 2; // gdy stacja gotowwa --> rozpocznij transfer
        END_IF;
        
    2: // rozladunek
        IF NOT Paczkowany_na_wozku AND Timer_transportera.Q THEN
            Krok := 3; // paczka opuscila wozek
        ELSIF NOT Wozek_na_pozycji THEN
            Krok := 0; // gdy dochodzido bledu pozycji to odetnij naped
        END_IF;
        
    3: // zakonczenie cyklu i odryglowanie wozka
        IF NOT Rygluj_wozek THEN
            Krok := 0; // wozek moze jechac dalej
        END_IF;
END_CASE;

// timery - pas pracuje 2 sekundy po braku sygnali z fotokomorki
Timer_transportera(IN := (Krok = 2) AND NOT Paczkowany_na_wozku, PT := T#2s);

// sterowaie wyjsciami
Rygluj_wozek      := (Krok = 1) OR (Krok = 2);
Uruchom_pas_wozka := (Krok = 2) AND Wozek_na_pozycji AND Sygnal_odbioru_stacji;
