@echo off

echo Creation of a Certificate, and sign it by our CA.

REM ======================================================================================
REM Preparation: loading and completing environment
REM ======================================================================================

call setEnv.cmd

set ALIAS_CERTIFICATE=juploaddemo
set ALIAS_CA=juploadca

REM Creating a file containing only a carriadge return, to allo keytool to create a keypair, without specific password for it 
REM (only the keystore password)
echo.  > %ROOT_JUPLOAD%\tmp\emptyline.txt
REM echo.  >> %ROOT_JUPLOAD%\tmp\emptyline.txt


REM ======================================================================================
REM Certificate creation
REM ======================================================================================


REM Generation of the initial certificate
:beforeGenKeyPair
keytool -genkeypair -keyalg rsa -keysize 2048 -validity 365 -dname "CN=%TARGET_CERTIFICATE_CN%, OU=%TARGET_CERTIFICATE_OU%, O=%TARGET_CERTIFICATE_O%, L=%TARGET_CERTIFICATE_L%, ST=%TARGET_CERTIFICATE_ST%, C=%TARGET_CERTIFICATE_C%" -v -alias "%ALIAS_CERTIFICATE%" -keystore "%KEYSTORE%" -storepass "%KEYSTORE_KEY%"  < %ROOT_JUPLOAD%\tmp\emptyline.txt
echo Error level: %errorlevel%
if errorlevel 1 goto keyAlreadyExists
REM Ok. Let's skip the keyAlreadyExists case
goto afterKeyAlreadyExists

REM If the key already exists, we ask the user if wants to remove it.
:keyAlreadyExists
set /p REMOVE_KEY="The %ALIAS_CERTIFICATE% key already exists. Do you want to remove (and recreate) it? (Y/N)" %=%
if "%REMOVE_KEY%" NEQ "Y" goto :error
keytool -delete -v -alias "%ALIAS_CERTIFICATE%" -keystore "%KEYSTORE%" -storepass "%KEYSTORE_KEY%"
goto beforeGenKeyPair


:afterKeyAlreadyExists
REM Generation of the Certificate Signature Request
keytool -certreq -v -file %ROOT_JUPLOAD%\certs\juploadDemoCARequest.csr -v -alias "%ALIAS_CERTIFICATE%" -validity 365  -keystore "%KEYSTORE%" -storepass "%KEYSTORE_KEY%" 
if errorlevel 1 goto error

REM Signing of the CSR by the CA
openssl ca -days 365 -in %ROOT_JUPLOAD%\certs\juploadDemoCARequest.csr -out %ROOT_JUPLOAD%\newcerts\juploadDemoCARequest.pem -passin env:CA_KEY -policy policy_anything  
if errorlevel 1 goto error

REM Export of the certificate to a more standard format:
openssl x509 -outform der -in %ROOT_JUPLOAD%\newcerts\juploadDemoCARequest.pem  -out %ROOT_JUPLOAD%\newcerts\juploadDemoCARequest.crt
if errorlevel 1 goto error

REM 'purify' the generated PEM
openssl x509 -outform PEM -in %ROOT_JUPLOAD%\newcerts\juploadDemoCARequest.pem  -out %ROOT_JUPLOAD%\newcerts\juploadDemoCARequest.pem
if errorlevel 1 goto error

REM Building the certificate chain
copy %ROOT_JUPLOAD%\newcerts\juploadDemoCARequest.pem + %ROOT_JUPLOAD%\cacert.pem %ROOT_JUPLOAD%\newcerts\juploadDemoCARequest.chain
if errorlevel 1 goto error

REM Import of the (possible) new CA in the keystore
:beforeImportTrustcacerts
echo Trying to delete the %ALIAS_CA% certificate in the Keystore, if it exists.
keytool -import -v -trustcacerts -file %ROOT_JUPLOAD%\cacert.pem -alias "%ALIAS_CA%" -keystore "%KEYSTORE%" -storepass "%KEYSTORE_KEY%" 
if errorlevel 1 goto CA_AlreadyExists

REM If Ok, let's got the next step...
goto CA_Imported

:CA_AlreadyExists
set /p REMOVE_CAKEY="The %ALIAS_CA% key already exists. Do you want to remove (and reimport) it? (Y/N)" %=%
if "%REMOVE_CAKEY%" NEQ "Y" goto :error
keytool -delete -v -alias "%ALIAS_CA%" -keystore "%KEYSTORE%" -storepass "%KEYSTORE_KEY%" 
goto beforeImportTrustcacerts

:CA_Imported

REM Import of the response for the CSR.
keytool -import -v -file %ROOT_JUPLOAD%\newcerts\juploadDemoCARequest.chain -alias "%ALIAS_CERTIFICATE%" -keystore "%KEYSTORE%" -storepass "%KEYSTORE_KEY%" 
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
