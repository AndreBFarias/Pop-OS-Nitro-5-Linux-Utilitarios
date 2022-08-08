#1
import os
import subprocess

fontconfig_dir = os.path.expanduser("~/.config/fontconfig/conf.d/")
if not os.path.exists(fontconfig_dir):
    print(f"Diretório {fontconfig_dir} não encontrado. Criando...")
    os.makedirs(fontconfig_dir)
    print("Diretório criado com sucesso.")
else:
    print(f"Diretório {fontconfig_dir} já existe. Prosseguindo.")

#2
config_file_path = os.path.join(fontconfig_dir, "99-custom.conf")
print(f"Criando o arquivo de configuração em {config_file_path}...")

#3
xml_content = """<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
    <match>
        <edit name="family" mode="prepend">
            <string>Fira Code Nerd Font</string>
        </edit>
    </match>
    <match target="pattern">
        <test name="family">
            <string>sans-serif</string>
        </test>
        <edit name="family" mode="assign">
            <string>Roboto Slab</string>
            <string>Fira Sans SemiBold</string>
        </edit>
    </match>
    <match target="pattern">
        <test name="family">
            <string>serif</string>
        </test>
        <edit name="family" mode="assign">
            <string>Roboto Slab</string>
            <string>Fira Sans SemiBold</string>
        </edit>
    </match>
</fontconfig>
"""

with open(config_file_path, "w") as f:
    f.write(xml_content)
print("Arquivo de configuração '99-custom.conf' criado com sucesso.")

#4
print("Atualizando o cache de fontes do sistema...")
try:
    subprocess.run(["fc-cache", "-fv"], check=True)
    print("Cache de fontes atualizado. Por favor, reinicie seu ambiente gráfico ou faça logout para ver as mudanças.")
except FileNotFoundError:
    print("O comando 'fc-cache' não foi encontrado. Certifique-se de que o pacote 'fontconfig' está instalado.")
except subprocess.CalledProcessError as e:
    print(f"Ocorreu um erro ao executar o 'fc-cache': {e}")
