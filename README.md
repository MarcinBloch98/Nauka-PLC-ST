# Nauka Programowania PLC w języku ST (IEC 61131-3)

Repozytorium zawiera zbiór moich programów i algorytmów tworzonych podczas nauki programowania sterowników PLC w języku tekstowym Structured Text (ST). Projekty realizowane są w oparciu o standardy przemysłowe

---

## 1. Sterowanie Napędem (Motor Control)
Podstawowy moduł sterowania silnikiem z podtrzymaniem programowym
* **Funkcjonalność:** Start/Stop silnika
* **Kluczowe rozwiązania:** Zastosowanie priorytetu wyłączenia (bezpieczniejsza logika sterowania)

---

## 2. Bezpieczeństwo: Emergency Stop (E-Stop)
Implementacja funkcji bezpieczeństwa chroniącej operatora i maszynę
* **Logika NC (Normally Closed):** Wykorzystanie standardu zapewniającego zadziałanie zabezpieczenia w przypadku przerwania obwodu (np. zerwanie przewodu)
* **Reset Interlock:** Zabezpieczenie przed samoczynnym rozruchem – wymagane świadome potwierdzenie przyciskiem Reset po odblokowaniu grzyba bezpieczeństwa
* **Zgodność:** Algorytm zgodny z wymogami normy IEC 61131-3

---

## 3. Licznik Produkcji (Production Counter)
Moduł monitorowania wydajności linii i zliczania gotowych detali
* **Detekcja zbocza (R_TRIG):** Autorska implementacja wykrywania zbocza narastającego, co gwarantuje precyzyjne zliczanie (jeden detal = jeden impuls)
* **Kontrola limitu:** Funkcja porównywania wartości aktualnej z zadaną (np. sygnał "Karton pełen")
* **Typy danych:** Praca na zmiennych całkowitych (INT) oraz flagach statusowych (BOOL)

---

## 4. Sterowanie sekwencyjne taśmociągiem (MAszyna stanu - State Machine)
Zaawansowany algorytm zarządzający logiką maszyny w oparciu o stany procesowe
* **Struktura CASE:** Podział na stany IDLE, RUNNING i EMERGENCY
* **Bezpieczeństwo:** Implementacja trybu awaryjnego (99) z blokadą ponownego rozruchu
* **Architektura:** Skalowalna numeracja stanów (co 10) umożliwiająca łatwą rozbudowę systemu

## 5. Sterownik Silnika z Diagnostyką (Feedback Monitoring)
Zaawansowany blok funkcyjny (FB) zarządzający pracą napędu z kontrolą czasu odpowiedzi.
* **Diagnostyka Feedback:** Wykorzystanie timera TON do weryfikacji sytnału potwierdzenia działania układu w czasie 2s.
* **Obsługa błędów zewnętrznych:** Integracja sygnału z wyzwalacza termicznego (ErrorIn) blokująca pracę urządzenia w celu ochrony przed przegrzaniem.
* **Gotowość HMI:** Implementacja stanu układu w postaci statusów tekstowych (STRING) przygotowanych pod wizualizację procesową.
