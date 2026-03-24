// 1. Obsługa Stopu Awaryjnego (Reset wszystkiego)
IF NOT Stop_awaryjny THEN
    Krok_ukladu := 0;
    Zawor_A := FALSE;
    Zawor_B := FALSE;
    Mieszadlo := FALSE;
    Zawor_spustowy := FALSE;
END_IF;

// 2. Główna maszyna stanów
CASE Krok_ukladu OF
    0: // Oczekiwanie
        IF Start THEN
            Krok_ukladu := 10;
        END_IF;
        
    10: // Dolewanie A
        Zawor_A := TRUE;
        IF Czujnik_poziomu >= 40.0 THEN
            Zawor_A := FALSE; // Wyłączamy, gdy pełne!
            Krok_ukladu := 20;
        END_IF;

    20: // Dolewanie B
        Zawor_B := TRUE;
        IF Czujnik_poziomu >= 80.0 THEN // Używaj tej samej nazwy zmiennej poziomu
            Zawor_B := FALSE;
            Krok_ukladu := 30;
        END_IF;

    30: // Mieszanie
        Mieszadlo := TRUE;
        // Składnia timera: Czas_mieszania(IN := TRUE, PT := T#10S);
        IF Czas_mieszania.Q THEN
            Mieszadlo := FALSE;
            Krok_ukladu := 40;
        END_IF;

    40: // Opróżnianie
        Zawor_spustowy := TRUE;
        IF Czujnik_poziomu <= 2.0 THEN
            Zawor_spustowy := FALSE;
            Krok_ukladu := 0; // Koniec cyklu, wróć do początku
        END_IF;
END_CASE;
