VAR
    Impuls_bebna_napedu   : BOOL;  // czujnik obrotow napedu
    Impuls_rolki_zwrotnej : BOOL;  // czujnik obrotow rolki na koncu tasmy
    Silnik_tasmy_On       : BOOL;  // sygnal ze silnik w ogole powinien pracowac
    
    Licznik_napedu        : CTU;   // zliczanie impulsow z napedu
    Licznik_zwrotny       : CTU;   // zliczanie impulsow
    Timer_sprawdzania     : TON;   // weryfikacja poslizgu co 5 sekund
    
    Blokada_awaryjna      : BOOL;  // wykrycie poslizgu
END_VAR

// Zliczanie impulsów w pracy
Licznik_napedu(CU := Impuls_bebna_napedu, R := Timer_sprawdzania.Q OR NOT Silnik_tasmy_On);  // licznik zlicza zbocza narastajace z czujnika
Licznik_zwrotny(CU := Impuls_rolki_zwrotnej, R := Timer_sprawdzania.Q OR NOT Silnik_tasmy_On);  // licznik zwrotny zlicza jego obroty

// sprawdzanie roznicy co 5 sekund
Timer_sprawdzania(IN := Silnik_tasmy_On, PT := T#5s);  // okno pomiarowe

// bezpieczenstwo
IF Timer_sprawdzania.Q THEN  // sprawdza poslizg gdy minelo 5 sekund
    IF (Licznik_napedu.CV - Licznik_zwrotny.CV) >= 3 THEN  // sprawdza czy roznica obu licznikow wynosi wiecej niz 3 
        Blokada_awaryjna := TRUE;  // jesli tasma ucieka lub zwalnia zalacz trwaly alarm
    END_IF;
END_IF;
