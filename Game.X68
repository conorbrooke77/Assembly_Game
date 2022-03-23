
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
CARBON_REDUCTION_OF_WINDMILL    EQU 1350

COST_OF_TREE        EQU 10
COST_OF_SOLARPANEL  EQU 100
COST_OF_WINDMILL    EQU 1000

*Staring the game
START:                 
    MOVE.L #1000000, $6000   #Total Carbon in atmosphere (1,000,000)
    MOVE.L #0, $6100    #MEMORY LOCATION OF TREES
    MOVE.L #0, $6200    #MEMORY LOCATION OF SOLARPANELS
    MOVE.L #0, $6300    #MEMORY LOCATION OF WINDMILL
    MOVE.L #1000, $6400    #MEMORY LOCATION OF MONEY
    
    MOVE.L #0, $6350    #MEMORY LOCATION OF TIME
    
*-------------------------------------------------------
*-----------------Starting the Game---------------------
*-------------------------------------------------------
GAME:
    BSR ENTER_NAME_SCREEN  #Asks User for name
    BSR GAME_LOAD_SCREEN_SR #Loads the games name in Ascii art
    BSR WELCOME #BRANCH TO WELCOME SCREEN
    BSR CLEAR_SCREEN
    BSR GAMELOOP    #BRANCH TO GAMELOOP

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

    LEA SHOP_PROMPT, A1
    MOVE.B #14, D0
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
    LEA BALANCE, A1
    MOVE.B #14, D0
    TRAP #15

    MOVE.L ($6400), D1
    MOVE.B #3, D0
    TRAP #15
    
    LEA SHOP_MENU, A1
    MOVE.B #14, D0
    TRAP #15
    
    
    RTS

SHOP_INPUT:

    MOVE.B #4, D0
    TRAP #15
    MOVE.L D1, D3
  
    CMP #0, D1
    BLT GAMELOOP
    
    CMP #3, D1
    BGT GAMELOOP
    
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
    
    CMP.L ($6400), D4
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
    
    CMP.L ($6400), D4
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
    
    CMP.L ($6400), D4
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
    ADD.L D1, $6100
    SUB.L D4, ($6400)
    
    BSR PURCHASE_SUCCESSFUL
    
SOLAR_CAL: 
    ADD.L D1, $6200
    SUB.L D4, ($6400)

    BSR PURCHASE_SUCCESSFUL
    
WIND_CAL:
    ADD.L D1, $6300
    SUB.L D4, ($6400)
    
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
    
    MOVE.L $6000, D1
    MOVE.B #3, D0
    TRAP #15
    
    MOVE.B #14, D0
    
    LEA TOTAL_CAPITAL, A1 #Display Total Capital
    TRAP #15
    
    MOVE.L $6400, D1
    MOVE.B #3, D0
    TRAP #15
    
    MOVE.B #14, D0
    LEA TOTAL_DAYS, A1 #Display Total Capital
    TRAP #15
    
    MOVE.L $6350, D1
    MOVE.B #3, D0
    TRAP #15
    
    LEA LINE_BREAK, A1
    MOVE.B #14, D0
    TRAP #15
    
    
    LEA TOTAL_TREES, A1 #Display Total trees
    TRAP #15
    
    MOVE.L $6100, D1
    MOVE.B #3, D0
    TRAP #15
    
    MOVE.B #14, D0
    
    LEA TOTAL_SOLARPANELS, A1 #Display Total Solar Panels
    TRAP #15
    
    MOVE.L $6200, D1
    MOVE.B #3, D0
    TRAP #15
    
    MOVE.B #14, D0
   
    LEA TOTAL_WINDMILLS, A1 #Display Total Windmills
    TRAP #15
    
    MOVE.L $6300, D1
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
    MOVE.L ($6100), D1

    MULU.W #CARBON_REDUCTION_OF_TREE, D1
    
    MOVE.L D1, D7
    
    MOVE.L ($6200), D2
    
    MULU.W #CARBON_REDUCTION_OF_SOLARPANEL, D2
    
    ADD.L D2, D7
    
    MOVE.L ($6300), D3
    
    MULU.W #CARBON_REDUCTION_OF_WINDMILL, D3
    
    ADD.L D3, D7
    
    MOVE.L D7, D1
    
    SUB.L D7, ($6000)
    
    ADD.L #1500, ($6000)
    
    RTS
    
