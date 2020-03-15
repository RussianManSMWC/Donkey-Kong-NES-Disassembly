;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;local RAM addresses
;some of this comes from Data Crystal. Thanks!

;$00-$0C - common scratch ram for various purposes
;$0D-0E - Unused

ControlMirror = $10				;mirror of ControlBits
RenderMirror = $11				;mirror of RenderBits
CameraPositionY = $12				;Y-position value of CameraPositionReg (first write)
CameraPositionX = $13				;X-position value of CameraPositionReg (second write)

ControllerInput_Player1 = $14			;buttons held by player 1
ControllerInput_Player1Previous = $15		;holds initial input that won't change if holding additional buttons beside one saved in this address.

ControllerInput_Player2 = $16			;\same for player 2
ControllerInput_Player2Previous = $17		;/

RNG_Value = $18					;8 bytes (18-1F)

ScoreDisplay_Top = $21				;\3 bytes, decimal (21-23)
ScoreDisplay_Player1 = $25			;|(25-27)
ScoreDisplay_Player2 = $29			;/(29-2B)
ScoreDisplay_Bonus = $2E			;2 bytes, decimal, also acts as timer

Players = $51					;$18 - 1 player, $1C - 2 players
Players_CurrentPlayer = $52			;who's currently in play

Timer_Timing = $34				;used to decrease other timers, probably has other uses
Timer_Global = $35				;16 bytes ($35-$45), specific timers listed below. $35-$3D decrease every frame, the rest decreases every 10 frames
;Timer_KongAnimation = $34			;
Timer_Hammer = $3F				;timer for hammer power
Timer_Transition = $43				;common timer used for changing game states, like game over, phase init, etc. (sorta timer though it's strangely handled)
Timer_Demo = $44				;timer that ticks at the title screen, when 0 demo gameplay starts.
Timer_BonusScoreDecrease = $45			;timer that decreases bonus score by 100.

TitleScreen_Flag = $4E				;if we're on title screen
TitleScreen_MainCodeFlag = $0510		;init/main flag. 0 - init, 1 - main

;related with platforms
Platform_HeightIndex = $59			;how high player is by platform. 1st platform is the lowest and etc.
Platform_ShiftIndex = $86			;used in phase 1 to determine on which shifted platform jumpman's standing.
Jumpman_OnPlatformFlag = $5A			;set when jumpman's standing on the platform. reset when in air or climbing a ladder

PhaseNo = $53

GameControlFlag = $4F				;

Kong_DefeatedFlag = $9A				;sometimes set and reset immideatly when completing phase but phase 3. stops normal gameplay functions just like GameControlFlag
Kong_AnimationFlag = $0503			;if set, kong will play animations, but it's always set to 1, so he always play animations.

;hold directional inputs
Direction = $56					;saves directional input
Direction_Horz = $57				;only saves left and right directional inputs

;Player character addressses
Jumpman_Lives = $55
Jumpman_State = $96				;$01 - grounded, $02 - on ladder, $04 - Jumping, $08 - Falling, $0A - Has a hammer, $FF - Dead
;Jumpman_XPos = $48				;maybe this one is actually the true one, but IDK
;Jumpman_XPos = $A1
Jumpman_JumpSpeed = $043E			;how high jumpman goes when jumping. (every X pixels)
Hammer_OnScreenFlag = $0451			;2 bytes. If set, it's on screen and can be picked up, if not it has been picked up already.
Hammer_JumpmanFrame = $9F			;graphical frame index when jumpman's swinging the hammer
Hammer_DestroyingEnemy = $BF			;flag that deternimes whether we're destoying a hazard with a hammer. also acts as graphical index for destruction.

;$0500 - Unused

Demo_Active = $58				;demo is active flag.
Demo_InitFlag = $050B				;true - has been initialized, false - do init
Demo_InputTimer = $050C				;how long input/command will last
Demo_Input = $050D				;what input (button/command) is processed
Demo_InputIndex = $050E				;index of current input

Cursor_YPosition = $0511

Pause_Flag = $0516				;flag to indicate if game is paused
Pause_Timer = $0517				;timer for pausing and unpausing

Sound_MusicDataPointer = $F7			;2 bytes, indirect addressing
Sound_Music = $FC
Sound_MusicPauseBackup = $0F			;used for pausing to disable music but keep it safe ($FC)
Sound_MusicHammerBackup = $0519			;used to save music value that played before picking up a hammer
Sound_Fanfare = $FD				;holds value for various jingles and sound effects, like title screen theme, score, pause and etc.
Sound_Effect = $FE
Sound_Effect2 = $FF

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

ControllerReg = $4016				;$4016 - First controller, $4017 - Second controller

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Constant defines

;VRAM Write routine values, used as commands
VRAMWriteCommand_Repeat = $40   		;bit 6 will make repeat writes of one value
VRAMWriteCommand_DrawVert = $80			;bit 7 - change drawing from horizontal line to vertical
VRAMWriteCommand_Stop = $00     		;command to stop VRAM write and return from routine.

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
Jumpman_State_Jumping = $04
Jumpman_State_Falling = $08
Jumpman_State_Hammer = $0A
Jumpman_State_Dead = $FF

;Phase values. Technically speaking title screen is $00 but it's not checked, so...
Phase_25M = $01
;50M is not present, so $02 isn't used
Phase_75M = $03
Phase_100M = $04

Players_1Player = $18
Players_2Players = $1C

;$FC
Sound_Music_Silence = $00
Sound_Music_25M = $01
;$02, $04 and $08 are duplicates of 25M
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
Sound_Effect_DonkeyKongHit = $80		;chest hit sound

;$FF
Sound_Effect2_Dead = $01
Sound_Effect2_EnemyDestruct = $02
Sound_Effect2_Jump = $04
Sound_Effect2_Movement = $08
;other bits are unused

;version defines, don't touch
JP = 0
US = 1
Gamecube = 2