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
\def\HK@classfontsize{11pt}    % Default font size

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
\LoadClass[\HK@classfontsize,a4paper,twoside,openany]{book}

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
% GRAPHICS AND TABLE PACKAGES
% --------------------------
\RequirePackage{graphicx} % For including images (including logo)
\RequirePackage{array}    % Advanced columns in tables
\RequirePackage{booktabs} % Typographically better tables (\toprule, \midrule, \bottomrule)
\RequirePackage{enumitem} % For customizing list spacing

% --------------------------
% MATHEMATICAL PACKAGES
% --------------------------
\RequirePackage{amsmath,amssymb,amsthm} % Enhancements for mathematics (Theorems, symbols)
\RequirePackage{mathtools}              % Extensions to amsmath

% --------------------------
% DOCUMENT LAYOUT
% --------------------------
\RequirePackage[a4paper,margin=3cm]{geometry}
% Set margins and page size to A4 with 3cm margins.
% Modifiable as desired.

% --------------------------
% HYPERREF FOR INTERNAL AND EXTERNAL LINKS
% --------------------------
% Create clickable links in PDF and set link colors
\RequirePackage{hyperref}
\hypersetup{
    colorlinks=true,
    linkcolor=black,
    citecolor=black,
    urlcolor=blue
}

% --------------------------
% SVG IMAGES
% --------------------------
\RequirePackage[inkscapeversion=1]{svg} % SVG images with Inkscape

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
\newcommand{\doclicence}{ccbyncnd.png}  % Contains license logo path
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
        % Logo e titoli centrati
        \begin{center}
            \vspace*{0.5cm}
            \includegraphics[scale = 0.2]{\doclogofrontpage}\\[1.0 cm]  % HKN Logo
            \textsc{\Large Mu Nu Chapter of IEEE-HKN}\\[-0.2 cm]  % Name
            \rule{0.80\linewidth}{0.1 mm} \\
            \textsc{\large Politecnico di Torino - Honor Society}\\[2.0 cm]  % Branch
            \rule{\linewidth}{0.2 mm} \\[0.4 cm]
            {\LARGE \textbf{\maintitle}}\\
            \rule{\linewidth}{0.2 mm} \\[2 cm]
        \end{center}

        \noindent
        % Author(s) left
        \begin{minipage}[t]{0.4\textwidth}
            \raggedright
            \ifx\DocumentLanguage\tempa
                {\Large\textit{Autori:}\\[0.5cm]}%
            \else
                {\Large\textit{Authors:}\\[0.5cm]}%
            \fi
            \ifx\DDauthors\empty\else
                \DDauthors\\[0.5cm]%
            \fi
        \end{minipage}\hfill% <-- nessun blank line qui
        % Editor (s) right
        \begin{minipage}[t]{0.4\textwidth}
            \raggedleft
            \ifx\DocumentLanguage\tempa
                {\Large\textit{Editori:}\\[0.5cm]}%
            \else
                {\Large\textit{Editors:}\\[0.5cm]}%
            \fi
            \ifx\DDeditors\empty\else
                \DDeditors\\[0.5cm]%
            \fi
        \end{minipage}
        \vfill
        % Opzionale: Versione e Data centrati
        \begin{center}
            % Optional version
            \ifx\DDversion\empty\else
                \ifx\DocumentLanguage\tempa
                    {\large Versione: \DDversion}\\[0.5cm]
                \else
                    {\large Version: \DDversion}\\[0.5cm]
                \fi
            \fi

            % Date: if not defined, use today's date
            \ifx\DDdate\empty
                {\large \today}
            \else
                {\large \DDdate}
            \fi

            \vfill
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

% --------------------------
% NUMBERING OF FIGURES, TABLES, AND EQUATIONS
% --------------------------
% Makes numbering dependent on the chapter (Fig. 1.1, 1.2... ; Eq. (1.1), (1.2)...)
\numberwithin{figure}{chapter}
\numberwithin{table}{chapter}
\numberwithin{equation}{chapter}

