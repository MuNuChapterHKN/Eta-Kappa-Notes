import { createDirectus, rest, staticToken, createItem, readItems, updateItem } from "@directus/sdk";

export const directus = createDirectus(process.env.DIRECTUS_URL)
    .with(staticToken(process.env.DIRECTUS_TOKEN))
    .with(rest());

export async function upsertNotebook(yml) {
    const existing = await directus.request(
        readItems("notebook", { filter: { code: { _eq: yml.code } }, limit: 1 })
    );

    const payload = {
        name: yml.name,
        teacher: yml.teacher,
        program_level: yml.program_level,
        start_academic_year: yml.start_academic_year,
        semester: yml.semester,
        translations: [
            { languages_code: "it-IT", program: yml.program },
            { languages_code: "en-US", program: yml.program_en },
        ],
    };

    let res;

    if (existing.length > 0)
        res = await directus.request(updateItem("notebook", existing[0].code, payload));
    else
        res = await directus.request(createItem("notebook", { code: yml.code, ...payload }));

    return res;
}

export async function upsertNote(notebookId, href, completed) {
    const existing = await directus.request(
        readItems("note", { filter: { notebook: { _eq: notebookId } }, limit: 1 })
    );

    const payload = { version: process.env.NOTES_VERSION, href, completed };

    if (existing.length > 0) {
        return directus.request(updateItem("note", existing[0].id, payload));
    } else {
        return directus.request(createItem("note", { notebook: notebookId, ...payload }));
    }
}
