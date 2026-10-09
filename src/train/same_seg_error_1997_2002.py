import numpy as np
import pandas as pd
from dask_ml.model_selection import train_test_split
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_absolute_error, mean_squared_error, mean_absolute_percentage_error, r2_score
from skops.io import dump, load, get_untrusted_types
unknown_types = get_untrusted_types(file='../../outputs/models/1996_RFE_center.skops')
model = load('../../outputs/models/1996_RFE_center.skops', trusted=["sklearn.tree._tree.Tree"])

phx_1997_2002 = pd.read_parquet('../../datasets/ephin_1997_2002/')
center_phx_1997_2002 =  phx_1997_2002.query('angle_class == 0').compute()
X = phx_1997_2002[[
    'log1p_delta_A',
    'log1p_delta_ABC',
    'status_opp_err_frame',
    'status_fma',
    'status_fmb',
]]
y = phx_1997_2002[['log1p_delta_D', 'log1p_delta_E']]

predictions = model.predict(X)

mae = mean_absolute_error(y, predictions)
mse = mean_squared_error(y, predictions)
# mape not good since we have values near 0
# mape = mean_absolute_percentage_error(y_test, multi_predictions)
r2= r2_score(y, predictions)

print('Error on both predictions on log D + E')
print(f'mean absolute error {mae}')
print(f'mean squared error {mse}')
# print(f'mean absolute percent error {mape}')
print(f'r^2 coefficient of determination {r2}')

y_test_d = y['log1p_delta_D']
m_pred_d =  predictions[:, 0]
mae_d = mean_absolute_error(y_test_d, m_pred_d)
mse_d = mean_squared_error(y_test_d, m_pred_d)
# mape_d = mean_absolute_percentage_error(y_test_d, m_pred_d)
r2_d = r2_score(y_test_d, m_pred_d)

print('Error on both predictions on log D only')
print(f'mean absolute error {mae_d}')
print(f'mean squared error {mse_d}')
# print(f'mean absolute percent error {mape_d}')
print(f'r^2 coefficient of determination {r2_d}')

# invert function
y_mev = np.expm1(y)
pred_mev = np.expm1(predictions)
mae = mean_absolute_error(y_mev, pred_mev)
mse = mean_squared_error(y_mev, pred_mev)
# mape not good since we have values near 0
# mape = mean_absolute_percentage_error(y_test, multi_predictions)
r2= r2_score(y_mev, pred_mev)
print('Error on both predictions in MeV')
print(f'mean absolute error {mae}')
print(f'mean squared error {mse}')
print(f'r^2 coefficient of determination {r2}')

# for fun let's test on other segments without training
not_center_phx_1997_2002 = phx_1997_2002.query('angle_class != 0').compute()
X_not_center = not_center_phx_1997_2002 [[
    'log1p_delta_A',
    'log1p_delta_ABC',
    'status_opp_err_frame',
    'status_fma',
    'status_fmb',
]]
'''
y_not_center = not_center_phx_1997_2002[['log1p_delta_D', 'log1p_delta_E']] # Two columns to predict

pred_not_center = model.predict(X_not_center)

mae_not_center = mean_absolute_error(y_not_center, pred_not_center)
mse_not_center = mean_squared_error(y_not_center, pred_not_center)
r2_not_center = r2_score(y_not_center, pred_not_center)

print('Error on non center predictions')
print(f'mean absolute error {mae_not_center}')
print(f'mean squared error {mse_not_center}')
print(f'r^2 coefficient of determination {r2_not_center}')
'''
