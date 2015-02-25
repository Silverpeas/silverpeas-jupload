@call setEnv.cmd

REM ======================================================================================
REM Generation of the CRL. This file is to be published in the URL, indicated in the Certificate.
REM Check the jupload_openssl.cfg for the crl_section section.
REM ======================================================================================

REM To revoke a certificate, use this command:
REM openssl ca -revoke %JUPLOAD_CERT_ROOT%/certs/CertName.pem

REM Generation of the CRL file. 
REM It is to be published here (for JUpload certificates): http://jupload.sourceforge.net/certificates/crl.pem
openssl ca -gencrl -passin env:JUPLOAD_CA_KEY -out %JUPLOAD_CERT_ROOT%\crl\crl.pem
if errorlevel 1 goto error

REM View the CRL file in clear:
echo ========================================================================================================
echo The generated CRL:
echo ========================================================================================================
openssl crl -in %JUPLOAD_CERT_ROOT%\crl\crl.pem -text
if errorlevel 1 goto error
echo ========================================================================================================


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
