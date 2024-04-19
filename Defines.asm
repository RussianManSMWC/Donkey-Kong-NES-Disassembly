;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;local RAM addresses
;some of this comes from Data Crystal. Thanks!
;(to-do: split into addresses and constants?)

;$00-$0C - common scratch ram for various purposes
;Most common uses of the scratch RAM. other specific uses are local
TEMP_EntityXPosition = $00
TEMP_EntityYPosition = $01
TEMP_EntityOAMTile = $02			;first tile from which it'll draw the rest
TEMP_EntityOAMProp = $02			;a far less common use
TEMP_EntityGFXSize = $03			;low nibble - amount of tiles on the same row, high nibble - amount of rows placed on top of each other
TEMP_EntityOAMSlot = $04

;$0D-0E - Unused
;$0F - used for multiple purposes, listed below
Sound_MusicPauseBackup = $0F			;used for pausing to disable music but keep it safe ($FC)
;add more... maybe

ControlMirror = $10				;mirror of ControlBits
RenderMirror = $11				;mirror of RenderBits
CameraPositionX = $12				;X-position value of CameraPositionReg (first write)
CameraPositionY = $13				;Y-position value of CameraPositionReg (second write)

ControllerInput = $14				;base adress for both controllers (indexed)
ControllerInput_Previous = $15			;same as above but for presses

ControllerInput_Player1 = $14			;buttons held by player 1
ControllerInput_Player1Previous = $15		;holds initial input that won't change if holding additional buttons beside one saved in this address.

ControllerInput_Player2 = $16			;\same for player 2
ControllerInput_Player2Previous = $17		;/

RNG_Value = $18					;8 bytes (18-1F). Some of these aren't used.

Score_InvertOperandFlag = $20			;alternates every 4 bytes for each counter, when there's an overflow/underflow, the operation (addition or substraction) will be reverted to prevent that (not entirely sure how it works though)
ScoreDisplay_Top = $21				;\3 bytes, decimal (21-23).
ScoreDisplay_Player1 = $25			;|(25-27)
ScoreDisplay_Player2 = $29			;/(29-2B)
ScoreDisplay_Bonus = $2E			;2 bytes, decimal, also acts as timer
ScoreDisplay_Counter = ScoreDisplay_Player1	;general score address used with an offset, can be both either player one or two score or a bonus score

;$30-$33 - unused

Timer_Timing = $34				;used to decrease other timers, probably has other uses
;Timer_KongAnimation = $34			;
Timer_Global = $35				;16 bytes ($35-$45), specific timers listed below. $35-$3D decrease every frame, the rest decreases every 10 frames
Timer_EntitySpawn = $36				;timer for donkey kong to spawn an entity (barrel or springboard)
Timer_BarrelHold = $37
Timer_FlameAnimation = $38			;used for oil flame in phase 1
Timer_PaulineAnimation = $39			;used for pauline animation, when zero, start animation
Timer_PhaseEndTimer = $3A			;either win or lose
Timer_FlameEnemyMoveDirUpdate = $3B		;used to update flame enemy's movement direction to move where the player is at (or was when it decided to move that way)

;$3C-$3E - unused

