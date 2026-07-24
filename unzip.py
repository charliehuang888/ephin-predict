import gzip
from pathlib import Path

def unzip_all(target_dir):
    print("unziping!")
    for zip_path in Path(target_dir).rglob("*.gz"):
        output_file = zip_path.with_suffix("")
        print(f"extracting {zip_path.name} to {output_file}")
        with gzip.open(zip_path, "rb") as f, open(output_file, "wb") as g:
            for line in f:
                g.write(line)


target_dir = '/home/chuang/Projects/ephin-predict/og-data/level1'
unzip_all(target_dir)