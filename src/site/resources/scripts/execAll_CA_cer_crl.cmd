REM
REM  Execution in one time of:
REM  - buildJUploadCA
REM  - createJUploadDemoCert
REM  - generateCRL
REM  
REM  Its main interest, is that the CA key and the store password will be asked only once.
REM  
REM


REM Set the envionment variables
@call setEnv.cmd


REM Set the flag, which indicates to the setEnv and cleanEnv scripts that they should do nothing
set JUPLOAD_ERROR=
set JUPLOAD_EXEC_ALL=Running

REM Let's execute the three main scripts
@call buildJUploadCA
if "%JUPLOAD_ERROR%"=="1" goto endExecAllCACerCrl
@call createJUploadDemoCert
if "%JUPLOAD_ERROR%"=="1" goto endExecAllCACerCrl
@call generateCRL
if "%JUPLOAD_ERROR%"=="1" goto endExecAllCACerCrl


:endExecAllCACerCrl

REM Clear the flag, to allow environment cleaning by cleanEnv
set JUPLOAD_EXEC_ALL=

REM Clean the environement.
@call cleanEnv.cmd
