@echo off
setlocal enabledelayedexpansion
title Minecraft Multiplayer Fixer

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Ошибка: Требуются права администратора.
    echo Запустите файл правой кнопкой мыши -> От имени администратора.
    pause >nul
    exit /b
)

set "HOSTS_PATH=%SystemRoot%\System32\drivers\etc\hosts"
set "DOMAINS=api.minecraftservices.com authserver.mojang.com sessionserver.mojang.com api.mojang.com"

:menu
cls
echo ------------------------------------------------------
echo       Minecraft Multiplayer Fix 
echo ------------------------------------------------------
echo  1. Применить фикс (изменить hosts)
echo  2. Откатить изменения (очистить hosts)
echo  3. Выход
echo ------------------------------------------------------
set /p choice="Выберите вариант (1-3): "

if "%choice%"=="1" goto install
if "%choice%"=="2" goto uninstall
if "%choice%"=="3" exit
goto menu

:install
echo.
echo Применение изменений...
for %%D in (%DOMAINS%) do (
    findstr /I /C:"%%D" "%HOSTS_PATH%" >nul
    if errorlevel 1 (
        echo 127.0.0.1 %%D >> "%HOSTS_PATH%"
        echo Добавлено: %%D
    ) else (
        echo Пропуск: %%D уже есть в файле.
    )
)
goto finalize

:uninstall
echo.
echo Удаление записей...
set "TEMP_HOSTS=%temp%\hosts_new"
type "%HOSTS_PATH%" | findstr /V /I "mojang.com minecraftservices.com" > "%TEMP_HOSTS%"
move /y "%TEMP_HOSTS%" "%HOSTS_PATH%" >nul
echo Файл hosts приведен в исходное состояние.
goto finalize

:finalize
ipconfig /flushdns >nul
echo Операция завершена. Нажмите любую клавишу для возврата в меню.
pause >nul
goto menu
