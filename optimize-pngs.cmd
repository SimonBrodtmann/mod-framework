@echo off
:loop
@echo %1
magick %1 -colors 256 -depth 8 %1
oxipng -o max -s -a %1
shift
if not "%~1"=="" goto loop