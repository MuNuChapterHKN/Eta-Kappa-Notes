import os
import subprocess

# Ottieni il percorso della cartella contenente questo script
scripts_folder = os.path.dirname(__file__)

# Ottieni tutti i file .py nella cartella
python_files = [f for f in os.listdir(scripts_folder) if f.endswith('.py') and f != os.path.basename(__file__)]

# Esegui ogni script
for script in python_files:
    script_path = os.path.join(scripts_folder, script)
    print(f"Eseguendo {script_path}...")
    subprocess.run(["python", script_path])  # Esegui lo script
    print(f"{script} eseguito con successo.")
