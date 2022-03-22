
*-------------------------------------------------------
* STARTING MEMORY ADDRESS FOR THE PROGRAMME $1000
*-------------------------------------------------------
    ORG    $1000

*-------------------------------------------------------
*Literal Values
*-------------------------------------------------------

EXIT                            EQU 0        #USED TO EXIT ASSEMBLY PROGRAM
CARBON_REDUCTION_OF_TREE        EQU 10
CARBON_REDUCTION_OF_SOLARPANEL  EQU 130
CARBON_REDUCTION_OF_WINDMILL    EQU 1400

COST_OF_TREE        EQU 10
COST_OF_SOLARPANEL  EQU 100
COST_OF_WINDMILL    EQU 1000

*Staring the game
START:                 
    MOVE.L #1000000, $4000   #Total Carbon in atmosphere (1,000,000,000)
    MOVE.L #0, $4100    #MEMORY LOCATION OF TREES
    MOVE.L #0, $4200    #MEMORY LOCATION OF SOLARPANELS
    MOVE.L #0, $4300    #MEMORY LOCATION OF WINDMILL
    MOVE.L #500, $4400    #MEMORY LOCATION OF MONEY
    
    MOVE.L #0, $4350    #MEMORY LOCATION OF TIME
    
*-------------------------------------------------------
*-----------------Starting the Game---------------------
*-------------------------------------------------------
GAME:
    *BSR ENTER_NAME_SCREEN  #Asks User for name
    *BSR GAME_LOAD_SCREEN_SR #Loads the games name in Ascii art
    *BSR WELCOME BRANCH TO WELCOME SCREEN
    *BSR CLEAR_SCREEN
    BSR GAMELOOP    BRANCH TO GAMELOOP

*Enter name screen
ENTER_NAME_SCREEN:   
    LEA ENTER_USERNAME, A1
    MOVE.B #14, D0 
    TRAP #15
    
    MOVE.B #4, D0 #Asks the user for their name as input
    TRAP #15
    
    BSR CLEAR_SCREEN
    RTS
    
*Load game name
GAME_LOAD_SCREEN_SR:
    LEA GAME_LOAD_SCREEN, A1    #Loads the Ascii Art
    MOVE.B #14, D0
    TRAP #15
    
    MOVE.W   #500,D1     ; delay in 1/100th of seconds
    MOVE.B   #23,D0 #Uses a wait timer to delay the loading of text
    TRAP     #15
    
    BSR CLEAR_SCREEN
    RTS
    
*Load Mission Screen
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
    BSR CLEAR_SCREEN
    BSR HUD #Displays the HUD AFTER EVERY LOOP
    BSR GAMEPLAY    
    BRA UPDATE


GAMEPLAY:
    LEA SHOP_PROMPT, A1 #Prompt shop
    MOVE.B #14, D0
    TRAP #15
    
    LEA CHOICE, A1 #Prompt Choice
    TRAP #15
    
    MOVE.B #4, D0
    TRAP #15
    
    CMP #1, D1 #If 1 is enter shop is loaded
    BEQ SHOP
    
    RTS
*-------------------------------------------------------
*-----------------THE SHOP---------------------
*-------------------------------------------------------
SHOP:
    BSR CLEAR_SCREEN
    
    *LOAD SHOP GRAPHICS
    BSR SHOP_GUI
    BSR SHOP_INPUT
    RTS

*Shop menu
SHOP_GUI:
    LEA SHOP_MENU, A1
    MOVE.B #14, D0
    TRAP #15
    
    RTS

SHOP_INPUT:

    MOVE.B #4, D0
    TRAP #15
    MOVE.B D1, D3
  
    CMP #0, D1
    BNE QUANTITY
    
    BRA UPDATE
    
SHOP_CHOICE:
    *MENU'S IF ELSE STATEMENT
    CMP #1, D3
    BEQ ADD_TREE_SR
    
    CMP #2, D3
    BEQ ADD_SOLARPANEL_SR
    
    CMP #3, D3
    BEQ ADD_WINDMILLS_SR
    
    CMP #4, D3
    BEQ UPGRADE
    
    RTS

QUANTITY:
    LEA ITEM_QUANTITY, A1
    MOVE.B #14, D0
    TRAP #15
    
    MOVE.B #4, D0
    TRAP #15
    
    BRA SHOP_CHOICE
    
ADD_TREE_SR:
    
    MOVE.W D1, D4
    MULU.W #COST_OF_TREE, D4
    
    CMP.L ($4400), D4
    BLE.S CALCULATIONS
    
    MOVE.B #3, D0
    TRAP #15
    
    LEA NOT_ENOUGH_CAPITAL, A1
    MOVE.B #14, D0
    TRAP #15
    
    MOVE.W   #400,D1     ; delay in 1/100th of seconds
    MOVE.B   #23,D0
    TRAP     #15
    
    
    RTS
    
