import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from facebook_scraper import get_posts

group_ids = [
    'GypsyHousingNYC',
    'NewYorkCityhousing',
    '2070694583203864',
    '2050201058584087',
    '1416151198490459',
    '626355231038903',
    '2028131347450371',
    '1225966920763001',
    '354409988359926',
    '2105363849675275',
    '442465739544235',
    '221104891777373',
    '1986175048370665',
    '211591802759097',
    '191002868295974',
    '2030208160592374',
    'NYCRooms'
]

if __name__ == "__main__":

    dfs = []

    for id_ in group_ids:
        print(id_)
        df_tmp = pd.DataFrame(get_posts(group=id_, pages=20))
        dfs.append(df_tmp)

    final_df = pd.concat(dfs)

    final_df.to_csv('facebook_postings.csv')