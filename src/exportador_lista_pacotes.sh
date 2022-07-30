### ARQUIVO: exportador_lista_pacotes.sh ###
==================================================

# DESCRIÇÃO
# Este script cria uma lista de todos os pacotes e aplicações instalados no sistema a partir de diferentes fontes (APT, Flatpak, Snap).
# Ele também lida com pacotes instalados manualmente (.deb, .tar.gz, .zip), copiando-os para diretórios locais e listando-os.
# O resultado é um único arquivo de texto que serve como um manifesto para recriar o ambiente de software em outra máquina.

# COMENTÁRIOS
#1: Define o nome do arquivo de saída e dos diretórios para onde os pacotes manuais serão copiados.
#2: Inicia o arquivo de saída, limpando qualquer conteúdo anterior, e adiciona um cabeçalho para os pacotes APT.
#3: Lista todos os pacotes instalados via APT, formata a saída com 'awk' para prefixar cada linha com 'apt:' e anexa ao arquivo.
#4: Adiciona um cabeçalho para os pacotes Flatpak e anexa a lista de aplicações Flatpak, prefixadas com 'flatpak:'.
#5: Adiciona um cabeçalho para os pacotes Snap e anexa a lista de snaps, prefixadas com 'snap:'. 'NR>1' ignora a linha de cabeçalho da saída do 'snap list'.
#6: Adiciona um cabeçalho para pacotes .deb manuais, cria o diretório de backup, copia todos os arquivos .deb da pasta Downloads e anexa seus nomes ao arquivo de log, prefixados com 'deb:'.
#7: Faz o mesmo para arquivos compactados (.tar, .zip), copiando-os e listando-os com o prefixo 'tarzip:'.
#8: Informa ao usuário que a exportação foi concluída.

# CÓDIGO
#!/bin/bash
#1
ARQUIVO_SAIDA="manifesto_pacotes_instalados.txt"
PASTA_DEB_BKP="./pacotes_deb_backup"
PASTA_TAR_BKP="./pacotes_tar_backup"

#2
echo "# Manifesto de Pacotes - APT" > $ARQUIVO_SAIDA
#3
apt list --installed 2>/dev/null | awk -F/ '{print "apt:"$1}' >> $ARQUIVO_SAIDA

#4
echo -e "\n# Manifesto de Pacotes - Flatpak" >> $ARQUIVO_SAIDA
flatpak list --app --columns=application | awk '{print "flatpak:"$1}' >> $ARQUIVO_SAIDA

#5
echo -e "\n# Manifesto de Pacotes - Snap" >> $ARQUIVO_SAIDA
snap list | awk 'NR>1 {print "snap:"$1}' >> $ARQUIVO_SAIDA

