It's a very astute and appropriate question & one I touched on in a blog (link at end of twitter rant :-)

There are a few reasons for githubbing. The ones here are far from exhaustive.

First, many folks are fleshing out an idea (so it's a short-or-long WIP) and also looking for collaborators and testers. This is a good/necessary iteration step IMO as it garners attention from the community and one can get a sense for the utility/desirability/reach. 

The "CRAN" hurdle is a serious effort that all pkg authors (even if they aren't on GH or CRAN) should strive to vault since the checks associated with it really help with overall package quality. 

Now, I'm as "guilty" as anyone else when it comes to having GH-only packages and I do it for many reasons. 

Some of them are there b/c I needed to make something quick for personal/work use but didn't have time to dot the i's and cross the t's for the CRAN hurdle or it's not fully finished and not ready for CRAN. Some involve C[++] code that only works on macOS or Linux and I don't have the time or skill to get it working on Windows. Some — like my recent splashr package — just took time to bake. 

I, too, am really, really wary of relying on GH code or branches for production work and I am more concerned than I should likely be about the threat of hacking (see hrbrmstr/rpwnd for an example of how dangerous pkgs can be). 

But, CRAN — as we noted in notary — is no security panacea. I could likely embed some pretty destructive code in one of my packages. There are also packages (esp for Windows) that use vulnerable embedded binary libraries, thus baking in vulnerabilities to R code. So, really, CRAN buys you some goodness but you're stil at risk (and thanks to Hadley I did poke at bioconductor and ran away screaming). 

I would absolutely suggest avoiding devtools::install_github() and forking + cloning forked repos and doing at least a cursory code-review before installing from said clone and keeping the clone sync'd with releases when you want new functionality. 

But, we also live in a computing world where other things are curl-piped-to-bash (outside of R stuff) without you knowing. 

And, a world where we're docker-running things with wild abandon (that can be super bad btw). 

And, a world where we're asked to right-click and enable non-certified programs to run b/c devs are too lazy to code sign them. (I could go on).

So, I'll leave you with said link to a previous personal blathering on this but also invite you to keep asking great questions that help the community become safer and more secure. We need more folks like you! 

https://rud.is/b/2017/02/23/on-watering-holes-trust-defensible-systems-and-data-science-community-security/