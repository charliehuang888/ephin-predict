import unittest
from src import file_io as fio
from src.constants import PHA_COLUMNS


class MyTestCase(unittest.TestCase):
    def test_path_search(self):
        exact_file = list(fio.get_data_files("phx", "2003", "1"))
        print(exact_file)
        self.assertEqual(len(exact_file), 1)
        many_files = list(fio.get_data_files("pha", "2010"))
        print(many_files)
        self.assertEqual(len(many_files), 365)
        all_of_type = fio.get_data_files("phx")
        for subpath in all_of_type:
            self.assertTrue(subpath.is_file())
            self.assertFalse(subpath.name.endswith(".gz"))

    def test_pha_read(self):
        path = fio.get_data_files("phx", "2003", "1")[0]
        df = fio.read_pha(path)
        self.assertEqual(len(PHA_COLUMNS), df.shape[1])

if __name__ == '__main__':
    unittest.main()
