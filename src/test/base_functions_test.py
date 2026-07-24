import os
import unittest
import src
from src import base_functions as bf


class MyTestCase(unittest.TestCase):
    def test_project_root_lookup(self):
        expected_path = os.path.dirname(os.path.dirname(os.path.abspath(src.__file__)))

        test_path = bf.get_project_root_folder().as_posix()
        self.assertEqual(expected_path, test_path)



if __name__ == '__main__':
    unittest.main()
