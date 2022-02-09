
*-------------------------------------------------------
* STARTING MEMORY ADDRESS FOR THE PROGRAMME $1000
*-------------------------------------------------------
    ORG    $1000

*-------------------------------------------------------
*Literal Values
*-------------------------------------------------------

EXIT                            EQU 0        USED TO EXIT ASSEMBLY PROGRAM
CARBON_REDUCTION_OF_TREE        EQU 100
CARBON_REDUCTION_OF_SOLARPANEL  EQU 1000
CARBON_REDUCTION_OF_WINDMILL    EQU 10000

COST_OF_TREE        EQU 1000
COST_OF_SOLARPANEL  EQU 10000
COST_OF_WINDMILL    EQU 100000

*Staring the game
START:                 
    MOVE.L #1000000000, $4000   #Total Carbon in atmosphere (1,000,000,000)
    MOVE.L #0, $4100    #MEMORY LOCATION OF TREES
    MOVE.L #0, $4200    #MEMORY LOCATION OF SOLARPANELS
    MOVE.L #0, $4300    #MEMORY LOCATION OF WINDMILL
    MOVE.L #10000, $4400    #MEMORY LOCATION OF MONEY
    
*-------------------------------------------------------
*-----------------Starting the Game---------------------
*-------------------------------------------------------
GAME:
    BSR WELCOME BRANCH TO WELCOME SCREEN
    BSR CLEAR_SCREEN
    BSR GAMELOOP    BRANCH TO GAMELOOP

WELCOME:
    LEA WELCOME_PROMPT, A1 #DISPLAY TEXT
    MOVE.B #14, D0
    TRAP #15
    BSR DELAY
    RTS
    
GAMELOOP:
    BSR HUD
    BSR GAMEPLAY
    BSR CLEAR_SCREEN
    BRA UPDATE

GAMEPLAY:
    LEA BUY_A_TREE, A1
    MOVE.B #14, D0
    TRAP #15
    BSR DELAY
    
    LEA CHOICE, A1
    MOVE.B #14, D0
    TRAP #15
    
    MOVE.B #4, D0
    TRAP #15
    
    CMP #1, D1
    BNE UPDATE
    ADD D1, $4100
    RTS
    
HUD:
    MOVE.B #14, D0
    
    LEA TOTAL_CARBON, A1 #Display Total Carbon
    TRAP #15
    
    MOVE.L $4000, D1
    MOVE.B #3, D0
    TRAP #15
    
    MOVE.B #14, D0
    
    LEA TOTAL_CAPITAL, A1 #Display Total Carbon
    TRAP #15
    
    MOVE.L $4400, D1
    MOVE.B #3, D0
    TRAP #15
    
    LEA LINE_BREAK, A1
    MOVE.B #14, D0
    TRAP #15
    
    
    LEA TOTAL_TREES, A1 #Display Total trees
    TRAP #15
    
    MOVE.W $4100, D1
    MOVE.B #3, D0
    TRAP #15
    
    MOVE.B #14, D0
    *TAB
    LEA TAB, A1
    TRAP #15
    
    LEA TOTAL_SOLARPANELS, A1 #Display Total Solar Panels
    TRAP #15
    
    MOVE.W $4200, D1
    MOVE.B #3, D0
    TRAP #15
    
    MOVE.B #14, D0
    *TAB
    LEA TAB, A1
    TRAP #15
   
    LEA TOTAL_WINDMILLS, A1 #Display Total Windmills
    TRAP #15
    
    MOVE.W $4300, D1
    MOVE.B #3, D0
    TRAP #15
    
    LEA LINE_BREAK, A1
    MOVE.B #14, D0
    TRAP #15
    TRAP #15
    
    BSR DELAY
    RTS
    
UPDATE: #Fix, have update reduce carbon based on time
    LEA EXIT_GAME, A1
    MOVE.B #14, D0
    TRAP #15
    
    MOVE.B #4, D0
    TRAP #15
    
    CMP #EXIT, D1
    BNE GAMELOOP

CLEAR_SCREEN:
    MOVE.B  #11,D0
    MOVE.W  #$FF00,D1
    TRAP    #15
    
    RTS
    
DELAY:
    MOVE.W   #100,D1     ; delay in 1/100th of seconds
    MOVE.B   #23,D0
    TRAP     #15
    RTS

    SIMHALT
* Put variables and constants here
CR EQU $0D
LF EQU $0A

TAB:            DC.B $09,0
LINE_BREAK:     DC.B $0D,$0A,0
WELCOME_PROMPT: DC.B 'MISSION: STOP CLIMATE CHANGE AND SAVE THE WORLD',CR,LF,CR,LF
                DC.B 'This is UN and you have been chosen to complete an important mission to SAVE THE WORLD!',CR,LF
                DC.B 'Your mission is simple remove all the carbon from the atmosphere within the next 365 days or the world ends',CR,LF
                DC.B 'Good Luck and dont mess this up',CR,LF,CR,LF,0

BUY_A_TREE: DC.B 'Do you want to buy a tree?',CR,LF,0

CHOICE: DC.B 'Enter 1 for Yes, 0 for No',CR,LF, 0

EXIT_GAME: DC.B 'Enter 0 to end the loop!!', 0

TOTAL_TREES: DC.B 'Total trees: ', 0

TOTAL_SOLARPANELS: DC.B 'Total Solar Panels: ', 0

TOTAL_WINDMILLS: DC.B 'Total Windmills: ', 0

TOTAL_CARBON: DC.B 'Total Carbon: ', 0

TOTAL_CAPITAL: DC.B $09,$09,'Total Capital: ', 0

    END    START


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