INCREASE_CAPITAL: 
    
    CMP.L #250, D7
    BGE INCREASE
    
    RTS
        
INCREASE:
    SUB.L #250, D7
    
    ADD.L #10, ($6400)
    
    BRA INCREASE_CAPITAL
    
    
*-------------------------------------------------------
*-----------------GAME EVENTS---------------------
*-------------------------------------------------------

RANDOM_EVENT:
    
    MOVE.B #8, D0 #Loads D1 with Time in 100's of Seconds since midnight (6 Bits)

    TRAP #15  

    AND.L #$5FFFFF, D1 # AND 6 Bits to prevent any overflow

    DIVU #100, D1 #Divide by 100

    SWAP D1 #SWAP Higher Order Word and Lower Order Word in D1

    ADDQ.W #1, D1 

    MOVE.W D1, D2

    CLR.L D1

    MOVE.W D2, D1
    
    CMP #10, D1
    BLE NATURAL_FOREST_FIRE
    
    CMP #20, D1
    BLE NATURAL_FLOOD
    
    CMP #30, D1
    BLE NATURAL_HURRICANE
    
    CMP #40, D1
    BLE NUCLEAR_PLANT
    
    CMP #50, D1
    BLE NEW_WINDMILL_PLANT
    
    CMP #60, D1
    BLE UN_GRANT
    
    CMP #70, D1
    BLE TEAM_TREES
    
    CMP #80, D1
    BLE EARTH_DAY
    
    CMP #90, D1
    BLE NATURAL_FLOOD
    
    CMP #100, D1
    BLE NATURAL_HURRICANE
    
    BRA REDUCE_CARBON
    
NATURAL_FOREST_FIRE:

    BSR CLEAR_SCREEN
    
    LEA FOREST_FIRE, A1
    MOVE.B #14, D0
    TRAP #15
    
    MOVE.W   #500,D1
    MOVE.B   #23,D0
    TRAP     #15
        
    MOVE.L ($6100), D4
    DIVU #10, D4
    
    MOVE.B D4, D5
    
    SUB.L D5, ($6100)
    
    CMP #0, ($6100)
    BEQ REDUCE_CARBON
    
    CMP #9, ($6100)
    BLE SUB_FOR
    
    BRA REDUCE_CARBON
    
NATURAL_FLOOD:

    BSR CLEAR_SCREEN
    LEA FLOOD, A1
    MOVE.B #14, D0
    TRAP #15
    
    MOVE.W   #500,D1
    MOVE.B   #23,D0
    TRAP     #15
        
    MOVE.L ($6200), D4
    DIVU #20, D4
    
    MOVE.B D4, D5
    
    SUB.L D5, ($6200)
    
    SUB.L #1000, ($6400)
    
    CMP #0, ($6200)
    BEQ REDUCE_CARBON
    
    CMP #19, ($6200)
    BLE SUB_FLOOD
    
    BRA REDUCE_CARBON
    
NATURAL_HURRICANE:

    BSR CLEAR_SCREEN
    LEA HURRICANE, A1
    MOVE.B #14, D0
    TRAP #15

    MOVE.W   #500,D1
    MOVE.B   #23,D0
    TRAP     #15
    
    MOVE.L ($6300), D4
    DIVU #10, D4
    
    MOVE.B D4, D5
    
    SUB.L D5, ($6300)
    
    CMP #0, ($6300)
    BEQ REDUCE_CARBON
    
    CMP #9, ($6300)
    BLE SUB_HUR
    
    BRA REDUCE_CARBON

SUB_HUR:
    
    SUB.L #1, ($6300)
    
    RTS
    
SUB_FLOOD:
    
    SUB.L #1, ($6200)
    
    RTS

SUB_FOR:
    
    SUB.L #1, ($6100)
    
    RTS
     
