from ingestion.run_ingestion import run_ingestion as run_ingestion
# from processing.run_processing import run_processing as run_processing


def main():

    print("Pipeline started")

    print("Ingestion phase started")

    run_ingestion()

    print("Ingestion phase completed")

    print("Processing phase started")

    # run_processing()

    print("Processing phase completed")



    print("Pipeline completed")

if __name__ == "__main__":
    main()