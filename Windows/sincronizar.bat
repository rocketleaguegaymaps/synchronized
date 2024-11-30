@echo off
:: ============================================
::          SCRIPT DE GERENCIAMENTO GIT
:: ============================================
:: Este script fornece um menu interativo para realizar
:: operacoes Git no repositorio especificado.
:: As opcoes disponiveis sao:
:: 1. Upload: git add ., git commit -m "maps", git push
:: 2. Download: git pull
:: 3. Sair
:: ============================================

:: ==============================
::      CONFIGURACAO DO REPO
:: ==============================

:: Definir o diretorio do repositorio.
:: Substitua o caminho abaixo pelo caminho do seu repositorio Git.
set "REPO_DIR=C:\Program Files\Epic Games\rocketleague\TAGame\CookedPCConsole\mods\synchronized"

:: Verificar se a variavel REPO_DIR esta definida
if "%REPO_DIR%"=="" (
    echo [ERRO] A variavel REPO_DIR nao esta definida.
    echo Por favor, defina a variavel de ambiente REPO_DIR ou edite o script para incluir o caminho do repositorio.
    pause
    exit /b
)

:: Navegar para o diretorio do repositorio
pushd "%REPO_DIR%" >nul 2>&1
if errorlevel 1 (
    echo [ERRO] Falha ao acessar o diretorio: %REPO_DIR%
    pause
    exit /b
)

:: ==============================
::           MENU
:: ==============================

:MENU
cls
echo ===================================
echo           MENU DE MAPAS
echo ===================================
echo.
echo 1. UPLOAD  - Adicionar, Comitar e Enviar mudancas
echo 2. DOWNLOAD - Baixar as ultimas mudancas
echo 3. SAIR    - Encerrar o script
echo.
set /p choice=Escolha uma opcao (1, 2, 3): 

:: Processar a escolha do usuario
if "%choice%"=="1" goto OPTION1
if "%choice%"=="2" goto OPTION2
if "%choice%"=="3" goto END
echo.
echo [AVISO] Opcao invalida. Por favor, tente novamente.
pause
goto MENU

:: ==============================
::        OPCAO 1: UPLOAD
:: ==============================

:OPTION1
cls
echo ===================================
echo           EXECUTANDO UPLOAD
echo ===================================
echo.
:: Adicionar todas as mudancas
echo [INFO] Executando: git add .
git add . 
if errorlevel 1 (
    echo [ERRO] Falha ao executar git add.
    pause
    goto MENU
)

:: Comitar as mudancas com a mensagem "maps"
echo [INFO] Executando: git commit -m "maps"
git commit -m "maps"
if errorlevel 1 (
    echo [ERRO] Falha ao executar git commit.
    pause
    goto MENU
)

:: Enviar as mudancas para o repositorio remoto
echo [INFO] Executando: git push
git push
if errorlevel 1 (
    echo [ERRO] Falha ao executar git push.
    pause
    goto MENU
)

echo.
echo [SUCESSO] Upload concluido com sucesso!
pause
goto MENU

:: ==============================
::        OPCAO 2: DOWNLOAD
:: ==============================

:OPTION2
cls
echo ===================================
echo           EXECUTANDO DOWNLOAD
echo ===================================
echo.
:: Baixar as ultimas mudancas do repositorio remoto
echo [INFO] Executando: git pull
git pull
if errorlevel 1 (
    echo [ERRO] Falha ao executar git pull.
    pause
    goto MENU
)

echo.
echo [SUCESSO] Download concluido com sucesso!
pause
goto MENU

:: ==============================
::            SAIR
:: ==============================

:END
cls
echo ===================================
echo            ENCERRANDO SCRIPT
echo ===================================
echo.
echo Ate logo! :)
popd >nul
pause
exit
