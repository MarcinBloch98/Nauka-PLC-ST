VAR
    Start_automatu       : BOOL;  // przycisk wlaczenia trybu automatycznego prasy
    Fotokomorka_zasypu   : BOOL;  // wykrycie odpadow w komorze zasypowej
    Czujnik_cisnienia    : BOOL;  // czujnik osiagniecia max nacisku prasowania (bela gotowa)
    Krancowka_powrotu    : BOOL;  // czujnik potwierdzajacy pelne cofniecie plyty prasujacej
    
    Timer_zasypu         : TON;   // timer filtrujacy stala obecnosc materialu przed startem prasy
    Krok                 : INT;   // krok sekwencji: 0-idle, 2-prasowanie, 3-powrot
    
    Ruch_prasowania      : BOOL;  // zawor wysuwu silownika - zgniatanie
    Ruch_powrotny        : BOOL;  // zawor wsuwu silownika - cofniecie plyty
    Licznik_bel          : CTU;   // licznik sprasowanych bel odpadu
END_VAR

// Sekwencja
CASE Krok OF
    0: // Oczekiwanie na zsyp komory
        IF Start_automatu AND Timer_zasypu.Q AND Krancowka_powrotu THEN
            Krok := 2; // Komora pelna, plyta u gory -> start prasowania
        END_IF;
        
    2: // Ruch plyty prasujacej w dol - zgniatanie odpadow
        IF Czujnik_cisnienia THEN
            Krok := 3; // Osiagnieto maksymalny zgniot -> przejscie do cofania
        END_IF;
        
    3: // Powrot plyty prasujacej do samej gory
        IF Krancowka_powrotu THEN
            Krok := 0; // Plyta wrocila bazowo - powrot do oczekiwania
        END_IF;
END_CASE;

// Opoznienie startu - material musi zaslonic fotokomorke przez 3 sekundy aby prasa nie ruszyla na pusto
Timer_zasypu(IN := Fotokomorka_zasypu, PT := T#3s);

// Kontrola wyjsc
Ruch_prasowania := (Krok = 2);
Ruch_powrotny   := (Krok = 3);

// Prowadzenie statystyki
// Licznik zwieksza wartosc na zboczu narastajacym po zwiekszeniu cisnienia
Licznik_bel(CU := Czujnik_cisnienia, R := NOT Start_automatu);
