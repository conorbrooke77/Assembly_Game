
*-------------------------------------------------------
* STARTING MEMORY ADDRESS FOR THE PROGRAMME $1000
*-------------------------------------------------------
    ORG    $1000

*-------------------------------------------------------
*Literal Values
*-------------------------------------------------------

EXIT                            EQU 0        #USED TO EXIT ASSEMBLY PROGRAM
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
    *BSR ENTER_NAME_SCREEN  #Asks User for name
    *BSR GAME_LOAD_SCREEN_SR #Loads the games name in Ascii art
    *#BSR WELCOME BRANCH TO WELCOME SCREEN
    *#BSR CLEAR_SCREEN
    BSR GAMELOOP    BRANCH TO GAMELOOP

ENTER_NAME_SCREEN:
    LEA ENTER_USERNAME, A1
    MOVE.B #14, D0 
    TRAP #15
    
    MOVE.B #4, D0 #Asks the user for their name as input
    TRAP #15
    
    BSR CLEAR_SCREEN
    RTS
    
GAME_LOAD_SCREEN_SR:
    LEA GAME_LOAD_SCREEN, A1    #Loads the Ascii Art
    MOVE.B #14, D0
    TRAP #15
    
    MOVE.W   #500,D1     ; delay in 1/100th of seconds
    MOVE.B   #23,D0 #Uses a wait timer to delay the loading of text
    TRAP     #15
    
    BSR CLEAR_SCREEN
    RTS
    
WELCOME:
    LEA UN_LOGO, A1 #Loads the UN logo
    MOVE.B #14, D0
    TRAP #15
    
    LEA WELCOME_PROMPT, A1 #DISPLAY TEXT
    MOVE.B #14, D0
    TRAP #15
    
    MOVE.W   #1100,D1     ; delay in 1/100th of seconds
    MOVE.B   #23,D0
    TRAP     #15
    
    RTS
    
    
*-------------------------------------------------------
*-----------------THE GAME LOOP---------------------
*-------------------------------------------------------

GAMELOOP:
    BSR HUD #Displays the HUD AFTER EVERY LOOP
    BSR SHOP #ALLOWS THE USER TO MAKE PURCHASES
    BSR CLEAR_SCREEN #CLEARS THE SCREEN 
    BRA UPDATE

SHOP:
    
    LEA BUY_A_TREE, A1
    MOVE.B #14, D0
    TRAP #15
    
    MOVE.W   #100,D1     ; delay in 1/100th of seconds
    MOVE.B   #23,D0
    TRAP     #15
    
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
    LEA LINE_BREAK, A1
    MOVE.B #14, D0
    TRAP #15
    TRAP #15
    
    LEA TOTAL_CARBON, A1 #Display Total Carbon
    TRAP #15
    
    MOVE.L $4000, D1
    MOVE.B #3, D0
    TRAP #15
    
    MOVE.B #14, D0
    
    LEA TOTAL_CAPITAL, A1 #Display Total Capital
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
    
    LEA TOTAL_SOLARPANELS, A1 #Display Total Solar Panels
    TRAP #15
    
    MOVE.W $4200, D1
    MOVE.B #3, D0
    TRAP #15
    
    MOVE.B #14, D0
   
    LEA TOTAL_WINDMILLS, A1 #Display Total Windmills
    TRAP #15
    
    MOVE.W $4300, D1
    MOVE.B #3, D0
    TRAP #15
    
    LEA FOREST, A1
    MOVE.B #14, D0
    TRAP #15
    
    LEA LINE_BREAK, A1
    MOVE.B #14, D0
    TRAP #15
    TRAP #15
    
    MOVE.W   #100,D1     ; delay in 1/100th of seconds
    MOVE.B   #23,D0
    TRAP     #15
    RTS
    
UPDATE: 
    LEA EXIT_GAME, A1
    MOVE.B #14, D0
    TRAP #15
    
    MOVE.B #4, D0
    TRAP #15
    
    BSR CLEAR_SCREEN
    CMP #EXIT, D1
    BNE GAMELOOP

CLEAR_SCREEN:
    MOVE.B  #11,D0
    MOVE.W  #$FF00,D1
    TRAP    #15
    
    RTS
    
    SIMHALT
* Put variables and constants here
CR EQU $0D
LF EQU $0A

