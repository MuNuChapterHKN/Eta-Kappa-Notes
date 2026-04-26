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

% ______________________________________________________________________________ INIZIO MODIFICA TIZIANO - TESTATINE

% % --------------------------
% % HEADER AND FOOTER
% % --------------------------
% % Now define how headers and footers will appear on common pages.
% % The twoside structure means LE/RO are opposite positions on even and odd pages.
% % Here we put:
% % - On left pages (even pages): author on the left (RE), short title on the right (RO)
% % - On right pages (odd pages): short title on the left (LE), author on the right (LO)
% % Footer: page number centered (C)
% \fancyhead{}
% \fancyfoot{}
% \renewcommand\headrule{%
%   \vspace{-14.5pt}  % Aggiungi spazio negativo per posizionare la linea
%   \hrulefill     % Crea una linea orizzontale a sinistra
%   \hspace{50pt}  % Aggiungi uno spazio orizzontale (regola la dimensione a piacere)
%   \hrulefill     % Crea una linea orizzontale a destra
% }
% \renewcommand{\chaptermark}[1]{\markboth{#1}{}}
% \fancyhead[L]{\leftmark}
% \fancyhead[R]{\DDorganization}
% \fancyhead[C]{%
%   \raisebox{-0.6\height}{%
%     \href{https://hknpolito.org/}{\includegraphics[height=1cm]{\DDsmalllogo}}%
%   }%
% }
% \fancyfoot[C]{\thepage}
% \setlength{\headheight}{30pt} % Avoids warnings about head height
% \addtolength{\topmargin}{-20pt} % Corrects top margin for header

\fancyhead{}            % Clear headers, just for precaution (good practice)
\fancyfoot{}            % Clear footers, just for precaution (good practice)

\makeatletter           % Rende la @ un carattere normale, utilizzabile per comandi

% NOTA: LaTeX utilizza di default \MakeUppercase per forzare i titoli in maiuscolo nelle testatine.
% NOTA: se vuoi titoli nella testatina in maiuscolo, basta aggiungere \MakeUppercase{} attorno gli argomenti di
% \markboth e \markright nei comandi sopra: se lo fai, ricorda anche di farlo per i comandi custom \uchapter,
% \usection[]{}, e \usubsubsection[]{}, per mantenere coerenza di stile. FATTO IN AUTOMATICO, con modifica di markboth e
% markright, e con la creazione di uchaptermark e usectionmark.
% NOTA: la testatina della licenza è impostata più avanti, prima della sua chiamata con input.
% Se modifiche lo stile, modifica anche quello per coerenza. FATTO IN AUTOMATICO, con modifica di markboth e markright.
% NOTA: in pratica si potrebbero modificare, invece che \sectionmark e \chaptermark, direttamente \rightmark e
% \markboth. Tuttavia si tratta di primitive di basso livello, che è utile che si comportino in modo standard, per
% eventuale uso manuale. ATTENZIONE NON SI PUÒ FARE PER TUTTE LE FUNZIONI: infatti servono comportamenti diversi per
% markboth e markright, in funzione che si tratti di capitoli o sezioni. Si può quindi fare solo per il case del
% carattere. FATTO COSÌ!
% NOTA: la bibliografia, così come l'indice analitico, la lista delle tabelle, la lista delle figure, se presenti,
% generano la loro testatina da se! Qualora li si aggiunga al documento, VANNO SISTEMATI CASO PER CASO. Qui per ora
% è stato sistemato solo il caso della bibliografia, con la creazione di un heading style custom, che chiama \uchapter
% per generarla (in alternativa, copiaci dentro lo stesso codice), che chiama il markboth modificato!.
% AGGIORNAMENTO: testatine corrette anche per LOF e LOT, con la sovrascrittura dei comandi \listoffigures e
% \listoftables. manca solo l'indice analitico, caso diverso (essendo un enviroment), ma è probabile che non serva in
% questo progetto.

% NOTA: si potrebbe aggiungere un opzione alla classe "HeaderCase=upper" o "HeaderCase=normal" per attivare o
% disattivare il maiuscolo forzato in modo comodo, ovviamente aggiungendo un controllo condizionale nei comandi sopra.
% FATTO A SEGUIRE!

% AGGIORNAMENTO: CREAZIONE DI INTERFACCIA DI SELEZIONE LAYOUT TESTATINA CON PGFKEYS (si potrebbero usare anche solo
% direttive interne di basso livello)

% 1. VARIABILI DI STATO (Boolean flags)
\newif\ifHKN@hdrUpperCase           % Flag: se true, i titoli nelle testatine saranno tutti in maiuscolo
\newif\ifHKN@hdrChapLabel           % Flag: se true, viene stampata l'etichetta \chaptername nella testatina, ossia
                                    % "Capitolo" o "Chapter" in funzione della lingua attiva.
\newif\ifHKN@hdrBriefLabel          % Flag: se true, l'eticehtta sopra è stampata in forma abbreviata (disponibile solo
                                    % per italiano, "Cap.", e inglese, "Ch.").
\newif\ifHKN@hdrNumberLabel         % Flag: se true, viene aggiunta nella testatina l'etichetta numerica ai capitoli e
                                    % alle sezioni numerati, dichiarate con \chapter e \section
                                    % NOTA: andrebbero usate numerate solo nel mainmatter! Nel frontmatter e backmatter
                                    % la numerazione capitoli è disattivata, ma non quella delle sezioni (numerazioni
                                    % sezioni sballa). Allora o usi le versioni stellate delle sottodivisoni, ad esempio
                                    % \section* (ma in quel caso non vanno nell'indice o nella testatina), o usi
                                    % le macro custom unnumbered but indexed, come \usection, che risolvono questi
                                    % problemi: numerazione annullata, ma compaiono in indice e testatina.


% 2. INTERFACCIA DI CONTROLLO (pgfkeys) CON GESTIONE DELLE ECCEZIONI O ERRORI
% ATTENZIONE alla FORMATTAZIONE all'interno di pgfkeys: è molto rigido, non usare righe vuote, e ci devono essere solo
% virgole per separare le coppie chiave-valore. Per aggiungere spazi, commentali per annullarne l'effetto.
% NOTA: è stato usato pgfkeys come esercizio di programmazione, essendo molto versatile e potente. Tuttavia lo stesso
% identico risultato (cioè usare booleani per modificare il comporament delle funzioni modificatrici dichiarate a
% seguire), si può ottenere anche con le primitive di basso livello di TeX (incluso il controllo dell'esistenza dei
% booleani). Si dovrebbe poi creare un'interfaccia di gestione apposita, se non si vuole che l'utente finale stia a
% scrivere i booleani.

\pgfkeys{
    /HKNhdr/.is family,             % Dichiara una nuova famiglia di chiavi, nella folder /HKNhdr (hdr: sta per header)
    /HKNhdr,                        % Attiva il percorso suddetto come default (solo per le prossime dichiarazioni)
    %
    % GESTIONE DEL MAIUSCOLO (is choice crea un menu chiuso)
    HeaderCase/.is choice,                                             % Dichiara la chiave HeaderCase come scelta multipla (choice)
    HeaderCase/upper/.code  = {\HKN@hdrUpperCasetrue},                 % Se usata setta true il flag per il maiuscolo forzato
    HeaderCase/normal/.code = {\HKN@hdrUpperCasefalse},                % Se usata setta false il flag per il maiuscolo forzato
    HeaderCase/.unknown/.code = {%                                     % Gestione Eccezioni: avvisa l'utente se usa valori non ammessi
        \ClassError{HKNdocument}{%                                      % Tipo di errore: errore di classe, custom class HKNdocument
            Invalid value for key HeaderCase.\MessageBreak             % Messaggio stampato nell'errore
            Allowed values are: upper, normal%
        }{%
            Check your \string\setupHeaders\space options for typos.%   % Messaggio di help (scrivi h nel terminale
            %                                                           % dopo blocco compilazione per visualizzarlo)
        }%
    },
    HeaderCase = normal,                                                           % Imposta il valore di default della key: se l'utente non specifica nulla, usa questo
    % GESTIONE ETICHETTA CHAPTER
    ChapterLabel/.is choice,                                                        % Dichiara la chiave ChapterLabel come scelta multipla (choice)
    ChapterLabel/absent/.code = {\HKN@hdrChapLabelfalse},                           % Se usata, setta false il flag per stampare l'etichetta "capitolo"
    ChapterLabel/normal/.code = {\HKN@hdrChapLabeltrue \HKN@hdrBriefLabelfalse},    % Se usata, setta true il flag per stampare l'etichetta "capitolo", ma falso per la versione breve
    ChapterLabel/brief/.code  = {\HKN@hdrChapLabeltrue \HKN@hdrBriefLabeltrue},     % Se usata, setta ture i 2 flag per stampare l'etichetta "capitolo" in forma breve
    ChapterLabel/.unknown/.code = {%                                                % Gestione Eccezioni: avvisa l'utente se usa valori non ammessi
        \ClassError{HKNdocument}{%                                                  % Tipo di errore: errore di classe, custom class HKNdocument
            Invalid value for key ChapterLabel.\MessageBreak                        % Messaggio stampato nell'errore
            Allowed values are: absent, normal, brief%
        }{%
            Check your \string\setupHeaders\space options for typos.%               % Messaggio di help (scrivi h nel terminale dopo blocco compilazione per visualizzarlo)
        }%
    },
    ChapterLabel = absent,                                                          % Imposta il valore di default della key: se l'utente non specifica nulla, usa questo
    % GESTIONE ETICHETTA NUMERICA
    NumberLabel/.is choice,                                                         % Dichiara la chiave NumberLabel come scelta multipla (choice)
    NumberLabel/absent/.code = {\HKN@hdrNumberLabelfalse},                          % Se usata, setta false il flag per stampare l'etichetta numerica
    NumberLabel/normal/.code = {\HKN@hdrNumberLabeltrue},                           % Se usata, setta false il flag per stampare l'etichetta numerica
    NumberLabel/.unknown/.code = {%                                                 % Gestione Eccezioni: avvisa l'utente se usa valori non ammessi
        \ClassError{HKNdocument}{%                                                  % Tipo di errore: errore di classe, custom class HKNdocument
            Invalid value for key NumberLabel.\MessageBreak                         % Messaggio stampato nell'errore
            Allowed values are: absent, normal%
        }{%
            Check your \string\setupHeaders\space options for typos.%               % Messaggio di help (scrivi h nel terminale dopo blocco compilazione per visualizzarlo)
        }%
    },
    NumberLabel = absent,                                                           % Imposta il valore di default della key: se l'utente non specifica nulla, usa questo
    % GESTIONE ERRORI PER CHIAVI INESISTENTI
    % Se l'utente sbaglia a digitare il NOME della chiave (es. CapterLabel=brief),scatta l'unknown generale della
    % famiglia. \pgfkeyscurrentname contiene il nome della chiave sbagliata.
    .unknown/.code = {%                                                             % Gestione Eccezioni: avvisa l'utente se usa key non ammesse
        \ClassError{HKNdocument}{%                                                  % Tipo di errore: errore di classe, custom class HKNdocument
            Unknown key '\pgfkeyscurrentname' used in header setup.\MessageBreak    % Messaggio stampato dall'errore
            Allowed keys are: HeaderCase, ChapterLabel, NumberLabel%
        }{%
            Please read the class documentation or check for typos.%                % Messaggio di help (scrivi h nel terminale dopo blocco compilazione per visualizzarlo)
        }%
    },
}

% Valori di default iniziali: COMMENTATI PERCHÈ INSERITI DIRETTAMENTE DOPO LE DICHIARAZIONI
% \pgfkeys{/HKNhdr, HeaderCase=normal, ChapterLabel=absent, NumberLabel=absent}

% Comando per l'utente finale: interfaccia di alto livello, che accetta direttamente la lista separate da virgole e
% spazi (o "a capo").
% NOTA: il comando a seguire è \pgfqkeys e non \pgfkeys: quella "q" in più sta per "quick": è una versione del comando
% più veloce, che accetta due argomenti: la cartella dove cercare le chiavi, e la lista di valori.
% La velocità superiore consiste proprio in questa separazione degli argomenti: sostanzialmente il parser si risparmia
% una parte del lavoro! È la best practice per dichiare i comandi di impostazione!
% Si sarebbe potuto usare anche:
% \newcommand{\setupHeaders}[1]{\pgfkeys{/HKNhdr, #1}}
% Oppure: metodo generale, quando la cartella dove si ricerca non è dichiarata come una famiglia: va aggiunto un .cd
% per change directory (le folder delle keys).
% \newcommand{\setupHeaders}[1]{\pgfkeys{/HKNhdr/.cd, #1}}
% Qui non è necessario, in quanto (dalla documentazione del pacchetto pgfkeys), se si dichiara una stringa come famiglia
% di chiavi, come "/HKNhdr", allora ad ogni chiamata di questa è aggiunto in automatico un .cd.
\newcommand{\setupHeaders}[1]{\pgfqkeys{/HKNhdr}{#1}}

% 3. MODIFICATORI E FILTRI (Logica di formattazione)

% Filtro Case: applica il maiuscolo se richiesto
\newcommand{\HKNcase}[1]{%
    \ifHKN@hdrUpperCase
        \MakeUppercase{#1}%
    \else
        #1%
    \fi
}

% Generatore Etichetta Chapter Breve: in italiano scrive Cap., altrimenti Ch. (inglese default per ogni altra lingua,
% in caso va modificato a mano per altre lingue, ma inglese ed italino sono le uniche supportate dal progetto).
% Invece il nome completo è scritto col comando "\chaptername", che gestisce tutte le lingue.
\newcommand{\HKNbrieflabel}{\iflanguage{italian}{Cap.}{Ch.}}

% Generatore Etichetta Chapter: costruisce l'etichetta prima del numero del capitolo.
% Controlla se farla, e poi se farla completa o abbreviata.
\newcommand{\HKNchaplabel}{%
    \ifHKN@hdrChapLabel%
        \ifHKN@hdrBriefLabel%
            \HKNbrieflabel\space%
        \else%
            \chaptername\space%
        \fi%
    % \else%
    %     \relax%                           % Comando filler: è meglio omettere del tutto l'else per le prestazioni.
    \fi%
}

% Generatore Etichetta Numerica Chapter: costruisce l'etichetta con numero del capitolo.
% Controlla se stamparla
\newcommand{\HKNnumchaplabel}{%
    \ifHKN@hdrNumberLabel%
        \thechapter.\ %                     % la stringa "\ " forza la stampa di uno spazio dopo il numero del capitolo
    % \else%
    %     \relax%                           % Comando filler: è meglio omettere del tutto l'else per le prestazioni.
    \fi%
}

% Generatore Etichetta Numerica Section: costruisce l'etichetta con numero della sezione.
% Controlla se stamparla
\newcommand{\HKNnumseclabel}{%
    \ifHKN@hdrNumberLabel%
        \thesection.\ %                     % la stringa "\ " forza la stampa di uno spazio dopo il numero della sezione
    % \else%
    %     \relax%                           % Comando filler: è meglio omettere del tutto l'else per le prestazioni.
    \fi%
}

% 4. APPLICAZIONE
% --- TITOLI DEI CAPITOLI (chiamati con \chapter) NELLE TESTATINE ---
% Quando inizia un capitolo: riempie sia SX che DX col nome del capitolo, in modo che se non sono presenti sezioni,
% comunque la testatina non rimane vuota (fallback al nome del capitolo).
% NOTA: Se non vuoi il numero del capitolo, rimuovi "\thechapter.\ " da entrambe le parentesi.
% In precisione compare un punto dopo il numero del capitolo, poi uno spazio, come nel comporatmento standard di book.
% NOTA: controllo condizionale: aggiunge il numero di capitolo solo nel mainmatter, come di default in book.

% WRAPPER PER APPLICARE HKNcase in generale
\let\OLDmarkboth=\markboth
\let\OLDmarkright=\markright
\renewcommand{\markboth}[2]{\OLDmarkboth{\HKNcase{#1}}{\HKNcase{#2}}}
\renewcommand{\markright}[1]{\OLDmarkright{\HKNcase{#1}}}

% RIDEFINIZIONE CHAPTERMARK
\renewcommand{\chaptermark}[1]{%
    \if@mainmatter%
        \markboth{\HKNchaplabel\HKNnumchaplabel{}#1}{\HKNchaplabel\HKNnumchaplabel{}#1}%
        % Graffe dopo numlabel per evitare pronlemi di spazi e formattazione: spazi inseriti già dalle etichette!
    \else%
        \markboth{#1}{#1}%
    \fi%
}

% NON NECESSARIO: meglio usare direttamente \markboth modificato, come in origine: tanto sarebbe aggiunta solo la label
% CAPITOLO, che nei capitoli non numerati non ha molto senso (Avranno sicuramente un nome speciale, infatti).
% % RIDEFINIZIONE CHAPTERMARK per CAPITOLI NON NUMERATI generati con uchapter
% \newcommand{\uchaptermark}[1]{%
%     \if@mainmatter%
%         \markboth{\HKNchaplabel{}#1}{\HKNchaplabel{}#1}%
%     \else%
%         \markboth{#1}{#1}%
%     \fi%
% }

% --- TITOLI DELLE SEZIONI (chiamate con \section) NELLE TESTATINE ---
% Quando inizia una sezione: sovrascrive SOLO la memoria di DX.
% NOTA: Se non vuoi il numero della sezione, rimuovi "\thesection.\ ".
% In precisione compare un punto dopo il numero della sezione, poi uno spazio, come nel comporatmento standard di book.

% \renewcommand{\sectionmark}[1]{%
%     \if@mainmatter%
%         \markright{\thesection.\ #1}%
%     \else%
%         \markright{#1}%
%     \fi%
% }

\renewcommand{\sectionmark}[1]{\markright{\HKNnumseclabel{}#1}}
    % Graffe dopo numlabel per evitare pronlemi di spazi e formattazione: spazi inseriti già dalle etichette!


% Perchè ho disattivato la prima versione: Comunque compare il 0.1, 0.2... per le sezioni del frontmatter nella PAGINA
% DI INIZIO SEZIONE. Andrebbe modificato dunque eventualmnete anche il comando che ne stampa il titolo della sezione ad
% inizio sezione, per evitare confusione. Per questo lascio il numero di sezione nella testatina anche nel frontmatter.
% In ogni caso NON SI DOVREBBERO USARE SEZIONI NUMERATE NEL FRONTMATTER e nel BACKMATTER! Usa in caso il comando
% \section*{} per evitare numerazione e presenza in testatina e nell'indice: ma attenzione in quanto i comandi stellati
% non aggiornano le testatine! Ho creato i comandi custom "unnumbered" appositamente per risolvere questi problemi: usa
% \usection se vuoi reinserire nella testatina e nell'indice (non stampa numero) la sezione non numerata, ma che compare
% nell'indice e nella testatina.

% NON NECESSARIO: meglio usare direttamente \markritgh modificato, come in origine. Tanto consiste solo in quello.
% RIDEFINIZIONE SECTIONMARK per SEZIONI NON NUMERATE, generate con \usection
% \newcommand{\usectionmark}[1]{\markright{#1}}

\makeatother            % Rende di nuovo la @ un carattere non utilizzabile per comandi (protezione)

%---------------------------------------------
% DISPOSIZIONE FISICA SULLA PAGINA (Il Layout)

% Pagine PARI (Even - Foglio di Sinistra)
\fancyhead[LE]{\leftmark}           % Leftmark (Nome Capitolo) sul margine ESTERNO (SX)
\fancyhead[RE]{\DDorganization}     % Nome Associazione sul margine INTERNO (DX)

% Pagine DISPARI (Odd - Foglio di Destra)
\fancyhead[LO]{\DDorganization}     % Nome Associazione sul margine INTERNO (SX)
\fancyhead[RO]{\rightmark}          % Righmark (Nome Sezione, o fallback Capitolo) sul margine ESTERNO (DX)

% Logo sempre al CENTRO (su tutte le pagine)
\fancyhead[C]{%
  \raisebox{-0.6\height}{%
    \href{https://hknpolito.org/}{\includegraphics[height=1cm]{\DDsmalllogo}}%
  }%
}

\renewcommand{\headrule}{%
    \vspace{-14.5pt}%               % Forza la posizione della linea più in alto, vicina al testo della testatina
    \hrulefill%                     % Disegna la linea orizzontale, regolando elasticamente lo spazio
    \hspace{50pt}%                  % Aggiunge uno spazio orizzontale vuoto (al centro, per far spazio al logo)
    \hrulefill%                     % Disegna la linea orizzontale dopo lo spazio, regolando lo spazio
    % EFFETTO COMPLESSIVO: le linee si esdpando a sx e a dx dell'hspace con la stessa "forza elastica": lo spazio bianco
    % si troverà di conseguenza sempre al centro.
}

\setlength{\headheight}{30pt}       % Aumenta l'altezza della testatina per accogliere il logo evitando warnings
\addtolength{\topmargin}{-20pt}     % Avendo aumentato l'altezza della testatina, viene corretto il margine superiore
                                    % alzandone la posizione di 20pt (esatti sarebbe 18pt, essendo di default 12pt).

\fancyfoot[C]{\thepage}             % Numero di pagina centrato nel piedino di pagina

% ______________________________________________________________________________ FINE MODIFICA TIZIANO - TESTATINE


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

% --------------------------------
% CHAPTER COMMAND WRAPPER (xparse)
% --------------------------------
% Conserva il comando nativo della classe book
\let\oldchapter\chapter             % Backup del comando originale
                                    % Supporta la variante con *, come lo stesso comando chapter.

% Ridefinisce \chapter per disaccoppiare TOC e Header, e gestire i capitoli stellati
% Testatina: usa sempre titolo breve
% Indice: usa sempre titolo lungo (di norma LaTeX invierebbe il breve)
% Aggiunto supporto per titoli brevi a capitoli stellati

\RenewDocumentCommand{\chapter}{ s o m }{%
    \IfBooleanTF{#1}{%
        % CASO 1:                   % Capitolo stellato \chapter*
        \IfNoValueTF{#2}{%
            % CASO 1-A:             % chapter* Senza titolo breve \chapter*[]{Lungo}
            \oldchapter*{#3}%       % Invia il titolo LUNGO alla pagina
            \chaptermark{#3}%       % Aggiorna l'header anche se non numerato
        }{%
            % CASO 1-B:             % chapter* con titolo breve \chapter*[Breve]{Lungo}
            \oldchapter*{#3}%       % Invia il titolo LUNGO alla pagina
            \chaptermark{#2}%       % Sovrascrive l'header con il titolo BREVE
            %                       % Non invia nulla al ToC, come di norma per \chapter*.
            %                       % Se vuoi che compaia nell'indice, usa la custom macro \uchapter.
        }%
    }{%
        % CASO 2:                   % Capitolo normale \chapter
        \IfNoValueTF{#2}{%
            % CASO 2-A:             % chapter Senza titolo breve \chapter[]{Lungo}
            \oldchapter{#3}%        % Comportamento standard: invia il titolo LUNGO al TOC e alla pagina
        }{%
            % CASO 2-B:             % chapter con titolo breve \chapter[Breve]{Lungo}
            \oldchapter{#3}%        % Invia il titolo LUNGO al TOC e alla pagina
            \chaptermark{#2}%       % Sovrascrive l'header con il titolo BREVE
        }%
    }%
}

% --------------------------------
% SECTION COMMAND WRAPPER (xparse)
% --------------------------------
% Nato per risolvere gli stessi problemi di disaccoppiamento : i titoli corti devono andare solo negli header, mentre
% quelli lunghi devono andare in pagina e in indice. Inoltre aggiunto supporto ai titolli corti per le sezioni stellate.

% NOTA BENE: ALTRI WRAPPER PER LE ALTRE DIVISIONI?
% Per gli altri comandi legati alle divisioni o struttura del documento, come, \part, \subsection, \subsubsection,
% \paragraph, e \subparagraph, visto che non vengono mai stampati nella testatina, si consiglia semplicemente di non
% usare i titoli brevi (che ammettono tutti), se si vuole che nell'indice \compaiano i titoli lunghi.

% Conserva il comando nativo della classe book
\let\oldsection\section             % Backup del comando originale
                                    % Supporta la variante con *, come lo stesso comando section.

% Ridefinisce \section per disaccoppiare TOC e Header, e gestire le sezioni stellate
% Testatina: usa sempre titolo breve
% Indice: usa sempre titolo lungo (di norma LaTeX invierebbe il breve)
% Aggiunto supporto per titoli brevi a sezioni stellate

\RenewDocumentCommand{\section}{ s o m }{%
    \IfBooleanTF{#1}{%
        % CASO 1:                   % Sezione stellata \section*
        \IfNoValueTF{#2}{%
            % CASO 1-A:             % section* Senza titolo breve \section*[]{Lungo}
            \oldsection*{#3}%       % Invia il titolo LUNGO alla pagina
            \sectionmark{#3}%       % Aggiorna l'header anche se non numerato
        }{%
            % CASO 1-B:             % section* con titolo breve \section*[Breve]{Lungo}
            \oldsection*{#3}%       % Invia il titolo LUNGO alla pagina
            \sectionmark{#2}%       % Sovrascrive l'header con il titolo BREVE
            %                       % Non invia nulla al ToC, come di norma per \section*.
            %                       % Se vuoi che compaia nell'indice, usa la custom macro \usection.
        }%
    }{%
        % CASO 2:                   % Sezione normale \section
        \IfNoValueTF{#2}{%
            % CASO 2-A:             % section Senza titolo breve \section[]{Lungo}
            \oldsection{#3}%        % Comportamento standard: invia il titolo LUNGO al TOC e alla pagina
        }{%
            % CASO 2-B:             % section con titolo breve \section[Breve]{Lungo}
            \oldsection{#3}%        % Invia il titolo LUNGO al TOC e alla pagina
            \sectionmark{#2}%       % Sovrascrive l'header con il titolo BREVE
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

% ______________________________________________________________________________ INIZIO MODIFICA TIZIANO - COMMENTI COLORI
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
% ______________________________________________________________________________ FINE MODIFICA TIZIANO - COMMENTI COLORI

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
% ______________________________________________________________________________ INIZIO MODIFICA TIZIANO - HKNbox
\DeclareHKNBox{proposition}{Proposizione}{Proposition}{munuLightBlue}
% ______________________________________________________________________________ INIZIO MODIFICA TIZIANO - HKNbox

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
% ______________________________________________________________________________ INIZIO MODIFICA TIZIANO - TESTATINA LICENZA
    \iflanguage{italian}{%
        \markboth{Presentazione e Licenza}{Presentazione e Licenza}%            % Scrittura Testatina sx e dx in ita
    }{%
        \markboth{Overview and License}{Overview and License}%                  % Scrittura Testatina sx e dx in eng
    }
% ______________________________________________________________________________ FINE MODIFICA TIZIANO - TESTATINA LICENZA
% ______________________________________________________________________________ INIZIO MODIFICA TIZIANO - COLORI ToC e License
    % Spostati nel mainmatter per gestire la colorazione tutti in un posto, e sfruttare le definizioni di macro già
    % introdotte fuori dalla custom class. In Futuro: semplicemente va centralizzata la gestione colori nella class.
    %
    % \input{cclicense.tex}
    % \tableofcontents
    % \clearpage                % Non necessario, \tableofcontents lancia di perse \clearpage.
% ______________________________________________________________________________ FINE MODIFICA TIZIANO - COLORI ToC e License
% ______________________________________________________________________________ INIZIO MODIFICA TIZIANO - MAINMATTER
    %\mainmatter
    % IMPORTANTE DISATTIVARLA: altrimenti se si richiama di nuovo successivamente il frontmatter, la numerazione romana
    % delle pagine rinizia da capo, sballando dunque tutta la numerazione.
% ______________________________________________________________________________ FINE MODIFICA TIZIANO - MAINMATTER
}
\AfterEndDocument{
    \backmatter
    \input{_postamble.tex}
}
