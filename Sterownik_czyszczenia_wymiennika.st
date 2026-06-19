VAR
    Temperatura_wlot     : REAL;  // temperatura spalin przed wymiennikiem
    Temperatura_wylot    : REAL;  // temperatura spalin za wymiennikiem
    Zgoda_na_przedmuch   : BOOL;  // cisnienie powietrza w zbiorniku jest prawidlowe
    
    Timer_sekcji         : TON;   // czas otwarcia zaworu danego obszaru podczas czyszczenia
    Krok                 : INT;   // krok sekwencji
    
    Sprawnosc_niska      : BOOL;  // zmienna informujaca o uruchomieniu cyklu
    Zawor_sekcji_1       : BOOL;  // zawor elektro-pneumatyczny sekcji pierwszej
    Zawor_sekcji_2       : BOOL;  // zawor elektro-pneumatyczny sekcji drugiej
END_VAR

// gdy roznica temperatur spadnie ponizej 15 stopni to wymiennik jest zabrudzony
IF (Temperatura_wlot - Temperatura_wylot) < 15.0 THEN
    Sprawnosc_niska := TRUE;
ELSE
    Sprawnosc_niska := FALSE;
END_IF;

// logika czyszczenia obu sekcji
CASE Krok OF
    0: // badanie sprawnosci sekcji i oczekiwanie na odpowiednie cisnienie powietrza
        IF Sprawnosc_niska AND Zgoda_na_przedmuch THEN
            Krok := 1; // start cisnienia pierwszej sekcji
        END_IF;
        
    1: // przedmuchanie dla pierwszej sekcji
        IF Timer_sekcji.Q THEN
            Krok := 2; // po uplywie czasu przejdz dop drugiej sekcji
        END_IF;
        
    2: // przedmuchanie drugiej sekcji
        IF Timer_sekcji.Q THEN
            Krok := 3; // Koniec czyszczenia obu sekcji
        END_IF;
        
    3: // zrestartowanie sekwencji
        Krok := 0;
END_CASE;

// timery - kazda sekcja jest przedmuchiwana przez 8 sekund
Timer_sekcji(IN := (Krok = 1) OR (Krok = 2), PT := T#8s);

// wyjscia
Zawor_sekcji_1 := (Krok = 1) AND Zgoda_na_przedmuch;
Zawor_sekcji_2 := (Krok = 2) AND Zgoda_na_przedmuch;
