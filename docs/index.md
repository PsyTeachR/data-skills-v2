--- 
title: "Data Skills" # edit
#subtitle: "optional" 
author: "Emily Nordmann" # edit
date: "2023-09-25"
site: bookdown::bookdown_site
documentclass: book
classoption: oneside # for PDFs
geometry: margin=1in # for PDFs
bibliography: [book.bib, packages.bib]
description: "This is the Level 1 data skills book for Psychology at UofG"
csl: include/apa.csl
link-citations: yes
url: https://psyteachr.github.io/data-skills-v2 # edit
github-repo: psyteachr/data-skills-v2 # edit
cover-image: images/logos/logo.png # replace with your logo
apple-touch-icon: images/logos/apple-touch-icon.png # replace with your logo
apple-touch-icon-size: 180
favicon: images/logos/favicon.ico # replace with your logo
always_allow_html: true
---



# Overview {-}

<div class="small_right"><img src="images/logos/logo.png" 
     alt="Data skills Logo" /></div>

By the end of this book, you will be able to analyse data from classic psychological experiments and questionnaires by:

* Importing and simulating data
* Manipulating and wrangling data into an appropriate format for analysis
* Calculate summaries of descriptive statistics
* Produce informative data visualisations
* Perform basic probability calculations using simulation

## How to use this book and the walkthrough videos

For most chapters of this book there is an associated walkthrough video. These videos are there to support you as you get comfortable using R, however, it's important that you use them wisely. You should always try to work through each chapter of this book (or if you prefer each activity) on your own and only then watch the video if you get stuck, or for extra information. 

For many of the initial chapters, we will provide the code you need to use. You can copy and paste from the book, however, we strongly encourage you to type out the code by yourself. This will seem much slower and you will make errors, but you will learn much more quickly this way.

Additionally, we also provide the solutions to many of the activities. No-one is going to check whether you tried to figure it out yourself rather than going straight to the solution but remember this: if you copy and paste without thinking, you will learn nothing. 

Finally, on occasion we will make updates to the book such as fixing typos and including additional detail or activities and as such this book should be considered a living document. When substantial changes are made, new walkthrough videos will be recorded, however, it would be impossible to record a new video every time we made a minor change, therefore, sometimes there may be slight differences between the walkthrough videos and the content of this book. Where there are differences between the book and the video, the book should always be considered the definitive version. 

## Changes from version 1

In terms of the coverage of skills, v2 covers the same functions as v1, however, there are a number of changes to the content and structure.

* Instructions are only given for how to use the online server version of RStudio to avoid installation issues compounding initial anxieties about coding.
* v1 used a single data in each semester. v2 now uses multiple datasets per semester to help generalise skills to new datasets and variables and to discourage blind copying and pasting. These datasets are based on classic psychological experiments where each experiment is used for two chapters.
* Pipes are introduced earlier and as the default approach to avoid students having to relearn a second method after initially learning a less efficient one.
* The concept of wide-form and long-form data is introduced earlier. Transforming data between these two formats is still done in the second semester, however, students are introduced to these data types immediately to help build familiarity before the conceptually difficult task of transformation.
* Information about coding conventions and rules (e.g., info on how functions and arguments work) that was previously in an early chapter named Programming Basics has been distributed throughout the chapters in the first semester to try and convey this information in context.
* There is now a full chapter on fixing errors.


