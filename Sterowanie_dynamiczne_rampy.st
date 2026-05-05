VAR
    rTargetBrightness  : REAL := 0.0;   // wartosc docelowa jasnosci lampy
    rActualInternal    : REAL := 0.0;   // biezacy poziom jasnosci
    rRampSpeed         : REAL := 0.5;   // szybkosc zmiany wartosci na raz - skok rampy
    
    iAnalogOut         : INT;  // wartosc wysylkana na wyjscie fizyczne
    iMaxRaw            : INT := 27648;  // rozdzielczosc przetwornika
END_VAR

// jesli roznica jest mniejsza niz krok to ustaw wartosc docelowa
IF ABS(rTargetBrightness - rActualInternal) < rRampSpeed THEN
    rActualInternal := rTargetBrightness;  

ELSIF rActualInternal < rTargetBrightness THEN
    rActualInternal := rActualInternal + rRampSpeed;  // w kazdym cyklu dodajemy maly kawalek jasnosci

ELSIF rActualInternal > rTargetBrightness THEN  // sprawdzenie czy jasnosc nie jest za duza
    rActualInternal := rActualInternal - rRampSpeed;
END_IF;

iAnalogOut := REAL_TO_INT((rActualInternal / 100.0) * INT_TO_REAL(iMaxRaw));  // zamiana wartosci 0100 na zakres 0-1.0

IF iAnalogOut > iMaxRaw THEN  // sprawdza czy wynik sie nie znalazl poza dopuszczalne wartosci
    iAnalogOut := iMaxRaw;  // nie pozwol wyjsc powyzej 27648
ELSIF iAnalogOut < 0 THEN
    iAnalogOut := 0;  // nie pozwala na wyjscie na wartosci ujemne
END_IF;
