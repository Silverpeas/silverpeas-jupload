@call setEnv.cmd
echo Creation of a Certificate, and sign it by our CA.

REM Defaulting value to 'my' file
set JUPLOAD_FILE_TO_VERIFY=H:\data\eclipse\jupload\target\site\wjhk.jupload.jar

REM Let's ask which file we'll verify...
if %JUPLOAD_FILE_TO_VERIFY% == "" goto askForFileToVerify
goto afterAskForFileToVerify
:askForFileToVerify
set /p JUPLOAD_FILE_TO_VERIFY="Enter the full pat for the file to verify: " %=%
:afterAskForFileToVerify

REM ======================================================================================
REM Certificate verification
REM ======================================================================================


REM First : remove this keystore. It should contain only our CA certitifate (with user confirmation)
del %JUPLOAD_KEYSTORE_CA_ONLY% /P

REM Creation of the keystore, and import of our CA.
keytool -import -trustcacerts -file %JUPLOAD_CERT_ROOT%\cacert.crt -alias juploadca -keystore "%JUPLOAD_KEYSTORE_CA_ONLY%" -storepass "%JUPLOAD_KEYSTORE_CA_ONLY_KEY%" < %JUPLOAD_CERT_ROOT%\tmp\oui.txt
if errorlevel 1 goto error

REM Verification that the given jar is signed by a Certificate, signed by this CA : the keystore contains only the CA.
jarsigner -verify "%JUPLOAD_FILE_TO_VERIFY%" -strict -certs -verbose:all -keystore "%JUPLOAD_KEYSTORE_CA_ONLY%"  -storepass "%JUPLOAD_KEYSTORE_CA_ONLY_KEY%"
if errorlevel 1 goto error


REM If we got here, everything was fine.
echo SCRIPT FINISHED NORMALLY....
goto end


:error
REM if we got here, there was an error.
echo AN ERROR OCCURED....


:end

REM Let's clean the environement (espectially the passwords...)
call cleanEnv
