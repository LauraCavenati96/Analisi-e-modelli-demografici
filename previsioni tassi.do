import excel "C:\Users\Laura\Google Drive (l.cavenati1@campus.unimib.it)\MAGISTRALE\2 anno\2 semestre\analisi dei modelli demografici\lavoro di gruppo lab1 lab2\soddisfazione - età, genere.xlsx", sheet("tassi") firstrow clear

cd "C:\Users\Laura\Google Drive (l.cavenati1@campus.unimib.it)\MAGISTRALE\2 anno\2 semestre\analisi dei modelli demografici\lavoro di gruppo lab1 lab2"


generate a=anno-2001
gen tasso=molto_abbastanza/100
drop molto abbastanza poco per_niente non_risponde molto_abbastanza

*creo le variabili tasso_2019 .... tasso_2040
for num 2019/2040 : generate tasso_X=.
*calcolo i valori del tasso: devo applicare la trasformazione sopra per ogni serie definita da genere e classe età (M 15-24, M 25-44..... F65+)
*sono 5 classi d'età quindi il ciclo 1....5

/*
Bisogna specificare un valore dei parametri  diverso per ciascuna classe età e per genere
(CIOE' PER CIASCUNA CLASSE D'ETA E GENERE HO UN P DIVERSO)
le previsioni sui tassi si basano solo sul minimo.. bah, misembra poco sensato
*/

bys genere cla_eta: egen P=min(tasso) 
generate k=1-P

sort a genere cla_eta

*Maschi
foreach num of numlist 1/5 {
*calcolo la trasformata z applico logistica e calcolo z
generate z= ln((k + P - tasso)/(tasso - P)) if cla_eta==`num' & genere==1
*faccio regressione di z
regress z a if cla_eta==`num' & genere==1
*salvo i risultati in una matrice m, dall'help di regress vedo che 
*Stored results
*regress stores the following in e():
*Matrices : e(b) coefficient vector
matrix m = e(b)
*estraggo il secondo elemento che è "a" e ne faccio exp per ottenere c 
*per prendere il secondo valore uso la funzione exp(m[1,2]) 
* [1,2] indicano la posizione: 1° riga e 2° colonna
generate c= exp(m[1,2])
*estraggo il primo parametro h=-b
generate h= -m[1,1]
*stimo i valori dei tassi usando i parametri appena stimati
for num 2019/2040 : replace tasso_X= P + (k/(1+ c *exp( -h *(X-2001)))) if cla_eta==`num' & genere==1
*elimino quello che non mi serve
drop z c h
}

*Femmine: ripetiamo quanto fatto sui maschi
foreach num of numlist 1/5 {
*applico logistica e calcolo z
generate z= ln((k + P - tasso)/(tasso - P)) if cla_eta==`num' & genere==2
*faccio regressione di z
regress z a if cla_eta==`num' & genere==2
*salvo i risultati in una matrice m
matrix m = e(b)
*estraggo il secondo elemento che è a e ne faccio exp per ottenere c 
generate c= exp(m[1,2])
*estraggo il primo parametro b=-h
generate h= -m[1,1]
*stimo i valori dei tassi usando i parametri appena stimati
for num 2019/2040 : replace tasso_X= P + (k/(1+ c *exp( -h *(X-2001)))) if cla_eta==`num' & genere==2
drop z c h
}

*Totale
foreach num of numlist 1/5 {
*applico logistica e calcolo z
generate z= ln((k + P - tasso)/(tasso - P)) if cla_eta==`num' & genere==3
*faccio regressione di z
regress z a if cla_eta==`num' & genere==3
*salvo i risultati in una matrice m
matrix m = e(b)
*estraggo il secondo elemento che è a e ne faccio exp per ottenere c 
generate c= exp(m[1,2])
*estraggo il primo parametro b=-h
generate h= -m[1,1]
*stimo i valori dei tassi usando i parametri appena stimati
for num 2019/2040 : replace tasso_X= P + (k/(1+ c *exp( -h *(X-2001)))) if cla_eta==`num' & genere==3
drop z c h
}

*teniamo solo quello che serve
keep genere cla_eta tasso_*

*al momento ho molti record duplicati, li elimino
duplicates drop genere cla_eta, force

*a questo punto abbiamo stimato i tassi variabili

*per potere calcolare le previsioni dobbiamo ristrutturare il dataset in modo diverso
*vogliamo che tasso_2020 tasso_2040 diventino una sola variabile e vogliamo 
*aggiungere una variabile che indichi anno.

reshape long tasso_ , i(cla_eta genere) j(a)
*rinomino la variabile tasso_ in tasso
rename tasso_ tasso_variabile
rename a anno
*ordino i record per anno genere e classe età
sort anno genere cla_eta 


*AGGIUNGO TASSI FISSI!!
*calcolo delle previsioni a tassi fissi:

* in certi casi è più prudente prendere come tassi fissi la media mobile degli ultimi tre anni con pesi 1/5 1/5 3/5

*M calcolati io manualmente!in excel!!!
generate tasso_fisso= 0.7468 if cla_eta==1 & genere==1
replace tasso_fisso= 0.778  if cla_eta==2 & genere==1
replace tasso_fisso= 0.7636 if cla_eta==3 & genere==1
replace tasso_fisso= 0.7624 if cla_eta==4 & genere==1
replace tasso_fisso= 0.7694 if cla_eta==5 & genere==1

*F calcolati io manualmente!in excel!!!
replace tasso_fisso= 0.7674 if cla_eta==1 & genere==2
replace tasso_fisso= 0.7798 if cla_eta==2 & genere==2
replace tasso_fisso= 0.7738 if cla_eta==3 & genere==2
replace tasso_fisso= 0.7418 if cla_eta==4 & genere==2
replace tasso_fisso= 0.7754 if cla_eta==5 & genere==2

*T calcolati io manualmente!in excel!!!
replace tasso_fisso= 0.756  if cla_eta==1 & genere==3
replace tasso_fisso= 0.779  if cla_eta==2 & genere==3
replace tasso_fisso= 0.768  if cla_eta==3 & genere==3
replace tasso_fisso= 0.7562 if cla_eta==4 & genere==3
replace tasso_fisso= 0.772  if cla_eta==5 & genere==3

*questo è il file finale con i tassi
save previsioni_tassi, replace

*grafico totale f/m
egen per_m=mean(tasso_variabile) if genere==1 & cla_eta==5, by(anno)
egen per_f=mean(tasso_variabile) if genere==2 & cla_eta==5, by(anno)

egen per_m_fisso=mean(tasso_fisso) if genere==1 & cla_eta==5, by(anno)
egen per_f_fisso=mean(tasso_fisso) if genere==2 & cla_eta==5, by(anno)
twoway line per_m per_f per_m_fisso per_f_fisso anno, sort xtitle(anno indagine)


save "C:\Users\Laura\Google Drive (l.cavenati1@campus.unimib.it)\MAGISTRALE\2 anno\2 semestre\analisi dei modelli demografici\lavoro di gruppo lab1 lab2\previsioni_tassi.dta", replace
