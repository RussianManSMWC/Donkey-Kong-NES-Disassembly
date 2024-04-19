MAPPER = 0					;which mapper it's using (NROM)
MIRRORING = 0					;horizontal mirroring
REGION = 0					;0 - NTSC, 1 - PAL

db "NES",$1A

If Version = Gamecube
  db $02					;gamecube version has more space (two 16KB PRG banks instead of 1)
else
  db $01					;16KB PRG banks = 1
endif

db $01						;one 8KB graphics bank
db MAPPER<<4&$F0|MIRRORING			;mirroring & mapper
db MAPPER&$F0					;more mapper

db $00						;unused
db REGION					;region
db $00,$00,$00,$00,$00,$00			;also unused (at least for this game specifically)