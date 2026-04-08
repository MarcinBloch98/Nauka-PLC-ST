VAR
    Wylacznik_ukladu    : BOOL;  // przcycisk bistabilny NC wylaczajacy brame
    Pilot_bramy         : BOOL;  // przycisk monostabilny NO otwierajacy brame
    Czujnik_ruchu_1     : BOOL;  // czujnik ruchu nr 1 w okolicach bramy
    Czujnik_ruchu_2     : BOOL;  // czujnik ruchu nr 2 w okolicach bramy
    Przycisk_serwisowy  : BOOL;  // przycisk NO monostabilny wlaczajacy swiatło na stałe
    Czujnik_CO2         : BOOL;  // czujnik wykrywajacy CO2 w powietrzu
    Potwierdzenie_went  : BOOL;  // potwierdzenie pracy wentylatora

    // --- WYJŚCIA (Fizyczne) ---
    Silnik_bramy        : BOOL;  // umozliwia wjazd samochodu
    Oswietlenie_bramy   : BOOL;  // oswietlenie bramy garazowej
    Wentylator          : BOOL;  // urzadzenie z podtrzymaniem
    Alarm_CO2           : BOOL; // czerwona lampka
    Alarm_Awaria_Went   : BOOL; // bład wentylatora/awaria wentylatora

    // --- BLOKI CZASOWE ---
    Timer_swiatlo       : TOF; // podtrzymanie światla po ruchu
    Timer_wentylator    : TOF; // podtrzymuje wietrzenie po zniknieciu gazu
    Timer_awaria_went   : TON; // odliczanie czasu na potwierdzenie pracy
END_VAR

// swiatlo reaguje na ruch, pdtrzymuje 30s po zniknieciu ruchu
Timer_swiatlo(IN := (Czujnik_ruchu_1 OR Czujnik_ruchu_2), PT := T#30s);

// wentylacja reaguje na gaz, trzyma 10s po oczyszczeniu powietrza
Timer_wentylator(IN := Czujnik_CO2, PT := T#10s);

// diagnostyka jeśli wentylator ma pracowac, a nie ma potwierdzenia przez 5s, a musi byc potwierdzenie
Timer_awaria_went(IN := Wentylator AND NOT Potwierdzenie_went, PT := T#5s);

// brama otwiera się z pilota, o ile nie ma gazu i system jest wlaczony
Silnik_bramy := Pilot_bramy AND NOT Czujnik_CO2 AND Wylacznik_ukladu;

// swiatlo: swieci gdy jest ruch (z podtrzymaniem), serwis, lub gdy brama pracuje
Oswietlenie_bramy := (Timer_swiatlo.Q OR Przycisk_serwisowy OR Silnik_bramy) AND Wylacznik_ukladu;

// wentylator pracuje na podstawie timera gazu
Wentylator := Timer_wentylator.Q AND Wylacznik_ukladu;

// alarmy
Alarm_CO2 := Czujnik_CO2; 
Alarm_awaria_went := Timer_awaria_went.Q;
