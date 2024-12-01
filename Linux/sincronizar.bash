#!/bin/bash
# ============================================
#        SCRIPT DE GERENCIAMENTO GIT
# ============================================
# Este script fornece um menu interativo para realizar
# operações Git no repositório especificado.
# As opções disponíveis são:
# 1. Upload: git add ., git commit -m "maps", git push
# 2. Download: git pull
# 3. Sair
# Antes de qualquer operação, verifica a autenticação SSH.
# ============================================

# ==============================
#      CONFIGURAÇÃO DO REPO
# ==============================

# Definir o diretório do repositório.
REPO_DIR="/home/pedro/Games/rocket-league/drive_c/Program Files/Epic Games/rocketleague/TAGame/CookedPCConsole/mods/synchronized/Maps/"

# Verificar se a variável REPO_DIR está definida
if [ -z "$REPO_DIR" ]; then
    echo "[ERRO] A variável REPO_DIR não está definida."
    echo "Por favor, edite o script para incluir o caminho do repositório."
    read -p "Pressione Enter para sair..."
    exit 1
fi

# ==============================
#    VERIFICAÇÃO DE AUTENTICAÇÃO SSH
# ==============================

echo "Verificando a autenticação SSH com o GitHub..."
ssh_output=$(ssh -T git@github.com 2>&1)
ssh_exit_status=$?

if [ $ssh_exit_status -ne 1 ]; then
    echo "[ERRO] Falha na autenticação SSH com o GitHub."
    echo "Por favor, verifique se sua chave SSH está configurada corretamente."
    echo "Consulte: https://docs.github.com/en/authentication/connecting-to-github-with-ssh"
    read -p "Pressione Enter para sair..."
    exit 1
else
    echo "[SUCESSO] Autenticação SSH com o GitHub foi bem-sucedida."
fi

# ==============================
#    NAVEGAR PARA O REPOSITÓRIO
# ==============================

if ! cd "$REPO_DIR"; then
    echo "[ERRO] Falha ao acessar o diretório: $REPO_DIR"
    read -p "Pressione Enter para sair..."
    exit 1
fi

# ==============================
#           MENU
# ==============================

while true; do
    clear
    echo "==================================="
    echo "           MENU DE MAPAS"
    echo "==================================="
    echo
    echo "1. UPLOAD    - Adicionar, Comitar e Enviar mudanças"
    echo "2. DOWNLOAD  - Baixar as últimas mudanças"
    echo "3. SAIR      - Encerrar o script"
    echo
    read -p "Escolha uma opção (1, 2, 3): " choice

    case "$choice" in
        1)
            # ==============================
            #        OPÇÃO 1: UPLOAD
            # ==============================
            clear
            echo "==================================="
            echo "          EXECUTANDO UPLOAD"
            echo "==================================="
            echo

            # Sincronizar branch local com remoto
            echo "[INFO] Sincronizando com o branch remoto..."
            git pull origin main --rebase
            if [ $? -ne 0 ]; then
                echo "[ERRO] Falha ao sincronizar com o branch remoto."
                read -p "Pressione Enter para retornar ao menu..."
                continue
            fi

            # Adicionar todas as mudanças
            echo "[INFO] Executando: git add ."
            git add .
            if [ $? -ne 0 ]; then
                echo "[ERRO] Falha ao executar git add."
                read -p "Pressione Enter para retornar ao menu..."
                continue
            fi

            # Comitar as mudanças com a mensagem "maps"
            echo "[INFO] Executando: git commit -m \"maps\""
            git commit -m "maps"
            if [ $? -ne 0 ]; then
                echo "[ERRO] Falha ao executar git commit. Verifique se há mudanças para comitar."
                read -p "Pressione Enter para retornar ao menu..."
                continue
            fi

            # Enviar as mudanças para o repositório remoto
            echo "[INFO] Executando: git push"
            git push
            if [ $? -ne 0 ]; then
                echo "[ERRO] Falha ao executar git push."
                read -p "Pressione Enter para retornar ao menu..."
                continue
            fi

            echo
            echo "[SUCESSO] Upload concluído com sucesso!"
            read -p "Pressione Enter para retornar ao menu..."
            ;;
        2)
            # ==============================
            #        OPÇÃO 2: DOWNLOAD
            # ==============================
            clear
            echo "==================================="
            echo "          EXECUTANDO DOWNLOAD"
            echo "==================================="
            echo

            # Baixar as últimas mudanças do repositório remoto
            echo "[INFO] Executando: git pull"
            git pull
            if [ $? -ne 0 ]; then
                echo "[ERRO] Falha ao executar git pull."
                read -p "Pressione Enter para retornar ao menu..."
                continue
            fi

            echo
            echo "[SUCESSO] Download concluído com sucesso!"
            read -p "Pressione Enter para retornar ao menu..."
            ;;
        3)
            # ==============================
            #            SAIR
            # ==============================
            clear
            echo "==================================="
            echo "           ENCERRANDO SCRIPT"
            echo "==================================="
            echo
            echo "Até logo! :)"
            exit 0
            ;;
        *)
            echo
            echo "[AVISO] Opção inválida. Por favor, tente novamente."
            read -p "Pressione Enter para continuar..."
            ;;
    esac
done
