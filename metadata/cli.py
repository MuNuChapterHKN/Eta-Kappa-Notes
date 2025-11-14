import argh
import yaml
import pathlib

def verify():
    import jsonschema
    import sys
    schema_path = pathlib.Path(__file__).parent / 'metadata_schema.json'
    with open(schema_path) as f:
        schema = yaml.safe_load(f)

    notes_dir = pathlib.Path(__file__).parent.parent / 'notes'
    error_count = 0
    total_dirs = 0
    dirs_with_metadata = 0

    for subdir in notes_dir.iterdir():
        if not subdir.is_dir():
            continue
        total_dirs += 1
        yaml_file = subdir / 'metadata.yaml'
        if not yaml_file.exists():
            print(f"{subdir.name} skipped: no metadata.yaml")
            continue
        dirs_with_metadata += 1
        try:
            with open(yaml_file) as f:
                data = yaml.safe_load(f)
            jsonschema.validate(data, schema)
            print(f"{subdir.name} ok")
        except jsonschema.ValidationError as e:
            print(f"{subdir.name} error: {e.message}")
            error_count += 1
        except Exception as e:
            print(f"{subdir.name} error: {str(e)}")
            error_count += 1

    if error_count > 0:
        print(f"Found {error_count} errors. Checked {dirs_with_metadata} out of {total_dirs} notes.")
        sys.exit(1)
    else:
        print(f"All metadata files are valid. Checked {dirs_with_metadata} out of {total_dirs} notes.")

@argh.arg('--status', default='released')
def filter(status='released'):
    notes_dir = pathlib.Path(__file__).parent.parent / 'notes'
    for yaml_file in notes_dir.rglob('metadata.yaml'):
        try:
            with open(yaml_file) as f:
                data = yaml.safe_load(f)
            if data.get('status') == status:
                print(yaml_file.parent.name)
        except Exception:
            pass  # Skip invalid files

if __name__ == '__main__':
    argh.dispatch_commands([verify, filter])