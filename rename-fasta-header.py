#! /usr/bin/env python
"""
Prefix a set of FASTA (STDIN)  headers with a given string.

Example run:  zcat my_fasta.gz | ./rename-fasta-header.py headers.txt PREFIX
"""
from __future__ import print_function

if __name__ == '__main__':
    import sys
    import argparse as ap

    parser = ap.ArgumentParser(
        prog='fastq_cleanup',
        conflict_handler='resolve',
        description='Prefix a a set of FASTA headers with a given string.')
    group1 = parser.add_argument_group('Options', '')
    group1.add_argument('header', metavar="LIST_FILE", type=str,
                        help='A list of headers to search for and prefix.')
    group1.add_argument('prefix', metavar="STR", type=str,
                        help='A string to prefix the fasta headers with.')

    args = parser.parse_args()

    headers = {}
    with open(args.header, 'r') as fh:
        for line in fh:
            line = '>{0}'.format(line)
            headers[line] = True

    for line in sys.stdin:
        if line in headers:
            line = line.rstrip()
            line = '{0} {1}\n'.format(line, args.prefix)
        print(line, end="")
