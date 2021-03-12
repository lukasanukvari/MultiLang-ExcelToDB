from mysql.connector import connect, Error
from googletrans import Translator
import pandas as pd

def lstExcel(filepath, colname):
    """
    lstExcel function analyses the excel file and creates a list of the elements, that should be translated.
    Parameter:
        filepath:str: Path of the excel file.
        colname:str: Name of the column to be translated.
    Returns list.
    """
    df = pd.read_excel(filepath)
    elems = [elem for elem in df[colname]]
    return elems

def service(elements):
    """
    service function translates elements (words/sentences) from english to all available (in database) languages;
    It stores them in the database "lang_support_db" tables in a really organized way.
    Parameter:
        elements:list:string: List of elements to be translated.
    """
    try:
        # Connect to MySQL database
        with connect(
            host='localhost',
            user=input('Enter database username: '),
            password=input('Enter database password: '),
            database='lang_support_db'
        ) as conn:
            print('Success!')

            cur = conn.cursor()
            elem_ids = []
            translations = []

            # Insert elements in the table with stored procedure
            # Get their ids in "elem_ids" list
            for elem in elements:
                args = [elem, 0]
                tmp_res = cur.callproc('ins_into_elements', args)
                elem_ids.append(tmp_res[1])
            # Ids in "elem_ids" will be ordered the same way as the actual elements in the "elements" list
            # So it will be safe to use for inserting with other field lists later

            # Get all available languages with their ids and abbreviations
            cur.execute('select * from lang_support_db.languages_lst order by language_id asc')
            langs = cur.fetchall() # List of tuples like: (1, "English", "en")

            # Start translating from english to all the available (in database) languages
            translator = Translator()
            for lang in langs:
                for i in range(len(elements)):
                    translated = translator.translate(elements[i], src='en', dest=lang[2]).text
                    translations.append((elem_ids[i], lang[0], translated))
                    # "translations" - List of tuples, later used in database stored procedure arguments

            for trans in translations:
                cur.callproc('ins_into_translations', trans)
            
            print('\nSuccessful database "lang_support_db" action.')
            print('Please, standby...\n')

        # Create and transform the dataframe for visuzlizing translations in terminal
        df = pd.DataFrame()
        df.insert(0, 'en', elements)
        trans = {}

        for lang in langs:
            for el in df['en']:
                # Add translation to the dictionary
                trans[el] = translator.translate(el, src='en', dest=lang[2]).text

            df.insert(0, lang[2], trans)
        
        print(df.head())
        print('\nSuccess!')
    except Error as e:
        print(e)

if __name__ == '__main__':
    exc_path = input('Enter the excel file path (If in the same directory, just name would be enough): ')
    eng_lst = lstExcel(exc_path, 'en')
    service(eng_lst)