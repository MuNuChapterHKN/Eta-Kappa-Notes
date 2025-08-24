import os
from pathlib import Path
import yaml
import json

import path_variables

def collect_metadata(notes_dir, metadata_filename):
    index = []
    for root, dirs, files in os.walk(notes_dir):
        root_path = Path(root)
        if metadata_filename in files:
            metadata_path = root_path / metadata_filename
            with open(metadata_path, 'r', encoding='utf-8') as f:
                metadata = yaml.safe_load(f)

            metadata["path"] = root_path.as_posix()
            index.append(metadata)
    return index

if __name__ == '__main__':
    index = collect_metadata(
        path_variables.NOTES_DIR,
        path_variables.METADATA_FILENAME
    )
    # Use newline='\n' to ensure lf line ending
    with open(path_variables.INDEX_PATH, 'w', encoding='utf-8', newline='\n') as f:
        json.dump(index, f, indent=2, ensure_ascii=False)
        f.write('\n')
    print(f"✅ {path_variables.INDEX_PATH.as_posix()} updated")
