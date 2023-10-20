
# Server troubleshooting

## Can't access server

Sometimes the server crashes. Often, there's nothing we can do about this until IT fix it but one useful trick to try if you are getting an error message when trying to access the server is to open the server in an incognito window. 

If this works, [clear your cache](https://its.uiowa.edu/support/article/719) and that should fix it long-term (well, until the next crash). This also sometimes works if you're having issues accessing Moodle or MyCampus. 

## Out of date packages

If you get an error message that says something like `namespace package 1.1.0 is already loaded, but >= 2.0.1 is required` then it likely means that you have installed a newer version of a package on the server. As it notes in the the [original explanation of packages and functions](https://psyteachr.github.io/data-skills-v2/stroop.html#sec-install-package), you should not be installing anything on the server, everything you need is there and installing updated versions of packages only causes issues. We promise that we don't write these things down just for fun! 

If this is happening to you, run the following code in the console. This will uninstall any packages you have installed and default to the ones on the server so everything will work again:


```r
lapply(dir("~/.Rp/packages", full.names = TRUE), unlink, TRUE, TRUE)
```

