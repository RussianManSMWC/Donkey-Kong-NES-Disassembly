;Donkey Kong (NES) Disassembly
;This is a disassembly of Donkey Kong for NES, specifically 3 different versions.
;-Japenese (Revision 0)
;-US (Revision 1)
;-Gamecube (from Animal Crossing)
;Disassembled By RussianManSMWC. Does not include Graphic data - you have to rip it yourself.
;To be compiled with ASM6
;Personal note - the code is an absolute spaghetti mess. Mmm... spaghetti.

incsrc Defines.asm

;Set version with this define. Use one of the following arguments
;JP
;US
;Gamecube
;or you can use number 0-2 for respective version.

Version = US

incsrc JPRemap.asm				;macros for some changes done between JP vs. US/Rev 0 vs. Rev 1

incsrc iNES_Header.asm				;should be self-explanatory

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
  ADC Cursor_OAM_Y				;
  RTS

  FILLVALUE $00					;the rest is $00
;after which a few more unused bytes
endif

org $C000
FILLVALUE $FF					;original game's free space is marked with FFs
;big table block
;TO DO: Figure out if some of these unused tables are actually used (at least in theory)

;Tile VRAM location for scores (the last byte for each entry is some kind of properties that are unused. only bits 0 and 4)
ScoreVRAMUpdData_C000:
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
;DATA_C014:
DemoInputData_C014:
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
;DATA_C028:
DemoTimingData_C028:
db $DB,$60,$E2,$55
db $14,$20,$01,$F9
db $A0,$E0,$30,$10
db $10,$01,$50,$01
db $30,$D0,$FF,$FF				;after this it'll start taking garbage values, which should be impossible, unless you disable barrels

DATA_C03C:
dw DATA_C63E					;\pointers to kong's frames. this one is "toss to the side"
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

;Also something (Phase 1 only?)
dw DATA_C08C
dw DATA_C0CF 
dw DATA_C161

;doesn't look like a pointer to data in ROM, does it? maybe it is something in RAM? either way it is unused.
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
db $E1,$C1,$9E,$C1
dw DATA_C1E7					;$E7,$C1
db $0C,$C6
db $70,$C6,$89,$C6,$25,$C6

dw DATA_C6A2

