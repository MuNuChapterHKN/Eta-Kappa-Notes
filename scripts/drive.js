import fs from "fs";
import { google } from "googleapis";

const auth = new google.auth.OAuth2(process.env.GOOGLE_CLIENT_ID, process.env.GOOGLE_CLIENT_SECRET);
auth.setCredentials({ refresh_token: process.env.GOOGLE_REFRESH_TOKEN });
export const drive = google.drive({ version: "v3", auth });

export async function getOrCreateFolder(name, parentId) {
    const res = await drive.files.list({
        q: `name='${name}' and mimeType='application/vnd.google-apps.folder' and '${parentId}' in parents and trashed=false`,
        fields: "files(id)",
    });
    if (res.data.files.length > 0) return res.data.files[0].id;
    const created = await drive.files.create({
        requestBody: { name, mimeType: "application/vnd.google-apps.folder", parents: [parentId] },
        fields: "id",
    });
    return created.data.id;
}

export async function uploadFile(filePath, fileName, folderId) {
    const existing = await drive.files.list({
        q: `name='${fileName}' and '${folderId}' in parents and trashed=false`,
        fields: "files(id)",
    });

    const media = { mimeType: "application/pdf", body: fs.createReadStream(filePath) };

    let fileId;
    if (existing.data.files.length > 0) {
        fileId = existing.data.files[0].id;
        await drive.files.update({ fileId, media, fields: "id" });
    } else {
        const created = await drive.files.create({
            requestBody: { name: fileName, mimeType: "application/pdf", parents: [folderId] },
            media,
            fields: "id",
        });
        fileId = created.data.id;
    }

    await drive.permissions.create({
        fileId,
        requestBody: { role: "reader", type: "anyone" },
    });

    const { data } = await drive.files.get({ fileId, fields: "webViewLink" });
    return { id: fileId, webViewLink: data.webViewLink };
}
