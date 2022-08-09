#1
set -e

echo "Iniciando instalação e configuração do BoxBuddy..."
echo "----------------------------------------------------"
echo "Verificando e instalando dependências: flatpak e podman."

sudo apt update
sudo apt install -y flatpak podman

echo "----------------------------------------------------"

#2
echo "Instalando BoxBuddy via Flathub..."
flatpak install --user flathub io.github.dvlv.boxbuddyrs -y

echo "----------------------------------------------------"

#3
echo "Ajustando permissões do BoxBuddy para acessar o diretório pessoal..."
# Concede acesso ao diretório /home para que o BoxBuddy possa criar caixas em qualquer lugar
flatpak override --user io.github.dvlv.boxbuddyrs --filesystem=home

echo "----------------------------------------------------"

#4
if flatpak list | grep -q "io.github.dvlv.boxbuddyrs"; then
    echo "✅ BoxBuddy instalado e configurado com sucesso!"
    echo "Você pode iniciá-lo pelo menu de aplicativos ou via terminal com o comando:"
    echo "flatpak run io.github.dvlv.boxbuddyrs"
    echo "----------------------------------------------------"
else
    echo "❌ Erro: A instalação do BoxBuddy falhou. Por favor, verifique a saída acima."
    exit 1
fi
