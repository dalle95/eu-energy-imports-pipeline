import requests
import csv
import json
from typing import Union


def export_woeqpt_to_csv(api_response: Union[dict, str], output_csv_path: str) -> None:
    """
    Estrae da una risposta API i campi:
    - woeqpt_id
    - wo_id
    - eqpt_id

    e li salva in un file CSV.

    Parametri:
    - api_response: dict Python oppure stringa JSON
    - output_csv_path: percorso del file CSV di output
    """

    # Se arriva una stringa JSON, la converto in dict
    if isinstance(api_response, str):
        api_response = json.loads(api_response)

    data = api_response.get("data", [])

    rows = []

    for item in data:
        woeqpt_id = item.get("id")

        wo_id = (
            item.get("relationships", {})
                .get("WO", {})
                .get("data", {})
                .get("id")
        )

        eqpt_id = (
            item.get("relationships", {})
                .get("eqpt", {})
                .get("data", {})
                .get("id")
        )

        rows.append({
            "woeqpt_id": woeqpt_id,
            "wo_id": wo_id,
            "eqpt_id": eqpt_id
        })

    with open(output_csv_path, mode="w", newline="", encoding="utf-8") as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=["woeqpt_id", "wo_id", "eqpt_id"])
        writer.writeheader()
        writer.writerows(rows)


for int in range(1, 6):
    offset = (int - 1) * 1000
    url = f"https://tecnomat.in-am.it/gmaoCS02/api/entities/v1/woeqpt?include=eqpt%2CWO&page[offset]={offset}&page[limit]=1000&filter[WO.WOBegin][GE]=2026-03-01&filter[WO.WOBegin][LE]=2026-03-31&filter[eqpt.xtraTxt01]=Negozio"

    payload = {}
    headers = {
    'Authorization': 'Basic REVNTzpkZW1v'
    }

    response = requests.request("GET", url, headers=headers, data=payload)

    export_woeqpt_to_csv(response.text, f"woeqpt_data_{int}.csv")



