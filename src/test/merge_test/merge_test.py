import pandas as pd
import constants
from constants import PHA_COLUMNS, SCI_COLUMNS

left = pd.read_csv('left.csv', sep=' ', header=None, names=PHA_COLUMNS)

right = pd.read_csv('right.csv', sep=' ', header=None, names=SCI_COLUMNS)

combined = pd.merge_asof(left, right, on='ms_of_day', by=['year', 'day_of_year'])
combined.to_csv('combined.csv')
