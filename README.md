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

### 11. Automatyczny Cykl Nawrotny – Automatyczny_cykl_nawrotny.st
Autoamtyczne sterowanie zmianą kierunku pracy napędu (Lewo/Prawo)
* **Logika sekwencyjna:** Automatyczne przełączanie kierunków po upływie czasu pracy (5s)
* **Bezpieczeństwo (Interlock):** Pauza (3s) przed każdą zmianą kierunku
* **Pamięć stanu:** Wykorzystanie flagi do zapamiętywania fazy cyklu i przejścia w kolejny krok
* **Priorytet Stop:** Natychmiastowe zatrzymanie automatu po naciśnięciu przycisku STOP (NC)

### 12. Automatyczny Mieszalnik – Automatyczny_mieszalnik.st
Algorytm sterowania sekwencyjnego z przygotowaniem mieszanki dwóch składników.
* **Maszyna Stanów (CASE):** Wykorzystanie struktury `CASE...OF` do zarządzania etapami procesu
* **Obsługa Sygnałów Analogowych:** Dozowanie składników A (40%) i B (80%) na podstawie odczytu z analogowego czujnika poziomu (REAL)
* **Automatyzacja Czasowa:** Zastosowanie timera TON do odliczania 10 sekund cyklu mieszania
* **Logika Bezpieczeństwa:** Wdrożenie nadrzędnego sygnału Stop Awaryjny (E-Stop), który natychmiast przerywa sekwencję i resetuje układ do stanu bezpiecznego

### 13. Skalowanie Analogowe (PT100) – Skalowanie_analogowe_PT100.st
Program realizujący przeliczanie  danych z wejścia analogowego sterownika na °C
* **Konwersja:** Wykorzystanie funkcji `INT_TO_REAL` do obliczeń na liczbach zmiennoprzecinkowych
* **Matematyka Procesowa:** Wykorzystanie wzoru na liniowe skalowanie sygnału w zakresie -50.0 do 150.0°C
* **Diagnostyka:** Automatyczny alarm przekroczenia temperatury krytycznej (>100°C)

### 14. Kaskada Pomp z Autozamianą – Sterowanie_kaskadowe_pomp.st
Algorytm zarządzania pracą dwóch pomp w systemie przepompowni
* **Kaskada:** Automatyczne dołączanie drugiej pompy przy wysokim zapotrzebowaniu (>90%)
* **Equal Run Time:** Mechanizm zamiany pompy głównej przy każdym cyklu, co optymalizuje czas eksploatacji urządzeń
* **Ochrona:** System ochrony przed suchobiegiem i zbędnymi cyklami załączeń

### 15. System Sortowania Paczek – Sortownik_paczek.st
Logika sterowania linią transportową z automatyczną segregacją towaru na podstawie masy
* **Synchronizacja Czasowa:** Wykorzystanie timera TON do odliczania czasu dojazdu paczki do sekcji wykonawczej (opóźnienie transportowe).
* **Logika Decyzyjna:** Rozdzielanie paczek na "lekkie" i "ciężkie" przy użyciu instrukcji warunkowych i danych z wagowego czujnika analogowego

### 16. Nadzór Wentylacji z Pętlą Zwrotną – Kontrola_wentylatora.st
System sterowania wentylatorem z weryfikacją pracy na podstawie przepływu powietrza
* **Startup Bypass:** Timer TON (5s) do ignorowania stanu czujnika podczas rozruchu
* **Pętla Sprzężenia:** Ciągła weryfikacja czujnika przepływu względem stanu wyjścia
* **Zabezpieczenie termiczne:** Wyłączenie układu po przekroczeniu 80°C

* **Automatyzacja Cyklu:** Maszyna stanów kontrolująca pełny proces: od detekcji obecności, przez transport, aż po selekcję i powrót do stanu gotowości
