# DESCRIÇÃO
# Este script automatiza a criação de um atalho de desktop (.desktop) para gerenciar
# uma instância local do Penpot. Ele gera os scripts de controle (iniciar/parar),
# cria o ícone de aplicativo e, se um arquivo 'icon.png' for encontrado,
# o define como o ícone personalizado do atalho.

# COMENTÁRIOS
#1: Define dinamicamente o nome do usuário e os caminhos necessários.
#2: Cria o script 'start_penpot.sh' dentro de '~/penpot-server'.
#3: Cria o script 'stop_penpot.sh' no mesmo local.
#4: Aplica permissões de execução aos scripts de controle.
#5: Cria o arquivo 'penpot.desktop' no diretório de aplicativos do usuário.
#6: **NOVA ETAPA**: Verifica se '~/penpot-server/icon.png' existe. Se existir,
#   atualiza o arquivo .desktop para usar este ícone personalizado.
#7: Informa ao usuário que a configuração foi concluída com sucesso.

# CÓDIGO
#!/bin/bash

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
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
echo -e "\n${YELLOW}[1/5] Criando script de inicialização...${NC}"
cat << EOF > "${PENPOT_DIR}/start_penpot.sh"
#!/bin/bash
cd "\$(dirname "\$0")"
docker compose -p penpot up -d
sleep 5
xdg-open http://localhost:9001
EOF

#3
echo -e "${YELLOW}[2/5] Criando script de parada...${NC}"
cat << EOF > "${PENPOT_DIR}/stop_penpot.sh"
#!/bin/bash
cd "\$(dirname "\$0")"
docker compose -p penpot down
EOF

#4
echo -e "${YELLOW}[3/5] Aplicando permissões de execução...${NC}"
chmod +x "${PENPOT_DIR}/start_penpot.sh" "${PENPOT_DIR}/stop_penpot.sh"

#5
echo -e "${YELLOW}[4/5] Criando atalho no menu de aplicativos...${NC}"
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
echo -e "${YELLOW}[5/5] Verificando e aplicando ícone personalizado...${NC}"
ICON_FILE="${PENPOT_DIR}/icon.png"
LAUNCHER_FILE="${USER_HOME}/.local/share/applications/penpot.desktop"
if [ -f "$ICON_FILE" ]; then
    sed -i "s|^Icon=.*|Icon=${ICON_FILE}|" "$LAUNCHER_FILE"
    echo "Ícone personalizado encontrado e aplicado."
else
    echo "Nenhum ícone personalizado ('icon.png') encontrado. Usando ícone padrão do sistema."
fi

#7
echo -e "\n${GREEN}=== ATALHO DO PENPOT CRIADO E CONFIGURADO COM SUCESSO ===${NC}"
echo "Você agora pode encontrar e gerenciar o Penpot a partir do seu menu de aplicativos."

# CITAÇÃO
# "A simplicidade é a alma da eficiência." - Austin Freeman
