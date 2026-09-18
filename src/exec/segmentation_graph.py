import sys
import os
import matplotlib.pyplot as plt
import datashader as ds
from datashader.mpl_ext import dsshow
import mpl_scatter_density # adds projection='scatter_density'
from astropy.visualization import LogStretch
from astropy.visualization.mpl_normalize import ImageNormalize
import numpy as np
import pandas as pd
import dask.dataframe as dd
import hvplot.dask

import datetime as dt

from matplotlib.colors import LinearSegmentedColormap

from src.constants import PHA_COLUMNS, SCI_COLUMNS
from src import file_io as fio
from src import calc

norm = ImageNormalize(vmin=0., vmax=1000, stretch=LogStretch())

# hacky color map
custom_cmap = LinearSegmentedColormap.from_list('custom_cmap', [
    (0, 'white'),
    (1e-20, 'indigo'),
    (0.2, 'navy'),
    (0.4, 'springgreen'),
    (0.6, 'yellow'),
    (0.8, 'orange'),
    (1, 'red'),
], N=256)

print('starting load 2002')
# let's look at an active year, and see if the plots vary when we select same, close, vs far segments
data_2002 = fio.get_data_files("phx", "1998")
accum = dd.read_csv(data_2002, sep= " ")
print(accum.shape)
accum.columns = PHA_COLUMNS
accum = accum.drop(labels="terminator", axis=1)
print('finished loading 1998')

same_segment_filter = accum["a_seg"] == accum["b_seg"]

same_seg = accum[same_segment_filter]
print(f'filtered {dt.datetime.now()}')
same_seg["de/dx"] = same_seg.apply(calc.calc_de_dx, axis=1)
print(f'calced a loss {dt.datetime.now()}')
same_seg['energy loss across ABCD'] = same_seg.apply(calc.calc_total_energy, axis=1, to_e=False)
print(f'calced total loss {dt.datetime.now()}')

#convert to pandas for now for graphing stuff
same_seg = same_seg.compute()

fig = plt.figure()
ax = fig.add_subplot(1, 1, 1, projection='scatter_density')
ax.set_xlabel("energy loss across ABCD after factors")
ax.set_xscale("log")
ax.set_ylabel("pha_a after factors")
ax.set_yscale("log")

dsartist = dsshow(
        same_seg,
        ds.Point('energy loss across ABCD', "de/dx"),
        ds.count(),
        norm="linear",
        aspect="auto",
        ax=ax,
    )

fig.colorbar(dsartist)
fig.suptitle(f"Energy Loss across ABCD detectors through same A B segments, 2002")
plt.savefig(f"../../outputs//graphs/same_seg_energy_loss_1998.png")
print('finished same seg')

sys.exit()

'''
# drawing time
fig = plt.figure()
ax = fig.add_subplot(1, 1, 1, projection='scatter_density')
ax.set_xlabel("energy loss over ABCD")
ax.set_xscale("log")
ax.set_ylabel("energy loss over A")
ax.set_yscale("log")

density = ax.scatter_density(same_seg['energy loss across ABCD'], same_seg['de/dx'], norm=norm, cmap=custom_cmap)
fig.colorbar(density, label='points per pixel')
fig.suptitle(f"Energy Loss across ABCD detectors through same segment, {year_str}")
plt.savefig(f"energyloss_2002_same_seg.png")
plt.close(fig)
'''

close_seg = accum.query("(a_seg == 0 ^ b_seg == 0) | abs(a_seg - b_seg) == 1 | abs(a_seg - b_seg) == 4")
close_seg["de/dx"] = close_seg.apply(calc.calc_de_dx, axis=1)
close_seg['energy loss across ABCD'] = close_seg.apply(calc.calc_total_energy, axis=1, to_e=False)
close_seg["de/dx"] = close_seg.apply(calc.calc_de_dx, axis=1)
close_seg['energy loss across ABCD'] = close_seg.apply(calc.calc_total_energy, axis=1, to_e=False)
graph = close_seg.hvplot.scatter(x='energy loss across ABCD', y='de/dx', title="energy loss over close segment, 2002", logz=True, rasterize=True)
hvplot.save(graph, f"energyloss_2002_close_seg.png")

print('finished close seg')

'''
# drawing time
fig = plt.figure()
ax = fig.add_subplot(1, 1, 1, projection='scatter_density')
ax.set_xlabel("energy loss over ABCD")
ax.set_xscale("log")
ax.set_ylabel("energy loss over A")
ax.set_yscale("log")

density = ax.scatter_density(close_seg['energy loss across ABCD'], close_seg['de/dx'], norm=norm, cmap=custom_cmap)
fig.colorbar(density, label='points per pixel')
fig.suptitle(f"Energy Loss across ABCD detectors through same segment, {year_str}")
plt.savefig(f"energyloss_2002_close_seg.png")
plt.close(fig)
'''

far_seg = accum.query("a_seg != 0 & b_seg != 0 & (abs(a_seg - b_seg) == 2 | abs(a_seg - b_seg) == 3)")
far_seg["de/dx"] = far_seg.apply(calc.calc_de_dx, axis=1)
far_seg['energy loss across ABCD'] = far_seg.apply(calc.calc_total_energy, axis=1, to_e=False)
graph = far_seg.hvplot.scatter(x='energy loss across ABCD', y='de/dx', title="energy loss over far segment, 2002", logz=True, rasterize=True)
hvplot.save(graph, f"energyloss_2002_far_seg.png")
print('finished far seg')
'''
# drawing time
fig = plt.figure()
ax = fig.add_subplot(1, 1, 1, projection='scatter_density')
ax.set_xlabel("energy loss over ABCD")
ax.set_xscale("log")
ax.set_ylabel("energy loss over A")
ax.set_yscale("log")

density = ax.scatter_density(far_seg['energy loss across ABCD'], far_seg['de/dx'], norm=norm, cmap=custom_cmap)
fig.colorbar(density, label='points per pixel')
fig.suptitle(f"Energy Loss across ABCD detectors through same segment, {year_str}")
plt.savefig(f"energyloss_2002_far_seg.png")
plt.close(fig)
'''
