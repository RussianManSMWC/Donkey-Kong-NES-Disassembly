;Donkey Kong (NES) Disassembly
;This is a disassembly of Donkey Kong for NES, specifically 3 different versions.
;-Japenese (Revision 0)
;-US (Revision 1)
;-Gamecube (from Animal Crossing)
;Disassembled By RussianManSMWC. Does not include Graphic data - you have to rip it yourself.
;To be compiled with ASM6
;Personal note - this code is a mess.

;Set version with this define. Use one of the following arguments
;JP
;US
;Gamecube
;or you can use number 0-2 for respective version.

incsrc Defines.asm

Version = US

incsrc JPRemap.asm				;macros for some changes done between JP vs. US/Rev 0 vs. Rev 1

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

If Version = Gamecube
  org $8000
  FILLVALUE $00					;fill unused space for this expansion with zeros
  org $BFD0					;all space before this point is unused (from $8000, pad with $00)
  
Gamecube_CODE_BFD0:
  pad $BFEB,$EA					;after which there are some NOPs. to make RNG slower? but why?
  
Gamecube_CODE_BFEB:
  LDA RNG_Value					;
  AND #$02					;
  RTS						;

Gamecube_CODE_BFF0:
  LDA ControllerInput_Player1Previous		;yeah, that additional space isn't used all that much. missed opportunity...
  AND #$08					;check for Up button - go from first option to last
  ASL A						;
  ASL A						;
  ADC $0200					;
  RTS

  FILLVALUE $00					;the rest is $00
;after which a few more unused bytes
endif


org $C000
FILLVALUE $FF					;original game's free space is marked with FFs
;big table block
;TO DO: Figure out if some of these unused tables are actually used (at least in theory)

;Tile VRAM location for scores
DATA_C000:
db $20,$70,$06,$00				;TOP
db $20,$64,$06,$00				;Player 1
db $20,$78,$06,$00				;Player 2
db $20,$B7,$04,$00				;Bonus

;----------------------------------------------
;!UNUSED
;Loop counter uses a single byte write, so this is unecessary and unused
UNUSED_C010:
db $20,$BC,$01,$00
;----------------------------------------------

;Input data for demo
;DemoInputData_C014:
DATA_C014:
;probably doesn't look good. shrugio
db Input_Right
db Input_Up
db Input_Left
db Input_Up

db Input_Left
db Demo_NoInput
db Demo_JumpCommand
db Input_Right

db Demo_NoInput
db Input_Left
db Input_Right
db Input_Right

db Input_Right
db Demo_JumpCommand
db Input_Right
db Demo_JumpCommand

db Input_Right
db Input_Left
db Input_Right
db Input_Left

;Timings for each input (^^^) for demo
;DemoTimingData_C028:
DATA_C028:
db $DB,$60,$E2,$55
db $14,$20,$01,$F9
db $A0,$E0,$30,$10
db $10,$01,$50,$01              
db $30,$D0,$FF,$FF				;after this it'll start taking garbage values, which should be impossible, unless you disable barrels

DATA_C03C:
dw DATA_C63E					;\pointers to kong's frames
dw DATA_C657					;/
dw DATA_C6E1					;erase II if not in two player mode
dw DATA_C760					;erase various tiles for ending (part 1)

;various table pointers for the ending (erase tiles, draw some), combined with a table from above
DATA_C044:
dw DATA_C77D
dw DATA_C6E4
dw DATA_C6F1
dw DATA_C753
dw DATA_C708
dw DATA_C719
dw DATA_C71C
dw DATA_C735
dw DATA_C74E

;Also something
dw DATA_C08C
dw DATA_C0CF 
dw DATA_C161

;doesn't look like a pointer to data in ROM, does it? maybe it is somehing in RAM? either way it is unused.
UNUSED_C05C:
db $60,$04

DATA_C05E:
dw DATA_C0C3					;$C3,$C0

db $DF,$C0,$6E,$C1

UNUSED_C064:
db $C4,$C2

DATA_C066:
db $C8,$C2,$86,$C1,$B0,$C1,$92,$C1
db $CF,$C1,$D5,$C1

UNUSED_C072:  
db $DB,$C1

DATA_C074:
db $E1,$C1,$9E,$C1,$E7,$C1,$0C,$C6
db $70,$C6,$89,$C6,$25,$C6,$A2,$C6

