from argparse import ArgumentParser
from pathlib import Path
import h5py
import numpy
import shutil
import subprocess
import yaml
import vigra

def parse_args():
    p = ArgumentParser(
        description="",
    )

    p.add_argument(
        "config_file",
    )
    p.add_argument("--fiji-executable", required=True)
    p.add_argument("--skip-clean", default=False, action="store_true")

    args = p.parse_args()
    return args


def read_config(config_path: Path):
    return yaml.safe_load(config_path.open("r"))


def clean_tmp(config):
    shutil.rmtree("./tmp")


def run_macro(fiji_executable: Path, run_config: dict):
    subprocess.check_call(
        [
            fiji_executable,
            # "--ij2",
            # "--headless",
            "-macro",
            run_config["macro"]
        ]
    )
    return run_config["reference_outputs"], run_config["outputs"]


def diff_results(reference, computed):
    with h5py.File(reference["path"], "r") as ref:
        ref_ds = ref[reference["dataset"]]
        with h5py.File(computed["path"], "r") as com:
            com_ds = com[computed["dataset"]]

            numpy.testing.assert_array_equal(ref_ds, com_ds)


def main():
    args = parse_args()
    config = read_config(Path(args.config_file))
    if not args.skip_clean:
        clean_tmp(config)
    Path("./tmp").mkdir(exist_ok=True)
    for run in config["runs"]:
        reference, computed = run_macro(args.fiji_executable, run)
        for ref, com in zip(reference, computed):
            diff_results(ref, com)


if __name__ == "__main__":
    main()