db $CC,$00					;use RAM $CC (buffer item erasing (umbrella, handbag)

db $8E,$C1

dw DATA_C196
dw DATA_C6A6					;Pointer to Sprite Palette 2

;data related with checking sloped surfaces (phase 1) of unknown format
DATA_C08C:
db $00,$D8,$00,$00,$01,$00
db $80,$D7,$04,$18,$06,$FE
db $C8,$BC,$04,$E8,$09,$FE
db $20,$9E,$04,$18,$09,$FE
db $C8,$80,$04,$E8,$09,$FE
db $20,$62,$04,$18,$09,$FE
db $C8,$44,$04,$E8,$06,$FE
db $80,$28,$04,$00,$01,$FE

;y-position of each platform (from highest point + 16 pixels), used to calculate platform index
;FF sets index to 7 (which is the lowest platform)
;Phase 1
DATA_C0BC:
db $BC,$9E,$80,$62,$44,$28,$FF

DATA_C0C3:
db $00,$00,$80,$00,$00,$00,$18,$00

UNUSED_C0CB:
db $00,$00,$10,$00

;IDK
DATA_C0CF:
db $E0,$BC,$00,$10,$9E,$00
db $E0,$80,$00,$10,$62,$00
db $E0,$44,$00,$FE,$00,$00,$10,$03

DATA_C0E3:
db $C8,$BC,$08,$C8
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

;Jumpman's animation frames when climbing on top of the platform
;$54 - draw Jumpman_GFXFrame_Climbing with horz flip
DATA_C147:
db Jumpman_GFXFrame_Climbing,Jumpman_GFXFrame_Climbing
db $54,$54
db Jumpman_GFXFrame_ClimbPlat_Frame1,Jumpman_GFXFrame_ClimbPlat_Frame1
db Jumpman_GFXFrame_ClimbPlat_Frame2,Jumpman_GFXFrame_ClimbPlat_Frame2
db Jumpman_GFXFrame_ClimbPlat_Frame1,Jumpman_GFXFrame_ClimbPlat_Frame1
db Jumpman_GFXFrame_Climbing,Jumpman_GFXFrame_Climbing
db Jumpman_GFXFrame_ClimbPlat_IsOn,Jumpman_GFXFrame_ClimbPlat_IsOn

;more animation frames?
UNUSED_C155:
db $68,$68,$68,$68

;this data is used to animate jumpman when climbing the ladder.
;$54 it the same as in DATA_C147 (Jumpman_GFXFrame_Climbing but flip horizontally)
DATA_C159:
db Jumpman_GFXFrame_Climbing,Jumpman_GFXFrame_Climbing,Jumpman_GFXFrame_Climbing
db $54,$54,$54

;unknown, probably just some placeholder (for the table above?)
UNUSED_C15F:
db $00,$00

DATA_C161:
db $60,$B7,$00,$50,$7B,$00,$B8,$5C
db $00,$68,$40,$00,$FE,$00,$00,$08
db $18

DATA_C172:
db $CA,$A7,$8E,$6B,$51

;related with barrels and ladders?
DATA_C177:
db $5C,$2C,$4C,$2C,$64

DATA_C17C:
db $C6,$AA,$8C,$6D,$4D

DATA_C181:
db $C4,$6C,$7C,$54,$C4

DATA_C186:
db $08,$11,$0A,$11

UNUSED_C18A:
db $08,$10,$0A,$11

DATA_C18E:
db $08,$0F,$0A,$11,$05,$01,$0C,$09

DATA_C196:
db $05,$05,$0A,$0A

UNUSED_C19A:
db $08,$10,$08,$10

DATA_C19E:
db $04,$04,$0C,$0D

;jumpman's animation frames for when holding a hammer
DATA_C1A2:
db Jumpman_GFXFrame_Walk2_HammerUp
db Jumpman_GFXFrame_Stand_HammerUp
db Jumpman_GFXFrame_Walk1_HammerUp
db Jumpman_GFXFrame_Walk2_HammerDown
db Jumpman_GFXFrame_Stand_HammerDown
db Jumpman_GFXFrame_Walk1_HammerDown

DATA_C1A8:
db $03,$05

UNUSED_C1AA:
db $02,$03,$00,$00

DATA_C1AE:
db $03,$04,$00,$00,$08,$08

;boundary positions
DATA_C1B4:
db $10,$E0
db $10,$E0					;unused becuase there's no Phase 2
db $0C,$E0
db $08,$E8

;table representing each bit value
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
db $52,$6C,$8E,$A8,$CA,$FE

DATA_C1E7:
db $00,$06,$08,$08				;hmm...

DATA_C1EB:
db $19,$30,$34,$30,$34,$30,$34,$38
db $3C,$3C,$3C

;contains maximum amount of flame enemies that can be processed per-phase
;MaxNumberOfFlameEnemies_C1F6:
DATA_C1F6:
db $02,$04,$02,$04			;2 in 25M and 75M, 4 in 50M (unused) and 100M

DATA_C1FA:
db $07          

UNUSED_C1FB:
db $05					;used? maybe I messed up somewhere...

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

DATA_C24C:
db $B0,$78,$60,$40,$28,$FF

DATA_C252:
db $00,$00
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

DATA_C300:
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

;X and Y positions for flame enemy spawns (100M)
;Init_100M_FlameEnemy_XYPos_C3CE:
DATA_C3CE:
db $08,$C7
db $10,$A7
db $18,$7F
db $20,$57
db $E8,$C7
db $E0,$A7
db $D8,$7F
db $D0,$57

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

;table used for barrel throw timer setting (based on difficulty)
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

DATA_C45C:
db $88,$88,$24,$55,$55

DATA_C461:
db $88,$88,$49,$55,$55

;number of frames between each flame enemy spawn for 100M, based on difficulty
DATA_C466:
db $40,$20,$10,$08,$01

;pointers?
UNUSED_C46B:
db $8C,$C0,$0C,$C2

DATA_C46F:
db $0C,$C2,$F0,$C2      

UNUSED_C473:
db $C3,$C0,$0C,$C2

DATA_C477:
db $52,$C2,$06,$C3

;ladder-related (pointers)
DATA_C47B:
dw DATA_C0E3

UNUSED_C47D:
db $0C,$C2				;phase 2 most likely

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

;pointers to platform heights for each phase
DATA_C493:
dw DATA_C0BC

UNUSED_C495:
dw DATA_C20C					;no phase 2

DATA_C497:
dw DATA_C24C
dw DATA_C300

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

;this data is used to initialize various entities, storing directly to their OAM slots
;Format: XYTRcOD
;X - initial X-position
;Y - initial Y-position
;T - Sprite tile (the first one to draw, after each +1 is addded for other tiles)
;Rc - Rows and columns - how many rows and columns to draw, with rows taking high nibble and columns low nibble (e.g. $12 is 1 row and 2 columns)
;O - OAM slot
;D - Drawing mode, see SpriteDrawingEngine_F096 for more (input accamulator)
;for example, let's take a 6 byte row below:
;remove 6 sprite tiles starting from OAM offset E8, which is, by default, Pauline's head (so that means remove pauline, then reinitialize), X and Y-positions don't matter
;$FE acts as a terminator for the initializer

;Phase1_InitEntities_C4B3:
DATA_C4B3:
db $00,$00,$01,$06,PaulineHead_OAM_Slot*4,$04

;draw Pauline's head tiles
db $50,$18,PaulineHead_Tile,$12,PaulineHead_OAM_Slot*4,$00

;then some BODY of Pauline's
db $50,$20,PaulineBody_GFXFrame_Frame2,$22,PaulineBody_OAM_Slot*4,$00

;remove barrels
db $00,$00,$03,$2C,Barrel_OAM_Slot*4,$04

;hammer 1
db $20,$7F,Hammer_GFXFrame_HammerUp,$21,Hammer_OAM_Slot*4,$00

;hammer 2
db $20,$46,Hammer_GFXFrame_HammerUp,$21,Hammer_OAM_Slot*4+8,$00

;remove score
db $00,$00,$01,$04,Score_OAM_Slot*4,$04

;remove jumpman
db $00,$00,$00,$04,Jumpman_OAM_Slot*4,$04

;init jumpman's position
db $30,$C7,$04,$22,Jumpman_OAM_Slot*4,$00

;remove flame enemies
db $00,$00,$02,$08,FlameEnemy_OAM_Slot*4,$04

;remove oil barrel flame
db $00,$00,$02,$02,Flame_OAM_Slot*4,$04

db $FE						;no more init

;Phase3_InitEntities_C4F6:
DATA_C4F6:
;remove pauline
db $00,$00,$01,$06,PaulineHead_OAM_Slot*4,$04

;place pauline
db $50,$18,PaulineHead_Tile,$12,PaulineHead_OAM_Slot*4,$00
db $50,$20,PaulineBody_GFXFrame_Frame2,$22,PaulineBody_OAM_Slot*4,$00

;remove platforms
db $00,$00,$03,$0C,PlatformSprite_OAM_Slot*4,$04

;then place in some
db $30,$78,PlatformSprite_Tile,$12,PlatformSprite_OAM_Slot*4,$00	;each platform uses 2 OAM tiles btw
db $30,$A8,PlatformSprite_Tile,$12,(PlatformSprite_OAM_Slot+2)*4,$00
db $30,$49,PlatformSprite_Tile,$12,(PlatformSprite_OAM_Slot+4)*4,$00
db $70,$70,PlatformSprite_Tile,$12,(PlatformSprite_OAM_Slot+6)*4,$00
db $70,$A0,PlatformSprite_Tile,$12,(PlatformSprite_OAM_Slot+8)*4,$00
db $70,$D7,PlatformSprite_Tile,$12,(PlatformSprite_OAM_Slot+10)*4,$00

;remove something... (springboards?)
db $00,$00,$23,$02,$40,$04			;it skips 48???
db $00,$00,$23,$02,$58,$04

;init jumpman
db $00,$00,$00,$04,Jumpman_OAM_Slot*4,$04
db $10,$B7,Jumpman_GFXFrame_Stand,$22,Jumpman_OAM_Slot*4,$00

;init flame enemies
db $00,$00,$02,$08,FlameEnemy_OAM_Slot*4,$04
db $4C,$9F,FlameEnemy_GFXFrame_Frame1,$22,FlameEnemy_OAM_Slot*4,$00
db $CC,$67,FlameEnemy_GFXFrame_Frame1,$22,(FlameEnemy_OAM_Slot+4)*4,$00

;remove something else...
db $00,$00,$03,$0C,$60,$04
db $00,$00,$01,$16,$90,$04

db $FE

;Phase4_InitEntities_C569:
DATA_C569:

;pauline as usual
db $00,$00,$01,$06,PaulineHead_OAM_Slot*4,$04
db $50,$18,PaulineHead_Tile,$12,PaulineHead_OAM_Slot*4,$00
db $50,$20,PaulineBody_GFXFrame_Frame2,$22,PaulineBody_OAM_Slot*4,$00

db $00,$00,$03,$04,Hammer_OAM_Slot*4,$04
db $14,$6E,Hammer_GFXFrame_HammerUp,$21,Hammer_OAM_Slot*4,$00
db $7C,$46,Hammer_GFXFrame_HammerUp,$21,(Hammer_OAM_Slot+2)*4,$00

db $00,$00,$01,$20,$50,$04

db $00,$00,$00,$04,Jumpman_OAM_Slot*4,$04
db $38,$C7,Jumpman_GFXFrame_Stand,$22,Jumpman_OAM_Slot*4,$00

db $00,$00,$02,$10,$10,$04

db $FE

;pointer for various entity initializations (tables above) for each phase
DATA_C5A6:
dw DATA_C4B3
dw DATA_C4F6				;y'know the drill by now.
dw DATA_C4F6
dw DATA_C569

;unknown, maybe related with the table below?
UNUSED_C5AE:
db $7F,$7F,$7F,$00

DATA_C5B2:
db $5F,$3F,$00,$2F,$7F,$7F

UNUSED_C5B8:
db $00

DATA_C5B9:
db $A9,$A9,$81,$81,$59,$59,$31,$31

UNUSED_C5C1:
db $00,$30,$4C,$D5,$00

DATA_C5C6:
db $10,$E0,$00,$24,$50,$C0

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

;Score values added to score counter (hundreds)
DATA_C600:
db $01						;100
db $03						;300 (unused)
db $05						;500
db $08						;800

;score sprite tile
DATA_C604:
db Score_OneTile				;1 for 100
db Score_ThreeTile				;3 for 300 (unused)
db Score_FiveTile				;5 for 500
db Score_EightTile				;8 for 800

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

;...
db $46
db $C2
db $C3,$24,$9E,$C4,$C5,$C6,$C7,$A3
db $B9,$A5,$A6,$A7,$BB,$6B,$C8,$C9
db $CA,$CB,$CC,$24,$CD,$CE,$CF,$46
db $24,$B2,$B3,$B4,$B5,$B6,$B7,$B8
db $A3,$B9,$69,$BA,$A7,$BB,$A9,$AA
db $BC,$BD,$BE,$BF,$C0,$C1,$24,$B1

;palette for fireballs when in "panic mode" (100M exclusive)
;affects sprite palette 2
DATA_C6A2:
db $13,$2C,$16,$13

;sprite color palette 2 for flames.
;1 row with 3 "tiles" to upload (which is, 3 colors). 
DATA_C6A6:
db $13,$16,$30,$37

;data for "Player X" screen.
DATA_C6AA:
db $23,$DB					;set up attributes
db $02|VRAMWriteCommand_Repeat
db $A0

db $21,$CA
db $0C|VRAMWriteCommand_Repeat
db $24

;"  PLAYER I  " (I is replaced with II (tile 67) if second player, obviously
db $21,$EA
db $0C
db $24,$24,$19,$15,$0A,$22,$0E,$1B,$24,$66,$24,$24

db VRAMWriteCommand_Stop

;data for "GAME OVER" message
;Attributes first
DATA_C6C2:
db $23,$E2
db $04
db $08,$0A,$0A,$02

db $22,$0A
db $0C|VRAMWriteCommand_Repeat
db $24

;" GAME  OVER "
db $22,$2A
db $0C
db $24,$10,$0A,$16,$0E,$24,$24,$18,$1F,$0E,$1B,$24

db $22,$4A
db $0C|VRAMWriteCommand_Repeat
db $24

db VRAMWriteCommand_Stop

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

JSR SetInitRegsAndClearScreen_C7E7		;clear screen and initialize some hardware registers

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
;LOOP_C7E1:

GameLoop_CFE1:
JSR RNG_F4ED					;run through RNG loop
JMP GameLoop_CFE1				;keep looping

;set initial register settings and clear screen
;CODE_C7E7:

SetInitRegsAndClearScreen_C7E7:
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

JSR CODE_CBAE					;remove sprite tiles
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

;this one uses buffer. used for palettes and kong updates and probably other stuff.
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
TAX						;
LDA DATA_C03C,X					;
STA $08						;

LDA DATA_C03C+1,X				;
STA $09						;
RTS						;

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

LDA #<BufferAddr				;\set indirect addressing RAM ($0331)
STA $00						;|
LDA #>BufferAddr				;|(buffer for various tile updates, like Kong animation
STA $01						;/
JSR CODE_F228					;draw tiles

LDA #$00					;
STA BufferOffset				;reset buffer index
STA BufferAddr					;first buffer byte

JSR ReadControllers_F50E			;read controller

LDA RenderMirror				;
EOR #$18					;enable background and sprite rendering
STA RenderBits					;

JSR SoundEngine_FA48				;play sounds and music (sound engine)

LDA TitleScreen_Flag				;if we're on title screen
BNE CODE_C8C1					;do title screen-y things

LDA GameControlFlag				;check if game isn't controllable yet
BEQ CODE_C8D4					;
 
LDA Kong_DefeatedFlag				;run kong defeat scene
BNE CODE_C8A5					;

JSR CODE_CE7C					;run normal gameplay
JMP CODE_C8D7					;

CODE_C8A5:
LDA $044F					;another check (animate kong for a bit before displaying sprite?)
CMP #$08					;
BNE CODE_C8D4					;

JSR CODE_CCF4					;falldown

LDA $43						;check if the scene has ended
BNE CODE_C8D7

LDA #$00					;
STA $044F					;some flag
STA GameControlFlag				;resume normal play

LDA #$79
STA $43
JMP CODE_C8D7
  
CODE_C8C1:
LDA Jumpman_Lives				;if Jumpman has some lives left, continue playing
BNE CODE_C8CB					;
JSR CODE_CA30					;game over (or demo end)
JMP CODE_C8D7					;end NMI

CODE_C8CB:  
JSR CODE_C8F3					;
JSR CODE_F4AC					;handle timers
JMP CODE_C8D7
  
CODE_C8D4:
JSR CODE_CAC9

CODE_C8D7:  
LDA Score_UpdateFlag				;check if we need to update the score
CMP #$01					;
BNE CODE_C8E8					;no, end NMI

LDA Players					;\update score
STA $00						;|
JSR CODE_F23C					;/

DEC Score_UpdateFlag				;- 1 = 0 (don't trigger above check)
  
CODE_C8E8:
LDA ControlMirror				;re-enable NMI
EOR #$80					;
STA ControlBits					;
STA ControlMirror				;
PLA						;restore A
RTI						;return from the interrupt

CODE_C8F3:
LDA Sound_FanfarePlayFlag			;see if the sound should actually play
BNE CODE_C8FE					;
STA APU_SoundChannels				;
STA Sound_ChannelsMirrorUnused			;

CODE_C8FE:
LDA TitleScreen_DemoCount			;if we need to play more demos before playing music again
BNE CODE_C914					;

LDA #Sound_Fanfare_TitleScreenTheme		;if we didn't play title theme, do it
STA Sound_Fanfare				;

LDA #$04					;i assume this is a number of resets after demo mode required for song to start playing again
STA TitleScreen_DemoCount			;

LDA #$0F					;enable all sound channels
STA APU_SoundChannels				;
STA Sound_ChannelsMirrorUnused			;backup (or "backup")

CODE_C914:
LDA TitleScreen_MainCodeFlag			;check if we've initialized title screen
BNE CODE_C940					;check for controller input when on title screen

JSR CODE_D19A					;disable render

LDA #$08					;
JSR CODE_C807					;draw title screen

;set cursor sprite for title screen
LDA Cursor_YPosition				;Y-position
STA Cursor_OAM_Y				;

LDA #Cursor_Tile				;sprite tile
STA Cursor_OAM_Tile				;

LDA #Cursor_Prop				;property
STA Cursor_OAM_Prop				;
STA Demo_Active					;demo isn't active

LDA #Cursor_XPos				;
STA Cursor_OAM_X				;X-pos
STA TitleScreen_MainCodeFlag			;any non-zero value is fine

LDA #$20                 			;set pre-demo timer
STA Timer_Demo					;
RTS						;

CODE_C940:
LDA ControllerInput_Player1Previous		;check for select (change option or cancel demo)
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
STA TitleScreen_SelectHeldFlag			;if no button is pressed/held, reset select held flag

LDA Timer_Demo					;if timer for demo is still active
BNE RETURN_C95C					;don't activate demo mode

LDA #$01					;activate demo mode
STA Demo_Active					;
JMP CODE_C9B1					;

RETURN_C95C:
RTS						;
  
CODE_C95D:
LDA #$40					;set timer before demo if pressed/held a button that switches option
STA Timer_Demo					;

LDA TitleScreen_SelectHeldFlag			;if select is being held, don't switch anymore
BNE CODE_C985					;

LDA #$40					;
STA $35						;timer that's actually pointless (see below)

If Version = Gamecube
  JSR Gamecube_CODE_BFF0			;make cursor loop from first option to last (since we can use D-pad now)
else
  LDA Cursor_OAM_Y				;
endif
CLC						;
ADC #$10					;
CMP #$BF					;check if changed option after last (or first on gamecube) (wrap around)
If Version = Gamecube
  BCC CODE_C976					;
  SBC #$40					;either first or last
else
  BNE CODE_C976					;
  LDA #$7F					;first option location
endif

CODE_C976:
STA Cursor_OAM_Y				;
STA Cursor_YPosition				;change cursor's Y-pos

INC TitleScreen_SelectHeldFlag			;hold select flag used if select is held so it doesn't switch options every frame but every button PRESS

LDA #$0A					;Ram address that does... absolutely nothing.
STA Unused_0513					;in DK JR (for the NES) similar address is set as a timer for switching options if select is held long enough (Japan only)
RTS						;

CODE_C985:
LDA $35						;wait a minute... what? this check makes no sense!
BNE RETURN_C989					;however, DK JR gives us a clue on what this supposed to be. this timer was used for option switching when select was held (so it'd continiously switch when this timer was zero). It'd use timer for option switching that is unused for this game (it's Unused_0513). 

RETURN_C989:
RTS						;

CODE_C98A:
STA Pause_HeldPressed				;

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
STA GameMode					;
CMP #$02					;
BMI CODE_C9AD					;check if it was one of first two options (1 Player Game A or B)

LDA #Players_2Players				;set two players if selected 2 player game A or B (and pressed start for said option)
STA Players					;
JMP CODE_C9B1					;

CODE_C9AD:
LDA #Players_1Player				;one player
STA Players					;

CODE_C9B1:
LDA GameMode					;load bit for game B if set (option 1 or 3)
AND #$01					;
ASL A						;
TAX						;
LDA Score_Top,X					;show top score depending on whether it was an A or B game.
STA ScoreDisplay_Top				;

LDA Score_Top+1,X				;
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
STA TitleScreen_MainCodeFlag			;initialize title screen next time we get there
STA $050B
STA TitleScreen_SelectHeldFlag			;not holding select, k?

LDA #$01                 
STA PhaseNo					;start from 25M
STA PhaseNo_PerPlayer				;initialize  both player's phase number
STA PhaseNo_PerPlayer+1				;

LDA #$00
STA LoopCount					;initialize loop counter
STA LoopCount_PerPlayer				;
STA LoopCount_PerPlayer+1			;

LDA #$00					;but we had 00 loaded before... and before before.
STA Players_CurrentPlayer			;
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
BNE CODE_CA26					;

LDA #$97					;transition is extended a bit because of sound effect
STA Timer_Transition				;

LDA #Sound_Fanfare_GameStart			;
STA Sound_Fanfare				;
  
LDA #$0F					;enable all sound channels
STA APU_SoundChannels				;
STA Sound_ChannelsMirrorUnused			;and back up
RTS

CODE_CA26:
DEC TitleScreen_DemoCount			;-1 demo for title screen music

LDA #$75                 
STA Timer_Transition
JMP CODE_CBAE					;no sprite tiles

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
DEC Timer_Transition				;
JMP CODE_CBAE
  
CODE_CA5F:
DEC Timer_Transition
JMP CODE_CBCA

CODE_CA64:  
DEC Timer_Transition				;

LDA GameMode					;preserve top score
AND #$01					;
ASL A						;
TAX						;
LDA ScoreDisplay_Top
STA Score_Top,X					;store top score for game A or B

LDA ScoreDisplay_Top+1				;
STA Score_Top+1,X				;
JMP CODE_CBF5					;reset kong frame (phase 1 only?)
  
CODE_CA79:
LDX $52
LDA #$01                 
STA $0406,X
STA $4E

LDA Players					;check players
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

;load current player's variables into zero page address (for less cycles and space and stuff)
;Input X - current player
CODE_CAA9:
LDY #$00					;

LOOP_CAAB:
LDA $0400,X					;
STA $0053,Y					;
INX						;
INX						;X+2 so to hop over other player's address
INY						;
CPY #$03					;
BNE LOOP_CAAB					;
RTS						;

;store current player's variables for next time they're playing
;pretty much CODE_CAA9 but in reverse
;Input X - current player
CODE_CAB9:
LDY #$00					;

LOOP_CABB: 
LDA $0053,Y					;
STA $0400,X					;
INX						;
INX						;
INY						;
CPY #$03					;
BNE LOOP_CABB					;
RTS						;

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
LDA #$01					;
STA GameControlFlag				;can play game...
JSR CODE_CC47					;
RTS						;

CODE_CB02:
LDX Players_CurrentPlayer			;load current pplayer in play
LDA PhaseNo					;check current phase
CMP $0400,X					;versus where player's supposed to go (?)
BEQ CODE_CB15
CMP #$01                 
BEQ CODE_CB15

JSR CODE_CC24 					;must be score related              
JSR CODE_CC04
  
CODE_CB15:
DEC $43						;decrease transiition timer
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
LDA Demo_Active					;demo?
BNE JP_CODE_CB3D				;no sound and stuff

LDA #Sound_Fanfare_PhaseStart			;start da phase
STA Sound_Fanfare				;

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

DEC $43						;
LDA Demo_Active					;demo?
BNE RETURN_CB46					;

LDA #Sound_Fanfare_PhaseStart			;start da phase but it's a revision 1
STA Sound_Fanfare				;

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
LDA #$01					;update the score
STA Score_UpdateFlag				;
JSR CODE_D032    
JSR CODE_CBBD

LDA #<VRAMLoc_LoopCount				;
STA $00						;
LDY LoopCount					;render loop count
INY						;w +1 e.g. instead of 0, show 1
JSR VRAMUpdateSingle_F4C2			;

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

;used to clear OAM via sprite drawing engine
CODE_CBAE:
LDA #<OAM_Y					;
STA $04						;

LDA #$FF					;remove ALL tiles!
JMP CODE_F092					;

;DisableRenderAndClearScreen_CBB7:
JP_CODE_CBB3:
CODE_CBB7:
JSR CODE_D19A					;no rendering
JMP CODE_F1B4					;clear screen

;UpdateLiveCounter_CBBD:
CODE_CBBD:
LDA #<VRAMLoc_LivesCount			;set VRAM location to where lives count is
STA $00

LDA #>VRAMLoc_LivesCount			;
STA $01						;

LDY Jumpman_Lives				;set lives number as tile value
JMP VRAMUpdateSingle_F4C2			;

;show "PLAYER X" screen where X is the player's number (player 1 or Player 2)
JP_CODE_CBC6:
CODE_CBCA:             
LDA Demo_Active					;if demo mode is active, don't show game over
BNE RETURN_CBF4

LDA Players					;if the game is in 2 player mode
CMP #Players_2Players				;
BNE RETURN_CBF4					;if so, don't show normal game over message (should show which player has game over)

LDX Players_CurrentPlayer			;not sure what's the point of this, but...
LDA PhaseNo  
CMP $0400,X              
BNE RETURN_CBF4

LDY #$00

LOOP_CBDF:
LDA DATA_C6AA,Y			;set 
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
LDA DATA_C6C2,Y					;
STA $0331,Y					;store things to buffer
BEQ RETURN_CC03                
INY                      
JMP LOOP_CBF7

RETURN_CC03:
RTS                      

;give extra life based ob score
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
CMP #$02					;check for 20000 score
BCC RETURN_CC23					;if less, return
STA $0408,Y					;set flag for receiving extra life (only once per game and per player)

INC Jumpman_Lives				;increase lives count
JSR CODE_CBBD					;draw lives, i think
  
RETURN_CC23:
RTS

;add bonus score to the player's when phase complete (or is TOP score?)
CODE_CC24:
LDA ScoreDisplay_Bonus				;add bonus score to player's score
STA $00						;store hundreds into scratch ram

LDA Players_CurrentPlayer			;current player index
ORA #$08					;and bit 3 for w/e reason
STA $01						;also into scrath ram    
JSR CODE_F342					;
JMP CODE_D032 					;

CODE_CC34:
LDA #$01					;unecessary (CODE_D032 already enables score update flag)
STA Score_UpdateFlag				;
 
JSR CODE_D032					;prepare for score drawing i think
   
LDA #$00					;
STA Demo_InitFlag				;init demo (for when we're back at the title screen)

JSR CODE_CCC1					;
JMP CODE_D7F2					;load fire colors

;phase late initialization (after phase start jingle plays out and gameplay actually begins)

CODE_CC47:
LDA #$00
TAX

LOOP_CC4A:  
STA $59,X					;initialize RAM from 59-E2
STA $040D,X					;and $040D-$0496
INX						;
CPX #$89					;
BNE LOOP_CC4A					;

LDA #$01					;
STA Platform_HeightIndex			;initial platform jumpman's standing on is the first
STA Jumpman_State				;and state
STA Jumpman_JumpSpeed				;only one pixel per frame
STA Hammer_CanGrabFlag				;can grab da hammer
STA Hammer_CanGrabFlag+1			;
STA Hammer_JumpmanFrame				;
STA Kong_AnimationFlag				;always animate

LDA #Jumpman_GFXFrame_Stand			;show standing frame upon phase load
STA Jumpman_GFXFrame				;

LDA #$58
STA $043D

LDA #$20
STA $A2

LDA #$80
STA RNG_Value					;set first RNG byte as 80

LDA #Time_ForTiming				;decrease other timers every 10 frames
STA Timer_Timing
  
LDX Players_CurrentPlayer			;set some variables based on which player's currently playing?
JSR CODE_CAB9					;

LDA #Time_PaulineAnim				;
STA Timer_PaulineAnimation			;

LDA #Time_ForDemo				;
STA Timer_Demo					;

LDA PhaseNo					;check phase
CMP #Phase_25M					;25M?
BEQ CODE_CC99					;initialize some variables for it
CMP #Phase_75M					;75M?
BEQ CODE_CCA6					;initialize things for it instead

LDA #Sound_Music_100M				;otherwise it's just 100M music.
STA Sound_Music					;
RTS						;

CODE_CC99:
LDA #$38					;initial barrel throw timer
STA Timer_KongSpawn				;

LDA #$40					;
STA Timer_Transition				;

LDA #Sound_Music_25M				;obviously play 25M music at 25M
STA Sound_Music					;
RTS						;

CODE_CCA6:
LDA #$20				;initial springboard spawn timer
STA Timer_KongSpawn			;
    
LDA #$50				;something about lifts
STA $043F                
STA $0441                
STA $0443
 
LDA #$03                 
STA $0440                
STA $0442                
STA $0444                
RTS    

;entity initialization?
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

LDA ($09),Y					;
JSR SpriteDrawingEngine_F096			;

;Y and X get restored, so this is pointless?
LDY $86						;
INY						;
LDX #$00					;
JMP LOOP_CCD6					;
  
RETURN_CCF3:
RTS

CODE_CCF4:
LDA $0450
BNE CODE_CD07

;initialize kong falling scene
LDA #$01					;flag
STA $0450					;

LDA #$0A					;timer
STA $34						;

LDA #Sound_Fanfare_KongFalling			;i can't believe the kong is dead :pensive:
STA Sound_Fanfare				;
RTS						;

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

LDA #$12					;
JSR CODE_C815
      
LDA #$01                 
JMP CODE_CE0E					;another gem.

;draw kong as BG when they land, also used for animation
CODE_CE0E:
PHP                      
LDA #$8D                 
STA $00

LDA #$22                 
STA $01                  
PLP                      
BNE CODE_CE1F

LDA #$16					;
JMP CODE_C815					;draw defeated kong frame 1

CODE_CE1F:   
LDA #$14					;
JMP CODE_C815					;frame 2

CODE_CE24:  
CMP #$85
BEQ CODE_CE2F

LDA $43                  
AND #$01                 
JMP CODE_CE0E

;when the kong's defeated, initialize some things (place pauline and jumpman on the platform, heart, sound and what have you)
CODE_CE2F:
LDA #Sound_Fanfare_KongDefeated
STA Sound_Fanfare

LDY #$04					;draw platform with pauline and jumpman on
LDA #$18					;
JSR CODE_C823					;

;draw love
LDA #Ending_Heart_XPos				;
STA $00						;

LDA #Ending_Heart_YPos				;
STA $01

LDA #Heart_OAM_Tile				;tile
STA $02						;

LDA #$22					;standart 16x16
STA $03						;

LDA #Heart_OAM_Slot*4				;OAM slot
JSR CODE_F080					;draw!
 
DEC Timer_Transition
   
LDA #Ending_Jumpman_XPos			;x-pos
STA $00						;
    
LDA #Ending_Jumpman_YPos			;y-pos
STA $01						;
   
LDA #Jumpman_GFXFrame_Stand			;init draw jumpman
JSR SpriteDrawingPREP_StoreTile_EAD4		;

LDA #<Jumpman_OAM_Y				;
JSR CODE_F086					;draw jumpman

;Pauline sprite tile Y positions (same x-pos, just slightly lower)
LDA #$28					;head
STA PaulineHead_OAM_Y				;
STA PaulineHead_OAM_Y+4				;

LDA #$30					;body
STA PaulineBody_OAM_Y				;
STA PaulineBody_OAM_Y+8				;

LDA #$38					;body part 2
STA PaulineBody_OAM_Y+4				;
STA PaulineBody_OAM_Y+12			;
RTS						;

;check for a bunch of flags, mostly player-related
CODE_CE7C:
LDA Demo_Active					;if it's demo time, keep going
BEQ CODE_CE94					;if not, run normal gameplay i think

LDA Sound_FanfarePlayFlag			;also related with sound channels because why not
BNE CODE_CE8B					;
STA APU_SoundChannels				;disable sound channels. sure.
STA Sound_ChannelsMirrorUnused			;

CODE_CE8B:
LDA ControllerInput_Previous			;
AND #Input_Select				;check select button       
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
LDA Hammer_DestroyingEnemyFlag			;but before that, check if we're destoying an enemy
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
   
JSR RunDemoMode_EBDA				;run demo inputs
JMP CODE_CED6					;run other routines

CODE_CED3:
JSR CODE_D175					;get player's directions & maybe jump

CODE_CED6:
JSR CODE_EB06					;run gameplay routines
JSR CODE_EBB6					;handle bonus counter (decrease over time & kill the player)
JSR CODE_D041					;bonus counter hurry up check
JSR CODE_D1A4					;handle player's state
JSR CODE_EA5F					;
JSR CODE_E1E5
JSR CODE_EE79
 
;handle different hazards depending on phase
LDA PhaseNo
CMP #Phase_75M					;handle springboards in phase 2
BEQ CODE_CF01					;
CMP #Phase_100M					;handle following fires in phase 3 
BEQ CODE_CF0D					;

JSR CODE_DA16					;barrels of phase 1   
JSR CODE_E19A					;handle oil barrel flame
JSR CODE_EC29
JMP CODE_CF1C
  
CODE_CF01:
JSR CODE_E834					;handle platform lifts
JSR CODE_E981					;run springboards
JSR CODE_EC29                
JMP CODE_CF1C
  
CODE_CF0D:
JSR CODE_EC29
JMP CODE_CF1C

CODE_CF13:  
JSR CODE_EE0C                
JMP CODE_CF1C

CODE_CF19:  
JSR CODE_D0C0					;death state exclusive routine (animate?)
  
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
LDA #$01					;
STA TitleScreen_Flag				;go to title screen
STA TitleScreen_SelectHeldFlag			;well, we've pressed select, so...
STA Jumpman_Lives				;and set jumpman's lives count (for next demo i think)

LDA #$20					;demo timer
STA Timer_Demo					;

LDA #$00					; 
STA Demo_Active					;demo no more
STA TitleScreen_MainCodeFlag			;rebuild title screen
JMP CODE_CA53					;

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
CMP Pause_HeldPressed				;holds pause and any other input, but it's most likely you hold pause input (after all it IS set after pause input)
BEQ CODE_CF92					;check if it should unpause game
STA Pause_HeldPressed				;fun fact - if you hold start button and press/release any other input, the game will pause/unpause. that means player technically can pause game with any button (with pause being held)

LDA Pause_Flag					;if the game wasn't paused, then pause it
BEQ CODE_CF7A					;

LDA Pause_Timer					;unpause game on timer
BNE RETURN_CF79					;
STA Pause_Flag					;reset pause flag

LDA Sound_MusicPauseBackup			;restore whatever music was playing before
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
STA Sound_MusicPauseBackup			;

LDA #Sound_Music_Silence        		;silence music
STA Sound_Music					;

CODE_CF87:
LDA #Sound_Fanfare_GamePause			;set pause timer
STA Pause_Timer					;
STA Sound_Fanfare				;and sound effect (bit)
RTS						;

CODE_CF8F:
STA Pause_HeldPressed				;

CODE_CF92:
LDA Pause_Timer					;if pause timer isn't set, return
BEQ CODE_CF9B					;

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
;Score_Remove_CFA8:
CODE_CFA8:
LDX #$00					;
LDY #$00					;

LOOP_CFAC:
LDA Timer_Score,X				;if it's not time to erase
BNE CODE_CFB8					;don't
   
LDA #$FF					;
STA Score_OAM_Y,Y				;
STA Score_OAM_Y+4,Y				;
  
CODE_CFB8:
INX						;
INY						;
INY						;
INY						;
INY						;
INY						;
INY						;
INY						;
INY						;
CPX #$02					;run through all score sprites
BMI LOOP_CFAC					;
RTS						;

;score sprite functionality (graphics, score addition)
;init?
;input:
;X - score value (see DATA_C600)
;$05 - score X-position
;$06 - score Y-position
CODE_CFC6:
LDY #$00					;Y into zero
STY $0F						;

JSR CODE_D008					;add score and stuff

CODE_CFCD:
LDA Score_OAM_Y,Y				;check if OAM slot is free
CMP #$FF					;
BNE CODE_CFF9					;check next pair

LDA $05						;score's X-position
STA Score_OAM_X,Y				;
CLC						;
ADC #$08					;next tile is 8 pixels to the right
STA Score_OAM_X+4,Y				;

LDA $06						;Y-position
STA Score_OAM_Y,Y				;
STA Score_OAM_Y+4,Y				;

LDA DATA_C604,X					;load first score tile depending on what value (200, 300, etc.)
STA Score_OAM_Tile,Y				;

LDA #Score_TwoZeroTile				;00 ending tile for all values
STA Score_OAM_Tile+4,Y				;

LDX $0F						;load score sprite index i assume
LDA #$03					;timer
STA Timer_Score,X				;decreases every few frames
RTS						;

CODE_CFF9:
INY						;get next OAM slot pair
INY						;which means inc Y by  8
INY						;
INY						;
INY						;
INY						;
INY						;
INY						;
INC $0F						;score Index
CPY #$10					;if still have OAM slots to check, do so
BMI CODE_CFCD					;
RTS						;no score spawn (did add to the counter)

;score addition (from score sprites)
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
LDA Score_UpdateFlag				;(LDA #$01 : STA Score_UpdateFlag would've work just fine)
ORA #$01					;
STA Score_UpdateFlag				;also some places that call this routine set this before hand, which is pointless and wastes space and stuff

LDA #$F9					;
STA $00						;
JMP CODE_F435					;update it on-screen (i think)

CODE_D041:
LDA ScoreDisplay_Bonus				;if bonus score is less than 1000, play hurry up sound
CMP #$10					;
BPL RETURN_D04B

LDA #Sound_Music_HurryUp			;play hurry up music
STA Sound_Music					;
  
RETURN_D04B:
RTS

CODE_D04C:
LDA $9A                  
BNE CODE_D092

LDX PhaseNo					;100M means bolts
CPX #Phase_100M					;
BEQ CODE_D063					;

LDA $5A
BEQ RETURN_D0BF                
DEX  
LDA DATA_C1FA,X              
CMP $59                  
BEQ CODE_D074                
RTS

;check for bolts? (100M)
CODE_D063:
LDX #$00

LOOP_D065:
LDA $C1,X                
BEQ RETURN_D0BF                
INX                      
STX $044F					;amount of remaining bolts (or rather amount of removed ones?)
CPX #$08                 
BNE LOOP_D065                
JMP CODE_D086

;completed phase! got up to Pauline
CODE_D074:
JSR JumpmanPosToScratch_EAE1			;

LDA #Jumpman_GFXFrame_Stand			;draw Jumpman's normal standing frame, facing Pauline
JSR SpriteDrawingPREP_StoreTile_EAD4		;
JSR SpriteDrawingPREP_JumpmanOAM_EACD		;
JSR CODE_F088					;

LDA #Sound_Fanfare_PhaseComplete		;
STA Sound_Fanfare				;
  
CODE_D086:
LDA #Sound_Music_Silence			;no music
STA Sound_Music					;

LDA #$01					;
STA $9A						;

LDA #$00					;some timer
STA $3A						;

CODE_D092:  
LDA $3A                  
BNE RETURN_D0BF

INC PhaseNo					;next phase
LDA PhaseNo					;check which phase
CMP #$02					;non-existant cement factory?
BEQ CODE_D0A5					;fix that!
CMP #$05					;should loop into 25M?
BCS CODE_D0AA					;should loop into 25M.
JMP CODE_D0B5					;
  
CODE_D0A5:
INC PhaseNo					;jump over #$02
JMP CODE_D0B5					;
  
CODE_D0AA:
LDA #Phase_25M					;loop into 25M
STA PhaseNo					;

INC LoopCount					;+1 to the loop counter

LDA #$A0					;
STA Timer_Transition				;
RTS						;

CODE_D0B5:
LDA #$8D                 
STA $43

LDA #$00                 
STA $4F
STA $9A

RETURN_D0BF:
RTS

;This runs if player's dead
CODE_D0C0:
LDA #Sound_Music_Silence			;no music during death 
STA Sound_Music					;
  
LDA #$10					;
JSR CODE_D9E6					;
BEQ RETURN_D138					;

LDA Jumpman_Death_FlipTimer			;
CMP #$FF					;don't animate flipping, just show one frame
BEQ CODE_D130					;

LDA Jumpman_Death_FlipTimer			;
BNE CODE_D0E4					;

LDA Demo_Active					;if in demo, no sound
BNE CODE_D0DD					;

LDA #Sound_Effect_Hit				;hit sound
STA Sound_Effect				;
  
CODE_D0DD:
LDA #$40                 
STA $3A

INC Jumpman_Death_FlipTimer
RTS
  
CODE_D0E4:
LDA $3A						;timer
BEQ CODE_D0F8					;initialize
CMP #$0E					;don't run things when less than 0E
BCC RETURN_D138					;

;player is dying
LDA Demo_Active					;if died during demo, stay silent
BNE CODE_D0F4					;

LDA #Sound_Effect2_Dead				;
STA Sound_Effect2				;
  
CODE_D0F4:
LDA #$00					;reset timer
STA $3A						;

CODE_D0F8:
LDA Jumpman_OAM_Tile				;animate flipendo
CMP #Jumpman_GFXFrame_Dead_Up			;
BCS CODE_D101					;

LDA #Jumpman_GFXFrame_Dead_Up			;

CODE_D101:
CLC						;
ADC #$04					;
CMP #Jumpman_GFXFrame_Dead_Dead			;if flowing into very dead frame, change to the normal flip
BCC CODE_D11F					;

INC Jumpman_Death_FlipTimer

LDA Jumpman_Death_FlipTimer			;if made enough 360s
CMP #$05					;
BEQ CODE_D115					;show dead frame

LDA #Jumpman_GFXFrame_Dead_Up			;
JMP CODE_D11F					;

CODE_D115:
LDA Demo_Active					;is it demo?
BEQ CODE_D11D					;if so, skip timer shenanigans

LDA #$7D					;wait a bit before reloading phase/going to the title screen
STA $3A						;

CODE_D11D:  
LDA #Jumpman_GFXFrame_Dead_Dead			;

CODE_D11F:
STA $02						;store tile
JSR JumpmanPosToScratch_EAE1			;get some prep work
JSR SpriteDrawingPREP_JumpmanOAM_EACD		;more of it
JSR CODE_F082					;draw simple flips.

LDA Jumpman_Death_FlipTimer			;if not enough 360s, return
CMP #$05					;
BNE RETURN_D138					;

CODE_D130:
LDA #$FF					;set to FF, so he doesn't flip anymore
STA Jumpman_Death_FlipTimer			;

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
STA TitleScreen_Flag				;

LDA #$87					;transition onto the title screen!
STA Timer_Transition				;
RTS						;

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
STA Direction					;save directional input
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
AND #Input_A					;press A - the player'll jump
BEQ RETURN_D199					;

LDA #Jumpman_State_Jumping			;jumpman is a jumping man ofc
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

;check player's state
;HandleJumpmanState_D1A4:
CODE_D1A4:
LDA Jumpman_State				;
CMP #Jumpman_State_Grounded			;
BEQ CODE_D1BB					;if grounded, can move normally

CODE_D1AA:
CMP #Jumpman_State_Climbing			;is jumpman climbing?
BEQ CODE_D1C3					;do climbing things
CMP #$04                 
BEQ CODE_D1C6
CMP #Jumpman_State_Falling
BEQ CODE_D1C9
CMP #Jumpman_State_Hammer			;move and stuff when equipped with hammer
BEQ CODE_D1CC
RTS

CODE_D1BB:
JSR CODE_D1CF					;handle movement

LDA Jumpman_State				;continue checking
JMP CODE_D1AA					;in case we changed it during movement
  
CODE_D1C3:
JMP CODE_D37E					;climb

CODE_D1C6:
JMP CODE_D547

;falling. Oops
CODE_D1C9:
JMP CODE_D697                

;HAMMER
CODE_D1CC:
JMP CODE_D6C6

;Grounded state
CODE_D1CF:
LDA Direction					;check for directional input
CMP #Input_Right				;holding right...
BEQ CODE_D1E5					;move
CMP #Input_Left					;holding left...
BEQ CODE_D1E5					;move
CMP #Input_Down					;holding down...
BEQ CODE_D1E2					;check ladder
CMP #Input_Up					;moving up...
BEQ CODE_D1E2					;check ladder
RTS						;don't move or anything

CODE_D1E2:
JMP CODE_D28B					;check ladder i think

;moving left or right
CODE_D1E5:
LDA #$DB					;bits...
STA $0A						;

LDA #$36					;more bits...
JSR CODE_D9E8					;yeah, i'm still not sure how this works
BNE CODE_D1F3					;i think move only certain frames (or all frames?
JMP CODE_D275					;

CODE_D1F3:
JSR CODE_D990					;check boundary
BEQ CODE_D1F9					;if not interacting, move
RTS						;

;move the player horizontally
CODE_D1F9:
LDA Direction					;move left or right?
CMP #Input_Left					;
BEQ CODE_D205					;

INC Jumpman_OAM_X				;move right
JMP CODE_D208					;
  
CODE_D205:
DEC Jumpman_OAM_X				;move left

CODE_D208:  
JSR CODE_D2CB					;check if on platform
STA Jumpman_OnPlatformFlag			;

LDA Jumpman_OAM_Y				;
JSR CODE_E016					;which platform height?
STA Platform_HeightIndex			;

JSR CODE_D8EB					;add shift pos, or something
BEQ CODE_D233					;

LDX PhaseNo					;phase?
CPX #$01					;1?
BNE CODE_D227					;yes?
CLC						;yes.
ADC Jumpman_OAM_Y				;yes!
STA Jumpman_OAM_Y				;shift player's Y-pos
  
CODE_D227:
JSR CODE_D36A					;check if walked of the ledge?
CMP #$00					;
BEQ CODE_D233					;

LDA #Jumpman_State_Falling			;do i have to tell what this does?
STA Jumpman_State				;
RTS						;

CODE_D233:  
LDA Jumpman_WalkFlag				;animate walking every other frame
BNE CODE_D23E					;

LDA #$01					;
STA Jumpman_WalkFlag				;move next frame
JMP CODE_D275					;

CODE_D23E:
LDA #Sound_Effect2_Movement			;make walking sound effect
STA Sound_Effect2				;

LDA #$00					;
STA Jumpman_WalkFlag				;don't move next frame

;Animate walking
LDA Jumpman_GFXFrame				;walking frame 2?
BEQ CODE_D262					;set staning frame (or walk 3)
CMP #Jumpman_GFXFrame_Walk1			;walking 1?
BEQ CODE_D26D					;set walk 2

LDA #Jumpman_GFXFrame_Stand			;load standing frame by default
STA Jumpman_GFXFrame

LDA $85						;another every other frame flag???
BEQ CODE_D25B					;

LDA #Jumpman_GFXFrame_Walk2			;
JMP CODE_D25D					;
  
CODE_D25B:
LDA #Jumpman_GFXFrame_Walk1			;walk frame 1
  
CODE_D25D:
STA Jumpman_GFXFrame				;set frame
JMP CODE_D275					;and continue doing a thing
  
CODE_D262:
LDA #Jumpman_GFXFrame_Stand			;standing ftrame
STA Jumpman_GFXFrame

LDA #$00					;walking frame update flag i think
STA $85						;
JMP CODE_D275					;
  
CODE_D26D:
LDA #Jumpman_GFXFrame_Stand			;standing frame
STA Jumpman_GFXFrame

LDA #$01					;
STA $85						;

CODE_D275:
JSR JumpmanPosToScratch_EAE1			;get pos to scrath ram

LDA Jumpman_GFXFrame				;get jumpman's animation
STA $02						;
JSR SpriteDrawingPREP_JumpmanOAM_EACD		;set jumpman's OAM to low byte indirect address

LDA Direction					;
CMP #Input_Left					;
BEQ CODE_D288					;if holding left, draw flipped
JMP CODE_F082					;not flipped

CODE_D288:
JMP CODE_F088					;yes, flipped

CODE_D28B:
JSR JumpmanPosToScratch_EAE1			;get Jumpmans position

LDA #<DATA_C186					;
STA $02						;

LDA #>DATA_C186					;
STA $03						;
JSR CODE_EFEB					;update graphics

LDA PhaseNo					;get ladder data depending on phase
SEC						;
SBC #$01					;
ASL A						;
TAX						;
LDA DATA_C47B,X					;get some ladder data (i think?)
STA $04						;

LDA DATA_C47B+1,X
STA $05

LDA DATA_C483,X
STA $06

LDA DATA_C483+1,X 
STA $07

JSR CODE_D8AD					;check for all ladders
BEQ RETURN_D2CA					;not climbing ladder? return

LDA $00						;
SEC						;
SBC #$04					;
STA Jumpman_CurrentLadderXPos			;this must be ladder's X-pos

LDA #Jumpman_State_Climbing			;jumpman is climbing a ladder
STA Jumpman_State				;

LDA #$00					;reset other animatio counters
STA Jumpman_ClimbOnPlatAnimCounter		;
STA Jumpman_ClimbAnimCounter			;

RETURN_D2CA:
RTS						;

CODE_D2CB:
JSR JumpmanPosToScratch_EAE1			;get jumpmans position

LDA Jumpman_State				;
CMP #Jumpman_State_Jumping			;i think those checks are for vertical pos update
BEQ CODE_D2DD					;
CMP #Jumpman_State_Falling			;
BEQ CODE_D2DD					;
 
LDA #$2C
JMP CODE_D2DF
  
CODE_D2DD:
LDA #$4A
  
CODE_D2DF:
JSR CODE_EFE8					;collision-related
 
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

;shift player on shifted platforms in phase one (Jumpman_OAM_Y+Platform_ShiftIndex)
CODE_D36A:
LDA PhaseNo					;
CMP #Phase_25M					;
BEQ CODE_D373					;check if phase 1
JMP CODE_D37B					;return
  
CODE_D373:
LDA #$1C					;offset data
JSR CODE_C831    
JMP CODE_D8AD
  
CODE_D37B:
LDA #$01					;
RTS						;

;Handle player climbing
CODE_D37E:
LDA Direction					;
CMP #Input_Up					;move up?
BEQ CODE_D38E					;
CMP #Input_Down					;move down?
BEQ CODE_D38B					;
JMP CODE_D4CF					;not moving
  
CODE_D38B:
JMP CODE_D432					;move down
  
CODE_D38E:
LDA Jumpman_OnPlatformFlag			;on platform?
BEQ CODE_D39C					;continue clumbing
JSR JumpmanPosToScratch_EAE1			;jumpman's position to scratch ram

DEC $01						;go up
JSR CODE_D50A					;climb from platform
BNE CODE_D3CD					;
  
CODE_D39C:
LDA #$24					;
STA $0A						;

LDA #$49					;something bit-related
JSR CODE_D9E8					;
BNE CODE_D3AF					;

LDA Jumpman_OAM_Y				;y-pos to scrath ram
STA $01						;
JMP CODE_D4CF					;skip it all

CODE_D3AF:
JSR CODE_D50A                
BEQ CODE_D3E7
CMP #$02
BNE CODE_D3BB
JMP CODE_D4CF
  
CODE_D3BB:
LDA Jumpman_ClimbOnPlatAnimCounter		;
BEQ CODE_D3D0					;
CLC						;
ADC #$01					;
CMP #$10					;
BEQ CODE_D3D2					;
BCC CODE_D3D2					;

;!UNUSED
;can't trigger because animation stops when reaching exactly 10 (fully climbed onto the platform)
LDA #$10					;
JMP CODE_D3D2					;

CODE_D3CD:
JMP CODE_D4CF					;
  
CODE_D3D0:
LDA #$01					;
  
CODE_D3D2:
STA Jumpman_ClimbOnPlatAnimCounter		;
TAX						;
DEX						;
LDA DATA_C147,X					;
STA $02						;sprite tile

LDA #$00					;
STA $5A						;
STA Jumpman_ClimbAnimCounter			;
JSR Jumpman_MoveLadderDown_D4EE			;
JMP CODE_D40D					;

;animate ladder climbing
CODE_D3E7:
LDA Jumpman_ClimbAnimCounter			;we're just climbing the ladder
BEQ CODE_D3F9					;set initial value
CLC						;
ADC #$01					;+1
CMP #$06					;if the value is 6 or less, continue animating
BEQ CODE_D3FB					;
BCC CODE_D3FB					;

LDA #$01					;set to 1
JMP CODE_D3FB					;
  
CODE_D3F9:
LDA #$02					;
  
CODE_D3FB:
STA Jumpman_ClimbAnimCounter			;
TAX						;
DEX						;
LDA DATA_C159,X					;get ladder frame
STA $02

LDA #$00					;other animation related adresses?
STA $5A						;
STA Jumpman_ClimbOnPlatAnimCounter		;
JSR Jumpman_MoveLadderDown_D4EE			;
  
CODE_D40D:
LDA Jumpman_CurrentLadderXPos			;player's X-position
STA $00						;
STA Jumpman_OAM_X				;put on the ladder
JSR SpriteDrawingPREP_Draw16x16_EAD1		;draw 16x16

LDA #<Jumpman_OAM_Y				;
STA $04						;
 
LDA $02						;check if we've got $54 from the data above
CMP #$54					;
BEQ CODE_D426					;yes, load normal climbing frame but flip

LDA #$00					;draw normal
JMP CODE_D42C					;

CODE_D426:
LDA #Jumpman_GFXFrame_Climbing			;
STA $02						;

LDA #$01					;draw flip

CODE_D42C:
JSR SpriteDrawingEngine_F096			;draw
JMP CODE_D4CF					;

CODE_D432:
LDA Jumpman_OnPlatformFlag			;check if grounded
BEQ CODE_D445					;no?

JSR JumpmanPosToScratch_EAE1			;

INC $01						;move down
JSR CODE_D50A					;also, run JumpmanPosToScratch_EAE1 again and other stuff... (which means above INC $01 is pointless)
CMP #$01                 
BEQ CODE_D445
JMP CODE_D4CF
  
CODE_D445:
LDA #$24					;this is pointless because of CODE_D9E6 (will be set to $49)
STA $0A						;

LDA #$49					;
STA $0B						;
JSR CODE_D9E6					;
BNE CODE_D45A					;

LDA Jumpman_OAM_Y				;temp store
STA $01						;
JMP CODE_D4CF					;check if on ground

CODE_D45A:
JSR CODE_D50A					;
BEQ CODE_D48B					;don't climb?
CMP #$02					;
BEQ CODE_D48B					;don't climb???

LDA Jumpman_ClimbOnPlatAnimCounter		;animate when going down
BEQ CODE_D471					;
SEC						;
SBC #$01					;
CMP #$01					;
BCC CODE_D476					;
JMP CODE_D478					;
  
CODE_D471:
LDA #$0D					;
JMP CODE_D478					;
  
CODE_D476:
LDA #$01					;
  
CODE_D478:
STA Jumpman_ClimbOnPlatAnimCounter		;
TAX						;
DEX						;
LDA DATA_C147,X					;
STA $02						;

LDA #$03					;something
STA Jumpman_ClimbAnimCounter			;
JSR Jumpman_MoveLadderUp_D4F9			;
JMP CODE_D4B1					;

;looks similar to CODE_D40D? because yes!
CODE_D48B:  
LDA Jumpman_ClimbAnimCounter			;
BEQ CODE_D49D					;
CLC						;
ADC #$01					;
CMP #$06					;
BEQ CODE_D49F					;
BCC CODE_D49F					;

LDA #$01					;
JMP CODE_D49F					;

CODE_D49D:
LDA #$01					;inaccessible?

CODE_D49F:
STA Jumpman_ClimbAnimCounter			;get climbing frame (w/ flip or not)
SEC						;
SBC #$01					;
TAX						;
LDA DATA_C159,X					;
STA $02						;

LDA #$00					;
STA Jumpman_ClimbOnPlatAnimCounter		;
JSR Jumpman_MoveLadderUp_D4F9			;

CODE_D4B1:
LDA Jumpman_CurrentLadderXPos			;
STA Jumpman_OAM_X				;
STA $00						;X-position

JSR SpriteDrawingPREP_JumpmanOAM_EACD		;16x16 and OAM

LDA $02						;check for 54
CMP #$54					;
BEQ CODE_D4C6					;yes, draw flipped climbing

LDA #$00					;draw norm
JMP CODE_D4CC					;

CODE_D4C6:
LDA #Jumpman_GFXFrame_Climbing			;
STA $02						;

LDA #$01					;

CODE_D4CC:
JSR SpriteDrawingEngine_F096			;draw jumpman

CODE_D4CF:
JSR CODE_D2CB					;check if not climbing anymore
STA Jumpman_OnPlatformFlag			;be or not be on platform
BEQ RETURN_D4ED					;still on ladder? return

LDA Jumpman_OAM_Y				;
CLC						;
ADC #$08					;
JSR CODE_E016					;get which platform the Jumpman's on
STA Platform_HeightIndex			;

LDA #Jumpman_State_Grounded			;
STA Jumpman_State				;

LDA #$00					;
STA Jumpman_ClimbAnimCounter			;
STA $5B                  
STA $85

RETURN_D4ED:
RTS						;

;CODE_D4EE:
;moving jumpman (ladder)

Jumpman_MoveLadderDown_D4EE:
LDA Jumpman_OAM_Y				;move down
SEC						;
SBC #$01					;
STA $01						;
JMP CODE_D501					;

;CODE_D4F9:
Jumpman_MoveLadderUp_D4F9:
LDA Jumpman_OAM_Y				;move up
CLC						;
ADC #$01					;
STA $01						;
  
CODE_D501:
AND #$06					;
BNE RETURN_D509					;

;every 6 pixels, make a movement sound
LDA #Sound_Effect2_Movement			;
STA Sound_Effect2				;

RETURN_D509:
RTS						;

CODE_D50A:
JSR JumpmanPosToScratch_EAE1			;

LDA #$2C					;
JSR CODE_EFE8					;get collision values

LDA PhaseNo					;something that depends on current phase
SEC						;
SBC #$01					;
ASL A						;
TAX						;
LDA DATA_C48B,X					;
STA $04						;

LDA DATA_C48B+1,X				;
STA $05						;

LDA #$43					;indirect addressing set-up?
STA $06

LDA #$C1
STA $07
JSR CODE_D8AD                
STA $08

LDA PhaseNo					;if phase isn't 1, return
CMP #$01					;
BNE CODE_D544					;

LDA #$1E					;i assume checks for broken ladders?
JSR CODE_C831					;
JSR CODE_D8AD					;
BEQ CODE_D544					;

LDA #$02					;
STA $08						;
  
CODE_D544:
LDA $08						;
RTS						;

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

;This code handles jumpman's movement when jumping
CODE_D55A:
JSR CODE_D990					;check solid walls? (to bounce off in opposite direction)
BEQ CODE_D570					;if didn't bop a boundary, continue

LDA Direction					;change direction from right to left and vice versa
CMP #Input_Right				;
BNE CODE_D56A					;

LDA #Input_Left					;
JMP CODE_D56C					;
  
CODE_D56A:
LDA #Input_Right				;
  
CODE_D56C:
STA Direction					;set direction
STA Direction_Horz				;

CODE_D570:  
LDA Jumpman_OAM_Y				;
STA $01						;

LDA #$00					;
JSR CODE_EF72					;calculate jumpman's Y-pos?

LDA $01						;i think calculated Y-pos?
STA Jumpman_OAM_Y				;

;always move in one direction
LDA Direction					;
CMP #Input_Right				;see if moving right
BEQ CODE_D58C					;
CMP #Input_Left					;
BEQ CODE_D5A1					;
JMP CODE_D5B3					;jumping in place

;moving right
CODE_D58C:
LDA Jumpman_AirMoveFlag				;update player's x-pos every other frame
BEQ CODE_D59A					;

INC Jumpman_OAM_X				;move right

LDA #$00					;
STA Jumpman_AirMoveFlag				;no update next frame
JMP CODE_D5B3					;

CODE_D59A:
LDA #$01					;update next frame
STA Jumpman_AirMoveFlag				;
JMP CODE_D5B3					;

CODE_D5A1:
LDA Jumpman_AirMoveFlag				;pretty much the same as above
BEQ CODE_D5AF					;

DEC Jumpman_OAM_X				;but move left instead

LDA #$00					;
STA Jumpman_AirMoveFlag				;
JMP CODE_D5B3					;update position i think
  
CODE_D5AF:
LDA #$01					;update x-pos next frame (p-sure could've used frame counter, though there's no such thing?)
STA Jumpman_AirMoveFlag				;
  
CODE_D5B3:
LDA Jumpman_OAM_X				;for collision?
STA $00						;
JSR CODE_D800					;

LDA $94						;
BEQ CODE_D5E2					;

LDA $01						;
SEC						;
SBC #$10					;
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
LDA #Jumpman_GFXFrame_Jumping			;
JMP CODE_F070					;draw

CODE_D5F6:
JSR JumpmanPosToScratch_EAE1			;jumpman's position to scratch ram

LDA #Jumpman_GFXFrame_Landing			;
STA $02						;tile
JSR SpriteDrawingPREP_JumpmanOAM_EACD		;prepare for drawing

LDA Direction_Horz				;flip player's GFX if necessary
AND #Input_Right|Input_Left			;
LSR A						;b-b-b-b-b-b-but... CODE_F078?
JSR SpriteDrawingEngine_F096			;

LDA #$F0					;currently unknown
STA $94						;
RTS						;

CODE_D60D:
INC $94						;some kinda timer
LDA $94						;
CMP #$F4					;
BNE RETURN_D64F					;

LDA $95						;timer or distance or w/e
CMP #$FF					;
BEQ CODE_D642					;dead if $FF (landed from high place)

;non-lethal landing
LDA #Jumpman_GFXFrame_Stand			;
JSR CODE_F070					;

LDA #$00                 
STA $042C                
STA $94                  
STA $95

LDA #Jumpman_State_Grounded			;
STA Jumpman_State				;
   
LDA Jumpman_HeldHammerIndex			;didn't interact with the hammer -> didn't pick up -> return
BEQ RETURN_D64F					;

;Jumpman picked up a hammer
LDA #$01					;
STA Hammer_JumpmanFrame				;

LDA #Timer_ForHammer				;hammer timer
STA Timer_Hammer				;

LDA #Jumpman_State_Hammer			;
STA Jumpman_State				;
 
LDA #Sound_Music_Hammer				;
STA Sound_Music					;
RTS						;

;landed to death
CODE_D642:
LDA #$00                 
STA $042C
STA $94                  
STA $95
   
LDA #Jumpman_State_Dead				;
STA Jumpman_State				;

RETURN_D64F:
RTS						;


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
BEQ RETURN_D696					;not moving, return

LDA #Jumpman_State_Falling			;we're falling
STA Jumpman_State
  
LDA #$01

RETURN_D696:
RTS
;----------------------------------------------

;Jumpman is falling!!! AAA
CODE_D697:
LDA #$FF					;update... always?
JSR CODE_D9E6					;
BEQ RETURN_D6C5					;

JSR JumpmanPosToScratch_EAE1			;
INC $01						;fall down & quick!
INC $01

LDA Direction_Horz				;
CMP #Input_Left					;
BEQ CODE_D6B1					;

LDA Jumpman_OAM_Tile				;keep the same frame
JMP CODE_D6B7					;

CODE_D6B1:
LDA Jumpman_OAM_Tile				;keep the same frame but with -2
SEC						;
SBC #$02					;(becuase first OAM tile is actually the last tile for non-flipped sprite) (when i mean last i mean on the same row)

CODE_D6B7:  
STA $02						;
  
JSR CODE_F075					;draw da player

JSR CODE_D2CB					;check for platform
BEQ RETURN_D6C5					;
      
LDA #Jumpman_State_Dead				;
STA Jumpman_State				;Jumpman dies
  
RETURN_D6C5:
RTS						;

;movement & animation with hammer
CODE_D6C6:
LDA Timer_Hammer				;
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
JSR CODE_D990					;check boundaries
BNE CODE_D6E8					;can't move if colliding

LDA Direction					;
CMP #Input_Right				;
BEQ CODE_D70A					;moving right
CMP #Input_Left					;
BEQ CODE_D710					;moving left

;stationary
CODE_D6E8:  
LDA $A2						;i think this is for animation timing
ASL A
STA $A2
BEQ CODE_D6F2					;
JMP CODE_D753					;don't animate

CODE_D6F2:  
LDA #$20                 
STA $A2

;animate moving w/ hammer
LDA Hammer_JumpmanFrame
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
INC Jumpman_OAM_X				;move right
JMP CODE_D713

CODE_D710:  
DEC Jumpman_OAM_X				;move left
  
CODE_D713:
JSR CODE_D2CB
STA Jumpman_OnPlatformFlag			;stay on platform i think

LDA Jumpman_OAM_Y
JSR CODE_E016
STA Platform_HeightIndex
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

;animate jumpman w/ hammer (hoving horz)
CODE_D73E:
LDA #Sound_Effect2_Movement			;play movement sound effect every frame
STA Sound_Effect2				;

LDA Hammer_JumpmanFrame				;
BEQ CODE_D74F					;if zero, set to 1 (from walk 2 to stand)
CMP #$06					;
BCS CODE_D74F					;more than or equal 6, set stand, hammer up

INC Hammer_JumpmanFrame				;
JMP CODE_D753
  
CODE_D74F:
LDA #$01					;
STA Hammer_JumpmanFrame				;
  
CODE_D753:
LDX Hammer_JumpmanFrame				;get animation frame
DEX						;
LDA DATA_C1A2,X					;from this beautiful little table              
JSR CODE_F070					;draw frame
    
LDA Hammer_JumpmanFrame				;place hammer according to frame (hammer up or down)
LSR A						;
LSR A						;
BEQ CODE_D767					;

LDA #$00					;hammer down
JMP CODE_D769					;
  
CODE_D767:
LDA #$01					;hammer up
  
CODE_D769:
BEQ CODE_D786					;
    
LDA #$04					;slight x-offset
CLC						;
ADC Jumpman_OAM_X				;
STA $00						;

LDA Jumpman_OAM_Y				;and y-pos
SEC						;
SBC #$0E					;
STA $01						;

LDA #$21					;2 rows, 1 tile each
STA $03						;

LDA #Hammer_GFXFrame_HammerUp			;
STA $02						;
JMP CODE_D7AD					;draw the hammer

;hammer's down
CODE_D786:
LDA Direction_Horz				;position hammer based on horz direction
CMP #Input_Right				;
BNE CODE_D795					;

LDA #$0E					;shift hammer's pos
CLC						;
ADC Jumpman_OAM_X				;relative to jumpman
JMP CODE_D79B					;

CODE_D795:
LDA Jumpman_OAM_X				;
SEC						;
SBC #$0E					;

CODE_D79B:  
STA $00						;

LDA #$06					;
CLC						;
ADC Jumpman_OAM_Y				;
STA $01						;

LDA #$12					;1 row w/ 2 tiles
STA $03						;

LDA #Hammer_GFXFrame_HammerDown			;
STA $02						;

CODE_D7AD:  
LDA Jumpman_HeldHammerIndex			;check which hammer we're holing
CMP #$01					;get OAM slots that way
BEQ CODE_D7B8					;

LDA #<Hammers_OAM_Y+8				;load OAM offset (second hammer)
JMP CODE_D7BA					;
  
CODE_D7B8:
LDA #<Hammers_OAM_Y				;first hammer OAM
  
CODE_D7BA:
STA $04						;
JMP CODE_F078					;draw da hammer

;hammer has worn out...
CODE_D7BF:
LDA #$12					;prepare for sprite tile removal, i think
STA $03						;

LDA Jumpman_HeldHammerIndex			;
CMP #$01					;
BEQ CODE_D7D3					;

LDA #$00					;
STA Hammer_CanGrabFlag+1			;

LDA #<Hammers_OAM_Y+8				;
JMP CODE_D7DA

CODE_D7D3:  
LDA #$00					;
STA Hammer_CanGrabFlag				;

LDA #<Hammers_OAM_Y				;
  
CODE_D7DA:
STA $04						;
JSR CODE_F094					;remove the hammer
JSR CODE_D7F2					;restore fire color (if in 100M, fire enemies change color when equipped with hammer)

LDA #$01					;jumpman is grounded
STA Jumpman_State

LDA #$00					;
STA Jumpman_HeldHammerIndex			;jumpman's no longer holding a hammer
STA Hammer_JumpmanFrame				;

LDA Sound_MusicHammerBackup			;restore music
STA Sound_Music					;
RTS						;

;upload sprite palette 2 for fire
CODE_D7F2:
LDA #$19					;
STA $00						;

LDA #$3F					;VRAM pos ($3F19)
STA $01						;

LDA #$4E					;offset
JSR CODE_C815					;
RTS						;

CODE_D800:
LDA Jumpman_HeldHammerIndex			;check if jumpman has grabbed a hammer
BEQ CODE_D805					;check for hammers
RTS						;

CODE_D805:
LDY PhaseNo					;check phase
CPY #Phase_75M					;
BNE CODE_D80E					;
JMP CODE_D8A8					;if it's 75M, reset hammer flag (but why??? it's 0 already)

;not 75M...
CODE_D80E:
LDA Jumpman_OAM_X				;
CPY #Phase_25M					;check phase 1
BEQ CODE_D81E					;go check pos for hammers in phase 1
CMP #$88					;
BEQ CODE_D827					;collide (or try to)
BCC CODE_D827					;
JMP CODE_D8A8					;

CODE_D81E:  
CMP #$28					;check if jumpman's X-pos is $28 or less
BEQ CODE_D827					;can interact w/ hammer
BCC CODE_D827					;can interact w/ hammer
JMP CODE_D8A8					;can't

CODE_D827:  
LDA OAM_Y					;get y-pos
CLC						;and +8 (higher)
ADC #$08					;
JSR CODE_E016					;
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

LDA Hammer_CanGrabFlag+1			;can grab second hammer?
BNE CODE_D856					;yes
JMP CODE_D8A8					;no
  
CODE_D856:
LDA #$02					;get hammer 2
STA Jumpman_HeldHammerIndex			;

LDA Hammers_OAM_Y+8				;probably place at jumpman's position
STA $01						;

LDA Hammers_OAM_X+8				;
STA $00						;
JMP CODE_D87D

CODE_D867:
LDA Hammer_CanGrabFlag				;can player even grab the hammer?
BNE CODE_D86F					;if yes, do so
JMP CODE_D8A8					;no, return

CODE_D86F:
LDA #$01					;get hammer 1
STA Jumpman_HeldHammerIndex			;

LDA Hammers_OAM_Y				;place hammer at player's pos
STA $01						;(probably)

LDA Hammers_OAM_X				;
STA $00						;

CODE_D87D:  
LDA #$2E					;
JSR CODE_EFE8					;get hammer's hitbox

JSR JumpmanPosToScratch_EAE1			;

LDA #$30					;
JSR CODE_C847					;and jumpman's

JSR CODE_EFEF					;check for actual collision w/ hammer
BEQ CODE_D8A8					;we didn't pick it up!

LDA Sound_Music					;
STA Sound_MusicHammerBackup			;backup music

LDA PhaseNo					;check phase
CMP #Phase_100M					;100M?
BNE RETURN_D8A7					;if not, return

LDA #$19					;change flame enemies' color
STA $00						;

LDA #$3F					;VRAM
STA $01						;

LDA #$46					;
JSR CODE_C815					;
  
RETURN_D8A7:
RTS						;
  
CODE_D8A8:
LDA #$00					;no hammer thank you very much
STA Jumpman_HeldHammerIndex			;
RTS						;

;something about shifted platforms (phase 1), i think???
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

;same as GetLRDir_D904 but values are swapped (1 - moving right, FF - moving left)
LDA Direction					;
CMP #Input_Right				;
BEQ CODE_D914					;
CMP #Input_Left					;
BEQ CODE_D911					;
JMP CODE_D917					;

;get movement based on direction.
;Output:
;A - 0 - not moving, 1 - moving left, FF - moving right
;GetLRDir_D904:
CODE_D904:
LDA Direction					;
CMP #Input_Right				;
BEQ CODE_D911					;
CMP #Input_Left					;
BEQ CODE_D914					;
JMP CODE_D917					;
  
CODE_D911:
LDA #$FF					;moving left (or right)
RTS						;

CODE_D914:
LDA #$01					;moving right (or left)
RTS						;

CODE_D917:
LDA #$00					;not moving (for certain)
RTS						;

;(phase 1 only)
;collision with curved platforms?
;probably with slightly curved platforms/slope platforms/what ever the hell
CODE_D91A:
LDA Jumpman_OAM_Y				;get player's Y position
CLC						;and add 8
ADC #$08					;
JSR CODE_E016					;get which platform's on
STA Platform_HeightIndex			;if player's on the very low platform (at the beginning)
CMP #$01					;
BEQ CODE_D938					;don't check for ladders, i think?

LDX #$02					;
LDA #$0C					;

LOOP_D92D:
CPX Platform_HeightIndex			;check if it is a platform 2 onward
BEQ CODE_D93B					;
CLC						;
ADC #$06					;offset by platform
INX						;
JMP LOOP_D92D					;
  
CODE_D938:
SEC						;-1 (because platform counts from 1)
SBC #$01					;

CODE_D93B:
TAX						;and into index

LOOP_D93C:          
LDA #$00					;
STA Platform_ShiftIndex				;

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

;used to check for level boundaries/walls
CODE_D990:
LDA Direction					;check direction
CMP #Input_Right				;right boundary
BEQ CODE_D99D					;
CMP #Input_Left					;left boundary
BEQ CODE_D9AF					;
JMP CODE_D9E3					;

CODE_D99D:  
LDA PhaseNo					;depending on phase...
ASL A						;
TAX						;check left boundary here
DEX						;
LDA DATA_C1B4,X					;get boundaries?
CMP Jumpman_OAM_X				;check with player's X-pos
BEQ CODE_D9E0					;if equals, push away
BCC CODE_D9E0					;if less, also push
JMP CODE_D9E3					;no wall
  
CODE_D9AF:
LDA PhaseNo					;get boundary and stuff depending on phase
ASL A						;yada yada yada
TAX						;
DEX						;
DEX						;
LDA DATA_C1B4,X					;this time check right boundary
CMP Jumpman_OAM_X				;
BCS CODE_D9E0					;
 
LDA PhaseNo					;if phase 4, return
CMP #Phase_100M					;because donkey kong is standing on a platform jumpman can't pass through
BEQ CODE_D9E3					;

LDX Platform_HeightIndex			;what is this for
CMP #Phase_75M					;if phase is 75M, the platform is slightly lower
BEQ CODE_D9D0					;counts as did interact (huh?)
CPX #$06					;
BNE CODE_D9E3					;
JMP CODE_D9D4
  
CODE_D9D0:
CPX #$05					;check height 5?
BNE CODE_D9E3					;if not, not on the same level as DKs platform

CODE_D9D4:  
LDA Jumpman_OAM_X				;check actual platform boundary
CMP #$68					;
BEQ CODE_D9E0					;if equal to 68
BCC CODE_D9E0					;or less, go away (pro tip: can be shortened to CMP #$69 : BCC)
JMP CODE_D9E3					;not go away
  
CODE_D9E0:
LDA #$01					;A = 1 - interacts with a wall/boundary
RTS						;
  
CODE_D9E3:
LDA #$00					;A = 0 - opposite of what i said above
RTS						;

;used for timing things
;still not sure how it works really.
;Uses A as input (and $0A if using CODE_D9E8)
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

LDA #$00					;
STA Barrel_CurrentIndex				;

JP_LOOP_DA19:
LOOP_DA1D:
JSR GetBarrelOAM_EFD5				;

LDA OAM_Y,X					;see if the barrel doesn't exist
CMP #$FF					;
BNE CODE_DA3D					;it does, run

LDA Timer_KongSpawn				;check if timer for barrel spawn is up
BNE CODE_DA40					;if not, dont spawn

LDA #$80					;enable a barrel? i assume this is a "flag".
LDX Barrel_CurrentIndex				;load barrel index
STA $5E,X					;store enable bit

LDA #$10					;barrel hold timer, basically it'll stay in place for this amount of frames
STA $37						;

JSR CODE_EAF7					;get difficuly
LDA CODE_C443,X					;load timer for next barrel throw
STA Timer_KongSpawn				;
  
CODE_DA3D:
JSR CODE_DA4C					;run barrel code
  
CODE_DA40:
LDA Barrel_CurrentIndex				;BarrelIndex = BarrelIndex + 1        
CLC						;makes me think that this was either written in higher level language or the programmer was just lazy to optimize)
ADC #$01					;INC BarrelIndex would look like BarrelIndex++ (i admit i don't know much about C, so plz don't kill me if im wrong)
STA Barrel_CurrentIndex						;anyway, yeah... a way to go
CMP #$09					;well, you could INC then LDA, it'd still be more optimal.

If Version = JP
  BEQ JP_RETURN_DA4A				;
  JMP JP_LOOP_DA19				;bad nintendo, bad!
else
  BNE LOOP_DA1D					;wow, they actually optimized something in this code in revision 1! :clap: :clap: :clap:
endif

JP_RETURN_DA4A:
RTS						;
  
CODE_DA4C:
LDX $5D						; 
LDA $5E,X					;various barrel states w/ very specific values
CMP #$80					;if initialized
BEQ CODE_DA7D					;
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
JSR GetBarrelOAM_EFD5				;

LDA #$30                 
STA $00

If Version = JP
  LDA #$30					;another minor optimization they did in revision 1. we had 30 already loaded before. nintendo was still incredibly lazy to clean up everything.
endif
STA $01						;

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

JSR GetBarrelOAM_EFD5

LDA #$4D                 
STA $00

LDA #$32                 
STA $01

LDA #$84                 
STA $02                  
STX $04                  
JSR CODE_EADB

;show kong's "toss to the side" frame
INC Kong_TossToTheSideFlag			;
JMP RETURN_DB2B					;and jump, instead of just, y'know... using RTS!?
  
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
JSR GetBarrelOAM_EFD5				;get barrel's OAM
PHA						;
JSR EntityPosToScratch_EAEC			;barrel's pos

LDA $01						;
JSR CODE_E016					;get which platform the barrel's on based on Y-pos

LDY $5D                  
STA Barrel_CurrentPlatformIndex,Y		;depending on current platform, go left or right
AND #$01					;
BNE CODE_DB4E					;every other platfform it goes left
INC $00						;move right
JMP CODE_DB50					;
  
CODE_DB4E:
DEC $00						;move left
  
CODE_DB50:
LDA $00						;
JSR CODE_E05A					;1 - crossed lower into the platform
STA Barrel_ShiftDownFlag			;
  
JSR CODE_E048					;check Barrel_ShiftDownFlag and smth else
CLC						;check if shifted down
ADC $01						;new Y-pos
STA $01						;
 
JSR CODE_DBEE					;animate the barrel

LDX Barrel_CurrentIndex				;
LDA Barrel_GFXFrame,X				;barrel's GFX frame
JSR SpriteDrawingPREP_StoreTile_EAD4		;get some prep for drawing
PLA						;
TAX						;X - OAM!
JSR CODE_F080					;draw da barrel!

LDA $00						;X-pos
JSR CODE_E0AE					;check for ladder
BEQ CODE_DBAC					;if no laddder, don't try to go down

JSR CODE_EAF7					;get some value to compare with RNG value
LDA DATA_C448,X					;
AND RNG_Value+1					;$19
BNE CODE_DBAC					;bits set, don't go down

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
CMP $0200					;if jumpman's higher than the barrel, always go down
BCS CODE_DBA3					;
CLC						;
ADC #$0F					;
CMP $0200					;uhh...
BCS CODE_DBAC					;check
  
CODE_DBA3:
LDA #$02                 
LDX $5D						;
STA $5E,X					;barrel state i think
DEC $68,X					;
RTS
  
CODE_DBAC:
LDA $00                  
JSR CODE_E090                
BEQ CODE_DBB6					;check if on lowest platform?
JMP CODE_DBE7
  
CODE_DBB6:
JSR CODE_DF40

LDX Barrel_CurrentIndex				;
LDA Barrel_CurrentPlatformIndex,X		;yes, check lowest platform
CMP #$01                 
BNE RETURN_DBED					;if not on lowest platform, return

JSR CODE_DFC3					;background priority

LDA $00						;check X-pos for oil barrel
CMP #$20					;
BEQ CODE_DBCD					;equal or less, spawn flame
BCC CODE_DBCD					;
RTS						;

CODE_DBCD:
LDA #$03                 
STA $02
 
LDA #$04                 
STA $03

JSR CODE_F08E					;draw something (barrel...)
    
LDA #$01					;set oil ablaze
STA $AD						;
    
LDA #$00					;remove the barrel
LDX $5D						;
STA $68,X					;

LDA #Sound_Effect_Hit				;hit sound
STA Sound_Effect				;
RTS						;

CODE_DBE7:
LDX $5D                  
LDA #$08                 
STA $5E,X
  
RETURN_DBED:
RTS						;

;Animate horizontal barrel
CODE_DBEE:
LDX Barrel_CurrentIndex				;get index (is it me, or doing so every call is unecessary?)
INC Barrel_AnimationTimer,X			;increase frame counter

LDA Barrel_AnimationTimer,X			;if more or equal [define], change frame
CMP #Barrel_AnimateFrames			;
BCS CODE_DBFB					;
RTS						;otherwise return

CODE_DBFB:
LDA #$00					;clear the timer
STA Barrel_AnimationTimer,X			;

LDA Barrel_CurrentPlatformIndex,X		;check which platform it's on     
AND #$01					;so we can roll it the other way
BEQ CODE_DC1B					;

LDA Barrel_GFXFrame,X				;calculate the frame to DO A BARREL ROLL
CLC						;
ADC #$04                 
CMP #Barrel_GFXFrame_UpLeft			;less than up-left?
BCC CODE_DC16					;set up-left
CMP #Barrel_GFXFrame_Vertical1			;if was bottom-left (with +4 that's Barrel_GFXFrame_Vertical1)
BCS CODE_DC16					;change to up-left
JMP CODE_DC2D					;otherwise just keep the addition

CODE_DC16:
LDA #Barrel_GFXFrame_UpLeft			;
JMP CODE_DC2D					;

;roll the other way
CODE_DC1B:
LDA Barrel_GFXFrame,X				;
SEC						;
SBC #$04					;
CMP #Barrel_GFXFrame_UpLeft			;
BCC CODE_DC2B					;set bottom-left from up-left
CMP #Barrel_GFXFrame_Vertical1			;
BCS CODE_DC2B					;not sure about this one...
JMP CODE_DC2D					;

CODE_DC2B:
LDA #Barrel_GFXFrame_BottomLeft			;

CODE_DC2D:
STA Barrel_GFXFrame,X				;calculated graphics frame
RTS						;

CODE_DC30:
LDA #$55                 
JSR CODE_DFE4                
BEQ RETURN_DC68                
JSR GetBarrelOAM_EFD5
STX $04
 
JSR EntityPosToScratch_EAEC
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
JSR GetBarrelOAM_EFD5
STX $04

JSR EntityPosToScratch_EAEC

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
JSR GetBarrelOAM_EFD5
STX $04

JSR EntityPosToScratch_EAEC

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
JSR GetBarrelOAM_EFD5
STX $04

JSR EntityPosToScratch_EAEC

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

CODE_DD6A:
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
JSR GetBarrelOAM_EFD5
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
JSR GetBarrelOAM_EFD5

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

CODE_DE13:
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
JSR GetBarrelOAM_EFD5
STX $04

JSR EntityPosToScratch_EAEC
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
JSR GetBarrelOAM_EFD5				;
STX $04						;

JSR EntityPosToScratch_EAEC

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

;hide barrel behind BG if low enough (so it goes behind the oil barrel)
CODE_DFC3:
LDX $5D    
LDA $68,X
CMP #$01
BNE RETURN_DFE3 

JSR GetBarrelOAM_EFD5				;
LDA OAM_X,X					;check barrel's X-pos, if it's close enough to the barrel
CMP #$30					;
BCS RETURN_DFE3					;

;set low priority (and keep it's palette of course)
LDA #$23					;
STA OAM_Prop,X					;
STA OAM_Prop+4,X				;
STA OAM_Prop+8,X				;
STA OAM_Prop+12,X				;
  
RETURN_DFE3:
RTS						;

CODE_DFE4:
STA $0A						;
STA $0B						;

;barrel-related
CODE_DFE8:
LDX Barrel_CurrentIndex				;
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
;$0B - platform index the player's on (or slightly above)

CODE_E016:
STA $0A						;
   
LDA PhaseNo					;get Y-positions for platforms depending on phase
SEC						;
SBC #$01					;
ASL A						;
TAX						;
LDA DATA_C493,X					;
STA $08						;
  
LDA DATA_C493+1,X				;
STA $09

LDY #$00					;
LDA #$01					;platform index = 1 by default
STA $0B						;

LOOP_E02F:
LDA ($08),Y					;
CMP #$FF					;
BEQ CODE_E041					;
CMP $0A						;check if at the same Y position OR below
BEQ CODE_E045					;
BCC CODE_E045					;
INC $0B						;
INY						;
JMP LOOP_E02F					;

CODE_E041:  
LDA #$07					;if encountered FF command, set highest (or lowest? platform)
STA $0B						;
  
CODE_E045:
LDA $0B						;
RTS						;

CODE_E048:
LDX $5D                  
LDA $5E,X                
CMP #$01                 
BNE ReturnA_E053+ReturnABranchDist		;CODE_E057

LDA $7D						;
BNE ReturnA_E053+ReturnABranchDist		;CODE_E057

;Load #$01
ReturnA_E053:
Macro_ReturnA $0C,$01				;more optimizations between revisions. now 0C isn't used to store value (simply load value and return)

;used by barrels
CODE_E05A:
STA $0C						;temporary store X-pos
  
LDX $5D						;
LDA Barrel_CurrentPlatformIndex,X		;get height
CMP #$01					;bottom platform?
BEQ CODE_E079					;
CMP #$06					;top platform?
BEQ CODE_E079					;

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

;Checks for ladders! if it should go down
CODE_E0AE:
STA $0C						;save X-pos

LDX Barrel_CurrentIndex				;
LDA Barrel_CurrentPlatformIndex,X		;check which platform it's on
CMP #$02					;second to last (lowest) platform
BEQ CODE_E0CB					;
CMP #$03					;3rd lowest...
BEQ CODE_E0CB					;
CMP #$04					;and so on
BEQ CODE_E0D1					;
CMP #$05					;
BEQ CODE_E0DD					;
CMP #$06					;highest platform
BEQ CODE_E0E9					;
JMP CODE_E0EC					;lowest platform (no ladders)
 
CODE_E0CB:
JSR CODE_E0F1                
JMP CODE_E0EC
  
CODE_E0D1:
JSR CODE_E0F1

;if not terminated by PLAs, means the barrel isn't at an X-pos where the ladder can be.
LDY #$89
CMP #$C4					;check if very far to the right
BEQ CODE_E109					;can disappear, maybe?
JMP CODE_E0EC					;not on the ladder is all that's clear
  
CODE_E0DD:           
JSR CODE_E0F1

LDY #$71                 
CMP #$B4					;check position where the barrel can fall down off the ledge (i think?)
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
LDA $0C						;check X-pos
LDY DATA_C172,X              
CMP DATA_C177,X              
BEQ CODE_E107

LDY DATA_C17C,X					;two different ladder positions?
CMP DATA_C181,X              
BEQ CODE_E107                
RTS

CODE_E107:
PLA						;terminate further barrel processing
PLA						;

CODE_E109:
LDX $5D
STY $A3,X
 
LDA #$01					;
  
CODE_E10F:
STA $0C						;output A - 0 = no ladder, 1 - yes ladder
RTS						;

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
INC $7E,X					;increase smth (mark as destroyed with a hammer?)

RETURN_E199:
RTS

CODE_E19A:
LDA Flame_State					;see if oil barrel flame is a thing
BNE CODE_E19F					;if so, run it's code
RTS						;

CODE_E19F:  
CMP #$01					;if not init, run main
BNE CODE_E1BF					;

;initalize oil flame (is it used multiple times (each time new flame is spawned)
LDA #Flame_XPos					;flame X-pos
STA $00						;

LDA #Flame_YPos					;y-pos
STA $01						;

LDA #Flame_GFXFrame_Frame1			;
STA $02						;

LDA #$12					;only 1 row 2 bytes wide
STA $03						;

LDA #Flame_OAM_Slot*4				;
JSR CODE_F080					;draw em

LDA #$02					;\
STA Flame_State					;/no more init, can run normally
JMP CODE_E1E0					;and flame animation ofc

CODE_E1BF:
LDA Timer_FlameAnimation			;don't animate for
BNE RETURN_E1E4					;

LDA #$03					;not sure what 3 does
STA Flame_State					;

;instead if using fixed address (like pretty much everything else) using X as index to offset OAM adress... mkay
LDX #Flame_OAM_Slot*4+1				;
LDA OAM_Y,X					;check sprite tile (not Y-pos!)
CMP #Flame_GFXFrame_Frame1			;check if was frame 1
BEQ CODE_E1D5					;change to frame 2

LDA #Flame_GFXFrame_Frame1			;and vice versa
JMP CODE_E1D7					;

CODE_E1D5:
LDA #Flame_GFXFrame_Frame2			;

CODE_E1D7:
STA OAM_Y,X					;not actual Y-pos due to offset, store sprite tiles
CLC						;
ADC #$01					;and next tile gets a +1
STA OAM_Y+4,X					;

CODE_E1E0:
LDA #Time_ForFlameAnim				;
STA Timer_FlameAnimation			;set timer

RETURN_E1E4:
RTS						;

;Run fire enemy AI and stuff
CODE_E1E5:
LDA #$00					;initialize flame enemy
STA FlameEnemy_CurrentIndex			;

LOOP_E1E9:
JSR GetFlameEnemyOAM_EFDD			;get OAM

LDA OAM_Y,X					;see if the enemy's on screen
CMP #$FF					;yes, run
BNE CODE_E225					;

LDA PhaseNo					;check for phase
CMP #Phase_25M					;25M - must come out of the barrel
BEQ CODE_E200					;
CMP #Phase_100M					;100M - appear out of thin air
BEQ CODE_E213					;
JMP CODE_E225					;flames appear in 75M, however they're already placed during init (they don't spawn during gameplay), so this jump never triggers

;flames appear in 25M
CODE_E200:
LDA Timer_FlameEnemySpawn			;flame appear timer...
BNE CODE_E228					;don't appear

LDA Flame_State					;there is no index 0?
BEQ CODE_E228					;
CMP #$02					;if not 2, return (what)
BNE CODE_E228					;

LDA #$19					;
STA Timer_FlameEnemySpawn			;
JMP CODE_E21F					;

;flames appear in 100M
CODE_E213:
LDA Timer_FlameEnemySpawn			;don't appear yet
BNE CODE_E228					;

JSR CODE_EAF7					;get difficulty
LDA DATA_C466,X					;
STA Timer_FlameEnemySpawn			;and set timer for next flame spawn

CODE_E21F:
LDA #FlameEnemy_State_SpawnINIT			;initialize flame enemy
LDX FlameEnemy_CurrentIndex			;
STA FlameEnemy_State,X				;

CODE_E225:
JSR CODE_E250					;run flame enemy's code!

CODE_E228:
LDX PhaseNo					;
DEX						;
INC FlameEnemy_CurrentIndex			;process next flame
LDA FlameEnemy_CurrentIndex			;
CMP DATA_C1F6,X					;check flame max
BEQ CODE_E237					;processed all
JMP LOOP_E1E9					;

CODE_E237:
LDA PhaseNo					;
CMP #Phase_75M					;75M - return
BEQ RETURN_E24F					;

LDA $3B						;initialize something?
BNE RETURN_E24F

LDA #$00                 
STA $D2                 
STA $D3                 
STA $D4                  
STA $D5

LDA #$BC                 
STA $3B

RETURN_E24F:
RTS

;handle flame enemies!
CODE_E250:  
LDX FlameEnemy_CurrentIndex			;
LDA FlameEnemy_State,X				;check for state

CODE_E254:
AND #$0F					;if flame enemy state isn't in range between 00-0F
BEQ CODE_E292					;just animate i think
CMP #FlameEnemy_State_SpawnINIT			;
BEQ CODE_E28F					;init spawn
CMP #FlameEnemy_State_SpawnFromOil		;
BEQ CODE_E28F					;actual spawn
CMP #FlameEnemy_State_MoveRight			;
BEQ CODE_E295					;move right i think
CMP #FlameEnemy_State_MoveLeft			;
BEQ CODE_E29A					;move left i think
CMP #$03					;
BEQ CODE_E2A1					;idk i think
 
LDA PhaseNo					;
CMP #Phase_75M					;if phase is 75M
BEQ CODE_E278					;pure RNG movement
JSR CODE_E2B6					;something else (must be RNG too?)
JMP CODE_E280					;facing

CODE_E278:
LDA RNG_Value+1,X				;facing depends on RNG
AND #$03					;
LDX FlameEnemy_CurrentIndex			;
STA FlameEnemy_State,X				;

CODE_E280:
LDA FlameEnemy_State,X				;
CMP #FlameEnemy_State_MoveRight			;
BEQ CODE_E28A					;
CMP #FlameEnemy_State_MoveLeft			;if NOT moving left
BNE CODE_E28C					;skip

CODE_E28A:
STA FlameEnemy_Direction,X			;decide direction for when standing still

CODE_E28C:
JMP CODE_E254					;process new state

CODE_E28F:
JMP CODE_E538					;handle flame enemy spawn

CODE_E292:
JMP CODE_E2F9					;move down and up when standing still (animation)

CODE_E295:
LDA #$00					;moving right
JMP CODE_E29C					;

CODE_E29A:
LDA #$01					;moving left

CODE_E29C:
STA FlameEnemy_MoveDirection			;
JMP CODE_E368					;process movenent and stuff

CODE_E2A1:
LDA PhaseNo					;check phase...
CMP #Phase_25M					;
BNE CODE_E2B3					;

JSR CODE_E626					;check for special state...
LDX FlameEnemy_CurrentIndex			;
LDA FlameEnemy_State,X				;
BNE CODE_E2B3					;
JMP CODE_E292					;animate
  
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
LDA #$55					;animate every x frames (still unsure how this works)
STA $0A						;
STA $0B						;

JSR CODE_E806					;
BNE CODE_E305					;
RTS						;

;animate when normally walking (move up 'n down graphically)
CODE_E305:
JSR GetFlameEnemyOAM_EFDD			;get flame's OAM slots
STX $04						;store em here
JSR EntityPosToScratch_EAEC			;
  
LDX FlameEnemy_CurrentIndex			;
LDA FlameEnemy_State,X				;
CMP #FlameEnemy_State_NoGFXShift		;
BNE CODE_E31A					;

LDA #FlameEnemy_State_GFXShiftDown		;
STA FlameEnemy_State,X				;
RTS						;

CODE_E31A:
CMP #FlameEnemy_State_GFXShiftUp		;
BEQ CODE_E323					;

DEC $01						;move down
JMP CODE_E325					;

CODE_E323:
INC $01						;

;i keep seeing the same repeated code, see CODE_E3ED. this one for animation when on the ladder
CODE_E325:
LDA $04						;OAM
TAY						;
INY						;get tile (not Y-pos)
LDA OAM_Y,Y					;
LDX PhaseNo					;
CPX #Phase_100M					;
BEQ CODE_E340					;
CMP #FlameEnemy_GFXFrame_Frame2			;
BEQ CODE_E33B					;

LDA #FlameEnemy_GFXFrame_Frame2			;
JMP CODE_E34B					;

CODE_E33B:
LDA #FlameEnemy_GFXFrame_Frame1			;
JMP CODE_E34B					;

CODE_E340:
CMP #FlameEnemy100M_GFXFrame_Frame2		;
BEQ CODE_E349					;

LDA #FlameEnemy100M_GFXFrame_Frame2		;
JMP CODE_E34B					;

CODE_E349:
LDA #FlameEnemy100M_GFXFrame_Frame1		;

CODE_E34B:
JSR SpriteDrawingPREP_StoreTile_EAD4		;

LDX FlameEnemy_CurrentIndex			;
LDA $B3,X					;something to do with direction i think
LSR A						;
JSR SpriteDrawingEngine_F096			;draw the flame enemy

LDX FlameEnemy_CurrentIndex			;
LDA FlameEnemy_State,X				;
CMP #FlameEnemy_State_GFXShiftUp		;don't shift next time
BEQ CODE_E363					;

LDA #FlameEnemy_State_GFXShiftUp		;
JMP CODE_E365					;
  
CODE_E363:
LDA #FlameEnemy_State_NoGFXShift		;
  
CODE_E365:
STA FlameEnemy_State,X				;
RTS						;

;something to do with flame enemies
CODE_E368:
LDA #$55					;
STA $0A						;also timing-related
STA $0B						;

JSR CODE_E806					;also time
BNE CODE_E374					;also run
RTS						;also also

CODE_E374:  
JSR GetFlameEnemyOAM_EFDD			;get OAM
STX $04						;temp store
JSR EntityPosToScratch_EAEC			;

LDA FlameEnemy_MoveDirection			;this is enemy's direction
BNE CODE_E385					;if moving left, mvoe left
     
INC $00						;move right
JMP CODE_E387					;
  
CODE_E385:
DEC $00						;move left

CODE_E387:   
LDA $00						;move up'n down at certain positions
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

;flame enemy animation...
CODE_E3CE:
LDA FlameEnemy_MoveDirection			;hardcoded check for ladder pos depending on direction
BEQ CODE_E3ED					;moving right, no worries

LDA $00						;if reached this position, make it climb the ladder (i think)
CMP #$0C                 
BEQ CODE_E3DD					;if at this position, make sure to think about moving further
BCC CODE_E3E6					;don't move if less, please turn away
JMP CODE_E3ED					;move freely

CODE_E3DD:  
LDA #$00					;set to stop movement & check for ladders?
LDX FlameEnemy_CurrentIndex			;
STA FlameEnemy_State,X				;
JMP CODE_E3ED					;

CODE_E3E6:
LDA #$00					;copy-paste code strikes back
LDX FlameEnemy_CurrentIndex			;
STA FlameEnemy_State,X				;
RTS						;

;another routine related with animation, CODE_E50C is similar to this
CODE_E3ED:
LDA $04						;
TAY						;
INY						;get sprite tile
LDA OAM_Y,Y					;
LDX PhaseNo					;if in 100M, use different frames
CPX #Phase_100M					;
BEQ CODE_E408					;
CMP #FlameEnemy_GFXFrame_Frame2			;standart animation procedure
BCS CODE_E403					;

LDA #FlameEnemy_GFXFrame_Frame2			;
JMP CODE_E413					;

CODE_E403:
LDA #FlameEnemy_GFXFrame_Frame1			;
JMP CODE_E413					;

CODE_E408:
CMP #FlameEnemy100M_GFXFrame_Frame2		;
BCS CODE_E411					;

LDA #FlameEnemy100M_GFXFrame_Frame2		;
JMP CODE_E413					;

CODE_E411:
LDA #FlameEnemy100M_GFXFrame_Frame1		;

CODE_E413:
JSR SpriteDrawingPREP_StoreTile_EAD4		;

LDA FlameEnemy_MoveDirection			;draw flip according to movement direction
JMP SpriteDrawingEngine_F096			;

CODE_E41B:
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
JSR GetFlameEnemyOAM_EFDD
STX $04                  
JSR EntityPosToScratch_EAEC
       
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

;some special state?
LDA #$13
LDX $AE
STA $AF,X

;animate da flame (AGAIN)
;this is pretty much a copy-paste of CODE_E3ED (with a few differences)
CODE_E50C:
LDA $04						;
TAY						;
INY						;get tile
LDA OAM_Y,Y					;
LDX PhaseNo					;check if from 100M
CPX #$04					;other sprite tiles
BEQ CODE_E527					;
CMP #FlameEnemy_GFXFrame_Frame2			;animate whichever flame
BCS CODE_E522					;

LDA #FlameEnemy_GFXFrame_Frame2			;pretty standart
JMP CODE_E532					;

CODE_E522:
LDA #FlameEnemy_GFXFrame_Frame1			;
JMP CODE_E532					;

CODE_E527:
CMP #FlameEnemy100M_GFXFrame_Frame2		;and animate 100M one ofc
BCS CODE_E530					;

LDA #FlameEnemy100M_GFXFrame_Frame2		;
JMP CODE_E532					;

CODE_E530:
LDA #FlameEnemy100M_GFXFrame_Frame1		;

CODE_E532:
JSR SpriteDrawingPREP_StoreTile_EAD4		;prep
JMP CODE_F088					;draw the flame

;handle special kinda flames
CODE_E538:
LDX FlameEnemy_CurrentIndex			;
LDA FlameEnemy_State,X				;
CMP #FlameEnemy_State_SpawnINIT			;spawn from oil barrel (init)
BEQ CODE_E548					;
CMP #FlameEnemy_State_SpawnFromOil		;
BEQ CODE_E545					;spawned from oil barrel
RTS						;untriggered (and unecessary, along with couple lines above

CODE_E545:
JMP CODE_E59F					;spawn from oil barrel

CODE_E548:
LDA PhaseNo					;how to spawn the flame enemy?
CMP #Phase_25M					;jump out of the oil barrel
BEQ CODE_E553					;
CMP #Phase_100M					;just appear
BEQ CODE_E564					;
RTS						;untriggered

;spawn a flame enemy from lit up oil barrel
CODE_E553:      
LDA #$20					;set initial positions
STA $00						;this is X-pos

LDA #$B8					;Y-pos
STA $01						;

LDX FlameEnemy_CurrentIndex			;
LDA #FlameEnemy_State_SpawnFromOil		;spawn from the oil barrel
STA FlameEnemy_State,X				;
JMP CODE_E592					;

CODE_E564:
LDA Jumpman_OAM_X				;check player's pos
CMP #$78					;
BCC CODE_E570					;

LDY #$00					;
JMP CODE_E572					;spawn at different positions (on the left)

;spawn flame enemies from 100M
CODE_E570:  
LDY #$08					;spawn on the right by default
  
CODE_E572:
STY $0C						;

LDA RNG_Value+1					;spawn x-pos and Y-pos seems to be RNG dependent
AND #$03					;
ASL A						;
CLC						;
ADC $0C						;spawn on the left or the right
TAX						;
LDA DATA_C3CE,X					;
STA $00						;X-pos

LDA DATA_C3CE+1,X				;
STA $01						;and Y-pos

LDX FlameEnemy_CurrentIndex			;
LDA #$00					;no init
STA FlameEnemy_State,X				;

LDA #FlameEnemy100M_GFXFrame_Frame1		;set initial frame
JMP CODE_E594					;

CODE_E592:  
LDA #FlameEnemy_GFXFrame_Frame1			;
  
CODE_E594:
JSR SpriteDrawingPREP_StoreTile_EAD4		;
JSR GetFlameEnemyOAM_EFDD			;get OAM
STA $04						;
JMP CODE_F082					;a new challenger approaches...

;the flame that jumps out of the oil barrel
CODE_E59F:  
JSR GetFlameEnemyOAM_EFDD			;get flame's proper OAM slots
STX $04						;
JSR EntityPosToScratch_EAEC			;and position

LDA OAM_Tile,X					;ok? (doesn't actually update the sprite tile number)
JSR SpriteDrawingPREP_StoreTile_EAD4		;

LDA PhaseNo					;
CMP #Phase_25M					;
BEQ CODE_E5B4					;
RTS						;untriggered, meaning this type of flame only runs in 25M (this could've worked for 50M maybe?)

CODE_E5B4:
INC $00						;move horizonrally
LDA $00						;
CMP #$2C					;when at certain position, start moving down
BEQ CODE_E5BE					;
BCC CODE_E5E5					;if less than, skip

;more than that pos also counts
CODE_E5BE:
INC $01						;move down
LDA $01						;
CMP #$C5					;
BNE CODE_E5E5					;

LDA #$00					;
LDX FlameEnemy_CurrentIndex			;
STA FlameEnemy_State,X				;become normal

DEC $00						;
LDA $00						;
CMP #$68					;
BCS CODE_E5D9					;

INC $01						;
JMP CODE_E5DB					;

CODE_E5D9:  
DEC $01						;unused, because flame becomes normal and doesn't execure anymore of this, meaning the check for this to run can't be triggered

CODE_E5DB:  
CMP #$60					;something else about X-pos (which is pointless)
BNE CODE_E5E5

LDX FlameEnemy_CurrentIndex			;untriggered & pointless (has become normal already)
LDA #$00					;
STA FlameEnemy_State,X				;

CODE_E5E5:
JMP CODE_F082					;draw da flame

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
LDX FlameEnemy_CurrentIndex
LDA FlameEnemy_State,X				;what is this check? to get to this, you need FlameEnemyState = 3, of course this always triggers
CMP #$13					;
BNE CODE_E62F					;
RTS						;

CODE_E62F:
JSR GetFlameEnemyOAM_EFDD
JSR EntityPosToScratch_EAEC

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

JSR GetFlameEnemyOAM_EFDD
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

;something about animating flame enemy
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
  STA $0C					;another unecessary store
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

;move the springboard
CODE_E981:
LDA #$00					;
STA Springboard_CurrentIndex			;initialize springboard counter (up to 3)

LOOP_E986:
LDA Springboard_CurrentIndex			;
JSR CODE_EFD7					;get OAM depending on which springboard is being run
TXA						;
CLC						;
ADC #$30					;and + 30
TAX						;
STX $04						;

JSR EntityPosToScratch_EAEC			;get x and y-pos
CMP #$FF					;if not even onscreen, try to spawn (?)
BEQ CODE_E9F0					;

;when in air
LDX Springboard_CurrentIndex			;
LDA $0446,X					;
CLC						;something to do with x-pos
ADC #$B0					;
CMP $00						;
BCC CODE_E9B4					;
 
LDA $01						;
CMP #$26					;
BCS CODE_E9BE					;also

LDA #Spring_GFXFrame_UnPressed			;
STA $02						;
JMP CODE_E9DA					;continue moving
  
CODE_E9B4:
JSR CODE_EA01                
CMP #$FF					;
BEQ CODE_E9F3					;don't run
JMP CODE_E9EA					;

;bounce off the platform
CODE_E9BE:
LDA #Spring_GFXFrame_Pressed			;
STA $02						;

LDA $01						;check Y-pos
CMP #$2E					;if higher than the platform
BCC CODE_E9DA					;continue moving

LDA #Sound_Effect_SpringBounce			;da bounce
STA Sound_Effect				;

LDA #$2E					;place the spring on the platform
STA $01						;

LDA Springboard_CurrentIndex			;
ASL A						;
TAX						;
LDA #$00					;
STA $042E,X					;

CODE_E9DA:
LDA $00						;move x-pos
CLC						;by two pixels
ADC #$02					;
STA $00						;

LDA Springboard_CurrentIndex			;
CLC						;
ADC #$01					;
JSR CODE_EF72					;update y-pos?
  
CODE_E9EA:
JSR CODE_EADB                
JMP CODE_E9F3
  
CODE_E9F0:
JSR CODE_EA34					;spawn a springboard (at least try to)
  
CODE_E9F3:
INC Springboard_CurrentIndex			;
LDA Springboard_CurrentIndex			;
CMP #$03					;
BEQ RETURN_EA00					;if all 3 springboards have been processed, return
JMP LOOP_E986					;loop

RETURN_EA00:
RTS						;

;move springboard straight down (when dropping)
CODE_EA01:
LDA $01						;
INC $01						;drop quickly
INC $01						;
INC $01						;
CMP #$26					;
BNE CODE_EA11					;

LDX #Sound_Effect_SpringFall			;only play dropping sound effect when reaching certain Y-pos
STX Sound_Effect				;

;animate at certain Y-positions
CODE_EA11:  
CMP #$50					;
BCC CODE_EA2A					;when reching 50, show pressed frame
CMP #$90					;
BCC CODE_EA2F					;when reaching 90, show pressed
CMP #$C0					;
BCC CODE_EA2A					;and so on
CMP #$D8					;
BCC CODE_EA2F					;

JSR SpriteDrawingPREP_Draw16x16_EAD1		;draw 16x16
JSR CODE_F094					;actually draw

LDA #$FF					;return FF
RTS						;

CODE_EA2A:
LDA #Spring_GFXFrame_Pressed			;
STA $02						;
RTS						;

CODE_EA2F:    
LDA #Spring_GFXFrame_UnPressed			;
STA $02						;
RTS						;

;spawn a springboard
CODE_EA34:
LDA Timer_KongSpawn				;if it isn't time to spawn, return
BNE RETURN_EA5E					;

LDA RNG_Value+1					;
AND #$03
TAX
LDA DATA_C1FF,X              
CLC
ADC #$10
LDX $0445					;get springboard's index
STA $0446,X					;x-pos is slightly randomized
STA $00

LDA #Spring_Spawn_YPos				;
STA $01						;

LDA #Spring_GFXFrame_Pressed
STA $02
  
JSR CODE_EADB					;yes, spawn
JSR CODE_EAF7

LDA DATA_C457,X              
STA $36
  
RETURN_EA5E:
RTS

;pauline related?
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
LDA #$50					;pauline's body x-pos
STA $00						;

LDA #$20					;and Y-pos
STA $01						;

LDA PaulineBody_OAM_Tile			;check pauline's frame
CMP #PaulineBody_GFXFrame_Frame2		;2?
BEQ CODE_EA88					;yes, change to frame 1
INC Pauline_AnimationCount			;count animation
 
LDA #PaulineBody_GFXFrame_Frame2		;
JMP CODE_EA8A					;
  
CODE_EA88:
LDA #PaulineBody_GFXFrame_Frame1		;
  
CODE_EA8A:
JSR SpriteDrawingPREP_StoreTile_EAD4		;update pauline's body

LDA #<PaulineBody_OAM_Y				;OAM adress, low byte
JSR CODE_F080					;draw pauline's body

LDA Pauline_AnimationCount			;animate 4 times
CMP #$04					;
BNE RETURN_EAA0					;return if didn't animate this much

LDA #$00					;
STA Pauline_AnimationCount			;

LDA #Time_PaulineAnim				;animate next time after this amount of frames
STA Timer_PaulineAnimation			;

RETURN_EAA0:
RTS						;

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

;CODE_EACD:
SpriteDrawingPREP_JumpmanOAM_EACD:
LDA #<Jumpman_OAM_Y				;get Jumpmans OAM sprite tile low byte for sprite update (indirect adressing)
STA $04						;

;CODE_EAD1:
SpriteDrawingPREP_Draw16x16_EAD1:		;pointless label, can just use JSR SpriteDrawingPREP_Draw16x16_2_EAD6.
JMP SpriteDrawingPREP_Draw16x16_2_EAD6		;

;prep routine for sprite drawing
;A - first sprite tile to draw

;CODE_EAD4
SpriteDrawingPREP_StoreTile_EAD4:
STA $02						;store tile

;CODE_EAD6:
;this label isn't even used, only for pointless jump above
SpriteDrawingPREP_Draw16x16_2_EAD6:
LDA #$22					;2 rows and 2 columns
STA $03						;
RTS						;

;i think this is used for entity spawning (barrels, springs and such)
;uses sprite drawing because it sets OAM positions and this game heavily relies on those for movement and stuff.
;EntitySpawn_EADB:
CODE_EADB:
JSR SpriteDrawingPREP_Draw16x16_EAD1		;16x16 sprite
JMP CODE_F082					;draw

;store Jumpman's positions to scrath RAM
;CODE_EAE1:

JumpmanPosToScratch_EAE1:
LDA Jumpman_OAM_X				;sprite tile X-position
STA $00						;

LDA Jumpman_OAM_Y				;sprite tile Y-position
STA $01						;
RTS						;

;same as above but for other entities
;CODE_EAEC:
EntityPosToScratch_EAEC:
LDA OAM_X,X					;entity's x-pos
STA $00						;

LDA OAM_Y,X					;y-pos
STA $01						;
RTS						;

;get speed index for various objects, to make it more difficult for the player
CODE_EAF7:
LDA GameMode					;check for Game B
AND #$01					;
CLC						;
ADC LoopCount					;and add loop counter
TAX						;
CPX #$04					;
BCC RETURN_EB05					;if it's more than 4, limit
  
LDX #$04					;maximum of speed values
  
RETURN_EB05:
RTS						;

CODE_EB06:
LDA Kong_AnimationFlag				;since this is always set to 1, it feels pointless
BNE CODE_EB0C					;
RTS						;since it's always 1, this can't be triggered

CODE_EB0C:
LDA $0505					;some bits...
AND #$0F                 
STA $0505

LDA PhaseNo					;
TAX						;
TAY
DEX
LDA DATA_C608,X
STA $00

LDA #$20                 
STA $01                  
TYA                      
CMP #$02					;check if phase value is less than 2 
BMI CODE_EB54					;go here
 
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

LDA Kong_TossToTheSideFlag			;if donkey should show "toss to the side" frame
BEQ CODE_EB6F					;NO???

JSR CODE_EBA1					;actually, yes

LDA #$00                 
STA Kong_TossToTheSideFlag			;play once

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

;various inputs for CODE_C815, which is kong related (basically load various graphical frames for donkey)
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

;show "toss the barrel to the side" frame
CODE_EBA1:
LDA #$00					;
JMP CODE_EBA8					;

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
LDA Timer_BonusScoreDecrease			;check bonus counter timer
BEQ CODE_EBBB					;if zero, decrease or kill player
RTS						;

CODE_EBBB:
LDA ScoreDisplay_Bonus				;check bonus counter
BNE CODE_EBC4					;if not zero, decrease bonus counter

LDA #Jumpman_State_Dead				;RIP
STA Jumpman_State				;
RTS						;

CODE_EBC4:
LDA #$0B					;restore timer
STA Timer_BonusScoreDecrease			;

LDA #$01					;substract 1 (hundred) from bonus counter
STA $00						;

LDA #$0A					;make substraction
STA $01						;
JSR CODE_F33E

LDA #$02
STA $00
JMP CODE_F23C

;run demo - initialization and movement
;CODE_EBDA:
RunDemoMode_EBDA:
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
BEQ DemoGetInput_EC16				;
   
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
RTS						;

;get next frame input for demo mode
;CODE_EC16:
DemoGetInput_EC16:
LDX Demo_InputIndex				;
LDA DemoTimingData_C028,X			;
STA Demo_InputTimer				;

LDA DemoInputData_C014,X			;get input/command
STA Demo_Input					;
INC Demo_InputIndex				;next input
RTS						;

CODE_EC29:
JSR JumpmanPosToScratch_EAE1			;

LDA #$4C					;
JSR CODE_EFE8					;for possible collision

LDA PhaseNo					;
CMP #Phase_75M					;
BEQ CODE_EC3B					;
CMP #Phase_25M					;
BNE CODE_EC3E					;
  
CODE_EC3B:
JSR CODE_EC44					;barrels?
  
CODE_EC3E:
JSR CODE_ED8A
JMP CODE_EDC5                

;check if Jumpman has jumped over a barrel to add score (not barrel only it seems)
CODE_EC44:
LDA #$00                 
STA $5D

CODE_EC48:
LDA #$3A
JSR CODE_C847
JSR GetBarrelOAM_EFD5

LDA PhaseNo					;interesting isn't it?
CMP #Phase_25M					;
BEQ CODE_EC5B					;
TXA						;what about barrels?
CLC						;
ADC #$30					;
TAX						;

CODE_EC5B:
JSR EntityPosToScratch_EAEC
JSR CODE_EFEF                
BNE CODE_ECA7					;if made a contact with the barrel, dead

LDA Jumpman_State
CMP #Jumpman_State_Jumping                 
BNE CODE_EC97					;if jumpman isn't jumping, don't check barrel

LDA Direction					;check if moving while jumping
AND #Input_Left|Input_Right			;
BNE CODE_EC76					;if se, execure this

LDA $9C						;calculated x pos i think
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
  
;player jumped over a barrel, spawn score 100 (p-sure it's also about the bolts removals in 100M)
LDA $00						;score's pos to player's
STA $05						;

LDA $01						;
STA $06						;

LDX #$00					;score index IIRC (so that's 100 score)
JSR CODE_CFC6					;give score
  
LDA #Sound_Fanfare_Score			;little fanfare
STA Sound_Fanfare				;
  
CODE_EC97:
INC $5D

LDA PhaseNo					;get phase
LSR A						;
TAX						;
LDA $5D						;
CMP DATA_C1FD,X
BEQ CODE_ECAF
JMP CODE_EC48

;jumpman contacted barrel (or other enemy) - DIE
CODE_ECA7:
JSR CODE_EF51					;no held hammer zone

LDA #Jumpman_State_Dead				;Jumpman is dead? Always have been.
STA Jumpman_State				;
RTS						;

;enemy destruction w/ hammer?
CODE_ECAF:
LDA PhaseNo					;if phase is 75M 
CMP #Phase_75M					;
BEQ RETURN_ECBE					;don't care about hammer

LDA Jumpman_State				;if holding a hammer
CMP #Jumpman_State_Hammer			;
BNE RETURN_ECBE					;no? return
JMP CODE_ECBF					;yeah yeah, run collision

RETURN_ECBE:
RTS						;

;check hammer<->hazard collision
CODE_ECBF:
LDA Jumpman_HeldHammerIndex			;are we holding a hammer?
BNE CODE_ECC6					;(answer - this check is reduntant)
JMP CODE_ED87					;untriggered

CODE_ECC6:
LDA Hammer_JumpmanFrame				;get hammer's state (wether it's up or down based on jumpman's position)
LSR A                    
LSR A                    
BEQ CODE_ECD1					;if it's down, check hitbox when it's down (duh)

LDA #$00					;UP
JMP CODE_ECD3					;
  
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
LDA Direction_Horz				;shift hammer's hitbox depending on jumpman's horizontal direction
CMP #Input_Right				;
BEQ CODE_ECF7					;

LDA Jumpman_OAM_X				;jumpman's x-pos - 10
SEC						;
SBC #$10					;
JMP CODE_ECFD					;for interaction?
  
CODE_ECF7:
LDA Jumpman_OAM_X				;jumpman's x-pos + 10
CLC						;
ADC #$10					;
  
CODE_ECFD:
STA $00						;scratch ram

LDA Jumpman_OAM_Y				;jumpman's y-pos
CLC						;
ADC #$06					;
STA $01						;
  
CODE_ED07:
LDA #$3C					;get hammer's hitbox
JSR CODE_EFE8					;

LDA PhaseNo					;
CMP #Phase_25M					;if we're NOT in 25M, that means can interact with flamies ONLY
BNE CODE_ED34					;

;check hammer<->barrel interaction
LDA #$00                 
STA Barrel_CurrentIndex

LOOP_ED16:
JSR GetBarrelOAM_EFD5				;
JSR EntityPosToScratch_EAEC			;

LDA #$3A					;
JSR CODE_C847					;get barrel's hit box

JSR CODE_EFEF					;collision
BNE CODE_ED57					;happened!

LDA Barrel_CurrentIndex				;
CLC						;
ADC #$01					;
STA Barrel_CurrentIndex				;next barrel (could've used INC... which is exactly what is used for flames!)
CMP #$09					;max barrels?
BEQ CODE_ED85					;no destruction
JMP LOOP_ED16					;

;check hammer<->flame enemy interaction
CODE_ED34:
LDA #$00                 
STA $AE
  
LOOP_ED38:
JSR GetFlameEnemyOAM_EFDD
JSR EntityPosToScratch_EAEC

LDA #$3A                 
JSR CODE_C847

JSR CODE_EFEF					;check collision
BNE CODE_ED57					;success!
 
INC FlameEnemy_CurrentIndex			;
LDA FlameEnemy_CurrentIndex			;
LDX PhaseNo					;
DEX						;
CMP DATA_C1F6,X					;went through all flames?
BEQ CODE_ED85					;no destruction
JMP LOOP_ED38					;loop

;enemy destruction (with a hammer)
CODE_ED57:
LDA #Sound_Effect2_EnemyDestruct		;sound ofc
STA Sound_Effect2				;
  
LDA $00						;not sure yet (X and Y-pos related)
STA $05						;

LDA $01						;
STA $06						;

LDA PhaseNo					;see if we've destroyed a barrel or a flanemy
CMP #Phase_25M					;
BNE CODE_ED74					;

LDA #$00					;
LDX Barrel_CurrentIndex				;
STA Barrel_CurrentPlatformIndex,X		;not on any platform (because destroyed)

LDA #$01					;yes destroying an enemy
JMP CODE_ED87					;

CODE_ED74:  
LDA #$10					;set up a short timer
STA Timer_FlameEnemySpawn			;

LDA #$00					;
LDX FlameEnemy_CurrentIndex			;
STA $E0,X					;some sprite tables for flame enemies (currently unknown)
STA $DB,X					;one of them must be platform index

LDA #$01					;yes destroying an enemy
JMP CODE_ED87					;

CODE_ED85:  
LDA #$00					;not destroying an enemy
  
CODE_ED87:
STA Hammer_DestroyingEnemyFlag			;
RTS						;

CODE_ED8A:
LDA #$00                 
STA $AE

LDA #$3A                 
JSR CODE_C847

LOOP_ED93:
JSR GetFlameEnemyOAM_EFDD			;
JSR EntityPosToScratch_EAEC			;get positions

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

;this is used to handle destroyed enemy animation.
CODE_EE1A:
LDA PhaseNo					;flame enemy destruction is in other phases
CMP #$01					;
BNE CODE_EE26					;makes sense, since the player can't normally destroy the flame enemy in 25M (too low)

JSR GetBarrelOAM_EFD5				;instead can destroy barrels
JMP CODE_EE29					;

CODE_EE26:
JSR GetFlameEnemyOAM_EFDD			;destroying flame enemy, get it's OAM slots
  
CODE_EE29:
STX $04						;save OAM slot

JSR EntityPosToScratch_EAEC

LDA EnemyDestruction_Animation			;did we play the destruction sound?
CMP #$01					;
BNE CODE_EE38					;if yes, skip

LDY #Sound_Effect2_EnemyDestruct		;enemy is destroyed
STY Sound_Effect2				;
  
CODE_EE38:
CMP #$0B					;
BEQ CODE_EE51					;if animation has ended, remove all traces

LDX EnemyDestruction_Animation			;
DEX						;
LDA DATA_C1EB+1,X				;show animation
STA $02						;
  
JSR CODE_EADB

LDX $04						;saved OAM slot
LDA #$02					;
JSR CODE_EE6C					;something something draw

INC EnemyDestruction_Animation			;next animation next frame
RTS						;

;remove destroyed enemy
CODE_EE51:
LDA PhaseNo					;if not phase value
CMP #Phase_25M					;
BNE CODE_EE5C					;don't set property (?)

LDA #$03					;do set property, thank you very much
JSR CODE_EE6C					;

CODE_EE5C:
JSR SpriteDrawingPREP_Draw16x16_EAD1		;
JSR CODE_F094					;

LDX #$02					;
JSR CODE_CFC6					;something else, idk (maybe set sprite tiles of destroyed enemy before destruction)

LDA #$00					;
STA EnemyDestruction_Animation			;
RTS						;

;set OAM tile property for 4 tiles
;X - OAM slot
CODE_EE6C:
STA OAM_Prop,X					;
STA OAM_Prop+4,X				;
STA OAM_Prop+8,X				;
STA OAM_Prop+12,X				;
RTS						;

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
LDA UNUSED_C5C1+1,X				;and since we load "fixed" value i don't think loading these as table values is necessary
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

JSR CODE_EF51					;remove hammer if being held

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

LDA UNUSED_C5C1+1,X              
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

;this code is used to remove the hammer Jumpman was holding
;RemoveHammer_EF51:
CODE_EF51:
LDA Jumpman_State				;if jumpman didn't have hammer, return 
CMP #Jumpman_State_Hammer			;
BNE RETURN_EF71					;

LDA Jumpman_HeldHammerIndex			;
BEQ RETURN_EF71					;might be a one frame thing (where it resets held index but not the state).
SEC						;-1 because starts from 1
SBC #$01					;TAX : DEX ftw
TAX						;
LDA #$00					;reset "can grab" flag
STA Hammer_CanGrabFlag,X			;
TXA						;
ASL A						;get proper OAM slot for hammers
ASL A						;
ASL A						;
TAX						;
LDA #$FF					;
STA Hammers_OAM_Y,X				;remove hammer
STA Hammers_OAM_Y+4,X				;part 2
  
RETURN_EF71:
RTS						;

;input:
;A - pointer for some adresses...

CODE_EF72:
STX $0F						;used to preserve x
ASL A
TAX                      
LDA $042C,X					;what are these addresses, speed related?
BNE CODE_EF94					;
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

LDA $01					;$01 is Jumpmans Y-pos (and some other other things
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
LDX $0F						;restore X
RTS						;

;this is used to get appropriate OAM slot for the enemies (barrels and flames)

;CODE_EFD5:
GetBarrelOAM_EFD5:
LDA Barrel_CurrentIndex				;get OAM slot depending on current barrel index

;GetSpringboardOAM_EFD7:
CODE_EFD7:
CLC						;input A - current springboard index
ADC #$03					;
JMP CODE_EFE2					;

;CODE_EFDD:
GetFlameEnemyOAM_EFDD:
LDA FlameEnemy_CurrentIndex			;get OAM depending on the flame that is currently being processed
CLC						;
ADC #$01					;

CODE_EFE2:
ASL A						;
ASL A						;
ASL A						;
ASL A						;
TAX						;
RTS						;

;must be collision-related
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

;i think this checks 4 sides...
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

;routines all leading to sprite tile drawing one, with various inputs
;this specific routine (CODE_F070) could've been used more...
CODE_F070:
STA $02						;
JSR JumpmanPosToScratch_EAE1			;get jumpman's positions into scrath RAM ($00 and $01)

CODE_F075:
JSR SpriteDrawingPREP_JumpmanOAM_EACD		;and other stuff, like OAM address itself (for indirect addressing)

CODE_F078:
LDA Direction_Horz				;something for horz dir
AND #$03					;why is this a thing? didn't we filter other inputs specifically for this address?
LSR A						;draw flipped or not
JMP SpriteDrawingEngine_F096			;start drawing

CODE_F080:
STA $04						;OAM low byte

CODE_F082:
LDA #$00					;
BEQ SpriteDrawingEngine_F096			;wow, so branches are a thing now?

CODE_F086:
STA $04						;OAM low byte

CODE_F088:
LDA #$01					;draw flipped
BNE SpriteDrawingEngine_F096			;

CODE_F08C:
STA $04						;

CODE_F08E:
LDA #$04					;
BNE SpriteDrawingEngine_F096			;

CODE_F092:
STA $03						;rows and columns n stuff

CODE_F094:
LDA #$0F

;This routine is used for sprite tile updates
;Input:
;A - currently unknown, drawing mode? 00 - unknown, normal? 01 - draw horizontally flipped, 04 - erase tiles, anything else - also erase???
;$00 - X-position of the first column (to the left)
;$01 - Y-position of the first row (the highest)
;$02 - first tile to start drawing from (e.g. 04 means draw tiles 04,05,06 and 07 if drawing 4 tiles)
;$03 - Rows and columns to draw (?)
;$04 - low byte of OAM address for indirect addressing.

;used addresses (aside from above ofc)
;$05 - high byte of OAM address for indirect addressing (always #$02)
;$06 - how many columns of tiles to draw
;$07 - rows
;$08 - total sprite tiles to draw

;CODE_F096:
SpriteDrawingEngine_F096:
;push a bunch of things, registers, some temp RAM and stuff
PHA					;
STA $0F					;input A into this

TXA					;
PHA					;save x

TYA					;
PHA					;save y

LDA $00					;save this
PHA					;

LDA $05					;and this
PHA					;

LDA $06					;you get the idea
PHA					;

LDA $07					;
PHA					;

LDA $08					;
PHA					;

LDA $09					;
PHA					;

LDA #>OAM_Y				;high byte for indirect addressing is always 02 (to get access to 0200 page, OAM)         
STA $05					;

LDA $0F					;check for erasing mode
CMP #$04				;
BEQ CODE_F0EF				;

LDA #$0F				;
AND $03					;
STA $07					;rows?
     
LDA $03					;
LSR A					;
LSR A					;
LSR A					;
LSR A					;
STA $06					;columns?
TAX					;
LDA #$00				;calculate from zero
CLC					;

LOOP_F0CB:       
ADC $07					;Rows * Columns (so if 2 columns and 2 rows thats a 4)
DEX					;
BNE LOOP_F0CB				;loop
STA $08					;get total OAM slots to draw
  
LDA $0F					;
BNE CODE_F0DC				;
JSR CODE_F11E				;normal drawing routine, i think
JMP CODE_F0E9				;

CODE_F0DC:   
CMP #$01                 
BEQ CODE_F0E6                
JSR CODE_F195				;erase tiles?
JMP CODE_F0F2

CODE_F0E6:
JSR CODE_F161				;

CODE_F0E9:
JSR CODE_F139				;positions
JMP CODE_F0F2				;end

CODE_F0EF:
JSR CODE_F10A

CODE_F0F2:
PLA					;restore all stuff (a lot!)
STA $09					;

PLA					;
STA $08					;

PLA					;
STA $07					;

PLA					;
STA $06					;

PLA					;
STA $05					;

PLA					;
STA $00					;

PLA					;
TAY					;

PLA					;
TAX					;

PLA					;
RTS					;

;remove some sprite tiles
CODE_F10A:
LDX $03					;in this case $03 isn't columns and rows but a number of tiles to remove (instead of $08 used in other routines)
LDY #$00				;

LOOP_F10E:
LDA #$FF
STA ($04),y				;Y-pos (remove sprite tile)
INY					;
INY					;
LDA $02					;
STA ($04),Y				;and props for some reason
INY					;
INY					;
DEX					;remove all tiles
BNE LOOP_F10E				;
RTS					;
  
CODE_F11E:
LDA $02					;load first tile
LDX $08					;how many tiles?
LDY #$01				;for sprite tile

LOOP_F124: 
STA ($04),Y				;
CLC					;
ADC #$01				;next sprite tile number
INY					;load property next
PHA					;and save A
LDA ($04),Y				;remove flip bits
AND #$3F				;
STA ($04),Y				;
PLA					;restore sprite tile num
INY					;next OAM slot
INY					;
INY					;
DEX					;untill all tiles are done
BNE LOOP_F124				;
RTS					;

;store sprite tile positions
CODE_F139:
LDY #$00

LOOP_F13B:        
LDX $06
LDA $01
STA $09

LOOP_F141:
LDA $09					;
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

;draw flipped
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
EOR #$40			;flip x!
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
;ClearOAM_F195:
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
;ClearScreen_F1B4:
CODE_F1B4:
LDA HardwareStatus				;write during V-blank                
LDA ControlMirror				;no sprite tile select  
AND #$FB					;
STA ControlBits					;

LDA #$20					;set initial VRAM drawing position
STA VRAMDrawPosReg				;

LDA #$00
STA VRAMDrawPosReg				;it's $2000

LDX #$04					;
LDY #$00                 
LDA #$24					;fill entire screen with tile 24

LOOP_F1CE: 
STA DrawRegister				;
DEY						;
BNE LOOP_F1CE					;
DEX						;
BNE LOOP_F1CE					;

LDA #$23					;clear attributes
STA VRAMDrawPosReg				;

LDA #$C0					;
STA VRAMDrawPosReg				;

LDY #$40					;
LDA #$00					;

LOOP_F1E5:
STA DrawRegister				;
DEY						;
BNE LOOP_F1E5					;
RTS						;

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
STA ControlBits					;
STA ControlMirror				;
PLA						;
ASL A						;shift again
BCC CODE_F20E					;if carry was set by shifting bit 6 (which should trigger repeated write)
ORA #$02					;set bit that'll go into carry when we shift everything back
INY						;

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
LSR $00						;
BCC CODE_F248					;
PHA						;
JSR CODE_F24E					;update/draw score counter
PLA						;

CODE_F248:
CLC						;
SBC #$00					;question-mark
BPL LOOP_F23F					;
RTS						;

CODE_F24E:  
ASL A						;*4 to get proper counter index (TOP, player 1, 2, bonus)
ASL A						;
TAY						;
STA $01						;

LDX BufferOffset				;load offset within buffer
LDA ScoreVRAMUpdData_C000,Y			;update which counter?
STA BufferAddr,X				;first byte  - VRAM location, low byte
JSR NextVRAMUpdateIndex_F32D			;

INY						;
LDA ScoreVRAMUpdData_C000,Y			;second byte - VRAM location, high byte
STA BufferAddr,X				;
JSR NextVRAMUpdateIndex_F32D			;

INY
LDA ScoreVRAMUpdData_C000,Y			;third byte - how many digits (tiles) to write (update)
AND #$87					;unsure
STA BufferAddr,X				;
AND #$07					;still unsure
STA $02						;how many digits
TXA						;
SEC						;
ADC $02						;
JSR NextVRAMUpdateIndex_CheckOverflow_F32F	;
TAX						;
STX BufferOffset				;

LDA #$00
STA BufferAddr,X				;ones/tens is always zero - there's no score bonus that adds from 1 to 99
INY						;
LDA ScoreVRAMUpdData_C000,Y			;load end command for score update after all digit bytes
STA $03						;
DEX						;
CLC						;

LOOP_F28E:  
LDA $0020,Y					;store byte's low digit
AND #$0F					;
BEQ CODE_F296					;
CLC						;

CODE_F296:
BCC CODE_F29A					;

;----------------------------------------------
;!UNUSED
;draw empty tiles instead of zeros, probably supposed to be for high digits, but it's unfinished and unused

LDA #$24
;----------------------------------------------
  
CODE_F29A:
STA BufferAddr,X				;
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
STA BufferAddr,X				;

LDA $03						;
AND #$01					;check for some bit
BEQ CODE_F2BE					;

;----------------------------------------------
;!UNUSED
;related with zero into empty tiles
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
;some code for unknown (unused) trigger bit
INX						;
LDY $01						;get counter
CLC						;
LDA $0020,Y					;
ADC #$37					;print platform part tiles? what this was for?
STA BufferAddr,X				;
;----------------------------------------------

RETURN_F2D6:
RTS						;

;This routine tosses stuff to upload to VRAM into buffer, using "row" format.
;first byte is number of rows and bytes per row (low nibble and high nibble respectively)
CODE_F2D7:
LDY #$00					;
LDA ($02),Y					;get first byte's low nibble - rows
AND #$0F					;
STA $05						;

LDA ($02),Y					;amount of bytes per-line
LSR A						;
LSR A						;
LSR A						;
LSR A						;
STA $04						;

LDX BufferOffset				;load buffer offset

LOOP_F2EA:
LDA $01						;VRAM locations are pre-set
STA BufferAddr,X				;high byte
JSR NextVRAMUpdateIndex_F32D			;

LDA $00						;
STA BufferAddr,X				;low byte
JSR NextVRAMUpdateIndex_F32D			;

LDA $04						;
STA $06						;
ORA #VRAMWriteCommand_DrawVert			;vertical drawing
STA BufferAddr,X				;

LOOP_F303: 
JSR NextVRAMUpdateIndex_F32D			;
INY						;
LDA ($02),Y					;
STA BufferAddr,X				;
DEC $06						;if transferred all bytes for current line, proceed...
BNE LOOP_F303					;

JSR NextVRAMUpdateIndex_F32D			;
CLC						;next vertical row in VRAM.
LDA #$01					;
ADC $00						;
STA $00

LDA #$00					;
ADC $01						;take high byte into account also
STA $01						;
STX BufferOffset				;next row index

DEC $05						;
BNE LOOP_F2EA					;if all rows were stored, exit

LDA #VRAMWriteCommand_Stop			;
STA BufferAddr,X				;
RTS						;

NextVRAMUpdateIndex_F32D:
;CODE_F32D:
INX						;next index...
TXA						;into A

NextVRAMUpdateIndex_CheckOverflow_F32F:
;CODE_F32F:
CMP #$3F					;check if we're updating too much (not to overflow into bit 6, which is a repeat bit)
BCC RETURN_F33D					;if not, return

LDX BufferOffset				;prevent further updates to glitches

LDA #VRAMWriteCommand_Stop			;put an end
STA BufferAddr,X				;
PLA						;\
PLA						;/terminate return from routine that called this one

RETURN_F33D:
RTS						;

;score addition routine, i think
CODE_F33E:
LDX #$FF
BNE CODE_F344

CODE_F342:   
LDX #$00

CODE_F344:
STX $04

LDX #$00
STX $05						;set scratch ram score addresses
STX $06                  
STX $07

LDA $01
AND #$08
BNE CODE_F355
INX						;if bit 3 isn't set, addition is done to tens/ones
  
CODE_F355:
LDA $00                  
STA $06,X

LDA $01						;load player information
JMP CODE_F35E					;ok???

CODE_F35E:
AND #$07					;only relevant bits for current player   
ASL A						;
ASL A						;get correct index for score RAM addresses
TAX                      
LDA $04						;if this address was not set, don't do some other addition (i shrug)
BEQ CODE_F38E

LDA $24,X                
BEQ CODE_F392

CODE_F36B:
CLC                      
LDA ScoreDisplay_CurPlayer+2,X                
STA $03

LDA $07                  
JSR CODE_F3E3                
STA ScoreDisplay_CurPlayer+2,X

LDA ScoreDisplay_CurPlayer+1,X                
STA $03

LDA $06                  
JSR CODE_F3E3                
STA ScoreDisplay_CurPlayer+1,X

LDA ScoreDisplay_CurPlayer,X                
STA $03

LDA $05
JSR CODE_F3E3
STA ScoreDisplay_CurPlayer,X
RTS

CODE_F38E:  
LDA $24,X			;some kinda update flag?
BEQ CODE_F36B
  
CODE_F392:
SEC                      
LDA ScoreDisplay_CurPlayer+2,X                
STA $03

LDA $07                  
JSR CODE_F404
STA ScoreDisplay_CurPlayer+2,X

LDA ScoreDisplay_CurPlayer+1,X                
STA $03

LDA $06                  
JSR CODE_F404
STA ScoreDisplay_CurPlayer+1,X

LDA ScoreDisplay_CurPlayer,X                
STA $03

LDA $05                  
JSR CODE_F404
STA ScoreDisplay_CurPlayer,X

LDA ScoreDisplay_CurPlayer,X                
BNE CODE_F3C0

LDA ScoreDisplay_CurPlayer+1,X                
BNE CODE_F3C0

LDA ScoreDisplay_CurPlayer+2,X                
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

LDA ScoreDisplay_CurPlayer+2,X                
JSR CODE_F404
STA ScoreDisplay_CurPlayer+2,X

LDA ScoreDisplay_CurPlayer+1,X                
JSR CODE_F404                
STA ScoreDisplay_CurPlayer+1,X

LDA ScoreDisplay_CurPlayer,X                
JSR CODE_F404 
STA ScoreDisplay_CurPlayer,X

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
JSR CODE_F426					;extract digits into separate adresses
SBC $01						;do some calculation for carry
STA $01						;
BCS CODE_F417					;
ADC #$0A					;
STA $01						;

LDA $02						;
ADC #$0F					;
STA $02						;

CODE_F417:
LDA $03						;
AND #$F0					;
SEC						;
SBC $02						;
BCS CODE_F423					;
ADC #$A0					;
CLC						;

CODE_F423:
ORA $01						;
RTS						;

;extract two digits into two bytes
;Input:
;A - Value to get digits from
;
;Output:
;$01 - low digit (00-0F)
;$02 - high digit (00-F0) 

CODE_F426:
PHA						;
AND #$0F					;
STA $01						;save low digit
PLA						;
AND #$F0					;and high digit
STA $02						;

LDA $03						;calculate low digit of value we're about to calculate
AND #$0F					;
RTS						;

;this code is used to calculate difference between player score(s) and TOP score to potentially replace it
;Input $00 - low nibble is player score offset (bits 0-2 ONLY), high nibble - TOP score offset (#$10 is added to it, so if it's #$F0 it'll result in #$00)
;low nibble bit 3 - run through 2 player scores (if not set, can be used for single player games)
;in this game only input is #$F9 which means TOP score offset is 0, and player score offset is 1 (to take 2 players into accounts, since it uses DEXes for next player check) + bit 3 set for 2 players
CODE_F435:
LDA #$00					;not quite sure what this is for yet
STA $04						;
CLC						;for next ADC

LDA $00						;Y - TOP score offset (can support multiple TOP scores?)
ADC #$10					;
AND #$F0					;
LSR A						;
LSR A						;
TAY						;
  
LDA $00						;X - players score offset
AND #$07					;
ASL A						;
ASL A						;
TAX						;

CODE_F44A:
LDA $0020,Y					;those unknown flags...
BEQ CODE_F4A0					;

LDA $24,X					;those unknown flags 2: electric boogaloo
BEQ CODE_F479					;

;compare player's score vs. TOP score
CODE_F453:
SEC                      
LDA ScoreDisplay_Top+2,Y              
STA $03

LDA ScoreDisplay_CurPlayer+2,X                
JSR CODE_F404

LDA ScoreDisplay_Top+1,Y              
STA $03

LDA ScoreDisplay_CurPlayer+1,X                
JSR CODE_F404

LDA ScoreDisplay_Top,Y              
STA $03

LDA ScoreDisplay_CurPlayer,X                
JSR CODE_F404 
BCS CODE_F4A4

LDA $0020,Y              
BNE CODE_F4A9
  
CODE_F479:
LDA #$FF                 
STA $04    
SEC						;carry set, means can overwrite TOP score

CODE_F47E:   
TYA						;something to do if there were multiple TOP scores? i'm not sure...
BNE RETURN_F49F					;
BCC CODE_F493					;

;store TOP score (if score is higher)
LDA $24,X					;still not sure what this is supposed to be
STA $20						;

LDA ScoreDisplay_CurPlayer,X			;
STA ScoreDisplay_Top				;

LDA ScoreDisplay_CurPlayer+1,X                
STA ScoreDisplay_Top+1

LDA ScoreDisplay_CurPlayer+2,X                
STA ScoreDisplay_Top+2
  
CODE_F493:
LDA $00						;check bit 3 (from input)
AND #$08					;
BEQ RETURN_F49F					;check for player 1 score?
DEX						;
DEX						;
DEX						;
DEX						;
BPL CODE_F44A					;
  
RETURN_F49F:
RTS						;

CODE_F4A0:
LDA $24,X                
BEQ CODE_F453
  
CODE_F4A4:
LDA $0020,Y              
BNE CODE_F479

CODE_F4A9:
CLC						;can't overwrite TOP score
BCC CODE_F47E					;

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

;one tile/attribute buffer update
;Input:
;$00, $01 - VRAM position for tile/attribute update
;Y - tile/attribute value
;CODE_F4C2:
VRAMUpdateSingle_F4C2:
LDX BufferOffset				;get current offest within buffer

LDA $01						;set VRAM position (low byte)
STA BufferAddr,X				;
JSR NextVRAMUpdateIndex_F32D			;next buffer byte

LDA $00						;
STA BufferAddr,X				;
JSR NextVRAMUpdateIndex_F32D			;

LDA #$01					;set a single byte update
STA BufferAddr,X				;
JSR NextVRAMUpdateIndex_F32D			;

TYA						;
STA BufferAddr,X				;store whatever was in Y as a tile/attribute we want to write
JSR NextVRAMUpdateIndex_F32D			;
      
LDA #VRAMWriteCommand_Stop			;put a stop (probably for now)
STA BufferAddr,X				;
STX BufferOffset				;store current offset for other potential tile updates
RTS						;

;the root of all evil in this game - RNG.
RNG_F4ED:
If Version = Gamecube
  JSR Gamecube_CODE_BFD0			;make RNG slower for one reason or another on gamecube version
  NOP						;
else
  LDA RNG_Value					;
  AND #$02					;
endif

STA $00						;
         
LDA RNG_Value+1					;
AND #$02					;
EOR $00						;
CLC						;
BEQ CODE_F4FD					;
SEC						;

CODE_F4FD:
ROR RNG_Value					;
ROR RNG_Value+1					;
ROR RNG_Value+2					;
ROR RNG_Value+3					;
ROR RNG_Value+4					;
ROR RNG_Value+5					;
ROR RNG_Value+6					;
ROR RNG_Value+7					;
RTS						;

;controller reading routine
;i've seen it before in Mario Bros. i assume it's used in most (if not all) early Nintendo NES titles.
;only beginning part and end are slightly different
;CODE_F50E:

ReadControllers_F50E:
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
LDY ControllerInput,X 
STY $00
STA ControllerInput,X
If Version = JP
  STA ControllerInput_Previous,X		;HMM...
endif              
AND #$FF                 
BPL CODE_F549               
BIT $00                  
BPL CODE_F549
AND #$7F

If Version = JP
  STA ControllerInput_Previous,X		;japenese version has a shorter input reading code. US adds some bit (probably related with 2 inputs at once, for example holding left+up won't make jumpman move left in rev 0)

JP_RETURN_F55B:
CODE_F549:
  RTS						;
else
CODE_F549:
  LDY ControllerInput_Previous,X
  STA ControllerInput_Previous,X                
  TYA                      
  AND #$0F                 
  AND ControllerInput_Previous,X                
  BEQ RETURN_F55A
  ORA #$F0
  AND ControllerInput_Previous,X
  STA ControllerInput_Previous,X

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
db $0F,$30,$12,$24				;tile 1

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
;CODE_FA48:

SoundEngine_FA48:
LDA #$C0
STA APU_FrameCounter				;don't generate IRQs
JSR CODE_FBF2					;play music/sound

LDX #$00					;reset sound values
STX Sound_Effect2				;
STX Sound_Effect				;
STX Sound_Fanfare				;
    
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

;get a bit into a bit number (bit 0-7)
;BitToNum_FA86:
CODE_FA86:
LDY #$07				;

CODE_FA88:
ASL A					;
BCS RETURN_FA8E				;
DEY					;
BNE CODE_FA88				;if there are still bits left, loop

;otherwise it's assumed that bit 0 is set

RETURN_FA8E:
RTS					;

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
LDA Sound_Music					;check if should play music
BNE CODE_FD0B					;init music?

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

LDA Sound_Music					;check if we're trying to play some music
BNE CODE_FD18					;yes we are
STA $06A3					;clear this mirror or w/e is this
BEQ CODE_FD58					;and play no music

CODE_FD18:  
EOR $06A3					;check if we're trying to play the same musc
BEQ CODE_FD35					;don't do anything

CODE_FD1D:
LDA Sound_Music					;initialize song and remember that we're playing this one
STA $06A3					;
JSR CODE_FA86					;

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
LDA Sound_Fanfare				;should we initialize some fanfare?
BNE CODE_FD62					;yes!

LDA Sound_FanfarePlayFlag			;continue playing fanfare?
BNE CODE_FD9B					;yes
RTS						;no, return

;initialize fanfare variables
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
STA Sound_FanfarePlayFlag				;do play fanfare plz

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
STA $F9						;
STA Sound_FanfarePlayFlag			;no more fanfare!

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