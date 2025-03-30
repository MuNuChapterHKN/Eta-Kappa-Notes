#!/bin/bash

# Controllo che siano stati forniti due argomenti
if [ $# -ne 2 ]; then
    echo "Uso: $0 <cartella_sorgente> <cartella_destinazione>"
    exit 1
fi

# Assegno gli input a variabili
source_folder="$1"
dest_folder="$2"

# Controllo che la cartella di origine esista
if [ ! -d "$source_folder" ]; then
    echo "La cartella sorgente non esiste: $source_folder"
    exit 1
fi

# Se la cartella di destinazione non esiste, la creo
if [ ! -d "$dest_folder" ]; then
    echo "La cartella destinazione non esiste, la creo: $dest_folder"
    mkdir -p "$dest_folder"
fi

# Itero su tutte le sottocartelle nella cartella di origine
for subfolder in "$source_folder"/*/; do
    if [ -d "$subfolder" ]; then
        # Estrai il nome della sottocartella (senza il percorso completo)
        subfolder_name=$(basename "$subfolder")

        # Crea una sottocartella con lo stesso nome nella cartella di destinazione
        mkdir -p "$dest_folder/$subfolder_name"
        echo "Creata la cartella: $dest_folder/$subfolder_name"
    fi
done

echo "Operazione completata."
