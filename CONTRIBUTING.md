# Contributing

**Thank you for considering contributing to this repository!**

- [🤝 Ways of contributing](#-ways-of-contributing)
- [✍️ How to create new notes](#-how-to-create-new-notes)
  - [Workspace setup](#workspace-setup)
  - [Notes directory](#notes-directory)
- [🔄 Repository workflow](#-repository-workflow)
  - [Branches](#branches)
  - [Merges](#merges)
  - [Roles](#roles)
  - [Commits](#commits)

## 🤝 Ways of contributing

✍️ **Create new notes**: see the [section below](#-how-to-create-new-notes).

🔧 **Improve existing ones**: fork the repository and create a pull request.

❗**Report errors** or 💡**make suggestions**:

- [Contact the project manager](README.md#-contact), or
- [Create a GitHub Issue](https://github.com/MuNuChapterHKN/Eta-Kappa-Notes/issues/new), or
- Fork the repository and create a pull request

## ✍️ How to create new notes

### Workspace setup

1. Choose a course for which you will take notes.
2. [Tell the project manager](README.md#-contact)
3. The project manager will create a branch and tell you to fork it.

### Notes directory

Inside `notes/`:
- delete the `.gitkeep` file;
- create a folder `<notes-name>/` with the same name as your branch.

From this points on, this guide only applies to LaTeX notes.

You will organize your notes inside it using the following structure:

<!-- https://asciitools.com/tree?trailingDirSlash=true&fullPath=false&rootDot=false -->
    notes/
    └── notes-name/
        ├── chapters/
        ├── res/
        │   ├── drawio/
        │   ├── ggb/
        │   ├── py/
        │   ├── svg/
        │   └── ...
        ├── main.tex
        └── metadata.yaml

- `main.tex` will be the main file that gathers the various chapters.
  See [below](#main-file) for the template.
- `metadata.yaml` is a metadata file you’ll fill in as shown [below](#metadata-file).
- `chapters/` contains the `.tex` files that make up your chapters.
  Give these files appropriate names.
  If necessary, you can further organize them into subfolders.
  See [below](#chapter-files) for the template.
- `res/` and its subfolders are all optional and contain files associated with images you’ll include in your notes.
  In particular:
  - `drawio/` will contain Draw.io images in `.drawio.svg` format.
  - `ggb/` will contain GeoGebra projects (`.ggb` extension).
  - `py/` will contain Python scripts (`.py` extension).
  - `svg/` will contain SVG images, e.g. exported from GeoGebra.
  You can freely create other subfolders for different image types (e.g. PNG); just try to maintain good organization.

When compiling the PDF, a `build/` folder will be automatically generated, and if you’ve used SVG files, also an `svg-inkscape/` folder.
The output PDF will be located at `build/main.pdf`.

#### Metadata file

Fill out `metadata.yaml` following this example:

```yaml
course_code: "AB1CDE2"
course_name: "Course name"
teacher: "Surname, Name"
start_academic_year: 2025
program_level: "bachelor"
program: "Name of Degree Program"
language: "ita"
formats:
  - "latex"
authors:
  - "Surname, Name"
  - "Surname, Name"
editors: []
```

- `teacher` is the course teacher.
- `program_level` is either `bachelor` or `master`.
- `program` is the name of the degree program, in English.
- `language` can be `ita` or `eng`.
- `formats` is a list with elements among `latex`, `typst`, and `markdown`.
- The names in `teacher`, `authors`, and `editors` must follow the `Surname, Name` format.
- The `editors` field should initially be an empty list (`[]`). Later, if needed, it will be filled in like `authors`.

#### Main file

This is the template for `main.tex`:

``` latex
% !TEX root = main.tex

\documentclass[italian]{HKNdocument}

% Add here your custom packages and commands

\title{}
\shorttitle{}
\author{}
\docdate{First semester 2025/2026}
\docversion{1.0}

\begin{document}

\include{chapters/first-chapter}
\include{chapters/second-chapter}

\end{document}
```

- The comment `% !TEX root = main.tex` on the first line is not just a comment, but it indicates that this is the main file of the folder and the one that should be compiled.

- Set the language (`italian` or `english`) as an option in `\documentclass`.

- Where indicated, you can import your own packages and define your commands.

- Fill in `\title`, `\shorttitle`, `\author`, and `\docdate`.
  - `\title` is the course name.
  - `\shorttitle` helps avoid title overflow into the page margin graphics.
  - `\docdate` indicates the semester and academic year.

- The actual content will be included using lines like `\include{chapters/first-chapter}` (replace `first-chapter` with your chapter's `.tex` filename, extension optional).

  If some chapters are inside subfolders of `chapters/`, specify the correct path, for example `\include{chapters/subdirectory/first-chapter}`.

#### Chapter files

Chapter files begin with the following line:

``` latex
\chapter[Short chapter title]{Full chapter title}
```

The option in `[ ]` is only needed for chapters with long titles and can be omitted if unnecessary.

After that comes the actual content, divided into `\section`, etc.

## 🔄 Repository workflow

> [!NOTE]
> This section is intended for maintainers.

The repository workflow is designed to address the following goals:
- The students who write notes should be able **not to care** about the repository if not for the commits, the maintainers should manage everything.
- The students should work in a **clean branch**.
- Updates to the released PDFs should **not be too frequent**.

### Branches

- `main`: branch with all the notes, the index, and the compiled PDFs.
- `structure`: just as the main, but without notes, index, and PDFs (only repository structure and templates)
- `feat/*` and `fix/*` feature branches: created from `structure`, merge into `structure`
- `notes/*` notes branches: created from `structure`, do not contain the notes of other courses

### Merges

- feature branches $\to$ `structure`
- `structure` $\to$ `main` (to update templates, etc.)
- notes branches $\to$ `main` (to update the notes content)
- `structure` $\to$ notes branches (preferably rarely, case \*)

Some commits of `main` may be tagged and correspond to published versions.

Publication is not automated.

### Roles

#### Repository maintainers...

- Develop in `structure`, possibly through feature branches
- Manage all merges
- Create the notes branches

  Naming convention: `notes/<course-name>-<teacher-surname>`, where the course name is in the appropriate language, lowercase, with words joined by hyphens and with numbers instead of I, II, etc.

  Examples: `notes/fisica-2-pirri`, `notes/fisica-dello-stato-solido-di-fabrizio`
- Tell those writing notes to perform a `git pull` (case \*)

#### Notes writers...

- Only use their own notes branch
- Perform a `git pull` when asked (case \*)

### Commits

Commits should be **atomic** and focused on single changes.

For commit messages:
- Please follow [**Conventional Commits 1.0.0**](https://www.conventionalcommits.org/en/v1.0.0/), but
  - omit the scope
  - introduce the commit type `notes:` for addition of notes content.
- Consider following the **50/72 Rule**
