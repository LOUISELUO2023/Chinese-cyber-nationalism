# -*- coding: utf-8 -*-
"""
Created on Sun Dec  3 15:01:48 2023

@author: Administrator
"""

import jieba
import jieba.analyse
import pandas as pd

jieba.load_userdict(r"D:\博士\course sem3\Data Mining\nationalism\结果文件\日本数据\日本词典.txt")
jieba.del_word('天后')
#jieba.del_word('##')

def extract_keywords_with_tf_idf(file_path, column_name, topK=200):
    df = pd.read_csv(file_path, encoding='utf-8')
    # 合并指定列的所有文本数据
    content = ' '.join(df[column_name].astype(str))

    # 提取关键词及其 TF 和 IDF 值
    keywords = jieba.analyse.extract_tags(content, topK=topK, withWeight=True)

    # 转换为 DataFrame
    df_keywords = pd.DataFrame(keywords, columns=['Keyword', 'TF-IDF'])
    return df_keywords

# 示例使用
file_path = r'D:\博士\course sem3\Data Mining\nationalism\结果文件\日本数据\日本去重去噪 1203抽样 1212.csv'  # 替换为 CSV 文件路径
column_name = '微博正文'  # 替换为 CSV 文件中的列名
topK = 150  # 提取前n个关键词
df_keywords = extract_keywords_with_tf_idf(file_path, column_name, topK)

# 输出到 Excel 文件
excel_path = r'D:\博士\course sem3\Data Mining\nationalism\结果文件\日本数据\日本关键词1217.xls'  # 输出的文件名
df_keywords.to_excel(excel_path, index=False)

print(f"关键词已成功输出到文件：{excel_path}")
