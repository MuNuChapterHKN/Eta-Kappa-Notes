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

% PDF metadata and links
\RequirePackage{hyperref}

% --------------------------
% TABLE OF CONTENTS LEVEL
% --------------------------
% Once options are processed, set the tocdepth accordingly
\AtEndOfClass{
  \setcounter{tocdepth}{\HK@tocdepth}
}

% --------------------------
% COMMANDS FOR TITLE, AUTHOR, LOGO
% --------------------------

% Static variables
\gdef\HK@versionFileName{version}
\gdef\DDbiglogo{hkn_logo.pdf}
\gdef\DDsmalllogo{hkn_ideogramma.pdf}
\gdef\DDlicenselogo{ccbyncnd.png}
\gdef\DDorganization{IEEE-HKN -- Mu Nu Chapter}

% Course metadata
% Optional variables are initialized as empty

% Authors
\gdef\DDauthors{}
\let\oldauthor\author
\renewcommand{\author}[1]{\ifx\DDauthors\empty\gdef\DDauthors{#1}\else\g@addto@macro\DDauthors{, #1}\fi}

% Editors
\gdef\DDeditors{}
\def\editor#1{\ifx\DDeditors\empty\gdef\DDeditors{#1}\else\g@addto@macro\DDeditors{, #1}\fi}

% Title
\gdef\DDtitle{}
\let\oldtitle\title
\renewcommand{\title}[1]{\oldtitle{#1}\gdef\DDtitle{#1}}

% Course code
\def\coursecode#1{\gdef\DDcoursecode{#1}}

% Course name
\def\coursename#1{\gdef\DDcoursename{#1}}

% Main teacher
\def\teacher#1{\gdef\DDteacher{#1}}

% Program
\def\program#1{\gdef\DDprogram{#1}}
\gdef\DDprogramen{\DDprogram}
\def\programen#1{\gdef\DDprogramen{#1}}

% Program level
\def\programlevel#1{
    \gdef\DDprogramlevel{#1}  % bachelor or master
    \ifdefstring{\DDprogramlevel}{bachelor}{
        \gdef\DDprogramlevelword{\iflanguage{italian}{Corso di laurea triennale}{Bachelor program}}
    }{
        \ifdefstring{\DDprogramlevel}{master}{
            \gdef\DDprogramlevelword{\iflanguage{italian}{Corso di laurea magistrale}{Master program}}
        }{
            \ClassError{HKNdocument}
            {Invalid program level value: #1}
            {The \protect\programlevel\space command only accepts 'bachelor' or 'master'.}
        }
    }
}

% Academic year
\def\startacademicyear#1{
    \gdef\DDstartacademicyear{#1}  % starting year
    \gdef\DDacademicyear{#1-\the\numexpr#1+1\relax}  % range of two years
}

% Semester
\def\semester#1{
    \gdef\DDsemester{#1}  % number, 1 or 2
    \ifnum#1=1
        \gdef\DDsemesterword{\iflanguage{italian}{Primo semestre}{First semester}}
    \else
        \ifnum#1=2
            \gdef\DDsemesterword{\iflanguage{italian}{Secondo semestre}{Second semester}}
        \else
            \ClassError{HKNdocument}
            {Invalid semester value: #1}
            {The \protect\semester\space command only accepts 1 or 2.}
        \fi
    \fi
}

% Completed flag
\def\completed#1{
    \gdef\DDcompleted{#1}
}

% Version
\RequirePackage{catchfile}
\IfFileExists{\HK@versionFileName}{
    \CatchFileDef{\DDversion}{\HK@versionFileName}{\endlinechar=-1}
}{
    \gdef\DDversion{}
}

% Interface through \courseinfo command
\RequirePackage{pgfkeys}
\pgfkeys{
    /HKN/.is family, /HKN,
    code/.code = {\coursecode{#1}},
    name/.code = {\coursename{#1}},
    teacher/.code = {\teacher{#1}},
    program/.code = {\program{#1}},
    program_en/.code = {\programen{#1}},
    program_level/.code = {\programlevel{#1}},
    start_academic_year/.code = {\startacademicyear{#1}},
    semester/.code = {\semester{#1}},
    completed/.code = {\completed{#1}},
}
\newcommand{\courseinfo}[1]{\pgfqkeys{/HKN}{#1}}

% Title page

\renewcommand{\maketitle}{
    \thispagestyle{empty} % No header/footer on title page
    \begin{titlepage}
    \begin{center}
        % Logo e titoli
        \includegraphics[scale = 0.2]{\DDbiglogo}  % HKN Logo

        \vfill

        \textsc{\Large Mu Nu Chapter of IEEE-HKN}  % Name
        \par
        \vspace{-0.45cm}
        \rule{0.80\linewidth}{0.1 mm}
        \par
        \vspace{-0.1cm}
        \textsc{\large Politecnico di Torino -- Honor Society}

        \vfill

        \rule{\linewidth}{0.2 mm}
        \par
        \vspace{0.1cm}
        \ifx\DDtitle\empty
            % Course information
            {\LARGE \textbf{\iflanguage{italian}{Appunti di}{Notes of} \DDcoursename}}

            \vspace{0.2cm}

            {\large
                \iflanguage{italian}{Corso}{Course} \DDcoursecode, \DDteacher

                \DDprogramlevelword\ in \DDprogram

                \DDsemesterword\ \DDacademicyear
            \par}
        \else
            % Title
            {\LARGE \textbf{\DDtitle}}
        \fi
        \vspace{-0.3cm}
        \rule{\linewidth}{0.2 mm}

        \vfill

        % Authors
        \if\DDauthors\empty\else
            \linespread{1.5}\selectfont
            {\Large \DDauthors}
        \fi

        \vfill

        % Editors
        \if\DDeditors\empty\else
            \linespread{1.5}\selectfont
            {\Large \textit{\iflanguage{italian}{Revisionati da}{Edited by}:} \DDeditors}
        \fi

        % Date and version
        \vfill
        {\large
            \iflanguage{italian}{Ultimo aggiornamento}{Last updated}: \today
            \ifx\DDversion\empty
                \par
                \vfill
                {\color{red} \Large
                    \iflanguage{italian}
                    {Attenzione: versione non pubblicata!}
                    {Warning: unpublished version!}
                    \unskip
                }
            \else
                \ (\iflanguage{italian}{versione}{version} \DDversion)
                \unskip
                \ifdefstring{\DDcompleted}{false}{
                    \par
                    \vfill
                    {\color{red} \Large
                        \iflanguage{italian}
                        {Attenzione: appunti incompleti!}
                        {Warning: incomplete notes!}
                        \unskip
                    }
                }
            \fi
        }
    \end{center}
    \end{titlepage}
    \pagebreak
}

% Watermark
\ifx\DDversion\empty
    \RequirePackage{background}
    \backgroundsetup{
        contents=\iflanguage{italian}{NON PUBBLICATO}{UNPUBLISHED},
        color=hknRed!50,
        angle=54.7,  % = arctan(sqrt(2)) in degrees, the A4 diagonal angle
        scale=\iflanguage{italian}{7}{9},
        opacity=0.2,
        position=current page.center
    }
\fi

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
    \href{https://hknpolito.org/}{\includegraphics[height=1cm]{\DDsmalllogo}}%
  }%
}
\fancyfoot[C]{\thepage}
\setlength{\headheight}{30pt} % Avoids warnings about head height
\addtolength{\topmargin}{-20pt} % Corrects top margin for header

% ______________________________________________________________________________ INIZIO MODIFICA TIZIANO - COMANDO CHAPTER

% % Chapter start pages will not have headers (only page number in "plain" style)
% % Redefine \chapter to force plain style on the first page of each chapter.
% % Also modify chapter marking to support short titles
% \makeatletter
% \def\chapter{\clearpage%
%   \thispagestyle{plain}% Plain page style (no fancy header, only page number)
%   \global\@topnum\z@%
%   \@afterindentfalse%
%   \secdef\@chapter\@schapter}

% % Redefine \@chapter to handle optional short titles for headers
% \def\@chapter[#1]#2{%
%   \ifnum \c@secnumdepth >\m@ne
%     \refstepcounter{chapter}%
%     \typeout{\@chapapp\space\thechapter.}%
%     \addcontentsline{toc}{chapter}%
%                      {\protect\numberline{\thechapter}#2}%  % Use full title (#2) for TOC
%   \else
%     \addcontentsline{toc}{chapter}{#2}%  % Use full title (#2) for TOC
%   \fi
%   \chaptermark{#1}%  % Use the optional argument (short title) for the header
%   \addtocontents{lof}{\protect\addvspace{10\p@}}%
%   \addtocontents{lot}{\protect\addvspace{10\p@}}%
%   \if@twocolumn
%     \@topnewpage[\@makechapterhead{#2}]%
%   \else
%     \@makechapterhead{#2}%
%     \@afterheading
%   \fi}

% % Redefine \@schapter (for starred chapters) to also support header marking
% \def\@schapter#1{%
%   \if@twocolumn
%     \@topnewpage[\@makeschapterhead{#1}]%
%   \else
%     \@makeschapterhead{#1}%
%     \@afterheading
%   \fi
%   \chaptermark{#1}}  % Use the full title for starred chapters
% \makeatother



\RequirePackage{xparse}

% NOTA SU XPARSE E LATEX3: È necessario aggiungere \RequirePackage{xparse}
% all'inizio della classe per garantire la retrocompatibilità con vecchie
% distribuzioni TeX antecedenti al 2020. Dal 2020 in poi, xparse e le
% funzioni di LaTeX3 sono state integrate nativamente nel kernel standard.
% Non bisogna modificare l'istruzione \NeedsTeXFormat{LaTeX2e} (es. in
% LaTeX3), poiché LaTeX3 non è mai stato rilasciato come formato a sé
% stante, ma è un ambiente di programmazione integrato dentro LaTeX2e.

% --------------------------
% CHAPTER COMMAND WRAPPER (xparse)
% --------------------------
% Conserva il comando nativo della classe book
\let\oldchapter\chapter         % Backup del comando originale
                                % Supporta la variante con *, come lo stesso comando chapter.

% Ridefinisce \chapter per disaccoppiare TOC e Header, e gestire i capitoli stellati
% Testatina: usa sempre titolo breve
% Indice: usa sempre titolo lungo
% Aggiunto supporto per titoli brevi a capitoli stellati

\RenewDocumentCommand{\chapter}{ s o m }{%
    \IfBooleanTF{#1}{%
        % CASO 1: Capitolo stellato \chapter*[]{Lungo}
        \IfNoValueTF{#2}{%
            % CASO 1-A: chapter* Senza titolo breve
            \oldchapter*{#3}%
            \chaptermark{#3}% Aggiorna l'header anche se non numerato
        }{%
            % CASO 1-B: chapter* con titolo breve \chapter*[Breve]{Lungo}
            \oldchapter*{#3}% Invia il titolo LUNGO alla pagina
            \chaptermark{#2}% Sovrascrive l'header con il titolo BREVE
                            % Non invia nulla al ToC nulla, come di norma per \chapter*
        }%
    }{%
        % CASO 2: Capitolo normale \chapter
        \IfNoValueTF{#2}{%
            % CASO 2-A: chapter Senza titolo breve
            \oldchapter{#3}%
        }{%
            % CASO 2-B: chapter con titolo breve \chapter[Breve]{Lungo}
            \oldchapter{#3}% Invia il titolo LUNGO al TOC e alla pagina
            \chaptermark{#2}% Sovrascrive l'header con il titolo BREVE
        }%
    }%
}

% ______________________________________________________________________________ FINE MODIFICA TIZIANO - COMANDO CHAPTER

% ______________________________________________________________________________ INIZIO MODIFICA TIZIANO - COMANDI CLEAR

% % Redefines \clearpage and \cleardoublepage to remove headers/footers on blank pages.
% \let\originalclearpage\clearpage
% \renewcommand{\clearpage}{%
%     \originalclearpage%
%     \thispagestyle{empty}%
% }
% \let\originalcleardoublepage\cleardoublepage
% \renewcommand{\cleardoublepage}{%
%     \originalcleardoublepage%
%     \thispagestyle{empty}%
% }

\RequirePackage{emptypage}
% Fa esattamente la stessa cosa sopra, ma meglio e senza bug.
% Soprattutto è sbagliato rendere lo stile empty con \clearpage, perchè è usato
% per chiudere in generale una pagina, anche con del testo.

% ______________________________________________________________________________ FINE MODIFICA TIZIANO - COMANDI CLEAR


% --------------------------
% STYLE
% --------------------------
\RequirePackage{xcolor}  % custom colors
\RequirePackage{tcolorbox}  % custom boxes

% HKN color palette
\definecolor{hknLightBlue}{HTML}{00629B}    % #00629B                         % Caselle AGGIUNTE da Tiziano
\definecolor{hknOrange}{HTML}{FEC526}       % #FEC526
\definecolor{hknYellow}{HTML}{FDD10C}       % #FDD10C
\definecolor{hknDarkBlue}{HTML}{0F2D52}     % #0F2D52
\definecolor{hknDarkRed}{HTML}{C22033}      % #C22033
\definecolor{hknRed}{HTML}{E2383F}          % #E2383F
\definecolor{hknLightGray}{HTML}{D6DBE4}    % #D6DBE4

% Mu Nu Chapter color palette
\definecolor{munuDarkBlue}{HTML}{061E33}    % #061E33
\definecolor{munuMediumBlue}{HTML}{1F3852}  % #1F3852
\definecolor{munuLightBlue}{HTML}{375171}   % #375171
\definecolor{munuLightGray}{HTML}{F2F2F2}   % #F2F2F2
\definecolor{munuMediumGray}{HTML}{C0C0C0}  % #C0C0C0
\definecolor{munuDarkGray}{HTML}{929AA6}    % #929AA6

% Other colors
\definecolor{darkerOrange}{HTML}{EAAC01}    % #EAAC01
\definecolor{backgroundLight}{HTML}{F6F8FA} % #F6F8FA

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
    \newtcolorbox[auto counter]{#1}[1]{
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
\DeclareHKNBox{lemma}{Lemma}{Lemma}{hknYellow}
\DeclareHKNBox{corollary}{Corollario}{Corollary}{hknOrange}
\DeclareHKNBox{exercise}{Esercizio}{Exercise}{munuDarkBlue}
\DeclareHKNBox{observation}{Osservazione}{Observation}{hknLightBlue}

\DeclareHKNBox{proposition}{Proposizione}{Proposition}{munuLightBlue}           % AGGIUNTA da Tiziano

% Frontmatter and backmatter
\input{_preamble.tex}
\AtBeginDocument{
    \renewcommand{\lstlistlistingname}{Codes}
    \renewcommand{\lstlistingname}{Code}

    % PDF metadata
    \ifx\DDtitle\empty
        \iflanguage{italian}{
            \hypersetup{pdfsubject = {Appunti di \DDcoursename\ per \DDprogram\ tenuto da \DDteacher\ (corso \DDcoursecode) -- \DDsemesterword\ \DDacademicyear, Politecnico di Torino, progetto Eta Kappa Notes (https://github.com/MuNuChapterHKN/Eta-Kappa-Notes)}}
            \ifx\DDversion\empty
                \hypersetup{pdftitle = {Appunti di \DDcoursename\ per \DDprogram\ -- versione non pubblicata}}
            \else
                \hypersetup{pdftitle = {Appunti di \DDcoursename\ per \DDprogram\ -- versione \DDversion}}
            \fi
        }{
            \hypersetup{pdfsubject = {Notes of \DDcoursename\ for \DDprogram\ held by \DDteacher\ (course \DDcoursecode) -- \DDsemesterword\ \DDacademicyear, Politecnico di Torino, Eta Kappa Notes project (https://github.com/MuNuChapterHKN/Eta-Kappa-Notes)}}
            \ifx\DDversion\empty
                \hypersetup{pdftitle = {Notes of \DDcoursename\ for \DDprogram\ -- unpublished version}}
            \else
                \hypersetup{pdftitle = {Notes of \DDcoursename\ for \DDprogram\ -- version \DDversion}}
            \fi
        }
    \else
        \hypersetup{pdftitle = {\DDtitle}}
    \fi

    \ifx\DDeditors\empty
        \gdef\DDallauthors{\DDauthors}
    \else
        \gdef\DDallauthors{\DDauthors, \DDeditors}
    \fi
    \hypersetup{pdfauthor = {Mu Nu Chapter of IEEE-HKN, \DDallauthors}}

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
