

REM When executing all scripts, the conf is cleaned once (see execAll_CA_cer_crl.cmd)
if "%JUPLOAD_EXEC_ALL%" == "Running" goto endCleanEnv



IF EXIST %JUPLOAD_KEYSTORE_KEY_INPUT_FILE% DEL %JUPLOAD_KEYSTORE_KEY_INPUT_FILE%
IF EXIST %JUPLOAD_CA_KEY_INPUT_FILE% DEL %JUPLOAD_CA_KEY_INPUT_FILE%

set JUPLOAD_CA_KEY=
set JUPLOAD_KEYSTORE_KEY=
set JUPLOAD_KEYSTORE_KEY_INPUT_FILE=
set JUPLOAD_CA_KEY_INPUT_FILE=

echo The sensitive values has been cleaned from the environment

REM Waiting for user input. This Allows the user to view the script output, before it closes the window (when launched from the explorer)
pause 


:endCleanEnv
