import { z } from "zod";

export const NoteSchema = z.object({
    code: z.string(),
    name: z.string(),
    teacher: z.string(),
    program: z.string(),
    program_en: z.string(),
    program_level: z.enum(["bachelor", "master", "phd"]),
    start_academic_year: z.string().transform(Number),
    semester: z.string().transform(Number),
    completed: z.string().transform((v) => v != "false"),
});
