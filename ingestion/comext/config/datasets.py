COMEXT_DATASETS = {
    "oil_imports": {
        "dataset_id": "DS-045409",
        "description": "EU imports of crude oil by partner country",
        "filters": {
            "freq": "M",
            "reporter": "EU27_2020",
            "flow": "1",
            "product": "2709",
            "indicators": ["VALUE_IN_EUROS", "QUANTITY_IN_100KG"],
        },
    },
    "gas_imports": {
        "dataset_id": "DS-045409",
        "description": "EU imports of natural gas by partner country",
        "filters": {
            "freq": "M",
            "reporter": "EU27_2020",
            "flow": "1",
            "product": ["271111",'271121'],
            "indicators": ["VALUE_IN_EUROS", "QUANTITY_IN_100KG"],
        },
    },
}