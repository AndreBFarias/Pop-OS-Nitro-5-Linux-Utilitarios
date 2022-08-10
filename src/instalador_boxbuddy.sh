set -e
echo "Iniciando instalação e configuração do BoxBuddy..."
echo "----------------------------------------------------"

# Instala as dependências do sistema
echo "Verificando e instalando dependências: flatpak e podman."
sudo apt update
sudo apt install -y flatpak podman

echo "----------------------------------------------------"

# Instala distrobox usando o método oficial (curl)
echo "Instalando distrobox a partir do repositório oficial..."
curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sudo sh

echo "----------------------------------------------------"

# Adiciona o repositório Flathub para o usuário atual
echo "Adicionando repositório Flathub para o usuário atual..."
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "----------------------------------------------------"

# Instala BoxBuddy via Flathub
echo "Instalando BoxBuddy via Flathub..."
flatpak install --user flathub io.github.dvlv.boxbuddyrs -y

echo "----------------------------------------------------"

# Concede acesso ao diretório /home para que o BoxBuddy possa criar caixas em qualquer lugar
echo "Ajustando permissões do BoxBuddy para acessar o diretório pessoal..."
flatpak override --user io.github.dvlv.boxbuddyrs --filesystem=home

echo "----------------------------------------------------"

# Verifica se a instalação foi bem-sucedida e informa a invocação correta
if flatpak list --user | grep -q "io.github.dvlv.boxbuddyrs"; then
    echo "✅ BoxBuddy instalado e configurado com sucesso!"
    echo "Você pode iniciá-lo pelo menu de aplicativos ou via terminal com o comando:"
    echo "flatpak run --user io.github.dvlv.boxbuddyrs"
    echo "----------------------------------------------------"
else
    echo "❌ Erro: A instalação do BoxBuddy falhou. Por favor, verifique a saída acima."
    exit 1
fi
