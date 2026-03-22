import "dotenv/config";
import fs from "fs";
import path from "path";
import yaml from "js-yaml";
import { NoteSchema } from "./schema.js";
import { getOrCreateFolder, uploadFile } from "./drive.js";
import { upsertNotebook, upsertNote } from "./directus.js";

const ROOT_DIR = path.join(process.cwd(), "..");
const DRY = process.argv.includes("--dry");

const version = process.env.NOTES_VERSION;
const versionFolderId = DRY ? null : await getOrCreateFolder(version, process.env.GOOGLE_DIR_ID);

for (const subdir of fs.readdirSync(path.join(ROOT_DIR, "notes"))) {
    const compressed = path.join(ROOT_DIR, "build", `${subdir}-compressed.pdf`);
    const normal = path.join(ROOT_DIR, "build", `${subdir}.pdf`);

    if (!fs.existsSync(compressed) && !fs.existsSync(normal)) {
        console.warn(`  no pdf for ${subdir}, skipping`);
        continue;
    }

    const raw = yaml.load(fs.readFileSync(path.join(ROOT_DIR, "build", `${subdir}.yml`), "utf-8"));
    const yml = NoteSchema.parse(raw);

    console.log(subdir, yml);

    if (DRY) {
        if (fs.existsSync(compressed)) console.log(`  would upload ${compressed} → ${version}/${subdir}/compressed.pdf`);
        if (fs.existsSync(normal)) console.log(`  would upload ${normal} → ${version}/${subdir}/build.pdf`);
        console.log(`  would upsert notebook/note`);
        continue;
    }

    const courseFolderId = await getOrCreateFolder(subdir, versionFolderId);

    let href;
    if (fs.existsSync(compressed)) {
        const { webViewLink } = await uploadFile(compressed, "compressed.pdf", courseFolderId);
        href = webViewLink;
        console.log(`  uploaded compressed.pdf → ${webViewLink}`);
    }
    if (fs.existsSync(normal)) {
        const { webViewLink } = await uploadFile(normal, "build.pdf", courseFolderId);
        if (!href) href = webViewLink;
        console.log(`  uploaded build.pdf → ${webViewLink}`);
    }

    const notebook = await upsertNotebook(yml);
    console.log(`  notebook upserted (code: ${notebook.code})`);

    await upsertNote(notebook.code, href, yml.completed);
    console.log(`  note upserted`);
}
