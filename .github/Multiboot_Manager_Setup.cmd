echo off
chcp 65001 > NUL
setlocal enabledelayedexpansion
title Multiboot_Manager Setup │ OgnitorenKs
mode con cols=80 lines=30
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (set R=%%b)
cd /d "%~dp0"
for /f %%a in ('"cd"') do set Konum=%%a

:: -------------------------------------------------------------
RD /S /Q "C:\Multiboot_Manager" > NUL 2>&1
MD "C:\Multiboot_Manager" > NUL 2>&1

:: =============================================================
:: Güncelleme dosyası indirilir
cls&Call :Panel "[■■■■■■■■■■■■                                    ]" "%R%[92m  Installing Multiboot_Manager...   %R%[0m"
Call :Powershell "& { iwr https://raw.githubusercontent.com/OgnitorenKs12/Multiboot_Manager/main/.github/Multiboot_Manager.zip -OutFile %temp%\Multiboot_Manager.zip }"

:: İndirilen güncelleme zip dosyası klasörü çıkarılır.
cls&Call :Panel "[■■■■■■■■■■■■■■■■■■■■■■■■                        ]" "%R%[92m  Installing Multiboot_Manager...   %R%[0m"
Call :Powershell "Expand-Archive -Force '%temp%\Multiboot_Manager.zip' 'C:\Multiboot_Manager'"

:: Güncelleme zip dosyası silinir.
cls&Call :Panel "[■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■            ]" "%R%[92m  Installing Multiboot_Manager...   %R%[0m"
DEL /F /Q /A "%temp%\Multiboot_Manager.zip" > NUL 2>&1

(
echo Set oWS = WScript.CreateObject^("WScript.Shell"^)
echo sLinkFile = "C:\Users\%username%\Desktop\Multiboot_Manager.lnk"
echo Set oLink = oWS.CreateShortcut^(sLinkFile^)
echo oLink.TargetPath = "C:\Multiboot_Manager\Multiboot_Manager.cmd"
echo oLink.WorkingDirectory = "C:\Multiboot_Manager"
echo oLink.Description = "Multiboot_Manager"
echo oLink.IconLocation = "C:\Multiboot_Manager\Bin\Icon\Ogni.ico"
echo oLink.Save
) > %Temp%\OgnitorenKs.Shortcut.vbs
cscript "%Temp%\OgnitorenKs.Shortcut.vbs" > NUL 2>&1
DEL /F /Q /A "%Temp%\OgnitorenKs.Shortcut.vbs" > NUL 2>&1

:: Settings.ini içine güncelleme tarihi yazılır.
cls&Call :Panel "[■■■■■■■■■■■■■■■■■■■■COMPLETE■■■■■■■■■■■■■■■■■■■■]" "%R%[92m  Installing Multiboot_Manager...   %R%[0m"
:: Güncel Toolbox açılır.
Call :Powershell "Start-Process 'C:\Multiboot_Manager\Multiboot_Manager.cmd' -Verb Runas"
exit
:: =============================================================
:: ██████████████████████████████████████████████████████████████████████████████████████████████████
:: ██████████████████████████████████████████████████████████████████████████████████████████████████
:: ██████████████████████████████████████████████████████████████████████████████████████████████████
:Panel
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo                     %~2
echo.            
echo               %~1
echo.
echo             %R%[33m████ ████ █   █ █ █████ ████ ████ ███ █   █ █  █ ████%R%[0m
echo             %R%[33m█  █ █    ██  █ █   █   █  █ █  █ █   ██  █ █ █  █   %R%[0m
echo             %R%[33m█  █ █ ██ █ █ █ █   █   █  █ ████ ██  █ █ █ ██   ████%R%[0m
echo             %R%[33m█  █ █  █ █  ██ █   █   █  █ █ █  █   █  ██ █ █     █%R%[0m
echo             %R%[33m████ ████ █   █ █   █   ████ █  █ ███ █   █ █  █ ████%R%[0m
goto :eof

:: -------------------------------------------------------------
:Powershell
chcp 437 > NUL 2>&1
Powershell -command %*
chcp 65001 > NUL 2>&1
goto :eof


