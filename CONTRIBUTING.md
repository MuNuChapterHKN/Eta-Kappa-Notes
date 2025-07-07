# Contributing to the Notes repository

> **English Version** | [Versione Italiana](#🇮🇹-versione-italiana)

---

## 🇺🇸 English Version

Thank you for considering contributing to the notes repository. To do so, follow the steps outlined below.

### 🚀 Installation and Compilation

#### Prerequisites

- **For LaTeX**: Complete TeX distribution (TeX Live, MiKTeX)
- **For Typst**: [Typst](https://typst.app/) (version 0.12.0 or higher)
- **For Python**: Python 3.x with dependencies from `requirements.txt`

#### Installation

1. Clone the repository:
```bash
git clone https://github.com/MuNuChapterHKN/Eta-Kappa-Notes.git
cd Eta-Kappa-Notes
```

2. Install Python dependencies:
```bash
pip install -r requirements.txt
```

#### Compilation

**For LaTeX documents:**
```bash
cd latex/guide
latexmk -pdf guide.tex
```

**For Typst documents:**
```bash
typst compile typst/guide.typ
```

### 🤝 Contributing Process

1. Fork the repository
2. Clone **your** fork locally
3. Create a new branch that briefly describes the changes you are making
4. Push your changes to your fork
5. Create a pull request to the main repository

Pull requests should be atomic and focused on a single change. If you have multiple changes, please create multiple pull requests.

For maintainers, please follow the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) specification and squash commits before merging.

---

## 🇮🇹 Versione Italiana

Grazie per aver considerato di contribuire al repository delle note. Per farlo, segui i passaggi descritti di seguito.

### 🚀 Installazione e Compilazione

#### Prerequisiti

- **Per LaTeX**: Distribuzione TeX completa (TeX Live, MiKTeX)
- **Per Typst**: [Typst](https://typst.app/) (versione 0.12.0 o superiore)
- **Per Python**: Python 3.x con le dipendenze in `requirements.txt`

#### Installazione

1. Clona il repository:
```bash
git clone https://github.com/MuNuChapterHKN/Eta-Kappa-Notes.git
cd Eta-Kappa-Notes
```

2. Installa le dipendenze Python:
```bash
pip install -r requirements.txt
```

#### Compilazione

**Per documenti LaTeX:**
```bash
cd latex/guide
latexmk -pdf guide.tex
```

**Per documenti Typst:**
```bash
typst compile typst/guide.typ
```

### 🤝 Processo di Contribuzione

1. Fai un fork del repository
2. Clona **il tuo** fork localmente
3. Crea un nuovo branch che descriva brevemente le modifiche che stai apportando
4. Invia le tue modifiche al tuo fork
5. Crea una pull request al repository principale

Le pull request dovrebbero essere atomiche e focalizzate su una singola modifica. Se hai modifiche multiple, crea più pull request.

Per i maintainer, seguire la specifica [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) e fare squash dei commit prima del merge.