NUCLEAR_PLANT:

    BSR CLEAR_SCREEN
    LEA NUCLEAR_IMG, A1
    MOVE.B #14, D0
    TRAP #15
    
    MOVE.B   #4,D0
    TRAP     #15
    
    CMP #1, D1
    BEQ BRIBE
    
    CMP #2, D1
    BEQ INCREASE_CARBON_OPT
    
    BRA REDUCE_CARBON
    
BRIBE:
    
    SUB.L #2500, ($6400)
    
    RTS

INCREASE_CARBON_OPT:

    ADD.L #100000, ($6000)
    RTS

UN_GRANT:

    BSR CLEAR_SCREEN
    LEA GRANT, A1
    MOVE.B #14, D0
    TRAP #15
    
    MOVE.W   #500,D1
    MOVE.B   #23,D0
    TRAP     #15
    
    ADD.L #2500, ($6400)
    
    BRA REDUCE_CARBON
    
NEW_WINDMILL_PLANT:

    BSR CLEAR_SCREEN
    LEA WIND_PLANT, A1
    MOVE.B #14, D0
    TRAP #15

    MOVE.W   #500,D1
    MOVE.B   #23,D0
    TRAP     #15
    
    ADD.L #3, ($6300)
    
    BRA REDUCE_CARBON
    
TEAM_TREES:

    BSR CLEAR_SCREEN
    LEA TEAM_TREES_LOGO, A1
    MOVE.B #14, D0
    TRAP #15
    
    MOVE.W   #500,D1
    MOVE.B   #23,D0
    TRAP     #15
    
    ADD.L #100, ($6100)
    
    BRA REDUCE_CARBON

EARTH_DAY:

    BSR CLEAR_SCREEN
    LEA EARTH, A1
    MOVE.B #14, D0
    TRAP #15
    
    MOVE.W   #500,D1
    MOVE.B   #23,D0
    TRAP     #15
    
    SUB.L #20000, ($6000)
    
    BRA REDUCE_CARBON

*-------------------------------------------------------
*-----------------END GAME---------------------
*-------------------------------------------------------
UPDATE_DAY:
    
    ADD.L #1, ($6350)
    
    BSR END_OF_GAME_BY_DAY
    BSR END_OF_GAME_BY_WIN
    
    RTS
    
END_OF_GAME_BY_DAY:

    BSR CLEAR_SCREEN
    CMP.L #100, ($6350)
    BEQ FAILED_MISSION
    
    RTS
    
END_OF_GAME_BY_WIN:
    
    BSR CLEAR_SCREEN
    CMP.L #0, ($6000)
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

    BSR RANDOM_EVENT
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

BALANCE:            
                    DC.B $0D,$0A,$0D,$0A
                    DC.B '  Your balance is: ',0

SHOP_MENU:          
                    DC.B $0D,$0A
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
                    DC.B $0D,$0A
                    DC.B '  *------------------------------------------------------*',$0D,$0A
                    DC.B '  *------------------------------------------------------*',$0D,$0A
                    DC.B '  *------------------------------------------------------*',$0D,$0A
                    DC.B $0D,$0A,$0D,$0A
                    DC.B ' Choose an item above, or press 0 to exit the shop: ',0
                    
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
                    DC.B   $0D,$0A,$0D,$0A
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
                    DC.B   $0D,$0A,$0D,$0A
                    DC.B '                                      /\',$0D,$0A
                    DC.B '                                 /\  //\\',$0D,$0A
                    DC.B '                          /\    //\\///\\\        /\',$0D,$0A
                    DC.B '                         //\\  ///\////\\\\  /\  //\\',$0D,$0A
                    DC.B '            /\          /  ^ \/^ ^/^  ^  ^ \/^ \/  ^ \',$0D,$0A
                    DC.B '           / ^\    /\  / ^   /  ^/ ^ ^ ^   ^\ ^/  ^^  \',$0D,$0A
                    DC.B '          /^   \  / ^\/ ^ ^   ^ / ^  ^    ^  \/ ^   ^  \       *',$0D,$0A
                    DC.B '         /  ^ ^ \/^  ^\ ^ ^ ^   ^  ^   ^   ____  ^   ^  \     /|\',$0D,$0A
                    DC.B '        / ^ ^  ^ \ ^  _\___________________|  |_____^ ^  \   /||o\',$0D,$0A
                    DC.B '       / ^^  ^ ^ ^\  /______________________________\ ^ ^ \ /|o|||\',$0D,$0A
                    DC.B '      /  ^  ^^ ^ ^  /________________________________\  ^  /|||||o|\',$0D,$0A
                    DC.B '     /^ ^  ^ ^^  ^    ||___|___||||||||||||___|__|||      /||o||||||\       |',$0D,$0A
                    DC.B '    / ^   ^   ^    ^  ||___|___||||||||||||___|__|||          | |           |',$0D,$0A
                    DC.B '   / ^ ^ ^  ^  ^  ^   ||||||||||||||||||||||||||||||oooooooooo| |ooooooo  |',$0D,$0A
                    DC.B '   ooooooooooooooooooooooooooooooooooooooooooooooooooooooooo  ',$0D,$0A, 0
                    
                    
