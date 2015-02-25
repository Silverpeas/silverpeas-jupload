@call setEnv.cmd
echo Creation of a Certificate, and sign it by our CA.


REM ======================================================================================
REM Certificate creation
REM ======================================================================================


REM Generation of the initial certificate
:beforeGenKeyPair
keytool -genkeypair -keyalg rsa -validity 365 -dname "CN=%JUPLOAD_TARGET_CERTIFICATE_CN%, OU=%JUPLOAD_TARGET_CERTIFICATE_OU%, O=%JUPLOAD_TARGET_CERTIFICATE_O%, L=%JUPLOAD_TARGET_CERTIFICATE_L%, ST=%JUPLOAD_TARGET_CERTIFICATE_ST%, C=%JUPLOAD_TARGET_CERTIFICATE_C%" -v -alias "%JUPLOAD_ALIAS_CERTIFICATE%" -keystore "%JUPLOAD_KEYSTORE%" -storepass "%JUPLOAD_KEYSTORE_KEY%"  < %JUPLOAD_CERT_ROOT%\tmp\emptyline.txt
echo Error level: %errorlevel%
if errorlevel 1 goto keyAlreadyExists
REM Ok. Let's skip the keyAlreadyExists case
goto afterKeyAlreadyExists

REM If the key already exists, we ask the user if wants to remove it.
:keyAlreadyExists
set /p JUPLOAD_REMOVE_KEY="The %JUPLOAD_ALIAS_CERTIFICATE% key already exists. Do you want to remove (and recreate) it? (Y/N)" %=%
if "%JUPLOAD_REMOVE_KEY%" NEQ "Y" goto :error
keytool -delete -v -alias "%JUPLOAD_ALIAS_CERTIFICATE%" -keystore "%JUPLOAD_KEYSTORE%" -storepass "%JUPLOAD_KEYSTORE_KEY%"
goto beforeGenKeyPair


:afterKeyAlreadyExists
REM Generation of the Certificate Signature Request
keytool -certreq -v -file %JUPLOAD_CERT_ROOT%\certs\juploadDemoCARequest.csr -v -alias "%JUPLOAD_ALIAS_CERTIFICATE%" -validity 365  -keystore "%JUPLOAD_KEYSTORE%" -storepass "%JUPLOAD_KEYSTORE_KEY%" 
if errorlevel 1 goto error

REM Signing of the CSR by the CA
openssl ca -days 365 -in %JUPLOAD_CERT_ROOT%\certs\juploadDemoCARequest.csr -out %JUPLOAD_CERT_ROOT%\newcerts\juploadDemoCARequest.pem -passin env:JUPLOAD_CA_KEY -policy policy_anything  < %JUPLOAD_CERT_ROOT%\tmp\yy.txt
rem openssl x509 -days 3650 -CA %JUPLOAD_CERT_ROOT%\cacert.pem -CAkey %JUPLOAD_CERT_ROOT%\private\cakey.pem -passin env:JUPLOAD_CA_KEY -req -in %JUPLOAD_CERT_ROOT%\certs\juploadDemoCARequest.csr -outform PEM -out %JUPLOAD_CERT_ROOT%\newcerts\juploadDemoCARequest.pem -CAserial %JUPLOAD_CERT_ROOT%\serial
if errorlevel 1 goto error

REM Export of the certificate to a more standard format:
openssl x509 -outform der -in %JUPLOAD_CERT_ROOT%\newcerts\juploadDemoCARequest.pem  -out %JUPLOAD_CERT_ROOT%\newcerts\juploadDemoCARequest.crt
if errorlevel 1 goto error

REM 'purify' the generated PEM
REM openssl x509 -outform PEM -in %JUPLOAD_CERT_ROOT%\newcerts\juploadDemoCARequest.pem  -out %JUPLOAD_CERT_ROOT%\newcerts\juploadDemoCARequest.pem
REM if errorlevel 1 goto error

REM To see the generated certificate
echo ========================================================================================================
echo The generated Certificate:
echo ========================================================================================================
openssl x509 -in %JUPLOAD_CERT_ROOT%\newcerts\juploadDemoCARequest.pem -text
if errorlevel 1 goto error
echo ========================================================================================================

REM Building the certificate chain
copy %JUPLOAD_CERT_ROOT%\newcerts\juploadDemoCARequest.pem + %JUPLOAD_CERT_ROOT%\cacert.pem %JUPLOAD_CERT_ROOT%\newcerts\juploadDemoCARequest.chain
if errorlevel 1 goto error

REM Import of the (possible) new CA in the keystore
:beforeImportTrustcacerts
echo Trying to delete the %JUPLOAD_ALIAS_CA% certificate in the Keystore, if it exists.
keytool -import -v -trustcacerts -file %JUPLOAD_CERT_ROOT%\cacert.pem -alias "%JUPLOAD_ALIAS_CA%" -keystore "%JUPLOAD_KEYSTORE%" -storepass "%JUPLOAD_KEYSTORE_KEY%"  -noprompt
rem < %JUPLOAD_CERT_ROOT%\tmp\oui.txt
if errorlevel 1 goto CA_AlreadyExists

REM If Ok, let's got the next step...
goto CA_Imported

:CA_AlreadyExists
set /p JUPLOAD_REMOVE_CAKEY="The %JUPLOAD_ALIAS_CA% key already exists. Do you want to remove (and reimport) it? (Y/N)" %=%
if "%JUPLOAD_REMOVE_CAKEY%" NEQ "Y" goto :error
keytool -delete -v -alias "%JUPLOAD_ALIAS_CA%" -keystore "%JUPLOAD_KEYSTORE%" -storepass "%JUPLOAD_KEYSTORE_KEY%" 
goto beforeImportTrustcacerts

:CA_Imported

REM Import of the response for the CSR.
keytool -import -v -file %JUPLOAD_CERT_ROOT%\newcerts\juploadDemoCARequest.chain -alias "%JUPLOAD_ALIAS_CERTIFICATE%" -keystore "%JUPLOAD_KEYSTORE%" -storepass "%JUPLOAD_KEYSTORE_KEY%" 
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
