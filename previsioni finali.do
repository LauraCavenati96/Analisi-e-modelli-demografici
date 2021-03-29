cd "C:\Users\Laura\Google Drive (l.cavenati1@campus.unimib.it)\MAGISTRALE\2 anno\2 semestre\analisi dei modelli demografici\lavoro di gruppo lab1 lab2"

*importazione dei tassi
use "C:\Users\Laura\Google Drive (l.cavenati1@campus.unimib.it)\MAGISTRALE\2 anno\2 semestre\analisi dei modelli demografici\lavoro di gruppo lab1 lab2\previsioni_tassi.dta"


*POTREI FARE ANCHE PER TOTALE!!!!!!
merge 1:1 anno genere cla_eta using previsioni_popolazione
*elimino la variabile _merge
drop _merge
*togli se fai anche totale
*drop if cla_eta==5

*calcolo la previsione 90_inf CON TASSO FISSO e CON TASSO VARIABILE
generate pop_90_inf_fisso= pop_90_inf*tasso_fisso
generate pop_90_inf_variabile= pop_90_inf* tasso_variabile

*calcolo la previsione 80_inf CON TASSO FISSO e CON TASSO VARIABILE
generate pop_80_inf_fisso= pop_80_inf*tasso_fisso
generate pop_80_inf_variabile= pop_80_inf* tasso_variabile

*calcolo la previsione 50_inf CON TASSO FISSO e CON TASSO VARIABILE
generate pop_50_inf_fisso= pop_50_inf*tasso_fisso
generate pop_50_inf_variabile= pop_50_inf* tasso_variabile

*calcolo la previsione mediana CON TASSO FISSO e CON TASSO VARIABILE
generate pop_mediano_fisso= pop_mediano*tasso_fisso
generate pop_mediano_variabile= pop_mediano* tasso_variabile

*calcolo la previsione 50_sup CON TASSO FISSO e CON TASSO VARIABILE
generate pop_50_sup_fisso= pop_50_sup*tasso_fisso
generate pop_50_sup_variabile= pop_50_sup* tasso_variabile

*calcolo la previsione 80_sup CON TASSO FISSO e CON TASSO VARIABILE
generate pop_80_sup_fisso= pop_80_sup*tasso_fisso
generate pop_80_sup_variabile= pop_80_sup* tasso_variabile

*calcolo la previsione 90_sup CON TASSO FISSO e CON TASSO VARIABILE
generate pop_90_sup_fisso= pop_90_sup*tasso_fisso
generate pop_90_sup_variabile= pop_90_sup* tasso_variabile


*salvo i risultati
save previsioni_finali, replace

*una volta finito è bene eliminare tutti i file di lavoro generati che possono
*sempre essere rigenerati.
*per eliminare i file si usa erase.
erase  previsioni_finali.xls

*esporto i risultati in Excel
export excel using "previsioni_finali", firstrow(variables)