;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;local RAM addresses
;some of this comes from Data Crystal. Thanks!

;$00-$0C - common scratch ram for various purposes
;$0D-0E - Unused
;$0F - is a scratch ram too, also used for music restoration from pause (Sound_MusicPauseBackup)

ControlMirror = $10				;mirror of ControlBits
RenderMirror = $11				;mirror of RenderBits
CameraPositionY = $12				;Y-position value of CameraPositionReg (first write)
CameraPositionX = $13				;X-position value of CameraPositionReg (second write)

ControllerInput = $14				;base adress for both controllers (indexed)
ControllerInput_Previous = $15			;same as above but for presses

ControllerInput_Player1 = $14			;buttons held by player 1
ControllerInput_Player1Previous = $15		;holds initial input that won't change if holding additional buttons beside one saved in this address.

ControllerInput_Player2 = $16			;\same for player 2
ControllerInput_Player2Previous = $17		;/

RNG_Value = $18					;8 bytes (18-1F)

ScoreDisplay_Top = $21				;\3 bytes, decimal (21-23).
ScoreDisplay_Player1 = $25			;|(25-27)
ScoreDisplay_Player2 = $29			;/(29-2B)
ScoreDisplay_CurPlayer = $25			;for current player, contains both player1 and player 2 (offset by X)
ScoreDisplay_Bonus = $2E			;2 bytes, decimal, also acts as timer
Score_Top = $0507				;4 bytes, contains top score for game A and B, to be displayed when starting a level. doesn't take tens and ones into account.

Players = $51					;$18 - 1 player, $1C - 2 players
Players_CurrentPlayer = $52			;who's currently in play
ReceivedLife_Flag = $0408			;2 bytes for each player, if true, don't give player extra lives anymore.

