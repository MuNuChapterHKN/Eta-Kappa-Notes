% HKNdocument.cls
% --------------------------
% This LaTeX class is derived from the base "book" class and offers:
% - Language control (italian or english)
% - Various levels of depth for the Table of Contents (ToC)
% - Configurable font size (10pt, 11pt, 12pt)
% - Customizable title page with author, date, version, logo
% - Custom headers and footers with author and short title
% - Numbering of figures, tables, and equations by chapter
% --------------------------

\NeedsTeXFormat{LaTeX2e} % Requires at least LaTeX2e
\ProvidesClass{HKNdocument}[2024/12/08 v1.5 Base class for publishing]

% --------------------------
% CLASS OPTIONS
% --------------------------
% Language: italian (default), english
%   - Sets the document language via the babel package.
%
% TOC (Table of Contents):
%   toc=chapters:   shows only chapters in the ToC (tocdepth=0)
%   toc=sections:   chapters and sections (tocdepth=1)
%   toc=subsections: up to subsections (default, tocdepth=2)
%   toc=subsubsections: up to sub-subsections (tocdepth=3)
%
% Font size:
%   10pt, 11pt (default), 12pt
%   Specifies the base font size of the document.

% Default values
\def\DocumentLanguage{italian} % Default language
\newcommand{\HK@tocdepth}{2}   % Default ToC depth: chapters, sections, subsections
\def\HK@classfontsize{12pt}    % Default font size

% --------------------------
% DECLARATION OF OPTIONS
% --------------------------

% Language options
\DeclareOption{italian}{\def\DocumentLanguage{italian}}
\DeclareOption{english}{\def\DocumentLanguage{english}}

% TOC options
\DeclareOption{toc=chapters}{\AtEndOfClass{\def\HK@tocdepth{0}}}
\DeclareOption{toc=sections}{\AtEndOfClass{\def\HK@tocdepth{1}}}
\DeclareOption{toc=subsections}{\AtEndOfClass{\def\HK@tocdepth{2}}}
\DeclareOption{toc=subsubsections}{\AtEndOfClass{\def\HK@tocdepth{3}}}

% Font size options
\DeclareOption{10pt}{\def\HK@classfontsize{10pt}}
\DeclareOption{11pt}{\def\HK@classfontsize{11pt}}
\DeclareOption{12pt}{\def\HK@classfontsize{12pt}}

% Process all options
\ProcessOptions\relax

% --------------------------
% LOADING THE BASE CLASS
% --------------------------
% Load the base book class, inheriting its structure
% and setting the determined options: font size, a4paper, twoside.
\LoadClass[\HK@classfontsize,a4paper,openany]{book}

% --------------------------
% BASE TYPOGRAPHY AND INPUT PACKAGES
% --------------------------
\RequirePackage[T1]{fontenc}    % T1 font encoding (better for European languages)
\RequirePackage[utf8]{inputenc} % UTF-8 input (supports direct accented characters)
\RequirePackage{lmodern}        % Latin Modern font (cleaner and scalable)

% --------------------------
% LANGUAGE SETTING
% --------------------------
% Load babel with the language chosen via the class option
\RequirePackage[\DocumentLanguage]{babel}

% --------------------------
% DOCUMENT LAYOUT
% --------------------------
\RequirePackage[a4paper,margin=3cm]{geometry}
% Set margins and page size to A4 with 3cm margins.
% Modifiable as desired.

% --------------------------
% FANCYHDR FOR CUSTOM HEADERS AND FOOTERS
% --------------------------
\RequirePackage{fancyhdr}
\pagestyle{fancy}
% We will set headers and footers after defining commands for author and short title.

% --------------------------
% COMMANDS FOR TITLE, AUTHOR, SHORT TITLE, DATE, VERSION, LOGO
% --------------------------
% These commands will be redefined by the user in the main document preamble.
% \title, \author: standard LaTeX definitions, here we capture them to save the data.
% \shorttitle, \docdate, \docversion, \doclogo: additional commands for extra data.
\newcommand{\shorttitle}{}  % Contains short title for header
\newcommand{\docdate}{}     % Contains custom date
\newcommand{\docversion}{}  % Contains document version
\newcommand{\doclogofrontpage}{hkn_logo.pdf}      % Contains logo big path
\newcommand{\doclogoupperpage}{hkn_ideogramma.pdf}    % Contains logo big path
\newcommand{\doclicense}{ccbyncnd.png}  % Contains license logo path
\newcommand{\DDorganization}{IEEE - MuNu Chapter}

