# -*- coding: utf-8 -*-
"""
Created on Mon Dec 11 23:31:42 2023

@author: Administrator
"""

import pandas as pd

def remove_rows_with_keywords(csv_file, keywords, column):
    # 读取CSV文件
    df = pd.read_csv(csv_file)

    # 对于每个关键词，删除包含关键词的行
    for keyword in keywords:
        df = df[~df[column].str.contains(keyword, case=False, na=False)]

    # 将修改后的数据保存到新的CSV文件
    df.to_csv(output_file, index=False)

# 使用示例
csv_file = r'D:\博士\course sem3\Data Mining\nationalism\结果文件\日本数据\日本preprocess 1212.csv'  # 替换为你的CSV文件名
output_file = r'D:\博士\course sem3\Data Mining\nationalism\结果文件\日本数据\日本preprocess 1212 (2).csv'
keywords = ['添衣']  # 替换为你想要搜索和删除的关键词列表
column = 'Segmented_Content'  # 替换为包含文本的列名

remove_rows_with_keywords(csv_file, keywords, column)
