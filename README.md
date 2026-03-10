# Nauka-PLC-ST - Język Structured Text (ST/SCL)

Repozytorium zawiera projekty i ćwiczenia realizowane w ramach nauki programowania sterowników PLC. Skupiam się na implementacji algorytmów w języku tekstowym, zgodnie z normą IEC 61131-3.

## Projekt: Sterowanie silnikiem z symulacją obiektu
Pierwszy projekt realizujący podstawową logikę sterowania napędem (np. bramą lub pompą) z wykorzystaniem podtrzymania i czasowej symulacji sygnałów zwrotnych.

### Funkcjonalność:
* **Logika Start/Stop**: Klasyczne sterowanie z priorytetem dla sygnału zatrzymania.
* **Symulacja krańcówki**: Wykorzystanie bloku `TON` do emulacji dojechania do celu po 5 sekundach pracy.
* **Bezpieczeństwo**: Blokada załączenia przy aktywnej krańcówce lub wciśniętym przycisku Stop.

### Standardy kodowania:
U kodzie stosuję notację techniczną ułatwiającą diagnostykę:
* `x` - zmienne binarne (BOOL), np. `xSilnik`.
* `fb` - instancje bloków funkcyjnych, np. `fbTimer`.

**Projekt: Emergency Stop**
Implementacja funkcji bezpieczeństwa (E-Stop) zgodnie z logiką NC (Normally Closed).
Zastosowanie mechanizmu Reset Interlock – blokada samoczynnego rozruchu maszyny po zwolnieniu przycisku.
Zgodność ze standardem IEC 61131-3.
