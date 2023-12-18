# -*- coding: utf-8 -*-
"""
Created on Sat Dec  2 22:22:33 2023

@author: Administrator
"""

import pandas as pd

def random_sample_from_csv(input_file, output_file, sample_size):
    # 读取 CSV 文件
    df = pd.read_csv(input_file)
    
    # 从 DataFrame 中随机抽取指定数量的行
    sampled_df = df.sample(n=sample_size, random_state=42)  # 设置 random_state 以确保结果可重现
    
    # 将抽样结果保存到输出 CSV 文件
    sampled_df.to_csv(output_file, index=False)

input_file = r'D:\博士\course sem3\Data Mining\nationalism\结果文件\日本数据\日本去重 1203.csv'  # 输入 CSV 文件路径
output_file = r'D:\博士\course sem3\Data Mining\nationalism\结果文件\日本数据\日本去重 1203抽样.csv'  # 输出 CSV 文件路径
sample_size = 14586  # 抽样数量

random_sample_from_csv(input_file, output_file, sample_size)