# HD-RP
San Andreas Multiplayer - High Desert Roleplay server
06/10/2016

# Background:
This script was developed to a server that was released by the name "High Desert Prison Roleplay", this server had its peeks regarding playerbase, it was amazing and fun to develop and play.
This is a complete gamemode, its 100% working at this current status and can run on a server (just needs to switch back to the old inventory system, its real easy to do) without any special problems.

# Why I'm releasing it:
When I started developing this, I was still 21, young and ambitious about running and scripting a server - focusing on a prison roleplay as I really enjoyed the concept. I am 23 today, and I have almost no free time to continue develop this, and to be honest the last time I wrote a line in this script I was 22.
So I decided to give everyone a chance to enjoy this and maybe even run this on their server to enjoy with friends, this is an amazing server with lots of unique features that took me a fair amount of time to develop.

# Features:

# Factions:
High Desert Correctional Officers (Guards)
High Desert Emergency Medical Team (EMT)

# Gangs:
Total adjustable gang system, up to 6 official gang leaders (appointed by admins), anything from rank names to gang color and clothes can be changed via dialog menu.

# Scripted Jobs:
Table Cleaner (Food trays spawn randomly at the cafeteria, you need to pick them up and wash them at the sink)
Trash Man (Garbage spawns inside bins [also players can throw items into the bins to fill them] and players need to empty the bins from the trash)
Laundry Worker (You get a pile of dirty clothes and you take them to a washing machine, when its done you need to put them in the right stack)

# Script Features:
• Custom mapping with all needed things to run a prison server.
• Basic anti-hack system.
• Working GUI inventory system.
• Administrator password that is set outside of the game (need to edit the .ini file)
• Fully dynamic saving system. (Skin, health&armour, weapons, items, drugs and so on)
• New players register to the server have to fill an RP quiz that needs to be checked either by an admin or a helper, only if approved they get teleported to the server. (PICTURE)
• 5 level administrator system.
• Forum/Nickname system for Administrators.
• Helper system (with /helpme and more)
• Head of Helpers position, can track helpers and appoint/demote new helpers.
• Personal payday system, each player got a 60 minute counter in order to get a payday.
• Code redeem system. (give out a single use code to someone that you set what it gives/takes/grants - good for prizes and new player gift codes)
• Realistic weapon system & damages. (Big weapons are showing up on the player, only one weapon on the player and up to 3 total in the inventory, can't scroll the weapon, fire-arm damages are set to very high)
• Knife wound system. (If you get stabbed there is a chance you will bleed, only guards/emt's can apply a bandage on you, if you won't treat your bleeding or keep getting stabbed further you will die from bleeding)
• Unique donator status and system.
• Prison ID system. (/showprisonid)
• Advanced cell system. (Admins can create cells everywhere, cells have inventory to deposit and withdraw items/money/weapons from, guards can shake down cells)
• Complete Correctional Officer system with custom gear and an entire floor with interrogation & chill rooms.
• Fully working isolation. (Guards take someone and put them in a cell that only they can open using /door, and they decide when to release the prisoner)
• Shop system at the prison interior entrance.
• Actor NPC's spread around the prison, along with a black market smuggler that sells illegal parts for crafting, a corrupt cop that sells illegal products to official gang members and more. (PICTURE)
• Every player that an admin executed a command on him gets written inside a text file. (scriptfiles/PlayerUCP)
• Everything is logged, everything...
• Drugs system. (roll joints, snort and give away drugs)
• Advanced smoking system. (Player taps the ashes off a cigarette while standing still with a cigarette/joint in his hand, mouth/hand placement and more)
• Bench press system. (With 3 difficulty levels, increasing with the player strength)
• Player strength system. (Workout to learn better fightstyles)
• All the sounds that play in the server (gates open, tasers, guards radio, falling, climbing, picking trash, cleaning plates, NPC talk to you and much more) can be heard by all players, making the server feel very alive.
• Clothes system.
• Hunger system.
• Amazing sewer system.
• And Much, much, much, much, much, much more. (About 50 more features)

# Administrator commands (level 5):
Code:
/aduty /a /ha /gotoprison /(un)mute /getmaskname /kick /arevive /spec(off) /(un)freeze /slap /check /checkinv /checkwarnings.
/checkcell /checkweapons /am /reportmute /goto /get /setinterior /setvirtualworld /go /send /(un)ajail /gotocell /set /answerapp.
/checkapps /reviewapp /acceptreport /skick /fixjob /toggleooc /(un)ban /warn /setweather /(stop)trackpms /respawnvehicles /hiddenadmin
/gotopos /(un)banip /offlineban /offlineajail /giveitem /giveweapon /makegangleader /forcepc /resetgang /applications
/setdonator /cc /spawncar /explode /makehelepr /makeleader /createcell(2) /setcelllevel /gmx /reloadmap /makeadmin /hostname
/setaname /removeaccount
FUN COMMANDS:
/playmusicp /playmusica.
Head of Helpers commands:
Code:
/makehelper /checkhelpmes
Helper commands:
Code:
/hduty /hc /ha /unfreeze /hset /hpm /accepthelpme /answerapp /checkapps /rewviewapp
You have my full permission to run, edit, change and update this gamemode, the only thing I'm asking is leaving the credits in the gamemode for everyones hard work.

# Download:
Download the ZIP.

# Running:
1) Extract the files in a clean 037r2 folder.
2) Open server.cfg, change "rcon_password 12345678" save & close.
3) Go to scriptfiles/Accounts/ .
4) Edit "First_Last.ini" file name to a desired name. (ex; Marco_Simpson.ini)
5) Open the file you just edited, find "Password=" "AdminCode=" (default set to 123456) and edit them to your values, avoid using the same password for your admin code.
6) Run the server.
7) Login with your details and type /admincode (yourcode), ex; /admincode 123456.
Have fun! 

# Credits:
Naruto_Emilio - for originally releasing the Blueberry Prison gamemode, this what inspired me and what I learned on prison roleplay gamemodes based on his scripting, which turned out to be an amazing project.
Bronny
Ecko
Sparkie
Sanguine
& more