FOREST_FIRE:
                    DC.B   $0D,$0A,$0D,$0A,$0D,$0A,$0D,$0A
                    DC.B '                             (  .      )',$0D,$0A
                    DC.B '                         )           (              )',$0D,$0A
                    DC.B '                               .  ,   .   ,  .  "  .',$0D,$0A
                    DC.B '                      (    , )       (.   )  (   ",    )',$0D,$0A
                    DC.B '                       ." ) ( . )    ,  ( ,     )   ( .',$0D,$0A
                    DC.B '                    ). , ( .   (  ) ( , ")  ." (  ,    )',$0D,$0A
                    DC.B '                  (_,) . ), ) _) _,`)  (, ) ". )  ,. (` )',$0D,$0A
                    DC.B '                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^',$0D,$0A
                    DC.B $0D,$0A, $0D,$0A, $0D,$0A  
                    DC.B '  Forest Fire:',$0D,$0A
                    DC.B $0D,$0A                 
                    DC.B '  Oh No! Your forest has caught on fire. The damges have been ',$0D,$0A  
                    DC.B '  severe and you have lost 10% of your total trees. ',$0D,$0A, 0 
                    
HURRICANE:
                    DC.B   $0D,$0A,$0D,$0A,$0D,$0D,$0A,$0D
                    DC.B '                        ((  "####@@!!$$    ))',$0D,$0A
                    DC.B '                            `#####@@!$$`  ))',$0D,$0A
                    DC.B '                         ((  `####@!!$:',$0D,$0A
                    DC.B '                        ((  ,####@!!$:   ))',$0D,$0A
                    DC.B '                            .###@!!$:',$0D,$0A
                    DC.B '                            `##@@!$:',$0D,$0A
                    DC.B '                             `#@!!$',$0D,$0A
                    DC.B '                       !@#    `#@!$:       @#$',$0D,$0A
                    DC.B '                        #$     `#@!$:       !@!',$0D,$0A
                    DC.B '                                 `@!$:',$0D,$0A
                    DC.B '                             ``\   "!$: /``',$0D,$0A
                    DC.B '                                `\  `!: /`',$0D,$0A
                    DC.B '                                  "\ : /"',$0D,$0A
                    DC.B '                       -."-/\\\-."//.-"/:`\."-.JrS"."-=_\\',$0D,$0A
                    DC.B '                     " -."-.\\"-."//.-".`-."_\\-.".-\".-//',$0D,$0A
                    DC.B $0D,$0A, $0D,$0A  
                    DC.B '  A Hurricane:',$0D,$0A
                    DC.B $0D,$0A                 
                    DC.B '  A Hurricane has came and destroyed your Windmills! ',$0D,$0A
                    DC.B '  Due to this event being a natural diaster the UN will not  ',$0D,$0A  
                    DC.B '  cover the damges. You have lost 10% of your total windmills.',$0D,$0A, 0               
                    
