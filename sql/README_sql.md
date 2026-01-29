# SQL Data Modeling & Preparation

This folder contains the SQL scripts used to prepare, clean, normalize, and model the data for analytical purposes.

## Tables
- **dim_municipio**: dimension table with municipality information
- **fato_dengue**: fact table containing dengue incidence data
- **fato_populacao**: fact table with population indicators
- **fato_saneamento**: fact table with sanitation infrastructure data
- **agua_parana, esgoto_parana, populacao_ibge**: staging/source tables

## Process
1. Creation of dimension and fact tables using a **star schema**
2. Removal of redundancies and inconsistencies
3. Application of normalization and standardization rules
4. Integration of multiple public datasets

The final data model follows a star schema structure to optimize analytical queries and dashboard performance.
