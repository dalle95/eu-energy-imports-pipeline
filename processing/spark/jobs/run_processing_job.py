from processing_comext_data_oil import process_comext_oil_data
from processing_comext_data_gas import process_comext_gas_data


def run_processing_job():
    print("Starting Spark processing job")

    process_comext_oil_data()
    process_comext_gas_data()

    print("Spark processing job completed")


if __name__ == "__main__":
    run_processing_job()