#!/usr/bin/python

# Import standard libraries
from os.path import expanduser, basename
from os.path import join as pathjoin
from os import getenv
from glob import glob

# Set project directory
project_dir = pathjoin(expanduser('~'), 'Projects')

# Set HTML output directory
html_output_dir = pathjoin(project_dir, 'output', 'html')

# Create list of bet slices pages
# NOTE:  questions marks are interpreted as in Bash
bet_slices_html = glob(pathjoin(html_output_dir, 'sub???_bet_slices.html'))
bet_slices_html.sort()

html_header = """
<html>
<head>
<title>Brain extraction QC pages</title>
</head>
<body>
<h2>Brain extraction QC pages</h2>
"""

html_footer = """
</body>
</html>
"""

# Open master page and write header
master_page = open(pathjoin(html_output_dir, 'ds008_bet_slices.html'), 'w')
master_page.write(html_header)

# Add links to subject pages
for page in bet_slices_html:
    subject = basename(page).split('_')[0]
    subject.replace('sub', 'Subject ')
    sub_link = '<p><a href="{}">{} extraction QC page</p>\n'
    master_page.write(sub_link.format(page, subject))

# Write footer and close master page
master_page.write(html_footer)
master_page.close()

