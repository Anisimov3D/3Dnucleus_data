#============================
#
# Different data visualization methods for volume and intensity of c 1 and 2
# IMPORTANT: Requires output df from MACRO IV "final_df_C"
# (or "combined_data_C.csv" obtained from macro V)
#
#============================

final_df_MQ$nucleus <- as.factor(final_df_MQ$nucleus)
head(final_df_MQ)
str(final_df_MQ)

library(ggplot2)
# Basic violin plot
p <-ggplot(dfnuc, aes(x=nucleus, y=log10(Volume))) + 
  geom_violin()
p
# Rotate the violin plot
p + coord_flip()
# Set trim argument to FALSE
ggplot(ToothGrowth, aes(x=dose, y=len)) + 
  geom_violin(trim=FALSE)

str(dfnuc)

library(dplyr)

nuc_filtered <- dfnuc %>% filter(!nucleus %in% c("4", "5", "6"))
library(ggplot2)
q <- ggplot(nuc_filtered, aes(x=1, y=Volume, fill = nucleus)) + 
  geom_violin(alpha = 0.2, position = "identity") + theme_classic()
q

s <- q + coord_flip() + labs(x = "Ядерная оценка плотности данных, x", y = "Логарифм обьема коилин+ телец, log10(мкм^3)", 
                             title = "Сравнение распределения коилин+ телец в ядрах клеткок кумулюса", fill = "Номер ядра")
s
=
  
