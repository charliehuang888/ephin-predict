import pandas as pd
import pathlib
from src.constants import PHA_COLUMNS, SCI_COLUMNS

def get_project_root_folder():
    return pathlib.Path(__file__).resolve().parent.parent.parent

# returns dir path of file type
def get_data_dir(data_type=""):
    proj_root = pathlib.Path(get_project_root_folder())
    data_path = proj_root / "og-data" / "level1"
    if data_type:
        data_path = data_path / data_type

    return data_path

# returns all files from the file type matching data_type, year, and day
def get_data_files(data_type, year="", day=""):
    if not data_type:
        return []
    if year:
        year_as_int = int(year)
        assert 1995 <= year_as_int <= 2026
        assert len(year) == 4
    else:
        day = ''

    if day:
        day_as_int = int(day)
        assert 1 <= day_as_int <= 365
        assert len(day) <= 3
        if len(day) < 3:
            day = day.rjust(3, "0")

    if year:
        globyear = year[2:]
        globday = day if day else "*"
    else:
        globyear = ''
        globday = ''

    file_type_path = get_data_dir(data_type=data_type)
    if year:
        file_type_path = file_type_path / year
    pattern = f"*{globyear}{globday}.*[!g][!z]"
    return sorted(file_type_path.rglob(pattern))

def read_pha(file_path):
    pha_data = pd.read_csv(file_path, sep= " ")
    pha_data = pha_data.iloc[:,:18] # every row ends with an extra 69
    pha_data.columns = PHA_COLUMNS
    return pha_data

def read_sci(file_path):
    sci_data = pd.read_csv(file_path, sep=" ")
    sci_data.columns = SCI_COLUMNS
    return sci_data
