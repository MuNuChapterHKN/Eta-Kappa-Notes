#import "lib/template.typ": degree-template

#show: degree-template.with(
  title: [Guide],
  release: "0.1.0",
  show-outline: false,
  authors: ("Eduard Antonovic Occhipinti, ", "Erik Scolaro"),
)

= HKNotes - Guide

== Introduction

Each block of notes should be structured as follows:

```
.
└── mathematical_analysis_1
    ├── eng
    └── ita
        ├── chapters
        │   └── 01_introduction.typ
        ├── main.typ
        ├── res
        │   ├── imgs
        │   │   ├── diagram.drawio.svg
        │   │   └── example.svg
        │   └── py
        │       └── example.py
        └── works.bib
```

Where:

- *mathematical_analysis_1*: is the name of the course you are currently taking notes for.
  - *ita/eng*: codifies the language of the notes, in our example we have filled in the Italian section but the english one should have the same structure.
    - *chapters*: divide each chapter into a separate file. The naming should be prepended with the chapter number with two digits.
    - *`main.typ`*: the main file that includes all the chapters.
    - *res*: contains all the resources used in the notes.
      - *imgs*: contains all the images used in the notes. They should all be in SVG format where possible, avoid including as `pdf`, use `png` only if strictly necessary.
      - *py*: contains all the python scripts used in the notes, for example to generate an svg image.
    - *`works.bib`*: contains all the works cited in the notes.

== Citations

If you are citing an external source, add the citation in the `works.bib` file.

In Typst to cite a source you use the `@` symbol followed by the key of the source. The syntax is the same for citing sections, figures, tables or equations.

To add a citation, instead append your identifier, surrounded by angled brackets, at the end of the line. For example, to add a label named "einstein" to the following equation:

$
  E = m c^2
$ <einstein>

You would write:

```typ
$
  E = m c^2
$ <einstein>
```

And you would cite it like this:

```typ
The famous equation by Einstein is shown in @einstein.
```

The famous equation by Einstein is shown in @einstein.

Like in LaTeX, the `&` operator can be used for alignment of equations in Typst. For example, the following code:

```typ
$
  angle.l a, b angle.r &= arrow(a) dot arrow(b) \
                       &= a_1 b_1 + a_2 b_2 + ... a_n b_n \
                       &= sum_(i=1)^n a_i b_i. #<sum>
$ <dot-product>
```

Will produce the following output:

$
  angle.l a, b angle.r &= arrow(a) dot arrow(b) \
                       &= a_1 b_1 + a_2 b_2 + ... a_n b_n \
                       &= sum_(i=1)^n a_i b_i. #<sum>
$ <dot-product>

As we can see we can also quote separate parts of the equation and cite it in the standard fashion, "like we see in @sum for @dot-product".

== Code

Inserting code follows the markdown syntax, for example to write the following cell:

```python
def f(x):
    return x**2
```

You would write:

#raw("```python\ndef f(x):\n    return x**2\n```", lang: "typ")

== Images

To include an image in Typst, you can simply use the `image` function. For example:

```typ
#image("res/imgs/diagram.drawio.svg")
```

I would, however, recommend always wrapping the image in a `figure` function to decorate it with a caption and, eventually, a label. For example:

```typ
#figure(
  image("res/imgs/diagram.drawio.svg"),
  caption: "A diagram of the system"
) <diagram>
```

=== Images generated with a Python script

When writing a script in Python always initialize a virtual environment first initialized from the `requirements.txt` file. This is done to make each script reproducible.

To do so first create a virtual environment with the following command:

```bash
python3 -m venv .venv
```

Then activate the virtual environment with the following command:

```bash
source .venv/bin/activate
```

Or in Windows:

```powershell
.\.venv\Scripts\activate
```

Then install the requirements with the following command:

```bash
pip install -r requirements.txt
```
