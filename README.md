# Portfolio Automatyka – Projekty PLC (Structured Text)

Zbiór algorytmów i rozwiązań przemysłowych napisanych w języku ST (IEC 61131-3). Repozytorium prezentuje dobre praktyki programistyczne, dbałość o bezpieczeństwo oraz diagnostykę układów sterowania.

**55. System Kontroli Oddymiania i Napowietrzania Klatki Schodowej (`System_oddymiania_klatki.st`)**
Projekt algorytmu bezpieczeństwa pożarowego (Safety System) odpowiedzialnego za usuwanie gazów pożarowych oraz wytwarzanie nadciśnienia na drogach ewakuacyjnych
* **Logika Dual-Trigger:** Układ procedury alarmowej zintegrowany z automatyczną centralą sygnalizacji pożarowej 

## 54. Inteligentny Sterownik Oświetlenia Hali (`Sterownik_Oswietlenia_Hali.st`)
Automatyka optymalizacji użytej energii systemu oświetlenia
* **Skalowanie sygnałów:** Samodzielna implementacja skalowania wartości surowych (RAW 0-27648) na jednostki fizyczne (0-1000 Lux) przy użyciu konwersji typów INT_TO_REAL.
Tryb Energooszczędny (Energy Saving):
* **-W godzinach 07:00 - 17:00:** Poziom oświetlenia jest utrzymywany, wyłączając wykrywając źródło światła narturalnego
* **-Tryb Nocny:** Logika uzależniona od obecności pracowników. Zastosowano blok TOF (Off-Delay Timer), który podtrzymuje oświetlenie przez 15 minut od ostatniego wykrycia ruchu przez czujnik PIR.
* **-Stabilizacja sygnału:** Wprowadzenie marginesu przełączania, co likwiduje "miganie" świateł przy oscylacjach przy granicznych wartościach natężeniach światła [luks] i zapobiega przedwczesnym zuzyciu styków stycznika

## 53. Licznik Serwisowy Maszyny (`Licznik_serwisowy_maszyny.st`)
Algorytm monitorujący zużycie eksploatacyjne maszyny poprzez zliczanie cykli pracy.
* **Detekcja:** Detekcja jest oparta na zboczu, co pozwala unikn ać problemu z długimi syghnałami
* **Zarządzanie:** Automatyczna sygnalizacja flagi `WymaganySerwis` po osiągnięciu progu 1000 cykli
* **Interfejs techniczny:** Zaimplementowanie seystemu dla obsługi serwisowej

## 52. Monitor Wydajności Cyklu (`Monitor_wydajnosci_cyklu.st`)
Algorytm monitorujący sprawność mechaniczną układu poprzez monitoring cyklu maszyny
**Pomiar czasu rzeczywistego:** Badanie czasu timera do określeaia czasu trwania cyklu pracy
**Diagnostyka predykcyjna:** System porównuje czas ostatniego cyklu z zadanym limitem, co umożliwia wykrycie np. spadków ciśnienia w układzie lub zużycia uszczelnień siłownika.

## 51. Zaawansowany sterownik prasy hydraulicznej (`Zaawansowany_sterownik_prasy_hydraulicznej.st`)
Zastosowanie maszyny stanów sterującej cyklem produkcyjnym maszyny dociskającej detale
**Typy Wyliczeniowe (ENUM):** Zastosowanie autorskich sekwencji z użytą sekwencja stanów maszyny (OCZEKIWANIE, PRASOWANIE, ALARM), co pozwala eliminować błędy logiczne i zwiększa czytelność kodu dla programisty
**Logika sekwencyjna:** Pełna kontrola nad cyklem wyglądający następująco: dojazd do krańcówki, precyzyjny czas docisku (użyty Timer TON), automatyczny powrót i powrót siłownika
**System Bezpieczeństwa:** Nadrzędny stan alarmowy odcina wszystkie wyjścia sterujące w przypadku wykrycia nieprawidłowości

## 50. System obsługi i sygnalizacji alarmów (`System_obslugi_alarmow.st`)
Algorytm zarządzania stanami awaryjnymi oraz sygnalizacją wizualną
* **Wizualna sygnalizacja stanów:** Wykorzystanie generatora impulsów do rozróżnienia alarmu niepotwierdzonego (miganie) od potwierdzonego (świecenie ciągłe)
* **Pamięć wystąpienia awarii:** Zastosowanie flagi alarmu, która przechowuje informację o awarii
* **Reset alarmu**: Konstrukcja programu wymuszająca fizyczne potwierdzenie błędu przez operatora przed powrotem do trybu pracy
* **Zabezpieczenie przed samoczynnym startem:** Program blokuje wyjście procesowe do czasu całkowitego usunięcia przyczyny awarii i zresetowania układu

## 49. Naprzemienna rotacja pracy pomp (`Naprzemienna rotacja pracy pom.st`)
Algorytm zarządzania kaskadą pomp aby zapewnic rownomierne zuzycie
* **Automatyczna zamiana naprzemienna pompy:** Wykorzystanie zbocza narastającego do zmiany aktywnej pompy po akdzym uruchomieniu
* **Zabezpieczenie pomp:** Program jest zabezpieczony, przed praca dwoch pomp jednoczesnie, co by mogło być obciażeniem dla zasilania
* **Automatyczna zamiana pompy:** Wykorzystanie zbocza do zmiany aktywnej pompy
* **Zabezpieczenie pracy jednej pompy:** Konstrukcja warunków gwarantuje że w danym momencie pracuje tylko jedna pompa

