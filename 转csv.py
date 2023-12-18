# -*- coding: utf-8 -*-
"""
Created on Sun Dec 17 13:36:02 2023

@author: Administrator
"""

import pandas as pd

def convert_txt_to_csv(input_file, output_file):
    with open(input_file, 'r', encoding='utf-8') as file:
        lines = file.readlines()

    # 创建一个包含文本的数据框
    df = pd.DataFrame({'Text': lines})

    # 将数据框保存为CSV文件
    df.to_csv(output_file, index=False, encoding='utf-8')

input_file = 'input.txt'  # 输入文本文件路径
output_file = 'output.csv'  # 输出CSV文件路径

convert_txt_to_csv(input_file, output_file)