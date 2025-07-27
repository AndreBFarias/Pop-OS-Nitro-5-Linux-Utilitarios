### ARQUIVO: restaurador_audio_pipewire.sh ###
==================================================

# DESCRIÇÃO
# Um script de reparo focado no subsistema de áudio PipeWire.
# Ele foi criado para reverter uma tentativa de instalação de um plugin de supressão de ruído que corrompeu as configurações, mas serve como um reset geral do PipeWire.
# Remove arquivos de configuração e plugins conflitantes, reinstala os pacotes principais do PipeWire e reinicia seus serviços.

# COMENTÁRIOS
#1: Remove o diretório e o arquivo de plugin (.so) de uma instalação manual de 'noise-suppression-for-voice'.
#2: Remove o arquivo de configuração customizado do PipeWire que ativava o plugin.
#3: Atualiza a lista de pacotes e reinstala forçadamente os componentes centrais do PipeWire e suas camadas de compatibilidade (ALSA, PulseAudio, JACK).
#4: Reinicia os serviços do PipeWire a nível de usuário para aplicar as configurações limpas.
#5: Informa ao usuário que o processo foi concluído e sugere os próximos passos para verificação manual.

# CÓDIGO
#!/bin/bash
echo "Iniciando processo de restauração do sistema de áudio PipeWire..."

echo "[1/4] Removendo configurações e plugins conflitantes..."
#1
rm -rf ~/noise-suppression-for-voice
sudo rm -f /usr/local/lib/librnnoise_ladspa.so
#2
rm -f ~/.config/pipewire/pipewire.conf.d/99-input-denoising.conf

echo "[2/4] Reinstalando pacotes de áudio essenciais..."
#3
sudo apt update
sudo apt install --reinstall pipewire pipewire-alsa pipewire-pulse pipewire-jack -y

echo "[3/4] Reiniciando serviços de áudio..."
#4
systemctl --user restart pipewire.service
systemctl --user restart pipewire-pulse.service

echo "[4/4] Processo de restauração concluído."
#5
echo "-------------------------------------------------------------------"
echo "Verifique as configurações de 'Som' do sistema ou use 'pavucontrol'"
echo "para confirmar que seus dispositivos de áudio estão funcionando."
echo "-------------------------------------------------------------------"

# CITAÇÃO
# "Não se pode pisar duas vezes no mesmo rio." - Heráclito
### ARQUIVO: restaurador_audio_pipewire.sh ###
==================================================

# DESCRIÇÃO
# Um script de reparo focado no subsistema de áudio PipeWire.
# Ele foi criado para reverter uma tentativa de instalação de um plugin de supressão de ruído que corrompeu as configurações, mas serve como um reset geral do PipeWire.
# Remove arquivos de configuração e plugins conflitantes, reinstala os pacotes principais do PipeWire e reinicia seus serviços.

# COMENTÁRIOS
#1: Remove o diretório e o arquivo de plugin (.so) de uma instalação manual de 'noise-suppression-for-voice'.
#2: Remove o arquivo de configuração customizado do PipeWire que ativava o plugin.
#3: Atualiza a lista de pacotes e reinstala forçadamente os componentes centrais do PipeWire e suas camadas de compatibilidade (ALSA, PulseAudio, JACK).
#4: Reinicia os serviços do PipeWire a nível de usuário para aplicar as configurações limpas.
#5: Informa ao usuário que o processo foi concluído e sugere os próximos passos para verificação manual.

# CÓDIGO
#!/bin/bash
echo "Iniciando processo de restauração do sistema de áudio PipeWire..."

echo "[1/4] Removendo configurações e plugins conflitantes..."
#1
rm -rf ~/noise-suppression-for-voice
sudo rm -f /usr/local/lib/librnnoise_ladspa.so
#2
rm -f ~/.config/pipewire/pipewire.conf.d/99-input-denoising.conf

echo "[2/4] Reinstalando pacotes de áudio essenciais..."
#3
sudo apt update
sudo apt install --reinstall pipewire pipewire-alsa pipewire-pulse pipewire-jack -y

echo "[3/4] Reiniciando serviços de áudio..."
#4
systemctl --user restart pipewire.service
systemctl --user restart pipewire-pulse.service

echo "[4/4] Processo de restauração concluído."
#5
echo "-------------------------------------------------------------------"
echo "Verifique as configurações de 'Som' do sistema ou use 'pavucontrol'"
echo "para confirmar que seus dispositivos de áudio estão funcionando."
echo "-------------------------------------------------------------------"

# CITAÇÃO
# "Não se pode pisar duas vezes no mesmo rio." - Heráclito
