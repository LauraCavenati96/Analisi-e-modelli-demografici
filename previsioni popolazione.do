cd "C:\Users\Laura\Google Drive (l.cavenati1@campus.unimib.it)\MAGISTRALE\2 anno\2 semestre\analisi e modelli demografici\lavoro di gruppo lab1 lab2"

*serve la popolazione

import excel "C:\Users\Laura\Google Drive (l.cavenati1@campus.unimib.it)\MAGISTRALE\2 anno\2 semestre\analisi e modelli demografici\lavoro di gruppo lab1 lab2\Popolazione_ita_eta_genere.xlsx", sheet("ita-Popolazione_per_eta_-_Ripar") firstrow clear

*togliamo le ipotesi che non ci interessano
*drop pop_90_inf pop_80_inf pop_50_inf pop_90_sup pop_80_sup pop_50_sup 
*tolgo le colonne dei totali, si lavora separatamente per genere
*drop if genere==3
*elimino totale
drop if Eta=="Totale"

destring Eta, generate(eta)
drop Eta
*elimino i minori di 15 anni non ho i tassi
drop if eta<15


*definisco le etichette per la variabile genere
label define genere 1 "M" 2 "F" 3 "T"
label value genere genere
*ordino
sort anno genere eta


*prima di applicare i tassi dobbiamo ancora fare un'ultima operazione: raggruppare in classi
*creo una variabile classe eta
recode eta (15/24=1) (25/44=2) (45/64=3) (65/110=4), generate(cla_eta)
label variable cla_eta "classi età"
label define cla_eta 1 "15-24 anni" 2 "25-44 anni" 3 "45-64 anni" 4 "65+ anni" 
label value cla_eta cla_eta 

*per ogni classe d'età vogliamo un solo valore (il numero di persone per anno t classe_eta x e genere s)
* ovvero la somma dei record con stesso valore di genere anno e classe_eta
collapse (sum) pop_90_inf pop_80_inf pop_50_inf pop_mediano pop_50_sup pop_80_sup pop_90_sup, by (anno genere cla_eta)
*tengo solo gli anni che mi servono
keep if anno>=2019 & anno<=2040

*salvo
save previsioni_popolazione, replace