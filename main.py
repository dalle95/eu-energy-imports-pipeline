from ingestion.eurostat.config.download_dimensions import download_dimensions as download_dimensions

from ingestion.eurostat.extract.download_oil_data import download_oil_data as download_oil_data_eurostat
from ingestion.eurostat.extract.download_gas_data import download_gas_data as download_gas_data_eurostat
from ingestion.eurostat.extract.download_electricity_data import download_electricity_data as download_electricity_data_eurostat

from ingestion.comext.extract.download_oil_data import download_oil_data as download_oil_data_comext
from ingestion.comext.extract.download_gas_data import download_gas_data as download_gas_data_comext


def main():

    print("Starting Eurostat dimensions ingestion")

    download_dimensions()

    print("Pipeline completed")

    print("Starting Eurostat oil ingestion")

    download_oil_data_eurostat()

    print("Pipeline completed")

    print("Starting Eurostat gas ingestion")

    download_gas_data_eurostat()

    print("Pipeline completed")

    print("Starting Eurostat electricity ingestion")

    download_electricity_data_eurostat()

    print("Pipeline completed")   

    print("Starting Comext oil ingestion")

    download_oil_data_comext()

    print("Pipeline completed")

    print("Starting Comext gas ingestion")

    download_gas_data_comext()

    print("Pipeline completed")

if __name__ == "__main__":
    main()