ADD_SOLARPANEL_SR:

    MOVE.W D1, D4
    MULU.W #COST_OF_SOLARPANEL, D4
    
    CMP.L ($4400), D4
    BLE.S CALCULATIONS
    
    MOVE.B #3, D0
    TRAP #15
    
    LEA NOT_ENOUGH_CAPITAL, A1
    MOVE.B #14, D0
    TRAP #15
    
    MOVE.W   #400,D1     ; delay in 1/100th of seconds
    MOVE.B   #23,D0
    TRAP     #15
    
    RTS
    
ADD_WINDMILLS_SR

    MOVE.W D1, D4
    MULU.W #COST_OF_WINDMILL, D4
    
    CMP.L ($4400), D4
    BLE.S CALCULATIONS
    
    MOVE.B #3, D0
    TRAP #15
    
    LEA NOT_ENOUGH_CAPITAL, A1
    MOVE.B #14, D0
    TRAP #15
    
    MOVE.W   #400,D1     ; delay in 1/100th of seconds
    MOVE.B   #23,D0
    TRAP     #15
    
    RTS

CALCULATIONS:
    CMP #1, D3
    BEQ TREE_CAL
    
    CMP #2, D3
    BEQ SOLAR_CAL
    
    CMP #3, D3
    BEQ WIND_CAL
    
TREE_CAL: 
    ADD.L D1, $4100
    SUB.L D4, ($4400)
    
    BSR PURCHASE_SUCCESSFUL
    
SOLAR_CAL: 
    ADD.L D1, $4200
    SUB.L D4, ($4400)

    BSR PURCHASE_SUCCESSFUL
    
WIND_CAL:
    ADD.L D1, $4300
    SUB.L D4, ($4400)
    
    BSR PURCHASE_SUCCESSFUL

PURCHASE_SUCCESSFUL: 
    LEA PUR_SUCCESS, A1
    MOVE.B #14, D0
    TRAP #15
    
    MOVE.W   #300,D1    
    MOVE.B   #23,D0 
    TRAP     #15
    
    BRA SHOP
    
UPGRADE:
    LEA UPGRADES, A1
    MOVE.B #14, D0
    TRAP #15
    
    RTS
    
*-------------------------------------------------------
*-----------------THE HUD---------------------
*-------------------------------------------------------
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
    
    MOVE.L $4100, D1
    MOVE.B #3, D0
    TRAP #15
    
    MOVE.B #14, D0
    
    LEA TOTAL_SOLARPANELS, A1 #Display Total Solar Panels
    TRAP #15
    
    MOVE.L $4200, D1
    MOVE.B #3, D0
    TRAP #15
    
    MOVE.B #14, D0
   
    LEA TOTAL_WINDMILLS, A1 #Display Total Windmills
    TRAP #15
    
    MOVE.L $4300, D1
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
*-------------------------------------------------------
*-----------------CARBON CALCULATIONS---------------------
*-------------------------------------------------------

REDUCE_CARBON:
    MOVE.L ($4100), D1

    MULU.W #CARBON_REDUCTION_OF_TREE, D1
    
    MOVE.L D1, D7
    
    MOVE.L ($4200), D2
    
    MULU.W #CARBON_REDUCTION_OF_SOLARPANEL, D2
    
    ADD.W D2, D7
    
    MOVE.L ($4300), D3
    
    MULU.W #CARBON_REDUCTION_OF_WINDMILL, D3
    
    ADD.W D3, D7
    
    MOVE.L D7, D1
    
    SUB.L D7, ($4000)
    
    RTS
    
INCREASE_CAPITAL: 
    
    CMP.L #100, D7
    BGE INCREASE
    
    RTS
        
INCREASE:
    SUB.L #100, D7
    
    ADD.L #10, ($4400)
    
    BRA INCREASE_CAPITAL
    
    
*-------------------------------------------------------
*-----------------GAME EVENTS---------------------
*-------------------------------------------------------

UPDATE_DAY:
    
    ADD.L #1, ($4350)
    
    BSR END_OF_GAME_BY_DAY
    BSR END_OF_GAME_BY_WIN
    
    RTS
    
END_OF_GAME_BY_DAY:

    BSR CLEAR_SCREEN
    CMP.L #365, ($4350)
    BEQ FAILED_MISSION
    
    RTS
    
END_OF_GAME_BY_WIN:
    
    BSR CLEAR_SCREEN
    CMP.L #0, ($4000)
    BLE WON
    
    RTS
 
*Won the game   
WON:
    LEA WON_TEXT, A1
    MOVE.B #14, D0
    TRAP #15
    
    MOVE.W   #500,D1     
    MOVE.B   #23,D0
    TRAP     #15
    
    BRA END
    
*Lost the game     
FAILED_MISSION:

    LEA FAILED, A1
    MOVE.B #14, D0
    TRAP #15
    
    MOVE.W   #500,D1     
    MOVE.B   #23,D0
    TRAP     #15
    
    BRA END
    
UPDATE: 

    BSR REDUCE_CARBON
    BSR INCREASE_CAPITAL
    BSR UPDATE_DAY
    
    BRA GAMELOOP

