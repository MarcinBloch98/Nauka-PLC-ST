VAR
    Fotokomorka_pomiaru   : BOOL;  // czujnik optyczny PNP wykrywajacy paczke 
    Tasma_praca           : BOOL;  // potwierdzenie ze tasmociag sie porusza
    
    Timer_gabarytu        : TON;   // timer mierzacy czas przykrycia fotokomorki
    Impuls_spychacza      : TOF;   // timer generujacy odpowiedni czas pracy silownika spychajacego
    
    Silownik_spychacza    : BOOL;  // wyjscie: sterowanie elektrozaworem siłownika spychajacego
    Licznik_gabarytow     : CTU;   // licznik zliczajacy odrzucone duze paczki
END_VAR

// Mierzenie czasu przejscia paczki
// Timer zaczyna odliczac czas, gdy paczka zasloni czujnik, pod warunkiem ze tasma jedzie. Gdy paczka zasloni czujnik na dluzej niz 1.5 sekundy to jest za duzy gabaryt
Timer_gabarytu(IN := Fotokomorka_pomiaru AND Tasma_praca, PT := T#1s500ms);

// Sterowanie silownikiem
// Gdy timer wykryje gabaryt generujemy impuls trwajacy 1 sekunde(wysuniecie silownika na boczny tor)
Impuls_spychacza(IN := Timer_gabarytu.Q, PT := T#1s);
Silownik_spychacza := Impuls_spychacza.Q;

// Statystyka
// Licznik zwieksza wartosc po kazdym wykrytym i odrzuconej paczce
Licznik_gabarytow(CU := Timer_gabarytu.Q, R := NOT Tasma_praca);
