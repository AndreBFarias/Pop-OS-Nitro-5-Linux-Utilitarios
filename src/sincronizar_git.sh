#!/bin/bash
# Script universal de sincronização de repositórios Git

set -e

# Nome do arquivo de configuração
CONFIG_FILE="repositorios.conf"

# Diretório de desenvolvimento
DEV_DIR="$HOME/Desenvolvimento"

echo "Iniciando o rito de sincronização universal..."
echo "----------------------------------------------------"

# Verifica se o arquivo de configuração existe
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Erro: Arquivo de configuração '$CONFIG_FILE' não encontrado."
    echo "Crie este arquivo e liste as URLs dos seus repositórios, uma por linha."
    exit 1
fi

# Itera sobre cada linha do arquivo de configuração
while read -r url; do
    # Ignora linhas em branco ou comentários
    if [[ -z "$url" || "$url" =~ ^# ]]; then
        continue
    fi

    # Extrai o nome do projeto da URL
    projeto_pasta=$(basename -s .git "$url")
    pasta="$DEV_DIR/$projeto_pasta"

    if [ ! -d "$pasta" ]; then
        echo "Pasta '$pasta' não encontrada. Clonando repositório..."
        git clone "$url" "$pasta"
        echo "Repositório '$projeto_pasta' clonado com sucesso."
    else
        echo "Entrando na pasta '$pasta'..."
        cd "$pasta" || continue

        if [ ! -d ".git" ]; then
            echo "Pasta não é um repositório Git. Ignorando."
            echo "Para sincronizar, remova a pasta e execute o script novamente para que ele clone."
        else
            echo "Pasta já é um repositório Git. Sincronizando..."
            git pull origin main
            echo "Sincronização concluída."
        fi
    fi
    echo "----------------------------------------------------"
done < "$CONFIG_FILE"

echo "Rito de sincronização de todos os projetos concluído."
