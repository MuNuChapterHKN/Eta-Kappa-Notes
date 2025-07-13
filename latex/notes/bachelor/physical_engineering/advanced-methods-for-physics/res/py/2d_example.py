"""
Visualizzazione di un grafico 3D con stile wireframe.
Il file SVG viene salvato automaticamente nella cartella predestinata.
"""
import matplotlib.pyplot as plt
import numpy as np
import os

# Dimensioni immagine in cm
width = 15
height = 5

# Nome del file SVG basato sul nome dello script
script_name = os.path.splitext(os.path.basename(__file__))[0]
file_name = f"{script_name}.svg"

# Cartella di destinazione (relativa alla posizione dello script)
folder_path = os.path.join(os.path.dirname(__file__), "../../res/svg")

# Crea la cartella di destinazione se non esiste
os.makedirs(folder_path, exist_ok=True)

# Genera i dati
t = np.arange(0.0, 2.0, 0.01)
s = 1 + np.sin(2 * np.pi * t)

# Crea il grafico
fig, ax = plt.subplots()
ax.plot(t, s)

# Aggiungi etichette agli assi
ax.set(xlabel='time (s)', ylabel='voltage (mV)',
       title='About as simple as it gets, folks')
ax.grid()

# Imposta le dimensioni della figura in centimetri (1 cm = 0.393701 pollici)
cm_to_inch = 0.393701
fig.set_size_inches(width * cm_to_inch, height * cm_to_inch)

# Salva il grafico nella cartella di destinazione
output_path = os.path.join(folder_path, file_name)
plt.savefig(output_path, format="svg", bbox_inches="tight")

print(f"Grafico salvato in: {output_path}")

# Disabilitare quando compili tutti i file con run_all_scripts.py
# plt.show()

