#!/bin/bash

#1: Instala as dependências essenciais: curl para downloads e docker.io como motor de contêineres.
#2: Configura o ambiente Docker: adiciona o usuário ao grupo 'docker' para uso sem sudo e instala
#   manualmente a versão mais recente do Docker Compose V2 para garantir compatibilidade e estabilidade.
#3: Prepara o ambiente do Penpot, criando um diretório dedicado e baixando o arquivo de configuração oficial.
#4: Aplica correções automáticas no arquivo docker-compose.yaml usando 'sed' para converter valores
#   booleanos em strings, evitando erros de parsing em tempo de execução.
#5: Inicia todos os serviços do Penpot em segundo plano usando 'docker compose'. A permissão de grupo
#   é aplicada na mesma sessão através de uma subshell 'newgrp docker'.
#6: Fornece ao usuário o feedback final, incluindo a URL de acesso à instância do Penpot e a recomendação de reiniciar a sessão.


BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}=== INICIANDO SETUP DO AMBIENTE PENPOT (DOCKER) ===${NC}"

#1
echo -e "\n${YELLOW}[FASE 1/4] Instalando dependências do sistema...${NC}"
sudo apt update
sudo apt install -y curl docker.io

#2
echo -e "\n${YELLOW}[FASE 2/4] Configurando Docker e Docker Compose V2...${NC}"
if ! groups $USER | grep &>/dev/null '\bdocker\b'; then
    sudo usermod -aG docker $USER
    echo "Permissões de usuário para o Docker configuradas."
fi
if ! docker compose version &> /dev/null; then
    echo "Instalando Docker Compose V2 (plugin)..."
    sudo mkdir -p /usr/local/lib/docker/cli-plugins
    sudo curl -SL "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s | tr '[:upper:]' '[:lower:]')-$(uname -m)" -o /usr/local/lib/docker/cli-plugins/docker-compose
    sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
fi

#3
echo -e "\n${YELLOW}[FASE 3/4] Preparando arquivos de configuração do Penpot...${NC}"
mkdir -p ~/penpot-server && cd ~/penpot-server
echo "Baixando 'docker-compose.yaml'..."
curl -L https://raw.githubusercontent.com/penpot/penpot/main/docker/images/docker-compose.yaml -o docker-compose.yaml

#4
echo "Aplicando patches de compatibilidade ao arquivo de configuração..."
sed -i 's/PENPOT_TELEMETRY_ENABLED: true/PENPOT_TELEMETRY_ENABLED: "true"/' docker-compose.yaml
sed -i 's/PENPOT_SMTP_TLS: false/PENPOT_SMTP_TLS: "false"/' docker-compose.yaml
sed -i 's/PENPOT_SMTP_SSL: false/PENPOT_SMTP_SSL: "false"/' docker-compose.yaml

#5
echo -e "\n${YELLOW}[FASE 4/4] Iniciando serviços do Penpot...${NC}"
echo "Esta operação pode levar vários minutos no primeiro uso, pois baixará as imagens."
newgrp docker <<EOC
docker compose -p penpot up -d
EOC
cd ~

#6
echo -e "\n${GREEN}=== SETUP DO PENPOT CONCLUÍDO ===${NC}"
echo -e "Sua instância local do Penpot está disponível em: ${YELLOW}http://localhost:9001${NC}"
echo -e "O primeiro usuário a se registrar será o administrador."
echo -e "\n${YELLOW}AÇÃO RECOMENDADA: Reinicie a sessão (Logout/Login) para que a permissão do Docker seja aplicada permanentemente.${NC}"

S
