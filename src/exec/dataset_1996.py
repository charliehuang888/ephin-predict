import file_io as fio
import dask.dataframe as dd
import pandas as pd

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

final_df = dd.concat(dataframes)
dd.to_csv(final_df, '../../datasets/ephin_1995_1996/phx_sci-*.csv')
