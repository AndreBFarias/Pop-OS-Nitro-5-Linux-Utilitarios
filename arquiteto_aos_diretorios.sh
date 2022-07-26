==================================================
### ARQUIVO: arquiteto_de_diretorios.sh ###
==================================================

# DESCRIÇÃO
# Um assistente interativo e seguro para organizar arquivos nas pastas de usuário ($HOME e Downloads).
# Utiliza uma interface de texto (TUI) criada com 'dialog' para guiar o usuário em cada passo.
# Suas funções principais incluem simular a organização sem mover arquivos, executar a organização em pastas categorizadas, e gerenciar arquivos duplicados de forma segura, movendo-os para a lixeira do sistema.
# É uma ferramenta universal, projetada para ser usada por qualquer pessoa, independente do nível técnico.

# COMENTÁRIOS
#1: Função de verificação de dependências. Garante que as ferramentas 'dialog' e 'fdupes' estejam instaladas antes da execução, informando o usuário como instalá-las caso estejam ausentes.
#2: Definição de variáveis globais. Define o diretório de destino padrão e o local do arquivo de log.
#3: O "Mapa de Organização". Um array associativo que define para qual pasta cada grupo de extensões de arquivo deve ser movido. É o cérebro da categorização.
#4: A função do menu principal. Usa 'dialog' para criar a interface de texto interativa, apresentando as opções ao usuário.
#5: Função para definir a pasta de destino. Permite que o usuário altere o diretório padrão '~/Organizado' para qualquer outro de sua escolha.
#6: A função principal de processamento de arquivos. Centraliza a lógica para encontrar e lidar com os arquivos, operando em modo de "simulação" ou "movimentação".
#7: O comando 'find'. É o núcleo da busca por arquivos. A construção '-path "$DEST_DIR" -prune -o' é crucial: ela instrui o 'find' a ignorar (podar) o diretório de destino, evitando que o script organize arquivos que já foram organizados.
#8: Lógica de execução. Dependendo do modo ("simulate" ou "move"), o script apenas relata a ação ou executa o comando 'mv -n' (-n para não sobrescrever arquivos existentes no destino).
#9: Função para gerenciar duplicatas. Usa 'fdupes' para encontrar arquivos idênticos dentro da pasta de destino.
#10: Interação e segurança no gerenciamento de duplicatas. O script formata a saída do 'fdupes' em uma lista de verificação interativa ('dialog --checklist'), permitindo que o usuário selecione quais cópias deseja enviar para a lixeira do sistema usando 'gio trash', uma alternativa muito mais segura que o 'rm'.
#11: O loop de execução principal. Mantém o menu ativo, aguardando a escolha do usuário e direcionando para a função apropriada através de uma estrutura 'case'.

# CÓDIGO
#!/bin/bash
#1
check_dependencies() {
    for cmd in dialog fdupes; do
        if ! command -v "$cmd" &> /dev/null; then
            dialog --title "Erro de Dependência" --msgbox "A ferramenta '$cmd' não foi encontrada. Por favor, instale-a para continuar.\n\nEm sistemas Debian/Ubuntu, use: sudo apt install $cmd" 8 70
            exit 1
        fi
    done
}

#2
DEST_DIR="$HOME/Organizado"
LOG_FILE="$HOME/log_arquiteto_de_diretorios.txt"

#3
declare -A CATEGORIAS=(
    ["Imagens"]="jpg jpeg png gif svg webp"
    ["Videos"]="mp4 mkv mov wmv avi flv webm"
    ["Audios"]="mp3 ogg wav flac aac"
    ["Documentos"]="pdf doc docx odt ods odp txt md"
    ["Planilhas"]="xls xlsx csv"
    ["Compactados"]="zip rar 7z tar gz bz2 xz"
    ["Executaveis"]="deb appimage exe sh"
    ["Fontes"]="ttf otf"
)

#4
main_menu() {
    dialog --clear --backtitle "Arquiteto de Diretórios - Guardião da Ordem" \
    --title "Menu Principal" \
    --menu "Pasta de destino atual: $DEST_DIR\n\nEscolha sua ação:" 15 70 5 \
    1 "Simular Organização (Ver o que será movido)" \
    2 "Executar Organização (Mover Arquivos)" \
    3 "Gerenciar Duplicatas (Na pasta de destino)" \
    4 "Definir Pasta de Destino" \
    0 "Sair" 2>&1 >/dev/tty
}

#5
set_destination() {
    local new_path
    new_path=$(dialog --title "Definir Pasta de Destino" --inputbox "Digite o caminho completo para a pasta onde os arquivos serão organizados:" 8 70 "$DEST_DIR" 2>&1 >/dev/tty)
    if [ $? -eq 0 ]; then
        DEST_DIR="$new_path"
        dialog --title "Sucesso" --msgbox "A pasta de destino foi atualizada para:\n$DEST_DIR" 6 70
    fi
}

