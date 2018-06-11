ggplot(mtcars, aes(mpg, wt*30)) +
  geom_point() +
  labs(x="Fuel effiiency (mpg)", y="Weight (tons)",
       title="Seminal ggplot2 scatterplot example",
       subtitle="A plot that is only useful for demonstration purposes",
       caption="Brought to you by the letter 'g'") +
  theme_ipsum(base_family="San Francisco Text",
              subtitle_family="San Francisco Text",
              subtitle_face = "plain",
              axis_title_family = "San Francisco Text Medium",
              axis_title_face = "plain",
              caption_family="San Francisco Text Light",
              caption_face = "plain")
