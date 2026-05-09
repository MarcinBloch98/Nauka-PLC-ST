VAR
  stanAktualny               : stanPrasy;
  Przycisk_1                 : BOOL;  // pierwszy reczny przycisk uruchamiajacy prace ukladu
  Przycisk_2                 : BOOL;  // drugi reczny przycisk uruchamiajacy prace ukladu
  Dolna_krancowka_silownika  : BOOL;  // przelacznik krancowy wykrywajacy wysuniecie silownika
  Gorna_krancowka_silownika  : BOOL;  // przelacznik krancowy wykrywajacy wsuniecie silownika
  Timer_prasowanie           : TON;   // czas prasowania detalu
  Zawor_A                    : BOOL;  // zawor wysuwajacy prase w dol
  Zawor_B                    : BOOL;  // zawor wsuwajacy prase do gory
END_VAR

Timer_prasowanie(IN := Dolna_krancowka, PT := T#3S)

TYPE stanPrasy :
(
  OCZEKIWANIE
  RUCH_W_DOL
  PRASOWANIE
  RUCH_W_GORE
  ALARM
);
END_TYPE

CASE stanAktualny OF
    OCZEKIWANIE:
        Zawor_A := FALSE;
        Zawor_B := TRUE; // prasa czeka w górze
        
        // Warunek startu: Oba przyciski
        IF Przycisk_1 AND Przycisk_2 THEN
            stanAktualny := RUCH_W_DOL;
        END_IF;

    RUCH_W_DOL:
        Zawor_A := TRUE;  // Jedziemy w dół
        Zawor_B := FALSE;
        
        // oczekiwanie na stan wysoki od dolnej krancowki
        IF Dolna_krancowka_silownika THEN
            stanAktualny := PRASOWANIE;
        END_IF;

    PRASOWANIE:
        // wlaczamy timer (IN := TRUE)
        Timer_prasowanie(IN := TRUE, PT := T#3S);
        
        IF Timer_prasowanie.Q THEN
            Timer_prasowanie(IN := FALSE); // reset timera przed powrotem
            stanAktualny := RUCH_W_GORE;
        END_IF;

    RUCH_W_GORE:
        Zawor_A := FALSE;
        Zawor_B := TRUE; // powrot prasy do stanu poczatkowego
        
        IF Gorna_krancowka_silownika THEN
            stanAktualny := OCZEKIWANIE;
        END_IF;

    ALARM:
        Zawor_A := FALSE;
        Zawor_B := FALSE; // sytuacja awaryjna
END_CASE
