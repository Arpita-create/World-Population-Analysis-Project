# World Population Analysis (SQL + Python)

Analysis of a world population dataset (234 countries) built the way data work
usually happens on the job: the analysis runs in **MySQL**, and **Python** is
used only to turn the query results into charts.

I first built this as a pandas-only EDA notebook. This version reworks it so the
querying, aggregation and ranking happen in SQL, which is a more realistic
workflow and shows a second, in-demand skill.

## Why SQL and Python together

In most real setups the data lives in a database, so you query and summarise it
with SQL right there, then bring the smaller results into Python (or a BI tool)
to visualise. SQL isn't built to draw graphs, and pandas isn't where the data
usually starts, so each tool does the part it's good at:

- **SQL** – load, check, group, rank, and run growth/window calculations.
- **Python** – read those results and plot them.

## Project structure

```
.
├── 01_schema_and_load.sql     # create the database/table and load the CSV
├── 02_analysis_queries.sql    # the analysis queries
├── visualize.py               # runs the queries and saves the charts
├── world_population.csv        # the dataset (234 countries)
├── requirements.txt
├── charts/                     # generated charts (PNG)
└── README.md
```

## Dataset

`world_population.csv` holds 234 countries with population figures for several
years (1970 through 2023), plus area, density, growth rate and each country's
share of the world total. Two columns (`growth rate` and `world percentage`)
arrive as text with a `%` sign, so the load step strips the `%` and stores them
as numbers.

## Requirements

- MySQL 8.0 or later (window functions are used)
- Python 3.9+
- Python packages: pandas, matplotlib, seaborn, SQLAlchemy, mysql-connector-python

## Installation

1. Clone the repository and open the folder.
2. Install the Python packages:
   ```
   pip install -r requirements.txt
   ```
3. Make sure MySQL is running locally.

## Usage

1. Load the data. Run `01_schema_and_load.sql` in MySQL (via VS Code's SQLTools
   extension, MySQL Workbench, or the command line). It creates the
   `world_population` database, builds the `population` table, and loads the CSV.
   If `LOAD DATA` is blocked by your MySQL settings, use your client's
   "Import CSV" option instead.
2. Explore the data by running the queries in `02_analysis_queries.sql`.
3. Generate the charts:
   ```
   python visualize.py
   ```
   Open your MySQL password in `visualize.py` first. The charts are written to
   the `charts/` folder.

## What the analysis covers

- Data quality checks – missing values and duplicate countries
- Summary statistics for 2023 (average, spread, min/max)
- Largest and most densely populated countries
- Population and share by continent
- Average growth rate by continent
- Fastest growing and shrinking countries
- World population from 1970 to 2023
- Per-country growth over time, ranked with window functions

## Expected output

Running `visualize.py` produces six charts in `charts/`:

1. `chart1_population_histogram.png` – distribution of country populations
2. `chart2_worldpct_by_continent.png` – world population share by continent
3. `chart3_least_populous.png` – ten least populous countries
4. `chart4_density_vs_growth.png` – density vs growth rate by continent
5. `chart5_density_growth_scale.png` – density, growth and scale together
6. `chart6_population_spread.png` – spread of populations within each continent
