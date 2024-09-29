@echo off
rem ---------------------------------------------------------------------------------------------
rem Version 1.0; D. Fischer; 08.01.2024
rem 
rem Programm stellt Buchstaben in Zeichengrafik dar.
rem 
rem 1. Parameter ist ein Wort
rem 2. Parameter bestimmt 					0...wird nicht ausgegeben	Ausgabe.txt beschrieben
rem								1...wird in Konsole ausgegeben	Ausgabe.txt beschrieben
rem                                         			2...wird in Konsole ausgegeben 	Ausgabe.txt geloescht
rem
rem
rem Beispiel:
rem call BigLetter/BigLetter.bat Hallo 1
rem
rem ---------------------------------------------------------------------------------------------

rem Initialisierung Variablen
set "Setting=0"
set "Letters=%1"
set "Setting=%2"

Setlocal EnableDelayedExpansion
set Zeichenfolge=%Letters%
FOR /F "delims=:" %%A IN ('^(echo %Zeichenfolge%^&echo.^)^|findstr /O $') DO set /a StringLength=%%A - 4
rem echo Stringlaenge %StringLength%
break>Ausgabe.txt
FOR /L %%A IN (0,1,%StringLength%) DO (
	set Varname=Var%%A
	set "Lettername=!Zeichenfolge:~%%A,1!"
	set "line=0"
	set "lone=0"
	
	for /f "tokens=1 delims=" %%m in (BigLetter\Letter!Lettername!.txt) do (
		set /a line +=1
		set "lone=0"
		if %%A GTR 0 (
			for /f "tokens=1 delims=" %%r in (Ausgabe.txt) do (
				set /a lone +=1
				if !lone! equ !line! (
					echo %%r%%m>>"Temp1.txt"
				)	
			)
		) else (
		echo %%m>>"Temp1.txt"
		)
	)
	break>Ausgabe.txt
	for /f "tokens=1 delims=" %%w in (Temp1.txt) do (
	echo %%w >>"Ausgabe.txt"
	)
	del Temp1.txt
)

if %Setting% equ 1 (
 	type Ausgabe.txt
)
if %Setting% equ 2 (
	type Ausgabe.txt
	del Ausgabe.txt
)
