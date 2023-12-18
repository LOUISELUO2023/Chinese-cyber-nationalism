# -*- coding: utf-8 -*-
"""
Created on Sat Nov 25 21:11:15 2023

@author: Administrator
"""

import csv

#def convert_csv_to_txt(input_csv, output_txt):
    #with open(input_csv, 'r', newline='') as csv_file:
        #csv_reader = csv.reader(csv_file)

        #with open(output_txt, 'w') as txt_file:
            #for row in csv_reader:
                # 将CSV行连接成字符串，使用逗号分隔
               # line = ','.join(row)
               # txt_file.write(line)
               # txt_file.write('\n')  # 写入换行符

   # print(f"CSV文件已成功转换为TXT文件: {output_txt}")

def convert_csv_to_utf8_txt(input_csv, output_txt, input_encoding):
    with open(input_csv, mode='r', newline='', encoding=input_encoding) as csv_file:
        csv_reader = csv.reader(csv_file)

        with open(output_txt, mode='w', encoding='utf-8') as txt_file:
            for row in csv_reader:
                line = ','.join(row)
                txt_file.write(line + '\n')

    print(f"CSV文件已成功转换为UTF-8编码的TXT文件: {output_txt}")



# 示例用法
input_csv = r'D:\博士\course sem3\Data Mining\nationalism\结果文件\大英数据\大英关键词1212 - csv.csv'  # 输入CSV文件路径
output_txt = r'D:\博士\course sem3\Data Mining\nationalism\结果文件\大英数据\大英关键词1212 净文本.txt'  # 输出TXT文件路径
#convert_csv_to_txt(input_csv, output_txt)
convert_csv_to_utf8_txt(input_csv, output_txt, 'gbk')  # 假设原始CSV文件使用GBK编码, 'gbk'