Timer_Hammer = $3F				;timer for hammer power
Timer_FlameEnemySpawn = $40
Timer_Score = $41				;2 bytes, show score sprites for a little bit
;$42 - unused
Timer_Transition = $43				;common timer used for changing game states, like game over, phase init, etc. (sorta timer though it's strangely handled)
Timer_ForVertBarrelToss = $43			;another use for this timer is in 25M, when it runs out, the kong can throw a vertical barrel again
Timer_Demo = $44				;timer that ticks at the title screen, when 0 demo gameplay starts. (TO-DO: used for something else as well?)
Timer_KongAnimation = $44			;
Timer_BonusScoreDecrease = $45			;timer that decreases bonus score by 100.

;hitbox shenanigans
HitboxA_XPos_Left = $46
HitboxA_YPos_Top = $47
HitboxA_XPos_Right = $48			;after adding width
HitboxA_YPos_Bottom = $49			;after adding height

HitboxB_XPos_Left = $4A
HitboxB_YPos_Top = $4B
HitboxB_XPos_Right = $4C			;after adding width
HitboxB_YPos_Bottom = $4D			;after adding height

TitleScreen_Flag = $4E				;if we're on title screen (also counts as game over flag)

GameControlFlag = $4F				;if set to 0, freeze gameplay
GameMode = $50					;bit 0 - Game A or B, if any of the remaining bits are set, will enable 2 player game

Players = $51					;$18 - 1 player, $1C - 2 players
Players_CurrentPlayer = $52			;who's currently in play

PhaseNo = $53

LoopCount = $54
Jumpman_Lives = $55

;hold directional inputs
Direction = $56					;saves directional input
Direction_Horz = $57				;only saves left and right directional inputs

Demo_Active = $58				;demo is active flag.
Jumpman_CurrentPlatformIndex = $59		;how high player is by platform. 1st platform is the lowest and etc.
Jumpman_OnPlatformFlag = $5A			;set when jumpman's standing on the platform. reset when in air or climbing a ladder
Jumpman_ClimbOnPlatAnimCounter = $5B		;this is counted when climbing on top of the platform from ladder/climbing down the ladder from the platform
Jumpman_ClimbAnimCounter = $5C			;counted when climbing a ladder. used to animate climbing 

Entity_TimingIndex = $5D

;maybe not barrel-specific vvv (for springboard as well?)
Barrel_CurrentIndex = $5D
Barrel_State = $5E				;each barrel table is 9 bytes long
Barrel_CurrentPlatformIndex = $68		;works the same way as Jumpman_CurrentPlatformIndex but for barrels
Barrel_GFXFrame = $72
Barrel_ShiftDownFlag = $7D			;if set, move barrel's y-pos by 1 pixel for shifted platforms

EntitiesPerPlatform = $7E			;7 bytes. counts the amount of entities on any given platform (except the last one). entities counted are barrels, Jumpman, and if he holds a hammer, that also counts as one (this is only used in 25M).
						;however, since the platform index always starts from 1, the first byte is technically "unused" - it's always defaulted to 0

Jumpman_AlternateWalkAnimFlag = $85		;this is used to alternate walking frames. if 0, show Jumpman_GFXFrame_Walk1, if not 0, show Jumpman_GFXFrame_Walk2
Platform_ShiftIndex = $86			;used in phase 1 to determine on which shifted platform (elevated bit or what have you) jumpman's standing on (otherwise used as scratch ram in a few routines).
;$87 - unused
Jumpman_TimingCounter = $88
;$89 - unused
Entity_TimingCounter = $8A			;count which bit to check for the timing (CODE_DFE8)

Jumpman_JumpedFlag = $94			;set to 1 when player has jumped to play a sound effect and stuff once
Jumpman_LandingFrameCounter = $94		;yes, the above also acts as this. when the player lands, this frame ticks to specific point to display landing frame, after which jumpman's fate is decided
Jumpman_JumpYPos = $95				;this is y-position stored for when the player jumps, if the player ends up much lower than this position, they die upon landing. this is set to FF when they player is set to die that way
Jumpman_State = $96				;$01 - grounded, $02 - on ladder, $04 - Jumping, $08 - Falling, $0A - Has a hammer, $FF - Dead
Jumpman_GFXFrame = $97				;contains top-left sprite tile value, remaining sprite tiles get +1 to this value each (used for walking)
Jumpman_Death_FlipTimer = $98			;timer for flipping death animation. when set to FF, show actual death frame. Increases every time a full 360 loop is made

FlameEnemy_MoveDirection = $99			;1 byte, stores movement direction (also used for drawing for said movement instead of sprite table above) 0 - move right, 1 - move left.

Phase_CompleteFlag = $9A			;sometimes set and reset immedeatly when completing phase but phase 3. stops normal gameplay functions just like GameControlFlag
Jumpman_WalkFlag = $9B				;if set, move the player and animate (move every other frame)

Hitboxes_XDistance = $9C			;calculated horizontal distance between two hitboxes
Hitboxes_YDistance = $9D			;calculated vertical distance between two hitboxes, notably used for jumpman jumping over a barrel and awarding points

Jumpman_AirMoveFlag = $9E			;if set, move player horizontally when jumping (update every other frame)

Hammer_JumpmanFrame = $9F			;graphical frame index when jumpman's swinging the hammer
Jumpman_HeldHammerIndex = $A0			;stores index of hammer that is currently being held (0 - not holding anything)
Jumpman_CurrentLadderXPos = $A1			;X-position of the ladder the jumpman's currently climbing
Hammer_AnimationFrameCounter = $A2		;works on a bitwise basis, when it's at 0, Jumpman and hammer will update the appearance

Barrel_LadderYDestination = $A3			;when goes down the ladder checks for this value to see where the ladder ends and it should start moving like normal again

Flame_State = $AD				;oil flame state. 0 - non-existant, 1 - init, 2 - animate, 3 - ???

FlameEnemy_CurrentIndex = $AE			;
FlameEnemy_State = $AF				;actual enemies
FlameEnemy_Direction = $B3			;surprizingly underutilized, only used when standing in place (direction is also FlameEnemy_State)

Pauline_AnimationCount = $B7			;used to change graphic frame, counts untill specified value after which stops animating for a bit
Pauline_TimingCounter = $B8
FlameEnemy_LadderBoundary = $B9			;each flame enemy reserves a pair of bytes - first one stores the Y-position of the upper ladder boundary (where the flame stops climbing, potentially to be prevented from climbing too high), and the second is the ladder's bottom boundary

Jumpman_ActingFlag = $BE			;set when Jumpman is performing some action (movement, dying, etc.). This is only used to check if Jumpman can pick up bonus items/activate bolts (probably for performace reasons).
Hammer_DestroyingEnemy = $BF			;acts as a flag and animation counter for enemy destruction.

;$C0 - barrel related?
Barrel_EscapeYDestination = $C0			;When jumpman is holding a hammer, one of the barrels can move down a platform to escape, this is used to set it's Y-destination
Bolt_RemovedFlag = $C1				;7 bytes, a flag indicating that a bolt has been removed
Item_RemovedFlag = $C9				;2 bytes, a flag indicating that an umbrella/a handbag has been removed
EraseBuffer = $CC				;5 bytes, a temporary buffer used to store into actual buffer, used for handbag, bolt and umbrella removal

;$D1 - unused

MovingPlatform_CurrentIndex = $D2

FlameEnemy_DontFollowFlag = $D2			;25M and 100M only, if set don't follow the player (but it depends on difficulty) (rename? it doesn't "chase", just updates its movement direction to be towards where the player is)

