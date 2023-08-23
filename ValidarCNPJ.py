from flask import Flask, request, jsonify
import requests  

app = Flask(__name__)

def validar_cnpj(cnpj):
    # Monta a URL da API com o CNPJ
    url = f"https://www.receitaws.com.br/v1/cnpj/{cnpj}" 
     # Faz uma requisição GET à API
    response = requests.get(url)

    # Se a resposta for bem-sucedida (status 200)
    if response.status_code == 200: 
        # Converte a resposta JSON para um dicionário
        data = response.json()
        # Verifica se as chaves existem no dicionário
        if "atividade_principal" in data and "nome" in data:
            nome_estabelecimento = data["nome"]
            telefone = data.get("telefone") 
            email = data.get("email") 

            # Extrai uma lista de sócios/acionistas ou usa uma lista vazia
            qsa_list = data.get("qsa", [])
            if qsa_list:
                # Extrai o nome do CEO ou usa "N/A"
                nome_ceo = qsa_list[0].get("nome_rep_legal", "N/A") 
            else:
                nome_ceo = "N/A"

            data_fundacao = data.get("abertura", "N/A") 
            cep = data.get("cep", "N/A")
            setor = data.get("atividade_principal", [{}])[0].get("text", "N/A")

            return nome_estabelecimento, telefone, email, nome_ceo, data_fundacao, cep, setor
    return None, None, None, None, None, None, None

 # Define a rota e os métodos permitidos
@app.route('/consulta_cnpj', methods=['GET'])
def consulta_cnpj():
     # Obtém o CNPJ a partir dos parâmetros da requisição
    cnpj = request.args.get('cnpj')
     # Valida o CNPJ e obtém os dados
    nome, telefone, email, nome_ceo, data_fundacao, cep, setor = validar_cnpj(cnpj)

    # Se o CNPJ for válido (nome não é None)
    if nome: 
        # Retorna os dados em formato JSON
        return jsonify({ 
            "nome": nome,
            "telefone": telefone,
            "email": email,
            "nome_ceo": nome_ceo,
            "data_fundacao": data_fundacao,
            "cep": cep,
            "setor": setor
        })
    else: 
        return jsonify({"erro": "CNPJ inválido!"}), 400 

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
