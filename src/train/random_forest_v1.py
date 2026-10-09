import numpy as np
import pandas as pd
import dask.dataframe as dd
from dask_ml.model_selection import train_test_split
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_absolute_error, mean_squared_error, mean_absolute_percentage_error, r2_score
from skops.io import dump, load

from src import file_io as fio
from src import calc

joined_df = dd.read_parquet('../../datasets/ephin_1995_1996_v1/')
print(joined_df.columns)
# 1a. filter the inputs to only A0 B0 coincidences
center_solar_data = joined_df.query('angle_class == 0').compute()

# 2. Separate into multivariable inputs (X) and multivariable outputs (y)
X = center_solar_data [[
    'log1p_delta_A',
    'log1p_delta_B',
    'log1p_delta_C',
    'status_opp_err_frame',
    'status_fma',
    'status_fmb',
]]

y = center_solar_data[['log1p_delta_D', 'log1p_delta_E']] # Two columns to predict

# 3. Split dataset
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42, shuffle=True)

# 4. Train the multi-output model
multi_rf = RandomForestRegressor(n_estimators=100, random_state=42)
multi_rf.fit(X_train, y_train)

# 5. Predict both target variables at once
multi_predictions = multi_rf.predict(X_test)
# print("Predicted D + E pairs:\n", multi_predictions)

mae = mean_absolute_error(y_test, multi_predictions)
mse = mean_squared_error(y_test, multi_predictions)
# mape not good since we have values near 0
# mape = mean_absolute_percentage_error(y_test, multi_predictions)
r2= r2_score(y_test, multi_predictions)

print('Error on both predictions on log D + E')
print(f'mean absolute error {mae}')
print(f'mean squared error {mse}')
# print(f'mean absolute percent error {mape}')
print(f'r^2 coefficient of determination {r2}')

y_test_d = y_test['log1p_delta_D']
m_pred_d = multi_predictions[:, 0]
mae_d = mean_absolute_error(y_test_d, m_pred_d)
mse_d = mean_squared_error(y_test_d, m_pred_d)
# mape_d = mean_absolute_percentage_error(y_test_d, m_pred_d)
r2_d = r2_score(y_test_d, m_pred_d)

print('Error on both predictions on log D only')
print(f'mean absolute error {mae_d}')
print(f'mean squared error {mse_d}')
# print(f'mean absolute percent error {mape_d}')
print(f'r^2 coefficient of determination {r2_d}')

dump(multi_rf, '../../outputs/models/1996_RFE_center_v1.skops')

# for fun let's test on other segments without training
not_center_solar_data = joined_df.query('angle_class != 0').compute()
X_not_center = not_center_solar_data [[
    'log1p_delta_A',
    'log1p_delta_B',
    'log1p_delta_C',
    'status_opp_err_frame',
    'status_fma',
    'status_fmb',
]]
y_not_center = not_center_solar_data[['log1p_delta_D', 'log1p_delta_E']] # Two columns to predict

pred_not_center = multi_rf.predict(X_not_center)

mae_not_center = mean_absolute_error(y_not_center, pred_not_center)
mse_not_center = mean_squared_error(y_not_center, pred_not_center)
r2_not_center = r2_score(y_not_center, pred_not_center)

print('Error on non center predictions')
print(f'mean absolute error {mae_not_center}')
print(f'mean squared error {mse_not_center}')
print(f'r^2 coefficient of determination {r2_not_center}')

# save the testing set + predictions for some visualizations
'''
testing_X = pd.concat([X_test, X_not_center], axis=0, ignore_index=True)
testing_y = pd.concat([y_test, y_not_center], axis=0, ignore_index=True)
testing_set = pd.concat([testing_X, testing_y], axis=1, ignore_index=True)
testing_set.columns = [
    'log1p_delta_A',
    'log1p_delta_B',
    'log1p_delta_C',
    'status_opp_err_frame',
    'status_fma',
    'status_fmb',
    'log1p_delta_D',
    'log1p_delta_E'
]

pred_d = np.concat([multi_predictions[:, 0], pred_not_center[:,0]])
pred_e = np.concat([multi_predictions[:, 1], pred_not_center[:,1]])
'''
testing_X = X_test
testing_y = y_test
testing_set = pd.concat([testing_X, testing_y], axis=1, ignore_index=True)
testing_set.columns = [
    'log1p_delta_A',
    'log1p_delta_B',
    'log1p_delta_C',
    'status_opp_err_frame',
    'status_fma',
    'status_fmb',
    'log1p_delta_D',
    'log1p_delta_E'
]

pred_d = multi_predictions[:, 0]
pred_e = multi_predictions[:, 1]

testing_set['pred_log1p_delta_D'] = pd.Series(pred_d, testing_set.index)
testing_set['pred_log1p_delta_E'] = pd.Series(pred_e, testing_set.index)
#testing_set.to_parquet('../../datasets/test_predictions_1996_v1/test_predictions_1996_v1.parquet')
testing_set.to_parquet('../../datasets/test_predictions_1996_v1/test_predictions_1996_v1_center.parquet')

# these errors are calculated in terms of log (1 +x)
# let's try converting back to MeV

# invert function
y_mev = np.expm1(y_test)
pred_mev = np.expm1(multi_predictions)
mae = mean_absolute_error(y_mev, pred_mev)
mse = mean_squared_error(y_mev, pred_mev)
# mape not good since we have values near 0
# mape = mean_absolute_percentage_error(y_test, multi_predictions)
r2 = r2_score(y_mev, pred_mev)
print('Error on both predictions in MeV')
print(f'mean absolute error {mae}')
print(f'mean squared error {mse}')
# should stay pretty close to log version (non linear transform)
print(f'r^2 coefficient of determination {r2}')
