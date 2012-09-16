@REM Requires the DirectX SDK bin directory to be in your path!

del test.txt
del test.bin
fxc /Od /T ps_4_0 test.hlsl /Fo test.bin /Fc test.txt 
@if ERRORLEVEL 1 goto errorexit
type test.txt
debug\fxdis.exe test.bin
goto done
:errorexit
@ECHO Compile error!
:done
