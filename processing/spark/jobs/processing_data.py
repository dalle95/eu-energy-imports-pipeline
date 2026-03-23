from pyspark.sql import SparkSession
from pyspark.sql import types

def process_comext_data(input_path, output_base_path, app_name):
	"""Read a Comext CSV dataset and split it into quantity and value parquet outputs."""

	print(f"Processing dataset from {input_path}")

	spark = (
		SparkSession.builder
		.appName(app_name)
		.master("spark://spark-master:7077")
		.config("spark.driver.host", "spark-client")
		.config("spark.driver.bindAddress", "0.0.0.0")
		.getOrCreate()
	)

	schema = types.StructType(
				[
					types.StructField ('DATAFLOW', types.StringType(), True),
					types.StructField('LAST UPDATE', types.StringType(), True),
					types.StructField('freq', types.StringType(), True),
					types.StructField('reporter', types.StringType(), True),
					types.StructField('partner', types.StringType(), True),
					types.StructField('product', types.StringType(), True),
					types.StructField('flow', types.StringType(), True),
					types.StructField('indicators', types.StringType(), True),
					types.StructField('TIME_PERIOD', types.StringType(), True),
					types.StructField('OBS_VALUE', types.DoubleType(), True)
				]
	)

	df_oil = spark.read \
		.option("header", True) \
		.schema(schema) \
		.csv(input_path)

	df_oil_quantity = df_oil.select('reporter', 'partner', 'product', 'TIME_PERIOD', 'OBS_VALUE').filter(df_oil.indicators == 'QUANTITY_IN_100KG')

	df_oil_quantity.write.parquet(output_base_path + '/quantity', mode = 'overwrite')

	df_oil_value = df_oil.select('reporter', 'partner', 'product', 'TIME_PERIOD', 'OBS_VALUE').filter(df_oil.indicators == 'VALUE_IN_EUROS')

	df_oil_value.write.parquet(output_base_path + '/value', mode = 'overwrite')

	spark.stop()
