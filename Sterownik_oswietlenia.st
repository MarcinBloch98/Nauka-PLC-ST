VAR
    Zasilanie_glowne_OK : BOOL;       // status zasilania sieciowego (TRUE = jest napięcie)
    Czujnik_zmierzchu   : BOOL;       // TRUE = jest ciemno na zewnątrz
    Wymuszenie_reczne   : BOOL;       // przycisk testowy na szafie (Styk NO)
    
    Oswietlenie_ewakuacja : BOOL;    // wyjście na lampy awaryjne
END_VAR

// Logika: Włącz światła awaryjne, jeśli brakuje zasilania głównego
// LUB gdy jest ciemno i operator wciśnie przycisk testowy
Oswietlenie_Ewakuacja := NOT Zasilanie_Glowne_OK OR (Czujnik_Zmierzchu AND Wymuszenie_Reczne);