## 48. Diagnostyka uszkodzenia czujnika (`Diagnostyka_uszkodzenia_czujnika.st`)
Algorytm typu **Watchdog** dla sygnałów analogowych, zapobiegający pracy na błędnych danych.
* **Detekcja uszkodzenia (freeze):** Program weryfikuje, czy wartość z czujnika ulega zmianie. Jeśli sygnał się nie zmienia przez 10 sekund, system sygnalizuje awarię
* **Analiza sygnałów (ABS):** Wykorzystanie wartości sygnału do badania różnicy pomiędzy dwoma cyklami, co pozwala na wykrycie braku aktywności sygnałuz czujnika
* **Filtracja:** Zastosowanie timera `TON` pozwala na odróżnienie naturalnych, krótkich przestojów w odczytywania wartosci z czujnika od rzeczywistej awarii sprzętowej
* **Bezpieczeństwo:** Funkcja niezbędna aby była możliwa, samokontgrola programu, co pomaga zminimalizowaćnie wykrycia awarii układu
  
## 47. Sterowanie Rampy (`Sterowanie_dynamiczne_rampy.st`)
Algorytm płynnego sterowania sygnałem analogowym
*  **Płynność sygnału:** Eliminacja gwałtownych skoków wartości poprzez narastanie/opadanie krokowe, co chroni odbiorniki i mechanikę maszyn
*  **Skalowanie:** Przeliczanie wartości procentowej (0.0 - 100.0%) na standardową rozdzielczość sterownika (0 - 27648) przy użyciu konwersji REAL_TO_INT
*  **Zabezpieczenie:** Implementacja programowych limitów wyjścia, gwarantująca, że sygnał nigdy nie przekroczy bezpiecznego zakresu pracy karty analogowej

## 46. Licznik Wydajności z Rejestrem (`Licznik_wydajnosci_z_rejestrem.st`)
Program monitorujący czas produkcji
*   **Bufor pierścieniowy:** Nadpisywanie najstarszych danych nowymi przy użyciu ograniczonego miejsca tablicy
*   **Pętla FOR:** Przetwarzanie zbiorów danych (sumowanie tablicy) w jednym cyklu sterownika
*   **Konwersja danych:** Przekształcanie typu `TIME` na formaty liczbowe (`LINT`), aby móc przeprowadzić operacje matematyczne
*   **Detekcja Zboczy:** Użycie `R_TRIG` do synchronizacji zapisu danych z fizycznym zdarzeniem na linii produkcyjnej

## 45. System Nawadniania Szklarni (`System_nawadniania_szklarni.st`)
Program sterujący podlewający rośliny, z optymalizowany kodem z indeksowaniem danych
*   **Zastosowanie Tablic** Czasy pracy dla poszczególnych sekcji są przechowywane w tablicy, co łatwe dopasowanie czasów podlwania każdej z sekcji
*   **Sterowanie sekcjami:** Wykorzystanie zmiennej `Numer_sekcji` do prostego wskazywania aktualnie aktywnego zaworu (`Zawory[Numer_sekcji]`)
*   **Deterministyczna Maszyna Stanów:** Podział procesu na kroki (Inicjalizacja, Podlewanie, Przełączenie sekcji) eliminuje ryzyko jednoczesnego otwarcia wielu zaworów.
*   **Prawidłowa Obsługa Timerów:** Blok `TON` jest wywoływany w każdym cyklu, co odlicza czas niezależnie od numeru kroku

## 44. Automat Segregujący Odpady (`Automat_segregujacy.st`)
Program segregujący odpady, poddajacy detekcji roadzjów materiałów danego odpadu
* **Struktura CASE:** Program podzielony na logiczne kroki, co zapewnia pełną kontrolę nad sekwencyjnym cyklem maszyny
* **System bezpieczeństwa:** Obsługa wejścia `E_Stop` jako styk **NC (Normally Closed)**. Każde przerwanie obwodu skutkuje natychmiastowym zatrzymaniem napędów 
* **Selekcja materiałów:** Wykorzystanie czujników identyfikacji rodzaju materiałów, a następnie kierowania odpadów do odpowiednich kontenerów
* **Precyzja:** Zastosowanie bloków `TON` do synchronizacji transportu z pracą siłowników pneumatycznych
* **Feedback mechaniczny:** Logika uzależniona od sygnałów z krańcówek

## 43. Autorski Licznik Godzin z Blokadą Napędu (`Licznik_godzin_z_blokada.st`)
Program zlicza czas dbając o bezpieczeństwo maszyny
**Bezpieczeństwo:** W przeciwieństwie do podstawowych liczników, ten program posiada funkcję blokady silnika. Po przekroczeniu limitu czasu pracy, program natychmiastowo zatrzymuje silnik aby wykonać serwis
**Zliczanie czasu:**. Zastosowanei zmiennej DINT pozwala na zliczanie nawet tysięcy godzin bezproblemowo
**Możliwość resetu serwisowego:** Zerowanie rejestru czasu i zdejmując blokadę z napędu, dając szansę dalszą pracę po serwisie

