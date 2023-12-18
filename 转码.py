# -*- coding: utf-8 -*-
"""
Created on Fri Dec  1 22:20:17 2023

@author: Administrator
"""

import pandas as pd

def convert_csv_to_utf8(input_file, output_file):
    df = pd.read_csv(input_file,encoding='gbk') #设置解码格式 # encoding='gbk'
    df.to_csv(output_file, index=False, encoding='utf-8') #设置转码格式 #ASCII

def convert_csv_to_utf8(input_file, output_file):
    with open(input_file, 'r', encoding='utf-8') as file:
        lines = file.readlines()

    decoded_lines = []
    for line in lines:
        try:
            decoded_line = line.encode('utf-8').decode('utf-8', 'ignore')  # 忽略无法转码的字符
            decoded_lines.append(decoded_line)
        except UnicodeDecodeError:
            continue

    with open(output_file, 'w', encoding='utf-8') as file:
        file.writelines(decoded_lines)


input_file = r''  # 输入CSV文件路径
output_file = r'D:\博士\course sem3\Data Mining\nationalism\结果文件\大英数据\大英 去重去噪 1212 纯文本 - ASC.csv'  # 输出CSV文件路径

convert_csv_to_utf8(input_file, output_file)