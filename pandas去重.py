# -*- coding: utf-8 -*-
"""
Created on Fri Dec  1 12:21:05 2023

@author: Administrator
"""

import pandas as pd

def remove_duplicates(input_file, output_file, column_names):
    df = pd.read_csv(input_file, error_bad_lines=False)  # 读取输入文件为 DataFrame #, encoding='gbk'

    # 根据指定的列进行去重
    df.drop_duplicates(subset=column_names, keep='first', inplace=True)

    df.to_csv(output_file, index=False)  # 将去重后的 DataFrame 写入输出文件
    print("去重完成，并将结果写入新的CSV文件。")
    print(df)
    
    

input_file = r'D:\博士\course sem3\Data Mining\nationalism\结果文件\大英数据\大英 raw 1212 utf-8.csv'  # 输入CSV文件路径
output_file = r'D:\博士\course sem3\Data Mining\nationalism\结果文件\大英数据\大英 去重 1212.csv'  # 输出CSV文件路径
remove_duplicates(input_file, output_file, ['user_id','发布时间'])
    