## 41. Analiza danych – Algorytm wyszukiwania wartości maksymalnej (`Przeszukiwanie_tablicy.st`)
Wskazywanie wartosci o najweikszej wartosci w tablicy
* **Zastosowanie pętli:** Wykorzystanie pętli FOR do sekwencyjnego sprawdzenia każdego elementu tablicy ARRAY[0..4]
* **porównywanie wartości:** Program w każdym kroku pętli porównuje bieżący element z dotychczasowym rekordem (Max_Wartosc), aktualizując dane tylko po znalezieniu wyższej wartości
**Inicjalizacja zmiennych:** Resetowanie wartości maksymalnej przed każdym skanem pętli zapewnia rzetelność wyników i odporność na błędy z poprzednich cykli

## 40. Wielostanowiskowy Licznik Paczek – Zarządzanie Tablicami (PLC ST) (`Licznik_paczek.st`)
* **Inteligęntne liczenie produktów:** Użycie struktur danych zamiast dodawanie zbędnych czujników co minimalizuje koszty
* **Dynamiczne adresowanie:** Wykorzystanie tablicy umożliwiającej na obsługę wielu stanowisk jednym rejestrem. O tym gdzie trafi paczka, decyduje wartość zmiennej Numer_stanowiska
* **Automatyzacja pętlą FOR:** Pętla pozwalająca na zresetowanie wszystkich liczników jednocześnie, niezależnie od ich liczby
* **Zabezpieczenie Range Checking:** Kontrola zakresu - zapobiega to próbom zapisu danych poza obszar tablicy, co w rzeczywistych sterownikach PLC mogłoby doprowadzić do zatrzymania procesora
* **Detekcja zboczy:** Zapewnia poprawność liczenia – jedno naciśnięcie przycisku lub jeden sygnał z czujnika to dokładnie jedna paczka

## 39. Tablica pomiarów - Filtr cyfrowy sygnału** (`Tablica_pomiarow_filtr_cyfrowy.st`)
Program realizujący funkcję programowego filtra dolnoprzepustowego, służący do stabilizacji sygnałów z czujników analogowych narażonych na szumy i nagłe skoki
* **Rejestr przesuwny:** Wykorzystanie tablicy ARRAY[0..9] OF REAL do przechowywania historii 10 ostatnich pomiarów
* **Logika przesuwania:** Zastosowanie pętli FOR do automatycznego przesuwania danych w pamięci – każda nowa próbka wypycha najstarszą, utrzymując aktualne pomiarowe
* **Obróbka danych statystycznych:** Obliczanie średniej w czasie rzeczywistym, co pozwala na wygładzenie przebiegu sygnału
* **Diagnostyka Trendu:** System alarmowy reagujący na uśrednioną wartość z 50 sekund (10 próbek co 5 sekund), eliminujące ryzyko fałszywych alarmów przy chwilowych wahaniach

## 38. Skalowanie sygnału analogowego z obsługą alarmów – Skalowanie_analogowe.st (`Skalowanie_analogowe.st`)
Program ten pokazuje odejście od maszyny stanów instrukcji CaSE, skupiając się na przetwarzaniu prorgamów w czasie rzeczywistym
* **Wykorzystanie matematyki:** Zastosowanie skalowania liniowego (konwersja wartości `INT` z wejść na fizyczną `REAL`)
* **Konwersja typów danych:** Wykorzystanie funkcji `INT_TO_REAL` do zapewnienia precyzji obliczeń i uniknięcia błędów dzielenia całkowitego
* **System monitoringu:** Niezależne bloki kontrolne sprawdzające progi alarmowe (High-High oraz Low-Low) w każdym cyklu sterownika
* **Brak sekwencyjności:** Kod jest wykonywany w całości w każdym skanie PLC, co gwarantuje najszybszą reakcję wartości programu

## 37. Automatyczna stacja napełniania butelek (`Stacja_napelniania_butelek.st`)
System dozujący, wykorzystujący wagę analogową do odmierzania cieczy oraz realizuje proces kontroli jakości
**Maszyna stanów:** Program posiada 5 stanów, co zapewnia przewidywalność zachowania procesu – od ustawienia butelki, przez nalewanie do weryfikacji wagi napoju
**Sprzężenie Zwrotne z wagi:** System na bieżąco kontroluje wagę, aby w odpowiednim momencie zamknać zawór dozujący ciecz
**Etap stabilizacji pomiaru:** Zastosowanie 2-sekundowego opóźnienia po zakończeniu nalewania. Pozwala to na ustabilizowanie się cieczy w butelce i uzyskanie precyzyjnego odczytu przed kontrolą jakości
**Kontrola Jakości:** System automatycznie sprawdza, czy finalna waga mieści się w przedziale 495g – 505g
**Zarządzanie alarmami:** W przypadku wykrycia niedolania lub przelania, system aktywuje blokadę alarmową, wymagającą interwencji operatora 

