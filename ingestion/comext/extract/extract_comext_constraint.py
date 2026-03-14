import requests
import xml.etree.ElementTree as ET


def get_comext_constraints(dataset_id: str) -> dict[str, list[str]]:
    url = (
        f"https://ec.europa.eu/eurostat/api/comext/dissemination/sdmx/2.1/"
        f"contentconstraint/ESTAT/{dataset_id}"
    )

    response = requests.get(url, timeout=60)
    response.raise_for_status()

    root = ET.fromstring(response.content)

    namespaces = {
        "c": "http://www.sdmx.org/resources/sdmxml/schemas/v2_1/common",
        "str": "http://www.sdmx.org/resources/sdmxml/schemas/v2_1/structure",
    }

    constraints = {}

    for key_value in root.findall(".//str:CubeRegion/str:KeyValue", namespaces):
        dim_id = key_value.attrib.get("id")
        values = [v.text for v in key_value.findall("str:Value", namespaces) if v.text]
        constraints[dim_id] = values

    return constraints