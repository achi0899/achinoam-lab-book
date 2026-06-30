# Photophysiology analysis

## Research aim

The aim of this analysis was to compare photophysiological performance between samples of algae exposed to **Light** and **Dark** treatments using PAM fluorometry.

## Parameters analyzed

The analysis focused on ETR measurements and parameters estimated from photosynthesis-irradiance (PI) curves.

| Parameter | Meaning | Unit |
|---|---|---|
| ETR | Electron transport rate | Relative ETR units |
| Am / Pmax | Estimated maximum photosynthetic capacity | Relative ETR units |
| AQY / alpha | Initial slope of the PI curve | ETR per PAR |
| Rd | Respiration/intercept term in the fitted curve | Relative ETR units |
| Ik | Saturation irradiance, calculated as Am/AQY | µmol photons m^-2 s^-1 |

## Materials and Methods

The algae were collected from Sdot Yam. then, the photophysiological performance were mesured, using PAM fluorometry in light and dark treatments.

Photophysiology data were analyzed in R. The raw data files were `light.csv` and `dark.csv`, and sample information was imported from `Photophysiology_metadata.csv`.

The raw ETR columns were reshaped from wide to long format. ETR values equal to zero at PAR values above zero were treated as missing values because they indicate that the measurement had ended. Following the exercise script, only PAR values below 600 µmol photons m^-2 s^-1 were used for curve fitting. Samples `Light_3` and `Light_9` were removed because they did not show the expected curve shape in the example script.

PI curves were fitted for each sample using a non-linear least squares model:

```r
ETR ~ (Am * ((AQY * PAR) / sqrt(Am^2 + (AQY * PAR)^2))) - Rd
```

From this model, Am, AQY and Rd were estimated for each sample. Ik was calculated as:

```r
Ik = Am / AQY
```

The analysis was performed in R using the packages `dplyr`, `lubridate`, `hms`, `tidyr`, `ggplot2`, `purrr`, `broom`, and `patchwork`. Package versions are reported in `R_sessionInfo.txt`.

## Results

### Figure 1. PI curves for light and dark treatments

![PI curves](https://raw.githubusercontent.com/achi0899/achinoam-lab-book/main/images/PI_curves.png)

**Figure 1.** Photosynthesis-irradiance curves for samples from the light and dark treatment groups. Points represent measured ETR values at each PAR level. Lines represent fitted PI curves for each sample.

### Figure 2. Photophysiology parameters by treatment

![Photophysiology parameters](https://raw.githubusercontent.com/achi0899/achinoam-lab-book/main/images/boxplots_parameters.png)
**Figure 2.** Estimated photophysiology parameters for light and dark treatments. The parameters are Am, AQY, Rd and Ik. Each point represents one sample, colored by taxon.

### Figure 3. Light/Dark ratios by taxon

![Difference plot](https://raw.githubusercontent.com/achi0899/achinoam-lab-book/main/images/difference_plot.png)
**Figure 3.** Light/Dark ratios for each photophysiology parameter by taxon. The dashed line indicates a ratio of 1, meaning no difference between light and dark treatments.

### Figure 4. Light-Dark differences by taxon

![Ratio plot](https://raw.githubusercontent.com/achi0899/achinoam-lab-book/main/images/ratio_plot.png)

**Figure 4.** Difference between light and dark treatments for each taxon and photophysiology parameter. Positive values indicate higher values in the light treatment, while negative values indicate higher values in the dark treatment.

## Tables

## Table 1. Summary statistics of photophysiology parameters

| Parameter | Group | n | Mean | SD | Median | Max |
|-----------|-------|--:|-----:|---:|-------:|----:|
| AQY | Dark | 8 | 0.204 | 0.056 | 0.205 | 0.308 |
| AQY | Light | 11 | 0.140 | 0.026 | 0.139 | 0.184 |
| Am | Dark | 8 | 18.97 | 10.96 | 14.83 | 40.57 |
| Am | Light | 11 | 22.78 | 11.70 | 17.73 | 47.08 |
| Ik | Dark | 8 | 119.52 | 37.42 | 123.49 | 188.65 |
| Ik | Light | 11 | 161.13 | 74.60 | 137.74 | 347.40 |
| Rd | Dark | 8 | 0.91 | 0.83 | 0.57 | 2.55 |
| Rd | Light | 11 | 0.57 | 0.45 | 0.52 | 1.51 |

**Table 1.** Summary statistics of the fitted photophysiology parameters (AQY, Am, Ik and Rd) for the Light and Dark treatment groups.


## Table 2. Wilcoxon paired tests

| Parameter | Number of pairs | p-value | BH-adjusted p-value |
|-----------|----------------:|--------:|--------------------:|
| AQY | 7 | 0.1094 | 0.2188 |
| Am | 7 | 0.2969 | 0.2969 |
| Ik | 7 | 0.1094 | 0.2188 |
| Rd | 7 | 0.2188 | 0.2917 |

**Table 2.** Results of paired Wilcoxon signed-rank tests comparing the Light and Dark treatments. No parameter showed a statistically significant difference after Benjamini–Hochberg (BH) correction (all adjusted *p* > 0.05).


## Statistical test results

- AQY: Wilcoxon paired test, n = 7, p = 0.1094, BH-adjusted p = 0.2188 (not significant).
- Am: Wilcoxon paired test, n = 7, p = 0.2969, BH-adjusted p = 0.2969 (not significant).
- Ik: Wilcoxon paired test, n = 7, p = 0.1094, BH-adjusted p = 0.2188 (not significant).
- Rd: Wilcoxon paired test, n = 7, p = 0.2188, BH-adjusted p = 0.2917 (not significant).

Overall, none of the photophysiological parameters showed statistically significant differences between the Light and Dark treatments after Benjamini–Hochberg correction (all adjusted p > 0.05).

## Interpretation

## Interpretation


The fitted PI curves and derived photophysiological parameters were used to compare algae exposed to the Light and Dark treatments.

The Wilcoxon tests did not detect statistically significant differences after Benjamini–Hochberg correction for any of the measured parameters (Am, AQY, Rd and Ik). Therefore, based on these data, there is no strong statistical evidence that the Light and Dark treatments produced consistent changes in the photophysiological performance of the algae included in this study.

However, the ratio and difference plots indicate that responses varied among algal species. This suggests that different species may respond differently to light conditions, although these trends were not statistically significant in the present dataset. In the future studies with larger sample sizes may help determine whether these species-specific patterns represent real biological responses.

