# Reads the analysis results from MySQL and saves the charts.
# The database does the aggregation; this script just plots what comes back.
# Chart types follow the original pandas EDA notebook.

import os
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from sqlalchemy import create_engine

# Update the password to match your local MySQL setup.
DB_URL = "mysql+mysqlconnector://root:your_password@localhost:3306/world_population"
engine = create_engine(DB_URL)

sns.set_theme(style="whitegrid")
os.makedirs("charts", exist_ok=True)


def run(sql):
    return pd.read_sql(sql, engine)


# 1. Distribution of country population in 2023
df = run("SELECT pop_2023 FROM population WHERE pop_2023 IS NOT NULL")
plt.figure(figsize=(10, 6))
sns.histplot(df["pop_2023"], bins=40)
plt.title("Distribution of Country Population (2023)")
plt.xlabel("Population")
plt.ylabel("Number of countries")
plt.tight_layout()
plt.savefig("charts/chart1_population_histogram.png", dpi=120)
plt.close()


# 2. World population share by continent
df = run("SELECT continent, world_percentage FROM population")
plt.figure(figsize=(11, 6))
sns.boxplot(data=df, x="continent", y="world_percentage")
plt.title("World Population % by Continent")
plt.xlabel("")
plt.ylabel("Share of world population (%)")
plt.xticks(rotation=20)
plt.tight_layout()
plt.savefig("charts/chart2_worldpct_by_continent.png", dpi=120)
plt.close()


# 3. Ten least populous countries
df = run("SELECT country, pop_2023 FROM population ORDER BY pop_2023 ASC LIMIT 10")
plt.figure(figsize=(10, 6))
sns.barplot(data=df, x="pop_2023", y="country", hue="country", palette="flare", legend=False)
plt.title("10 Least Populous Countries (2023)")
plt.xlabel("Population")
plt.ylabel("")
plt.tight_layout()
plt.savefig("charts/chart3_least_populous.png", dpi=120)
plt.close()


# 4. Average density vs average growth rate, one point per continent
df = run("""SELECT continent,
                   AVG(density_per_km2) AS avg_density,
                   AVG(growth_rate)     AS avg_growth
            FROM population GROUP BY continent""")
plt.figure(figsize=(9, 6))
sns.scatterplot(data=df, x="avg_density", y="avg_growth", hue="continent", s=150)
plt.title("Avg Population Density vs Avg Growth Rate (by Continent)")
plt.xlabel("Average density (people per km²)")
plt.ylabel("Average growth rate (%)")
plt.tight_layout()
plt.savefig("charts/chart4_density_vs_growth.png", dpi=120)
plt.close()


# 5. Same as above, but marker size shows total population (a third dimension)
df = run("""SELECT continent,
                   AVG(density_per_km2) AS avg_density,
                   AVG(growth_rate)     AS avg_growth,
                   SUM(pop_2023)        AS total_pop
            FROM population GROUP BY continent""")
plt.figure(figsize=(9, 6))
sns.scatterplot(data=df, x="avg_density", y="avg_growth",
                size="total_pop", hue="continent", sizes=(80, 1500))
plt.title("Density, Growth & Scale by Continent (size = total population)")
plt.xlabel("Average density (people per km²)")
plt.ylabel("Average growth rate (%)")
plt.tight_layout()
plt.savefig("charts/chart5_density_growth_scale.png", dpi=120)
plt.close()


# 6. Spread of country populations within each continent (log scale)
df = run("SELECT continent, pop_2023 FROM population WHERE pop_2023 > 0")
plt.figure(figsize=(11, 6))
sns.boxplot(data=df, x="continent", y="pop_2023")
plt.yscale("log")
plt.title("Spread of Country Populations within Each Continent")
plt.xlabel("")
plt.ylabel("Population (log scale)")
plt.xticks(rotation=20)
plt.tight_layout()
plt.savefig("charts/chart6_population_spread.png", dpi=120)
plt.close()

print("Saved 6 charts to the charts/ folder.")
