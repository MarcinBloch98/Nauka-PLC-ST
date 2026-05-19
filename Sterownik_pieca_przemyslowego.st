VAR
    Przycisk_start      : BOOL;       // przycisk START procesu (Styk NO)
    Przycisk_stop       : BOOL;       // przycisk STOP NC
    Czujnik_drzwi       : BOOL;       // czujnik otwarcia drzwi (TRUE = Otwarte)
    Temp_RAW            : INT;        // surowy sygnał z karty PT100 (0 - 27648)
    Grzalka             : BOOL;       // stycznik załączający grzałki oporowe
    Wentylator_obiegowy : BOOL;       // stymulacja ruchu powietrza w komorze
    Koniec_procesu      : BOOL;       // lampa sygnalizacyjna na panelu
    Temperatura_aktualna : REAL;      // przeliczona temperatura w °C
    Proces_aktywny      : BOOL;       // flaga informująca, że piec pracuje
    Temperatura_osiagnieta : BOOL;    // flaga zezwolenia na odliczanie czasu
    Timer_pieczenia     : TON;        // zegar liczacy czas trwania procesu
END_VAR

// skalowanie na wartosc w Celcjusza
Temperatura_aktualna := (INT_TO_REAL(Temp_RAW) / 27648.0) * 250.0;

// start/stop procesu
IF Przycisk_Start AND NOT Czujnik_Drzwi AND NOT Przycisk_Stop THEN
    Proces_Aktywny := TRUE;
    Koniec_Procesu := FALSE;
ELSIF Przycisk_Stop OR Timer_Pieczenia.Q THEN
    Proces_Aktywny := FALSE; // wyłączenie procesu przy STOP lub po upływie czasu
END_IF;

// grzałka i wentylator mogą pracować tylko przy aktywnym procesie i zamkniętych drzwiach
IF Proces_Aktywny AND NOT Czujnik_Drzwi THEN
    Wentylator_Obiegowy := TRUE; // termoobieg działa zawsze, gdy piec pracuje
    
    IF Temperatura_aktualna < 178.0 THEN
        Grzalka := TRUE;
    ELSIF Temperatura_aktualna > 182.0 THEN
        Grzalka := FALSE;
    END_IF;
    
    // rozpoczynanie odliczania czasu gdy piec sie nagrzeje do 180 stopni
    IF Temperatura_aktualna >= 180.0 THEN
        Temperatura_osiagnieta := TRUE;
    END_IF;
    
ELSE
    // otwarte drzwi lub wylaczony proces wylaczaja grzanie i wentylacje
    Grzalka := FALSE;
    Wentylator_obiegowy := FALSE;
END_IF;


// timer rusza gdy osiagnelismy zadana temperature, otwarcie drzwizatrzymuje liczenie 
Timer_pieczenia(IN := (Proces_aktywny AND Temperatura_osiagnieta AND NOT Czujnik_drzwi), 
                PT := T#10m);

// Po odliczeniu czasu zapal lampę końca i zresetuj flagę temperatury
IF Timer_pieczenia.Q THEN
    Koniec_procesu := TRUE;
    Temperatura_osiagnieta := FALSE;
END_IF;
