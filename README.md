# MultiLang-ExcelToDB

Translate and store elements in a MySQL database from Excel file in an organized way.

This service may fail on some of the runs, as the used library [googletrans](https://pypi.org/project/googletrans) is an unofficial package (not created by Google). Also in the disclaimer, it has the following "*...this API does not guarantee that the library would work properly at all times...*".

## Install
**I am assuming, that you have installed MySQL on your machine as well as the development environment (like MySQL Workbench).**
1. Install requirements: `pip3 install -r requirements.txt`
2. Run `database.sql` code into your database development environment (e.g. MySQL Workbench).
3. If your host is other than *localhost*, please replace the word *localhost* in line 27 of `service.py` with the name of your host.
```python
host='localhost',
```

## Usage
1. Change directory to **MultiLang-ExcelToDB**.
2. Create an Excel file and name the first column *en*.
3. Write english elements (words/sentences) in this column.
4. Run `service.py`
5. Enter the information (you will be asked for).

Now just wait...

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.
