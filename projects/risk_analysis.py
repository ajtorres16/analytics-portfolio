import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# 1. Simulating the data from your SQL output
data = {
    'Region': ['North', 'South', 'East', 'West'] * 25,
    'Risk_Tier': (['Low Risk'] * 40) + (['Medium Risk'] * 40) + (['High Risk'] * 20),
    'Portfolio_Value': [150000, 220000, 180000, 95000] * 25
}

df = pd.DataFrame(data)

# 2. Pivot the data to create a matrix for the Heatmap
# We're calculating the sum of portfolio value at risk in each region/tier
heatmap_data = df.pivot_table(index='Region', columns='Risk_Tier', values='Portfolio_Value', aggfunc='sum')

# 3. Create the Visualization
plt.figure(figsize=(10, 6))
sns.heatmap(heatmap_data, annot=True, fmt=".0f", cmap="YlOrRd", cbar_kws={'label': 'Total Value ($)'})

plt.title('Portfolio Exposure: Total Value by Risk Tier & Region', fontsize=14)
plt.ylabel('Geographic Region')
plt.xlabel('Risk Segmentation')

# Display the plot
plt.tight_layout()
plt.show()
