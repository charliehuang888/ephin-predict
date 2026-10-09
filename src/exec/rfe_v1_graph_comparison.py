import sys
import os
module_path = os.path.abspath(os.path.join('..'))
if module_path not in sys.path:
    sys.path.append(module_path)

from src import file_io as fio
import matplotlib.pyplot as plt
import numpy as np
import dask.dataframe as dd
import hvplot.dask
import pandas as pd
import itertools
from scipy.constants import year
from scipy.stats import gaussian_kde

import mpl_scatter_density # adds projection='scatter_density'
from matplotlib.colors import LinearSegmentedColormap
# Make the norm object to define the image stretch
from astropy.visualization import LogStretch
from astropy.visualization.mpl_normalize import ImageNormalize
norm = ImageNormalize(vmin=0., vmax=1000, stretch=LogStretch())

custom_cmap = LinearSegmentedColormap.from_list('custom_cmap', [
    (0, 'white'),
    (1e-20, 'indigo'),
    (0.2, 'navy'),
    (0.4, 'springgreen'),
    (0.6, 'yellow'),
    (0.8, 'orange'),
    (1, 'red'),
], N=256)

# solar_data = pd.read_parquet('/home/chuang/Projects/ephin-predict/datasets/test_predictions_1996_v1/test_predictions_1996_v1.parquet')
solar_data = pd.read_parquet('/home/chuang/Projects/ephin-predict/datasets/test_predictions_1996_v1/test_predictions_1996_v1_center.parquet')


solar_data['A'] = np.expm1(solar_data['log1p_delta_A'])
solar_data['B'] = np.expm1(solar_data['log1p_delta_B'])
solar_data['C'] = np.expm1(solar_data['log1p_delta_C'])
solar_data['D'] = np.expm1(solar_data['log1p_delta_D'])
solar_data['E'] = np.expm1(solar_data['log1p_delta_E'])
solar_data['D_pred'] = np.expm1(solar_data['pred_log1p_delta_D'])
solar_data['E_pred'] = np.expm1(solar_data['pred_log1p_delta_E'])

print(solar_data.columns)

total_energy = solar_data[['A', 'B', 'C', 'D', 'E']].sum(axis=1)
total_energy_pred = solar_data[['A', 'B', 'C', 'D_pred', 'E_pred']].sum(axis=1)

print(solar_data.shape)
print(total_energy.shape)
print(total_energy_pred.shape)

fig = plt.figure(layout='constrained')
fig.set_figheight(6.4)
fig.set_figwidth(4.8)

ax1 = fig.add_subplot(2, 1, 1, projection='scatter_density')
ax1.set_xlabel("REAL total energy loss")
ax1.set_xscale("log")
ax1.set_ylabel("loss in A")
ax1.set_yscale("log")
ax1.set_xlim(10**-1,10**2.5)
ax1.set_ylim(10**-2,10**1.5)
ax1.set_title('REAL Total Energy Loss vs Loss in A')
# try a log normed density map
density1 = ax1.scatter_density(total_energy, solar_data['A'], norm=norm, cmap=custom_cmap)
fig.colorbar(density1, ax=ax1, label='points per pixel')

ax2 = fig.add_subplot(2, 1, 2, projection='scatter_density')
ax2.set_xlabel("PREDICTED total energy loss")
ax2.set_xscale("log")
ax2.set_ylabel("loss in A")
ax2.set_yscale("log")
ax2.set_xlim(10**-1,10**2.5)
ax2.set_ylim(10**-2,10**1.5)
ax2.set_title('Predicted Total Energy Loss vs Loss in A')
density2 = ax2.scatter_density(total_energy_pred, solar_data['A'], norm=norm, cmap=custom_cmap)
fig.colorbar(density2, ax=ax2, label='points per pixel')

fig.suptitle("Actual Compared to Predicted Total Energy Loss (Center Segment Only)")

# plt.savefig('/home/chuang/Projects/ephin-predict/outputs/graphs/random_forest_v1_sim_vs_realpng')
plt.savefig('/home/chuang/Projects/ephin-predict/outputs/graphs/random_forest_v1_sim_vs_real_center.png')
plt.close(fig)