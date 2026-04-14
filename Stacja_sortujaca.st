VAR
    Czujnik_paczki : BOOL;  // wykrycie produktu
    Waga_analogowa : INT;   // masa produktu wartosc 0-1000
    Przycisk_Reset : BOOL;  // resetowanie alarmu i licznikow   
    Tasmociag : BOOL;       // silnik linii
    Silownik_odrzutu : BOOL;  // spychacz
    Lampa_Alarm : BOOL;     // sygnalizacja bledu
    Stan : INT := 0;        // krok maszyny
    
    Timer_Wazenia : TON;    // czas na zwazenie produktu
    Timer_Odrzutu : TON;    // czas wysuniecia silownika
    Timer_Dojazdu : TON;    // DODANO: czas przejazdu miedzy sekcjami
    
    Sztuki_OK : INT := 0;   // produkty poprawne
    Sztuki_NOK : INT := 0;  // produkty odrzucone
    Bledy_pod_rzad : INT := 0; //licznik bledow
    Alarm_Aktywny : BOOL := FALSE;
END_VAR

CASE Stan OF
0:  // --- Stan oczekiwania na sygnal ---
    Tasmociag := FALSE; // tasma stoi
    
    IF Czujnik_paczki AND NOT Alarm_Aktywny THEN
        Stan := 10;
    END_IF;

10: // --- Transport paczek ---
    Tasmociag := TRUE;

    // Paczka jedzie 3 sekundy pod wage
    Timer_Dojazdu(IN := TRUE, PT := T#3S);
    
    IF Timer_Dojazdu.Q THEN
        Timer_Dojazdu(IN := FALSE); // reset timera
        Tasmociag := FALSE;         // stop tasmy bo paczka jest na wadze
        Stan := 20;                 // nastepny krok - wazenie
    END_IF;
    
20: // wazenie paczki przez 2 sek
    Timer_Wazenia(IN := TRUE, PT := T#2S);

    IF Timer_Wazenia.Q THEN
        Timer_Wazenia(IN := FALSE); // reset timera wazenia
            
        // LOGIKA ANALIZY WAGI
        IF Waga_analogowa >= 400 AND Waga_analogowa <= 600 THEN
            // PACZKA POPRAWNA
            Sztuki_OK := Sztuki_OK + 1;
            Bledy_pod_rzad := 0; // wyzerowanie licznika bledow
            Stan := 30;          // przejscie do kolejnego kroku
        ELSE
            // PACZKA WADLIWA
            Sztuki_NOK := Sztuki_NOK + 1;
            Bledy_pod_rzad := Bledy_pod_rzad + 1; // Zliczamy bledy pod rzad
            Stan := 40;          // kolejny kroku odrzut
        END_IF;
    END_IF;

30: // transport poprawnej paczki
    Tasmociag := TRUE;

    // czas zjazdu z wagi
    Timer_Dojazdu(IN := TRUE, PT := T#3S);

    IF Timer_Dojazdu.Q THEN
       Timer_Dojazdu(IN := FALSE);
       Tasmociag := FALSE; 
       Stan := 0; // wyzerowanie ukladu do stanu poczatkowego
    END_IF;
    
40: // przygotowanie do odrzutu paczki
    Tasmociag := TRUE;
    
    // Spychacz jest 2 sekundy za waga
    Timer_Odrzutu(IN := TRUE, PT := T#2S);
    
    IF Timer_Odrzutu.Q THEN
        Timer_Odrzutu(IN := FALSE);
        Tasmociag := FALSE; // zatrzymanie tasmy aby zepchnac
        Stan := 45;         
    END_IF;

45: // praca spychacza
    Silownik_odrzutu := TRUE; 
    
    Timer_Odrzutu(IN := TRUE, PT := T#1S); 
    
    IF Timer_Odrzutu.Q THEN
        Timer_Odrzutu(IN := FALSE);
        Silownik_odrzutu := FALSE; // schowanie tloka
        Stan := 0; 
    END_IF;

END_CASE;

// alarm
IF Bledy_pod_rzad >= 3 THEN
    Alarm_Aktywny := TRUE;
    Lampa_Alarm := TRUE;
END_IF;

IF Przycisk_Reset THEN
    Alarm_Aktywny := FALSE;
    Lampa_Alarm := FALSE;
    Bledy_pod_rzad := 0;
    Stan := 0;
END_IF;
