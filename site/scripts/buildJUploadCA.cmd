@call setEnv.cmd


REM ======================================================================================
REM Backup of the current openssl actuel
REM ======================================================================================

REM Formatage : http://stackoverflow.com/questions/1192476/windows-batch-script-format-date-and-time
REM Hour formatting
set hour=%time:~0,2%
if "%hour:~0,1%" == " " set hour=0%hour:~1,1%
REM echo hour=%hour%
set min=%time:~3,2%
if "%min:~0,1%" == " " set min=0%min:~1,1%
REM echo min=%min%
set secs=%time:~6,2%
if "%secs:~0,1%" == " " set secs=0%secs:~1,1%
REM echo secs=%secs%

REM Date formatting
set year=%date:~-4%
REM echo year=%year%
set month=%date:~3,2%
if "%month:~0,1%" == " " set month=0%month:~1,1%
REM echo month=%month%
set day=%date:~0,2%
if "%day:~0,1%" == " " set day=0%day:~1,1%
REM echo day=%day%

REM Rename of the toor folder, for backup
set JUPLOAD_NEW_NAME=jupload_%year%-%month%-%day%_%hour%-%min%-%secs%
echo Renaming folder %JUPLOAD_CERT_ROOT% to %JUPLOAD_NEW_NAME%
ren "%JUPLOAD_CERT_ROOT%" %JUPLOAD_NEW_NAME%

REM ======================================================================================
REM Preparation : folder, temporary files, storage keys...
REM ======================================================================================

REM Folder creation
mkdir %JUPLOAD_CERT_ROOT%
mkdir %JUPLOAD_CERT_ROOT%\certs
mkdir %JUPLOAD_CERT_ROOT%\crl
mkdir %JUPLOAD_CERT_ROOT%\newcerts
mkdir %JUPLOAD_CERT_ROOT%\private
mkdir %JUPLOAD_CERT_ROOT%\tmp\
(echo 1000) > %JUPLOAD_CERT_ROOT%\serial
REM echo. > %JUPLOAD_CERT_ROOT%\index.txt
copy /y NUL %JUPLOAD_CERT_ROOT%\index.txt >NUL
echo. > %RANDFILE%

echo 00 > %JUPLOAD_CERT_ROOT%\crlnumber

REM Creating a file containing only a carriadge return, to allo keytool to create a keypair, without specific password for it 
REM (only the keystore password)
echo.  > %JUPLOAD_CERT_ROOT%\tmp\emptyline.txt

REM Creating a file containing two lines, each containing only a 'y' string (commit of the openssl ca signing command)
echo y  > %JUPLOAD_CERT_ROOT%\tmp\yy.txt
echo y  >> %JUPLOAD_CERT_ROOT%\tmp\yy.txt

REM Creating a file containing one line, containing only a 'oui' string (French version for yes, when importing a CA certificate in keytool)
echo oui  > %JUPLOAD_CERT_ROOT%\tmp\oui.txt

REM ======================================================================================
REM Creation of the CA
REM ======================================================================================


REM Creation of the input files (not used here). We used instead ths direct storage into an environment variable: NOT RELIABLE IN A MULTI-USER COMPUTER
REM echo %KEYSTORE_KEY% > %KEYSTORE_KEY_INPUT_FILE%
REM echo %CA_KEY% > %CA_KEY_INPUT_FILE%

REM Creation of the CA
REM not used: -extensions v3_ca 
REM openssl req -new -x509 -days 3650 -newkey rsa:2048 -passout env:JUPLOAD_CA_KEY -keyout %JUPLOAD_CERT_ROOT%\private\cakey.pem -out %JUPLOAD_CERT_ROOT%\cacert.pem -subj "/CN=%JUPLOAD_CA_CERTIFICATE_CN%/OU=%JUPLOAD_CA_CERTIFICATE_OU%/O=%JUPLOAD_CA_CERTIFICATE_O%/ST=%JUPLOAD_CA_CERTIFICATE_ST%/L=%JUPLOAD_CA_CERTIFICATE_L%/C=%JUPLOAD_CA_CERTIFICATE_C%" 
openssl req -new -x509 -days 3650 -keyform PEM -outform PEM -passout env:JUPLOAD_CA_KEY -keyout %JUPLOAD_CERT_ROOT%\private\cakey.pem -out %JUPLOAD_CERT_ROOT%\cacert.pem -subj "/CN=%JUPLOAD_CA_CERTIFICATE_CN%/OU=%JUPLOAD_CA_CERTIFICATE_OU%/O=%JUPLOAD_CA_CERTIFICATE_O%/ST=%JUPLOAD_CA_CERTIFICATE_ST%/L=%JUPLOAD_CA_CERTIFICATE_L%/C=%JUPLOAD_CA_CERTIFICATE_C%" 
if errorlevel 1 goto error

REM To see the generated certificate
echo ========================================================================================================
echo The generated CA:
echo ========================================================================================================
openssl x509 -in %JUPLOAD_CERT_ROOT%\cacert.pem -text
echo ========================================================================================================
if errorlevel 1 goto error

REM "Purification" of the PEM

REM A more standard format for the certificate
openssl x509 -outform der -in %JUPLOAD_CERT_ROOT%\cacert.pem -out %JUPLOAD_CERT_ROOT%\cacert.crt
if errorlevel 1 goto error


REM If we got here, everything was fine.
echo SCRIPT FINISHED NORMALLY....

goto end


:error
REM Let's clean the executeAll flag, to allow the script to stop there (after env cleaning).
set JUPLOAD_EXEC_ALL=
set JUPLOAD_ERROR=1
REM if we got here, there was an error.
echo AN ERROR OCCURED....


:end
REM Let's clean the environement (espectially the passwords...)
call cleanEnv
