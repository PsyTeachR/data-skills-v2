
# Who knows

### Adding a theme

In addition to adding colour, you can also apply a theme to the entire plot which will apply a preset aesthetic style.

* The below code adds on `theme_minimal()` but try removing this line and then typing `theme_` to see all the options that are available with the auto-complete. Try a few and see which one your favourite is.


```r
ggplot(age_control, aes(x = Condition, 
                        y = Corsi_Score, 
                        fill = Condition)) +
  geom_boxplot(alpha = 0.9) +
  guides(fill = "none") +
  scale_fill_viridis_d(option = "E") +
  theme_minimal()
```
