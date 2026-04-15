VAR
    Przycisk_start : BOOL;         // przycisk NO monostabilny uruchamiajacy uklad
    Przycisk_stop : BOOL;          // przycisk NC bistabilny wylaczajacy uklad
    Potwierdzenie_awarii : BOOL;   // przycsik NO monostabilny potwierdzajacy awarie
    Prad_silnika : INT;            // miernik pradu na silniku wartosc 0-1000
    Temp_uzwojenia : INT;          // czujnik temperatur yan silniku wartosc 0-150
    Stycznik_silnika : BOOL;       // stycznik zasilajacy silnik
    Lamp_ostrzezenie : BOOL;       // lampa sygnalizujaca przeciazenie silnika
    Syrena_przeciazenia : BOOL;    // sygnal dzwiekowy informujacy o przeciazeniu
    Blokada_Awaryjna : BOOL;       // flaga pamietajaca wystapienie awarii
    Timer_przeciazenia : TON;      // czas opoznienia stanu przeciazenia silnika
    Licznik_uruchomien : CTU;      // ilosc uruchomien silnika
END_VAR

// deklaracja timera
Timer_przeciazenia(IN := (Prad_silnika >= 900), PT := T#5S);

// licznik uruchomien silnika
Licznik_uruchomien(CU := Stycznik_silnika);

// wykrycie awarii i blokada silnika
IF Timer_przeciazenia.Q OR Temp_uzwojenia > 110 THEN
    Blokada_Awaryjna := TRUE;   // aktywacja flagii awarii
    Stycznik_silnika := FALSE;  // natychmiastowe wyłączenie silnika
    Syrena_przeciazenia := TRUE;  // wlaczenie syerny ifnormujacej o przeciazeniu
END_IF;

// ostrzezenie, silnik jeszcze pracuje
IF Prad_silnika > 700 THEN
    Lamp_ostrzezenie := TRUE;
ELSE
    Lamp_ostrzezenie := FALSE;
END_IF;

// reset awarii gdy silnik ostygl i zostal wcisniety przycisk
IF Potwierdzenie_awarii AND Temp_uzwojenia < 60 THEN
    Blokada_Awaryjna := FALSE;
    Syrena_przeciazenia := FALSE;
END_IF;

// sterowanie silnikiem gdy nie ma blokady
IF Przycisk_start AND NOT Blokada_Awaryjna AND Przycisk_stop THEN
    Stycznik_silnika := TRUE;
END_IF;

IF NOT Przycisk_Stop THEN  // wcisniecie przycisku lub zerwanie kabla wylacza silnik
    Stycznik_silnika := FALSE;
END_IF;