#6
process_files() {
    local mode="$1"
    local report_file
    report_file=$(mktemp)
    
    local file_count=0
    local search_paths=("$HOME" "$HOME/Downloads")

    echo "Relatório de Organização - $(date)" > "$LOG_FILE"
    echo "Modo: $mode" >> "$LOG_FILE"
    echo "Pasta de Destino: $DEST_DIR" >> "$LOG_FILE"
    echo "-------------------------------------" >> "$LOG_FILE"

    for pasta in "${!CATEGORIAS[@]}"; do
        mkdir -p "$DEST_DIR/$pasta"
    done

    for category in "${!CATEGORIAS[@]}"; do
        for ext in ${CATEGORIAS[$category]}; do
            #7
            find "${search_paths[@]}" -maxdepth 1 -path "$DEST_DIR" -prune -o -type f -iname "*.$ext" -print | while read -r file; do
                ((file_count++))
                local dest_path="$DEST_DIR/$category/$(basename "$file")"
                #8
                if [ "$mode" == "simulate" ]; then
                    echo "Moveria: '$file' ---> '$dest_path'" >> "$report_file"
                elif [ "$mode" == "move" ]; then
                    mv -n "$file" "$dest_path"
                    echo "Movido: '$file' ---> '$dest_path'" >> "$LOG_FILE"
                fi
            done
        done
    done

    if [ "$mode" == "simulate" ]; then
        if [ "$file_count" -gt 0 ]; then
            dialog --title "Relatório da Simulação" --textbox "$report_file" 20 80
        else
            dialog --title "Relatório da Simulação" --msgbox "Nenhum arquivo para organizar foi encontrado em seu Desktop ou em Downloads." 6 70
        fi
    elif [ "$mode" == "move" ]; then
        dialog --title "Organização Concluída" --msgbox "Processo finalizado. $file_count arquivos foram processados.\n\nUm log detalhado foi salvo em:\n$LOG_FILE" 8 70
    fi
    rm -f "$report_file"
}

#9
manage_duplicates() {
    if [ ! -d "$DEST_DIR" ] || [ -z "$(ls -A "$DEST_DIR")" ]; then
        dialog --title "Aviso" --msgbox "A pasta de destino '$DEST_DIR' não existe ou está vazia. Não há duplicatas para gerenciar." 8 70
        return
    fi

    dialog --title "Aviso Importante" --infobox "Procurando por arquivos duplicados... Isso pode levar um tempo." 5 70
    
    local fdupes_output
    fdupes_output=$(mktemp)
    fdupes -rS "$DEST_DIR" > "$fdupes_output"

    if [ ! -s "$fdupes_output" ]; then
        dialog --title "Gerenciar Duplicatas" --msgbox "Nenhum arquivo duplicado encontrado em '$DEST_DIR'." 6 70
        rm -f "$fdupes_output"
        return
    fi
    
    #10
    local checklist_items=()
    while read -r line; do
        if [[ -n "$line" && -f "$line" ]]; then
            checklist_items+=("$line" "" "ON")
        fi
    done < <(tail -n +2 "$fdupes_output" | grep -v '^$')

    if [ ${#checklist_items[@]} -eq 0 ]; then
         dialog --title "Gerenciar Duplicatas" --msgbox "Nenhum arquivo duplicado encontrado." 6 70
         return
    fi

    local files_to_trash
    files_to_trash=$(dialog --title "Gerenciador de Duplicatas" --checklist "Selecione os arquivos duplicados que você deseja mover para a lixeira. O PRIMEIRO arquivo de cada grupo será mantido." 20 80 15 "${checklist_items[@]}" 2>&1 >/dev/tty)
    
    if [ $? -ne 0 ]; then
        dialog --title "Cancelado" --msgbox "Nenhuma ação foi tomada." 5 70
        return
    fi

    for file in $files_to_trash; do
        gio trash "$file"
        echo "Movido para a lixeira: $file" >> "$LOG_FILE"
    done
    dialog --title "Concluído" --msgbox "Os arquivos selecionados foram movidos para a lixeira." 6 70
    rm -f "$fdupes_output"
}

#11
check_dependencies
while true; do
    choice=$(main_menu)
    case $choice in
        1) process_files "simulate" ;;
        2) dialog --title "Confirmação" --yesno "Você tem certeza que deseja mover os arquivos permanentemente? Recomenda-se executar a simulação primeiro." 8 70 
           if [ $? -eq 0 ]; then
                process_files "move"
           fi
           ;;
        3) manage_duplicates ;;
        4) set_destination ;;
        0) break ;;
    esac
done

clear
echo "Arquiteto de Diretórios finalizado."

# CITAÇÃO
# "A vida, a liberdade e a propriedade não existem porque os homens fizeram leis. Pelo contrário, foi o fato de a vida, a liberdade e a propriedade existirem de antemão que levou os homens a fazerem leis, em primeiro lugar." - Frédéric Bastiat