% Preserve old commands for title and author
\let\oldtitle\title
\renewcommand{\title}[1]{\oldtitle{#1}\gdef\maintitle{#1}}
\let\oldauthor\author
\renewcommand{\author}[1]{\ifx\DDauthors\empty\gdef\DDauthors{#1}\else\g@addto@macro\DDauthors{, #1}\fi}

% Define commands for short title, short author, editors, organization, date, version.
\def\shorttitle#1{\gdef\STtitle{#1}}
\def\editor#1{\ifx\DDeditors\empty\gdef\DDeditors{#1}\else\g@addto@macro\DDeditors{, #1}\fi}
\def\docdate#1{\gdef\DDdate{#1}}
\def\docversion#1{\gdef\DDversion{#1}}

% Initialize variables to prevent undefined errors
\gdef\maintitle{}
\gdef\DDauthors{}
\gdef\DDeditors{}
\gdef\DDdate{}
\gdef\DDversion{}
\gdef\DDlicense{}

% --------------------------
% TABLE OF CONTENTS LEVEL
% --------------------------
% Once options are processed, set the tocdepth accordingly
\AtEndOfClass{
  \setcounter{tocdepth}{\HK@tocdepth}
}

% --------------------------
% CUSTOM TITLE PAGE
% --------------------------
% \maketitle here creates a title page with:
% - Logo (if defined)
% - Title, Author
% - Version (if defined)
% - Date (if defined, otherwise today)
\renewcommand{\maketitle}{
    \thispagestyle{empty} % No header/footer on title page
    \def\tempa{italian}% Define comparison variable like in copyright section
    \begin{titlepage}
    \begin{center}
        % Logo e titoli
        \vspace*{0.5cm}
        \includegraphics[scale = 0.2]{\doclogofrontpage}\\[1.0 cm]  % HKN Logo
        \textsc{\Large Mu Nu Chapter of IEEE-HKN}\\[-0.2 cm]  % Name
        \rule{0.80\linewidth}{0.1 mm} \\
        \textsc{\large Politecnico di Torino -- Honor Society}\\[2.0 cm]  % Branch
        \rule{\linewidth}{0.2 mm} \\[0.4 cm]
        {\LARGE \textbf{\maintitle}}\\
        \rule{\linewidth}{0.2 mm} \\[1.5 cm]

        \if\DDauthors\empty\else
            \Large\DDauthors
        \fi

        \vspace{0.3cm}

        \if\DDeditors\empty\else
            \ifx\DocumentLanguage\tempa
                \Large \textit{Revisionato da:}
            \else
                \Large \textit{Edited by:}
            \fi
            \DDeditors
        \fi

        \vspace{1.5cm}

        % Date, required
        \Large \DDdate

        % Optional version
        \ifx\DDversion\empty\else
            \ifx\DocumentLanguage\tempa
                {\large Versione \DDversion}
            \else
                {\large Version \DDversion}
            \fi
        \fi
    \end{center}
    \end{titlepage}
    \clearpage
}

% --------------------------
% HEADER AND FOOTER
% --------------------------
% Now define how headers and footers will appear on common pages.
% The twoside structure means LE/RO are opposite positions on even and odd pages.
% Here we put:
% - On left pages (even pages): author on the left (RE), short title on the right (RO)
% - On right pages (odd pages): short title on the left (LE), author on the right (LO)
% Footer: page number centered (C)
\fancyhead{}
\fancyfoot{}
\renewcommand\headrule{%
  \vspace{-14.5pt}  % Aggiungi spazio negativo per posizionare la linea
  \hrulefill     % Crea una linea orizzontale a sinistra
  \hspace{50pt}  % Aggiungi uno spazio orizzontale (regola la dimensione a piacere)
  \hrulefill     % Crea una linea orizzontale a destra
}
\renewcommand{\chaptermark}[1]{\markboth{#1}{}}
\fancyhead[L]{\leftmark}
\fancyhead[R]{\DDorganization}
\fancyhead[C]{%
  \raisebox{-0.6\height}{%
    \href{https://hknpolito.org/}{\includegraphics[height=1cm]{\doclogoupperpage}}%
  }%
}
\fancyfoot[C]{\thepage}
\setlength{\headheight}{30pt} % Avoids warnings about head height
\addtolength{\topmargin}{-20pt} % Corrects top margin for header

% Chapter start pages will not have headers (only page number in "plain" style)
% Redefine \chapter to force plain style on the first page of each chapter.
% Also modify chapter marking to support short titles
\makeatletter
\def\chapter{\clearpage%
  \thispagestyle{plain}% Plain page style (no fancy header, only page number)
  \global\@topnum\z@%
  \@afterindentfalse%
  \secdef\@chapter\@schapter}

% Redefine \@chapter to handle optional short titles for headers
\def\@chapter[#1]#2{%
  \ifnum \c@secnumdepth >\m@ne
    \refstepcounter{chapter}%
    \typeout{\@chapapp\space\thechapter.}%
    \addcontentsline{toc}{chapter}%
                     {\protect\numberline{\thechapter}#2}%  % Use full title (#2) for TOC
  \else
    \addcontentsline{toc}{chapter}{#2}%  % Use full title (#2) for TOC
  \fi
  \chaptermark{#1}%  % Use the optional argument (short title) for the header
  \addtocontents{lof}{\protect\addvspace{10\p@}}%
  \addtocontents{lot}{\protect\addvspace{10\p@}}%
  \if@twocolumn
    \@topnewpage[\@makechapterhead{#2}]%
  \else
    \@makechapterhead{#2}%
    \@afterheading
  \fi}

% Redefine \@schapter (for starred chapters) to also support header marking
\def\@schapter#1{%
  \if@twocolumn
    \@topnewpage[\@makeschapterhead{#1}]%
  \else
    \@makeschapterhead{#1}%
    \@afterheading
  \fi
  \chaptermark{#1}}  % Use the full title for starred chapters
\makeatother

% Reproduce parskip package behaviour
\makeatletter
\newcommand{\setupparskip}{
    \@ifpackageloaded{parskip}{}{
        \setlength{\parskip}{.5\baselineskip plus 2pt}  % space between paragraphs
        \setlength{\parindent}{0pt}  % remove paragraph indentation
        \BeforeBeginEnvironment{center}{\vspace{-\parskip}}
        \AfterEndEnvironment{center}{\vspace{-\parskip}}
    }
}
\makeatother
\newcommand{\cclicense}{\input{cclicense.tex}}

% Redefines \clearpage and \cleardoublepage to remove headers/footers on blank pages.
\let\originalclearpage\clearpage
\renewcommand{\clearpage}{%
    \originalclearpage%
    \thispagestyle{empty}%
}
\let\originalcleardoublepage\cleardoublepage
\renewcommand{\cleardoublepage}{%
    \originalcleardoublepage%
    \thispagestyle{empty}%
}

% --------------------------
% STYLE
% --------------------------
\RequirePackage{xcolor}  % custom colors
\RequirePackage{tcolorbox}  % custom boxes

% Primary (Accent) Colors
\definecolor{accentYellow}{RGB}{254, 196, 41}  % #FEC421
\definecolor{accentRed}{RGB}{236, 45, 36}      % #EC2D24

% Secondary Colors
\definecolor{supportOrange}{RGB}{242, 183, 5}  % #F2B705
\definecolor{supportDarkBlue}{RGB}{55, 81, 113} % #375171

% Background Colors
\definecolor{backgroundLight}{RGB}{242, 242, 242} % #F2F2F2

% Text & Border Colors
\definecolor{textGrayBlue}{RGB}{100, 117, 140}   % #64758C
\definecolor{textGrayMedium}{RGB}{146, 154, 166}  % #929AA6
\definecolor{textGrayLight}{RGB}{184, 187, 191}   % #B8BBBF

% Listings style
\RequirePackage{listings}  % code highlighting
\lstdefinestyle{hkn}{
    basicstyle=\ttfamily\small\color{textGrayBlue},                         % Base style (size and font)
    keywordstyle=\bfseries\color{accentRed},           % Keywords in red (important, eye-catching)
    identifierstyle=\color{supportDarkBlue},               % Identifiers in blue (clear distinction)
    commentstyle=\color{textGrayMedium},                 % Comments in gray-blue (less prominent)
    stringstyle=\color{supportOrange},                 % Strings in orange (warm and readable)
    numberstyle=\ttfamily\scriptsize\color{textGrayMedium}, % Line numbers in gray (non-intrusive)
    backgroundcolor=\color{backgroundLight},           % Light background for contrast
    rulecolor=\color{textGrayLight},                   % Soft gray border for structure
    frame=single,                          % Border around code (single, double, shadowbox, none)
    framerule=0.8pt,                       % Border thickness
    frameround=tttt,                       % Round all corners
    framesep=5pt,                          % Distance between border and code
    rulesep=2pt,                           % Distance between border and code line
    numbers=left,                          % Line number position (left, right, none)
    stepnumber=1,                          % Line number interval
    numbersep=10pt,                        % Distance between line numbers and code
    xleftmargin=30pt,                      % Left margin
    xrightmargin=30pt,                     % Right margin
    resetmargins=true,                     % Reset margins
    numberblanklines=false,                % Number blank lines
    firstnumber=auto,                      % Initial line number
    columns=fixed,                         % Fixed column width
    showstringspaces=false,                % Show spaces in strings
    tabsize=2,                             % Tab size
    breaklines=true,                       % Automatic line break for long lines
    breakatwhitespace=true,                % Line break at whitespace
    breakautoindent=true,                  % Automatic indentation after line break
    escapeinside={(*@}{@*)}                % LaTeX commands in code
}

% Underline settings

\RequirePackage{ulem}  % underline
\RequirePackage{contour}  % border around text

\renewcommand{\ULdepth}{1.8pt} % Underline depth
\contourlength{0.8pt}

% Custom underline command
\newcommand{\myuline}[1]{%
\uline{\phantom{#1}}%
\llap{\contour{white}{#1}}%
}

% tcolorbox color settings
\definecolor{tcolorboxLeftColor}{RGB}{2, 65, 191}
\definecolor{tcolorboxBackTitleColor}{RGB}{119, 152, 255}
\definecolor{tcolorboxBackColor}{RGB}{210, 226, 255}

% Factory macro for custom boxes
\newcommand{\DeclareHKNBox}[4]{
    \newtcolorbox[auto counter, number within=chapter]{#1}[1]{
        title={\iflanguage{italian}{#2}{#3}~\arabic{\tcbcounter}.~##1},
        boxrule=0mm,  % Bordo principale (disabilitato)
        leftrule=1mm,  % Bordo sinistro principale
        arc=2mm,
        colframe=#4,  % Colore bordo
        colbacktitle=textGrayMedium,
        colback=backgroundLight,  % Colore sfondo
        fonttitle=\bfseries,
        rounded corners=all  % Bordi arrotondati
    }
}

\DeclareHKNBox{definition}{Definizione}{Definition}{accentRed}
\DeclareHKNBox{theorem}{Teorema}{Theorem}{accentYellow}
\DeclareHKNBox{corollary}{Corollario}{Corollary}{supportOrange}
\DeclareHKNBox{exercise}{Esercizio}{Exercise}{supportDarkBlue}
\DeclareHKNBox{observation}{Osservazione}{Observation}{textGrayBlue}

% Frontmatter and backmatter
\input{_preamble.tex}
\AtBeginDocument{
    \frontmatter
    \maketitle
    \input{cclicense.tex}
    \tableofcontents
    \clearpage

    \mainmatter
}
\AfterEndDocument{
    \backmatter
    \input{_postamble.tex}
}
