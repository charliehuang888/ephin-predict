import pandas as pd
import numpy as np
import dask.dataframe as dd
import dask_histogram as dh
import hvplot.dask
import holoviews as hv
from hvplot import dask

hv.extension('matplotlib')
hvplot.extension('matplotlib')
import datetime as dt

from src.constants import PHA_COLUMNS, SCI_COLUMNS
from src import file_io as fio
from src import calc

data_2002 = fio.get_data_files("phx", "1998")
accum = dd.read_csv(data_2002, sep= " ")
print(accum.shape)
accum.columns = PHA_COLUMNS
accum = accum.drop(labels="terminator", axis=1)
print('finished loading 1998')

same_segment_filter = accum["a_seg"] == accum["b_seg"]

# calc
same_seg = accum[same_segment_filter]
print(f'filtered {dt.datetime.now()}')
same_seg["de/dx"] = same_seg.apply(calc.calc_de_dx, axis=1)
print(f'calced a loss {dt.datetime.now()}')
same_seg['energy loss across ABCD'] = same_seg.apply(calc.calc_total_energy, axis=1, to_e=False)
print(f'calced total loss {dt.datetime.now()}')

# bin the data for heatmap
#log data first so bins are sensible
same_seg = same_seg[['energy loss across ABCD', 'de/dx']]
same_seg['log energy loss across ABCD'] = same_seg['energy loss across ABCD'].apply(np.log10)
same_seg['log de/dx'] = same_seg['de/dx'].apply(np.log10)
print('data logarithm\'d')

total_min, total_max = dd.compute(same_seg['log energy loss across ABCD'].min(), same_seg['log energy loss across ABCD'].max())
de_dx_min, de_dx_max = dd.compute(same_seg['log de/dx'].min(), same_seg['log de/dx'].max())
print('data range of log calc\'d')

num_bins = 100
x_bins = np.linspace(total_min, total_max, num=num_bins)
y_bins = np.linspace(de_dx_min, de_dx_max, num=num_bins)
same_seg['x_binned'] = same_seg['log energy loss across ABCD'].map_partitions(pd.cut, bins=x_bins)
same_seg['y_binned'] = same_seg['log de/dx'].map_partitions(pd.cut, bins=y_bins)
print('data binned')

graph_obj = same_seg.hvplot.heatmap(x='x_binned',
                                    y='y_binned',
                                    reduce_function=np.size,
                                    datashade=True,
                                    rasterize=True,
                                    cmap='viridis',
                                    xlabel='log10 energy loss across abcd',
                                    ylabel='log10 energy loss across a',
                                    title='Same AB segment energy loss, 1998')
print('data graphed')

'''
h = dh.histogram2d(
    same_seg['log energy loss across ABCD'],
    same_seg['log de/dex'],
    bins=num_bins,
    range=(total_min_max, de_dx_min_max),
    histogram=True
)
h.compute()
'''
                                    

'''
graph_obj = same_seg.hvplot.hexbin(
    x='energy loss across ABCD',
    y='de/dx',
    gridsize=100,
    rasterize=True,
    data_aspect=1,
    width=600,
    cmap='viridis',
    title='Same AB segment energy loss, 1998',
    xlabel='log10 energy loss across abcd',
    ylabel='log10 energy loss across a'
)
fig = hv.render(graph_obj)
print(type(fig))

# render = hv.renderer('matplotlib')
# render.save(graph_obj, "../../outputs/graphs/same_seg_energy_loss_v2_1998.png")
hv.save(graph_obj, "../../outputs/graphs/same_seg_energy_loss_v2_1998.png", backend='matplotlib')
print('data graphed')
'''

#convert to pandas for now for graphing stuff
#same_seg = same_seg.compute()