## 36. Automatyczny sterownik sekcji podlewania (`Nawadnianie_ogrodu.st`)
**Oszczędność wody:** Blokada podlewania w przypadku wykrycia opadów (czujnik deszczu) lub gdy wilgotność gleby jest wystarczająca (powyżej 40%)
**Harmonogram świtu:** Automatyczny start o godzinie 5:00 rano, co minimalizuje parowanie wody i szok termiczny dla roślin
**Zabezpieczenie przed przelaniem:** Blokada cyklu gwarantujący tylko jedno uruchomienie w ciągu doby

## 35. Inteligentny Sterownik Oświetlenia Korytarzowego (`Oświetlenie_korytarzowe.st`)
Algorytm zarządzania oświetleniem w automatyce budynkowej, z naciskiem na maksymalną oszczędność i komforcie użytkownika
**Logika dzień/noc:** Program bazuje na zegarze czasu rzeczywistego, aby automatycznie przełączać się między pełną mocą (100% w dzień), a trybem zredukowanym (30% w nocy), co ma nie oślepiać pracowników
**Tryb Standby:** Zaprojektowanie sekwencyjnego wyłączania – zamiast nagłego odcięcia światła, system przechodzi w tryb 10% mocy po 30 sekundach braku ruchu
**Oszczędność Energii:** Wykorzystanie blokady oświetlenia przy wystarczającym natężeniu światła naturalnego (powyżej 500 lx), co eliminuje niepotrzebne zużycie prądu.
**Maszyna Stanów:** Program działający na strukturze CASE...OF, z zaprojektowanymi stananmi OFF, FULL i STANDBY.
**Automatyczne wyłączanie:** Funkcja całkowitego wyłączenia systemu po 5 minutach bezczynności w trybie czuwania

## 34. Sterownik Bramy Magazynowej z Kurtyną Powietrzną (`Sterownik_Bramy_Kurtyna.st`)
Zaawansowany system sterowania dostępem zintegrowany z systemem oszczędzania energii HVAC.
**Logika hybrydowa:** Wykorzystanie maszyny stanów z opóźnieniem czasowym wyłączenia ukladu
**System bezpieczeństwa:** Użycie bariery optycznej zapobiegającej zamknięciu bramy gdy obiekt jest w miejscu pracy
**Efektywność energetyczna:** Zautomatyzowane sterowanie kurtyną powietrzną w celu minimalizacji strat ciepła
**Analityka:** Licznik cykli pracy dla odpowiedniego planowania przegladów technicznych

## 33. Automat prasy formującej – (`Sterownik_Prasy_Formujacej.st`)
Program sekwencyjny oparty na maszynie stanów (CASE...OF), realizujący cykl pracy prasy hydraulicznej/pneumatycznej z wymaganym naciskiem na bezpieczeństwo operatora
**Maszyna Stanów (State Machine):** Podział procesu na 4 faz(Oczekiwanie, ruch siłownika w dół, prasowanie, powrót siłownika):
**Funkcja bezpieczenstwa:** Wymaganie ciągłego trzymania przycisku Start podczas fazy ruchu i prasowania. Zwolnienie przycisku w dowolnym momencie skutkuje natychmiastowym przerwaniem cyklu i wycofaniem prasy
**Sprzężenie zwrotne:** Wykorzystanie czujników krańcowych (Czujnik_gora, Czujnik_dol) do weryfikacji fizycznego położenia tłoka przed przejściem do kolejnego kroku, co zapobiega błędom procesowym

## 32. Sterownik oswietlenia klatki schodowej (`Sterownik_oswietlenia_klatki.st`)
System sterowania oświetleniem budynkowym, dający komfort użytkownika z optymalizacją zużycia energii
**Logika układu:** Obsługa czujnika ruchu (Auto) oraz przycisku wielofunkcyjnego
**Funkcja ostrzeżenia:** Użycie czasu, który upłynął timera do sygnalizacji zbliżającego się wyłączenia światła poprzez redukcję mocy światła (Dimming) lub mruganie
**Detekcja Długiego Przyciśnięcia (Long Press):** Rozróżnianie krótkiego kliknięcia (start timera) od przytrzymania powyżej 3s (tryb serwisowy)
**Blokada Jasności:** Integracja z czujnikiem zmierzchowym (fotokomórką), zapobiegająca niepotrzebnemu załączaniu świateł w dzień.

## 31. Monitoring obciążenia silnika (`Monitoring_obciazenia_silnika.st`)
* **Ochrona przed przeciążeniem:** Zastosowanie  zwłoki czasowej (5s) dla prądu rozruchowego i roboczego przy użyciu timera TON
* **Zabezpieczenie termiczne:** Natychmiastowe przerwanie pracy przy przekroczeniu temperatury krytycznej uzwojeń
* **Obsługa przycisku STOP (NC):** Zastosoawnie logiki bezpieczeństwa – przerwanie obwodu skutkuje natychmiastowym stopem silnika
* **Restart awarii:** Blokada programowa uniemożliwiająca reset awarii przed schłodzeniem silnika do normalnego poziomu
* **Licznik ilości włączeń:** Dodanie licznika CTU zliczającego całkowitą liczbę załączeń stycznika głównego