FLOOD:
                    DC.B   $0D,$0A,$0D,$0A,$0D,$0A,$0D,$0A,$0D
                    DC.B '                                      000      00',$0D,$0A
                    DC.B '                                    0000000   0000',$0D,$0A
                    DC.B '                       0      00  00000000000000000',$0D,$0A
                    DC.B '                     0000 0  000000000000000000000000       0',$0D,$0A
                    DC.B '                  000000000000000000000000000000000000000 000',$0D,$0A
                    DC.B '                 0000000000000000000000000000000000000000000000',$0D,$0A
                    DC.B '             000000000000000000000000000000000000000000000000',$0D,$0A
                    DC.B '         00000000000000000000000000000000000000000000000000000000',$0D,$0A
                    DC.B '                       / / / / / / / / / / / / / / / /',$0D,$0A
                    DC.B '                     / / / / / / / / / / / / / / /',$0D,$0A
                    DC.B '                     / / / / / / / / / / / / / / /',$0D,$0A
                    DC.B '                   / / / / / / / / / / / / / /',$0D,$0A
                    DC.B '                   / / / / / / / / / / / / /',$0D,$0A
                    DC.B '                 / / / / / / / / / / / /',$0D,$0A
                    DC.B '                 / / / / / / / / / /',$0D,$0A
                    DC.B $0D,$0A, $0D,$0A  
                    DC.B '  A Flood:',$0D,$0A
                    DC.B $0D,$0A                 
                    DC.B '  Your Solar Panels have been demolished by the force of ',$0D,$0A
                    DC.B '  the Flood! You have lost 5% of your Solars Panels and',$0D,$0A
                    DC.B '  the repairs from the damages will cost 1000 euros.',$0D,$0A, 0                    

NUCLEAR_IMG:
                    DC.B   $0D,$0A,$0D,$0A,$0D,$0A,$0D
                    DC.B '                  ) ) )                     ) ) )',$0D,$0A
                    DC.B '                ( ( (                      ( ( (',$0D,$0A
                    DC.B '              ) ) )                       ) ) )',$0D,$0A
                    DC.B '           (~~~~~~~~~)                 (~~~~~~~~~)',$0D,$0A
                    DC.B '            | POWER |                   | POWER |',$0D,$0A
                    DC.B '            |       |                   |       |',$0D,$0A
                    DC.B '            I      _._                  I       _._',$0D,$0A
                    DC.B '            I    /`   `\                I     /`   `\',$0D,$0A
                    DC.B '            I   |   N   |               I    |   N   |',$0D,$0A
                    DC.B '            f   |   |~~~~~~~~~~~~~~|    f    |    |~~~~~~~~~~~~~~|',$0D,$0A
                    DC.B '          .`    |   ||~~~~~~~~|    |  .`     |    | |~~~~~~~~|   |',$0D,$0A
                    DC.B '        /`______|___||__###___|____|/`_______|____|_|__###___|___',$0D,$0A
                    DC.B $0D,$0A, $0D,$0A  
                    DC.B '  New Nuclear Plant Plan:',$0D,$0A
                    DC.B $0D,$0A                 
                    DC.B '  A private company want to build new Nuclear Power Plants ',$0D,$0A
                    DC.B '  around the earth. The plan will dramatically increase the ',$0D,$0A
                    DC.B '  carbon in the atmosphere. This will seriously hurt your Mission!',$0D,$0A
                    DC.B $0D,$0A,$0D,$0A
                    DC.B '  [Bribe Company] 1.Pay 2500 euros.',$0D,$0A
                    DC.B $0D,$0A
                    DC.B '  [Continue] 2.Increase Carbon By 100,000.',$0D,$0A
                    DC.B $0D,$0A
                    DC.B '  Choose an option from above: ', 0
                    
