
World Population Analysis Using SQL and Python

This project analyses a world population dataset containing information for 234 countries.

MySQL is used to store, clean, aggregate, and analyse the data, while Python is used to generate clear visualisations from the SQL query results. The project covers population distribution, continental trends, growth rates, density, historical changes, and country-level rankings.

---

Project Overview

The analysis focuses on understanding how the global population is distributed across countries and continents.

It examines:

* Population distribution across countries
* Population share by continent
* Population density
* Country-wise growth rates
* Fastest-growing and declining populations
* Historical world population trends
* Country rankings using SQL window functions
* Data quality issues such as missing values and duplicate records

---

Project Structure

```text
.
├── 01_schema_and_load.sql
├── 02_analysis_queries.sql
├── visualize.py
├── world_population.csv
├── requirements.txt
├── charts/
└── README.md
```

File Description

* `01_schema_and_load.sql` creates the database and table and loads the CSV data.
* `02_analysis_queries.sql` contains the SQL queries used for analysis.
* `visualize.py` runs selected SQL queries and generates the charts.
* `world_population.csv` contains the population data for 234 countries.
* `requirements.txt` contains the required Python packages.
* `charts/` stores the generated visualisations.

---

Dataset

The dataset contains population-related information for 234 countries.

The available data includes:

* Population figures from 1970 to 2023
* Country area
* Population density
* Population growth rate
* Continent
* Country rank
* Percentage share of the world population

The `growth rate` and `world percentage` columns originally contain percentage symbols. During the data-loading process, the symbols are removed and the values are stored in numerical format for analysis.

---

Technologies Used

* MySQL 8.0 or later
* Python 3.9 or later
* pandas
* Matplotlib
* Seaborn
* SQLAlchemy
* MySQL Connector for Python

MySQL 8.0 or later is required because the analysis uses window functions.

---
Installation

1. Clone the Repository

```bash
git clone <repository-url>
cd world-population-analysis
```
 2. Install the Required Python Packages

```bash
pip install -r requirements.txt
```

3. Start MySQL

Make sure the local MySQL server is running before loading the dataset or generating charts.

---

Loading the Dataset

Run the following SQL file in MySQL:

```text
01_schema_and_load.sql
```

This script:

* Creates the `world_population` database
* Creates the `population` table
* Defines the required columns and data types
* Loads the population dataset from the CSV file
* Converts percentage-based text columns into numerical values

The script can be executed using:

* MySQL Workbench
* VS Code with the SQLTools extension
* MySQL command line
* Any compatible MySQL client

If the `LOAD DATA` command is restricted by the local MySQL configuration, the CSV file can be imported using the client application's CSV import feature.

---

Running the SQL Analysis

After loading the dataset, run:

```text
02_analysis_queries.sql
```

The file contains queries for:

* Checking missing values
* Identifying duplicate countries
* Calculating summary statistics
* Finding the most and least populated countries
* Finding the most densely populated countries
* Comparing continents by total population
* Calculating average population growth by continent
* Identifying growing and declining populations
* Examining historical world population
* Ranking countries using SQL window functions

Each query can also be executed separately for closer inspection.

---

Generating the Charts

Before running the Python file, update the MySQL connection details inside `visualize.py`.

The connection configuration includes:

```python
host = "localhost"
user = "root"
password = "your_mysql_password"
database = "world_population"
```

Run the visualisation script:

```bash
python visualize.py
```

The generated charts are saved automatically in the `charts/` folder.

---

Analysis Performed

Data Quality Checks

The dataset is checked for:

* Missing values
* Duplicate country records
* Invalid population values
* Inconsistent percentage values
* Incorrect or incomplete continent information

---

Population Summary

The analysis calculates key statistics for the 2023 population, including:

* Average population
* Minimum population
* Maximum population
* Population spread
* Total number of countries

---

Most Populated Countries

Countries are ranked according to their 2023 population.

This analysis highlights the countries that contribute the largest share of the global population.

---

Least Populated Countries

The countries with the smallest populations are identified and compared.

This helps show the wide difference in population size between highly populated countries and smaller nations or territories.

---

Population Density

Countries are ranked by population density to identify locations with a high number of people living within a relatively small geographical area.

---

Population by Continent

Country populations are grouped by continent to calculate:

* Total continental population
* Average country population
* Number of countries in each continent
* Percentage contribution to the global population

---

Population Growth

The analysis compares population growth rates across countries and continents.

It identifies:

* Countries with the highest growth rates
* Countries with declining populations
* Continents with the highest average growth
* Differences in growth patterns across regions

---

Historical Population Trend

Population figures from 1970 to 2023 are combined to show how the global population has changed over time.

This analysis provides a broader view of long-term global population growth.

---

Country-Level Growth Ranking

SQL window functions are used to calculate and rank population growth for individual countries.

The ranking makes it possible to compare countries based on their population change over different time periods.

---

Generated Charts

Running `visualize.py` produces six charts.

1. Population Distribution

```text
chart1_population_histogram.png
```

Shows the distribution of country populations in 2023.

Most countries have relatively small populations, while a limited number of countries account for a much larger share of the global population.

---

2. Population Share by Continent

```text
chart2_worldpct_by_continent.png
```

Displays the percentage of the world's population represented by each continent.

---

3. Least Populated Countries

```text
chart3_least_populous.png
```

Compares the ten countries or territories with the smallest populations in the dataset.

---
4. Most Densely Populated Countries

```text
chart4_most_dense.png
```

Shows the countries with the highest population density.

---

5. Average Growth Rate by Continent

```text
chart5_growth_by_continent.png
```

Compares the average population growth rate across continents.

---
6. World Population Over Time

```text
chart6_world_population_trend.png
```

Shows the change in total world population from 1970 to 2023.

---

Example Workflow

The project can be completed in the following sequence:

```text
1. Run 01_schema_and_load.sql
2. Run 02_analysis_queries.sql
3. Update the MySQL credentials in visualize.py
4. Run python visualize.py
5. View the generated charts in the charts/ folder
```

---

Skills Demonstrated

This project demonstrates practical skills in:

* SQL database creation
* CSV data loading
* Data cleaning
* SQL aggregation
* Grouping and filtering
* Ranking and window functions
* Historical trend analysis
* Python database connectivity
* Data visualisation
* Project organisation

---

Limitations

The dataset provides population information at the country level and does not include detailed demographic factors such as:

* Age distribution
* Birth rate
* Death rate
* Migration
* Urban and rural population
* Income levels
* Employment patterns

The analysis is therefore focused on population size, density, geographical distribution, and growth.

---

Future Improvements

Possible extensions include:

* Adding birth-rate and death-rate data
* Including migration statistics
* Comparing population with GDP
* Analysing urbanisation
* Building an interactive dashboard
* Adding regional and subregional comparisons
* Automating database configuration using environment variables
* Creating continent-specific trend charts
* Comparing population growth with land area and density

---

Conclusion

This project provides a structured analysis of world population patterns using SQL and Python.

The SQL queries identify major trends in population size, growth, density, continental distribution, and historical change. The Python visualisations make the results easier to interpret and communicate.

Together, the analysis provides a clear overview of how the global population is distributed and how it has changed over time.