CLEAR_SCREEN:
    MOVE.B  #11,D0
    MOVE.W  #$FF00,D1
    TRAP    #15
    
    RTS
    
END:

    SIMHALT
* Put variables and constants here
CR EQU $0D
LF EQU $0A

*USEFUL STRINGS
TAB:                DC.B $09,0
LINE_BREAK:         DC.B $0D,$0A,0

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
                    
SHOP_MENU:          
                    DC.B '  *------------------------------------------------------*',$0D,$0A
                    DC.B '  *----------------------THE SHOP------------------------*',$0D,$0A
                    DC.B '  *------------------------------------------------------*',$0D,$0A
                    DC.B $0D,$0A
                    DC.B '    Climate Saving Resources  ',$0D,$0A                     
                    DC.B $0D,$0A
                    DC.B '  1. Purchase each Tree for 10 euro',$0D,$0A 
                    DC.B '  2. Purchase each Solar Panel for 100 euro',$0D,$0A
                    DC.B '  3. Purchase each Windmill for 1000 euro',$0D,$0A
                    DC.B $0D,$0A
                    DC.B '  4. Check Upgrades',$0D,$0A,$0D,$0A
                    DC.B '  *------------------------------------------------------*',$0D,$0A
                    DC.B '  *------------------------------------------------------*',$0D,$0A
                    DC.B '  *------------------------------------------------------*',$0D,$0A
                    DC.B $0D,$0A,$0D,$0A
                    DC.B ' Choose an item above, or press 0 to exit the shop: ', 0

UPGRADES:           DC.B '  *------------------------------------------------------*',$0D,$0A
                    DC.B '  *--------------------THE UPGRADES----------------------*',$0D,$0A
                    DC.B '  *------------------------------------------------------*',$0D,$0A
                    DC.B $0D,$0A
                    DC.B '    Climate Saving Resources  ',$0D,$0A                     
                    DC.B $0D,$0A
                    DC.B '  1. Purchase each Tree for 1000 euro',$0D,$0A 
                    DC.B '  2. Purchase each Solar Panel for 10000 euro',$0D,$0A
                    DC.B '  3. Purchase each Windmill for 100000 euro',$0D,$0A
                    DC.B $0D,$0A
                    DC.B '  4. Check Upgrades',$0D,$0A,$0D,$0A
                    DC.B '  *------------------------------------------------------*',$0D,$0A
                    DC.B '  *------------------------------------------------------*',$0D,$0A
                    DC.B '  *------------------------------------------------------*',$0D,$0A
                    DC.B $0D,$0A,$0D,$0A
                    DC.B ' Choose an item above, or press 0 to exit the shop: ', 0
                    
ITEM_QUANTITY:      DC.B $0D,$0A
                    DC.B ' How many would you like to purchase: ',0    
PUR_SUCCESS:        DC.B $0D,$0A
                    DC.B ' Purchase Successful ',0                                                                                                            
ENTER_USERNAME:     DC.B $0D,$0A
                    DC.B '  Welcome : ', 0
WELCOME_PROMPT:     DC.B 'MISSION: STOP CLIMATE CHANGE AND SAVE THE WORLD',CR,LF,CR,LF,CR,LF
                    DC.B 'This is UN and you have been chosen to complete an important mission to SAVE ',CR,LF
                    DC.B 'THE WORLD! Your mission is simple remove all the carbon from the atmosphere',CR,LF
                    DC.B 'within the next 365 days or the world ends. Good Luck and dont mess this up ',CR,LF,CR,LF,0

BUY_A_TREE: DC.B 'Do you want to buy a tree?',CR,LF,0
SUCCESS: DC.B 'YAY',0

SHOP_PROMPT: DC.B 'Would you like to enter the shop?',CR,LF, 0
CHOICE: DC.B 'Enter 1 for Yes, 0 for No ', 0

CONTINUE_GAME: DC.B 'Enter a character other than zero to continue', 0

TOTAL_TREES:    DC.B $09
                DC.B 'Total trees: ', 0

TOTAL_SOLARPANELS:  DC.B $09
                    DC.B 'Total Solar Panels: ', 0

TOTAL_WINDMILLS:    DC.B $09
                    DC.B 'Total Windmills: ', 0

TOTAL_CARBON:       DC.B $09
                    DC.B 'Total Carbon: ', 0

TOTAL_CAPITAL: DC.B $09,$09,'Total Capital: ', 0

NOT_ENOUGH_CAPITAL: DC.B $09
                    DC.B 'You dont have enough capital to make this purchase! ', 0 
                    
FAILED:             DC.B $0D,$0A
                    DC.B 'You have ran out of time to save the climate and the world is now doomed!',CR,LF
                    DC.B 'The mission has beeen a failure and it is all your fault!', 0 
                    
WON_TEXT:             DC.B $0D,$0A
                    DC.B 'You have cleaned the climate and save the world!',CR,LF
                    DC.B 'Because of your momentous achievement you have been offer the Nobel Prize', 0 

    END    START










*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
