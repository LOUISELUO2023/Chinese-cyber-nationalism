# -*- coding: utf-8 -*-
"""
Created on Sat Nov 25 19:57:58 2023

@author: Administrator
"""

import csv
#以下代码表现不好，会把（不同时间点收集的）不同点赞数的同一用户同一内容微博算成不同微博
#def remove_duplicates(input_file, output_file):
    #unique_records = set()  # 用于存储唯一记录的集合

   # with open(input_file, 'r', newline='', encoding='gbk', errors='ignore') as file:
       # reader = csv.reader(file)
       # header = next(reader)  # 读取CSV文件的标题行
       # unique_records.add(tuple(header))  # 将标题行添加到唯一记录集合中

       # for row in reader:
           # record = tuple(row)
           # unique_records.add(record)  # 将每行记录添加到唯一记录集合中

   # with open(output_file, 'w', newline='') as file:
       # writer = csv.writer(file)
       # writer.writerow(header)  # 写入CSV文件的标题行

       # for record in unique_records:
       #     writer.writerow(record)  # 写入去重后的记录

   # print("去重完成，并将结果写入新的CSV文件。")


#依据指定列的内容判断是否为重复微博,但效果不好，改用pandas去重.py
def remove_duplicates(input_file, output_file, column_indices):
    unique_records = set()  # 用于存储唯一记录的集合

    with open(input_file, 'r', newline='', encoding='gbk', errors='ignore') as file:
        reader = csv.reader(file)
        header = next(reader)  # 读取CSV文件的标题行
        unique_records.add(tuple(header))  # 将标题行添加到唯一记录集合中

        for row in reader:
            record = tuple(row)
            key = tuple(row[i] for i in column_indices)  # 获取指定列的值作为键
            unique_records.add((key, record))  # 将记录及其键添加到唯一记录集合中

    with open(output_file, 'w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(header)  # 写入CSV文件的标题行

        for record in unique_records:
            writer.writerow(record[1])  # 写入去重后的记录，不包括键

    print("去重完成，并将结果写入新的CSV文件。")


# 示例用法
input_file = r'D:\博士\course sem3\Data Mining\nationalism\结果文件\大英.csv'  # 输入CSV文件路径
output_file = r'D:\博士\course sem3\Data Mining\nationalism\结果文件\大英去重 1201.csv'  # 输出CSV文件路径
remove_duplicates(input_file, output_file, [2,12])