GRANT:
                    DC.B   $0D,$0A,$0D,$0A
                    DC.B '    ||====================================================================||',$0D,$0A
                    DC.B '    ||//$\\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\//$\\||',$0D,$0A
                    DC.B '    ||(100)==================| FEDERAL RESERVE NOTE |================(100)||',$0D,$0A
                    DC.B '    ||\\$//        ~         `------========--------`                \\$//||',$0D,$0A
                    DC.B '    ||<< /        /$\              // ____ \\                         \ >>||',$0D,$0A
                    DC.B '    ||>>|  12    //L\\            // ///..) \\         L38036133B   12 |<<||',$0D,$0A
                    DC.B '    ||<<|        \\ //           || <||  >\  ||                        |>>||',$0D,$0A
                    DC.B '    ||>>|         \$/            ||  $$ --/  ||        One Hundred     |<<||',$0D,$0A
                    DC.B '    ||<<|      L38036133B        *\\  |\_/  //* series                 |>>||',$0D,$0A
                    DC.B '    ||>>|  12                     *\\/___\_//*   1989                  |<<||',$0D,$0A
                    DC.B '    ||<<\      Treasurer     ______/Franklin\________     Secretary 12 />>||',$0D,$0A
                    DC.B '    ||//$\                 ~|UNITED STATES OF AMERICA|~               /$\\||',$0D,$0A
                    DC.B '    ||(100)===================  ONE HUNDRED DOLLARS =================(100)||',$0D,$0A
                    DC.B '    ||\\$//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\\$//||',$0D,$0A
                    DC.B '    ||====================================================================||',$0D,$0A
                    DC.B $0D,$0A,$0D,$0A  
                    DC.B '  UN Grant:',$0D,$0A
                    DC.B $0D,$0A                 
                    DC.B '  Due to your hard work the EU have offered you a Grant! ',$0D,$0A
                    DC.B '  The Grant sum is 2500 euros. Congrats!',$0D,$0A, 0                 
        
WIND_PLANT:
                    DC.B   $0D,$0A,$0D,$0A,$0D,$0A,$0D,$0A
                    DC.B '                                                         __',$0D,$0A
                    DC.B '                                   ,-_                  (`  ).',$0D,$0A
                    DC.B '                                   |-_`-,              (     ).',$0D,$0A
                    DC.B '                                   |-_`-`           _(        ``.',$0D,$0A
                    DC.B '                          _        |-_`/        .=(`(      .     )',$0D,$0A
                    DC.B '                         /;-,_     |-_`        (     (.__.:-`-_.`',$0D,$0A
                    DC.B '                        /-.-;,-,___|`          `(       ) )',$0D,$0A
                    DC.B '                       /;-;-;-;_;_/|\_ _ _ _ _   ` __.:`   )',$0D,$0A
                    DC.B '                          x_( __`|_P_|`-;-;-;,|        `--`',$0D,$0A
                    DC.B '                          |\ \    _||   `-;-;-`',$0D,$0A
                    DC.B '                          | \`   -_|.      `-`',$0D,$0A
                    DC.B '                          | /   /-_| `',$0D,$0A
                    DC.B '                          |/   ,`-_|  \',$0D,$0A
                    DC.B '                          /____|`-_|___\',$0D,$0A
                    DC.B '                   _..,____]__|_\-_`|_[___,.._',$0D,$0A
                    DC.B '                  `                          ```--,..,.',$0D,$0A
                    DC.B $0D,$0A,$0D,$0A  
                    DC.B '  New Windmill Plant:',$0D,$0A
                    DC.B $0D,$0A                 
                    DC.B '  A Non profit group have helped you on your Mission ',$0D,$0A
                    DC.B '  by granting you 3 new windmills. You are doing great!',$0D,$0A, 0   
                  
TEAM_TREES_LOGO:
                    DC.B   $0D,$0A,$0D,$0A,$0D,$0A,$0D,$0A
                    DC.B '                    _______ ______          __  __',$0D,$0A     
                    DC.B '                   |__   __|  ____|   /\   |  \/  |',$0D,$0A     
                    DC.B '                      | |  | |__     /  \  | \  / |',$0D,$0A     
                    DC.B '                      | |  |  __|   / /\ \ | |\/| |',$0D,$0A     
                    DC.B '                      | |  | |____ / ____ \| |  | |',$0D,$0A     
                    DC.B '                    __|_|__|______/_/____\_\_|__|_|____',$0D,$0A 
                    DC.B '                   |__   __|  __ \|  ____|  ____|/ ____|',$0D,$0A
                    DC.B '                      | |  | |__) | |__  | |__  | (___',$0D,$0A  
                    DC.B '                      | |  |  _  /|  __| |  __|  \___ \',$0D,$0A 
                    DC.B '                      | |  | | \ \| |____| |____ ____) |',$0D,$0A
                    DC.B '                      |_|  |_|  \_\______|______|_____/',$0D,$0A
                    DC.B $0D,$0A, $0D,$0A  
                    DC.B '  OMG Its Team Trees:',$0D,$0A
                    DC.B $0D,$0A                 
                    DC.B '  A Non profit group Team Trees have just planted ',$0D,$0A
                    DC.B '  Trees on your land! You have gained 100 new Trees ',$0D,$0A, 0  
              
