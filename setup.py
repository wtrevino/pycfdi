#!/usr/bin/env python
# -*- coding: utf-8 -*-

from setuptools import setup

with open('README.rst') as readme_file:
    readme = readme_file.read()

with open('HISTORY.rst') as history_file:
    history = history_file.read()

requirements = [
    'Click>=6.0',
    'Cerberus==1.0.1',
]

test_requirements = [
    'tox',
    'pytest',
]

setup(
    name='pycfdi',
    version='0.1.0',
    description="A python module to create, manipulate and validate CFDI documents.",
    long_description=readme + '\n\n' + history,
    author="Walter Treviño",
    author_email='walter.trevino@gmail.com',
    url='https://github.com/wtrevino/pycfdi',
    packages=[
        'pycfdi',
    ],
    package_dir={'pycfdi':
                 'pycfdi'},
    entry_points={
        'console_scripts': [
            'pycfdi=pycfdi.cli:main'
        ]
    },
    include_package_data=True,
    install_requires=requirements,
    license="MIT license",
    zip_safe=False,
    keywords=['pycfdi', 'cfdi', 'cfdi sat', 'cfdi comprobante', 'cfdi nómina', 'facturación electrónica', 'e-invoicing',]
    classifiers=[
        'Development Status :: 2 - Pre-Alpha',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: MIT License',
        'Natural Language :: English',
        "Programming Language :: Python :: 2",
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.3',
        'Programming Language :: Python :: 3.4',
        'Programming Language :: Python :: 3.5',
    ],
    test_suite='tests',
    tests_require=test_requirements
)