#6
echo -e "\n# Pacotes Manuais - DEB" >> $ARQUIVO_SAIDA
mkdir -p $PASTA_DEB_BKP
find ~/Downloads -maxdepth 1 -type f -name "*.deb" -exec cp {} $PASTA_DEB_BKP/ \;
ls $PASTA_DEB_BKP/*.deb 2>/dev/null | awk -F'/' '{print "deb:"$NF}' >> $ARQUIVO_SAIDA

#7
echo -e "\n# Pacotes Manuais - TAR/ZIP" >> $ARQUIVO_SAIDA
mkdir -p $PASTA_TAR_BKP
find ~/Downloads -maxdepth 1 -type f \( -name "*.tar*" -o -name "*.zip" \) -exec cp {} $PASTA_TAR_BKP/ \;
ls $PASTA_TAR_BKP/*.{tar,tar.gz,tgz,zip} 2>/dev/null | awk -F'/' '{print "tarzip:"$NF}' >> $ARQUIVO_SAIDA

#8
echo "Exportação de pacotes concluída. Manifesto salvo em: $ARQUIVO_SAIDA"

# CITAÇÃO
# "Aquele que não quer se lembrar do passado está condenado a repeti-lo." - George Santayana


==================================================
### ARQUIVO: exportador_lista_pacotes.sh ###
==================================================

# DESCRIÇÃO
# Este script cria uma lista de todos os pacotes e aplicações instalados no sistema a partir de diferentes fontes (APT, Flatpak, Snap).
# Ele também lida com pacotes instalados manualmente (.deb, .tar.gz, .zip), copiando-os para diretórios locais e listando-os.
# O resultado é um único arquivo de texto que serve como um manifesto para recriar o ambiente de software em outra máquina.

# COMENTÁRIOS
#1: Define o nome do arquivo de saída e dos diretórios para onde os pacotes manuais serão copiados.
#2: Inicia o arquivo de saída, limpando qualquer conteúdo anterior, e adiciona um cabeçalho para os pacotes APT.
#3: Lista todos os pacotes instalados via APT, formata a saída com 'awk' para prefixar cada linha com 'apt:' e anexa ao arquivo.
#4: Adiciona um cabeçalho para os pacotes Flatpak e anexa a lista de aplicações Flatpak, prefixadas com 'flatpak:'.
#5: Adiciona um cabeçalho para os pacotes Snap e anexa a lista de snaps, prefixadas com 'snap:'. 'NR>1' ignora a linha de cabeçalho da saída do 'snap list'.
#6: Adiciona um cabeçalho para pacotes .deb manuais, cria o diretório de backup, copia todos os arquivos .deb da pasta Downloads e anexa seus nomes ao arquivo de log, prefixados com 'deb:'.
#7: Faz o mesmo para arquivos compactados (.tar, .zip), copiando-os e listando-os com o prefixo 'tarzip:'.
#8: Informa ao usuário que a exportação foi concluída.

# CÓDIGO
#!/bin/bash
#1
ARQUIVO_SAIDA="manifesto_pacotes_instalados.txt"
PASTA_DEB_BKP="./pacotes_deb_backup"
PASTA_TAR_BKP="./pacotes_tar_backup"

#2
echo "# Manifesto de Pacotes - APT" > $ARQUIVO_SAIDA
#3
apt list --installed 2>/dev/null | awk -F/ '{print "apt:"$1}' >> $ARQUIVO_SAIDA

#4
echo -e "\n# Manifesto de Pacotes - Flatpak" >> $ARQUIVO_SAIDA
flatpak list --app --columns=application | awk '{print "flatpak:"$1}' >> $ARQUIVO_SAIDA

#5
echo -e "\n# Manifesto de Pacotes - Snap" >> $ARQUIVO_SAIDA
snap list | awk 'NR>1 {print "snap:"$1}' >> $ARQUIVO_SAIDA

#6
echo -e "\n# Pacotes Manuais - DEB" >> $ARQUIVO_SAIDA
mkdir -p $PASTA_DEB_BKP
find ~/Downloads -maxdepth 1 -type f -name "*.deb" -exec cp {} $PASTA_DEB_BKP/ \;
ls $PASTA_DEB_BKP/*.deb 2>/dev/null | awk -F'/' '{print "deb:"$NF}' >> $ARQUIVO_SAIDA

#7
echo -e "\n# Pacotes Manuais - TAR/ZIP" >> $ARQUIVO_SAIDA
mkdir -p $PASTA_TAR_BKP
find ~/Downloads -maxdepth 1 -type f \( -name "*.tar*" -o -name "*.zip" \) -exec cp {} $PASTA_TAR_BKP/ \;
ls $PASTA_TAR_BKP/*.{tar,tar.gz,tgz,zip} 2>/dev/null | awk -F'/' '{print "tarzip:"$NF}' >> $ARQUIVO_SAIDA

#8
echo "Exportação de pacotes concluída. Manifesto salvo em: $ARQUIVO_SAIDA"

# CITAÇÃO
# "Aquele que não quer se lembrar do passado está condenado a repeti-lo." - George Santayana


==================================================
