VAR
    // WEJŚCIA
    Czujnik_paczki       : BOOL; // Czujnik wykrywający paczki (NO)
    Stop_awaryjny_NC     : BOOL; // Przycisk awaryjny (NC - True gdy jest OK)
    Silownik_wrocil      : BOOL; // Czujnik krańcowy pozycji bazowej siłownika

    // WYJŚCIA
    Silnik_tasmy         : BOOL; // Napęd taśmociągu
    Silownik_zrzutu      : BOOL; // Wyjście na siłownik spychający

    // BLOKI FUNKCYJNE
    Licznik_paczek       : CTU;  // Blok zliczający
    Timer_zrzutu         : TP;   // Generator impulsu 2s dla siłownika
    
    // USTAWIENIA
    Limit_paczek         : INT := 6;
END_VAR

// Licznik paczek - licznik zwiększa się, gdy paczka przetnie czujnik, nastapi reset gdy zruci paczki do pakowania
Licznik_paczek(CU := Czujnik_paczki, 
               R := (Timer_zrzutu.Q = FALSE AND Licznik_paczek.Q), 
               PV := Limit_paczek);

// Gdy licznik zrzuci paczki to zacznie jest zrzucac, bedzie to trwalo 2 sekundy
Timer_zrzutu(IN := Licznik_paczek.Q, PT := T#2s);

// Sterowanie silnikiem od tasmy - tasma caly czas jedzie dopoki nie ma stopu, pelnego kartonu
Silnik_tasmy := Stop_awaryjny_NC AND NOT Licznik_paczek.Q AND NOT Timer_zrzutu.Q;

// Sterowanie silownikiem pakujacym paczki - gdy chce pakowac to trwa to mu dwie sekundy
Silownik_zrzutu := Timer_zrzutu.Q AND Stop_awaryjny_NC;
