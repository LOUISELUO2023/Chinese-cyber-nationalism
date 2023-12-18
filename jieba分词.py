# -*- coding: utf-8 -*-
"""
Created on Sat Dec  2 21:27:28 2023

@author: Administrator
"""

import pandas as pd
import jieba

def segment_csv_file(input_file, output_file, column_name):
    # 读取 CSV 文件
    df = pd.read_csv(input_file)
    
    # 对指定列进行分词，并将分词结果保存到新的列中
    df['分词结果'] = df[column_name].apply(lambda x: ' '.join(jieba.cut(x)))
    
    # 将结果保存到输出 CSV 文件
    df.to_csv(output_file, index=False)

input_file = r'D:\博士\course sem3\Data Mining\nationalism\结果文件\大英数据\大英去重 1201（2）utf-8.csv'  # 输入 CSV 文件路径
output_file = r'D:\博士\course sem3\Data Mining\nationalism\结果文件\大英数据\大英去重 1201（2）utf-8 - 分词.csv'  # 输出 CSV 文件路径
column_name = '微博正文'  # 指定要分词的列名

segment_csv_file(input_file, output_file, column_name)