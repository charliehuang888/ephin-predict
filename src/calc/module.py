import pandas as pd

# chandra low high table
raw_chandra = [
    ["pha_a", 3.00, 30.00],
    ["pha_b", 3.00, 45.00],
    ["pha_c", 16.07, 166.70],
    ["pha_d", 20.00, 225.00],
    ["pha_e", 20.00, 225.00]
]
factor_chandra = pd.DataFrame(data=raw_chandra, columns=["detector", 0, 1])
factor_chandra.set_index("detector", inplace=True)
# magic number in chandra paper pha = tlm/1023 * factor
magic_chandra = 1023

def calc_de_dx(row):
    return row["pha_a"] / magic_chandra * factor_chandra.loc["pha_a", row["a_lh_flag"]]


def calc_layer_loss(row, sensor="a"):
    assert sensor in set(["a", "b", "c", "d", "e"])
    energy_col_name = f"pha_{sensor}"
    flag_col_name = f"{sensor}_lh_flag"
    return row[energy_col_name] / magic_chandra * factor_chandra.loc[energy_col_name, row[flag_col_name]]


def calc_total_energy(row, to_d=True, to_e=True):
    apply_factors = row["pha_a"] * factor_chandra.loc["pha_a", row["a_lh_flag"]] + \
                    row["pha_b"] * factor_chandra.loc["pha_b", row["b_lh_flag"]] + \
                    row["pha_c"] * factor_chandra.loc["pha_c", row["c_lh_flag"]]
    to_e = to_e and to_d
    if to_e or to_d:
        apply_factors += row["pha_d"] * factor_chandra.loc["pha_d", row["d_lh_flag"]]
    if to_e:
        apply_factors += row["pha_e"] * factor_chandra.loc["pha_e", row["e_lh_flag"]]

    return apply_factors / magic_chandra

def incidence_angle_class(row):
    a = row['a_seg']
    b = row['b_seg']
    diff = (a - b) % 5
    if a == b == 0:
        return 0
    elif a == b and a != 0:
        return 1
    elif a != b and (a == 0 or b == 0 or diff == 1 or diff ==4 ):
        return 2
    else:
        return 3