GAME_LOAD_SCREEN:   DC.B   $0D,$0A,$0D,$0A,$0D,$0A,$0D,$0A     
                    DC.B '        88b  d88. d888888b .d8888. .d8888. d888888b  .d88b.  d8b   db',$0D,$0A  
                    DC.B '        88 YbdP 88    88   88   YP  88  YP     88   .8P  Y8. 888o  88',$0D,$0A        
                    DC.B '        88  88  88    88    `8bo.   `8bo.      88    88    88 88V8o 88',$0D,$0A   
                    DC.B '        88  88  88    88      `Y8b.   `Y8b.    88    88    88 88 V8o88',$0D,$0A     
                    DC.B '        88  88  88   .88.   db   8D db   8D   .88.    8b  d8  88  V888',$0D,$0A  
                    DC.B '        YP  YP  YP Y888888P `8888Y   8888Y  Y888888P   Y88P   VP   V8P',$0D,$0A 
                    DC.B   $0D,$0A     
                    DC.B   $0D,$0A    
                    DC.B '        .o88b. db      d888888b .88b  d88.  .d8b.  d888888b d88888b',$0D,$0A  
                    DC.B '       d8P  Y8 88          88   88 YbdP 88 d8   8b  ~~88~~  88',$0D,$0A  
                    DC.B '        8P      88         88   88  88  88 88ooo88    88    88ooooo ',$0D,$0A  
                    DC.B '        8b      88         88   88  88  88 88~~~88    88    88~~~~~ ',$0D,$0A   
                    DC.B '        Y8b  d8 88booo.   .88.  88  88  88 88   88    88    88.',$0D,$0A  
                    DC.B '         `Y88P  Y88888P Y888888 YP  YP  YP YP   YP    YP    Y88888P',$0D,$0A, 0
                    
UN_LOGO:   
                    DC.B   $0D,$0A,$0D,$0A,$0D
                    DC.B '          @@@@@@@@@@@@@@@@@@@@@@@@@@(*******@@@@@@@@@@@@@@@@@@@@@@@@@@',$0D,$0A 
                    DC.B '          @@@@@@@@@@@@&*@@@@@#*(@@@@@@@@*@@@@@@@/*(@@@@@(*%@@@@@@@@@@@',$0D,$0A 
                    DC.B '          @@@@@@@&****@@@@*#@@@@@@#***%%*/%***#@@@@@%*&@@@***#*&@@@@@@',$0D,$0A 
                    DC.B '          @@@@@**@**@*@&*@*@@&**@@@@@@@@*@@@@@/****@@/**(@@*#*/**/@@@@',$0D,$0A 
                    DC.B '          @@@*%**/**(@*@@@@**@@@@**#@@@@*@@@@/*(@****(@@@*&@***@**#*@@',$0D,$0A 
                    DC.B '          @@**/***#@&*@@@*/@@@**@@@@%*******%@@@**(@#**@@@#*@/@***@*(@',$0D,$0A 
                    DC.B '          @%**%#**%@*@@@*@@@(*@@@*&@@@@@*@@@(***@@**@@@//@@&*@**(*#**@',$0D,$0A 
                    DC.B '          @@*****@@*@@@&%@@(*@@*(*****(************@*@@@*@@@*@@%****(#',$0D,$0A 
                    DC.B '          *(%**&*@@*@*@*@@@***@*****/*(@@@*********%@(@@&#@@@*@**&**@*',$0D,$0A 
                    DC.B '          ****@**@@***********@*@@@*/*@@@@@********(@(@@&#@@@*@@**&@**',$0D,$0A 
                    DC.B '          @*****@@@*#@@*******@@(@@&**##@*********@@*@@@*@@@#*@#/****%',$0D,$0A 
                    DC.B '          *@/**/@*@@*@@@******%@@**@@@@&*/********@*@@@/(@@@*@&*@***@*',$0D,$0A 
                    DC.B '          @**@*%**@@@*@@@*/@****@@@@/********/*****@@**@@@@*@@****@***',$0D,$0A 
                    DC.B '          @@***/**%*(@*(@@@**(@@@**@#****************(@@@%*@*@**@***@@',$0D,$0A 
                    DC.B '          @@(@%****@**@@*.*@@&*/@@@@@@@@*@@********@@*%@*@@**@***(@*@@',$0D,$0A 
                    DC.B '          @@@@***@(****(@@(*&@@@@@****%%*%%*****(@@@@**@#%**%*@***/@@@',$0D,$0A 
                    DC.B '          @@@@@@*****%*/(*/@@@**%@@@@@@@*@@@@@@@@**%@&**@*******@@@@@@',$0D,$0A 
                    DC.B '          @@@@@@@%*@@@@******#@@@@@@@*******(@@@@@@***%*(@@@@**@@@@@@@',$0D,$0A 
                    DC.B '          @@@@@@@@@@&*********(@&*****/***/*****#@//*******#@@@@@@@@@@',$0D,$0A 
                    DC.B '          @@@@@@@@@@@@@**********(@**#@@@@@***@(*********(@@@@@@@@@@@@',$0D,$0A 
                    DC.B '          @@@@@@@@@@@@@@@@@@@@@@/**@@@@@@@@@@@**%@@@@@@@@@@@@@@@@@@@@@',$0D,$0A
                    DC.B   $0D,$0A,$0D,$0A, 0
                                                             
