"""
Visualizzazione di un grafico 3D con stile wireframe.
Il file SVG viene salvato automaticamente nella cartella predestinata.
"""
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import axes3d
import os

plt.style.use('_mpl-gallery')

# Dimensioni immagine in cm
width = 20
height = 20

# Nome del file SVG basato sul nome dello script
script_name = os.path.splitext(os.path.basename(__file__))[0]
file_name = f"{script_name}.svg"

# Cartella di destinazione (relativa alla posizione dello script)
folder_path = os.path.join(os.path.dirname(__file__), "../../res/svg")

# Crea la cartella di destinazione se non esiste
os.makedirs(folder_path, exist_ok=True)

# Genera i dati
X, Y, Z = axes3d.get_test_data(0.05)

# Crea il grafico
fig, ax = plt.subplots(subplot_kw={"projection": "3d"})
ax.plot_wireframe(X, Y, Z, rstride=10, cstride=10)

# Aggiungi etichette agli assi
ax.set(xlabel="Asse X", ylabel="Asse Y", zlabel="Asse Z")

# Imposta le dimensioni della figura in centimetri (1 cm = 0.393701 pollici)
cm_to_inch = 0.393701
fig.set_size_inches(width * cm_to_inch, height * cm_to_inch)

# Salva il grafico nella cartella di destinazione
output_path = os.path.join(folder_path, file_name)
plt.savefig(output_path, format="svg", bbox_inches="tight")

print(f"Grafico salvato in: {output_path}")

# Disabilitare quando compili tutti i file con run_all_scripts.py
#plt.show()

