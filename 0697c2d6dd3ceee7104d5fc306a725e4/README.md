A few ways to visualize 1D distributions.

Swarm and pile plots show all the data points but can't be used when
there are a lot of data points. Histograms and boxplots work for any number
of data points since they are visualizing summary statistics. Histograms
provide more information than a boxplot. Boxplots fit in small spaces,
making them nice for comparing many distributions side-by-side.

Other chart types for 1D distributions:
[violin plot](http://docs.ggplot2.org/current/geom_violin.html),
[kernel density](http://docs.ggplot2.org/current/geom_density.html),
[empirical CDF](http://docs.ggplot2.org/current/stat_ecdf.html).

The [d3.forceChart()](https://github.com/armollica/force-chart) plugin is used for the
swarm and pile plots; [d3.layout.histogram()](https://github.com/mbostock/d3/wiki/Histogram-Layout#histogram)
for the histogram; [d3.scale.quantile()](https://github.com/mbostock/d3/wiki/Quantitative-Scales#quantile-scales)
for the quartile summary statistics used in the boxplot.
