VAR
    Stoper_Cyklu     : TON;         // timer mirzacy czas trwania cyklu
    Czas_Ostatni     : TIME;        // ostatni zapisany wynik
    Limit_Czasu      : TIME := T#10S; // limit do uruchomienia alarmu
    Alarm_Wydajnosci : BOOL;
END_VAR

// 1. Logika stopera - działa gdy prasa NIE JEST w stanie OCZEKIWANIE ani ALARM
// mierzenie czasu od startu ruchu w dół do powrotu na górę
Stoper_Cyklu(IN := (stanAktualny <> OCZEKIWANIE AND stanAktualny <> ALARM), PT := T#60S);

// zbocze gdy maszyna wrocila do stanu poczatkowego
IF stanAktualny = OCZEKIWANIE AND Stoper_Cyklu.ET > T#0S THEN
    Czas_Ostatni := Stoper_Cyklu.ET; // aktualnie liczony czas timera ET
END_IF;

// detekcja czy maszyna nie pracuje za wolno
Alarm_Wydajnosci := Czas_Ostatni > Limit_Czasu;