FOREST:
                    DC.B   $0D,$0A,$0D,$0A,$0D
                    DC.B '                                        /\',$0D,$0A
                    DC.B '                                   /\  //\\',$0D,$0A
                    DC.B '                            /\    //\\///\\\        /\',$0D,$0A
                    DC.B '                           //\\  ///\////\\\\  /\  //\\',$0D,$0A
                    DC.B '              /\          /  ^ \/^ ^/^  ^  ^ \/^ \/  ^ \',$0D,$0A
                    DC.B '             / ^\    /\  / ^   /  ^/ ^ ^ ^   ^\ ^/  ^^  \',$0D,$0A
                    DC.B '            /^   \  / ^\/ ^ ^   ^ / ^  ^    ^  \/ ^   ^  \       *',$0D,$0A
                    DC.B '           /  ^ ^ \/^  ^\ ^ ^ ^   ^  ^   ^   ____  ^   ^  \     /|\',$0D,$0A
                    DC.B '          / ^ ^  ^ \ ^  _\___________________|  |_____^ ^  \   /||o\',$0D,$0A
                    DC.B '         / ^^  ^ ^ ^\  /______________________________\ ^ ^ \ /|o|||\',$0D,$0A
                    DC.B '        /  ^  ^^ ^ ^  /________________________________\  ^  /|||||o|\',$0D,$0A
                    DC.B '       /^ ^  ^ ^^  ^    ||___|___||||||||||||___|__|||      /||o||||||\       |',$0D,$0A
                    DC.B '      / ^   ^   ^    ^  ||___|___||||||||||||___|__|||          | |           |',$0D,$0A
                    DC.B '     / ^ ^ ^  ^  ^  ^   ||||||||||||||||||||||||||||||oooooooooo| |ooooooo  |',$0D,$0A
                    DC.B '     ooooooooooooooooooooooooooooooooooooooooooooooooooooooooo  ',$0D,$0A, 0
                                                                                                                          
TAB:                DC.B $09,0
LINE_BREAK:         DC.B $0D,$0A,0
ENTER_USERNAME:     DC.B $0D,$0A
                    DC.B '  Welcome : ', 0
WELCOME_PROMPT:     DC.B 'MISSION: STOP CLIMATE CHANGE AND SAVE THE WORLD',CR,LF,CR,LF,CR,LF
                    DC.B 'This is UN and you have been chosen to complete an important mission to SAVE ',CR,LF
                    DC.B 'THE WORLD! Your mission is simple remove all the carbon from the atmosphere',CR,LF
                    DC.B 'within the next 365 days or the world ends. Good Luck and dont mess this up ',CR,LF,CR,LF,0

BUY_A_TREE: DC.B 'Do you want to buy a tree?',CR,LF,0

CHOICE: DC.B 'Enter 1 for Yes, 0 for No',CR,LF, 0

EXIT_GAME: DC.B 'Enter 0 to end the loop!!', 0

TOTAL_TREES:    DC.B $09
                DC.B 'Total trees: ', 0

TOTAL_SOLARPANELS:  DC.B $09
                    DC.B 'Total Solar Panels: ', 0

TOTAL_WINDMILLS:    DC.B $09
                    DC.B 'Total Windmills: ', 0

TOTAL_CARBON:       DC.B $09
                    DC.B 'Total Carbon: ', 0

TOTAL_CAPITAL: DC.B $09,$09,'Total Capital: ', 0

    END    START



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
