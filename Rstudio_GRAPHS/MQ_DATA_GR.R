#============================
#
# Different data visualization methods for volume and intensity of c 1 and 2
# IMPORTANT: Requires output df from MACRO IV "final_df_C"
# (or "combined_data_C.csv" obtained from macro V)
#
#============================
library(dplyr)
library(ggplot2)

#Cleaning

final_df_MQ$nucleus <- as.factor(final_df_MQ$nucleus)
head(final_df_MQ)
str(final_df_MQ)

str(dfnuc)



#nuc_filtered <- dfnuc %>% filter(!nucleus %in% c("4", "5", "6"))

#DATA STRUCTURE and parameters

mean(measurements_count$measurements)
sd(measurements_count$measurements)

sum(measurements_count$measurements)
# Amount: 7.85 +- 4.03, Bimodal distrubution of coilin+ bodies in some cases 5/14.
# THe DAPI region surrounds the Coilin+ Bodies



#GRAPHS

library(ggplot2)
violin_mq <- ggplot(final_df_MQ, aes(x=1, y=log10(Vol..unit.), fill = nucleus)) + 
  geom_violin(alpha = 0.1, position = "identity") + theme_classic() +
  facet_wrap(~nucleus)
violin_mq + labs(x = "Kernel density estimation, x", y = "Volume of coilin+ bodies, log10(um^3)", 
                             title = "Distribution of coilin+ bodies by volume in each individual nucleus", fill = "Nucleus number")
s
#scattergraph

# First calculate the means
mean_data <- final_df_MQ %>%
  group_by(measurements) %>%
  summarise(mean_Mean = mean(Mean, na.rm = TRUE))

# calculate SD
library(dplyr)

summary_data <- final_df_MQ %>%
  group_by(measurements) %>%
  summarise(
    mean_Mean = mean(Mean, na.rm = TRUE),
    sd_Mean = sd(Mean, na.rm = TRUE)  # Standard deviation
  )

# Then plot

# Calculate correlation statistics
cor_test <- cor.test(summary_data$measurements, summary_data$mean_Mean)

# Create plot with regression line and statistics
point_mq <- ggplot(summary_data, aes(x = measurements, y = mean_Mean)) + 
  geom_point(size = 3, color = "blue") +
  geom_errorbar(
    aes(ymin = mean_Mean - sd_Mean, ymax = mean_Mean + sd_Mean),
    width = 0.2, color = "red"
  ) +
  geom_smooth(method = "lm", se = FALSE, color = "black") +  # Add regression line
  labs(
    x = "Количество телец кахаля", 
    y = "Mean grey valaue ± SD"
  ) +
  theme_classic() +
  annotate("text", 
           x = Inf, y = Inf,
           hjust = 1.1, vjust = 1.5,
           label = paste0("r = ", round(cor_test$estimate, 3), 
                          "\np = ", format.pval(cor_test$p.value, digits = 2)),
           size = 5)

point_mq
#second lm graph

library(ggplot2)
library(dplyr)

# Calculate summary stats (mean ± SD)
summary_data <- final_df_MQ %>%
  group_by(measurements) %>%
  summarise(
    mean_Vol..unit. = mean(Vol..unit., na.rm = TRUE),
    sd_Vol..unit. = sd(Vol..unit., na.rm = TRUE)
  )

# Plot with error bars + regression line
ggplot(summary_data, aes(x = measurements, y = mean_Vol..unit.)) + 
  geom_point(size = 3, color = "blue") +                     # Mean points
  geom_errorbar(
    aes(ymin = mean_Vol..unit. - sd_Vol..unit., ymax = mean_Vol..unit. + sd_Vol..unit.),
    width = 0.2, color = "red"                              # Error bars (SD)
  ) +
  geom_smooth(
    method = "lm",          # Linear regression
    formula = y ~ x,        # Explicitly specify the relationship
    se = TRUE,              # Show confidence interval (shaded area)
    color = "darkgreen",    # Line color
    linewidth = 1           # Line thickness
  ) +
  labs(
    x = "Количество Коилин+ телец",
    y = "Средний обьем тельца, мкм^3",
  ) +
  theme_classic()

# Calculate summary stats (mean ± SD)
summary_data <- final_df_MQ %>%
  group_by(measurements) %>%
  summarise(
    mean_Vol..unit. = mean(Vol..unit., na.rm = TRUE),
    sd_Vol..unit. = sd(Vol..unit., na.rm = TRUE)
  )

# Calculate Pearson correlation and p-value (using raw data, not summarized)
cor_test_result <- cor.test(final_df_MQ$measurements, final_df_MQ$Vol..unit., 
                            method = "pearson")
pearson_r <- cor_test_result$estimate
p_value <- cor_test_result$p.value

# Plot with error bars + regression line + correlation annotation
ggplot(summary_data, aes(x = measurements, y = mean_Vol..unit.)) + 
  geom_point(size = 3, color = "blue") +                     # Mean points
  geom_errorbar(
    aes(ymin = mean_Vol..unit. - sd_Vol..unit., ymax = mean_Vol..unit. + sd_Vol..unit.),
    width = 0.2, color = "red"                              # Error bars (SD)
  ) +
  geom_smooth(
    method = "lm",          # Linear regression
    formula = y ~ x,        # Explicitly specify the relationship
    se = TRUE,              # Show confidence interval (shaded area)
    color = "darkgreen",    # Line color
    linewidth = 1           # Line thickness
  ) +
  labs(
    x = "Количество Коилин+ телец",
    y = "Средний обьем тельца, мкм^3"
  ) +
  annotate("text", x = Inf, y = Inf, 
           label = sprintf("r = %.2f, p = %.3f", pearson_r, p_value),
           hjust = 1.1, vjust = 1.1, size = 5) +  # Annotation in top-right corner
  theme_classic()

  