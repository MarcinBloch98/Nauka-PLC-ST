VAR
    Czujnik_obecnosci : BOOL;   // Wykrywa paczke na linii
    Czujnik_wagi : REAL;        // Waga paczki (0.0 - 10.0 kg)
    Silnik_tasmy : BOOL;        // Napęd głowny
    Spychacz_w_lewo : BOOL;     // Spycha lekkie paczki
    Spychacz_w_prawo : BOOL;    // Spycha ciezkie paczki
    
    Krok_ukladu : INT := 0;     // Stan ukladu
    Timer_Przejazd : TON;       // Timer odmierzajacy 2s dojazdu
END_VAR

// Wywołanie timera
Timer_przejazd(PT := T#2S);

// KROK 0: Oczekiwanie na paczkę
IF Krok_ukladu = 0 AND Czujnik_obecnosci THEN
    Silnik_tasmy := TRUE;
    Timer_przejazd.IN := TRUE; // Start odliczania
    Krok_ukladu := 1;
END_IF;

// KROK 1: Decyzja o sortowaniu (po minieciu 2 sekundach)
IF Krok_ukladu = 1 AND Timer_przejazd.Q THEN
    IF Czujnik_wagi < 5.0 THEN
        Spychacz_w_lewo := TRUE;
    ELSE
        Spychacz_w_prawo := TRUE;
    END_IF;
    Krok_ukladu := 2;
END_IF;

// KROK 2: Sprzątanie i powrót (paczka znika z czujnika)
IF Krok_ukladu = 2 AND NOT Czujnik_obecnosci THEN
    Silnik_tasmy := FALSE;
    Spychacz_w_lewo := FALSE;
    Spychacz_w_prawo := FALSE;
    Timer_przejazd.IN := FALSE; // Reset timera
    Krok_ukladu := 0;
END_IF;
