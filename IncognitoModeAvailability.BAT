@ ECHO OFF
TITLE IncognitoModeAvailability
COLOR 0A
CLS
CD /D %~dp0

IF EXIST TITLE DEL TITLE

IF NOT EXIST TITLE.NFO (

	fsutil file createNew TITLE 0 > NUL
	
	>> TITLE ECHO IncognitoModeAvailability
	>> TITLE ECHO VERSION 1.0
	>> TITLE ECHO Il Favoloso Mondo di Leo
	>> TITLE ECHO https://ilfavolosomondodileo.wordpress.com/
	>> TITLE ECHO.

)

TYPE TITLE

SET DAY=%DATE:~0,2%
SET MONTH=%DATE:~3,2%
SET YEAR=%DATE:~6,4%
SET HOURS=%TIME:~0,2%
SET MINUTES=%TIME:~3,2%
SET SECONDS=%TIME:~6,2%
IF "%HOURS:~0,1%"==" " SET HOURS=0%HOURS:~1,1%
SET CODE=%YEAR%%MONTH%%DAY%%HOURS%%MINUTES%%SECONDS%

SET TEST=%CODE%
fsutil file createNew C:\Windows\System32\%TEST% 0 > NUL
IF NOT EXIST C:\Windows\System32\%TEST% GOTO ERROR
IF EXIST C:\Windows\System32\%TEST% DEL C:\Windows\System32\%TEST%
CD /D %~dp0

IF NOT EXIST BACKUP MKDIR BACKUP

IF EXIST CHOOSE RMDIR /S /Q CHOOSE
IF NOT EXIST CHOOSE MKDIR CHOOSE
fsutil file createNew CHOOSE\YES 0 > NUL
fsutil file createNew CHOOSE\NO 0 > NUL
fsutil file createNew CHOOSE\FORCED 0 > NUL
CD CHOOSE
SET /P IncognitoModeAvailability=IncognitoModeAvailability	
CD ..

IF "%IncognitoModeAvailability%"=="YES" GOTO GOOD
IF "%IncognitoModeAvailability%"=="NO" GOTO GOOD
IF "%IncognitoModeAvailability%"=="FORCED" GOTO GOOD

CLS
TYPE TITLE
ECHO ERROR
ECHO.
IF "%IncognitoModeAvailability%"=="" ( ECHO THE IncognitoModeAvailability VARIABLE MUST HAVE A VALUE ) ELSE ( ECHO THE IncognitoModeAvailability VARIABLE MUST HAVE A RECOGNIZED VALUE )
ECHO.
PAUSE
GOTO EXIT

: GOOD

CLS
TYPE TITLE
ECHO Google Chrome WILL CLOSE
ECHO.
PAUSE

CLS
TYPE TITLE

TASKLIST /M chrome.dll /FO CSV /NH | find "chrome.exe" > NUL && TSKILL chrome

REG ADD HKLM\SOFTWARE\Policies\Google\Chrome /f
REG QUERY HKLM\SOFTWARE\Policies\Google\Chrome | FIND "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" > NUL && GOTO REMOVE
GOTO EDIT

: REMOVE
REG QUERY HKLM\SOFTWARE\Policies\Google\Chrome | FIND "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" > NUL && REG EXPORT HKLM\SOFTWARE\Policies\Google\Chrome "BACKUP\Google Chrome (%CODE%).reg"
REG QUERY HKLM\SOFTWARE\Policies\Google\Chrome | FIND "IncognitoModeAvailability" > NUL && REG DELETE HKLM\SOFTWARE\Policies\Google\Chrome /v IncognitoModeAvailability /f
REG QUERY HKLM\SOFTWARE\Policies\Google\Chrome | FIND "IncognitoEnabled" > NUL && REG DELETE HKLM\SOFTWARE\Policies\Google\Chrome /v IncognitoEnabled /f

: EDIT
IF "%IncognitoModeAvailability%"=="YES" REG ADD HKLM\SOFTWARE\Policies\Google\Chrome /v IncognitoModeAvailability /t REG_DWORD /d 0 /f
IF "%IncognitoModeAvailability%"=="NO" REG ADD HKLM\SOFTWARE\Policies\Google\Chrome /v IncognitoModeAvailability /t REG_DWORD /d 1 /f
IF "%IncognitoModeAvailability%"=="FORCED" REG ADD HKLM\SOFTWARE\Policies\Google\Chrome /v IncognitoModeAvailability /t REG_DWORD /d 2 /f

START "Google Chrome" /B "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"

GOTO EXIT

: ERROR

IF NOT EXIST C:\Windows\System32\%TEST% ECHO THIS BATCH SCRIPT MUST BE RUN WITH ADMINISTRATOR RIGHTS

PAUSE > NUL

: EXIT

IF EXIST CHOOSE RMDIR /S /Q CHOOSE

IF EXIST TITLE DEL TITLE

TIMEOUT /T 1 /NOBREAK > NUL

EXIT