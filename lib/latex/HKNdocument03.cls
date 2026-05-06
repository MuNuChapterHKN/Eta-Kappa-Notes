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
\ProvidesClass{HKNdocument03}[2026/04/28 v3.0 Base class for publishing]

% CREATA IL 2026-04-28 PER REFACTOR CODICE TESTATINE

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CODICE ORIGINALE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%------- SPIEGAZIONE INIZIALE FUNZIONAMENTO TESTATINE - FONDAMENTALE PER CAPIRE COME APPLICARE MODIFICHE

\fancyhead{}            % Pulizia Precauzionale delle testatine
\fancyfoot{}            % Clear footers, just for precaution (good practice)

\makeatletter           % Rende la @ un carattere normale, utilizzabile per comandi

% NOTA: Di default, LaTeX utilizza \MakeUppercase per forzare i titoli in maiuscolo nelle testatine.
% NOTA: se vuoi titoli nella testatina in maiuscolo, o in generale per altre modifiche puramente dello stile di quanto
% già presente, è sufficiente modificare il contenuto dei comandi \fancyhead, che si occupano solo della stampa di
% testatina (header) e piè di pagina (footer). In generale, per pure modifiche di stile, non è necessario toccare i
% comandi di marks.
% NOTA: i comandi di marks sono \chaptermark, \sectionmak, \markboth, \markright (\leftmark non esiste in LaTeX default,
% perché non ha senso aggiornare il capitolo senza toccare le sezioni (rightmark).



% basta usare \MakeUppercase{} attorno gli argomenti di
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
% \listoftables. manca solo l'indice analitico, caso diverso (essendo un environment), ma è probabile che non serva in
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
\newif\ifHKN@hdrBriefLabel          % Flag: se true, l'etichetta sopra è stampata in forma abbreviata (disponibile solo
                                    % per italiano, "Cap.", e inglese, "Ch.").
