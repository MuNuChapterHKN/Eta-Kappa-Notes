import os
from pathlib import Path
import yaml
import json
from jsonschema import validate, ValidationError

import path_variables

def validate_metadata(notes_dir, metadata_filename, schema_file):
    with open(schema_file, 'r', encoding='utf-8') as f:
        schema = json.load(f)

    errors = []
    for root, dirs, files in os.walk(notes_dir):
        root_path = Path(root)
        if metadata_filename in files:
            metadata_path = root_path / metadata_filename
            with open(metadata_path, 'r', encoding='utf-8') as f:
                metadata = yaml.safe_load(f)
            try:
                validate(instance=metadata, schema=schema)
            except ValidationError as e:
                errors.append(f"{metadata_path.as_posix()}: {e.message}")

    return errors

if __name__ == '__main__':
    errors = validate_metadata(
        path_variables.NOTES_DIR,
        path_variables.METADATA_FILENAME,
        path_variables.SCHEMA_FILE
    )
    if errors:
        print("❌ Validation errors found:")
        for err in errors:
            print(" -", err)
        exit(1)
    else:
        print(f"✅ All {path_variables.METADATA_FILENAME} files are valid")