Timer_Timing = $34				;used to decrease other timers, probably has other uses
Timer_Global = $35				;16 bytes ($35-$45), specific timers listed below. $35-$3D decrease every frame, the rest decreases every 10 frames
;Timer_KongAnimation = $34			;
Timer_KongSpawn = $36				;timer for donkey kong to spawn an entity (barrel or springboard)
Timer_Hammer = $3F				;timer for hammer power
Timer_Score = $41				;2 bytes, show score sprites for a little bit
Timer_Transition = $43				;common timer used for changing game states, like game over, phase init, etc. (sorta timer though it's strangely handled)
Timer_Demo = $44				;timer that ticks at the title screen, when 0 demo gameplay starts.
Timer_BonusScoreDecrease = $45			;timer that decreases bonus score by 100.

TitleScreen_Flag = $4E				;if we're on title screen
TitleScreen_MainCodeFlag = $0510		;init/main flag. 0 - init, 1 - main
TitleScreen_SelectHeldFlag = $0512		;used to tell if select was pressed so it's not possible to switch options every frame (stays active if select is being held) (also counts up and down in gamecube version)

;related with platforms
Platform_HeightIndex = $59			;how high player is by platform. 1st platform is the lowest and etc.
Platform_ShiftIndex = $86			;used in phase 1 to determine on which shifted platform jumpman's standing.
Jumpman_OnPlatformFlag = $5A			;set when jumpman's standing on the platform. reset when in air or climbing a ladder

PhaseNo = $53

GameControlFlag = $4F				;
GameMode = $50					;bit 0 - Game A or B, bit 1 - 1 player or 2 players

LoopCount = $54					;number of times 100M was completed
LoopCount_PerPlayer = $0402			;2 bytes, contains loop count for each player

Kong_DefeatedFlag = $9A				;sometimes set and reset immideatly when completing phase but phase 3. stops normal gameplay functions just like GameControlFlag
Kong_AnimationFlag = $0503			;if set, kong will play animations, but it's always set to 1, so he always play animations.

;hold directional inputs
Direction = $56					;saves directional input
Direction_Horz = $57				;only saves left and right directional inputs

;Player character addressses
Jumpman_XPos = $46				;doesn't represent actual X-pos, it's used for various checks. it's a copy of jumpman's top-right OAM slot X-pos.
Jumpman_YPos = $47				;same as above
Jumpman_XPosRange = $48				;used for ladder detection. it's the same  value as in Jumpman_XPos, + 4
Jumpman_Lives = $55
Jumpman_State = $96				;$01 - grounded, $02 - on ladder, $04 - Jumping, $08 - Falling, $0A - Has a hammer, $FF - Dead
Jumpman_GFXFrame = $97				;contains top-left sprite tile value, remaining sprite tiles get +1 to this value each
Jumpman_Death_FlipTimer = $98			;timer for flipping death animation. when set to FF, show actual death frame.
Jumpman_HeldHammerIndex = $A0			;stores index of hammer that is currently being held (0 - not holding anything)
;Jumpman_XPos = $48				;maybe this one is actually the true one, but IDK
;Jumpman_XPos = $A1
Jumpman_JumpSpeed = $043E			;how high jumpman goes when jumping. (every X pixels)

Jumpman_WalkFlag = $9B				;if set, move the player and animate (move every other frame)
Jumpman_AirMoveFlag = $9E			;if set, move player horizontally when jumping (update every other frame)

Hammer_CanGrabFlag = $0451			;2 bytes. If set, it can be interacted with and when grabbed, set to 0.
Hammer_JumpmanFrame = $9F			;graphical frame index when jumpman's swinging the hammer
Hammer_DestroyingEnemy = $BF			;flag that deternimes whether we're destoying a hazard with a hammer. also acts as graphical index for destruction.

;$0500 - Unused

Cursor_YPosition = $0511

Demo_Active = $58				;demo is active flag.
Demo_InitFlag = $050B				;true - has been initialized, false - do init
Demo_InputTimer = $050C				;how long input/command will last
Demo_Input = $050D				;what input (button/command) is processed
Demo_InputIndex = $050E				;index of current input

Pause_HeldPressed = $0514			;this address reacts to pause being pressed/held but can also hold directional inputs (as long as pause is held). used to prevent pause switching every frame when pause is held.
Pause_Flag = $0516				;flag to indicate if game is paused
Pause_Timer = $0517				;timer for pausing and unpausing

;Sound addressess
Sound_MusicDataPointer = $F7			;2 bytes, indirect addressing
Sound_Music = $FC
Sound_MusicPauseBackup = $0F			;used for pausing to disable music but keep it safe ($FC)
Sound_MusicHammerBackup = $0519			;used to save music value that played before picking up a hammer
Sound_Fanfare = $FD				;holds value for various jingles and sound effects, like title screen theme, score, pause and etc.
Sound_Effect = $FE
Sound_Effect2 = $FF

;OAM base ram addresses
OAM_Y = $0200
OAM_Tile = $0201
OAM_Prop = $0202
OAM_X = $0203

;OAM addresses for various objects
;use X_OAM_Slot to change RAM addresses for these, where X is a thing the OAM slot is being assigned to (e.g. Jumpman_OAM_Slot)

Cursor_OAM_Y = OAM_Y+(4*Cursor_OAM_Slot)
Cursor_OAM_Tile = OAM_Tile+(4*Cursor_OAM_Slot)
Cursor_OAM_Prop = OAM_Prop+(4*Cursor_OAM_Slot)
Cursor_OAM_X = OAM_X+(4*Cursor_OAM_Slot)

;NOTE: OAM Y and X positions are often used as real X and Y pos for checks and stuff, sometimes stored in other addresses, but those are basically main addresses

Jumpman_OAM_Y = OAM_Y+(4*Jumpman_OAM_Slot)
Jumpman_OAM_Tile = OAM_Tile+(4*Jumpman_OAM_Slot)
Jumpman_OAM_Prop = OAM_Prop+(4*Jumpman_OAM_Slot)
Jumpman_OAM_X = OAM_X+(4*Jumpman_OAM_Slot)

Score_OAM_Y = OAM_Y+(4*Score_OAM_Slot)
Score_OAM_Tile = OAM_Tile+(4*Score_OAM_Slot)
;prop isn't used
Score_OAM_X = OAM_X+(4*Score_OAM_Slot)

Hammers_OAM_Y = OAM_Y+(4*Hammer_OAM_Slot)
Hammers_OAM_Tile = OAM_Tile+(4*Hammer_OAM_Slot)
Hammers_OAM_Prop = OAM_Prop+(4*Hammer_OAM_Slot)
Hammers_OAM_X = OAM_X+(4*Hammer_OAM_Slot)

BufferOffset = $0330				;used to offset buffer position
BufferAddr = $0331				;buffer for tile updates (62 bytes)

;RAM addresses that are "used" but do nothing.
Unused_0513 = $0513				;similar address is used in Donkey Kong Jr. NES port.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;NES Hardware Registers

ControlBits = $2000
RenderBits = $2001
HardwareStatus = $2002
OAMAddress = $2003

CameraPositionReg = $2005
VRAMDrawPosReg = $2006				;first two writes set VRAM position to start drawing at
DrawRegister = $2007				;used to draw tiles, change palettes and attributes

OAMDMA = $4014					;upload $100 bytes

APU_SoundChannels = $4015			;needs confirmation though.
ControllerReg = $4016				;$4016 - First controller, $4017 - Second controller

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Constant defines

;VRAM Write routine values, used as commands
VRAMWriteCommand_Repeat = $40   		;bit 6 will make repeat writes of one value
VRAMWriteCommand_DrawVert = $80			;bit 7 - change drawing from horizontal line to vertical
VRAMWriteCommand_Stop = $00     		;command to stop VRAM write and return from routine.

;Various background tile defines
Tile_Empty = $24				;standart empty tile (transperant).
Tile_Roman_I = $66				;\a pair or roman numbers used as player number
Tile_Roman_II = $67				;/for "PLAYER X" screen and status bar

;various VRAM tile locations
VRAMLoc_LivesCount = $20B5

;controller input constants
Input_A = $80
Input_Select = $20
Input_Start = $10
Input_Up = $08
Input_Down = $04
Input_Left = $02
Input_Right = $01
Input_AllDirectional = Input_Up|Input_Down|Input_Right|Input_Left

;Demo mode only, used for jumping (doesn't use controller input)
Demo_JumpCommand = $05
Demo_NoInput = $00

;Jumpman state values
Jumpman_State_Grounded = $01
Jumpman_State_Climbing = $02
Jumpman_State_Jumping = $04
Jumpman_State_Falling = $08
Jumpman_State_Hammer = $0A
Jumpman_State_Dead = $FF

;Barrel state values
Barrel_Initialized = $80

;Phase values. Technically speaking title screen is $00 but it's not checked, so...
Phase_25M = $01
;50M is not present, so $02 isn't used
Phase_75M = $03
Phase_100M = $04

Players_1Player = $18
Players_2Players = $1C

;$FC
Sound_Music_Silence = $00
Sound_Music_25M = $02
;$01, $04 and $08 are duplicates of 25M
Sound_Music_100M = $10
Sound_Music_HurryUp = $20
Sound_Music_Hammer = $40
;$80 is a hammer theme with 3 repeating sounds at the beginning (unused)

;$FD
Sound_Fanfare_GameStart = $01			;when pressing start at the title screen
Sound_Fanfare_PhaseComplete = $02
Sound_Fanfare_KongDefeated = $04		;plays after kong is defeated after which phase 1 begins
Sound_Fanfare_PhaseStart = $08
Sound_Fanfare_KongFalling = $10			;before kong actually falls when defeated this is played
Sound_Fanfare_Score = $20			;anything that gives score plays this e.g. collecting item
Sound_Fanfare_GamePause = $40
Sound_Fanfare_TitleScreenTheme = $80

;$FE
Sound_Effect_SpringFall = $01			;\only can play in phase 2 (75M) (or during pause via hacking)
Sound_Effect_SpringBounce = $02			;/
;Bits 2-6 are unused
Sound_Effect_Hit = $80				;donkey kong chest hit sound and plays when dying

;$FF
Sound_Effect2_Dead = $01
Sound_Effect2_EnemyDestruct = $02
Sound_Effect2_Jump = $04
Sound_Effect2_Movement = $08
;other bits are unused

;Various OAM-related defines. OAM slots are in decimal (from 0 to 63).
Cursor_OAM_Slot = 0				;for title screen
Cursor_Tile = $A2
Cursor_XPos = $38
Cursor_Prop = $00

Jumpman_OAM_Slot = 0

;Jumpman graphic frames
Jumpman_GFXFrame_Walk2 = $00
Jumpman_GFXFrame_Stand = $04
Jumpman_GFXFrame_Walk1 = $08
Jumpman_GFXFrame_Jumping = $28
Jumpman_GFXFrame_Landing = $2C

Jumpman_GFXFrame_Walk2_HammerUp = $0C
Jumpman_GFXFrame_Walk2_HammerDown = $10
Jumpman_GFXFrame_Stand_HammerUp = $14
Jumpman_GFXFrame_Stand_HammerDown = $18
Jumpman_GFXFrame_Walk1_HammerUp = $1C
Jumpman_GFXFrame_Walk1_HammerDown = $20

Score_OAM_Slot = 48
Score_OneTile = $D0				;score sprite tile for 1 (for 100 points)
Score_ThreeTile = $D1				;score sprite tile for 3 (for 300 points) (unused)
Score_FiveTile = $D2				;score sprite tile for 5 (for 500 points)
Score_EightTile = $D3				;score sprite tile for 8 (for 800 points)
Score_TwoZeroTile = $D4				;00 tile

Hammer_OAM_Slot = 52				;one hammer takes 2 slots
Hammer_GFXFrame_HammerUp = $F6			;2 tiles, F6 and F7
Hammer_GFXFrame_HammerDown = $FA		;same as above

;version defines, don't touch
JP = 0
US = 1
Gamecube = 2