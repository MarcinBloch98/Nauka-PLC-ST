VAR
  tempNagrzewnicy : REAL;  // aktualna temperatura na powrocie wody z nagrzewnicy
  termostatBezpieczenstwa : BOOL;  // czujnik termostat bezpieczenstwa, TRUE jesli roznica temperatury powietrza a nagrzewnica spadnie ponizej 5 stopni
  wentNawiew : BOOL;  // sterowanie wentylatorem nawiewem
  zaworNagrzewnicy : BOOL;  // sterowanie zaworem nagrzewnicy
  alarm : BOOL;  // stan alarmu przeciwzamrozeniowego
END_VAR

IF (tempNagrzewnicy < 12.0) OR termostatBezpiecz THEN  // jesli niska temperatura wody lub sygnal z termostatu bezpieczenstwa
    alarm := TRUE;
END_IF;

IF (tempNagrzewnicy > 20.0) AND NOT termostatBezpiecz THEN  // warunek wylaczenia a - temp wody bezpeieczna i brak sygnalo z termostatBezpieczenstwa
    alarm := FALSE;
END_IF;

// co jesli jest alarm
IF alarm THEN  
    wentNawiew      := FALSE; // wyłącz wentylator zeby nie bylo mrozu
    zaworNagrzewnicy := TRUE;  // otworz zawor aby ogrzac wymiennik
ELSE
    // urzadzenia pracuja w trybie normalnym jesli nie ma alarmu
    wentNawiew      := TRUE;  
    zaworNagrzewnicy := FALSE; 
END_IF;
