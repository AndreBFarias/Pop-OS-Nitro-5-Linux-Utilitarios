### ARQUIVO: removedor_seguro_diretorio.sh ###
==================================================

# DESCRIÇÃO
# Um script para remover um diretório específico de forma segura, pedindo confirmação explícita do usuário.
# Ele foi projetado para uma tarefa específica (remover '~/resgate_raiz_antiga'), mas pode ser facilmente adaptado.
# Em vez de uma exclusão permanente e imediata com 'rm -rf', ele usa 'gio trash', que move o diretório para a lixeira, permitindo a recuperação.

# COMENTÁRIOS
#1: Define o caminho do diretório a ser excluído.
#2: Verifica se o diretório alvo existe. Se não existir, informa ao usuário e encerra o script.
#3: Exibe um aviso claro sobre a ação e sua permanência, e usa 'read' para aguardar a confirmação do usuário.
#4: Verifica se a entrada do usuário começa com 's' ou 'S'.
#5: Se a confirmação for positiva, executa 'gio trash' para mover o diretório para a lixeira e informa o sucesso da operação.
#6: Se a confirmação for negativa ou qualquer outra tecla for pressionada, informa que a operação foi cancelada.

# CÓDIGO
#!/bin/bash
#1
DIRETORIO_ALVO=~/resgate_raiz_antiga
#2
if [[ ! -d "$DIRETORIO_ALVO" ]]; then
  echo "Diretório alvo não encontrado em '$DIRETORIO_ALVO'. Nenhuma ação necessária."
  exit 0
fi

echo "Atenção: Você está prestes a mover o diretório '$DIRETORIO_ALVO' para a lixeira."
echo "Esta ação é reversível através da lixeira do sistema."
#3
read -p "Você tem certeza que deseja continuar? [s/N]: " confirmacao
#4
if [[ "$confirmacao" =~ ^[sS]$ ]]; then
    #5
    echo "Movendo para a lixeira..."
    gio trash "$DIRETORIO_ALVO" && echo "Diretório movido para a Lixeira com sucesso."
#6
else
    echo "Operação cancelada pelo usuário. Nada foi alterado."
fi

# CITAÇÃO
# "O melhor profeta do futuro é o passado." - Lord Byron


==================================================
### ARQUIVO: removedor_seguro_diretorio.sh ###
==================================================

# DESCRIÇÃO
# Um script para remover um diretório específico de forma segura, pedindo confirmação explícita do usuário.
# Ele foi projetado para uma tarefa específica (remover '~/resgate_raiz_antiga'), mas pode ser facilmente adaptado.
# Em vez de uma exclusão permanente e imediata com 'rm -rf', ele usa 'gio trash', que move o diretório para a lixeira, permitindo a recuperação.

# COMENTÁRIOS
#1: Define o caminho do diretório a ser excluído.
#2: Verifica se o diretório alvo existe. Se não existir, informa ao usuário e encerra o script.
#3: Exibe um aviso claro sobre a ação e sua permanência, e usa 'read' para aguardar a confirmação do usuário.
#4: Verifica se a entrada do usuário começa com 's' ou 'S'.
#5: Se a confirmação for positiva, executa 'gio trash' para mover o diretório para a lixeira e informa o sucesso da operação.
#6: Se a confirmação for negativa ou qualquer outra tecla for pressionada, informa que a operação foi cancelada.

# CÓDIGO
#!/bin/bash
#1
DIRETORIO_ALVO=~/resgate_raiz_antiga
#2
if [[ ! -d "$DIRETORIO_ALVO" ]]; then
  echo "Diretório alvo não encontrado em '$DIRETORIO_ALVO'. Nenhuma ação necessária."
  exit 0
fi

echo "Atenção: Você está prestes a mover o diretório '$DIRETORIO_ALVO' para a lixeira."
echo "Esta ação é reversível através da lixeira do sistema."
#3
read -p "Você tem certeza que deseja continuar? [s/N]: " confirmacao
#4
if [[ "$confirmacao" =~ ^[sS]$ ]]; then
    #5
    echo "Movendo para a lixeira..."
    gio trash "$DIRETORIO_ALVO" && echo "Diretório movido para a Lixeira com sucesso."
#6
else
    echo "Operação cancelada pelo usuário. Nada foi alterado."
fi

# CITAÇÃO
# "O melhor profeta do futuro é o passado." - Lord Byron


==================================================
