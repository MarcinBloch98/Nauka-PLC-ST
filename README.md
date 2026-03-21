# Portfolio Automatyka – Projekty PLC (Structured Text)

Zbiór algorytmów i rozwiązań przemysłowych napisanych w języku ST (IEC 61131-3). Repozytorium prezentuje dobre praktyki programistyczne, dbałość o bezpieczeństwo oraz diagnostykę układów sterowania.

---

### 1. Obsługa Grzyba – Emergency_Stop.st
System bezpieczeństwa dla maszyny
* **Logika NC:** Reakcja na zanik napięcia (bezpieczeństwo w przypadku uszkodzenia przewodu)
* **Reset:** Blokada restartu – wymagane świadome potwierdzenie operatora po ustąpieniu awarii

### 2. Maszyna Stanu – Sterowanie_sekwencyjne_tasmociagu.st
Sekwencja pracy z użyciem instrukcji `CASE`
* **Skalowalność:** Numeracja stanów co 10 pozwala na łatwe dodawanie kroków pośrednich
* **Stany:** Obsługa trybów IDLE, RUNNING oraz ERROR

### 3. Diagnostyka Silnika – Motor_Control_Diagnostic.st
Sterowanie napędem z monitoringiem odpowiedzi
* **Feedback:** Czasowa weryfikacja odpowiedzi ze stycznika (2s)
* **Zabezpieczenie:** Integracja z wyłącznikiem silnikowym (termikiem)
* **Statusy HMI:** Przekazywanie komunikatów tekstowych o błędach

### 4. Skalowanie Analogowe – Skalowanie_Analogowe.st
Przeliczanie danych wejściowych (INT) na wartości fizyczne (REAL)
* **Diagnostyka:** Detekcja błędów pomiarowych

### 5. Alarmy z Histerezą – Obsluga_alarmow_analogowych.st
Monitorowanie progów bezpieczeństwa dla wartości analogowych
* **Histereza:** Zapobieganie fluktuacjom sygnału i fałszywym alarmom
* **Poziomy:** Rozdzielenie ostrzeżenia od alarmu krytycznego

### 6. Licznik Produkcji – Production_counter.st
Zliczanie detali z użyciem detekcji zbocza narastającego `R_TRIG`

### 7. Monitorowanie ruchu – Kontrola_ruchu_tasmy.st
Nadzór faktycznej pracy silnika z wykorzystaniem czujnika obrotów
* **Oczekiwanie na rozruch:** Czas ochronny (3s) pozwalający maszynie na wejście w obroty
* **Nadzór czasu:** Kontrola czasu między impulsami (800ms)
* **Blokada ruchu:** Automatyczne zatrzymanie napędu w przypadku wykrycia blokady mechanicznej

### 8. Licznik czasu pracy – Licznik_Godzin_Pracy.st
System monitorowania zużycia eksploatacyjnego napędu
* **Pomiar czasu:** Zliczanie sekund pracy tylko podczas aktywnego sygnału silnika
* **Diagnostyka HMI:** Automatyczne przeliczanie jednostek na motogodziny
* **Harmonogram serwisu:** System powiadomień o przeglądzie technicznym po przekroczeniu 500h

### 9. Rozruch Kaskadowy – Sekwencyjne_wlaczanie_silnikow.st
Sekwencyjnye uruchamianiem napędów
* **Pomiar zwłoki:** Użycie timerów TON do odliczania przerw (5s) między startem sekcji
* **Logika powiązań:** Zabezpieczenie przed startem dalszych silników w przypadku awarii poprzednika
* **Bezpieczeństwo:** Użycie podtrzymania programowego z priorytetem dla sygnału STOP (NC)

### 10. Regulacja Poziomu – Regulacja_poziomu_w_zbiorniku_z_histereza.st
Algorytm napełniania zbiornika w zakresie 20-80%
* **Histereza:** Blokada przed zbyt częstym uruchomieniom i wyłączeniom pompy
* **Ochrona sprzętu:** Likwidacja zjawiska "szarpania" stycznikiem przy niewielkich wahaniach poziomu cieczy
* **Diagnostyka:** Wykrycie wartości poza zakresem czujnika (-5% do 105%) i automatyczne przejście w stan zabezpieczający układ