EARTH:      
                    DC.B   $0D,$0A,$0D,$0A,$0D,$0A
                    DC.B '          o               .        ___---___                    .',$0D,$0A                    
                    DC.B '                 .              .--\        --.     .     .         .',$0D,$0A 
                    DC.B '                              ./.;_.\     __/~ \.',$0D,$0A      
                    DC.B '                             /;  / `-`  __\    . \',$0D,$0A                             
                    DC.B '           .        .       / ,--`     / .   .;   \        |',$0D,$0A 
                    DC.B '                           | .|       /       __   |      -O-       .',$0D,$0A 
                    DC.B '                          |__/    __ |  . ;   \ | . |      |',$0D,$0A 
                    DC.B '                          |      /  \\_    . ;| \___|',$0D,$0A     
                    DC.B '             .    o       |      \  .~\\___`--`     |           .',$0D,$0A 
                    DC.B '                           |     | . ; ~~~~\_    __|',$0D,$0A 
                    DC.B '              |             \    \   .  .  ; \  /_/   .',$0D,$0A 
                    DC.B '             -O-        .    \   /         . |  ~/                  .',$0D,$0A 
                    DC.B '              |    .          ~\ \   .      /  /~          o',$0D,$0A 
                    DC.B '            .                   ~--___ ; ___--~',$0D,$0A        
                    DC.B '                           .          ---         .',$0D,$0A    
                    DC.B $0D,$0A, $0D,$0A  
                    DC.B '  Earth Day:',$0D,$0A
                    DC.B $0D,$0A                 
                    DC.B '  Today is Earth day and the world has come together to help ',$0D,$0A
                    DC.B '  you on your Mission. Due to people cycling to work and smart ',$0D,$0A
                    DC.B '  decisions to save electricty, the total carbon has dropped ',$0D,$0A
                    DC.B '  by 20,000 units.',$0D,$0A, 0          

UPGRADES:           DC.B '  *------------------------------------------------------*',$0D,$0A
                    DC.B '  *--------------------THE UPGRADES----------------------*',$0D,$0A
                    DC.B '  *------------------------------------------------------*',$0D,$0A
                    DC.B $0D,$0Ad
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
                    DC.B ' Choose an item above, or press 0 to exit the shop: ',0
                    
ITEM_QUANTITY:      DC.B $0D,$0A
                    DC.B ' How many would you like to purchase: ',0    
PUR_SUCCESS:        DC.B $0D,$0A
                    DC.B ' Purchase Successful ',0                                                                                                            
ENTER_USERNAME:     DC.B $0D,$0A
                    DC.B '  Welcome : ',0
WELCOME_PROMPT:     DC.B ' MISSION: STOP CLIMATE CHANGE AND SAVE THE WORLD',CR,LF,CR,LF,CR,LF
                    DC.B ' This is UN and you have been chosen to complete an important mission to SAVE ',CR,LF
                    DC.B ' THE WORLD! Your mission is simple remove all the carbon from the atmosphere',CR,LF
                    DC.B ' within the next 100 days or the world ends. Good Luck and dont mess this up ',CR,LF,CR,LF,0

BUY_A_TREE: DC.B 'Do you want to buy a tree?',CR,LF,0
SUCCESS: DC.B 'YAY',0

SHOP_PROMPT: DC.B ' Enter 1 for the Shop , or a charcter to continue ', 0

CONTINUE_GAME: DC.B 'Enter a character other than zero to continue',0

