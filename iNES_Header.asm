db "NES",$1A

If Version = Gamecube
  db $02					;gamecube version has more space (two 16KB PRG banks instead of 1)
else
  db $01					;16KB PRG banks = 1
endif

db $01						;one 8KB graphic bank
db $00						;horizontal mirroring
db $00						;Mapper 0 - NROM

db $00,$00,$00,$00				;unused
db $00,$00,$00,$00				;