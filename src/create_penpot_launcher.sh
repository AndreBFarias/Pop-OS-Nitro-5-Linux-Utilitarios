#!/bin/bash

# DESCRIÇÃO
# Versão final que usa o caminho correto ~/penpot-server,
# confirmado pelo comando 'ls -la'.

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=== INICIANDO CRIAÇÃO DO ATALHO PARA O PENPOT (VERSÃO DEFINITIVA) ===${NC}"

# 1: Define os caminhos corretos
USER_HOME=$HOME
PENPOT_DIR="${USER_HOME}/penpot-server"

# 2: Valida se o diretório e o ícone existem
if [ ! -d "$PENPOT_DIR" ] || [ ! -f "${PENPOT_DIR}/icon.png" ]; then
    echo -e "${RED}ERRO: Diretório '$PENPOT_DIR' ou arquivo 'icon.png' não encontrado.${NC}"
    exit 1
fi

# 3: Cria scripts de controle (start/stop)
echo -e "\n${YELLOW}[1/4] Criando scripts de controle...${NC}"
cat << EOF > "${PENPOT_DIR}/start_penpot.sh"
#!/bin/bash
cd "\$(dirname "\$0")"
docker compose -p penpot up -d
sleep 5
xdg-open http://localhost:9001
EOF

cat << EOF > "${PENPOT_DIR}/stop_penpot.sh"
#!/bin/bash
cd "\$(dirname "\$0")"
docker compose -p penpot down
EOF

chmod +x "${PENPOT_DIR}/start_penpot.sh" "${PENPOT_DIR}/stop_penpot.sh"

# 4: Cria o arquivo .desktop com os caminhos corretos
echo -e "${YELLOW}[2/4] Criando arquivo de atalho...${NC}"
LAUNCHER_FILE="${USER_HOME}/.local/share/applications/penpot.desktop"
mkdir -p "$(dirname "${LAUNCHER_FILE}")"
cat << EOF > "${LAUNCHER_FILE}"
[Desktop Entry]
Version=1.0
Name=Penpot
Comment=Design and Prototyping Platform
Exec=${PENPOT_DIR}/start_penpot.sh
Icon=${PENPOT_DIR}/icon.png
Terminal=false
Type=Application
Categories=Graphics;Development;
Actions=Stop;

[Desktop Action Stop]
Name=Stop Penpot Server
Exec=${PENPOT_DIR}/stop_penpot.sh
EOF

# 5: Força a atualização do cache de ícones
echo -e "${YELLOW}[3/4] Forçando atualização do cache de aplicativos...${NC}"
update-desktop-database "${USER_HOME}/.local/share/applications"

# 6: Conclusão
echo -e "${YELLOW}[4/4] Verificação final...${NC}"
echo -e "\n${GREEN}=== ATALHO CRIADO E CONFIGURADO COM SUCESSO ===${NC}"
echo "O caminho do ícone foi definido corretamente como: ${PENPOT_DIR}/icon.png"
echo -e "${YELLOW}O atalho já deve estar visível no seu menu. Se não, um logout/login resolverá.${NC}"

# CITAÇÃO
# "A verdade é sempre a mais forte das discussões." - Sófocles
