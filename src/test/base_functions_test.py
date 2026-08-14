import os
import unittest
import file_io as fio


class MyTestCase(unittest.TestCase):
    def test_project_root_lookup(self):
        expected_path = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
        print(expected_path)
        test_path = fio.get_project_root_folder().as_posix()
        print(test_path)
        self.assertEqual(expected_path, test_path)



if __name__ == '__main__':
    unittest.main()
