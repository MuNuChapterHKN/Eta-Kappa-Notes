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
\LoadClass[\HK@classfontsize,a4paper,twoside]{book}

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
\newcommand{\organization}{}% Contains organization
\newcommand{\docdate}{}     % Contains custom date
\newcommand{\docversion}{}  % Contains document version
\newcommand{\doclogo}{}     % Contains logo path
\newcommand{\doclicense}{}  % Contains license logo path

% Preserve old commands for title and author
\let\oldtitle\title
\renewcommand{\title}[1]{\oldtitle{#1}\gdef\maintitle{#1}}
\let\oldauthor\author
\renewcommand{\author}[1]{\ifx\DDauthors\undefined\gdef\DDauthors{#1}\else\g@addto@macro\DDauthors{, #1}\fi}

% Define commands for short title, short author, editors, organization, date, version, and logo.
\def\shorttitle#1{\gdef\STtitle{#1}}
\def\editor#1{\ifx\DDeditors\undefined\gdef\DDeditors{#1}\else\g@addto@macro\DDeditors{, #1}\fi}
\def\organization#1{\gdef\DDorganization{#1}\gdef\organization{#1}}
\def\docdate#1{\gdef\DDdate{#1}}
\def\docversion#1{\gdef\DDversion{#1}}
\def\doclogo#1{\gdef\DDlogo{#1}}
\def\doclicense#1{\gdef\DDlicense{#1}}

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
    \begin{titlepage}
        \begin{center}

            % Logo
            \ifx\DDlogo\empty\else
                \vspace*{1cm}
                \includegraphics[width=0.4\textwidth]{\DDlogo}\\[1cm]
            \fi

            % Main title
            {\LARGE \textbf{\maintitle}}\\[1.5cm]

            % Author(s)
            \@ifundefined{DDauthors}{}{
                \ifx\DocumentLanguage\italian
                    {\Large Autori: \DDauthors\\[0.5cm]}
                \else
                    {\Large Authors: \DDauthors\\[0.5cm]}
                \fi
            }

            % Editor(s)
            \@ifundefined{DDeditors}{}{
                \ifx\DocumentLanguage\italian
                    {\Large Editori: \DDeditors\\[0.5cm]}
                \else
                    {\Large Editors: \DDeditors\\[0.5cm]}
                \fi
            }
            % Organization
            \ifx\DDorganization\empty\else
                {\Large \DDorganization\\[0.5cm]}
            \fi

            % Optional version
            \ifx\DDversion\empty\else
                \ifx\DocumentLanguage\italian
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
\fancyhead[RE, LO]{\STtitle}
\fancyhead[Ro, LE]{\DDorganization}
\fancyfoot[C]{\thepage}
\setlength{\headheight}{15pt} % Avoids warnings about head height
\addtolength{\topmargin}{-2.5pt} % Corrects top margin for header

% Chapter start pages will not have headers (only page number in "plain" style)
% Redefine \chapter to force plain style on the first page of each chapter.
\makeatletter
\def\chapter{\clearpage%
  \thispagestyle{plain}% Plain page style (no fancy header, only page number)
  \global\@topnum\z@%
  \@afterindentfalse%
  \secdef\@chapter\@schapter}
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
    % Linguaggio condizionale
    \ifx\DocumentLanguage\italian
        \vfill
        Questo lavoro è distribuito con una \textbf{Licenza Creative Commons Attribuzione - Non commerciale - Non opere derivate 4.0 International}.
        Il lavoro è stato prodotto da \DDauthors, editato da \DDeditors e pubblicizzato da \DDorganization.\\
        \textbf{Puoi:}
        \begin{itemize}
            \item \textbf{Condividere:} copiare, distribuire e trasmettere il lavoro
        \end{itemize}
        \textbf{Alle seguenti condizioni:}
        \begin{itemize}
            \item \textbf{Attribuzione:} devi attribuire il lavoro nei modi indicati dall'autore o da chi ti ha dato la licenza (ma non in un modo che suggerisca che loro approvino te o il tuo uso del lavoro).
            \item \textbf{Non commerciale:} non puoi usare questo lavoro per fini commerciali.
            \item \textbf{Non opere derivate:} se modifichi, trasformi o sviluppi questo lavoro, non puoi distribuire il risultato.
        \end{itemize}
        Maggiori informazioni sul sito di \href{https://creativecommons.org/licenses/by-nc-nd/4.0/}{Creative Commons}.
    \else
        \vfill
        This work is licensed under a \textbf{Creative Commons Attribution - NonCommercial - NoDerivatives 4.0 International}.
        The work was produced by \DDauthors, edited by \DDeditors, and publicized by \DDorganization.\\
        \textbf{You are free:}
        \begin{itemize}
            \item \textbf{to Share:} to copy, distribute and transmit the work
        \end{itemize}
        \textbf{Under the following conditions:}
        \begin{itemize}
            \item \textbf{Attribution:} you must attribute the work in the manner specified by the author or licensor (but not in any way that suggests that they endorse you or your use of the work).
            \item \textbf{Noncommercial:} you may not use this work for commercial purposes.
            \item \textbf{No derivatives:} if you alter, transform, or build upon this work, you may not distribute the resulting work.
        \end{itemize}
        More information on the \href{https://creativecommons.org/licenses/by-nc-nd/4.0/}{Creative Commons website}.
    \fi
    % Logo
    \\
    \ifx\DDlicense\empty\else
        \vspace{1cm} % Spazio prima dell'immagine
        \hfill\includegraphics[width=0.4\textwidth]{\DDlicense} % Immagine allineata a destra
        \vspace{1cm} % Spazio dopo l'immagine
    \fi

}

% End of class
\endinput
