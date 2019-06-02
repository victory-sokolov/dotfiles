#!/bin/bash

#Python Packages Instalation

py_packages=(
  "numpy"
  "python3-tk"
  "pyqt5"
  "PyQtWebEngine"
  "Pillow"
  "django"
  "selenium"
  "requests"
  "mysql-python"
  "mysqlclient"
  "python3-bs4"
  "lxml"
  "zerorpc"
  "pyinstaller"
  "--upgrade google-api-python-client"
  "scipy"
  "jupyter"
  "matplotlib"
  "xlrd"
  "pandas"
  "openpyxl"
  "pyyaml"
  "parsel"
  "scrapy"
  "sklearn"
  "quandl"
  "gspread"
  "twocaptchaapi"
  "pipreqs"
)

#Update pip
#pip install --upgrade pip

for element in ${py_packages[@]}
do
    sudo pip install $element
done

