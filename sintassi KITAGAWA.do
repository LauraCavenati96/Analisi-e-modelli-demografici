*modifiche file popolazione

import excel "C:\Users\Laura\Google Drive (l.cavenati1@campus.unimib.it)\MAGISTRALE\2 anno\2 semestre\analisi dei modelli demografici\lavoro di gruppo lab1 lab2\popolazione_2001_2019.xls", sheet("popolazione_input") firstrow clear

cd "C:\Users\Laura\Google Drive (l.cavenati1@campus.unimib.it)\MAGISTRALE\2 anno\2 semestre\analisi dei modelli demografici\lavoro di gruppo lab1 lab2"

rename Eta eta
drop if eta<15

recode eta (15/24=1) (25/44=2) (45/64=3) (65/110=4), generate(cla_eta)
label variable cla_eta "classi età"
label define cla_eta 1 "15-24 anni" 2 "25-44 anni" 3 "45-64 anni" 4 "65+ anni" 
*label value cla_eta cla_eta 

collapse (sum) M* F* T*, by (cla_eta)

reshape long M F T, i(cla_eta) j(anno)

*per avere una sola colonna con la popolazione applichiamo una seconda volta reshape
*prima devo rinominare la variabile perchè per funzionaer reshape 
*il nome della variabile deve essere var1....varn
rename M pop1 
rename F pop2
rename T pop3

reshape long pop, i(cla_eta anno) j(genere)

sort anno genere cla_eta



*salvo i risultati
save popolazione_2001_2019_per_cla_eta, replace

erase  popolazione_2001_2019_per_cla_eta.xls
*esporto i risultati in Excel
export excel using "popolazione_2001_2019_per_cla_eta", firstrow(variables)













*modifiche file tassi
 import excel "C:\Users\Laura\Google Drive (l.cavenati1@campus.unimib.it)\MAGISTRALE\2 anno\2 semestre\analisi dei modelli demografici\lavoro di gruppo lab1 lab2\soddisfazione - età, genere.xlsx", sheet("tassi") firstrow clear


*assegno etichette alle classi
label variable cla_eta "classi età"
label define cla_eta 1 "15-24 anni" 2 "25-44 anni" 3 "45-64 anni" 4 "65+ anni" 
label value cla_eta cla_eta 

label define genere 1 "M" 2 "F" 3 "T"
label value genere genere

*grafico totale

drop if anno==2004
*grafico totale
twoway line molto_abbastanza anno if genere==3 & cla_eta==5, sort xtitle(anno indagine)

*grafico per classi d'età
*faccio mean ma è solo un valore!!!! (forse c'è modo migliore ma non so!!!!)
egen per_1=mean(molto_abbastanza) if cla_eta==1 & genere==3, by(anno)
egen per_2=mean(molto_abbastanza) if cla_eta==2 & genere==3, by(anno)
egen per_3=mean(molto_abbastanza) if cla_eta==3 & genere==3, by(anno)
egen per_4=mean(molto_abbastanza) if cla_eta==4 & genere==3, by(anno)

twoway line per_1 per_2 per_3 per_4 anno, sort xtitle(anno indagine)

*grafico totale f/m
egen per_m=mean(molto_abbastanza) if genere==1 & cla_eta==5, by(anno)
egen per_f=mean(molto_abbastanza) if genere==2 & cla_eta==5, by(anno)

twoway line per_m per_f anno, sort xtitle(anno indagine)
