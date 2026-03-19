# Nauka PLC w Structured Text (ST)
Moje autorskie projekty i algorytmy pisane podczas nauki programowania sterowników w języku ST. Skupiam się na czystym kodzie i standardach przemysłowych

---

### 1. Obsługa Grzyba – Emergency_Stop.st
Logika bezpieczeństwa dla maszyny
* **Logika NC:** Reakcja na zanik napięcia (bezpieczeństwo w przypadku uszkodzenia przewodu)
* **Reset:** Blokada restartu – wymagane świadome potwierdzenie operatora po ustąpieniu awarii

### 2. Maszyna Stanu – Sterowanie_sekwencyjne_tasmociagu.st
Zarządzanie sekwencją pracy przez instrukcję `CASE`
* **Skalowalność:** Numeracja stanów co 10 (10, 20, 30...) pozwala na łatwe dodawanie kroków pośrednich
* **Stany:** Obsługa trybów IDLE, RUNNING oraz ERROR

### 3. Diagnostyka Silnika – Motor_Control_Diagnostic.st
Zaawansowane sterowanie napędem z kontrolą odpowiedzi
* **Feedback:** Czasowa weryfikacja odpowiedzi ze stycznika (2s)
* **Zabezpieczenie:** Integracja z wyłącznikiem silnikowym (termikiem)
* **Statusy HMI:** Przekazywanie jasnych komunikatów tekstowych o błędach

### 4. Skalowanie Analogowe – Skalowanie_Analogowe.st
Przeliczanie surowych danych wejściowych (INT) na wartości fizyczne (REAL)
* **Diagnostyka:** Detekcja błędów pomiarowych (np. wykrywanie przerwania pętli 4-20mA poza zakresem)

### 5. Alarmy z Histerezą – Obsluga_alarmow_analogowych.st
Monitorowanie progów bezpieczeństwa dla wartości analogowych
* **Histereza:** Zapobieganie fluktuacjom sygnału i fałszywym alarmom ("drganie styków")
* **Poziomy:** Rozdzielenie ostrzeżenia od alarmu krytycznego

### 6. Licznik Produkcji – Production_counter.st
Zliczanie detali z wykorzystaniem detekcji zbocza `R_TRIG`

### 7. Licznik godzin pracy.st – Kontrola_ruchu_tasmy.st
Nadzór fizycznej pracy silnika z wykorzystaniem czujnika obrotów.
* **Oczekiwanie na ruch silnika:** Czas ochronny (3s) pozwalający maszynie rozpędzić się
* **Nadzór czasu:** Kontrola czasu między impulsami ustawiona na 800ms
* **Blokada ruchu:** Automatyczne zatrzymanie napędu w przypadku wykrycia blokady mechanicznej

**8. Licznik czasu pracy – Licznik_Godzin_Pracy.st**
Monitorowanie zużycia napędu
**Pomiar czasu:** Zliczanie czasu pracy tylko w momencie faktycznego załączenia silnika
**Informowanie poprzez HMI:** Automatyczne pokazywanie jednostek na godziny (REAL) Poprzez wizualizacje
**Harmonogram serwisu:** System kontroli czasu potrzebnego do przegladu do przepracowanych 500h