## 30. Inteligentna Stacja Sortujaca z Kontrola Jakosci (`Stacja_sortujaca.st`)
Sterowanie sekwencyjne obróbką sygnałów analogowych i diagnostyką procesu
**Zaawansowana Maszyna Stanow (CASE):** Złożona logika krokowa (kroki 0-45) zarządzająca transportem, precyzyjnym pozycjonowaniem i selekcją produktów
**Przetwarzanie Sygnalu Analogowego:** Wykorzystanie kontroli wagi produktu. Wykorzystanie okna tolerancji do automatycznej klasyfikacji produktów na poprawne (OK) i wadliwe (NOK)
**System Diagnostyki i Safety:** Funkcja wykrywania błędów. Automatyczne zatrzymanie linii i aktywacja alarmu po wykryciu trzech wadliwych sztuk pod rząd, wymagające ręcznego potwierdzenia
**Zarzadzanie Wyjsciami:** Praca napędu taśmociągu oraz elementów pneumatycznych z siłownikiem odrzutu, z uwzględnieniem czasów stabilizacji pomiaru

## 29. Automatyczna Myjnia Samochodowa (Sekwencja Czasowa) (`Myjnia_samochodowa.st`)
Algorytm sterowania sekwencyjnego procesem mycia pojazdu z wykorzystaniem maszyny stanów.
**Maszyna stanow (CASE):** Zastosowanie struktury krokowej (0-4), która gwarantuje, że kolejne procesy (namaczanie, mycie, płukanie, suszenie) nigdy nie nałożą się na siebie w niepożądany sposób
**Wielopoziomowa Kontrola Czasu:** Zastosowanie bloków TON dla każdego etapu procesu, pozwalających na niezależną kontrolę czasu trwania każdej z faza (np. dłuższe mycie, krótsze płukanie).
**Bezpieczenstwo NC (Normally Closed):** Wykorzystanie logiki dla przycisku bezpieczeństwa STOP. Program monitoruje ciągłość obwodu – w przypadku wciśnięcia przycisku lub awarii okablowania, system natychmiast przechodzi w stan bezpieczny i resetuje wszystkie wyjścia

Zarzadzanie Wyjsciami: Koordynacja pracy wielu odbiorników jednocześnie (elektrozawory wody/szamponu, napędy szczotek oraz wentylator suszarki) w zależności od aktualnego kroku algorytmu

## 28. Inteligentna Winda Magazynowa (Pozycjonowanie Analogowe) (`Myjnia_samochodowa.st`)
Algorytm sterowania windą towarową 3 poziomową
**Pozycjonowanie bezstykowe:** Zastąpienie klasycznych krańcówek odczytem z czujnika odległości (zakres 0-1000 jednostek)
Histereza: Wykorzystanie programowego marginesu błędu (+/- 10 jednostek), likwidująca zjawisko "szarpania" napędem przy dojeżdżaniu do celu
**Zarządzanie Celem:** Wykorzystanie zmiennej Cel jako nastawy, co pozwala na łatwą konfigurację poziomów bez zmiany logiki ruchu
**System bezpieczeństwa:** Najwyższy priorytet blokady ruchu przy otwartych drzwiach oraz funkcja natychmiastowego zatrzymania w przypadku naruszenia bezpieczeństwa podczas jazdy
**Diagnostyka Stanu:** Podział logiki na sekcję wyboru poziomu oraz sekcję wykonawczą, co ułatwia kontrolowanie kodu online

## 27. Inteligentna Prasa Hydrauliczna (BHP & Proces) (`Prasa_Hydrauliczna.st`)
Algorytm sterowania siłownikiem prasy z naciskiem na bezpieczeństwo operatora.
* **Sterowanie Dwuręczne:** Zastosowanie logiki wymagającej jednoczesnego wciśnięcia dwóch przycisków (Przycisk_1 AND Przycisk_2), co eliminuje ryzyko włożenia dłoni w strefę pracy maszyny
* **Czujnik świetlny (NC)**: Wykorzystanie czujnika bezpieczeństwa – przerwanie wiązki w fazie ruchu powoduje natychmiastowe wycofanie tłoka do pozycji bezpiecznej
* **Maszyna Stanów (CASE):** Podział procesu na fazy: oczekiwanie, ruch w dół, Docisk czasowy, powrót
* **Docisk Sekwencyjny:** Wykorzystanie timera TON do utrzymania ciśnienia przez 3 sekundy a następnie powrotem siłownika
* **Licznik Wydajności:** Użycie zmiennej Liczba_sztuk następuje dopiero po poprawnie wykonanym docisku detalu
* **Logika Fail-Safe:** Automatyczne wycofanie maszyny w przypadku puszczenia przycisków sterujących przed zakończeniem cyklu

## 26. Automatyczna stacja pakująca zbiorcza (`Stacja_pakujaca.st`)
* **Zliczanie produktów:** Wykorzystanie licznika CTU do odliczania 6 sztuk towaru na tasmociągu
* **Sekwencja spychająca:** Po osiągnięciu limitu 6 sztuk, system automatycznie zatrzymuje taśmę, aby nie doszlo do kolizji z kolejnymi paczkami
* **Sterowanie czasowe:** Wykorzystanie timera impulsowego do sterowania siłownikiem zrzutowym paczek 2 sekundy
*  **Automatyczny Reset:** Licznik samoczynnie sie resetuje i wznawia pracę taśmy po pełnym zapakowaniu paczki, co pozwala na ciaglą pracę
* **Bezpieczeństwo (E-Stop):** Wykorzystanie przycisku awaryjnego ze stykiem NC, który przerywa pracę silnika taśmy oraz siłownika

