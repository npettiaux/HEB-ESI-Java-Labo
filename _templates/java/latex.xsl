﻿<?xml version="1.0" encoding="UTF-8"?>
<!-- =========================================================== -->
<!--           Script de conversion de eLML vers LaTeX           -->
<!-- =========================================================== -->
<!-- 1) On importe le script global fournit par ELML             -->
<!-- 2) On défnit les paramètres de conversion                   -->
<!--    (auront la priorité sur les valeurs globales)            -->
<!-- 3) On recopie et modifie les parties qui ne conviennent pas -->   
<!-- =========================================================== -->
<xsl:stylesheet xmlns:elml="http://www.elml.ch" version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2004/07/xpath-functions" xmlns:xdt="http://www.w3.org/2004/07/xpath-datatypes" xmlns:fox="http://xml.apache.org/fop/extensions">
	<!-- Importation de la transformation par défaut-->
	<xsl:import href="../../../core/presentation/latex/elml.xsl"/>
	<!-- Définition des paramètres  -->
	<!-- The name of this layout (=folder name of template folder!) -->
	<xsl:param name="layout" select="'java'"/>
	<xsl:param name="documentclass" select="'article'"/>
	<xsl:param name="pagebreak_level" select="'lesson'"/>
	<xsl:param name="chapter_numeration" select="'yes'"/>
	<!-- ===== / ===== -->
	<!-- Ajout du package pifonts pour la police dingbats utilisée pour les cases à cocher des QCM -->
	<!-- Mise en forme de la premièer page : on utilise le plus possible le tag metadata -->
	    <xsl:template match="/">
        <xsl:result-document href="{$pathRoot}/{/elml:lesson/@label}/{$lang}/latex/{/elml:lesson/@label}{$filename_suffix}" format="latex">
            <xsl:text>\documentclass[11pt,a4paper]{</xsl:text>
            <xsl:value-of select="$documentclass"/>
            <xsl:text>}
			</xsl:text>
            <xsl:choose>
                <xsl:when test="$lang='de'">
                    <xsl:text>\usepackage{ngerman}
					</xsl:text>
                </xsl:when>
                <xsl:when test="$lang='fr'">
                    <xsl:text>\usepackage[french]{babel}
					</xsl:text>
                </xsl:when>
                <xsl:when test="$lang='it'">
                    <xsl:text>\usepackage[italian]{babel}
					</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>\usepackage[english]{babel}
					</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="not($chapter_numeration='yes')">
                <xsl:text>\setcounter{secnumdepth}{-1}
				</xsl:text>
            </xsl:if>
            <xsl:text disable-output-escaping="yes">
				\usepackage{pifont}  <!-- MCD: Pour dingbats -->
				\usepackage{fancyhdr}
				\usepackage{textcomp}
				\usepackage{makeidx}
				\usepackage{tabularx}
				\usepackage{multicol}
				\usepackage{multirow}
				\usepackage{longtable}
				\usepackage{color}
				\usepackage{soul}
				\usepackage{boxedminipage}
				\usepackage{shadow}
				\usepackage{framed}			
				\usepackage{array}
				\usepackage{url}
				\usepackage{ragged2e}
				\ifx\pdfoutput\undefined
					\usepackage{graphicx}
				\else
					\usepackage[pdftex]{graphicx}
				\fi
				\usepackage[a4paper, hyperfigures=true, colorlinks, linkcolor=black, citecolor=blue,urlcolor=blue, pagebackref=true, bookmarks=true, bookmarksopen=true,bookmarksnumbered=true,
                pdfauthor={</xsl:text>
            <xsl:choose>
                <xsl:when test="$multiple='on' and document($config_file)/elml:config/elml:modules/elml:course[child::node()=$transformlesson_label]/@authors">
                    <xsl:value-of select="document($config_file)/elml:config/elml:modules/elml:course[child::node()=$transformlesson_label]/@authors" disable-output-escaping="yes"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select="/elml:lesson/elml:metadata/elml:lessonInfo/elml:lifecycle/elml:contribute/elml:person">
                        <xsl:value-of select="@name" disable-output-escaping="yes"/>
                        <xsl:if test="not(position()=last())">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>}, pdftitle={</xsl:text>
            <xsl:choose>
                <xsl:when test="$multiple='on' and document($config_file)/elml:config/elml:modules/elml:course[child::node()=$transformlesson_label]/@title">
                    <xsl:value-of select="document($config_file)/elml:config/elml:modules/elml:course[child::node()=$transformlesson_label]/@title"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="/elml:lesson/@title" disable-output-escaping="yes"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>}, pdfkeywords={</xsl:text>
            <xsl:value-of select="/elml:lesson/@title"/>, <xsl:for-each select="/elml:lesson/elml:metadata/elml:keywords/elml:keywordItem">
                <xsl:value-of select="." disable-output-escaping="yes"/>
                <xsl:if test="not(position()=last())">, </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="/elml:lesson/elml:glossary/elml:definition">
                <xsl:value-of select="@term" disable-output-escaping="yes"/>, </xsl:for-each>
            <xsl:text disable-output-escaping="yes">},pdfpagemode=UseOutlines,pdfpagetransition=Dissolve,nesting=true,
				backref, pdffitwindow=true, bookmarksnumbered=true]{hyperref}
				\usepackage{supertabular}
				\usepackage[table]{xcolor}
				\usepackage{url}
				\usepackage{caption} 
				\setlength{\parskip}{1.3ex plus 0.2ex minus 0.2ex}
				\setlength{\parindent}{0pt}
				
				\makeatletter
				\def\url@leostyle{ \@ifundefined{selectfont}{\def\UrlFont{\sf}}{\def\UrlFont{\footnotesize\ttfamily}}}
				\makeatother
				\urlstyle{leo}
				
				\definecolor{examplecolor}{rgb}{0.156,0.333,0.443}
				\definecolor{definitioncolor}{rgb}{0.709,0.784,0.454}
				\definecolor{exercisecolor}{rgb}{0.49,0.639,0}
				\definecolor{hintcolor}{rgb}{0.941,0.674,0.196}
				\definecolor{tableHeadercolor}{rgb}{0.709,0.784,0.454}
				\definecolor{tablerowAltcolor}{rgb}{.866,.905,.737}
				\definecolor{tablerowAlt2color}{rgb}{.968,.976,.933}
				
				\newenvironment{fshaded}{
				\def\FrameCommand{\fcolorbox{framecolor}{shadecolor}}
				\MakeFramed {\FrameRestore}}
				{\endMakeFramed}
				
				\newenvironment{fexample}[1][]{\definecolor{shadecolor}{rgb}{.913,.913,.913}
				\definecolor{framecolor}{rgb}{.156,.333,.443}
				\begin{fshaded}}{\end{fshaded}} 
				
				\newenvironment{fdefinition}{\definecolor{shadecolor}{rgb}{.913,.913,.913}
				\definecolor{framecolor}{rgb}{.709,.784,.454}
				\begin{fshaded}}{\end{fshaded}}
				
				\newenvironment{fexercise}{\definecolor{shadecolor}{rgb}{.913,.913,.913}
				\definecolor{framecolor}{rgb}{.49,.639,0}
				\begin{fshaded}}{\end{fshaded}}
				
				\newenvironment{fhint}{\definecolor{shadecolor}{rgb}{.913,.913,.913}
				\definecolor{framecolor}{rgb}{.941,.674,.196}
				\begin{fshaded}}{\end{fshaded}}	
				
				\newcommand{\PreserveBackslash}[1]{
				\let\temp=\\#1\let\\=\temp
				}
				\let\PBS=\PreserveBackslash
				\newcolumntype{A}{>{\PBS\raggedright\small\hspace{0pt}}X}
				\newcolumntype{L}[1]{>{\PBS\raggedright\small\hspace{0pt}}p{#1}}
				\newcolumntype{R}[1]{>{\PBS\raggedleft\small\hspace{0pt}}p{#1}}
				\newcolumntype{C}[1]{>{\PBS\centering\small\hspace{0pt}}p{#1}}
				
				\makeindex
				
				\title{</xsl:text>
            <xsl:choose>
                <xsl:when test="$multiple='on' and document($config_file)/elml:config/elml:modules/elml:course[child::node()=$transformlesson_label]/@title">
                    <xsl:value-of select="document($config_file)/elml:config/elml:modules/elml:course[child::node()=$transformlesson_label]/@title"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="/elml:lesson/@title"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>}	
			\date{}
			\author{}
			\fancyhead[L]{
				\small\textsc{Haute École de Bruxelles}\\
	    			\small\textsc{École Supérieure d'Informatique}
			}
			\fancyhead[R]{
				\small\textsc{</xsl:text>
	    <xsl:value-of select="/elml:lesson/elml:metadata/elml:organisation/@module"/>
			<xsl:text>}\\
			\small{</xsl:text>
	    <xsl:value-of select="/elml:lesson/elml:metadata/elml:organisation/@level"/>
	    <xsl:text>}}
				\fancyfoot[L]{\tiny{</xsl:text>
                    <xsl:for-each select="/elml:lesson/elml:metadata/elml:lessonInfo/elml:lifecycle/elml:contribute/elml:person">
                        <xsl:value-of select="@name"/>
                        <xsl:if test="not(position()=last())"><xsl:text> -- </xsl:text></xsl:if>
                    </xsl:for-each>
		<xsl:text>}}
				\fancyfoot[C]{}
				\fancyfoot[R]{{\tiny version </xsl:text>
	    <xsl:value-of select="/elml:lesson/elml:metadata/elml:lessonInfo/elml:lifecycle/elml:version"/>
				<xsl:text> (\today)}}
				\pagestyle{plain}			
				\begin{document}
				\setcounter{section}{-1}
				\addtocounter{section}{</xsl:text>
	    <xsl:value-of select="/elml:lesson/elml:metadata/elml:organisation/elml:creationPosition/elml:posNumber"/>
				<xsl:text>}
				\maketitle
				\thispagestyle{fancy}
				\tableofcontents
				\pagestyle{plain}
            </xsl:text>
            <xsl:choose>
                <xsl:when test="$multiple='on'">
                    <xsl:for-each select="document($config_file)/elml:config/elml:modules/elml:course[child::node()=$transformlesson_label]/elml:labelname">
                        <xsl:apply-templates select="document(concat(substring-before($config_file,'_config'),text(),'/',$lang,'/text/',text(),'.xml'))/elml:lesson"/>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="/elml:lesson/elml:bibliography" mode="multiple"/>
            <xsl:call-template name="elml:index"/>
            <xsl:if test="/elml:lesson/elml:listOfFigures[not(@visible='online') and not(@visible='none')] and (not(count(//elml:multimedia) = 0) or $multiple='on')">
                <xsl:if test="$pagebreak_level='unit' or $pagebreak_level='lo'">
                    <xsl:text>
                        \clearpage
                    </xsl:text>
                </xsl:if>
                <xsl:text>
                    \listoffigures
                    \addcontentsline{toc}{</xsl:text>
                <xsl:choose>
                    <xsl:when test="$documentclass='book'">
                        <xsl:text>chapter</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>section</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text>}{</xsl:text>
                <xsl:value-of select="$name_figures"/>
                <xsl:text>}
                </xsl:text>
            </xsl:if>
            <xsl:if test="/elml:lesson/elml:listOfTables[not(@visible='online') and not(@visible='none')] and (not(count(//elml:table) = 0) or $multiple='on')">
                <xsl:if test="$pagebreak_level='unit' or $pagebreak_level='lo'">
                    <xsl:text>
                        \clearpage
                    </xsl:text>
                </xsl:if>
                <xsl:text>
                    \listoftables
                    \addcontentsline{toc}{</xsl:text>
                <xsl:choose>
                    <xsl:when test="$documentclass='book'">
                        <xsl:text>chapter</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>section</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text>}{</xsl:text>
                <xsl:value-of select="$name_tables"/>
                <xsl:text>}
                </xsl:text>
            </xsl:if>
            <xsl:text>
				\end{document}
			</xsl:text>
        </xsl:result-document>
    </xsl:template>

    <!-- Les popup ne seront pas repris dans la version LaTeX -->
    <xsl:template match="elml:popup">
	    <xsl:text>\footnotesize\emph{ (plus d'information dans la version en ligne) }</xsl:text>
    </xsl:template>

    <xsl:template match="elml:formatted[@style='input']">
        <xsl:text> \texttt{</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>}</xsl:text>
    </xsl:template>

</xsl:stylesheet>