
*-------------------------------------------------------
* STARTING MEMORY ADDRESS FOR THE PROGRAMME $1000
*-------------------------------------------------------
    ORG    $1000

*-------------------------------------------------------
*Literal Values
*-------------------------------------------------------

EXIT                            EQU 0        USED TO EXIT ASSEMBLY PROGRAM
CARBON_REDUCTION_OF_TREE        EQU 1000
CARBON_REDUCTION_OF_SOLARPANEL  EQU 10000
CARBON_REDUCTION_OF_WINDMILL    EQU 100000

*Staring the game
START:                 
    MOVE.L #1000000000, $4000   #Total Carbon in atmosphere (1,000,000,000)
    MOVE.L #0, $4100    #MEMORY LOCATION OF TREES
    MOVE.L #0, $4200    #MEMORY LOCATION OF SOLARPANELS
    MOVE.L #0, $4300    #MEMORY LOCATION OF WINDMILL
    
*-------------------------------------------------------
*-----------------Starting the Game---------------------
*-------------------------------------------------------
GAME:
    BSR WELCOME BRANCH TO WELCOME SCREEN
    BSR CLEAR_SCREEN
    BSR GAMELOOP    BRANCH TO GAMELOOP
    RTS

WELCOME:
    LEA WELCOME_PROMPT, A1 #DISPLAY TEXT
    MOVE.B #14, D0
    TRAP #15
    BSR DELAY
    RTS
GAMELOOP:
    BRA LOOP
    
    SIMHALT
LOOP:
    LEA CHOICE, A1
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
    MOVE.W   #500,D1     ; delay in 1/100th of seconds
    MOVE.B   #23,D0
    TRAP     #15
    RTS
    
* Put variables and constants here
CR EQU $0D
LF EQU $0A
WELCOME_PROMPT: DC.B 'MISSION: STOP CLIMATE CHANGE AND SAVE THE WORLD',CR,LF,CR,LF
                DC.B 'This is UN and you have been chosen to complete an important mission to SAVE THE WORLD!',CR,LF
                DC.B 'Your mission is simple remove all the carbon from the atmospher within the next 365 days or the world ends',CR,LF
                DC.B 'Good Luck and dont mess this up',CR,LF,CR,LF,0

CHOICE: DC.B 'Enter 0 to end the loop!!', 0

    END    START


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