## 25. Logika ukladu bramy garazowej (`Inteligentny_garaz.st`)
* **Wykrywanie:** Monitoring stężenia dwutlenku węgla
* **Wentylacja:** Aktywacja wyciągu po wykryciu gazu. Wykorzystano timer TOF, który podtrzymuje pracę wentylatora przez 10 sekund po ustaniu sygnału z czujnika, aby mieć pewność całkowitego usunięcia czynnika z powietrza
* **Blokada Bramy:** Ze względów bezpieczeństwa, silnik bramy zostaje zablokowany, gdy poziom CO2 przekracza bezpieczną normę, uniemożliwiając wjazd
* **Automatyka światła:** Światło zapala się samoistnie po wykryciu ruchu z czujników
* **Detekcja awarii:** System po włączaniu wentylatora, oczekuje na sygnał powietdzający 

## 24. Logika Taśmociągu (`Logika_tasmociagu.st`)
Program sterujący linią transportową z funkcją oszczędzania energii oraz diagnostyką zatorów.
Technologia: Structured Text (ST), standard IEC 61131-3.
Safety: Obsługa przycisków NC i blokada programowa napędu przy awarii.

## 23. Inteligentna Winda Magazynowa (5 poziomów) (`Winda_Magazynowa_Analogowa.st`)
Pozycjonowanie kabiny z wykorzystaniem czujnika analogowego i algorytmu
* **Mapowanie Pozycji (CASE):** Przypisywanie 5 przystanków (0-4) do wartości cyfrowych czujnika odległości (0-1000 jednostek)
* **Algorytm Histerezy:** Wkorzystanie tolerancji (+/- 10 jednostek), która eliminuje zjawisko "szarpania" silnikiem przy dojeżdżaniu do celu i stabilizuje postój
**Ochrona Napędu (TON):** Programowa blokada nawrotu (2.0s), zapobiegająca gwałtownym zmianom kierunku obrotów silnika, co chroni przekładnię i styczniki
**Logika Przeciążeniowa:** Ciągły monitoring masy ładunku (Waga > 500) zintegrowany z systemem bezpieczeństwa, blokujący ruch w warunkach niebezpiecznych
**Interlock Safety:** Nadrzędna sekcja zatrzymania (STOP/Alarm) umieszczona na końcu cyklu programu, gwarantująca najwyższy priorytet dla sygnałów bezpieczeństwa

### 22. System Smarowania Progresywnego (`LubeControl_Main.st`)
Algorytm sterowania układem smarowania połączony z napędem głównym
* **Dual Triggering:** Automatyczne uruchomienie smarowania po 8h pracy netto LUB po 100 cyklach roboczych maszyny
* **Monitoring ciśnienia:** Diagnostyka czasu narastania ciśnienia (min. 50 bar w 30s) zabezpieczająca przed pracą na sucho lub wyciekiem
* **Safety Interlock:** Safety Interlock: Automatyczna blokada silnika głównego w przypadku wykrycia awarii układu smarowania (Predictive Maintenance)
* **Zatrzask SET/RESET:** Zatrzask SET/RESET: Pełna obsługa przycisków monostabilnych START/STOP z priorytetem dla zatrzymania awaryjnego

## 21. Sterownik HVAC z Redundancją i Autodiagnostyką (`Inteligentny_Sterownik_HVAC.st`)
Zaawansowany algorytm sterowania wentylacją hali, skupiony na niezawodności i bezpieczeństwie procesowym (Fail-Safe).
* **Autodiagnostyka Wejść (Wire-break):** Program kontroluje poprawność sygnałów z czujników. Wartości poza zakresem (-50°C do 150°C) są natychmiast wykrywane jako uszkodzenie okablowania
* **Redundancja Czujników (Fail-over):** W przypadku awarii czujnika głównego, system natychmiast przełącza się na odczyt z czujnika zapasowego, aktywując przy tym alarm dla służb utrzymania ruchu
* **Algorytm Fail-Safe:** W sytuacji utraty sygnału z obu czujników, sterownik wymusza pracę wentylatora na 100%, zapobiegając przegrzaniu urządzeń na hali (priorytet bezpieczeństwa)
* **Stabilizacja Wyjścia (Histereza):** Implementacja programowej histerezy (2.0°C) zapobiega oscylacjom stycznika (tzw. "migotaniu" wyjścia) przy temperaturze oscylującej wokół punktu nastawy, co znacząco wydłuża żywotność silnika

## 20. Transporter Tasmowy (`Sterowanie_przepompownia.st`)
Zaawansowany algorytm sterowania tasmociagiem oparty na maszynie stanow (CASE...OF).
* **Architektura CASE:** Logika podzielona na trzy stany: OFF (0), AUTO (1) oraz SERVICE (2), co zwieksza przejrzystosc kodu
* **Tryb Automatyczny:** Wykorzystanie timera TP do sterowania czasem jazdy (5s) po wykryciu obiektu/paczki
* **Tryb Serwisowy (JOG):** Mozliwosc recznego wymuszenia pracy silnika przez operatora w trybie serwisowym
* **Bezpieczenstwo (E-STOP):** Warunek stopu (styk NC) z najwiekszym priorytetem, ktory natychmiastowo resetuje maszyne do stanu bezpiecznego (OFF) w razie awarii - wylacza wszystko
* **Licznik Wydajnosci:** Zliczanie sztuk towaru na zboczu narastajacym pracy silnika