;$D6-$D7 - unused
MovingPlatform_Upward_RespawnFlag = $D8
MovingPlatform_Downward_RespawnFlag = $D9
Jumpman_StandingOnMovingPlatformValue = $DA	;0 - not standing on a moving platform, 1 - standing on a platform that moves up, 2 - standing on a platform that moves down

FlameEnemy_LadderEndYPos = $DB
FlameEnemy_CurrentPlatformIndex = $E0		;same as Jumpman_CurrentPlatformIndex but for flame enemies
FlameEnemy_TimingCounter = $E4			;similar to Entity_TimingCounter, but specifically for flame boys

;$E8 - fire enemy-related (timer of sorts?)
FlameEnemy_LadderRestTime = $E8			;used for ladder movement, to make it move every few frames

;EC - flame enemy...
FlameEnemy_FollowDirection = $EC		;used to deternmine its movement direction when it randomly decides to chase the player

Sound_Effect2_Current = $F0			;sound effect2 that is currently playing
Sound_Effect2_Length = $F1			;ticks down and controls the square's sweep bits
Sound_Square_Frequency = $F2			;for PlayerDead, this acts as an index for frequencies, rather than an actual frequency value
Sound_Square_SweepIndex = $F2			;used by Jump SFX
Sound_FanfareSquare2TrackOffset = $F3
;$F4 - unused
Sound_Effect_Length = $F5			;\these are used for Sound_Effect (utilize triangle channel)
Sound_Triangle_Frequency = $F6			;/

Sound_MusicDataPointer = $F5			;2 bytes, for music
Sound_SoundDataPointer = $F7			;2 bytes, indirect addressing (for fanfares)

Sound_FanfareTriangleTrackOffset = $F9		;for fanfares that use triangle (00 - no triangle)
Sound_FanfareSquareTrackOffset = $FA		;for fanfares that use square (00 - no square)
Sound_CurrentFanfareID = $FB			;bit index (e.g. bit 3 set = $03)
Sound_Music = $FC				;simple beeps and boops to accompany you during gameplay (or not).
Sound_Fanfare = $FD				;holds value for various jingles and sound effects, like title screen theme, score, pause and etc.
Sound_Effect = $FE
Sound_Effect2 = $FF
Sound_FanfarePlayFlag = $0102			;this is used to continue playing music (may also affect other sound effects, or specifically sound channels)

BufferOffset = $0330				;used to offset buffer position
BufferAddr = $0331				;buffer for tile updates (62 bytes)

PhaseNo_PerPlayer = $0400			;2 bytes, phase for each player
LoopCount_PerPlayer = $0402			;2 bytes, contains loop count for each player
Jumpman_Lives_PerPlayer = $0404			;again 2 bytes, lives for each player
GameOverFlag_PerPlayer = $0406			;it's TitleScreen_Flag per player but used as a game over (which that flag technically is)
ReceivedLife_Flag = $0408			;2 bytes, one for each player. if true, don't give player extra lives anymore.

