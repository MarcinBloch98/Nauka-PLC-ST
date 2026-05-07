VAR
    niskiPoziomWody   : BOOL; // wykrycie niskiego poziomu wody w zbiorniku
    kolejPompy1       : BOOL := TRUE; // pamiec ktora pompa ma dzialac
    zboczeNiskiPoziom : R_TRIG; // zbocze wykrywajace niski poziom
    
    Pompa_1           : BOOL; // stycznik sterujacy pompa #1
    Pompa_2           : BOOL; // stycznik sterujacy pompa #2
END_VAR

// wkrycie niskiego poziomu wody w zbiorniku
zboczeNiskiPoziom(CLK := niskiPoziomWody);

// wykryto zbocze, zmien priorytet pomp
IF zboczeNiskiPoziom.Q THEN
    kolejPompy1 := NOT kolejPompy1; 
END_IF;

// sterowanie pompami - pompa pracuje gdy jest niski poziom wody oraz jest jej kolej do pracy
Pompa_1 := niskiPoziomWody AND kolejPompy1;
Pompa_2 := niskiPoziomWody AND NOT kolejPompy1;
