### ARQUIVO: backup_particao_efi.sh ###
==================================================

# DESCRIÇÃO
# Realiza um backup completo e versionado da partição EFI (/boot/efi).
# A partição EFI contém os arquivos de boot do sistema (bootloader), e um backup é crucial para a recuperação de desastres.
# O script cria um diretório com data e hora para cada backup, garantindo que os backups anteriores não sejam sobrescritos.

# COMENTÁRIOS
#1: Define a variável DATA com o timestamp atual no formato Ano-Mês-Dia_HoraMinuto.
#2: Define o diretório de destino para o backup, usando o timestamp para criar uma pasta única.
#3: Cria o diretório de destino. A opção -p garante que diretórios pais sejam criados se não existirem.
#4: Verifica se a partição /boot/efi está montada. O comando mountpoint retorna 0 se estiver montada.
#5: Se não estiver montada, tenta montar a partição. Se a montagem falhar, exibe uma mensagem de erro e encerra o script.
#6: Usa o rsync para copiar o conteúdo de /boot/efi para o diretório de destino. As opções -avh garantem uma cópia de arquivamento, verbosa e humanamente legível. O --delete remove arquivos no destino que não existem mais na origem.
#7: O comando tee redireciona a saída do rsync tanto para o terminal quanto para um arquivo de log dentro da pasta de backup.
#8: Informa ao usuário que o backup foi concluído e onde ele está localizado.

# CÓDIGO
#!/bin/bash
#1
DATA=$(date +"%Y-%m-%d_%H%M")
#2
DEST="$HOME/backup_efi/$DATA"
#3
mkdir -p "$DEST"

echo "Iniciando backup da partição EFI para: $DEST"
#4
if ! mountpoint -q /boot/efi; then
    echo "Aviso: Partição /boot/efi não está montada. Tentando montar..."
    #5
    sudo mount /boot/efi || { echo "Falha ao montar /boot/efi. Abortando."; exit 1; }
fi

echo "Copiando arquivos EFI com rsync..."
#6
#7
sudo rsync -avh --delete --progress /boot/efi/ "$DEST" | tee "$DEST/backup.log"
#8
echo "Backup da partição EFI concluído com sucesso."
echo "Local do backup: $DEST"

# CITAÇÃO
# "A prudência, em todos os tempos, não confiará a questões de liberdade ou propriedade a mãos débeis e inseguras." - Edmund Burke


==================================================
### ARQUIVO: backup_particao_efi.sh ###
==================================================

# DESCRIÇÃO
# Realiza um backup completo e versionado da partição EFI (/boot/efi).
# A partição EFI contém os arquivos de boot do sistema (bootloader), e um backup é crucial para a recuperação de desastres.
# O script cria um diretório com data e hora para cada backup, garantindo que os backups anteriores não sejam sobrescritos.

# COMENTÁRIOS
#1: Define a variável DATA com o timestamp atual no formato Ano-Mês-Dia_HoraMinuto.
#2: Define o diretório de destino para o backup, usando o timestamp para criar uma pasta única.
#3: Cria o diretório de destino. A opção -p garante que diretórios pais sejam criados se não existirem.
#4: Verifica se a partição /boot/efi está montada. O comando mountpoint retorna 0 se estiver montada.
#5: Se não estiver montada, tenta montar a partição. Se a montagem falhar, exibe uma mensagem de erro e encerra o script.
#6: Usa o rsync para copiar o conteúdo de /boot/efi para o diretório de destino. As opções -avh garantem uma cópia de arquivamento, verbosa e humanamente legível. O --delete remove arquivos no destino que não existem mais na origem.
#7: O comando tee redireciona a saída do rsync tanto para o terminal quanto para um arquivo de log dentro da pasta de backup.
#8: Informa ao usuário que o backup foi concluído e onde ele está localizado.

# CÓDIGO
#!/bin/bash
#1
DATA=$(date +"%Y-%m-%d_%H%M")
#2
DEST="$HOME/backup_efi/$DATA"
#3
mkdir -p "$DEST"

echo "Iniciando backup da partição EFI para: $DEST"
#4
if ! mountpoint -q /boot/efi; then
    echo "Aviso: Partição /boot/efi não está montada. Tentando montar..."
    #5
    sudo mount /boot/efi || { echo "Falha ao montar /boot/efi. Abortando."; exit 1; }
fi

echo "Copiando arquivos EFI com rsync..."
#6
#7
sudo rsync -avh --delete --progress /boot/efi/ "$DEST" | tee "$DEST/backup.log"
#8
echo "Backup da partição EFI concluído com sucesso."
echo "Local do backup: $DEST"

# CITAÇÃO
# "A prudência, em todos os tempos, não confiará a questões de liberdade ou propriedade a mãos débeis e inseguras." - Edmund Burke


==================================================
