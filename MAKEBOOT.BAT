@echo off
del *.obj > nul
del *.bin > nul

@echo on
tasm bootsect.asm,bootsect.obj
tlink /t /x bootsect.obj,bootsect.bin
dir bootsect.bin
