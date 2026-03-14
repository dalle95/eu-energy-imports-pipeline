import requests
from pathlib import Path
import xml.etree.ElementTree as ET
import pandas as pd

def update_gitignore():
    gitignore_path = Path(".gitignore")
    content = gitignore_path.read_text(encoding="utf-8") if gitignore_path.exists() else ""

    if "data/" not in content:
        with open(gitignore_path, "a", encoding="utf-8") as f:
            if content and not content.endswith("\n"):
                f.write("\n")
            f.write("# Data directory\ndata/\n")

def download_file(url: str, output_path: Path):
    response = requests.get(url, timeout=30)
    response.raise_for_status()
    output_path.write_bytes(response.content)


def parse_all_codelists(xml_path: str, output_dir: str):
    tree = ET.parse(xml_path)
    root = tree.getroot()

    namespaces = {
        "structure": "http://www.sdmx.org/resources/sdmxml/schemas/v2_1/structure",
        "common": "http://www.sdmx.org/resources/sdmxml/schemas/v2_1/common",
    }

    output_dir = Path(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    for codelist in root.findall(".//structure:Codelist", namespaces):
        codelist_id = codelist.attrib.get("id")
        rows = []

        for code in codelist.findall("structure:Code", namespaces):
            code_id = code.attrib.get("id")

            for name in code.findall("common:Name", namespaces):
                lang = name.attrib.get("{http://www.w3.org/XML/1998/namespace}lang")
                if lang == "en":
                    rows.append(
                        {
                            "code": code_id,
                            "label": name.text,
                            "lang": lang,
                        }
                    )

        if rows:
            df = pd.DataFrame(rows)
            df.to_csv(output_dir / f"{codelist_id}.csv", index=False)


def download_dimensions():

    endpoint = "https://ec.europa.eu/eurostat/api/dissemination/sdmx/2.1"
    base_url = (
        f"{endpoint}/codelist/ESTAT/"
    )

    output_dir = Path("data/raw/eurostat/dimensions")
    output_dir.mkdir(parents=True, exist_ok=True)

    update_gitignore()

    dimensions = ['FREQ','SIEC','PARTNER','UNIT','GEO']

    for dimension in dimensions:
        url_parametrized = base_url + dimension

        output_file = output_dir / f"dimension_{dimension}.xml"

        print(f"Downloading {dimension} dimension...")
        print(url_parametrized)

        download_file(url_parametrized, output_file)

        processed_output_dir = Path("data/processed/eurostat/dimensions")

        print(f"Parsing {dimension} dimension...")

        parse_all_codelists(output_file, processed_output_dir)





