#Webscraper written by Naval Handa to scrape public enrollment data of California Public schools. 

from time import sleep
from bs4 import BeautifulSoup
import os.path

import requests
import pandas as pd
import re

def get_data(school, year, school_id, school_query, report_type, student_type='EL', view_state_generator='', view_state='', event_validation=''):
    year_query = gen_year_query(year)
    url = determine_aspx_query_url(report_type)
    headers = {
        'Host': 'dq.cde.ca.gov',
        'User-Agent': 'Mozilla/5.0 (Windows NT 6.3; WOW64; rv:54.0) Gecko/20100101 Firefox/54.0',
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        'Accept-Language': 'en-US,en;q=0.5',
        'Referer': url+'?cYear='+year_query+'&cType=ALL&cCDS='+school_id+'&cName='+school_query+'&cLevel=School&cChoice='+report_type+'&ReportCode='+report_type,
        'Connection': 'keep-alive',
    }
    params = (
        ('cYear', year_query),
        ('cType', 'ALL'),
        ('cCDS', school_id),
        ('cName', school_query.replace('+', ' ')),
        ('cLevel', 'School'),
        ('cChoice', report_type),
        ('ReportCode', report_type),
    )
    if view_state_generator != '':
        data = [
            ('__EVENTTARGET', ''),
            ('__EVENTARGUMENT', ''),
            ('__LASTFOCUS', ''),
            ('__VIEWSTATE', view_state),
            ('__VIEWSTATEGENERATOR', view_state_generator),
            ('__EVENTVALIDATION', event_validation),
            ('ctl00$drpReport', report_type),
            ('ctl00$drpYear', year_query),
            ('ctl00$drpLevel', school_id),
            ('ctl00$drpType', student_type),
            ('ctl00$ContentPlaceHolder1$btnDownload', 'Download Data'),
        ]
        response = requests.post(url, headers=headers, params=params, data=data)
    else:
        response = requests.post(url, headers=headers, params=params)
    return response.text

def write_file(string, filename):
    outfile = open(filename, 'w')
    outfile.write(string)
    outfile.close()

def determine_aspx_query_url(report_type):
    if report_type == 'sExpEthOff':
        url = 'http://dq.cde.ca.gov/dataquest/SuspExp/explbyscheth.aspx'
    elif report_type == 'sSusEthOff':
        url = 'http://dq.cde.ca.gov/dataquest/SuspExp/suspbyscheth.aspx'
    elif report_type == 'sDefByEth':
        url = 'http://dq.cde.ca.gov/dataquest/SuspExp/defbyscheth.aspx'
    return url

def gen_year_query(base_year):
    query_year = base_year + '-' + str(int(base_year[2:4]) + 1)
    return query_year

def gen_output_filename(school, school_id, year, report_type, student_Type):
    filename = school.replace(' ', '_').replace('/','()') + '--' + school_id + '--' + year + '--' + report_type + '--' + student_type + '.txt'
    return filename

def extract_asp_vars(html):
    soup = BeautifulSoup(html, 'html.parser')
    div_elements = soup.findAll('div', {'class': 'aspNetHidden'})
    view_state = div_elements[0].find('input', {'id': '__VIEWSTATE'})['value']
    view_state_generator = div_elements[1].find('input', {'id': '__VIEWSTATEGENERATOR'})['value']
    event_validation = div_elements[1].find('input', {'id': '__EVENTVALIDATION'})['value']
    return (view_state, view_state_generator, event_validation)

if __name__ == '__main__':
    io_path = '\\local'
    input_path = os.path.join(io_path, 'non_mcs_school_list.csv')
    df = pd.read_csv(input_path, dtype={'school_id': object, 'year': object})
    df_sub = df[df['data_availability'] == 'data_available'][['school', 'year', 'school_id', 'school_query']]
    schools = df_sub.iloc[:,0]
    years = df_sub.iloc[:,1]
    school_ids = df_sub.iloc[:,2]
    school_queries = df_sub.iloc[:,3]
    for i, school in enumerate(schools):
        for report_type in ['sDefByEth']:
            for student_type in ['EL']:
                year = str(years.iloc[i])
                school_id = str(school_ids.iloc[i])
                print(str(i) + '-' + year + '-' + report_type + '-' + student_type + '-' + school_id + ': ' + school)
                school_query = str(school_queries.iloc[i])
                pre_query = get_data(school, year, school_id, school_query, report_type)
                (view_state, view_state_generator, event_validation) = extract_asp_vars(pre_query)
                report = get_data(school, year, school_id, school_query, report_type, student_type, view_state_generator=view_state_generator, view_state=view_state, event_validation=event_validation)
                out_path = os.path.join(io_path, gen_output_filename(school, school_id, year, report_type, student_type))
                write_file(report, out_path)
                sleep(1)