\newif\ifHKN@hdrNumberLabel         % Flag: se true, viene aggiunta nella testatina l'etichetta numerica ai capitoli e
                                    % alle sezioni numerati, dichiarate con \chapter e \section
                                    % NOTA: andrebbero usate numerate solo nel mainmatter! Nel frontmatter e backmatter
                                    % la numerazione capitoli è disattivata, ma non quella delle sezioni (numerazioni
                                    % sezioni sballa). Allora o usi le versioni stellate delle sottodivisioni, ad
                                    % esempio \section* (ma in quel caso non vanno nell'indice o nella testatina), o usi
                                    % le macro custom unnumbered but indexed, come \usection, che risolvono questi
                                    % problemi: numerazione annullata, ma compaiono in indice e testatina.


% 2. INTERFACCIA DI CONTROLLO (pgfkeys) CON GESTIONE DELLE ECCEZIONI O ERRORI
% ATTENZIONE alla FORMATTAZIONE all'interno di pgfkeys: è molto rigido, non usare righe vuote, e ci devono essere solo
% virgole per separare le coppie chiave-valore. Per aggiungere spazi, commentali per annullarne l'effetto.
% NOTA: è stato usato pgfkeys come esercizio di programmazione, essendo molto versatile e potente. Tuttavia lo stesso
% identico risultato (cioè usare booleani per modificare il comportamento delle funzioni modificatrici dichiarate a
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
    % Se l'utente sbaglia a digitare il NOME della chiave (es. ChapterLabel=brief),scatta l'unknown generale della
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

% Valori di default iniziali: COMMENTATI PERCHÉ INSERITI DIRETTAMENTE DOPO LE DICHIARAZIONI
% \pgfkeys{/HKNhdr, HeaderCase=normal, ChapterLabel=absent, NumberLabel=absent}

% Comando per l'utente finale: interfaccia di alto livello, che accetta direttamente la lista separate da virgole e
% spazi (o "a capo").
% NOTA: il comando a seguire è \pgfqkeys e non \pgfkeys: quella "q" in più sta per "quick": è una versione del comando
% più veloce, che accetta due argomenti: la cartella dove cercare le chiavi, e la lista di valori.
% La velocità superiore consiste proprio in questa separazione degli argomenti: sostanzialmente il parser si risparmia
% una parte del lavoro! È la best practice per dichiarare i comandi di impostazione!
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
% in caso va modificato a mano per altre lingue, ma inglese ed italiano sono le uniche supportate dal progetto).
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
% In precisione compare un punto dopo il numero del capitolo, poi uno spazio, come nel comportamento standard di book.
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
        % Graffe dopo numlabel per evitare problemi di spazi e formattazione: spazi inseriti già dalle etichette!
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
% In precisione compare un punto dopo il numero della sezione, poi uno spazio, come nel comportamento standard di book.

% \renewcommand{\sectionmark}[1]{%
%     \if@mainmatter%
%         \markright{\thesection.\ #1}%
%     \else%
%         \markright{#1}%
%     \fi%
% }

\renewcommand{\sectionmark}[1]{\markright{\HKNnumseclabel{}#1}}
    % Graffe dopo numlabel per evitare problemi di spazi e formattazione: spazi inseriti già dalle etichette!


% Perché ho disattivato la prima versione: Comunque compare il 0.1, 0.2... per le sezioni del frontmatter nella PAGINA
% DI INIZIO SEZIONE. Andrebbe modificato dunque eventualmente anche il comando che ne stampa il titolo della sezione ad
% inizio sezione, per evitare confusione. Per questo lascio il numero di sezione nella testatina anche nel frontmatter.
% In ogni caso NON SI DOVREBBERO USARE SEZIONI NUMERATE NEL FRONTMATTER e nel BACKMATTER! Usa in caso il comando
% \section*{} per evitare numerazione e presenza in testatina e nell'indice: ma attenzione in quanto i comandi stellati
% non aggiornano le testatine! Ho creato i comandi custom "unnumbered" appositamente per risolvere questi problemi: usa
% \usection se vuoi reinserire nella testatina e nell'indice (non stampa numero) la sezione non numerata, ma che compare
% nell'indice e nella testatina.

% NON NECESSARIO: meglio usare direttamente \markright modificato, come in origine. Tanto consiste solo in quello.
% RIDEFINIZIONE SECTIONMARK per SEZIONI NON NUMERATE, generate con \usection
% \newcommand{\usectionmark}[1]{\markright{#1}}

\makeatother            % Rende di nuovo la @ un carattere non utilizzabile per comandi (protezione)


% --- AGGIORNAMENTO 2026-27-04 - FIX BUGS TESTATINE \chapter* e \uchapter, e \section* e \usection ---
%
% Nelle versioni precedenti del codice era presente un BUG: nel codice della custom class, a seguire, vengono modificati
% i comandi nativi per \chapter e \section, con l'obiettivo di:
% - aggiungere il supporto ai titoli brevi opzionali anche per le versioni stellate (\chapter* e \section*)
% - le versioni non stellate (\chapter e \section) devono inviare al ToC il titolo lungo obbligatorio, invece di quello
%   breve opzionale
% - le versioni stellate (\chapter* e \section*) devono inviare comunque il titolo lungo obbligatorio al ToC (di norma
%   non lo inviano)
% - le versioni non stellate (\chapter e \section) devono inviare alla testatina il titolo breve opzionale se c'è,
%   altrimenti il titolo lungo obbligatorio, come in LaTeX standard.
% - le versioni stellate (\chapter* e \section*) devono inviare alla testatina il titolo breve opzionale se c'è,
%   altrimenti il titolo lungo obbligatorio (in LaTeX standard non inviano nulla alla testatina, e rimane quella della
%   sezione precedente, o del capitolo precedente se non c'è una sezione prima, con risultati sballati).
% - sia nel caso stellato che non stellato, il comando \chapter riempie sia il leftmark che il rightmark, così se alle
%   pagine dopo non viene chiamata una sezione, la testatina non sarà vuota è conterrà il capitolo, l'ultimo avviato.
%
% [NOTA: ricorda che di norma SOLO chapter è programmato in modo da essere sensibile al frontmatter e al backmatter:
% quando è chiamato in essi, si comporta esattamente come il mio \uchapter, cioè stampa il titolo senza etichetta
% "CAPITOLO X" (senza numero dunque), ma AGGIORNA l'INDICE e LA TESTATINA (tuttavia di standard usa il titolo breve,
% ma io ho corretto il comportamento). Quindi in sostanza, \chapter in backmatter e frontmatter è indistinguibile da
% \uchapter]
%
% Comunque le correzioni citate consistono in una sovrascrittura di funzioni di base, che a mia idea è un po' assurdo
% che non siano fornite di base come opzioni, dalla classe book. Se ho capito bene, la superclass memoir (modifica di
% book) le offre, insieme a tanto altro.
%
% Il punto fondamentale è che per poter correggere questi comportamenti in modo esatto, è fondamentale conoscere come
% funzionano le testatine in LaTeX, in particolare la loro memoria, che non è affatto una cosa banale purtroppo. Ho
% formulato personalmente un mio modello, che spiega esattamente cosa accade di DEFAULT in LaTeX. Successivamente, si
% potrà quindi capire l'effetto delle modifiche ai comandi.


% ======================================================================================================================
% MODELLO TEORICO DELLA MEMORIA DELLE TESTATINE IN (La)TeX - COMPORTAMENTO DI DEFAULT - I MARKS (leftmark, rightmark)
% ======================================================================================================================
% Questo modello descrive il meccanismo asincrono e asimmetrico con cui TeX gestisce i "post-it" (marks) per le
% testatine, modellizzandolo come un array tridimensionale. È lo strumento definitivo per prevedere e fare debug del
% comportamento di \leftmark e \rightmark.
% NOTA: in realtà LaTeX non fa storage di tutti i mark, ma sovrascrive la stessa parte di ram ad ogni pagina
% (fondamentale per non saturare la ram dei pc anni '80).
%
% ----------------------------------------------------------------------------------------------------------------------
% 1. IL CONTENITORE (MemoriaTestatina)
% La memoria delle testatine può essere modellizzata come un array: M(n, k, m)
%    Dove:
% - n = Numero identificativo della pagina corrente
% - k = Scompartimento: 1 = SINISTRA (Pagine PARI, Testatina: Capitoli), 2 = DESTRA (Pagine DISPARI, Testatina: Sezioni)
% - m = Indice cronologico della scrittura all'interno della singola pagina 'n' (m=1 per il primo comando lanciato, m=2
%       per il secondo, ecc.: si intendono i comandi di scrittura: markboth e markright).
%
% NOTA TECNICA SULLA STRUTTURA: TeX non salva scompartimenti isolati. Ogni volta che si esegue una scrittura, TeX crea
% un "post-it" contenente la COPPIA [ Sx | Dx ], incrementando 'm'. Lo stato globale, che contiene i valori sia per
% pagina Sx che Dx, esiste a prescindere dal fatto che la pagina in elaborazione diventerà pari (Sx) o dispari (Dx).
%
% ----------------------------------------------------------------------------------------------------------------------
% 2. I COMANDI DI SCRITTURA (Come si popola l'array)
% - \markboth{A}{B} : Aggiorna ENTRAMBI gli scompartimenti. Genera un nuovo record m: M(n, 1, m) = A  |  M(n, 2, m) = B
% - \markright{B}   : Aggiorna SOLO lo scompartimento destro. Trascinando il vecchio sinistro, genera: M(n, 1, m) = M(n,
%                     1, m-1) [vecchio sx]  |  M(n, 2, m) = B
% - \markleft       : Comando INESISTENTE in LaTeX standard (richiede pacchetti extra) poiché tipograficamente non ha
%                     senso aggiornare il macro-livello (Capitolo) senza pulire il micro-livello (Sezione).
%
% COMANDI STRUTTURALI BASE:
% - \chapter : Esegue internamente \markboth{Capitolo}{}, svuotando la destra. Inoltre applica \thispagestyle{plain} per
%              spegnere la testatina su quella prima pagina (mantenendo solo il numero in basso).
% - \section : Esegue internamente \markright{Sezione}, aggiornando solo la destra.
%
% ----------------------------------------------------------------------------------------------------------------------
% 3. EREDITARIETÀ (Gestione delle pagine senza nuovi comandi, m=0) Se nella pagina 'n' non viene eseguito alcun nuovo
%    comando di mark (l'array degenererebbe a m=0), il motore compensa a posteriori durante lo shipout. Clona l'ultimo
%    stato noto della pagina precedente, iniettandolo virtualmente come primo e unico stato della nuova pagina: M(n,
%    1,1) = M(n-1, 1, m_max(n-1))  --> Il sinistro eredita l'ultimo sinistro M(n, 2, 1) = M(n-1, 2, m_max(n-1))  --> Il
%    destro eredita l'ultimo destro
%
% NOTA: In TeX questa primitiva si chiama \topmark, che cattura esattamente l'intero \botmark, ossia gli ultimi valori
% di \leftmark e \rightmark della pagina precedente).
%
% ----------------------------------------------------------------------------------------------------------------------
% 4. I COMANDI DI LETTURA (Estrazione alla chiusura della pagina) Quando TeX chiude e stampa la pagina 'n', estrae i
%    valori per le testatine secondo regole asimmetriche e inflessibili:
%
% - Pagine PARI (Sx) -> Stampano in testatina l'ULTIMO \leftmark
%                       (hanno in memoria anche il rightmark proprio, ma non lo usano)
%
%   REGOLA MODELLO: Alla pagina attuale n, Estrae sempre M(n, 1, m_max(n)).
%   REGOLA TIPOGRAFICA: Estrae l'ULTIMO valore sinistro scritto sulla pagina. (La primitiva TeX sottostante è \botmark).
%   MOTIVO TIPOGRAFICO: La testatina di sinistra deve riflettere l'ultimo capitolo iniziato, perché si fa in modo che
%   più capitoli non inizino sulla stessa pagina (\chpater lancia un \clearpage). Se ciò accadesse lo stesso (caso
%   limite), con la modifica di macro interne, comunque la convenzione tipografica ci si aspetta che l'ultimo capitolo
%   arrivato sia quello che occupa il maggiore spazio nella pagina (tempo di lettura), altrimenti va iniziato inu una
%   nuova pagina. Per questo è importante che il \leftmark sfrutti sempre l'ultimo valore salvato nella pagina.
%
% - Pagine DISPARI (Dx) -> Stampano in testatina il PRIMO \rightmark
%                          (hanno in memoria anche il leftmark proprio, ma non lo usano)
%
%   REGOLA MODELLO: Alla pagina attuale n, Estrae sempre M(n, 2, 1).
%   REGOLA TIPOGRAFICA: Estrae rigorosamente il PRIMO valore destro scritto sulla pagina, anche se fosse una stringa
%   vuota {}. (La primitiva TeX sottostante è \firstmark).
%   MOTIVO TIPOGRAFICO: Qualora inizino sezioni in una pagina destra, la testatina di destra deve riflettere la sezione
%   più recente iniziata sulla pagina stessa, perché visto che in una pagina possono iniziare più sezioni, si presuppone
%   che tra tutte quelle che inizino, la sezione più recente sia quella che occupa il maggiore spazio nella pagina
%   (tempo di lettura). Ovviamente potrebbe capitare il caso che una vecchia sezione iniziata pagine prime occupi
%   comunque il maggiore spazio, ma è una situazione in cui comunque va ammessa l'ultima sezione iniziata (l'inizio di
%   una nuova sezione è un evento tipografico importante, che va evidenziato, e LaTeX non offre un controllo
%   condizionale basato sul riempimento delle pagine: in ogni caso meglio avere una regola semplice da rispettare
%   sempre).
% ----------------------------------------------------------------------------------------------------------------------
%
% 5. COROLLARI DI DEBUG (IL PROBLEMA DELLE SEZIONI E IL PRIMO RIGHTMARK)
% - FALLIMENTO SOVRASCRITTURA SEZIONI: Se si cerca di sovrascrivere l'output di \section richiamando un \markright
%   subito dopo, l'azione fallirà sulla pagina corrente. Il motore di impaginazione per la pagina Dx pescherà SEMPRE
%   M(n, 2, 1), mentre la correzione manuale giacerà ignorata in M(n, 2, 2).
%   SOLUZIONE: Intercettare \sectionmark prima che scriva il record m=1. O si chiama sectionmark in anticipo, ma non è
%   la mossa migliore, in quanto si rischia che la sezioni inizi in una pagina diversa (in funzione di come lo spazio è
%   gestito im automatico), usando il valore corretto, oppure si modifica localmente sectionmark, in modo che la sezioni
%   chiami il \markright corretto.
%   NOTA: non usare un gruppo per la ridefinizione delle macro, perché \section interagisce con altre macro per
%   funzionare correttamente. Usa: \let\vecchioComando\comando, dunque \renecommand{\comando} poi
%   \let\comando\vecchioComando.
%
% - SUCCESSO SOVRASCRITTURA CAPITOLI: Sovrascrivere l'output di \chapter usando \chaptermark funziona perfettamente.
%   Questo perché \leftmark (sulle pagine Sx) legge M(n, 1, m_max), catturando con successo l'ultimo comando impartito.
%
% - INDIPENDENZA DA OPENANY E OPENRIGHT: Il meccanismo delle testatine È COMPLETAMENTE INDIPENDENTE da openany e
%   openright, non c'è bisogno di fare distinzioni.
%
% - ESISTENZA DI ENTRAMBI I MARK PER TUTTE LE PAGINE: sebbene già citato più volte, per debuggare è fondamentale capire
%   che tutte le pagine possiedono \leftmark e \rightmark proprio indipendenti in assoluto, ma le Sx usano solo il
%   \leftmark e le Dx usano solo il \rightmark. Quindi ad esempio, se un capitolo chiama \marboth{nomecapitolo}{}, il
%   rightmark vuoto non influenzerà il \rightmark della pagina successiva, qualora in essa vengano dichiarate sezioni
%   (se non vengono dichiarate \topmark clona e quindi l'influenza c'è, ma questo solo a posteriori!).
%
% - COMANDI CLEARPAGE E CLEARDOUBLEPAGE: non hanno nulla a che vedere, e non interferiscono, con le testatine.
% ======================================================================================================================




% ======================================================================================================================
% LISTA DEI BUG RISCONTRATI NELLE VERSIONI PRECEDENTI DEL CODICE SOVRASCRITTO:
% ======================================================================================================================

% BUG N°1: UTILIZZO DI CHAPTERMARK PER LA TESTATINA DEI CAPITOLI STELLATI:
% Il chaptermark che ho riprogrammato, fa questo:
% - stampa il nome passato del capitolo sempre su entrambi leftmark e rightmark, così se non iniziano sezioni la
%   testatina non rimane vuota, ma mostra comunque il capitolo.
% - se è nel mainmatter:
%   stampa etichetta capitolo ("CAPITOLO" o "Cap." a seconda dell'impostazione, anche in inglese) +
%   + etichetta numerica (es: "1.") (se impostato) + titolo del capitolo.
% - se è nel frontmatter o backmatter: stampa solo il titolo del capitolo, senza etichette (non andrebbero bene)
%
% Dunque, chiaramente se si vuole un capitolo STELLATO, dunque NON NUMERATO (ma che aggiorna ToC con titolo lungo e
% entrambi i marks della testatina con titolo breve se c'è, altrimenti titolo lungo) CHIARAMENTE IL CHAPTERMARK
% MODIFICATO NON PUÒ ESSERE USATO, altrimenti NEL MAINMATTER \chapter* stamperebbe comunque le etichette. Visto che
% questa variante di chaptermark serve anche per \uchapter (vedi bug a seguire), la chiamiamo \uchaptermark (chaptermark
% per capitolo non numerato). AGGIORNAMENTO: cambio il nome in \NLchpatermark, "NL" sta per NO LABELS, perché i comandi
% "u" (unnumbered but indexed + header) non fanno parte della custom class.

\newcommand{\NLchaptermark}[1]{%
    \markboth{#1}{#1}%              % Aggiorna entrambi i mark, cosicché in assenza si sezioni, la testatina non sia
    %                               % vuota, ma mostri comunque il capitolo.
}

% ----------------------------------------------------------------------------------------------------------------------

% BUG N°2: UTILIZZO DI SECTIONMARK PER LA TESTATINA DELLE SEZIONI STELLATE:
% Il sectionmark che ho riprogrammato, fa questo:
% - stampa il nome passato della sezione in rightmark
% - stampa: etichetta numerica (es: "1.") (se impostato) + titolo della sezione SEMPRE.
% - Nessuna differenza tra mainmatter e front/backmatter, in quanto questi NON influenzano il comando section, come
%   accade invece nel caso chapter: se lo modificassi per essere sensibile per usarlo con \section nel front/backmatter,
%   allora avrei comunque il numero SBAGLIATO nel titolo, ma non nella testatina. Meglio che l'errore sia più evidente.
%   Usa \usection per le sezioni non numerate nel front/backmatter: Lamport e Knuth non avevano previsto infatti che
%   venissero usate sezioni nel front/backmatter (di norma non si fa, ma può essere utile).
%
% Dunque, chiaramente se si vuole una SEZIONE STELLATA, dunque NON NUMERATA (ma che aggiorna ToC con titolo lungo e
% il rightmark della testatina con titolo breve se c'è, altrimenti titolo lungo) CHIARAMENTE IL SECTIONMARK MODIFICATO
% NON PUÒ ESSERE USATO, altrimenti stamperebbe comunque le etichette numeriche sempre. Visto che questa variante
% di sectionmark serve anche per \usection (vedi bug a seguire), la chiamiamo \usectionmark (sectionmark per sezione
% non numerata). AGGIORNAMENTO: cambio il nome in \NLsectionmark, "NL" sta per NO LABELS, perché i comandi "u"
% (unnumbered but indexed + header) non fanno parte della custom class.

\newcommand{\NLsectionmark}[1]{%
    \markright{#1}                  % Aggiorna il rightmark della pagina corrente, con l'ultima sezione.
}

% ----------------------------------------------------------------------------------------------------------------------

% BUG N°3: SOVRASCRITTURA DEI MARK USATA SIA PER CAPITOLI CHE PER SEZIONI NELLA RIDEFINIZIONE DEI COMANDI CHAPTER E
% SECTION CON WRAPPER - TESTATINE SBAGLIATE (NUMERATE QUANDO NON DOVREBBERO ESSERLO)! - PER I CAPITOLI E DIVERSO CHE
% PER LE SEZIONI (AGGIORNAMENTO: VEDI BUG 4 A RIGUARDO).
% Come spiegato chiaramente nel modello teorica, se si tenta di sovrascrivere i mark di una pagina in particolare,
% esclusivamente la sovrascrittura del \leftmark, riservato ai capitoli, funziona: infatti per i motivi tipografici
% spiegati, in tutte le pagine viene usato il \leftmark più recente o il primo \rightmark (il meno recente), in
% funzione della pagina, che sia Sx o Dx.
% Quindi, nel caso dei:
%
% - CAPITOLI: dopo la chiamata di \OLDchapter, si può modificare la testatina richiamando \chaptermark o \uchaptermark
%   ATTENZIONE: AGGIORNAMENTO (*) FORSE È MEGLIO APPLICARE UNA MODIFICA COME QUELLA PER SECTION.
%
% - SEZIONI: dopo la chiamata di \OLDsection, se si richiama \sectionmark, non si avrà ALCUN EFFETTO SULLA TESTATINA:
%   l'unico modo per modificare la testatina è intercettare \sectionmark PRIMA della chiamata di \OLDsection.
%   È sconsigliato semplicemente chiamare \sectionmark o \usectionmark dopo \OLDsection o \OLDsection* rispettivamente,
%   in quanto la sezione potrebbe iniziare in una pagina diversa da quella in cui è chiamato il mark, se la disposizione
%   degli elementi è al limite pagina (funzionerebbe comunque nelle pagine successive, se non sono chiamate sezioni, ma
%   è decisamente meglio evitare: può rendere difficile il debug, e soprattutto è un comportamento non deterministico.
%   Per questo, è molto meglio MODIFICARE LOCALMENTE IL COMANDO \sectionmark o \usectionmark per far si che quanto viene
%   chiamato internamente da \OLDsection o \OLDsection*, sappia già cosa stampare.
%   La logica da seguire è la seguente:
%
%   .....{%     % POSIZIONE: all'interno dei casi del wrapper (\section) a cui è passato #1=TitoloLungo e #2=TitoloBreve
%   \let\TempSectionMark\sectionmark%     OPPURE     \let\TempSectionMark\usectionmark (a seconda del caso)
%   \renewcommand{\sectionmark}[1]{\TempSectionMark{#2}}%  OPPURE  \renewcommand{\usectionmark}[1]{\TempSectionMark{#2}}
%   \OLDsection{#1}%
%   \let\sectionmark\TempSectionMark%     OPPURE     \let\usectionmark\TempSectionMark (a seconda del caso)
%   }
%
%   Perché in questo modo?
%   Come si può osservare, così facendo si RIDEFINISCE LOCALMENTE \sectionmark o \usectionmark, sempre usando lo stesso
%   contenuto di \sectionmark o \usectionmark originale, MA IMPONENDO CHE USINO #2 INDIPENDENTEMENTE DA COSA È PASSATO
%   A \OLDsection O \OLDsection*, ossia #1. Ed il bello è che è comunque chiamato da \OLDsection o \OLDsection*!
%   In pratica preimpostiamo localmente il contenuto di \sectionmark o \usectionmark, che perde l'interattività con #1.
%
%   NOTA BENE: dentro section, al \sectionmark è passato comunque il titolo breve, quindi il comando si aspetta un
%   argomento! Per questo, per evitare errori, va comunque inserito l'argomento nella ridefinizione locale, con [1],
%   sebbene poi non venga usato! Infatti il #2 è srotolato dalla macro prima. Per passare parametri in modo annidato,
%   in definizioni annidate di macro, si deve usare ##numero per annidamento doppio, ###numero per annidamento triplo,
%   e così via.
%
%   NOTA: modifica locale, quindi gruppo? NO, sebbene sia logico, è sconsigliato mettere \section originale, quindi
%   \OLDsection dentro un gruppo, perché altrimenti perde impostazioni o contatti con il resto del codice.
%   Queste macro così complesse ed articolate è sconsigliato inserirle in gruppi, per evitare effetti indesiderati la
%   cui causa è complessa da individuare.
%
% NOTA FINALE: tra tutti e 4 i casi di uso della section sovrascritta (con o senza stella, con o senza titolo breve),
% ovviamente è un problema solo del caso normale senza stella, perché \OLDsection* non aggiorna i mark, e col titolo
% breve, perché altrimenti non c'è distinzione tra i titoli nelle testatine.

% ----------------------------------------------------------------------------------------------------------------------

% BUG N°4: CASO PARTICOLARE COME IL 3 MA DI MINORE INTERESSE - TESTATINE NELLE PAGINE DEI CAPITOLI SBALLATE
% ATTENZIONE: AGGIORNAMENTO (*): UN ALTRO DOVUTO COMMENTO RELATIVO AI CAPITOLI - TESTATINA AD INIZIO CAPITOLO.
% SEBBENE una modifica analoga a quella discussa per le sezioni si possa fare anche per i capitoli, come spiegato almeno
% in generale non sembra necessaria. Tuttavia potrebbe non essere scontato. A seguire analizzeremo il caso particolare
% in cui si attivino le testatine sulla prima pagina del capitolo stesso.
% Quello che accade nel codice.
% IN OGNI CASO:
% - il comportamento della memoria della testatina non cambia in funzione del fatto che il capitolo inizi su
%   su una pagina destra (openright) o una sinistra (openany)
% - il comportamento della stampa della testatina, a posteriori della memoria, invece cambia come sappiamo in base alla
%   pagina: sulla sinistra stampa ultimo leftmark, sulla destra stampa primo rightmark.
% LATEX DEFAULT:
% - usa \markboth{nomecapitolo}{}: il capitolo di default è memorizzato solo sul \leftmark, la cui stampa si aggiorna,
%   mentre il \rightmark rimane vuoto, e la stampa non si può aggiornare.
% - sulla pagina del capitolo non c'è mai la testatina
% CUSTOM CLASS CON TESTATINA MODIFICATA
% - usa \markboth{nomecapitolo}{nomecapitolo}: il capitolo è memorizzato sia sul \leftmark, la cui stampa si aggiorna,
%   che sul \rightmark, la cui stampa non si può aggiornare.
% - sulla pagina del capitolo non c'è mai la testatina
% LATEX DEFAULT: SE SI ATTIVASSE DUNQUE LA TESTATINA SULLA PAGINA DEL CAPITOLO?
% - se la pagina è a sx, che stampa il leftmark, mostra il nome del capitolo. In particolare l'ultimo sovrascritto. OK.
% - se la pagina è a dx, che stampa il rightmark, è VUOTA. Ok? Sì in sostanza, non è una sezione, e anche se ci fossero
%   sezioni non sarebbero stampate (rightmark non si aggiorna). Non del tutto giusto, discutibile, ma non sbagliato.
% - pagine successive: nessun problema ovviamente. O usano i loro valori, o se non ci sono dichiarazioni, il sistema
%   eredita quelli delle precedenti pagine, sempre gli ultimi valori aggiornati.
%   Senza nuovi dati, continuano ad esserci testatine vuote a DX, com'è giusto senza sezioni.
% Forse è discutibile che la testatina sia vuota nel caso cominci a dx, ma almeno sta seguendo una regola semplice.
%   Quindi in realtà è giusto. Ricorda comunque che con la stampa della testatina disattiva sulla pagina del capitolo,
%   come di norma, IL PROBLEMA NON SI VEDE.
% CUSTOM CLASS CON TESTATINA MODIFICATA: SE SI ATTIVASSE DUNQUE LA TESTATINA SULLA PAGINA DEL CAPITOLO?
% - se la pagina è a sx, che stampa il leftmark, mostra il nome del capitolo. In particolare l'ultimo sovrascritto. OK.
% - se la pagina è a dx, che stampa il rightmark, STAMPA IL PRIMO LEFTMARK, cioè IL TITOLO LUNGO secondo il codice
%   che fa solo la sovrascrittura del \chaptermark -> ERRORE! Stiamo inserendo un'anomalia nel comportamento del codice:
%   anche se è nascosto, solo li farebbe questa cosa diversa da tutte le altre pagine: non segue una regola.
% Qui la cosa è formalmente sbagliata, perché non sta seguendo comunque una regola semplice.
% Faremo quindi in modo DI NON USARE LA SOVRASCRITTURA anche nel caso dei capitoli, bensì L'INTERCETTAZIONE, in modo da
% avere IN MEMORIA IL PRIMO LEFTMARK sempre e comunque corretto.
% Questa è una strategia di PROGRAMMAZIONE DIFENSIVA, che serve ad evitare errori e comportamenti anomali, le cui cause
% sono difficili da individuare, e che rendono il debugging tipicamente infernale.
% Se la modifica è da fare, tanto vale farla corretta a priori.
% Ricorda comunque che con la stampa della testatina disattiva sulla pagina del capitolo, come di norma anche con i
% comandi custom, IL PROBLEMA NON SI VEDE.
%
% NOTA FINALE: tra tutti e 4 i casi di uso del chapter sovrascritto (con o senza stella, con o senza titolo breve),
% ovviamente è un problema solo del caso normale senza stella, perché \OLDchapter* non aggiorna i mark, e col titolo
% breve, perché altrimenti non c'è distinzione tra i titoli nelle testatine.

% ----------------------------------------------------------------------------------------------------------------------

% BUG N°5: CONFLITTO RIDEFINIZIONE DI CHAPTER E SECTION, CON LE DEFINIZIONI DI UCHAPTER E USECTION RISPETTIVAMENTE
% Avevo scritto uchapter e usection prima di modificare, come allo stato attuale, i comandi chapter e section, e dunque
% al loro interno avevo usato i comandi \chapter* e \section* originali.
% Visto che erano definiti nel contesto dei chapter originali, basta che al loro posto al loro interno si usino
% \OLDchapter* e \OLDsection* per risolvere il problema.
% Oppure li si può riscrivere utilizzando direttamente \chapter e \section modificati appunto! Basta in realtà passare i
% titoli nel modo giusto in sostanza, e lasciare che siano i comandi modificati a gestire tutto.
% Altrimenti ancora, per evitare che siano riferiti ai comandi dello stato modificato, si potrebbe fare in modo che
% usino le macro protette dei capitoli \@schapter e \@ssection, che per prassi non si toccano!
% Vedi codice in custom macros!

% ----------------------------------------------------------------------------------------------------------------------

% BUG N°6: RIDEFINIZIONE DI \listoffigures e \listoftables PER CORREGGERE TESTATINE - Definizioni chapter, criteri marks
% MEGLIO USARE INTERCETTAZIONE, anche in quel caso! Applicare anche a toc!


% AGGIORNAMENTO: ho capito di aver usato una filosofia sbagliata! Non si dovrebbe sfruttare la modifica dei marks,
% che sono sezioni di memoria pensate per funzionare solo in un certo modo, per ottenere un risultato grafico.
% È molto meglio lasciarli come sono, e gestire gli aspetti grafici a posteriori, mediante fancyhdr.
% Mi riferisco al fatto dell'uso di \markboth{capitolo}{capitolo} per aggiornare le testatine, che tra l'altro va
% propagato su tutto il codice, modificando ogni comando che genera un capitolo (LoF, LoT, ToC, Index, Appendix, Bib...)
% È Molto più semplice agire una volta per tutte ad alto livello secondo l'interfaccio di fancyhdr:
% \fancyhead[RO]{\ifblank{\rigthmark}{\leftmark}{\rightmark}}, così agisce indipendentemente OVUNQUE! Era una riga!
% NOTA: \ifblank è una macro di etoolbox, che controlla se il suo argomento è vuoto o contiene solo spaziature.
% Ho scritto il seguente commento per spiegare meglio la questione.

% ======================================================================================================================
% MANIFESTO DI DESIGN DELLE TESTATINE: IL PATTERN MVC IN (La)TeX E IL PROBLEMA DEI MARKS
% ======================================================================================================================
% Questo blocco documenta un cambio di paradigma fondamentale nella gestione delle testatine. Invece di hackerare le
% primitive del kernel TeX, la classe adotterà un approccio MVC (Model-View-Controller):
% - MODEL (Modello): Il livello dei "Dati", ovvero come TeX immagazzina le informazioni (i marks).
% - VIEW (Vista): Il livello della "Presentazione", ovvero il pacchetto fancyhdr che disegna fisicamente la pagina.
% - CONTROLLER (Controllo): La logica condizionale che decide cosa estrarre dai dati per passarlo alla vista. Separare
%   rigorosamente questi tre livelli garantisce un codice pulito, robusto e prevedibile.
%
% ----------------------------------------------------------------------------------------------------------------------
% 1. MODEL - IL MISUNDERSTANDING STORICO DEI NOMI E LA FILOSOFIA DEL KERNEL (Il Livello Dati)
%
% I nomi scelti negli anni '80 da Knuth/Lamport per i marks sono semanticamente fuorvianti per il layout moderno. Sotto
% il cofano, \leftmark e \rightmark sono intimamente legati a contenitori di memoria pensati per funzionare sempre e
% rigorosamente in un solo, specifico modo:
%
% - \leftmark NON significa "stampato a sinistra nelle testatine" o "stampato solo nelle pagine di sinistra". È il
%    MACRO-CONTENITORE, progettato per ospitare SOLO IL CAPITOLO. Si potrebbe rinominarlo in "\markforchapter", ma
%    anche questo sarebbe fuorviante, visto che esiste \chaptermark, che però fa altro (vedi a seguire).
%
% - \rightmark NON significa "stampa a destra nelle testatine" o "stampa solo nelle pagine di destra". È il
%    MICRO-CONTENITORE, progettato per ospitare SOLO LE SEZIONI. Si potrebbe rinominarlo in "\markforsection", ma
%    anche questo sarebbe fuorviante, visto che esiste \sectionmark, che però fa altro (vedi a seguire).
%
% Entrambi questi valori risiedono nello stato globale del motore TeX ed esistono simultaneamente su OGNI pagina,
% indipendentemente che sia pari o dispari. Il pensiero di fondo del Kernel prevede questo uso esclusivo:
% \chapter{capitolo} riempie il macro-contenitore svuotando il micro, e lo fa chiamando il comando
% \chaptermark{capitolo}, che a sua volta chiama \markboth{capitolo}{} (il vuoto, svuota il \rightmark), mentre
% \section{sezione} aggiorna solo il micro-contenitore, chiamando \sectionmark{sezione}, che a sua volta chiama
% \markright{sezione}. Modificare questo comportamento significa andare contro la natura stessa del motore.
%
% ----------------------------------------------------------------------------------------------------------------------
% 2. MODEL - LA TRAPPOLA DELL'HACKING STRUTTURALE DEI MARKS
%
% L'errore più comune (e frustrante) in LaTeX è tentare di ottenere layout custom per le testatine, come quello
% asimmetrico inizialmente proposto (es. "stampa il Capitolo a destra se non ci sono sezioni"), alterando la logica dei
% comandi marks, mettendo mano alle definizioni dei comandi \chaptermark e \sectionmark. In questo caso li si era usati
% per forzarli a scrivere dati ridondanti nelle celle di memoria sbagliate dell'array globale dei marks di TeX,
% costringendo i chapter a riempire il \rightmark).
% Questo approccio distrugge la semantica del kernel e costringe a "patchare" singolarmente ogni ambiente speciale
% (Indice, Bibliografia, Appendici, List of Figures) che non usa i comandi standard.
%
% ----------------------------------------------------------------------------------------------------------------------
% 3. VIEW E CONTROL - LA SOLUZIONE "ARCHITETTURALE" (Il Livello Presentazione)
%
% La Regola d'Oro è: LASCIA CHE TEX FACCIA IL SUO LAVORO SEMANTICO. Tutte le decisioni grafiche e spaziali devono essere
% delegate esclusivamente all'interfaccia di visualizzazione (fancyhdr, la Vista), utilizzando logiche condizionali
% direttamente in fase di stampa (il Controllo).
%
% ESEMPIO PRATICO (Il Dominio del Capitolo sulla pagina destra): Invece di costringere \chaptermark a riempire il
% \rightmark, si istruisce fancyhdr a valutare la situazione in tempo reale sulla pagina corrente. Si possono usare due
% approcci equivalenti:
%
%   APPROCCIO 1 (Classico, richiede il pacchetto ifthen):
%   \fancyhead[RO]{\ifthenelse{\equal{\rightmark}{}}{\leftmark}{\rightmark}}
%
%   APPROCCIO 2 (Moderno e ottimizzato, richiede il pacchetto etoolbox):
%   \fancyhead[RO]{\ifblank{\rightmark}{\leftmark}{\rightmark}}
%
% SPIEGAZIONE: "Se il micro-contenitore (\rightmark) è vuoto (es. inizio capitolo, o capitoli speciali), allora stampa
% in questa posizione il macro-contenitore (\leftmark). Altrimenti, stampa la Sezione".
%
% ----------------------------------------------------------------------------------------------------------------------
% 4. CONTROL - LA MODIFICA LEGITTIMA DEL CONTENUTO (Le API del Modello)
%
% Tutto questo non significa che i marks siano intoccabili. Al contrario, \chaptermark e \sectionmark sono le API
% ufficiali di LaTeX, i comandi di interfaccia pensati appositamente per essere ridefiniti e personalizzati.
% L'importante è rispettare il confine tra "Dove/Come salvare" e "Cosa salvare":
%
% - SBAGLIATO (Hacking architetturale): Usare \chaptermark per scrivere nel contenitore di destra, o in generale
%   alterare l'uso della memoria delle testatine, agendo su come i marks funzionano.
% - CORRETTO (Formattazione del Dato): Usare \chaptermark per cambiare il TESTO che finisce nel contenitore di sinistra
%   (es. omettere la parola "Capitolo", usare il maiuscoletto, o inviare il "Titolo Breve" catturato dinamicamente).
%
% Agire su \chaptermark e \sectionmark per raffinare la stringa di testo PRIMA che venga inghiottita dal motore è una
% pratica architetturalmente perfetta e pienamente incoraggiata. Sono comandi d'interfaccia pensati anche per essere
% modificati.
%
% ----------------------------------------------------------------------------------------------------------------------
% 5. LE ECCEZIONI HARDCODED E LE TECNICHE DI INTERVENTO
%
% Sebbene \chaptermark e \sectionmark siano le interfacce previste, in LaTeX esistono generatori di capitoli automatici
% (come Bibliografia, Indice Generale (ToC), Indice Analitico, List of Figures (LoF) e List of Tables (LoT)) che
% bypassano queste API. Le classi standard inviano ai marks uno stile preformattato (es. tutto maiuscolo tramite
% \MakeUppercase o comandi come \@mkboth), senza offrire un'interfaccia semplice per modificarlo.
%
% In questi casi, per correggere la formattazione del Dato senza infrangere il pattern MVC, è necessario intervenire
% direttamente sul codice del generatore. Le tecniche per farlo includono:
% - Hooks (Ganci): Usare i moderni comandi \AddToHook per iniettare codice prima o dopo l'esecuzione dell'ambiente.
% - Modificatori di codice: Sfruttare pacchetti come etoolbox (\patchcmd) per cercare e sostituire stringhe interne.
% - Wrapper o Decorator: Salvare il comando originale e avvolgerlo in una nuova macro che ne altera il comportamento.
% - Intercettazione (L'approccio di più alto livello): Sfruttare le primitive (\let) per catturare in volo parametri o
%   comandi annidati, preimpostandone il contenuto (come fatto in questa classe per l'opzione del titolo breve).
%
% ----------------------------------------------------------------------------------------------------------------------
% VANTAGGI DI QUESTO APPROCCIO COMBINATO (MVC):
% - Il kernel TeX rimane incontaminato e la sua filosofia semantica (Macro vs Micro contenitore) è preservata.
% - Le decisioni sul "Cosa Testo" (maiuscole, numeri, titoli brevi) sono gestite ordinatamente dalle API (\..mark).
% - Le decisioni sul "Dove/Quando" sono centralizzate nella Vista (fancyhdr), rendendo il layout globale facilissimo da
%   aggiornare in un unico punto del codice.
% - I comandi strutturali (\chapter, \section) richiedono ridefinizioni minime e pulite (solo per l'intercettazione
%   degli argomenti brevi).
% - I capitoli speciali (ToC, LoF, LoT) ereditano magicamente il layout corretto senza toccare una riga del loro codice:
%   lasciando per loro natura il \rightmark vuoto, attivano automaticamente la logica condizionale della Vista.
% ======================================================================================================================





% ======================================================================================================================





%---------------------------------------------
% DISPOSIZIONE FISICA SULLA PAGINA (Il Layout)

% NOTA: per ogni pagina, come già spiegato, c'è un \leftmark e un \rightmark, ma le pagine pari (Sx) usano solo il
% \leftmark, mentre le pagine dispari (Dx) usano solo il \rightmark.
% Il pacchetto fancyhdr inoltre mette in gioco PER OGNI TESTATINA, 3 CONTENITORI GRAFICI, indicati da L, C, R, che
% stanno ovviamente per Left, Center, Right. Questi sono INDIPENDENTI DAI MARKS, e sono semplicemente dei box grafici,
% che il seguente codice configura nel contenuto.
% Si è scelto di stampare:
% - Sulle pagine pari (Sx): il \lefmark (sempre e solo il capitolo, eventualmente il nome della sezione) nel box L, il
%   logo nel box C, e il nome dell'associazione nel box R
% - Sulle pagine dispari (Dx): il nome dell'associazione nel box L, il logo nel box C, e il \rightmark (se ci sono
%   sezioni attive c'è il titolo della sezione, altrimenti quello del capitolo, grazie alle modifiche fatte) nel box R
% Così facendo:
% - il logo è sempre al centro della testatina
% - il nome dell'associazione è sempre vicino al margine interno del libro (vicino alla rilegatura, zona meno visibile)
% - i titoli di capitolo e sezione sono sempre vicino al margine esterno del libro (bordo esterno delle pagine), più
%   visibili, essendo importanti per navigare il contenuto.
%
% NOTA DI COMPRENSIONE FINALE: ricorda che indipendentemente da come si stampa la testatina con fancyhdr, il
% comportamento della memoria è sempre lo stesso, e si sconsiglia fortemente di sovvertire l'ordine con cui i leftmark
% e i rightmark sono usati. Il primo serve per il capitolo, il secondo per le sezioni. Non sovvertire mai l'ordine
% perché sarebbe un problema gestirne la logica! Se l'intento è solo scambiare le posizioni sulla testatina, bastano le
% opzioni associate di fancyhdr, senza toccare la logica dei mark.
% Tutti i bug commentati, e la riprogrammazione fatta, sono un esempio sufficientemente ampio di come la logica dei mark
% rende complesse le modifiche.


% Pagine PARI (Even - Foglio di Sinistra)
\fancyhead[LE]{\leftmark}           % Leftmark (Nome Capitolo) sul margine ESTERNO (SX)
\fancyhead[RE]{\DDorganization}     % Nome Associazione sul margine INTERNO (DX)

% Pagine DISPARI (Odd - Foglio di Destra)
\fancyhead[LO]{\DDorganization}     % Nome Associazione sul margine INTERNO (SX)
\fancyhead[RO]{\rightmark}          % Rightmark (Nome Sezione, o fallback Capitolo) sul margine ESTERNO (DX)

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
    % EFFETTO COMPLESSIVO: le linee si espandono a sx e a dx dell'hspace con la stessa "forza elastica": lo spazio bianco
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
% NOTA SU XPARSE E LATEX3: È necessario aggiungere \RequirePackage{xparse} all'inizio della classe per garantire la
% retrocompatibilità con vecchie distribuzioni TeX antecedenti al 2020. Dal 2020 in poi, xparse e le funzioni di LaTeX3
% sono state integrate nativamente nel kernel standard. Non bisogna modificare l'istruzione \NeedsTeXFormat{LaTeX2e}
% (es. in LaTeX3), poiché LaTeX3 non è mai stato rilasciato come formato a sé stante, ma è un ambiente di programmazione
% integrato dentro LaTeX2e.

% --------------------------------
% CHAPTER COMMAND WRAPPER (xparse)
% --------------------------------
% Conserva il comando nativo della classe book
\let\OLDchapter\chapter             % Backup del comando originale
                                    % Supporta la variante con *, come lo stesso comando chapter.

% Ridefinisce \chapter per disaccoppiare TOC e Header, e gestire i capitoli stellati
% Testatina: usa sempre titolo breve
% Indice: usa sempre titolo lungo (di norma LaTeX invierebbe il breve)
% Aggiunto supporto per titoli brevi a capitoli stellati

% NOTA BENE: ricorda, per i capitoli la sovrascrittura de

\RenewDocumentCommand{\chapter}{ s o m }{%
    \IfBooleanTF{#1}{%
        % CASO 1:                   % Capitolo stellato \chapter*
        %                           % Aggiorna Header. Non invia nulla all'indice (ToC), come di norma per \chapter*.
        %                           % Se vuoi che compaia nell'indice (ToC), usa la custom macro \uchapter.
        \IfNoValueTF{#2}{%
            % CASO 1-A:             % chapter* senza titolo breve \chapter*[]{Lungo}
            \OLDchapter*{#3}%       % Invia il titolo LUNGO alla pagina
            % CORRETTO BUG DEL CHAPTERMARK SU CAPITOLI STELLATI - VEDI BUG 1 (tra quelli citati in precedenza).
            \NLchaptermark{#3}%     % Aggiorna l'header con titolo (lungo), usando la variante senza etichette.
            %                       % NOTA: \OLDchapter* non chiama \chaptermark, dunque non c'è nessuna sovrascrittura
            %                       % dei marks, ergo nessuno dei problemi discussi nei bug.
            %\chaptermark{#3}%      % NON USARE - VEDI BUG 1. Nel mainmatter caricava label numerica su capitoli
            %                       % stellati.
        }{%
            % CASO 1-B:             % chapter* con titolo breve \chapter*[Breve]{Lungo}
            \OLDchapter*{#3}%       % Invia il titolo LUNGO alla pagina
            % CORRETTO BUG DEL CHAPTERMARK SU CAPITOLI STELLATI - VEDI BUG 1 (tra quelli citati in precedenza).
            \NLchaptermark{#2}%     % Aggiorna l'header con titolo corto, usando la variante senza etichette.
            %                       % NOTA: \OLDchapter* non chiama \chaptermark, dunque non c'è nessuna sovrascrittura
            %                       % dei marks, ergo nessuno dei problemi discussi nei bug.
            %\chaptermark{#3}%      % NON USARE - VEDI BUG 1. Nel mainmatter caricava label numerica su capitoli
            %                       % stellati.
        }%
    }{%
        % CASO 2:                   % Capitolo normale \chapter
        \IfNoValueTF{#2}{%
            % CASO 2-A:             % chapter senza titolo breve \chapter[]{Lungo}
            \OLDchapter{#3}%        % Comportamento standard: invia il titolo LUNGO al TOC e alla pagina
            %                       % NOTA: nessuna sovrascrittura dei mark, ergo nessuno dei problemi discussi nei bug.
        }{%
            % CASO 2-B:             % chapter con titolo breve \chapter[Breve]{Lungo}
            %
            % CORRETTO BUG CON INTERCETTAZIONE - VEDI BUG 4 (tra quelli citati in precedenza).
            %
            \let\TempChapterMark\chaptermark%                       % Salva il comando originale \chaptermark
            \renewcommand{\chaptermark}[1]{\TempChapterMark{#2}}%   % Ridefinizione locale che intercetta #2 (parametro
            %                                                       % della macro \chapter).
            % NOTA: va aggiunto un parametro [1] alla ridefinizione locale di \chaptermark, anche se non è usato
            % (si userebbe con ##1), perché comunque \OLDchapter chiama \chaptermark{#3}, quindi passa un argomento,
            % che va gestito per evitare errori. È ignorato, e viene usato #2 hardcoded (è questa l'intercettazione).
            %
            % NOTA: per le definizioni locali di macro qui non puoi usare un group al posto di questi comandi, perché
            % \chapter dialoga con altre macro e impostazioni globali che altrimenti sarebbero ignorate.
            %
            \OLDchapter{#3}%        % Invia il titolo LUNGO al TOC e alla pagina, e chiama \chaptermark modificato.
            \let\chaptermark\TempChapterMark%                       % Ripristina il comando originale \chaptermark
            %
            %\chaptermark{#2}%      % NON USARE - VEDI BUG 4. NON USARE SOVRASCRITTURA, MA INTERCETTAZIONE, come per le
            %                       % sezioni, per evitare problemi di testatine sbagliate all'inizio del capitolo su
            %                       % pag dx, qualora fossero attivate.
        }%
    }%
}

% --------------------------------
% SECTION COMMAND WRAPPER (xparse)
% --------------------------------
% Nato per risolvere gli stessi problemi di disaccoppiamento : i titoli corti devono andare solo negli header, mentre
% quelli lunghi devono andare in pagina e in indice. Inoltre aggiunto supporto ai titoli corti per le sezioni stellate.

% NOTA BENE: ALTRI WRAPPER PER LE ALTRE DIVISIONI?
% Per gli altri comandi legati alle divisioni o struttura del documento, come, \part, \subsection, \subsubsection,
% \paragraph, e \subparagraph, visto che non vengono mai stampati nella testatina, si consiglia semplicemente di non
% usare i titoli brevi (che ammettono tutti), se si vuole che nell'indice \compaiano i titoli lunghi.

% Conserva il comando nativo della classe book
\let\OLDsection\section             % Backup del comando originale
                                    % Supporta la variante con *, come lo stesso comando section.

% Ridefinisce \section per disaccoppiare TOC e Header, e gestire le sezioni stellate
% Testatina: usa sempre titolo breve
% Indice: usa sempre titolo lungo (di norma LaTeX invierebbe il breve)
% Aggiunto supporto per titoli brevi a sezioni stellate

\RenewDocumentCommand{\section}{ s o m }{%
    \IfBooleanTF{#1}{%
        % CASO 1:                   % Sezione stellata \section*
        %                           % Aggiorna Header. Non invia nulla all'indice (ToC), come di norma per \section*.
        %                           % Se vuoi che compaia nell'indice (ToC), usa la custom macro \usection.
        \IfNoValueTF{#2}{%
            % CASO 1-A:             % section* senza titolo breve \section*[]{Lungo}
            \OLDsection*{#3}%       % Invia il titolo LUNGO alla pagina
            \NLsectionmark{#3}%     % Aggiorna l'header con titolo (lungo), usando la variante senza etichette.
            %                       % NOTA: \OLDsection* non chiama \sectionmark, dunque non c'è nessuna sovrascrittura
            %                       % dei marks, ergo nessuno dei problemi discussi nei bug.
            %\sectionmark{#3}%      % NON USARE - VEDI BUG 2. Caricava label numerica su sezioni stellate.
        }{%
            % CASO 1-B:             % section* con titolo breve \section*[Breve]{Lungo}
            \OLDsection*{#3}%       % Invia il titolo LUNGO alla pagina
            \NLsectionmark{#2}%     % Aggiorna l'header con titolo corto, usando la variante senza etichette.
            %                       % NOTA: \OLDsection* non chiama \sectionmark, dunque non c'è nessuna sovrascrittura
            %                       % dei marks, ergo nessuno dei problemi discussi nei bug.
            %\sectionmark{#3}%      % NON USARE - VEDI BUG 2. Caricava label numerica su sezioni stellate.
        }%
    }{%
        % CASO 2:                   % Sezione normale \section
        \IfNoValueTF{#2}{%
            % CASO 2-A:             % section senza titolo breve \section[]{Lungo}
            \OLDsection{#3}%        % Comportamento standard: invia il titolo LUNGO al TOC e alla pagina
            %                       % NOTA: nessuna sovrascrittura dei mark, ergo nessuno dei problemi discussi nei bug.
        }{%
            % CASO 2-B:             % section con titolo breve \section[Breve]{Lungo}
            %
            % CORRETTO BUG CON INTERCETTAZIONE - VEDI BUG 3 (tra quelli citati in precedenza).
            %
            \let\TempSectionMark\sectionmark%                       % Salva il comando originale \sectionmark
            \renewcommand{\sectionmark}[1]{\TempSectionMark{#2}}%   % Ridefinizione locale che intercetta #2 (parametro
            %                                                       % della macro \section).
            % NOTA: va aggiunto un parametro [1] alla ridefinizione locale di \sectionmark, anche se non è usato
            % (si userebbe con ##1), perché comunque \OLDsection chiama \sectionmark{#3}, quindi passa un argomento,
            % che va gestito per evitare errori. È ignorato, e viene usato #2 hardcoded (è questa l'intercettazione).
            %
            % NOTA: per le definizioni locali di macro qui non puoi usare un group al posto di questi comandi, perché
            % \section dialoga con altre macro e impostazioni globali che altrimenti sarebbero ignorate.
            %
            \OLDsection{#3}%        % Invia il titolo LUNGO al TOC e alla pagina, e chiama \sectionmark modificato.
            \let\sectionmark\TempSectionMark%                       % Ripristina il comando originale \sectionmark
            %
            %\sectionmark{#2}%      % Sovrascrive l'header con il titolo BREVE. AGGIORNATO: VEDI BUG 3, NON USARE
            %                       % SOVRASCRITTURA, MA INTERCETTAZIONE, come per le sezioni, per evitare problemi di
            %                       % testatine sbagliate all'inizio del capitolo su pag dx, qualora fossero attivate.
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
% Soprattutto è sbagliato rendere lo stile empty con \clearpage, perché è usato
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
