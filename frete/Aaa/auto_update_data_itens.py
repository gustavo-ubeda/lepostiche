import pandas as pd, pyodbc, time, requests

server = "192.1.1.175"
database = ""
user = "suporte_linx"
password = "Linx123@"
time_h = 8 # Tempo em horas para atualização

firebase_token = "dUtLx4Bwwjte6H6CPZWgKbDVK3mqm5OJ1NUEtUCv"
firebase_base = "https://singy-b98fb-default-rtdb.firebaseio.com"
name_base = "lepostiche/fretes"

query = open("itens.sql").read()
con_string = "DRIVER={SQL Server};SERVER="+ server +";DATABASE=" + database
cnxn = pyodbc.connect(con_string)

print(f"Iniciando atualizações (a cada {time_h} horas)\n")
while True:
    result = pd.read_sql(query, cnxn)
    result_json = result.to_dict(orient="records")

    response = requests.patch(
        f"{firebase_base}/{name_base}.json?auth={firebase_token}", 
        json={"datas": result_json})
    
    if response.ok:    
        print(f"\t{pd.Timestamp.now()} - Bando de dados atualizado com sucesso")
    else:
        print(f"\t{pd.Timestamp.now()} - Erro na atualização do banco de dados")

    time.sleep(time_h*60*60)