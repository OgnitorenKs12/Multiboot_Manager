:: ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
::
::       ██████   ██████   ██    ██ ████ ████████  ██████  ████████  ████████ ██    ██ ██    ██  ██████
::      ██    ██ ██    ██  ███   ██  ██     ██    ██    ██ ██     ██ ██       ███   ██ ██   ██  ██    █
::      ██    ██ ██        ████  ██  ██     ██    ██    ██ ██     ██ ██       ████  ██ ██  ██   ██     
::      ██    ██ ██   ████ ██ ██ ██  ██     ██    ██    ██ ████████  ██████   ██ ██ ██ █████      ██████
::      ██    ██ ██    ██  ██  ████  ██     ██    ██    ██ ██   ██   ██       ██  ████ ██  ██         ██
::      ██    ██ ██    ██  ██   ███  ██     ██    ██    ██ ██    ██  ██       ██   ███ ██   ██  ██    ██
::       ██████   ██████   ██    ██ ████    ██     ██████  ██     ██ ████████ ██    ██ ██    ██  ██████ 

::  ► Hazırlayan: Hüseyin UZUNYAYLA / OgnitorenKs
::
::  ► İletişim - Contact;
::  --------------------------------------
::  •    Mail: ognitorenks@gmail.com
::  •    Site: https://ognitorenks.blogspot.com
::
:: ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
:Multiboot_Manager
echo off
chcp 65001 > NUL 2>&1
setlocal enabledelayedexpansion
cls
title Multiboot Manager_v4.2 │ OgnitorenKs

REM -------------------------------------------------------------
REM Renklendirm için gerekli
FOR /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E#&for %%b in (1) do rem"') do (set R=%%b)

REM -------------------------------------------------------------
cd /d "%~dp0"
FOR /F "tokens=*" %%a in ('cd') do (set Konum=%%a)
REM Değişkenler
set NSudo="%Konum%\Bin\NSudo.exe" -U:T -P:E -Wait -ShowWindowMode:hide cmd /c
set Error=NT

REM -------------------------------------------------------------
REM Yönetici yetkisi
reg query "HKU\S-1-5-19" > NUL 2>&1
	if !errorlevel! NEQ 0 (Call :Powershell "Start-Process '%Konum%\Multiboot_Manager.cmd' -Verb Runas"&exit
)

REM -------------------------------------------------------------
FOR %%a in (Config DiskDevice DiskMenu DiskMenu) do (DEL /F /Q /A "%Konum%\%%a.txt" > NUL 2>&1)

REM -------------------------------------------------------------
REM Settings.ini dosyası içine dil bilgisi kayıtlı ise onu alır. Yok ise sistem varsayılan diline göre atama yapar.
Findstr /i "Language_Pack" %Konum%\Settings.ini > NUL 2>&1
	if !errorlevel! NEQ 0 (FOR /F "tokens=6" %%a in ('Dism /online /Get-intl ^| Find /I "Default system UI language"') do (set DefaultLang=%%a)
						   if "!DefaultLang!" EQU "tr-TR" (echo. >> %Konum%\Settings.ini
														   echo ► Language_Pack^= Turkish >> %Konum%\Settings.ini
														   set Dil=%Konum%\Bin\Language\Turkish.cmd
														  )
						   if "!DefaultLang!" NEQ "tr-TR" (echo. >> %Konum%\Settings.ini
														   echo ► Language_Pack= English >> %Konum%\Settings.ini
														   set Dil=%Konum%\Bin\Language\English.cmd
														  ) 
						  )
	if !errorlevel! EQU 0 (FOR /F "tokens=3" %%a in ('Findstr /i "Language_Pack" %Konum%\Settings.ini') do (set Dil=%Konum%\Bin\Language\%%a.cmd))
REM -------------------------------------------------------------
Call :Path_Check "%Konum%"
	if "!Error!" EQU "X" (exit)

