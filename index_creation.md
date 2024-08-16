---
title: "Index Calculation Process"
layout: page
---

**Conversion to Percentiles:**

Standardization:
- The first step in creating the index is to standardize the data by converting all non-percentile data into percentiles. Percentiles rank each data point relative to the rest of the dataset, placing values on a uniform scale from 0 to 100. This ensures that the data is comparable across different metrics and categories, regardless of their original units or scales.

Why Percentiles?
- Percentiles are particularly useful because they allow us to compare different types of data on the same scale.

**Assignment of Weights to Categories / Drivers:**

Weighting by the Web Creator:
- In this step, the web creator assigns specific weights to each category. These weights are based on the perceived importance or significance of each driver in the context of the overall index. For instance, if the index is intended to measure water reuse potentials, the web creator might assign higher weights to drivers like water scarcity and discharge volume limitations compared to others.
Customization:
- The ability to assign weights gives the web creator flexibility in tailoring the index to specific objectives or perspectives. By adjusting the weights, the creator can emphasize certain aspects of the data that are more relevant to the goals of the analysis.

**Dimensionality Reduction using Principal Component Analysis (PCA):**

PCA Overview:
- Principal Component Analysis (PCA) is a statistical technique used to reduce the dimensionality of the data while preserving as much of its variance as possible. It identifies the key components (or directions) in the data that capture the largest amount of variability.
Application to Categories:
- For each category in the dataset, PCA is applied to distill the data into a single principal component. This component represents the most significant underlying pattern or trend within that category. PCA helps simplify the data, focusing on the most informative aspects of each category, which facilitates combining them into a single index.
Why PCA?
- PCA is particularly valuable when dealing with large datasets with many variables, as it simplifies the data without losing essential information. It allows us to represent each category with a single value that captures the key variations within that category.

**Calculation of the Weighted Average (Index Creation):**

Combining PCA Values with Assigned Weights:
- Once the principal component for each category is obtained, the weights assigned by the web creator are applied to calculate a weighted average. This involves multiplying each category’s PCA-derived value by its corresponding weight.
Index Calculation:
- The final index is calculated as the sum of these weighted values. This index is a comprehensive measure that combines all the relevant information from different categories into a single score.
Interpretation:
- The resulting index is a powerful tool for comparison and analysis. It enables ranking or evaluating entities (such as regions or organizations) based on the aggregated data, providing insights that are both holistic and data-driven.


