# -*- coding: utf-8 -*-
"""
Created on Thu Dec 14 01:03:28 2023

@author: Administrator
"""

import codecs

def convert_file_to_utf8(input_file, output_file):
    with codecs.open(input_file, 'r', encoding='utf-8') as file:
        content = file.read()

    with codecs.open(output_file, 'w', encoding='utf-8') as file:
        file.write(content)

    print("文件已成功转换为UTF-8编码。")
    
input_file = r'D:\博士\course sem3\Data Mining\nationalism\结果文件\日本数据\日本关键词1217 语义.txt'
output_file = r'D:\博士\course sem3\Data Mining\nationalism\结果文件\日本数据\日本关键词1217语义utf-8.txt'

convert_file_to_utf8(input_file, output_file)