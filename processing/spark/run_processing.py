from jobs.processing_comext_data_oil import process_comext_oil_data
from jobs.processing_comext_data_gas import process_comext_gas_data

def run_processing():
    print("Starting processing phase")

    process_comext_oil_data()
    process_comext_gas_data()

    print("Processing phase completed")

if __name__ == "__main__":
    run_processing()