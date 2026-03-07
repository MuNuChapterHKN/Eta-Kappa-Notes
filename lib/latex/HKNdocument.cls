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
\RequirePackage{parskip}  % Remove paragraph indentation and add space between paragraphs

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
\newcommand{\DDorganization}{IEEE-HKN -- Mu Nu Chapter}

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

% HKN color palette
\definecolor{hknLightBlue}{HTML}{00629B}
\definecolor{hknOrange}{HTML}{FEC526}
\definecolor{hknYellow}{HTML}{FDD10C}
\definecolor{hknDarkBlue}{HTML}{0F2D52}
\definecolor{hknDarkRed}{HTML}{C22033}
\definecolor{hknRed}{HTML}{E2383F}
\definecolor{hknLightGray}{HTML}{D6DBE4}

% Mu Nu Chapter color palette
\definecolor{munuDarkBlue}{HTML}{061E33}
\definecolor{munuMediumBlue}{HTML}{1F3852}
\definecolor{munuLightBlue}{HTML}{375171}
\definecolor{munuLightGray}{HTML}{F2F2F2}
\definecolor{munuMediumGray}{HTML}{C0C0C0}
\definecolor{munuDarkGray}{HTML}{929AA6}

% Other colors
\definecolor{darkerOrange}{HTML}{EAAC01}
\definecolor{backgroundLight}{HTML}{F6F8FA}

% Listings style
% See Section 4.3 'Options' of the Listings package documentation for more details
% https://ctan.mirror.garr.it/mirrors/ctan/macros/latex/contrib/listings/listings.pdf#subsection.4.3
\RequirePackage{listings}  % code highlighting
\lstdefinestyle{hkn}{
    % Space and placement
    aboveskip=0.7\baselineskip,
    belowskip=-0.2\baselineskip,
    % Figure out the appearance
    basicstyle=\ttfamily\small\color{munuLightBlue},
    identifierstyle=\color{munuDarkBlue},
    commentstyle=\color{munuDarkGray},
    stringstyle=\color{hknRed},
    keywordstyle=[1]\bfseries\color{hknLightBlue},
    keywordstyle=[2]\bfseries\color{darkerOrange},
    % Getting all characters right
    upquote=true,
    showtabs=true,
    tab={\scriptsize \hfill\;$\mapsto$\hfill},
    showstringspaces=false,
    % Line numbers
    numbers=none,
    % Margins and line shape
    xleftmargin=4pt,
    xrightmargin=4pt,
    breaklines=true,
    breakatwhitespace=true,
    % Frames
    frame=single,
    backgroundcolor=\color{backgroundLight},
    rulecolor=\color{backgroundLight},
}
\lstdefinestyle{hkn-numbered}{
    style=hkn,
    % Line numbers
    numbers=left,
    numberstyle=\ttfamily\scriptsize\color{munuDarkGray},
    numbersep=10pt,  % distance between number and listing
    % Margins and line shape
    xleftmargin=20pt,
}
\lstset{style=hkn}

% Underline settings

\RequirePackage{ulem}  % underline
\RequirePackage{contour}  % border around text

\renewcommand{\ULdepth}{1.8pt} % Underline depth
\contourlength{0.8pt}

% Custom underline command
\newcommand{\myuline}[1]{
    \uline{\phantom{#1}}
    \llap{\contour{white}{#1}}
}

% Factory macro for custom boxes
\newcommand{\DeclareHKNBox}[4]{
    \newtcolorbox[auto counter, number within=chapter]{#1}[1]{
        title={\iflanguage{italian}{#2}{#3}~\arabic{\tcbcounter}.~##1},
        boxrule=0mm,  % Bordo principale (disabilitato)
        leftrule=1mm,  % Bordo sinistro principale
        arc=0.5mm,
        colframe=#4,  % Colore bordo
        colbacktitle=munuLightBlue!90,
        colback=backgroundLight,  % Colore sfondo
        fonttitle=\bfseries,
        rounded corners=all  % Bordi arrotondati
    }
}

\DeclareHKNBox{definition}{Definizione}{Definition}{hknRed}
\DeclareHKNBox{theorem}{Teorema}{Theorem}{hknYellow}
\DeclareHKNBox{corollary}{Corollario}{Corollary}{hknOrange}
\DeclareHKNBox{exercise}{Esercizio}{Exercise}{munuDarkBlue}
\DeclareHKNBox{observation}{Osservazione}{Observation}{hknLightBlue}

% Frontmatter and backmatter
\input{_preamble.tex}
\AtBeginDocument{
    \renewcommand{\lstlistlistingname}{Codes}
    \renewcommand{\lstlistingname}{Code}

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
