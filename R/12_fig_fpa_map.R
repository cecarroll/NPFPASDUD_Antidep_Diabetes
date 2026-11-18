source(here::here("R", "00_config.R"))
# install.packages(c(
#   "ggplot2","dplyr","tibble","readr","tidyr","purrr","stringr","forcats",
#   "scales","patchwork","viridis","ggrepel"
# ), dependencies=TRUE)



library(tidyverse)
library(scales)
library(patchwork)
library(viridis)
library(ggrepel)


df <- mtcars |> 
  rownames_to_column("model") |> 
  as_tibble()


theme_nice <- function() {
  ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(
      panel.grid.minor = ggplot2::element_blank(),
      plot.title       = ggplot2::element_text(face = "bold"),
      legend.position  = "top"
    )
}

p_scatter <- ggplot2::ggplot(df, ggplot2::aes(x = wt, y = mpg)) +
  ggplot2::geom_point() +
  theme_nice()


p_scatter


# install.packages(c(
#   "ggplot2", "usmap", "dplyr"
# ), dependencies=TRUE)


library(tidyverse)
library(scales)
library(patchwork)
library(viridis)
library(ggrepel)
library(usmap)
library(dplyr)
library(ggplot2)
library(readr)
library(purrr)
theme_nice <- function() {
  ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(
      panel.grid.minor = ggplot2::element_blank(),
      plot.title       = ggplot2::element_text(face = "bold"),
      legend.position  = "top"
    )
}
in_dir <- paste0(DIR_CONTROLS, "/")
df <- read_csv(file.path(paste0(in_dir, "NPFPASet_Final.csv")))
df_q <- df %>%
  group_by(state, year, quarter) %>%
  summarise(treat = max(treat, na.rm = TRUE), .groups = "drop") %>%
  mutate(treat = factor(treat, levels = c("0", "1")))


theme_nice <- function() {
  ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(
      panel.grid.minor = ggplot2::element_blank(),
      plot.title       = ggplot2::element_text(face = "bold"),
      legend.position  = "top",
      axis.title = ggplot2::element_blank(),
      axis.text  = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank()
      
    )
}


years = 1998:2023
quarters = 1:4
walk(years, function(y) {
  df0 <- filter(df_q, year == y) 
  walk(quarters, function(q) {
    df1 <- filter(df0, quarter == q)
    out_file <- file.path(paste0(file.path(DIR_FIGS, "NPMap"), y, "Q", q, ".png"))
    usachart <- plot_usmap(data = df1, values = "treat") +
      facet_grid(year ~ quarter,
                 labeller = ggplot2::labeller(
                   quarter = function(q) paste0("Y", y,  " Q", q)
                 )) +
      scale_fill_manual(values = c( "0" = "grey90", "1"= "dodgerblue3"), 
                        breaks = c("0", "1"),
                        labels = c("Control: FPA Not Allowed", "Treated: FPA Implemented"),
                        name   = "NP FPA") +
      labs(fill = "NP FPA") +
      theme_nice() +
      theme(panel.grid = element_blank(), strip.text.y = ggplot2::element_blank(),
      strip.background = ggplot2::element_blank(), strip.text.x = ggplot2::element_text(face = "bold", size = 12))
    
  
  
    ggsave(filename = out_file, plot = usachart, width = 9, height = 6, dpi = 300)
  } 
  )
}
)
#usmap::plot_usmap(data = df_2010, values = "treat")


  df0 <- filter(df_q, year == y) 
 
    df1 <- filter(df0, quarter == q)
    out_file <- file.path(paste0(file.path(DIR_FIGS, "NPMap"), y, "Q", q, ".png"))
    usachart <- plot_usmap(data = df1, values = "treat") +
      facet_grid(year ~ quarter,
                 labeller = ggplot2::labeller(
                   year    = function(y) paste0("Year ", y),
                   quarter = function(q) paste0("Q", q)
                 )) +
      scale_fill_manual(values = c( "0" = "grey90", "1"= "dodgerblue3")) +
      labs(fill = "NP FPA") +
      theme_nice() +
      theme(panel.grid = element_blank(), strip.text.y = ggplot2::element_blank(),
            strip.background = ggplot2::element_blank(), strip.text.x = ggplot2::element_text(face = "bold", size = 12))
    
    
    
    ggsave(filename = out_file, plot = usachart)

