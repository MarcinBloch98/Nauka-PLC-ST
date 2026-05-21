VAR
    Zasilanie_glowne_OK : BOOL;       // status zasilania sieciowego (TRUE = sieciowe OK)
    Czujnik_zmierzchu   : BOOL;       // TRUE = noc / ciemność w strefie
    Wymuszenie_reczne   : BOOL;       // przycisk testowy na elewacji szafy (Styk NO)
    Stabilizacja_sieci  : TON;        // timer opóźniający powrót do normalnego zasilania
    Oswietlenie_ewakuacja : BOOL;     // wyjście lamp awaryjnych
END_VAR

// 1. liczymy czas stabilizacji sieci (np. prąd wraca, ale czekamy 5 sekund czy napięcie jest stabilne)
Stabilizacja_sieci(IN := Zasilanie_glowne_OK, PT := T#5s);

// 2. logika załączenia oświetlenia awaryjnego:
// swiatła świecą jeśli sieć nie jest jeszcze stabilna lub gdy operator wymusi test po zmroku
Oswietlenie_ewakuacja := NOT Stabilizacja_sieci.Q OR (Czujnik_zmierzchu AND Wymuszenie_reczne); 

