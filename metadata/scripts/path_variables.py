from pathlib import Path

# Metadata files are identified by the name METADATA_FILENAME and must be
# located within the NOTES_DIR directory.

# Assume the scripts are run from the project root

METADATA_FILENAME = "metadata.yaml"
NOTES_DIR = Path("notes")
INDEX_PATH = Path("metadata") / "index.json"
SCHEMA_FILE = Path("metadata") / "metadata_schema.json"
