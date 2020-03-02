# Decryptor

*Prezentarea implementarii:

   -Task1: 
    Am selectat adresa de dupa primul '\0' din ecx pentru a determina adresa
cheii. Am trimis-o ca parametru functiei xor_strings impreuna cu adresa ecx,
corespunzatoare sirului criptat. In xor_strings, salvez in registre adresele
primite ca parametru, si prin intermediul lor parcurg fiecare sir facand xor
caracter cu caracter, salvand la adresa corespunzatoare din sir, caracterul 
decriptat.

   -Task2:
    Am trimis ca parametru functiei rolling_xor, adresa sirului criptat.
In rolling_xor, parcurg sirul de la adresa primita ca parametru, salvand
fiecare caracter intr-un registru. In continuare efectuez xor intre 
caracterul urmator si cel salvat in registru, salvand la adresa urmatoare
caracterul decriptat.

   -Task3:
    Neabordat.
    
   -Task4:
    Neabordat.
    
   -Task5:
    Registrul eax va fi folosit pentru stocarea cheii. Incepem cu cheia 0 si
verificam daca xor de cheia curenta si litera curenta din sirul criptat din
ecx este egala cu 'f', respectiv urmatoare cu 'o', si asa mai departe pana 
cand obtinem cuvantul "force" in interiorul sirului. In acel moment oprim
cautarea cheii si apelam functia bruteforce_singlebyte_xor in care vom 
decripta sirul dat ca input.

   -Task6:
    Abordat, dar neterminat.