REM █████████████████████████████████████████████████████████████
:Menu
mode con cols=70 lines=15
echo.
Call :Dil A 2 Title_1_&echo ►%R%[96m !LA2! %R%[0m
echo.
FOR /L %%a in (1,1,4) do (
	FOR /F "delims=> tokens=2" %%b in ('Findstr /i "Menu_%%a_" !Dil! 2^>NUL') do (
		echo   %R%[32m%%a%R%[90m-%R%[33m %%b %R%[0m
	)
)
Call :Dil A 2 Value_1_&echo.&set /p Menu=►%R%[32m !LA2!: %R%[0m
	if "!Menu!" EQU "1" (goto VHD_Maker)
	if "!Menu!" EQU "2" (goto Image_Manager)
	if "!Menu!" EQU "3" (goto VHD_Redifine)
	if "!Menu!" EQU "4" (goto VHD_Size)
goto Menu

REM -------------------------------------------------------------
:VHD_Maker
mode con cols=100 lines=25
REM VHD hangi isimle 
Call :Dil A 2 Value_3_&echo.&set /p Road=►%R%[32m !LA2!: %R%[0m
echo !Road! | Findstr /i ".vhd" > NUL 2>&1
	if "!errorlevel!" NEQ "0" (set Road=!Road!.vhd)
Call :Dil A 2 Value_2_&echo.&set /p Size=►%R%[32m !LA2!: %R%[0m
set /a Size=!Size! * 1024
REM Disk yapılandırma türünü kullanıcıya soruyorum.
Call :Dil A 2 Title_2_&echo.&echo ►%R%[96m !LA2! %R%[0m
echo  %R%[32m 1%R%[90m-%R%[33m MBR %R%[0m
echo  %R%[32m 2%R%[90m-%R%[33m GPT %R%[0m
Call :Dil A 2 Value_1_&echo.&set /p Type=►%R%[32m !LA2!: %R%[0m
	if "!Type!" EQU "1" (set Type=MBR)
	if "!Type!" EQU "2" (set Type=GPT)
(
echo create vdisk file="!Road!" maximum=!Size! type=fixed
echo attach vdisk
) > %Konum%\Config.txt
if "!Type!" EQU "GPT" (echo convert gpt >> %Konum%\Config.txt)
REM VHD adını kullanıcı vermek isterse diye sorguluyorum.
set VHD_Name=VHD-!Random!
Call :Dil A 2 Text_3_&echo.&set /p VHD_Sor=►%R%[32m !LA2! %R%[90m[%R%[33m Y %R%[90m│%R%[33m N %R%[90m]: %R%[0m
Call :Upper !VHD_Sor! VHD_Sor
	if "!VHD_Sor!" NEQ "Y" (Call :Dil A 2 Value_6_&echo.
	                        set /p VHD_Name=►%R%[36m !LA2!: %R%[0m
						   )
(
echo create part primary
echo format quick label="!VHD_Name!"
) >> %Konum%\Config.txt
set VHD_Sor=
set VHD_Name=
REM Açılışta vhd görünür hale getirilmesiyle alakalı kullanıcıya soru yöneltiyorum
Call :Dil A 2 Value_7_&echo.&set /p VHD_Sor=►%R%[32m !LA2! %R%[90m[%R%[33m Y %R%[90m│%R%[33m N %R%[90m]: %R%[0m
Call :Upper !VHD_Sor! VHD_Sor
set VHD_Logon=VHD_%Random%_Enable
	if "!VHD_Sor!" EQU "Y" ((
	                        echo echo off
							echo chcp 65001
							echo setlocal enabledelayedexpansion
							echo cls
							echo ^(
	                        echo echo select vdisk file="!Road!"
	                        echo echo attach vdisk
	                        echo echo exit
							echo ^) ^> %%AppData%%\!VHD_Logon!.txt
							echo diskpart /s %%AppData%%\!VHD_Logon!.txt
							echo DEL /F /Q /A "%%AppData%%\!VHD_Logon!.txt" ^> NUL 2^>^&1
							) > C:\Users\%Username%\Desktop\!VHD_Logon!.cmd
						   )
REM VHD oluşturma bölümü
Call :Dil A 2 Title_3_&cls&echo.&echo %R%[33m !LA2! %R%[0m
Call :Powershell "Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object -Property DeviceID" > %Konum%\DiskDevice.txt
set Error=0
FOR %%a in (J K L M N P R S T V Y Z) do (
	if "!Error!" EQU "0" (Call :Disk_Harf_Kontrol %%a)
)
(
echo assign letter=!Harf!
echo exit
) >> %Konum%\Config.txt
diskpart /s %Konum%\Config.txt
Call :Dil A 2 Text_2_&echo.&echo ►%R%[92m !LA2! %R%[0m
DEL /F /Q /A "%Konum%\Config.txt" > NUL 2>&1
Call :Bekle 2
goto Menu

REM -------------------------------------------------------------
:Image_Manager
mode con cols=100 lines=25
Call :Dil A 2 Title_4_&echo ►%R%[96m !LA2! %R%[0m
echo.&Call :Install_Road
Call :ModeLong&mode con cols=130 lines=!Mode!
Call :OgnitorenKs.Reader "!MainWim!" echo :: :: :: :: ::
	if "!Error!" EQU "X" (goto Menu)
set Index=NT
Call :Dil A 2 Value_1_&set /p Index=►%R%[32m !LA2!: %R%[0m
mode con cols=100 lines=23
DEL /F /Q /A "%Konum%\DiskMenu.txt" > NUL 2>&1
set Count=0
Call :Powershell "Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object -Property DeviceID,VolumeName | FL" > %Konum%\DiskDevice.txt
FOR /F "tokens=3" %%a in ('Findstr /i "DeviceID" %Konum%\DiskDevice.txt 2^>NUL') do (
	set /a Count+=1
	echo DDisk_Harf_!Count!_^>%%a^> >> %Konum%\DiskMenu.txt
)
set Count=0
FOR /F "delims=':' tokens=2" %%a in ('Findstr /i "VolumeName" %Konum%\DiskDevice.txt 2^>NUL') do (
	set /a Count+=1
	set Value=%%a
	set Value=!Value:~1!
	echo DDisk_Name_!Count!_^>!Value!^> >> %Konum%\DiskMenu.txt
)
Call :Dil A 2 Title_5_&echo ►%R%[96m !LA2! %R%[0m&echo.
FOR /L %%a in (1,1,!Count!) do (
	FOR /F "delims=> tokens=2" %%b in ('Findstr /i "DDisk_Harf_%%a_" %Konum%\DiskMenu.txt 2^>NUL') do (
		FOR /F "delims=> tokens=2" %%c in ('Findstr /i "DDisk_Name_%%a_" %Konum%\DiskMenu.txt 2^>NUL') do (
			echo %R%[32m   %%a%R%[90m-%R%[33m %%b %R%[90m-%R%[36m %%c %R%[0m
		)
	)
)
Call :Dil A 2 Value_1_&set /p Disk=►%R%[32m !LA2!: %R%[0m
FOR /F "delims=> tokens=2" %%a in ('Findstr /i "DDisk_Harf_!Disk!_" %Konum%\DiskMenu.txt 2^>NUL') do (set Harf=%%a)
FOR /F "delims=> tokens=2" %%b in ('Findstr /i "DDisk_Name_!Disk!_" %Konum%\DiskMenu.txt 2^>NUL') do (set DiskName=%%b)
cls
Call :Dil A 2 Text_1_
FOR /F "tokens=2 delims=:" %%a IN ('Dism /Get-WimInfo /WimFile:!MainWim! /Index:!Index! ^| Find "Name"') do (
	FOR /F "tokens=*" %%b in ('echo %%a') do (
		echo ►%R%[33m "%%b" %R%[37m !LA2! %R%[0m
		Dism /Apply-Image /ImageFile:!MainWim! /index:!Index! /ApplyDir:!Harf!\
		bcdboot !Harf!\Windows
		bcdedit /set {default} description "%%b-!DiskName!"
	)
)
Call :Dil A 2 Text_2_&echo.&echo ►%R%[92m !LA2! %R%[0m
Call :Bekle 2
goto Menu

REM -------------------------------------------------------------
:VHD_Redifine
mode con cols=100 lines=25
REM VHD yolunu alıyorum
Call :Dil A 2 Value_3_&echo.&set /p Road=►%R%[32m !LA2!: %R%[0m
Call :Path_Check "!Road!"
	if "!Error!" EQU "X" (goto Menu)
Call :NailRemove Road !Road!
Call :Powershell "Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object -Property DeviceID | FL" > %Konum%\DiskDevice.txt
set Count=0
FOR /F "tokens=3" %%a in ('Findstr /i "DeviceID" %Konum%\DiskDevice.txt') do (
	set /a Count+=1
	echo Harf_!Count!_^>%%a^> >> %Konum%\DiskMenu.txt
)
set /a Count+=1
set Error=0
(
echo select vdisk file=!Road!
echo attach vdisk
echo exit
) > %Konum%\Config.txt
diskpart /s %Konum%\Config.txt
DEL /F /Q /A "%Konum%\DiskMenu.txt" > NUL 2>&1
Call :Powershell "Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object -Property DeviceID,VolumeName | FL" > %Konum%\DiskDevice.txt
set Count2=0
FOR /F "delims=':' tokens=2" %%a in ('Findstr /i "VolumeName" %Konum%\DiskDevice.txt 2^>NUL') do (
	set /a Count2+=1
	set Value=%%a
	set Value=!Value:~1!
	echo DDisk_Name_!Count2!_^>!Value!^> >> %Konum%\DiskMenu.txt
)
set Count2=0
FOR /F "tokens=3" %%a in ('Findstr /i "DeviceID" %Konum%\DiskDevice.txt') do (
	set /a Count2+=1
	echo DDisk_Harf_!Count2!_^>%%a^> >> %Konum%\DiskMenu.txt
)
set Harf=
set /a Calc=!Count2! - !Count!
	if "!Calc!" EQU "0" (FOR /F "delims=> tokens=2" %%a in ('Findstr /i "Harf_!Count!_" %Konum%\DiskMenu.txt') do (set Harf=%%a)
						 goto VDF_Redifine_Pass
						)
	if "!Calc!" NEQ "0" (goto Redifine_Menu)
	
REM -------------------------------------------------------------
:Redifine_Menu
cls&Call :Dil A 2 Title_5_&echo ►%R%[96m !LA2! %R%[0m&echo.
FOR /L %%a in (1,1,!Count2!) do (
	FOR /F "delims=> tokens=2" %%b in ('Findstr /i "DDisk_Harf_%%a_" %Konum%\DiskMenu.txt 2^>NUL') do (
		FOR /F "delims=> tokens=2" %%c in ('Findstr /i "DDisk_Name_%%a_" %Konum%\DiskMenu.txt 2^>NUL') do (
			echo %R%[32m   %%a%R%[90m-%R%[33m %%b %R%[90m-%R%[36m %%c %R%[0m
		)
	)
)
Call :Dil A 2 Value_1_&set /p Disk=►%R%[32m !LA2!: %R%[0m
FOR /F "delims=> tokens=2" %%a in ('Findstr /i "DDisk_Harf_!Disk!_" %Konum%\DiskMenu.txt 2^>NUL') do (set Harf=%%a)
goto VDF_Redifine_Pass

REM -------------------------------------------------------------
:VDF_Redifine_Pass
set Count=
set Count2=
bcdboot !Harf!\Windows
Call :Dil A 2 Text_2_&echo.&echo ►%R%[92m !LA2! %R%[0m
Call :Bekle 2
goto Menu

REM -------------------------------------------------------------
:VHD_Size
REM VHD boyutu arttırma bölümü
mode con cols=100 lines=25
Call :Dil A 2 Menu_4_&echo ►%R%[96m !LA2! %R%[0m
Call :Dil A 2 Value_3_&echo.&set /p Road=►%R%[32m !LA2!: %R%[0m
Call :NailRemove Road !Road!
Call :Path_Check "!Road!"
	if "!Error!" EQU "X" (goto Menu)
Call :Dil A 2 Value_2_&echo.&set /p Size=►%R%[32m !LA2!: %R%[0m
set /a Size2=!Size! * 1024
Call :Dil A 2 Text_5_&echo.&echo %R%[33m !LA2! %R%[0m
Call :Dil A 2 Value_9_&echo.&echo %R%[90m !LA2! %R%[0m
pause > NUL
cls
(
echo select vdisk file="!Road!"
echo expand vdisk maximum=!Size2!
echo exit
) > %Konum%\VHD_Size.txt
Call :Dil A 2 Title_6_&echo.&echo ►%R%[36m !LA2!%R%[33m !Size! GB %R%[0m
diskpart /s %Konum%\VHD_Size.txt
DEL /F /Q /A "%Konum%\VHD_Size.txt" > NUL 2>&1
set Size=
set Size2=
set Road=
cls
Call :Dil A 2 Text_4_&echo.&echo •%R%[33m !LA2! %R%[0m
Call :Dil A 2 Value_8_&echo.&echo %R%[90m !LA2! %R%[0m
pause > NUL
goto Menu

REM █████████████████████████████████████████████████████████████
:___HANGAR___
:Powershell
REM chcp 65001 kullanıldığında Powershell komutları ekranı kompakt görünüme sokuyor. Bunu önlemek için bu bölümde uygun geçişi sağlıyorum.
chcp 437 > NUL 2>&1
Powershell -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -C %*
chcp 65001 > NUL 2>&1
goto :eof

REM -------------------------------------------------------------
:Upper
REM Bu bölüme yönlendirdiğim kelimeleri büyük harf yaptırıyorum.
chcp 437 > NUL 2>&1
FOR /F %%g in ('Powershell -command "'%~1'.ToUpper()"') do (set %~2=%%g)
chcp 65001 > NUL 2>&1
goto :eof

REM -------------------------------------------------------------
:Dil
REM Dil verilerini buradan alıyorum. Call komutu ile buraya uygun değerleri gönderiyorum.
REM %~1= Harf │ %~2= tokens değeri │ %~3= Find değeri
set L%~1%~2=
FOR /F "delims=> tokens=%~2" %%z in ('Findstr /i "%~3" %Dil% 2^>NUL') do (set L%~1%~2=%%z)
goto :eof

REM -------------------------------------------------------------
:Disk_Harf_Kontrol
Findstr /i "%~1:" %Konum%\DiskDevice.txt > NUL 2>&1
	if "!errorlevel!" NEQ "0" (set Harf=%~1&set Error=1)
goto :eof

REM -------------------------------------------------------------
:Bekle
REM Timeout beklemeleri için
timeout /t %~1 /nobreak > NUL
goto :eof

:: -------------------------------------------------------------
:Path_Check
set PathCheck=%~1
REM Klasör yolunda Türkçe karakter kontrolü yapar
FOR %%a in (Ö ö Ü ü Ğ ğ Ş ş Ç ç ı İ) do (
	echo %PathCheck% | Find "%%a" > NUL 2>&1
		if !errorlevel! EQU 0 (cls&Call :Dil A 2 Error_1_&echo.&echo %R%[31m !LA2! %R%[0m&Call :Bekle 5&set Error=X&goto :eof)
)
REM Klasör yolunda boşluk olup olmadığını kontrol eder
if "%PathCheck%" NEQ "%PathCheck: =%" (cls&Call :Dil A 2 Error_2_&echo.&echo %R%[31m !LA2! %R%[0m&Call :Bekle 5&set Error=X&goto :eof)
goto :eof

:: -------------------------------------------------------------
:Uzunluk
:: %~1: Değişken değeri  %~2: Uzunluğu hesaplanacak olan değer
chcp 437 > NUL
FOR /F "tokens=*" %%z in ('Powershell -C "'%~2'.Length"') do (set Uzunluk%~1=%%z)
chcp 65001 > NUL
goto :eof

REM -------------------------------------------------------------
:NailAdd
set %~1="%~2"
goto :eof

REM -------------------------------------------------------------
:NailRemove
set %~1=%~2
goto :eof

REM -------------------------------------------------------------
:Install_Road
set Error=NT
Call :Dil A 2 Value_4_&set /p MainWim=►%R%[92m !LA2!: %R%[0m
	if "!MainWim!" EQU "X" (set Error=X&goto :eof)
	if "!MainWim!" EQU "x" (set Error=X&goto :eof)
REM Klasör yolunda Türkçe karakter kontrolü yapar
FOR %%a in (Ö ö Ü ü Ğ ğ Ş ş Ç ç ı İ) do (
	echo %Konum% | Find "%%a" > NUL 2>&1
		if !errorlevel! EQU 0 (cls&Call :Dil A 2 Error_1_&echo.&echo %R%[31m !LA2! %R%[0m&Call :Bekle 5&set Error=X&goto :eof)
)
REM Klasör yolunda boşluk olup olmadığını kontrol eder
if "%Konum%" NEQ "%Konum: =%" (cls&Call :Dil A 2 Error_2_&echo.&echo %R%[31m !LA2! %R%[0m&Call :Bekle 5&set Error=X&goto :eof)
REM ISO için önlem
echo %MainWim%\ | Find "\\" > NUL 2>&1
	if !errorlevel! EQU 0 (set MainWim=!MainWim:~0,-1!)
REM Verilen yolda boot.wim olarak mı verilmiş onu kontrol ediyorum.
echo !MainWim! | Findstr /i "boot.wim" > NUL 2>&1
	if !errorlevel! EQU 0 (cls&Call :Dil A 2 Error_4_&echo.&echo %R%[31m !LA2! %R%[0m&Call :Bekle 5&set Error=X&goto :eof)
)
REM Verilen yol install.wim'in mi onu kontrol ediyorum.
echo !MainWim! | Findstr /i "install.wim" > NUL 2>&1
	if !errorlevel! EQU 0 (Call :NailAdd MainWim !MainWim!&goto :eof)
	if !errorlevel! NEQ 0 (dir /b /s "!MainWim!\*install.wim" > NUL 2>&1
							   if !errorlevel! EQU 0 (FOR /F "tokens=*" %%g in ('dir /b /s "!MainWim!\*install.wim"') do (Call :NailAdd MainWim %%g&goto :eof))
)
REM Verilen yol install.esd'nin yolu mu onu kontrol ediyorum.
echo !MainWim! | Findstr /i "install.esd" > NUL 2>&1
	if !errorlevel! EQU 0 (Call :NailAdd MainWim !MainWim!&goto :eof)
	if !errorlevel! NEQ 0 (dir /b /s "!MainWim!\*install.esd" > NUL 2>&1
							   if !errorlevel! EQU 0 (FOR /F "tokens=*" %%g in ('dir /b /s "!MainWim!\*install.esd"') do (Call :NailAdd MainWim %%g&goto :eof))
)
cls&Call :Dil A 2 Error_5_&echo.&echo %R%[31m !LA2! %R%[0m&Call :Bekle 5&set Error=X
goto :eof

REM -------------------------------------------------------------
:ModeLong
FOR /F "tokens=3" %%z in ('Dism /Get-WimInfo /WimFile:!MainWim! ^| Find "Index"') do (set Mode=%%z)
set /a Mode*=2
set /a Mode=6+!Mode!
goto :eof

REM -------------------------------------------------------------
:OgnitorenKs.Reader
%~3  %R%[90m┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐%R%[0m
%~3  %R%[95m ► %~4 ◄
%~3  %R%[90m├─────┬──────┬────────────┬───────┬────────────┬───────────────────────────────────────────────────────────────────────────────┤%R%[0m
%~5  %R%[90m├─────┴──────┴────────────┴───────┴────────────┴───────────────────────────────────────────────────────────────────────────────┤%R%[0m
%~5  %R%[95m ► %~6 ◄
%~5  %R%[90m├─────┬──────┬────────────┬───────┬────────────┬───────────────────────────────────────────────────────────────────────────────┤%R%[0m
%~2  %R%[90m┌─────┬──────┬────────────┬───────┬────────────┬───────────────────────────────────────────────────────────────────────────────┐%R%[0m
echo  %R%[90m│%R%[32mIndex%R%[90m│%R%[32m Arch %R%[90m│ %R%[32m  Version  %R%[90m│  %R%[32mLang %R%[90m│   %R%[32m Edit    %R%[90m│    %R%[32mName%R%[0m
FOR /F "tokens=3" %%a IN ('Dism /Get-WimInfo /WimFile:%~1 ^| Find "Index"') DO (
	FOR /F "tokens=3" %%b IN ('Dism /Get-WimInfo /WimFile:%~1 /Index:%%a ^| Find "Architecture"') DO (
		FOR /F "skip=1 delims=. tokens=3" %%c in ('Dism /Get-WimInfo /WimFile:%~1  /Index:%%a ^| Find "Version"') do (
				FOR /F "tokens=4" %%d in ('Dism /Get-WimInfo /WimFile:%~1  /Index:%%a ^| Find "Build"') do (
					FOR /F "tokens=1" %%e in ('Dism /Get-WimInfo /WimFile:%~1  /Index:%%a ^| findstr /i Default') do (
						FOR /F "tokens=2 delims=':'" %%f in ('Dism /Get-WimInfo /WimFile:%~1  /Index:%%a ^| findstr /i Name') do (
							FOR /F "tokens=2 delims='-',':' " %%g in ('Dism /Get-WimInfo /WimFile:%~1  /Index:%%a ^| findstr /i Modified') do (
								set Huseyin=%%g
								FOR /F "delims=. tokens=1" %%a in ('echo %%g') do (if %%a LSS 10 (set Huseyin=0%%g))
								Call :Uzunluk 1 %%c
								if %%a LSS 10 (set Marty= %%a)
								if %%a GEQ 10 (set Marty=%%a)
								if !Uzunluk1! EQU 4 (set Ogni= %%c)
								if !Uzunluk1! EQU 5 (set Ogni=%%c)
								echo  %R%[90m├─────┼──────┼────────────┼───────┼────────────┼───────────────────────────────────────────────────────────────────────────────┤%R%[0m
								echo   %R%[92m !Marty!%R%[0m  ► %R%[33m %%b  %R%[36m !Ogni!.%%d  %R%[33m %%e  %R%[36m !Huseyin!  %R%[37m %%f%R%[0m
						)
					)
				)
			)
		)
	)
)
%~2  %R%[90m└─────┴──────┴────────────┴───────┴────────────┴───────────────────────────────────────────────────────────────────────────────┘%R%[0m
%~7  %R%[90m└─────┴──────┴────────────┴───────┴────────────┴───────────────────────────────────────────────────────────────────────────────┘%R%[0m
FOR %%g in (Huseyin Ogni Marty Uzunluk1) do (set %%g=)
goto :eof