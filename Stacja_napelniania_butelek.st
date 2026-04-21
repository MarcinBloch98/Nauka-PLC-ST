VAR
    fotokomorka : BOOL;   // wykrywa butelke
    waga : INT;           // odczyt wagi
    transporter : BOOL;    // silnik linii
    zawor : BOOL;         // zawor cieczy
    alarm : BOOL;         // alarm
    krok : INT := 0;      // krok ukladu
    czas_stabilizacji : TON; // deklaracja timera
END_VAR

VAR_CONSTANT
    wartosc_docelowa : INT := 500;
    tolerancja : INT := 5;
END_VAR

// wywołanie timera
czas_stabilizacji(IN := (krok = 3), PT := T#2S);

CASE krok OF
    0:  // oczekiwanie
alarm := FALSE;        
transporter := TRUE;
        zawor := FALSE;
        IF fotokomorka THEN
            krok := 1;
        END_IF;

    1:  // Zatrzymanie i start nalewania
        transporter := FALSE;
        zawor := TRUE;
        krok := 2; // od razu do monitorowania wagi

    2:  // nalewanie cieczy
        IF waga >= wartosc_docelowa THEN
            zawor := FALSE;
            krok := 3;
        END_IF;

    3:  // stabilizacja
        IF czas_stabilizacji.Q THEN
            krok := 4;
        END_IF;

    4:  // Kontrola jakosci
        IF waga >= (wartosc_docelowa - tolerancja) AND 
           waga <= (wartosc_docelowa + tolerancja) THEN
            krok := 0; // waga ok - następna butelka
        ELSE
            alarm := TRUE; // blad - stop
        END_IF;
END_CASE;
