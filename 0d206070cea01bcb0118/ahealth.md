This hit `#rstats` today:

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr">Has anyone made a dumbbell dot plot in <a href="https://twitter.com/hashtag/rstats?src=hash">#rstats</a>, or better yet exported to <a href="https://twitter.com/plotlygraphs">@plotlygraphs</a> using the API? <a href="https://t.co/rWUSpH1rRl">https://t.co/rWUSpH1rRl</a></p>&mdash; Ken Davis (@ken_mke) <a href="https://twitter.com/ken_mke/status/657539344929071104">October 23, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

So, I figured it was worth a cpl mins to reproduce. 

While the US gov did give the data behind the chart it was _all_ the data and a pain to work with so I used [WebPlotDigitizer](http://arohatgi.info/WebPlotDigitizer/app/) to transcribe the points and then some data wrangling in R to clean it up and make it work well with ggplot2.

It is possible to make the top "dumbbell" legend in ggplot2 (but not by using a guide) and color the "All Metro Areas" text but that's an exercise left to the reader (totally doable and not much code, but not the point of the example).