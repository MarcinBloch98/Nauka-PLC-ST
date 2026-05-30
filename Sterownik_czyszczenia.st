VAR
    Start_czyszczenia    : BOOL;  // przycisk uruchomienia procedury mycia CIP
    Potwierdzenie_pompy  : BOOL;  // sygnal zwrotny prawidlowo pracujacej pompy
    
    Timer_etapu          : TON;   // timer mierzacy faze mycia
    Etap                 : INT;   // krok ukladu sekwencyjnego
    
    Zawor_wody_surowej   : BOOL;  // cewka zaworu podajacego wode do plukania wstepnego
    Zawor_srodka_chem    : BOOL;  // cewka zaworu podajacego goracy roztwor myjacy
    Zawor_wody_czystej   : BOOL;  // cewka zaworu podajacego wode do plukania koncowego
    Pompa_obiegowa_CIP   : BOOL;  // cewka pompy obiegowej podajacej wode przez rurociagi
END_VAR

CASE Etap OF
    0: // uklad czekajacy na sygnal
        IF Start_czyszczenia THEN
            Etap := 1; // przejscie do plukania wstepnego
        END_IF;
        
    1: // plukanie wstepne woda surowa
        IF Timer_etapu.Q THEN
            Etap := 2; // przejscie do mycia zasadniczego
        END_IF;
        
    2: // mycie goracym srodkiem czyszczacym
        IF Timer_etapu.Q THEN
            Etap := 3; // przejscie do koncowego plukania
        END_IF;
        
    3: // plukanie na koniec czysta woda
        IF Timer_etapu.Q THEN
            Etap := 0; // koniec calej sekwencji, uklad wraca do oczekiwania na sygnal
        END_IF;
END_CASE;

// przypisanie czasu dla kazdej z faz mycia
IF Etap = 1 THEN
    Timer_etapu(IN := Potwierdzenie_pompy, PT := T#15s);
ELSIF Etap = 2 THEN
    Timer_etapu(IN := Potwierdzenie_pompy, PT := T#30s);
ELSIF Etap = 3 THEN
    Timer_etapu(IN := Potwierdzenie_pompy, PT := T#20s);
ELSE
    Timer_etapu(IN := FALSE);
END_IF;

// sterowanie wyjsciami
Zawor_wody_surowej := (Etap = 1); // cewka zaworu otwartego podczas plukania wstepnego
Zawor_srodka_chem  := (Etap = 2); // cewka zaworu otwartego podczas mycia chemia
Zawor_wody_czystej := (Etap = 3); // cewka zaworu otwartego podczas plukania koncowego
Pompa_obiegowa_CIP := (Etap > 0); // pompa pracujaca w kazdym etapie mycia