% --------------------------
% CREATIVE COMMONS LICENSE COMMAND
% --------------------------
% Generates a language-sensitive Creative Commons license description with an image and hyperlink
\newcommand{\cclicense}{%
    \thispagestyle{empty}
    % \setlength{\parindent}{0pt}% Remove paragraph indentation
    % \setlength{\parskip}{0pt}% Suspend parskip package effects for this section
        \def\tempa{italian}%
        \ifx\DocumentLanguage\tempa
            {\Large\textbf{\#WeAreHKN}}
            \vspace{0.2cm}
            \par
            Il \textbf{Mu Nu Chapter} di \textbf{IEEE-Eta Kappa Nu (HKN)} è la Honor Society del Politecnico di Torino dedicata agli studenti di eccellenza nei campi dell'ingegneria elettrica, elettronica, informatica e delle telecomunicazioni. IEEE-HKN è la più antica e prestigiosa honor society internazionale per ingegneri elettrici ed elettronici, fondata nel 1904. Il nostro capitolo promuove l'eccellenza accademica, il servizio alla comunità e lo sviluppo professionale attraverso attività di tutoring, workshop e progetti collaborativi.

            \vspace{0.3cm}
            {\large\textbf{Progetto Gratuito per la Condivisione della Conoscenza}}
            \par
            Questo è un progetto completamente gratuito volto alla distribuzione libera di materiale didattico di qualità. Crediamo nell'importanza di rendere accessibile a tutti una formazione di eccellenza e offriamo gratuitamente queste risorse per supportare il percorso di studio di ogni studente.

            \vspace{0.3cm}
            {\large\textbf{Scopri le nostre iniziative:}}
            \par
            \begin{itemize}[topsep=0pt,itemsep=0pt,parsep=0pt,partopsep=0pt]
                \item \textbf{Sito web:} \href{https://hknpolito.org/}{https://hknpolito.org/}
                \item \textbf{Instagram:} \href{https://www.instagram.com/hknpolito/}{@hknpolito}
                \item \textbf{Repository GitHub:} \href{https://github.com/MuNuChapterHKN/Eta-Kappa-Notes/}{https://github.com/MuNuChapterHKN/Eta-Kappa-Notes/}
            \end{itemize}

            \vspace{0.3cm}
            \textbf{Segnalazioni ed Errori}
            \par
            Hai trovato un errore o vorresti contribuire al miglioramento di questo materiale? Consulta il documento \href{https://github.com/MuNuChapterHKN/Eta-Kappa-Notes/blob/main/CONTRIBUTING.md}{CONTRIBUTING.md} nella nostra repository GitHub oppure scrivici a: \href{mailto:responsabile.tutoring@hknpolito.it}{responsabile.tutoring@hknpolito.it}

            \vfill

            \begin{center}
                \begin{minipage}{\linewidth}
                    \begin{minipage}{0.6\textwidth}
                        {\Large\textbf{Licenza Creative Commons}}
                    \end{minipage}
                    \begin{minipage}{0.39\linewidth}
                        \raggedleft
                        \includegraphics[width=0.65\textwidth]{\doclicence}
                    \end{minipage}
                \end{minipage}
            \end{center}

            Questo lavoro è distribuito con una \textbf{Licenza Creative Commons Attribuzione - Non commerciale - Non opere derivate 4.0 International}.
            Il lavoro è stato prodotto da \DDauthors\ifx\DDeditors\empty\else, editato da \DDeditors\fi{} e pubblicizzato da \DDorganization.

            \textbf{Puoi:}
            \begin{itemize}[topsep=0pt,itemsep=0pt,parsep=0pt,partopsep=0pt]
                \item \textbf{Condividere:} copiare, distribuire e trasmettere il lavoro
            \end{itemize}

            \textbf{Alle seguenti condizioni:}
            \begin{itemize}[topsep=0pt,itemsep=0pt,parsep=0pt,partopsep=0pt]
                \item \textbf{Attribuzione:} devi attribuire il lavoro nei modi indicati dall'autore o da chi ti ha dato la licenza (ma non in un modo che suggerisca che loro approvino te o il tuo uso del lavoro).
                \item \textbf{Non commerciale:} non puoi usare questo lavoro per fini commerciali.
                \item \textbf{Non opere derivate:} se modifichi, trasformi o sviluppi questo lavoro, non puoi distribuire il risultato.
            \end{itemize}

            Maggiori informazioni sul sito di \href{https://creativecommons.org/licenses/by-nc-nd/4.0/}{Creative Commons}.
        \else
            % Information about HKN organization
            {\Large\textbf{\#WeAreHKN}}
            \vspace{0.2cm}
            \par
            The \textbf{Mu Nu Chapter} of \textbf{IEEE-Eta Kappa Nu (HKN)} is the Honor Society of Politecnico di Torino dedicated to outstanding students in electrical, electronic, computer, and telecommunications engineering. IEEE-HKN is the oldest and most prestigious international honor society for electrical and electronic engineers, founded in 1904. Our chapter promotes academic excellence, community service, and professional development through tutoring activities, workshops, and collaborative projects.

            \vspace{0.3cm}
            {\large\textbf{Free Project for Knowledge Sharing}}
            \par
            This is a completely free project aimed at the open distribution of high-quality educational materials. We believe in the importance of making excellent education accessible to everyone and offer these resources free of charge to support every student's learning journey.

            \vspace{0.3cm}
            {\large\textbf{Discover our initiatives:}}
            \par
            \begin{itemize}[topsep=0pt,itemsep=0pt,parsep=0pt,partopsep=0pt]
                \item \textbf{Website:} \href{https://hknpolito.org/}{https://hknpolito.org/}
                \item \textbf{Instagram:} \href{https://www.instagram.com/hknpolito/}{@hknpolito}
                \item \textbf{GitHub Repository:} \href{https://github.com/MuNuChapterHKN/Eta-Kappa-Notes/}{https://github.com/MuNuChapterHKN/Eta-Kappa-Notes/}
            \end{itemize}

            \vspace{0.3cm}
            \textbf{Error Reports and Contributions}
            \par
            Found an error or would like to contribute to improving this material? Check the \href{https://github.com/MuNuChapterHKN/Eta-Kappa-Notes/blob/main/CONTRIBUTING.md}{CONTRIBUTING.md} document in our GitHub repository or write to us at: \href{mailto:responsabile.tutoring@hknpolito.it}{responsabile.tutoring@hknpolito.it}

            \vfill

            \begin{center}
                \begin{minipage}{\linewidth}
                    \begin{minipage}{0.6\textwidth}
                        {\Large\textbf{Licenza Creative Commons}}
                    \end{minipage}
                    \begin{minipage}{0.39\linewidth}
                        \raggedleft
                        \includegraphics[width=0.65\textwidth]{\doclicence}
                    \end{minipage}
                \end{minipage}
            \end{center}

            This work is licensed under a \textbf{Creative Commons Attribution - NonCommercial - NoDerivatives 4.0 International}.
            The work was produced by \DDauthors\ifx\DDeditors\empty\else, edited by \DDeditors\fi{}, and publicized by \DDorganization.

            \textbf{You are free:}
            \begin{itemize}[topsep=0pt,itemsep=0pt,parsep=0pt,partopsep=0pt]
                \item \textbf{to Share:} to copy, distribute and transmit the work
            \end{itemize}

            \textbf{Under the following conditions:}
            \begin{itemize}[topsep=0pt,itemsep=0pt,parsep=0pt,partopsep=0pt]
                \item \textbf{Attribution:} you must attribute the work in the manner specified by the author or licensor (but not in any way that suggests that they endorse you or your use of the work).
                \item \textbf{Noncommercial:} you may not use this work for commercial purposes.
                \item \textbf{No derivatives:} if you alter, transform, or build upon this work, you may not distribute the resulting work.
            \end{itemize}

            More information on the \href{https://creativecommons.org/licenses/by-nc-nd/4.0/}{Creative Commons website}.
        \fi
    \clearpage
}


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

% End of class
\endinput
