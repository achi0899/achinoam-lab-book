# Photophysiology analysis - Achinoam Kling
# Place this script in the same folder as:
# light.csv, dark.csv, Photophysiology_metadata.csv

library(dplyr)
library(lubridate)
library(hms)
library(tidyr)
library(ggplot2)
library(purrr)
library(broom)
library(patchwork)

# Optional: set your working directory
# setwd("C:/Users/achi0/OneDrive/Documents/GitHub/achinoam-lab-book/Photophysiology")

dir.create("images", showWarnings = FALSE)

metadata <- read.csv("Photophysiology_metadata.csv", header = TRUE)
# Correct one spelling difference so Galaxaura can be paired between treatments
metadata$Taxon <- ifelse(metadata$Taxon == "Galxaura", "Galaxaura", metadata$Taxon)

light_PAM <- read.csv("light.csv", header = TRUE, sep = ";")
dark_PAM  <- read.csv("dark.csv", header = TRUE, sep = ";")

light_PAM$Date <- dmy(light_PAM$Date)
light_PAM$Time <- as_hms(light_PAM$Time)
dark_PAM$Date <- dmy(dark_PAM$Date)
dark_PAM$Time <- as_hms(dark_PAM$Time)

# Extract ETR columns and reshape from wide to long
light_ETR <- light_PAM[, c("Date", "Time", "No.", "PAR", paste0("ETR", 1:13))]
dark_ETR  <- dark_PAM[,  c("Date", "Time", "No.", "PAR", paste0("ETR", 1:8))]

light_ETR_long <- light_ETR %>%
  pivot_longer(cols = starts_with("ETR"), names_to = "Sample", values_to = "ETR")

dark_ETR_long <- dark_ETR %>%
  pivot_longer(cols = starts_with("ETR"), names_to = "Sample", values_to = "ETR")

metadata_light <- metadata %>% filter(Group == "Light") %>% mutate(ETR_name = paste0("ETR", Sample))
metadata_dark  <- metadata %>% filter(Group == "Dark")  %>% mutate(ETR_name = paste0("ETR", Sample))

light_ETR_long$Sample_ID <- metadata_light$Sample_ID[match(light_ETR_long$Sample, metadata_light$ETR_name)]
light_ETR_long$Taxon     <- metadata_light$Taxon[match(light_ETR_long$Sample, metadata_light$ETR_name)]
light_ETR_long$Group     <- "Light"

dark_ETR_long$Sample_ID <- metadata_dark$Sample_ID[match(dark_ETR_long$Sample, metadata_dark$ETR_name)]
dark_ETR_long$Taxon     <- metadata_dark$Taxon[match(dark_ETR_long$Sample, metadata_dark$ETR_name)]
dark_ETR_long$Group     <- "Dark"

# Remove zero ETR values at PAR > 0 because they indicate that the measurement ended
light_ETR_long$ETR[light_ETR_long$ETR == 0 & light_ETR_long$PAR > 0] <- NA
dark_ETR_long$ETR[dark_ETR_long$ETR == 0 & dark_ETR_long$PAR > 0] <- NA

Photophysiology_ready_for_R <- bind_rows(light_ETR_long, dark_ETR_long)
write.csv(Photophysiology_ready_for_R, "Photophysiology_ready_for_R.csv", row.names = FALSE)

# Filter data for PI curve fitting
# Following the exercise script: PAR < 600, and remove Light_3 and Light_9 because their curves did not reach expected shape.
light_ETR_pi <- light_ETR_long %>%
  filter(PAR < 600, !is.na(ETR), !Sample_ID %in% c("Light_3", "Light_9"))

dark_ETR_pi <- dark_ETR_long %>%
  filter(PAR < 600, !is.na(ETR))

photo_model <- function(data) {
  nls(
    ETR ~ (Am * ((AQY * PAR) / sqrt(Am^2 + (AQY * PAR)^2))) - Rd,
    data = data,
    start = list(Am = 0.7, AQY = 0.001, Rd = 0.4)
  )
}

fit_parameters <- function(df) {
  df %>%
    group_by(Sample_ID) %>%
    nest() %>%
    mutate(
      model = map(data, photo_model),
      params = map(model, tidy)
    ) %>%
    unnest(params) %>%
    select(Sample_ID, term, estimate) %>%
    pivot_wider(names_from = term, values_from = estimate) %>%
    mutate(Ik = Am / AQY)
}

light_nls_data <- fit_parameters(light_ETR_pi)
dark_nls_data  <- fit_parameters(dark_ETR_pi)

nls_data <- bind_rows(light_nls_data, dark_nls_data)
nls_data$Taxon <- metadata$Taxon[match(nls_data$Sample_ID, metadata$Sample_ID)]
nls_data$Group <- metadata$Group[match(nls_data$Sample_ID, metadata$Sample_ID)]
write.csv(nls_data, "Photophysiology_parameters.csv", row.names = FALSE)

nls_data_long <- nls_data %>%
  pivot_longer(cols = c(Am, AQY, Rd, Ik), names_to = "Photo_vars", values_to = "Value")

