#!/usr/bin/env python
import bs4
import markup
import argparse

HEADERS = ['Category', 'Total', 'Passed', 'Failed']

failed_cases, passed_cases = [], [] 

minified_css = '.container,table,td,th{border:1px solid #e0e0e0}body,th{color:#333}body{font-size:.9rem}.container{width:90%;padding:50px}table{border-collapse:collapse;width:80%}table,td,th{padding:10px;font-size:1em}th{background-color:#f5f5f5;text-align:left}.divider{border-top:1px solid #e0e0e0}.signature{color:#607d8b}.lead{font-size:1.68rem;color:#616161;font-weight:300}'


def generate_htmlpage(start_time, end_time, category, release, version, tabledata=[]):
    page = markup.page() 
    page.init(
        title='%s Report' % category, 
        doctype='<!DOCTYPE html>'
    )
    page.div(_class='container')
    page.table(style='width: 92% !important; border: 0px;') 
    page.tr() 
    page.td(width='30%', style='border: 0px!important; padding: 0px!important')
    page.h2('{} Test Report'.format(category.capitalize()), _class='lead')
    page.td.close() 
    page.td(width='70%', style='border: 0px!important; padding: 0px!important')
    page.table()
    page.tr()
    page.th('Status')
    page.th('Start Time')
    page.th('End Time')
    page.tr.close()
    page.tr()
    if len(failed_cases) > 0:
        page.td('Failed', style='background-color: #FFCCCC')
    else: 
        page.td('Passed', style='background-color: #E8F5E9')
    page.td(start_time)
    page.td(end_time) 
    page.tr.close() 
    page.table.close()
    page.td.close()
    page.tr.close()
    page.table.close()
    page.br()
    page.div(_class='divider')
    page.br() 
    
    page.table()
    page.caption('Test Results', _class='lead')
    
    page.tr()
    for header in HEADERS:
        page.th(header) 
    page.tr.close()
    
    page.tr()
    for data in tabledata:
        page.td(data)
    page.tr.close()
   
    page.table.close()
    for i in range(3): page.br()   
    if len(failed_cases) > 0: 
        page.table()
        page.caption('Failed Cases', _class='lead')
        page.tr()
        page.th('CaseId') 
        page.th('TestRun', width='10%') 
        page.th('Description') 
        page.tr.close() 
        for cases in failed_cases:
            page.tr() 
            page.td(cases.get('name'))
            page.td(cases.get('testrun'))
            page.td(cases.get('desc'))
            page.tr.close() 
        page.table.close()
    for i in range(3): page.br()   
    page.a(
        'Click to see online reports',
        href='http://10.10.30.37/reports/graphs/<%=@project.downcase%>/%s/%s/B%s' % (
            category.lower(), 
            release, 
            version
        ),
        style='text-decoration: none; color: #263238;'
    )
    for i in range(2): page.br()
    
    page.div('Automation Team <br/>Cavisson Systems Inc.', _class='signature') 
    page.div.close()  
    page.style(minified_css) 
    htmlpage = bs4.BeautifulSoup(str(page), "html.parser").prettify()
    return htmlpage


def parse_results_file(f):
    with open(f) as rfile: 
        for line in rfile:
            name, testrun, categoryid, componentid, status, desc = line.strip().split(',')
            hash_data = dict(
                name=name, 
                testrun=testrun, 
                categoryid=categoryid, 
                componentid=componentid, 
                status=status, 
                desc=desc
            )
            if status == 'fail': 
                failed_cases.append(hash_data)
            else:
                passed_cases.append(hash_data)

def gettabledata(category):
    failed_count = len(failed_cases)
    passed_count = len(passed_cases) 
    total = passed_count + failed_count
    return (category.upper(), total, passed_count, failed_count) 


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-c', '--category', help='the category', default='SMOKE') 
    parser.add_argument('-r', '--release', help='the release name', required=True)
    parser.add_argument('-v', '--version', help='the build version', required=True) 
    parser.add_argument('-f', '--infile', help='the result file', required=True)
    parser.add_argument('-o', '--outfile', help='the outfile to write to', default='/tmp/mail.body.htnl')
    parser.add_argument('-s', '--starttime', help='The startime', required=True)
    parser.add_argument('-e', '--endtime', help='The endtime', required=True)
    opts = parser.parse_args()
   
    parse_results_file(opts.infile)
    tabledata = gettabledata(opts.category) 
    start_time = opts.starttime 
    end_time = opts.endtime
    
    with open(opts.outfile, 'w') as outfile:
        outfile.write(
            generate_htmlpage(
                start_time, 
                end_time, 
                opts.category, 
                opts.release, 
                opts.version, 
                tabledata
            )
        )
