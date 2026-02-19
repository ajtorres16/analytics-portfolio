import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# Simulating pricing vs. volume data
data = {
    'Price_Point': [4.99, 5.49, 5.99, 6.49, 6.99, 7.49],
    'Weekly_Volume': [1200, 1150, 1080, 850, 600, 450]
}

df = pd.DataFrame(data)

plt.figure(figsize=(10, 5))
sns.regplot(x='Price_Point', y='Weekly_Volume', data=df, color='red')

plt.title('Price Elasticity: Combo Meal Volume vs. Price Point', fontsize=14)
plt.xlabel('Menu Price ($)')
plt.ylabel('Units Sold per Week')
plt.grid(True, linestyle='--', alpha=0.6)

plt.show()
