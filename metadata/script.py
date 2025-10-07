import os
import sys
from pathlib import Path
import yaml
import json
import jsonschema

def main() -> None:
    """
    Metadata files are identified by the name metadata_filename and must be
    located within the notes_dir directory.

    Assume the scripts are run from the project root
    """
    metadata_filename = "metadata.yaml"
    notes_dir = Path("notes")
    index_path = Path("metadata") / "index.json"
    schema_file = Path("metadata") / "metadata_schema.json"

    schema = get_json_schema(schema_file)
    collected_metadata, errors = scan_metadata(
        metadata_filename, notes_dir, schema)
    index_updated = update_index(index_path, collected_metadata)

    github_output = os.getenv('GITHUB_OUTPUT')
    if github_output:
        with open(github_output, 'a', encoding='utf-8') as f:
            f.write(f"index_updated={str(index_updated).lower()}\n")

    if errors:
        sys.exit(1)
    sys.exit(0)

def get_json_schema(schema_file: Path) -> dict:
    with open(schema_file, 'r', encoding='utf-8') as f:
        schema = json.load(f)
    return schema

def validate_metadata_instance(metadata_yaml: dict,
        schema: dict) -> tuple[bool, str]:
    try:
        jsonschema.validate(instance=metadata_yaml, schema=schema)
    except jsonschema.ValidationError as e:
        return False, e.message
    else:
        return True, ""

def scan_metadata(metadata_filename: str, notes_dir: Path,
        schema: dict) -> tuple[list[dict], list[str]]:
    collected_metadata = []
    errors = []
    for root, dirs, files in os.walk(notes_dir):
        root_path = Path(root)
        if metadata_filename in files:
            metadata_path = root_path / metadata_filename
            with open(metadata_path, 'r', encoding='utf-8') as f:
                metadata = yaml.safe_load(f)

            is_valid, error = validate_metadata_instance(metadata, schema)
            if is_valid:
                metadata["path"] = root_path.as_posix()
                collected_metadata.append(metadata)
            else:
                notes = root_path.relative_to(notes_dir)
                errors.append(f"{notes.as_posix()}: {error}")

    if errors:
        print("❌ Validation errors found:")
        for error in errors:
            print(" -", error)
    else:
        print("✅ All metadata files are valid.")

    return collected_metadata, errors

def read_index(index_path: Path) -> list[dict]:
    if index_path.exists():
        with open(index_path, 'r', encoding='utf-8') as f:
            try:
                data = json.load(f)
            except json.JSONDecodeError:
                data = []
    else:
        data = []
    return data

def write_index(index_path: Path, data: list[dict]):
    with open(index_path, 'w', encoding='utf-8', newline='\n') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
        f.write('\n')

def update_index(index_path: Path, collected_metadata: list[dict]) -> bool:
    current_index_data = read_index(index_path)
    if current_index_data == collected_metadata:
        print("📄 Index already up to date.")
        return False
    write_index(index_path, collected_metadata)
    print("📄 Index updated.")
    return True

if __name__ == '__main__':
    main()