## 19. Sterownik Przepompowni (Histereza i Suchobieg) (`Sterowanie_Przepompownia.st`)
Algorytm sterowania pompą z zaawansowaną diagnostyką i zliczaniem cykli
* **Logika Histerezy:** Wykorzystanie dwóch progów: start: 8.0m, Stop: 2.0m, w celu pracy napędu i uniknięcia częstych rozruchów co może wpływać negatywnie na pompę
* **Zabezpieczenie przed Suchobiegiem:** Kontrola ciśnienia w rurociągu za pomocą timera `TON`, aby zabezpieczyć układ przed suchobiegiem, co uszkodziłoby pompę. Automatyczne wyłączenie pompy w przypadku braku potwierdzenia przepływu w czasie 3 sekund
* **Zatrzask Awarii (Latch):** Blokada pracy po wystąpieniu alarmu, wymagająca fizycznej interwencji
* **Analityka Pracy:** Zliczanie uruchomień układu z wykorzystaniem detekcji zbocza narastającego (`R_TRIG`).

## 18. Skalowanie Analogowe z alarmem (`Skalowanie_poziomu_w_zbiorniku.st`)
Kontrola sygnałów z czujników analogowych na jednostki inżynierskie
* **Normalizacja:** Przeliczenie wartości z karty wejściowej na realny poziom w zbiorniku
* **Histereza:** Logika alarmowa, załączająca alarm przy 9.0m, a wyłączająca przy 8.5m
* **Data Integrity:** Wykorzystanie konwersji typów `INT_TO_REAL`

## 17. Cyfrowy Zadajnik Prędkości (VFD) (`Zadajnik_predkosci.st`)
Opracowanie interfejsu użytkownika do płynnego sterowania prędkością obrotową silnika w zakresie 0.0 - 100.0%
* **Detekcja Zboczy (Edge Detection):** Wykorzystanie bloków funkcyjnych `R_TRIG` do precyzyjnej regulacji wartości. Dzięki temu zmiana następuje tylko raz na każde kliknięcie przycisku, niezależnie od czasu jego trzymania
* **Ograniczanie Zakresu (Clamping):** Zastosowanie funkcji `LIMIT` gwarantującej, że wartość zadana nigdy nie przekroczy dopuszczalnych rejestrów (0-100%), co zapobiega błędom sterowania falownika
* **Arytmetyka REAL:** Obliczenia na liczbach zmiennoprzecinkowych pozwalające na płynne skalowanie częstotliwości wyjściowej

## 16. Nadzór Wentylacji z Pętlą Zwrotną (`Kontrola_wentylatora.st`)
System sterowania wentylatorem z weryfikacją pracy na podstawie przepływu powietrza
* **Startup Bypass:** Timer TON (5s) do ignorowania stanu czujnika podczas rozruchu
* **Pętla Sprzężenia:** Ciągła weryfikacja czujnika przepływu względem stanu wyjścia
* **Zabezpieczenie termiczne:** Wyłączenie układu po przekroczeniu 80°C

## 15. System Sortowania Pacze (`Sortownik_paczek.st`)
Logika sterowania linią transportową z automatyczną segregacją towaru na podstawie masy
* **Synchronizacja Czasowa:** Wykorzystanie timera TON do odliczania czasu dojazdu paczki do sekcji wykonawczej (opóźnienie transportowe).
* **Logika Decyzyjna:** Rozdzielanie paczek na "lekkie" i "ciężkie" przy użyciu instrukcji warunkowych i danych z wagowego czujnika analogowego
* **Automatyzacja Cyklu:** Maszyna stanów kontrolująca pełny proces: od detekcji obecności, przez transport, aż po selekcję i powrót do stanu gotowości

## 14. Kaskada Pomp z Autozamianą (`Sterowanie_kaskadowe_pomp.st`)
Algorytm zarządzania pracą dwóch pomp w systemie przepompowni
* **Kaskada:** Automatyczne dołączanie drugiej pompy przy wysokim zapotrzebowaniu (>90%)
* **Equal Run Time:** Mechanizm zamiany pompy głównej przy każdym cyklu, co optymalizuje czas eksploatacji urządzeń
* **Ochrona:** System ochrony przed suchobiegiem i zbędnymi cyklami załączeń

## 13. Skalowanie Analogowe (PT100) (`Skalowanie_analogowe_PT100.st`)
Program realizujący przeliczanie  danych z wejścia analogowego sterownika na °C
* **Konwersja:** Wykorzystanie funkcji `INT_TO_REAL` do obliczeń na liczbach zmiennoprzecinkowych
* **Matematyka Procesowa:** Wykorzystanie wzoru na liniowe skalowanie sygnału w zakresie -50.0 do 150.0°C
* **Diagnostyka:** Automatyczny alarm przekroczenia temperatury krytycznej (>100°C)

