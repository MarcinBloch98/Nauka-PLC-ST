# Nauka PLC w Structured Text (ST)
Moje autorskie projekty i algorytmy pisane podczas nauki programowania sterowników w języku ST. Skupiam się na czystym kodzie i standardach, które faktycznie spotyka się na obiektach.

### 1. Obsługa Grzyba (Emergency_Stop.st)
Logika bezpieczeństwa dla maszyny.
* **Logika NC:** Program reaguje na zanik napięcia (np. zerwany kabel), co jest standardem w przemyśle.
* **Reset:** Dodałem blokadę, żeby maszyna nie ruszyła sama po odblokowaniu przycisku – operator musi świadomie kliknąć Reset.

### 2. Licznik detali na linii (Production_counter)
Zliczanie produktów przejeżdżających przez czujnik. Wykorzystałem wykrywanie zbocza (`R_TRIG`), żeby jeden detal nie był liczony kilka razy. Jest też porównanie z limitem – system daje sygnał, gdy np. karton jest pełny.

### 3. Maszyna Stanu (Sterowanie_sekwencyjne_tasmociagu.st)
Zarządzanie pracą maszyny przez instrukcję `CASE`. Podzieliłem to na stany (IDLE, RUNNING, ERROR). Użyłem numeracji co 10 (10, 20, 30...), żeby w razie czego łatwo było dodać tam dodatkowy krok bez zmieniania całego programu.

### 4. Silnik z kontrolą odpowiedzi (Motor_Control_Diagnostic.st)
Bardziej rozbudowany blok sterowania napędem.
* **Diagnostyka:** Program czeka 2 sekundy na potwierdzenie ze stycznika. Jak stycznik nie "odpali", wywala błąd.
* **Zabezpieczenie termiczne:** Podpiąłem wejście pod termik, żeby chronić silnik przed spaleniem.
* **HMI:** Dodałem statusy tekstowe, żeby na panelu operator widział jasno, co się dzieje (np. "Praca" albo "Błąd termika").

### 5. Skalowanie czujników (Skalowanie_Analogowe.st)
Przeliczanie surowych danych z karty wejściowej na normalne jednostki. Zamieniam `INT` na `REAL`, żeby wynik (np. bary czy stopnie) był dokładny.
* **Diagnostyka:** Program pilnuje, czy sygnał nie wychodzi poza zakres (np. przy pękniętym kablu 4-20mA).

### 6. Blok obsługi alarmów (Obsluga_alarmow_analogowych)
Program monitoruje wartości analogowe i reaguje na przekroczenie progów bezpieczeństwa.
* **Histereza:** Kluczowy element zapobiegający "drganiu styków" (ciągłemu przełączaniu się alarmu przy małych wahaniach sygnału).
* **Dwa stopnie:** Ostrzeżenie (sygnalizacja) oraz Alarm (krytyczne zatrzymanie).
