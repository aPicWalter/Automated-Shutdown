@echo off
rem ---------------------------------------------------------------------------------------------
rem Version
set "version=1.2"
title Shutdown V%version%
rem 
rem Programm benötigt die Funktion BigNumber und BigLetter
rem ---------------------------------------------------------------------------------------------

rem Initialisierung Variablen
set "delay=2700"
set "callback=delay"
set "space=   "


rem Auswahlmenue
:zurueck
cls
@echo off
echo ######### Version: %version% #########
echo ####    Zeit in Minuten     ####
echo ####   1  = 60              ####
echo ####   2  = 45              ####
echo ####   3  = 30              ####
echo ####   4  = 15              ####
echo ####   M  = manuell         ####
echo ####   A  = stoppen         ####
echo ####   0  = beenden         #### 
echo ################################ 

:auswahl
set /P wahl=Auswahl: 
if /i "%wahl%"=="1" goto :eins
if /i "%wahl%"=="2" goto :zwei
if /i "%wahl%"=="3" goto :drei
if /i "%wahl%"=="4" goto :vier
if /i "%wahl%"=="m" goto :manual
if /i "%wahl%"=="t" goto :test
if /i "%wahl%"=="A" goto :stoppen
if /i "%wahl%"=="0" goto :exit
echo Falsche Auswahl.
goto :auswahl

:test
set "count=3600"
set "steps=60"
goto :visual


:delay
rem Sekundentakt
rem ping localhost -n 1 >nul
timeout /t %steps%
goto :sub

:sub
rem Reduzierung des Counters
set /a count=%count%-%steps%
goto :visual

rem Gibt eine Zahl im Commandofenster als Zeichengrafik an
:visual
call BigNumber/BigNumber.bat %count% 2

if /i "%callback%"=="delay" goto :delay
c:\windows\system32\timeout 3
goto :zurueck 



rem Parameter für Shutdown festlegen
:eins
set "delay=3600"
goto :send

:zwei
set "delay=2700"
goto :send

:drei
set "delay=1800"
goto :send

:vier
set "delay=900"
goto :send

:manual
cls
@echo off

rem Individuelle Anpassung der Visualisierung
set /a print=%delay%/60
FOR /F "delims=:" %%A IN ('^(echo %print%^&echo.^)^|findstr /O $') DO set /a StringLength=%%A - 3
call set leer=%%space:~0,-%stringlength%%%


echo ###################################################
echo ####                                           ####                                            
echo ####           Bitte waehle die Zeit           ####
echo ####     Aktuelle Zeit: %leer%%print% min.               ####           
echo ####       S = Start                           ####
echo ####   1-300 = Minuten festlegen               ####          
echo ####       0 = zurueck                         #### 
echo ####                                           ####                                                 
echo ###################################################
set /P wahl=Auswahl:
if /i "%wahl%"=="0" goto :zurueck
if /i "%wahl%"=="S" goto :send
if %wahl% GTR 0 (
	if %wahl% LSS 301 (
		set /a delay=%wahl%*60
		goto manual
	) else (
		echo Auswahl nicht zulaessig!
		pause
		goto :manual
	)
) else (
	echo Auswahl nicht zulaessig!
	pause
	goto :manual
)

rem Shutdown zurueck setzen
:stoppen
c:\windows\system32\shutdown.exe -a
call BigLetter/BigLetter.bat abort 2
c:\windows\system32\timeout 3
goto :exit

rem Shutdown auslösen
:send
c:\windows\system32\shutdown.exe -s -t %delay%
set "count=%delay%"
set "steps=1"
set "callback=not"
goto :visual

rem Programm beenden
:exit
exit