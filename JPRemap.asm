;macro for a few locations with the same routine and it's change.

;variable to determine distance between branch for result = 1 and result = 0 (used with Macro ReturnA)
If Version = JP
  ReturnABranchDist = 5				;take JMP into account
else
  ReturnABranchDist = 3
endif

Macro Macro_ReturnA StoringAddress,InvertFlag
If Version = JP
  LDA #$00^InvertFlag
  JMP StoreVal

  LDA #$01^InvertFlag

StoreVal:
  STA StoringAddress
  RTS
else
  LDA #$00^InvertFlag				;don't have to store at all
  RTS						;

  LDA #$01^InvertFlag				;
  RTS						;
endif
endm