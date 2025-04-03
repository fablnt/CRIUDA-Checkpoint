import time

import sys

# Stampa tutti gli argomenti
print("Argomenti:", sys.argv)

# Accedere agli argomenti
if len(sys.argv) > 1:
    print("Il primo argomento:", sys.argv[1])
    print("Il secondo argomento:", sys.argv[2] if len(sys.argv) > 2 else "Nessun secondo argomento")
else:
    print("Nessun argomento passato")


a = 0
while True:
    a+=1
    print(a)
    time.sleep(1)
