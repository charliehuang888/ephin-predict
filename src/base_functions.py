import pathlib
import src

def get_project_root_folder():
    return pathlib.Path(src.__file__).resolve().parent.parent