db $CC,$00					;use RAM $CC (buffer item erasing (umbrella, handbag)

db $8E,$C1,$96,$C1,$A6,$C6

;data related with checking sloped surfaces (phase 1) of unknown format
DATA_C08C:
db $00,$D8,$00,$00,$01,$00
db $80,$D7,$04,$18,$06,$FE
db $C8,$BC,$04,$E8,$09,$FE
db $20,$9E,$04,$18,$09,$FE
db $C8,$80,$04,$E8,$09,$FE,$20,$62
db $04,$18,$09,$FE,$C8,$44,$04,$E8
db $06,$FE,$80,$28,$04,$00,$01,$FE

DATA_C0BC:
db $BC,$9E,$80,$62,$44,$28,$FF

DATA_C0C3:
db $00,$00,$80,$00,$00,$00,$18,$00

UNUSED_C0CB:
db $00,$00,$10,$00

;IDK
DATA_C0CF:
db $E0,$BC,$00,$10,$9E,$00,$E0,$80
db $00,$10,$62,$00,$E0,$44,$00,$FE
db $00,$00,$10,$03,$C8,$BC,$08,$C8
db $80,$04,$B8,$74,$10,$68,$58,$14
db $C8,$44,$04,$60,$CF,$0C,$70,$9B
db $00,$30,$9E,$04,$50,$85,$08,$80
db $7D,$00,$30,$62,$04,$58,$60,$00
db $90,$28,$18,$FE,$00,$00,$08,$1D
db $00,$00,$08,$17,$00,$00,$08,$18
db $00,$00,$08,$09,$00,$00,$08,$0B
db $00,$00,$08,$07,$00,$00,$08,$19
db $C8,$BC,$00,$70,$9B,$00,$30,$9E
db $00,$C8,$80,$00,$80,$7D,$00,$30
db $62,$00,$58,$60,$00,$C8,$44,$00
db $90,$28,$00,$FE,$00,$00,$08,$0D

DATA_C147:
db $24,$24,$54,$54,$60,$60,$64,$64
db $60,$60,$24,$24,$68,$68

UNUSED_C155:
db $68,$68,$68,$68

DATA_C159:
db $24,$24,$24,$54,$54,$54

UNUSED_C15F:
db $00,$00

DATA_C161:
db $60,$B7,$00,$50,$7B,$00,$B8,$5C
db $00,$68,$40,$00,$FE,$00,$00,$08
db $18

DATA_C172:
db $CA,$A7,$8E,$6B,$51

DATA_C177:
db $5C,$2C,$4C,$2C,$64

DATA_C17C:
db $C6,$AA,$8C,$6D,$4D

DATA_C181:
db $C4,$6C,$7C,$54,$C4,$08,$11,$0A
db $11

UNUSED_C18A:
db $08,$10,$0A,$11

DATA_C18E:
db $08,$0F,$0A,$11,$05,$01,$0C,$09
db $05,$05,$0A,$0A

UNUSED_C19A:
db $08,$10,$08,$10

DATA_C19E:
db $04,$04,$0C,$0D

DATA_C1A2:
db $0C,$14,$1C,$10,$18,$20

DATA_C1A8:
db $03,$05

UNUSED_C1AA:
db $02,$03,$00,$00

DATA_C1AE:
db $03,$04,$00,$00,$08,$08

DATA_C1B4:
db $10,$E0

UNUSED_C1B6:
db $10,$E0

DATA_C1B8:
db $0C,$E0,$08,$E8

DATA_C1BC:
db $01,$02,$04,$08,$10,$20,$40,$80

DATA_C1C4:
db $13,$30,$48,$60,$78,$90,$A8,$C0
db $E0

DATA_C1CD:
db $13,$DB,$4C,$6A,$88,$A6,$C5,$FE
db $53,$6B,$8F,$A7,$CA,$FE
        
UNUSED_C1DB:
db $52,$6E,$8C,$AC,$C5,$FE

DATA_C1E1:
db $52,$6C,$8E,$A8,$CA,$FE,$00,$06
db $08,$08

DATA_C1EB:
db $19,$30,$34,$30,$34,$30,$34,$38
db $3C,$3C,$3C

DATA_C1F6:
db $02

UNUSED_C1F7:
db $04

DATA_C1F8:
db $02,$04

DATA_C1FA:
db $07          

UNUSED_C1FB:
db $05

DATA_C1FC:
db $07

DATA_C1FD:
db $09,$03

DATA_C1FF:
db $00,$00,$04,$08

UNUSED_C203:
db $01,$02,$03,$04

;bonus score values (hundreds)
DATA_C207:
db $50,$60,$70,$80

UNUSED_C20B:
db $90						;unused bonus score counter value, it's capped at 8000.

DATA_C20C:
db $0E,$D8,$18,$0E,$C8,$04,$86,$C8
db $04,$A6,$C0,$00,$BE,$B8,$00,$D6
db $B0,$04,$4E,$B0,$04,$0E,$A0,$04
db $DE,$A0,$00,$C6,$98,$00,$AE,$90
db $00,$96,$88,$14,$C6,$78,$0C,$0E
db $70,$04,$46,$70,$08,$8E,$68,$04
db $AE,$60,$00,$C6,$58,$00,$DE,$50
db $00,$66,$40,$10,$86,$28,$00,$FE
db $B0,$78,$60,$40,$28,$FF,$00,$00
db $14,$00,$00,$00,$1C,$00,$00,$00
db $24,$00,$00,$00,$2C,$00,$00,$00
db $54,$00,$00,$00,$12,$00,$00,$00
db $E4,$00,$18,$A0,$0C,$20,$70,$10
db $50,$70,$14,$60,$70,$14,$98,$68
db $08,$C8,$78,$08,$E0,$A0,$00,$E0
db $50,$0C,$B0,$40,$08,$90,$28,$04
db $FE,$00,$00,$08,$10,$00,$00,$08
db $18,$00,$00,$08,$20,$00,$00,$08
db $28,$00,$00,$08,$30,$00,$00,$08
db $40,$18,$A0,$00,$20,$70,$00,$50
db $70,$00,$60,$70,$00,$98,$68,$00
db $C8,$78,$00,$E0,$A0,$00,$E0,$50
db $00,$B0,$40,$00,$90,$28,$00,$FE

UNUSED_C2C4:
db $04,$01,$1B,$0E

DATA_C2C8:
db $00,$01,$12,$01

;OAM slots for moving platforms from phase 2 (75M) (maybe used by other entities?)
DATA_C2CC:
db $30,$38,$40,$48,$50,$58              

UNUSED_C2D2:
db $00

DATA_C2D3:
db $00,$09,$15,$18      

UNUSED_C2D7:
db $00

DATA_C2D8:
db $4C,$5F,$03,$5C,$5F,$03,$C4,$67
db $03,$4C,$9F,$13,$5C,$9F,$13,$C4
db $87,$13,$DC,$3F,$03,$DC,$67,$13
db $06,$D8,$00,$06,$B8,$00,$16,$90
db $04,$1E,$68,$08,$26,$40,$0C,$FE
db $B8,$90,$68,$40,$28  

UNUSED_C305:
db $FF

DATA_C306:
db $00,$00,$F5,$00,$00,$00,$D5,$00
db $00,$00,$C5,$00,$00,$00,$B5,$00
db $10,$B8,$00,$78,$B8,$00,$E8,$B8
db $00,$18,$90,$04,$60,$90,$04,$98
db $90,$04,$E0,$90,$04,$20,$68,$04
db $80,$68,$04,$D8,$68,$04,$28,$40
db $04,$48,$40,$04,$B0,$40,$04,$D0
db $40,$04,$FE,$00,$00,$08,$20,$00
db $00,$08,$28,$10,$B8,$00,$78,$B8
db $00,$E8,$B8,$00,$18,$90,$00,$60
db $90,$00,$98,$90,$00,$E0,$90,$00
db $20,$68,$00,$80,$68,$00,$D8,$68
db $00,$28,$40,$00,$48,$40,$00,$B0
db $40,$00,$D0,$40,$00,$FE,$00,$09
db $1E,$33,$48,$54

DATA_C37A:
db $0C,$A7,$03,$74,$A7,$03,$E4,$A7
db $03,$0C,$C7,$13,$74,$C7,$13,$E4
db $C7,$13,$14,$7F,$03,$5C,$7F,$03
db $94,$7F,$03,$DC,$7F,$03,$1C,$57
db $03,$7C,$57,$03,$D4,$57,$03,$14
db $A7,$13,$5C,$A7,$13,$94,$A7,$13
db $DC,$A7,$13,$24,$2F,$03,$44,$2F
db $03,$AC,$2F,$03,$CC,$2F,$03,$1C
db $7F,$13,$7C,$7F,$13,$D4,$7F,$13
db $24,$57,$13,$44,$57,$13,$AC,$57
db $13,$CC,$57,$13

DATA_C3CE:
db $08,$C7,$10,$A7,$18,$7F,$20,$57
db $E8,$C7,$E0,$A7,$D8,$7F,$D0,$57

DATA_C3DE:
db $34,$AC,$44,$BC

DATA_C3E2:
db $05,$03,$0D,$0B

DATA_C3E6:
db $D4,$0C

DATA_C3E8:
db $E4,$0C

DATA_C3EA:
db $5D,$4B

DATA_C3EC:
db $CD,$C3

DATA_C3EE:
db $5D,$43

DATA_C3F0:
db $E5,$C3

DATA_C3F2:
db $ED,$03

DATA_C3F4:
db $24,$49,$77,$77

DATA_C3F8:
db $77,$77,$FF,$FF

DATA_C3FC:
db $0B,$0C,$0D,$15,$16,$17,$18,$19
db $1A,$1E,$1F

DATA_C407:
db $FF,$FF,$FF,$01,$01,$01,$01,$FF
db $FF,$01,$01

DATA_C412:
db $E4,$E3,$E2,$D8,$D7,$D6,$D5,$D4
db $D3,$D0,$CF

DATA_C41D:
db $48,$84,$C0

DATA_C420:
db $50,$8D,$C7

DATA_C423:
db $20,$C0

UNUSED_C425:
db $78,$60

DATA_C427:
db $28,$44,$6B,$20

DATA_C42B:
db $33,$C4

UNUSED_C42D:
db $37,$C4

DATA_C42F:
db $3B,$C4,$3F,$C4,$00,$00,$10,$08

UNUSED_C437:
db $00,$00,$10,$08

DATA_C43B:
db $00,$00,$60,$10,$00,$00,$2A,$20

CODE_C443:
db $B0,$A0,$78,$68,$68

DATA_C448:
db $88,$88,$88,$88,$88

DATA_C44D:
db $48,$38,$28,$18,$18

UNUSED_C452:
db $BB,$BB,$5E,$2F,$13

DATA_C457:
db $88,$78,$64,$56,$49

;two nearly indentical tables related with timing of sprite processing (compared bitwise)
DATA_C45C:
db $88,$88,$24,$55,$55

DATA_C461:
db $88,$88,$49,$55,$55

DATA_C466:
db $40,$20,$10,$08,$01   

UNUSED_C46B:
db $8C,$C0,$0C,$C2

DATA_C46F:
db $0C,$C2,$F0,$C2      

UNUSED_C473:
db $C3,$C0,$0C,$C2

DATA_C477:
db $52,$C2,$06,$C3

DATA_C47B:
db $E3,$C0

UNUSED_C47D:
db $0C,$C2

DATA_C47F:
db $6E,$C2,$16,$C3

DATA_C483:
db $0B,$C1

UNUSED_C485:
db $0C,$C2

DATA_C487:
db $8D,$C2,$41,$C3

DATA_C48B:
db $27,$C1					;

UNUSED_C48D:
db $0C,$C2

DATA_C48F:
db $A5,$C2,$49,$C3

DATA_C493:
dw DATA_C0BC

UNUSED_C495:
db $0C,$C2

DATA_C497:
db $4C,$C2,$00,$C3      

UNUSED_C49B:
db $0C,$C2

DATA_C49D:
db $D2,$C2,$74,$C3

UNUSED_C4A1:
db $0C,$C2

DATA_C4A3:
dw DATA_C2D8					;
dw DATA_C37A					;

;seems to be stage design data pointers
DATA_C4A7:
dw DATA_F55B					;phase 1

UNUSED_C4A9:
dw DATA_F8D9					;data pointer for cement factory phase. unfortunatly, it was cut so no actual stage data left. it's place is occupied by title screen data.

DATA_C4AB:
dw DATA_F7CD					;
dw DATA_F71C					;
dw DATA_F8D9					;title screen
dw DATA_FA1B					;hud

db $00,$00,$01,$06,$E8,$04,$50,$18
db $D5,$12,$E8,$00,$50,$20,$DB,$22
db $F0,$00,$00,$00,$03,$2C,$30,$04
db $20,$7F,$F6,$21,$D0,$00,$20,$46
db $F6,$21,$D8,$00,$00,$00,$01,$04
db $C0,$04,$00,$00,$00,$04,$00,$04
db $30,$C7,$04,$22,$00,$00,$00,$00
db $02,$08,$10,$04,$00,$00,$02,$02
db $E0,$04,$FE,$00,$00,$01,$06,$E8
db $04,$50,$18,$D5,$12,$E8,$00,$50
db $20,$DB,$22,$F0,$00,$00,$00,$03
db $0C,$30,$04,$30,$78,$A0,$12,$30
db $00,$30,$A8,$A0,$12,$38,$00,$30
db $49,$A0,$12,$40,$00,$70,$70,$A0
db $12,$48,$00,$70,$A0,$A0,$12,$50
db $00,$70,$D7,$A0,$12,$58,$00,$00
db $00,$23,$02,$40,$04,$00,$00,$23
db $02,$58,$04,$00,$00,$00,$04,$00
db $04,$10,$B7,$04,$22,$00,$00,$00
db $00,$02,$08,$10,$04,$4C,$9F,$98
db $22,$10,$00,$CC,$67,$98,$22,$20
db $00,$00,$00,$03,$0C,$60,$04,$00
db $00,$01,$16,$90,$04,$FE,$00,$00
db $01,$06,$E8,$04,$50,$18,$D5,$12
db $E8,$00,$50,$20,$DB,$22,$F0,$00
db $00,$00,$03,$04,$D0,$04,$14,$6E
db $F6,$21,$D0,$00,$7C,$46,$F6,$21
db $D8,$00,$00,$00,$01,$20,$50,$04
db $00,$00,$00,$04,$00,$04,$38,$C7
db $04,$22,$00,$00,$00,$00,$02,$10
db $10,$04,$FE

DATA_C5A6:
db $B3,$C4

UNUSED_C5A8:
db $F6,$C4

DATA_C5AA:
db $F6,$C4,$69,$C5      

UNUSED_C5AE:
db $7F,$7F,$7F,$00

DATA_C5B2:
db $5F,$3F,$00,$2F,$7F,$7F

UNUSED_C5B8:
db $00

DATA_C5B9:
db $A9,$A9,$81,$81,$59,$59,$31,$31

UNUSED_C5C1:
db $00

UNUSED_C5C2:
db $30,$4C,$D5,$00

DATA_C5C5:
db $10,$E0              

UNUSED_C5C8:
db $00

DATA_C5C9:
db $24,$50,$C0

UNUSED_C5CC:
db $00

DATA_C5CD:
db $3B,$B3,$3B,$B3,$3B,$B3,$38,$B3

UNUSED_C5D5:
db $00

DATA_C5D6:
db $22,$22,$22,$00

DATA_C5DA:
db $21,$21

UNUSED_C5DC:
db $00

DATA_C5DD:
db $20,$22,$22

UNUSED_C5E0:
db $00

DATA_C5E1:
db $22,$22,$22,$22,$21,$21,$21,$21

UNUSED_C5E9:
db $06,$0A,$1B,$00

DATA_C5ED:
db $82,$1C              

UNUSED_C5EF:
db $00

DATA_C5F0:
db $C5,$0A,$18

UNUSED_C5F3:
db $00

DATA_C5F4:
db $E8,$F7,$48,$57,$A8,$B7

DATA_C5FA:
db $08,$17

UNUSED_C5FC:
db $00

DATA_C5FD:
db $04
db $07

DATA_C5FF:
db $0B

;------------------------------------------

;score sprite data
;there's data for completely unused 300 score.

;Score values added to score counter

DATA_C600:
db $01						;100
db $03						;300 (unused)
db $05						;500
db $08						;800

;score sprite tile
DATA_C604:
db $D0						;1 for 100
db $D1						;3 for 300 (unused)
db $D2						;5 for 500
db $D3						;8 for 800

;------------------------------------------

DATA_C608:
db $84

UNUSED_C609:
db $8D						;unused (50M is non-existant)

DATA_C60A:
db $84,$8D,$46,$76,$77,$78,$79,$7A
db $7B,$7C,$7D,$7E,$7F,$80,$81,$82
db $83,$84,$85,$24,$24,$86,$87,$24
db $24,$24,$88,$46,$24,$9C,$9D,$9E
db $9F,$A0,$A1,$A2,$A3,$A4,$A5,$A6
db $A7,$A8,$A9,$AA,$AB,$AC,$AD,$AE
db $24,$AF,$B0,$B1

;donkey kong frame - throwing barrel to the side (phase 1)
DATA_C63E:
db $46						;6 vertical lines with 4 bytes each
db $24,$24,$24,$89
db $24,$24,$8A,$8B
db $8C,$8D,$8E,$8F
db $90,$91,$92,$93
db $94,$95,$96,$97
db $98,$99,$9A,$9B

;donkey kong frame - standing still
DATA_C657:
db $46
db $24,$B2,$68,$9E
db $B5,$B6,$6C,$C7
db $A3,$A4,$69,$A6
db $A7,$A8,$6B,$AA
db $C9,$CA,$6D,$BF
db $24,$CD,$6A,$B1

;
db $46,$C2
db $C3,$24,$9E,$C4,$C5,$C6,$C7,$A3
db $B9,$A5,$A6,$A7,$BB,$6B,$C8,$C9
db $CA,$CB,$CC,$24,$CD,$CE,$CF,$46
db $24,$B2,$B3,$B4,$B5,$B6,$B7,$B8
db $A3,$B9,$69,$BA,$A7,$BB,$A9,$AA
db $BC,$BD,$BE,$BF,$C0,$C1,$24,$B1
db $13,$2C,$16,$13,$13,$16,$30,$37

DATA_C6AA:
db $23,$DB,$42,$A0,$21,$CA,$4C,$24
db $21,$EA,$0C,$24,$24,$19,$15,$0A
db $22,$0E,$1B,$24,$66,$24,$24,$00

DATA_C6C2:
db $23,$E2,$04,$08,$0A,$0A,$02,$22
db $0A,$4C,$24,$22,$2A,$0C,$24,$10
db $0A,$16,$0E,$24,$24,$18,$1F,$0E
db $1B,$24,$22,$4A,$4C,$24,$00

DATA_C6E1:
db $12						;two vertical lines with 1 byte each
db $24,$24					;two empty tiles to remove II

;Erase score tiles for the ending
DATA_C6E4:
db $20,$63
db $1B|VRAMWriteCommand_Repeat			;all score, player 1, 2 and TOP
db $24

db $20,$94					;erase other stats (Lives, Bonus, Loop counter)
db $0A|VRAMWriteCommand_Repeat
db $24

db $20,$B4					;stats, bottom row
db $0A|VRAMWriteCommand_Repeat
db $24

db VRAMWriteCommand_Stop

;erase platforms for ending
DATA_C6F1:
db $21,$09
db $0E|VRAMWriteCommand_Repeat
db $24

db $21,$A9
db $0E|VRAMWriteCommand_Repeat
db $24

db $22,$49
db $0E|VRAMWriteCommand_Repeat
db $24

db $22,$E9
db $0E|VRAMWriteCommand_Repeat
db $24

db $3F,$1D
db $03
db $30,$36,$06					;sprite palette for kong

db VRAMWriteCommand_Stop

;erase kong (ending)
DATA_C708:
db $20,$8D
db $06|VRAMWriteCommand_Repeat
db $24

db $20,$AD
db $06|VRAMWriteCommand_Repeat
db $24

db $20,$CD
db $06|VRAMWriteCommand_Repeat
db $24

db $20,$ED
db $06|VRAMWriteCommand_Repeat
db $24

db VRAMWriteCommand_Stop

;Draw defeated kong (ending)
;Attributes
DATA_C719:
db $12						;two vertical lines with 1 byte each
db $AA,$AA

;first frame
DATA_C71C:
db $46						;defeated frame (6 rows, 4 tiles each)
db $24,$24,$DC,$DD
db $D4,$D5,$DE,$DF
db $D6,$D7,$E0,$E1
db $D8,$D9,$E2,$E3
db $DA,$DB,$E4,$E5
db $24,$24,$E6,$E7

;second frame
DATA_C735:
db $46
db $E8,$E9,$EA,$EB
db $EC,$ED,$EE,$EF
db $24,$F0,$F1,$F2
db $24,$F3,$F4,$F5
db $F6,$F7,$F8,$F9
db $FA,$FB,$FC,$FD

;Platform where Jumpman and Pauline are standing (ending)
DATA_C74E:
db $21,$08
db $10|VRAMWriteCommand_Repeat
db $62

db VRAMWriteCommand_Stop

;Platforms at the bottom (ending)
DATA_C753:
db $23,$09
db $0E|VRAMWriteCommand_Repeat
db $62

db $23,$29
db $0E|VRAMWriteCommand_Repeat
db $62

db $23,$49
db $0E|VRAMWriteCommand_Repeat
db $62

db VRAMWriteCommand_Stop

;used for DK Defeat cutscene (erase some tiles)
DATA_C760:
db $20,$C5					;erase umbrella
db $02|VRAMWriteCommand_Repeat			;
db $24

db $20,$CA					;erase platform with Pauline
db $02|VRAMWriteCommand_Repeat
db $24

db $20,$EA					;erase tiles below platform (there's none?)
db $02|VRAMWriteCommand_Repeat
db $24

db $20,$E5					;erase bottom tiles of umbrella
db $02|VRAMWriteCommand_Repeat			;
db $24						;

db $22,$0A					;erase handbag, top
db $02|VRAMWriteCommand_Repeat
db $24

db $22,$2A					;handbag, bottom
db $02|VRAMWriteCommand_Repeat			;
db $24						;

db $22,$18					;Umbrella 2 top
db $02|VRAMWriteCommand_Repeat			;
db $24						;

db VRAMWriteCommand_Stop

;Ending cutscene tile removal data part 2
DATA_C77D:
db $22,$38					;Umbrella 2 bottom
db $02|VRAMWriteCommand_Repeat
db $24

db $21,$29					;erasing ladders
db $04|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $24

db $21,$36
db $04|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $24

db $21,$D0
db $04|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $24

db $22,$6C
db $04|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $24

db $22,$73
db $04|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $24

db $23,$0F
db $03|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $24

db VRAMWriteCommand_Stop

;pretty sure those are common speed tables
DATA_C79A:
db $FF,$01

DATA_C79C:
db $01,$FF      

RESET_C79E:
SEI						;\pretty standart initialization. set interrupt
CLD						;/clear decimal mode.
LDA #$10					;enable background tile select only (i need to remember what it does)
STA ControlBits					;

LDX #$FF					;initialize stack
TXS						;

LOOP_C7A8:
LDA HardwareStatus				;wait untill NES is powered full and well
AND #$80					;
BEQ LOOP_C7A8					;

LDY #$07					;RAM clear loop
STY $01						;

LDY #$00					;$0700 through $0000
STY $00						;

LDA #$00					;

LOOP_C7B9:
STA ($00),Y					;
DEY						;
BNE LOOP_C7B9					;
DEC $01						;
BPL LOOP_C7B9					;

JSR CODE_C7E7					;clear screen

LDA #$7F					;initial cursor position
STA Cursor_YPosition				;

LDA #Players_1Player				;initial number of players
STA Players					;

LDA #$01					;
STA TitleScreen_Flag				;title screen
STA Jumpman_Lives				;lives

LDA #$00					;some kind of "game is active" flag used in normal gameplay
STA $4F						;(why is it set cleared again after clear loop?)
LDA ControlMirror				;
EOR #$80					;enable NMI
STA ControlBits					;
STA ControlMirror				;

;game loop, wait for NMI where all the important code is at
;GameLoop_CFE1:
LOOP_C7E1:
JSR RNG_F4ED					;run through RNG loop
JMP LOOP_C7E1					;keep looping

;set initial register settings and clear screen
;SetInitRegsAndClearScreen_C7E7:
CODE_C7E7:
LDA #$10					;
STA ControlBits					;
STA ControlMirror				;

LDA #$06                 			;enable leftmost column of the screen rendering (sprites and tiles)
STA RenderBits					;
STA RenderMirror				;

LDA #$00					;
STA CameraPositionReg				;\set camera position
STA CameraPositionY				;|
STA CameraPositionReg           		;|
STA CameraPositionX          			;/

JSR CODE_CBAE					;I don't know purpose of this routine yet
JMP CODE_CBB7					;clear screen

;Get drawing pointer - used to get pointers for phase design and HUD.
;Input: A - even index
;GetDrawPointer_C807:
CODE_C807:
TAX						;
LDA DATA_C4A7,X					;set indirect addressing
STA $00						;

LDA DATA_C4A7+1,X				;
STA $01						;
JMP CODE_F228					;jump to drawing routine

;this one uses buffer
;GetDrawPointerBuffer_C815:
CODE_C815:
TAX						;
LDA DATA_C03C,X					;
STA $02						;

LDA DATA_C03C+1,X				;
STA $03						;
JMP CODE_F2D7					;

;routine used for ending to get data pointers for tile deletion & drawing (platform with pauline 'n jumpman)
CODE_C823:
TAX						;
LDA DATA_C03C,X					;
STA $00						;

LDA DATA_C03C+1,X				;    
STA $01						;
JMP LOOP_CD76					;

;and another one.
CODE_C831:
TAX						;
LDA DATA_C03C,X					;
STA $04

LDA DATA_C03C+1,X				;
STA $05						;

LDA DATA_C044,X					;
STA $06						;

LDA DATA_C044+1,X				;
STA $07						;
RTS						;

;almost there
CODE_C847:
TAX						;
LDA DATA_C03C,X					;
STA $02						;

LDA DATA_C03C+1,X				; 
STA $03						;
RTS						;

;used only for DK defeated animation?
;oh, and also last one
CODE_C853:
TAX                      
LDA DATA_C03C,X              
STA $08

LDA DATA_C03C+1,X
STA $09
RTS

NMI_C85F:
PHA						;game's code is actually here
LDA ControlMirror				;
AND #$7F					;disable NMI
STA ControlBits					;
STA ControlMirror				;

LDA #$00					;
STA OAMAddress					;

LDA #$02					;DMA sprites from $0200-$02FF
STA OAMDMA					;

LDA #$31					;\set indirect addressing RAM ($0331)
STA $00						;|
LDA #$03					;|(buffer for various tile updates, like Kong animation
STA $01						;/
JSR CODE_F228					;draw tiles

LDA #$00					;
STA $0330					;reset update index
STA $0331					;reset "HUD" update flag
JSR CODE_F50E					;read controller

LDA RenderMirror				;
EOR #$18					;enable background and sprite rendering
STA RenderBits					;

JSR CODE_FA48					;play sounds and music (sound engine)

LDA TitleScreen_Flag				;if we're on title screen
BNE CODE_C8C1					;do title screen-y things

LDA GameControlFlag				;check if game isn't controllable yet
BEQ CODE_C8D4					;
 
LDA Kong_DefeatedFlag				;
BNE CODE_C8A5					;

JSR CODE_CE7C					;run normal gameplay
JMP CODE_C8D7					;

CODE_C8A5:
LDA $044F					;check if 
CMP #$08
BNE CODE_C8D4

JSR CODE_CCF4

LDA $43                  
BNE CODE_C8D7

LDA #$00                 
STA $044F                
STA $4F

LDA #$79
STA $43
JMP CODE_C8D7
  
CODE_C8C1:
LDA Jumpman_Lives				;if Jumpman has some lives left, continue playing
BNE CODE_C8CB					;
JSR CODE_CA30					;game over (or demo end)
JMP CODE_C8D7					;end NMI

CODE_C8CB:  
JSR CODE_C8F3
JSR CODE_F4AC					;handle timers
JMP CODE_C8D7
  
CODE_C8D4:
JSR CODE_CAC9

CODE_C8D7:  
LDA $0505                
CMP #$01                 
BNE CODE_C8E8

LDA Players
STA $00                  
JSR CODE_F23C

DEC $0505					;decrease some kind of timer?
  
CODE_C8E8:
LDA $10						;re-enable NMI
EOR #$80					;
STA $2000					;
STA $10						;
PLA						;restore A
RTI						;return from the interrupt

CODE_C8F3:
LDA $0102
BNE CODE_C8FE
STA $4015                
STA $0100
  
CODE_C8FE:
LDA $0518					;
BNE CODE_C914					;
        
LDA #Sound_Fanfare_TitleScreenTheme		;if we didn't play title theme, do it
STA Sound_Fanfare				;
        
LDA #$04					;i assume this is a number of resets after demo mode required for song to start playing again
STA $0518					;

LDA #$0F					;enable all sound channels
STA $4015					;
STA $0100					;backup
  
CODE_C914:
LDA TitleScreen_MainCodeFlag			;check if we've initialized title screen
BNE CODE_C940					;check for controller input when on title screen

JSR CODE_D19A					;disable render

LDA #$08					;
JSR CODE_C807					;draw title screen

;set cursor sprite for title screen
LDA Cursor_YPosition				;Y-position
STA $0200

LDA #$A2					;sprite tile
STA $0201					;

LDA #$00					;property
STA $0202					;
STA Demo_Active					;demo isn't active

LDA #$38					;
STA $0203					;X-pos
STA TitleScreen_MainCodeFlag			;any non-zero value is fine

LDA #$20                 			;set pre-demo timer
STA Timer_Demo					;
RTS						;

CODE_C940:
LDA $15						;check for select (change option or cancel demo)
If Version = Gamecube
  AND #Input_Select|Input_Up|Input_Down		;on gamecube Up and Down on D-pad also change option
else
  AND #Input_Select				;
endif
BNE CODE_C95D					;

LDA ControllerInput_Player1Previous		;
AND #Input_Start				;
BNE CODE_C98A					;check for the start button
  
LDA #$00					;
STA $0512					;

LDA $44						;if timer for demo is still active
BNE RETURN_C95C					;don't activate demo mode

LDA #$01					;
STA Demo_Active					;
JMP CODE_C9B1					;

RETURN_C95C:
RTS
  
CODE_C95D:
LDA #$40                 
STA $44
 
LDA $0512                
BNE CODE_C985

LDA #$40                 
STA $35

If Version = Gamecube
  JSR Gamecube_CODE_BFF0			;make cursor loop from first option to last (since we can use D-pad now)
else
  LDA $0200
endif
CLC                      
ADC #$10                 
CMP #$BF					;check if changed option after last (or first on gamecube) (wrap around)
If Version = Gamecube
  BCC CODE_C976
  SBC #$40					;either first or last
else
  BNE CODE_C976
  LDA #$7F					;first option location
endif

CODE_C976:
STA $0200
STA $0511

INC $0512					;timer? for demo?

LDA #$0A
STA $0513
RTS

CODE_C985:
LDA $35						;     
BNE RETURN_C989					;wait a minute... what? this check makes no sense!

RETURN_C989:
RTS						;

CODE_C98A:
STA $0514					;

LDX #$0A					;reset score  
LDA #$00					;

LOOP_C991:
STA ScoreDisplay_Player1-1,X			;both players and bonus
DEX						;(no it doesn't clear part of TOP display because it exits loop at zero)
BNE LOOP_C991					;

LDA Cursor_YPosition				;get option we just chose
LSR A						;
LSR A						;
LSR A						;
LSR A						;
SEC						;
SBC #$07					;
STA $50						;
CMP #$02					;
BMI CODE_C9AD					;check if it was one of first two options (1 Player Game A or B)

LDA #Players_2Players				;set two players if selected 2 player game A or B (and pressed start for said option)
STA Players					;
JMP CODE_C9B1					;

CODE_C9AD:
LDA #Players_1Player				;one player
STA Players					;

CODE_C9B1:
LDA $50						;load bit for game B if set (option 1 or 3)
AND #$01					;
ASL A						;
TAX						;
LDA $0507,X					;show top score depending on whether it was a 1P or 2P game.
STA ScoreDisplay_Top				;

LDA $0508,X					;
STA ScoreDisplay_Top+1				;

LDA #$0F					;set RNG seed, basically
STA RNG_Value					;

LDA #$13					;           
STA RNG_Value+1					;

LDA #$00					;
STA TitleScreen_Flag				;not in title screen anymore
STA $0406					;
STA $0407					;
STA GameControlFlag				;can't control yet
STA $0510                
STA $050B
STA $0512

LDA #$01                 
STA PhaseNo					;start from 25M
STA $0400
STA $0401

LDA #$00
STA $54                  
STA $0402                
STA $0403

LDA #$00					;but we had 00 loaded before... and before before.
STA $52						;
STA $0408					;
STA $0409					;
STA Sound_Music					;

LDA #$03					;set number of lives depending on whether we're in demo mode or not
LDX Demo_Active					;
BEQ CODE_CA06					;

LDA #$01					;only one life in demo so it ends upon death

CODE_CA06:
STA Jumpman_Lives				;
STA $0404                
STA $0405                
STA $040B

LDA Demo_Active					;initialize different variables if in demo mode
BNE CODE_CA26

LDA #$97					;transition is extended a bit because of sound effect
STA Timer_Transition				;

LDA #Sound_Fanfare_GameStart			;
STA Sound_Fanfare				;
  
LDA #$0F					;enable all sound channels
STA $4015					;
STA $0100					;and back up
RTS

CODE_CA26:
DEC $0518

LDA #$75                 
STA Timer_Transition
JMP CODE_CBAE

CODE_CA30:
JSR CODE_F4AC					;handle timer
   
LDA Demo_Active					;if game over during demo, simply end it
BNE CODE_CA4A					;

LDA Timer_Transition
CMP #$75
BEQ CODE_CA5A
CMP #$74
BEQ CODE_CA5F
CMP #$73
BEQ CODE_CA64  
CMP #$5F
BEQ CODE_CA79
RTS

CODE_CA4A:
STA Jumpman_Lives				;set lives

LDA #$00					;
STA Demo_Active					;but reset demo flag and initialize title screen
STA TitleScreen_MainCodeFlag			;

CODE_CA53:
JSR CODE_CBB7
JSR CODE_CBAE
RTS                      

CODE_CA5A:
DEC Timer_Transition
JMP CODE_CBAE
  
CODE_CA5F:
DEC $43                  
JMP CODE_CBCA

CODE_CA64:  
DEC $43

LDA $50                  
AND #$01                 
ASL A                    
TAX                      
LDA ScoreDisplay_Top
STA $0507,X

LDA ScoreDisplay_Top+1
STA $0508,X              
JMP CODE_CBF5
  
CODE_CA79:
LDX $52
LDA #$01                 
STA $0406,X
STA $4E

LDA $51						;check players
CMP #Players_2Players				;2-player mode?
BNE CODE_CA94					;if not, don't switch

LDA $52						;this is supposed to switch players? i think??? QUESTION MARK????????????
EOR #$01                 
TAX                      
LDA $0406,X              
STA $4E                  
BEQ CODE_CA99

CODE_CA94:  
STA $55                  
JMP CODE_CA53
  
CODE_CA99:
LDA #$85                 
STA $43
STA $040B

LDY #$00                 
STY $4F                  
STX $52                  
JMP CODE_CAA9					;these 1-byte jumps are kind of ridiculous.

CODE_CAA9:
LDY #$00

LOOP_CAAB:  
LDA $0400,X              
STA $0053,Y              
INX                      
INX                      
INY                      
CPY #$03                 
BNE LOOP_CAAB                
RTS                      

CODE_CAB9:
LDY #$00

LOOP_CABB: 
LDA $0053,Y              
STA $0400,X           
INX                      
INX                      
INY                      
CPY #$03                 
BNE LOOP_CABB                
RTS                      

CODE_CAC9:
JSR CODE_F4AC

LDA PhaseNo   
CMP #Phase_25M
BEQ CODE_CAD8

LDA Timer_Transition
CMP #$84
BEQ CODE_CB02

CODE_CAD8:  
LDA Timer_Transition

If Version = JP
  CMP #$74					;different compared values in Japenese version
  BCS CODE_CB18
  CMP #$6F
  BEQ CODE_CAE7
  CMP #$64                 
  BEQ CODE_CAFA  
else
  CMP #$72
  BCS CODE_CB18
  CMP #$6D                 
  BEQ CODE_CAE7
  CMP #$62                 
  BEQ CODE_CAFA
endif               
RTS

CODE_CAE7:          
LDA $040B                
BEQ CODE_CAF6

LDA #$00                 
STA $040B

DEC Jumpman_Lives				;decrease jumpman's life count
JSR CODE_CBBD

CODE_CAF6:  
JSR CODE_CC34
RTS                      

CODE_CAFA:
LDA #$01                 
STA $4F                  
JSR CODE_CC47
RTS                      

CODE_CB02:
LDX Players_CurrentPlayer			;load current pplayer in play
LDA $53						;check current phase
CMP $0400,X					;versus where player's supposed to go (?)
BEQ CODE_CB15                
CMP #$01                 
BEQ CODE_CB15
JSR CODE_CC24                
JSR CODE_CC04
  
CODE_CB15:
DEC $43                  
RTS

CODE_CB18:  
JMP CODE_CB1B					;another JMP that shouldn't be here

CODE_CB1B:
if Version = JP
CMP #$7A					;more different checks, except this time different code is also included
BEQ JP_CODE_CB28                
CMP #$75
BEQ JP_CODE_CB30
CMP #$74
BEQ JP_CODE_CB4C                
RTS                      

JP_CODE_CB28:
DEC $43                  
JSR CODE_CA53                
JMP JP_CODE_CBC6

JP_CODE_CB30:
JSR JP_CODE_CBB3

DEC $43                  
LDA $58                  
BNE JP_CODE_CB3D

LDA #$08                 
STA $FD                  

else
CMP #$7A                 
BEQ CODE_CB30					;revision 1 changes some checks and adds some
CMP #$75                 
BEQ CODE_CB39                
CMP #$74                 
BEQ CODE_CB36
CMP #$73                 
BEQ CODE_CB58                
CMP #$72                 
BEQ CODE_CB47
RTS
  
CODE_CB30:
JSR CODE_CA53                
JSR CODE_CBCA

CODE_CB36:
DEC $43                  
RTS

CODE_CB39:
JSR CODE_CBB7

DEC $43                  
LDA $58
BNE RETURN_CB46

LDA #$08
STA $FD

RETURN_CB46:
RTS
  
CODE_CB47:
DEC $43
endif

JP_CODE_CB3D:
LDX PhaseNo   
DEX                      
LDA DATA_C608,X              
STA $00

LDA #$20                 
STA $01                  
JMP CODE_EBA6

JP_CODE_CB4C:
CODE_CB58:
JSR CODE_D19A					;disable rendering

LDX PhaseNo					;get phase design
DEX						;
TXA						;
ASL A						;
JSR CODE_C807					;

LDA #$0A					;draw score 'n hud
JSR CODE_C807					;

LDA Players					;check players
CMP #Players_2Players				;
BEQ CODE_CB7B					;
      
LDA #$76					;VRAM location (indirect)
STA $00						;

LDA #$20					;($2076)
STA $01						;

LDA #$04					;erase II symbol and score display for second player if not in 2 player mode
JSR CODE_C815					;
  
CODE_CB7B:
LDA #$01
STA $0505
JSR CODE_D032    
JSR CODE_CBBD

LDA #$BC                 
STA $00                  
LDY $54                  
INY                      
JSR CODE_F4C2

LDA #$00					;
STA $2C						;

LDA #$80					;cap bonus score counter
DEY						;
CPY #$04					;
BPL CODE_CB9E					;however the logic is flawed. if value is 80+, it'll use incorrect table bytes (and cause killscreen)

LDA DATA_C207,Y					;load bonus points from table

CODE_CB9E:
STA ScoreDisplay_Bonus

LDA #$0D					;
STA Timer_BonusScoreDecrease			;

LDA #$02                 
STA $00                  
JSR CODE_F23C                
DEC Timer_Transition

If Version = JP
  LDA $58					;check if it's a demo mode
  BEQ JP_RETURN_CBA9

  LDA #$73					;set timer
  STA $43					;
endif

JP_RETURN_CBA9:
RTS

JP_CODE_CBAA:
CODE_CBAE:
LDA #$00
STA $04

LDA #$FF                 
JMP CODE_F092

;DisableRenderAndClearScreen_CBB7:
JP_CODE_CBB3:
CODE_CBB7:
JSR CODE_D19A					;no rendering
JMP CODE_F1B4					;clear screen

CODE_CBBD:
LDA #$B5                 
STA $00
   
LDA #$20 
STA $01
  
LDY $55
JMP CODE_F4C2

JP_CODE_CBC6:
CODE_CBCA:             
LDA $58                  
BNE RETURN_CBF4

LDA $51                  
CMP #$1C                 
BNE RETURN_CBF4

LDX $52
LDA $53                  
CMP $0400,X              
BNE RETURN_CBF4

LDY #$00

LOOP_CBDF:
LDA DATA_C6AA,Y
STA $0331,Y
BEQ CODE_CBEB                
INY                      
JMP LOOP_CBDF

CODE_CBEB:
LDA $52                  
BEQ RETURN_CBF4
  
LDA #$67
STA $0345
  
RETURN_CBF4:
RTS

CODE_CBF5:  
LDY #$00

LOOP_CBF7:
LDA DATA_C6C2,Y
STA $0331,Y              
BEQ RETURN_CC03                
INY                      
JMP LOOP_CBF7

RETURN_CC03:
RTS                      

CODE_CC04:
LDA Demo_Active					;don't process if in demo mode
BNE RETURN_CC23					;

LDX Players_CurrentPlayer			;
LDA $0408,X					;
BNE RETURN_CC23					;
TXA
TAY
CLC                      
ASL A                    
ASL A                    
TAX                      
LDA ScoreDisplay_Player1,X
CMP #$02                 
BCC RETURN_CC23

STA $0408,Y              
INC $55                  
JSR CODE_CBBD
  
RETURN_CC23:
RTS

CODE_CC24:
LDA ScoreDisplay_Bonus				;add bonus score to player's score
STA $00

LDA $52
ORA #$08                 
STA $01                  
JSR CODE_F342
JMP CODE_D032 

CODE_CC34:
LDA #$01
STA $0505
 
JSR CODE_D032
   
LDA #$00                 
STA $050B

JSR CODE_CCC1                
JMP CODE_D7F2

;phase late initialization (after phase start jingle plays out and gameplay actually begins)

CODE_CC47:
LDA #$00
TAX

CODE_CC4A:  
STA $59,X					;initialize RAM from 59-E2
STA $040D,X					;and $040D-$0496
INX						;
CPX #$89					;
BNE CODE_CC4A					;

LDA #$01
STA Platform_HeightIndex			;initial platform jumpman's standing on is the first
STA Jumpman_State				;
STA Jumpman_JumpSpeed				;
STA Hammer_OnScreenFlag				;
STA Hammer_OnScreenFlag+1			;
STA Hammer_JumpmanFrame				;
STA Kong_AnimationFlag				;always animate

LDA #$04
STA $97

LDA #$58
STA $043D

LDA #$20
STA $A2

LDA #$80
STA $18

LDA #$0A
STA $34
  
LDX $52
JSR CODE_CAB9

LDA #$BB                 
STA $39

LDA #$27                 
STA $44

LDA PhaseNo				;check phase
CMP #Phase_25M
BEQ CODE_CC99                
CMP #Phase_75M
BEQ CODE_CCA6

LDA #Sound_Music_100M
STA $FC                  
RTS                      

CODE_CC99:
LDA #$38                 
STA $36

LDA #$40                 
STA $43

LDA #$02                 
STA $FC                  
RTS                      

CODE_CCA6:
LDA #$20                 
STA $36
    
LDA #$50                 
STA $043F                
STA $0441                
STA $0443
 
LDA #$03                 
STA $0440                
STA $0442                
STA $0444                
RTS    

CODE_CCC1:
LDA $53                  
SEC                      
SBC #$01                 
ASL A                    
TAX                      
LDA DATA_C5A6,X              
STA $09

LDA DATA_C5A6+1,X              
STA $0A

LDX #$00                 
LDY #$00

LOOP_CCD6:                 
LDA ($09),Y              
CMP #$FE                 
BEQ RETURN_CCF3                
STA $00,X                
INY                      
INX                      
CPX #$05                 
BNE LOOP_CCD6
STY $86

LDA ($09),Y              
JSR CODE_F096

LDY $86                  
INY                      
LDX #$00                 
JMP LOOP_CCD6
  
RETURN_CCF3:
RTS                      

CODE_CCF4:
LDA $0450
BNE CODE_CD07

LDA #$01
STA $0450

LDA #$0A
STA $34

LDA #$10
STA $FD
RTS

CODE_CD07:
LDA $43                  
CMP #$58                 
BCC CODE_CD13

JSR CODE_F4AC                
JMP CODE_CD22

CODE_CD13:
JSR CODE_CC24
JSR CODE_CC04

LDA #$00                 
STA $43
STA $9A
JMP CODE_CA53
  
CODE_CD22:
LDA $43
CMP #$9F                 
BEQ CODE_CD45                
CMP #$9E                 
BEQ CODE_CD4A
CMP #$9D                 
BEQ CODE_CD4F
CMP #$9C                 
BEQ CODE_CD58
CMP #$9B                 
BEQ CODE_CD61                
CMP #$90                 
BCS CODE_CD66                
CMP #$86                 
BCS CODE_CD69                
CMP #$70                 
BCS CODE_CD6C                
RTS

CODE_CD45:  
DEC $43                  
JMP CODE_CD6F
  
CODE_CD4A:
DEC $43
JMP CODE_CD7F
  
CODE_CD4F:
LDY #$1C
DEC $43

LDA #$06                 
JMP CODE_C823
  
CODE_CD58:
LDY #$1C                 
DEC $43

LDA #$08                 
JMP CODE_C823
  
CODE_CD61:
DEC $43                  
JMP CODE_CD89

CODE_CD66:  
JMP CODE_CD9D

CODE_CD69:  
JMP CODE_CDB1
  
CODE_CD6C:
JMP CODE_CE24

CODE_CD6F:
LDY #$0C                 
LDA #$0A                 
JMP CODE_C823

LOOP_CD76:
LDA ($00),Y              
STA $0331,Y              
DEY                      
BPL LOOP_CD76                
RTS

CODE_CD7F:  
JSR CODE_CBAE

LDY #$16                 
LDA #$0C                 
JMP CODE_C823
  
CODE_CD89:
LDY #$0C                 
LDA #$0E                 
JSR CODE_C823

LDA #$03                 
STA $02
        
LDA #$18                 
STA $03
       
LDA #$50                 
JMP CODE_F08C

CODE_CD9D:  
LDA #$8D                 
STA $00

LDA #$20                 
STA $01

LDA $43                  
AND #$01                 
BEQ CODE_CDAE                
JMP CODE_EB89

CODE_CDAE:
JMP CODE_EB92
  
CODE_CDB1:
CMP #$8F                 
BNE CODE_CDD7                
DEC $43

LDY #$10                 
LDA #$10                 
JSR CODE_C823

LDA #$01                 
STA $FE

LDA #$68                 
STA $00

LDA #$3E                 
STA $01

CODE_CDCA:
LDA #$40
STA $02

LDA #$46                 
STA $03

LDA #$50                 
JMP CODE_F080

CODE_CDD7:  
LDA $0250                
CMP #$A0                 
BEQ CODE_CDEF
CMP #$FF                 
BEQ CODE_CDF3
CLC
ADC #$02                 
STA $01

LDA $0253                
STA $00                  
JMP CODE_CDCA

CODE_CDEF:  
LDA #$80  
STA $FE

CODE_CDF3:  
LDA #$18                 
STA $03

LDA #$50                 
JSR CODE_F08C

LDA #$EB
STA $00

LDA #$23 
STA $01

LDA #$12                 
JSR CODE_C815
      
LDA #$01                 
JMP CODE_CE0E					;another gem.

CODE_CE0E:
PHP                      
LDA #$8D                 
STA $00

LDA #$22                 
STA $01                  
PLP                      
BNE CODE_CE1F

LDA #$16                 
JMP CODE_C815

CODE_CE1F:   
LDA #$14                 
JMP CODE_C815

CODE_CE24:  
CMP #$85
BEQ CODE_CE2F

LDA $43                  
AND #$01                 
JMP CODE_CE0E

CODE_CE2F:
LDA #$04                 
STA $FD

LDY #$04                 
LDA #$18                 
JSR CODE_C823
   
LDA #$78                 
STA $00
    
LDA #$20                 
STA $01

LDA #$C8                 
STA $02

LDA #$22                 
STA $03

LDA #$B0                 
JSR CODE_F080
 
DEC $43
   
LDA #$A0                 
STA $00
    
LDA #$30                 
STA $01
   
LDA #$04                 
JSR CODE_EAD4

LDA #$00
JSR CODE_F086

;Pauline sprite tile Y positions
LDA #$28                 
STA $02E8                
STA $02EC

LDA #$30                 
STA $02F0                
STA $02F8

LDA #$38                 
STA $02F4                
STA $02FC                
RTS                      

;check for a bunch of flags, mostly player-related
CODE_CE7C:
LDA Demo_Active					;if it's demo time, keep going
BEQ CODE_CE94					;if not, run normal gameplay i think

LDA $0102					;
BNE CODE_CE8B					;
STA $4015					;disable sound channels. sure.
STA $0100					;

CODE_CE8B:
LDA $15                  
AND #$20					;check select button       
BEQ CODE_CE94					;otherwise keep demo on
JMP CODE_CF2B					;if pressed select, exit demo
  
CODE_CE94:
LDA Pause_Flag					;if the game is paused
BNE CODE_CEAE					;process almost nothing

LDA Pause_Timer					;if pause timer is clear, can continue
BEQ CODE_CEA2					;

DEC Pause_Timer					;count down
RTS						;

CODE_CEA2:
JSR CODE_CC04					;process score sprites, i think???
JSR CODE_CFA8					;erase score sprites

LDA Kong_DefeatedFlag				;check if we just defeated DK
CMP #$01					;
BNE CODE_CEB1					;if not, process jumpman's state

CODE_CEAE:  
JMP CODE_CF1C					;
  
CODE_CEB1:
LDA Hammer_DestroyingEnemy			;but before that, check if we're destoying an enemy
BEQ CODE_CEB8                			;if not, actually check jumpman's states
JMP CODE_CF13					;

CODE_CEB8:
LDA Jumpman_State				;
CMP #Jumpman_State_Dead				;if not dead, run like normal
BNE CODE_CEC1					;
JMP CODE_CF19					;otherwise, death. it's inevitable.

CODE_CEC1:
CMP #Jumpman_State_Falling			;jumpman is uncontrollable while mid-air
BEQ CODE_CED6					;
CMP #Jumpman_State_Jumping			;
BEQ CODE_CED6					;

LDA Demo_Active					;check if demo is active
BEQ CODE_CED3					;
   
JSR CODE_EBDA					;run demo inputs
JMP CODE_CED6					;run other routines

CODE_CED3:
JSR CODE_D175					;check player inputs & run game normally

CODE_CED6:
JSR CODE_EB06					;run gameplay routines
JSR CODE_EBB6
JSR CODE_D041
JSR CODE_D1A4
JSR CODE_EA5F                
JSR CODE_E1E5
JSR CODE_EE79
 
;handle different hazards depending on phase
LDA PhaseNo
CMP #Phase_75M			;handle springboards in phase 2
BEQ CODE_CF01
CMP #Phase_100M			;handle following fires in phase 3 
BEQ CODE_CF0D

JSR CODE_DA16			;barrels of phase 1   
JSR CODE_E19A                
JSR CODE_EC29
JMP CODE_CF1C
  
CODE_CF01:
JSR CODE_E834			;handle platform lifts
JSR CODE_E981                 
JSR CODE_EC29                
JMP CODE_CF1C
  
CODE_CF0D:
JSR CODE_EC29
JMP CODE_CF1C

CODE_CF13:  
JSR CODE_EE0C                
JMP CODE_CF1C

CODE_CF19:  
JSR CODE_D0C0
  
CODE_CF1C:
JSR CODE_CF42
  
LDA $0516					;if game is paused, return
BNE RETURN_CF2A

JSR CODE_D04C
JSR CODE_F4AC
  
RETURN_CF2A:
RTS

;exiting demo via select button
CODE_CF2B:
LDA #$01                 
STA $4E                  
STA $0512                
STA $55

LDA #$20
STA $44

LDA #$00                 
STA $58                  
STA $0510                
JMP CODE_CA53                

CODE_CF42:
LDA ControllerInput_Player1Previous		;if pressed start, pause
AND #Input_Start				;
BEQ CODE_CF8F					;

LDA Demo_Active					;check if demo mode was active, start game
BEQ CODE_CF55					;

LDA #$00					;no more demo
STA Demo_Active					;
  
LDA ControllerInput_Player1Previous		;and start game as normal (with last chosen option)
JMP CODE_C98A					;
  
CODE_CF55:
LDA ControllerInput_Player1Previous		;
CMP $0514					;holds pause and any other input, but it's most likely yo hold pause input (after all it IS set after pause input)
BEQ CODE_CF92					;check if it should unpause game
STA $0514					;fun fact - if you hold start button and press/release any other input, the game will pause/unpause. that means player technically can pause game with any button (with pause being held)

LDA Pause_Flag					;if the game wasn't paused, then pause it
BEQ CODE_CF7A					;

LDA Pause_Timer					;unpause game on timer
BNE RETURN_CF79					;
STA Pause_Flag					;reset pause flag

LDA $0F						;restore whatever music was playing before
STA Sound_Music					;

LDA RenderMirror				;enable sprite render when unpausing
AND #$EF					;
STA RenderMirror				;
JMP CODE_CF87					;disable pause flag (and play pause sound effect)
  
RETURN_CF79:
RTS						;

CODE_CF7A:
LDA #$01					;
STA Pause_Flag					;

LDA Sound_Music					;back up music to restore it after unpausing
STA $0F

LDA #Sound_Music_Silence        		;silence music     
STA Sound_Music					;
  
CODE_CF87:
LDA #Sound_Fanfare_GamePause			;set pause timer
STA Pause_Timer					;
STA Sound_Fanfare				;and sound effect (bit)
RTS						;

CODE_CF8F:
STA $0514
  
CODE_CF92:
LDA Pause_Timer					;if pause timer isn't set, return
BEQ CODE_CF9B

DEC Pause_Timer					;decrease pause timer every frame
RTS						;

CODE_CF9B:
LDA Pause_Flag					;
BNE CODE_CFA1					;if game was paused, disable sprites
RTS						;

CODE_CFA1:
LDA RenderMirror				;disable sprite render
ORA #$10					;
STA RenderMirror				;
RTS						;
 
;erase score sprite graphics
CODE_CFA8:
LDX #$00                 
LDY #$00

LOOP_CFAC:
LDA $41,X
BNE CODE_CFB8
   
LDA #$FF                 
STA $02C0,Y
STA $02C4,Y
  
CODE_CFB8:
INX                      
INY                      
INY                      
INY                      
INY                      
INY                      
INY
INY
INY
CPX #$02                 
BMI LOOP_CFAC                
RTS

;score sprite functionality (graphics, score addition)
;init?

CODE_CFC6:
LDY #$00					;Y into zero
STY $0F						;

JSR CODE_D008					;

CODE_CFCD:
LDA $02C0,Y					;check if OAM slot is free
CMP #$FF					;
BNE CODE_CFF9					;check next pair

LDA $05						;score's X-position
STA $02C3,Y					;
CLC						;
ADC #$08					;next tile is 8 pixels to the right
STA $02C7,Y					;

LDA $06						;Y-position
STA $02C0,Y
STA $02C4,Y

LDA DATA_C604,X					;load first score tile depending on what value (200, 300, etc.)
STA $02C1,Y

LDA #$D4					;00 ending tile for all values
STA $02C5,Y					;

LDX $0F						;load score sprite index i assume
LDA #$03					;timer
STA $41,X					;decreases every few frames i believe
RTS
  
CODE_CFF9:
INY						;get next OAM slot pair
INY
INY                      
INY                      
INY                      
INY                      
INY                      
INY                      
INC $0F                  
CPY #$10					;if no free OAM slot pair, return
BMI CODE_CFCD                
RTS                      

CODE_D008:
TXA           
PHA                      
TYA
PHA

;added score flag?
LDA $58                  
BNE CODE_D02A

;set-up for score addition to the counter
LDA $52                  
ORA #$18                 
STA $01

LDA DATA_C600,X 
STA $00

LDA $05						;save positions
PHA
LDA $06                  
PHA
JSR CODE_F342					;score routine
PLA
STA $06 
PLA 
STA $05
  
CODE_D02A:
JSR CODE_D032					;does something with score, as well?
PLA                      
TAY                      
PLA						;
TAX
RTS 

CODE_D032:
LDA $0505
ORA #$01
STA $0505

LDA #$F9 
STA $00 
JMP CODE_F435

CODE_D041:
LDA ScoreDisplay_Bonus				;if bonus score is less than 1000, play hurry up sound
CMP #$10					;
BPL RETURN_D04B

LDA #$20					;
STA $FC						;music
  
RETURN_D04B:
RTS

CODE_D04C:
LDA $9A                  
BNE CODE_D092

LDX PhaseNo
CPX #$04                 
BEQ CODE_D063

LDA $5A                  
BEQ RETURN_D0BF                
DEX  
LDA DATA_C1FA,X              
CMP $59                  
BEQ CODE_D074                
RTS
  
CODE_D063:
LDX #$00

LOOP_D065:
LDA $C1,X                
BEQ RETURN_D0BF                
INX                      
STX $044F                
CPX #$08                 
BNE LOOP_D065                
JMP CODE_D086
  
CODE_D074:
JSR CODE_EAE1

LDA #$04                 
JSR CODE_EAD4                
JSR CODE_EACD                
JSR CODE_F088

LDA #$02                 
STA Sound_Fanfare
  
CODE_D086:
LDA #Sound_Music_Silence
STA $FC

LDA #$01                 
STA $9A

LDA #$00                 
STA $3A                  

CODE_D092:  
LDA $3A                  
BNE RETURN_D0BF

INC $53                  
LDA $53                  
CMP #$02                 
BEQ CODE_D0A5
CMP #$05                 
BCS CODE_D0AA                
JMP CODE_D0B5
  
CODE_D0A5:
INC $53                  
JMP CODE_D0B5
  
CODE_D0AA:
LDA #$01                 
STA $53

INC $54                  
LDA #$A0                 
STA $43                  
RTS                      

CODE_D0B5:
LDA #$8D                 
STA $43

LDA #$00                 
STA $4F
STA $9A

RETURN_D0BF:
RTS

CODE_D0C0:
LDA #Sound_Music_Silence   
STA $FC
  
LDA #$10                 
JSR CODE_D9E6                
BEQ RETURN_D138

LDA $98                  
CMP #$FF                 
BEQ CODE_D130
  
LDA $98                  
BNE CODE_D0E4

LDA $58                  
BNE CODE_D0DD

LDA #$80                 
STA $FE
  
CODE_D0DD:
LDA #$40                 
STA $3A

INC $98
RTS
  
CODE_D0E4:
LDA $3A                  
BEQ CODE_D0F8                
CMP #$0E                 
BCC RETURN_D138

LDA Demo_Active					;if died during demo, stay silent
BNE CODE_D0F4					;

;player dies
LDA #Sound_Effect2_Dead				;
STA Sound_Effect2				;
  
CODE_D0F4:
LDA #$00                 
STA $3A

CODE_D0F8:
LDA $0201                
CMP #$6C                 
BCS CODE_D101

LDA #$6C
  
CODE_D101:
CLC                      
ADC #$04                 
CMP #$7C                 
BCC CODE_D11F

INC $98                  
LDA $98                  
CMP #$05                 
BEQ CODE_D115

LDA #$6C                 
JMP CODE_D11F
  
CODE_D115:
LDA $58                  
BEQ CODE_D11D

LDA #$7D                 
STA $3A

CODE_D11D:  
LDA #$7C
  
CODE_D11F:
STA $02                  
JSR CODE_EAE1                
JSR CODE_EACD                
JSR CODE_F082

LDA $98  
CMP #$05                 
BNE RETURN_D138

CODE_D130:
LDA #$FF                 
STA $98

LDA $3A
BEQ CODE_D139   

RETURN_D138:
RTS

CODE_D139:
LDX $52
JSR CODE_CAB9

LDA Jumpman_Lives				;if jumpman still has some lives to spare
BNE CODE_D14B					;just restart the phase

LDA #$01					;show title screen
STA $4E

LDA #$87   
STA $43   
RTS

;seems to be related with death (and player switching)
CODE_D14B:
LDA Players  
CMP #Players_2Players
BNE CODE_D169

LDA $52
EOR #$01                 
TAX                      
STX $52

LDA $0406,X              
BEQ CODE_D166

TXA
EOR #$01
TAX                      
STX $52						;don't switch players if one of them has game over'd    
JMP CODE_D169

CODE_D166:
JSR CODE_CAA9
  
CODE_D169:
LDA #$87                 
STA $43                  
STA $040B

LDA #$00                 
STA $4F                  
RTS                      

;GetPlayerInput_D175
CODE_D175:
LDA Players_CurrentPlayer			;which player  
ASL A						;get proper controller input address
TAX						;
  
LDA ControllerInput_Player1Previous,X		;either player 1 or 2
AND #Input_AllDirectional			;
STA Direction					;save direction input
BEQ CODE_D189					;don't bother with check if no input was made
LSR A						;
LSR A						;
BNE CODE_D189					;check if it was left or right

LDA Direction					;
STA Direction_Horz				;save horizontal direction

CODE_D189:
LDA Jumpman_State				;if player state isn't in normal state (aka if not airborm, dead, etc.)
CMP #Jumpman_State_Grounded			;
BNE RETURN_D199					;return

LDA ControllerInput_Player1Previous,X		;check player's input         
AND #Input_A					;press A - player'll jump
BEQ RETURN_D199

LDA #Jumpman_State_Jumping			;
STA Jumpman_State				;

RETURN_D199:
RTS						;

;disable rendering
;DisableRender_D19A:
CODE_D19A:
LDA RenderMirror				;disable sprite render, greyscale and background render
AND #$E7					;
STA RenderBits					;
STA RenderMirror				;
RTS						;

CODE_D1A4:
LDA $96                  
CMP #$01                 
BEQ CODE_D1BB

CODE_D1AA:
CMP #$02                 
BEQ CODE_D1C3
CMP #$04                 
BEQ CODE_D1C6
CMP #$08                 
BEQ CODE_D1C9
CMP #$0A                 
BEQ CODE_D1CC
RTS

CODE_D1BB:
JSR CODE_D1CF
LDA $96                  
JMP CODE_D1AA
  
CODE_D1C3:
JMP CODE_D37E

CODE_D1C6:
JMP CODE_D547

CODE_D1C9:
JMP CODE_D697                

CODE_D1CC:
JMP CODE_D6C6                

CODE_D1CF:
LDA $56                  
CMP #$01                 
BEQ CODE_D1E5
CMP #$02                 
BEQ CODE_D1E5       
CMP #$04                 
BEQ CODE_D1E2
CMP #$08                 
BEQ CODE_D1E2
RTS

CODE_D1E2:
JMP CODE_D28B

CODE_D1E5:
LDA #$DB                 
STA $0A

LDA #$36                 
JSR CODE_D9E8
BNE CODE_D1F3
JMP CODE_D275

CODE_D1F3:
JSR CODE_D990
BEQ CODE_D1F9
RTS

CODE_D1F9:
LDA $56                  
CMP #$02                 
BEQ CODE_D205

INC $0203                
JMP CODE_D208
  
CODE_D205:
DEC $0203

CODE_D208:  
JSR CODE_D2CB
STA $5A

LDA $0200                
JSR CODE_E016
STA $59

JSR CODE_D8EB
BEQ CODE_D233

LDX $53                  
CPX #$01                 
BNE CODE_D227
CLC                      
ADC $0200                
STA $0200
  
CODE_D227:
JSR CODE_D36A
CMP #$00
BEQ CODE_D233

LDA #Jumpman_State_Falling
STA Jumpman_State
RTS

CODE_D233:  
LDA $9B                  
BNE CODE_D23E

LDA #$01                 
STA $9B                  
JMP CODE_D275

;climbing a ladder
CODE_D23E:
LDA #$08                 
STA $FF

LDA #$00                 
STA $9B

LDA $97                  
BEQ CODE_D262
CMP #$08                 
BEQ CODE_D26D

LDA #$04                 
STA $97                  
LDA $85                  
BEQ CODE_D25B                
LDA #$00
JMP CODE_D25D
  
CODE_D25B:
LDA #$08
  
CODE_D25D:
STA $97                  
JMP CODE_D275
  
CODE_D262:
LDA #$04                 
STA $97

LDA #$00                 
STA $85                  
JMP CODE_D275
  
CODE_D26D:
LDA #$04                 
STA $97

LDA #$01                 
STA $85                  

CODE_D275:
JSR CODE_EAE1

LDA $97                  
STA $02                  
JSR CODE_EACD

LDA $56                  
CMP #$02                 
BEQ CODE_D288  
JMP CODE_F082

CODE_D288:
JMP CODE_F088

CODE_D28B:
JSR CODE_EAE1

LDA #$86                 
STA $02
   
LDA #$C1					;>DATA_C186 i think
STA $03                  
JSR CODE_EFEB

LDA $53                  
SEC                      
SBC #$01                 
ASL A                    
TAX                      
LDA DATA_C47B,X
STA $04

LDA DATA_C47B+1,X
STA $05

LDA DATA_C483,X
STA $06

LDA DATA_C483+1,X 
STA $07
  
JSR CODE_D8AD                
BEQ RETURN_D2CA

LDA $00                  
SEC                      
SBC #$04
STA $A1

LDA #$02                 
STA $96
  
LDA #$00                 
STA $5B                  
STA $5C
  
RETURN_D2CA:
RTS
  
CODE_D2CB:
JSR CODE_EAE1

LDA Jumpman_State
CMP #Jumpman_State_Jumping
BEQ CODE_D2DD
CMP #Jumpman_State_Falling
BEQ CODE_D2DD
 
LDA #$2C
JMP CODE_D2DF
  
CODE_D2DD:
LDA #$4A
  
CODE_D2DF:
JSR CODE_EFE8
 
LDA PhaseNo
CMP #$01                 
BEQ CODE_D2F0
SEC
SBC #$01                 
ASL A                    
TAX                      
JMP CODE_D2FD
  
CODE_D2F0:
LDA #$1A
JSR CODE_C831

JSR CODE_D91A
STA $0C                  
JMP CODE_D323
  
CODE_D2FD:
LDA UNUSED_C46B,X				;load used values offset from unused table
STA $04

LDA UNUSED_C46B+1,X
STA $05

LDA UNUSED_C473,X              
STA $06

LDA UNUSED_C473+1,X              
STA $07

JSR CODE_D8AD
STA $0C                  
BNE CODE_D323

LDA $53
CMP #$03
BNE CODE_D323

JSR CODE_D326                
STA $0C
  
CODE_D323:
LDA $0C                  
RTS

CODE_D326:    
LDA #$2A                 
JSR CODE_C847

LDA #$00                 
STA $D2

CODE_D32F:
LDA $D2                  
CMP #$06                 
BEQ CODE_D365
TAX                      
LDY DATA_C2CC,X  
LDA $0200,Y              
CMP #$FF
BEQ CODE_D34E
STA $01

LDA $0203,Y              
STA $00

JSR CODE_EFEF
CMP #$01                 
BEQ CODE_D353
  
CODE_D34E:
INC $D2                  
JMP CODE_D32F
  
CODE_D353:
LDA $D2                  
CMP #$03                 
BCS CODE_D35E

LDA #$01                 
JMP CODE_D360

CODE_D35E:
LDA #$02

CODE_D360:
STA $DA

LDA #$01                 
RTS
  
CODE_D365:
LDA #$00                 
STA $DA                  
RTS                      

;used to shift player when stepping on slightly higher platforms (when moving on sloped thing)
CODE_D36A:
LDA PhaseNo
CMP #Phase_25M					;
BEQ CODE_D373					;check if phase 1
JMP CODE_D37B
  
CODE_D373:
LDA #$1C					;offset data
JSR CODE_C831    
JMP CODE_D8AD
  
CODE_D37B:
LDA #$01
RTS                      

CODE_D37E:
LDA $56                  
CMP #$08                 
BEQ CODE_D38E
CMP #$04                 
BEQ CODE_D38B
JMP CODE_D4CF
  
CODE_D38B:
JMP CODE_D432
  
CODE_D38E:
LDA $5A                  
BEQ CODE_D39C
JSR CODE_EAE1

DEC $01                  
JSR CODE_D50A
BNE CODE_D3CD
  
CODE_D39C:
LDA #$24                 
STA $0A

LDA #$49                 
JSR CODE_D9E8
BNE CODE_D3AF

LDA $0200                
STA $01
JMP CODE_D4CF

CODE_D3AF:
JSR CODE_D50A                
BEQ CODE_D3E7
CMP #$02
BNE CODE_D3BB
JMP CODE_D4CF
  
CODE_D3BB:
LDA $5B                  
BEQ CODE_D3D0                
CLC                      
ADC #$01                 
CMP #$10                 
BEQ CODE_D3D2
BCC CODE_D3D2
  
LDA #$10					;\untriggered
JMP CODE_D3D2					;/
  
CODE_D3CD:
JMP CODE_D4CF
  
CODE_D3D0:
LDA #$01
  
CODE_D3D2:
STA $5B                  
TAX                      
DEX                      
LDA DATA_C147,X              
STA $02

LDA #$00                 
STA $5A                  
STA $5C                  
JSR CODE_D4EE                
JMP CODE_D40D
  
CODE_D3E7:
LDA $5C                  
BEQ CODE_D3F9
CLC                      
ADC #$01                 
CMP #$06                 
BEQ CODE_D3FB
BCC CODE_D3FB

LDA #$01                 
JMP CODE_D3FB
  
CODE_D3F9:
LDA #$02
  
CODE_D3FB:
STA $5C                  
TAX                      
DEX                      
LDA $C159,X              
STA $02                  
LDA #$00                 
STA $5A                  
STA $5B                  
JSR CODE_D4EE
  
CODE_D40D:
LDA $A1						;player's X-position
STA $00
STA $0203					;sprite tile's X-position
JSR CODE_EAD1

LDA #$00                 
STA $04
 
LDA $02
CMP #$54
BEQ CODE_D426

LDA #$00
JMP CODE_D42C
  
CODE_D426:
LDA #$24                 
STA $02

LDA #$01
  
CODE_D42C:
JSR CODE_F096                
JMP CODE_D4CF
  
CODE_D432:
LDA $5A                  
BEQ CODE_D445

JSR CODE_EAE1

INC $01                  
JSR CODE_D50A                
CMP #$01                 
BEQ CODE_D445
JMP CODE_D4CF
  
CODE_D445:
LDA #$24                 
STA $0A

LDA #$49                 
STA $0B
JSR CODE_D9E6
BNE CODE_D45A

LDA $0200                
STA $01
JMP CODE_D4CF

CODE_D45A:
JSR CODE_D50A                
BEQ CODE_D48B                
CMP #$02                 
BEQ CODE_D48B

LDA $5B                  
BEQ CODE_D471
SEC                      
SBC #$01                 
CMP #$01                 
BCC CODE_D476                
JMP CODE_D478
  
CODE_D471:
LDA #$0D                 
JMP CODE_D478
  
CODE_D476:
LDA #$01
  
CODE_D478:
STA $5B                  
TAX                      
DEX                      
LDA DATA_C147,X              
STA $02

LDA #$03                 
STA $5C                  
JSR CODE_D4F9                
JMP CODE_D4B1

CODE_D48B:  
LDA $5C                  
BEQ CODE_D49D                
CLC                      
ADC #$01                 
CMP #$06                 
BEQ CODE_D49F                
BCC CODE_D49F

LDA #$01                 
JMP CODE_D49F
  
CODE_D49D:
LDA #$01					;inaccessible?

CODE_D49F:
STA $5C                  
SEC                      
SBC #$01                 
TAX                      
LDA DATA_C159,X              
STA $02

LDA #$00                 
STA $5B                  
JSR CODE_D4F9
  
CODE_D4B1:
LDA $A1						;X-position
STA $0203                
STA $00

JSR CODE_EACD

LDA $02                  
CMP #$54                 
BEQ CODE_D4C6

LDA #$00                 
JMP CODE_D4CC
  
CODE_D4C6:
LDA #$24                 
STA $02                  
LDA #$01
  
CODE_D4CC:
JSR CODE_F096
  
CODE_D4CF:
JSR CODE_D2CB                
STA $5A
BEQ RETURN_D4ED

LDA $0200                
CLC
ADC #$08                 
JSR CODE_E016					;
STA $59

LDA #$01                 
STA $96

LDA #$00                 
STA $5C                  
STA $5B                  
STA $85

RETURN_D4ED:
RTS                      

;moving sprite tile vertically. Hmm...
CODE_D4EE:
LDA $0200                
SEC                      
SBC #$01                 
STA $01                  
JMP CODE_D501                

CODE_D4F9:
LDA $0200                
CLC                      
ADC #$01                 
STA $01
  
CODE_D501:
AND #$06                 
BNE RETURN_D509

;every 6 pixels, make a movement sound
LDA #$08
STA $FF

RETURN_D509:
RTS
  
CODE_D50A:
JSR CODE_EAE1

LDA #$2C                 
JSR CODE_EFE8

LDA $53                  
SEC                      
SBC #$01                 
ASL A                    
TAX                      
LDA DATA_C48B,X
STA $04

LDA DATA_C48B+1,X              
STA $05

LDA #$43					;indirect addressing set-up?
STA $06

LDA #$C1
STA $07
JSR CODE_D8AD                
STA $08

LDA $53                  
CMP #$01                 
BNE CODE_D544

LDA #$1E                 
JSR CODE_C831
JSR CODE_D8AD                
BEQ CODE_D544

LDA #$02                 
STA $08
  
CODE_D544:
LDA $08                  
RTS                      

CODE_D547:
LDA #$FF                 
JSR CODE_D9E6                
CMP #$00					;FeelsBadMan
BNE CODE_D551                
RTS						;untriggered

CODE_D551:
LDA $94
CMP #$F0
BCC CODE_D55A
JMP CODE_D60D

CODE_D55A:
JSR CODE_D990
BEQ CODE_D570

LDA $56
CMP #$01
BNE CODE_D56A

LDA #$02
JMP CODE_D56C
  
CODE_D56A:
LDA #$01
  
CODE_D56C:
STA $56
STA $57

CODE_D570:  
LDA $0200                
STA $01

LDA #$00                 
JSR CODE_EF72

LDA $01                  
STA $0200

LDA $56                  
CMP #$01                 
BEQ CODE_D58C
CMP #$02                 
BEQ CODE_D5A1
JMP CODE_D5B3

CODE_D58C:
LDA $9E
BEQ CODE_D59A

INC $0203

LDA #$00                 
STA $9E                  
JMP CODE_D5B3
  
CODE_D59A:
LDA #$01                 
STA $9E                  
JMP CODE_D5B3
  
CODE_D5A1:
LDA $9E                  
BEQ CODE_D5AF

DEC $0203

LDA #$00                 
STA $9E                  
JMP CODE_D5B3
  
CODE_D5AF:
LDA #$01                 
STA $9E
  
CODE_D5B3:
LDA $0203                
STA $00
JSR CODE_D800

LDA $94                  
BEQ CODE_D5E2

LDA $01                  
SEC                      
SBC #$10                 
CMP $95                  
BCC CODE_D5CC

LDA #$FF                 
STA $95
  
CODE_D5CC:
JSR CODE_D2CB
STA $5A                  
BEQ CODE_D5F1

LDA $4B                  
SEC                      
SBC #$11                 
STA $0200

LDA #$01                 
STA $5A                  
JMP CODE_D5F6

;Jumpman performs jump action
CODE_D5E2:
LDA #$04                 
STA $FF
     
LDA #$01                 
STA $94

LDA $01                  
STA $95                  
JMP CODE_D5F1					;sighio
  
CODE_D5F1:
LDA #$28                 
JMP CODE_F070

CODE_D5F6:
JSR CODE_EAE1

LDA #$2C                 
STA $02                  
JSR CODE_EACD

LDA $57                  
AND #$03                 
LSR A                    
JSR CODE_F096

LDA #$F0                 
STA $94                  
RTS

CODE_D60D:
INC $94                  
LDA $94                  
CMP #$F4                 
BNE RETURN_D64F

LDA $95                  
CMP #$FF                 
BEQ CODE_D642

LDA #$04                 
JSR CODE_F070

LDA #$00                 
STA $042C                
STA $94                  
STA $95

LDA #$01                 
STA $96
   
LDA $A0                  
BEQ RETURN_D64F


;Jumpman picked up a hammer
LDA #$01                 
STA $9F

LDA #$4B					;hammer timer
STA Timer_Hammer

LDA #Jumpman_State_Hammer
STA Jumpman_State
 
LDA #Sound_Music_Hammer
STA $FC                  
RTS                      

CODE_D642:
LDA #$00                 
STA $042C
STA $94                  
STA $95
   
LDA #$FF                 
STA $96
  
RETURN_D64F:
RTS                      


;----------------------------------------------
;!UNUSED
;unknown block of code. collision related?

UNUSED_D650:
LDA #$FE                 
STA $0472                
STA $0473

LDX #$00                 
LDY #$60

CODE_D65C:
LDA $0200,Y              
CMP #$FF                 
BEQ CODE_D672                
STA $0461,X

LDA $0203,Y              
SEC                      
SBC #$08                 
STA $0460,X              
JMP CODE_D67A
  
CODE_D672:
LDA #$00                 
STA $0461,X              
STA $0460,X
  
CODE_D67A:
TYA                      
CLC                      
ADC #$08                 
TAY                      
INX                      
INX                      
INX                      
CPY #$90                 
BNE CODE_D65C

LDA #$20                 
JSR CODE_C831                
JSR CODE_D8AD
BEQ RETURN_D696

LDA #$08                 
STA $96
  
LDA #$01

RETURN_D696:
RTS
;----------------------------------------------

CODE_D697:
LDA #$FF                 
JSR CODE_D9E6                
BEQ RETURN_D6C5

JSR CODE_EAE1 
INC $01                  
INC $01

LDA $57                  
CMP #$02                 
BEQ CODE_D6B1

LDA $0201                
JMP CODE_D6B7

CODE_D6B1:  
LDA $0201                
SEC                      
SBC #$02

CODE_D6B7:  
STA $02
  
JSR CODE_F075
JSR CODE_D2CB
BEQ RETURN_D6C5
      
LDA #$FF					;
STA Jumpman_State				;Jumpman dies
  
RETURN_D6C5:
RTS
  
CODE_D6C6:
LDA $3F                  
BNE CODE_D6CD
JMP CODE_D7BF

CODE_D6CD:
LDA #$DB                 
STA $0A

LDA #$36                 
JSR CODE_D9E8                
BNE CODE_D6D9
RTS

CODE_D6D9:
JSR CODE_D990
BNE CODE_D6E8

LDA $56                  
CMP #$01                 
BEQ CODE_D70A
CMP #$02                 
BEQ CODE_D710

CODE_D6E8:  
LDA $A2                  
ASL A                    
STA $A2                  
BEQ CODE_D6F2
JMP CODE_D753

CODE_D6F2:  
LDA #$20                 
STA $A2

LDA $9F                  
BEQ CODE_D6FE   
CMP #$04                 
BCC CODE_D703

CODE_D6FE:
LDA #$02                 
JMP CODE_D705

CODE_D703: 
LDA #$05
  
CODE_D705:
STA $9F                  
JMP CODE_D753
  
CODE_D70A:
INC $0203                
JMP CODE_D713

CODE_D710:  
DEC $0203
  
CODE_D713:
JSR CODE_D2CB    
STA $5A

LDA $0200
JSR CODE_E016
STA $59
JSR CODE_D8EB
BEQ CODE_D73E

LDX $53                  
CPX #$01                 
BNE CODE_D732
CLC                      
ADC $0200                
STA $0200

CODE_D732:  
JSR CODE_D36A
BEQ CODE_D73E

LDA #Jumpman_State_Falling
STA Jumpman_State
JMP CODE_D7BF
  
CODE_D73E:
LDA #$08                 
STA $FF

LDA $9F                  
BEQ CODE_D74F                
CMP #$06                 
BCS CODE_D74F

INC $9F
JMP CODE_D753
  
CODE_D74F:
LDA #$01                 
STA $9F
  
CODE_D753:
LDX $9F                  
DEX                      
LDA DATA_C1A2,X              
JSR CODE_F070
    
LDA $9F                  
LSR A                    
LSR A                    
BEQ CODE_D767

LDA #$00                 
JMP CODE_D769
  
CODE_D767:
LDA #$01
  
CODE_D769:
BEQ CODE_D786
    
LDA #$04                 
CLC                      
ADC $0203                
STA $00

LDA $0200                
SEC                      
SBC #$0E                 
STA $01

LDA #$21                 
STA $03

LDA #$F6                 
STA $02                  
JMP CODE_D7AD
  
CODE_D786:
LDA $57                  
CMP #$01                 
BNE CODE_D795

LDA #$0E
CLC
ADC $0203                
JMP CODE_D79B
  
CODE_D795:
LDA $0203                
SEC                      
SBC #$0E

CODE_D79B:  
STA $00

LDA #$06                 
CLC                      
ADC $0200                
STA $01

LDA #$12                 
STA $03

LDA #$FA                 
STA $02

CODE_D7AD:  
LDA $A0                  
CMP #$01                        
BEQ CODE_D7B8

LDA #$D8                 
JMP CODE_D7BA
  
CODE_D7B8:
LDA #$D0
  
CODE_D7BA:
STA $04                  
JMP CODE_F078

CODE_D7BF:
LDA #$12                 
STA $03

LDA $A0                  
CMP #$01                 
BEQ CODE_D7D3

LDA #$00                 
STA $0452

LDA #$D8                 
JMP CODE_D7DA

CODE_D7D3:  
LDA #$00                 
STA $0451

LDA #$D0
  
CODE_D7DA:
STA $04                  
JSR CODE_F094
JSR CODE_D7F2

LDA #$01					;jumpman is grounded
STA Jumpman_State

LDA #$00                 
STA $A0                  
STA $9F

LDA $0519                
STA $FC                  
RTS                      

CODE_D7F2:
LDA #$19                 
STA $00

LDA #$3F                 
STA $01

LDA #$4E                 
JSR CODE_C815
RTS

CODE_D800:
LDA $A0                  
BEQ CODE_D805                
RTS

CODE_D805:
LDY $53                  
CPY #$03                 
BNE CODE_D80E
JMP CODE_D8A8
  
CODE_D80E:
LDA $0203                
CPY #$01                 
BEQ CODE_D81E                
CMP #$88                 
BEQ CODE_D827                
BCC CODE_D827                
JMP CODE_D8A8

CODE_D81E:  
CMP #$28                 
BEQ CODE_D827  
BCC CODE_D827
JMP CODE_D8A8

CODE_D827:  
LDA $0200                
CLC                      
ADC #$08                 
JSR CODE_E016
STA $59

LDA $53                  
SEC                      
SBC #$01                 
ASL A                    
TAX                      
LDA $59                  
CMP DATA_C1A8,X              
BEQ CODE_D849                
INX                      
CMP DATA_C1A8,X              
BEQ CODE_D849                
JMP CODE_D8A8
  
CODE_D849:
TXA                      
AND #$01                 
BEQ CODE_D867

LDA $0452                
BNE CODE_D856                
JMP CODE_D8A8
  
CODE_D856:
LDA #$02                 
STA $A0

LDA $02D8                
STA $01

LDA $02DB                
STA $00                  
JMP CODE_D87D

CODE_D867:
LDA $0451                
BNE CODE_D86F
JMP CODE_D8A8

CODE_D86F:
LDA #$01                 
STA $A0

LDA $02D0                
STA $01

LDA $02D3                
STA $00

CODE_D87D:  
LDA #$2E                 
JSR CODE_EFE8                
JSR CODE_EAE1

LDA #$30                 
JSR CODE_C847

JSR CODE_EFEF                
BEQ CODE_D8A8

LDA $FC                  
STA $0519

LDA $53                  
CMP #$04                 
BNE RETURN_D8A7

LDA #$19                 
STA $00

LDA #$3F                 
STA $01

LDA #$46                 
JSR CODE_C815
  
RETURN_D8A7:
RTS
  
CODE_D8A8:
LDA #$00                 
STA $A0                  
RTS                      

CODE_D8AD:
LDA #$F3
STA $0B

LDA #$00
STA $86

LDY #$00                 
LDA ($04),Y

LOOP_D8B9:
STA $00                  
INY                      
LDA ($04),Y              
STA $01                  
INY                      
LDA ($04),Y              
CLC                      
ADC $06                  
STA $02

LDA $07                  
ADC #$00                 
STA $03

STY $86                  
JSR CODE_EFF3
BNE CODE_D8E1
  
LDY $86                  
INY                      
LDA ($04),Y              
CMP #$FE
BEQ CODE_D8E6
JMP LOOP_D8B9

CODE_D8E1:  
LDA #$01                 
JMP CODE_D8E8
  
CODE_D8E6:
LDA #$00

CODE_D8E8:  
STA $0C                  
RTS                      

CODE_D8EB:
LDA $5A                  
BNE CODE_D917

LDA $59                  
BEQ CODE_D917
AND #$01                 
BNE CODE_D904

LDA $56                  
CMP #$01                 
BEQ CODE_D914                
CMP #$02                 
BEQ CODE_D911                
JMP CODE_D917

CODE_D904:
LDA $56                  
CMP #$01                 
BEQ CODE_D911                
CMP #$02                 
BEQ CODE_D914                
JMP CODE_D917
  
CODE_D911:
LDA #$FF                 
RTS
  
CODE_D914:
LDA #$01
RTS

CODE_D917:
LDA #$00
RTS

;(phase 1 only)
;collision with curved platforms?
;probably with slightly curved platforms/slope platforms/what ever the hell
CODE_D91A:
LDA $0200					;get player's Y position
CLC						;and add 8
ADC #$08					;
JSR CODE_E016					;
STA $59						;if player's on the very low platform (at the beginning)
CMP #$01					;
BEQ CODE_D938					;don't do smth

LDX #$02					;
LDA #$0C					;

LOOP_D92D:
CPX $59						;check if it is a platform 2 onward
BEQ CODE_D93B					;
CLC						;
ADC #$06					;offset by platform
INX						;
JMP LOOP_D92D					;
  
CODE_D938:
SEC						;-1 (because phase counts from 1)
SBC #$01					;

CODE_D93B:
TAX						;and into index

LOOP_D93C:          
LDA #$00					;
STA $86						;

LDA DATA_C08C,X					;
STA $00						;

INX						;
LDA DATA_C08C,X					;
STA $01						;

INX						;
LDA DATA_C08C,X					;
CLC						;
ADC $06						;
STA $02						;

LDA $07						;
STA $03						;

INX						;
LDA DATA_C08C,X					;
STA $08						;

INX						;
LDA DATA_C08C,X					;
STA $09						;

LOOP_D964:
JSR CODE_EFEF					;check if on platform
BNE CODE_D98B					;

LDA $00						;
CLC						;
ADC $08						;
STA $00						;
  
DEC $01						;
INC $86						;check slightly higher

LDA $09
CMP $86
BNE LOOP_D964
INX
LDA DATA_C08C,X					;
CMP #$FE					;end command
BEQ CODE_D986					;if not on any platform, not grounded
INX						;
JMP LOOP_D93C
  
CODE_D986:
LDA #$00
JMP CODE_D98D
  
CODE_D98B:
LDA #$01

CODE_D98D:
STA $5A                  
RTS                      

CODE_D990:
LDA $56                  
CMP #$01
BEQ CODE_D99D
CMP #$02                 
BEQ CODE_D9AF                
JMP CODE_D9E3

CODE_D99D:  
LDA $53                  
ASL A                    
TAX                      
DEX                      
LDA DATA_C1B4,X              
CMP $0203                
BEQ CODE_D9E0                
BCC CODE_D9E0      
JMP CODE_D9E3
  
CODE_D9AF:
LDA $53                  
ASL A                    
TAX                      
DEX                      
DEX                      
LDA DATA_C1B4,X              
CMP $0203                
BCS CODE_D9E0
 
LDA $53                  
CMP #$04                 
BEQ CODE_D9E3

LDX $59                  
CMP #$03                 
BEQ CODE_D9D0                
CPX #$06                 
BNE CODE_D9E3                
JMP CODE_D9D4
  
CODE_D9D0:
CPX #$05                 
BNE CODE_D9E3

CODE_D9D4:  
LDA $0203                
CMP #$68                 
BEQ CODE_D9E0 
BCC CODE_D9E0
JMP CODE_D9E3
  
CODE_D9E0:
LDA #$01                 
RTS
  
CODE_D9E3:
LDA #$00
RTS

CODE_D9E6:
STA $0A
 
CODE_D9E8:
STA $0B
  
INC $88    
LDA $88                  
CMP #$0F                 
BCS CODE_D9F5                
JMP CODE_D9F9

CODE_D9F5:
LDA #$00                 
STA $88

CODE_D9F9:  
CMP #$08                 
BCS CODE_DA06                
TAX                      
LDA DATA_C1BC,X              
AND $0A                  
JMP CODE_DA0F

CODE_DA06:  
SEC                      
SBC #$08                 
TAX                      
LDA DATA_C1BC,X              
AND $0B
  
CODE_DA0F:
BEQ CODE_DA13

LDA #$01

CODE_DA13: 
STA $BE                  
RTS

CODE_DA16:
JSR CODE_E166

LDA #$00                 
STA $5D

JP_LOOP_DA19:
LOOP_DA1D:
JSR CODE_EFD5

LDA $0200,X              
CMP #$FF                 
BNE CODE_DA3D

LDA $36                  
BNE CODE_DA40

LDA #$80
LDX $5D                  
STA $5E,X

LDA #$10                 
STA $37

JSR CODE_EAF7                
LDA CODE_C443,X              
STA $36
  
CODE_DA3D:
JSR CODE_DA4C
  
CODE_DA40:
LDA $5D                  
CLC
ADC #$01                 
STA $5D                  
CMP #$09

If Version = JP
BEQ JP_RETURN_DA4A
JMP JP_LOOP_DA19
else
BNE LOOP_DA1D					;wow, they actually optimized something in this code in revision 1! :clap: :clap: :clap:
endif

JP_RETURN_DA4A:
RTS
  
CODE_DA4C:
LDX $5D                  
LDA $5E,X                
CMP #$80                 
BEQ CODE_DA7D                
CMP #$81                 
BEQ CODE_DA80                
CMP #$01                 
BEQ CODE_DA83                
CMP #$02                 
BEQ CODE_DA86                
CMP #$C0                 
BEQ CODE_DA89
CMP #$C1                 
BEQ CODE_DA89  
CMP #$C2                 
BEQ CODE_DA89
CMP #$08                 
BEQ CODE_DA8F                
CMP #$10                 
BEQ CODE_DA92                
CMP #$20                 
BEQ CODE_DA95                
CMP #$40                 
BEQ CODE_DA98                
RTS						;unused RTS. cool.

CODE_DA7D:
JMP CODE_DA9C

CODE_DA80:
JMP CODE_DB00

CODE_DA83:
JMP CODE_DB2C

CODE_DA86:
JMP CODE_DC30

CODE_DA89:
LDA $0421,X              
JMP CODE_DD8B

CODE_DA8F:
JMP CODE_DC69

CODE_DA92:  
JMP CODE_DCD0
  
CODE_DA95:
JMP CODE_DD32
  
CODE_DA98:
JSR CODE_DF07                
RTS

CODE_DA9C:     
JSR CODE_EFD5

LDA #$30                 
STA $00

If Version = JP
LDA #$30					;another minor optimization they did in revision 1. we had 30 already loaded before. question is... why didn't they clean it up ENTIRELY?
endif
STA $01

LDA #$90                 
STA $02                  
STX $04                  
JSR CODE_EADB

LDA $37                  
BNE RETURN_DAFF

LDA #$81                 
LDX $5D                  
STA $5E,X
   
LDA #$00                 
STA $8A,X

LDA $AD                  
BEQ CODE_DAC3                
JMP CODE_DAD5

CODE_DAC3:
LDA $5D                  
BNE RETURN_DAFF

LDA #$C0                 
LDX $5D                  
STA $5E,X

LDA #$01                 
STA $0421,X              
JMP CODE_DAF7

CODE_DAD5:
LDA $43                  
BNE RETURN_DAFF

LDA $5D						;ORA - exists
BNE RETURN_DAFF					;Nintendo - lol, no

LDA #$C0
LDX $5D
STA $5E,X

LDA $0421,X
CMP #$01
BNE CODE_DAF2

LDA #$03                 
STA $0421,X              
JMP CODE_DAF7
  
CODE_DAF2:
LDA #$01                 
STA $0421,X
  
CODE_DAF7:
JSR CODE_EAF7

LDA DATA_C44D,X              
STA $43
  
RETURN_DAFF:
RTS

;barrel tossed to the side
CODE_DB00:
LDA #$55
JSR CODE_DFE4                
BNE CODE_DB21

JSR CODE_EFD5

LDA #$4D                 
STA $00

LDA #$32                 
STA $01

LDA #$84                 
STA $02                  
STX $04                  
JSR CODE_EADB

INC $0515                
JMP RETURN_DB2B
  
CODE_DB21:
LDX $5D
 
LDA #$01                 
STA $5E,X

LDA #$84                 
STA $72,X
  
RETURN_DB2B:
RTS

;barrel movement?
CODE_DB2C:
LDA #$FF                 
JSR CODE_DFE4                
BNE CODE_DB34                
RTS						;untriggered

CODE_DB34:
JSR CODE_EFD5                
PHA                      
JSR CODE_EAEC

LDA $01                  
JSR CODE_E016

LDY $5D                  
STA $0068,Y              
AND #$01                 
BNE CODE_DB4E
INC $00                  
JMP CODE_DB50
  
CODE_DB4E:
DEC $00
  
CODE_DB50:
LDA $00                  
JSR CODE_E05A 
STA $7D
  
JSR CODE_E048                
CLC                      
ADC $01                  
STA $01
 
JSR CODE_DBEE

LDX $5D                  
LDA $72,X                
JSR CODE_EAD4                
PLA                      
TAX                      
JSR CODE_F080

LDA $00                  
JSR CODE_E0AE                
BEQ CODE_DBAC

JSR CODE_EAF7
LDA DATA_C448,X					;
AND RNG_Value+1					;$19
BNE CODE_DBAC					;

LDX $5D                  
LDA $68,X                
TAX                      
DEX                      
LDA $7E,X                
CMP #$04
BCS CODE_DBAC

LDA Jumpman_State				;if not on ladder, skip something
CMP #$02                 
BNE CODE_DBA3

LDX $04                  
LDA $0200,X					;check collision?
CMP $0200                
BCS CODE_DBA3                
CLC                      
ADC #$0F                 
CMP $0200                
BCS CODE_DBAC
  
CODE_DBA3:
LDA #$02                 
LDX $5D                  
STA $5E,X                
DEC $68,X                
RTS
  
CODE_DBAC:
LDA $00                  
JSR CODE_E090                
BEQ CODE_DBB6                
JMP CODE_DBE7
  
CODE_DBB6:
JSR CODE_DF40

LDX $5D                  
LDA $68,X                
CMP #$01                 
BNE RETURN_DBED                
JSR CODE_DFC3

LDA $00                  
CMP #$20                 
BEQ CODE_DBCD                
BCC CODE_DBCD       
RTS

CODE_DBCD:    
LDA #$03                 
STA $02
 
LDA #$04                 
STA $03
 
JSR CODE_F08E
    
LDA #$01                 
STA $AD
    
LDA #$00                 
LDX $5D                  
STA $68,X

LDA #$80                 
STA $FE                  
RTS                      

CODE_DBE7:
LDX $5D                  
LDA #$08                 
STA $5E,X
  
RETURN_DBED:
RTS                      

CODE_DBEE:
LDX $5D                  
INC $040D,X              
LDA $040D,X              
CMP #$06                 
BCS CODE_DBFB                
RTS

CODE_DBFB:
LDA #$00                 
STA $040D,X

LDA $68,X                
AND #$01                 
BEQ CODE_DC1B

LDA $72,X                
CLC                      
ADC #$04                 
CMP #$80                 
BCC CODE_DC16                
CMP #$90                 
BCS CODE_DC16      
JMP CODE_DC2D
  
CODE_DC16:
LDA #$80                 
JMP CODE_DC2D

CODE_DC1B:  
LDA $72,X                
SEC                      
SBC #$04                 
CMP #$80                 
BCC CODE_DC2B                
CMP #$90                 
BCS CODE_DC2B      
JMP CODE_DC2D

CODE_DC2B:
LDA #$8C
  
CODE_DC2D:
STA $72,X                
RTS

CODE_DC30:
LDA #$55                 
JSR CODE_DFE4                
BEQ RETURN_DC68                
JSR CODE_EFD5                
STX $04
 
JSR CODE_EAEC                
INC $01

LDY $5D                  
LDA $0072,Y              
CMP #$90                 
BNE CODE_DC4F

LDA #$94                 
JMP CODE_DC51
  
CODE_DC4F:
LDA #$90

CODE_DC51:  
STA $02

LDX $5D                  
STA $72,X                
JSR CODE_EADB

LDA $01                  
LDX $5D                  
CMP $A3,X                
BNE RETURN_DC68

LDX $5D                  
LDA #$01                 
STA $5E,X
  
RETURN_DC68:
RTS

CODE_DC69:    
LDA #$FF                 
JSR CODE_DFE4                
BNE CODE_DC71                
RTS						;untriggered

CODE_DC71:
JSR CODE_EFD5                
STX $04

JSR CODE_EAEC

INC $01                  
LDA $01                  
AND #$01
BEQ CODE_DC90

LDX $5D                  
LDA $68,X                
AND #$01                 
BEQ CODE_DC8E                
DEC $00                  
JMP CODE_DC90

CODE_DC8E:
INC $00
  
CODE_DC90:
JSR CODE_DBEE

LDX $5D                  
LDA $72,X                
STA $02
JSR CODE_EADB

LDA #$32                 
JSR CODE_C853

LDA $01                  
JSR CODE_E112
BEQ RETURN_DCCF

LDX $5D                  
LDA #$10                 
STA $5E,X                
JSR CODE_E130                
BEQ CODE_DCBC

LDA $19                  
AND #$01                 
BEQ CODE_DCBC                
JMP CODE_DCC9
  
CODE_DCBC:
LDX $5D                  
LDA $68,X                
TAX                      
DEX                      
LDA $7E,X                
CMP #$04                 
BCS CODE_DCC9                
RTS                      

CODE_DCC9:
LDX $5D                  
LDA #$20
STA $5E,X
  
RETURN_DCCF:
RTS                      

CODE_DCD0:
LDA #$77                 
JSR CODE_DFE4
BNE CODE_DCD8                
RTS

CODE_DCD8:
JSR CODE_EFD5                
STX $04

JSR CODE_EAEC

LDA $01                  
JSR CODE_E016                
LDX $5D                  
STA $68,X                
AND #$01                 
BNE CODE_DD00

INC $00                  
LDA $00                  
LDX #$00

LOOP_DCF3:
CMP DATA_C3FC,X              
BEQ CODE_DD13                
INX                      
CPX #$0B                 
BEQ CODE_DD25                
JMP LOOP_DCF3
  
CODE_DD00:
DEC $00                  
LDA $00                  
LDX #$00

LOOP_DD06:
CMP DATA_C412,X              
BEQ CODE_DD13                
INX                      
CPX #$0B                 
BEQ CODE_DD25                
JMP LOOP_DD06
  
CODE_DD13:
LDA $01                  
CLC                      
ADC DATA_C407,X              
STA $01                  
CPX #$0A                 
BNE CODE_DD25

LDX $5D                  
LDA #$01
STA $5E,X
  
CODE_DD25:
JSR CODE_DBEE

LDX $5D                  
LDA $72,X                
STA $02                  
JSR CODE_EADB                
RTS

CODE_DD32:
LDA #$55                 
JSR CODE_DFE4
BNE CODE_DD3A                
RTS

CODE_DD3A:
JSR CODE_EFD5
STX $04

JSR CODE_EAEC

LDA $01                  
JSR CODE_E016

LDX $5D                  
STA $68,X                
AND #$01                 
BNE CODE_DD60                
DEC $00
    
LDA $01                  
CMP #$14                 
BNE CODE_DD59                
DEC $01						;untriggered
  
CODE_DD59:
LDA $00                  
BNE CODE_DD73                
JMP CODE_DD7F
   
CODE_DD60:
INC $00                  
LDA $01                  
CMP #$EC                 
BNE CODE_DD6A

DEC $01						;untriggered

CODE_DD6A:					;5th missing l
LDA $00                  
CMP #$F4                 
BNE CODE_DD73                
JMP CODE_DD7F

CODE_DD73:
JSR CODE_DBEE
LDX $5D                  
LDA $72,X                
STA $02                  
JMP CODE_EADB

CODE_DD7F:
LDA #$22                 
JSR CODE_F092
  
LDA #$00                 
LDX $5D                  
STA $68,X                
RTS

CODE_DD8B:
STA $07

LDX $5D                  
LDA $5E,X                
CMP #$C2                 
BNE CODE_DD98
JMP CODE_DE82

CODE_DD98:  
CMP #$C1                 
BEQ CODE_DDD7
  
LDA $07                  
CMP #$02                 
BEQ CODE_DDAB                
CMP #$03                 
BEQ CODE_DDB0                
LDA #$34                 
JMP CODE_DDB2
  
CODE_DDAB:
LDA #$36					;\unused?    
JMP CODE_DDB2					;/

CODE_DDB0:
LDA #$38
  
CODE_DDB2:
JSR CODE_C853                
JSR CODE_EFD5                
STX $04

LDA $0200,X              
JSR CODE_E112

LDY $0A                  
CPY #$04                 
BNE CODE_DDC9                
JMP CODE_DE73
  
CODE_DDC9:
CMP #$00                 
BEQ CODE_DDD7

LDX $5D                  
LDA #$01                 
STA $8A,X
   
LDA #$C1                 
STA $5E,X                
 
CODE_DDD7:
JSR CODE_EFD5

STX $04                  
LDX $5D                  
LDA $5E,X                
CMP #$C1                 
BNE CODE_DE13

LDA #$20
JSR CODE_DFE4                
BNE CODE_DDF5

LDX $04                  
LDA $0200,X              
STA $01                  
JMP CODE_DE27

CODE_DDF5:  
LDX $5D                  
LDA #$C0                 
STA $5E,X
  
LDA $07                  
CMP #$03                 
BNE CODE_DE10

LDA $0417,X              
BEQ CODE_DE0B
 
LDA #$00                 
JMP CODE_DE0D

CODE_DE0B:  
LDA #$01

CODE_DE0D  
STA $0417,X
  
CODE_DE10:
JMP CODE_DE1A

CODE_DE13:					;missing L no. 4
LDA #$FF                 
JSR CODE_DFE4                
BEQ RETURN_DE85

CODE_DE1A:  
LDX $04                  
LDA #$01                 
CLC                      
ADC $0200,X              
STA $01                  
JSR CODE_DE86
 
CODE_DE27:
INX                      
INX                      
INX                      
LDA $07                  
CMP #$02                 
BNE CODE_DE36
INC $0200,X					;\untriggered
JMP CODE_DE56					;/

CODE_DE36:
CMP #$03                 
BNE CODE_DE56

LDA $01                  
AND #$01                 
BEQ CODE_DE56

LDY $5D                  
LDA $0417,Y              
BNE CODE_DE50                
INC $0200,X              
INC $0200,X              
JMP CODE_DE56
  
CODE_DE50:
DEC $0200,X              
DEC $0200,X
  
CODE_DE56:
LDA $0200,X              
STA $00

LDX $5D                  
LDA $72,X                
CMP #$90                 
BNE CODE_DE68

LDA #$94                 
JMP CODE_DE6A
  
CODE_DE68:
LDA #$90
  
CODE_DE6A:
STA $02
  
LDX $5D                  
STA $72,X                
JMP CODE_EADB
 
CODE_DE73:
LDA #$C2                 
LDX $5D                  
STA $5E,X
 
LDX $04                  
LDA $0203,X
STA $042B                
RTS  

CODE_DE82:
JSR CODE_DEA5

RETURN_DE85:   
RTS

CODE_DE86:
LDA $07                  
CMP #$01                 
BNE RETURN_DEA4
 
LDY #$00                 
LDA $01

LOOP_DE90:
CMP DATA_C41D,Y              
BCC CODE_DE9F                
CMP DATA_C420,Y              
BCS CODE_DE9F

INC $01                  
JMP RETURN_DEA4

CODE_DE9F:
INY                      
CPY #$03                 
BNE LOOP_DE90
  
RETURN_DEA4:
RTS                      

CODE_DEA5:
JSR CODE_EFD5                
STX $04

JSR CODE_EAEC                
DEC $00                  
LDA $042B                
SEC                      
SBC #$01                 
CMP $00                  
BEQ CODE_DEE8                
SEC                      
SBC #$01                 
CMP $00                  
BEQ CODE_DEE8                
SEC                      
SBC #$01                 
CMP $00                  
BEQ CODE_DEF2                
SEC                      
SBC #$08                
CMP $00                  
BEQ CODE_DEED
SEC                      
SBC #$01                 
CMP $00                  
BEQ CODE_DEED                
SEC                      
SBC #$01                 
CMP $00                  
BNE CODE_DEFB

CODE_DEDC:
LDA #$01                 
LDX $5D                  
STA $5E,X

LDA #$00                 
STA $0417,X              
RTS                      

CODE_DEE8:
DEC $01
JMP CODE_DEFB

CODE_DEED:  
INC $01                  
JMP CODE_DEFB    

CODE_DEF2:
LDX $5D                  
LDA $0421,X              
CMP #$01                 
BEQ CODE_DEDC

CODE_DEFB:  
LDA #$84                 
LDX $5D                  
STA $72,X                
STA $02
  
JSR CODE_EADB                
RTS   

CODE_DF07:
LDA #$55                 
JSR CODE_DFE4
BNE CODE_DF0F                
RTS

CODE_DF0F:
JSR CODE_EFD5                
STX $04

JSR CODE_EAEC

INC $01                  
LDA $0201,X              
CMP #$90                 
BEQ CODE_DF25

LDA #$90                 
JMP CODE_DF27
  
CODE_DF25:
LDA #$94
  
CODE_DF27:
STA $02

JSR CODE_EADB

LDA $C0                  
CMP $01                  
BEQ CODE_DF35                
BCC CODE_DF35   
RTS

CODE_DF35:
LDX $5D
LDA #$01                 
STA $5E,X

LDA #$00                 
STA $C0                  
RTS                      

CODE_DF40:
LDA $C0                  
BEQ CODE_DF45                
RTS                      

CODE_DF45:
LDA Jumpman_State				;if Jumpman has a hammer...
CMP #$0A					;
BEQ CODE_DF4C                
RTS                      

CODE_DF4C:
LDA $59                  
CMP #$03                 
BEQ CODE_DF55                
JMP CODE_DF72

CODE_DF55:
LDX #$03                 
LDA $7E,X                
CMP #$05                 
BCS CODE_DF5E                
RTS

CODE_DF5E:
LDX #$00

LOOP_DF60: 
LDA $5E,X                
CMP #$01                 
BNE CODE_DF6C

LDA $68,X                
CMP #$03                 
BEQ CODE_DF8F
  
CODE_DF6C:
INX                      
CPX #$0A                 
BNE LOOP_DF60       
RTS                      

CODE_DF72:
LDX #$05
LDA $7E,X
CMP #$05
BCS CODE_DF7B
RTS

CODE_DF7B:
LDX #$00

LOOP_DF7D: 
LDA $5E,X                
CMP #$01                 
BNE CODE_DF89

LDA $68,X                
CMP #$05                 
BEQ CODE_DF8F
  
CODE_DF89:
INX                      
CMP #$0A                 
BNE LOOP_DF7D          
RTS                      

CODE_DF8F:  
LDA #$40                 
STA $5E,X

DEC $68,X                
TXA                      
CLC                      
ADC #$03                 
ASL A                    
ASL A                    
ASL A                    
ASL A                    
TAY                      
LDA $0200,Y              
STA $01

LDA $0203,Y              
STA $00

LDA DATA_C1EB                
LDY #$00

LOOP_DFAD:
CMP $00                  
BCS CODE_DFB8                
CLC                      
ADC #$18                 
INY                      
JMP LOOP_DFAD
  
CODE_DFB8:
TYA                      
ASL A                    
CLC                      
ADC #$15                 
CLC                      
ADC $01                  
STA $C0                  
RTS                      

CODE_DFC3:
LDX $5D    
LDA $68,X
CMP #$01
BNE RETURN_DFE3 

JSR CODE_EFD5                
LDA $0203,X              
CMP #$30                 
BCS RETURN_DFE3

LDA #$23                 
STA $0202,X              
STA $0206,X              
STA $020A,X              
STA $020E,X
  
RETURN_DFE3:
RTS                      

CODE_DFE4:
STA $0A						;
STA $0B						;

;sprite-related (various objects, like barrels, platforms, etc.)
;(seems to be movement related as it loads some values from before that are based on difficulty)
CODE_DFE8:
LDX $5D					;
INC $8A,X					;timer

LDA $8A,X					;if negative (for whatever reason)
BMI CODE_DFF7					;reset
CMP #$10					;if 16, reset and do a thing
BCS CODE_DFF7					;
JMP CODE_DFFB					;

CODE_DFF7:
LDA #$00
STA $8A,x

CODE_DFFB:
CMP #$08					;check if more than 8
BCS CODE_E008					;then substract
TAX						;
LDA DATA_C1BC,X					;bits
AND $0A						;
JMP CODE_E011					;
  
CODE_E008:
SEC
SBC #$08                 
TAX                      
LDA DATA_C1BC,X              
AND $0B
  
CODE_E011:
If Version = JP
  BEQ JP_CODE_E016
else
  BEQ RETURN_E015
endif

LDA #$01

If Version = JP
JP_CODE_E016:
  STA $0C

  LDA $0C
endif

RETURN_E015:
RTS

;$08-09 - Indirect addressing pointer
;$0A - Y-position of Jumpman (or any entity?) (sometimes offset)
;$0B

CODE_E016:
STA $0A						;
   
LDA PhaseNo					;get some pointer by Phase
SEC						;
SBC #$01					;
ASL A						;
TAX						;
LDA DATA_C493,X					;
STA $08						;
  
LDA DATA_C493+1,X				;
STA $09

LDY #$00					;
LDA #$01					;
STA $0B						;

LOOP_E02F:
LDA ($08),Y					;
CMP #$FF					;
BEQ CODE_E041					;stop with command
CMP $0A						;check if at the same Y position OR below
BEQ CODE_E045					;
BCC CODE_E045					;
INC $0B						;idk what this is
INY						;
JMP LOOP_E02F					;

CODE_E041:  
LDA #$07                 
STA $0B
  
CODE_E045:
LDA $0B                  
RTS

CODE_E048:
LDX $5D                  
LDA $5E,X                
CMP #$01                 
BNE ReturnA_E053+ReturnABranchDist		;CODE_E057

LDA $7D                  
BNE ReturnA_E053+ReturnABranchDist		;CODE_E057

ReturnA_E053:
Macro_ReturnA $0C,$01				;more optimizations between revisions. now 0C isn't used to store value (simply load value and return)

CODE_E05A:
STA $0C
  
LDX $5D                  
LDA $68,X                
CMP #$01                 
BEQ CODE_E079                
CMP #$06                 
BEQ CODE_E079
LDX #$00

LOOP_E06A:
LDA DATA_C1C4,X              
CMP $0C                  
BEQ CODE_E08A
INX
CPX #$09                 
BEQ CODE_E08A+ReturnABranchDist      
JMP LOOP_E06A
  
CODE_E079:
LDX #$04

LOOP_E07B:
LDA DATA_C1C4,X              
CMP $0C
BEQ CODE_E08A                
INX                      
CPX #$09                 
BEQ CODE_E08A+ReturnABranchDist
JMP LOOP_E07B

CODE_E08A:
Macro_ReturnA $0B,$00				;yet another "don't have to store to RAM just return" change

CODE_E090:
STA $0C

LDX $5D                  
LDA $68,X                
AND #$01                 
BEQ CODE_E09F

LDX #$00                 
JMP CODE_E0A1
  
CODE_E09F:
LDX #$01
  
CODE_E0A1:
LDA DATA_C1CD,X              
CMP $0C                  
BEQ ReturnA_E0A8+ReturnABranchDist		;CODE_E0AB

ReturnA_E0A8:
Macro_ReturnA $0B,$00

CODE_E0AE:
STA $0C

LDX $5D                  
LDA $68,X                
CMP #$02                 
BEQ CODE_E0CB                
CMP #$03                 
BEQ CODE_E0CB   
CMP #$04                 
BEQ CODE_E0D1                
CMP #$05                 
BEQ CODE_E0DD                
CMP #$06                 
BEQ CODE_E0E9                
JMP CODE_E0EC
 
CODE_E0CB:
JSR CODE_E0F1                
JMP CODE_E0EC
  
CODE_E0D1:
JSR CODE_E0F1

LDY #$89                 
CMP #$C4                 
BEQ CODE_E109                
JMP CODE_E0EC
  
CODE_E0DD:           
JSR CODE_E0F1

LDY #$71                 
CMP #$B4                 
BEQ CODE_E109                
JMP CODE_E0EC
 
CODE_E0E9:  
JSR CODE_E0F1
 
CODE_E0EC:
LDA #$00                 
JMP CODE_E10F

CODE_E0F1:
TAX                      
DEX                      
DEX                      
LDA $0C                  
LDY DATA_C172,X              
CMP DATA_C177,X              
BEQ CODE_E107

LDY DATA_C17C,X              
CMP DATA_C181,X              
BEQ CODE_E107                
RTS

CODE_E107:
PLA
PLA

CODE_E109:
LDX $5D
STY $A3,X
 
LDA #$01
  
CODE_E10F:
STA $0C                  
RTS

CODE_E112:
STA $0B
  
LDY #$00

LOOP_E116:
LDA ($08),Y              
CMP #$FE                 
BEQ CODE_E129                
CMP $0B                  
BEQ CODE_E124                
INY                      
JMP LOOP_E116
  
CODE_E124:
LDA #$01                 
JMP CODE_E12B
  
CODE_E129:
LDA #$00
  
CODE_E12B:
STA $0C                  
STY $0A                  
RTS

CODE_E130:  
LDX $5D                  
LDA $68,X                
SEC                      
SBC $59                  
BEQ CODE_E13E                
BMI CODE_E13E
JMP CODE_E13E+ReturnABranchDist

CODE_E13E:
Macro_ReturnA $0B,$01

;----------------------------------------------
;!UNUSED
;Inaccessible block of code.
;purpose unknown

UNUSED_E144:
LDX #$00                 
LDY #$20

LOOP_E148:
LDA $0200,Y
CMP #$FF                 
BEQ CODE_E157

JSR CODE_E016                
STA $68,X                
JMP CODE_E15B

CODE_E157:
LDA #$00                 
STA $68,X

CODE_E15B:
TYA                      
CLC                      
ADC #$10                 
TAY                      
INX                      
CPX #$0A                 
BNE LOOP_E148                
RTS                      
;----------------------------------------------

;i think this is a routine for phase 1 to check barrels and run their code
CODE_E166:
LDA #$00
LDY #$06

LOOP_E16A:                 
STA $007E,Y					;reset some table. possible directions (which are semi-random)
DEY
BPL LOOP_E16A

LDY #$00

LOOP_E172:
LDA $0068,Y					;barrel's in this slot Y/N
BEQ CODE_E17F					;if no, check next barrel
TAX   
LDA $7E,X					;no INC?
CLC
ADC #$01
STA $7E,X

CODE_E17F: 
CPY #$09					;max of 9, though i never triggered such number of barrels
BEQ CODE_E187
INY                      
JMP LOOP_E172
  
CODE_E187:
LDX $59                  
CPX #$07                 
BEQ RETURN_E199                
INC $7E,X

LDA Jumpman_State				;if player's holding a hammer
CMP #$0A
BNE RETURN_E199

LDX $59
INC $7E,X					;inclrease smth (mark as destroyed with a hammer?)

RETURN_E199:
RTS

CODE_E19A:
LDA $AD                  
BNE CODE_E19F
RTS                      

CODE_E19F:  
CMP #$01                 
BNE CODE_E1BF

LDA #$20                 
STA $00
  
LDA #$C0                 
STA $01

LDA #$FC                 
STA $02

LDA #$12                 
STA $03

LDA #$E0                 
JSR CODE_F080

LDA #$02                 
STA $AD                  
JMP CODE_E1E0
  
CODE_E1BF:
LDA $38
BNE RETURN_E1E4

LDA #$03                 
STA $AD

LDX #$E1                 
LDA $0200,X              
CMP #$FC                 
BEQ CODE_E1D5

LDA #$FC                 
JMP CODE_E1D7

CODE_E1D5:
LDA #$FE
  
CODE_E1D7:
STA $0200,X              
CLC                      
ADC #$01                 
STA $0204,X
  
CODE_E1E0:
LDA #$10
STA $38
  
RETURN_E1E4:
RTS

CODE_E1E5:
LDA #$00
STA $AE

LOOP_E1E9:
JSR CODE_EFDD

LDA $0200,X              
CMP #$FF                 
BNE CODE_E225

LDA $53                  
CMP #$01                 
BEQ CODE_E200                
CMP #$04                 
BEQ CODE_E213                
JMP CODE_E225					;untriggered

CODE_E200:
LDA $40                  
BNE CODE_E228
  
LDA $AD                  
BEQ CODE_E228    
CMP #$02                 
BNE CODE_E228

LDA #$19                 
STA $40                  
JMP CODE_E21F

CODE_E213:
LDA $40
BNE CODE_E228

JSR CODE_EAF7                
LDA DATA_C466,X              
STA $40

CODE_E21F:
LDA #$06                 
LDX $AE                  
STA $AF,X
  
CODE_E225:
JSR CODE_E250

CODE_E228:
LDX $53                  
DEX                      
INC $AE                  
LDA $AE                  
CMP DATA_C1F6,X              
BEQ CODE_E237                
JMP LOOP_E1E9

CODE_E237:
LDA $53                  
CMP #$03                 
BEQ RETURN_E24F

LDA $3B                  
BNE RETURN_E24F

LDA #$00                 
STA $D2                 
STA $D3                 
STA $D4                  
STA $D5

LDA #$BC                 
STA $3B

RETURN_E24F:					;3rd missing l
RTS

CODE_E250:  
LDX $AE                  
LDA $AF,X

LOOP_E254:
AND #$0F                 
BEQ CODE_E292                
CMP #$06
BEQ CODE_E28F                
CMP #$08                 
BEQ CODE_E28F                
CMP #$01                 
BEQ CODE_E295                
CMP #$02                 
BEQ CODE_E29A                
CMP #$03                 
BEQ CODE_E2A1
 
LDA $53                  
CMP #$03                 
BEQ CODE_E278                
JSR CODE_E2B6                
JMP CODE_E280
   
CODE_E278:
LDA RNG_Value+1,X
AND #$03                 
LDX $AE                  
STA $AF,X

CODE_E280:					;another missing l
LDA $AF,X                
CMP #$01                 
BEQ CODE_E28A                
CMP #$02                 
BNE CODE_E28C

CODE_E28A:
STA $B3,X
  
CODE_E28C:
JMP LOOP_E254
  
CODE_E28F:
JMP CODE_E538

CODE_E292:
JMP CODE_E2F9
  
CODE_E295:
LDA #$00                 
JMP CODE_E29C
  
CODE_E29A:
LDA #$01
  
CODE_E29C:
STA $99                  
JMP CODE_E368
  
CODE_E2A1:
LDA $53                  
CMP #$01                 
BNE CODE_E2B3

JSR CODE_E626                
LDX $AE                  
LDA $AF,X                
BNE CODE_E2B3                
JMP CODE_E292
  
CODE_E2B3:
JMP CODE_E41B

CODE_E2B6:
LDX $AE                  
LDA $D2,X                
BNE CODE_E2DD

LDA #$01                 
STA $D2,X

LDA $AE                  
CLC                      
ADC #$01                 
ASL A                    
ASL A                    
ASL A                    
ASL A                    
TAY                      
LDA $0203,Y              
CMP $0203                
BCS CODE_E2D9

LDA #$01                 
STA $EC,X                
JMP CODE_E2DD
  
CODE_E2D9:
LDA #$02                 
STA $EC,X
  
CODE_E2DD:
LDA RNG_Value+1,X                
AND #$07                 
STA $AF,X
TAY                      
CMP #$04                 
BCS CODE_E2EB                
JMP CODE_E2F6

CODE_E2EB:
LDY $EC,X                
CMP #$07                 
BCS CODE_E2F4                
JMP CODE_E2F6
  
CODE_E2F4:
LDY #$03
  
CODE_E2F6:
STY $AF,X                
RTS
  
CODE_E2F9:
LDA #$55                 
STA $0A                  
STA $0B

JSR CODE_E806                
BNE CODE_E305
RTS

CODE_E305:
JSR CODE_EFDD                
STX $04
JSR CODE_EAEC 
  
LDX $AE                  
LDA $AF,X                
CMP #$20                 
BNE CODE_E31A

LDA #$FF                 
STA $AF,X                
RTS                      

CODE_E31A:
CMP #$10                 
BEQ CODE_E323                
DEC $01                  
JMP CODE_E325
  
CODE_E323:
INC $01

CODE_E325:  
LDA $04                  
TAY                      
INY                      
LDA $0200,Y              
LDX $53                  
CPX #$04                 
BEQ CODE_E340                
CMP #$9C                 
BEQ CODE_E33B

LDA #$9C                 
JMP CODE_E34B
  
CODE_E33B:
LDA #$98                 
JMP CODE_E34B
  
CODE_E340:
CMP #$AC                 
BEQ CODE_E349

LDA #$AC                 
JMP CODE_E34B
  
CODE_E349:
LDA #$A8
  
CODE_E34B:
JSR CODE_EAD4

LDX $AE                  
LDA $B3,X                
LSR A                    
JSR CODE_F096

LDX $AE                  
LDA $AF,X                
CMP #$10                 
BEQ CODE_E363

LDA #$10                 
JMP CODE_E365
  
CODE_E363:
LDA #$20
  
CODE_E365:
STA $AF,X                
RTS                      

CODE_E368:
LDA #$55                 
STA $0A                  
STA $0B

JSR CODE_E806                
BNE CODE_E374                
RTS

CODE_E374:  
JSR CODE_EFDD                
STX $04                  
JSR CODE_EAEC

LDA $99                  
BNE CODE_E385
     
INC $00                  
JMP CODE_E387
  
CODE_E385:
DEC $00

CODE_E387:   
LDA $00                  
AND #$0F                 
CMP #$04                 
BEQ CODE_E396                
CMP #$0C                 
BEQ CODE_E396                
JMP CODE_E39B
  
CODE_E396:
INC $01                  
JMP CODE_E3AF

CODE_E39B: 
LDX $99                  
CMP DATA_C3E2,X              
BEQ CODE_E3AA                
CMP DATA_C3E2+2,X              
BEQ CODE_E3AA     
JMP CODE_E3AF

CODE_E3AA:
DEC $01                  
JMP CODE_E3C0
  
CODE_E3AF:
CMP #$04                 
BEQ CODE_E3BA                
CMP #$0C                 
BEQ CODE_E3BA
JMP CODE_E3C0

CODE_E3BA:
LDX $AE
LDA #$FF                 
STA $AF,X
  
CODE_E3C0:
LDY $99                  
JSR CODE_E6A5                
BNE CODE_E3CE

LDA #$00                 
LDX $AE                  
STA $AF,X                
RTS                      

CODE_E3CE:
LDA $99                  
BEQ CODE_E3ED

LDA $00                  
CMP #$0C                 
BEQ CODE_E3DD                
BCC CODE_E3E6                
JMP CODE_E3ED

CODE_E3DD:  
LDA #$00                 
LDX $AE                  
STA $AF,X                
JMP CODE_E3ED

CODE_E3E6:  
LDA #$00                 
LDX $AE                  
STA $AF,X                
RTS

CODE_E3ED:
LDA $04                  
TAY                      
INY                      
LDA $0200,Y              
LDX $53                  
CPX #$04                 
BEQ CODE_E408
CMP #$9C                 
BCS CODE_E403
 
LDA #$9C                 
JMP CODE_E413
  
CODE_E403:
LDA #$98                 
JMP CODE_E413
  
CODE_E408:
CMP #$AC                 
BCS CODE_E411
  
LDA #$AC                 
JMP CODE_E413
  
CODE_E411:
LDA #$A8

CODE_E413:
JSR CODE_EAD4                
LDA $99                  
JMP CODE_F096

CODE_E41B:					;was a missing l
LDX $AE                  
LDA $AF,X                
LSR A                    
LSR A                    
LSR A                    
TAX                      
LDA $53                  
CMP #$04                 
BEQ CODE_E436

CODE_E429:
LDA DATA_C3F4,X              
STA $0A

LDA DATA_C3F4+1,X              
STA $0B
JMP CODE_E44B
  
CODE_E436:
LDA $50                  
AND #$01
CLC
ADC $54                  
CMP #$03                 
BCC CODE_E429
 
LDA DATA_C3F8,X              
STA $0A

LDA DATA_C3F8+1,X              
STA $0B

CODE_E44B:
JSR CODE_E806                
BNE CODE_E451                
RTS                      

CODE_E451:
JSR CODE_EFDD                
STX $04                  
JSR CODE_EAEC
       
LDX $AE                  
LDA $E8,X                
BEQ CODE_E46D                
CMP #$03
BEQ CODE_E466
JMP CODE_E46D

CODE_E466:
LDA #$00                 
STA $E8,X                
JMP CODE_E47A
   
CODE_E46D:
LDA $01                  
AND #$03                 
BNE CODE_E47A

LDA #$01                 
INC $E8,X                
JMP CODE_E50C
  
CODE_E47A:
LDA $53                  
CMP #$01                 
BEQ CODE_E4B5
   
JSR CODE_E7A3                
CMP #$03                 
BEQ CODE_E48E                
CMP #$13                 
BEQ CODE_E49B                
JMP CODE_E50C
 
CODE_E48E:
DEC $01                  
LDA $01                  
LDX $AE                  
CMP $DB,X                
BEQ CODE_E4A8                
JMP CODE_E50C

CODE_E49B:  
INC $01                  
LDA $01                  
LDX $AE                  
CMP $DB,X                
BEQ CODE_E4A8                
JMP CODE_E50C

CODE_E4A8:
LDA #$01                 
LDX $AE                  
STA $AF,X

LDA #$00                 
STA $DB,X                
JMP CODE_E50C

CODE_E4B5:  
LDX $AE                  
LDA $AF,X                
CMP #$13                 
BEQ CODE_E4C0                
JMP CODE_E4D6
  
CODE_E4C0:
INC $01                  
LDA $AE                  
ASL A                    
TAX                      
INX                      
LDA $B9,X                
CMP $01                  
BNE CODE_E4D3                

LDA #$01                 
LDX $AE                  
STA $AF,X

CODE_E4D3:
JMP CODE_E50C
  
CODE_E4D6:
DEC $01                  
LDX $AE                  
CPX #$00					;hmm, yeah
BNE CODE_E4F9

LDX $AE
LDA $E0,X                
CMP #$02                 
BEQ CODE_E4F9
  
LDA $AE                  
ASL A                    
TAX                      
LDA $B9,X                
CMP $01
BNE CODE_E50C

LDA #$02                 
LDX $AE                  
STA $AF,X                
JMP CODE_E50C

CODE_E4F9:
LDA $AE                  
ASL A                    
TAX                      
LDA $B9,X                
CLC                      
ADC #$0D                 
CMP $01                  
BNE CODE_E50C

LDA #$13
LDX $AE
STA $AF,X

CODE_E50C:  
LDA $04                  
TAY                      
INY                      
LDA $0200,Y              
LDX $53                  
CPX #$04                 
BEQ CODE_E527                
CMP #$9C                 
BCS CODE_E522

LDA #$9C                 
JMP CODE_E532
  
CODE_E522:
LDA #$98                 
JMP CODE_E532
  
CODE_E527:
CMP #$AC  
BCS CODE_E530

LDA #$AC                 
JMP CODE_E532

CODE_E530:
LDA #$A8
  
CODE_E532:
JSR CODE_EAD4                
JMP CODE_F088                
  
CODE_E538:
LDX $AE                  
LDA $AF,X                
CMP #$06                 
BEQ CODE_E548                
CMP #$08                 
BEQ CODE_E545
RTS						;untriggered

CODE_E545:
JMP CODE_E59F

CODE_E548:
LDA $53                  
CMP #$01                 
BEQ CODE_E553                
CMP #$04                 
BEQ CODE_E564                
RTS						;untriggered

CODE_E553:      
LDA #$20                 
STA $00

LDA #$B8                 
STA $01

LDX $AE                  
LDA #$08                 
STA $AF,X                
JMP CODE_E592

CODE_E564:
LDA $0203                
CMP #$78                 
BCC CODE_E570

LDY #$00                 
JMP CODE_E572

CODE_E570:  
LDY #$08
  
CODE_E572:
STY $0C

LDA $19                  
AND #$03                 
ASL A                    
CLC                      
ADC $0C                  
TAX                      
LDA DATA_C3CE,X              
STA $00

LDA DATA_C3CE+1,X              
STA $01

LDX $AE                  
LDA #$00                 
STA $AF,X

LDA #$A8
JMP CODE_E594

CODE_E592:  
LDA #$98
  
CODE_E594:
JSR CODE_EAD4                
JSR CODE_EFDD                
STA $04                  
JMP CODE_F082

CODE_E59F:  
JSR CODE_EFDD                
STX $04                  
JSR CODE_EAEC

LDA $0201,X              
JSR CODE_EAD4

LDA $53                  
CMP #$01                 
BEQ CODE_E5B4                
RTS						;untriggered

CODE_E5B4:
INC $00  
LDA $00                  
CMP #$2C                 
BEQ CODE_E5BE
BCC CODE_E5E5

CODE_E5BE:
INC $01                  
LDA $01                  
CMP #$C5                 
BNE CODE_E5E5

LDA #$00                 
LDX $AE                  
STA $AF,X

DEC $00                  
LDA $00                  
CMP #$68                 
BCS CODE_E5D9

INC $01                  
JMP CODE_E5DB

CODE_E5D9:  
DEC $01						;unused?

CODE_E5DB:  
CMP #$60
BNE CODE_E5E5

LDX $AE						;untriggered
LDA #$00
STA $AF,X

CODE_E5E5:
JMP CODE_F082

CODE_E5E8:
STA $0C                  
LDX $AE                  
LDA $E0,X                
CMP #$01                 
BEQ CODE_E60F                
CMP #$06                 
BEQ CODE_E60F

LDX #$00                 
LDA #$18

LOOP_E5FA:
CMP $0C                  
BEQ CODE_E609                
INX                      
CPX #$09                 
BEQ CODE_E60C

LDA DATA_C1C4,X              
JMP LOOP_E5FA
  
CODE_E609:
LDA #$00                 
RTS

CODE_E60C:
LDA #$01 
RTS

CODE_E60F:  
LDX #$04

LOOP_E611:  
LDA DATA_C1C4,X              
CMP $0C                  
BEQ CODE_E620                
INX                      
CPX #$09                 
BEQ CODE_E623                
JMP LOOP_E611
  
CODE_E620:
LDA #$00
RTS

CODE_E623:
LDA #$01
RTS

CODE_E626:
LDX $AE                  
LDA $AF,X                
CMP #$13                 
BNE CODE_E62F                
RTS

CODE_E62F:
JSR CODE_EFDD                
JSR CODE_EAEC

LDX $AE                  
LDA $E0,X                
CMP #$01                 
BEQ CODE_E640                
JMP CODE_E66D

CODE_E640:   
LDA $00                  
CMP #$5C                 
BEQ CODE_E64D                
CMP #$C4                 
BEQ CODE_E65D                
JMP CODE_E69E

CODE_E64D:  
LDA $AE                  
ASL A                    
TAX                      
LDA #$A6                 
STA $B9,X                
INX                      
LDA #$C7                 
STA $B9,X                
JMP CODE_E697
  
CODE_E65D:
LDA $AE                  
ASL A                    
TAX                      
LDA #$AB                 
STA $B9,X                
INX                      
LDA #$C3                 
STA $B9,X                
JMP CODE_E697

CODE_E66D:  
LDA $00                  
CMP #$2C                 
BEQ CODE_E67A                
CMP #$6C                 
BEQ CODE_E68A                
JMP CODE_E69E

CODE_E67A:  
LDA $AE                  
ASL A                    
TAX                      
LDA #$8D                 
STA $B9,X                
INX                      
LDA #$A4                 
STA $B9,X                
JMP CODE_E697
  
CODE_E68A:
LDA $AE                  
ASL A                    
TAX                      
LDA #$8A                 
STA $B9,X                
INX                      
LDA #$A7                 
STA $B9,X

CODE_E697:  
LDA #$03                 
LDX $AE                  
STA $AF,X                
RTS

CODE_E69E:  
LDA #$00                 
LDX $AE                  
STA $AF,X                
RTS

CODE_E6A5:
LDA $01                  
CLC                      
ADC #$0B                 
JSR CODE_E016

LDY $99                  
LDX $AE                  
STA $E0,X                

LDA $53                  
CMP #$01                 
BNE CODE_E6BC                
JMP CODE_E6C6                

CODE_E6BC:
CMP #$03                 
BNE CODE_E6C3                
JMP CODE_E702

CODE_E6C3:
JMP CODE_E73C

CODE_E6C6:
LDA $00                  
JSR CODE_E5E8                
BNE CODE_E6E3
 
LDX $AE                  
LDA $E0,X                
AND #$01                 
BEQ CODE_E6DB

LDA DATA_C79A,Y              
JMP CODE_E6DE
 
CODE_E6DB:
LDA DATA_C79C,Y
  
CODE_E6DE:
CLC                      
ADC $01                  
STA $01

CODE_E6E3:  
LDX $AE                  
LDA $E0,X                
CMP #$01                 
BEQ CODE_E6F3

LDA $00                  
CMP DATA_C3E6,Y              
BEQ CODE_E6FB
RTS

CODE_E6F3:  
LDA $00                  
CMP DATA_C3E8,Y              
BEQ CODE_E6FB
RTS

CODE_E6FB:
LDA #$00                 
LDX $AE                  
STA $AF,X                
RTS                      

CODE_E702:
LDX $AE                  
LDA $E0,X                
CMP #$02                 
BNE CODE_E719

LDA $00                  
CMP DATA_C3EA,Y              
BEQ CODE_E735

CMP DATA_C3EC,Y              
BEQ CODE_E735
JMP RETURN_E72D

CODE_E719:
CPY #$01                 
BNE CODE_E721                
CMP #$04                 
BEQ CODE_E72E
  
CODE_E721:
LDA $00                  
CMP DATA_C3EE,Y              
BEQ CODE_E735 
CMP DATA_C3F0,Y              
BEQ CODE_E735
  
RETURN_E72D:
RTS

CODE_E72E:
LDA $00                  
CMP #$DB                 
BEQ CODE_E735                
RTS

CODE_E735:
LDX $AE

LDA #$00                 
STA $AF,X                
RTS                      

CODE_E73C:
LDX $AE                  
LDA $E0,X                
TAY                      
DEY                      
LDX $99                  
LDA DATA_C3F2,X

LOOP_E747:  
CPY #$00                 
BEQ CODE_E75C                
CPX #$00
BEQ CODE_E755                
CLC                      
ADC #$08                 
JMP CODE_E758

CODE_E755:  
SEC                      
SBC #$08
  
CODE_E758:
DEY                      
JMP LOOP_E747

CODE_E75C:  
CMP $00                  
BEQ CODE_E769
    
LDA $99                  
ASL A                    
JSR CODE_E770
BEQ CODE_E769  
RTS

CODE_E769:
LDX $AE                  
LDA #$00                 
STA $AF,X                
RTS

CODE_E770:
STA $09

JSR CODE_EFDD
LDA $0203,X              
STA $0A

LDX $AE                  
LDA $E0,X                
SEC                      
SBC #$02                 
ASL A                    
TAX                      
LDA $C1,X                
BEQ CODE_E790

LDY $09                  
LDA DATA_C3DE,Y              
CMP $0A                  
BEQ CODE_E79D
  
CODE_E790:
LDA $C2,X                
BEQ CODE_E7A0

LDY $09                  
LDA DATA_C3DE+1,Y              
CMP $0A                  
BNE CODE_E7A0
  
CODE_E79D:
LDA #$00                 
RTS

CODE_E7A0:
LDA #$01
RTS

CODE_E7A3:
LDX $AE                  
LDA $DB,X                
BEQ CODE_E7AE

LDX $AE                  
LDA $AF,X                
RTS                      

;related with flames (phase 3)?
CODE_E7AE:
LDA $53                  
SEC                      
SBC #$02                 
ASL A                    
TAY                      
LDA UNUSED_C49B,Y              
STA $07

LDA UNUSED_C49B+1,Y              
STA $08

LDX $AE                  
LDY $E0,X                
BEQ CODE_E7F2                
DEY                      
LDA ($07),Y              
STA $09                  
INY                      
LDA ($07),Y              
STA $0A

LDA $53                  
SEC                      
SBC #$02                 
ASL A
TAY                      
LDA UNUSED_C4A1,Y              
STA $07

LDA UNUSED_C4A1+1,Y              
STA $08

LDY $09

LOOP_E7E2:
CPY $0A                  
BEQ CODE_E7F2

LDA ($07),Y              
CMP $00                  
BEQ CODE_E7F9                
INY                      
INY                      
INY                      
JMP LOOP_E7E2
  
CODE_E7F2:
LDA #$00                 
LDX $AE                  
STA $AF,X                
RTS

CODE_E7F9:
INY                      
LDA ($07),Y 
LDX $AE                  
STA $DB,X
  
INY                      
LDA ($07),Y              
STA $AF,X                
RTS

CODE_E806:
LDX $AE                  
INC $E4,X                
LDA $E4,X                
BMI CODE_E815                
CMP #$10                 
BCS CODE_E815                
JMP CODE_E819
  
CODE_E815:
LDA #$00                 
STA $E4,X
  
CODE_E819:
CMP #$08                 
BCS CODE_E826                
TAX                      
LDA DATA_C1BC,X              
AND $0A                  
JMP CODE_E82F

CODE_E826:
SEC                      
SBC #$08                 
TAX                      
LDA DATA_C1BC,X              
AND $0B

CODE_E82F:
If Version = JP
  BEQ JP_CODE_E848
else
  BEQ RETURN_E833
endif

LDA #$01

If Version = JP
JP_CODE_E848:
  STA $0C						;another unecessary store
endif

RETURN_E833:
RTS

;moving lifts (75M only)
CODE_E834:
JSR CODE_EAF7					;get speed index
LDA DATA_C45C,X
STA $0A
LDA DATA_C461,X
STA $0B
LDA #$00					;only one check
STA $5D						;
JSR CODE_DFE8					;check if it should run platforms code
BNE CODE_E84B					;every some frames
RTS						;
;move lifts
CODE_E84B:
LDA #$00					;moving platform index
STA $D2						;
LOOP_E84F:
LDA $D2						;if we moved first three platforms
CMP #$03					;next three, which move up
BCS CODE_E8A9					;
TAX						;
BNE CODE_E86A					;
LDA $DA						;if platform isn't being stood on
CMP #$01					;
BNE CODE_E86A					;don't move jumpman
DEC $0200					;\move jumpman down (sprite tiles Y-pos) 
DEC $0204					;|
DEC $0208					;|
DEC $020C					;/

CODE_E86A:
LDY DATA_C2CC,X					;get proper OAM slot for each platform 
LDA $0200,Y					;
CMP #$FF					;
BEQ CODE_E8A4					;if offscreen, next platform
TYA						;convert Y into X
TAX						;
DEC $0200,X					;No DEC $XXXX,y
DEC $0204,X					;
LDA $0200,X					;if not at this height, check different Y-position
CMP #$50					;
BNE CODE_E889					;
JSR CODE_E968					;enable priority
JMP CODE_E890					;check different Y-pos (but it's pointless since we're here from $50)
  
CODE_E889:
CMP #$C8					;if it appears from the bottom, disable priority
BNE CODE_E890					;
JSR CODE_E971					;disable priority
  
CODE_E890:
LDA $0200,Y					;if low enough... again?
CMP #$70					;
BNE CODE_E89B					;
LDA #$01					;some kind of flag (remove sprite, i think)
STA $D8						;
  
CODE_E89B:
LDA $0200,Y					;remove sprite if low enough
CMP #$48					;
BEQ CODE_E901					;
BCC CODE_E901					;
  
CODE_E8A4:
INC $D2						;next platoform sprite
JMP LOOP_E84F					;
CODE_E8A9:
CMP #$06					;if gone through all platoforms, wrap it up
BEQ CODE_E90E					;
TAX
CMP #$03
BNE CODE_E8C4
LDA $DA
CMP #$02
BNE CODE_E8C4
  
INC $0200     
INC $0204   
INC $0208                
INC $020C
  
CODE_E8C4:
LDY DATA_C2CC,X              
LDA $0200,Y              
CMP #$FF                 
BEQ CODE_E8FC                
TYA 
TAX
INC $0200,X              
INC $0204,X
LDA $0200,X              
CMP #$50                 
BNE CODE_E8E3
  
JSR CODE_E971                
JMP CODE_E8EA
  
CODE_E8E3:
CMP #$C8                 
BNE CODE_E8EA                
JSR CODE_E968
  
CODE_E8EA:
LDA $0200,Y              
CMP #$A8                 
BNE CODE_E8F8
LDA #$01                 
STA $D9                  
  
LDA $0200,Y
  
CODE_E8F8:
CMP #$D0                 
BCS CODE_E901
  
CODE_E8FC:
INC $D2                  
JMP LOOP_E84F
  
CODE_E901:
LDA #$FF                 
STA $0200,Y              
STA $0204,Y
INC $D2                  
JMP LOOP_E84F
  
CODE_E90E:
LDA $D8					;check this flag (whatever it does)
CMP #$01				;
BNE CODE_E93B

LDA #$00                 
STA $D2

LOOP_E918:
LDA $D2                  
CMP #$03                 
BEQ RETURN_E967                
TAX                      
LDY DATA_C2CC,X

LDA $0200,Y              
CMP #$FF                 
BEQ CODE_E92E

INC $D2                  
JMP LOOP_E918
  
CODE_E92E:
LDA #$D0                 
JSR CODE_E97A                
JSR CODE_E968

LDA #$00                 
STA $D8                  
RTS                      

CODE_E93B:
LDA $D9                  
CMP #$01                 
BNE RETURN_E967

LDA #$03                 
STA $D2

CODE_E945:
LDA $D2                  
CMP #$06                 
BEQ RETURN_E967   
TAX                      
LDY DATA_C2CC,X

LDA $0200,Y              
CMP #$FF                 
BEQ CODE_E95B                
INC $D2                  
JMP CODE_E945

CODE_E95B:  
LDA #$48                 
JSR CODE_E97A                
JSR CODE_E968

LDA #$00                 
STA $D9
  
RETURN_E967:
RTS

CODE_E968:
LDA #$23
STA $0202,Y              
STA $0206,Y              
RTS

CODE_E971:
LDA #$03                 
STA $0202,Y              
STA $0206,Y              
RTS                      

CODE_E97A:
STA $0200,Y              
STA $0204,Y              
RTS

CODE_E981:
LDA #$00                 
STA $0445

LOOP_E986:
LDA $0445                
JSR CODE_EFD7                
TXA                      
CLC                      
ADC #$30                 
TAX                      
STX $04

JSR CODE_EAEC                
CMP #$FF                 
BEQ CODE_E9F0

LDX $0445                
LDA $0446,X              
CLC                      
ADC #$B0                 
CMP $00                  
BCC CODE_E9B4
 
LDA $01                  
CMP #$26                 
BCS CODE_E9BE

LDA #$C0                 
STA $02                  
JMP CODE_E9DA
  
CODE_E9B4:
JSR CODE_EA01                
CMP #$FF                 
BEQ CODE_E9F3                
JMP CODE_E9EA
  
CODE_E9BE:
LDA #$C4
STA $02

LDA $01                  
CMP #$2E                 
BCC CODE_E9DA

LDA #$02
STA $FE

LDA #$2E
STA $01

LDA $0445
ASL A
TAX
LDA #$00                 
STA $042E,X
  
CODE_E9DA:
LDA $00                  
CLC                      
ADC #$02                 
STA $00

LDA $0445                
CLC                      
ADC #$01                 
JSR CODE_EF72
  
CODE_E9EA:
JSR CODE_EADB                
JMP CODE_E9F3
  
CODE_E9F0:
JSR CODE_EA34
  
CODE_E9F3:
INC $0445                
LDA $0445                
CMP #$03                 
BEQ RETURN_EA00   
JMP LOOP_E986

RETURN_EA00:
RTS                      

CODE_EA01:
LDA $01                  
INC $01                  
INC $01                  
INC $01                  
CMP #$26                 
BNE CODE_EA11

LDX #$01                 
STX $FE

CODE_EA11:  
CMP #$50                 
BCC CODE_EA2A                
CMP #$90                 
BCC CODE_EA2F                
CMP #$C0                 
BCC CODE_EA2A
CMP #$D8                 
BCC CODE_EA2F

JSR CODE_EAD1                
JSR CODE_F094

LDA #$FF
RTS

CODE_EA2A:
LDA #$C4                 
STA $02                  
RTS

CODE_EA2F:    
LDA #$C0                 
STA $02                  
RTS 
  
CODE_EA34:
LDA $36
BNE RETURN_EA5E

LDA $19                  
AND #$03
TAX
LDA DATA_C1FF,X              
CLC
ADC #$10
LDX $0445
STA $0446,X
STA $00

LDA #$30
STA $01

LDA #$C4
STA $02
  
JSR CODE_EADB                
JSR CODE_EAF7

LDA DATA_C457,X              
STA $36
  
RETURN_EA5E:
RTS

CODE_EA5F:
LDA $39                  
BEQ CODE_EA64                
RTS

CODE_EA64:
LDA #$08                 
STA $0A
     
LDA #$00                 
STA $0B                  
JSR CODE_EAA1                
BNE CODE_EA72                
RTS

CODE_EA72:
LDA #$50                 
STA $00

LDA #$20                 
STA $01

LDA $02F1                
CMP #$DB                 
BEQ CODE_EA88                
INC $B7
 
LDA #$DB                 
JMP CODE_EA8A
  
CODE_EA88:
LDA #$D7
  
CODE_EA8A:
JSR CODE_EAD4

LDA #$F0                 
JSR CODE_F080

LDA $B7                  
CMP #$04                 
BNE RETURN_EAA0
   
LDA #$00                 
STA $B7

LDA #$BB                 
STA $39
  
RETURN_EAA0:
RTS                      

CODE_EAA1:
INC $B8                  
LDA $B8                  
BMI CODE_EAAE                
CMP #$10                 
BCS CODE_EAAE    
JMP CODE_EAB2
  
CODE_EAAE:
LDA #$00                 
STA $B8
  
CODE_EAB2:
CMP #$08                 
BCS CODE_EABF                
TAX                      
LDA DATA_C1BC,X              
AND $0A                  
JMP CODE_EAC8
  
CODE_EABF:
SEC                      
SBC #$08                 
TAX                      
LDA DATA_C1BC,X              
AND $0B
  
CODE_EAC8:
If Version = JP
BEQ JP_CODE_EAE3
else
BEQ RETURN_EACC
endif

LDA #$01

If Version = JP
JP_CODE_EAE3:
STA $0C
endif

RETURN_EACC:
RTS                      

CODE_EACD:
LDA #$00                 
STA $04

CODE_EAD1:
JMP CODE_EAD6
  
CODE_EAD4:
STA $02

CODE_EAD6:
LDA #$22                 
STA $03                  
RTS

CODE_EADB:
JSR CODE_EAD1                
JMP CODE_F082                

CODE_EAE1:
LDA $0203					;sprite tile X-position
STA $00

LDA $0200					;sprite tile Y-position
STA $01
RTS

CODE_EAEC:
LDA $0203,X              
STA $00

LDA $0200,X              
STA $01                  
RTS                      

;get speed index for various objects, to make it more difficult for the player
CODE_EAF7:
LDA GameMode					;check for Game B
AND #$01					;
CLC						;
ADC LoopCount					;and add loop counter
TAX						;
CPX #$04					;
BCC RETURN_EB05					;if it's more than 4, limit
  
LDX #$04					;maximus of speed values for lifts
  
RETURN_EB05:
RTS						;
CODE_EB06:
LDA $0503					;since this is always set to 1, it feels pointless
BNE CODE_EB0C					;
RTS						;since it's always 1, this can't be triggered

CODE_EB0C:
LDA $0505					;some bits...
AND #$0F                 
STA $0505

LDA PhaseNo
TAX        
TAY
DEX
LDA DATA_C608,X
STA $00

LDA #$20                 
STA $01                  
TYA                      
CMP #$02				;check if phase value is less than 2 
BMI CODE_EB54				;go here
 
LDA $44                  
BEQ CODE_EB4F

CODE_EB2B:
CMP #$13                 
BNE CODE_EB32                
JMP CODE_EB85

CODE_EB32:
CMP #$0F                 
BNE CODE_EB39                
JMP CODE_EB8E
  
CODE_EB39:
CMP #$0B                 
BNE CODE_EB40                
JMP CODE_EB85

CODE_EB40:
CMP #$08                 
BNE CODE_EB47                
JMP CODE_EB8E

CODE_EB47:  
CMP #$04
BNE RETURN_EB4E
JSR CODE_EBA6

RETURN_EB4E:
RTS
  
CODE_EB4F:
LDA #$25                 
STA $44                  
RTS
  
CODE_EB54:
LDA $36                  
CMP #$18                 
BEQ CODE_EB74                
CMP #$00
BEQ CODE_EB7B

LDA $0515                
BEQ CODE_EB6F                
JSR CODE_EBA1

LDA #$00                 
STA $0515

LDA #$1A                 
STA $44

CODE_EB6F:  
LDA $44                  
JMP CODE_EB2B
  
CODE_EB74:
LDA #$30                 
STA $44                  
JMP CODE_EB9C

CODE_EB7B:  
LDA #$1A                 
STA $44                  
JSR CODE_EB97                
JMP CODE_EB2B

CODE_EB85:
LDA #$80
STA $FE
  
CODE_EB89:
LDA #$40                 
JMP CODE_EBA8

CODE_EB8E:
LDA #$80                 
STA $FE

CODE_EB92:
LDA #$42
JMP CODE_EBA8

CODE_EB97:
LDA #$44                 
JMP CODE_EBA8

CODE_EB9C:
LDA #$3E                 
JMP CODE_EBA8

CODE_EBA1:
LDA #$00                 
JMP CODE_EBA8      

CODE_EBA6:
LDA #$02

CODE_EBA8:
JSR CODE_C815
DEC $44

LDA $0505
ORA #$10
STA $0505
RTS

CODE_EBB6:
LDA $45                  
BEQ CODE_EBBB
RTS       

CODE_EBBB:
LDA ScoreDisplay_Bonus				;if bonus score is at zero, kill player
BNE CODE_EBC4

LDA #$FF					;RIP
STA Jumpman_State				;
RTS

CODE_EBC4:
LDA #$0B                 
STA $45

LDA #$01                 
STA $00

LDA #$0A                 
STA $01 
JSR CODE_F33E

LDA #$02
STA $00
JMP CODE_F23C

;run demo - initialization and movement
CODE_EBDA:
LDA Demo_InitFlag				;check if demo needs initialization. if not, run demo
BNE CODE_EBED					;

LDA #$01					;has initialized, disable
STA Demo_InitFlag

LDA #$00					;reset index and timer
STA Demo_InputIndex				;
STA Demo_InputTimer				;
RTS						;

CODE_EBED:
LDA Demo_InputTimer				;when timer for this input runs out, grab next input
BEQ CODE_EC16					;
   
LDA Demo_Input					;check if it was a jump command
CMP #Demo_JumpCommand				;
BNE CODE_EC0A					;if it was directional input, move in that direction

;Japenese version has a small oversight where jumpman can jump with a hammer equipped during demo mode. hammer stays in place during jumpman's jump and is placed back in his hands once he lands.
;however it is unlikely to occure normally, as hammer timer runs out before jump input.                                                                                                                                                  
;US version adds a check for this. probably as "just in case".
If Version = JP
LDA #Jumpman_State_Jumping			;no silly checks!
STA Jumpman_State				;
JMP JP_CODE_EC21				;
else
LDA Jumpman_State				;
CMP #Jumpman_State_Hammer			;check if player doesn't have a hammer, so player can't jump with hammer equipped during demo (but i don't think movement data has jump input during hammer period)
BNE CODE_EC03					;
 
LDA #$00					;reset direction
BEQ CODE_EC0A					;

CODE_EC03:
LDA #Jumpman_State_Jumping			;jumpman is jumping
STA Jumpman_State				;
JMP CODE_EC12					;
endif

CODE_EC0A:
STA Direction					;
AND #$03					;and of course, horizontal direction
BEQ CODE_EC12					;
STA Direction_Horz				;

JP_CODE_EC21:
CODE_EC12:
DEC Demo_InputTimer				;decrease timer untill next input
RTS

;get next frame input for demo mode
;DemoGetInput_EC16:
CODE_EC16:  
LDX Demo_InputIndex				;
LDA DATA_C028,X					;
STA Demo_InputTimer				;

LDA DATA_C014,X					;get input/command
STA Demo_Input					;
INC Demo_InputIndex				;next input
RTS

CODE_EC29:
JSR CODE_EAE1

LDA #$4C                 
JSR CODE_EFE8

LDA $53                  
CMP #$03                 
BEQ CODE_EC3B                
CMP #$01                 
BNE CODE_EC3E
  
CODE_EC3B:
JSR CODE_EC44
  
CODE_EC3E:
JSR CODE_ED8A
JMP CODE_EDC5                

;check if Jumpman has jumped over a barrel to add score
CODE_EC44:
LDA #$00                 
STA $5D

CODE_EC48:
LDA #$3A
JSR CODE_C847
JSR CODE_EFD5

LDA PhaseNo                  
CMP #Phase_25M
BEQ CODE_EC5B
TXA                      
CLC                      
ADC #$30                 
TAX

CODE_EC5B:
JSR CODE_EAEC                
JSR CODE_EFEF                
BNE CODE_ECA7

LDA Jumpman_State
CMP #$04                 
BNE CODE_EC97					;if jumpman isn't jumping, don't check barrel

LDA $56                  
AND #$03                 
BNE CODE_EC76

LDA $9C                  
BEQ CODE_EC80
JMP CODE_EC97
  
CODE_EC76:
LDA $9C                  
CMP #$03                 
BCS CODE_EC97

LDA $9E                  
BNE CODE_EC97
  
CODE_EC80:
LDA $9D                  
CMP #$18                 
BCS CODE_EC97
  
;player jumped over a barrel, spawn score 100
LDA $00                  
STA $05

LDA $01                  
STA $06

LDX #$00   
JSR CODE_CFC6
  
LDA #$20                 
STA $FD
  
CODE_EC97:
INC $5D

LDA $53                  
LSR A                    
TAX                      
LDA $5D                  
CMP DATA_C1FD,X              
BEQ CODE_ECAF                
JMP CODE_EC48
  
CODE_ECA7:
JSR CODE_EF51

LDA #$FF                 
STA $96                  
RTS

CODE_ECAF:
LDA $53                  
CMP #$03                 
BEQ RETURN_ECBE

LDA $96                  
CMP #$0A                 
BNE RETURN_ECBE
JMP CODE_ECBF

RETURN_ECBE:
RTS

CODE_ECBF:
LDA $A0                  
BNE CODE_ECC6
JMP CODE_ED87					;untriggered

CODE_ECC6:
LDA $9F                  
LSR A                    
LSR A                    
BEQ CODE_ECD1

LDA #$00
JMP CODE_ECD3
  
CODE_ECD1:
LDA #$01

CODE_ECD3:
BEQ CODE_ECE8

LDA #$04                 
CLC                      
ADC $0203                
STA $00

LDA $0200                
SEC                      
SBC #$10                 
STA $01                  
JMP CODE_ED07

CODE_ECE8:
LDA $57                  
CMP #$01                 
BEQ CODE_ECF7

LDA $0203                
SEC                      
SBC #$10                 
JMP CODE_ECFD
  
CODE_ECF7:
LDA $0203                
CLC                      
ADC #$10
  
CODE_ECFD:
STA $00
    
LDA $0200                
CLC                      
ADC #$06                 
STA $01
  
CODE_ED07:
LDA #$3C                 
JSR CODE_EFE8

LDA $53                  
CMP #$01                 
BNE CODE_ED34

LDA #$00                 
STA $5D

CODE_ED16:
JSR CODE_EFD5
JSR CODE_EAEC

LDA #$3A                 
JSR CODE_C847
JSR CODE_EFEF                
BNE CODE_ED57

LDA $5D                  
CLC                      
ADC #$01                 
STA $5D 
CMP #$09                 
BEQ CODE_ED85                
JMP CODE_ED16
  
CODE_ED34:
LDA #$00                 
STA $AE
  
LOOP_ED38:
JSR CODE_EFDD                
JSR CODE_EAEC

LDA #$3A                 
JSR CODE_C847     
JSR CODE_EFEF
BNE CODE_ED57
 
INC $AE                  
LDA $AE                  
LDX $53                  
DEX                      
CMP DATA_C1F6,X              
BEQ CODE_ED85                
JMP LOOP_ED38

;enemy destruction (with a hammer)
CODE_ED57:
LDA #$02
STA $FF
  
LDA $00                  
STA $05

LDA $01                  
STA $06

LDA $53                  
CMP #$01
BNE CODE_ED74

LDA #$00                 
LDX $5D                  
STA $68,X

LDA #$01                 
JMP CODE_ED87

CODE_ED74:  
LDA #$10                 
STA $40

LDA #$00                 
LDX $AE                  
STA $E0,X                
STA $DB,X

LDA #$01                 
JMP CODE_ED87

CODE_ED85:  
LDA #$00
  
CODE_ED87:
STA $BF                  
RTS                      

CODE_ED8A:
LDA #$00                 
STA $AE

LDA #$3A                 
JSR CODE_C847

LOOP_ED93:
JSR CODE_EFDD                
JSR CODE_EAEC                
JSR CODE_EFEF                
BNE CODE_EDAD

INC $AE                  
LDA $AE                  
LDX $53                  
DEX                      
CMP DATA_C1F6,X              
BEQ CODE_EDB5                
JMP LOOP_ED93
  
CODE_EDAD:
JSR CODE_EF51

LDA #$FF                 
STA $96                  
RTS                      

CODE_EDB5:
LDA $96                  
CMP #$0A                 
BNE RETURN_EDC4

LDA $53                  
CMP #$01                 
BEQ RETURN_EDC4
JSR CODE_ECBF
  
RETURN_EDC4:
RTS

CODE_EDC5:
LDA $53                  
CMP #$03                 
BNE CODE_EDD2

LDY $96                  
CPY #$01                 
BEQ CODE_EDD2
RTS

CODE_EDD2:               
SEC                      
SBC #$01                 
ASL A                    
TAX   
LDA DATA_C42B,X              
STA $02
  
LDA DATA_C42B+1,X              
STA $03

LDA DATA_C423,X              
STA $00

LDA DATA_C423+1,X              
STA $01

CODE_EDEB:
JSR CODE_EFEF
BNE CODE_EE07
  
LDA $53                  
CMP #$03                 
BNE RETURN_EE0B

LDA $01                  
CMP #$C9                 
BEQ RETURN_EE0B

LDA #$70                 
STA $00

LDA #$C9					;
STA $01
JMP CODE_EDEB
  
CODE_EE07:
LDA #$FF
STA $96
  
RETURN_EE0B:
RTS

CODE_EE0C: 
LDA #$80
STA $0A

LDA #$80					;oh yeah, uhuh, right
STA $0B

JSR CODE_DFE4                
BNE CODE_EE1A                
RTS

CODE_EE1A:
LDA $53                  
CMP #$01                 
BNE CODE_EE26                
JSR CODE_EFD5                
JMP CODE_EE29

CODE_EE26:
JSR CODE_EFDD
  
CODE_EE29:
STX $04

JSR CODE_EAEC

LDA $BF                  
CMP #$01                 
BNE CODE_EE38

LDY #$02                 
STY $FF
  
CODE_EE38:
CMP #$0B                 
BEQ CODE_EE51

LDX $BF                  
DEX                      
LDA DATA_C1EB+1,X              
STA $02
  
JSR CODE_EADB

LDX $04                  
LDA #$02                 
JSR CODE_EE6C

INC $BF                  
RTS                      

CODE_EE51:
LDA $53                  
CMP #$01                 
BNE CODE_EE5C

LDA #$03                 
JSR CODE_EE6C
  
CODE_EE5C:
JSR CODE_EAD1                
JSR CODE_F094

LDX #$02                 
JSR CODE_CFC6

LDA #$00                 
STA $BF                  
RTS                      

CODE_EE6C:
STA $0202,X              
STA $0206,X              
STA $020A,X              
STA $020E,X              
RTS                      

CODE_EE79:  
LDY $53                  
CPY #$01                 
BNE CODE_EE80
RTS                      

CODE_EE80:
LDA $BE                  
BEQ RETURN_EED8                
CPY #$04                 
BNE CODE_EEF0

LDY #$00                 
LDX DATA_C5FF					;why not fixed value... again, this is a DK (NES) code we're talking about.

CODE_EE8D:
LDA UNUSED_C5C2,X				;and since we load "fixed" value i don't think loading these as table values is necessary
CMP $0203
BNE CODE_EEE7

LDA UNUSED_C5AE,X              
CMP $0200                
BCC CODE_EEE7                
SEC                      
SBC #$11                 
CMP $0200                
BCS CODE_EEE7

LDA $00C1,Y              
CMP #$00					;sigh
BNE CODE_EED9

LDA $96                  
CMP #$08                 
BEQ RETURN_EED8    
CMP #$FF                 
BEQ RETURN_EED8

LDA #$11					;erase 1 tile (removable tile from phase 3)
STA $CC						;

LDA #$01                 
STA $00C1,Y              
JSR CODE_EF38

LDA $0200                
CLC                      
ADC #$10                 
STA $06

LDA $0203                
STA $05

LDX #$00                 
JSR CODE_CFC6

LDA #$20                 
STA $FD
  
RETURN_EED8:
RTS

;check if player's falling off ledge
CODE_EED9:
LDA Jumpman_State				;if Jumpman's jumping, return
CMP #$04                 
BEQ RETURN_EEE6

JSR CODE_EF51

LDA #$08					;
STA Jumpman_State				;Jumpman's falling
  
RETURN_EEE6:
RTS                      

CODE_EEE7:
CPY #$07                 
BEQ CODE_EEF0                
INX                      
INY                      
JMP CODE_EE8D                

CODE_EEF0:     
LDY $53                  
LDX DATA_C5FA,Y

LDY #$00

CODE_EEF7:
LDA UNUSED_C5AE,X              
CMP $0200                
BNE CODE_EF2F

LDA UNUSED_C5C2,X              
CMP $0203                
BNE CODE_EF2F

LDA $00C9,Y              
BNE CODE_EF2F

LDA #$22                 
STA $CC

LDA #$01                 
STA $00C9,Y              
JSR CODE_EF38

LDA $0200                
SEC                      
SBC #$08                 
STA $06

LDA $0203                
STA $05
 
LDX #$03                 
JSR CODE_CFC6

LDA #$20                 
STA $FD

RETURN_EF2E:  
RTS                      

CODE_EF2F:
CPY #$02                 
BEQ RETURN_EF2E                
INX                      
INY                      
JMP CODE_EEF7

CODE_EF38:
LDA #$24
STA $CD
STA $CE
STA $CF
STA $D0
   
LDA DATA_C5D6,X              
STA $01

LDA UNUSED_C5E9,X              
STA $00

LDA #$48                 
JMP CODE_C815

CODE_EF51:
LDA $96                  
CMP #$0A                 
BNE RETURN_EF71

LDA $A0                  
BEQ RETURN_EF71   
SEC                      
SBC #$01                 
TAX                      
LDA #$00                 
STA $0451,X              
TXA                      
ASL A                    
ASL A                    
ASL A                    
TAX                      
LDA #$FF                 
STA $02D0,X              
STA $02D4,X
  
RETURN_EF71:
RTS

CODE_EF72:
STX $0F                  
ASL A                    
TAX                      
LDA $042C,X              
BNE CODE_EF94                
STA $0436,X              
CPX #$00                 
BNE CODE_EF87 

LDA #$08                 
JMP CODE_EF89

CODE_EF87:  
LDA #$80
  
CODE_EF89:
STA $0435,X

LDA #$F0
STA $042D,X              
JMP CODE_EFAD
  
CODE_EF94:
LDA $0435,X              
CPX #$00                 
BNE CODE_EFA0                
ADC #$10                 
JMP CODE_EFA2

CODE_EFA0:
ADC #$30
  
CODE_EFA2:
STA $0435,X

LDA $0436,X              
ADC #$00                 
STA $0436,X

;performing jump action?

CODE_EFAD:
LDA $042D,X              
SEC                      
SBC $043D,X              
STA $042D,X

LDA $01                  
SBC $043E,X              
STA $01                  
CLC                      
LDA $042D,X              
ADC $0435,X              
STA $042D,X

LDA $01                  
ADC $0436,X              
STA $01

INC $042C,X              
LDX $0F
RTS

CODE_EFD5:
LDA $5D

CODE_EFD7:
CLC                      
ADC #$03                 
JMP CODE_EFE2

CODE_EFDD:
LDA $AE                  
CLC                      
ADC #$01                 

CODE_EFE2:
ASL A                    
ASL A                    
ASL A                    
ASL A                    
TAX                      
RTS

CODE_EFE8:
JSR CODE_C847

CODE_EFEB:
LDA #$00                 
BEQ CODE_EFF5

CODE_EFEF:
LDA #$01                 
BNE CODE_EFF5

CODE_EFF3:
LDA #$02                 

CODE_EFF5:
STA $0C                  
TXA                      
PHA                      
TYA                      
PHA                      
LDY #$00

LDA $0C                  
BNE CODE_F018

JSR CODE_F063                
STA $46

JSR CODE_F069                
STA $47

JSR CODE_F062          
STA $48

JSR CODE_F069                
STA $49                  
JMP CODE_F059
  
CODE_F018:
JSR CODE_F063                
STA $4A
 
JSR CODE_F069                
STA $4B

JSR CODE_F062                
STA $4C

JSR CODE_F069                
STA $4D

LDA $4A                  
SEC                      
SBC $46                  
STA $9C
  
LDA $4B                  
SEC                      
SBC $47                  
STA $9D

LDA $49                  
CMP $4B                  
BCC CODE_F057

LDA $4D                  
CMP $47                  
BCC CODE_F057
  
LDA $4C                  
CMP $46                  
BCC CODE_F057

LDA $48                  
CMP $4A                  
BCC CODE_F057

LDA #$01                 
JMP CODE_F059
  
CODE_F057:
LDA #$00
  
CODE_F059:
STA $0C                  
PLA                      
TAY                      
PLA                      
TAX                      
LDA $0C                  
RTS

CODE_F062:
INY

CODE_F063:
LDA ($02),Y              
CLC                      
ADC $00                  
RTS                      

CODE_F069:
INY                      
LDA ($02),Y              
CLC                      
ADC $01                  
RTS

CODE_F070:
STA $02                  
JSR CODE_EAE1

CODE_F075:
JSR CODE_EACD

CODE_F078:
LDA $57                  
AND #$03                 
LSR A                    
JMP CODE_F096                

CODE_F080:
STA $04

CODE_F082:
LDA #$00                 
BEQ CODE_F096					;wow, so branches are now a thing?

CODE_F086:
STA $04

CODE_F088:
LDA #$01                 
BNE CODE_F096  

CODE_F08C:
STA $04

CODE_F08E:
LDA #$04
BNE CODE_F096                

CODE_F092:
STA $03

CODE_F094:
LDA #$0F

CODE_F096:

;push a bunch of things, registers, some temp RAM and stuff
PHA          
STA $0F
TXA                      
PHA                      
TYA                      
PHA                      
LDA $00                  
PHA                      
LDA $05                  
PHA                      
LDA $06                  
PHA                      
LDA $07                  
PHA                      
LDA $08                  
PHA                      
LDA $09                  
PHA                      
LDA #$02                 
STA $05

LDA $0F
CMP #$04
BEQ CODE_F0EF

LDA #$0F                 
AND $03                  
STA $07
     
LDA $03       
LSR A                    
LSR A                    
LSR A                    
LSR A                    
STA $06
TAX                      
LDA #$00                 
CLC

LOOP_F0CB:       
ADC $07                  
DEX                      
BNE LOOP_F0CB                
STA $08                  
LDA $0F                  
BNE CODE_F0DC                
JSR CODE_F11E                
JMP CODE_F0E9

CODE_F0DC:   
CMP #$01                 
BEQ CODE_F0E6                
JSR CODE_F195                
JMP CODE_F0F2

CODE_F0E6:
JSR CODE_F161

CODE_F0E9:
JSR CODE_F139                
JMP CODE_F0F2

CODE_F0EF:
JSR CODE_F10A

CODE_F0F2:
PLA
STA $09
PLA                      
STA $08                  
PLA                      
STA $07                  
PLA                      
STA $06                  
PLA                      
STA $05                  
PLA                      
STA $00                  
PLA                      
TAY                      
PLA                      
TAX                      
PLA                      
RTS

CODE_F10A:        
LDX $03     
LDY #$00

LOOP_F10E:
LDA #$FF                 
STA ($04),Y              
INY                      
INY
LDA $02                  
STA ($04),Y              
INY                      
INY                      
DEX                      
BNE LOOP_F10E                
RTS
  
CODE_F11E:
LDA $02                  
LDX $08                  
LDY #$01

LOOP_F124: 
STA ($04),Y              
CLC                      
ADC #$01                 
INY                      
PHA                      
LDA ($04),Y              
AND #$3F                 
STA ($04),Y              
PLA                      
INY                      
INY                      
INY                      
DEX                      
BNE LOOP_F124                
RTS

CODE_F139:
LDY #$00

LOOP_F13B:        
LDX $06                  
LDA $01                  
STA $09

LOOP_F141:
LDA $09                  
STA ($04),Y               
CLC                      
ADC #$08                 
STA $09                  
INY                      
INY                      
INY                      
LDA $00                  
STA ($04),Y              
INY                      
DEX                      
BNE LOOP_F141

LDA $00                  
CLC                      
ADC #$08                 
STA $00                  
DEC $07                  
BNE LOOP_F13B                
RTS                      


CODE_F161:
LDY #$01                 
STY $0A
       
LDA $08                  
SEC                      
SBC $06

LOOP_F16A:      
TAY                      
STA $0B                  
LDX $06

LOOP_F16F:
TYA                      
PHA                      
CLC                      
TYA                      
ADC $02                  
LDY $0A                  
STA ($04),Y

INY                      
LDA ($04),Y              
AND #$3F                 
EOR #$40                 
STA ($04),Y

INY                      
INY                      
INY                      
STY $0A                  
PLA                      
TAY                      
INY                      
DEX                      
BNE LOOP_F16F                
LDA $0B                  
SEC                      
SBC $06                  
BPL LOOP_F16A                
RTS                                    

;this is used to clear OAM data
;sometimes thrice or more
CODE_F195:
LDY #$00

LOOP_F197:   
LDX $06

LDA $01                  
STA $09

LDA #$FF

LOOP_F19F:
STA ($04),Y              
INY                      
INY                      
INY                      
INY                      
DEX                      
BNE LOOP_F19F

LDA $00                  
CLC                      
ADC #$08                 
STA $00                  
DEC $07                  
BNE LOOP_F197                
RTS                      

;clear screen and attributes
CODE_F1B4:
LDA HardwareStatus				;write during V-blank                
LDA ControlMirror				;no sprite tile select  
AND #$FB
STA ControlBits

LDA #$20					;set initial VRAM drawing position
STA VRAMDrawPosReg				;

LDA #$00
STA VRAMDrawPosReg				;it's $2000

LDX #$04
LDY #$00                 
LDA #$24					;fill entire screen with tile 24

LOOP_F1CE: 
STA DrawRegister
DEY                      
BNE LOOP_F1CE                
DEX                      
BNE LOOP_F1CE

LDA #$23					;clear attributes
STA VRAMDrawPosReg				;

LDA #$C0					;
STA VRAMDrawPosReg				;

LDY #$40                 
LDA #$00

LOOP_F1E5:
STA DrawRegister
DEY                      
BNE LOOP_F1E5
RTS

;NES Stripe Image RLE

LOOP_F1EC:
STA VRAMDrawPosReg				;store VRAM position to write to (high byte)
INY						;
LDA ($00),Y					;
STA VRAMDrawPosReg				;Low byte
INY						;
LDA ($00),Y					;next byte is how many bytes to write and if it should be repeated
ASL A						;shift left
PHA						;
LDA ControlMirror				;
ORA #$04					;enable drawing in a verical line
BCS CODE_F202					;
AND #$FB					;or disable it (on bit 7)
  
CODE_F202:
STA ControlBits
STA ControlMirror
PLA
ASL A						;shift again
BCC CODE_F20E					;if carry was set by shifting bit 6 (which should trigger repeated write)
ORA #$02					;set bit that'll go into carry when we shift everything back
INY
  
CODE_F20E:
LSR A						;
LSR A						;restore original value-bit 6 - how many bytes to write
TAX						;and said write X times into X

LOOP_F211:
BCS CODE_F214					;check carry from before and store the same value if set
INY						;otherwise use next value

CODE_F214:
LDA ($00),Y					;
STA $2007					;
DEX						;
BNE LOOP_F211					;
SEC						;set carry
TYA						;shift original read location so we can continue from here
ADC $00						;
STA $00						;

LDA #$00					;high byte ofc.
ADC $01						;
STA $01						;

CODE_F228:
LDX HardwareStatus				;
LDY #$00					;
LDA ($00),Y					;if value isn't zero, which acts as stop writing comand
BNE LOOP_F1EC					;do actual writing

LDA CameraPositionY				;restore camera position
STA CameraPositionReg				;

LDA CameraPositionX				;
STA CameraPositionReg				;
RTS						;

;add score - push stuff to buffer.
CODE_F23C:
CLD						;disable decimal mode (not sure why)
LDA #$04					;

LOOP_F23F:
LSR $00
BCC CODE_F248
PHA                      
JSR CODE_F24E                
PLA

CODE_F248:
CLC                      
SBC #$00					;question-mark
BPL LOOP_F23F                
RTS

CODE_F24E:  
ASL A
ASL A
TAY
STA $01

LDX $0330					;how many counters to update/which counter to upate?
LDA DATA_C000,Y					;
STA $0331,X					;first byte  - VRAM location, low byte
JSR CODE_F32D					;

INY                      
LDA DATA_C000,Y					;second byte - VRAM location, high byte
STA $0331,X
JSR CODE_F32D

INY
LDA DATA_C000,Y					;third byte - how many digits (tiles) to write (update)
AND #$87					;unsure
STA $0331,X					;
AND #$07					;still unsure
STA $02						;how many digits
TXA						;
SEC						;
ADC $02						;
JSR CODE_F32F					;
TAX						;
STX $0330					;

LDA #$00
STA $0331,X					;ones/tens is always zero - there's no score bonus that adds from 1 to 99
INY						;
LDA DATA_C000,Y					;load end command for score update after all digit bytes
STA $03						;
DEX						;
CLC

LOOP_F28E:  
LDA $0020,Y					;store byte's low digit
AND #$0F					;
BEQ CODE_F296					;
CLC

CODE_F296:
BCC CODE_F29A

;----------------------------------------------
;!UNUSED
;probably supposed to draw empty tiles for high (or low?) digits that are zero but there's no more logic to support this.
LDA #$24
;----------------------------------------------
  
CODE_F29A:
STA $0331,X					;
DEX						;
DEC $02						;next digit
BEQ CODE_F2C4					;when all bytes transferred, end (it'd work if counter had even amount of digits, like unused loop counter data)

LDA $0020,Y					;high digit
AND #$F0					;
PHP						;
LSR A						;shift it to low nibble - actual digit value
LSR A						;
LSR A						;
LSR A						;
PLP						;
BEQ CODE_F2B0					;
CLC						;

CODE_F2B0:
BCC CODE_F2B4					;

;----------------------------------------------
;!UNUSED
;Similar to the same line from above. unsure why it's here...
LDA #$24
;----------------------------------------------

CODE_F2B4:
STA $0331,X					;

LDA $03						;
AND #$01					;check for some bit
BEQ CODE_F2BE					;

;----------------------------------------------
;!UNUSED
;Unknown what this supposed to do but it could've been by a trigger bit.
SEC
;----------------------------------------------

CODE_F2BE:    
DEY						;next score address
DEX						;and digit
DEC $02						;and -1 byte to transfer
BNE LOOP_F28E					;
  
CODE_F2C4:
LDA $03						;
AND #$10
BEQ RETURN_F2D6

;----------------------------------------------
;!UNUSED
;Unknown code for unknown (unused) trigger bit
INX
LDY $01
CLC
LDA $0020,Y
ADC #$37
STA $0331,X
;----------------------------------------------

RETURN_F2D6:
RTS

;draw kong - toss into buffer.
;BufferKongFrame_F2D7: 
;(except not really)
CODE_F2D7:
LDY #$00					;
LDA ($02),Y					;get first byte's low digit - vertical lines
AND #$0F					;
STA $05						;

LDA ($02),Y					;amount of bytes per-line
LSR A						;
LSR A						;
LSR A						;
LSR A						;
STA $04						;

LDX $0330					;load buffer offset

LOOP_F2EA:
LDA $01						;VRAM locations are pre-set
STA $0331,X					;high byte
JSR CODE_F32D					;
 
LDA $00						;
STA $0331,X					;low byte
JSR CODE_F32D					;

LDA $04						;
STA $06						;
ORA #VRAMWriteCommand_DrawVert			;vertical drawing
STA $0331,X					;

LOOP_F303: 
JSR CODE_F32D					;
INY						;
LDA ($02),Y					;
STA $0331,X					;
DEC $06						;if transferred all bytes for current line, proceed...
BNE LOOP_F303					;
  
JSR CODE_F32D					;
CLC						;next vertical row in VRAM.
LDA #$01					;
ADC $00						;
STA $00

LDA #$00					;
ADC $01						;take high byte into account also
STA $01						;
STX $0330					;next row index

DEC $05						;
BNE LOOP_F2EA					;if all rows were stored, exit

LDA #VRAMWriteCommand_Stop			;
STA $0331,X					;
RTS						;

;NextDrawingIndex_F32D:
CODE_F32D:
INX						;next index...
TXA						;into A

CODE_F32F:
CMP #$3F
BCC RETURN_F33D

;i think this is a fail proof for tile updates, if too many tiles update at once, game will glitch. or something like that. there's not as much tile updates however.
LDX $0330					;don't update what we wanted

LDA #$00					;put an end
STA $0331,X					;
PLA						;\
PLA						;/terminate return from routine that called this one

RETURN_F33D:
RTS						;

CODE_F33E:
LDX #$FF
BNE CODE_F344

CODE_F342:   
LDX #$00

CODE_F344:
STX $04

LDX #$00
STX $05                  
STX $06                  
STX $07

LDA $01                  
AND #$08                 
BNE CODE_F355                
INX						;untriggered
  
CODE_F355:
LDA $00                  
STA $06,X

LDA $01                  
JMP CODE_F35E					;ok???

CODE_F35E:
AND #$07                 
ASL A                    
ASL A                    
TAX                      
LDA $04                  
BEQ CODE_F38E

LDA $24,X                
BEQ CODE_F392

CODE_F36B:
CLC                      
LDA $27,X                
STA $03

LDA $07                  
JSR CODE_F3E3                
STA $27,X

LDA $26,X                
STA $03

LDA $06                  
JSR CODE_F3E3                
STA $26,X

LDA $25,X                
STA $03

LDA $05
JSR CODE_F3E3
STA $25,X
RTS

CODE_F38E:  
LDA $24,X                
BEQ CODE_F36B
  
CODE_F392:
SEC                      
LDA $27,X                
STA $03

LDA $07                  
JSR CODE_F404
STA $27,X

LDA $26,X                
STA $03

LDA $06                  
JSR CODE_F404
STA $26,X

LDA $25,X                
STA $03

LDA $05                  
JSR CODE_F404
STA $25,X

LDA $25,X                
BNE CODE_F3C0

LDA $26,X                
BNE CODE_F3C0

LDA $27,X                
BEQ CODE_F3C6
  
CODE_F3C0:
BCS RETURN_F3E2
    
LDA $24,X					;how to trigger these lines?
EOR #$FF					;

CODE_F3C6:  
STA $24,X   
SEC                      
LDA #$00                 
STA $03

LDA $27,X                
JSR CODE_F404

STA $27,X
LDA $26,X                
JSR CODE_F404                
STA $26,X

LDA $25,X                
JSR CODE_F404 
STA $25,X

RETURN_F3E2:
RTS                      

CODE_F3E3:
JSR CODE_F426
ADC $01                  
CMP #$0A                 
BCC CODE_F3EE                
ADC #$05

CODE_F3EE:  
CLC                      
ADC $02                  
STA $02
  
LDA $03
AND #$F0
ADC $02
BCC CODE_F3FF

CODE_F3FB:
ADC #$5F
SEC
RTS

CODE_F3FF:
CMP #$A0                 
BCS CODE_F3FB                
RTS                      

CODE_F404:
JSR CODE_F426
SBC $01
STA $01
BCS CODE_F417                
ADC #$0A                 
STA $01

LDA $02                  
ADC #$0F                 
STA $02
  
CODE_F417:
LDA $03                  
AND #$F0                 
SEC                      
SBC $02                  
BCS CODE_F423
ADC #$A0                 
CLC

CODE_F423:
ORA $01                  
RTS

;extract two digits into two bytes
;Input:
;A - Value to get digits from
;
;Output:
;$01 - low digit (00-0F)
;$02 - high digit (00-F0) 

CODE_F426:
PHA
AND #$0F
STA $01
PLA
AND #$F0
STA $02

LDA $03
AND #$0F
RTS

CODE_F435:
LDA #$00                 
STA $04                  
CLC

LDA $00                  
ADC #$10                 
AND #$F0                 
LSR A                    
LSR A                    
TAY
  
LDA $00                  
AND #$07                 
ASL A
ASL A
TAX

CODE_F44A:
LDA $0020,Y              
BEQ CODE_F4A0

LDA $24,X
BEQ CODE_F479

CODE_F453:
SEC                      
LDA $0023,Y              
STA $03

LDA $27,X                
JSR CODE_F404

LDA $0022,Y              
STA $03

LDA $26,X                
JSR CODE_F404

LDA $0021,Y              
STA $03

LDA $25,X                
JSR CODE_F404 
BCS CODE_F4A4

LDA $0020,Y              
BNE CODE_F4A9
  
CODE_F479:
LDA #$FF                 
STA $04    
SEC

CODE_F47E:   
TYA                      
BNE RETURN_F49F
BCC CODE_F493

LDA $24,X
STA $20

LDA $25,X                
STA $21

LDA $26,X                
STA $22

LDA $27,X                
STA $23
  
CODE_F493:
LDA $00                  
AND #$08                 
BEQ RETURN_F49F                
DEX                      
DEX                      
DEX                      
DEX                      
BPL CODE_F44A
  
RETURN_F49F:
RTS

CODE_F4A0:
LDA $24,X                
BEQ CODE_F453
  
CODE_F4A4:
LDA $0020,Y              
BNE CODE_F479

CODE_F4A9:
CLC    
BCC CODE_F47E

;Handle various timers
;HandleTimers_F4AC:
CODE_F4AC:
LDX #$09
DEC Timer_Timing
BPL LOOP_F4B8

LDA #$0A					;decrease every some timers every 10 frames
STA Timer_Timing

LDX #$10

LOOP_F4B8:
LDA Timer_Global,X
BEQ CODE_F4BE

DEC Timer_Global,X

CODE_F4BE:
DEX                      
BPL LOOP_F4B8             
RTS

CODE_F4C2:
LDX $0330

LDA $01
STA $0331,X

JSR CODE_F32D

LDA $00                  
STA $0331,X              
JSR CODE_F32D

LDA #$01                 
STA $0331,X              
JSR CODE_F32D

TYA                      
STA $0331,X              
JSR CODE_F32D
      
LDA #$00                 
STA $0331,X              
STX $0330                
RTS

;the root of all evil in this game - RNG.
RNG_F4ED:
If Version = Gamecube
  JSR Gamecube_CODE_BFD0			;make RNG slower for one reason or another on gamecube version
  NOP
else
  LDA $18					;
  AND #$02					;
endif

STA $00						;
         
LDA $19                  
AND #$02
EOR $00
CLC
BEQ CODE_F4FD
SEC

CODE_F4FD:
ROR $18
ROR $19
ROR $1A
ROR $1B
ROR $1C
ROR $1D
ROR $1E
ROR $1F
RTS

;controller reading routine
;i've seen it before in Mario Bros. i assume it's used in most (if not all) early Nintendo NES titles.
;only beginning part and end are slightly different

CODE_F50E:
LDA #$01					;prepare controller 1 for reading
STA ControllerReg

LDX #$00 
LDA #$00                 
STA ControllerReg				;and controller 2
JSR CODE_F522
INX
If Version = JP
JMP JP_CODE_F530				;interestingly enough, Revision 1 REMOVES a minor optimization... though it's pointless either way
else
JSR CODE_F522					;
RTS						;eh
endif

JP_CODE_F530:
CODE_F522:
LDY #$08

LOOP_F524:
PHA                      
LDA ControllerReg,X              
STA $00                  
LSR A                    
ORA $00                  
LSR A                    
PLA                      
ROL A                    
DEY                      
BNE LOOP_F524
STX $00
ASL $00						;double X, basically, to get proper press and hold addresses for each player

LDX $00                  
LDY $14,X 
STY $00
STA $14,X
If Version = JP
  STA $15,X					;HMM...
endif              
AND #$FF                 
BPL CODE_F549               
BIT $00                  
BPL CODE_F549
AND #$7F

If Version = JP
  STA $15,X					;japenese version has a shorter input reading code. US adds some bit (probably related with 2 inputs at once, for example holding left+up won't make jumpman move left in rev 0)

JP_RETURN_F55B:
CODE_F549:
  RTS
else
CODE_F549:
  LDY $15,X
  STA $15,X                
  TYA                      
  AND #$0F                 
  AND $15,X                
  BEQ RETURN_F55A
  ORA #$F0
  AND $15,X
  STA $15,X

RETURN_F55A:
  RTS
endif

;phase design (or layout, whichever you prefer), including palettes and attributes
;Phase 1
DATA_F55B:
;First, palette.
db $3F,$00
db $20
db $0F,$15,$2C,$12				;all background palettes
db $0F,$27,$02,$17
db $0F,$30,$36,$06
db $0F,$30,$2C,$24

db $0F,$02,$36,$16				;sprite palettes
db $0F,$30,$27,$24
db $0F,$16,$30,$37
db $0F,$06,$27,$02

;after palette there are attributes
db $23,$C0
db $08|VRAMWriteCommand_Repeat
db $FF						;very top of the screen (where score is at)

db $23,$C8
db $03
db $55,$AA,$22					;barrels, Donkey Kong and a little bit of platform to the side

db $23,$CD
db $03|VRAMWriteCommand_Repeat
db $0F

;the actual stage layout
db $20,$2C
db $07|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $20,$81
db $04|VRAMWriteCommand_DrawVert
db $50,$51,$52,$53

db $20,$82
db $04|VRAMWriteCommand_DrawVert
db $54,$55,$56,$57

db $20,$83
db $04|VRAMWriteCommand_DrawVert
db $58,$59,$5A,$5B

db $20,$2A
db $07|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $20,$AD
db $06|VRAMWriteCommand_Repeat
db $30

db $20,$CA
db $03|VRAMWriteCommand_Repeat
db $30

db $20,$D2
db $02|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $21,$02
db $0E|VRAMWriteCommand_Repeat
db $30

db $21,$10
db $0C
db $3E,$3E,$45,$3D,$3D,$3D,$3C,$3C
db $3C,$3B,$3B,$3B

db $21,$2D
db $0F
db $3F,$24,$24,$37,$37,$37,$36,$36
db $36,$35,$35,$35,$49,$34,$34

db $21,$59
db $01
db $3F

db $21,$6D
db $11
db $40,$38,$38,$39,$39,$39,$3A,$3A
db $3A,$3B,$3B,$3B,$43,$3C,$3C,$3D
db $3D

db $21,$84
db $1A
db $3D,$3D,$3D,$3E,$3E,$3E,$30,$30
db $30,$31,$31,$31,$32,$32,$32,$33
db $33,$33,$34,$49,$34,$35,$35,$35
db $36,$36

db $21,$A4
db $06
db $36,$36,$4B,$37,$37,$37

db $21,$C6
db $01
db $3F

db $21,$E2
db $17
db $30,$30,$3E,$3E,$45,$3D,$3D,$3D
db $3C,$43,$3C,$3B,$3B,$3B,$3A,$3A
db $3A,$39,$39,$39,$38,$40,$38

db $21,$AB
db $02|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $22,$04
db $18
db $37,$37,$37,$36,$36,$36,$4A,$35
db $35,$34,$34,$34,$48,$33,$33,$32
db $32,$32,$31,$31,$31,$30,$30,$30

db $22,$30
db $02|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $22,$39
db $01
db $3F

db $22,$4A
db $01
db $3F

db $22,$59
db $05
db $40,$38,$38,$39,$39

db $22,$64
db $1A
db $39,$39,$39,$3A,$3A,$3A,$42,$3B
db $3B,$3C,$3C,$3C,$44,$3D,$3D,$3E
db $3E,$3E,$30,$30,$30,$31,$31,$31
db $32,$32

db $22,$84
db $12
db $32,$32,$47,$33,$33,$33,$34,$34
db $34,$35,$4A,$35,$36,$36,$36,$37
db $37,$37

db $22,$A6
db $01
db $3F

db $22,$AE
db $02|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $22,$C2
db $0B
db $3B,$3B,$3A,$3A,$41,$39,$39,$39
db $38,$38,$38

db $22,$E2
db $1A
db $34,$34,$33,$33,$33,$32,$32,$32
db $31,$31,$46,$30,$30,$30,$3E,$3E
db $3E,$3D,$3D,$3D,$3C,$3C,$3C,$3B
db $3B,$3B

db $23,$0C
db $10
db $3F,$24,$24,$24,$37,$37,$37,$36
db $36,$36,$35,$35,$35,$49,$34,$34

db $23,$39
db $01
db $3F

db $23,$4C
db $13
db $3F,$24,$24,$24,$38,$38,$38,$39
db $39,$39,$3A,$3A,$3A,$42,$3B,$3B
db $3C,$3C,$3C

db $23,$61
db $0F|VRAMWriteCommand_Repeat
db $30

db $23,$70
db $0F
db $31,$31,$31,$32,$32,$32,$33,$33
db $33,$34,$34,$34,$35,$35,$35

db $23,$24
db $02|VRAMWriteCommand_DrawVert
db $4C,$4D

db $23,$25
db $02|VRAMWriteCommand_DrawVert
db $4E,$4F

db VRAMWriteCommand_Stop

;Phase 2
DATA_F71C:
db $3F,$00					;palette changes
db $08						;
db $0F,$2C,$27,$02				;tile 0
db $0F,$30,$12,$24			;	tile 1

db $3F,$1D
db $03
db $06,$30,$12					;?

db $23,$C0
db $08|VRAMWriteCommand_Repeat
db $FF

db $23,$C9
db $07
db $55,$00,$AA,$AA,$0F,$0F,$0F

db $23,$E2
db $05
db $04,$00,$00,$00,$01

db $20,$C5
db $02
db $70,$72

db $20,$E5
db $02
db $71,$73

db $20,$CA
db $02|VRAMWriteCommand_Repeat
db $62

db $21,$05
db $16|VRAMWriteCommand_Repeat
db $62

db $21,$A4
db $18|VRAMWriteCommand_Repeat
db $62

db $22,$43
db $1A|VRAMWriteCommand_Repeat
db $62

db $22,$E2
db $1C|VRAMWriteCommand_Repeat
db $62

db $23,$61
db $1E|VRAMWriteCommand_Repeat
db $62

db $21,$08
db $01
db $63

db $21,$17
db $01
db $63

db $21,$A8
db $01
db $63

db $21,$B7
db $01
db $63

db $22,$48
db $01
db $63

db $22,$57
db $01
db $63

db $22,$E8
db $01
db $63

db $22,$F7
db $01
db $63

db $21,$25
db $04|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $21,$29
db $04|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $21,$36
db $04|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $21,$3A
db $04|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $21,$C4
db $04|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $21,$D0
db $04|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $21,$DB
db $04|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $22,$63
db $04|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $22,$6C
db $04|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $22,$73
db $04|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $22,$7C
db $04|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $23,$02
db $03|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $23,$0F
db $03|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $23,$1D
db $03|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $22,$0A
db $02|VRAMWriteCommand_DrawVert
db $6E,$6F

db $22,$18
db $02|VRAMWriteCommand_DrawVert
db $70,$71

db $22,$19
db $02|VRAMWriteCommand_DrawVert
db $72,$73

db VRAMWriteCommand_Stop

;Phase 3 (100M)
DATA_F7CD:
db $3F,$00
db $08
db $0F,$15,$2C,$06
db $0F,$30,$27,$16

db $3F,$1D
db $03
db $12,$37,$15

db $23,$C0
db $08|VRAMWriteCommand_Repeat
db $FF

db $23,$C9
db $02
db $AA,$22

db $23,$CD
db $03|VRAMWriteCommand_Repeat
db $0F

db $23,$D1
db $02|VRAMWriteCommand_DrawVert
db $84,$48

db $23,$D7
db $05
db $03,$0C,$88,$00,$88

db $23,$E1
db $03
db $88,$00,$88

db $23,$E9
db $03
db $88,$00,$88

db $23,$D3
db $02|VRAMWriteCommand_DrawVert
db $84,$48

db $20,$2C
db $07|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $20,$2A
db $07|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $20,$CA
db $03|VRAMWriteCommand_Repeat
db $30

db $20,$AD
db $06|VRAMWriteCommand_Repeat
db $30

db $20,$D2
db $02|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $21,$02
db $15|VRAMWriteCommand_Repeat
db $30

db $21,$06
db $02
db $5E,$5F

db $21,$26
db $02
db $5C,$5D

db $21,$0E
db $02
db $5E,$5F

db $21,$2E
db $02
db $5C,$5D

db $23,$61
db $1E|VRAMWriteCommand_Repeat
db $30

db $23,$46
db $02
db $5C,$5D

db $23,$66
db $02
db $60,$61

db $23,$4E
db $02
db $5C,$5D

db $23,$6E
db $02
db $60,$61

db $21,$46
db $10|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $74

db $21,$47
db $10|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $75

db $21,$5C
db $02|VRAMWriteCommand_Repeat
db $30

db $21,$79
db $02|VRAMWriteCommand_Repeat
db $30

db $21,$96
db $02|VRAMWriteCommand_Repeat
db $30

db $21,$B2
db $03|VRAMWriteCommand_Repeat
db $30

db $21,$C2
db $03|VRAMWriteCommand_Repeat
db $30

db $21,$C9
db $04|VRAMWriteCommand_Repeat
db $30

db $21,$F9
db $05|VRAMWriteCommand_Repeat
db $30

db $22,$33
db $02|VRAMWriteCommand_Repeat
db $30

db $22,$56
db $02|VRAMWriteCommand_Repeat
db $30

db $22,$79
db $02|VRAMWriteCommand_Repeat
db $30

db $22,$9C
db $02|VRAMWriteCommand_Repeat
db $30

db $22,$82
db $03|VRAMWriteCommand_Repeat
db $30

db $22,$CA
db $03|VRAMWriteCommand_Repeat
db $30

db $22,$DB
db $03|VRAMWriteCommand_Repeat
db $30

db $22,$F8
db $02|VRAMWriteCommand_Repeat
db $30

db $23,$15
db $02|VRAMWriteCommand_Repeat
db $30

db $23,$22
db $03|VRAMWriteCommand_Repeat
db $30

db $23,$31
db $03|VRAMWriteCommand_Repeat
db $30

db $21,$36
db $03|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $21,$7C
db $04|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $21,$D3
db $03|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $21,$E4
db $05|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $21,$EA
db $07|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $21,$EC
db $07|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $22,$19
db $03|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $22,$A3
db $04|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $22,$BC
db $01
db $3F

db $21,$82
db $02|VRAMWriteCommand_DrawVert
db $70,$71

db $21,$83
db $02|VRAMWriteCommand_DrawVert
db $72,$73

db $21,$1D
db $82|VRAMWriteCommand_DrawVert
db $6E,$6F

db $21,$4E
db $10|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $74

db $21,$4F
db $10|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $75

db VRAMWriteCommand_Stop

;VRAM Data for title screen (palettes, attributes and tiles)
;Palette
DATA_F8D9:
db $3F,$00					;VRAM pos to write to

db $0D						;write 13 bytes

db $0F,$2C,$38					;tile palette 0
If Version = JP
db $02						;US Version brightens "Donkey Kong" title
else
db $12
endif
db $0F,$27,$27,$27				;tile palette 1
db $0F,$30,$30,$30				;tile palette 2
db $0F						;so, you're telling me that palette 3 has only a single color update?

db $3F,$11					;next location
db $01						;a single byte of update (sprite palette 0, used for cursor)
db $25						;

db $23,$E0
db $10|VRAMWriteCommand_Repeat			;16 bytes of repeated update
db $55

db $23,$F0
db $08|VRAMWriteCommand_Repeat
db $AA

;from here actually draw title screen
db $20,$83
db $05|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $20,$84
db $05|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $20,$85
db $01
db $62

db $21,$05
db $01
db $62

db $20,$A6
db $03|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $20,$88
db $05|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $20,$89
db $01
db $62

db $21,$09
db $01
db $62

db $20,$8A
db $05|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $20,$8C
db $05|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $20,$AD
db $C2
db $62

db $20,$CE
db $02|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $20,$8F
db $05|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $20,$91
db $05|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $20,$B2
db $02|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $20,$B3
db $01
db $62

db $20,$94
db $01
db $62

db $20,$F3
db $01
db $62

db $21,$14
db $01
db $62

db $20,$96
db $05|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $20,$97
db $02|VRAMWriteCommand_Repeat
db $62

db $20,$D7
db $02|VRAMWriteCommand_Repeat
db $62

db $21,$17
db $02|VRAMWriteCommand_Repeat
db $62

db $20,$9A
db $03|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $20,$DB
db $03|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $20,$9C
db $03|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $21,$47
db $05|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $21,$68
db $02|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $21,$69
db $01
db $62

db $21,$4A
db $01
db $62

db $21,$A9
db $01
db $62

db $21,$CA
db $01
db $62

db $21,$4C
db $05|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $21,$4D
db $01
db $62

db $21,$CD
db $01
db $62

db $21,$4E
db $05|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $21,$50
db $05|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $21,$71
db $02|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $21,$92
db $02|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $21,$53
db $05|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $21,$55
db $05|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $21,$56
db $03|VRAMWriteCommand_Repeat
db $62

db $21,$D6
db $03|VRAMWriteCommand_Repeat
db $62

db $21,$98
db $02|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $21,$97
db $01
db $62

db $22,$09
db $0F
db $01,$24,$19,$15,$0A,$22,$0E,$1B
db $24,$10,$0A,$16,$0E,$24,$0A

db $22,$49
db $0F
db $01,$24,$19,$15,$0A,$22,$0E,$1B
db $24,$10,$0A,$16,$0E,$24,$0B

db $22,$89
db $0F
db $02,$24,$19,$15,$0A,$22,$0E,$1B
db $24,$10,$0A,$16,$0E,$24,$0A

db $22,$C9
db $0F
db $02,$24,$19,$15,$0A,$22,$0E,$1B
db $24,$10,$0A,$16,$0E,$24,$0B

db $23,$05
db $16
db $D3,$01,$09,$08,$01,$24,$17,$12
db $17,$1D,$0E,$17,$0D,$18,$24,$0C
db $18,$65,$15,$1D,$0D,$64

db $23,$4B
db $0D
db $16,$0A,$0D,$0E,$24,$12,$17,$24
db $13,$0A,$19,$0A,$17

db VRAMWriteCommand_Stop

;data for hud - score symbols (I, II, TOP) and other counters
DATA_FA1B:
db $20,$63
db $01						;I
db $FF

db $20,$6D
db $03
db $D0,$D1,$D2					;word TOP

db $20,$76
db $02
db $FE,$FF					;II

db $20,$94
db $0A						;top of lives/bonus/loop counters portion
db $25,$16,$2A,$26,$27,$28,$29,$2A
db $15,$2D

db $20,$B4
db $0A
db $2B,$24,$2C,$24,$24,$24,$24,$2C		;empty tiles (default is 24) are for values to be written later
db $24,$2F

db VRAMWriteCommand_Stop

;US (and Gamecube) has 2 bytes of freespace here, JP has 3

org $FA48
;sound engine (fixed location for all versions)
CODE_FA48:
LDA #$C0
STA $4017					;sequencer mode and interrupt inhibit flag
JSR CODE_FBF2					;play music/sound

LDX #$00                 
STX $FF						;reset sound/music values
STX $FE						;
STX $FD						;
    
LDA $06F0                
CMP #$90                 
BCS CODE_FA64

LDX #$00                 
STX $06F1
  
CODE_FA64:
CMP #$D8                 
BCC CODE_FA6B    
INC $06F1
  
CODE_FA6B:
TAY                      
LSR A                    
LSR A                    
LSR A                    
LSR A                    
LSR A                    
LSR A                    
STA $00                  
TYA                      
LDX $06F1                
BNE CODE_FA7F                
SEC                      
ADC $00                  
BNE CODE_FA82

CODE_FA7F:  
CLC                      
SBC $00

CODE_FA82:
STA $06F0                
RTS

CODE_FA86:
LDY #$07

CODE_FA88:
ASL A                    
BCS RETURN_FA8E                
DEY                      
BNE CODE_FA88

RETURN_FA8E:
RTS

CODE_FA8F:
STA $F1                  
STY $F2                  

CODE_FA93:
LDY #$7F                 

CODE_FA95:
STX $4000                
STY $4001                
RTS

JSR CODE_FA95					;inaccessible line of code

CODE_FA9F:
LDX #$00

CODE_FAA1:   
TAY                      
LDA UNUSED_FB00+1,Y              
BEQ RETURN_FAB2                
STA $4002,X 

LDA UNUSED_FB00,Y              
ORA #$08                 
STA $4003,X
  
RETURN_FAB2:
RTS

CODE_FAB3:
STY $4005

LDX #$04                 
BNE CODE_FAA1

CODE_FABA:
STA $4008                
TXA                      
AND #$3E                 
LDX #$08                 
BNE CODE_FAA1

CODE_FAC4:
TAX                      
ROR A                    
TXA                      
ROL A
ROL A
ROL A

CODE_FACA:  
AND #$07                 
CLC                      
ADC $068D                
TAY                      
LDA DATA_FB4C,Y              
RTS                      

CODE_FAD5:
TYA                      
LSR A

CODE_FAD7:
LSR A                    
LSR A                    
STA $00                  
TYA                      
SEC                      
SBC $00                  
RTS                      

CODE_FAE0:
LDA #$90                 
STA $4000                
RTS

DATA_FAE6:
db $8D,$8D,$8C,$8C,$8B,$8C,$83,$83
db $8F,$8F,$8F,$8F,$8D,$85,$84

DATA_FAF5:
db $85,$7F,$85,$85,$85,$7F,$8D,$8D
db $8D,$8D,$8D           

;first three bytes are unused
UNUSED_FB00:
db $07,$F0,$00

db $00,$00,$69,$00,$53,$00,$46,$00
db $D4,$00,$BD,$00,$A8,$00,$9F,$00
db $8D,$00,$7E,$01,$AB,$01,$7C,$01
db $52,$01,$3F,$01,$1C,$00,$FD,$00
db $EE,$00,$E1,$03,$57,$02,$F9

;unused
db $02,$CF
;---

db $02,$A6,$02,$80,$02,$3A,$02,$1A
db $01,$FC,$01,$DF,$01,$C4,$06,$AE
db $05,$9E,$05,$4D,$05,$01,$04,$75
db $04,$35,$03,$F8,$03,$BF,$03,$89


DATA_FB4C:
db $05,$0A,$14,$28,$50,$1E,$3C,$0B
db $06,$0C,$18,$30,$60,$24

db $48						;unused

db $07,$0D,$1A,$34,$78,$27,$4E

DATA_FB62:
db $0A,$08,$05,$0A,$09

DATA_FB67:
db $50,$40,$46,$4A,$50,$56,$5C,$64
db $6C,$74,$7C,$88,$90,$9A

CODE_FB75:
STA $F0                  
STA $FB

LDY #$08                 
JMP CODE_FD67                

CODE_FB7E:
STY $F0                  
LDA #$71                 
LDY #$00                 
LDX #$9F                 
JSR CODE_FA8F                

CODE_FB89:
LDX $F2                  
LDY DATA_FB67,X              
    
DEC $F1                  
LDA $F1                  
BEQ CODE_FB75                
AND #$07                 
BNE CODE_FBA0                
TYA                      
LSR A                    
ADC DATA_FB67,X              
TAY                      
BNE CODE_FBA7

CODE_FBA0:
AND #$03                 
BNE CODE_FBB2
    
INC $F2                  
CLC
  
CODE_FBA7:
STY $4002
 
LDY #$28                 
BCC CODE_FBAF

INY						;unused (branch before will always trigger)

CODE_FBAF:      
STY $4003
  
CODE_FBB2:
LDA #$00
JMP CODE_FE00
  
CODE_FBB7:
STY $F0

LDA #$54                 
LDY #$6A                 
LDX #$9C                 
JSR CODE_FA8F
  
CODE_FBC2:
LDY $F2                  
LDA $F1                  
AND #$03                 
BEQ CODE_FBD4                
CMP #$03                 
BNE CODE_FBD9

JSR CODE_FAD5                
STA $F2                  
TAY

CODE_FBD4:
TYA                      
LSR A                    
ADC $F2                  
TAY

CODE_FBD9:
TYA                      
ROL A                    
ROL A                    
ROL A                    
STA $4002                
ROL A                    
STA $4003

LDA $F1                  
CMP #$18                 
BCS CODE_FC44                
LSR A                    
ORA #$90                 
STA $4000                
BNE CODE_FC44                

CODE_FBF2:
LDY $FF
LDA $F0 
LSR A     
BCS CODE_FB89                
LSR $FF						;$01 - died
BCS CODE_FB7E					;

LDX $FA                  
BNE CODE_FC4B                
LSR A                    
BCS CODE_FBC2                
LSR $FF						;$02 - enemy destruct
BCS CODE_FBB7                
LSR A                    
BCS CODE_FC28                
LSR $FF						;$04 - jump
BCS CODE_FC19                
LSR A                    
BCS CODE_FC62                
LSR $FF						;$08 - movement sound
BCS CODE_FC51

CODE_FC16:   
JMP CODE_FC90
  
CODE_FC19:
STY $F0

LDA #$22
STA $F1

LDY #$0B                 
STY $F2

LDA #$20                 
JSR CODE_FA9F
  
CODE_FC28:
DEC $F2                  
BNE CODE_FC30

LDA #$07                 
STA $F2
  
CODE_FC30:
LDX $F2                  
LDY DATA_FAF5,X
LDX #$5A                 
LDA $F1                  
CMP #$14                 
BCS CODE_FC41                
LSR A                    
ORA #$50                 
TAX
  
CODE_FC41:
JSR CODE_FA95

CODE_FC44:  
DEC $F1                  
BNE CODE_FC16                
JSR CODE_FAE0
  
CODE_FC4B:
LDA #$00                 
STA $F0                  
BEQ CODE_FC16
  
CODE_FC51:
STY $F0

LDA #$0A                 
STA $F1

LDY $06F0                
STY $4002
 
LDA #$88                 
STA $4003

CODE_FC62:
LDA $18                  
AND #$08                 
CLC                      
ADC $F1                  
ADC #$FE                 
TAX                      
LDY DATA_FAE6-1,X              
LDX #$41                 
BNE CODE_FC41

CODE_FC73:  
LDA #$0E                 
STA $06A5

LDY #$85                 
LDA #$46                 
JSR CODE_FAB3
  
CODE_FC7F:
DEC $06A5                
BEQ CODE_FC9D

LDA $06A5                
ORA #$90                 
TAY                      
DEY                      
STY $4004                
BNE CODE_FC9D
  
CODE_FC90:
LDA $F3                  
BNE CODE_FC9D
   
LDA $06A5                
BNE CODE_FC7F

LDY $FE                  
BMI CODE_FC73
  
CODE_FC9D:
LDA $FC                  
BNE CODE_FD0B

LDA $F9                  
BNE CODE_FD0B
  
LDY $FE                  
LDA $06A1                
LSR $FE                  
BCS CODE_FCBA                
LSR A                    
BCS CODE_FCBE                
LSR A                    
BCS CODE_FCF0                
LSR $FE                  
BCS CODE_FCDB                
BCC CODE_FD0B
  
CODE_FCBA:
LDA #$28                 
BNE CODE_FCDD
  
CODE_FCBE:
LDA $F5                  
BNE CODE_FCC6
 
LSR $FE                  
BCS CODE_FCDB

CODE_FCC6:
LDA $F6                  
LSR A                    
LSR A                    
LSR A                    
LSR A                    
LSR A                    
ADC $F6                  
BCC CODE_FD00

CODE_FCD1:
LDA #$00                 
STA $06A1                
STA $4008                
BEQ CODE_FD0B
  
CODE_FCDB:
LDA #$FE
  
CODE_FCDD:
STY $06A1

LDX #$0E                 
STX $F5
  
LDY #$FF                 
STY $4008
 
LDY #$08                 
STY $400B                
BNE CODE_FD00
  
CODE_FCF0:
LDA #$FE                 
LDY $F5                  
BEQ CODE_FCD1                
CPY #$07                 
BEQ CODE_FD00
 
LDA $F6                  
TAY                      
JSR CODE_FAD7

CODE_FD00:  
STA $F6                  
STA $400A

LDA $F5                  
BEQ CODE_FD0B

DEC $F5

CODE_FD0B:  
LDX $FA                  
BNE CODE_FD58

LDA $FC                  
BNE CODE_FD18
 
STA $06A3                
BEQ CODE_FD58

CODE_FD18:  
EOR $06A3                
BEQ CODE_FD35

CODE_FD1D:
LDA $FC                  
STA $06A3
JSR CODE_FA86

LDA UNUSED_FFCD,Y              
STA $0680

LDA #<DATA_FFD4					;$D4                 
STA $F5

LDA #>DATA_FFD4					;$FF                 
STA $F6                  
BNE CODE_FD3A
  
CODE_FD35:
DEC $0698                
BNE CODE_FD58
  
CODE_FD3A:
LDY $0680                
INC $0680                
LDA ($F5),Y              
BEQ CODE_FD1D                
TAX                      
ROR A                    
TXA                      
ROL A                    
ROL A                    
ROL A                    
AND #$07                 
TAY                      
LDA DATA_FB62,Y              
STA $0698                
LDA #$10                 
JSR CODE_FABA
  
CODE_FD58:
LDA $FD                  
BNE CODE_FD62

LDA $0102                
BNE CODE_FD9B                
RTS
  
CODE_FD62:
JSR CODE_FA86                
STY $FB
  
CODE_FD67:
LDA DATA_FE59,Y              
TAY                      
LDA DATA_FE59,Y              
STA $068D

LDA DATA_FE59+1,Y              
STA $F7

LDA DATA_FE59+2,Y  
STA $F8

LDA DATA_FE59+3,Y              
STA $F9

LDA DATA_FE59+4,Y              
STA $FA

LDA #$01                 
STA $0695                
STA $0696                
STA $0698                
STA $0102

LDY #$00                 
STY $F3

LDA $FB                  
BEQ CODE_FDA4
  
CODE_FD9B:
LDY $FA                  
BEQ CODE_FDD8                
DEC $0696                
BNE CODE_FDD8
  
CODE_FDA4:
INC $FA                  
LDA ($F7),Y              
BEQ CODE_FDE9                
BPL CODE_FDB8    
JSR CODE_FACA                
STA $0691

LDY $FA                  
INC $FA                  
LDA ($F7),Y

CODE_FDB8:
JSR CODE_FA9F                
BNE CODE_FDC1

LDY #$10                 
BNE CODE_FDCF
  
CODE_FDC1:
LDX #$9F                 
LDA $FB                  
BEQ CODE_FDCF

LDX #$06                 
LDA $F9                  
BNE CODE_FDCF

LDX #$86
  
CODE_FDCF:
JSR CODE_FA93

LDA $0691                
STA $0696
  
CODE_FDD8:
LDA $FB                  
BEQ CODE_FE31

DEC $0695                
BNE CODE_FE31

LDY $F3                  
INC $F3                  
LDA ($F7),Y              
BNE CODE_FE09
  
CODE_FDE9:
JSR CODE_FAE0

LDA #$00                 
STA $FA                  
STA $F3                  
STA $F9                  
STA $0102

LDY $FB                  
BEQ CODE_FE00

LDY $06A1                
BNE CODE_FE03
  
CODE_FE00:
STA $4008

CODE_FE03:
LDA #$10                 
STA $4004                
RTS

CODE_FE09:
JSR CODE_FAC4                
STA $0695                
TXA                      
AND #$3E                 
LDY #$7F                 
JSR CODE_FAB3                
BNE CODE_FE1D

LDX #$10                 
BNE CODE_FE2E
  
CODE_FE1D:
LDX #$89                 
LDA $0695                
CMP #$18                 
BCS CODE_FE2E

LDX #$86                 
CMP #$10                 
BCS CODE_FE2E

LDX #$84

CODE_FE2E:
STX $4004                

CODE_FE31:
LDY $F9                  
BEQ RETURN_FE58

DEC $0698                
BNE RETURN_FE58

INC $F9                  
LDA ($F7),Y              
JSR CODE_FAC4

STA $0698                
CLC                      
ADC #$FE                 
ASL A                    
ASL A                    
CMP #$38                 
BCC CODE_FE4F

LDA #$38
  
CODE_FE4F:
LDY $FB                  
BNE CODE_FE55

LDA #$FF

CODE_FE55:
JSR CODE_FABA
  
RETURN_FE58:
RTS       

DATA_FE59:
db $09,$0E,$13,$18,$1D,$22,$27,$2C
db $31,$00,$8F,$FE,$1B,$00,$08,$B0
db $FE,$00,$0C,$00,$CF,$FE,$00,$1A
db $08,$05,$FF,$00,$0B,$00,$AD,$FF
db $00,$03,$00,$BE,$FF,$00,$00,$00
db $C4,$FF,$00,$00,$0F,$20,$FF,$21
db $3E,$00,$A1,$FF,$08,$00,$86,$46
db $82,$4A,$83,$26,$46,$80,$34,$32
db $34,$32,$34,$32,$34,$32,$34,$32
db $34,$32,$34,$32,$34,$32,$84,$34
db $00,$A9,$AC,$EE,$E8,$33,$35,$16
db $16,$57,$1E,$20,$64,$9E,$1E,$20
db $64,$9E,$00,$80,$30,$30,$85,$30
db $80,$1A,$1C,$81,$1E,$82,$1A,$80
db $1A,$1C,$81,$1E,$82,$1A,$5E,$5E
db $5C,$5C,$5A,$5A,$58,$58,$57,$16
db $18,$9A,$96,$59,$18,$1A,$9C,$98
db $5F,$5E,$60,$5E,$5C,$5A,$1F,$00
db $81,$1A,$1A,$18,$18,$16,$16,$38
db $38,$82,$26,$42,$26,$42,$28,$46
db $28,$46,$30,$28,$30,$28,$81,$3A
db $85,$3C,$84,$3A,$5E,$02,$20,$42
db $4A,$42,$60,$5E,$60,$1D,$00,$82
db $26,$42,$26,$42,$81,$40,$80,$42
db $44,$48,$26,$28,$2C,$83,$2E,$56
db $56,$E0,$42,$5A,$5E,$5C,$99,$58
db $58,$E2,$42,$5E,$60,$5E,$9B,$5A
db $5A,$CA,$42,$60,$62,$4A,$8D,$5C
db $5E,$E0,$42,$5A,$5C,$5E,$1D,$00
db $82,$6F,$6E,$EE,$71,$70,$F0,$77
db $76,$F6,$57,$56,$D6,$A0,$9A,$96
db $B4,$A2,$9C,$98,$B6,$5C,$9C,$96
db $57,$5C,$96,$74,$2F,$85,$02,$81
db $2E,$34,$2E,$83,$34,$81,$48,$28
db $30,$28,$30,$28,$85,$30,$81,$30
db $36,$30,$83,$36,$81,$26,$2C,$30
db $2C,$30,$2C,$16,$16,$1A,$16,$34
db $16,$1A,$16,$34,$16,$1C,$18,$36
db $18,$1C,$18,$36,$18,$16,$2E,$80
db $16,$36,$34,$36,$83,$16,$81,$02
db $2E,$80,$16,$36,$34,$30,$86,$2E
db $81,$1A,$82,$1E,$30,$83,$16,$00
db $42,$96,$B0,$E6,$03,$83,$00,$87
db $42,$3E,$42,$3E,$42,$3E,$42,$3E
db $42,$3E,$42,$82,$3E,$0A,$0C,$0E
db $54,$90,$00,$04,$12,$04,$12,$04
db $12,$04,$92,$00      

UNUSED_FFCD:
db $00						;unused
db $00						;used
db $00,$00					;unused

;used
db $09,$0E,$12

DATA_FFD4:
db $16,$02,$02,$1A,$02,$1E,$20,$1E
db $00,$5A,$42,$56,$56,$00,$09,$07
db $05,$00,$CA,$8A,$8A,$CA,$CA,$CE
db $CA,$CE,$CA,$CE,$8E,$8E,$CE,$CE
db $D2,$CE,$D2,$CE,$00

;only a single byte of freespace is here. YAY!

org $FFFA
dw NMI_C85F
dw RESET_C79E
dw $FFF0					;no IRQ
