# Eta Kappa Notes

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Version](https://img.shields.io/badge/version-0.1.0-green.svg)](https://github.com/MuNuChapterHKN/Eta-Kappa-Notes)

**Eta Kappa Notes** is an academic note-taking project developed by the Mu Nu Chapter of IEEE-HKN at Politecnico di Torino. The project collects study notes for various university courses, providing high-quality resources for engineering students and beyond.

- [🎯 Goals](#goals)
- [🤝 Contributing](#contributing)
- [📚 Project Structure](#project-structure)
- [🚀 Installation and compilation](#installation-and-compilation)
- [⚖️ License](#license)
- [📞 Contact](#contact)
- [🧭 About us](#about-us)

## 🎯 Goals

- Provide quality notes for Politecnico di Torino courses
- Create a shared resource for the student community
- Standardize note formatting and structure
- Support both LaTeX and Typst for document composition

## 🤝 Contributing

We are always looking for new contributors!
See the **[`CONTRIBUTING.md`](CONTRIBUTING.md)** file for more information.

## 📚 Project Structure

The project is organized as follows:

- [**`notes/`**](notes/): class notes
- [**`guide/`**](guide/): a simple guide to get started with the project
- [**`lib/`**](lib/): templates
- [**`resources/`**](resources/): shared resources (images, diagrams, etc.)

## 🚀 Installation and compilation

### LaTeX

We encourage using the **[LaTeX Workshop](https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop) VS Code extension**.
In order to use it you need a TeX installation (see https://github.com/James-Yu/LaTeX-Workshop/wiki/Install).
They "*strongly recommend **TeX Live***".

You may also need **Inkscape**.

> [!TIP]
> If VS Code is not your code editor of choice, you can mimic the intended compilation by reproducing the `latexmk` tool in [`.vscode/settings.json`](.vscode/settings.json).

### Typst

Version 0.12.0 or higher, see https://typst.app/

Compile with
``` bash
typst compile typst/guide.typ
```

### Python

In case you want to create figures with Python, use Python 3.x with dependencies from [`requirements.txt`](requirements.txt).

For example, to create a **virtual environment** on Windows, run the following from the project root:

``` powershell
python -m venv .venv
.\.venv\Scripts\activate
pip install -r requirements.txt
```

## ⚖️ License

This repository contains both source code and textual content (class notes), distributed under different licenses.

### Source code

The project's source code is **Copyright © 2024-2025 Erik Scolaro, Eduard Occhipinti, Giulio Cosentino**,
and is distributed under the [GNU GPL 3.0 or later](https://www.gnu.org/licenses/gpl-3.0.html).

See the [`COPYING`](COPYING) file for more details.

License notice:

    Copyright (C) 2024-2025 Erik Scolaro, Eduard Occhipinti, Giulio Cosentino
    SPDX-License-Identifier: GPL-3.0-or-later

    Eta-Kappa-Notes is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Eta-Kappa-Notes is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Eta-Kappa-Notes.  If not, see <https://www.gnu.org/licenses/>.

### Notes

The notes (in the `notes/` directory) and the guide (in the `guide/` directory) are distributed under the [Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International](https://creativecommons.org/licenses/by-nc-nd/4.0/).

Credit for the notes must be attributed to the **authors and editors** of each respective document.

## 📞 Contact

- **Project manager:** responsabile.publishing@hknpolito.org (italian language is preferred in emails)
- **GitHub repository:** [MuNuChapterHKN/Eta-Kappa-Notes](https://github.com/MuNuChapterHKN/Eta-Kappa-Notes/)

## 🧭 About us

- **Mu Nu Chapter:** [hknpolito.org](https://hknpolito.org/) (website), [@hknpolito](https://www.instagram.com/hknpolito/) (instagram)
- **IEEE-Eta Kappa Nu:** [hkn.ieee.org](https://hkn.ieee.org/)
- **Politecnico di Torino:** [polito.it](https://www.polito.it/)
