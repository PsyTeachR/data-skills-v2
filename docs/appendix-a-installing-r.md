# Installing `R` {#installing-r}

Installing R and RStudio is usually straightforward. The sections below explain how and [there is a helpful YouTube video here](https://www.youtube.com/watch?v=lVKMsaWju8w){target="_blank"}.

## Installing Base R

[Install base R](https://cran.rstudio.com/){target="_blank"}. Choose the download link for your operating system (Linux, Mac OS X, or Windows).

If you have a Mac, install the latest release from the newest `R-x.x.x.pkg` link (or a legacy version if you have an older operating system). After you install R, you should also install [XQuartz](http://xquartz.macosforge.org/){target="_blank"} to be able to use some visualisation packages.

If you are installing the Windows version, choose the "[base](https://cran.rstudio.com/bin/windows/base/)" subdirectory and click on the download link at the top of the page. After you install R, you should also install [RTools](https://cran.rstudio.com/bin/windows/Rtools/){target="_blank"}; use the "recommended" version highlighted near the top of the list.

If you are using Linux, choose your specific operating system and follow the installation instructions.

## Installing RStudio

Go to [rstudio.com](https://www.rstudio.com/products/rstudio/download/#download){target="_blank"} and download the RStudio Desktop (Open Source License) version for your operating system under the list titled **Installers for Supported Platforms**.

## RStudio Settings

There are a few settings you should fix immediately after updating RStudio. Go to **`Global Options...`** under the **`Tools`** menu (&#8984;,), and in the General tab, uncheck the box that says **`Restore .RData into workspace at startup`**.  If you keep things around in your workspace, things will get messy, and unexpected things will happen. You should always start with a clear workspace. This also means that you never want to save your workspace when you exit, so set this to **`Never`**. The only thing you want to save are your scripts.

You may also want to change the appearance of your code. Different fonts and themes can sometimes help with visual difficulties or [dyslexia](https://datacarpentry.org/blog/2017/09/coding-and-dyslexia){target="_blank"}. 

<div class="figure" style="text-align: center">
<img src="images/rstudio_settings_general_appearance.png" alt="RStudio General and Appearance settings" width="100%" />
<p class="caption">(\#fig:settings-general)RStudio General and Appearance settings</p>
</div>

You may also want to change the settings in the Code tab. Foe example, some people prefer two spaces instead of tabs for their code and like to be able to see the <a class='glossary' target='_blank' title='Spaces, tabs and line breaks' href='https://psyteachr.github.io/glossary/w#whitespace'>whitespace</a> characters. But these are all a matter of personal preference.

<div class="figure" style="text-align: center">
<img src="images/rstudio_settings_code.png" alt="RStudio Code settings" width="100%" />
<p class="caption">(\#fig:settings-code)RStudio Code settings</p>
</div>


## Installing LaTeX

You can install the LaTeX typesetting system to produce PDF reports from RStudio. Without this additional installation, you will be able to produce reports in HTML but not PDF. This course will not require you to make PDFs. To generate PDF reports, you will additionally need to install <code class='package'>tinytex</code> [@R-tinytex] and run the following code:


```r
tinytex::install_tinytex()
```


## Installing packages

Whilst Base R comes with built-in functions, you will also need to install any additional packages you want to use. 

You can install packages using the `install.packages()` function. **Only ever run this command in the console, never save it in a script or Markdown**. This is because if you save it in a script, everytime you run that script it will install the package again. At best, this will be a waste of time and at work, it might install a more recent version of the package that no longer works with your code.


```r
install.packages("tidyverse")
```

When you run this code it will produce a bunch of text until it eventually installs. You're looking for something that says "package ‘tidyverse’ successfully unpacked and MD5 sums checked" which confirms that the installation has been successful. Once you've done this, you can then run `library(tidyverse)` as usual. You only need to install packages once but remember you need to load them each time you use them.

If you ever get an error message saying "No package called X", check you've spelled the name of the package right and if so, it might be that you need to install it using the same method. 
