@echo off



REM When executing all scripts, the conf is set once (see execAll_CA_cer_crl.cmd)
if "%JUPLOAD_EXEC_ALL%" == "Running" goto endSetEnv


REM Set these two properties, according to your own configuration. Everything else should run fine, provided that you execute the script 
REM from 'your' right place.

REM PLEASE set the JUPLOAD_OPENSSL_ROOT to the path where your cf file is, and under which the openssl folder will be created (see buildJUploadCA.cmd)
REM In my case: JUPLOAD_OPENSSL_ROOT=H:\data\jupload\openssl

if "%JUPLOAD_OPENSSL_ROOT%" == "" goto juploadRootEmpty
goto afterJuploadRootEmpty
:juploadRootEmpty
echo YOU MUST SET A VALUE FOR JUPLOAD_OPENSSL_ROOT
pause
exit
:afterJuploadRootEmpty
echo Using this root: %JUPLOAD_OPENSSL_ROOT%


REM ======================================================================================
REM Very important: the openssl configuration, to use with these scripts
REM ======================================================================================

set OPENSSL_CONF=%JUPLOAD_OPENSSL_ROOT%\jupload_openssl.cfg


REM ======================================================================================
REM Defining keys values
REM ======================================================================================

REM To accelerate the testing of these scripts: everything can be hard coded
REM
REM  PLEASE COMMENT THESE TWO LINES FOR REAL CERTIFICATES (EVEN TEST ONES)
REM
REM set JUPLOAD_KEYSTORE_KEY=keystore_key
REM set JUPLOAD_CA_KEY=ca_key

REM Ask the user the keys ... if they are not already set.
if "%JUPLOAD_CA_KEY%" == "" goto askForCAKey
echo Using 'Hard Coded key' for the CA (PLEASE UNCOMMENT THE SETTING OF JUPLOAD_CA_KEY FOR PRODUCTION CERTIFICATE): '%JUPLOAD_CA_KEY%'
pause
goto afterAskForCAKey
:askForCAKey
set /p JUPLOAD_CA_KEY="Clef pour le CA: " %=%
:afterAskForCAKey

if "%JUPLOAD_KEYSTORE_KEY%" == "" goto askForKeystoreKey
echo Using 'Hard Coded key' for the Keystore  (PLEASE UNCOMMENT THE SETTING OF JUPLOAD_KEYSTORE_KEY FOR PRODUCTION CERTIFICATE): '%JUPLOAD_KEYSTORE_KEY%'
pause
goto afterAskForKeystoreKey
:askForKeystoreKey
set /p JUPLOAD_KEYSTORE_KEY="Clef pour le keystore: " %=%
:afterAskForKeystoreKey


REM ======================================================================================
REM General constants
REM ======================================================================================

set JUPLOAD_CERT_ROOT=%JUPLOAD_OPENSSL_ROOT%\jupload

set JUPLOAD_KEYSTORE_KEY_INPUT_FILE=%JUPLOAD_CERT_ROOT%\tmp\keystore_key_input.txt
set JUPLOAD_CA_KEY_INPUT_FILE=%JUPLOAD_CERT_ROOT%\tmp\ca_key_input.txt

REM Only for windows. Don't override your value when using Unix.
set RANDFILE=%JUPLOAD_CERT_ROOT%\a.rnd

REM The 'real' keystore, used to store the CA Cert, and the generated certificates
set JUPLOAD_KEYSTORE=%JUPLOAD_CERT_ROOT%\keystore.jks

REM A keystore to check that a jar is correctly signed by a certificate signed by a CA (see verifyJUploadDemoCert)
REM This keystore will have no password
set JUPLOAD_KEYSTORE_CA_ONLY=%JUPLOAD_CERT_ROOT%\keystore_ca_only.jks
set JUPLOAD_KEYSTORE_CA_ONLY_KEY=not_a_secret

set JUPLOAD_ALIAS_CERTIFICATE=juploaddemo
set JUPLOAD_ALIAS_CA=juploadca


REM ======================================================================================
REM CA's properties
REM ======================================================================================
set JUPLOAD_CA_CERTIFICATE_CN=JUpload's CA
set JUPLOAD_CA_CERTIFICATE_OU=CA
set JUPLOAD_CA_CERTIFICATE_O=JUpload
set JUPLOAD_CA_CERTIFICATE_ST=None
set JUPLOAD_CA_CERTIFICATE_L=Paris
set JUPLOAD_CA_CERTIFICATE_C=FR

REM ======================================================================================
REM Properties for the target Certificate
REM ======================================================================================
set JUPLOAD_TARGET_CERTIFICATE_CN=JUpload's Demo
set JUPLOAD_TARGET_CERTIFICATE_OU=Demo
set JUPLOAD_TARGET_CERTIFICATE_O=JUpload
set JUPLOAD_TARGET_CERTIFICATE_ST=None
set JUPLOAD_TARGET_CERTIFICATE_L=Paris
set JUPLOAD_TARGET_CERTIFICATE_C=FR




:endSetEnv