Photophysiology_summary_table <- nls_data_long %>%
  group_by(Photo_vars, Group) %>%
  summarise(
    n = sum(!is.na(Value)),
    mean = mean(Value, na.rm = TRUE),
    sd = sd(Value, na.rm = TRUE),
    min = min(Value, na.rm = TRUE),
    q25 = quantile(Value, 0.25, na.rm = TRUE),
    median = median(Value, na.rm = TRUE),
    q75 = quantile(Value, 0.75, na.rm = TRUE),
    max = max(Value, na.rm = TRUE),
    .groups = "drop"
  )
write.csv(Photophysiology_summary_table, "Photophysiology_summary_table.csv", row.names = FALSE)

# Augmented fitted values for PI curves
augment_fit <- function(df) {
  df %>%
    group_by(Sample_ID) %>%
    nest() %>%
    mutate(
      fit = map(data, photo_model),
      augmented = map(fit, augment)
    ) %>%
    unnest(augmented)
}

augmented_light <- augment_fit(light_ETR_pi)
augmented_light$Taxon <- metadata$Taxon[match(augmented_light$Sample_ID, metadata$Sample_ID)]

augmented_dark <- augment_fit(dark_ETR_pi)
augmented_dark$Taxon <- metadata$Taxon[match(augmented_dark$Sample_ID, metadata$Sample_ID)]

PI_curves_light <- ggplot(augmented_light, aes(x = PAR, y = ETR, color = Taxon)) +
  geom_point() +
  geom_line(aes(y = .fitted, group = Sample_ID)) +
  theme_classic() +
  labs(title = "Light", x = "PAR (µmol photons m-2 s-1)", y = "ETR")

PI_curves_dark <- ggplot(augmented_dark, aes(x = PAR, y = ETR, color = Taxon)) +
  geom_point() +
  geom_line(aes(y = .fitted, group = Sample_ID)) +
  theme_classic() +
  labs(title = "Dark", x = "PAR (µmol photons m-2 s-1)", y = "ETR")

ggsave("images/PI_curves.png", PI_curves_light + PI_curves_dark, width = 11, height = 5, dpi = 300)

boxplots_parameters <- ggplot(nls_data_long, aes(x = Group, y = Value)) +
  geom_boxplot() +
  geom_point(aes(color = Taxon), size = 2, position = position_jitter(width = 0.2)) +
  facet_wrap(~Photo_vars, scales = "free") +
  theme_bw() +
  labs(title = "Photophysiology parameters by treatment", x = "Treatment group", y = "Parameter value")

ggsave("images/boxplots_parameters.png", boxplots_parameters, width = 9, height = 6, dpi = 300)

# Paired taxon analysis
nls_data_long_filtered <- nls_data_long %>%
  group_by(Taxon) %>%
  filter(n_distinct(Group) == 2) %>%
  ungroup()

diff_by_taxon <- nls_data_long_filtered %>%
  group_by(Taxon, Photo_vars, Group) %>%
  summarise(Value = mean(Value, na.rm = TRUE), .groups = "drop") %>%
  pivot_wider(names_from = Group, values_from = Value) %>%
  mutate(Difference = Light - Dark, Ratio = Light / Dark)
write.csv(diff_by_taxon, "Photophysiology_difference_ratio.csv", row.names = FALSE)

ratio_plot <- ggplot(diff_by_taxon, aes(x = Taxon, y = Ratio, fill = Taxon)) +
  geom_col() +
  geom_hline(yintercept = 1, linetype = "dashed") +
  facet_wrap(~Photo_vars, scales = "free") +
  theme_bw() +
  labs(title = "Light/Dark ratio for photophysiology parameters", x = "Taxon", y = "Light / Dark ratio")

ggsave("images/ratio_plot.png", ratio_plot, width = 10, height = 6, dpi = 300)

difference_plot <- ggplot(diff_by_taxon, aes(x = Taxon, y = Difference, fill = Taxon)) +
  geom_col() +
  geom_hline(yintercept = 0, linetype = "dashed") +
  facet_wrap(~Photo_vars, scales = "free") +
  theme_bw() +
  labs(title = "Light-Dark difference for photophysiology parameters", x = "Taxon", y = "Light - Dark")

ggsave("images/difference_plot.png", difference_plot, width = 10, height = 6, dpi = 300)

test_paired <- nls_data_long_filtered %>%
  select(Taxon, Group, Photo_vars, Value) %>%
  pivot_wider(names_from = Group, values_from = Value) %>%
  group_by(Photo_vars) %>%
  summarise(
    n_pairs = sum(!is.na(Light) & !is.na(Dark)),
    p_value = wilcox.test(Light, Dark, paired = TRUE)$p.value,
    .groups = "drop"
  ) %>%
  mutate(p_adjusted_BH = p.adjust(p_value, method = "BH"))
write.csv(test_paired, "Photophysiology_wilcoxon_tests.csv", row.names = FALSE)

# Record package versions for Materials & Methods
sink("R_sessionInfo.txt")
sessionInfo()
sink()

# Save the full R environment
save.image("Photophysiology_analysis_environment.RData")