TOTAL_TREES:    DC.B $09
                DC.B 'Total trees: ',0

TOTAL_SOLARPANELS:  DC.B $09
                    DC.B 'Total Solar Panels: ', 0

TOTAL_WINDMILLS:    DC.B $09
                    DC.B 'Total Windmills: ', 0

TOTAL_CARBON:       DC.B $09
                    DC.B 'Total Carbon: ', 0

TOTAL_CAPITAL:      DC.B $09,'Total Capital: ', 0

TOTAL_DAYS:         DC.B $09,'Day: ', 0

NOT_ENOUGH_CAPITAL: DC.B $09
                    DC.B 'You dont have enough capital to make this purchase! ', 0 
                    
FAILED:             DC.B $0D,$0A, $0D,$0A, $0D,$0A
                    DC.B '                _____  _               _   _ ______ _______',$0D,$0A           
                    DC.B '               |  __ \| |        /\   | \ | |  ____|__   __|',$0D,$0A           
                    DC.B '               | |__) | |       /  \  |  \| | |__     | |',$0D,$0A               
                    DC.B '               |  ___/| |      / /\ \ | . ` |  __|    | |',$0D,$0A               
                    DC.B '               | |    | |____ / ____ \| |\  | |____   | |',$0D,$0A               
                    DC.B '        _____  |_|___ |______/_/____\_\_|_\_|______|  |_|_______ _____',$0D,$0A  
                    DC.B '       |  __ \|  ____|/ ____|__   __|  __ \ / __ \ \   / /  ____|  __ \',$0D,$0A 
                    DC.B '       | |  | | |__  | (___    | |  | |__) | |  | \ \_/ /| |__  | |  | |',$0D,$0A
                    DC.B '       | |  | |  __|  \___ \   | |  |  _  /| |  | |\   / |  __| | |  | |',$0D,$0A
                    DC.B '       | |__| | |____ ____) |  | |  | | \ \| |__| | | |  | |____| |__| |',$0D,$0A
                    DC.B '       |_____/|______|_____/   |_|  |_|  \_\\____/  |_|  |______|_____/',$0D,$0A 
                    DC.B $0D,$0A,$0D,$0A,$0D,$0A
                    DC.B '  Congratulations on Destroying The World you have destroyed',$0D,$0A,$0D,$0A
                    DC.B '  everything!. Natural diasters have increase globally and millions',$0D,$0A,$0D,$0A
                    DC.B '  are dying each day. You shouldve planet more trees.', 0
                    
WON_TEXT:           DC.B $0D,$0A, $0D,$0A, $0D,$0A
                    DC.B '                                _______________',$0D,$0A
                    DC.B '                               |@@@@|     |####|',$0D,$0A
                    DC.B '                               |@@@@|     |####|',$0D,$0A
                    DC.B '                               |@@@@|     |####|',$0D,$0A
                    DC.B '                               \@@@@|     |####/',$0D,$0A
                    DC.B '                                \@@@|     |###/',$0D,$0A
                    DC.B '                                 `@@|_____|##`',$0D,$0A
                    DC.B '                                      (O)',$0D,$0A
                    DC.B '                                   .-``````-.',$0D,$0A
                    DC.B '                                 .`  * * *  `.',$0D,$0A
                    DC.B '                                :  *       *  :',$0D,$0A
                    DC.B '                               : ~ N O B E L ~ :',$0D,$0A
                    DC.B '                               : ~ P R I Z E ~ :',$0D,$0A
                    DC.B '                                :  *       *  :',$0D,$0A
                    DC.B '                                 `.  * * *  .`',$0D,$0A
                    DC.B '                                   `-.....-`',$0D,$0A
                    DC.B $0D,$0A,$0D,$0A,$0D,$0A
                    DC.B '  Congratulations on Saving The World you have done yourself Proud!',$0D,$0A,$0D,$0A
                    DC.B '  Because of your momentous achievement you have been offer the Nobel Prize!',$0D,$0A,$0D,$0A
                    DC.B '  You have also been gifted 1000 Windmills to continue on your Journey.', 0

    END    START













*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
