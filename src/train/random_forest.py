import numpy as np
import dask.dataframe as dd
from dask_ml.model_selection import train_test_split
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_absolute_error, mean_squared_error, mean_absolute_percentage_error, r2_score
from skops.io import dump, load
# 1. Create dummy dataset with multiple outputs
solar_data = dd.read_parquet('../../datasets/ephin_1995_1996/')

print(solar_data.columns)
# 2. Separate into multivariable inputs (X) and multivariable outputs (y)
X = solar_data[[
    'log_delta_A',
    'log_delta_ABC',
    'angle_class',
]]

y = solar_data[['log_delta_D', 'log_delta_E']] # Two columns to predict

# 3. Split dataset
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# 4. Train the multi-output model
multi_rf = RandomForestRegressor(n_estimators=100, random_state=42)
multi_rf.fit(X_train, y_train)

# 5. Predict both target variables at once
multi_predictions = multi_rf.predict(X_test)
# print("Predicted D + E pairs:\n", multi_predictions)

mae = mean_absolute_error(y_test, multi_predictions)
mse = mean_squared_error(y_test, multi_predictions)
mape = mean_absolute_percentage_error(y_test, multi_predictions)
r2= r2_score(y_test, multi_predictions)

print('Error on both predictions on log D + E')
print(f'mean absolute error {mae}')
print(f'mean squared error {mse}')
print(f'mean absolute percent error {mape}')
print(f'r^2 coefficient o fdetermination {r2}')

y_test_d = y_test['log1p_delta_D']
m_pred_d = multi_predictions[:, 0]
mae_d = mean_absolute_error(y_test_d, m_pred_d)
mse_d = mean_squared_error(y_test_d, m_pred_d)
mape_d = mean_absolute_percentage_error(y_test_d, m_pred_d)
r2_d = r2_score(y_test_d, m_pred_d)

print('Error on both predictions on log D only')
print(f'mean absolute error {mae_d}')
print(f'mean squared error {mse_d}')
print(f'mean absolute percent error {mape_d}')
print(f'r^2 coefficient o fdetermination {r2_d}')

dump(multi_rf, '../../outputs/models/1996_RFE.skops')