LostALifeFlag = $040B				;should be pretty self explanatory, set when lost a life to decrease a life counter

Barrel_AnimationTimer = $040D			;animate every certain amount of frames (see Barrel_AnimateFrames)

Barrel_VertTossHorzMovementDir = $0417		;which way to move if the movement pattern for the vertically tossed barrel is left & right. 0 - move right, 1 - move left
Barrel_VertTossPattern = $0421			;movement pattern. 01 - move straight down, 02 - unused diagonal pattern, 03 - move in a "wave" pattern
Barrel_VertTossLandingXPos = $042B		;stores barrel's x-position when it landes from the vertical toss, runs various adjustements depending on the distance between its current X-position and this original landing X-position

;these are used by jumpman and phase 2 springboards (only those use true gravity)
Entity_GravityInitFlag = $042C			;initializes downward y-speed
Jumpman_GravityInitFlag = Entity_GravityInitFlag
Springboard_GravityInitFlag = Entity_GravityInitFlag+2

Entity_SubYPos = $042D				;sub-pixel nonsense
;YPos is $01
Entity_DownwardSubSpeed = $0435
Entity_DownwardSpeed = $0436

Entity_UpwardSubSpeed = $043D			;units that are less than a full pixel (general)
Entity_UpwardSpeed = $043E

Jumpman_UpwardSubSpeed = Entity_UpwardSubSpeed
Jumpman_UpwardSpeed = Entity_UpwardSpeed	;how high jumpman goes when jumping. (X pixels)
Springboard_UpwardSubSpeed = Entity_UpwardSubSpeed+2
Springboard_UpwardSpeed = Entity_UpwardSpeed+2

;springboards from phase 3
Springboard_CurrentIndex = $0445
Springboard_SpawnedXPos = $0446			;stored to when spanwned, used to check if got far enough from the spawn point to start falling down

RemovedBoltCount = $044F

Kong_DefeatedFlag = $0450			;this flag indicates that the ending cutscene should play
Hammer_CanGrabFlag = $0451			;2 bytes. If set, it can be interacted with and when grabbed, set to 0.

;$0500-$0502 - Unused

