#!/usr/bin/env python
# coding: utf-8

from jobs.processing_data import process_comext_data

def process_comext_oil_data():
      
	process_comext_data(
		"/data/raw/comext/facts/oil_imports",
		"/data/processed/comext/facts/oil_imports",
		"data-oil-processing"
	)

if __name__ == "__main__":
    processing_comext_oil_data()
