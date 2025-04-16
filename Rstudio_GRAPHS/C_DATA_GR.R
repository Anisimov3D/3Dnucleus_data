#============================
#
# Different data visualization methods for co localisation of channel 1 and 2
# IMPORTANT: Requires output df from MACRO V "final_df_C"
# (or "combined_data_C.csv" obtained from macro V)
#
#============================

# libraries + data frame cleaning
library(ggplot2)
library(dplyr)

final_df_C$nucleus <- as.factor(final_df_C$nucleus)
final_df_C$Obj1 <- as.factor(final_df_C$Obj1)
final_df_C$Obj2 <- as.factor(final_df_C$Obj2)
head(final_df_C)


str(final_df_C)

#Coilin (c1) surface contact
nuc_filtered_C1 <- final_df_C[final_df_C$Obj1 == 1, ]
str(nuc_filtered_C1)
#Dapi (c2) surface contact
nuc_filtered_C2 <- final_df_C[final_df_C$Obj1 == 1, ]
str(nuc_filtered_C2)

#============================
# General Statistics
#============================



#============================
# GRAPHS
#============================

# Optional: add for labeling to each graph
# + labs(x = "Ядерная оценка плотности данных, x", y = "Логарифм обьема коилин+ телец, log10(мкм^3)", title = "Сравнение распределения коилин+ телец в ядрах клеткок кумулюса", fill = "Номер ядра")

# Bar graph for C1
dis_graph <- ggplot(nuc_filtered_C1, aes(x=nucleus, y=SurfCont.pos,  fill = nucleus)) + 
  geom_col(alpha = 0.2, position = "identity") + theme_classic() +  guides(fill = "none") +
  labs(x = "Номер ядра", y = "Относительная площадь контакта, surface voxel", 
  title = "Площадь контакта между коилин+ тельцами (C1) и DAPI (C2)")
dis_graph

#bar graph for c1 and c2
dis_graph_C12 <- ggplot(final_df_C, aes(x=nucleus, y=SurfCont.pos,  fill = Obj1)) + 
  geom_col(alpha = 1, position = position_dodge(width = 0.8)) + theme_classic()
dis_graph_C12 + labs(x = "Ядерная оценка плотности данных, x", y = "Логарифм обьема коилин+ телец, log10(мкм^3)", title = "Сравнение распределения коилин+ телец в ядрах клеткок кумулюса", fill = "Номер Канала")

#Boxplot graph for c1 and c2
dis_graph_C12 <- ggplot(final_df_C, aes(x=1, y=SurfCont.pos,  fill = Obj1)) + 
  geom_boxplot(alpha = 1, position = position_dodge(width = 0.8)) + 
  theme_classic() + labs(x = "x", y = "Относительная площадь контакта, surface voxel", 
  title = "Разница площадей контакта между Коилин+ (1) и DAPI+ (2) регионом", fill = "Номер Канала")
dis_graph_C12

# Box plot
box_graph <- ggplot(nuc_filtered_C, aes(x=1, y=SurfCont.pos)) + 
  geom_boxplot(alpha = 0.2, position = "identity") + theme_classic()
box_graph
