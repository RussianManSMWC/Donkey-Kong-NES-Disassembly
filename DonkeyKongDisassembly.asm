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
  AND #Input_Up					;check for Up on the D-pad - go from the first option to last
  ASL A						;
  ASL A						;
  ADC Cursor_OAM_Y				;
  RTS						;

  FILLVALUE $00					;the rest is $00
;after which a few more unused bytes
endif

org $C000
FILLVALUE $FF					;original game's free space is marked with FFs

;big tables block

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
DemoTimingData_C028:
db $DB,$60,$E2,$55
db $14,$20,$01,$F9
db $A0,$E0,$30,$10
db $10,$01,$50,$01
db $30,$D0,$FF,$FF				;after this it'll start taking garbage values, which should be impossible, unless you disable barrels

DATA_C03C:
dw Tilemap_DonkeyKong_SideToss_C63E		;\pointers to Kong's frames. this one is "toss to the side"
dw Tilemap_DonkeyKong_Stationary_C657		;/this one is simply stationary Donkey (default pose)
dw DATA_C6E1					;erase II if not in two player mode
dw DATA_C760					;erase various tiles for ending (part 1)

;various table pointers for the ending (erase tiles, draw some), combined with a table from above
DATA_C044:
dw DATA_C77D
dw DATA_C6E4
dw DATA_C6F1
dw DATA_C753
dw DATA_C708
dw DATA_C719					;init Donkey Kong's defeated frame (attributes & first frame)
dw Tilemap_DonkeyKong_Defeated1_C71C		;Defeated Kong frame 1
dw Tilemap_DonkeyKong_Defeated2_C735		;Defeated Kong frame 2
dw DATA_C74E

;other tables for 25M
dw DATA_C08C					;elevated platform data (25M)
dw DATA_C0CF					;platform ends for jumpman to fall off (25M)
dw DATA_C161					;broken ladder positions (25M)

;dynamic table that would be set in a routine that's not called anywhere (see UNUSED_D650)
UNUSED_C05C:
dw UnusedCollisionTable_0460

DATA_C05E:
dw Phase25MPlatforms_Hitboxes_C0C3		;25M platform collision dimensions
dw Phase25MGaps_Hitbox_C0DF			;25M fall area collision dimensions
dw BrokenLadder_Hitbox_C16E			;25M broken ladders' collision dimensions

;collision dimensions related to the dynamic table from above (also happens to be unused)
UNUSED_C064:
dw UNUSED_C2C4

DATA_C066:
dw MovingPlatform_Hitbox_C2C8			;moving platforms' hitbox (75M)
dw DATA_C186
dw HammerPickup_Hitbox_C1B0
dw DATA_C192
dw DATA_C1CF					;y-positions for barrel drop areas (onto lower platform)

dw DATA_C1D5					;tossed barrel platform y-positions to make it bounce off (pattern = Barrel_VertTossPattern_StraightDown)
dw UNUSED_C1DB					;tossed barrel platform y-positions to make it bounce off (pattern = Barrel_VertTossPattern_DiagonalRight)
dw DATA_C1E1					;tossed barrel platform y-positions to make it bounce off (pattern = Barrel_VertTossPattern_LeftAndRight)

dw DATA_C19E					;
dw DATA_C1E7					;

;MORE Background Donkey Kong Tilemaps
dw Tilemap_DonkeyKong_PickupBarrel_C60C		;
dw Tilemap_DonkeyKong_HitChestLeftHand_C670	;\chest hitting frames
dw Tilemap_DonkeyKong_HitChestRightHand_C689	;/Tilemap_DonkeyKong_HitChestRightHand_C689
dw Tilemap_DonkeyKong_HoldingBarrel_C625
;-----------------------------------------------------