## 12. Automatyczny Mieszalnik ('Automatyczny_mieszalnik.st')
Algorytm sterowania sekwencyjnego z przygotowaniem mieszanki dwóch składników.
* **Maszyna Stanów (CASE):** Wykorzystanie struktury `CASE...OF` do zarządzania etapami procesu
* **Obsługa Sygnałów Analogowych:** Dozowanie składników A (40%) i B (80%) na podstawie odczytu z analogowego czujnika poziomu (REAL)
* **Automatyzacja Czasowa:** Zastosowanie timera TON do odliczania 10 sekund cyklu mieszania
* **Logika Bezpieczeństwa:** Wdrożenie nadrzędnego sygnału Stop Awaryjny (E-Stop), który natychmiast przerywa sekwencję i resetuje układ do stanu bezpiecznego

## 11. Automatyczny Cykl Nawrotny (`Automatyczny_cykl_nawrotny.st`)
Automatyczne sterowanie zmianą kierunku pracy napędu (Lewo/Prawo)
* **Logika sekwencyjna:** Automatyczne przełączanie kierunków po upływie czasu pracy (5s)
* **Bezpieczeństwo (Interlock):** Pauza (3s) przed każdą zmianą kierunku
* **Pamięć stanu:** Wykorzystanie flagi do zapamiętywania fazy cyklu i przejścia w kolejny krok
* **Priorytet Stop:** Natychmiastowe zatrzymanie automatu po naciśnięciu przycisku STOP (NC)

## 10. Regulacja Poziomu (`Regulacja_poziomu_w_zbiorniku_z_histereza.st`)
Algorytm napełniania zbiornika w zakresie 20-80%
* **Histereza:** Blokada przed zbyt częstym uruchomieniom i wyłączeniom pompy
* **Ochrona sprzętu:** Likwidacja zjawiska "szarpania" stycznikiem przy niewielkich wahaniach poziomu cieczy
* **Diagnostyka:** Wykrycie wartości poza zakresem czujnika (-5% do 105%) i automatyczne przejście w stan zabezpieczający układ

## 9. Rozruch Kaskadowy (`Sekwencyjne_wlaczanie_silnikow.st`)
Sekwencyjnye uruchamianiem napędów
* **Pomiar zwłoki:** Użycie timerów TON do odliczania przerw (5s) między startem sekcji
* **Logika powiązań:** Zabezpieczenie przed startem dalszych silników w przypadku awarii poprzednika
* **Bezpieczeństwo:** Użycie podtrzymania programowego z priorytetem dla sygnału STOP (NC)

## 8. Licznik czasu pracy (`Licznik_Godzin_Pracy.st`)
System monitorowania zużycia eksploatacyjnego napędu
* **Pomiar czasu:** Zliczanie sekund pracy tylko podczas aktywnego sygnału silnika
* **Diagnostyka HMI:** Automatyczne przeliczanie jednostek na motogodziny
* **Harmonogram serwisu:** System powiadomień o przeglądzie technicznym po przekroczeniu 500h

## 7. Monitorowanie ruchu (`Kontrola_ruchu_tasmy.st`)
Nadzór faktycznej pracy silnika z wykorzystaniem czujnika obrotów
* **Oczekiwanie na rozruch:** Czas ochronny (3s) pozwalający maszynie na wejście w obroty
* **Nadzór czasu:** Kontrola czasu między impulsami (800ms)
* **Blokada ruchu:** Automatyczne zatrzymanie napędu w przypadku wykrycia blokady mechanicznej

## 6. Licznik Produkcji (`Production_counter.st`)
Zliczanie detali z użyciem detekcji zbocza narastającego `R_TRIG`

## 5. Alarmy z Histerezą (`Obsluga_alarmow_analogowych.st`)
Monitorowanie progów bezpieczeństwa dla wartości analogowych
* **Histereza:** Zapobieganie fluktuacjom sygnału i fałszywym alarmom
* **Poziomy:** Rozdzielenie ostrzeżenia od alarmu krytycznego

## 4. Skalowanie Analogowe (`Skalowanie_Analogowe.st`)
Przeliczanie danych wejściowych (INT) na wartości fizyczne (REAL)
* **Diagnostyka:** Detekcja błędów pomiarowych

## 3. Diagnostyka Silnika (`Motor_Control_Diagnostic.st`)
Sterowanie napędem z monitoringiem odpowiedzi
* **Feedback:** Czasowa weryfikacja odpowiedzi ze stycznika (2s)
* **Zabezpieczenie:** Integracja z wyłącznikiem silnikowym (termikiem)
* **Statusy HMI:** Przekazywanie komunikatów tekstowych o błędach

## 2. Maszyna Stanu (`Sterowanie_sekwencyjne_tasmociagu.st`)
Sekwencja pracy z użyciem instrukcji `CASE`
* **Skalowalność:** Numeracja stanów co 10 pozwala na łatwe dodawanie kroków pośrednich
* **Stany:** Obsługa trybów IDLE, RUNNING oraz ERROR

## 1. Obsługa Grzyba (`Emergency_Stop.st`)
System bezpieczeństwa dla maszyny
* **Logika NC:** Reakcja na zanik napięcia (bezpieczeństwo w przypadku uszkodzenia przewodu)
* **Reset:** Blokada restartu – wymagane świadome potwierdzenie operatora po ustąpieniu awarii
