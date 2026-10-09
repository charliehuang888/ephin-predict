import numpy as np
import pandas as pd
import dask.dataframe as dd
from dask_ml.model_selection import train_test_split
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_absolute_error, mean_squared_error, mean_absolute_percentage_error, r2_score
from skops.io import dump, load

from src import file_io as fio
from src import calc

# match the most closest (backwards) sci row to phx row to apply ephin state to phx data for ml analysis
dataframes = []
for year in range(1995, 1997):
    for day in range(1, 367):
        sci_files = fio.get_data_files('sci', str(year), str(day))
        phx_files = fio.get_data_files('phx', str(year), str(day))

        # error logging for missing files
        missing_files = []
        if not sci_files:
            missing_files.append('sci')
        if not phx_files:
            missing_files.append('phx')
        if missing_files:
            print(f'mismatch/missing {','.join(missing_files)} file for day {day} of {year}')
            continue

        # hacky but there should only be at most one file per day
        sci_fp = sci_files[0]
        phx_fp = phx_files[0]

        # actually load the files
        try:
            sci_df = fio.read_sci(sci_fp)
            phx_df = fio.read_pha(phx_fp)

        except pd.errors.EmptyDataError, ValueError:
            continue

        else:
            combined = dd.merge_asof(
                phx_df,
                sci_df,
                on='ms_of_day',
                by=['year', 'day_of_year'],
                allow_exact_matches=True
            )
            dataframes.append(combined)

joined_df = dd.concat(dataframes)

# calculate derived stats
joined_df['delta_A'] = joined_df.apply(calc.calc_layer_loss, axis=1, sensor='a')
joined_df['delta_B'] = joined_df.apply(calc.calc_layer_loss, axis=1, sensor='b')
joined_df['delta_C'] = joined_df.apply(calc.calc_layer_loss, axis=1, sensor='c')
joined_df['delta_D'] = joined_df.apply(calc.calc_layer_loss, axis=1, sensor='d')
joined_df['delta_E'] = joined_df.apply(calc.calc_layer_loss, axis=1, sensor='e')

# drop any rows with bad data on these columns
delta_labels = ['delta_A', 'delta_B', 'delta_C', 'delta_D', 'delta_E']
joined_df = joined_df.dropna(how='any', subset=delta_labels)

# logarithms of above for some regression methods
joined_df['log1p_delta_A']  = np.log1p(joined_df['delta_A'])
joined_df['log1p_delta_B']  = np.log1p(joined_df['delta_B'])
joined_df['log1p_delta_C']  = np.log1p(joined_df['delta_C'])
joined_df['log1p_delta_D']  = np.log1p(joined_df['delta_D'])
joined_df['log1p_delta_E']  = np.log1p(joined_df['delta_E'])

# bucket angle of particle path relative to detector
joined_df['angle_class'] = joined_df.apply(calc.incidence_angle_class, axis=1)

# defrag
joined_df = joined_df.repartition(partition_size='200MB')

dd.to_parquet(joined_df, '../../datasets/ephin_1995_1996_v1/', overwrite=True)