dw Palette_FlameEnemy_Threatened_C6A2		;Pointer to Sprite Palette 2 (100M flame enemies when Jumpman is equipped with the hammer. turn blue by default)
dw EraseBuffer					;use RAM (buffer for misc tile erasing (bolts and pauline's items))
dw DATA_C18E
dw DATA_C196
dw Palette_FlameEnemy_C6A6			;Pointer to Sprite Palette 2 (flame enemies)

;data related with checking sloped (or elevated or whatever I'll call them the next day) surfaces (25M only)
;byte 1 - base x-pos for the lowest elevation
;byte 2 - base y-pos for the lowest elevation
;byte 3 - offset for the collision table for the entire platform, for small bits it's always 4
;byte 4 - x-offset between each elevation (-$18 is for platforms where elevation goes from right to left)
;byte 5 - number of bits to go through (if not counting 0)
;byte 6 - terminator if $FE, if not can be used to have different platform collisions on the same platform (which is the case with the lowest platform)
DATA_C08C:
db $00,$D8,$00,$00,$01,$00			;first platform has two types of hitboxes, a long one that extend from the very left of the screen, and then elevated bits
db $80,$D7,$04,$18,$06,$FE			;by the way, 6? there are clearly 5 elevated platforms...

db $C8,$BC,$04,-$18,$09,$FE			;from here on elevated only
db $20,$9E,$04,$18,$09,$FE
db $C8,$80,$04,-$18,$09,$FE
db $20,$62,$04,$18,$09,$FE
db $C8,$44,$04,-$18,$06,$FE
db $80,$28,$04,$00,$01,$FE			;the very last platform that marks the end of the level, which is a single platform with no elevations

;y-position of each platform (from highest point + 16 pixels), used to calculate platform index
;FF sets index to 7 (which is the lowest platform)
;Phase 1
DATA_C0BC:
db $BC,$9E,$80,$62,$44,$28,$FF

;collision "dimensions" for platforms for 25M. first 4 values are for an extended part of the lowest platform, last 4 are for small bits
;format: x-offset, y-offset, width, height
;really, only width matters in this case
Phase25MPlatforms_Hitboxes_C0C3:
DATA_C0C3:
db $00,$00					;\
db $80,$00					;/lowest platform extended part hitbox ($80 pixels wide)

db $00,$00
db $18,$00					;small platform bits, each higher than the previous ($18 pixels, which is 3 8x8 tiles long)

;platform collision "dimensions" that are unused? it's for 2 tile wide ones, but those still use 3 tile wide hitboxes (there's no handling for individual elevations, either all parts use 3 8x8 tiles or 2 8x8 hitbox)
;to be fair, you're blocked by the screen boundaries so you can't walk off these 2 tile elevations or go further than intended
UNUSED_C0CB:
db $00,$00
db $10,$00

;X, Y and table offset for platform end areas in 25M, if Jumpman walks off the ledge, he will fall
DATA_C0CF:
db $E0,$BC,$00
db $10,$9E,$00
db $E0,$80,$00
db $10,$62,$00
db $E0,$44,$00
db $FE

;collision dimensions for fall areas
;same format as before: x-offset, y-offset, width, height
Phase25MGaps_Hitbox_C0DF:
DATA_C0DF:
db $00,$00
db $10,$03

;X, Y and collision table offset for all ladders from 25M level
DATA_C0E3:
db $C8,$BC,$08
db $C8,$80,$04
db $B8,$74,$10
db $68,$58,$14
db $C8,$44,$04
db $60,$CF,$0C
db $70,$9B,$00
db $30,$9E,$04
db $50,$85,$08
db $80,$7D,$00
db $30,$62,$04
db $58,$60,$00
db $90,$28,$18
db $FE						;no more ladders

;varying hitboxes for ladders for 25M
;format: x-offset, y-offset, width, height
DATA_C10B:
db $00,$00,$08,$1D				;all ladders are 8 pixels wide
db $00,$00,$08,$17
db $00,$00,$08,$18
db $00,$00,$08,$09
db $00,$00,$08,$0B
db $00,$00,$08,$07
db $00,$00,$08,$19

;ladder top positions for 25M level (broken ladders can't be climbed down from the top)
DATA_C127:
db $C8,$BC,$00
db $70,$9B,$00
db $30,$9E,$00
db $C8,$80,$00
db $80,$7D,$00
db $30,$62,$00
db $58,$60,$00
db $C8,$44,$00
db $90,$28,$00
db $FE

;top of the ladder hitbox. used to check where the player can go down the ladder and where the player's animation for climbing on top plays
DATA_C143:
db $00,$00
db $08,$0D

;Jumpman's animation frames when climbing on top of the platform
;Jumpman_GFXFrame_ClimbingFlipped - draw Jumpman_GFXFrame_Climbing with horz flip
DATA_C147:
db Jumpman_GFXFrame_Climbing,Jumpman_GFXFrame_Climbing
db Jumpman_GFXFrame_ClimbingFlipped,Jumpman_GFXFrame_ClimbingFlipped
db Jumpman_GFXFrame_ClimbPlat_Frame1,Jumpman_GFXFrame_ClimbPlat_Frame1
db Jumpman_GFXFrame_ClimbPlat_Frame2,Jumpman_GFXFrame_ClimbPlat_Frame2
db Jumpman_GFXFrame_ClimbPlat_Frame1,Jumpman_GFXFrame_ClimbPlat_Frame1
db Jumpman_GFXFrame_Climbing,Jumpman_GFXFrame_Climbing
db Jumpman_GFXFrame_ClimbPlat_IsOn,Jumpman_GFXFrame_ClimbPlat_IsOn

;most likely placeholder for in case more frames are needed for climbing animation (or they were intending to show these frames earlier?)
UNUSED_C155:
db Jumpman_GFXFrame_ClimbPlat_IsOn
db Jumpman_GFXFrame_ClimbPlat_IsOn
db Jumpman_GFXFrame_ClimbPlat_IsOn
db Jumpman_GFXFrame_ClimbPlat_IsOn

;this data is used to animate jumpman when climbing the ladder.
DATA_C159:
db Jumpman_GFXFrame_Climbing,Jumpman_GFXFrame_Climbing,Jumpman_GFXFrame_Climbing
db Jumpman_GFXFrame_ClimbingFlipped,Jumpman_GFXFrame_ClimbingFlipped,Jumpman_GFXFrame_ClimbingFlipped

;placeholder for above?
UNUSED_C15F:
db $00,$00

;broken ladder positions
DATA_C161:
db $60,$B7,$00					;those $00's don't matter (they're supposed to offset collision table, but there's only one hitbox for all broken ladders)
db $50,$7B,$00
db $B8,$5C,$00
db $68,$40,$00
db $FE

;hitbox dimensions for broken ladders. in this order: left, top, right, bottom (so the last two are width and height respectively)
BrokenLadder_Hitbox_C16E:
db $00,$00
db $08,$18

;ladder end destination for the barrels when they move down said ladder (first ladder to check)
DATA_C172:
db $CA,$A7,$8E,$6B,$51

;x-position of the ladder that the barrel can mode down (first ladder check)
DATA_C177:
db $5C,$2C,$4C,$2C,$64

;ladder destination for the barrels when they can move down the ladder (second ladder to check)
DATA_C17C:
db $C6,$AA,$8C,$6D,$4D				;y-positions that the barrel should reach to change from going down the ladder state to normal horizontal movement state (???)

;x-positions where the barrel can move down a ladder (once again, it's the second ladder check)
DATA_C181:
db $C4,$6C,$7C,$54,$C4

;these are jumpman's hitbox dimensions for platforms and ladders in 25M level (so he is correctly offset & interacts with environment)
;x-disp, y-disp, width, height
;8 pixels to the right, whopping 17 pixels down... and it's 10 pixels wide and 17 pixels tall?
;yes
;Jumpman_TileHitbox_C186:
DATA_C186:
db $08,$11
db $0A,$11

;unused table similar to above, which is vertically closer to jumpman by 1px
;doesn't have a pointer entry
;Jumpman_TileHitboxUNUSED_C18A:
UNUSED_C18A:
db $08,$10
db $0A,$11

;same as above, but used when jumpman is jumping/falling
;only difference is it's closer to jumpman on y-axis by TWO pixels!
;Jumpman_TileHitboxWhenAirborn_C18E:
DATA_C18E:
db $08,$0F
db $0A,$11

DATA_C192:
db $05,$01,$0C,$09

DATA_C196:
db $05,$05,$0A,$0A

UNUSED_C19A:
db $08,$10,$08,$10

DATA_C19E:
db $04,$04,$0C,$0D

;jumpman's animation frames for when holding a hammer
Jumpman_HammerWalkingAnimFrames_C1A2:
db Jumpman_GFXFrame_Walk2_HammerUp
db Jumpman_GFXFrame_Stand_HammerUp
db Jumpman_GFXFrame_Walk1_HammerUp
db Jumpman_GFXFrame_Walk2_HammerDown
db Jumpman_GFXFrame_Stand_HammerDown
db Jumpman_GFXFrame_Walk1_HammerDown

;platform heights at which the hammer can be grabbed
DATA_C1A8:
db $03,$05					;Phase 1
db $02,$03					;unused Phase 2 (seems to match the Arcade version's hammer positions)
db $00,$00					;Phase 3 doesn't have hammers
db $03,$04					;Phase 4

;hitbox dimensions for the hammer when it can be grabbed by the player
HammerPickup_Hitbox_C1B0:
db $00,$00
db $08,$08					;8 by 8 pixels

;boundary positions
DATA_C1B4:
db $10,$E0
db $10,$E0					;unused because there's no Phase 2
db $0C,$E0
db $08,$E8

;table representing each bit value
DATA_C1BC:
db $01,$02,$04,$08,$10,$20,$40,$80

;25m's platform shift x-positions used for barrels and flame enemies (to determine if they should go up or down the elevations)
DATA_C1C4:
db $13,$30,$48,$60,$78,$90,$A8,$C0,$E0

;edge x-positions for barrels to drop from to the lower platform (in case didn't go down any ladders)
DATA_C1CD:
db $13,$DB

;Y-posisions for the falling barrel to check for to know where the platforms are to land on (when falling off a higher platform)
DATA_C1CF:
db $4C,$6A,$88,$A6,$C5,$FE

;Y-posisions for the falling barrel to check for to know where the platforms are to bounce off (tossed by DK)
;this is for a straight moving one
DATA_C1D5:
db $53,$6B,$8F,$A7,$CA,$FE

;these y-position values are for an unused diagonal-moving pattern
UNUSED_C1DB:
db $52,$6E,$8C,$AC,$C5,$FE

;and lastly, the left and right moving one
DATA_C1E1:
db $52,$6C,$8E,$A8,$CA,$FE

DATA_C1E7:
db $00,$06,$08,$08				;hmm...

;a lonely value that could've been directly loaded with LDA #$xx, but noooooooooo, it has to be a 1 byte table
DATA_C1EB:
db $19

;enemy destruction frames (by hammer)
EnemyDestructionAnimationFrames_C1EC:
db EnemyDestruction_Frame1
db EnemyDestruction_Frame2
db EnemyDestruction_Frame1
db EnemyDestruction_Frame2
db EnemyDestruction_Frame1
db EnemyDestruction_Frame2
db EnemyDestruction_Frame3
db EnemyDestruction_Frame4
db EnemyDestruction_Frame4
db EnemyDestruction_Frame4

;contains maximum amount of flame enemies that can be processed per-phase
;MaxNumberOfFlameEnemies_C1F6:
DATA_C1F6:
db $02,$04,$02,$04				;2 in 25M and 75M, 4 in 50M (unused) and 100M

;this table stores which platform marks the end of the phase when Jumpman reaches it
;PhaseCompletePlatformIndex_C1FA:
DATA_C1FA:
db $07,$05,$07					;for first 3 phases, with phase 2 obviously being unused

;max amount of entitites
DATA_C1FD:
db $09,$03

;springboards x-pos when spawned (RNG dependent)
DATA_C1FF:
db $00,$00,$04,$08

UNUSED_C203:
db $01,$02,$03,$04

;bonus score values (hundreds)
;InitialBONUSScore_C207:
DATA_C207:
db $50,$60,$70,$80

UNUSED_C20B:
db $90						;unused bonus score counter value, it's capped at 8000.

;X/Y coordinates and collision data offset for all of 75M's platforms (collision data is at DATA_C252)
DATA_C20C:
db $0E,$D8,$18
db $0E,$C8,$04
db $86,$C8,$04
db $A6,$C0,$00
db $BE,$B8,$00
db $D6,$B0,$04
db $4E,$B0,$04
db $0E,$A0,$04
db $DE,$A0,$00
db $C6,$98,$00
db $AE,$90,$00
db $96,$88,$14
db $C6,$78,$0C
db $0E,$70,$04
db $46,$70,$08
db $8E,$68,$04
db $AE,$60,$00
db $C6,$58,$00
db $DE,$50,$00
db $66,$40,$10
db $86,$28,$00
db $FE

DATA_C24C:
db $B0,$78,$60,$40,$28,$FF

;hitboxes for 75M's platforms, only really contains widths
DATA_C252:
db $00,$00,$14,$00
db $00,$00,$1C,$00
db $00,$00,$24,$00
db $00,$00,$2C,$00
db $00,$00,$54,$00
db $00,$00,$12,$00
db $00,$00,$E4,$00

;X/Y coordinates and collision data offset for all of 75M's ladders (collision data is at DATA_C28D)
DATA_C26E:
db $18,$A0,$0C
db $20,$70,$10
db $50,$70,$14
db $60,$70,$14
db $98,$68,$08
db $C8,$78,$08
db $E0,$A0,$00
db $E0,$50,$0C
db $B0,$40,$08
db $90,$28,$04
db $FE

;hitboxes for ladders
DATA_C28D:
db $00,$00,$08,$10
db $00,$00,$08,$18
db $00,$00,$08,$20
db $00,$00,$08,$28
db $00,$00,$08,$30
db $00,$00,$08,$40

;ladder top positions for 75M level
DATA_C2A5:
db $18,$A0,$00
db $20,$70,$00
db $50,$70,$00
db $60,$70,$00
db $98,$68,$00
db $C8,$78,$00
db $E0,$A0,$00
db $E0,$50,$00
db $B0,$40,$00
db $90,$28,$00
db $FE

;collision/hitbox/what have you dimensions for... something.
UNUSED_C2C4:
db $04,$01
db $1B,$0E

;hitbox dimensions for moving platforms (75M)
MovingPlatform_Hitbox_C2C8:
db $00,$01
db $12,$01				;$12 (decimal 18) pixels wide, only 1 pixel high

;OAM slots for moving platforms from phase 2 (75M)
MovingPlatform_OAMSlots_C2CC:
db (PlatformSprite_OAM_Slot*4)
db (PlatformSprite_OAM_Slot*4)+8
db (PlatformSprite_OAM_Slot*4)+16
db (PlatformSprite_OAM_Slot*4)+24
db (PlatformSprite_OAM_Slot*4)+32
db (PlatformSprite_OAM_Slot*4)+40

;indexes between the first ladder and the last ladder to check on the same platform (for flame enemies)
DATA_C2D2:
db $00						;this single byte is actually unused
db $00,$09,$15,$18

UNUSED_C2D7:
db $00						;and this last one I guess

;ladder check stuff for flame enemies (75M)
;First Byte - Ladder's X-position, second byte - ladder's vertical end point, third byte - a state the flame enemy enters when at the position (climb up or down the ladder)
DATA_C2D8:
db $4C,$5F,FlameEnemy_State_LadderUp
db $5C,$5F,FlameEnemy_State_LadderUp
db $C4,$67,FlameEnemy_State_LadderUp
db $4C,$9F,FlameEnemy_State_LadderDown
db $5C,$9F,FlameEnemy_State_LadderDown
db $C4,$87,FlameEnemy_State_LadderDown
db $DC,$3F,FlameEnemy_State_LadderUp
db $DC,$67,FlameEnemy_State_LadderDown

;X/Y coordinates and collision data offset for all of 100M's platforms (collision data is at DATA_C306)
DATA_C2F0:
db $06,$D8,$00
db $06,$B8,$00
db $16,$90,$04
db $1E,$68,$08
db $26,$40,$0C
db $FE

DATA_C300:
db $B8,$90,$68,$40,$28

UNUSED_C305:
db $FF

;all different platform hitboxes for 100M (again, only width matters)
DATA_C306:
db $00,$00,$F5,$00
db $00,$00,$D5,$00
db $00,$00,$C5,$00
db $00,$00,$B5,$00

;X/Y coordinates and collision data offset for all of 100M's ladders (collision data is at DATA_C341)
DATA_C316:
db $10,$B8,$00
db $78,$B8,$00
db $E8,$B8,$00
db $18,$90,$04
db $60,$90,$04
db $98,$90,$04
db $E0,$90,$04
db $20,$68,$04
db $80,$68,$04
db $D8,$68,$04
db $28,$40,$04
db $48,$40,$04
db $B0,$40,$04
db $D0,$40,$04
db $FE

;only two different ladder heights
DATA_C341:
db $00,$00,$08,$20
db $00,$00,$08,$28

;Ladder top positions for 100M level
DATA_C349:
db $10,$B8,$00
db $78,$B8,$00
db $E8,$B8,$00
db $18,$90,$00
db $60,$90,$00
db $98,$90,$00
db $E0,$90,$00
db $20,$68,$00
db $80,$68,$00
db $D8,$68,$00
db $28,$40,$00
db $48,$40,$00
db $B0,$40,$00
db $D0,$40,$00
db $FE

;indexes between the first ladder and the last ladder to check on the same platform
DATA_C374:
db $00,$09,$1E,$33,$48,$54

DATA_C37A:
db $0C,$A7,FlameEnemy_State_LadderUp
db $74,$A7,FlameEnemy_State_LadderUp
db $E4,$A7,FlameEnemy_State_LadderUp
db $0C,$C7,FlameEnemy_State_LadderDown
db $74,$C7,FlameEnemy_State_LadderDown
db $E4,$C7,FlameEnemy_State_LadderDown
db $14,$7F,FlameEnemy_State_LadderUp
db $5C,$7F,FlameEnemy_State_LadderUp
db $94,$7F,FlameEnemy_State_LadderUp
db $DC,$7F,FlameEnemy_State_LadderUp
db $1C,$57,FlameEnemy_State_LadderUp
db $7C,$57,FlameEnemy_State_LadderUp
db $D4,$57,FlameEnemy_State_LadderUp
db $14,$A7,FlameEnemy_State_LadderDown
db $5C,$A7,FlameEnemy_State_LadderDown
db $94,$A7,FlameEnemy_State_LadderDown
db $DC,$A7,FlameEnemy_State_LadderDown
db $24,$2F,FlameEnemy_State_LadderUp
db $44,$2F,FlameEnemy_State_LadderUp
db $AC,$2F,FlameEnemy_State_LadderUp
db $CC,$2F,FlameEnemy_State_LadderUp
db $1C,$7F,FlameEnemy_State_LadderDown
db $7C,$7F,FlameEnemy_State_LadderDown
db $D4,$7F,FlameEnemy_State_LadderDown
db $24,$57,FlameEnemy_State_LadderDown
db $44,$57,FlameEnemy_State_LadderDown
db $AC,$57,FlameEnemy_State_LadderDown
db $CC,$57,FlameEnemy_State_LadderDown

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

;gap edge x positions in 100M, to prevent flame enemies from walking off
DATA_C3DE:
db $34,$AC
db $44,$BC

DATA_C3E2:
db $05,$03
db $0D,$0B

;platform edges where the flame enemies will stop moving, 25M, second platform
DATA_C3E6:
db $D4,$0C

;platform edges where the flame enemies will stop moving, 25M, first platform (at the very bottom)
DATA_C3E8:
db $E4,$0C

;platform edges, 75M, platform level 2, left platform
DATA_C3EA:
db $5D,$4B

;platform edges, 75M, platform level 2, right platform
DATA_C3EC:
db $CD,$C3

DATA_C3EE:
db $5D,$43

DATA_C3F0:
db $E5,$C3

DATA_C3F2:
db $ED,$03

;16-bit ladder movement update frequency for flame enemies, bitwise (bit set - move, otherwise don't), 25M
;first entry is for moving up the ladder, the second is moving down (moving down is faster)
DATA_C3F4:
dw %0100100100100100			;update every 3 frames with one exception of 4 frames
dw %0111011101110111			;don't update every 4th frame

;db $24,$49,$77,$77

;16-bit ladder movement update frequency for flame enemies, bitwise (bit set - move, otherwise don't), 100M
;same deal as above table
DATA_C3F8:
dw %0111011101110111
dw %1111111111111111

;db $77,$77,$FF,$FF

;x-positions, at which the y-position of the barrel gets affected during its bounce when it lands on a lower platform
;when bouncing to the right
DATA_C3FC:
db $0B,$0C,$0D,$15,$16,$17,$18,$19
db $1A,$1E,$1F

;y-position "speeds" for bouncing barrel's motion
DATA_C407:
db $FF,$FF,$FF
db $01,$01,$01,$01
db $FF,$FF
db $01,$01

;x-positions, at which the y-position of the barrel gets affected during its bounce when it lands on a lower platform
;when bouncing to the left
DATA_C412:
db $E4,$E3,$E2,$D8,$D7,$D6,$D5,$D4
db $D3,$D0,$CF

DATA_C41D:
db $48,$84,$C0

DATA_C420:
db $50,$8D,$C7

;x and y positions for misc. hitboxes
DATA_C423:
db $20,$C0					;oil barrel's flame
db $78,$60					;phase 2 isn't real, phase 2 can't hurt you (unused)
db $28,$44					;top-left lift end for the lifts that go upward (there's a special check and individual x/y offsets for the bottom-right one that aren't in a table)
db $6B,$20					;DK's hitbox pos

;misc. hitbox dimension pointers
DATA_C42B:
dw DATA_C433					;oil barrel flame hitbox (even if it hasn't been lit)
dw UNUSED_C437					;phase 2? never heard about such a thing
dw DATA_C43B					;lift ends
dw DATA_C43F					;DK

;remember format:
;offsets for top-left hitbox corner (X, Y)
;offsets for bottom-right hitbox corner (X, Y), basically width and height
DATA_C433:
db $00,$00					;are these values non-zero somewhere, or are these basically a waste?
db $10,$08					;width, height

UNUSED_C437:
db $00,$00
db $10,$08

DATA_C43B:
db $00,$00
db $60,$10					;huh, it's that long? that explains why you can land on the left side of the lowest platform (and safely walk on the bottom-left lift end since it lacks a hitbox), but you die when you try to jump over the bottom-right lift

DATA_C43F:
db $00,$00
db $2A,$20

;table used for barrel throw timer setting (based on difficulty)
CODE_C443:
db $B0,$A0,$78,$68,$68

DATA_C448:
db $88,$88,$88,$88,$88

;vertical barrel toss timings for DK (based on difficulty)
;DKVerticalBarrelTossTimes_C44D:
DATA_C44D:
db $48,$38,$28,$18,$18

;unused times, also based on difficulty I assume (related to the scrapped 50M?)
UNUSED_C452:
db $BB,$BB,$5E,$2F,$13

;timer for the next springboard spawn, based on difficulty
;SpringboardSpawnTimes_C457:
DATA_C457:
db $88,$78,$64,$56,$49

;timings for moving platforms, move every x-frames based on difficulty (bit set - move)
;MovingPlatformUpdateFrequency1_C45C:
DATA_C45C:
db %10001000,%10001000,%00100100,%01010101,%01010101

;second set of bits for above
;MovingPlatformUpdateFrequency2_C461:
DATA_C461:
db %10001000,%10001000,%01001001,%01010101,%01010101

;number of frames between each flame enemy spawn for 100M, based on difficulty
;100MFlameEnemySpawnTimes_C466:
DATA_C466:
db $40,$20,$10,$08,$01

;hitboxes for platform collision on which the jumpman can stand on
UNUSED_C46B:
dw DATA_C08C					;25M (different collision and uses different tables)
dw DATA_C20C					;50M that totally exists in NES Donkey Kong (no it doesnt)

DATA_C46F:
dw DATA_C20C					;platform hitboxes of 75M
dw DATA_C2F0					;100M

UNUSED_C473:
dw DATA_C0C3					;again, 25M uses a different platform collision detection thanks to the platforms DK whrecked
dw DATA_C20C					;50M that totally doesnt exist in NES Donkey Kong (yes it doesnt, don't look that up)

DATA_C477:
dw DATA_C252
dw DATA_C306

;pointers for ladder bottom hitbox positions and collision offsets
DATA_C47B:
dw DATA_C0E3					;25M
dw DATA_C20C					;50M
dw DATA_C26E					;75M
dw DATA_C316					;100M

;various ladder bottom hitboxes per phase
DATA_C483:
dw DATA_C10B
dw DATA_C20C
dw DATA_C28D
dw DATA_C341

;pointers for ladder top hitbox positions and collision offsets
DATA_C48B:
dw DATA_C127
dw DATA_C20C					;GUESS WHAT THIS MEANS
dw DATA_C2A5
dw DATA_C349

;pointers to platform heights for each phase
DATA_C493:
dw DATA_C0BC
dw DATA_C20C					;no phase 2. this is sadge
dw DATA_C24C
dw DATA_C300

;skipped over 25M
UNUSED_C49B:
dw DATA_C20C					;if you didn't know, there's no 50M level. I'm sure this info will come in handy

DATA_C49D:
dw DATA_C2D2
dw DATA_C374

UNUSED_C4A1:
dw DATA_C20C					;50M level doesn't exist and it can't hurt you

DATA_C4A3:
dw DATA_C2D8					;
dw DATA_C37A					;

;seems to be stage design data pointers
DATA_C4A7:
dw DATA_F55B					;phase 1

UNUSED_C4A9:
dw DATA_F8D9					;data pointer for cement factory phase. unfortunately, it was cut so no actual stage data left. it's place is occupied by title screen data.

DATA_C4AB:
dw DATA_F7CD					;
dw DATA_F71C					;
dw DATA_F8D9					;title screen (Tilemap_TitleScreen_F8D9)
dw DATA_FA1B					;hud

;this data is used to initialize various entities, storing directly to their OAM slots
;Format: XYTRcOD
;X - initial X-position
;Y - initial Y-position
;T - Sprite tile (the first one to draw, after each +1 is addded for other tiles)
;Rc - Rows and columns - how many rows and columns to draw, with rows taking high nibble and columns low nibble (e.g. $12 is 1 row and 2 columns)
;O - OAM slot
;D - Drawing mode, see SpriteDrawingEngine_F096 for more (input A)
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
dw DATA_C4F6					;y'know the drill by now.
dw DATA_C4F6
dw DATA_C569

;unknown, maybe related with the table below?
UNUSED_C5AE:
db $7F,$7F,$7F,$00

DATA_C5B2:
db $5F,$3F,$00,$2F,$7F,$7F

UNUSED_C5B8:
db $00

;Y-positions for every bolt in 100M
DATA_C5B9:
db $A9,$A9,$81,$81,$59,$59,$31,$31

UNUSED_C5C1:
db $00,$30,$4C,$D5,$00

DATA_C5C6:
db $10,$E0,$00,$24,$50,$C0

UNUSED_C5CC:
db $00

;X-positions of every bolt in 100M level
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
db $08						;0 counts for something (idk yet)
db $17						;25M

UNUSED_C5FC:
db $00						;no 50M!!!!!!!!!!!!!

DATA_C5FD:
db $04
db $07

;another table with the sole purpose of being used in quality programming(TM)
DATA_C5FF:
db $0B

;------------------------------------------

;score sprite data
;there's data for completely unused 300 score bonus.

;Score values added to score counter (hundreds)
ScorePointAwards_C600:
db $01						;100
db $03						;300 (unused)
db $05						;500
db $08						;800

;score sprite tile
ScoreSpriteTiles_C604:
db Score_OneTile				;1 for 100
db Score_ThreeTile				;3 for 300 (unused)
db Score_FiveTile				;5 for 500
db Score_EightTile				;8 for 800

;------------------------------------------

;VRAM position for Donkey Kong's image (the top-leftmost tile), low byte (high byte is always the same)
DATA_C608:
db $84
db $8D						;HOW MANY TIMES DO WE HAVE TO TEACH YOU A LESSON OLD MAN (no phase 2 = unused)
db $84
db $8D

;picking up a barrel from the stack frame
Tilemap_DonkeyKong_PickupBarrel_C60C:
db $46						;6 columns, 4 tiles each
db $76,$77,$78,$79
db $7A,$7B,$7C,$7D
db $7E,$7F,$80,$81
db $82,$83,$84,$85
db $24,$24,$86,$87
db $24,$24,$24,$88

Tilemap_DonkeyKong_HoldingBarrel_C625:
db $46
db $24,$9C,$9D,$9E
db $9F,$A0,$A1,$A2
db $A3,$A4,$A5,$A6
db $A7,$A8,$A9,$AA
db $AB,$AC,$AD,$AE
db $24,$AF,$B0,$B1

;donkey kong frame - throwing barrel to the side (phase 1)
Tilemap_DonkeyKong_SideToss_C63E:
db $46
db $24,$24,$24,$89
db $24,$24,$8A,$8B
db $8C,$8D,$8E,$8F
db $90,$91,$92,$93
db $94,$95,$96,$97
db $98,$99,$9A,$9B

;donkey kong frame - standing still
Tilemap_DonkeyKong_Stationary_C657:
db $46
db $24,$B2,$68,$9E
db $B5,$B6,$6C,$C7
db $A3,$A4,$69,$A6
db $A7,$A8,$6B,$AA
db $C9,$CA,$6D,$BF
db $24,$CD,$6A,$B1

;Chest hit, left hand (from his perspective ofc)
Tilemap_DonkeyKong_HitChestLeftHand_C670:
db $46
db $C2,$C3,$24,$9E
db $C4,$C5,$C6,$C7
db $A3,$B9,$A5,$A6
db $A7,$BB,$6B,$C8
db $C9,$CA,$CB,$CC
db $24,$CD,$CE,$CF

;Chest hit, right hand
Tilemap_DonkeyKong_HitChestRightHand_C689:
db $46
db $24,$B2,$B3,$B4
db $B5,$B6,$B7,$B8
db $A3,$B9,$69,$BA
db $A7,$BB,$A9,$AA
db $BC,$BD,$BE,$BF
db $C0,$C1,$24,$B1

;palette for fireballs when in "panic mode" (100M exclusive)
;affects sprite palette 2
Palette_FlameEnemy_Threatened_C6A2:
db $13
db $2C,$16,$13

;sprite color palette 2 for flames.
;1 row with 3 "tiles" to upload (which is, 3 colors). 
Palette_FlameEnemy_C6A6:
db $13
db $16,$30,$37

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
db $24,$24,$19,$15,$0A,$22,$0E,$1B,$24,Tile_Roman_I,$24,$24

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
db $12						;1 row with 2 tiles
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
Tilemap_DonkeyKong_Defeated1_C71C:
db $46						;defeated frame (6 columns, 4 tiles each)
db $24,$24,$DC,$DD
db $D4,$D5,$DE,$DF
db $D6,$D7,$E0,$E1
db $D8,$D9,$E2,$E3
db $DA,$DB,$E4,$E5
db $24,$24,$E6,$E7

;second frame
Tilemap_DonkeyKong_Defeated2_C735:
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

;pretty sure those are common speed tables (NOT!!!!!!!!!)
DATA_C79A:
db $FF,$01

DATA_C79C:
db $01,$FF      

RESET_C79E:
SEI						;\pretty standard initialization. set interrupt
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

LDY #$00					;$07FF through $0000
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
STA GameControlFlag				;(why is it set cleared again after clear loop?)

LDA ControlMirror				;
EOR #$80					;enable NMI
STA ControlBits					;
STA ControlMirror				;

;game loop, wait for NMI where all the important code is at
GameLoop_CFE1:
JSR RNG_F4ED					;run through RNG loop
JMP GameLoop_CFE1				;keep looping

;set initial register settings and clear screen

SetInitRegsAndClearScreen_C7E7:
LDA #$10					;
STA ControlBits					;
STA ControlMirror				;

LDA #$06                 			;enable leftmost column of the screen rendering (sprites and tiles)
STA RenderBits					;
STA RenderMirror				;

LDA #$00					;
STA CameraPositionReg				;\set camera position
STA CameraPositionX				;|
STA CameraPositionReg           		;|
STA CameraPositionY          			;/

JSR RemoveSpriteTiles_CBAE			;remove sprite tiles
JMP DisableRenderAndClearScreen_CBB7		;clear screen

;Get drawing pointer - used to get pointers for phase design and HUD.
;Input: A - even index
;GetDrawPointer_C807:
CODE_C807:
TAX						;
LDA DATA_C4A7,X					;set indirect addressing
STA $00						;

LDA DATA_C4A7+1,X				;
STA $01						;
JMP UpdateScreen_F228				;draw or update something on screen

;this one uses buffer. used for palettes and kong updates and probably other stuff.
;GetDrawPointerBuffer_C815:
;additional input is $00-$01 - VRAM address from which the modifications are made (used in CODE_F2D7)
CODE_C815:
TAX						;
LDA DATA_C03C,X					;
STA $02						;

LDA DATA_C03C+1,X				;
STA $03						;
JMP CODE_F2D7					;

;routine used for ending to get data pointers for tile deletion & drawing (platform with Pauline 'n Jumpman)
CODE_C823:
TAX						;
LDA DATA_C03C,X					;
STA $00						;

LDA DATA_C03C+1,X				;    
STA $01						;
JMP LOOP_CD76					;stuff into buffer

;and another one. (for collision detection I think?)
;GetHitbox_C831:
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

;used only for DK defeated animation (actually no)?
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
JSR UpdateScreen_F228				;draw tiles (or update palette or tile attributes or what have you)

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
 
LDA Phase_CompleteFlag				;phase complete, do phase completion stuff
BNE CODE_C8A5					;

JSR CODE_CE7C					;run normal gameplay
JMP CODE_C8D7					;

CODE_C8A5:
LDA RemovedBoltCount				;did we accomplish this by removing bolts?
CMP #$08					;
BNE CODE_C8D4					;nope, just reached where pauline is

JSR CODE_CCF4					;falldown

LDA Timer_Transition				;check if the scene has ended
BNE CODE_C8D7					;

LDA #$00					;
STA RemovedBoltCount				;reset removed bolt count
STA GameControlFlag				;resume normal play

LDA #$79					;timer for when the phase starts i think
STA Timer_Transition				;
JMP CODE_C8D7					;end NMI
  
CODE_C8C1:
LDA Jumpman_Lives				;if Jumpman has some lives left, continue playing
BNE CODE_C8CB					;

JSR CODE_CA30					;game over (or demo end)
JMP CODE_C8D7					;(almost) end NMI

CODE_C8CB:  
JSR CODE_C8F3					;
JSR HandleTimers_F4AC				;handle timers
JMP CODE_C8D7					;
  
CODE_C8D4:
JSR CODE_CAC9					;reached pauline!

CODE_C8D7:  
LDA Score_UpdateFlag				;check if we need to update the score
CMP #$01					;(can't update it if the kong played the animation BTW)
BNE CODE_C8E8					;no, end NMI (for real this time)

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

;HandleTitleScreen_C8F3:
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

;title screen initialization
JSR DisableRender_D19A				;disable render

LDA #$08					;\
JSR CODE_C807					;/draw title screen

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
STA Timer_Global				;timer that's actually pointless (see below)

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
LDA Timer_Global				;wait a minute... what? this check makes no sense!
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
STA GameOverFlag_PerPlayer			;\clear game over flags for both players
STA GameOverFlag_PerPlayer+1			;/
STA GameControlFlag				;can't control yet
STA TitleScreen_MainCodeFlag			;initialize title screen next time we get there
STA Demo_InitFlag				;init demo (in case it is, in fact, demo)
STA TitleScreen_SelectHeldFlag			;not holding select, k?

LDA #Phase_25M					;
STA PhaseNo					;start from 25M
STA PhaseNo_PerPlayer				;initialize  both player's phase number
STA PhaseNo_PerPlayer+1				;

LDA #$00					;
STA LoopCount					;initialize loop counter
STA LoopCount_PerPlayer				;
STA LoopCount_PerPlayer+1			;

LDA #$00					;but we had 00 loaded before... and before before.
STA Players_CurrentPlayer			;always start as player 1
STA ReceivedLife_Flag				;\can receive a freebie
STA ReceivedLife_Flag+1				;/
STA Sound_Music					;no music yet

LDA #Jumpman_InitLives				;set number of lives depending on whether we're in demo mode or not
LDX Demo_Active					;
BEQ CODE_CA06					;

LDA #$01					;only one life in demo so it ends upon death

CODE_CA06:
STA Jumpman_Lives				;
STA Jumpman_Lives_PerPlayer			;
STA Jumpman_Lives_PerPlayer+1			;
STA LostALifeFlag				;decrease life counter when loading the game (idk why it's like that)

LDA Demo_Active					;initialize different variables if in demo mode
BNE CODE_CA26					;

LDA #$97					;transition is extended a bit because of the sound effect
STA Timer_Transition				;

LDA #Sound_Fanfare_GameStart			;
STA Sound_Fanfare				;

LDA #$0F					;enable all sound channels
STA APU_SoundChannels				;
STA Sound_ChannelsMirrorUnused			;and back up
RTS						;

CODE_CA26:
DEC TitleScreen_DemoCount			;-1 demo for title screen music

LDA #$75					;
STA Timer_Transition				;
JMP RemoveSpriteTiles_CBAE			;no sprite tiles

CODE_CA30:
JSR HandleTimers_F4AC				;handle timers

LDA Demo_Active					;if game over during demo, simply end it
BNE CODE_CA4A					;

LDA Timer_Transition				;
CMP #$75					;
BEQ CODE_CA5A					;part one of game over process - remove sprite tiles
CMP #$74					;
BEQ CODE_CA5F					;part two - check if two player mode to show which player game overed
CMP #$73					;
BEQ CODE_CA64					;show game over message
CMP #$5F					;
BEQ CODE_CA79					;after showing game over for some time, either send to the title screen (1 player game or 2 player when both gameovered) or switch to the other player (2 player)
RTS						;

CODE_CA4A:
STA Jumpman_Lives				;set lives

LDA #$00					;
STA Demo_Active					;but reset demo flag and initialize title screen
STA TitleScreen_MainCodeFlag			;

;just calls both screen clear and OAM clear
ClearScreenAndRemoveSpriteTiles_CA53:
JSR DisableRenderAndClearScreen_CBB7		;
JSR RemoveSpriteTiles_CBAE			;
RTS						;

CODE_CA5A:
DEC Timer_Transition				;
JMP RemoveSpriteTiles_CBAE			;no sprite tiles

CODE_CA5F:
DEC Timer_Transition				;
JMP CODE_CBCA					;show PLAYER X if needed

CODE_CA64:  
DEC Timer_Transition				;

LDA GameMode					;preserve top score
AND #$01					;
ASL A						;
TAX						;
LDA ScoreDisplay_Top				;
STA Score_Top,X					;store top score for game A or B

LDA ScoreDisplay_Top+1				;
STA Score_Top+1,X				;
JMP ShowGameOverMessage_CBF5			;display GAME OVER

CODE_CA79:
LDX Players_CurrentPlayer			;
LDA #$01					;
STA GameOverFlag_PerPlayer,X			;mark current player as game overed
STA TitleScreen_Flag				;

LDA Players					;check players
CMP #Players_2Players				;2-player mode?
BNE CODE_CA94					;if not, game over for real

LDA Players_CurrentPlayer			;
EOR #$01					;
TAX						;
LDA GameOverFlag_PerPlayer,X			;
STA TitleScreen_Flag				;set other player's game over flag as title screen flag
BEQ CODE_CA99					;if they didn't game over, doesn't send to the title screen

CODE_CA94:
STA Jumpman_Lives				;probably set up lives for the title screen? even though when gameplay is initialized, it sets lives count accordingly
JMP ClearScreenAndRemoveSpriteTiles_CA53	;transition to the title screen

CODE_CA99:
LDA #$85					;
STA Timer_Transition				;
STA LostALifeFlag				;aaaand lost a life

LDY #$00					;
STY GameControlFlag				;don't run the gameplay part yet
STX Players_CurrentPlayer			;next player's a go
JMP CODE_CAA9					;these 1-byte jumps are kind of ridiculous.

;load current player's variables into zero page address (for less cycles and space and stuff)
;loads current player's PhaseNo, LoopCount and Jumpman_Lives
;Input X - current player
CODE_CAA9:
LDY #$00					;

LOOP_CAAB:
LDA PhaseNo_PerPlayer,X				;
STA PhaseNo,Y					;
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
LDA PhaseNo,Y					;
STA PhaseNo_PerPlayer,X				;
INX						;
INX						;
INY						;
CPY #$03					;
BNE LOOP_CABB					;
RTS						;

CODE_CAC9:
JSR HandleTimers_F4AC				;timers per usual

LDA PhaseNo					;if 25M, don't give bonus score
CMP #Phase_25M					;for starting a new game. in case of looping, 100M's ending already handles bonus points
BEQ CODE_CAD8					;

LDA Timer_Transition				;
CMP #$84					;give score points and maybe extra life
BEQ CODE_CB02					;

CODE_CAD8:
LDA Timer_Transition				;

If Version = JP
  CMP #$74					;different compared values in Japanese version (slightly faster transitions?)
  BCS CODE_CB18					;
  CMP #$6F					;
  BEQ CODE_CAE7					;
  CMP #$64					;
  BEQ CODE_CAFA					;
else
  CMP #$72					;transition for a couple extra frames in the REV1 version?
  BCS CODE_CB18					;
  CMP #$6D					;
  BEQ CODE_CAE7					;update lives count (in case of death or what have you)
  CMP #$62					;
  BEQ CODE_CAFA					;can finally play the game (end initialization)
endif
RTS						;

CODE_CAE7:
;there's a minor error where the life counter displays the previous life counter value for a few frames before decreading life count by 1. kinda makes sense when you lose a life, but this is also applied to the start of the game, which is why you "lose a life" by starting a game, going from 3 to 2 lives
LDA LostALifeFlag				;if didn't lose a life, well
BEQ CODE_CAF6

LDA #$00					;
STA LostALifeFlag				;lost it once

DEC Jumpman_Lives				;decrease jumpman's life count
JSR CODE_CBBD					;reflect the change in the life counter

CODE_CAF6:  
JSR CODE_CC34					;score stuff (TOP score?)
RTS						;

CODE_CAFA:
LDA #$01					;
STA GameControlFlag				;can play game...

JSR CODE_CC47					;
RTS						;

CODE_CB02:
LDX Players_CurrentPlayer			;load current player in play
LDA PhaseNo					;check current phase
CMP PhaseNo_PerPlayer,X				;versus where player's supposed to go
BEQ CODE_CB15					;if on the same stage, means died, don't add score points
CMP #Phase_25M					;check if its a 25M phase... why?
BEQ CODE_CB15					;you can't even get here if it's 25M! not to mention, starting the game sets both phase and per player phase to 25M already

JSR CODE_CC24 					;give bonus score
JSR CODE_CC04					;maybe give an extra life

CODE_CB15:
DEC Timer_Transition				;decrease transition timer
RTS						;

CODE_CB18:
JMP CODE_CB1B					;another JMP that shouldn't be here

CODE_CB1B:
if Version = JP
  CMP #$7A					;more different checks, except this time slightly different code is also included
  BEQ JP_CODE_CB28				;clear screen and maybe show PLAYER 1 or PLAYER 2 text
  CMP #$75					;
  BEQ JP_CODE_CB30				;clear screen again and play a sound effect and place kong
  CMP #$74					;
  BEQ JP_CODE_CB4C				;load stage layout and initialize some other stuff
  RTS						;

JP_CODE_CB28:
  DEC Timer_Transition				;
  JSR ClearScreenAndRemoveSpriteTiles_CA53	;
  JMP JP_CODE_CBC6				;actually more optimal than REV1? color me surprised (show player X string for 2P mode)

JP_CODE_CB30:
  JSR JP_DisableRenderAndClearScreen_CBB3	;no tiles on screen... and no screen on screen because no render

  DEC Timer_Transition				;

  LDA Demo_Active				;demo?
  BNE JP_CODE_CB3D				;no sound and stuff

  LDA #Sound_Fanfare_PhaseStart			;start da phase
  STA Sound_Fanfare				;

else
  CMP #$7A					;revision 1 changes some checks and adds some
  BEQ CODE_CB30					;some of the same deal though. clear screen and maybe show PLAYER 1 or PLAYER 2 text
  CMP #$75					;
  BEQ CODE_CB39					;clear screen again and play a sound effect
  CMP #$74					;
  BEQ CODE_CB36					;just wait for a frame, chill
  CMP #$73					;
  BEQ CODE_CB58					;load stage layout and initialize some other stuff
  CMP #$72					;
  BEQ CODE_CB47					;donkey kong image is now its own loading state instead of being placed right after the screen clear from after PLAYER X string. this fixes glitchy lines at the top of the screen that flicker briefly when the phase loads
  RTS						;
  
CODE_CB30:
  JSR ClearScreenAndRemoveSpriteTiles_CA53	;
  JSR CODE_CBCA					;show player 1 or player 2 screen

CODE_CB36:
  DEC $43					;
  RTS						;

CODE_CB39:
  JSR DisableRenderAndClearScreen_CBB7		;screen clear

  DEC Timer_Transition				;

  LDA Demo_Active				;if demo, don't play phase start when it starts playing
  BNE RETURN_CB46				;

  LDA #Sound_Fanfare_PhaseStart			;start da phase but it's a revision 1
  STA Sound_Fanfare				;

RETURN_CB46:
  RTS						;

CODE_CB47:
  DEC Timer_Transition				;
endif

JP_CODE_CB3D:
LDX PhaseNo					;
DEX						;
LDA DATA_C608,X					;VRAM low
STA $00						;

LDA #$20					;VRAM high
STA $01						;
JMP CODE_EBA6					;place donkey kong in

JP_CODE_CB4C:
CODE_CB58:
JSR DisableRender_D19A				;disable rendering

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
JSR UpdateTOPScorePrep_D032			;
JSR CODE_CBBD					;hmm...

LDA #<VRAMLoc_LoopCount				;
STA $00						;
LDY LoopCount					;render loop count
INY						;w +1 e.g. instead of 0, show 1
JSR VRAMUpdateSingle_F4C2			;

LDA #$00					;
STA $2C						;didnt overflow

LDA #$80					;cap bonus score counter
DEY						;
CPY #$04					;
BPL CODE_CB9E					;however the logic is flawed. if value is 80+, it'll use incorrect table bytes (and cause killscreen)

LDA DATA_C207,Y					;load bonus points from table

CODE_CB9E:
STA ScoreDisplay_Bonus				;

LDA #$0D					;
STA Timer_BonusScoreDecrease			;

LDA #$02                 
STA $00                  
JSR CODE_F23C                
DEC Timer_Transition

If Version = JP
  LDA Demo_Active				;check if it's a demo mode
  BEQ JP_RETURN_CBA9				;

  LDA #$73					;set timer
  STA $43					;
endif

JP_RETURN_CBA9:
RTS						;

;used to clear OAM via sprite drawing engine
RemoveSpriteTiles_CBAE:
LDA #<OAM_Y					;
STA $04						;

LDA #$FF					;remove ALL tiles!
JMP CODE_F092					;

JP_DisableRenderAndClearScreen_CBB3:
DisableRenderAndClearScreen_CBB7:
JP_CODE_CBB3:
CODE_CBB7:
JSR DisableRender_D19A				;no rendering
JMP CODE_F1B4					;clear screen

;UpdateLiveCounter_CBBD:
CODE_CBBD:
LDA #<VRAMLoc_LivesCount			;set VRAM location to where lives count is
STA $00						;

LDA #>VRAMLoc_LivesCount			;
STA $01						;

LDY Jumpman_Lives				;set lives number as tile value
JMP VRAMUpdateSingle_F4C2			;

;show "PLAYER X" screen where X is the player's number (player 1 or Player 2)
;ShowPlayerX_CBCA:
JP_CODE_CBC6:
CODE_CBCA:
LDA Demo_Active					;if demo mode is active, don't show player X message
BNE RETURN_CBF4					;

LDA Players					;if the game is in 2 player mode
CMP #Players_2Players				;
BNE RETURN_CBF4					;if so, don't show normal game over message (should show which player has game over)

LDX Players_CurrentPlayer			;not sure what's the point of this, but...
LDA PhaseNo					;check if in the same phase
CMP PhaseNo_PerPlayer,X				;
BNE RETURN_CBF4					;

LDY #$00					;

LOOP_CBDF:
LDA DATA_C6AA,Y					;display PLAYER X
STA BufferAddr,Y				;
BEQ CODE_CBEB					;
INY						;
JMP LOOP_CBDF					;

CODE_CBEB:
LDA Players_CurrentPlayer			;player 1?
BEQ RETURN_CBF4					;leave as is

LDA #Tile_Roman_II				;replace I with II
STA BufferAddr+20				;

RETURN_CBF4:
RTS						;

ShowGameOverMessage_CBF5:
LDY #$00					;

LOOP_CBF7:
LDA DATA_C6C2,Y					;
STA BufferAddr,Y				;GAME OVER message in the buffer
BEQ RETURN_CC03					;
INY						;
JMP LOOP_CBF7					;

RETURN_CC03:
RTS						;

;give extra life based on score
CODE_CC04:
LDA Demo_Active					;don't process if in demo mode
BNE RETURN_CC23					;

LDX Players_CurrentPlayer			;
LDA ReceivedLife_Flag,X				;
BNE RETURN_CC23					;if received a life once, no more
TXA						;
TAY						;
CLC						;
ASL A						;
ASL A						;
TAX						;
LDA ScoreDisplay_Player1,X			;
CMP #$02					;check for 20000 score
BCC RETURN_CC23					;if less, return
STA ReceivedLife_Flag,Y				;set flag for receiving extra life (only once per game and per player)

INC Jumpman_Lives				;increase lives count
JSR CODE_CBBD					;update visual life count

RETURN_CC23:
RTS

;add bonus score to the player's when phase complete (or is TOP score?)
CODE_CC24:
LDA ScoreDisplay_Bonus				;add bonus score to player's score
STA $00						;store hundreds into scratch ram

LDA Players_CurrentPlayer			;current player index
ORA #$08					;not adding ones and tens, BONUS is in hundred increments
STA $01						;also into scrath ram

JSR CODE_F342					;+ bonus score
JMP UpdateTOPScorePrep_D032 			;update TOP score (potentially)

CODE_CC34:
LDA #$01					;unecessary (UpdateTOPScorePrep_D032 already enables score update flag)
STA Score_UpdateFlag				;

JSR UpdateTOPScorePrep_D032			;TOP score update

LDA #$00					;
STA Demo_InitFlag				;init demo (for when we're back at the title screen)

JSR CODE_CCC1					;load all the entities
JMP CODE_D7F2					;load fire colors

;phase late initialization (after phase start jingle plays out and gameplay actually begins)
CODE_CC47:
LDA #$00					;
TAX						;

LOOP_CC4A:
STA $59,X					;initialize RAM from 59-E2
STA $040D,X					;and $040D-$0496
INX						;
CPX #$89					;
BNE LOOP_CC4A					;

LDA #$01					;
STA Jumpman_CurrentPlatformIndex		;initial platform jumpman's standing on is the first
STA Jumpman_State				;and state
STA Jumpman_UpwardSpeed				;one pixel of upward speed
STA Hammer_CanGrabFlag				;can grab da hammer
STA Hammer_CanGrabFlag+1			;
STA Hammer_JumpmanFrame				;
STA Kong_AnimationFlag				;always animate

LDA #Jumpman_GFXFrame_Stand			;show standing frame upon phase load
STA Jumpman_GFXFrame				;

LDA #$58					;slightly over one pixel speed (although gravity also affects upward speed)
STA Jumpman_UpwardSubSpeed			;

LDA #%00100000					;
STA Hammer_AnimationFrameCounter		;initialize hammer frame counter (or """""frame counter""""")

LDA #$80					;
STA RNG_Value					;set first RNG byte as 80

LDA #Time_ForTiming				;decrease other timers every 10 frames
STA Timer_Timing				;

LDX Players_CurrentPlayer			;save current player's variables (in case of 2P play)
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
STA Timer_EntitySpawn				;

LDA #$40					;
STA Timer_Transition				;

LDA #Sound_Music_25M				;obviously play 25M music at 25M
STA Sound_Music					;
RTS						;

CODE_CCA6:
LDA #$20					;initial springboard spawn timer
STA Timer_EntitySpawn				;

LDA #$50					;init all springboard vertical speeds
STA Springboard_UpwardSubSpeed			;
STA Springboard_UpwardSubSpeed+2		;
STA Springboard_UpwardSubSpeed+4		;

LDA #$03					;
STA Springboard_UpwardSpeed			;
STA Springboard_UpwardSpeed+2			;
STA Springboard_UpwardSpeed+4			;
RTS						;

;entity initialization
;InitEntities_CCC1:
CODE_CCC1:
LDA PhaseNo					;get a pointer
SEC						;
SBC #$01					;
ASL A						;
TAX						;

LDA DATA_C5A6,X					;
STA $09						;

LDA DATA_C5A6+1,X				;
STA $0A						;

LDX #$00					;
LDY #$00					;

LOOP_CCD6:
LDA ($09),Y					;check for a break command
CMP #$FE					;
BEQ RETURN_CCF3					;return if so
STA $00,X					;coordinates and stuff
INY						;
INX						;
CPX #$05					;
BNE LOOP_CCD6					;only 4 bytes per sprite tile
STY $86						;save Y (which is pointless

LDA ($09),Y					;
JSR SpriteDrawingEngine_F096			;

LDY $86						;Y is saved during SpriteDrawingEngine call so this is pointless
INY						;
LDX #$00					;
JMP LOOP_CCD6					;

RETURN_CCF3:
RTS						;

CODE_CCF4:
LDA Kong_DefeatedFlag				;handle the ending
BNE CODE_CD07					;

;initialize kong falling scene
LDA #$01					;flag
STA Kong_DefeatedFlag				;

LDA #$0A					;make sure the timing timer doesn't decrease transition timer, skipping various ending states!
STA Timer_Timing				;

LDA #Sound_Fanfare_KongFalling			;i can't believe the kong is dead :pensive:
STA Sound_Fanfare				;
RTS						;

CODE_CD07:
LDA $43						;
CMP #$58					;prematurely end when reaches this value
BCC CODE_CD13					;

JSR HandleTimers_F4AC				;timer handling (won't decrease transition timer for a little bit)
JMP CODE_CD22					;run states

CODE_CD13:
JSR CODE_CC24					;add bonus score to the score counter
JSR CODE_CC04					;more score shenanigans

LDA #$00					;
STA $43						;
STA Phase_CompleteFlag				;not defeated anymore, transition to the next stage
JMP ClearScreenAndRemoveSpriteTiles_CA53	;transition

CODE_CD22:
LDA $43						;run various states based on current timer's time
CMP #$9F					;
BEQ CODE_CD45					;remove HUD elements
CMP #$9E					;
BEQ CODE_CD4A					;remove sprite tiles and platforms
CMP #$9D					;
BEQ CODE_CD4F					;remove misc stuff (partially umbrella and handbag, pauline's platform)
CMP #$9C					;
BEQ CODE_CD58					;remove ladders, and remains of umbrella and handbag
CMP #$9B					;
BEQ CODE_CD61					;draw platforms below and initialize DK's sprite tiles
CMP #$90					;
BCS CODE_CD66					;animate BG DK before falling down
CMP #$86					;
BCS CODE_CD69					;fall down
CMP #$70					;
BCS CODE_CD6C					;draw platform with pauline and jumpman, animate BG DK
RTS						;nothing else

CODE_CD45:
DEC $43						;
JMP CODE_CD6F					;

CODE_CD4A:
DEC $43						;
JMP CODE_CD7F					;

CODE_CD4F:
LDY #$1C					;
DEC $43						;

LDA #$06					;
JMP CODE_C823					;remove misc. stuff

CODE_CD58:
LDY #$1C					;
DEC $43						;

LDA #$08					;
JMP CODE_C823					;remove ladders and more misc stuff.

CODE_CD61:
DEC $43						;
JMP CODE_CD89					;

CODE_CD66:  
JMP CODE_CD9D					;

CODE_CD69:  
JMP CODE_CDB1					;

CODE_CD6C:
JMP CODE_CE24					;animate defeated kongey donk

CODE_CD6F:
LDY #$0C					;\remove HUD
LDA #$0A					;|
JMP CODE_C823					;/

;DumpTilesIntoBuffer_CD76:
LOOP_CD76:
LDA ($00),Y					;
STA BufferAddr,Y				;store into buffer
DEY						;
BPL LOOP_CD76					;
RTS						;

CODE_CD7F:  
JSR RemoveSpriteTiles_CBAE			;all sprite tiles BEGONE

LDY #$16					;remove platforms, so they appear below
LDA #$0C					;
JMP CODE_C823					;

CODE_CD89:
LDY #$0C					;store platforms that appear below
LDA #$0E					;
JSR CODE_C823					;

LDA #OAMProp_Palette3				;default OAM prop
STA $02						;
        
LDA #6*4					;store to this much
STA $03						;
       
LDA #DonkeyKong_OAM_Slot*4			;store props for these tiles (for DK)
JMP CODE_F08C					;

;animate DK a little bit midair (before falling down)
CODE_CD9D:
LDA #$8D					;VRAM address where DK is
STA $00						;

LDA #$20					;high byte
STA $01						;

LDA Timer_Transition				;every other 10 frames
AND #$01					;
BEQ CODE_CDAE					;normal or flipped
JMP CODE_EB89					;normal

CODE_CDAE:
JMP CODE_EB92					;flipped (sorta)
  
CODE_CDB1:
CMP #$8F					;
BNE CODE_CDD7					;check if we should init some stuff

DEC Timer_Transition				;

LDY #$10					;remove BG DK
LDA #$10					;
JSR CODE_C823					;

LDA #Sound_Effect_Fall				;DK is falling sound effect
STA Sound_Effect				;

LDA #DonkeyKong_OAM_XPos			;initial x-pos
STA $00						;

LDA #DonkeyKong_OAM_YPos			;initial y-pos
STA $01						;

CODE_CDCA:
LDA #DonkeyKong_OAM_FirstTile			;start from tile $40
STA $02						;

LDA #$46					;4 rows, 6 tiles each
STA $03						;

LDA #DonkeyKong_OAM_Slot*4			;OAM slot to start from
JMP CODE_F080					;draw DK

CODE_CDD7:  
LDA DonkeyKong_OAM_Y				;check when DK hit platforms
CMP #$A0					;at this position
BEQ CODE_CDEF					;
CMP #$FF					;if the sprites are already removed
BEQ CODE_CDF3					;keep them offscreen?
CLC						;
ADC #$02					;move 2 pixels down
STA $01						;

LDA DonkeyKong_OAM_X				;same X-pos
STA $00						;
JMP CODE_CDCA					;update image

CODE_CDEF:
LDA #Sound_Effect_Hit				;rough landing
STA Sound_Effect				;

;remove DK's sprite tiles, then draw BG donkey kong
CODE_CDF3:
LDA #4*6					;remember 4 rows with 6 tiles each? this much we're removing
STA $03						;

LDA #DonkeyKong_OAM_Slot*4			;
JSR CODE_F08C					;remove DK sprite

LDA #$EB					;draw BG DK (his VRAM pos)
STA $00						;

LDA #$23					;and hibyte ofc
STA $01						;

LDA #$12					;
JSR CODE_C815					;init Donkey Kong's defeated frame (attributes + flows into drawing frame 2)

LDA #$01					;
JMP CODE_CE0E					;another gem.

;animate defeated BG Kong
CODE_CE0E:
PHP						;
LDA #$8D					;VRAM position for his tiled glory
STA $00						;

LDA #$22					;
STA $01						;
PLP                      			;
BNE CODE_CE1F					;A is not 0 (from LDA) - draw frame 2

LDA #$16					;
JMP CODE_C815					;draw defeated kong frame 1

CODE_CE1F:
LDA #$14					;
JMP CODE_C815					;frame 2

CODE_CE24:  
CMP #$85					;planted donkey?
BEQ CODE_CE2F					;init a few things before playing his defeat animation

LDA Timer_Transition				;animate defeat every few frames
AND #$01					;
JMP CODE_CE0E					;

;when the kong's defeated, initialize some things (place pauline and jumpman on the platform, heart, sound and what have you)
CODE_CE2F:
LDA #Sound_Fanfare_KongDefeated			;
STA Sound_Fanfare				;a little jingle that confirms that yes, you just beat Donkey Kong. Go you!

LDY #$04					;draw platform with pauline and jumpman on
LDA #$18					;
JSR CODE_C823					;

;draw love
LDA #Ending_Heart_XPos				;
STA $00						;

LDA #Ending_Heart_YPos				;
STA $01						;

LDA #Heart_OAM_Tile				;tile
STA $02						;

LDA #$22					;standart 16x16
STA $03						;

LDA #Heart_OAM_Slot*4				;OAM slot
JSR CODE_F080					;draw!

DEC Timer_Transition				;

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
BEQ CODE_CE94					;if not, run normal gameplay handling

LDA Sound_FanfarePlayFlag			;no fanfare
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

LDA Phase_CompleteFlag				;check if we completed a phase
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

JSR RunDemoMode_EBDA				;run demo inputs
JMP CODE_CED6					;run other routines

CODE_CED3:
JSR CODE_D175					;get player's directions & maybe jump

CODE_CED6:
JSR CODE_EB06					;DK animations (HandleDonkeyKong_EB06)
JSR HandleBonusCounter_EBB6			;handle bonus counter (decrease over time & kill the player)
JSR HandleHurryUpMusic_D041			;play hurry up music when the bonus counter is low enough
JSR CODE_D1A4					;handle player's state
JSR HandlePauline_EA5F				;animate pauline sometimes
JSR CODE_E1E5					;flame enemy spawning or smth
JSR CODE_EE79					;handle collectible items and bolts

;handle different hazards depending on phase
LDA PhaseNo
CMP #Phase_75M					;handle springboards in phase 2
BEQ CODE_CF01					;
CMP #Phase_100M					;handle following fires in phase 3 
BEQ CODE_CF0D					;

JSR RunBarrels_DA16				;barrels of phase 1   
JSR RunOilBarrelFlame_E19A			;handle oil barrel flame
JSR CODE_EC29					;make jumpman interact with various things (in this case, it's barrels and stuff) (this should've been a common routine btw)
JMP CODE_CF1C					;common stuff

CODE_CF01:
JSR RunMovingPlatforms_E834			;handle platform lifts
JSR RunSpringboards_E981			;RunSpringboards
JSR CODE_EC29					;jumpman's collision handling or smth
JMP CODE_CF1C					;and the rest

CODE_CF0D:
JSR CODE_EC29					;interact with hazards and just about anything that can make the player dead (or can be destroyed with a hammer)
JMP CODE_CF1C					;

CODE_CF13:
JSR CODE_EE0C					;destroyed-by-hammer enemy animation
JMP CODE_CF1C					;

CODE_CF19:
JSR CODE_D0C0					;death state exclusive routine (animate?)

CODE_CF1C:
JSR CODE_CF42					;handle pausing or getting out of demo mode with start

LDA Pause_Flag					;if game is paused, return
BNE RETURN_CF2A

JSR CODE_D04C					;check for a win situation
JSR HandleTimers_F4AC				;handle global timers

RETURN_CF2A:
RTS						;

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
JMP ClearScreenAndRemoveSpriteTiles_CA53	;

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
;X - score reward index (values taken from ScorePointAwards_C600)
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

LDA ScoreSpriteTiles_C604,X			;load first score tile depending on what value (200, 300, etc.)
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
TXA						;
PHA						;
TYA						;
PHA						;

LDA Demo_Active					;in demo?
BNE CODE_D02A					;don't mess with the score during that

LDA Players_CurrentPlayer			;add score to the corresponding player's counter
ORA #$18					;
STA $01						;

LDA ScorePointAwards_C600,X			;score reward based on the number
STA $00						;

LDA $05						;save positions
PHA						;
LDA $06						;
PHA						;
JSR CODE_F342					;score routine
PLA						;
STA $06						;
PLA						;
STA $05						;

CODE_D02A:
JSR UpdateTOPScorePrep_D032			;update TOP score
PLA						;
TAY						;
PLA						;
TAX						;
RTS						;

UpdateTOPScorePrep_D032:
LDA Score_UpdateFlag				;
ORA #$01					;
STA Score_UpdateFlag				;also some places that call this routine set this before hand, which is pointless and wastes space and stuff

LDA #$F9					;
STA $00						;
JMP UpdateTOPScore_F435				;compare TOP and player scores

HandleHurryUpMusic_D041:
LDA ScoreDisplay_Bonus				;if bonus score is less than 1000, play hurry up sound
CMP #BonusScoreCounter_WhenHurryUp		;
BPL RETURN_D04B					;

LDA #Sound_Music_HurryUp			;play hurry up music
STA Sound_Music					;

RETURN_D04B:
RTS						;

;handle level's goal (reach the very top platform or remove all bolts in 100M)
CODE_D04C:
LDA Phase_CompleteFlag				;did we complete this phase? (is this even needed btw?)
BNE CODE_D092					;

LDX PhaseNo					;100M means bolts
CPX #Phase_100M					;
BEQ CODE_D063					;

LDA Jumpman_OnPlatformFlag			;don;t bother checking platform if the player isn't grounded to begin with
BEQ RETURN_D0BF					;
DEX						;
LDA DATA_C1FA,X					;check if jumpman is on platform where pauline is
CMP Jumpman_CurrentPlatformIndex		;
BEQ CODE_D074					;if yes, phase complete!
RTS						;

;check for bolts (100M)
CODE_D063:
LDX #$00					;

LOOP_D065:
LDA Bolt_RemovedFlag,X				;is the bolt removed?
BEQ RETURN_D0BF					;if not, RETURN
INX						;
STX RemovedBoltCount				;amount of bolts we've removed so far
CPX #$08					;
BNE LOOP_D065					;
JMP CODE_D086					;prepare all phase transition shenanigans

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
STA Phase_CompleteFlag				;phase complete flag

LDA #$00					;already trigger next phase procedures
STA Timer_PhaseEndTimer				;

CODE_D092:  
LDA Timer_PhaseEndTimer				;
BNE RETURN_D0BF					;

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

LDA #$00					;
STA GameControlFlag				;no control yet
STA Phase_CompleteFlag				;transition from completed phase to the next

RETURN_D0BF:
RTS

;This runs if player's dead
CODE_D0C0:
LDA #Sound_Music_Silence			;no music during death 
STA Sound_Music					;

LDA #%00010000					;activate every 8 frames
JSR JumpmanTiming_BothBytes_D9E6		;
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
LDA #$40					;
STA Timer_PhaseEndTimer				;phase ends but not in a good way

INC Jumpman_Death_FlipTimer			;
RTS						;

CODE_D0E4:
LDA Timer_PhaseEndTimer				;timer
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
STA Timer_PhaseEndTimer				;

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
STA Timer_PhaseEndTimer				;

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

LDA Timer_PhaseEndTimer				;
BEQ CODE_D139					;

RETURN_D138:
RTS						;

;player died, return to title screen or reload the level
CODE_D139:
LDX Players_CurrentPlayer			;
JSR CODE_CAB9					;save player variables

LDA Jumpman_Lives				;if jumpman still has some lives to spare
BNE CODE_D14B					;just restart the phase

LDA #$01					;show title screen
STA TitleScreen_Flag				;

LDA #$87					;transition onto the title screen!
STA Timer_Transition				;
RTS						;

;lost life, no gameplay yet and switch players if in 2P mode
CODE_D14B:
LDA Players					;
CMP #Players_2Players				;
BNE CODE_D169					;

LDA Players_CurrentPlayer			;
EOR #$01					;
TAX						;
STX Players_CurrentPlayer			;switch the player

LDA GameOverFlag_PerPlayer,X			;if the player didn't get a game over, continue as normal
BEQ CODE_D166

TXA						;revert the player change
EOR #$01					;
TAX						;
STX Players_CurrentPlayer			;don't switch players if one of them has game over'd    
JMP CODE_D169					;

CODE_D166:
JSR CODE_CAA9					;load other player's addresses

CODE_D169:
LDA #$87					;
STA Timer_Transition				;
STA LostALifeFlag				;-1 life

LDA #$00					;
STA GameControlFlag				;don't run the gameplay yet
RTS						;

;GetPlayerInput_D175
CODE_D175:
LDA Players_CurrentPlayer			;which player  
ASL A						;get proper controller input address
TAX						;

LDA ControllerInput_Previous,X			;either player 1 or 2
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

LDA ControllerInput_Previous,X			;check player's input         
AND #Input_A					;press A - the player'll jump
BEQ RETURN_D199					;

LDA #Jumpman_State_Jumping			;jumpman is a jumping man ofc
STA Jumpman_State				;

RETURN_D199:
RTS						;

;disable rendering
DisableRender_D19A:
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
CMP #Jumpman_State_Jumping			;jumped?
BEQ CODE_D1C6					;do jump stuff
CMP #Jumpman_State_Falling			;
BEQ CODE_D1C9					;IM FALLING AND I CANT GET UP
CMP #Jumpman_State_Hammer			;move and stuff when equipped with hammer
BEQ CODE_D1CC					;
RTS						;

CODE_D1BB:
JSR CODE_D1CF					;handle movement

LDA Jumpman_State				;continue checking
JMP CODE_D1AA					;in case we changed it during movement

CODE_D1C3:
JMP CODE_D37E					;climb

CODE_D1C6:
JMP CODE_D547					;jump

CODE_D1C9:
JMP CODE_D697					;falling. Oops

CODE_D1CC:
JMP CODE_D6C6					;HAMMER TIME

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
JMP CODE_D28B					;check ladder

;moving left or right
CODE_D1E5:
LDA #%11011011					;
STA $0A						;

LDA #%00110110					;alternates between run for 2 frames, then resume after 2 frames for another round (there is one inconsistency towards the end where you need to wait 3 frames)
JSR JumpmanTiming_D9E8				;
BNE CODE_D1F3					;only run when the time is right
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
STA Jumpman_CurrentPlatformIndex		;

JSR CODE_D8EB					;add shift pos, or something
BEQ CODE_D233					;

LDX PhaseNo					;phase?
CPX #Phase_25M					;25M?
BNE CODE_D227					;yes?
CLC						;yes.
ADC Jumpman_OAM_Y				;yes!
STA Jumpman_OAM_Y				;shift player's Y-pos

CODE_D227:
JSR CODE_D36A					;check if walked off the ledge
CMP #$00					;I see no problem here, do you?
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
BEQ CODE_D262					;set standing frame (or walk 3)
CMP #Jumpman_GFXFrame_Walk1			;walking 1?
BEQ CODE_D26D					;set walk 2

LDA #Jumpman_GFXFrame_Stand			;load standing frame by default
STA Jumpman_GFXFrame

LDA Jumpman_AlternateWalkAnimFlag		;which walking animation frame to show
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

LDA #$00					;show Jumpman_GFXFrame_Walk1 next time
STA Jumpman_AlternateWalkAnimFlag		;
JMP CODE_D275					;
  
CODE_D26D:
LDA #Jumpman_GFXFrame_Stand			;standing frame
STA Jumpman_GFXFrame

LDA #$01					;show Jumpman_GFXFrame_Walk2 next time
STA Jumpman_AlternateWalkAnimFlag		;

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

;ladder bottom check for when the player presses up to climb one
CODE_D28B:
JSR JumpmanPosToScratch_EAE1			;get Jumpman's position

LDA #<DATA_C186					;
STA $02						;

LDA #>DATA_C186					;
STA $03						;
JSR CODE_EFEB					;get collision something (player's collision hitbox for ladders?).

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

LDA #$2C					;
JMP CODE_D2DF					;

CODE_D2DD:
LDA #$4A					;different collision box when jumping or falling?

CODE_D2DF:
JSR CODE_EFE8					;collision-related

LDA PhaseNo					;calculate pointer offset based on current phase
CMP #Phase_25M					;
BEQ CODE_D2F0					;
SEC						;
SBC #$01					;
ASL A						;
TAX						;
JMP CODE_D2FD					;

CODE_D2F0:
LDA #$1A					;
JSR CODE_C831					;jumpboi hitbox

JSR CODE_D91A					;check if colliding with any platform
STA $0C						;result
JMP CODE_D323					;(pointless jump..................)

CODE_D2FD:
LDA UNUSED_C46B,X				;load used values that are offset from an unused table (first two pointers are unused)
STA $04						;pointer for hitbox positions and width pointer offset

LDA UNUSED_C46B+1,X				;
STA $05						;

LDA UNUSED_C473,X				;retrieve different platform widths pointer
STA $06						;

LDA UNUSED_C473+1,X				;
STA $07						;

JSR CODE_D8AD					;a more standard platform collision check
STA $0C						;collision result (the routine already stores to this BTW)
BNE CODE_D323					;

LDA PhaseNo					;if in 75M, run platforms
CMP #Phase_75M					;
BNE CODE_D323					;

JSR CODE_D326					;handle moving platforms (lifts), can stand on 'em
STA $0C						;

CODE_D323:
LDA $0C						;
RTS						;

CODE_D326:    
LDA #$2A					;get platforms' hitbox i think
JSR CODE_C847					;

LDA #$00					;initialize platform counter
STA MovingPlatform_CurrentIndex			;

LOOP_D32F:
LDA MovingPlatform_CurrentIndex			;ran through all platforms?
CMP #$06					;
BEQ CODE_D365					;begone then
TAX						;
LDY MovingPlatform_OAMSlots_C2CC,X		;platform's OAM slots
LDA OAM_Y,Y					;
CMP #$FF					;is it offscreen?
BEQ CODE_D34E					;why bother then
STA $01						;save y-pos

LDA OAM_X,Y					;save x-pos
STA $00						;

JSR CODE_EFEF					;collision check
CMP #$01					;
BEQ CODE_D353					;did interact
  
CODE_D34E:
INC MovingPlatform_CurrentIndex			;next platform
JMP LOOP_D32F					;loop

;collision between player and platform is a success!
CODE_D353:
LDA MovingPlatform_CurrentIndex			;which platform?
CMP #$03					;>= 3 - the one that moves down
BCS CODE_D35E					;

LDA #$01					;otherwise it's a platform that moves up that the player's standing on
JMP CODE_D360					;

CODE_D35E:
LDA #$02					;standing on a down-moving platform

CODE_D360:
STA Jumpman_StandingOnMovingPlatformValue	;

LDA #$01					;successfull collision
RTS						;

CODE_D365:
LDA #$00					;not standing on any moving platform
STA Jumpman_StandingOnMovingPlatformValue	;
RTS						;

;special chcek for ledge ends in 25M
CODE_D36A:
LDA PhaseNo					;
CMP #Phase_25M					;
BEQ CODE_D373					;check if phase 1
JMP CODE_D37B					;return
  
CODE_D373:
LDA #$1C					;offset data
JSR CODE_C831					;specialized ledge end check
JMP CODE_D8AD					;handle collision
  
CODE_D37B:
LDA #$01					;won't fall (I guess its checked somewhere else)
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
LDA #%00100100					;
STA $0A						;

LDA #%01001001					;run every now and then
JSR JumpmanTiming_D9E8				;
BNE CODE_D3AF					;

LDA Jumpman_OAM_Y				;y-pos to scrath ram
STA $01						;
JMP CODE_D4CF					;skip it all

CODE_D3AF:
JSR CODE_D50A					;check if encountered ladder top or broken space
BEQ CODE_D3E7					;
CMP #$02					;02 - broken space
BNE CODE_D3BB					;
JMP CODE_D4CF					;

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
STA Jumpman_OnPlatformFlag			;we're climbing a ladder, meaning, we're not grounded
STA Jumpman_ClimbAnimCounter			;
JSR Jumpman_MoveLadderUp_D4EE			;
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
STA $02						;

LDA #$00					;
STA Jumpman_OnPlatformFlag			;again, not grounded!
STA Jumpman_ClimbOnPlatAnimCounter		;
JSR Jumpman_MoveLadderUp_D4EE			;

CODE_D40D:
LDA Jumpman_CurrentLadderXPos			;player's X-position
STA $00						;
STA Jumpman_OAM_X				;put on the ladder
JSR SpriteDrawingPREP_Draw16x16_EAD1		;draw 16x16

LDA #<Jumpman_OAM_Y				;
STA $04						;

LDA $02						;check if we've got $54 from the data above
CMP #Jumpman_GFXFrame_ClimbingFlipped		;
BEQ CODE_D426					;yes, load normal climbing frame but flip horizontally

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
CMP #$01					;
BEQ CODE_D445					;
JMP CODE_D4CF					;

CODE_D445:
LDA #%00100100					;this is pointless because of JumpmanTiming_BothBytes_D9E6 (will be set to %01001001)
STA $0A						;

LDA #%01001001					;this is also unecessary because this is stored to in the subroutine
STA $0B						;that also makes timing inconsistent (the bits will look like this: %0100100101001001, which means sometimes it'll activate every 3 frames, or 2 frames)
JSR JumpmanTiming_BothBytes_D9E6		;(most likely supposed to be JSR JumpmanTiming_D9E8)
BNE CODE_D45A					;

LDA Jumpman_OAM_Y				;temp store
STA $01						;
JMP CODE_D4CF					;check if on ground

CODE_D45A:
JSR CODE_D50A					;
BEQ CODE_D48B					;don't climb?
CMP #$02					;
BEQ CODE_D48B					;encountered broken ladder space, don't climb

;this is for when climbing down from the top of the platform
LDA Jumpman_ClimbOnPlatAnimCounter		;if timer is zero, initialize
BEQ CODE_D471					;
SEC						;
SBC #$01					;check if substracting 1 gives 0 (set to zero)
CMP #$01					;
BCC CODE_D476					;set to 1 and show only non-flipped frame
JMP CODE_D478					;just show normal climbing down animation (from the top of platform)

CODE_D471:
LDA #$0D					;timer and initial animation frame index
JMP CODE_D478					;

CODE_D476:
LDA #$01					;show non-flipped climbing frame

CODE_D478:
STA Jumpman_ClimbOnPlatAnimCounter		;
TAX						;
DEX						;
LDA DATA_C147,X					;get anim tile (or Jumpman_GFXFrame_ClimbingFlipped which is rather a command)
STA $02						;

LDA #$03					;
STA Jumpman_ClimbAnimCounter			;show flip next frame once we escape this animation
JSR Jumpman_MoveLadderDown_D4F9			;
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
LDA #$01					;accessible! somehow

CODE_D49F:
STA Jumpman_ClimbAnimCounter			;get climbing frame (w/ flip or not)
SEC						;
SBC #$01					;
TAX						;
LDA DATA_C159,X					;
STA $02						;

LDA #$00					;
STA Jumpman_ClimbOnPlatAnimCounter		;
JSR Jumpman_MoveLadderDown_D4F9			;

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
STA Jumpman_CurrentPlatformIndex		;

LDA #Jumpman_State_Grounded			;
STA Jumpman_State				;

LDA #$00					;
STA Jumpman_ClimbAnimCounter			;
STA Jumpman_ClimbOnPlatAnimCounter		;reset animation related addresses
STA Jumpman_AlternateWalkAnimFlag		;also walking animation frame

RETURN_D4ED:
RTS						;

;CODE_D4EE:
;moving jumpman (ladder)

Jumpman_MoveLadderUp_D4EE:
LDA Jumpman_OAM_Y				;move up
SEC						;
SBC #$01					;
STA $01						;
JMP CODE_D501					;

;CODE_D4F9:
Jumpman_MoveLadderDown_D4F9:
LDA Jumpman_OAM_Y				;move down
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

;check if reached ladder top or a broken ladder space from 25M
CODE_D50A:
JSR JumpmanPosToScratch_EAE1			;

LDA #$2C					;
JSR CODE_EFE8					;get collision values for player

LDA PhaseNo					;
SEC						;
SBC #$01					;
ASL A						;
TAX						;

LDA DATA_C48B,X					;hitbox positions for ladder tops
STA $04						;

LDA DATA_C48B+1,X				;
STA $05						;

LDA #<DATA_C143					;hitbox dimensions for the ladder tops
STA $06						;

LDA #>DATA_C143					;
STA $07						;

JSR CODE_D8AD					;check if on ladder
STA $08						;result

LDA PhaseNo					;if phase isn't 1, return
CMP #Phase_25M					;
BNE CODE_D544					;broken ladders are exclusive to phase 1

LDA #$1E					;hitbox of broken ladder space
JSR CODE_C831					;

JSR CODE_D8AD					;
BEQ CODE_D544					;is not a broken ladder - can continue moving

LDA #$02					;
STA $08						;on broken ladder space

CODE_D544:
LDA $08						;
RTS						;

CODE_D547:
LDA #%11111111					;
JSR JumpmanTiming_BothBytes_D9E6		;update every frame... is this even needed?
CMP #$00					;FeelsBadMan
BNE CODE_D551					;
RTS						;since it's always activated, this is never activated.

CODE_D551:
LDA Jumpman_LandingFrameCounter			;likely Jumpman_LandingFrameCounter in this context
CMP #$F0					;if not falling down after jump
BCC CODE_D55A					;move up then
JMP CODE_D60D					;move down

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
JSR CODE_EF72					;update vertical pos with y-speed and stuff (upward).

LDA $01						;calculated y-pos
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
JSR CODE_D800					;check if can grab a hammer

LDA Jumpman_JumpedFlag				;marked the player as jumped?
BEQ CODE_D5E2					;no, do so

LDA $01						;
SEC						;
SBC #$10					;if player's y-position 16 pixels lower than the initial y-pos from which the player jumped
CMP Jumpman_JumpYPos				;
BCC CODE_D5CC					;

LDA #$FF					;mark the player for death
STA Jumpman_JumpYPos				;
  
CODE_D5CC:
JSR CODE_D2CB					;check collision with a platform
STA Jumpman_OnPlatformFlag			;
BEQ CODE_D5F1					;if didn't land, keep jumping frame

LDA HitboxB_YPos_Top				;platform is hitbox B
SEC						;
SBC #$11					;
STA Jumpman_OAM_Y				;place the player on top of the platform

LDA #$01					;
STA Jumpman_OnPlatformFlag			;make it 1 again?
JMP CODE_D5F6					;show landing gfx frame

;Jumpman performs jump action
CODE_D5E2:
LDA #Sound_Effect2_Jump				;sound effect
STA Sound_Effect2				;

LDA #$01					;
STA Jumpman_JumpedFlag				;now we're sure the player has jumped

LDA $01						;y-pos thing
STA Jumpman_JumpYPos				;
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

LDA #$F0					;set jumped flag to this value so it can act as landing frame counter
STA Jumpman_LandingFrameCounter			;
RTS						;

CODE_D60D:
INC Jumpman_LandingFrameCounter			;some kinda timer
LDA Jumpman_LandingFrameCounter			;
CMP #$F4					;
BNE RETURN_D64F					;

LDA Jumpman_JumpYPos				;is this address FF?
CMP #$FF					;
BEQ CODE_D642					;means the player had dropped from a high ledge, meaning RIP

;non-lethal landing
LDA #Jumpman_GFXFrame_Stand			;
JSR CODE_F070					;

LDA #$00					;
STA Jumpman_GravityInitFlag			;y-speed related
STA Jumpman_JumpedFlag				;also known as Jumpman_LandingFrameCounter
STA Jumpman_JumpYPos				;

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
LDA #$00					;same address clearing shenanigans as for safe landing! C'mon
STA Jumpman_GravityInitFlag			;
STA Jumpman_JumpedFlag				;
STA Jumpman_JumpYPos				;

LDA #Jumpman_State_Dead				;
STA Jumpman_State				;

RETURN_D64F:
RTS						;

;----------------------------------------------
;!UNUSED
;a block of code related with some hitbox colliding with jumpman, making him fall off. potentially related to the scrapped 50M (I would've said it's related to the moving platforms from 75M, but the OAM locations don't match)

UNUSED_D650:
LDA #$FE					;a terminator for the collision check stuff
STA UnusedCollisionTable_0460+18		;
STA UnusedCollisionTable_0460+19		;twice, because why not

LDX #$00					;
LDY #24*4					;starting OAM slot is 24

CODE_D65C:
LDA OAM_Y,Y					;is this something even on screen?
CMP #$FF					;
BEQ CODE_D672					;negative, move stuff elsewhere
STA UnusedCollisionTable_0460+1,X		;Y-pos

LDA OAM_X,Y					;X-pos, and move to the left 8px
SEC						;
SBC #$08					;
STA UnusedCollisionTable_0460,X			;
JMP CODE_D67A					;

CODE_D672:
LDA #$00					;practically no hitbox (actually it's just at the very top-left of the screen, but shh)
STA UnusedCollisionTable_0460+1,X		;
STA UnusedCollisionTable_0460,X			;

CODE_D67A:
TYA						;
CLC						;
ADC #$08					;confirmed that this entity takes 2 OAM slots
TAY						;
INX						;
INX						;
INX						;third byte is supposed to an offset for the collision table, and should be left at 0
CPY #36*4					;6 of these unknown entities (36-24, then divide by 2).
BNE CODE_D65C					;

LDA #$20					;prepare tables
JSR CODE_C831					;collision detection... with ALL of these unknown thingas
JSR CODE_D8AD					;
BEQ RETURN_D696					;no collision at all

LDA #Jumpman_State_Falling			;whatever we just collided with, we fall off.
STA Jumpman_State				;

LDA #$01					;did actually collide

RETURN_D696:
RTS						;
;----------------------------------------------

;Jumpman is falling!!! AAA
CODE_D697:
LDA #%11111111					;update... always?
JSR JumpmanTiming_BothBytes_D9E6		;
BEQ RETURN_D6C5					;

JSR JumpmanPosToScratch_EAE1			;
INC $01						;fall down & quick!
INC $01						;

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
LDA Timer_Hammer				;check for hammer timer
BNE CODE_D6CD					;continue hammering the point home
JMP CODE_D7BF					;oops, I don't have any more quarters to insert to make the hammer work again

CODE_D6CD:
LDA #%11011011					;
STA $0A						;

LDA #%00110110					;
JSR JumpmanTiming_D9E8				;
BNE CODE_D6D9					;every some frames, do hammer stuff.
RTS						;

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
LDA Hammer_AnimationFrameCounter		;rotate this counter
ASL A						;
STA Hammer_AnimationFrameCounter		;the bit has been cleared
BEQ CODE_D6F2					;
JMP CODE_D753					;don't animate

CODE_D6F2:  
LDA #%00100000					;
STA Hammer_AnimationFrameCounter		;will activate after 3 frames

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
STA Hammer_JumpmanFrame
JMP CODE_D753

CODE_D70A:
INC Jumpman_OAM_X				;move right
JMP CODE_D713

CODE_D710:
DEC Jumpman_OAM_X				;move left

CODE_D713:
JSR CODE_D2CB
STA Jumpman_OnPlatformFlag			;stay on platform i think

LDA Jumpman_OAM_Y				;
JSR CODE_E016					;
STA Jumpman_CurrentPlatformIndex		;

JSR CODE_D8EB					;
BEQ CODE_D73E					;

LDX PhaseNo					;
CPX #Phase_25M					;
BNE CODE_D732					;
CLC						;
ADC Jumpman_OAM_Y				;
STA Jumpman_OAM_Y				;

CODE_D732:  
JSR CODE_D36A					;see if the player is standing on a platform
BEQ CODE_D73E					;if so, keep hammering

LDA #Jumpman_State_Falling			;fell off the platform, oopsie!
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
LDA Jumpman_HammerWalkingAnimFrames_C1A2,X	;from this beautiful little table              
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

LDA #Jumpman_State_Grounded			;jumpman is grounded
STA Jumpman_State				;

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
JSR CODE_E016					;get what platform jumpman's on
STA Jumpman_CurrentPlatformIndex		;

LDA PhaseNo					;get a platform from which you can get a hammer, depending on phase
SEC						;
SBC #$01					;
ASL A						;
TAX						;
LDA Jumpman_CurrentPlatformIndex		;
CMP DATA_C1A8,X					;yes on the platform
BEQ CODE_D849					;
INX						;
CMP DATA_C1A8,X					;yes on a different platform
BEQ CODE_D849					;
JMP CODE_D8A8					;

CODE_D849:
TXA						;check what hammer can get
AND #$01					;
BEQ CODE_D867					;

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
JMP CODE_D87D					;

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

LDA #$19					;change flame enemies' color (setup VRAM first)
STA $00						;

LDA #$3F					;
STA $01						;

LDA #$46					;
JSR CODE_C815					;save to buffer

RETURN_D8A7:
RTS						;

CODE_D8A8:
LDA #$00					;no hammer thank you very much
STA Jumpman_HeldHammerIndex			;
RTS						;

;check collision between player and something (be it a platform shift or a broken ladder) using pointers for hitbox position and width/height
CODE_D8AD:
LDA #$F3					;idk
STA $0B						;

LDA #$00					;
STA $86						;pointless cuz this is overwritten afterwards

LDY #$00					;
LDA ($04),Y					;

LOOP_D8B9:
STA $00						;x-pos
INY						;
LDA ($04),Y					;
STA $01						;y-pos
INY						;
LDA ($04),Y					;
CLC						;
ADC $06						;offset for indirect
STA $02						;

LDA $07						;high byte
ADC #$00					;
STA $03						;

STY $86						;preserve Y
JSR CODE_EFF3					;
BNE CODE_D8E1					;A != 0 - overlap occured (hitbox collision)

LDY $86						;
INY						;
LDA ($04),Y					;check for stop command
CMP #$FE					;
BEQ CODE_D8E6					;terminate
JMP LOOP_D8B9					;keep on looping

CODE_D8E1:
LDA #$01					;contact success
JMP CODE_D8E8					;

CODE_D8E6:
LDA #$00					;contact epic fail

CODE_D8E8:  
STA $0C						;
RTS						;

CODE_D8EB:
LDA Jumpman_OnPlatformFlag			;player platformed?
BNE CODE_D917					;sure

LDA Jumpman_CurrentPlatformIndex		;
BEQ CODE_D917					;on no platform?
AND #$01					;every other platform
BNE CODE_D904					;something to do with movement...

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
;collision with platforms
;with slightly curved platforms/slope platforms/what ever the hell (and the extended platform part at the very bottom)
CODE_D91A:
LDA Jumpman_OAM_Y				;get player's Y position
CLC						;and add 8
ADC #$08					;
JSR CODE_E016					;get which platform he's on
STA Jumpman_CurrentPlatformIndex		;if player's on the very low platform (at the beginning)
CMP #$01					;
BEQ CODE_D938					;don't check for ladders, i think?

LDX #$02					;start checking which platform the jumpman's on, starting from the second one
LDA #$06*2					;skip over two first 6 byte long entries

LOOP_D92D:
CPX Jumpman_CurrentPlatformIndex		;check if it is a platform 2 onward
BEQ CODE_D93B					;
CLC						;
ADC #$06					;next 6-byte, one per platform
INX						;
JMP LOOP_D92D					;

CODE_D938:
SEC						;-1 (because platform counts from 1)
SBC #$01					;

CODE_D93B:
TAX						;and into index

LOOP_D93C:
LDA #$00					;start from the lowest elevation/shift or what have you
STA Platform_ShiftIndex				;

LDA DATA_C08C,X					;
STA $00						;base x-pos

INX						;
LDA DATA_C08C,X					;
STA $01						;base y-pos

INX						;
LDA DATA_C08C,X					;offset for the hitbox
CLC						;
ADC $06						;
STA $02						;indirect pointer

LDA $07						;
STA $03						;more pointer stuff (that assumes high byte is the same?)

INX						;
LDA DATA_C08C,X					;
STA $08						;x-pos disposition between each platform platform

INX						;
LDA DATA_C08C,X					;max shifts
STA $09						;

LOOP_D964:
JSR CODE_EFEF					;check platform collision
BNE CODE_D98B					;

LDA $00						;platform bit x-pos
CLC						;
ADC $08						;+offset
STA $00						;new x-pos

DEC $01						;higher by 1 pixel
INC Platform_ShiftIndex				;check slightly higher

LDA $09						;
CMP Platform_ShiftIndex				;
BNE LOOP_D964					;
INX						;
LDA DATA_C08C,X					;
CMP #$FE					;end command
BEQ CODE_D986					;if not on any platform, not grounded
INX						;
JMP LOOP_D93C					;check other platform bits (lowest platform only)

CODE_D986:
LDA #$00					;
JMP CODE_D98D					;

CODE_D98B:
LDA #$01					;

CODE_D98D:
STA Jumpman_OnPlatformFlag			;most uncertanly on platform
RTS						;

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

LDX Jumpman_CurrentPlatformIndex		;what is this for
CMP #Phase_75M					;if phase is 75M, the platform is slightly lower
BEQ CODE_D9D0					;counts as did interact (huh?)
CPX #$06					;
BNE CODE_D9E3					;
JMP CODE_D9D4					;

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

;used for player to run his routines depending on current frame
;uses bitwise check for which frame to update the player's stuff
;input:
;$0A - timing for the first 8 bits
;$0B - timing for the last 8 bits
;Example of how it works:
;$0A = $88 - %10001000
;$0B = $88 - %10001000
;$88 = 0 - checks bit 0 of $0A - don't run the routine
;$88 = 8 - checks bit 0 of $0B - don't run the routine
;$88 = 3 - checks bit 3 of $0A - run the routine
;and so on

JumpmanTiming_BothBytes_D9E6:
STA $0A						;

JumpmanTiming_D9E8:
STA $0B						;

INC Jumpman_TimingCounter			;
LDA Jumpman_TimingCounter			;doesn't check for negative interestingly enough (unlike other similar routines later on)
CMP #$0F					;if 15, reset and do a thing (that means it skips over a single bit...)
BCS CODE_D9F5					;reset
JMP CODE_D9F9					;

CODE_D9F5:
LDA #$00					;
STA Jumpman_TimingCounter			;start checking from bit 0 again

CODE_D9F9:
CMP #$08					;check if more than 8
BCS CODE_DA06					;then substract
TAX						;
LDA DATA_C1BC,X					;
AND $0A						;check bits from A
JMP CODE_DA0F					;

CODE_DA06:
SEC						;-8 to get proper index
SBC #$08					;
TAX						;
LDA DATA_C1BC,X					;
AND $0B						;check bits from B

CODE_DA0F:
BEQ CODE_DA13					;

LDA #$01					;output 1 and run whatever's after this

CODE_DA13:
STA Jumpman_ActingFlag				;wether jumpman is doing something or not, store here
RTS						;

RunBarrels_DA16:
JSR CODE_E166					;count all entities on all platforms

LDA #$00					;
STA Barrel_CurrentIndex				;

JP_LOOP_DA19:
LOOP_DA1D:
JSR GetBarrelOAM_EFD5				;

LDA OAM_Y,X					;see if the barrel doesn't exist
CMP #$FF					;
BNE CODE_DA3D					;it does, run

LDA Timer_EntitySpawn				;check if timer for barrel spawn is up
BNE CODE_DA40					;if not, dont spawn

LDA #Barrel_State_Init				;barrel's init state
LDX Barrel_CurrentIndex				;load barrel index
STA Barrel_State,X				;store enable bit

LDA #$10					;barrel hold timer, basically it'll stay in place for this amount of frames
STA Timer_BarrelHold				;

JSR GetCurrentDifficulty_EAF7			;get difficuly
LDA CODE_C443,X					;load timer for next barrel throw
STA Timer_EntitySpawn				;

CODE_DA3D:
JSR CODE_DA4C					;run barrel code

CODE_DA40:
LDA Barrel_CurrentIndex				;BarrelIndex = BarrelIndex + 1        
CLC						;makes me think that this was either written in higher level language (or the programmer was just lazy to optimize)
ADC #$01					;INC BarrelIndex would look like BarrelIndex++
STA Barrel_CurrentIndex				;anyway, yeah... a way to go
CMP #$09					;well, you could INC then LDA, it'd still be more optimal.

If Version = JP
  BEQ JP_RETURN_DA4A				;
  JMP JP_LOOP_DA19				;bad nintendo, bad!
else
  BNE LOOP_DA1D					;wow, they actually optimized something in this code in revision 1! :clap: :clap: :clap:
endif

JP_RETURN_DA4A:
RTS						;

;Run barrel states
CODE_DA4C:
LDX Barrel_CurrentIndex				; 
LDA Barrel_State,X				;various barrel states w/ very specific values
CMP #Barrel_State_Init				;general initialization, become vertical or horizontal
BEQ CODE_DA7D					;
CMP #Barrel_State_HorzTossInit			;appear to the side and start moving
BEQ CODE_DA80					;
CMP #Barrel_State_HorzMovement			;
BEQ CODE_DA83					;horizontal move on platform
CMP #Barrel_State_GoDownLadder			;
BEQ CODE_DA86					;going down a ladder
CMP #Barrel_State_VertMovement			;
BEQ CODE_DA89					;tossed down
CMP #Barrel_State_VertMovementBounce		;
BEQ CODE_DA89					;bounced off a platform on its tossed way down
CMP #Barrel_State_HorzMovementAfterVertToss	;
BEQ CODE_DA89					;recover from being tossed down and move horizontally
CMP #Barrel_State_DropOffPlatform		;
BEQ CODE_DA8F					;didnt go down any of the ladders and approached a ledge end... uh oh!
CMP #Barrel_State_LandedOnPlatform		;
BEQ CODE_DA92					;after landing on the platform, bounce
CMP #Barrel_State_GoOffscreen			;
BEQ CODE_DA95					;after landing on the platform, just go offscreen
CMP #Barrel_State_GoDownPanic			;
BEQ CODE_DA98					;vertical movement, except it's from the hammer threat
RTS						;unused RTS. Cool.

CODE_DA7D:
JMP CODE_DA9C					;toss init

CODE_DA80:
JMP CODE_DB00					;toss side init

CODE_DA83:
JMP CODE_DB2C					;horizontally move like normal

CODE_DA86:
JMP CODE_DC30					;going down the ladder

CODE_DA89:
LDA $0421,X					;all states related to being tossed down
JMP CODE_DD8B					;

CODE_DA8F:
JMP CODE_DC69					;falling down from platform to platform

CODE_DA92:  
JMP CODE_DCD0					;landed from platform to platform and bounces

CODE_DA95:
JMP CODE_DD32					;go offscreen

CODE_DA98:
JSR CODE_DF07					;not JMP this time, HMM?
RTS						;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;BARREL STATE - ABOUT TO BE TOSSED
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CODE_DA9C:
JSR GetBarrelOAM_EFD5				;

LDA #$30					;
STA $00						;

If Version = JP
  LDA #$30					;another minor optimization they did in revision 1. we had 30 already loaded before. nintendo was still incredibly lazy to clean up everything.
endif
STA $01						;

LDA #Barrel_GFXFrame_Vertical1			;
STA $02						;
STX $04						;save OAM slot
JSR CODE_EADB					;draw the barrel

LDA Timer_BarrelHold				;are we still holding the barrel?
BNE RETURN_DAFF					;well, hold still

LDA #Barrel_State_HorzTossInit			;horizontal kind probably
LDX Barrel_CurrentIndex				;
STA Barrel_State,X				;

LDA #$00					;this will make horizontal barrel initialize in 2 frames
STA Entity_TimingCounter,X			;

LDA Flame_State					;check if the oil barrel has been lit
BEQ CODE_DAC3					;if not, the first barrel must be vertical
JMP CODE_DAD5					;

CODE_DAC3:
LDA Barrel_CurrentIndex				;check barrel's index
BNE RETURN_DAFF					;the vertical is only one and only slot 0

LDA #Barrel_State_VertMovement			;vertical barrel thing
LDX Barrel_CurrentIndex				;
STA Barrel_State,X				;

LDA #Barrel_VertTossPattern_StraightDown	;down it goes
STA Barrel_VertTossPattern,X			;
JMP CODE_DAF7					;

CODE_DAD5:
LDA Timer_ForVertBarrelToss			;timer for the next vertical barrel toss
BNE RETURN_DAFF					;

LDA Barrel_CurrentIndex				;ORA - exists
BNE RETURN_DAFF					;Nintendo - lol, no

LDA #Barrel_State_VertMovement			;start moving down
LDX Barrel_CurrentIndex				;
STA Barrel_State,X				;

LDA Barrel_VertTossPattern,X			;check if it has moved straight down last time, will alternate patterns
CMP #Barrel_VertTossPattern_StraightDown	;
BNE CODE_DAF2					;

LDA #Barrel_VertTossPattern_LeftAndRight	;left & right wave-like pattern
STA Barrel_VertTossPattern,X			;
JMP CODE_DAF7					;

CODE_DAF2:
LDA #Barrel_VertTossPattern_StraightDown	;straight down again
STA Barrel_VertTossPattern,X			;

CODE_DAF7:
JSR GetCurrentDifficulty_EAF7			;load difficulty

LDA DATA_C44D,X					;
STA Timer_ForVertBarrelToss			;time for vertical barrel toss (the harder the game, the more frequent it is)

RETURN_DAFF:
RTS						;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;BARREL STATE - GOT TOSSED HORIZONTALLY
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CODE_DB00:
LDA #%01010101					;every other frame (for the entity's frame counter)
JSR PlatformAndBarrelTiming_BothBytes_DFE4	;
BNE CODE_DB21					;since the entity's frame counter was set to 0, first frame it won't trigger this, it'll init its position to the side and make kong display his frame

JSR GetBarrelOAM_EFD5				;

LDA #Barrel_HorzTossXPos			;set x-pos
STA $00						;

LDA #Barrel_HorzTossYPos			;
STA $01						;

LDA #Barrel_GFXFrame_UpRight			;
STA $02						;
STX $04						;barrel's OAM slot
JSR CODE_EADB					;actually put the barrel on-screen

INC Kong_TossToTheSideFlag			;show kong's "toss to the side" frame
JMP RETURN_DB2B					;and jump, instead of just, y'know... using RTS!?

;on the second frame it actually starts moving
CODE_DB21:
LDX Barrel_CurrentIndex				;

LDA #Barrel_State_HorzMovement			;defo start moving right
STA Barrel_State,X				;

LDA #Barrel_GFXFrame_UpRight			;start with this frame
STA Barrel_GFXFrame,X				;

RETURN_DB2B:
RTS						;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;BARREL STATE - ROLLS HORIZONTALLY
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CODE_DB2C:
LDA #%11111111					;move every frame... which makes this call redundant
JSR PlatformAndBarrelTiming_BothBytes_DFE4	;
BNE CODE_DB34					;
RTS						;of course it moves every frame, making this unused. Hmm, an unused RTS, can't wait to document this on The Cutting Room Floor!

CODE_DB34:
JSR GetBarrelOAM_EFD5				;get barrel's OAM
PHA						;
JSR EntityPosToScratch_EAEC			;barrel's pos

LDA $01						;
JSR CODE_E016					;get which platform the barrel's on based on Y-pos

LDY Barrel_CurrentIndex				;
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

JSR CODE_E048					;check shift flag and everything
CLC						;check if shifted down
ADC $01						;new Y-pos
STA $01						;

JSR CODE_DBEE					;animate the barrel

LDX Barrel_CurrentIndex				;
LDA Barrel_GFXFrame,X				;barrel's GFX frame
JSR SpriteDrawingPREP_StoreTile_EAD4		;get some prep for drawing
PLA						;
TAX						;X - OAM!
JSR CODE_F080					;redraw da barrel!

LDA $00						;X-pos
JSR CODE_E0AE					;check for ladder
BEQ CODE_DBAC					;if no laddder, don't try to go down

JSR GetCurrentDifficulty_EAF7			;get some value to compare with RNG value
LDA DATA_C448,X					;which is all 88 btw
AND RNG_Value+1					;
BNE CODE_DBAC					;bits set, don't go down

LDX Barrel_CurrentIndex				;
LDA Barrel_CurrentPlatformIndex,X		;
TAX						;
DEX						;
LDA EntitiesPerPlatform,X			;check if there are 4+ entities on the platform below
CMP #$04					;
BCS CODE_DBAC					;if that's the case, it won't take the ladder (there's probably enough barrels and Jumpman, all sorts of unpleasantries)

LDA Jumpman_State				;if player is climbing, always go down the ladder
CMP #Jumpman_State_Climbing			;
BNE CODE_DBA3					;

LDX $04						;
LDA OAM_Y,X					;if the barrel is lower than (or at the same height as) the player
CMP Jumpman_OAM_Y				;
BCS CODE_DBA3					;always go down
CLC						;
ADC #$0F					;check one tile lower (almost one tile as it's 15 pixels)
CMP Jumpman_OAM_Y				;the barrel was higher, check again but lower
BCS CODE_DBAC					;if the result is lower, don't go down

CODE_DBA3:
LDA #Barrel_State_GoDownLadder			;roll down the ladder
LDX Barrel_CurrentIndex				;
STA Barrel_State,X				;
DEC Barrel_CurrentPlatformIndex,X		;set to be on lower platform
RTS						;

CODE_DBAC:
LDA $00						;x-pos
JSR CODE_E090					;check for platform edge
BEQ CODE_DBB6					;not appraching an edge
JMP CODE_DBE7					;yes drop

CODE_DBB6:
JSR CODE_DF40					;potentially escape Jumpman's hammer wrath

LDX Barrel_CurrentIndex				;
LDA Barrel_CurrentPlatformIndex,X		;yes, check the lowest platform
CMP #$01					;
BNE RETURN_DBED					;if not on lowest platform, return

JSR CODE_DFC3					;background priority

LDA $00						;check X-pos for oil barrel
CMP #$20					;
BEQ CODE_DBCD					;equal or less, spawn flame
BCC CODE_DBCD					;
RTS						;

CODE_DBCD:
LDA #Barrel_OAMProp				;that removes BG priority bit
STA $02						;

LDA #$04					;the barrel consists of 4 8x8 tiles, so remove 4 tiles.
STA $03						;

JSR CODE_F08E					;remove barrel

LDA #$01					;set oil ablaze
STA Flame_State					;

LDA #$00					;set as non-existent
LDX Barrel_CurrentIndex				;
STA Barrel_CurrentPlatformIndex,X		;on no platform

LDA #Sound_Effect_Hit				;hit sound
STA Sound_Effect				;
RTS						;

CODE_DBE7:
LDX Barrel_CurrentIndex				;

LDA #Barrel_State_DropOffPlatform		;dropping from the ledge state
STA Barrel_State,X				;

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
ADC #$04					;
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;BARREL STATE - MOVES DOWN THE LADDER
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CODE_DC30:
LDA #%01010101					;only update every other frame
JSR PlatformAndBarrelTiming_BothBytes_DFE4	;
BEQ RETURN_DC68					;return on odd frames

JSR GetBarrelOAM_EFD5				;
STX $04						;remember OAM slot

JSR EntityPosToScratch_EAEC			;
INC $01						;go down one pixel

LDY Barrel_CurrentIndex				;why Y btw? to waste a whopping byte?
LDA Barrel_GFXFrame,Y				;no zero page,y for you
CMP #Barrel_GFXFrame_Vertical1			;
BNE CODE_DC4F					;alternate between frames.

LDA #Barrel_GFXFrame_Vertical2			;if displayed the first frame, display the next frame.
JMP CODE_DC51					;

CODE_DC4F:
LDA #Barrel_GFXFrame_Vertical1			;

CODE_DC51:
STA $02						;

LDX Barrel_CurrentIndex				;
STA Barrel_GFXFrame,X				;
JSR CODE_EADB					;redraw

LDA $01						;check y-pos
LDX Barrel_CurrentIndex				;
CMP Barrel_LadderYDestination,X			;did it reach the end of the ladder?
BNE RETURN_DC68					;

LDX Barrel_CurrentIndex				;

LDA #Barrel_State_HorzMovement			;moved down to the platform, now continue moving horizontally
STA Barrel_State,X				;

RETURN_DC68:
RTS						;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;BARREL STATE - FELL OFF (OFF THE PLATFORM)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CODE_DC69:
LDA #%11111111					;
JSR PlatformAndBarrelTiming_BothBytes_DFE4	;
BNE CODE_DC71					;always runs so this is pointless.
RTS						;NOT EXECUTED, duh!

CODE_DC71:
JSR GetBarrelOAM_EFD5				;
STX $04						;

JSR EntityPosToScratch_EAEC			;

INC $01						;vertical move down 1 pixel

LDA $01						;only move horizontally every y-position increment (basically every other frame)
AND #$01					;
BEQ CODE_DC90					;

LDX Barrel_CurrentIndex				;based on where the barrel is vertically
LDA Barrel_CurrentPlatformIndex,X		;move left or right
AND #$01					;
BEQ CODE_DC8E					;

DEC $00						;move left
JMP CODE_DC90					;

CODE_DC8E:
INC $00						;move right

CODE_DC90:
JSR CODE_DBEE					;animate

LDX Barrel_CurrentIndex				;
LDA Barrel_GFXFrame,X				;
STA $02						;
JSR CODE_EADB					;update barrel GFX

LDA #$32					;indirect access to DATA_C1CF
JSR CODE_C853					;

LDA $01						;check if landed on lower platform
JSR CODE_E112					;
BEQ RETURN_DCCF					;

LDX Barrel_CurrentIndex				;
LDA #Barrel_State_LandedOnPlatform		;landed bounce state (by default it'll bounce slightly and move on)
STA Barrel_State,X				;

JSR CODE_E130					;if barrel is above jumpman...
BEQ CODE_DCBC					;check something else

LDA RNG_Value+1					;check RNG...
AND #$01					;
BEQ CODE_DCBC					;it's basically 50/50 between guaranteed offscreen exit and checking for all the entities, then considering taking it
JMP CODE_DCC9					;

CODE_DCBC:
LDX Barrel_CurrentIndex				;
LDA Barrel_CurrentPlatformIndex,X		;
TAX						;
DEX						;
LDA EntitiesPerPlatform,X			;are there 4 entities or more on the same platform?
CMP #$04					;
BCS CODE_DCC9					;it's too crowded
RTS						;

CODE_DCC9:
LDX Barrel_CurrentIndex				;

LDA #Barrel_State_GoOffscreen			;exit the stage
STA Barrel_State,X				;

RETURN_DCCF:
RTS						;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;BARREL STATE - BOUNCE FROM LANDING
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CODE_DCD0:
LDA #%01110111					;skip every 4th frame
JSR PlatformAndBarrelTiming_BothBytes_DFE4	;
BNE CODE_DCD8					;
RTS						;

CODE_DCD8:
JSR GetBarrelOAM_EFD5				;
STX $04						;

JSR EntityPosToScratch_EAEC			;

LDA $01						;
JSR CODE_E016					;get which platform's on

LDX Entity_TimingIndex				;
STA Barrel_CurrentPlatformIndex,X		;
AND #$01					;depending on the platform, it'll bounce to the right or to the left (where it should roll normally)
BNE CODE_DD00					;

INC $00						;roll right

LDA $00						;
LDX #$00					;

LOOP_DCF3:
CMP DATA_C3FC,X					;depending on its x-position...
BEQ CODE_DD13					;affect its y-position to simulate the bounce
INX						;
CPX #$0B					;
BEQ CODE_DD25					;
JMP LOOP_DCF3					;

CODE_DD00:
DEC $00						;roll left

LDA $00						;
LDX #$00					;

LOOP_DD06:
CMP DATA_C412,X					;a different set of x-positions to check (bouncing to the left)
BEQ CODE_DD13					;
INX						;
CPX #$0B					;
BEQ CODE_DD25					;
JMP LOOP_DD06					;

CODE_DD13:
LDA $01						;
CLC						;
ADC DATA_C407,X					;
STA $01						;change its y-position
CPX #$0A					;
BNE CODE_DD25					;check if done with this bounce motion thing, if not, don't snap out of it

LDX Barrel_CurrentIndex				;
LDA #Barrel_State_HorzMovement			;become normal barrel being
STA Barrel_State,X				;

CODE_DD25:
JSR CODE_DBEE					;standard animation

LDX Barrel_CurrentIndex				;
LDA Barrel_GFXFrame,X				;
STA $02						;
JSR CODE_EADB					;update its gfx
RTS						;

CODE_DD32:
LDA #%01010101					;move every other frame...
JSR PlatformAndBarrelTiming_BothBytes_DFE4	;
BNE CODE_DD3A					;
RTS						;

CODE_DD3A:
JSR GetBarrelOAM_EFD5				;
STX $04						;

JSR EntityPosToScratch_EAEC			;

LDA $01						;
JSR CODE_E016					;grab the platform by its tail (err, I mean its value)

LDX Barrel_CurrentIndex				;
STA Barrel_CurrentPlatformIndex,X		;go offscreen left or right, depending on the platform
AND #$01					;
BNE CODE_DD60					;

DEC $00						;go left

LDA $01						;I guess this is supposed to fix its y-position?
CMP #$14					;
BNE CODE_DD59					;

DEC $01						;untriggered (supposed to move the barrel up)

CODE_DD59:
LDA $00						;check for left end of the screen
BNE CODE_DD73					;
JMP CODE_DD7F					;if it reached the screen boundary, should disappear

CODE_DD60:
INC $00						;go right

LDA $01						;another edge case, y-position where it shouldn't be
CMP #$EC					;
BNE CODE_DD6A					;rules are made to follow, so it does, in fact, not reach that

DEC $01						;untriggered (again, move the barrel up)

CODE_DD6A:
LDA $00						;
CMP #$F4					;check if reached the right end of the screen
BNE CODE_DD73					;
JMP CODE_DD7F					;disappear

CODE_DD73:
JSR CODE_DBEE					;animation is hard

LDX Barrel_CurrentIndex				;
LDA Barrel_GFXFrame,X				;
STA $02						;
JMP CODE_EADB					;surprised its a JMP this time instead of JSR : RTS

CODE_DD7F:
LDA #$22					;remove barrel from the face of this earth
JSR CODE_F092					;

LDA #$00					;
LDX Barrel_CurrentIndex				;
STA Barrel_CurrentPlatformIndex,X		;clear its platform position
RTS						;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;BARREL STATE - TOSSED DOWN (3 SEPARATE STATES IN ONE)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CODE_DD8B:
STA $07						;saves Barrel_VertTossPattern,x

LDX Barrel_CurrentIndex				;
LDA Barrel_State,X				;
CMP #Barrel_State_HorzMovementAfterVertToss	;is it becoming normal horizontal moving barrel?
BNE CODE_DD98					;
JMP CODE_DE82					;well, good.

CODE_DD98:
CMP #Barrel_State_VertMovementBounce		;is it bouncing off the platform?
BEQ CODE_DDD7					;

;STATE Barrel_State_VertMovement
LDA $07						;
CMP #Barrel_VertTossPattern_DiagonalRight	;UNUSED PATTERN!!!
BEQ CODE_DDAB					;
CMP #Barrel_VertTossPattern_LeftAndRight	;
BEQ CODE_DDB0					;

LDA #$34					;y-positions to check for straight vertical pattern
JMP CODE_DDB2					;

CODE_DDAB:
LDA #$36					;normally unused
JMP CODE_DDB2					;y-positions to check for this unused diagonal pattern

CODE_DDB0:
LDA #$38					;y-positions to check for left and right wave pattern

CODE_DDB2:
JSR CODE_C853					;get the pointer to these values

JSR GetBarrelOAM_EFD5				;
STX $04						;

LDA OAM_Y,X					;
JSR CODE_E112					;check if the barrel hit any platforms lately

LDY $0A						;last platform?
CPY #$04					;
BNE CODE_DDC9					;
JMP CODE_DE73					;landed on the last platform, will become normal soon

CODE_DDC9:
CMP #$00					;did it land?
BEQ CODE_DDD7					;if not, well...

LDX Barrel_CurrentIndex				;
LDA #$01					;
STA Entity_TimingCounter,X			;

LDA #Barrel_State_VertMovementBounce		;...but if it did, it bounced on a platform (moving down)
STA Barrel_State,X				;

;STATE Barrel_State_VertMovementBounce (also executed when in state Barrel_State_VertMovement as well)
CODE_DDD7:
JSR GetBarrelOAM_EFD5				;
STX $04						;

LDX Barrel_CurrentIndex				;
LDA Barrel_State,X				;
CMP #Barrel_State_VertMovementBounce		;
BNE CODE_DE13					;bounce or no

LDA #%00100000					;runs after 8 frames (together would be 0010000000100000, which means first run it'll activate on 6th frame, then it'll become consistent every 8th frame after)
JSR PlatformAndBarrelTiming_BothBytes_DFE4	;
BNE CODE_DDF5					;(actually, it'll SKIP every 8 frames?)

LDX $04						;
LDA OAM_Y,X					;
STA $01						;
JMP CODE_DE27					;

CODE_DDF5:
LDX Barrel_CurrentIndex				;
LDA #Barrel_State_VertMovement			;
STA Barrel_State,X				;resume being tossed down

LDA $07						;
CMP #Barrel_VertTossPattern_LeftAndRight	;
BNE CODE_DE10					;only left/right pattern can change horizontal direction

LDA Barrel_VertTossHorzMovementDir,X		;change its movement direction (Nintendo hasn't learned about EOR yet... OH WAIT, MY BAD, THEY USED EOR BEFORE)
BEQ CODE_DE0B					;

LDA #$00					;move 
JMP CODE_DE0D					;

CODE_DE0B:
LDA #$01					;

CODE_DE0D  
STA Barrel_VertTossHorzMovementDir,X		;

CODE_DE10:
JMP CODE_DE1A					;

CODE_DE13:
LDA #%11111111					;move every frame (pointless)
JSR PlatformAndBarrelTiming_BothBytes_DFE4	;
BEQ RETURN_DE85					;

CODE_DE1A:
LDX $04						;
LDA #$01					;
CLC						;move down 1 px
ADC OAM_Y,X					;
STA $01						;

JSR CODE_DE86					;more down movement..........

;handle barrel's left and right motion (if applicable)
CODE_DE27:
INX						;this is not necessary if you could just, y'know... load OAM_X directly???
INX						;
INX						;(I made it so it's OAM_X but also added -3, to make the code clearer that we're modifying x-pos here, while preserving the original address)

LDA $07						;unused barrel pattern?
CMP #Barrel_VertTossPattern_DiagonalRight	;
BNE CODE_DE36					;(yes, it is)

INC OAM_X-3,X					;\just move to the right
JMP CODE_DE56					;/

CODE_DE36:
CMP #$03					;move left AND right
BNE CODE_DE56					;

LDA $01						;every other y-pos pixel...
AND #$01					;
BEQ CODE_DE56					;

LDY Barrel_CurrentIndex				;
LDA Barrel_VertTossHorzMovementDir,Y		;move in this direction
BNE CODE_DE50					;

INC OAM_X-3,X					;moves right two pixels
INC OAM_X-3,X					;
JMP CODE_DE56					;

CODE_DE50:
DEC OAM_X-3,X					;moves left two pixies (this is intentional. that's what I call a haha funny joke)
DEC OAM_X-3,X					;

CODE_DE56:
LDA OAM_X-3,X					;
STA $00						;final x-pos

LDX Barrel_CurrentIndex				;
LDA Barrel_GFXFrame,X				;animate the barrel and its silly vertical movement
CMP #Barrel_GFXFrame_Vertical1			;
BNE CODE_DE68					;

LDA #Barrel_GFXFrame_Vertical2			;
JMP CODE_DE6A					;

CODE_DE68:
LDA #Barrel_GFXFrame_Vertical1			;

CODE_DE6A:
STA $02						;

LDX Barrel_CurrentIndex				;
STA Barrel_GFXFrame,X				;resulting frame
JMP CODE_EADB					;update gfx (GraFiX)

CODE_DE73:
LDA #Barrel_State_HorzMovementAfterVertToss	;landed on the last platform, will turn into normal soon enough
LDX Barrel_CurrentIndex				;
STA Barrel_State,X				;

LDX $04						;
LDA OAM_X,X					;
STA Barrel_VertTossLandingXPos			;landed at this pos
RTS						;

;STATE Barrel_State_HorzMovementAfterVertToss
CODE_DE82:
JSR CODE_DEA5					;move horizontally BUT WITH CHECKS!!

RETURN_DE85:
RTS						;

;accelerate down at certain points (likely after it bounced off the platform (only if it's moving straight down without left/right movement)
CODE_DE86:
LDA $07						;left/right movement?
CMP #Barrel_VertTossPattern_StraightDown	;if so, don't care
BNE RETURN_DEA4					;

LDY #$00					;
LDA $01						;y-pos check

LOOP_DE90:
CMP DATA_C41D,Y					;
BCC CODE_DE9F					;lower than this position...
CMP DATA_C420,Y					;
BCS CODE_DE9F					;

INC $01						;
JMP RETURN_DEA4					;not enough RTS

CODE_DE9F:
INY						;next pair of y-positions to check
CPY #$03					;
BNE LOOP_DE90					;

RETURN_DEA4:
RTS						;

CODE_DEA5:
JSR GetBarrelOAM_EFD5				;
STX $04						;

JSR EntityPosToScratch_EAEC			;
DEC $00						;moves to the left

;various checks, depending on how far it has gone from its landing position.
LDA Barrel_VertTossLandingXPos			;
SEC						;
SBC #$01					;
CMP $00						;if moved one pixel...
BEQ CODE_DEE8					;adjust its y-position (move up)
SEC						;
SBC #$01					;
CMP $00						;if moved two pixels...
BEQ CODE_DEE8					;MORE Y-POS ADJUSTIN (UP)
SEC						;
SBC #$01					;
CMP $00						;if moved 3 pixels...
BEQ CODE_DEF2					;check if it should turn into a normal barrel, depending on wether it was a simple straight moving barrel, or a left & right one
SEC						;
SBC #$08					;
CMP $00						;if moved 11 pixels...
BEQ CODE_DEED					;adjust y-pos, but this time it moves down (this simulates a standard bounce off the platform thing
SEC						;
SBC #$01					;
CMP $00						;if moved 12 pixels..
BEQ CODE_DEED					;adjust y-pos yet again, down
SEC						;
SBC #$01					;
CMP $00						;if moved 13 pixels...
BNE CODE_DEFB					;just display graphics, it'll turn into a normal barrel next time

CODE_DEDC:
LDA #Barrel_State_HorzMovement			;normal horizontal moving barrel
LDX Barrel_CurrentIndex				;
STA Barrel_State,X				;

LDA #$00					;clear this [redacted]
STA Barrel_VertTossHorzMovementDir,X		;
RTS						;

CODE_DEE8:
DEC $01						;move up
JMP CODE_DEFB					;

CODE_DEED:
INC $01						;move down
JMP CODE_DEFB					;

CODE_DEF2:
LDX Barrel_CurrentIndex				;
LDA Barrel_VertTossPattern,X			;normal vertical moving barrel?
CMP #$01					;
BEQ CODE_DEDC					;

CODE_DEFB:
LDA #Barrel_GFXFrame_UpRight			;display horizontal gfx
LDX Barrel_CurrentIndex				;
STA Barrel_GFXFrame,X				;
STA $02						;

JSR CODE_EADB					;update barrel gfx and pos and everything
RTS						;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;BARREL STATE - MOVES DOWN FROM HAMMER JUMPSCARE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CODE_DF07:
LDA #%01010101					;move every other frame
JSR PlatformAndBarrelTiming_BothBytes_DFE4	;
BNE CODE_DF0F					;
RTS						;

CODE_DF0F:
JSR GetBarrelOAM_EFD5				;
STX $04						;

JSR EntityPosToScratch_EAEC			;

INC $01						;down 1px

LDA OAM_Tile,X					;animate
CMP #Barrel_GFXFrame_Vertical1			;
BEQ CODE_DF25					;

LDA #Barrel_GFXFrame_Vertical1			;
JMP CODE_DF27					;

CODE_DF25:
LDA #Barrel_GFXFrame_Vertical2			;

CODE_DF27:
STA $02						;correct gfx

JSR CODE_EADB					;refresh barrel image

LDA Barrel_EscapeYDestination			;check if it has reached the lower platform
CMP $01						;
BEQ CODE_DF35					;whew, safe from that maniac
BCC CODE_DF35					;become normal
RTS						;

CODE_DF35:
LDX Barrel_CurrentIndex				;

LDA #Barrel_State_HorzMovement			;horizontal state
STA Barrel_State,X				;

LDA #$00					;clear this, potentially for the next escape
STA Barrel_EscapeYDestination			;
RTS						;

;make a barrel potentially panic!
CODE_DF40:
LDA Barrel_EscapeYDestination			;only one barrel can "panic escape" at once
BEQ CODE_DF45					;
RTS						;

CODE_DF45:
LDA Jumpman_State				;if Jumpman has a hammer...
CMP #Jumpman_State_Hammer			;
BEQ CODE_DF4C					;lets see if one of the barrels can escape his wrath
RTS						;

CODE_DF4C:
LDA Jumpman_CurrentPlatformIndex		;this platform
CMP #$03					;
BEQ CODE_DF55					;
JMP CODE_DF72					;(otherwise on the 5th platform

CODE_DF55:
LDX #$03					;check if there are 5 entities on platform 3 (Jumpman+Hammer is already 2, so we need three barrels)
LDA EntitiesPerPlatform,X			;
CMP #$05					;
BCS CODE_DF5E					;one of the barrels will escape!
RTS						;

CODE_DF5E:
LDX #$00					;loopdydoo

LOOP_DF60: 
LDA Barrel_State,X				;is moving horizontally?
CMP #Barrel_State_HorzMovement			;
BNE CODE_DF6C					;

LDA Barrel_CurrentPlatformIndex,X		;is on the same platform as the player?
CMP #$03					;
BEQ CODE_DF8F					;

CODE_DF6C:
INX						;
CPX #$0A					;
BNE LOOP_DF60					;loop through all barrels
RTS						;

CODE_DF72:
LDX #$05					;check entities on platform 5 (again, jumpman+hammer is already 2, if there are three barrels on the same platform, this check will succeed)
LDA EntitiesPerPlatform,X			;
CMP #$05					;
BCS CODE_DF7B					;:AAAA:
RTS						;

CODE_DF7B:
LDX #$00					;

LOOP_DF7D:
LDA Barrel_State,X				;moving horizontally?
CMP #Barrel_State_HorzMovement			;
BNE CODE_DF89					;if not, next barrel

LDA Barrel_CurrentPlatformIndex,X		;should be the same platform as the player (assuming the hammer hasn't been moved or smth)
CMP #$05					;
BEQ CODE_DF8F					;nope outta there

CODE_DF89:
INX						;loop through barrels again
CMP #$0A					;
BNE LOOP_DF7D					;
RTS						;

CODE_DF8F:
LDA #Barrel_State_GoDownPanic			;EMERGENCY!!!
STA Barrel_State,X				;

DEC Barrel_CurrentPlatformIndex,X		;moves down a platform
TXA						;
CLC						;
ADC #$03					;
ASL A						;
ASL A						;
ASL A						;
ASL A						;
TAY						;calculate barrel's OAM slot
LDA OAM_Y,Y					;
STA $01						;the usual x/y stuff

LDA OAM_X,Y					;
STA $00						;

LDA DATA_C1EB					;loading a constant table value instead of the constant...
LDY #$00					;

LOOP_DFAD:
CMP $00						;if its x-pos is...
BCS CODE_DFB8					;at or to the right of the x-position we're comparing to
CLC						;
ADC #$18					;even right-er (every 3 8x8 tiles)
INY						;(basically gets an elevation for each one of the platform shifts... identations, or whatever I feel like calling them)
JMP LOOP_DFAD					;

CODE_DFB8:
TYA						;
ASL A						;
CLC						;
ADC #$15					;moves at least 21 pixels down
CLC						;
ADC $01						;and barrel's y-pos
STA Barrel_EscapeYDestination			;move down to this position
RTS						;

;hide barrel behind BG if low enough (so it goes behind the oil barrel)
CODE_DFC3:
LDX Barrel_CurrentIndex				;
LDA Barrel_CurrentPlatformIndex,X		;
CMP #$01					;check if on the lowest platform
BNE RETURN_DFE3					;

JSR GetBarrelOAM_EFD5				;
LDA OAM_X,X					;check barrel's X-pos, if it's close enough to the barrel
CMP #$30					;
BCS RETURN_DFE3					;

;set low priority (and keep it's palette of course)
LDA #Barrel_OAMProp|OAMProp_BGPriority		;
STA OAM_Prop,X					;
STA OAM_Prop+4,X				;
STA OAM_Prop+8,X				;
STA OAM_Prop+12,X				;

RETURN_DFE3:
RTS						;

;store the same value for both $0A and $0B (because of set bit positioning)
PlatformAndBarrelTiming_BothBytes_DFE4:
STA $0A						;
STA $0B						;same bit configuration

;used for platforms and barrels
;uses bitwise check for which frame to update the platforms/barrels on.
;input:
;$0A - timing for the first 8 bits
;$0B - timing for the last 8 bits
;Example of how it works:
;$0A = #$88 - %10001000
;$0B = #$88 - %10001000
;Entity_TimingCounter = 0 - checks bit 0 of $0A - don't run the routine
;Entity_TimingCounter = 8 - checks bit 0 of $0B - don't run the routine
;Entity_TimingCounter = 3 - checks bit 3 of $0A - run the routine
;and so on

PlatformAndBarrelTiming_DFE8:
LDX Entity_TimingIndex				;
INC Entity_TimingCounter,X			;

LDA Entity_TimingCounter,X			;if negative (for whatever reason)
BMI CODE_DFF7					;reset
CMP #$10					;if 16, reset and do a thing
BCS CODE_DFF7					;
JMP CODE_DFFB					;

CODE_DFF7:
LDA #$00					;start checking from bit 0 again
STA Entity_TimingCounter,x			;

CODE_DFFB:
CMP #$08					;check if more than 8
BCS CODE_E008					;then substract
TAX						;
LDA DATA_C1BC,X					;
AND $0A						;check bits from A
JMP CODE_E011					;

CODE_E008:
SEC						;-8 to get proper index
SBC #$08					;
TAX						;
LDA DATA_C1BC,X					;
AND $0B						;check bits from B

CODE_E011:
If Version = JP
  BEQ JP_CODE_E016				;
else
  BEQ RETURN_E015				;bit not set? output 0
endif

LDA #$01					;output 1 and run whatever's after this

If Version = JP
JP_CODE_E016:
  STA $0C					;

  LDA $0C					;optimization.
endif

RETURN_E015:
RTS						;

;$08-09 - Indirect addressing pointer
;$0A - Y-position of Jumpman (or any entity) (sometimes offset)
;$0B - platform index the player's on (or slightly above)
;GetCurrentPlatform_E016
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
STA $09						;

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
LDX Barrel_CurrentIndex				;check if it's BARREL ROLLing like normal
LDA Barrel_State,X				;
CMP #Barrel_State_HorzMovement			;
BNE ReturnA_E053+ReturnABranchDist		;CODE_E057

LDA Barrel_ShiftDownFlag			;check if it changed elevation
BNE ReturnA_E053+ReturnABranchDist		;CODE_E057

;Load #$01
ReturnA_E053:
Macro_ReturnA $0C,$01				;more optimizations between revisions. now 0C isn't used to store value (simply load value and return)

;used by barrels
CODE_E05A:
STA $0C						;temporary store X-pos

LDX Barrel_CurrentIndex				;
LDA Barrel_CurrentPlatformIndex,X		;get height
CMP #$01					;bottom platform?
BEQ CODE_E079					;
CMP #$06					;top platform?
BEQ CODE_E079					;

LDX #$00					;

LOOP_E06A:
LDA DATA_C1C4,X					;check if at this x-position
CMP $0C						;
BEQ CODE_E08A					;if so, it changed its elevation
INX						;
CPX #$09					;
BEQ CODE_E08A+ReturnABranchDist			;
JMP LOOP_E06A					;next x-pos to check

CODE_E079:
LDX #$04					;

LOOP_E07B:
LDA DATA_C1C4,X					;check if at THIS x-position
CMP $0C						;
BEQ CODE_E08A					;yass!
INX						;
CPX #$09					;
BEQ CODE_E08A+ReturnABranchDist			;
JMP LOOP_E07B					;

CODE_E08A:
Macro_ReturnA $0B,$00				;yet another "don't have to store to RAM, just return" change

;check if approaching a ledge to drop from
CODE_E090:
STA $0C						;

LDX Barrel_CurrentIndex
LDA Barrel_CurrentPlatformIndex,X		;
AND #$01					;every other platform, alternates edge to drop from
BEQ CODE_E09F					;

LDX #$00					;to the right
JMP CODE_E0A1					;

CODE_E09F:
LDX #$01					;edge to the left

CODE_E0A1:
LDA DATA_C1CD,X					;if moving towards an edge
CMP $0C						;
BEQ ReturnA_E0A8+ReturnABranchDist		;(CODE_E0AB) drop off.

ReturnA_E0A8:
Macro_ReturnA $0B,$00

;Checks for ladders! if it should go down
CODE_E0AE:
STA $0C						;save X-pos

LDX Barrel_CurrentIndex				;
LDA Barrel_CurrentPlatformIndex,X		;check which platform it's on
CMP #$02					;second platform (from the bottom) 
BEQ CODE_E0CB					;(THEY COULDVE USED CODE_E0E9 instead of CODE_E0CB, it's basically the same!)
CMP #$03					;3rd platform
BEQ CODE_E0CB					;both have only two ladders
CMP #$04					;
BEQ CODE_E0D1					;3 ladders!
CMP #$05					;
BEQ CODE_E0DD					;also 3
CMP #$06					;highest platform
BEQ CODE_E0E9					;
JMP CODE_E0EC					;lowest platform (no ladders)

CODE_E0CB:
JSR CODE_E0F1					;check a pair of ladders
JMP CODE_E0EC					;c'mon, it's the same as CODE_E0E9 basically (marking that no ladder has been encountered)

CODE_E0D1:
JSR CODE_E0F1					;check for one of the normal barrels

LDY #$89					;if not terminated by PLAs, means the barrel isn't at an X-pos where the ladder can be.
CMP #$C4					;check the ladder position on the very right
BEQ CODE_E109					;
JMP CODE_E0EC					;not on the ladder is all that's clear

CODE_E0DD:
JSR CODE_E0F1					;

LDY #$71					;check third ladder on platform 5 (the broken one)
CMP #$B4					;
BEQ CODE_E109					;encountered ladder - MOVE IT, MOVE IT, I LIKE TO
JMP CODE_E0EC					;

CODE_E0E9:
JSR CODE_E0F1					;if this terminated, that means we found a ladder

CODE_E0EC:
LDA #$00					;No Ladder
JMP CODE_E10F					;

CODE_E0F1:
TAX						;get an index for the ladders
DEX						;
DEX						;counting from platform 2 (since first one doesn't have ladders, and 0 is invalid)

LDA $0C						;check X-pos for one of the ladders
LDY DATA_C172,X					;y-destination for the end of this ladder
CMP DATA_C177,X					;
BEQ CODE_E107					;if at this pos, yes! we just hit the ladder, moving down...

LDY DATA_C17C,X					;a second ladder to check
CMP DATA_C181,X					;
BEQ CODE_E107					;
RTS						;

CODE_E107:
PLA						;terminate further ladder checks
PLA						;

CODE_E109:
LDX Barrel_CurrentIndex				;
STY Barrel_LadderYDestination,X			;must reach this destination

LDA #$01					;

CODE_E10F:
STA $0C						;output A - 0 = no ladder, 1 - yes ladder
RTS						;

;used by barrels to decide if they hit certain y-position (usually for landing on a platform)
CODE_E112:
STA $0B						;saves Y-position

LDY #$00					;

LOOP_E116:
LDA ($08),Y					;table terminator
CMP #$FE					;
BEQ CODE_E129					;
CMP $0B						;
BEQ CODE_E124					;see if the y-pos matches
INY						;next y-pos to check
JMP LOOP_E116					;

CODE_E124:
LDA #$01					;
JMP CODE_E12B					;

CODE_E129:
LDA #$00					;

CODE_E12B:
STA $0C						;1 - did hit one of the y-positions, 0 - didn't
STY $0A						;save which platform we hit
RTS						;

;check platform distance between the barrel and Jumpman (0 - barrel is above jumpman, 1 - same platform or below jumpman)
CODE_E130:
LDX Barrel_CurrentIndex				;
LDA Barrel_CurrentPlatformIndex,X		;barrel's platform value
SEC						;
SBC Jumpman_CurrentPlatformIndex		;minus Jumpman's
BEQ CODE_E13E					;they're on the same platform?
BMI CODE_E13E					;jumpman is above the barrel?
JMP CODE_E13E+ReturnABranchDist			;it's none of the above, it's barrel is above jumpman

CODE_E13E:
Macro_ReturnA $0B,$01

;----------------------------------------------
;!UNUSED
;Inaccessible block of code.
;supposedly for barrels, used to calculate their platform index
;probably supposed to be called alongside CODE_E166 before running through barrels

UNUSED_E144:
LDX #$00					;
LDY #8*4					;this must be barrel-related... except the initial OAM slot is different (it's occupied by the second flame enemy in the finished game)

LOOP_E148:
LDA OAM_Y,Y					;
CMP #$FF					;
BEQ CODE_E157					;

JSR CODE_E016					;see what platform it's on
STA Barrel_CurrentPlatformIndex,X		;
JMP CODE_E15B					;

CODE_E157:
LDA #$00					;if it's not on-screen, it's on no platform
STA Barrel_CurrentPlatformIndex,X		;

CODE_E15B:
TYA						;
CLC						;
ADC #$10					;
TAY						;
INX						;
CPX #$0A					;
BNE LOOP_E148					;that's a lotta barrels.
RTS						;

;----------------------------------------------

CODE_E166:
LDA #$00					;
LDY #$06					;

LOOP_E16A:
STA EntitiesPerPlatform,Y			;clear the entity count for each platform (we'll re-count everything)

DEY						;
BPL LOOP_E16A					;

LDY #$00					;now go through barrels

LOOP_E172:
LDA Barrel_CurrentPlatformIndex,Y		;is barrel even alive? (if platform value is 0, most likely not)
BEQ CODE_E17F					;if no, check next barrel
TAX						;current platform has +1 barrel

LDA EntitiesPerPlatform,X			;no INC? (btw the INC IS used later in this very same routine, so ???)
CLC						;
ADC #$01					;
STA EntitiesPerPlatform,X			;barrel counts as an entity, add that in

CODE_E17F:
CPY #$09					;max of 9 barrels to go through
BEQ CODE_E187					;
INY						;
JMP LOOP_E172					;

CODE_E187:
LDX Jumpman_CurrentPlatformIndex		;check if jumpman is on the very last platform (where Pauline is)
CPX #$07					;
BEQ RETURN_E199					;don't count anything there

INC EntitiesPerPlatform,X			;wait a sec, this is illegal! Everyone knows that this should be CLC ADC instead of INC. I mean c'mon!

LDA Jumpman_State				;if player's holding a hammer
CMP #Jumpman_State_Hammer			;
BNE RETURN_E199					;

LDX Jumpman_CurrentPlatformIndex
INC EntitiesPerPlatform,X			;hammer now counts as an entity

RETURN_E199:
RTS						;

RunOilBarrelFlame_E19A:
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

LDA #$03					;not sure what 3 does (ladder stuff...)
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;Handle Flame Enemies
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CODE_E1E5:
LDA #$00					;start looping through em
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

JSR GetCurrentDifficulty_EAF7			;get difficulty

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

LDA Timer_FlameEnemyMoveDirUpdate		;see if all flame enemies should move to where the player is at
BNE RETURN_E24F					;

;reset don't chase flag
LDA #$00                 
STA FlameEnemy_DontFollowFlag			;next time, all flamers will move towards player's position
STA FlameEnemy_DontFollowFlag+1			;
STA FlameEnemy_DontFollowFlag+2			;
STA FlameEnemy_DontFollowFlag+3			;

LDA #$BC					;after some time, it'll hit zero, when it'll update chasing and stuff
STA Timer_FlameEnemyMoveDirUpdate		;

RETURN_E24F:
RTS						;

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
CMP #FlameEnemy_State_LadderUp			;
BEQ CODE_E2A1					;covers both up and down (down is the same with a filtered bit)

LDA PhaseNo					;
CMP #Phase_75M					;if phase is 75M
BEQ CODE_E278					;pure RNG movement (won't "chase" the player)

JSR CODE_E2B6					;also RNG movement
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
JMP CODE_E368					;process movement and stuff

CODE_E2A1:
LDA PhaseNo					;check phase...
CMP #Phase_25M					;
BNE CODE_E2B3					;

JSR CODE_E626					;check if its still climbing a ladder I guess
LDX FlameEnemy_CurrentIndex			;
LDA FlameEnemy_State,X				;
BNE CODE_E2B3					;see if it's climbing a ladder
JMP CODE_E292					;animate

CODE_E2B3:
JMP CODE_E41B					;ladder stuff

CODE_E2B6:
LDX FlameEnemy_CurrentIndex			;
LDA FlameEnemy_DontFollowFlag,X			;check if it shouldn't follow...
BNE CODE_E2DD					;

LDA #$01					;
STA FlameEnemy_DontFollowFlag,X			;it'll continue in the same direction, where the Jumpman was (technically not a chase, I guess?)

LDA FlameEnemy_CurrentIndex			;get flame enemy's OAM slot
CLC						;
ADC #$01					;
ASL A						;
ASL A						;
ASL A						;
ASL A						;
TAY						;

LDA OAM_X,Y					;check if the flame enemy is to the right of the player
CMP Jumpman_OAM_X				;
BCS CODE_E2D9					;will move towards the player if the RNG decides so

LDA #FlameEnemy_State_MoveRight			;update chase direction, to the right
STA FlameEnemy_FollowDirection,X		;
JMP CODE_E2DD					;

CODE_E2D9:
LDA #FlameEnemy_State_MoveLeft			;update chase direction, to the left
STA FlameEnemy_FollowDirection,X		;

CODE_E2DD:
LDA RNG_Value+1,X				;decide the next move depending on RNG
AND #$07					;
STA FlameEnemy_State,X				;i don't know why this is stored, this'll be replaced afterwards anyway. why am I questioning this, that's because this is NES Donkey Kong of course!
TAY						;
CMP #$04					;see if the state value exceedes 4 (otherwise it'll limit the state to 0-3)
BCS CODE_E2EB					;
JMP CODE_E2F6					;

CODE_E2EB:
LDY FlameEnemy_FollowDirection,X		;movement state (move left or right)
CMP #$07					;if RNG value is 7
BCS CODE_E2F4					;guaranteed to climb up a ladder (if there is any)
JMP CODE_E2F6					;

CODE_E2F4:
LDY #FlameEnemy_State_LadderUp			;default to ladder climbing

CODE_E2F6:
STY FlameEnemy_State,X				;
RTS						;

CODE_E2F9:
LDA #%01010101					;animate every other frame
STA $0A						;
STA $0B						;

JSR FlameEnemyTiming_E806			;
BNE CODE_E305					;
RTS						;

;animate when standing still (move up 'n down graphically)
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
LDA FlameEnemy_Direction,X			;image should be flipped propertly
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

;movement?
CODE_E368:
LDA #%01010101					;
STA $0A						;run the code every other frame
STA $0B						;

JSR FlameEnemyTiming_E806			;also time
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
AND #$0F					;
CMP #$04					;
BEQ CODE_E396					;
CMP #$0C					;
BEQ CODE_E396					;
JMP CODE_E39B					;

CODE_E396:
INC $01						;one pixel down
JMP CODE_E3AF					;

CODE_E39B: 
LDX FlameEnemy_MoveDirection			;bop up depending on the position (within 16x16 tile range)
CMP DATA_C3E2,X					;and depending on the movement  direction
BEQ CODE_E3AA					;
CMP DATA_C3E2+2,X				;
BEQ CODE_E3AA					;
JMP CODE_E3AF					;

CODE_E3AA:
DEC $01						;y-position one pixel up
JMP CODE_E3C0					;

CODE_E3AF:
CMP #$04					;
BEQ CODE_E3BA					;and if bop down, change its state
CMP #$0C					;
BEQ CODE_E3BA					;
JMP CODE_E3C0					;

CODE_E3BA:
LDX FlameEnemy_CurrentIndex			;
LDA #FlameEnemy_State_GFXShiftDown		;actually show up as one pixel down
STA FlameEnemy_State,X				;

CODE_E3C0:
LDY FlameEnemy_MoveDirection			;
JSR CODE_E6A5					;
BNE CODE_E3CE					;

LDA #FlameEnemy_State_AnimateInPlace		;why? we already made the flame stand still
LDX FlameEnemy_CurrentIndex			;
STA FlameEnemy_State,X				;
RTS						;

;flame enemy animation...
CODE_E3CE:
LDA FlameEnemy_MoveDirection			;hardcoded check for ladder pos depending on direction
BEQ CODE_E3ED					;moving right, no worries

LDA $00						;we already had this check before, didn't we??? (it was a MoveDirection and a table check, at CODE_E6E3)
CMP #$0C					;
BEQ CODE_E3DD					;if at this position, make sure to think about moving further
BCC CODE_E3E6					;don't move if less, please turn away
JMP CODE_E3ED					;move freely

CODE_E3DD:
LDA #FlameEnemy_State_AnimateInPlace		;set to stop movement & animate
LDX FlameEnemy_CurrentIndex			;
STA FlameEnemy_State,X				;
JMP CODE_E3ED					;

CODE_E3E6:
LDA #FlameEnemy_State_AnimateInPlace		;copy-paste code strikes back
LDX FlameEnemy_CurrentIndex			;
STA FlameEnemy_State,X				;stop moving but don't animate
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

;climbing a ladder
CODE_E41B:
LDX FlameEnemy_CurrentIndex			;
LDA FlameEnemy_State,X				;
LSR A						;
LSR A						;
LSR A						;
TAX						;index for update frequency
LDA PhaseNo					;
CMP #Phase_100M					;
BEQ CODE_E436					;

CODE_E429:
LDA DATA_C3F4,X					;
STA $0A						;

LDA DATA_C3F4+1,X				;
STA $0B						;
JMP CODE_E44B					;

CODE_E436:
LDA GameMode					;game A or B
AND #$01					;
CLC						;+ count loop
ADC LoopCount					;
CMP #$03					;
BCC CODE_E429					;slower climbing if the game isn't supposed to be difficult enough

LDA DATA_C3F8,X					;max difficulty climbing speed
STA $0A						;

LDA DATA_C3F8+1,X				;
STA $0B						;

CODE_E44B:
JSR FlameEnemyTiming_E806			;climb every few frames
BNE CODE_E451					;
RTS						;

CODE_E451:
JSR GetFlameEnemyOAM_EFDD			;
STX $04						;
JSR EntityPosToScratch_EAEC			;

LDX FlameEnemy_CurrentIndex			;
LDA FlameEnemy_LadderRestTime,X			;
BEQ CODE_E46D					;this check is pointless, there's a JMP to this address already if it's not $03
CMP #$03					;
BEQ CODE_E466					;
JMP CODE_E46D					;

CODE_E466:
LDA #$00					;reset timer
STA FlameEnemy_LadderRestTime,X			;
JMP CODE_E47A					;

;TEMP_YPosition
CODE_E46D:
LDA $01						;every 4th pixel (vertically)
AND #$03					;
BNE CODE_E47A					;

LDA #$01					;why are we loading this? this isn't used afterwards
INC FlameEnemy_LadderRestTime,X			;maybe it was meant to be a movement flag instead of a timer?
JMP CODE_E50C					;

CODE_E47A:
LDA PhaseNo					;
CMP #Phase_25M					;
BEQ CODE_E4B5					;

JSR CODE_E7A3					;
CMP #FlameEnemy_State_LadderUp			;check if climbing ladder up or down to move in respective direction
BEQ CODE_E48E					;move up
CMP #FlameEnemy_State_LadderDown		;
BEQ CODE_E49B					;move down
JMP CODE_E50C					;just animation

CODE_E48E:
DEC $01						;move up 1px

LDA $01						;
LDX FlameEnemy_CurrentIndex			;
CMP FlameEnemy_LadderEndYPos,X			;check if reached the end of the ladder
BEQ CODE_E4A8					;will stop climbing
JMP CODE_E50C					;

CODE_E49B:
INC $01						;move down 1px

LDA $01						;
LDX FlameEnemy_CurrentIndex			;again, check if 
CMP FlameEnemy_LadderEndYPos,X			;
BEQ CODE_E4A8					;
JMP CODE_E50C					;

CODE_E4A8:
LDA #FlameEnemy_State_MoveRight			;immediatly move right I guess
LDX FlameEnemy_CurrentIndex			;
STA FlameEnemy_State,X				;

LDA #$00					;
STA FlameEnemy_LadderEndYPos,X			;reached the end of the ladder, init for the next time
JMP CODE_E50C					;still animate

CODE_E4B5:
LDX FlameEnemy_CurrentIndex			;
LDA FlameEnemy_State,X				;
CMP #FlameEnemy_State_LadderDown		;
BEQ CODE_E4C0					;
JMP CODE_E4D6					;otherwise moves up, naturally

CODE_E4C0:
INC $01						;move down 1px

LDA FlameEnemy_CurrentIndex			;
ASL A						;
TAX						;
INX						;
LDA FlameEnemy_LadderBoundary,X			;
CMP $01						;check if on ground level
BNE CODE_E4D3					;

LDA #FlameEnemy_State_MoveRight			;move right... again (is that even right?)
LDX FlameEnemy_CurrentIndex			;
STA FlameEnemy_State,X				;

CODE_E4D3:
JMP CODE_E50C					;animation stuff

CODE_E4D6:
DEC $01						;1 pixel up
LDX FlameEnemy_CurrentIndex			;
CPX #$00					;hmm, yeah
BNE CODE_E4F9					;

LDX FlameEnemy_CurrentIndex			;bruh
LDA FlameEnemy_CurrentPlatformIndex,X		;
CMP #$02					;check if climbed up from second platform
BEQ CODE_E4F9					;

LDA FlameEnemy_CurrentIndex			;
ASL A						;
TAX						;
LDA FlameEnemy_LadderBoundary,X			;
CMP $01						;see if climbed up the ladder fully
BNE CODE_E50C					;

LDA #FlameEnemy_State_MoveLeft			;will move left
LDX FlameEnemy_CurrentIndex			;
STA FlameEnemy_State,X				;
JMP CODE_E50C					;yep, animation

CODE_E4F9:
LDA FlameEnemy_CurrentIndex			;
ASL A						;
TAX						;
LDA FlameEnemy_LadderBoundary,X			;
CLC						;
ADC #$0D					;check if at this position but a bit lower
CMP $01						;
BNE CODE_E50C					;that would be third platform's y-position otherwise

LDA #FlameEnemy_State_LadderDown		;prevent from going too high up the stage. coward!
LDX FlameEnemy_CurrentIndex			;
STA FlameEnemy_State,X				;

;animate da flame (AGAIN)
;this is pretty much a copy-paste of CODE_E3ED (with a few differences)
CODE_E50C:
LDA $04						;
TAY						;
INY						;get tile
LDA OAM_Y,Y					;
LDX PhaseNo					;check if from 100M
CPX #Phase_100M					;other sprite tiles
BEQ CODE_E527					;
CMP #FlameEnemy_GFXFrame_Frame2			;animate whichever flame
BCS CODE_E522					;

LDA #FlameEnemy_GFXFrame_Frame2			;pretty standard
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
INC $00						;move horizonrally to the right
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

DEC $00						;move up
LDA $00						;
CMP #$68					;
BCS CODE_E5D9					;

INC $01						;
JMP CODE_E5DB					;

CODE_E5D9:
DEC $01						;unused, because flame becomes normal and doesn't execure anymore of this, meaning the check for this to run can't be triggered

CODE_E5DB:
CMP #$60					;something else about X-pos (which is pointless)
BNE CODE_E5E5					;

LDX FlameEnemy_CurrentIndex			;untriggered & pointless (has become normal already)
LDA #FlameEnemy_State_AnimateInPlace		;
STA FlameEnemy_State,X				;

CODE_E5E5:
JMP CODE_F082					;draw da flame

CODE_E5E8:
STA $0C						;can't directly compare x-pos of course, must use other address for that!

LDX FlameEnemy_CurrentIndex			;
LDA FlameEnemy_CurrentPlatformIndex,X		;
CMP #$01					;at the very bottom of the level
BEQ CODE_E60F					;only a few elevation points
CMP #$06					;at the very top (the flame enemy cannot be this high)
BEQ CODE_E60F					;also a few elevation points

LDX #$00					;
LDA #$18					;first shift is at thus position

LOOP_E5FA:
CMP $0C						;check if at this x-position
BEQ CODE_E609					;
INX						;
CPX #$09					;check if all elevation points have been checked
BEQ CODE_E60C					;

LDA DATA_C1C4,X					;
JMP LOOP_E5FA					;

CODE_E609:
LDA #$00					;move the flame enemy up/down
RTS						;

CODE_E60C:
LDA #$01					;not a point of elevation, don't move up/down
RTS						;

CODE_E60F:
LDX #$04					;skip over some entries because there aren't as many elevation points

LOOP_E611:
LDA DATA_C1C4,X					;
CMP $0C						;
BEQ CODE_E620 					;
INX						;
CPX #$09					;all elevation points checked?
BEQ CODE_E623					;
JMP LOOP_E611					;

CODE_E620:
LDA #$00					;move the flame enemy up/down
RTS						;

CODE_E623:
LDA #$01					;not a point of elevation, don't move up/down
RTS						;

CODE_E626:
LDX FlameEnemy_CurrentIndex			;
LDA FlameEnemy_State,X				;what is this check? to get to this, you need FlameEnemy_State = FlameEnemy_State_LadderUp, of course this always triggers
CMP #FlameEnemy_State_LadderDown		;
BNE CODE_E62F					;
RTS						;

CODE_E62F:
JSR GetFlameEnemyOAM_EFDD			;
JSR EntityPosToScratch_EAEC			;

LDX FlameEnemy_CurrentIndex
LDA FlameEnemy_CurrentPlatformIndex,X		;check platform's index
CMP #$01					;very bottom?
BEQ CODE_E640					;check ladder X-positions
JMP CODE_E66D					;

CODE_E640:
LDA $00						;check enemy's x-pos
CMP #$5C					;if it encounters a ladder at these coordinates, it'll start climbing up
BEQ CODE_E64D					;
CMP #$C4					;
BEQ CODE_E65D					;
JMP CODE_E69E					;

;all ladder related? (bottom/top climbing boundary basically)
CODE_E64D:
LDA FlameEnemy_CurrentIndex			;
ASL A						;
TAX						;
LDA #$A6					;Y-position of the top (this one is a broken ladder)
STA FlameEnemy_LadderBoundary,X			;
INX						;y'know that you don't need INX? just load $BA. like c'mon.
LDA #$C7					;bottom.
STA FlameEnemy_LadderBoundary,X			;
JMP CODE_E697					;

;literally copy-pasted multiple times. quality coding as usual
CODE_E65D:
LDA FlameEnemy_CurrentIndex			;
ASL A						;
TAX						;
LDA #$AB					;ladder's top
STA FlameEnemy_LadderBoundary,X			;
INX						;
LDA #$C3					;ladder's bottom
STA FlameEnemy_LadderBoundary,X			;
JMP CODE_E697					;

CODE_E66D:
LDA $00						;different ladder x-pos on the next platform
CMP #$2C					;
BEQ CODE_E67A					;
CMP #$6C					;
BEQ CODE_E68A					;
JMP CODE_E69E					;

CODE_E67A:
LDA FlameEnemy_CurrentIndex			;
ASL A						;
TAX						;
LDA #$8D					;ladder's top
STA FlameEnemy_LadderBoundary,X			;
INX						;
LDA #$A4					;ladder's-a-what?
STA FlameEnemy_LadderBoundary,X			;
JMP CODE_E697					;

CODE_E68A:
LDA FlameEnemy_CurrentIndex			;
ASL A						;
TAX						;
LDA #$8A					;
STA FlameEnemy_LadderBoundary,X			;
INX						;
LDA #$A7					;
STA FlameEnemy_LadderBoundary,X			;

CODE_E697:
LDA #FlameEnemy_State_LadderUp			;automatically climb up
LDX FlameEnemy_CurrentIndex			;
STA FlameEnemy_State,X				;
RTS						;

CODE_E69E:
LDA #FlameEnemy_State_AnimateInPlace		;stumped by the lack of ladders
LDX FlameEnemy_CurrentIndex			;
STA FlameEnemy_State,X				;
RTS						;

;flame enemy checks for platform edges and elevations in 25M level
CODE_E6A5:
LDA $01						;
CLC						;
ADC #$0B					;
JSR CODE_E016					;get what platform the enemy's on

LDY FlameEnemy_MoveDirection			;what direction is it movin'?
LDX FlameEnemy_CurrentIndex			;
STA FlameEnemy_CurrentPlatformIndex,X		;store the platform the flame enemy's on

LDA PhaseNo					;
CMP #Phase_25M					;
BNE CODE_E6BC					;
JMP CODE_E6C6					;find if the flame enemy has encountered wrecked platform elevations

CODE_E6BC:
CMP #Phase_75M					;
BNE CODE_E6C3					;
JMP CODE_E702					;check if found all sorts of platform edges

CODE_E6C3:
JMP CODE_E73C					;

CODE_E6C6:
LDA $00						;x-position
JSR CODE_E5E8					;check if standing on an elevation point on the platform
BNE CODE_E6E3					;not, moving on

LDX FlameEnemy_CurrentIndex			;
LDA FlameEnemy_CurrentPlatformIndex,X		;
AND #$01					;every other platform (which way the platform is wrecked)
BEQ CODE_E6DB					;

LDA DATA_C79A,Y					;move up when moving right/down when moving left
JMP CODE_E6DE					;

CODE_E6DB:
LDA DATA_C79C,Y					;other way around

CODE_E6DE:
CLC						;
ADC $01						;
STA $01						;

CODE_E6E3:
LDX FlameEnemy_CurrentIndex			;
LDA FlameEnemy_CurrentPlatformIndex,X		;
CMP #$01					;check if on the very bottom platform
BEQ CODE_E6F3					;

LDA $00						;check horizontal position
CMP DATA_C3E6,Y					;
BEQ CODE_E6FB					;stop right there if encountered an edge of the platform (2nd platform)
RTS						;

CODE_E6F3:
LDA $00						;chk x-pos
CMP DATA_C3E8,Y					;STOP RIGHT THERE CRIMINAL SCUM
BEQ CODE_E6FB					;don't move further if encountered a ledge, again.
RTS						;

CODE_E6FB:
LDA #FlameEnemy_State_AnimateInPlace		;just stand still
LDX FlameEnemy_CurrentIndex			;
STA FlameEnemy_State,X				;
RTS						;

;flame enemy checks for platform edges in 75M level
CODE_E702:
LDX FlameEnemy_CurrentIndex			;
LDA FlameEnemy_CurrentPlatformIndex,X		;
CMP #$02					;on this platform...
BNE CODE_E719					;

LDA $00						;
CMP DATA_C3EA,Y					;see if encountered an edge
BEQ CODE_E735					;
CMP DATA_C3EC,Y					;a different platform to the right
BEQ CODE_E735					;
JMP RETURN_E72D					;

CODE_E719:
CPY #$01					;see if moved to the left
BNE CODE_E721					;
CMP #$04					;see if on this platform
BEQ CODE_E72E					;

CODE_E721:
LDA $00						;
CMP DATA_C3EE,Y					;right platform's edges
BEQ CODE_E735					;
CMP DATA_C3F0,Y					;left platform's edges
BEQ CODE_E735					;

RETURN_E72D:
RTS						;

CODE_E72E:
LDA $00						;check if pretty much at the right edge of the level (no right check because the flame will automaitcally climb a ladder)
CMP #$DB					;
BEQ CODE_E735					;
RTS						;

CODE_E735:
LDX FlameEnemy_CurrentIndex			;

LDA #FlameEnemy_State_AnimateInPlace		;
STA FlameEnemy_State,X				;STOP! YOU HAVE VIOLATED THE LAW
RTS						;

;flame enemy checks for platform edges in 100M level
CODE_E73C:
LDX FlameEnemy_CurrentIndex			;
LDA FlameEnemy_CurrentPlatformIndex,X		;
TAY						;
DEY						;
LDX FlameEnemy_MoveDirection			;
LDA DATA_C3F2,X					;first platform's ends

LOOP_E747:
CPY #$00					;finally check
BEQ CODE_E75C					;
CPX #$00					;the platform will shrink, check appropriate end depending on the enemy's facing
BEQ CODE_E755					;

CLC						;
ADC #$08					;edge shifts moves to the right when on higher platforms
JMP CODE_E758					;

CODE_E755:
SEC						;the platformer is shorter this way
SBC #$08					;

CODE_E758:
DEY						;
JMP LOOP_E747					;next platform

CODE_E75C:
CMP $00						;
BEQ CODE_E769					;stop or not?

LDA FlameEnemy_MoveDirection			;
ASL A						;
JSR CODE_E770					;check little gaps left by removing bolts
BEQ CODE_E769					;if did encounter such a thing, please, don't move
RTS						;

CODE_E769:
LDX FlameEnemy_CurrentIndex			;stop flame enemy so it doesn't wander out of bounds
LDA #$00					;
STA FlameEnemy_State,X				;
RTS						;

CODE_E770:
STA $09						;movement direction * 2

JSR GetFlameEnemyOAM_EFDD			;
LDA OAM_X,X					;
STA $0A						;X-pos

LDX FlameEnemy_CurrentIndex			;
LDA FlameEnemy_CurrentPlatformIndex,X		;
SEC						;
SBC #$02					;
ASL A						;
TAX						;
LDA Bolt_RemovedFlag,X				;check if the bolt is absent
BEQ CODE_E790					;next bolt then

LDY $09						;check the gap's ends
LDA DATA_C3DE,Y					;
CMP $0A						;
BEQ CODE_E79D					;will stop if encountered the gap

CODE_E790:
LDA Bolt_RemovedFlag+1,X			;
BEQ CODE_E7A0					;

LDY $09						;next gap check
LDA DATA_C3DE+1,Y				;
CMP $0A						;
BNE CODE_E7A0					;

CODE_E79D:
LDA #$00					;stop
RTS						;

CODE_E7A0:
LDA #$01					;don't stop
RTS						;

CODE_E7A3:
LDX FlameEnemy_CurrentIndex			;
LDA FlameEnemy_LadderEndYPos,X			;already has destination set?
BEQ CODE_E7AE					;set it if not

LDX FlameEnemy_CurrentIndex			;pointless!!!!!!!!!!!!!!!
LDA FlameEnemy_State,X				;
RTS						;keep on climbing!!! you can do it!!!!!!!!!!!!!!!

;related with flames (phase 3)?
CODE_E7AE:
LDA PhaseNo					;
SEC						;
SBC #$02					;skip over 25M
ASL A						;
TAY						;

LDA UNUSED_C49B,Y				;
STA $07						;

LDA UNUSED_C49B+1,Y				;
STA $08						;

LDX FlameEnemy_CurrentIndex			;
LDY FlameEnemy_CurrentPlatformIndex,X		;
BEQ CODE_E7F2					;

DEY						;
LDA ($07),Y					;initialize first counter
STA $09						;

INY						;
LDA ($07),Y					;
STA $0A						;second counter (basically how many ladders to check against on the plane the flame guy is on)

LDA PhaseNo					;once again, skip over 25M
SEC						;
SBC #$02					;
ASL A						;
TAY						;

LDA UNUSED_C4A1,Y				;the ladder climb data for flame guy to climb on
STA $07						;

LDA UNUSED_C4A1+1,Y				;
STA $08						;

LDY $09						;

LOOP_E7E2:
CPY $0A						;
BEQ CODE_E7F2					;

LDA ($07),Y					;check if the flamer is at the ladder's x-pos
CMP $00						;
BEQ CODE_E7F9					;climb it
INY						;
INY						;
INY						;
JMP LOOP_E7E2					;

CODE_E7F2:
LDA #FlameEnemy_State_AnimateInPlace		;ERROR: Ladder not found, please hold
LDX FlameEnemy_CurrentIndex			;
STA FlameEnemy_State,X				;
RTS						;

CODE_E7F9:
INY						;LADDER FOUND, CLIMBING INITIATED
LDA ($07),Y					;
LDX FlameEnemy_CurrentIndex			;
STA FlameEnemy_LadderEndYPos,X			;end point for the ladder (where it stops climbing)

INY						;
LDA ($07),Y					;climb the ladder up or down state
STA FlameEnemy_State,X				;
RTS						;

;used for updating flame enemies
;uses bitwise check for which frame to update the flame enemies on.
;input:
;$0A - timing for the first 8 bits
;$0B - timing for the last 8 bits
;Example of how it works:
;$0A = $88 - %10001000
;$0B = $88 - %10001000
;FlameEnemy_TimingCounter = 0 - checks bit 0 of $0A - don't run the routine
;FlameEnemy_TimingCounter = 8 - checks bit 0 of $0B - don't run the routine
;FlameEnemy_TimingCounter = 3 - checks bit 3 of $0A - run the routine
;and so on.
;it's pretty much the same routine as with barrels/platform lifts (at PlatformAndBarrelTiming_DFE8)

FlameEnemyTiming_E806:
LDX FlameEnemy_CurrentIndex			;
INC FlameEnemy_TimingCounter,X			;

LDA FlameEnemy_TimingCounter,X			;
BMI CODE_E815					;if negative (for whatever reason)
CMP #$10					;
BCS CODE_E815					;
JMP CODE_E819					;

CODE_E815:
LDA #$00					;start checking from bit 0 again
STA FlameEnemy_TimingCounter,X			;

CODE_E819:
CMP #$08					;check if more than 8
BCS CODE_E826					;then substract             
TAX						;
LDA DATA_C1BC,X					;
AND $0A						;check bits from A
JMP CODE_E82F					;

CODE_E826:
SEC						;
SBC #$08					;
TAX						;
LDA DATA_C1BC,X					;
AND $0B						;check bits from B

CODE_E82F:
If Version = JP
  BEQ JP_CODE_E848				;
else
  BEQ RETURN_E833				;
endif

LDA #$01					;

If Version = JP
JP_CODE_E848:
  STA $0C					;another unecessary store (without a load right next this time though)
endif

RETURN_E833:
RTS						;

;handle moving lifts (75M only)
RunMovingPlatforms_E834:
JSR GetCurrentDifficulty_EAF7			;get speed index (dependent on difficulty)

LDA DATA_C45C,X					;bits to check 1
STA $0A						;

LDA DATA_C461,X					;bits to check 2
STA $0B						;

LDA #$00					;only one check
STA Entity_TimingIndex				;
JSR PlatformAndBarrelTiming_DFE8		;check if it should run platforms code
BNE CODE_E84B					;every some frames, run the routine
RTS						;

;move lifts
CODE_E84B:
LDA #$00					;moving platform index
STA MovingPlatform_CurrentIndex			;

LOOP_E84F:
LDA MovingPlatform_CurrentIndex			;if we moved first three platforms
CMP #$03					;next three, which move up
BCS CODE_E8A9					;
TAX						;
BNE CODE_E86A					;

LDA Jumpman_StandingOnMovingPlatformValue	;if platform isn't being stood on
CMP #$01					;
BNE CODE_E86A					;don't move jumpman

DEC Jumpman_OAM_Y				;\move jumpman up
DEC Jumpman_OAM_Y+4				;|
DEC Jumpman_OAM_Y+8				;|
DEC Jumpman_OAM_Y+12				;/

CODE_E86A:
LDY MovingPlatform_OAMSlots_C2CC,X		;get proper OAM slot for each platform 
LDA OAM_Y,Y					;
CMP #$FF					;
BEQ CODE_E8A4					;if offscreen, next platform
TYA						;convert Y into X
TAX						;
DEC OAM_Y,X					;No DEC $XXXX,y
DEC OAM_Y+4,X					;move the platform up

LDA OAM_Y,X					;if not at this height, check different Y-position
CMP #PlatformSprite_Upward_YesBGPriorityPoint	;
BNE CODE_E889					;

JSR CODE_E968					;enable priority
JMP CODE_E890					;check different Y-pos (but it's pointless since we're here from $50)

CODE_E889:
CMP #PlatformSprite_Upward_NoBGPriorityPoint	;if it appears from the bottom, disable priority
BNE CODE_E890					;
JSR CODE_E971					;disable priority

CODE_E890:
LDA OAM_Y,Y					;if one of the platforms reach this position (done so they're all at the same distance)
CMP #PlatformSprite_Upward_RespawnPoint		;
BNE CODE_E89B					;

LDA #$01					;make the platform that was previously despawned respawn
STA MovingPlatform_Upward_RespawnFlag		;

CODE_E89B:
LDA OAM_Y,Y					;remove sprite if high enough
CMP #PlatformSprite_Upward_RemovePoint		;
BEQ CODE_E901					;
BCC CODE_E901					;

CODE_E8A4:
INC MovingPlatform_CurrentIndex			;next platform sprite
JMP LOOP_E84F					;

CODE_E8A9:
CMP #$06					;if gone through all platforms, wrap it up
BEQ CODE_E90E					;
TAX						;
CMP #$03					;only check the player and if they should move with the lift on this index
BNE CODE_E8C4					;

LDA Jumpman_StandingOnMovingPlatformValue	;is player standing on a platform that moves up?
CMP #$02					;
BNE CODE_E8C4					;if not, don't move the player

INC Jumpman_OAM_Y				;\move the player down
INC Jumpman_OAM_Y+4				;|
INC Jumpman_OAM_Y+8				;|
INC Jumpman_OAM_Y+12				;/

CODE_E8C4:
LDY MovingPlatform_OAMSlots_C2CC,X		;
LDA OAM_Y,Y					;
CMP #$FF					;id the platform is offscreen, don't do things
BEQ CODE_E8FC					;
TYA						;
TAX						;
INC OAM_Y,X					;no INC $XXXX,y either
INC OAM_Y+4,X					;the platform moves down as well

LDA OAM_Y,X					;when reaches this position, get rid of priority bit
CMP #PlatformSprite_Downward_NoBGPriorityPoint	;
BNE CODE_E8E3					;

JSR CODE_E971					;store just palette prop
JMP CODE_E8EA					;

CODE_E8E3:
CMP #PlatformSprite_Downward_YesBGPriorityPoint	;at this pos?
BNE CODE_E8EA					;

JSR CODE_E968					;enable BG prop bit

CODE_E8EA:
LDA OAM_Y,Y					;
CMP #PlatformSprite_Downward_RespawnPoint	;
BNE CODE_E8F8					;

LDA #$01					;another some flag
STA MovingPlatform_Downward_RespawnFlag		;

LDA OAM_Y,Y					;

CODE_E8F8:
CMP #PlatformSprite_Downward_RemovePoint	;
BCS CODE_E901					;

CODE_E8FC:
INC MovingPlatform_CurrentIndex			;next platform to run
JMP LOOP_E84F					;

CODE_E901:
LDA #$FF					;remove this lift by storing it offscreen
STA OAM_Y,Y					;
STA OAM_Y+4,Y					;

INC MovingPlatform_CurrentIndex			;still next platform to run
JMP LOOP_E84F					;

CODE_E90E:
LDA MovingPlatform_Upward_RespawnFlag		;check if we despawned a platform and some other platform reached a point where it should respawn
CMP #$01					;
BNE CODE_E93B					;check the other flag then

LDA #$00					;loop through platforms going up
STA MovingPlatform_CurrentIndex			;

LOOP_E918:
LDA MovingPlatform_CurrentIndex			;
CMP #$03					;check only 3 platforms that move up
BEQ RETURN_E967					;when all checked, end
TAX						;

LDY MovingPlatform_OAMSlots_C2CC,X		;
LDA OAM_Y,Y					;
CMP #$FF					;if the platform is offscreen, bring it back on screen
BEQ CODE_E92E					;

INC MovingPlatform_CurrentIndex			;check next platform check
JMP LOOP_E918					;

CODE_E92E:
LDA #PlatformSprite_Upward_SpawnPoint		;
JSR CODE_E97A					;set it's position
JSR CODE_E968					;obviously hidden behind BG

LDA #$00					;
STA MovingPlatform_Upward_RespawnFlag		;no more respawn
RTS						;

CODE_E93B:
LDA MovingPlatform_Downward_RespawnFlag		;respawn downward lifts?
CMP #$01					;
BNE RETURN_E967					;if not, well... don't.

LDA #$03					;loop through platforms going down
STA MovingPlatform_CurrentIndex			;

CODE_E945:
LDA MovingPlatform_CurrentIndex			;only downward moving lifts to check
CMP #$06					;
BEQ RETURN_E967					;
TAX						;

LDY MovingPlatform_OAMSlots_C2CC,X		;
LDA OAM_Y,Y					;offscreen? plz come back i'm begging you i'm literally shaking and crying rn
CMP #$FF					;
BEQ CODE_E95B					;

INC MovingPlatform_CurrentIndex			;next platform
JMP CODE_E945					;

CODE_E95B:  
LDA #PlatformSprite_Downward_SpawnPoint		;
JSR CODE_E97A					;spawn in
JSR CODE_E968					;

LDA #$00					;don't respawn anymore
STA MovingPlatform_Downward_RespawnFlag		;

RETURN_E967:
RTS						;

;MovingPlatform_StorePropWithBGBit_E968:
CODE_E968:
LDA #PlatformSprite_Prop|OAMProp_BGPriority	;the platform goes behind bg tiles
STA OAM_Prop,Y					;
STA OAM_Prop+4,Y				;
RTS						;

;MovingPlatform_StorePropWithoutBGBit_E971:
CODE_E971:
LDA #PlatformSprite_Prop			;just prop
STA OAM_Prop,Y					;
STA OAM_Prop+4,Y				;
RTS						;

;MovingPlatform_StoreYPos_E97A:
CODE_E97A:
STA OAM_Y,Y					;spawn a platform at a certain y-position (input A)
STA OAM_Y+4,Y					;
RTS						;

;handle springboards (75M)
RunSpringboards_E981:
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
CMP #$FF					;if not even onscreen, try to respawn
BEQ CODE_E9F0					;

;when in air
LDX Springboard_CurrentIndex			;
LDA Springboard_SpawnedXPos,X			;check when it's supposed to drop down
CLC						;
ADC #$B0					;
CMP $00						;
BCC CODE_E9B4					;not far enough

LDA $01						;
CMP #$26					;
BCS CODE_E9BE					;also y-pos

LDA #Spring_GFXFrame_UnPressed			;
STA $02						;
JMP CODE_E9DA					;set it's gfx frame to be unpressed

CODE_E9B4:
JSR CODE_EA01					;make springboard fall
CMP #$FF					;
BEQ CODE_E9F3					;reached the end of the fall?
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
STA Springboard_GravityInitFlag,X		;can bounce again

CODE_E9DA:
LDA $00						;move x-pos
CLC						;by two pixels
ADC #$02					;
STA $00						;

LDA Springboard_CurrentIndex			;
CLC						;
ADC #$01					;+1 to skip over jumpman
JSR CODE_EF72					;update y-pos?

CODE_E9EA:
JSR CODE_EADB					;update springboard's position and stuff
JMP CODE_E9F3					;next springboard

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

LDX #Sound_Effect_Fall				;only play dropping sound effect when reaching certain Y-pos
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

LDA #$FF					;almost reached the end of the fall, no animating at this point
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
LDA Timer_EntitySpawn				;if it isn't time to spawn, return
BNE RETURN_EA5E					;

LDA RNG_Value+1					;
AND #$03
TAX
LDA DATA_C1FF,X					;randomized x-pos
CLC						;
ADC #$10					;+fixed distance
LDX Springboard_CurrentIndex			;get springboard's index
STA Springboard_SpawnedXPos,X			;remember spawn x-pos
STA $00						;

LDA #Spring_Spawn_YPos				;
STA $01						;

LDA #Spring_GFXFrame_Pressed			;
STA $02						;

JSR CODE_EADB					;yes, spawn

JSR GetCurrentDifficulty_EAF7			;difficulty thing
LDA DATA_C457,X					;restore timer (frequency depends on difficulty)
STA Timer_EntitySpawn				;

RETURN_EA5E:
RTS						;

;pauling's animation handling
HandlePauline_EA5F:
LDA Timer_PaulineAnimation			;if her animation timer is up
BEQ CODE_EA64					;
RTS						;maybe update

CODE_EA64:
LDA #%00001000					;
STA $0A						;

LDA #%00000000					;
STA $0B						;
JSR CODE_EAA1					;every 16 frames, will update the animation
BNE CODE_EA72					;
RTS						;

CODE_EA72:
LDA #PaulineBody_XPos				;pauline's body x-pos
STA $00						;

LDA #PaulineBody_YPos				;and Y-pos
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

LDA #$00					;reset the counter
STA Pauline_AnimationCount			;

LDA #Time_PaulineAnim				;animate next time after this amount of frames
STA Timer_PaulineAnimation			;

RETURN_EAA0:
RTS						;

;it's the same as all the previous bitwise timing routines, but this time it's for Pauline
;uses bitwise check for which frame to update the Pauline's animation
;input:
;$0A - timing for the first 8 bits
;$0B - timing for the last 8 bits
;Example of how it works:
;$0A = $88 - %10001000
;$0B = $88 - %10001000
;$88 = 0 - checks bit 0 of $0A - don't run the routine
;$88 = 8 - checks bit 0 of $0B - don't run the routine
;$88 = 3 - checks bit 3 of $0A - run the routine
;and so on

CODE_EAA1:
INC Pauline_TimingCounter			;next bit to check
LDA Pauline_TimingCounter			;
BMI CODE_EAAE					;only positivity is accepted
CMP #$10					;bit 16 doesn't exist - reset back to bit 0
BCS CODE_EAAE					;
JMP CODE_EAB2					;

CODE_EAAE:
LDA #$00					;start checking from bit 0 again
STA Pauline_TimingCounter			;

CODE_EAB2:
CMP #$08					;bit 8?
BCS CODE_EABF					;check the other address containing bits
TAX						;
LDA DATA_C1BC,X					;
AND $0A						;check bits from $0A
JMP CODE_EAC8					;

CODE_EABF:
SEC						;-8 to get proper index
SBC #$08					;
TAX						;
LDA DATA_C1BC,X					;
AND $0B						;check bits from B

CODE_EAC8:
If Version = JP
  BEQ JP_CODE_EAE3				;
else
  BEQ RETURN_EACC				;bit clear - output 0
endif

LDA #$01					;output 1 and run whatever's after this (in this case, it's pauline's animating)

If Version = JP
JP_CODE_EAE3:
  STA $0C					;optimized in further revisions
endif

RETURN_EACC:
RTS						;

SpriteDrawingPREP_JumpmanOAM_EACD:
LDA #<Jumpman_OAM_Y				;get Jumpmans OAM sprite tile low byte for sprite update (indirect adressing)
STA $04						;

SpriteDrawingPREP_Draw16x16_EAD1:		;pointless label, can just use JSR SpriteDrawingPREP_Draw16x16_2_EAD6.
JMP SpriteDrawingPREP_Draw16x16_2_EAD6		;

;prep routine for sprite drawing
;A - first sprite tile to draw

SpriteDrawingPREP_StoreTile_EAD4:
STA $02						;store tile

;this label isn't even used, only for a pointless jump above
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
;Output:
;$00 - Entity X-position
;$01 - Entity Y-position

;CODE_EAE1:
JumpmanPosToScratch_EAE1:
LDA Jumpman_OAM_X				;sprite tile X-position
STA $00						;

LDA Jumpman_OAM_Y				;sprite tile Y-position
STA $01						;
RTS						;

;same as above but for other entities
EntityPosToScratch_EAEC:
LDA OAM_X,X					;entity's x-pos
STA $00						;

LDA OAM_Y,X					;y-pos
STA $01						;
RTS						;

;get an index for various objects, to make it more difficult for the player
GetCurrentDifficulty_EAF7:
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
LDA Score_UpdateFlag				;clear the bit 4 prematurely (which tells the game that we're updating the kong's frame during an animation so it doesn't update the score)
AND #$0F					;can be set afterwards
STA Score_UpdateFlag				;

LDA PhaseNo					;
TAX						;
TAY						;
DEX						;
LDA DATA_C608,X					;get the VRAM of the kong's position (depending on the phase ofc)
STA $00						;

LDA #$20					;the high byte is consistent

STA $01						;
TYA						;
CMP #Phase_25M+1				;check if phase value is less than 2 (which is only 25M)
BMI CODE_EB54					;can toss barrels and stuff and we need to animate that

;animate idle DK hitting his chest

LDA Timer_KongAnimation				;
BEQ CODE_EB4F					;restore the timer if at zero

CODE_EB2B:
CMP #$13					;various timings
BNE CODE_EB32					;
JMP CODE_EB85					;show left fist hitting his chest

CODE_EB32:
CMP #$0F					;
BNE CODE_EB39					;
JMP CODE_EB8E					;now show right fist hitting his chest

CODE_EB39:
CMP #$0B					;alternates like that
BNE CODE_EB40					;
JMP CODE_EB85					;left hook!

CODE_EB40:
CMP #$08					;
BNE CODE_EB47					;
JMP CODE_EB8E					;right hook!

CODE_EB47:
CMP #$04					;
BNE RETURN_EB4E					;stop chest hitting animation at this frame

JSR CODE_EBA6					;show Donkey's normal pose

RETURN_EB4E:
RTS						;

CODE_EB4F:
LDA #$25					;
STA Timer_KongAnimation				;chest hitting frequency
RTS						;

;animate barrel tossing and everything
CODE_EB54:
LDA Timer_EntitySpawn				;
CMP #$18					;
BEQ CODE_EB74					;if at this point in time, show him picking up a barrel
CMP #$00					;
BEQ CODE_EB7B					;timer ran out? he'll continue his chest hit business

LDA Kong_TossToTheSideFlag			;if donkey should show "toss to the side" frame
BEQ CODE_EB6F					;NO???

JSR CODE_EBA1					;actually, yes

LDA #$00					;
STA Kong_TossToTheSideFlag			;play once

LDA #$1A					;after which, it'll perform the chest hit animation like normal
STA Timer_KongAnimation				;

CODE_EB6F:
LDA Timer_KongAnimation				;animate chest hitting
JMP CODE_EB2B					;

CODE_EB74:
LDA #$30					;
STA Timer_KongAnimation				;
JMP CODE_EB9C					;

CODE_EB7B:
LDA #$1A					;will start hitting his chest soon enough
STA Timer_KongAnimation				;
JSR CODE_EB97					;holding barrel gfx
JMP CODE_EB2B					;...then it jumps back to timer checks which won't do anything.

;various inputs for CODE_C815, which is kong related (basically load various graphical frames for donkey)
CODE_EB85:
LDA #Sound_Effect_Hit				;sound effect when DK hits his chest.
STA Sound_Effect				;

CODE_EB89:
LDA #$40					;
JMP CODE_EBA8					;show DK's "hitting chest, right hand" frame

CODE_EB8E:
LDA #Sound_Effect_Hit				;Doesn't it hurt to hit his chest every so often?
STA Sound_Effect				;probably not, but still

CODE_EB92:
LDA #$42					;
JMP CODE_EBA8					;show DK's "hitting chest, left hand" frame

CODE_EB97:
LDA #$44					;show DK's "holding barrel" frame
JMP CODE_EBA8					;

CODE_EB9C:
LDA #$3E					;show DK's "picking up barrel" frame
JMP CODE_EBA8					;

CODE_EBA1:
LDA #$00					;show DK's "toss the barrel to the side" frame
JMP CODE_EBA8					;

CODE_EBA6:
LDA #$02					;show DK's "default" frame

CODE_EBA8:
JSR CODE_C815					;load correct pointer for DK's image and then buffer it

DEC Timer_KongAnimation				;immediatly move on so it doesn't redraw the same frame for several frames

LDA Score_UpdateFlag				;stuffed kong's image into a buffer, no score update for this frame
ORA #$10					;
STA Score_UpdateFlag				;
RTS						;

HandleBonusCounter_EBB6:
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
JSR CODE_F33E					;substract

LDA #$02					;
STA $00						;
JMP CODE_F23C					;buffer update

;run demo - initialization and movement
;CODE_EBDA:
RunDemoMode_EBDA:
LDA Demo_InitFlag				;check if demo needs initialization. if not, run demo
BNE CODE_EBED					;

LDA #$01					;has initialized, disable
STA Demo_InitFlag				;

LDA #$00					;reset index and timer
STA Demo_InputIndex				;
STA Demo_InputTimer				;
RTS						;

CODE_EBED:
LDA Demo_InputTimer				;when timer for this input runs out, grab next input
BEQ DemoGetInput_EC16				;

LDA Demo_Input					;check if it is a jump command
CMP #Demo_JumpCommand				;
BNE CODE_EC0A					;if it is a directional input, move in that direction

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
;JumpmanInteractWithEntities_EC29:
JSR JumpmanPosToScratch_EAE1			;

LDA #$4C					;
JSR CODE_EFE8					;for possible collision (jumpman's hitbox)

LDA PhaseNo					;
CMP #Phase_75M					;75m? can jump over springs... maybe???
BEQ CODE_EC3B					;
CMP #Phase_25M					;not 25m? can't jump over barrels/destroy them with a hammer because there isn't any
BNE CODE_EC3E					;

CODE_EC3B:
JSR CODE_EC44					;score for jumping over stuff + hammer interaction

CODE_EC3E:
JSR CODE_ED8A					;make flame bois destructable with a hammer
JMP CODE_EDC5					;run misc. hitboxes (oil barrel flame, lift ends in 75M, DK in 100M)

;check if Jumpman has jumped over a barrel to add score (technically for springboards from 75M as well, but it seems nigh impossible to jump over one and receive score bonus)
CODE_EC44:
LDA #$00					;
STA Barrel_CurrentIndex				;

CODE_EC48:
LDA #$3A					;barrel/springboard hitbox
JSR CODE_C847					;
JSR GetBarrelOAM_EFD5				;

LDA PhaseNo					;check 25M
CMP #Phase_25M					;
BEQ CODE_EC5B					;that means barrels
TXA						;
CLC						;
ADC #$30					;offset for springboards
TAX						;

CODE_EC5B:
JSR EntityPosToScratch_EAEC

JSR CODE_EFEF					;check collision and calculate distances
BNE CODE_ECA7					;if made a contact with the barrel, dead

LDA Jumpman_State				;
CMP #Jumpman_State_Jumping			;
BNE CODE_EC97					;if jumpman isn't jumping, don't check barrel

LDA Direction					;check if moving while jumping
AND #Input_Left|Input_Right			;
BNE CODE_EC76					;if so, execute this

LDA Hitboxes_XDistance				;if the barrel and the jumpman are at the same position
BEQ CODE_EC80					;
JMP CODE_EC97					;

CODE_EC76:
LDA Hitboxes_XDistance				;if 3 or more pixels to the right of the barrel (top-right of barrel vs top right of the jumpman)
CMP #$03					;
BCS CODE_EC97					;too far, no score

LDA Jumpman_AirMoveFlag				;checks if updated horizontal position this frame
BNE CODE_EC97					;no score

CODE_EC80:
LDA Hitboxes_YDistance				;check how much higher the player is in relation to the barrel
CMP #$18					;
BCS CODE_EC97					;if too high (like when jumpman is on a way higher platform), don't award score

;player jumped over a barrel, spawn score 100 (or maybe a springboard, idk)
LDA $00						;score's pos to player's
STA $05						;

LDA $01						;
STA $06						;

LDX #$00					;score index IIRC (so that's 100 score)
JSR CODE_CFC6					;give score

LDA #Sound_Fanfare_Score			;little fanfare
STA Sound_Fanfare				;

CODE_EC97:
INC Barrel_CurrentIndex

LDA PhaseNo					;get phase
LSR A						;
TAX						;
LDA Barrel_CurrentIndex				;
CMP DATA_C1FD,X					;maximum slots for barrels/springboards
BEQ CODE_ECAF					;reached max, run hammer destruction, i think?
JMP CODE_EC48					;

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
BNE CODE_ECC6					;(answer - this check is redundant)
JMP CODE_ED87					;untriggered

CODE_ECC6:
LDA Hammer_JumpmanFrame				;get hammer's state (wether it's up or down based on jumpman's position)
LSR A						;
LSR A						;
BEQ CODE_ECD1					;if it's down, check hitbox when it's down (duh)

LDA #$00					;DOWN
JMP CODE_ECD3					;

CODE_ECD1:
LDA #$01					;UP

CODE_ECD3:
BEQ CODE_ECE8					;adjust hitbox if the hammer is up

LDA #$04					;adjust hammer hitbox position (center relative to the player)
CLC						;
ADC Jumpman_OAM_X				;
STA $00						;

LDA Jumpman_OAM_Y				;above the player
SEC						;
SBC #$10					;
STA $01						;
JMP CODE_ED07					;

CODE_ECE8:
LDA Direction_Horz				;shift hammer's hitbox depending on jumpman's horizontal direction
CMP #Input_Right				;
BEQ CODE_ECF7					;

LDA Jumpman_OAM_X				;jumpman's x-pos - 10
SEC						;
SBC #$10					;
JMP CODE_ECFD					;

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
LDA #$00					;
STA Barrel_CurrentIndex				;

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
LDA #$00					;check from the first enemy
STA FlameEnemy_CurrentIndex			;

LOOP_ED38:
JSR GetFlameEnemyOAM_EFDD			;
JSR EntityPosToScratch_EAEC			;

LDA #$3A					;flame enemy's hitbox
JSR CODE_C847					;

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
STA FlameEnemy_CurrentPlatformIndex,X		;it's on no platform
STA FlameEnemy_LadderEndYPos,X			;not climbing a ladder = no end point

LDA #$01					;yes destroying an enemy
JMP CODE_ED87					;

CODE_ED85:
LDA #$00					;not destroying an enemy

CODE_ED87:
STA Hammer_DestroyingEnemy			;
RTS						;

;handle interactions with flame enemies from 100M (hurt player and hammer)
CODE_ED8A:
LDA #$00					;
STA FlameEnemy_CurrentIndex			;start from the first one

LDA #$3A					;
JSR CODE_C847					;hitbox

LOOP_ED93:
JSR GetFlameEnemyOAM_EFDD			;
JSR EntityPosToScratch_EAEC			;get positions

JSR CODE_EFEF					;collison check
BNE CODE_EDAD					;player dead

INC FlameEnemy_CurrentIndex			;
LDA FlameEnemy_CurrentIndex			;
LDX PhaseNo					;
DEX						;
CMP DATA_C1F6,X					;all flame enemies loop
BEQ CODE_EDB5					;move on to hammer
JMP LOOP_ED93					;

CODE_EDAD:
JSR CODE_EF51					;if player held a hammer, remove it

LDA #Jumpman_State_Dead				;player is incapacitated
STA Jumpman_State				;
RTS                      			;

CODE_EDB5:
LDA Jumpman_State				;is jumpman holding a hammer?
CMP #Jumpman_State_Hammer			;
BNE RETURN_EDC4					;nein

LDA PhaseNo					;hammer cannot reach flame enemies in 25M
CMP #Phase_25M					;
BEQ RETURN_EDC4					;don't care + ratio

JSR CODE_ECBF					;run hammer detection

RETURN_EDC4:
RTS						;

CODE_EDC5:
LDA PhaseNo					;run when not 75M
CMP #Phase_75M					;
BNE CODE_EDD2

LDY Jumpman_State				;if 75M, check if jumpman is grounded
CPY #Jumpman_State_Grounded			;
BEQ CODE_EDD2					;
RTS						;

CODE_EDD2:
SEC						;hitbox dimension pointers
SBC #$01					;
ASL A						;
TAX						;

LDA DATA_C42B,X					;pointer for hitbox dimensions
STA $02						;

LDA DATA_C42B+1,X				;^
STA $03						;|

LDA DATA_C423,X					;hitbox position x
STA $00						;

LDA DATA_C423+1,X				;hitbox position y
STA $01						;

CODE_EDEB:
JSR CODE_EFEF					;collision
BNE CODE_EE07					;did collide with something, depending on current phase

LDA PhaseNo					;
CMP #Phase_75M					;another 75M check
BNE RETURN_EE0B					;not 75M = return (one hitbox)

LDA $01						;check if we altered y-position for the hitbox to check (checking the other lift end)
CMP #$C9					;
BEQ RETURN_EE0B					;

LDA #$70					;x-pos
STA $00						;

LDA #$C9					;
STA $01						;y-pos
JMP CODE_EDEB					;re-run this

CODE_EE07:
LDA #Jumpman_State_Dead				;kill
STA Jumpman_State				;

RETURN_EE0B:
RTS						;

CODE_EE0C:
LDA #%10000000					;
STA $0A						;

LDA #%10000000					;oh yeah, uhuh, right
STA $0B						;(these are stored in the routine anyway, so this is pointless, not to mention the same LDA value from before)

JSR PlatformAndBarrelTiming_BothBytes_DFE4	;run every 8th frame
BNE CODE_EE1A					;
RTS

;this is used to handle destroyed enemy animation.
CODE_EE1A:
LDA PhaseNo					;flame enemy destruction is in other phases
CMP #Phase_25M					;
BNE CODE_EE26					;makes sense, since the player can't normally destroy the flame enemy in 25M (too low)

JSR GetBarrelOAM_EFD5				;instead can destroy barrels
JMP CODE_EE29					;

CODE_EE26:
JSR GetFlameEnemyOAM_EFDD			;destroying flame enemy, get it's OAM slots

CODE_EE29:
STX $04						;save OAM slot

JSR EntityPosToScratch_EAEC			;

LDA Hammer_DestroyingEnemy			;are we just starting the destruction sequence?
CMP #$01					;
BNE CODE_EE38					;no, skip

LDY #Sound_Effect2_EnemyDestruct		;enemy is being destroyed
STY Sound_Effect2				;

CODE_EE38:
CMP #$0B					;
BEQ CODE_EE51					;if animation has ended, remove all traces

LDX Hammer_DestroyingEnemy			;
DEX						;
LDA EnemyDestructionAnimationFrames_C1EC,X	;show animation
STA $02						;

JSR CODE_EADB					;draw tiles

LDX $04						;saved OAM slot

LDA #EnemyDestruction_Prop			;
JSR CODE_EE6C					;set props

INC Hammer_DestroyingEnemy			;next animation next frame
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
STA Hammer_DestroyingEnemy			;
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
LDY PhaseNo					;there are no background collectibles in 25M
CPY #Phase_25M					;
BNE CODE_EE80					;
RTS						;

CODE_EE80:
LDA Jumpman_ActingFlag				;jumpman is performing some sorta action...
BEQ RETURN_EED8					;
CPY #Phase_100M					;if not 100M, no bolts
BNE CODE_EEF0					;

LDY #$00					;init bolt counter
LDX DATA_C5FF					;why not fixed value... again, this is a DK (NES) code we're talking about.

LOOP_EE8D:
LDA UNUSED_C5C1+1,X				;and since we load "fixed" value i don't think loading these as table values is necessary
CMP Jumpman_OAM_X				;
BNE CODE_EEE7					;

LDA UNUSED_C5AE,X				;
CMP Jumpman_OAM_Y				;
BCC CODE_EEE7					;
SEC						;
SBC #$11					;or slightly above because of jumping
CMP Jumpman_OAM_Y				;
BCS CODE_EEE7					;

LDA Bolt_RemovedFlag,Y				;check if the bolt has been removed
CMP #$00					;sigh
BNE CODE_EED9					;

LDA Jumpman_State				;
CMP #Jumpman_State_Falling			;if falling, can't remove bolt
BEQ RETURN_EED8					;
CMP #Jumpman_State_Dead				;nor when dead
BEQ RETURN_EED8					;

LDA #$11					;erase 1 tile (phase 3 bolt)
STA EraseBuffer					;

LDA #$01					;mark this bolt as removed
STA Bolt_RemovedFlag,Y				;
JSR CODE_EF38					;

LDA Jumpman_OAM_Y				;put score sprite above the player
CLC						;
ADC #$10					;
STA $06						;

LDA Jumpman_OAM_X				;at the same x-pos
STA $05						;

LDX #$00					;spawn score sprite for removed bolt (100)
JSR CODE_CFC6					;

LDA #Sound_Fanfare_Score			;score sound
STA Sound_Fanfare				;

RETURN_EED8:
RTS						;

;player is crossing a space without bolt.
CODE_EED9:
LDA Jumpman_State				;if Jumpman is jumping over that space, return
CMP #Jumpman_State_Jumping			;
BEQ RETURN_EEE6					;

JSR CODE_EF51					;remove hammer if being held

LDA #Jumpman_State_Falling			;
STA Jumpman_State				;Jumpman's falling

RETURN_EEE6:
RTS						;

CODE_EEE7:
CPY #$07					;checked all 6 bolts?
BEQ CODE_EEF0					;go check items then
INX						;check the next bolt
INY						;
JMP LOOP_EE8D					;

CODE_EEF0:
LDY PhaseNo					;
LDX DATA_C5FA,Y					;

LDY #$00					;

CODE_EEF7:
LDA UNUSED_C5AE,X				;check if at this Y-pos
CMP Jumpman_OAM_Y				;
BNE CODE_EF2F					;

LDA UNUSED_C5C1+1,X				;check if at this x-pos
CMP Jumpman_OAM_X				;
BNE CODE_EF2F					;

LDA Item_RemovedFlag,Y				;check if the item has been removed already
BNE CODE_EF2F					;if so, check next one maybe

LDA #$22					;2 rows with 2 tiles (16x16, yes, even handbag)
STA EraseBuffer					;

LDA #$01					;mark this item as removed
STA Item_RemovedFlag,Y				;
JSR CODE_EF38					;

LDA Jumpman_OAM_Y				;score spawn position, slightly above
SEC						;
SBC #$08					;
STA $06						;

LDA Jumpman_OAM_X				;at player's x-pos
STA $05						;

LDX #$03					;800 score for the item
JSR CODE_CFC6					;

LDA #Sound_Fanfare_Score			;collected an item sound
STA Sound_Fanfare				;

RETURN_EF2E:
RTS						;

CODE_EF2F:
CPY #$02					;only 2 items to check
BEQ RETURN_EF2E					;went through all of them, return
INX						;\
INY						;|next item then
JMP CODE_EEF7					;/

CODE_EF38:
LDA #Tile_Empty					;\all empty tiles
STA EraseBuffer+1				;|
STA EraseBuffer+2				;|
STA EraseBuffer+3				;|
STA EraseBuffer+4				;/

LDA DATA_C5D6,X					;VRAM address based on where we removed a thing
STA $01						;

LDA UNUSED_C5E9,X				;
STA $00						;

LDA #$48					;
JMP CODE_C815					;write to buffer

;this code is used to remove the hammer Jumpman was holding
;RemoveHeldHammer_EF51:
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
;A - pointer for correct speed and position addresses (for each entity)
;UpdateYPositionWithForce_EF72:
CODE_EF72:
STX $0F						;used to preserve x (springboards, technically jumpman but there's only 1 on-screen so its always 0 by default)
ASL A						;
TAX						;
LDA Entity_GravityInitFlag,X			;did we init speed and stuff?
BNE CODE_EF94					;apply gravity and stuff, init otherwise
STA Entity_DownwardSpeed,X			;downward speed (always 0)
CPX #$00					;
BNE CODE_EF87					;check if jumpman

LDA #$08					;downward subspeed for jumpman
JMP CODE_EF89					;

CODE_EF87:
LDA #$80					;downward subspeed for springboards

CODE_EF89:
STA Entity_DownwardSubSpeed,X			;downward subspeed (either 80 or 08)

LDA #$F0					;
STA Entity_SubYPos,X				;initializes sub-position (basically at the peak of a single pixel)
JMP CODE_EFAD					;

CODE_EF94:
LDA Entity_DownwardSubSpeed,X			;
CPX #$00					;once again, check if updating for jumpman
BNE CODE_EFA0					;

ADC #$10					;basically this is a gravity value for jumpman (subposition)
JMP CODE_EFA2					;

CODE_EFA0:
ADC #$30					;higher gravity force for springboards

CODE_EFA2:
STA Entity_DownwardSubSpeed,X			;downward speed sub

LDA Entity_DownwardSpeed,X			;downward speed actual
ADC #$00					;
STA Entity_DownwardSpeed,X			;

;how it works is it constantly applies gravity, but also fights with upward force

CODE_EFAD:
LDA Entity_SubYPos,X				;apply upward y-speed (the jump speed)
SEC						;
SBC Entity_UpwardSubSpeed,X			;
STA Entity_SubYPos,X				;sub-pos

LDA $01						;actual position
SBC Entity_UpwardSpeed,X			;
STA $01						;

CLC						;now apply downward y-speed
LDA Entity_SubYPos,X				;
ADC Entity_DownwardSubSpeed,X			;
STA Entity_SubYPos,X				;

LDA $01						;
ADC Entity_DownwardSpeed,X			;
STA $01						;final actual y-pos result

INC Entity_GravityInitFlag,X			;no more init... can potentially overflow if in air for too long, but I guess this can't happen anywhere in the base game.

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

;get hitboxes (and maybe check if they collide)
CODE_EFE8:
JSR CODE_C847					;A for hitbox A's width and height and stuff.

;GetHitboxA_EFEB:
CODE_EFEB:
LDA #$00					;A = 0 - get hitbox A
BEQ CODE_EFF5					;

;GetHitboxBAndCollisionDetection_EFEF:
CODE_EFEF:
LDA #$01					;A = 1 - get hitbox B and compare hitboxes
BNE CODE_EFF5					;

;GetHitboxBAndCollisionDetection_EFF3:
CODE_EFF3:
LDA #$02					;A = 2 - get hitbox B and compare hitboxes (same as 01?)

CODE_EFF5:
STA $0C						;

TXA						;\preserve X and Y
PHA						;|
TYA						;|
PHA						;/

LDY #$00					;

LDA $0C						;compare hitboxes against each other?
BNE CODE_F018					;sure

;calculate hitbox A
JSR CODE_F063					;
STA HitboxA_XPos_Left				;x-pos

JSR CODE_F069					;
STA HitboxA_YPos_Top				;y-pos

JSR CODE_F062					;
STA HitboxA_XPos_Right				;x-pos + hitbox width (hitbox horizontal end, or simply put, right boundary)

JSR CODE_F069					;
STA HitboxA_YPos_Bottom				;y-pos + hitbox height (hitbox vertical end, or simply bottom boundary)
JMP CODE_F059					;

;calculate hitbox B and and compare hitboxes
CODE_F018:
JSR CODE_F063					;
STA HitboxB_XPos_Left				;x-pos

JSR CODE_F069					;
STA HitboxB_YPos_Top				;y-pos

JSR CODE_F062					;
STA HitboxB_XPos_Right				;x-pos + hitbox width

JSR CODE_F069					;
STA HitboxB_YPos_Bottom				;y-pos + hitbox height

LDA HitboxB_XPos_Left				;hitbox B x-pos minus hitbox A x-pos
SEC						;
SBC HitboxA_XPos_Left				;
STA Hitboxes_XDistance				;distance (can be used afterwards)

LDA HitboxB_YPos_Top				;hitbox B y-pos minus hitbox A y-pos
SEC						;
SBC HitboxA_YPos_Top				;
STA Hitboxes_YDistance				;vertical distance

;y-pos checks
LDA HitboxA_YPos_Bottom				;bottom check for hitbox A vs. top check for hitbox B
CMP HitboxB_YPos_Top				;
BCC CODE_F057					;higher (from top to bottom, from 00 to FF)? no collision

LDA HitboxB_YPos_Bottom				;bottom check for hitbox B vs. top check for hitbox A
CMP HitboxA_YPos_Top				;
BCC CODE_F057					;higher? no collision

;x-pos checks
LDA HitboxB_XPos_Right				;right check for hitbox B vs. left check for hitbox A
CMP HitboxA_XPos_Left				;
BCC CODE_F057					;further to the left? no collsion

LDA HitboxA_XPos_Right				;right check for hitbox A vs. left check for hitbox B
CMP HitboxB_XPos_Left				;
BCC CODE_F057					;

;lets summarize (as an example jumpman is hitbox A and some entity like a block is hitbox B): 
;if Jumpman's bottom is higher than entity's top, no collision
;if entity's bottom is higher than Jumpman's top, no collision
;if entity's right is to the left of the Jumpman's left, no collision
;if Jumpman's right is to the left of entity's left, no collision
;if none of the above is true, the Jumpman's hitbox overlaps with entity's, and the collision occures
;Yeah, this is probably unecessary to explain in such detail, but my brain didn't want to work well without breaking it to such basics

LDA #$01					;collision - SUCCESS!
JMP CODE_F059					;

CODE_F057:
LDA #$00					;collision - opposite of SUCCESS!

CODE_F059:
STA $0C						;

PLA						;\restore X and Y
TAY						;|
PLA						;|
TAX						;/

LDA $0C						;result
RTS						;

CODE_F062:
INY						;

;get x-pos boundaries
CODE_F063:
LDA ($02),Y					;width
CLC						;
ADC $00						;00 contains x-pos
RTS						;

;get y-pos boundaries
CODE_F069:
INY						;
LDA ($02),Y					;height
CLC						;
ADC $01						;01 contains y-pos
RTS						;

;routines all leading to sprite tile drawing one, with various inputs
;this specific routine (CODE_F070) should've been used more...
CODE_F070:
STA $02						;
JSR JumpmanPosToScratch_EAE1			;get jumpman's positions into scrath RAM ($00 and $01)

CODE_F075:
JSR SpriteDrawingPREP_JumpmanOAM_EACD		;and other stuff, like OAM address itself (for indirect addressing)

CODE_F078:
LDA Direction_Horz				;
AND #$03					;why is this a thing? didn't we filter other inputs specifically for this address?
LSR A						;draw flipped or not depending on player's direction
JMP SpriteDrawingEngine_F096			;start drawing

CODE_F080:
STA $04						;OAM low byte

CODE_F082:
LDA #$00					;
BEQ SpriteDrawingEngine_F096			;wow, so branches are a thing now?

;SpriteDrawingEnginePrep_SetOAMThenDrawFlipped_F086:
CODE_F086:
STA $04						;OAM low byte

;SpriteDrawingEnginePrep_DrawFlipped_F088:
CODE_F088:
LDA #$01					;draw flipped
BNE SpriteDrawingEngine_F096			;

;SpriteDrawingEnginePrep_SetOAMThenRemoveSprites_F08C:
CODE_F08C:
STA $04						;

;SpriteDrawingEnginePrep_RemoveSprites_F08E:
CODE_F08E:
LDA #$04					;
BNE SpriteDrawingEngine_F096			;

CODE_F092:
STA $03						;rows and columns n stuff

CODE_F094:
LDA #$0F					;

;This routine is used for sprite tile updates
;Input:
;A - drawing mode stored into $0F, values: 00 - draw/redraw, 01 - draw/redraw horizontally flipped, 04 - init sprite tiles' properties (keeps them hidden however), any other value - erase tiles
;$00 - X-position of the first column (to the left)
;$01 - Y-position of the first row (the highest)
;$02 - first tile to start drawing from (e.g. 04 means draw tiles 04,05,06 and 07 if drawing 4 tiles). for sprite tile initialization (draw mode = 4) this is used to fill properties (OAM_Prop)
;$03 - rows and amount of tiles on each row (high nibble - rows, low nibble - number of tiles). for drawing mode = 4, used as a number of total tiles to remove
;$04 - low byte of OAM address for indirect addressing.

;used addresses (aside from above ofc)
;$05 - high byte of OAM address for indirect addressing (always #$02)
;$06 - how many tiles tall the sprite is (number of rows)
;$07 - how wide the sprite is (amount of sprites in the same row)
;$08 - total sprite tiles to draw
;$09 - y-position of each tile in a column (draw mode = 0). also contains copy of $01 for erasing mode (draw mode = 2-FF), but it's not used for anything.
;$0A - offset for indirect addressing to access OAM's tile and property (draw mode = 1)
;$0B - tile offset for reverse tile updating (draw mode = 1)
;$0F - drawing mode

SpriteDrawingEngine_F096:
;push a bunch of things, registers, some temp RAM and stuff
PHA						;
STA $0F						;input A into this

TXA						;
PHA						;save x

TYA						;
PHA						;save y

LDA $00						;save this
PHA						;

LDA $05						;and this
PHA						;

LDA $06						;you get the idea
PHA						;

LDA $07						;
PHA						;

LDA $08						;
PHA						;

LDA $09						;
PHA						;

LDA #>OAM_Y					;high byte for indirect addressing is always 02 (to get access to 0200 page, OAM)         
STA $05						;

LDA $0F						;check for tile init mode
CMP #$04					;
BEQ CODE_F0EF					;

LDA #$0F					;
AND $03						;
STA $07						;separate rows

LDA $03						;
LSR A						;
LSR A						;
LSR A						;
LSR A						;
STA $06						;get columns
TAX						;
LDA #$00					;calculate from zero
CLC						;

LOOP_F0CB:
ADC $07						;Rows * Tiles (so if 2 columns and 2 tiles each thats 4 tiles)
DEX						;
BNE LOOP_F0CB					;loop
STA $08						;get total OAM slots to draw

LDA $0F						;
BNE CODE_F0DC					;
JSR CODE_F11E					;update tiles and properties (no flips)
JMP CODE_F0E9					;

CODE_F0DC:
CMP #$01					;
BEQ CODE_F0E6					;

JSR CODE_F195					;erase tiles
JMP CODE_F0F2					;end

CODE_F0E6:
JSR CODE_F161					;draw but its horizontally flipped

CODE_F0E9:
JSR CODE_F139					;positions
JMP CODE_F0F2					;end

CODE_F0EF:
JSR CODE_F10A					;sprite tiles initialization

CODE_F0F2:
PLA						;restore all stuff (a lot!)
STA $09						;

PLA						;
STA $08						;

PLA						;
STA $07						;

PLA						;
STA $06						;

PLA						;
STA $05						;

PLA						;
STA $00						;

PLA						;
TAY						;

PLA						;
TAX						;

PLA						;
RTS						;

;init sprite tiles: keep them hidden but store props
CODE_F10A:
LDX $03						;in this case $03 isn't columns and rows but a number of tiles to init (instead of $08 used in other routines)
LDY #$00					;

LOOP_F10E:
LDA #$FF					;
STA ($04),y					;Y-pos (remove sprite tile)
INY						;
INY						;
LDA $02						;properties
STA ($04),Y					;
INY						;
INY						;
DEX						;init all of em
BNE LOOP_F10E					;
RTS						;

;draw or redraw sprite tiles (no x-flip)
CODE_F11E:
LDA $02						;load first tile
LDX $08						;how many tiles?
LDY #$01					;for sprite tile

LOOP_F124:
STA ($04),Y					;
CLC						;
ADC #$01					;next sprite tile number
INY						;load property next
PHA						;and save A
LDA ($04),Y					;remove flip bits
AND #$3F					;
STA ($04),Y					;
PLA						;restore sprite tile num
INY						;next OAM slot
INY						;
INY						;
DEX						;until all tiles are done
BNE LOOP_F124					;
RTS						;

;store sprite tile positions
CODE_F139:
LDY #$00					;

LOOP_F13B:
LDX $06						;
LDA $01						;copy y-position
STA $09						;

LOOP_F141:
LDA $09						;
STA ($04),Y					;
CLC						;next sprite tile's y-position in the same column
ADC #$08					;
STA $09						;
INY						;
INY						;
INY						;
LDA $00						;
STA ($04),Y					;same x-pos for all tiles in a column
INY						;
DEX						;
BNE LOOP_F141					;loop until done with a column

LDA $00						;next tile in a row
CLC						;
ADC #$08					;
STA $00						;

DEC $07						;
BNE LOOP_F13B					;draw another column
RTS						;

;draw horizontally flipped
CODE_F161:
LDY #$01					;for indirect access
STY $0A						;

LDA $08						;total tiles
SEC						;
SBC $06						;minus number of rows

LOOP_F16A:
TAY						;
STA $0B						;base offset for tiles (since we're drawing them in reverse order)

LDX $06						;

LOOP_F16F:
TYA						;
PHA						;
CLC						;
TYA						;
ADC $02						;tile offset + base tile value
LDY $0A						;
STA ($04),Y					;tile

INY						;
LDA ($04),Y					;
AND #$3F					;
EOR #OAMProp_XFlip				;flip x!
STA ($04),Y					;

INY						;next OAM slot
INY						;
INY 						;
STY $0A						;
PLA						;
TAY						;
INY						;
DEX						;update until the column is done
BNE LOOP_F16F					;

LDA $0B						;that tile offset
SEC						;
SBC $06						;minus rows
BPL LOOP_F16A					;continue witht the next column if we aren't done
RTS						;

;remove sprite tiles
CODE_F195:
LDY #$00					;

LOOP_F197:
LDX $06						;how many rows

LDA $01						;y-pos? seems pointless
STA $09						;

LDA #$FF					;remove sprite tiles

LOOP_F19F:
STA ($04),Y					;
INY						;
INY						;
INY						;
INY						;
DEX						;
BNE LOOP_F19F					;

LDA $00						;this is also pointless? smells like a copy-paste to me yet again
CLC						;
ADC #$08					;
STA $00						;

DEC $07						;remove all columns
BNE LOOP_F197					;
RTS						;

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
LDY #$00					;
LDA #Tile_Empty					;fill entire screen with tile EMPTY

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

UpdateScreenLoop_F1EC:
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
STA DrawRegister				;
DEX						;
BNE LOOP_F211					;
SEC						;set carry
TYA						;shift original read location so we can continue from here
ADC $00						;
STA $00						;

LDA #$00					;high byte ofc.
ADC $01						;
STA $01						;

;used to draw stuff on screen
;in this game, this is only called to draw from buffer and sometimes directly from draw pointers. there are some other drawing routines elsewhere.
UpdateScreen_F228:
LDX HardwareStatus				;
LDY #$00					;
LDA ($00),Y					;if value isn't zero, which acts as stop writing comand
BNE UpdateScreenLoop_F1EC			;do actual writing

LDA CameraPositionX				;restore camera position
STA CameraPositionReg				;

LDA CameraPositionY				;
STA CameraPositionReg				;
RTS						;

;Push score related stuff into buffer for display
;A - amount of counters to update (i think?)
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

INY						;
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

LDA #$00					;
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

LDA #Tile_Empty
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
LDA #Tile_Empty
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
AND #$10					;
BEQ RETURN_F2D6					;

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
;Input:
;$00-$01 - VRAM address from which the modifications are made
;$02-$03 - Table pointer from which the data for buffer is gathered

;VRAMWritetoBuffer_F2D7:
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

;score calculation routine.
;input:
;$00 - how much score to add/substract.
;$01 - score or counter offset (bits 0-2), valid values are listed below. bit 3 - do calculation with ones and tens, otherwise hundreds and thousands

;score substraction (used for BONUS counter)
;SubstractFromScoreCounter_F33E:
CODE_F33E:
LDX #$FF					;
BNE CODE_F344					;

;score addition
;AddToScoreCounter_F342:
CODE_F342:
LDX #$00					;

CODE_F344:
STX $04						;

LDX #$00					;
STX $05						;tens and hundreds of thousands init
STX $06						;hundreds and thousands init
STX $07						;tens and ones init

LDA $01						;check if adding to ones/hundreds
AND #$08					;
BNE CODE_F355					;

INX						;if bit 3 isn't set, addition is done to tens/ones

CODE_F355:
LDA $00						;
STA $06,X					;

LDA $01						;load player information
JMP CODE_F35E					;ok???

;$05 - Hundreds and tens thousands to add (always set to 0 however)
;$06 - Thousands and hundreds to add
;$07 - Tens and ones to add
;A - score address offset, where 0 - player 1, 1 - player 2, 2 - bonus counter

CODE_F35E:
AND #$07					;only relevant bits for current player (support for up to 7 different counters, huh?)
ASL A						;
ASL A						;get correct index for score RAM addresses
TAX						;

LDA $04						;0 - addition, non-zero - substraction
BEQ CODE_F38E					;

LDA $24,X					;if this flag is set, it'll instead do addition?
BEQ CODE_F392					;

;doing addition
CODE_F36B:
CLC						;
LDA ScoreDisplay_Counter+2,X			;
STA $03						;

LDA $07						;
JSR CODE_F3E3					;calculate ones and tens
STA ScoreDisplay_Counter+2,X			;

LDA ScoreDisplay_Counter+1,X			;
STA $03						;

LDA $06						;
JSR CODE_F3E3					;calculate hundreds and thousands
STA ScoreDisplay_Counter+1,X			;

LDA ScoreDisplay_Counter,X			;
STA $03						;

LDA $05						;calculate tens and hundreds thousands
JSR CODE_F3E3					;
STA ScoreDisplay_Counter,X			;
RTS						;

CODE_F38E:
LDA $24,X					;if this flag is set, it'll do substraction instead???
BEQ CODE_F36B					;i guess this is like an overflow/underflow prevention measure, but it seems weirdly handled (does it even work?).

;doing substraction
CODE_F392:
SEC						;
LDA ScoreDisplay_Counter+2,X			;
STA $03						;

LDA $07						;sub ones tens
JSR CODE_F404					;
STA ScoreDisplay_Counter+2,X			;

LDA ScoreDisplay_Counter+1,X			; 
STA $03						;

LDA $06						;sub hundreds thousands
JSR CODE_F404					;
STA ScoreDisplay_Counter+1,X			;

LDA ScoreDisplay_Counter,X			;
STA $03						;

LDA $05						;sub ten/hundred thousands
JSR CODE_F404					;
STA ScoreDisplay_Counter,X			;

;check for underflow?
LDA ScoreDisplay_Counter,X			;non zero is a ok
BNE CODE_F3C0					;

LDA ScoreDisplay_Counter+1,X			;keep checking if all are zero
BNE CODE_F3C0					;

LDA ScoreDisplay_Counter+2,X			;
BEQ CODE_F3C6					;if all is zero, keep substraction, but still compensate

CODE_F3C0:
BCS RETURN_F3E2					;check if there's a value underflow. if not, don't fix

LDA $24,X					;instead of substraction, do addition. but why?
EOR #$FF					;

CODE_F3C6:
STA $24,X					;

SEC						;
LDA #$00					;basically 1 because of SEC... yeah?
STA $03						;

LDA ScoreDisplay_Counter+2,X			;
JSR CODE_F404					;
STA ScoreDisplay_Counter+2,X			;

LDA ScoreDisplay_Counter+1,X			;
JSR CODE_F404					;
STA ScoreDisplay_Counter+1,X			;

LDA ScoreDisplay_Counter,X			;
JSR CODE_F404					;
STA ScoreDisplay_Counter,X			;

RETURN_F3E2:
RTS						;

;Calculate counter value, like score
;Input:
;$03 - original value to add to
;A - value to add
;Output:
;A - result
;Carry - if next calculation in this routine should have a +1 to the right digit
;CounterAddition_F3E3:
CODE_F3E3:
JSR CODE_F426					;
ADC $01						;
CMP #$0A					;if value less than A
BCC CODE_F3EE					;don't round
ADC #$05					;by adding 6 (incluing carry)

CODE_F3EE:
CLC						;
ADC $02						;
STA $02						;

LDA $03						;tens/thousands/ten thousands
AND #$F0					;only care about left digit that can overflow
ADC $02						;and additional ten/whatev
BCC CODE_F3FF					;overflow?

CODE_F3FB:
ADC #$5F					;+$60 because of the carry (need carry set to get there)
SEC						;and +1 to the next digit calculation (so for example 90+20=110, which results in +1 to the hundreds address)
RTS						;

CODE_F3FF:
CMP #$A0					;hundreds and etc?
BCS CODE_F3FB					;if so, round it to 0
RTS						;otherwise return

;Calculate counter value, like score, substraction
;$03 - original value to substract from
;A - value to substract
;Output:
;A - result
;Carry - if next calculation in this routine should have a -1 to the low digit
;CounterSubstraction_F404:
CODE_F404:
JSR CODE_F426					;extract digits into separate adresses
SBC $01						;do some calculation for carry
STA $01						;
BCS CODE_F417					;
ADC #$0A					;decimal-ize, 10-1 = 9, not F
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

ADC #$A0					;same decimal operation with high nibble
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
;ExtractDigits_F426:
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
UpdateTOPScore_F435:
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
SEC						;
LDA ScoreDisplay_Top+2,Y			;
STA $03						;

LDA ScoreDisplay_Counter+2,X			;will compare score with top score by substracting TOP from current player score
JSR CODE_F404					;

LDA ScoreDisplay_Top+1,Y			;
STA $03						;

LDA ScoreDisplay_Counter+1,X			;
JSR CODE_F404					;

LDA ScoreDisplay_Top,Y				;
STA $03						;

LDA ScoreDisplay_Counter,X			;
JSR CODE_F404					;
BCS CODE_F4A4					;

LDA $0020,Y					;TOP sub/add invert flag? similar to similar addresses for normal score calculation
BNE CODE_F4A9
  
CODE_F479:
LDA #$FF					;
STA $04						;
SEC						;carry set, means can overwrite TOP score

CODE_F47E:   
TYA						;something to do if there were multiple TOP scores? i'm not sure...
BNE RETURN_F49F					;
BCC CODE_F493					;

;store TOP score (if player's score is higher)
LDA $24,X					;still not sure what this is supposed to be
STA $20						;

LDA ScoreDisplay_Counter,X			;
STA ScoreDisplay_Top				;

LDA ScoreDisplay_Counter+1,X			;
STA ScoreDisplay_Top+1				;

LDA ScoreDisplay_Counter+2,X			;
STA ScoreDisplay_Top+2				;

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
LDA $24,X					;
BEQ CODE_F453					;

CODE_F4A4:
LDA $0020,Y					;
BNE CODE_F479					;

CODE_F4A9:
CLC						;can't overwrite TOP score
BCC CODE_F47E					;

;Handle various timers
HandleTimers_F4AC:
LDX #$09					;
DEC Timer_Timing				;
BPL LOOP_F4B8					;

LDA #$0A					;decrease every some timers every 10 frames
STA Timer_Timing				;

LDX #$10					;more timers decrease every 10 frames instead of just every frame

LOOP_F4B8:
LDA Timer_Global,X				;
BEQ CODE_F4BE					;if at zero, stay at zero

DEC Timer_Global,X				;

CODE_F4BE:
DEX						;
BPL LOOP_F4B8					;
RTS						;

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
  JSR Gamecube_CODE_BFD0			;make RNG slower for one reason or another in gamecube version
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
ReadControllers_F50E:
LDA #$01					;prepare controller 1 for reading
STA ControllerReg				;

LDX #$00					;run through controller 1 inputs
LDA #$00					;
STA ControllerReg				;and controller 2
JSR CODE_F522					;
INX						;
If Version = JP
  JMP JP_CODE_F530				;interestingly enough, Revision 1 REMOVES a minor optimization... though it's pointless either way
else
  JSR CODE_F522					;
RTS						;eh
endif

JP_CODE_F530:
CODE_F522:
LDY #$08					;

LOOP_F524:
PHA						;
LDA ControllerReg,X				;
STA $00						;
LSR A						;
ORA $00						;
LSR A						;
PLA						;
ROL A						;
DEY						;
BNE LOOP_F524					;
STX $00						;
ASL $00						;double X, basically, to get proper press and hold addresses for each player

LDX $00						;
LDY ControllerInput,X				;
STY $00						;
STA ControllerInput,X				;
If Version = JP
  STA ControllerInput_Previous,X		;HMM...
endif
AND #$FF					;HMMMMM
BPL CODE_F549					;
BIT $00						;
BPL CODE_F549					;
AND #$7F					;

If Version = JP
  STA ControllerInput_Previous,X		;japenese version has a shorter input reading code. US adds some bit (probably related with 2 inputs at once, for example holding left+up won't make jumpman move left in rev 0)

JP_RETURN_F55B:
CODE_F549:
  RTS						;
else
CODE_F549:
  LDY ControllerInput_Previous,X		;
  STA ControllerInput_Previous,X		;
  TYA						;
  AND #$0F					;
  AND ControllerInput_Previous,X		;
  BEQ RETURN_F55A				;
  ORA #$F0					;
  AND ControllerInput_Previous,X		;
  STA ControllerInput_Previous,X		;

RETURN_F55A:
  RTS						;
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

If Version = JP
  db $0F,$2C,$38,$02				;tile palette 0
else
  db $0F,$2C,$38,$12 				;US Version brightens "Donkey Kong" title
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

;this is where strings are stored (1 PLAYER GAME A, 2 PLAYER GAME B, etc.)

;1 PLAYER GAME A
db $22,$09
db $0F
db $01,$24,$19,$15,$0A,$22,$0E,$1B
db $24,$10,$0A,$16,$0E,$24,$0A

;1 PLAYER GAME B
db $22,$49
db $0F
db $01,$24,$19,$15,$0A,$22,$0E,$1B
db $24,$10,$0A,$16,$0E,$24,$0B

;2 PLAYER GAME A
db $22,$89
db $0F
db $02,$24,$19,$15,$0A,$22,$0E,$1B
db $24,$10,$0A,$16,$0E,$24,$0A

;2 PLAYER GAME B
db $22,$C9
db $0F
db $02,$24,$19,$15,$0A,$22,$0E,$1B
db $24,$10,$0A,$16,$0E,$24,$0B

;(c)1981 NINTENDO CO.,LTD.
db $23,$05
db $16
db $D3,$01,$09,$08,$01,$24,$17,$12
db $17,$1D,$0E,$17,$0D,$18,$24,$0C
db $18,$65,$15,$1D,$0D,$64

;MADE IN JAPAN
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

;i'll be using Super Mario Bros. and Super Mario Bros. 3's sound engine as a reference, since they's similar in some aspects (I know Mario Bros. got an update, which I'll get to)
SoundEngine_FA48:
LDA #$C0					;
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
LDY #$07					;

CODE_FA88:
ASL A						;
BCS RETURN_FA8E					;
DEY						;
BNE CODE_FA88					;if there are still bits left, loop

;otherwise it's assumed that bit 0 is set

RETURN_FA8E:
RTS					;

CODE_FA8F:
STA $F1                  
STY $F2                  

CODE_FA93:
LDY #$7F					;square's "sweep unit" is disabled, negate flag, shift and period at max    

CODE_FA95:
STX $4000
STY $4001					;
RTS

JSR CODE_FA95					;inaccessible line of code

;SetFreq_Squ1_FA9F:
CODE_FA9F:
LDX #$00

CODE_FAA1:   
TAY                      
LDA UNUSED_FB00+1,Y				;FreqRegLookupTbl
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

;play triangle sound
CODE_FABA:
STA $4008				;
TXA					;
AND #$3E				;
LDX #$08				;offset for triangle's APU registers
BNE CODE_FAA1				;

;AlternateLengthHandler_FAC4:
CODE_FAC4:
TAX                      
ROR A                    
TXA                      
ROL A
ROL A
ROL A

;ProcessLengthData_FACA:
CODE_FACA:  
AND #$07					;
CLC						;
ADC Sound_NoteLengthOffset			;
TAY						;
LDA DATA_FB4C,Y					;get note length from this little table
RTS						;

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

;note length data
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

LDY #$08					;technically 9th fanfare (Sound_Effect2_Dead part 2)
JMP CODE_FD67					;

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
LDY Sound_Effect2				;
LDA $F0						;keep playing dead sound
LSR A						;
BCS CODE_FB89					;
LSR Sound_Effect2				;$01 - died
BCS CODE_FB7E					;

LDX Sound_FanfareSquareTrackOffset		;playing fanfare that uses square
BNE CODE_FC4B					;no sound effects?
LSR A						;keep playing enemy destruction sound
BCS CODE_FBC2					;
LSR Sound_Effect2				;$02 - enemy destruct
BCS CODE_FBB7					;
LSR A						;keep playing jump sound
BCS CODE_FC28					;
LSR Sound_Effect2				;$04 - jump
BCS CODE_FC19					;
LSR A						;keep playing movement sound
BCS CODE_FC62					;
LSR Sound_Effect2				;$08 - movement sound
BCS CODE_FC51					;

CODE_FC16:
JMP CODE_FC90					;otherwise handle hit sound (Sound_Effect_Hit)
  
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

LDA Sound_FanfareTriangleTrackOffset		;is triangle being used?
BNE CODE_FD0B					;keep on playing

;play sound effect
LDY Sound_Effect
LDA $06A1                
LSR Sound_Effect
BCS CODE_FCBA                
LSR A                    
BCS CODE_FCBE                
LSR A                    
BCS CODE_FCF0                
LSR Sound_Effect
BCS CODE_FCDB                
BCC CODE_FD0B					;not playing a sound effect, skip ahead
  
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
LDX Sound_FanfareSquareTrackOffset		;don't play music during certain fanfares that use square?
BNE CODE_FD58					;

LDA Sound_Music					;check if we're trying to play some music
BNE CODE_FD18					;yes we are
STA Sound_MusicMirror				;clear the mirror
BEQ CODE_FD58					;and play no music

CODE_FD18:  
EOR Sound_MusicMirror				;check if we're trying to play the same musc
BEQ CODE_FD35					;continue playing triangle as the god intended if it's the same song

CODE_FD1D:
LDA Sound_Music					;initialize song and remember that we're playing this one
STA Sound_MusicMirror				;
JSR CODE_FA86					;

LDA DATA_FFCD,Y					;initialize triangle beat counter (the table is all zeroes though...)
STA Sound_TriangleTrackOffset			;

LDA #<DATA_FFD4					;setup pointer
STA Sound_MusicDataPointer			;

LDA #>DATA_FFD4					;    
STA Sound_MusicDataPointer+1			;
BNE CODE_FD3A					;always branch (a rarity!)
  
CODE_FD35:
DEC Sound_TriangleTimer				;Tri_NoteLenCounter/Music_TriRest
BNE CODE_FD58					;if the triangle is still playing, do something else
  
CODE_FD3A:
LDY Sound_TriangleTrackOffset			;Sound_TriangleTrackOffset
INC Sound_TriangleTrackOffset			;next time different timing
LDA (Sound_MusicDataPointer),Y			;get triangle timing
BEQ CODE_FD1D					;did we hit the end of triangle channel? if so, maybe loop
TAX						;\basically AlternateLengthHandler_FAC4 (which will be replaced with proper JSR in later iterations)
ROR A						;|
TXA						;|
ROL A						;|
ROL A						;|
ROL A						;|
AND #$07					;|
TAY						;/
LDA DATA_FB62,Y					;
STA Sound_TriangleTimer				;wait this long

LDA #$10					;default triangle value ($4008)
JSR CODE_FABA					;play da sound
  
CODE_FD58:
LDA Sound_Fanfare				;should we initialize some fanfare?
BNE CODE_FD62					;yes!

LDA Sound_FanfarePlayFlag			;continue playing fanfare?
BNE CODE_FD9B					;yes
RTS						;no, return

;initialize fanfare variables
CODE_FD62:
JSR CODE_FA86					;bit num
STY Sound_CurrentFanfareID			;

CODE_FD67:
LDA DATA_FE59,Y					;get offset for this fanfare
TAY						;

LDA DATA_FE59,Y					;
STA Sound_NoteLengthOffset			;

LDA DATA_FE59+1,Y				;pointer for the tracks
STA Sound_SoundDataPointer			;

LDA DATA_FE59+2,Y				;
STA Sound_SoundDataPointer+1			;

LDA DATA_FE59+3,Y				;
STA Sound_FanfareTriangleTrackOffset		;Triangle table offset

LDA DATA_FE59+4,Y				;
STA Sound_FanfareSquareTrackOffset		;Square table offset

LDA #$01					;
STA Sound_NoiseTimer				;always play noise
STA Sound_SquareTimer				;maybe play square
STA Sound_TriangleTimer				;maybe play triangle
STA Sound_FanfarePlayFlag			;do play fanfare plz

LDY #$00					;initialize noise track
STY Sound_FanfareNoiseTrackOffset		;

LDA Sound_CurrentFanfareID			;check if current fanfare is Sound_Fanfare_GameStart
BEQ CODE_FDA4					;play constant square sound

CODE_FD9B:
LDY Sound_FanfareSquareTrackOffset		;playing square?
BEQ CODE_FDD8					;no, don't

DEC Sound_SquareTimer				;
BNE CODE_FDD8					;timer is still ticking!

;initialize square
CODE_FDA4:
INC Sound_FanfareSquareTrackOffset		;next byte of the table for the next re-initialization
LDA (Sound_SoundDataPointer),Y			;
BEQ CODE_FDE9					;end fanfare prematurely if hit 0 (omly for game start sound)
BPL CODE_FDB8					;if positive, keep the same timing, just change the beat

JSR CODE_FACA                
STA Sound_SquareTimerSaved			;timer backup

LDY Sound_FanfareSquareTrackOffset		;
INC Sound_FanfareSquareTrackOffset		;
LDA ($F7),Y					;now load beat

CODE_FDB8:
JSR CODE_FA9F					;store to registers to play sound
BNE CODE_FDC1					;if the result was non-zero, go on

LDY #$10					;some kinda default then...
BNE CODE_FDCF					;
  
CODE_FDC1:
LDX #$9F					;more beat setup
LDA Sound_CurrentFanfareID			;check if we're playing Sound_Fanfare_GameStart
BEQ CODE_FDCF					;yes, some specific register value

LDX #$06					;for other fanfares, this
LDA Sound_FanfareTriangleTrackOffset		;unless there's no triangle channel
BNE CODE_FDCF					;

LDX #$86
  
CODE_FDCF:
JSR CODE_FA93

LDA Sound_SquareTimerSaved			;could be the same as last time or changed to a new value
STA Sound_SquareTimer				;actually store
  
CODE_FDD8:
LDA Sound_CurrentFanfareID			;check if fanfare was Sound_Fanfare_GameStart
BEQ CODE_FE31					;keep the same noise, play triangle

DEC Sound_NoiseTimer				;if timer isn't 0, maybe play triangle
BNE CODE_FE31					;

LDY Sound_FanfareNoiseTrackOffset		;
INC Sound_FanfareNoiseTrackOffset		;
LDA (Sound_SoundDataPointer),Y			;
BNE CODE_FE09					;keep playing noise if not 0

;the track has ended
CODE_FDE9:
JSR CODE_FAE0					;set square register to default

LDA #$00					;
STA Sound_FanfareSquareTrackOffset		;no more fanfare square!
STA Sound_FanfareNoiseTrackOffset		;no more fanfare noise!
STA Sound_FanfareTriangleTrackOffset		;no more fanfare triangle!
STA Sound_FanfarePlayFlag			;no more fanfare fanfare!

LDY Sound_CurrentFanfareID			;check if fanfare was Sound_Fanfare_GameStart
BEQ CODE_FE00					;keep the triangle, maybe?

LDY $06A1					;
BNE CODE_FE03
  
CODE_FE00:
STA $4008					;reset triangle

CODE_FE03:
LDA #$10					;
STA $4004					;more default square
RTS

CODE_FE09:
JSR CODE_FAC4					;
STA Sound_NoiseTimer				;timing for the next noise
TXA						;
AND #$3E					;
LDY #$7F					;
JSR CODE_FAB3					;play noise
BNE CODE_FE1D					;something...

LDX #$10                 
BNE CODE_FE2E
  
CODE_FE1D:
LDX #$89                 
LDA Sound_NoiseTimer				;check if timer is higher than
CMP #$18					;this right here value
BCS CODE_FE2E					;...yeah, no clue

LDX #$86                 
CMP #$10                 
BCS CODE_FE2E

LDX #$84

CODE_FE2E:
STX $4004

CODE_FE31:
LDY Sound_FanfareTriangleTrackOffset		;
BEQ RETURN_FE58					;if zero, no triangle

DEC Sound_TriangleTimer				;should update triangle?
BNE RETURN_FE58					;no, count down

INC Sound_FanfareTriangleTrackOffset		;
LDA (Sound_SoundDataPointer),Y			;
JSR CODE_FAC4					;fetch time for the next beat
STA Sound_TriangleTimer				;
CLC						;
ADC #$FE					;
ASL A						;
ASL A						;
CMP #$38					;this is a max value for triangle, whatever that value is
BCC CODE_FE4F					;

LDA #$38

CODE_FE4F:
LDY Sound_CurrentFanfareID			;is it Sound_Fanfare_GameStart that's playing?
BNE CODE_FE55					;

LDA #$FF					;some specific hardcoded value

CODE_FE55:
JSR CODE_FABA					;generate sound

RETURN_FE58:
RTS						;

;first 9 bytes are offsets foreach Sound_Fanfare entry
;9? But there are only 8 valid values for fanfares! you may proclaim.
;to which I say... yes. However, there's also Sound_Effect2_Dead, which is a two parter - the second part is considered to be fanfare and has dedicated tables and such.
DATA_FE59:
db $09,$0E,$13,$18,$1D,$22,$27,$2C,$31


;if the format is the same as in SMB, it's as follows:
;1 byte - length byte offset
;2 bytes - sound data address
;1 byte - triangle data offset
;1 byte - square 1 data offset

db $00,<DATA_FE8F,>DATA_FE8F,<(DATA_FEAA-DATA_FE8F),$00
db $08,<DATA_FEB0,>DATA_FEB0,$00,<(DATA_FEBC-DATA_FEB0)
db $00,<DATA_FECF,>DATA_FECF,$00,<(DATA_FEE9-DATA_FECF)
db $08,<DATA_FF05,>DATA_FF05,$00,<(DATA_FF10-DATA_FF05)
db $00,<DATA_FFAD,>DATA_FFAD,$00,<(DATA_FFB0-DATA_FFAD)
db $00,<DATA_FFBE,>DATA_FFBE,$00,$00
db $00,<DATA_FFC4,>DATA_FFC4,$00,$00
db $0F,<DATA_FF20,>DATA_FF20,<(DATA_FF41-DATA_FF20),<(DATA_FF5E-DATA_FF20) ;title screen theme uses both square and triangle
db $00,<DATA_FFA1,>DATA_FFA1,<(DATA_FFA9-DATA_FFA1),$00		;dead part 2

;Fanfare 1 - Game Start

;Square. the only fanfare that uses square as primary channel, and not noise
DATA_FE8F:
db $86,$46,$82,$4A,$83,$26,$46,$80
db $34,$32,$34,$32,$34,$32,$34,$32
db $34,$32,$34,$32,$34,$32,$34,$32
db $84,$34,$00

;Triangle
DATA_FEAA:
db $A9,$AC,$EE,$E8,$33,$35

;Fanfare 2 - Phase Complete

;Noise
DATA_FEB0:
db $16,$16,$57,$1E,$20,$64,$9E,$1E
db $20,$64,$9E,$00

;Square
DATA_FEBC:
db $80,$30,$30,$85,$30,$80,$1A,$1C
db $81,$1E,$82,$1A,$80,$1A,$1C,$81
db $1E,$82,$1A

;Fanfare 3 - Kong Defeated (Ending Theme)

;Noise
DATA_FECF:
db $5E,$5E,$5C,$5C,$5A,$5A,$58,$58
db $57,$16,$18,$9A,$96,$59,$18,$1A
db $9C,$98,$5F,$5E,$60,$5E,$5C,$5A
db $1F,$00

;Square
DATA_FEE9:
db $81,$1A,$1A,$18,$18,$16,$16,$38
db $38,$82,$26,$42,$26,$42,$28,$46
db $28,$46,$30,$28,$30,$28,$81,$3A
db $85,$3C,$84,$3A

;Fanfare 4 - Phase Start

;Noise
DATA_FF05:
db $5E,$02,$20,$42,$4A,$42,$60,$5E
db $60,$1D,$00

;Square
DATA_FF10:
db $82,$26,$42,$26,$42,$81,$40,$80
db $42,$44,$48,$26,$28,$2C,$83,$2E

;Fanfare 8 - Title Theme

;Noise
DATA_FF20:
db $56,$56,$E0,$42,$5A,$5E,$5C,$99
db $58,$58,$E2,$42,$5E,$60,$5E,$9B
db $5A,$5A,$CA,$42,$60,$62,$4A,$8D
db $5C,$5E,$E0,$42,$5A,$5C,$5E,$1D
db $00

;Triangle
DATA_FF41:
db $82,$6F,$6E,$EE,$71,$70,$F0,$77
db $76,$F6,$57,$56,$D6,$A0,$9A,$96
db $B4,$A2,$9C,$98,$B6,$5C,$9C,$96
db $57,$5C,$96,$74,$2F

;Square
DATA_FF5E:
db $85,$02,$81,$2E,$34,$2E,$83,$34
db $81,$48,$28,$30,$28,$30,$28,$85
db $30,$81,$30,$36,$30,$83,$36,$81
db $26,$2C,$30,$2C,$30,$2C,$16,$16
db $1A,$16,$34,$16,$1A,$16,$34,$16
db $1C,$18,$36,$18,$1C,$18,$36,$18
db $16,$2E,$80,$16,$36,$34,$36,$83
db $16,$81,$02,$2E,$80,$16,$36,$34
db $30,$86,$2E

;Fanfare 9 - Death

;Noise
DATA_FFA1:
db $81,$1A,$82,$1E,$30,$83,$16,$00

;Triangle
DATA_FFA9:
db $42,$96,$B0,$E6

;Fanfare 5 - Kong is Falling

;Noise
DATA_FFAD:
db $03,$83,$00

;Square
DATA_FFB0:
db $87,$42,$3E,$42,$3E,$42,$3E,$42
db $3E,$42,$3E,$42,$82,$3E

;Fanfare 6 - Score

;Noise
DATA_FFBE:
db $0A,$0C,$0E,$54,$90,$00

;Fanfare 7 - Pause sound

;Noise
DATA_FFC4:
db $04,$12,$04,$12,$04,$12,$04,$92
db $00      

;all seem to be used but idk
DATA_FFCD:
db $00,$00,$00,$00,$09,$0E,$12

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

incbin DKGFX.bin