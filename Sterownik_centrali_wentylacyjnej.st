VAR
    Moj_czas_struktura : DTL;        // struktura siemensa zawierajaca rok, miesiac, godzine
    Status_funkcji     : INT;        // informacja diagnostyczna
    Godzina_system     : INT;        // pamiec dla pobranej godziny (od 0 do 23)
    Tryb_nocny         : BOOL;       // flaga: TRUE = jest noc (18-6), FALSE = jest dzień
    Sygnal_CO2_RAW     : INT;        // surowy sygnal z czujnika fizycznego (od 0 do 27648)
    Poziom_CO2         : REAL;       // przeliczona wartosc (0 - 2000 ppm)
    Wydajnosc_nawiew   : REAL;       // sygnal dla wentylatora: jak mocno ma dmuchac (0% - 100%)
END_VAR

Status_funkcji := RD_LOC_T(OUT => Moj_Czas_Struktura);  
Godzina_system := Moj_czas_struktura.HOUR;  

Tryb_nocny := (Godzina_system >= 18) OR (Godzina_system < 6);  
Poziom_CO2 := (INT_TO_REAL(Sygnal_CO2_RAW) / 27648.0) * 2000.0;  

// logika sterowania
IF Tryb_nocny THEN
    Wydajnosc_nawiew := 10.0;
ELSE
    // praca dzienna uzalezniona od ilosci CO2
    IF Poziom_CO2 > 1000.0 THEN  // duze stezenie CO2, bardzo wysokie --> mocne wietrzenie
        Wydajnosc_nawiew := 100.0;
    ELSIF Poziom_CO2 > 700.0 THEN   // podwyzszone stezenie CO2, zwiekszona wentylacja
        Wydajnosc_nawiew := 75.0;
    ELSE
        Wydajnosc_nawiew := 50.0;  // standardowy poziom CO2, normalna wentylacja
    END_IF;
    
END_IF;
