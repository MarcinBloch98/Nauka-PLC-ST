# Nauka PLC w Structured Text (ST)
Moje autorskie projekty i algorytmy pisane podczas nauki programowania sterowników w języku ST. Skupiam się na czystym kodzie i standardach, które faktycznie spotyka się na obiektach.

### 1. Prosty Start/Stop silnika
Podstawa sterowania napędem z podtrzymaniem. Zrobiłem to na priorytecie wyłączenia – bezpieczeństwo przede wszystkim (Stop zawsze ma pierwszeństwo nad Startem).

### 2. Obsługa Grzyba (E-Stop)
Logika bezpieczeństwa dla maszyny.
* **Logika NC:** Program reaguje na zanik napięcia (np. zerwany kabel), co jest standardem w przemyśle.
* **Reset:** Dodałem blokadę, żeby maszyna nie ruszyła sama po odblokowaniu przycisku – operator musi świadomie kliknąć Reset.

### 3. Licznik detali na linii
Zliczanie produktów przejeżdżających przez czujnik. Wykorzystałem wykrywanie zbocza (`R_TRIG`), żeby jeden detal nie był liczony kilka razy. Jest też porównanie z limitem – system daje sygnał, gdy np. karton jest pełny.

### 4. Maszyna Stanu (Sekwencja taśmociągu)
Zarządzanie pracą maszyny przez instrukcję `CASE`. Podzieliłem to na stany (IDLE, RUNNING, ERROR). Użyłem numeracji co 10 (10, 20, 30...), żeby w razie czego łatwo było dodać tam dodatkowy krok bez zmieniania całego programu.

### 5. Silnik z kontrolą odpowiedzi (Feedback)
Bardziej rozbudowany blok sterowania napędem.
* **Diagnostyka:** Program czeka 2 sekundy na potwierdzenie ze stycznika. Jak stycznik nie "odpali", wywala błąd.
* **Zabezpieczenie termiczne:** Podpiąłem wejście pod termik, żeby chronić silnik przed spaleniem.
* **HMI:** Dodałem statusy tekstowe, żeby na panelu operator widział jasno, co się dzieje (np. "Praca" albo "Błąd termika").

### 6. Skalowanie czujników (Analogi)
Przeliczanie surowych danych z karty wejściowej na normalne jednostki. Zamieniam `INT` na `REAL`, żeby wynik (np. bary czy stopnie) był dokładny.
* **Diagnostyka:** Program pilnuje, czy sygnał nie wychodzi poza zakres (np. przy pękniętym kablu 4-20mA).
