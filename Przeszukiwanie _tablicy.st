VAR
    // tablica z danymi - 5 wartosci
    Licznik_Paczki : ARRAY[0..4] OF INT := [12, 45, 7, 23, 10]; 
    
    // zmienne 
    Max_Wartosc : INT;      // Ile paczek ma lider
    Lider_Stanowisko : INT; // Numer stanowiska-lidera
    
    // zmienne pomocnicze
    i : INT;                // Licznik do pętli
END_VAR

//poszukiwanie najwiekszej wartosci
Max_Wartosc := 0; // czyszczenie przed kazdym szukanie

FOR i := 0 TO 4 DO
    // wartosc wieksza niz dotychzawsowy max
    IF Licznik_Paczki[i] > Max_Wartosc THEN
        // wybranie najwieskzej wartosci
        Max_Wartosc := Licznik_Paczki[i];
        Lider_Stanowisko := i; // zapamietaj numer komorki
    END_IF;
END_FOR;
