VAR
    Przycisk_Plus : BOOL;  // Przycisk zwiekszajacy predkosc
    Przycisk_Minus : BOOL;  // Predkosc zmniejszajacy predkosc
    Wartosc_Zadana : REAL; // Zmienna do przechowywania zmiennosci
    Step : REAL := 0.5;    // Wartosc zmiany predkosci
    
    R_Trig_Plus : R_TRIG;  // Wykrycie klikniecia Plus, zabezpieczenie przed przytrzymaniem przycisku
    R_Trig_Minus : R_TRIG; // Wykrycie klikniecia minus, zabezpieczenie przed przytrzymaniem przycisku
END_VAR

// Wykrywamy kliknięcia - zbocze
R_Trig_Plus(CLK := Przycisk_Plus);
R_Trig_Minus(CLK := Przycisk_Minus);

// Faktyczne zwiększanie
IF R_Trig_Plus.Q AND Wartosc_Zadana < 100.0 THEN
    Wartosc_Zadana := Wartosc_Zadana + Step;
END_IF;

// Faktyczne zmniejszanie
IF R_Trig_Minus.Q AND Wartosc_Zadana > 0.0 THEN
    Wartosc_Zadana := Wartosc_Zadana - Step;
END_IF;

// Zabezpieczenie przed praca w nimozliwych zakresach - ponizej 0, ponad 100 procent
Wartosc_Zadana := LIMIT(0.0, Wartosc_Zadana, 100.0);
