#!/usr/bin/env python
# coding: utf-8

from processing_data import process_comext_data

def process_comext_gas_data():
      
	process_comext_data(
		"/data/raw/comext/facts/gas_imports",
		"/data/processed/comext/facts/gas_imports",
		"data-gas-processing"
	)

if __name__ == "__main__":
    process_comext_gas_data()