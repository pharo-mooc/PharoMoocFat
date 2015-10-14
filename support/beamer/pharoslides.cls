% By Luc Fabresse, 2015

%-------------------------------------------------------------------------------
%                identification
%-------------------------------------------------------------------------------
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{pharoslides}[2015/10/15 v1.0.0 Pharo MOOC beamer document class]

%-------------------------------------------------------------------------------
%                Commands
%-------------------------------------------------------------------------------

\newcommand{\usepharobeamertheme}{\usetheme{PharoMooc}}

\newcommand\@bottomlefttext{Pharo MOOC}
\newcommand\bottomlefttext[1]{\renewcommand\@bottomlefttext{#1}}


%-------------------------------------------------------------------------------
%                Class options
%-------------------------------------------------------------------------------

\DeclareOption{aspectratio=169}{
  \PassOptionsToClass{aspectratio=169}{beamer}}

\DeclareOption{withvideo}{
  \renewcommand{\usepharobeamertheme}{\usetheme[spaceforvideo]{PharoMooc}}
  \PassOptionsToClass{aspectratio=169}{beamer}%
}

% execute default options
% \ExecuteOptions{a4paper,11pt,final}

% process given options
\ProcessOptions\relax

%-------------------------------------------------------------------------------
%                Loading Packages
%-------------------------------------------------------------------------------

\LoadClass[handout]{beamer}

\RequirePackage[english]{babel}
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage{helvet} 
\RequirePackage{enumitem} %pour personnalisation des listes numérotées (cf. beamerthemeMoocLab.sty)

\RequirePackage[absolute,showboxes,overlay]{textpos}     % déclaration du package
\textblockorigin{0mm}{0mm}                               % origine des positions
\TPshowboxesfalse                                    

% \RequirePackage{tikz}
% \usetikzlibrary{arrows,shapes}
% \usetikzlibrary{trees}

% \RequirePackage{upquote}
% \RequirePackage{relsize}
% \RequirePackage{mathptmx}

\RequirePackage{booktabs}
\RequirePackage{textcomp}

\RequirePackage{calc}
\RequirePackage{ifthen}

%-------------------------------------------------------------------------------
%                Beamer Pharo Theme
%-------------------------------------------------------------------------------

\usepharobeamertheme

