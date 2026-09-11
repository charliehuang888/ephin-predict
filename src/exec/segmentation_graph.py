import sys
import os
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import dask.dataframe as dd
import hvplot.dask

import itertools
from scipy.constants import year
from scipy.stats import gaussian_kde
import mpl_scatter_density # adds projection='scatter_density'
from matplotlib.colors import LinearSegmentedColormap
# Make the norm object to define the image stretch
from astropy.visualization import LogStretch
from astropy.visualization.mpl_normalize import ImageNormalize
norm = ImageNormalize(vmin=0., vmax=1000, stretch=LogStretch())




from src.constants import PHA_COLUMNS, SCI_COLUMNS
from src import file_io as fio

# chandra low high table
raw_chandra = [
    ["pha_a", 3.00, 30.00],
    ["pha_b", 3.00, 45.00],
    ["pha_c", 16.07, 166.70],
    ["pha_d", 20.00, 225.00],
    ["pha_e", 20.00, 225.00]
]
factor_chandra = pd.DataFrame(data=raw_chandra, columns=["detector", 0, 1])
factor_chandra.set_index("detector", inplace=True)
# magic number in chandra paper pha = tlm/1023 * factor
magic_chandra = 1023

def calc_de_dx(row):
    return row["pha_a"] / magic_chandra * factor_chandra.loc["pha_a", row["a_lh_flag"]]


def calc_layer_loss(row, sensor="a"):
    assert sensor in set(["a", "b", "c", "d", "e"])
    energy_col_name = f"pha_{sensor}"
    flag_col_name = f"{sensor}_lh_flag"
    return row[energy_col_name] / magic_chandra * factor_chandra.loc[energy_col_name, row[flag_col_name]]


def calc_total_energy(row, to_d=True, to_e=True):
    apply_factors = row["pha_a"] * factor_chandra.loc["pha_a", row["a_lh_flag"]] + \
                    row["pha_b"] * factor_chandra.loc["pha_b", row["b_lh_flag"]] + \
                    row["pha_c"] * factor_chandra.loc["pha_c", row["c_lh_flag"]]
    to_e = to_e and to_d
    if to_e or to_d:
        apply_factors += row["pha_d"] * factor_chandra.loc["pha_d", row["d_lh_flag"]]
    if to_e:
        apply_factors += row["pha_e"] * factor_chandra.loc["pha_e", row["e_lh_flag"]]

    return apply_factors / magic_chandra

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

# let's look at an active year, and see if the plots vary when we select same, close, vs far segments
data_2002 = fio.get_data_files("phx", "2002")
accum = dd.read_csv(data_2002, sep= " ")
print(accum.shape)
accum.columns = PHA_COLUMNS
accum = accum.drop(labels="terminator", axis=1)

same_segment_filter = accum["a_seg"] == accum["b_seg"]

same_seg = accum[same_segment_filter]
same_seg["de/dx"] = same_seg.apply(calc_de_dx, axis=1)
same_seg['energy loss across ABCD'] = same_seg.apply(calc_total_energy, axis=1, to_e=False)
graph = same_seg.hvplot.scatter(x='energy loss across ABCD', y='de/dx', title="energy loss over same segment, 2002",  logz=True, rasterize=True)
hvplot.save(graph, f"energyloss_2002_same_seg.png")
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
close_seg["de/dx"] = close_seg.apply(calc_de_dx, axis=1)
close_seg['energy loss across ABCD'] = close_seg.apply(calc_total_energy, axis=1, to_e=False)
close_seg["de/dx"] = close_seg.apply(calc_de_dx, axis=1)
close_seg['energy loss across ABCD'] = close_seg.apply(calc_total_energy, axis=1, to_e=False)
graph = close_seg.hvplot.scatter(x='energy loss across ABCD', y='de/dx', title="energy loss over close segment, 2002", logz=True, rasterize=True)
hvplot.save(graph, f"energyloss_2002_close_seg.png")

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
far_seg["de/dx"] = far_seg.apply(calc_de_dx, axis=1)
far_seg['energy loss across ABCD'] = far_seg.apply(calc_total_energy, axis=1, to_e=False)
graph = far_seg.hvplot.scatter(x='energy loss across ABCD', y='de/dx', title="energy loss over far segment, 2002", logz=True, rasterize=True)
hvplot.save(graph, f"energyloss_2002_far_seg.png")
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
