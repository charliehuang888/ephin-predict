import file_io as fio
import dask.dataframe as dd
import numpy as np
import pandas as pd
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
joined_df['delta_A'] = joined_df.apply(calc.calc_de_dx, axis=1)
joined_df['delta_ABC'] = joined_df.apply(calc.calc_total_energy, axis=1, to_d=False, to_e=False)
joined_df['delta_D'] = joined_df.apply(calc.calc_layer_loss, axis=1, sensor='d')
joined_df['delta_E'] = joined_df.apply(calc.calc_layer_loss, axis=1, sensor='e')

# drop any rows with bad data on these columns
delta_labels = ['delta_A', 'delta_ABC', 'delta_D', 'delta_E']
joined_df = joined_df.dropna(how='any', subset=delta_labels)

# logarithms of above for some regression methods
joined_df['log1p_delta_A']  = np.log1p(joined_df['delta_A'])
joined_df['log1p_delta_ABC']  = np.log1p(joined_df['delta_ABC'])
joined_df['log1p_delta_D']  = np.log1p(joined_df['delta_D'])
joined_df['log1p_delta_E']  = np.log1p(joined_df['delta_E'])

# bucket angle of particle path relative to detector
joined_df['angle_class'] = joined_df.apply(calc.incidence_angle_class, axis=1)

dd.to_parquet(joined_df, '../../datasets/ephin_1995_1996/')
