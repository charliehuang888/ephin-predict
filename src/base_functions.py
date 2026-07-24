import pathlib

def get_project_root_folder():
    return pathlib.Path('..').resolve()