Kong_AnimationFlag = $0503			;if set, kong will play animations, but it's always set to 1, so he always play animations.
;$0504 - unused
Score_UpdateFlag = $0505			;if set, update score display (however if bit 4 is set the score won't be updated, set when the kong is animating)
;$0506 - unused
Score_Top = $0507				;4 bytes, contains top score for game A and B, to be displayed when starting a level. doesn't take tens and ones into account.

Demo_InitFlag = $050B				;true - has been initialized, false - do init
Demo_InputTimer = $050C				;how long input/command will last
Demo_Input = $050D				;what input (button/command) is processed
Demo_InputIndex = $050E				;index of current input

;$050F - unused

TitleScreen_MainCodeFlag = $0510		;init/main flag. 0 - init, 1 - main
Cursor_YPosition = $0511
TitleScreen_SelectHeldFlag = $0512		;used to tell if select was pressed so it's not possible to switch options every frame (stays active if select is being held) (also counts up and down in gamecube version)

Pause_HeldPressed = $0514			;this address reacts to pause being pressed/held but can also hold directional inputs (as long as pause is held). used to prevent pause switching every frame when pause is held.

Kong_TossToTheSideFlag = $0515			;this is used to show the "toss the barrel to the side" frame (doesn't affect the actual tossing)

Pause_Flag = $0516				;flag to indicate if game is paused
Pause_Timer = $0517				;timer for pausing and unpausing

TitleScreen_DemoCount = $0518			;how many times the demo must play for music to start playing again on the title screen

;Sound addressess
Sound_MusicHammerBackup = $0519			;used to save music value that played before picking up a hammer

;$051A-$067F - unused

Sound_MusicTriangleTrackOffset = $0680		;or a triangle phase/state/beat, w/e you wanna call that (this is for music btw.)
;$0681-$068C - unused
Sound_NoteLengthOffset = $068D
;$068E-$0690 - unused
Sound_SquareNoteLengthSaved = $0691		;this address is used to store to Sound_SquareTimer, this can change for the next beat or stay the same for the same timing
;$0692-$0694 - unused
Sound_Square2NoteLength = $0695
Sound_SquareNoteLength = $0696
;$0697 is unused
Sound_TriangleNoteLength = $0698		;time between each triangle beat
;$0699-$06A0 - unused
Sound_Effect_Current = $06A1			;tells what Sound_Effect is currently being played
;$06A2 is unused
Sound_Music_Current = $06A3			;tells what music is currently being played
;$06A4 is unused
Sound_HitSFX_Length = $06A5			;exclusively used by Sound_Effect_Hit to distinguish it from other SFX
;$06A6-$06EF - unused
Sound_StepSFX_Frequency = $06F0
Sound_StepSFX_FrequencyMode = $06F1		;0 - frequency goes up with each step, 1 - frequency goes down with each step
;$06F2-$07FF - unused

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

PaulineHead_OAM_Y = OAM_Y+(4*PaulineHead_OAM_Slot)
PaulineHead_OAM_Tile = OAM_Tile+(4*PaulineHead_OAM_Slot)
PaulineHead_OAM_Prop = OAM_Prop+(4*PaulineHead_OAM_Slot)
PaulineHead_OAM_X = OAM_X+(4*PaulineHead_OAM_Slot)

PaulineBody_OAM_Y = OAM_Y+(4*PaulineBody_OAM_Slot)
PaulineBody_OAM_Tile = OAM_Tile+(4*PaulineBody_OAM_Slot)
PaulineBody_OAM_Prop = OAM_Prop+(4*PaulineBody_OAM_Slot)
PaulineBody_OAM_X = OAM_X+(4*PaulineBody_OAM_Slot)

PlatformSprite_OAM_Y = OAM_Y+(4*PlatformSprite_OAM_Slot)
PlatformSprite_OAM_Tile = OAM_Tile+(4*PlatformSprite_OAM_Slot)
PlatformSprite_OAM_Prop = OAM_Prop+(4*PlatformSprite_OAM_Slot)
PlatformSprite_OAM_X = OAM_X+(4*PlatformSprite_OAM_Slot)

DonkeyKong_OAM_Y = OAM_Y+(4*DonkeyKong_OAM_Slot)
DonkeyKong_OAM_X = OAM_X+(4*DonkeyKong_OAM_Slot)

;RAM addresses that are "used" but do nothing (or exclusive to unused code).
UnusedCollisionTable_0460 = $0460		;would be used in an unused routine. would contain collision-related stuff for unknown entities, it would be a dynamic table, similar to ones like DATA_C0CF, containing coordinates and collision offset for the hitbox. Last two bytes were to be set as terminators (value $FE).
						;this table would be 19 bytes in size.

Sound_ChannelsMirrorUnused = $0100		;this address isn't actually used for anything, other than being a mirror of APU_SoundChannels (being stored in but not read)
Unused_0513 = $0513				;similar address is used in Donkey Kong Jr. NES port.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;NES Hardware Registers

ControlBits = $2000
RenderBits = $2001
HardwareStatus = $2002
OAMAddress = $2003

CameraPositionReg = $2005
VRAMDrawPosReg = $2006				;first two writes set VRAM position to start drawing at (also, camera position)
DrawRegister = $2007				;used to draw tiles, change palettes and attributes (maybe rename to a more general "UpdateRegister")

;this applies to all channels (except DMC (Delta Modulation Channel))
APU_ChannelFrequency = $4002
APU_ChannelFrequencyHigh = $4003

APU_Square1DutyAndVolume = $4000		;bitwise DDLc vvvv, DD - Duty cycle (pulse width, the available values are 12.5%, 25%, 50% and 25% negated (basically the same?)), L - length counter halt (play sound indefinitely), c - constant volume/envelope (if clear, the volume goes down when the sound ends), v - volume bits, as you can imagine the higher it is, the louder it gets
APU_Square1Sweep = $4001			;makes the sound "sweep" up or down its frequency (bitwise: EPPP NSSS, E - enable sweep, PPP - the divider's period (P+1 half-frames), N - negate flag, if clear, will sweep toward lower frequency, set - sweep toward higher frequency, SSS = shift count)
APU_Square1Frequency = $4002
APU_Square1FrequencyHigh = $4003		;first 3 bits are an extension to the above frequency thing, the rest are "Length counter load" bits, how long the sound will play (if L bit from APU_Square1DutyAndVolume isn't set)

APU_Square2DutyAndVolume = $4004		;same for the second square channel
APU_Square2Sweep = $4005
APU_Square2Frequency = $4006
APU_Square2FrequencyHigh = $4007

APU_TriangleLinearCounter = $4008		;bit 7 halts linear counter for constant noise, otherwise the channel will silence itself after playing the sound, the rest of the bits are how long the sound will play, basically like length counter load bits, but more flexible? but also doesn't allow for longer timing
;$4009 is unused for triangle
APU_TriangleFrequency = $400A			;think of it like a pitch control/how "long" the triangle is. the lower value is, the higher pitch it'll be
APU_TriangleFrequencyHigh = $400B		;first 3 bits are an extension to the above "pitch" thing, the rest are how long the sound will play  (in the context of the triangle channel, this is basically redundant, as there's already timer bits at APU_TriangleLinearCounter, the channel will be silenced once either reaches 0)

APU_NoiseVolume = $400C				;--LC VVVV, L - length counter halt (play the sound indefinitely if set), c - constant volume/envelope (if clear, the volume goes down when the sound ends), V - volume
;$400D is unused for noise
APU_NoiseLoop = $400E				;bit 7 enables the loop, the bits 0 through 3 are the noise's period
APU_NoiseLength = $400F				;same length counter load bits as previous channels, if length counter halt bit is clear, the noise will play for a certain amount of time

APU_DMCFrequency = $4010
APU_DMCLoadCounter = $4011			;like a timer for how long it runs, I guess? Like linear counter for other channels.... I THINK??? QUESTION MARK????????
APU_DMCSampleAddress = $4012			;where in ROM is the sample we're playing, between $C000 to $FFFF
APU_DMCSampleLength = $4013

OAMDMA = $4014					;upload $100 bytes

APU_SoundChannels = $4015			;used to enable channels (also, if read, returns some bit stuff, but it's not relevant here)
ControllerReg = $4016				;$4016 - First controller, $4017 (read) - Second controller
APU_FrameCounter = $4017			;(write) bit 6 can enable IRQ and bit 7 changes step mode (4 or 5 step sequence for envelope/sweep/length of sound channels (except DMC)). IRQ only triggers at the end of the 4-step sequence (bit 7 must be clear).

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Constant defines

;VRAM Write routine values, used as commands
VRAMWriteCommand_Repeat = $40   		;bit 6 will make repeat writes of one value
VRAMWriteCommand_DrawVert = $80			;bit 7 - change drawing from horizontal line to vertical
VRAMWriteCommand_Stop = $00     		;command to stop VRAM write and return from routine.

;Various background tile defines
Tile_Empty = $24				;standard empty tile (transparent).
Tile_Roman_I = $66				;\a pair or roman numbers used as player number
Tile_Roman_II = $67				;/for "PLAYER X" screen and status bar

;various VRAM tile locations
VRAMLoc_LivesCount = $20B5
VRAMLoc_LoopCount = $20BC			;only low byte is loaded, need additional code if changing the high byte

;controller input constants
Input_A = $80
Input_B = $40
Input_Select = $20
Input_Start = $10
Input_Up = $08
Input_Down = $04
Input_Left = $02
Input_Right = $01
Input_AllDirectional = Input_Up|Input_Down|Input_Right|Input_Left

;score related defines
BonusScoreCounter_WhenHurryUp = $10		;how many hundreds should it hit to start playing hutty up music

Jumpman_InitLives = 3				;the amount of lives given upon starting a new game
Jumpman_JumpSubYSpeed = $58			;initial jumping speed

;Demo mode only, used for jumping (doesn't use controller input)
Demo_JumpCommand = $05
Demo_NoInput = $00

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
;$80 doesn't exist, it'll use an erroneous offset, which places it in a part of hammer theme

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
Sound_Effect_Fall = $01				;\for springboards in phase 2 and for falling DK for the ending cutscene
Sound_Effect_SpringBounce = $02			;/
;Bits 2-6 are unused
Sound_Effect_Hit = $80				;donkey kong chest hit sound and plays when dying (and when the barrel hits oil)

;$FF
Sound_Effect2_PlayerDead = $01
Sound_Effect2_EnemyDestruct = $02
Sound_Effect2_Jump = $04
Sound_Effect2_Step = $08			;when the player moves
;other bits are unused

;Various OAM-related defines. OAM slots are in decimal (from 0 to 63).
Cursor_OAM_Slot = 0				;for title screen
Cursor_Tile = $A2
Cursor_XPos = $38
Cursor_Prop = OAMProp_Palette0

Jumpman_OAM_Slot = 0

;add jumpman prop somewhere?

;Jumpman graphic frames
Jumpman_GFXFrame_Walk2 = $00
Jumpman_GFXFrame_Stand = $04
Jumpman_GFXFrame_Walk1 = $08
Jumpman_GFXFrame_Jumping = $28
Jumpman_GFXFrame_Landing = $2C

;indexes for below frames (see Jumpman_HammerWalkingAnimFrames_C1A2 table)
Hammer_JumpmanFrame_Walk2_HammerUp = $01
Hammer_JumpmanFrame_Stand_HammerUp = $02
Hammer_JumpmanFrame_Walk1_HammerUp = $03
Hammer_JumpmanFrame_Walk2_HammerDown = $04
Hammer_JumpmanFrame_Stand_HammerDown = $05
Hammer_JumpmanFrame_Walk1_HammerDown = $06

Jumpman_GFXFrame_Walk2_HammerUp = $0C
Jumpman_GFXFrame_Walk2_HammerDown = $10
Jumpman_GFXFrame_Stand_HammerUp = $14
Jumpman_GFXFrame_Stand_HammerDown = $18
Jumpman_GFXFrame_Walk1_HammerUp = $1C
Jumpman_GFXFrame_Walk1_HammerDown = $20

Jumpman_GFXFrame_Climbing = $24
Jumpman_GFXFrame_ClimbPlat_Frame1 = $60
Jumpman_GFXFrame_ClimbPlat_Frame2 = $64
Jumpman_GFXFrame_ClimbPlat_IsOn = $68		;last frame when on top of the platform
Jumpman_GFXFrame_ClimbingFlipped = $54		;this isn't actually a graphic frame, but rather a specific value ("command") that tells the game to draw Jumpman_GFXFrame_Climbing flipped horizontally.

Jumpman_GFXFrame_Dead_Up = $6C
Jumpman_GFXFrame_Dead_Dead = $7C		;you want someone dead? Really dead?

;Jumpman state values
Jumpman_State_Grounded = $01
Jumpman_State_Climbing = $02
Jumpman_State_Jumping = $04
Jumpman_State_Falling = $08
Jumpman_State_Hammer = $0A
Jumpman_State_Dead = $FF

Score_OAM_Slot = 48				;each score sprite takes 2 sprite tiles, 4 in total
Score_OneTile = $D0				;score sprite tile for 1 (for 100 points)
Score_ThreeTile = $D1				;score sprite tile for 3 (for 300 points) (unused)
Score_FiveTile = $D2				;score sprite tile for 5 (for 500 points)
Score_EightTile = $D3				;score sprite tile for 8 (for 800 points)
Score_TwoZeroTile = $D4				;00 tile

Hammer_OAM_Slot = 52				;one hammer takes 2 slots
Hammer_GFXFrame_HammerUp = $F6			;2 tiles, F6 and F7
Hammer_GFXFrame_HammerDown = $FA		;FA and FB, you get the idea

EnemyDestruction_Frame1 = $30
EnemyDestruction_Frame2 = $34
EnemyDestruction_Frame3 = $38
EnemyDestruction_Frame4 = $3C

EnemyDestruction_Prop = OAMProp_Palette2

PaulineHead_OAM_Slot = 58			;2 tiles
PaulineBody_OAM_Slot = 60			;4 tiles

PaulineHead_Tile = $D5

PaulineBody_GFXFrame_Frame1 = $D7		;\for body animation
PaulineBody_GFXFrame_Frame2 = $DB		;/

PaulineBody_XPos = $50				;her body's position. it's the same for all phases (used for animation update)
PaulineBody_YPos = $20

Barrel_OAM_Slot = 12

Barrel_AnimateFrames = $06			;if equal or more, change GFX frame

;for when the kong tosses the barrel to the side it spawns at these coordinates
Barrel_HorzTossXPos = $4D
Barrel_HorzTossYPos = $32

;when I say UpLeft I mean the little dot's position
Barrel_GFXFrame_UpLeft = $80
Barrel_GFXFrame_UpRight = $84
Barrel_GFXFrame_BottomLeft = $8C
Barrel_GFXFrame_Vertical1 = $90
Barrel_GFXFrame_Vertical2 = $94

Barrel_OAMProp = OAMProp_Palette3		;default property

;Barrel state values
Barrel_State_HorzMovement = $01
Barrel_State_GoDownLadder = $02
Barrel_State_DropOffPlatform = $08
Barrel_State_LandedOnPlatform = $10		;small bounce, then continues moving
Barrel_State_GoOffscreen = $20			;when it lands on a platform, but instead of bouncing and continuing like normal, it continues moving offscreen and disappear
Barrel_State_GoDownPanic = $40			;when jumpman is holding a hammer, one of the barrels on the same platform gets this state and just moves down to the next platform to escape the hammer
Barrel_State_Init = $80				;general init, it'll then become either vertically tossed or horizontally
Barrel_State_HorzTossInit = $81
Barrel_State_VertMovement = $C0			;
Barrel_State_VertMovementBounce = $C1		;bounced off the platform while moving down, slow down slightly
Barrel_State_HorzMovementAfterVertToss = $C2	;basically horizontal movement, but its supposed to light a barrel on fire.

;vertically tossed patterns (Barrel_State_VertMovement & Barrel_State_VertMovementBounce states)
Barrel_VertTossPattern_StraightDown = $01	;what it says on the tin
Barrel_VertTossPattern_DiagonalRight = $02	;unused, a simple down-right pattern (it ends up on the right side of the stage)
Barrel_VertTossPattern_LeftAndRight = $03	;alternates between moving right and left each time it hits a platform

PlatformSprite_OAM_Slot = 12			;6 pairs for 6 platforms
PlatformSprite_Tile = $A0
PlatformSprite_Prop = OAMProp_Palette3

;when the downward moving lift gets to this position, the BG priority bit gets reset
PlatformSprite_Downward_NoBGPriorityPoint = $50

;when at this point, the bit is set
PlatformSprite_Downward_YesBGPriorityPoint = $C8

;at this point it'll be removed
PlatformSprite_Downward_RemovePoint = $D0

;respawn a previously despawned moving platform when one of them reaches this position
PlatformSprite_Downward_RespawnPoint = $A8

;don't confuse with the above define. that one enables a flag to spawn a platform back, and this is the position at which it spawns
PlatformSprite_Downward_SpawnPoint = $48

;same variables for upward lift
PlatformSprite_Upward_NoBGPriorityPoint = $C8

PlatformSprite_Upward_YesBGPriorityPoint = $50

PlatformSprite_Upward_RemovePoint = $48

PlatformSprite_Upward_RespawnPoint = $70

PlatformSprite_Upward_SpawnPoint = $D0

;not to be confused with flame enemy! this is oil barrel flame from phase 1
Flame_OAM_Slot = 56				;2 tiles
Flame_XPos = $20
Flame_YPos = $C0
Flame_GFXFrame_Frame1 = $FC
Flame_GFXFrame_Frame2 = $FE

Heart_OAM_Slot = 44
Heart_OAM_Tile = $C8

FlameEnemy_OAM_Slot = 4

FlameEnemy_GFXFrame_Frame1 = $98
FlameEnemy_GFXFrame_Frame2 = $9C

;a different enemy (well, at least in appearance) seen in 100M phase
FlameEnemy100M_GFXFrame_Frame1 = $A8
FlameEnemy100M_GFXFrame_Frame2 = $AC

FlameEnemy_State_AnimateInPlace = $00
FlameEnemy_State_MoveRight = $01
FlameEnemy_State_MoveLeft = $02
;FlameEnemy_State_Climbing = $03
FlameEnemy_State_LadderUp = $03
FlameEnemy_State_SpawnINIT = $06		;oil barrel (25M) or just appear (100M)
FlameEnemy_State_SpawnFromOil = $08
FlameEnemy_State_GFXShiftUp = $10
FlameEnemy_State_LadderDown = $13
FlameEnemy_State_NoGFXShift = $20
FlameEnemy_State_GFXShiftDown = $FF

Spring_GFXFrame_UnPressed = $C0
Spring_GFXFrame_Pressed = $C4
Spring_Spawn_YPos = $30

;various timer constants
Time_ForDemo = $27				;how long does it take to run a demo?
Time_ForTiming = $0A				;used by Timer_Timing to count some timers that take a bit longer to tick
Time_PaulineAnim = $BB				;how long does it take to start pauline animation (ticks every frame)
Time_ForFlameAnim = $10				;oil flame animation timer
Timer_ForHammer = $4B				;

;Ending variables
Ending_Jumpman_XPos = $A0
Ending_Jumpman_YPos = $30
Ending_Heart_YPos = $20
Ending_Heart_XPos = $78

;Donkey kong variables (when he turns into a sprite for the final cutscene)
DonkeyKong_OAM_Slot = 20
DonkeyKong_OAM_FirstTile = $40			;initial tile, from which 24 subsequent tiles are used
DonkeyKong_OAM_XPos = $68			;\initial positions for when it falls down
DonkeyKong_OAM_YPos = $3E			;/

;version defines, don't touch
JP = 0
US = 1
Gamecube = 2

;easy OAM props, don't change these
OAMProp_YFlip = %10000000
OAMProp_XFlip = %01000000
OAMProp_BGPriority = %00100000				;if set, go behind background
OAMProp_Palette0 = %00000000
OAMProp_Palette1 = %00000001
OAMProp_Palette2 = %00000010
OAMProp_Palette3 = %00000011