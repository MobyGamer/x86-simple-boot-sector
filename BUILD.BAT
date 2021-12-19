@echo off
del *.obj > nul
del *.com > nul
del *.bin > nul

@echo on
tasm /dCOMFILE=0 boothw.asm,bootsect.obj
tlink /t /x bootsect.obj,bootsect.bin

tasm /dCOMFILE=1 boothw.asm,boothw.obj
tlink /t /x boothw.obj,boothw.com

@dir boot*.* | xgrep -v asm | xgrep -v obj
