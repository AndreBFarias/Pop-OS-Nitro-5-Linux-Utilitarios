#!/bin/bash

#1: Define dinamicamente o nome do usuário e os caminhos necessários para garantir que o script seja universal.
#2: Cria o script 'start_penpot.sh' dentro de '~/penpot-server'. Este script inicia os contêineres e abre a interface web.
#3: Cria o script 'stop_penpot.sh' no mesmo local. Este script desliga os contêineres do Penpot.
#4: Aplica permissões de execução aos dois scripts recém-criados.
#5: Cria o arquivo 'penpot.desktop' em '~/.local/share/applications'. Este arquivo é o que o sistema usa
#   para exibir o ícone no menu de aplicativos. Ele é configurado com os caminhos dinâmicos para os scripts de controle.
#6: Informa ao usuário que a configuração foi concluída com sucesso.

# CÓDIGO


BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}=== INICIANDO CRIAÇÃO DO ATALHO PARA O PENPOT ===${NC}"

#1
USER_HOME=$HOME
PENPOT_DIR="${USER_HOME}/penpot-server"

if [ ! -d "$PENPOT_DIR" ]; then
    echo -e "${RED}ERRO: Diretório '$PENPOT_DIR' não encontrado. Certifique-se de que o Penpot foi instalado primeiro.${NC}"
    exit 1
fi

#2
echo -e "\n${YELLOW}[1/4] Criando script de inicialização...${NC}"
cat << EOF > "${PENPOT_DIR}/start_penpot.sh"
#!/bin/bash
cd "\$(dirname "\$0")"
docker compose -p penpot up -d
sleep 5
xdg-open http://localhost:9001
EOF

#3
echo -e "${YELLOW}[2/4] Criando script de parada...${NC}"
cat << EOF > "${PENPOT_DIR}/stop_penpot.sh"
#!/bin/bash
cd "\$(dirname "\$0")"
docker compose -p penpot down
EOF

#4
echo -e "${YELLOW}[3/4] Aplicando permissões de execução...${NC}"
chmod +x "${PENPOT_DIR}/start_penpot.sh" "${PENPOT_DIR}/stop_penpot.sh"

#5
echo -e "${YELLOW}[4/4] Criando atalho no menu de aplicativos...${NC}"
mkdir -p "${USER_HOME}/.local/share/applications"
cat << EOF > "${USER_HOME}/.local/share/applications/penpot.desktop"
[Desktop Entry]
Version=1.0
Name=Penpot
Comment=Design and Prototyping Platform
Exec=${PENPOT_DIR}/start_penpot.sh
Icon=penpot
Terminal=false
Type=Application
Categories=Graphics;Development;
Actions=Stop;

[Desktop Action Stop]
Name=Stop Penpot Server
Exec=${PENPOT_DIR}/stop_penpot.sh
EOF

#6
echo -e "\n${GREEN}=== ATALHO DO PENPOT CRIADO COM SUCESSO ===${NC}"
echo "Você agora pode encontrar e gerenciar o Penpot a partir do seu menu de aplicativos."


