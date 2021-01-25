#include <a_samp>
#include <sii>
#include <zcmd>
#include <sscanf2>
#include <streamer>
#include <irc>
#include <foreach>
#include <n_callbacks>

#undef MAX_PLAYERS
#define MAX_PLAYERS 50
#define MAX_CELLS            100
#define MAX_GANGS              7
#define MAX_ATTACHED_OBJECTS   1000

#define SERVER_MOTD "Welcome to High Desert Roleplay [www.HD-RP.net]."
#define SERVER_GM_TEXT "HD-RP 0.3.1 [BETA]"
/*
CREATED & SCRIPTED & MAPPED BY MARCO - http://forum.sa-mp.com/member.php?u=181058
*/

new gate;
new gydoor;
new prsgate;
new docdoor;
new docdoorarm;
new Text:BENCH;
new Text:BENCH_NAME;
new Text:BENCH_INFO;

new gatestatus;
new gymdoor;
new staffdoor;
new stafdoor1;
new stafdoor2;
new yarddoor1;
new yardoor1;
new docdoor1;
new docdoor2;
new isoldoor0;
new isoldoor1;
new isoldoor2;
new isoldoor3;
new isoldoor4;
new isoldoor5;
new isoldoor6;
new isoldoor7;
new isodoor0;
new isodoor1;
new isodoor2;
new isodoor3;
new isodoor4;
new isodoor5;
new isodoor6;
new isodoor7;
new blockadoor;
new blockador;
new blockbdoor;
new blockbdor;
new blockcdoor;
new blockcdor;
new librarydoor;
new librardoor;
new prisongate;
new prisongateclickable;
new kitchenknife;
new kitchencounter;
new kitchknife;


//==============================================================================
//                      		Colours
//==============================================================================
#define COLOUR_IRC 				0x0066CCFF
#define COLOUR_INFO 			0x00FFFFFF
#define COLOUR_SYSTEM 			0xFF0000FF
#define COLOUR_ADMIN 			0xCC00CCFF
#define COLOUR_PM 				0xFFFF2AFF
#define GREY            0xCECECEFF
#define WHITE           0xFFFFFFFF
#define RED             0xFF1919AA
#define PURPLE			0xCC00FFAA
#define DISPATCH_COLOR  0xFF9900AA
#define ACTION_COLOR 	0xC2A2DAAA
#define GREEN           0x33AA33AA
#define LIGHT_GREEN		0x70C470AA
#define DARK_GREEN		0x006600AA
#define OWNER_RED		0xFF3300AA
#define ORANGE          0xFF9900AA
#define GUARDS_RADIO	0x008FFFAA
#define LIGHT_BLUE      0x008FFFAA
#define BLUE			0x0000ffAA
#define LIGHT_RED		0xFF3030AA
#define DOCTORS_RADIO   0xFF499EAA
#define PINK            0xFF499EAA
#define EMERALD         0x4AFFABAA
#define GOLD            0xFFD700AA
#define SILVER          0x666666AA
#define BRONZE          0xA56729AA
#define YELLOW			0xFFCC00AA
#define LIGHT_GREY		0xD4D4BFAA
#define DARK_GREY		0x414140AA
#define CMD_COLOR		0x75A3A3AA

//==============================================================================
//                                  Configuration
//==============================================================================
#define VOICE_TO_CHAT           true // true: The players will need voice on IRC to send their messages to in-game. | false: The players do not need voice on IRC in order to send their messages to in-game.
#define IRC_SERVER 				"irc server" // The IRC server you want to connect to (SA:MP's "official" one (ran by betatesters) is irc.focogaming.com).
#define IRC_PORT 				6667 // The IRC port you want to connect to (Standard port is 6667 (or 8067)).
#define IRC_CHANNEL 			"#USER" // The main channel (the bots will only idle in here).
#define IRC_ECHO_CHANNEL 		"#USER" // The echo channel (the bots will echo chat messages and so on into here).
#define IRC_AECHO_CHANNEL 		"#User" // The admin echo channel (the bots will echo admin stuff into here like IPs and so on).
#define MAX_BOTS                3 // How many bots should the script try to connect? (Remember: Most IRC servers have a connection limit of 5. Connecting more than that will lead to a ban from the server).
#define BOT_NICKNAME            "user" // The username the bots will use followed by 2 square brackets with numbers in it (f.ex. TrollIRC[1], TrollIRC[2], TrollIRC[3], etc.).
#define BOT_REALNAME            "user" // The "realname" of the IRC bots (will only be visible in a /whois).
#define BOT_USERNAME            "user" // The name that will be infront of the hostname (username@hostname).
#define BOT_PASSWORD            "pass" // The password that the IRC bots will use for registering/logging in.
#define BOT_EMAIL   			"mail" // The e-mail that the IRC bots will use upon registration (and if you ever forget the password for the IRC bots, lol).
#define IRC_CONNECT_DELAY 		5 // Time to wait between connecting each bot (in seconds).
#define IRC_CONNECT_ATTEMPTS 	5 // How many attempts it will try to connect to the IRC server.
#define IRC_REGISTER_DELAY  	30000 // Time to wait before registering each bot (in ms).

//==============================================================================
//                      Variables/Macros
//==============================================================================
#undef MAX_PLAYER_NAME
#define MAX_PLAYER_NAME 24
#define MAX_SELLERS 20
new gGroupID, gBotID[MAX_BOTS char], CMDSString[1048], FALSE = false, pName[MAX_PLAYERS][MAX_PLAYER_NAME], PlayerIP[MAX_PLAYERS][16];
#define IRC_GroupSayEx(%0,%1,%2,%3) do{CMDSString = ""; format(CMDSString, sizeof(CMDSString), %2, %3); IRC_GroupSay(%0, %1, CMDSString);}while(FALSE)
#define IRC_GroupNoticeEx(%0,%1,%2,%3) do{CMDSString = ""; format(CMDSString, sizeof(CMDSString), %2, %3); IRC_GroupNotice(%0, %1, CMDSString);}while(FALSE)
#define SendMSG(%0,%1,%2,%3) do{CMDSString = ""; format(CMDSString, sizeof(CMDSString), %2, %3); SendClientMessage(%0, %1, CMDSString);}while(FALSE)
#define SendMSGToAll(%0,%1,%2) do{CMDSString = ""; format(CMDSString, sizeof(CMDSString), %1, %2); SendClientMessageToAll(%0, CMDSString);}while(FALSE)
new HiddenAdmin[MAX_PLAYERS];
new PlayerInCell[MAX_PLAYERS];
new InPrison[MAX_PLAYERS];
new PNewReg[MAX_PLAYERS];
new NewRegQuestion[MAX_PLAYERS];
new NewRegAwaiting[MAX_PLAYERS];
new PlayerAFK[MAX_PLAYERS];
new AFKTime[MAX_PLAYERS];
new AntiPayCheckSpam[MAX_PLAYERS];
new AFKTimeKeeper[MAX_PLAYERS];
new UnmaskedName[MAX_PLAYER_NAME][MAX_PLAYERS];
new Masked[MAX_PLAYERS];
new MaskName[MAX_PLAYERS];
new AwaitingHelper[MAX_PLAYERS];
new AwaitingAdmin[MAX_PLAYERS];
new AwaitingReport[MAX_PLAYERS];
new MaskedName[MAX_PLAYER_NAME][MAX_PLAYERS];
new Text3D:MaskID[MAX_PLAYERS];
new Float:DutyHealth[MAX_PLAYERS], Float:DutyArmour[MAX_PLAYERS];
new PlayerText3D:MaskRealName[MAX_PLAYERS];
new HoldingTray[MAX_PLAYERS];
new HoldingObject[MAX_PLAYERS];
new UsingDisher[MAX_PLAYERS];
new PMsTracked[MAX_PLAYERS];
new TrackPMs[MAX_PLAYERS];
new PlayerSitting[MAX_PLAYERS];
new RopeUsed;
new AwaitingApplications;
new ApplicationsMOTD[128];
new ApplicationsAllowed;
new PlayerClimbingRope[MAX_PLAYERS];
new CurrentSkin[MAX_PLAYERS];
new HackerKick[MAX_PLAYERS];
new ExamWrong[MAX_PLAYERS];
new TrashAmount[MAX_PLAYERS];
new AdminCodeTry[MAX_PLAYERS];
new AdminCommandTry[MAX_PLAYERS];
new PlayerPayDayT[MAX_PLAYERS];
new INV_SEL_ITM[MAX_PLAYERS];
new INV_SEL_WEP[MAX_PLAYERS];
new PFishing[MAX_PLAYERS];
new PFishingT[MAX_PLAYERS];
new PFishingCT[MAX_PLAYERS];
new PFishingCP[MAX_PLAYERS];
new IsolationVW;
new AutoPM[MAX_PLAYERS][128];
new AjailReason[MAX_PLAYERS][128];
//---------------------- Small Inventory Global Player Variables ----------------- //
new pSmokeAnim[MAX_PLAYERS];
new pCraftWindow[MAX_PLAYERS];
new CRF_ITM1[MAX_PLAYERS];
new CRF_ITM1A[MAX_PLAYERS];
new CRF_ITM2[MAX_PLAYERS];
new CRF_ITM2A[MAX_PLAYERS];
new CRF_ITM3[MAX_PLAYERS];
new CRF_ITM3A[MAX_PLAYERS];
new CRF_ITM4[MAX_PLAYERS];
new CRF_ITM4A[MAX_PLAYERS];
new CRF_ITM5[MAX_PLAYERS];
new CRF_ITM5A[MAX_PLAYERS];
new CRF_ITM6[MAX_PLAYERS];
new CRF_ITM6A[MAX_PLAYERS];
new CRF_ITM7[MAX_PLAYERS];
new CRF_ITM7A[MAX_PLAYERS];
new CRF_ITM8[MAX_PLAYERS];
new CRF_ITM8A[MAX_PLAYERS];
new CRF_ITM9[MAX_PLAYERS];
new CRF_ITM9A[MAX_PLAYERS];
new CRF_ITM10[MAX_PLAYERS];
new CRF_ITM10A[MAX_PLAYERS];
/* ============================================================================= */
//Dialogs defines

#define DIALOG_REGISTER     1
#define DIALOG_LOGIN        2
#define DIALOG_GENDER       3
#define DIALOG_AGE          4
#define DIALOG_QUIZ1        5
#define DIALOG_QUIZ2        6
#define DIALOG_QUIZ3        7
#define DIALOG_QUIZ4        8
#define DIALOG_QUIZ5        9
#define DIALOG_QUIZ6       10
#define DIALOG_QUIZ7       11
#define DIALOG_REASONS     12
#define DIALOG_HELP        13
#define DIALOG_NEWPW       14
#define DIALOG_ACCENT      15
#define DIALOG_LOCKER      16
#define DIALOG_WITHDRAW    17
#define DIALOG_DEPOSIT     18
#define DIALOG_CLOTHES1    19
#define DIALOG_ADJUSTGANG  21
#define DIALOG_GANGNAME    22
#define DIALOG_GANGMOTD    23
#define DIALOG_RANK1NAME   24
#define DIALOG_RANK2NAME   25
#define DIALOG_RANK3NAME   26
#define DIALOG_RANK4NAME   27
#define DIALOG_RANK5NAME   28
#define DIALOG_RANK6NAME   29
#define DIALOG_GANGCOLOR   30
#define DIALOG_RANK1SKIN   31
#define DIALOG_RANK2SKIN   32
#define DIALOG_RANK3SKIN   33
#define DIALOG_RANK4SKIN   34
#define DIALOG_RANK5SKIN   35
#define DIALOG_RANK6SKIN   36
#define DIALOG_FEMALESKIN  37
#define DIALOG_DLOCKER     38
#define DIALOG_GLOCKER     39
#define DIALOG_EQUIPMENT   40
#define DIALOG_STORE       41
#define DIALOG_ADMINCMDS   42
#define DIALOG_TICKET	   43
#define DIALOG_EXAM0	   44
#define DIALOG_EXAM1T1	   45
#define DIALOG_EXAM1T2	   46
#define DIALOG_EXAM1T3	   47
#define DIALOG_EXAM1Q1	   48
#define DIALOG_EXAM1Q2	   49
#define DIALOG_EXAM1Q3	   50
#define DIALOG_EXAM1Q4	   51
#define DIALOG_GYM		   90
#define DIALOG_BM0		   91
#define DIALOG_BM1		   92
#define DIALOG_BM2		   93
#define DIALOG_MSG       8888

//Attached Objects Index defines

#define INDEX_GARBAGE   1
#define INDEX_ARMOUR    2
#define INDEX_LIGHT     3
#define INDEX_TASER     4

// Textdraw defines

new Text: ServerNameTextDraw;
new PlayerText:Serverurl[MAX_PLAYERS];
new Text: AnimationTextDraw;
new Text: SecurityCameraTextDraw;
new PlayerText:ClothesShop1[MAX_PLAYERS];
new PlayerText:ClothesShop2[MAX_PLAYERS];
new PlayerText:ClothesShop3[MAX_PLAYERS];
new PlayerText:ClothesShop4[MAX_PLAYERS];
new PlayerText:ClothesShop5[MAX_PLAYERS];
new PlayerText:ClothesShop6[MAX_PLAYERS];
new PlayerText:ClothesShop7[MAX_PLAYERS];
new PlayerText:PRNID01[MAX_PLAYERS];
new PlayerText:PRNID02[MAX_PLAYERS];
new PlayerText:PRNID03[MAX_PLAYERS];
new PlayerText:PRNID04[MAX_PLAYERS];
new PlayerText:PRNID05[MAX_PLAYERS];
new PlayerText:PRNID06[MAX_PLAYERS];
new PlayerText:PRNID07[MAX_PLAYERS];
new PlayerText:PRNID08[MAX_PLAYERS];
new PlayerText:PRNID09[MAX_PLAYERS];
new PlayerText:PRNID10[MAX_PLAYERS];
new PlayerText:PRNID11[MAX_PLAYERS];
new PlayerText:PRNID12[MAX_PLAYERS];

//==============================================================================
//                      		INVENTORY TEXTDRAWS
//==============================================================================

new PlayerText:INV_BG1[MAX_PLAYERS];
new PlayerText:INV_BG2[MAX_PLAYERS];
new PlayerText:INV_BG3[MAX_PLAYERS];
new PlayerText:INV_BG4[MAX_PLAYERS];
new PlayerText:INV_BG5[MAX_PLAYERS];
new PlayerText:ITM1_STR_NAME[MAX_PLAYERS];
new PlayerText:ITM1_PIC_WEP[MAX_PLAYERS];
new PlayerText:ITM1_STR_AMMO[MAX_PLAYERS];
new PlayerText:INV_BG6[MAX_PLAYERS];
new PlayerText:INV_BG7[MAX_PLAYERS];
new PlayerText:ITM2_STR_NAME[MAX_PLAYERS];
new PlayerText:ITM2_PIC_WEP[MAX_PLAYERS];
new PlayerText:ITM2_STR_AMMO[MAX_PLAYERS];
new PlayerText:INV_BG8[MAX_PLAYERS];
new PlayerText:INV_BG9[MAX_PLAYERS];
new PlayerText:ITM3_STR_NAME[MAX_PLAYERS];
new PlayerText:ITM3_PIC_WEP[MAX_PLAYERS];
new PlayerText:ITM3_STR_AMMO[MAX_PLAYERS];
new PlayerText:INV_NAM_STR[MAX_PLAYERS];
new PlayerText:INV_CLO_BUT[MAX_PLAYERS];
new PlayerText:INV_BG10[MAX_PLAYERS];
new PlayerText:INV_BG11[MAX_PLAYERS];
new PlayerText:INV_BG12[MAX_PLAYERS];
new PlayerText:INV_BG13[MAX_PLAYERS];
new PlayerText:INV_BG14[MAX_PLAYERS];
new PlayerText:INV_BG15[MAX_PLAYERS];
new PlayerText:INV_BG16[MAX_PLAYERS];
new PlayerText:INV_BG17[MAX_PLAYERS];
new PlayerText:INV_BG18[MAX_PLAYERS];
new PlayerText:INV_BG19[MAX_PLAYERS];
new PlayerText:INV_SLOT1_IMG[MAX_PLAYERS];
new PlayerText:INV_SLOT2_IMG[MAX_PLAYERS];
new PlayerText:INV_SLOT3_IMG[MAX_PLAYERS];
new PlayerText:INV_SLOT4_IMG[MAX_PLAYERS];
new PlayerText:INV_SLOT5_IMG[MAX_PLAYERS];
new PlayerText:INV_SLOT6_IMG[MAX_PLAYERS];
new PlayerText:INV_SLOT7_IMG[MAX_PLAYERS];
new PlayerText:INV_SLOT8_IMG[MAX_PLAYERS];
new PlayerText:INV_SLOT9_IMG[MAX_PLAYERS];
new PlayerText:INV_SLOT10_IMG[MAX_PLAYERS];
new PlayerText:INV_AMO1_STR[MAX_PLAYERS];
new PlayerText:INV_AMO2_STR[MAX_PLAYERS];
new PlayerText:INV_AMO3_STR[MAX_PLAYERS];
new PlayerText:INV_AMO4_STR[MAX_PLAYERS];
new PlayerText:INV_AMO5_STR[MAX_PLAYERS];
new PlayerText:INV_AMO6_STR[MAX_PLAYERS];
new PlayerText:INV_AMO7_STR[MAX_PLAYERS];
new PlayerText:INV_AMO8_STR[MAX_PLAYERS];
new PlayerText:INV_AMO9_STR[MAX_PLAYERS];
new PlayerText:INV_AMO10_STR[MAX_PLAYERS];
new PlayerText:INV_BG20[MAX_PLAYERS];
new PlayerText:INV_BG21[MAX_PLAYERS];
new PlayerText:INV_BG22[MAX_PLAYERS];
new PlayerText:INV_BG23[MAX_PLAYERS];
new PlayerText:INV_USE_BTN[MAX_PLAYERS];
new PlayerText:INV_DROP_BTN[MAX_PLAYERS];
new PlayerText:INV_CRAFT_BTN[MAX_PLAYERS];
new PlayerText:INV_PRV_IMG[MAX_PLAYERS];
new PlayerText:INV_PRV_STR[MAX_PLAYERS];
new PlayerText:INV_STAT1_STR[MAX_PLAYERS];
new PlayerText:INV_STAT2_STR[MAX_PLAYERS];
new PlayerText:INV_STAT3_STR[MAX_PLAYERS];
//==============================================================================
//                      		CRAFTING - INVENTORY TEXTDRAWS
//==============================================================================
new PlayerText:CRF_BG1[MAX_PLAYERS];
new PlayerText:CRF_BG2[MAX_PLAYERS];
new PlayerText:CRF_BG3[MAX_PLAYERS];
new PlayerText:CRF_ITM1_STR[MAX_PLAYERS];
new PlayerText:CRF_ITM2_STR[MAX_PLAYERS];
new PlayerText:CRF_ITM3_STR[MAX_PLAYERS];
new PlayerText:CRF_ITM4_STR[MAX_PLAYERS];
new PlayerText:CRF_ITM5_STR[MAX_PLAYERS];
new PlayerText:CRF_ITM6_STR[MAX_PLAYERS];
new PlayerText:CRF_ITM7_STR[MAX_PLAYERS];
new PlayerText:CRF_ITM8_STR[MAX_PLAYERS];
new PlayerText:CRF_ITM9_STR[MAX_PLAYERS];
new PlayerText:CRF_ITM10_STR[MAX_PLAYERS];
new PlayerText:CRF_BG4[MAX_PLAYERS];
new PlayerText:CRF_BG5[MAX_PLAYERS];
new PlayerText:CRF_BG6[MAX_PLAYERS];
new PlayerText:CRF_MET_STR[MAX_PLAYERS];
new PlayerText:CRF_WOD_STR[MAX_PLAYERS];
new PlayerText:CRF_CRF_STR[MAX_PLAYERS];
new PlayerText:CRF_BG7[MAX_PLAYERS];
new PlayerText:CRF_CRF_BTN[MAX_PLAYERS];

//==============================================================================
//                      		Actors
//==============================================================================
new ACTKitchen1;
new ACTShop1;
new ACTShop2;
new ACTGuard1;
new ACTGuard2;
new ACTGym1;
new ACTBMDealer;
new ACTBMSmuggler;

//==============================================================================
// Server defines


// Systems

enum SellerInfo
{
	Cloth,
	Wood,
	Metal,
	RMetal,
	GunP,
}

enum ServerOption
{
	OOCStatus,
	PHMulti,
	PCMulti,
}


new SellerStat[MAX_SELLERS][SellerInfo];
new ServerStat[ServerOption];
// Player Stats

enum PlayerInfo
{
	 Password[128],
	 Logged,
	 Gender,
	 Age,
	 Money,
	 LastSkin,
	 Float: Health,
	 Float: Armour,
	 Float: LastX,
	 Float: LastY,
	 Float: LastZ,
	 Float: LastA,
	 LastInt,
	 LastVW,
	 LastIP[21],
	 FullyRegistered,
	 Spawned,
	 Reason[128],
	 TogOOC,
	 TogPM,
	 WrongPw,
	 Accent[128],
	 PlayingHours,
	 JobID,
	 HoursInJob,
	 PlayingMinutes,
	 Paycheck,
	 LockerMoney,
	 AbleToCollectGarbage,
	 AbleToCleanTables,
	 AbleToCollectFood,
	 CollectingGarbage,
	 CleaningTables,
	 CleaningCells,
	 JobID1ReloadTime,
	 JobID2ReloadTime,
	 JobID3ReloadTime,
	 JobID4ReloadTime,
	 JobID4CHP,
	 JobID4BOX,
	 AdminLevel,
	 AdminCode[128],
	 AdminLogged,
	 HelperLevel,
	 HelpmesAnswered,
	 hMuted,
	 ReportReloadTime,
	 HelpmeReloadTime,
	 StartingFightWith,
	 FightTimer,
     LastLoginSecond,
     LastLoginMinute,
     LastLoginHour,
     LastLoginDay,
     LastLoginMonth,
     LastLoginYear,
     GangID,
     GangRank,
     BeingInvitedToGang,
     GetDrugsReloadTime,
     GetWeapReloadTime,
     Pot,
     Crack,
     Slot0,
     Slot1,
     Slot2,
     Slot3,
     Slot4,
     Slot5,
     Slot6,
     Slot7,
     Slot8,
     Slot9,
     Slot10,
     Slot11,
	 FactionID,
	 FactionRank,
	 BeingInvitedToFaction,
	 HasCell,
	 Cell,
	 GuardDuty,
	 DoctorDuty,
	 Float: DeathPosX,
	 Float: DeathPosY,
	 Float: DeathPosZ,
	 DeathWeapon,
	 DeathAmmo,
	 Dead,
	 BleedingToDeath,
	 HospitalTime,
	 InHospital,
	 AnimsPreloaded,
	 Kills,
	 Deaths,
	 Taser,
	 BeingDragged,
	 BeingDraggedBy,
	 Cuffed,
	 Tased,
	 InIsolatedCell,
	 InIsolatedCellTime,
	 Lighter,
	 UsingPotReloadTime,
	 UsingCrackReloadTime,
	 Cigars,
	 Dices,
	 PlasticBags,
	 UsingLoopingAnims,
	 HandShakeStyle,
	 HandShakeTarget,
	 SecurityCameraStatus,
	 SecurityCameraNumber,
	 Muted,
	 MuteTime,
	 ReportMuted,
	 AdminPrisoned,
	 AdminPrisonedTime,
	 Banned,
	 TimesKicked,
	 TimesBanned,
	 Warnings,
	 Warn1[60],
	 Warn2[60],
	 BannedReason,
	 Specing,
	 BeingSpeced,
	 BeingSpecedBy,
	 SpecingID,
	 StatPWR,
	 StatINT,
	 Paper,
	 Joint,
	 DonLV,
	 Aname,
	 DeathT,
	 ADuty,
	 HDuty,
	 JRACD,
	 JRCD,
	 JSCD,
	 CUCD,
	 CSCD,
	 BPUSE,
	 BPDIF,
	 BPCD,
	 BPACD,
	 BPANM,
	 BPNMB,
	 BPBAR,
	 NameChangeTicket,
	 BleedingWound,
	 LogoutCuffs,
	 Answer1[128],
	 Answer2[128],
	 Answer3[128],
	 Answer4[128],
	 Answer5[128],
	 WeaponSlot0,
	 WeaponSlot1,
	 WeaponSlot2,
	 WeaponSlot0Ammo,
	 WeaponSlot1Ammo,
	 WeaponSlot2Ammo,
	 WeaponPocketCD,
	 FightStyle,
	 INV_SLOT1,
	 INV_SLOT1A,
	 INV_SLOT2,
	 INV_SLOT2A,
	 INV_SLOT3,
	 INV_SLOT3A,
	 INV_SLOT4,
	 INV_SLOT4A,
	 INV_SLOT5,
	 INV_SLOT5A,
	 INV_SLOT6,
	 INV_SLOT6A,
	 INV_SLOT7,
	 INV_SLOT7A,
	 INV_SLOT8,
	 INV_SLOT8A,
	 INV_SLOT9,
	 INV_SLOT9A,
	 INV_SLOT10,
	 INV_SLOT10A,
	 MetSkill,
	 WodSkill,
	 CrfSkill,
	 MetSkillXP,
	 WodSkillXP,
	 CrfSkillXP,
}

new PlayerStat[MAX_PLAYERS][PlayerInfo];

enum weapons
{
    Melee,
    Thrown,
    Pistols,
    Shotguns,
    SubMachine,
    Assault,
    Rifles,
    Heavy,
    Handheld,
}
new Weapons[MAX_PLAYERS][weapons];

//Specing Info

enum SpecInfo
{
	 Float: SpecX,
	 Float: SpecY,
	 Float: SpecZ,
	 SpecInt,
	 SpecVW,
}
new Spec[MAX_PLAYERS][SpecInfo];

//Server General Settings

enum ServerInfo
{
	 PMsStatus,
	 RingStatus,
	 LoadedCells,
	 CurrentGMX,
	 DoorStatus1,
	 DoorStatus2,
	 DoorStatus3,
	 StopTalkingAnimation,

}
new Server[ServerInfo];


//Cells Info

enum CellInfo
{
    CellPrice,
    CellOwner[128],
    CellLevel,
    Float:ExteriorX,
    Float:ExteriorY,
    Float:ExteriorZ,
    Float:InteriorX,
    Float:InteriorY,
    Float:InteriorZ,
    Owned,
    VW,
    Locked,
	CellPot,
	CellCrack,
	CellWeap1,
	CellWeap2,
    Text3D: TextLabel,
    PickupID,
}
new CellStat[MAX_CELLS][CellInfo];

enum GangInfo
{
    GangFile[60],
    GangName[60],
    Leader[60],
    Members,
	Rank1[128],
	Rank2[128],
	Rank3[128],
	Rank4[128],
	Rank5[128],
	Rank6[128],
	MOTD[128],
	Color,
	Skin1,
	Skin2,
	Skin3,
	Skin4,
	Skin5,
	Skin6,
	fSkin,
}
new GangStat[MAX_CELLS][GangInfo];


//Checkpoints defines
new TableCheckpoint1;
new TableCheckpoint2;
new TableCheckpoint3;
new TableCheckpoint4;
new TableCheckpoint5;
new TableCheckpoint6;
new TableCheckpoint7;
new TableCheckpoint8;
new TableCheckpoint9;
new TableCheckpoint10;
new TableCheckpoint11;
new TableCheckpoint12;
new TableCheckpoint13;
new TableCheckpoint14;

//Objects defines

new BenchPress1Used;
new BenchPress2Used;
new BenchPress3Used;
new Sink1Used;
new Sink2Used;
new FoodTray1;
new FoodTray2;
new FoodTray3;
new FoodTray4;
new FoodTray5;
new FoodTray6;
new FoodTray7;
new FoodTray8;
new FoodTray9;
new FoodTray10;
new FoodTray11;
new FoodTrayCounter;
new TableTrashCounter;
new Table1Spot0Object1;
new Table1Spot0Object2;
new Table1Spot1Object1;
new Table1Spot1Object2;
new Table1Spot2Object1;
new Table1Spot2Object2;
new Table1Spot3Object1;
new Table1Spot3Object2;
new Table2Spot0Object1;
new Table2Spot0Object2;
new Table2Spot1Object1;
new Table2Spot1Object2;
new Table2Spot2Object1;
new Table2Spot2Object2;
new Table2Spot3Object1;
new Table2Spot3Object2;
new Table3Spot0Object1;
new Table3Spot0Object2;
new Table3Spot1Object1;
new Table3Spot1Object2;
new Table3Spot2Object1;
new Table3Spot2Object2;
new Table3Spot3Object1;
new Table3Spot3Object2;
new Table4Spot0Object1;
new Table4Spot0Object2;
new Table4Spot1Object1;
new Table4Spot1Object2;
new Table4Spot2Object1;
new Table4Spot2Object2;
new Table4Spot3Object1;
new Table4Spot3Object2;
new Table5Spot0Object1;
new Table5Spot0Object2;
new Table5Spot1Object1;
new Table5Spot1Object2;
new Table5Spot2Object1;
new Table5Spot2Object2;
new Table5Spot3Object1;
new Table5Spot3Object2;
new Table1Spot0Used;
new Table1Spot1Used;
new Table1Spot2Used;
new Table1Spot3Used;
new Table2Spot0Used;
new Table2Spot1Used;
new Table2Spot2Used;
new Table2Spot3Used;
new Table3Spot0Used;
new Table3Spot1Used;
new Table3Spot2Used;
new Table3Spot3Used;
new Table4Spot0Used;
new Table4Spot1Used;
new Table4Spot2Used;
new Table4Spot3Used;
new Table5Spot0Used;
new Table5Spot1Used;
new Table5Spot2Used;
new Table5Spot3Used;
new Text3D:Trash1Label;
new Text3D:Trash2Label;
new Text3D:Trash3Label;
new Text3D:Trash4Label;
new Text3D:Trash5Label;
new Text3D:Trash6Label;
new Text3D:Trash7Label;
new Trash1Trash;
new Trash2Trash;
new Trash3Trash;
new Trash4Trash;
new Trash5Trash;
new Trash6Trash;
new Trash7Trash;

//Random Spawns

new Float: HospitalSpawns[6][4] =
{
    {1140.6716,-1302.7908,1024.6106},
    {1135.4911,-1302.8441,1024.6106},
    {1138.2471,-1302.6396,1024.6106},
    {1137.9498,-1308.0980,1024.6106},
    {1140.3585,-1307.7469,1024.6106},
    {1135.5750,-1307.9596,1024.6106}
};

//Others

forward NewPlayerData(playerid);
forward StopAudio(playerid);
forward SavePlayerData(playerid);
forward LoadPlayerData(playerid);
forward IsPlayerNearShop();
forward WashingTray(playerid);
forward WaterSplashSound(playerid);

forward OneSecondUpdate();
forward AntiCheat();
forward StopTalkingAnim(playerid);

forward ServerSettings();
forward LoadObjects();
forward LoadPickupsAnd3DTexts();
forward LoadCells();
forward LoadGangs();
forward LoadShops();
forward SaveShops();
forward LoadServerInfo();
forward SaveServerInfo();


forward SendNearByMessage(playerid, color, str[], Float:radius);
forward SendHelperMessage(color, str[]);
forward SendAdminMessage(color, str[]);
forward SendGangMessage(playerid, color, str[]);
forward SendFactionMessage(playerid, color, str[]);

forward ShowStatsForPlayer(playerid,targetid);
forward AdminHelp(playerid,targetid);
forward GarbageBagsRespawn();
forward LoadingObjects(playerid);
forward ToggleCheckpoints(playerid);
forward RemoveTaseEffect(playerid);
forward RemoveDrugEffect(playerid);

forward GiveWeapon(playerid, weaponid);
forward LoadPlayerWeapons(playerid);
forward GetWeaponSlot(playerid, weaponid);
forward ResetWeapons(playerid);
forward ShowPlayerWeaponsNames(playerid, targetid);

forward PreloadAnimLib(playerid, animlib[]);
forward ApplyLoopingAnimation(playerid,animlib[],animname[], Float:Speed, looping, lockx, locky, lockz, lp);
forward StopLoopingAnimation(playerid);

forward Teleport(playerid, type);
forward Float:GetDistanceBetweenPlayers(p1,p2);


#if defined FILTERSCRIPT


#else



main()
{
	print("\n----------------------------------");
	print("High Desert Roleplay v0.3.1 [BETA]");
	print("Created, scripted and mapped by Marco");
	print("----------------------------------\n");
}


#endif

public OnGameModeInit()
{
	new str1[128];
	TrashCanTrashUpdate();
    gatestatus = 0;
	gymdoor = 0;
	prisongate = 0;
	yardoor1 = 0;
	docdoor = 1;
	docdoorarm = 1;
	prisongateclickable = 1;
	staffdoor = 1;
	blockadoor = 0;
	blockbdoor = 0;
	blockcdoor = 0;
	librarydoor = 0;
	isoldoor0 = 1;
	isoldoor1 = 1;
	isoldoor2 = 1;
	isoldoor3 = 1;
	isoldoor4 = 1;
	isoldoor5 = 1;
	isoldoor6 = 1;
	isoldoor7 = 1;
	kitchenknife = 1;
	Table1Spot0Used = 0;
	Table1Spot1Used = 0;
	Table1Spot2Used = 0;
	Table1Spot3Used = 0;
	Table2Spot0Used = 0;
	Table2Spot1Used = 0;
	Table2Spot2Used = 0;
	Table2Spot3Used = 0;
	Table3Spot0Used = 0;
	Table3Spot1Used = 0;
	Table3Spot2Used = 0;
	Table3Spot3Used = 0;
	Table4Spot0Used = 0;
	Table4Spot1Used = 0;
	Table4Spot2Used = 0;
	Table4Spot3Used = 0;
	Table5Spot0Used = 0;
	Table5Spot1Used = 0;
	Table5Spot2Used = 0;
	Table5Spot3Used = 0;
	RopeUsed = 0;
	Trash1Trash = 0;
	Trash2Trash = 0;
	Trash3Trash = 0;
	Trash4Trash = 0;
	Trash5Trash = 0;
	Trash6Trash = 0;
	Trash7Trash = 0;
	IsolationVW = 0;
	format(str1, sizeof(str1), "Trash Can\n[%d] / [50]", Trash1Trash);
	Trash1Label = Create3DTextLabel(str1, WHITE, 440.2632, 1571.0500, 1000.6298, 8.0, 0, 0);
	format(str1, sizeof(str1), "Trash Can\n[%d] / [50]", Trash2Trash);
	Trash2Label = Create3DTextLabel(str1, WHITE, 440.2632, 1571.0500, 1000.6298, 8.0, 0, 0);
	format(str1, sizeof(str1), "Trash Can\n[%d] / [50]", Trash3Trash);
	Trash3Label = Create3DTextLabel(str1, WHITE, 440.2632, 1571.0500, 1000.6298, 8.0, 0, 0);
	format(str1, sizeof(str1), "Trash Can\n[%d] / [50]", Trash4Trash);
	Trash4Label = Create3DTextLabel(str1, WHITE, 440.2632, 1571.0500, 1000.6298, 8.0, 0, 0);
	format(str1, sizeof(str1), "Trash Can\n[%d] / [50]", Trash5Trash);
	Trash5Label = Create3DTextLabel(str1, WHITE, 440.2632, 1571.0500, 1000.6298, 8.0, 0, 0);
	format(str1, sizeof(str1), "Trash Can\n[%d] / [50]", Trash6Trash);
	Trash6Label = Create3DTextLabel(str1, WHITE, 440.2632, 1571.0500, 1000.6298, 8.0, 0, 0);
	format(str1, sizeof(str1), "Trash Can\n[%d] / [50]", Trash7Trash);
	Trash7Label = Create3DTextLabel(str1, WHITE, 440.2632, 1571.0500, 1000.6298, 8.0, 0, 0);
	AwaitingApplications = 0;
	ApplicationsMOTD = "Welcome new registrator, please view the rules and guidlines of the server at www.HD-RP.net.";
	ApplicationsAllowed = 1;
	FoodTrayCounter = 11;
	FoodTray1 = CreateDynamicObject(2767, 444.48050, 1631.99805, 1000.90668,   0.00000, 0.00000, -90.00000);// [1]
	FoodTray2 = CreateDynamicObject(2767, 444.48050, 1631.99805, 1000.91870,   0.00000, 0.00000, -90.00000);// [2]
	FoodTray3 = CreateDynamicObject(2767, 444.48050, 1631.99805, 1000.93268,   0.00000, 0.00000, -90.00000);// [3]
	FoodTray4 = CreateDynamicObject(2767, 444.48050, 1631.99805, 1000.94672,   0.00000, 0.00000, -90.00000);// [4]
	FoodTray5 = CreateDynamicObject(2767, 444.48050, 1631.99805, 1000.95868,   0.00000, 0.00000, -90.00000);// [5]
	FoodTray6 = CreateDynamicObject(2767, 444.48050, 1631.99805, 1000.97070,   0.00000, 0.00000, -90.00000);// [6]
	FoodTray7 = CreateDynamicObject(2767, 444.48050, 1631.99805, 1000.98273,   0.00000, 0.00000, -90.00000);// [7]
	FoodTray8 = CreateDynamicObject(2767, 444.48050, 1631.99805, 1000.99268,   0.00000, 0.00000, -90.00000);// [8]
	FoodTray9 = CreateDynamicObject(2767, 444.48050, 1631.99805, 1001.00269,   0.00000, 0.00000, -90.00000);// [9]
	FoodTray10 = CreateDynamicObject(2767, 444.48050, 1631.99805, 1001.01270,   0.00000, 0.00000, -90.00000);// [10]
	FoodTray11 = CreateDynamicObject(2767, 444.48050, 1631.99805, 1001.02472,   0.00000, 0.00000, -90.00000);// [11]
	kitchknife = CreateDynamicObject(335, 444.0352, 1647.4424, 1000.3264, 90.0000, 0.000, -47.0000);
	
	ACTKitchen1 = CreateActor(168, 445.3616, 1629.5665, 1001.0000, 88.4959);
	ACTShop1 = CreateActor(14, 416.2832, 1639.6379, 1001.0000, 178.7367);
	ACTShop2 = CreateActor(214, 243.4666, 1432.8695, 14.5545, 84.3280);
	ACTGuard1 = CreateActor(71, 271.1217, 1411.4755, 10.4565, 90);
	ACTGuard2 = CreateActor(71, 190.2659, 1464.9944, 10.5859, 271.8518);
	ACTGym1 = CreateActor(80, 442.3324, 1544.3494, 1001.0271, 252.9043);
	ACTBMSmuggler = CreateActor(249, 480.9567,1564.3361,996.6711,354.5759);
	ACTBMDealer = CreateActor(304, 444.6044,1645.3818,994.8571,180.3842);
	ApplyActorAnimation(ACTGuard2, "COP_AMBIENT", "Coplook_loop", 4.0, 1, 0, 0, 0, 0);
	ApplyActorAnimation(ACTGuard1, "COP_AMBIENT", "null", 4.0, 1, 0, 0, 0, 0);
	ApplyActorAnimation(ACTKitchen1, "COP_AMBIENT", "null", 4.0, 1, 0, 0, 0, 0);
	ApplyActorAnimation(ACTShop1, "COP_AMBIENT", "null", 4.0, 1, 0, 0, 0, 0);
	ApplyActorAnimation(ACTShop2, "COP_AMBIENT", "null", 4.0, 1, 0, 0, 0, 0);
	ApplyActorAnimation(ACTGym1, "GYMNASIUM", "gym_shadowbox", 4.0, 1, 0, 0, 0, 0);
	ApplyActorAnimation(ACTBMDealer, "DEALER", "DEALER_IDLE_03", 4.0, 1, 0, 0, 0, 0);
	ApplyActorAnimation(ACTBMSmuggler, "DEALER", "DEALER_IDLE", 4.0, 1, 0, 0, 0, 0);
	
    new string[50];
	for(new bot = 1; bot <= MAX_BOTS; bot++)
	{
		format(string, sizeof(string), "%s[%d]", BOT_NICKNAME, bot);
		gBotID{(bot-1)} = IRC_Connect(IRC_SERVER, IRC_PORT, string, BOT_REALNAME, BOT_USERNAME);
	    IRC_SetIntData(gBotID{(bot-1)}, E_IRC_CONNECT_DELAY, (IRC_CONNECT_DELAY * bot));
	    IRC_SetIntData(gBotID{(bot-1)}, E_IRC_CONNECT_ATTEMPTS, IRC_CONNECT_ATTEMPTS);
 	}
 	gGroupID = IRC_CreateGroup();
    print(">> TrollIRC v1.0: Connection initalized...");
	SetGameModeText(SERVER_GM_TEXT);
	EnableStuntBonusForAll(0);
	DisableInteriorEnterExits();
	ShowPlayerMarkers(0);
	SetTimer("AwaitingApplicationsReminder", 120000, true);
	SetTimer("TableTrashCreator", 200000, true);
	SetTimer("TrashCanTrashCreator", 200000, true);
	SetTimer("KitchenKnife", 900000, true);
	SetTimer("ActorReStream", 30000, true);
	AllowInteriorWeapons(1);
	CreatePickup(1318, 23, -50.6378, -233.5297, 6.7646, -1);
	CreatePickup(1318, 23, 414.3121, 1629.8132, 1001.0384, -1);
	CreatePickup(1318, 23, 207.5492, 1450.0723, 11.6758, -1);
    CreatePickup(1318, 23, 1756.0867, -1576.2657, 1734.9430, -1);
	CreatePickup(1318, 23, 254.0630, 1416.0303, 10.6396, -1); // Yard Dispatch entrance.
	CreatePickup(1318, 23, 249.3878, 1420.4248, 15.7631, -1); // Yard Dispatch exit.
	CreatePickup(1318, 23, 214.7496, 1442.9059, 10.8026, -1); // Garbage room entrance.
	CreatePickup(1318, 23, 210.8880, 1440.8680, 10.8026, -1); // Garbage room exit.
   	CreatePickup(1318, 23, 241.9591, 1441.8044, 13.5197, -1); // Marcos clothing shop enter arrow.
   	CreatePickup(1318, 23, 240.3986, 1438.1689, 14.9021,-1); // Marcos clothing shop exit arrow.
	CreatePickup(1275, 23, 234.2097, 1430.4180, 14.9918,-1); // Marcos clothing shop clothes sign.
   	CreatePickup(1318, 23, -5.1428,-325.2578,5.5, -1); // Marcos store enter arrow.
   	CreatePickup(1318, 23, 662.1767,-573.5,16.5, -1); // Marcos store exit arrow.
   	CreatePickup(1274, 23, 416.2987, 1637.5026, 1001.3114, -1); // Marcos store buying sign.
   	CreatePickup(1318, 23, 1056.4078,2079.5029,10.9,-1); // Marcos warehouse exit arrow.
   	CreatePickup(1318, 23, -10.5172,-269.4385,5.5,-1); // Marcos warehouse enter arrow.
	CreatePickup(1314, 23, 1094.9459,2117.4058,11.0,-1); // Marcos warehouse job icon.
	CreatePickup(1314, 23, 215.9945, 1440.0245, 10.3381, -1); // Marcos garbage job icon.
	CreatePickup(1314, 23, 442.9026,1640.4260,1001.2429,-1); // Marcos table cleaner job icon.
	CreatePickup(1314, 23, 440.4420, 1666.7238, 1001.0000,-1); // Marcos Laundry job icon.
	CreatePickup(1271, 23, 1071.9346,2117.6206,11.2,-1); // Marcos floating box to start warehouse job.
	CreatePickup(1247, 23, 434.2973, 1521.6466, 1001.2737,-1); // Dispatch Interior Star.
	CreatePickup(1247, 23, 459.4351, 1518.0682, 997.0270,-1); // DoC flocker
	CreatePickup(2894, 23, 456.6567, 1615.7222, 1001.0886,-1); // Library metal working
	CreatePickup(1318, 23, 285.8455, 1482.0536, 10.9282, -1); // Yard Tower Entrance Arrow
	Create3DTextLabel("Box pickup.\n/takebox", -1, 1071.9346,2117.6206,11.3, 12.0, 0);
	Create3DTextLabel("Interrogation room #1", -1, 457.3266, 1520.5444, 1005.7665, 12.0, 0, 1);
	Create3DTextLabel("Interrogation room #2", -1, 463.8281, 1520.6005, 1005.8544, 12.0, 0, 1);
	Create3DTextLabel("DEPUTY WARDEN", -1, 470.2101, 1515.3035, 1003.7726, 8.0, 0, 1);
	Create3DTextLabel("WARDEN", -1, 469.8431, 1514.3876, 1003.7726, 8.0, 0, 1);
	Create3DTextLabel("EXECUTIVE ASSISTANT", -1, 470.3064, 1513.5173, 1003.7726, 8.0, 0, 1);
	Create3DTextLabel("Conference Room", -1, 478.7069, 1520.5310, 1005.6629, 12.0, 0, 1);
	Create3DTextLabel("Executive Assistant\nMs. Stephanie Burnett", -1, 471.9819, 1531.4014, 1004.9064, 15.0, 0, 1);
	Create3DTextLabel("Warden", -1, 471.9373, 1537.4092, 1004.9064, 12.0, 0, 1);
	Create3DTextLabel("Briefing Room", -1, 481.8550, 1520.5402, 1005.7125, 12.0, 0, 1);
	Create3DTextLabel("Department of Corrections Offices.", -1, 444.8035, 1525.2498, 1002.7521, 12.0, 0, 1);
	Create3DTextLabel("Place washed trays here.\n/puttray", -1, 444.48050, 1631.99805, 1001.52472, 12.0, 0, 1);
	Create3DTextLabel("Tray Washing Sink\n/washtray", -1, 446.4695,1646.5646,1001.4623, 12.0, 0, 1);
	Create3DTextLabel("Tray Washing Sink\n/washtray", -1, 448.4959,1646.5646,1001.4623, 12.0, 0, 1);
	Create3DTextLabel("Prison", -1, 207.5492, 1450.0723, 11.6758, 12.0, 0, 1);
	Create3DTextLabel("Yard", -1, 414.3121, 1629.8132, 1001.0384, 12.0, 0, 1);
	Create3DTextLabel("Yard", -1, 240.3986, 1438.1689, 14.9021, 12.0, 0, 1);
	Create3DTextLabel("Click here to open the gate.", -1, 271.4011, 1412.3999, 10.4698, 12.0, 0, 1);
	Create3DTextLabel("Cafeteria", -1, 1806.2277, -1584.4825, 5700.4287, 12.0, 0, 1);
	Create3DTextLabel("INMATE Clothing", -1, 241.9591, 1441.8044, 13.5197, 12.0, 0, 1);
	Create3DTextLabel("/climbrope", -1, 224.3376, 1472.9353, 10.6878, 12.0, 0, 1);
	Create3DTextLabel("24/7 STORE\n/buy here", -1, 416.2987, 1637.5026, 1001.3114, 12.0, 0, 1);
	Create3DTextLabel("Warehouse", -1, -10.5172,-269.4385,5.5, 12.0, 0, 1);
	Create3DTextLabel("Duty Locker\n/flocker here.", -1, 459.4351, 1518.0682, 997.0270, 12.0, 0, 1);
	Create3DTextLabel("Buy clothes here.\n/buyclothes", -1, 234.2097, 1430.4180, 14.9918, 17.0, 0, 1);
	Create3DTextLabel("{FFD700}Isolation", -1, 444.3288, 1515.3823, 1002.8110, 17.0, 0, 1);
	Create3DTextLabel("{70C470}Dispatch\n{FFFFFF}/securitycamera here.", -1, 434.2973, 1521.6466, 1001.2737, 10.0, 0, 1);
	Create3DTextLabel("{FF1919}No armed firearms beyond this point!{FFFFFF}\nPlease don't forget to {FF1919}close the door{FFFFFF} behind you.\n      Have a pleasant shift.", -1, 437.9208, 1561.5908, 1001.8438, 7.0, 0, 1);
	Create3DTextLabel("{FF1919}Death Row", -1, 425.8264, 1515.3009, 1002.6763, 17.0, 0, 1);
	Create3DTextLabel("24/7 STORE\n/buy.", -1, 664.8037,-568.4133,16.0863, 17.0, 0, 1);
	Create3DTextLabel("Bench Press\n/liftweights to use.", -1, 219.8464,1476.4989,11.6525, 8.0, 0);
	Create3DTextLabel("Bench Press\n/liftweights to use.", -1, 223.0458,1476.4989,11.6525, 8.0, 0);
	Create3DTextLabel("Bench Press\n/liftweights to use.", -1, 226.0033,1476.4989,11.6525, 8.0, 0);
	Create3DTextLabel("Yard", -1, 249.3878, 1420.4248, 15.7631, 8.0, 0, 1);
	Create3DTextLabel("Yard Dispatch", -1, 254.0630, 1416.0303, 10.6396, 8.0, 0, 1);
	Create3DTextLabel("Yard", -1, 210.8880, 1440.8680, 10.8026, 8.0, 0, 1);
	Create3DTextLabel("Garbage Room", -1, 214.7496, 1442.9059, 10.8026, 8.0, 0, 1);
	Create3DTextLabel("Metal Working\n/study", -1, 456.6567, 1615.7222, 1001.0886, 8.0, 0, 1);
	Create3DTextLabel("Take An Exam Here\n/exam", -1, 451.7633, 1621.9839, 1001.4982, 8.0, 0, 1);
	Create3DTextLabel("Trash Can\n/throwtrash", -1, 211.0933, 1437.4363, 10.8826, 8.0, 0, 1);
	Create3DTextLabel("Trash Can\n/throwtrash", -1, 213.8933, 1437.4363, 10.8826, 8.0, 0, 1);
	Create3DTextLabel("Trash Can\n/throwtrash", -1, 216.5873, 1437.4363, 10.8826, 8.0, 0, 1);
	Create3DTextLabel("{FF1919}/smuggleknife", -1, 444.0352, 1647.4424, 1000.3264, 1.0, 0, 0);
	Create3DTextLabel("Washed Laundry\n/putlaundry", -1, 443.3646, 1663.9672, 1001.0, 8.0, 0, 0);
	Create3DTextLabel("Washed Laundry\n/putlaundry", -1, 445.2638, 1663.8988, 1001.0, 8.0, 0, 0);
	Create3DTextLabel("Washed Laundry\n/putlaundry", -1, 437.5423, 1669.6832, 1001.0, 8.0, 0, 0);
	Create3DTextLabel("Washed Laundry\n/putlaundry", -1, 441.5526, 1663.9672, 1001.0, 8.0, 0, 0);
	Create3DTextLabel("Dirty Laundry\n/putlaundry", -1, 443.9777, 1670.3749, 1001.0, 8.0, 0, 0);
	Create3DTextLabel("Dirty Laundry\n{FFFFFF}/putlaundry", -1, 446.6522, 1667.9740, 1001.0, 8.0, 0, 0);
	Create3DTextLabel("{FFD700}Dirty Laundry Stack\n/picklaundry", -1, 442.2152,1667.7783,1001.2348, 8.0, 0, 0);
	Create3DTextLabel("{FF1919}Gym Instructor\n/fightstyle", -1, 442.3324,1544.3494,1001.8, 8.0, 0, 0);
	//TROLL LABELS
	CreatePickup(1318, 23, 1259.6346, -785.4714, 92.0313, -1); // Secret House Enter.
	CreatePickup(1318, 23, 2468.8425, -1698.3463, 1013.5078, -1); // Secret House Exit.
	Create3DTextLabel("Here lays\nGrossmanit Taylor\n12.01.1854 - 02.09.2012", -1, 899.2562,-1075.9399,24.2969, 8.0, 0, 1);
	Create3DTextLabel("Here lays\nTariq & Jilly California\nUNKNOWN DATE", -1, 877.8582,-1077.8170,24.5843, 8.0, 0, 1);
	Create3DTextLabel("Here lays\nRakesh Darbenkadaurs Kevin Sunbulento\n02.06.1992 - 02.09.2013\nDied by his mother taking his internet.", -1, 880.6002,-1078.1230,24.2969, 8.0, 0, 1);
	Create3DTextLabel("Here lays our beloved\nJake\nUNKNOWN DATE", -1, 875.3404,-1078.1813,24.2969, 8.0, 0, 1);
	Create3DTextLabel("Here lays\nMeron PRS\n21BC - 15.09.2021\nDied by a sudani closing a piston on his head.\nThe big pole represents the piston.", -1, 915.1163,-1108.1670,24.2708, 8.0, 0, 1);
	Create3DTextLabel("Here lays\nDeagle Rason\nMEOW", -1, 881.1899,-1085.3455,24.3040, 8.0, 0, 1);
	Create3DTextLabel("Here lays\nLeBron 'Bron' Taylor(Rason)\n12.01.1974 - 17.01.2013", -1,884.5818,-1084.8048,24.2969, 8.0, 0, 1);
	Create3DTextLabel("Here lays\nDeshawn 'Ice' Taylor\n07.01.1979 - 21.05.2014", -1, 877.8815,-1084.8027,24.2969, 8.0, 0, 1);
	Create3DTextLabel("Here lays\nSmokey\nUNKNOWN DATE", -1, 889.2656,-1084.8063,24.2969, 8.0, 0, 1);
	Create3DTextLabel("Here lays\nRock\nUNKNOWN DATE", -1, 871.6995,-1085.1758,24.2969, 8.0, 0, 1);
	Create3DTextLabel("Here lays\nJay Forrest\nUNKNOWN DATE", -1, 857.5277,-1085.2821,24.2969, 8.0, 0, 1);
	Create3DTextLabel("Here lays\nMike Forrest\nUNKNOWN DATE\nThanks for the Deagle -Bron", -1, 862.9689,-1085.2823,24.2969, 8.0, 0, 1);
	Create3DTextLabel("Here lays\nDouble Wayne\nUNKNOWN DATE", -1, 867.4158,-1085.2827,24.2969, 8.0, 0, 1);
	Create3DTextLabel("Here lays\nJake 'Mr187' Southrerland\nANYDAY\nDied by his own greed for money.", -1, 857.5953,-1093.7350,24.2969, 8.0, 0, 1);
	Create3DTextLabel("Here lays\nMoustache 'SoFreshAndSoClean' Southerland\nUNKNOWN DATE", -1, 848.5858,-1093.5479,24.2969, 8.0, 0, 1);
	Create3DTextLabel("Here lays\nSharon's Weapon License\nUNKNOWN DATE", -1, 843.3284,-1094.0382,24.3040, 8.0, 0, 1);
	Create3DTextLabel("Here lays\nSlim's Nudy Pics\nUNKNOWN DATE", -1, 838.4923,-1094.5759,24.3040, 8.0, 0, 1);
	
	//TextDraws
	ServerNameTextDraw = TextDrawCreate(1.000000, 436.000000, "High Desert Prison Roleplay");
	TextDrawAlignment(ServerNameTextDraw, 0);
	TextDrawBackgroundColor(ServerNameTextDraw, 0x000000ff);
	TextDrawFont(ServerNameTextDraw, 3);
	TextDrawLetterSize(ServerNameTextDraw, 0.270000, 0.899999);
	TextDrawColor(ServerNameTextDraw, 0xffffffff);
	TextDrawSetOutline(ServerNameTextDraw, 1);
	TextDrawSetProportional(ServerNameTextDraw, 1);
	TextDrawSetShadow(ServerNameTextDraw, 1);
	
    BENCH_INFO = TextDrawCreate(580.5 ,132 , "Info");
	TextDrawFont(BENCH_INFO , 0);
	TextDrawLetterSize(BENCH_INFO , 0.4, 1.8000000000000001);
	TextDrawColor(BENCH_INFO , 0xffffffFF);
	TextDrawSetOutline(BENCH_INFO , false);
	TextDrawSetProportional(BENCH_INFO , true);
	TextDrawSetShadow(BENCH_INFO , 2);

	BENCH = TextDrawCreate(580.5 ,170 , "0 / 100");
	TextDrawFont(BENCH , 1);
	TextDrawLetterSize(BENCH , 0.2, 1.4000000000000001);
	TextDrawColor(BENCH , 0x06c48bFF);
	TextDrawSetOutline(BENCH , false);
	TextDrawSetProportional(BENCH , true);
	TextDrawSetShadow(BENCH , 2);
	
	BENCH_NAME = TextDrawCreate(530.5 ,147 , " Bench Presses Made:~n~~n~");
	TextDrawFont(BENCH_NAME , 1);
	TextDrawLetterSize(BENCH_NAME , 0.3, 2.1);
	TextDrawColor(BENCH_NAME , 0x06c48bFF);
	TextDrawSetOutline(BENCH_NAME , false);
	TextDrawSetProportional(BENCH_NAME , true);
	TextDrawSetShadow(BENCH_NAME , 1);
	TextDrawUseBox(BENCH_NAME, 1);
	TextDrawBoxColor(BENCH_NAME, 0x1a1a1aFF);

	AnimationTextDraw = TextDrawCreate(610.0, 400.0, "~r~~k~~PED_SPRINT~ ~w~to stop the animation");
	TextDrawAlignment(AnimationTextDraw, 3);
	TextDrawBackgroundColor(AnimationTextDraw, 0x000000FF);
	TextDrawFont(AnimationTextDraw, 2);
	TextDrawColor(AnimationTextDraw, 0xFFFFFFFF);
    TextDrawSetOutline(AnimationTextDraw,1);
    TextDrawSetProportional(AnimationTextDraw, 1);
    TextDrawSetShadow(AnimationTextDraw, 0);

    SecurityCameraTextDraw = TextDrawCreate(10.0, 320.0, " Press ~b~~k~~PED_DUCK~ ~w~to switch security cameras.");
	TextDrawUseBox(SecurityCameraTextDraw, 1);
	TextDrawBoxColor(SecurityCameraTextDraw,0x222222BB);
	TextDrawLetterSize(SecurityCameraTextDraw,0.25,0.75);
	TextDrawTextSize(SecurityCameraTextDraw,400.0,40.0);
	TextDrawFont(SecurityCameraTextDraw, 2);
	TextDrawSetShadow(SecurityCameraTextDraw,0);
    TextDrawSetOutline(SecurityCameraTextDraw,1);
    TextDrawBackgroundColor(SecurityCameraTextDraw,0x000000FF);
    TextDrawColor(SecurityCameraTextDraw,0xFFFFFFFF);


	//Time
	new Hour, Minute, Second;
    gettime(Hour, Minute, Second);
    SetWorldTime(Hour);


	ServerSettings();
	LoadObjects();
	LoadPickupsAnd3DTexts();
	LoadCells();
	LoadShops();
	LoadServerInfo();
	LoadGangs();

	//Vehicles
    AddStaticVehicle(599, 1816.4260,-1589.3337,13.5469,180.6372,0,1); // Car1
    AddStaticVehicle(599,1817.2520,-1580.4122,13.5469,170.8812,0,1); // Car2
    AddStaticVehicle(431,1820.2531,-1570.2288,13.5484,165.1944,0,1); //  // Bus
    AddStaticVehicle(497,-49.8017,-249.1267,37.0723,359.5442,0,1); // Heli
    AddStaticVehicle(523,-61.5917,-299.6392,4.9990,270.1317,0,0); // Bike1
    AddStaticVehicle(523,-61.5763,-301.0460,5.0009,270.8484,0,0); // Bike2
	return 1;
}





public LoadObjects() // MAPPING
{
gydoor = CreateDynamicObject(19302, 444.2495, 1562.1702, 1001.2301, 0.00000, 0.00000, 180.00000);
prsgate = CreateDynamicObject(988, 272.7830, 1408.4099, 10.5006, 0.00000, 0.00000, 90.00000);
stafdoor1 = CreateDynamicObject(1495, 436.6110, 1561.6997, 999.9951, 0.00000, 0.00000, 180.00000);
stafdoor2 = CreateDynamicObject(1495, 433.6059, 1561.6705, 999.9951, 0.00000, 0.00000, 0.00000);
yarddoor1 = CreateDynamicObject(19303, 198.6041, 1462.0718, 10.8194, 0.00000, 0.00000, 0.00000);
docdoor1 = CreateDynamicObject(19303, 444.8387, 1525.3693, 1001.2167, 0.000, 0.000, -40.0000);
docdoor2 = CreateDynamicObject(19302, 455.6743, 1525.2963, 997.0681, 0.000, 0.000, 90.0000);
blockador = CreateDynamicObject(19302, 430.6795, 1598.7889, 1001.2301, 0.000, 0.000, 90.000);
blockbdor = CreateDynamicObject(19302, 434.3550, 1598.7830, 1001.230, 0.000, 0.000, 90.000);
isodoor0 = CreateDynamicObject(19303, 445.9820, 1494.4187, 1001.2433, 0.0000, 0.0000, -90.000);
isodoor1 = CreateDynamicObject(19303, 462.0121, 1495.5077, 1001.2293, 0.000, 0.000, 90.000);
isodoor2 = CreateDynamicObject(19303, 462.0121, 1492.4537, 1001.2293, 0.000, 0.000, 90.000);
isodoor3 = CreateDynamicObject(19303, 462.0121, 1489.8448, 1001.2293, 0.000, 0.000, -90.000);
isodoor4 = CreateDynamicObject(19303, 462.0121, 1487.4608, 1001.2293, 0.000, 0.000, -90.000);
isodoor5 = CreateDynamicObject(19303, 461.9917, 1498.6859, 1004.7656, 0.000, 0.000, 90.000);
isodoor6 = CreateDynamicObject(19303, 461.9917, 1493.1759, 1004.7656, 0.000, 0.000, 90.000);
isodoor7 = CreateDynamicObject(19303, 461.9917, 1487.6239, 1004.7656, 0.000, 0.000, 90.000);
librardoor = CreateDynamicObject(19303, 439.0195, 1625.5581, 1001.2432, 0.00, 0.00, 42.0000);
blockcdor = CreateDynamicObject(19302, 436.9162, 1653.8390, 1001.2527, 0.00, 0.00, 90.0000);


return 1;
}


/*public GarbageBagsRespawn()
{
	if(GarbageBag1Used == 1)
	{
		GarbageBag1Used = 0;
		Bag1 = CreateDynamicObject(1264,-25.3515,-217.6652,5.4773,0.00000000,0.00000000,0.00000000);
	}
	if(GarbageBag2Used == 1)
	{
		GarbageBag2Used = 0;
		Bag2 = CreateDynamicObject(1264,-8.2990,-233.6059,5.4773,0.00000000,0.00000000,0.00000000);
	}
	if(GarbageBag3Used == 1)
	{
		GarbageBag3Used = 0;
		Bag3 = CreateDynamicObject(1264,16.3477,-255.7691,5.4773,0.00000000,0.00000000,0.00000000);
	}
	if(GarbageBag4Used == 1)
	{
		GarbageBag4Used = 0;
		Bag4 = CreateDynamicObject(1264,16.4836,-265.6946,5.4773,0.00000000,0.00000000,0.00000000);
	}
	if(GarbageBag5Used == 1)
	{
		GarbageBag5Used = 0;
		Bag5 = CreateDynamicObject(1264,-17.9705,-270.4784,5.4773,0.00000000,0.00000000,0.00000000);
	}
	if(GarbageBag6Used == 1)
	{
		GarbageBag6Used = 0;
		Bag6 = CreateDynamicObject(1265,-6.1656,-316.3453,5.4773,0.00000000,0.00000000,0.00000000);
	}
	if(GarbageBag7Used == 1)
	{
		GarbageBag7Used = 0;
		Bag7 = CreateDynamicObject(1265,2.9086,-344.0809,5.4835,0.00000000,0.00000000,0.00000000);
	}
	if(GarbageBag8Used == 1)
	{
		GarbageBag8Used = 0;
		Bag8 = CreateDynamicObject(1265,9.5234,-386.3439,6.5028,0.00000000,0.00000000,0.00000000);
	}
	if(GarbageBag9Used == 1)
	{
		GarbageBag9Used = 0;
		Bag9 = CreateDynamicObject(1265,-23.4145,-343.8364,5.4773,0.00000000,0.00000000,0.00000000);
	}
	return 1;
}*/


public LoadPickupsAnd3DTexts()
{
    printf("Objects Loaded, Loading Pickups and 3D Text Labels...");
	//Pickups:
    CreateDynamicPickup(1318, 23, -70.2152,-223.5770,-50.9922, -1, -1, -1, 50.0); //Cafeteria Int
    CreateDynamicPickup(1318, 23, 1757.8214,-1532.6128,9.4651, -1, -1, -1, 50.0); //Garbage
    CreateDynamicPickup(1239, 23, -77.7249,-223.9873,-50.9922, -1, -1, -1, 50.0); //Table Cleaner Job
    CreateDynamicPickup(1239, 23, -74.0929,-224.1152,-50.9849, -1, -1, -1, 50.0); //Food Supplier Job
    CreateDynamicPickup(1275, 23, 216.2847,-151.7829,-89.7245, -1, -1, -1, 50.0); //Clothes Pickup
    CreateDynamicPickup(1318, 23, -202.2754,-204.9325,14.0696, -1, -1, -1, 50.0); //BPG Prison Int
    CreateDynamicPickup(1240, 23, 442.9503,1629.7429,1001.2893, -1, -1, -1, 50.0); //Cafeteria eatmeal pickup
    CreateDynamicPickup(1240, 23, -196.5461,-209.3007,14.0627, -1, -1, -1, 50.0); //BPG eatmeal pickup
    CreateDynamicPickup(1318, 23, 1776.0771,-1585.0023,1742.4656, -1, -1, -1, 50.0); //BPM Prison Int
    CreateDynamicPickup(1318, 23, 1148.3007,-1318.3501,1023.7019, -1, -1, -1, 50.0); //BPM Prison Ex
    CreateDynamicPickup(1247, 23, 1803.4572,-1532.0161,5700.4287, -1, -1, -1, 50.0); //BPG Locker
    CreateDynamicPickup(1241, 23, 1803.8667,-1529.2509,5700.4287, -1, -1, -1, 50.0); //BPM 3
    CreateDynamicPickup(1247, 23, -200.2844,-208.5212,2.9520, -1, -1, -1, 50.0); //Isolated Cell Point
    CreateDynamicPickup(1318, 23, -27.0908,-379.4108,14.9761, -1, -1, -1, 50.0); //Control Room Int
    CreateDynamicPickup(1318, 23, -30.7525,-361.3723,5.4297, -1, -1, -1, 50.0); //Control Room Ex
    CreateDynamicPickup(1318, 23, -193.3490,-202.5885,2.8724, -1, -1, -1, 50.0); //Isolated Cells Int
    CreateDynamicPickup(1318, 23, 1814.1007,-1535.8702,5700.4287, -1, -1, -1, 50.0); //Isolated Cells Ex
    CreateDynamicPickup(1318, 23, 1760.7429,-1560.5433,9.6643, -1, -1, -1, 50.0);// Prison shop
    CreateDynamicPickup(1314, 23, 412.0197,1562.7104,1001.0000, -1, -1, -1, 50.0); // Prison Lockers
//    CreateDynamicPickup(1279, 23, 2178.0469,1592.6830,1000.0, -1, -1, -1, 50.0); // /getweap or /getdrugs
    CreateDynamicPickup(1314, 23, -59.0605,-225.3862,5.4297, -1, -1, -1, 50.0);



    Create3DTextLabel("Black Market Smuggler\nYou can use /blackmarket here.\n Don't get seen by a guard.",EMERALD,480.9567,1564.3361,997.7,3.0,0);
	Create3DTextLabel("Drugs and Weapons smuggler\nYou can use /getdrugs or /getweap. \n Don't get seen by a guard.",EMERALD,444.6044,1645.3818,996.4,3.0,0);
    // Just 3D Text

    Create3DTextLabel("Prison Locker\nType /locker to open this",GOLD,412.0197,1562.7104,1001.0000 + 0.25,9.0,0,1);

    //Jobs 3D Texts:

    Create3DTextLabel("Garbage Man Job\nType /job join to take this job.",GREEN, 215.9945, 1440.0245, 10.3381 , 9.0, 0, 1);
    Create3DTextLabel("Table Cleaner Job\nType /job join to take this job.",GREEN,442.9026,1640.4260,1001.2429,9.0,0);
    Create3DTextLabel("Laundry Worker Job\nType /job join to take this job.",GREEN,440.4420,1666.7238,1001.0000,9.0,0);
    Create3DTextLabel("Warehouse Worker Job\nType /job join to take this job.",GREEN,1094.9459,2117.4058,11.0 + 0.75,9.0,0);

    //Others
    Create3DTextLabel("/takemeal",WHITE,442.9503,1629.7429,1001.2893,9.0,0,1);//Cafeteria eatmeal pickup
    Create3DTextLabel("/eatmeal",GREEN,-196.5461,-209.3007,14.0627 + 0.75,9.0,0);//BPG eatmeal pickup
    Create3DTextLabel("Department of Corrections locker",GUARDS_RADIO,1803.4572,-1532.0161,5700.4287 + 0.75,9.0,0);//BPG Locker
    Create3DTextLabel("San Andreas Prison Infirmary locker", DOCTORS_RADIO ,1803.8667,-1529.2509,5700.4287 + 0.75,9.0,0);//BPM Locker
	return 1;
}
forward FreezeTimer(playerid);
public FreezeTimer(playerid)
{
	TogglePlayerControllable(playerid,1);
	return 1;
}

public LoadShops()
{
	printf("Loading shops...");
	new c;
	c = 0;
	new ShopFile[25];
	loop:
	format(ShopFile, 25, "Shops/Seller %d.ini", c);
	if(!fexist(ShopFile))
	{
		c++;
		if(c >= 21) return 1;
		goto loop;
	}
	if(INI_Open(ShopFile))
	{
	   SellerStat[c][Cloth] = INI_ReadInt("Cloth");
	   SellerStat[c][Wood] = INI_ReadInt("Wood");
	   SellerStat[c][Metal] = INI_ReadInt("Metal");
	   SellerStat[c][RMetal] = INI_ReadInt("RMetal");
	   SellerStat[c][GunP] = INI_ReadInt("GunP");
	   printf("Loaded seller ID %d.",c);
	   INI_Save();
	   INI_Close();
	   c++;
	   goto loop;
	}
	return 1;
}

public LoadServerInfo()
{
	printf("Loading server info files...");
	new OptionsFile[25];
	format(OptionsFile, 25, "Server/Options.ini");
	if(!fexist(OptionsFile))
	{
		return 1;
	}
	if(INI_Open(OptionsFile))
	{
	   ServerStat[OOCStatus] = INI_ReadInt("OOCStatus");
	   ServerStat[PHMulti] = INI_ReadInt("PHMulti");
	   ServerStat[PCMulti] = INI_ReadInt("PCMulti");
	   print("Loaded server options.");
	   INI_Save();
	   INI_Close();
	}
	return 1;
}

public SaveServerInfo()
{
	printf("Saving server info...");
	new OptionsFile[25];
	format(OptionsFile, 25, "Server/Options.ini");
	if(!fexist(OptionsFile))
	{
		return 1;
	}
	if(INI_Open(OptionsFile))
	{
	   INI_WriteInt("OOCStatus", ServerStat[OOCStatus]);
	   INI_WriteInt("PHMulti", ServerStat[PHMulti]);
	   INI_WriteInt("PCMulti", ServerStat[PCMulti]);
	   print("Server options saved.");
	   INI_Save();
	   INI_Close();
	}
	return 1;
}

public SaveShops()
{
	printf("Saving shops...");
	new c;
	c = 0;
	new ShopFile[25];
	loop:
	format(ShopFile, 25, "Shops/Seller %d.ini", c);
	if(!fexist(ShopFile))
	{
		c++;
		if(c >= 21) return 1;
		goto loop;
	}
	if(INI_Open(ShopFile))
	{
	   INI_WriteInt("Cloth", SellerStat[c][Cloth]);
	   INI_WriteInt("Wood", SellerStat[c][Wood]);
	   INI_WriteInt("Metal", SellerStat[c][Metal]);
	   INI_WriteInt("RMetal", SellerStat[c][RMetal]);
	   INI_WriteInt("GunP", SellerStat[c][GunP]);
	   printf("Saved seller ID %d.",c);
	   INI_Save();
	   INI_Close();
	   c++;
	   goto loop;
	}
	return 1;
}

public LoadCells()
{
    printf("Checkpoints Loaded, Loading Cells...");
    for(new c = 0; c < MAX_CELLS; c++)
    {
		new CellFile[20];
        format(CellFile, 20, "Cells/Cell %d.ini", c);
        if(!fexist(CellFile)) return 0;
        if(INI_Open(CellFile))
	    {
		   new str[128];
           CellStat[c][CellPrice] = INI_ReadInt("Price");
           INI_ReadString(CellStat[c][CellOwner],"Owner", 60);
           CellStat[c][Owned] = INI_ReadInt("Owned");

           CellStat[c][VW] = INI_ReadInt("VW");
           CellStat[c][Locked] = INI_ReadInt("Locked");

           CellStat[c][ExteriorX] = INI_ReadFloat("ExteriorX");
           CellStat[c][ExteriorY] = INI_ReadFloat("ExteriorY");
           CellStat[c][ExteriorZ] = INI_ReadFloat("ExteriorZ");
           CellStat[c][InteriorX] = INI_ReadFloat("InteriorX");
           CellStat[c][InteriorY] = INI_ReadFloat("InteriorY");
           CellStat[c][InteriorZ] = INI_ReadFloat("InteriorZ");

           CellStat[c][CellLevel] = INI_ReadInt("Level");
           CellStat[c][CellPot] = INI_ReadInt("Pot");
           CellStat[c][CellCrack] = INI_ReadInt("Crack");
           CellStat[c][CellWeap1] = INI_ReadInt("Weap1");
           CellStat[c][CellWeap2] = INI_ReadInt("Weap2");

           if(CellStat[c][Owned] == 1)
		   {
               format(str, sizeof(str), "Cell ID %d\nOwner: %s", c, CellStat[c][CellOwner]);
               CellStat[c][TextLabel] = Create3DTextLabel(str, WHITE, CellStat[c][ExteriorX], CellStat[c][ExteriorY], CellStat[c][ExteriorZ] + 0.75, 3.5, 0, 0);
               CellStat[c][PickupID] = CreateDynamicPickup(1272, 23, CellStat[c][ExteriorX], CellStat[c][ExteriorY], CellStat[c][ExteriorZ], 0, -1, -1, 100.0);
           }
		   else
           {
               format(str, sizeof(str), "Cell ID %d\nOwner: %s\nThis Cell is available for $%d.", c, CellStat[c][CellOwner], CellStat[c][CellPrice]);
               CellStat[c][TextLabel] = Create3DTextLabel(str, WHITE, CellStat[c][ExteriorX], CellStat[c][ExteriorY], CellStat[c][ExteriorZ] + 0.75, 3.5, 0, 0);
               CellStat[c][PickupID] = CreateDynamicPickup(1273, 23, CellStat[c][ExteriorX], CellStat[c][ExteriorY], CellStat[c][ExteriorZ], 0, -1, -1, 100.0);
           }

           INI_Save();
           INI_Close();
           Server[LoadedCells]++;
        }
    }
	return 1;
}

public LoadGangs()
{
    printf("Cells Loaded, Loading Gangs...");
    for(new i = 1; i < MAX_GANGS; i++)
    {
        format(GangStat[i][GangFile], 60, "Gangs/Gang %d.ini", i);
        if(INI_Open(GangStat[i][GangFile]))
	    {
           INI_ReadString(GangStat[i][Leader],"Leader",60);
           INI_ReadString(GangStat[i][GangName],"Name",60);
           INI_ReadString(GangStat[i][MOTD],"MOTD", 128);

           INI_ReadString(GangStat[i][Rank1],"Rank1",60);
           INI_ReadString(GangStat[i][Rank2],"Rank2",60);
           INI_ReadString(GangStat[i][Rank3],"Rank3",60);
           INI_ReadString(GangStat[i][Rank4],"Rank4",60);
           INI_ReadString(GangStat[i][Rank5],"Rank5",60);
           INI_ReadString(GangStat[i][Rank6],"Rank6",60);

           GangStat[i][Skin1] = INI_ReadInt("Skin1");
           GangStat[i][Skin2] = INI_ReadInt("Skin2");
           GangStat[i][Skin3] = INI_ReadInt("Skin3");
           GangStat[i][Skin4] = INI_ReadInt("Skin4");
           GangStat[i][Skin5] = INI_ReadInt("Skin5");
           GangStat[i][Skin6] = INI_ReadInt("Skin6");
           GangStat[i][fSkin] = INI_ReadInt("fSkin");

           GangStat[i][Members] = INI_ReadInt("Members");

           GangStat[i][Color] = INI_ReadInt("Color");

           INI_Save();
           INI_Close();
        }
    }
    printf("Gangs Loaded.");
	return 1;
}


public ServerSettings()
{
    SetTimer("OneSecondUpdate", 1000, true);
	SetTimer("TenSecondsUpdate", 10000, true);
    SetTimer("AntiCheat", 100, true);
    SetTimer("GarbageBagsRespawn", 120000, true);
    Server[PMsStatus] = 1;
    Server[RingStatus] = 0;
    Server[LoadedCells] = -1;
    Server[DoorStatus1] = 0;
    Server[DoorStatus2] = 0;
    // Server[DoorStatus3] = 0;
    BenchPress1Used = 0;
    BenchPress2Used = 0;
	Sink1Used = 0;
	Sink2Used = 0;
	return 1;
}


public OnGameModeExit()
{
    print(">> TrollIRC v1.0: Disconnecting IRC bots...");
	for(new bot = 0; bot < MAX_BOTS; bot++)
	IRC_DestroyGroup(gGroupID);
	print(">> TrollIRC v1.0: IRC bots disconnected...");
    return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SpawnPlayer(playerid);
	return 1;
}

public OnPlayerConnect(playerid) // REMOVE MAPPING
{
	RemoveBuildingForPlayer(playerid, 3682, 247.9297, 1461.8594, 33.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 3682, 192.2734, 1456.1250, 33.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 3682, 199.7578, 1397.8828, 33.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 3683, 133.7422, 1356.9922, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3683, 166.7891, 1356.9922, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3683, 166.7891, 1392.1563, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3683, 133.7422, 1392.1563, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3683, 166.7891, 1426.9141, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3683, 133.7422, 1426.9141, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3288, 221.5703, 1374.9688, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3289, 212.0781, 1426.0313, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3290, 218.2578, 1467.5391, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3291, 246.5625, 1435.1953, 9.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 3291, 246.5625, 1410.5391, 9.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 3291, 246.5625, 1385.8906, 9.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 3291, 246.5625, 1361.2422, 9.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 3290, 190.9141, 1371.7734, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3289, 183.7422, 1444.8672, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3289, 222.5078, 1444.6953, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3289, 221.1797, 1390.2969, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3288, 223.1797, 1421.1875, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3683, 133.7422, 1459.6406, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3289, 207.5391, 1371.2422, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3424, 220.6484, 1355.1875, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3424, 221.7031, 1404.5078, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3424, 210.4141, 1444.8438, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3424, 262.5078, 1465.2031, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3259, 220.6484, 1355.1875, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3636, 133.7422, 1356.9922, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3636, 166.7891, 1356.9922, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3256, 190.9141, 1371.7734, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3636, 166.7891, 1392.1563, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3636, 133.7422, 1392.1563, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3258, 207.5391, 1371.2422, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 205.6484, 1394.1328, 10.1172, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 205.6484, 1392.1563, 16.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 205.6484, 1394.1328, 23.7813, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 207.3594, 1390.5703, 19.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 206.5078, 1387.8516, 27.4922, 0.25);
	RemoveBuildingForPlayer(playerid, 3673, 199.7578, 1397.8828, 33.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 3257, 221.5703, 1374.9688, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3258, 221.1797, 1390.2969, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 203.9531, 1409.9141, 16.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 3674, 199.3828, 1407.1172, 35.8984, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 204.6406, 1409.8516, 11.4063, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 206.5078, 1404.2344, 18.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 206.5078, 1400.6563, 22.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 3259, 221.7031, 1404.5078, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 207.3594, 1409.0000, 19.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 3257, 223.1797, 1421.1875, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3258, 212.0781, 1426.0313, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3636, 166.7891, 1426.9141, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3636, 133.7422, 1426.9141, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3255, 246.5625, 1361.2422, 9.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 3255, 246.5625, 1385.8906, 9.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 3255, 246.5625, 1410.5391, 9.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 3258, 183.7422, 1444.8672, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3259, 210.4141, 1444.8438, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3258, 222.5078, 1444.6953, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 16086, 232.2891, 1434.4844, 13.5000, 0.25);
	RemoveBuildingForPlayer(playerid, 3673, 192.2734, 1456.1250, 33.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 3674, 183.0391, 1455.7500, 35.8984, 0.25);
	RemoveBuildingForPlayer(playerid, 3636, 133.7422, 1459.6406, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 196.0234, 1462.0156, 10.1172, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 198.0000, 1462.0156, 16.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 196.0234, 1462.0156, 23.7813, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 180.2422, 1460.3203, 16.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 180.3047, 1461.0078, 11.4063, 0.25);
	RemoveBuildingForPlayer(playerid, 3256, 218.2578, 1467.5391, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 199.5859, 1463.7266, 19.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 181.1563, 1463.7266, 19.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 185.9219, 1462.8750, 18.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 202.3047, 1462.8750, 27.4922, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 189.5000, 1462.8750, 22.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 3255, 246.5625, 1435.1953, 9.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 254.6797, 1451.8281, 27.4922, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 253.8203, 1458.1094, 23.7813, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 255.5313, 1454.5469, 19.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 253.8203, 1456.1328, 16.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 253.8203, 1458.1094, 10.1172, 0.25);
	RemoveBuildingForPlayer(playerid, 3259, 262.5078, 1465.2031, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 254.6797, 1468.2109, 18.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 3673, 247.9297, 1461.8594, 33.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 254.6797, 1464.6328, 22.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 3674, 247.5547, 1471.0938, 35.8984, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 255.5313, 1472.9766, 19.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 252.8125, 1473.8281, 11.4063, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 252.1250, 1473.8906, 16.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 16089, 342.1250, 1431.0938, 5.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 16090, 315.7734, 1431.0938, 5.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 16091, 289.7422, 1431.0938, 5.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 16087, 358.6797, 1430.4531, 11.6172, 0.25);
	RemoveBuildingForPlayer(playerid, 16088, 368.4297, 1431.0938, 5.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 16092, 394.1563, 1431.0938, 5.2734, 0.25);
    if(!IsPlayerNPC(playerid))
    {
		//-------------------------------------------------------------- PLAYER TEXTDRAWS --------------------------------------------------------------
		Serverurl[playerid] = CreatePlayerTextDraw(playerid, 549.000000, 433.000000, "www.hd-rp.net");
		PlayerTextDrawBackgroundColor(playerid, Serverurl[playerid], 255);
		PlayerTextDrawFont(playerid, Serverurl[playerid], 2);
		PlayerTextDrawLetterSize(playerid, Serverurl[playerid], 0.280000, 1.499999);
		PlayerTextDrawColor(playerid, Serverurl[playerid], -1);
		PlayerTextDrawSetOutline(playerid, Serverurl[playerid], 0);
		PlayerTextDrawSetProportional(playerid, Serverurl[playerid], 1);
		PlayerTextDrawSetShadow(playerid, Serverurl[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, Serverurl[playerid], 0);
		
		ClothesShop1[playerid] = CreatePlayerTextDraw(playerid, 198.000000, 150.000000, "I");
		PlayerTextDrawBackgroundColor(playerid, ClothesShop1[playerid], 255);
		PlayerTextDrawFont(playerid, ClothesShop1[playerid], 1);
		PlayerTextDrawLetterSize(playerid, ClothesShop1[playerid], 20.920043, 12.000000);
		PlayerTextDrawColor(playerid, ClothesShop1[playerid], 100);
		PlayerTextDrawSetOutline(playerid, ClothesShop1[playerid], 0);
		PlayerTextDrawSetProportional(playerid, ClothesShop1[playerid], 1);
		PlayerTextDrawSetShadow(playerid, ClothesShop1[playerid], 0);
		PlayerTextDrawSetSelectable(playerid, ClothesShop1[playerid], 0);

		ClothesShop2[playerid] = CreatePlayerTextDraw(playerid, 272.000000, 186.000000, "Would you like to purchase this clothes?");
		PlayerTextDrawBackgroundColor(playerid, ClothesShop2[playerid], 255);
		PlayerTextDrawFont(playerid, ClothesShop2[playerid], 2);
		PlayerTextDrawLetterSize(playerid, ClothesShop2[playerid], 0.130000, 1.000000);
		PlayerTextDrawColor(playerid, ClothesShop2[playerid], -1);
		PlayerTextDrawSetOutline(playerid, ClothesShop2[playerid], 0);
		PlayerTextDrawSetProportional(playerid, ClothesShop2[playerid], 1);
		PlayerTextDrawSetShadow(playerid, ClothesShop2[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, ClothesShop2[playerid], 0);

		ClothesShop3[playerid] = CreatePlayerTextDraw(playerid, 254.000000, 162.000000, "-");
		PlayerTextDrawBackgroundColor(playerid, ClothesShop3[playerid], 255);
		PlayerTextDrawFont(playerid, ClothesShop3[playerid], 1);
		PlayerTextDrawLetterSize(playerid, ClothesShop3[playerid], 10.200002, 2.400000);
		PlayerTextDrawColor(playerid, ClothesShop3[playerid], -1);
		PlayerTextDrawSetOutline(playerid, ClothesShop3[playerid], 0);
		PlayerTextDrawSetProportional(playerid, ClothesShop3[playerid], 1);
		PlayerTextDrawSetShadow(playerid, ClothesShop3[playerid], 0);
		PlayerTextDrawSetSelectable(playerid, ClothesShop3[playerid], 0);

		ClothesShop4[playerid] = CreatePlayerTextDraw(playerid, 273.000000, 228.000000, "ld_otb2:butnb");
		PlayerTextDrawBackgroundColor(playerid, ClothesShop4[playerid], 0);
		PlayerTextDrawFont(playerid, ClothesShop4[playerid], 4);
		PlayerTextDrawLetterSize(playerid, ClothesShop4[playerid], 0.400000, -1.000000);
		PlayerTextDrawColor(playerid, ClothesShop4[playerid], 3315350);
		PlayerTextDrawSetOutline(playerid, ClothesShop4[playerid], 0);
		PlayerTextDrawSetProportional(playerid, ClothesShop4[playerid], 1);
		PlayerTextDrawSetShadow(playerid, ClothesShop4[playerid], 1);
		PlayerTextDrawUseBox(playerid, ClothesShop4[playerid], 1);
		PlayerTextDrawBoxColor(playerid, ClothesShop4[playerid], 255);
		PlayerTextDrawTextSize(playerid, ClothesShop4[playerid], 55.000000, 23.000000);
		PlayerTextDrawSetSelectable(playerid, ClothesShop4[playerid], 1);

		ClothesShop5[playerid] = CreatePlayerTextDraw(playerid, 329.000000, 228.000000, "ld_otb2:butnb");
		PlayerTextDrawBackgroundColor(playerid, ClothesShop5[playerid], 0);
		PlayerTextDrawFont(playerid, ClothesShop5[playerid], 4);
		PlayerTextDrawLetterSize(playerid, ClothesShop5[playerid], 0.400000, -1.000000);
		PlayerTextDrawColor(playerid, ClothesShop5[playerid], 3315350);
		PlayerTextDrawSetOutline(playerid, ClothesShop5[playerid], 0);
		PlayerTextDrawSetProportional(playerid, ClothesShop5[playerid], 1);
		PlayerTextDrawSetShadow(playerid, ClothesShop5[playerid], 1);
		PlayerTextDrawUseBox(playerid, ClothesShop5[playerid], 1);
		PlayerTextDrawBoxColor(playerid, ClothesShop5[playerid], 255);
		PlayerTextDrawTextSize(playerid, ClothesShop5[playerid], 55.000000, 23.000000);
		PlayerTextDrawSetSelectable(playerid, ClothesShop5[playerid], 1);

		ClothesShop6[playerid] = CreatePlayerTextDraw(playerid, 282.000000, 230.000000, "Buy(60$)");
		PlayerTextDrawBackgroundColor(playerid, ClothesShop6[playerid], 255);
		PlayerTextDrawFont(playerid, ClothesShop6[playerid], 2);
		PlayerTextDrawLetterSize(playerid, ClothesShop6[playerid], 0.200000, 1.000000);
		PlayerTextDrawColor(playerid, ClothesShop6[playerid], -1);
		PlayerTextDrawSetOutline(playerid, ClothesShop6[playerid], 0);
		PlayerTextDrawSetProportional(playerid, ClothesShop6[playerid], 1);
		PlayerTextDrawSetShadow(playerid, ClothesShop6[playerid], 0);
		PlayerTextDrawSetSelectable(playerid, ClothesShop6[playerid], 0);

		ClothesShop7[playerid] = CreatePlayerTextDraw(playerid, 337.000000, 230.000000, "Cancel");
		PlayerTextDrawBackgroundColor(playerid, ClothesShop7[playerid], 255);
		PlayerTextDrawFont(playerid, ClothesShop7[playerid], 2);
		PlayerTextDrawLetterSize(playerid, ClothesShop7[playerid], 0.270000, 1.000000);
		PlayerTextDrawColor(playerid, ClothesShop7[playerid], -1);
		PlayerTextDrawSetOutline(playerid, ClothesShop7[playerid], 0);
		PlayerTextDrawSetProportional(playerid, ClothesShop7[playerid], 1);
		PlayerTextDrawSetShadow(playerid, ClothesShop7[playerid], 0);
		PlayerTextDrawSetSelectable(playerid, ClothesShop7[playerid], 0);
		
		PRNID01[playerid] = CreatePlayerTextDraw(playerid, 390.000000, 140.000000, "splash1:splash1");
		PlayerTextDrawBackgroundColor(playerid, PRNID01[playerid], 0);
		PlayerTextDrawFont(playerid, PRNID01[playerid], 4);
		PlayerTextDrawLetterSize(playerid, PRNID01[playerid], 0.500000, 1.000000);
		PlayerTextDrawColor(playerid, PRNID01[playerid], -1);
		PlayerTextDrawSetOutline(playerid, PRNID01[playerid], 0);
		PlayerTextDrawSetProportional(playerid, PRNID01[playerid], 1);
		PlayerTextDrawSetShadow(playerid, PRNID01[playerid], 1);
		PlayerTextDrawUseBox(playerid, PRNID01[playerid], 1);
		PlayerTextDrawBoxColor(playerid, PRNID01[playerid], 255);
		PlayerTextDrawTextSize(playerid, PRNID01[playerid], -150.000000, 108.000000);
		PlayerTextDrawSetSelectable(playerid, PRNID01[playerid], 0);

		PRNID02[playerid] = CreatePlayerTextDraw(playerid, 234.000000, 137.000000, "ld_spac:tvcorn");
		PlayerTextDrawBackgroundColor(playerid, PRNID02[playerid], 0);
		PlayerTextDrawFont(playerid, PRNID02[playerid], 4);
		PlayerTextDrawLetterSize(playerid, PRNID02[playerid], 0.500000, 1.000000);
		PlayerTextDrawColor(playerid, PRNID02[playerid], -1);
		PlayerTextDrawSetOutline(playerid, PRNID02[playerid], 0);
		PlayerTextDrawSetProportional(playerid, PRNID02[playerid], 1);
		PlayerTextDrawSetShadow(playerid, PRNID02[playerid], 1);
		PlayerTextDrawUseBox(playerid, PRNID02[playerid], 1);
		PlayerTextDrawBoxColor(playerid, PRNID02[playerid], 255);
		PlayerTextDrawTextSize(playerid, PRNID02[playerid], 83.000000, 60.000000);
		PlayerTextDrawSetSelectable(playerid, PRNID02[playerid], 0);

		PRNID03[playerid] = CreatePlayerTextDraw(playerid, 234.000000, 251.000000, "ld_spac:tvcorn");
		PlayerTextDrawBackgroundColor(playerid, PRNID03[playerid], 0);
		PlayerTextDrawFont(playerid, PRNID03[playerid], 4);
		PlayerTextDrawLetterSize(playerid, PRNID03[playerid], 0.500000, 1.000000);
		PlayerTextDrawColor(playerid, PRNID03[playerid], -1);
		PlayerTextDrawSetOutline(playerid, PRNID03[playerid], 0);
		PlayerTextDrawSetProportional(playerid, PRNID03[playerid], 1);
		PlayerTextDrawSetShadow(playerid, PRNID03[playerid], 1);
		PlayerTextDrawUseBox(playerid, PRNID03[playerid], 1);
		PlayerTextDrawBoxColor(playerid, PRNID03[playerid], 255);
		PlayerTextDrawTextSize(playerid, PRNID03[playerid], 83.000000, -54.000000);
		PlayerTextDrawSetSelectable(playerid, PRNID03[playerid], 0);

		PRNID04[playerid] = CreatePlayerTextDraw(playerid, 395.000000, 137.000000, "ld_spac:tvcorn");
		PlayerTextDrawBackgroundColor(playerid, PRNID04[playerid], 0);
		PlayerTextDrawFont(playerid, PRNID04[playerid], 4);
		PlayerTextDrawLetterSize(playerid, PRNID04[playerid], 0.500000, 1.000000);
		PlayerTextDrawColor(playerid, PRNID04[playerid], -1);
		PlayerTextDrawSetOutline(playerid, PRNID04[playerid], 0);
		PlayerTextDrawSetProportional(playerid, PRNID04[playerid], 1);
		PlayerTextDrawSetShadow(playerid, PRNID04[playerid], 1);
		PlayerTextDrawUseBox(playerid, PRNID04[playerid], 1);
		PlayerTextDrawBoxColor(playerid, PRNID04[playerid], 255);
		PlayerTextDrawTextSize(playerid, PRNID04[playerid], -80.000000, 62.000000);
		PlayerTextDrawSetSelectable(playerid, PRNID04[playerid], 0);

		PRNID05[playerid] = CreatePlayerTextDraw(playerid, 395.000000, 251.000000, "ld_spac:tvcorn");
		PlayerTextDrawBackgroundColor(playerid, PRNID05[playerid], 0);
		PlayerTextDrawFont(playerid, PRNID05[playerid], 4);
		PlayerTextDrawLetterSize(playerid, PRNID05[playerid], 0.500000, 1.000000);
		PlayerTextDrawColor(playerid, PRNID05[playerid], -1);
		PlayerTextDrawSetOutline(playerid, PRNID05[playerid], 0);
		PlayerTextDrawSetProportional(playerid, PRNID05[playerid], 1);
		PlayerTextDrawSetShadow(playerid, PRNID05[playerid], 1);
		PlayerTextDrawUseBox(playerid, PRNID05[playerid], 1);
		PlayerTextDrawBoxColor(playerid, PRNID05[playerid], 255);
		PlayerTextDrawTextSize(playerid, PRNID05[playerid], -79.000000, -52.000000);
		PlayerTextDrawSetSelectable(playerid, PRNID05[playerid], 0);

		PRNID06[playerid] = CreatePlayerTextDraw(playerid, 262.000000, 143.000000, "%strname");
		PlayerTextDrawBackgroundColor(playerid, PRNID06[playerid], 255);
		PlayerTextDrawFont(playerid, PRNID06[playerid], 1);
		PlayerTextDrawLetterSize(playerid, PRNID06[playerid], 0.370000, 1.200000);
		PlayerTextDrawColor(playerid, PRNID06[playerid], -1);
		PlayerTextDrawSetOutline(playerid, PRNID06[playerid], 1);
		PlayerTextDrawSetProportional(playerid, PRNID06[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, PRNID06[playerid], 0);

		PRNID07[playerid] = CreatePlayerTextDraw(playerid, 248.000000, 160.000000, "Prisoner: #%str");
		PlayerTextDrawBackgroundColor(playerid, PRNID07[playerid], 255);
		PlayerTextDrawFont(playerid, PRNID07[playerid], 1);
		PlayerTextDrawLetterSize(playerid, PRNID07[playerid], 0.200000, 1.000000);
		PlayerTextDrawColor(playerid, PRNID07[playerid], -1);
		PlayerTextDrawSetOutline(playerid, PRNID07[playerid], 1);
		PlayerTextDrawSetProportional(playerid, PRNID07[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, PRNID07[playerid], 0);

		PRNID08[playerid] = CreatePlayerTextDraw(playerid, 248.000000, 171.000000, "Occupation: %str");
		PlayerTextDrawBackgroundColor(playerid, PRNID08[playerid], 255);
		PlayerTextDrawFont(playerid, PRNID08[playerid], 1);
		PlayerTextDrawLetterSize(playerid, PRNID08[playerid], 0.170000, 1.000000);
		PlayerTextDrawColor(playerid, PRNID08[playerid], -1);
		PlayerTextDrawSetOutline(playerid, PRNID08[playerid], 1);
		PlayerTextDrawSetProportional(playerid, PRNID08[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, PRNID08[playerid], 0);

		PRNID09[playerid] = CreatePlayerTextDraw(playerid, 248.000000, 182.000000, "Cell Owner: %str");
		PlayerTextDrawBackgroundColor(playerid, PRNID09[playerid], 255);
		PlayerTextDrawFont(playerid, PRNID09[playerid], 1);
		PlayerTextDrawLetterSize(playerid, PRNID09[playerid], 0.200000, 1.000000);
		PlayerTextDrawColor(playerid, PRNID09[playerid], -1);
		PlayerTextDrawSetOutline(playerid, PRNID09[playerid], 1);
		PlayerTextDrawSetProportional(playerid, PRNID09[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, PRNID09[playerid], 0);

		PRNID10[playerid] = CreatePlayerTextDraw(playerid, 270.000000, 234.000000, "High Desert Prison");
		PlayerTextDrawBackgroundColor(playerid, PRNID10[playerid], 255);
		PlayerTextDrawFont(playerid, PRNID10[playerid], 3);
		PlayerTextDrawLetterSize(playerid, PRNID10[playerid], 0.300000, 1.000000);
		PlayerTextDrawColor(playerid, PRNID10[playerid], -1);
		PlayerTextDrawSetOutline(playerid, PRNID10[playerid], 0);
		PlayerTextDrawSetProportional(playerid, PRNID10[playerid], 1);
		PlayerTextDrawSetShadow(playerid, PRNID10[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, PRNID10[playerid], 0);

		PRNID11[playerid] = CreatePlayerTextDraw(playerid, 323.000000, 150.000000, "FACE_PICTURE");
		PlayerTextDrawBackgroundColor(playerid, PRNID11[playerid], 0);
		PlayerTextDrawFont(playerid, PRNID11[playerid], 5);
		PlayerTextDrawLetterSize(playerid, PRNID11[playerid], 0.500000, 1.000000);
		PlayerTextDrawColor(playerid, PRNID11[playerid], -1);
		PlayerTextDrawSetOutline(playerid, PRNID11[playerid], 0);
		PlayerTextDrawSetProportional(playerid, PRNID11[playerid], 1);
		PlayerTextDrawSetShadow(playerid, PRNID11[playerid], 1);
		PlayerTextDrawUseBox(playerid, PRNID11[playerid], 1);
		PlayerTextDrawBoxColor(playerid, PRNID11[playerid], 255);
		PlayerTextDrawTextSize(playerid, PRNID11[playerid], 92.000000, 98.000000);
		PlayerTextDrawSetPreviewModel(playerid, PRNID11[playerid], 114);
		PlayerTextDrawSetPreviewRot(playerid, PRNID11[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
		PlayerTextDrawSetSelectable(playerid, PRNID11[playerid], 0);

		PRNID12[playerid] = CreatePlayerTextDraw(playerid, 382.000000, 131.000000, "ld_beat:cross");
		PlayerTextDrawBackgroundColor(playerid, PRNID12[playerid], 0);
		PlayerTextDrawFont(playerid, PRNID12[playerid], 4);
		PlayerTextDrawLetterSize(playerid, PRNID12[playerid], 0.500000, 1.000000);
		PlayerTextDrawColor(playerid, PRNID12[playerid], -1778384696);
		PlayerTextDrawSetOutline(playerid, PRNID12[playerid], 0);
		PlayerTextDrawSetProportional(playerid, PRNID12[playerid], 1);
		PlayerTextDrawSetShadow(playerid, PRNID12[playerid], 1);
		PlayerTextDrawUseBox(playerid, PRNID12[playerid], 1);
		PlayerTextDrawBoxColor(playerid, PRNID12[playerid], 255);
		PlayerTextDrawTextSize(playerid, PRNID12[playerid], 16.000000, 18.000000);
		PlayerTextDrawSetSelectable(playerid, PRNID12[playerid], 1);
		
		INV_BG1[playerid] = CreatePlayerTextDraw(playerid, 201.000000, 130.000000, "              ");
		PlayerTextDrawBackgroundColor(playerid, INV_BG1[playerid], 255);
		PlayerTextDrawFont(playerid, INV_BG1[playerid], 1);
		PlayerTextDrawLetterSize(playerid, INV_BG1[playerid], 1.399999, 28.000000);
		PlayerTextDrawColor(playerid, INV_BG1[playerid], -1);
		PlayerTextDrawSetOutline(playerid, INV_BG1[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_BG1[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_BG1[playerid], 1);
		PlayerTextDrawUseBox(playerid, INV_BG1[playerid], 1);
		PlayerTextDrawBoxColor(playerid, INV_BG1[playerid], 170);
		PlayerTextDrawTextSize(playerid, INV_BG1[playerid], 440.000000, -200.000000);
		PlayerTextDrawSetSelectable(playerid, INV_BG1[playerid], 0);

		INV_BG2[playerid] = CreatePlayerTextDraw(playerid, 301.000000, 126.000000, "Inventory");
		PlayerTextDrawBackgroundColor(playerid, INV_BG2[playerid], 255);
		PlayerTextDrawFont(playerid, INV_BG2[playerid], 3);
		PlayerTextDrawLetterSize(playerid, INV_BG2[playerid], 0.280000, 1.000000);
		PlayerTextDrawColor(playerid, INV_BG2[playerid], -1);
		PlayerTextDrawSetOutline(playerid, INV_BG2[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_BG2[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_BG2[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, INV_BG2[playerid], 0);

		INV_BG3[playerid] = CreatePlayerTextDraw(playerid, 201.000000, 257.000000, "              ");
		PlayerTextDrawBackgroundColor(playerid, INV_BG3[playerid], 255);
		PlayerTextDrawFont(playerid, INV_BG3[playerid], 1);
		PlayerTextDrawLetterSize(playerid, INV_BG3[playerid], 1.399999, 13.899998);
		PlayerTextDrawColor(playerid, INV_BG3[playerid], -1);
		PlayerTextDrawSetOutline(playerid, INV_BG3[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_BG3[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_BG3[playerid], 1);
		PlayerTextDrawUseBox(playerid, INV_BG3[playerid], 1);
		PlayerTextDrawBoxColor(playerid, INV_BG3[playerid], 70);
		PlayerTextDrawTextSize(playerid, INV_BG3[playerid], 440.000000, -200.000000);
		PlayerTextDrawSetSelectable(playerid, INV_BG3[playerid], 0);

		INV_BG4[playerid] = CreatePlayerTextDraw(playerid, 200.000000, 184.000000, "(");
		PlayerTextDrawBackgroundColor(playerid, INV_BG4[playerid], 255);
		PlayerTextDrawFont(playerid, INV_BG4[playerid], 0);
		PlayerTextDrawLetterSize(playerid, INV_BG4[playerid], 0.460000, 4.800000);
		PlayerTextDrawColor(playerid, INV_BG4[playerid], -1);
		PlayerTextDrawSetOutline(playerid, INV_BG4[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_BG4[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_BG4[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, INV_BG4[playerid], 0);

		INV_BG5[playerid] = CreatePlayerTextDraw(playerid, 240.000000, 184.000000, ")");
		PlayerTextDrawBackgroundColor(playerid, INV_BG5[playerid], 255);
		PlayerTextDrawFont(playerid, INV_BG5[playerid], 0);
		PlayerTextDrawLetterSize(playerid, INV_BG5[playerid], 0.460000, 4.800000);
		PlayerTextDrawColor(playerid, INV_BG5[playerid], -1);
		PlayerTextDrawSetOutline(playerid, INV_BG5[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_BG5[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_BG5[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, INV_BG5[playerid], 0);

		ITM1_STR_NAME[playerid] = CreatePlayerTextDraw(playerid, 207.000000, 216.000000, "ITM1_STR_NAME");
		PlayerTextDrawBackgroundColor(playerid, ITM1_STR_NAME[playerid], 255);
		PlayerTextDrawFont(playerid, ITM1_STR_NAME[playerid], 2);
		PlayerTextDrawLetterSize(playerid, ITM1_STR_NAME[playerid], 0.109999, 0.799998);
		PlayerTextDrawColor(playerid, ITM1_STR_NAME[playerid], -1);
		PlayerTextDrawSetOutline(playerid, ITM1_STR_NAME[playerid], 0);
		PlayerTextDrawSetProportional(playerid, ITM1_STR_NAME[playerid], 1);
		PlayerTextDrawSetShadow(playerid, ITM1_STR_NAME[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, ITM1_STR_NAME[playerid], 0);

		ITM1_PIC_WEP[playerid] = CreatePlayerTextDraw(playerid, 204.000000, 184.000000, "ITM1_PIC_WEP");
		PlayerTextDrawBackgroundColor(playerid, ITM1_PIC_WEP[playerid], 0);
		PlayerTextDrawFont(playerid, ITM1_PIC_WEP[playerid], 5);
		PlayerTextDrawLetterSize(playerid, ITM1_PIC_WEP[playerid], 0.500000, 1.000000);
		PlayerTextDrawColor(playerid, ITM1_PIC_WEP[playerid], -1);
		PlayerTextDrawSetOutline(playerid, ITM1_PIC_WEP[playerid], 0);
		PlayerTextDrawSetProportional(playerid, ITM1_PIC_WEP[playerid], 1);
		PlayerTextDrawSetShadow(playerid, ITM1_PIC_WEP[playerid], 1);
		PlayerTextDrawUseBox(playerid, ITM1_PIC_WEP[playerid], 1);
		PlayerTextDrawBoxColor(playerid, ITM1_PIC_WEP[playerid], 255);
		PlayerTextDrawTextSize(playerid, ITM1_PIC_WEP[playerid], 53.000000, 61.000000);
		PlayerTextDrawSetPreviewModel(playerid, ITM1_PIC_WEP[playerid], 355);
		PlayerTextDrawSetPreviewRot(playerid, ITM1_PIC_WEP[playerid], 0.000000, -20.000000, 0.000000, 2.000000);
		PlayerTextDrawSetSelectable(playerid, ITM1_PIC_WEP[playerid], 1);

		ITM1_STR_AMMO[playerid] = CreatePlayerTextDraw(playerid, 228.000000, 194.000000, "ITM1_STR_AMMO");
		PlayerTextDrawBackgroundColor(playerid, ITM1_STR_AMMO[playerid], 255);
		PlayerTextDrawFont(playerid, ITM1_STR_AMMO[playerid], 1);
		PlayerTextDrawLetterSize(playerid, ITM1_STR_AMMO[playerid], 0.189998, 0.699998);
		PlayerTextDrawColor(playerid, ITM1_STR_AMMO[playerid], -1);
		PlayerTextDrawSetOutline(playerid, ITM1_STR_AMMO[playerid], 0);
		PlayerTextDrawSetProportional(playerid, ITM1_STR_AMMO[playerid], 1);
		PlayerTextDrawSetShadow(playerid, ITM1_STR_AMMO[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, ITM1_STR_AMMO[playerid], 0);

		INV_BG6[playerid] = CreatePlayerTextDraw(playerid, 200.000000, 214.000000, "(");
		PlayerTextDrawBackgroundColor(playerid, INV_BG6[playerid], 255);
		PlayerTextDrawFont(playerid, INV_BG6[playerid], 0);
		PlayerTextDrawLetterSize(playerid, INV_BG6[playerid], 0.460000, 4.800000);
		PlayerTextDrawColor(playerid, INV_BG6[playerid], -1);
		PlayerTextDrawSetOutline(playerid, INV_BG6[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_BG6[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_BG6[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, INV_BG6[playerid], 0);

		INV_BG7[playerid] = CreatePlayerTextDraw(playerid, 240.000000, 214.000000, ")");
		PlayerTextDrawBackgroundColor(playerid, INV_BG7[playerid], 255);
		PlayerTextDrawFont(playerid, INV_BG7[playerid], 0);
		PlayerTextDrawLetterSize(playerid, INV_BG7[playerid], 0.460000, 4.800000);
		PlayerTextDrawColor(playerid, INV_BG7[playerid], -1);
		PlayerTextDrawSetOutline(playerid, INV_BG7[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_BG7[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_BG7[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, INV_BG7[playerid], 0);

		ITM2_STR_NAME[playerid] = CreatePlayerTextDraw(playerid, 207.000000, 246.000000, "ITM2_STR_NAME");
		PlayerTextDrawBackgroundColor(playerid, ITM2_STR_NAME[playerid], 255);
		PlayerTextDrawFont(playerid, ITM2_STR_NAME[playerid], 2);
		PlayerTextDrawLetterSize(playerid, ITM2_STR_NAME[playerid], 0.109999, 0.799998);
		PlayerTextDrawColor(playerid, ITM2_STR_NAME[playerid], -1);
		PlayerTextDrawSetOutline(playerid, ITM2_STR_NAME[playerid], 0);
		PlayerTextDrawSetProportional(playerid, ITM2_STR_NAME[playerid], 1);
		PlayerTextDrawSetShadow(playerid, ITM2_STR_NAME[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, ITM2_STR_NAME[playerid], 0);

		ITM2_PIC_WEP[playerid] = CreatePlayerTextDraw(playerid, 204.000000, 214.000000, "ITM2_PIC_WEP");
		PlayerTextDrawBackgroundColor(playerid, ITM2_PIC_WEP[playerid], 0);
		PlayerTextDrawFont(playerid, ITM2_PIC_WEP[playerid], 5);
		PlayerTextDrawLetterSize(playerid, ITM2_PIC_WEP[playerid], 0.500000, 1.000000);
		PlayerTextDrawColor(playerid, ITM2_PIC_WEP[playerid], -1);
		PlayerTextDrawSetOutline(playerid, ITM2_PIC_WEP[playerid], 0);
		PlayerTextDrawSetProportional(playerid, ITM2_PIC_WEP[playerid], 1);
		PlayerTextDrawSetShadow(playerid, ITM2_PIC_WEP[playerid], 1);
		PlayerTextDrawUseBox(playerid, ITM2_PIC_WEP[playerid], 1);
		PlayerTextDrawBoxColor(playerid, ITM2_PIC_WEP[playerid], 255);
		PlayerTextDrawTextSize(playerid, ITM2_PIC_WEP[playerid], 53.000000, 61.000000);
		PlayerTextDrawSetPreviewModel(playerid, ITM2_PIC_WEP[playerid], 355);
		PlayerTextDrawSetPreviewRot(playerid, ITM2_PIC_WEP[playerid], 0.000000, -20.000000, 0.000000, 2.000000);
		PlayerTextDrawSetSelectable(playerid, ITM2_PIC_WEP[playerid], 1);

		ITM2_STR_AMMO[playerid] = CreatePlayerTextDraw(playerid, 228.000000, 224.000000, "ITM2_STR_AMMO");
		PlayerTextDrawBackgroundColor(playerid, ITM2_STR_AMMO[playerid], 255);
		PlayerTextDrawFont(playerid, ITM2_STR_AMMO[playerid], 1);
		PlayerTextDrawLetterSize(playerid, ITM2_STR_AMMO[playerid], 0.189998, 0.699998);
		PlayerTextDrawColor(playerid, ITM2_STR_AMMO[playerid], -1);
		PlayerTextDrawSetOutline(playerid, ITM2_STR_AMMO[playerid], 0);
		PlayerTextDrawSetProportional(playerid, ITM2_STR_AMMO[playerid], 1);
		PlayerTextDrawSetShadow(playerid, ITM2_STR_AMMO[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, ITM2_STR_AMMO[playerid], 0);

		INV_BG8[playerid] = CreatePlayerTextDraw(playerid, 200.000000, 244.000000, "(");
		PlayerTextDrawBackgroundColor(playerid, INV_BG8[playerid], 255);
		PlayerTextDrawFont(playerid, INV_BG8[playerid], 0);
		PlayerTextDrawLetterSize(playerid, INV_BG8[playerid], 0.460000, 4.800000);
		PlayerTextDrawColor(playerid, INV_BG8[playerid], -1);
		PlayerTextDrawSetOutline(playerid, INV_BG8[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_BG8[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_BG8[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, INV_BG8[playerid], 0);

		INV_BG9[playerid] = CreatePlayerTextDraw(playerid, 240.000000, 244.000000, ")");
		PlayerTextDrawBackgroundColor(playerid, INV_BG9[playerid], 255);
		PlayerTextDrawFont(playerid, INV_BG9[playerid], 0);
		PlayerTextDrawLetterSize(playerid, INV_BG9[playerid], 0.460000, 4.800000);
		PlayerTextDrawColor(playerid, INV_BG9[playerid], -1);
		PlayerTextDrawSetOutline(playerid, INV_BG9[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_BG9[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_BG9[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, INV_BG9[playerid], 0);

		ITM3_STR_NAME[playerid] = CreatePlayerTextDraw(playerid, 207.000000, 276.000000, "ITM3_STR_NAME");
		PlayerTextDrawBackgroundColor(playerid, ITM3_STR_NAME[playerid], 255);
		PlayerTextDrawFont(playerid, ITM3_STR_NAME[playerid], 2);
		PlayerTextDrawLetterSize(playerid, ITM3_STR_NAME[playerid], 0.109999, 0.799998);
		PlayerTextDrawColor(playerid, ITM3_STR_NAME[playerid], -1);
		PlayerTextDrawSetOutline(playerid, ITM3_STR_NAME[playerid], 0);
		PlayerTextDrawSetProportional(playerid, ITM3_STR_NAME[playerid], 1);
		PlayerTextDrawSetShadow(playerid, ITM3_STR_NAME[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, ITM3_STR_NAME[playerid], 0);

		ITM3_PIC_WEP[playerid] = CreatePlayerTextDraw(playerid, 204.000000, 244.000000, "ITM3_PIC_WEP");
		PlayerTextDrawBackgroundColor(playerid, ITM3_PIC_WEP[playerid], 0);
		PlayerTextDrawFont(playerid, ITM3_PIC_WEP[playerid], 5);
		PlayerTextDrawLetterSize(playerid, ITM3_PIC_WEP[playerid], 0.500000, 1.000000);
		PlayerTextDrawColor(playerid, ITM3_PIC_WEP[playerid], -1);
		PlayerTextDrawSetOutline(playerid, ITM3_PIC_WEP[playerid], 0);
		PlayerTextDrawSetProportional(playerid, ITM3_PIC_WEP[playerid], 1);
		PlayerTextDrawSetShadow(playerid, ITM3_PIC_WEP[playerid], 1);
		PlayerTextDrawUseBox(playerid, ITM3_PIC_WEP[playerid], 1);
		PlayerTextDrawBoxColor(playerid, ITM3_PIC_WEP[playerid], 255);
		PlayerTextDrawTextSize(playerid, ITM3_PIC_WEP[playerid], 53.000000, 61.000000);
		PlayerTextDrawSetPreviewModel(playerid, ITM3_PIC_WEP[playerid], 355);
		PlayerTextDrawSetPreviewRot(playerid, ITM3_PIC_WEP[playerid], 0.000000, -20.000000, 0.000000, 2.000000);
		PlayerTextDrawSetSelectable(playerid, ITM3_PIC_WEP[playerid], 1);

		ITM3_STR_AMMO[playerid] = CreatePlayerTextDraw(playerid, 228.000000, 254.000000, "ITM3_STR_AMMO");
		PlayerTextDrawBackgroundColor(playerid, ITM3_STR_AMMO[playerid], 255);
		PlayerTextDrawFont(playerid, ITM3_STR_AMMO[playerid], 1);
		PlayerTextDrawLetterSize(playerid, ITM3_STR_AMMO[playerid], 0.189998, 0.699998);
		PlayerTextDrawColor(playerid, ITM3_STR_AMMO[playerid], -1);
		PlayerTextDrawSetOutline(playerid, ITM3_STR_AMMO[playerid], 0);
		PlayerTextDrawSetProportional(playerid, ITM3_STR_AMMO[playerid], 1);
		PlayerTextDrawSetShadow(playerid, ITM3_STR_AMMO[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, ITM3_STR_AMMO[playerid], 0);

		INV_NAM_STR[playerid] = CreatePlayerTextDraw(playerid, 200.000000, 126.000000, "INV_NAM_STR");
		PlayerTextDrawBackgroundColor(playerid, INV_NAM_STR[playerid], 50);
		PlayerTextDrawFont(playerid, INV_NAM_STR[playerid], 2);
		PlayerTextDrawLetterSize(playerid, INV_NAM_STR[playerid], 0.200000, 1.000000);
		PlayerTextDrawColor(playerid, INV_NAM_STR[playerid], -206);
		PlayerTextDrawSetOutline(playerid, INV_NAM_STR[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_NAM_STR[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_NAM_STR[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, INV_NAM_STR[playerid], 0);

		INV_CLO_BUT[playerid] = CreatePlayerTextDraw(playerid, 434.000000, 126.000000, "X");
		PlayerTextDrawBackgroundColor(playerid, INV_CLO_BUT[playerid], 0);
		PlayerTextDrawFont(playerid, INV_CLO_BUT[playerid], 2);
		PlayerTextDrawLetterSize(playerid, INV_CLO_BUT[playerid], 0.259999, 1.100000);
		PlayerTextDrawColor(playerid, INV_CLO_BUT[playerid], -16776961);
		PlayerTextDrawSetOutline(playerid, INV_CLO_BUT[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_CLO_BUT[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_CLO_BUT[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, INV_CLO_BUT[playerid], 1);

		INV_BG10[playerid] = CreatePlayerTextDraw(playerid, 261.000000, 78.000000, ".");
		PlayerTextDrawBackgroundColor(playerid, INV_BG10[playerid], 255);
		PlayerTextDrawFont(playerid, INV_BG10[playerid], 3);
		PlayerTextDrawLetterSize(playerid, INV_BG10[playerid], 3.499999, 18.199996);
		PlayerTextDrawColor(playerid, INV_BG10[playerid], -56);
		PlayerTextDrawSetOutline(playerid, INV_BG10[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_BG10[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_BG10[playerid], 0);
		PlayerTextDrawSetSelectable(playerid, INV_BG10[playerid], 0);

		INV_BG11[playerid] = CreatePlayerTextDraw(playerid, 291.000000, 78.000000, ".");
		PlayerTextDrawBackgroundColor(playerid, INV_BG11[playerid], 255);
		PlayerTextDrawFont(playerid, INV_BG11[playerid], 3);
		PlayerTextDrawLetterSize(playerid, INV_BG11[playerid], 3.499999, 18.199996);
		PlayerTextDrawColor(playerid, INV_BG11[playerid], -56);
		PlayerTextDrawSetOutline(playerid, INV_BG11[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_BG11[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_BG11[playerid], 0);
		PlayerTextDrawSetSelectable(playerid, INV_BG11[playerid], 0);

		INV_BG12[playerid] = CreatePlayerTextDraw(playerid, 321.000000, 78.000000, ".");
		PlayerTextDrawBackgroundColor(playerid, INV_BG12[playerid], 255);
		PlayerTextDrawFont(playerid, INV_BG12[playerid], 3);
		PlayerTextDrawLetterSize(playerid, INV_BG12[playerid], 3.499999, 18.199996);
		PlayerTextDrawColor(playerid, INV_BG12[playerid], -56);
		PlayerTextDrawSetOutline(playerid, INV_BG12[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_BG12[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_BG12[playerid], 0);
		PlayerTextDrawSetSelectable(playerid, INV_BG12[playerid], 0);

		INV_BG13[playerid] = CreatePlayerTextDraw(playerid, 351.000000, 78.000000, ".");
		PlayerTextDrawBackgroundColor(playerid, INV_BG13[playerid], 255);
		PlayerTextDrawFont(playerid, INV_BG13[playerid], 3);
		PlayerTextDrawLetterSize(playerid, INV_BG13[playerid], 3.499999, 18.199996);
		PlayerTextDrawColor(playerid, INV_BG13[playerid], -56);
		PlayerTextDrawSetOutline(playerid, INV_BG13[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_BG13[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_BG13[playerid], 0);
		PlayerTextDrawSetSelectable(playerid, INV_BG13[playerid], 0);

		INV_BG14[playerid] = CreatePlayerTextDraw(playerid, 381.000000, 78.000000, ".");
		PlayerTextDrawBackgroundColor(playerid, INV_BG14[playerid], 255);
		PlayerTextDrawFont(playerid, INV_BG14[playerid], 3);
		PlayerTextDrawLetterSize(playerid, INV_BG14[playerid], 3.499999, 18.199996);
		PlayerTextDrawColor(playerid, INV_BG14[playerid], -56);
		PlayerTextDrawSetOutline(playerid, INV_BG14[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_BG14[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_BG14[playerid], 0);
		PlayerTextDrawSetSelectable(playerid, INV_BG14[playerid], 0);

		INV_BG15[playerid] = CreatePlayerTextDraw(playerid, 261.000000, 109.000000, ".");
		PlayerTextDrawBackgroundColor(playerid, INV_BG15[playerid], 255);
		PlayerTextDrawFont(playerid, INV_BG15[playerid], 3);
		PlayerTextDrawLetterSize(playerid, INV_BG15[playerid], 3.499999, 18.199996);
		PlayerTextDrawColor(playerid, INV_BG15[playerid], -56);
		PlayerTextDrawSetOutline(playerid, INV_BG15[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_BG15[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_BG15[playerid], 0);
		PlayerTextDrawSetSelectable(playerid, INV_BG15[playerid], 0);

		INV_BG16[playerid] = CreatePlayerTextDraw(playerid, 291.000000, 109.000000, ".");
		PlayerTextDrawBackgroundColor(playerid, INV_BG16[playerid], 255);
		PlayerTextDrawFont(playerid, INV_BG16[playerid], 3);
		PlayerTextDrawLetterSize(playerid, INV_BG16[playerid], 3.499999, 18.199996);
		PlayerTextDrawColor(playerid, INV_BG16[playerid], -56);
		PlayerTextDrawSetOutline(playerid, INV_BG16[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_BG16[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_BG16[playerid], 0);
		PlayerTextDrawSetSelectable(playerid, INV_BG16[playerid], 0);

		INV_BG17[playerid] = CreatePlayerTextDraw(playerid, 321.000000, 109.000000, ".");
		PlayerTextDrawBackgroundColor(playerid, INV_BG17[playerid], 255);
		PlayerTextDrawFont(playerid, INV_BG17[playerid], 3);
		PlayerTextDrawLetterSize(playerid, INV_BG17[playerid], 3.499999, 18.199996);
		PlayerTextDrawColor(playerid, INV_BG17[playerid], -56);
		PlayerTextDrawSetOutline(playerid, INV_BG17[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_BG17[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_BG17[playerid], 0);
		PlayerTextDrawSetSelectable(playerid, INV_BG17[playerid], 0);

		INV_BG18[playerid] = CreatePlayerTextDraw(playerid, 351.000000, 109.000000, ".");
		PlayerTextDrawBackgroundColor(playerid, INV_BG18[playerid], 255);
		PlayerTextDrawFont(playerid, INV_BG18[playerid], 3);
		PlayerTextDrawLetterSize(playerid, INV_BG18[playerid], 3.499999, 18.199996);
		PlayerTextDrawColor(playerid, INV_BG18[playerid], -56);
		PlayerTextDrawSetOutline(playerid, INV_BG18[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_BG18[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_BG18[playerid], 0);
		PlayerTextDrawSetSelectable(playerid, INV_BG18[playerid], 0);

		INV_BG19[playerid] = CreatePlayerTextDraw(playerid, 381.000000, 109.000000, ".");
		PlayerTextDrawBackgroundColor(playerid, INV_BG19[playerid], 255);
		PlayerTextDrawFont(playerid, INV_BG19[playerid], 3);
		PlayerTextDrawLetterSize(playerid, INV_BG19[playerid], 3.499999, 18.199996);
		PlayerTextDrawColor(playerid, INV_BG19[playerid], -56);
		PlayerTextDrawSetOutline(playerid, INV_BG19[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_BG19[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_BG19[playerid], 0);
		PlayerTextDrawSetSelectable(playerid, INV_BG19[playerid], 0);

		INV_SLOT1_IMG[playerid] = CreatePlayerTextDraw(playerid, 261.000000, 191.000000, "INV_SLOT1_IMG");
		PlayerTextDrawBackgroundColor(playerid, INV_SLOT1_IMG[playerid], 0);
		PlayerTextDrawFont(playerid, INV_SLOT1_IMG[playerid], 5);
		PlayerTextDrawLetterSize(playerid, INV_SLOT1_IMG[playerid], 0.500000, 1.000000);
		PlayerTextDrawColor(playerid, INV_SLOT1_IMG[playerid], -1);
		PlayerTextDrawSetOutline(playerid, INV_SLOT1_IMG[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_SLOT1_IMG[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_SLOT1_IMG[playerid], 1);
		PlayerTextDrawUseBox(playerid, INV_SLOT1_IMG[playerid], 1);
		PlayerTextDrawBoxColor(playerid, INV_SLOT1_IMG[playerid], 255);
		PlayerTextDrawTextSize(playerid, INV_SLOT1_IMG[playerid], 30.000000, 34.000000);
		PlayerTextDrawSetPreviewModel(playerid, INV_SLOT1_IMG[playerid], 18631);
		PlayerTextDrawSetPreviewRot(playerid, INV_SLOT1_IMG[playerid], -20.000000, 0.000000, 150.000000, 0.699999);
		PlayerTextDrawSetSelectable(playerid, INV_SLOT1_IMG[playerid], 1);

		INV_SLOT2_IMG[playerid] = CreatePlayerTextDraw(playerid, 291.000000, 191.000000, "INV_SLOT2_IMG");
		PlayerTextDrawBackgroundColor(playerid, INV_SLOT2_IMG[playerid], 0);
		PlayerTextDrawFont(playerid, INV_SLOT2_IMG[playerid], 5);
		PlayerTextDrawLetterSize(playerid, INV_SLOT2_IMG[playerid], 0.500000, 1.000000);
		PlayerTextDrawColor(playerid, INV_SLOT2_IMG[playerid], -1);
		PlayerTextDrawSetOutline(playerid, INV_SLOT2_IMG[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_SLOT2_IMG[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_SLOT2_IMG[playerid], 1);
		PlayerTextDrawUseBox(playerid, INV_SLOT2_IMG[playerid], 1);
		PlayerTextDrawBoxColor(playerid, INV_SLOT2_IMG[playerid], 255);
		PlayerTextDrawTextSize(playerid, INV_SLOT2_IMG[playerid], 30.000000, 34.000000);
		PlayerTextDrawSetPreviewModel(playerid, INV_SLOT2_IMG[playerid], 18631);
		PlayerTextDrawSetPreviewRot(playerid, INV_SLOT2_IMG[playerid], -20.000000, 0.000000, 150.000000, 0.699999);
		PlayerTextDrawSetSelectable(playerid, INV_SLOT2_IMG[playerid], 1);

		INV_SLOT3_IMG[playerid] = CreatePlayerTextDraw(playerid, 320.000000, 191.000000, "INV_SLOT3_IMG");
		PlayerTextDrawBackgroundColor(playerid, INV_SLOT3_IMG[playerid], 0);
		PlayerTextDrawFont(playerid, INV_SLOT3_IMG[playerid], 5);
		PlayerTextDrawLetterSize(playerid, INV_SLOT3_IMG[playerid], 0.500000, 1.000000);
		PlayerTextDrawColor(playerid, INV_SLOT3_IMG[playerid], -1);
		PlayerTextDrawSetOutline(playerid, INV_SLOT3_IMG[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_SLOT3_IMG[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_SLOT3_IMG[playerid], 1);
		PlayerTextDrawUseBox(playerid, INV_SLOT3_IMG[playerid], 1);
		PlayerTextDrawBoxColor(playerid, INV_SLOT3_IMG[playerid], 255);
		PlayerTextDrawTextSize(playerid, INV_SLOT3_IMG[playerid], 30.000000, 34.000000);
		PlayerTextDrawSetPreviewModel(playerid, INV_SLOT3_IMG[playerid], 18631);
		PlayerTextDrawSetPreviewRot(playerid, INV_SLOT3_IMG[playerid], -20.000000, 0.000000, 150.000000, 0.699999);
		PlayerTextDrawSetSelectable(playerid, INV_SLOT3_IMG[playerid], 1);

		INV_SLOT4_IMG[playerid] = CreatePlayerTextDraw(playerid, 350.000000, 192.000000, "INV_SLOT4_IMG");
		PlayerTextDrawBackgroundColor(playerid, INV_SLOT4_IMG[playerid], 0);
		PlayerTextDrawFont(playerid, INV_SLOT4_IMG[playerid], 5);
		PlayerTextDrawLetterSize(playerid, INV_SLOT4_IMG[playerid], 0.500000, 1.000000);
		PlayerTextDrawColor(playerid, INV_SLOT4_IMG[playerid], -1);
		PlayerTextDrawSetOutline(playerid, INV_SLOT4_IMG[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_SLOT4_IMG[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_SLOT4_IMG[playerid], 1);
		PlayerTextDrawUseBox(playerid, INV_SLOT4_IMG[playerid], 1);
		PlayerTextDrawBoxColor(playerid, INV_SLOT4_IMG[playerid], 255);
		PlayerTextDrawTextSize(playerid, INV_SLOT4_IMG[playerid], 30.000000, 34.000000);
		PlayerTextDrawSetPreviewModel(playerid, INV_SLOT4_IMG[playerid], 18631);
		PlayerTextDrawSetPreviewRot(playerid, INV_SLOT4_IMG[playerid], -20.000000, 0.000000, 150.000000, 0.699999);
		PlayerTextDrawSetSelectable(playerid, INV_SLOT4_IMG[playerid], 1);

		INV_SLOT5_IMG[playerid] = CreatePlayerTextDraw(playerid, 381.000000, 191.000000, "INV_SLOT5_IMG");
		PlayerTextDrawBackgroundColor(playerid, INV_SLOT5_IMG[playerid], 0);
		PlayerTextDrawFont(playerid, INV_SLOT5_IMG[playerid], 5);
		PlayerTextDrawLetterSize(playerid, INV_SLOT5_IMG[playerid], 0.500000, 1.000000);
		PlayerTextDrawColor(playerid, INV_SLOT5_IMG[playerid], -1);
		PlayerTextDrawSetOutline(playerid, INV_SLOT5_IMG[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_SLOT5_IMG[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_SLOT5_IMG[playerid], 1);
		PlayerTextDrawUseBox(playerid, INV_SLOT5_IMG[playerid], 1);
		PlayerTextDrawBoxColor(playerid, INV_SLOT5_IMG[playerid], 255);
		PlayerTextDrawTextSize(playerid, INV_SLOT5_IMG[playerid], 30.000000, 34.000000);
		PlayerTextDrawSetPreviewModel(playerid, INV_SLOT5_IMG[playerid], 18631);
		PlayerTextDrawSetPreviewRot(playerid, INV_SLOT5_IMG[playerid], -20.000000, 0.000000, 150.000000, 0.699999);
		PlayerTextDrawSetSelectable(playerid, INV_SLOT5_IMG[playerid], 1);

		INV_SLOT6_IMG[playerid] = CreatePlayerTextDraw(playerid, 260.000000, 222.000000, "INV_SLOT6_IMG");
		PlayerTextDrawBackgroundColor(playerid, INV_SLOT6_IMG[playerid], 0);
		PlayerTextDrawFont(playerid, INV_SLOT6_IMG[playerid], 5);
		PlayerTextDrawLetterSize(playerid, INV_SLOT6_IMG[playerid], 0.100000, 0.100000);
		PlayerTextDrawColor(playerid, INV_SLOT6_IMG[playerid], -1);
		PlayerTextDrawSetOutline(playerid, INV_SLOT6_IMG[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_SLOT6_IMG[playerid], 0);
		PlayerTextDrawSetShadow(playerid, INV_SLOT6_IMG[playerid], 0);
		PlayerTextDrawUseBox(playerid, INV_SLOT6_IMG[playerid], 1);
		PlayerTextDrawBoxColor(playerid, INV_SLOT6_IMG[playerid], 255);
		PlayerTextDrawTextSize(playerid, INV_SLOT6_IMG[playerid], 30.000000, 34.000000);
		PlayerTextDrawSetPreviewModel(playerid, INV_SLOT6_IMG[playerid], 18631);
		PlayerTextDrawSetPreviewRot(playerid, INV_SLOT6_IMG[playerid], -20.000000, 0.000000, 150.000000, 0.699999);
		PlayerTextDrawSetSelectable(playerid, INV_SLOT6_IMG[playerid], 1);

		INV_SLOT7_IMG[playerid] = CreatePlayerTextDraw(playerid, 289.000000, 221.000000, "INV_SLOT7_IMG");
		PlayerTextDrawBackgroundColor(playerid, INV_SLOT7_IMG[playerid], 0);
		PlayerTextDrawFont(playerid, INV_SLOT7_IMG[playerid], 5);
		PlayerTextDrawLetterSize(playerid, INV_SLOT7_IMG[playerid], 0.100000, 0.100000);
		PlayerTextDrawColor(playerid, INV_SLOT7_IMG[playerid], -1);
		PlayerTextDrawSetOutline(playerid, INV_SLOT7_IMG[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_SLOT7_IMG[playerid], 0);
		PlayerTextDrawSetShadow(playerid, INV_SLOT7_IMG[playerid], 10);
		PlayerTextDrawUseBox(playerid, INV_SLOT7_IMG[playerid], 1);
		PlayerTextDrawBoxColor(playerid, INV_SLOT7_IMG[playerid], 255);
		PlayerTextDrawTextSize(playerid, INV_SLOT7_IMG[playerid], 30.000000, 34.000000);
		PlayerTextDrawSetPreviewModel(playerid, INV_SLOT7_IMG[playerid], 18631);
		PlayerTextDrawSetPreviewRot(playerid, INV_SLOT7_IMG[playerid], -20.000000, 0.000000, 150.000000, 0.699999);
		PlayerTextDrawSetSelectable(playerid, INV_SLOT7_IMG[playerid], 1);

		INV_SLOT8_IMG[playerid] = CreatePlayerTextDraw(playerid, 320.000000, 222.000000, "INV_SLOT8_IMG");
		PlayerTextDrawBackgroundColor(playerid, INV_SLOT8_IMG[playerid], 0);
		PlayerTextDrawFont(playerid, INV_SLOT8_IMG[playerid], 5);
		PlayerTextDrawLetterSize(playerid, INV_SLOT8_IMG[playerid], 0.500000, 1.000000);
		PlayerTextDrawColor(playerid, INV_SLOT8_IMG[playerid], -1);
		PlayerTextDrawSetOutline(playerid, INV_SLOT8_IMG[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_SLOT8_IMG[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_SLOT8_IMG[playerid], 1);
		PlayerTextDrawUseBox(playerid, INV_SLOT8_IMG[playerid], 1);
		PlayerTextDrawBoxColor(playerid, INV_SLOT8_IMG[playerid], 255);
		PlayerTextDrawTextSize(playerid, INV_SLOT8_IMG[playerid], 30.000000, 34.000000);
		PlayerTextDrawSetPreviewModel(playerid, INV_SLOT8_IMG[playerid], 18631);
		PlayerTextDrawSetPreviewRot(playerid, INV_SLOT8_IMG[playerid], -20.000000, 0.000000, 150.000000, 0.699999);
		PlayerTextDrawSetSelectable(playerid, INV_SLOT8_IMG[playerid], 1);

		INV_SLOT9_IMG[playerid] = CreatePlayerTextDraw(playerid, 351.000000, 221.000000, "INV_SLOT9_IMG");
		PlayerTextDrawBackgroundColor(playerid, INV_SLOT9_IMG[playerid], 0);
		PlayerTextDrawFont(playerid, INV_SLOT9_IMG[playerid], 5);
		PlayerTextDrawLetterSize(playerid, INV_SLOT9_IMG[playerid], 0.500000, 1.000000);
		PlayerTextDrawColor(playerid, INV_SLOT9_IMG[playerid], -1);
		PlayerTextDrawSetOutline(playerid, INV_SLOT9_IMG[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_SLOT9_IMG[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_SLOT9_IMG[playerid], 1);
		PlayerTextDrawUseBox(playerid, INV_SLOT9_IMG[playerid], 1);
		PlayerTextDrawBoxColor(playerid, INV_SLOT9_IMG[playerid], 255);
		PlayerTextDrawTextSize(playerid, INV_SLOT9_IMG[playerid], 30.000000, 34.000000);
		PlayerTextDrawSetPreviewModel(playerid, INV_SLOT9_IMG[playerid], 18631);
		PlayerTextDrawSetPreviewRot(playerid, INV_SLOT9_IMG[playerid], -20.000000, 0.000000, 150.000000, 0.699999);
		PlayerTextDrawSetSelectable(playerid, INV_SLOT9_IMG[playerid], 1);

		INV_SLOT10_IMG[playerid] = CreatePlayerTextDraw(playerid, 379.000000, 223.000000, "INV_SLOT10_IMG");
		PlayerTextDrawBackgroundColor(playerid, INV_SLOT10_IMG[playerid], 0);
		PlayerTextDrawFont(playerid, INV_SLOT10_IMG[playerid], 5);
		PlayerTextDrawLetterSize(playerid, INV_SLOT10_IMG[playerid], 0.500000, 1.000000);
		PlayerTextDrawColor(playerid, INV_SLOT10_IMG[playerid], -1);
		PlayerTextDrawSetOutline(playerid, INV_SLOT10_IMG[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_SLOT10_IMG[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_SLOT10_IMG[playerid], 1);
		PlayerTextDrawUseBox(playerid, INV_SLOT10_IMG[playerid], 1);
		PlayerTextDrawBoxColor(playerid, INV_SLOT10_IMG[playerid], 255);
		PlayerTextDrawTextSize(playerid, INV_SLOT10_IMG[playerid], 30.000000, 34.000000);
		PlayerTextDrawSetPreviewModel(playerid, INV_SLOT10_IMG[playerid], 18631);
		PlayerTextDrawSetPreviewRot(playerid, INV_SLOT10_IMG[playerid], -20.000000, 0.000000, 150.000000, 0.699999);
		PlayerTextDrawSetSelectable(playerid, INV_SLOT10_IMG[playerid], 1);

		INV_AMO1_STR[playerid] = CreatePlayerTextDraw(playerid, 261.000000, 194.000000, "INV_AMO1_STR");
		PlayerTextDrawBackgroundColor(playerid, INV_AMO1_STR[playerid], 255);
		PlayerTextDrawFont(playerid, INV_AMO1_STR[playerid], 1);
		PlayerTextDrawLetterSize(playerid, INV_AMO1_STR[playerid], 0.139999, 0.699999);
		PlayerTextDrawColor(playerid, INV_AMO1_STR[playerid], -1);
		PlayerTextDrawSetOutline(playerid, INV_AMO1_STR[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_AMO1_STR[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_AMO1_STR[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, INV_AMO1_STR[playerid], 0);

		INV_AMO2_STR[playerid] = CreatePlayerTextDraw(playerid, 291.000000, 194.000000, "INV_AMO2_STR");
		PlayerTextDrawBackgroundColor(playerid, INV_AMO2_STR[playerid], 255);
		PlayerTextDrawFont(playerid, INV_AMO2_STR[playerid], 1);
		PlayerTextDrawLetterSize(playerid, INV_AMO2_STR[playerid], 0.139999, 0.699999);
		PlayerTextDrawColor(playerid, INV_AMO2_STR[playerid], -1);
		PlayerTextDrawSetOutline(playerid, INV_AMO2_STR[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_AMO2_STR[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_AMO2_STR[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, INV_AMO2_STR[playerid], 0);

		INV_AMO3_STR[playerid] = CreatePlayerTextDraw(playerid, 321.000000, 194.000000, "INV_AMO3_STR");
		PlayerTextDrawBackgroundColor(playerid, INV_AMO3_STR[playerid], 255);
		PlayerTextDrawFont(playerid, INV_AMO3_STR[playerid], 1);
		PlayerTextDrawLetterSize(playerid, INV_AMO3_STR[playerid], 0.139999, 0.699999);
		PlayerTextDrawColor(playerid, INV_AMO3_STR[playerid], -1);
		PlayerTextDrawSetOutline(playerid, INV_AMO3_STR[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_AMO3_STR[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_AMO3_STR[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, INV_AMO3_STR[playerid], 0);

		INV_AMO4_STR[playerid] = CreatePlayerTextDraw(playerid, 351.000000, 194.000000, "INV_AMO4_STR");
		PlayerTextDrawBackgroundColor(playerid, INV_AMO4_STR[playerid], 255);
		PlayerTextDrawFont(playerid, INV_AMO4_STR[playerid], 1);
		PlayerTextDrawLetterSize(playerid, INV_AMO4_STR[playerid], 0.139999, 0.699999);
		PlayerTextDrawColor(playerid, INV_AMO4_STR[playerid], -1);
		PlayerTextDrawSetOutline(playerid, INV_AMO4_STR[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_AMO4_STR[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_AMO4_STR[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, INV_AMO4_STR[playerid], 0);

		INV_AMO5_STR[playerid] = CreatePlayerTextDraw(playerid, 381.000000, 194.000000, "INV_AMO5_STR");
		PlayerTextDrawBackgroundColor(playerid, INV_AMO5_STR[playerid], 255);
		PlayerTextDrawFont(playerid, INV_AMO5_STR[playerid], 1);
		PlayerTextDrawLetterSize(playerid, INV_AMO5_STR[playerid], 0.139999, 0.699999);
		PlayerTextDrawColor(playerid, INV_AMO5_STR[playerid], -1);
		PlayerTextDrawSetOutline(playerid, INV_AMO5_STR[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_AMO5_STR[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_AMO5_STR[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, INV_AMO5_STR[playerid], 0);

		INV_AMO6_STR[playerid] = CreatePlayerTextDraw(playerid, 261.000000, 224.000000, "INV_AMO6_STR");
		PlayerTextDrawBackgroundColor(playerid, INV_AMO6_STR[playerid], 255);
		PlayerTextDrawFont(playerid, INV_AMO6_STR[playerid], 1);
		PlayerTextDrawLetterSize(playerid, INV_AMO6_STR[playerid], 0.139999, 0.699999);
		PlayerTextDrawColor(playerid, INV_AMO6_STR[playerid], -1);
		PlayerTextDrawSetOutline(playerid, INV_AMO6_STR[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_AMO6_STR[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_AMO6_STR[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, INV_AMO6_STR[playerid], 0);

		INV_AMO7_STR[playerid] = CreatePlayerTextDraw(playerid, 291.000000, 224.000000, "INV_AMO7_STR");
		PlayerTextDrawBackgroundColor(playerid, INV_AMO7_STR[playerid], 255);
		PlayerTextDrawFont(playerid, INV_AMO7_STR[playerid], 1);
		PlayerTextDrawLetterSize(playerid, INV_AMO7_STR[playerid], 0.139999, 0.699999);
		PlayerTextDrawColor(playerid, INV_AMO7_STR[playerid], -1);
		PlayerTextDrawSetOutline(playerid, INV_AMO7_STR[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_AMO7_STR[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_AMO7_STR[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, INV_AMO7_STR[playerid], 0);

		INV_AMO8_STR[playerid] = CreatePlayerTextDraw(playerid, 321.000000, 224.000000, "INV_AMO8_STR");
		PlayerTextDrawBackgroundColor(playerid, INV_AMO8_STR[playerid], 255);
		PlayerTextDrawFont(playerid, INV_AMO8_STR[playerid], 1);
		PlayerTextDrawLetterSize(playerid, INV_AMO8_STR[playerid], 0.139999, 0.699999);
		PlayerTextDrawColor(playerid, INV_AMO8_STR[playerid], -1);
		PlayerTextDrawSetOutline(playerid, INV_AMO8_STR[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_AMO8_STR[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_AMO8_STR[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, INV_AMO8_STR[playerid], 0);

		INV_AMO9_STR[playerid] = CreatePlayerTextDraw(playerid, 351.000000, 224.000000, "INV_AMO9_STR");
		PlayerTextDrawBackgroundColor(playerid, INV_AMO9_STR[playerid], 255);
		PlayerTextDrawFont(playerid, INV_AMO9_STR[playerid], 1);
		PlayerTextDrawLetterSize(playerid, INV_AMO9_STR[playerid], 0.139999, 0.699999);
		PlayerTextDrawColor(playerid, INV_AMO9_STR[playerid], -1);
		PlayerTextDrawSetOutline(playerid, INV_AMO9_STR[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_AMO9_STR[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_AMO9_STR[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, INV_AMO9_STR[playerid], 0);

		INV_AMO10_STR[playerid] = CreatePlayerTextDraw(playerid, 381.000000, 224.000000, "INV_AMO10_STR");
		PlayerTextDrawBackgroundColor(playerid, INV_AMO10_STR[playerid], 255);
		PlayerTextDrawFont(playerid, INV_AMO10_STR[playerid], 1);
		PlayerTextDrawLetterSize(playerid, INV_AMO10_STR[playerid], 0.139999, 0.699999);
		PlayerTextDrawColor(playerid, INV_AMO10_STR[playerid], -1);
		PlayerTextDrawSetOutline(playerid, INV_AMO10_STR[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_AMO10_STR[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_AMO10_STR[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, INV_AMO10_STR[playerid], 0);

		INV_BG20[playerid] = CreatePlayerTextDraw(playerid, 261.000000, 7.000000, ".");
		PlayerTextDrawBackgroundColor(playerid, INV_BG20[playerid], 255);
		PlayerTextDrawFont(playerid, INV_BG20[playerid], 3);
		PlayerTextDrawLetterSize(playerid, INV_BG20[playerid], 17.399990, 44.200000);
		PlayerTextDrawColor(playerid, INV_BG20[playerid], -56);
		PlayerTextDrawSetOutline(playerid, INV_BG20[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_BG20[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_BG20[playerid], 0);
		PlayerTextDrawSetSelectable(playerid, INV_BG20[playerid], 0);

		INV_BG21[playerid] = CreatePlayerTextDraw(playerid, 219.000000, 199.000000, ".");
		PlayerTextDrawBackgroundColor(playerid, INV_BG21[playerid], 255);
		PlayerTextDrawFont(playerid, INV_BG21[playerid], 3);
		PlayerTextDrawLetterSize(playerid, INV_BG21[playerid], 4.800000, 14.000000);
		PlayerTextDrawColor(playerid, INV_BG21[playerid], -56);
		PlayerTextDrawSetOutline(playerid, INV_BG21[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_BG21[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_BG21[playerid], 0);
		PlayerTextDrawSetSelectable(playerid, INV_BG21[playerid], 0);

		INV_BG22[playerid] = CreatePlayerTextDraw(playerid, 219.000000, 224.000000, ".");
		PlayerTextDrawBackgroundColor(playerid, INV_BG22[playerid], 255);
		PlayerTextDrawFont(playerid, INV_BG22[playerid], 3);
		PlayerTextDrawLetterSize(playerid, INV_BG22[playerid], 4.800000, 14.000000);
		PlayerTextDrawColor(playerid, INV_BG22[playerid], -56);
		PlayerTextDrawSetOutline(playerid, INV_BG22[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_BG22[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_BG22[playerid], 0);
		PlayerTextDrawSetSelectable(playerid, INV_BG22[playerid], 0);

		INV_BG23[playerid] = CreatePlayerTextDraw(playerid, 219.000000, 249.000000, ".");
		PlayerTextDrawBackgroundColor(playerid, INV_BG23[playerid], 255);
		PlayerTextDrawFont(playerid, INV_BG23[playerid], 3);
		PlayerTextDrawLetterSize(playerid, INV_BG23[playerid], 4.800000, 14.000000);
		PlayerTextDrawColor(playerid, INV_BG23[playerid], -56);
		PlayerTextDrawSetOutline(playerid, INV_BG23[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_BG23[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_BG23[playerid], 0);
		PlayerTextDrawSetSelectable(playerid, INV_BG23[playerid], 0);

		INV_USE_BTN[playerid] = CreatePlayerTextDraw(playerid, 224.000000, 291.000000, "USE");
		PlayerTextDrawBackgroundColor(playerid, INV_USE_BTN[playerid], 16711935);
		PlayerTextDrawFont(playerid, INV_USE_BTN[playerid], 3);
		PlayerTextDrawLetterSize(playerid, INV_USE_BTN[playerid], 0.500000, 1.899999);
		PlayerTextDrawColor(playerid, INV_USE_BTN[playerid], -1);
		PlayerTextDrawSetOutline(playerid, INV_USE_BTN[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_USE_BTN[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_USE_BTN[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, INV_USE_BTN[playerid], 1);

		INV_DROP_BTN[playerid] = CreatePlayerTextDraw(playerid, 224.000000, 318.000000, "DROP");
		PlayerTextDrawBackgroundColor(playerid, INV_DROP_BTN[playerid], -16776961);
		PlayerTextDrawFont(playerid, INV_DROP_BTN[playerid], 3);
		PlayerTextDrawLetterSize(playerid, INV_DROP_BTN[playerid], 0.400000, 1.599999);
		PlayerTextDrawColor(playerid, INV_DROP_BTN[playerid], -1);
		PlayerTextDrawSetOutline(playerid, INV_DROP_BTN[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_DROP_BTN[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_DROP_BTN[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, INV_DROP_BTN[playerid], 1);

		INV_CRAFT_BTN[playerid] = CreatePlayerTextDraw(playerid, 223.000000, 341.000000, "CRAFT");
		PlayerTextDrawBackgroundColor(playerid, INV_CRAFT_BTN[playerid], 65535);
		PlayerTextDrawFont(playerid, INV_CRAFT_BTN[playerid], 3);
		PlayerTextDrawLetterSize(playerid, INV_CRAFT_BTN[playerid], 0.350000, 1.900000);
		PlayerTextDrawColor(playerid, INV_CRAFT_BTN[playerid], -1);
		PlayerTextDrawSetOutline(playerid, INV_CRAFT_BTN[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_CRAFT_BTN[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_CRAFT_BTN[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, INV_CRAFT_BTN[playerid], 1);

		INV_PRV_IMG[playerid] = CreatePlayerTextDraw(playerid, 300.000000, 283.000000, "INV_PRV_IMG");
		PlayerTextDrawBackgroundColor(playerid, INV_PRV_IMG[playerid], 0);
		PlayerTextDrawFont(playerid, INV_PRV_IMG[playerid], 5);
		PlayerTextDrawLetterSize(playerid, INV_PRV_IMG[playerid], 0.500000, 5.000000);
		PlayerTextDrawColor(playerid, INV_PRV_IMG[playerid], -1);
		PlayerTextDrawSetOutline(playerid, INV_PRV_IMG[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_PRV_IMG[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_PRV_IMG[playerid], 1);
		PlayerTextDrawUseBox(playerid, INV_PRV_IMG[playerid], 1);
		PlayerTextDrawBoxColor(playerid, INV_PRV_IMG[playerid], 255);
		PlayerTextDrawTextSize(playerid, INV_PRV_IMG[playerid], 59.000000, 82.000000);
		PlayerTextDrawSetPreviewModel(playerid, INV_PRV_IMG[playerid], 18631);
		PlayerTextDrawSetPreviewRot(playerid, INV_PRV_IMG[playerid], -20.000000, 0.000000, 150.000000, 0.699999);
		PlayerTextDrawSetSelectable(playerid, INV_PRV_IMG[playerid], 0);

		INV_PRV_STR[playerid] = CreatePlayerTextDraw(playerid, 289.000000, 351.000000, "INV_PRV_STR");
		PlayerTextDrawBackgroundColor(playerid, INV_PRV_STR[playerid], 255);
		PlayerTextDrawFont(playerid, INV_PRV_STR[playerid], 3);
		PlayerTextDrawLetterSize(playerid, INV_PRV_STR[playerid], 0.600000, 1.000000);
		PlayerTextDrawColor(playerid, INV_PRV_STR[playerid], -1);
		PlayerTextDrawSetOutline(playerid, INV_PRV_STR[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_PRV_STR[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_PRV_STR[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, INV_PRV_STR[playerid], 0);
		
		INV_STAT1_STR[playerid] = CreatePlayerTextDraw(playerid, 202.000000, 140.000000, "Weed: X I Cocaine: X");
		PlayerTextDrawBackgroundColor(playerid, INV_STAT1_STR[playerid], 255);
		PlayerTextDrawFont(playerid, INV_STAT1_STR[playerid], 2);
		PlayerTextDrawLetterSize(playerid, INV_STAT1_STR[playerid], 0.200000, 1.000000);
		PlayerTextDrawColor(playerid, INV_STAT1_STR[playerid], -1);
		PlayerTextDrawSetOutline(playerid, INV_STAT1_STR[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_STAT1_STR[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_STAT1_STR[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, INV_STAT1_STR[playerid], 0);

		INV_STAT2_STR[playerid] = CreatePlayerTextDraw(playerid, 202.000000, 150.000000, "Rolling Papers: X");
		PlayerTextDrawBackgroundColor(playerid, INV_STAT2_STR[playerid], 255);
		PlayerTextDrawFont(playerid, INV_STAT2_STR[playerid], 2);
		PlayerTextDrawLetterSize(playerid, INV_STAT2_STR[playerid], 0.200000, 1.000000);
		PlayerTextDrawColor(playerid, INV_STAT2_STR[playerid], -1);
		PlayerTextDrawSetOutline(playerid, INV_STAT2_STR[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_STAT2_STR[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_STAT2_STR[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, INV_STAT2_STR[playerid], 0);

		INV_STAT3_STR[playerid] = CreatePlayerTextDraw(playerid, 202.000000, 160.000000, "Health: X I Armour: X");
		PlayerTextDrawBackgroundColor(playerid, INV_STAT3_STR[playerid], 255);
		PlayerTextDrawFont(playerid, INV_STAT3_STR[playerid], 2);
		PlayerTextDrawLetterSize(playerid, INV_STAT3_STR[playerid], 0.200000, 1.000000);
		PlayerTextDrawColor(playerid, INV_STAT3_STR[playerid], -1);
		PlayerTextDrawSetOutline(playerid, INV_STAT3_STR[playerid], 0);
		PlayerTextDrawSetProportional(playerid, INV_STAT3_STR[playerid], 1);
		PlayerTextDrawSetShadow(playerid, INV_STAT3_STR[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, INV_STAT3_STR[playerid], 0);
		
		CRF_BG1[playerid] = CreatePlayerTextDraw(playerid, 444.000000, 140.000000, "                 ");
		PlayerTextDrawBackgroundColor(playerid, CRF_BG1[playerid], 255);
		PlayerTextDrawFont(playerid, CRF_BG1[playerid], 1);
		PlayerTextDrawLetterSize(playerid, CRF_BG1[playerid], 0.699999, 10.299997);
		PlayerTextDrawColor(playerid, CRF_BG1[playerid], -1);
		PlayerTextDrawSetOutline(playerid, CRF_BG1[playerid], 0);
		PlayerTextDrawSetProportional(playerid, CRF_BG1[playerid], 1);
		PlayerTextDrawSetShadow(playerid, CRF_BG1[playerid], 1);
		PlayerTextDrawUseBox(playerid, CRF_BG1[playerid], 1);
		PlayerTextDrawBoxColor(playerid, CRF_BG1[playerid], 848737460);
		PlayerTextDrawTextSize(playerid, CRF_BG1[playerid], 570.000000, 0.000000);
		PlayerTextDrawSetSelectable(playerid, CRF_BG1[playerid], 0);

		CRF_BG2[playerid] = CreatePlayerTextDraw(playerid, 444.000000, 236.000000, "                 ");
		PlayerTextDrawBackgroundColor(playerid, CRF_BG2[playerid], 255);
		PlayerTextDrawFont(playerid, CRF_BG2[playerid], 1);
		PlayerTextDrawLetterSize(playerid, CRF_BG2[playerid], 0.699999, 10.299997);
		PlayerTextDrawColor(playerid, CRF_BG2[playerid], -1);
		PlayerTextDrawSetOutline(playerid, CRF_BG2[playerid], 0);
		PlayerTextDrawSetProportional(playerid, CRF_BG2[playerid], 1);
		PlayerTextDrawSetShadow(playerid, CRF_BG2[playerid], 1);
		PlayerTextDrawUseBox(playerid, CRF_BG2[playerid], 1);
		PlayerTextDrawBoxColor(playerid, CRF_BG2[playerid], 848742600);
		PlayerTextDrawTextSize(playerid, CRF_BG2[playerid], 570.000000, 0.000000);
		PlayerTextDrawSetSelectable(playerid, CRF_BG2[playerid], 0);

		CRF_BG3[playerid] = CreatePlayerTextDraw(playerid, 437.000000, 134.000000, "-");
		PlayerTextDrawBackgroundColor(playerid, CRF_BG3[playerid], 255);
		PlayerTextDrawFont(playerid, CRF_BG3[playerid], 1);
		PlayerTextDrawLetterSize(playerid, CRF_BG3[playerid], 10.000000, 0.699998);
		PlayerTextDrawColor(playerid, CRF_BG3[playerid], -1);
		PlayerTextDrawSetOutline(playerid, CRF_BG3[playerid], 0);
		PlayerTextDrawSetProportional(playerid, CRF_BG3[playerid], 1);
		PlayerTextDrawSetShadow(playerid, CRF_BG3[playerid], 0);
		PlayerTextDrawSetSelectable(playerid, CRF_BG3[playerid], 0);

		CRF_ITM1_STR[playerid] = CreatePlayerTextDraw(playerid, 443.000000, 154.000000, "CRF_ITM1_STR");
		PlayerTextDrawBackgroundColor(playerid, CRF_ITM1_STR[playerid], 255);
		PlayerTextDrawFont(playerid, CRF_ITM1_STR[playerid], 3);
		PlayerTextDrawLetterSize(playerid, CRF_ITM1_STR[playerid], 0.300000, 1.000000);
		PlayerTextDrawColor(playerid, CRF_ITM1_STR[playerid], -1);
		PlayerTextDrawSetOutline(playerid, CRF_ITM1_STR[playerid], 0);
		PlayerTextDrawSetProportional(playerid, CRF_ITM1_STR[playerid], 1);
		PlayerTextDrawSetShadow(playerid, CRF_ITM1_STR[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, CRF_ITM1_STR[playerid], 0);

		CRF_ITM2_STR[playerid] = CreatePlayerTextDraw(playerid, 443.000000, 164.000000, "CRF_ITM2_STR");
		PlayerTextDrawBackgroundColor(playerid, CRF_ITM2_STR[playerid], 255);
		PlayerTextDrawFont(playerid, CRF_ITM2_STR[playerid], 3);
		PlayerTextDrawLetterSize(playerid, CRF_ITM2_STR[playerid], 0.300000, 1.000000);
		PlayerTextDrawColor(playerid, CRF_ITM2_STR[playerid], -1);
		PlayerTextDrawSetOutline(playerid, CRF_ITM2_STR[playerid], 0);
		PlayerTextDrawSetProportional(playerid, CRF_ITM2_STR[playerid], 1);
		PlayerTextDrawSetShadow(playerid, CRF_ITM2_STR[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, CRF_ITM2_STR[playerid], 0);

		CRF_ITM3_STR[playerid] = CreatePlayerTextDraw(playerid, 443.000000, 174.000000, "CRF_ITM3_STR");
		PlayerTextDrawBackgroundColor(playerid, CRF_ITM3_STR[playerid], 255);
		PlayerTextDrawFont(playerid, CRF_ITM3_STR[playerid], 3);
		PlayerTextDrawLetterSize(playerid, CRF_ITM3_STR[playerid], 0.300000, 1.000000);
		PlayerTextDrawColor(playerid, CRF_ITM3_STR[playerid], -1);
		PlayerTextDrawSetOutline(playerid, CRF_ITM3_STR[playerid], 0);
		PlayerTextDrawSetProportional(playerid, CRF_ITM3_STR[playerid], 1);
		PlayerTextDrawSetShadow(playerid, CRF_ITM3_STR[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, CRF_ITM3_STR[playerid], 0);

		CRF_ITM4_STR[playerid] = CreatePlayerTextDraw(playerid, 443.000000, 184.000000, "CRF_ITM4_STR");
		PlayerTextDrawBackgroundColor(playerid, CRF_ITM4_STR[playerid], 255);
		PlayerTextDrawFont(playerid, CRF_ITM4_STR[playerid], 3);
		PlayerTextDrawLetterSize(playerid, CRF_ITM4_STR[playerid], 0.300000, 1.000000);
		PlayerTextDrawColor(playerid, CRF_ITM4_STR[playerid], -1);
		PlayerTextDrawSetOutline(playerid, CRF_ITM4_STR[playerid], 0);
		PlayerTextDrawSetProportional(playerid, CRF_ITM4_STR[playerid], 1);
		PlayerTextDrawSetShadow(playerid, CRF_ITM4_STR[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, CRF_ITM4_STR[playerid], 0);

		CRF_ITM5_STR[playerid] = CreatePlayerTextDraw(playerid, 443.000000, 194.000000, "CRF_ITM5_STR");
		PlayerTextDrawBackgroundColor(playerid, CRF_ITM5_STR[playerid], 255);
		PlayerTextDrawFont(playerid, CRF_ITM5_STR[playerid], 3);
		PlayerTextDrawLetterSize(playerid, CRF_ITM5_STR[playerid], 0.300000, 1.000000);
		PlayerTextDrawColor(playerid, CRF_ITM5_STR[playerid], -1);
		PlayerTextDrawSetOutline(playerid, CRF_ITM5_STR[playerid], 0);
		PlayerTextDrawSetProportional(playerid, CRF_ITM5_STR[playerid], 1);
		PlayerTextDrawSetShadow(playerid, CRF_ITM5_STR[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, CRF_ITM5_STR[playerid], 0);

		CRF_ITM6_STR[playerid] = CreatePlayerTextDraw(playerid, 443.000000, 204.000000, "CRF_ITM6_STR");
		PlayerTextDrawBackgroundColor(playerid, CRF_ITM6_STR[playerid], 255);
		PlayerTextDrawFont(playerid, CRF_ITM6_STR[playerid], 3);
		PlayerTextDrawLetterSize(playerid, CRF_ITM6_STR[playerid], 0.300000, 1.000000);
		PlayerTextDrawColor(playerid, CRF_ITM6_STR[playerid], -1);
		PlayerTextDrawSetOutline(playerid, CRF_ITM6_STR[playerid], 0);
		PlayerTextDrawSetProportional(playerid, CRF_ITM6_STR[playerid], 1);
		PlayerTextDrawSetShadow(playerid, CRF_ITM6_STR[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, CRF_ITM6_STR[playerid], 0);

		CRF_ITM7_STR[playerid] = CreatePlayerTextDraw(playerid, 443.000000, 214.000000, "CRF_ITM7_STR");
		PlayerTextDrawBackgroundColor(playerid, CRF_ITM7_STR[playerid], 255);
		PlayerTextDrawFont(playerid, CRF_ITM7_STR[playerid], 3);
		PlayerTextDrawLetterSize(playerid, CRF_ITM7_STR[playerid], 0.300000, 1.000000);
		PlayerTextDrawColor(playerid, CRF_ITM7_STR[playerid], -1);
		PlayerTextDrawSetOutline(playerid, CRF_ITM7_STR[playerid], 0);
		PlayerTextDrawSetProportional(playerid, CRF_ITM7_STR[playerid], 1);
		PlayerTextDrawSetShadow(playerid, CRF_ITM7_STR[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, CRF_ITM7_STR[playerid], 0);

		CRF_ITM8_STR[playerid] = CreatePlayerTextDraw(playerid, 443.000000, 224.000000, "CRF_ITM8_STR");
		PlayerTextDrawBackgroundColor(playerid, CRF_ITM8_STR[playerid], 255);
		PlayerTextDrawFont(playerid, CRF_ITM8_STR[playerid], 3);
		PlayerTextDrawLetterSize(playerid, CRF_ITM8_STR[playerid], 0.300000, 1.000000);
		PlayerTextDrawColor(playerid, CRF_ITM8_STR[playerid], -1);
		PlayerTextDrawSetOutline(playerid, CRF_ITM8_STR[playerid], 0);
		PlayerTextDrawSetProportional(playerid, CRF_ITM8_STR[playerid], 1);
		PlayerTextDrawSetShadow(playerid, CRF_ITM8_STR[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, CRF_ITM8_STR[playerid], 0);

		CRF_ITM9_STR[playerid] = CreatePlayerTextDraw(playerid, 443.000000, 234.000000, "CRF_ITM9_STR");
		PlayerTextDrawBackgroundColor(playerid, CRF_ITM9_STR[playerid], 255);
		PlayerTextDrawFont(playerid, CRF_ITM9_STR[playerid], 3);
		PlayerTextDrawLetterSize(playerid, CRF_ITM9_STR[playerid], 0.300000, 1.000000);
		PlayerTextDrawColor(playerid, CRF_ITM9_STR[playerid], -1);
		PlayerTextDrawSetOutline(playerid, CRF_ITM9_STR[playerid], 0);
		PlayerTextDrawSetProportional(playerid, CRF_ITM9_STR[playerid], 1);
		PlayerTextDrawSetShadow(playerid, CRF_ITM9_STR[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, CRF_ITM9_STR[playerid], 0);

		CRF_ITM10_STR[playerid] = CreatePlayerTextDraw(playerid, 443.000000, 244.000000, "CRF_ITM10_STR");
		PlayerTextDrawBackgroundColor(playerid, CRF_ITM10_STR[playerid], 255);
		PlayerTextDrawFont(playerid, CRF_ITM10_STR[playerid], 3);
		PlayerTextDrawLetterSize(playerid, CRF_ITM10_STR[playerid], 0.300000, 1.000000);
		PlayerTextDrawColor(playerid, CRF_ITM10_STR[playerid], -1);
		PlayerTextDrawSetOutline(playerid, CRF_ITM10_STR[playerid], 0);
		PlayerTextDrawSetProportional(playerid, CRF_ITM10_STR[playerid], 1);
		PlayerTextDrawSetShadow(playerid, CRF_ITM10_STR[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, CRF_ITM10_STR[playerid], 0);

		CRF_BG4[playerid] = CreatePlayerTextDraw(playerid, 475.000000, 125.000000, "Crafting");
		PlayerTextDrawBackgroundColor(playerid, CRF_BG4[playerid], 255);
		PlayerTextDrawFont(playerid, CRF_BG4[playerid], 0);
		PlayerTextDrawLetterSize(playerid, CRF_BG4[playerid], 0.620000, 2.000000);
		PlayerTextDrawColor(playerid, CRF_BG4[playerid], -1);
		PlayerTextDrawSetOutline(playerid, CRF_BG4[playerid], 0);
		PlayerTextDrawSetProportional(playerid, CRF_BG4[playerid], 1);
		PlayerTextDrawSetShadow(playerid, CRF_BG4[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, CRF_BG4[playerid], 0);

		CRF_BG5[playerid] = CreatePlayerTextDraw(playerid, 437.000000, 253.000000, "-");
		PlayerTextDrawBackgroundColor(playerid, CRF_BG5[playerid], 255);
		PlayerTextDrawFont(playerid, CRF_BG5[playerid], 1);
		PlayerTextDrawLetterSize(playerid, CRF_BG5[playerid], 10.000000, 0.699998);
		PlayerTextDrawColor(playerid, CRF_BG5[playerid], -1);
		PlayerTextDrawSetOutline(playerid, CRF_BG5[playerid], 0);
		PlayerTextDrawSetProportional(playerid, CRF_BG5[playerid], 1);
		PlayerTextDrawSetShadow(playerid, CRF_BG5[playerid], 0);
		PlayerTextDrawSetSelectable(playerid, CRF_BG5[playerid], 0);

		CRF_BG6[playerid] = CreatePlayerTextDraw(playerid, 437.000000, 326.000000, "-");
		PlayerTextDrawBackgroundColor(playerid, CRF_BG6[playerid], 255);
		PlayerTextDrawFont(playerid, CRF_BG6[playerid], 1);
		PlayerTextDrawLetterSize(playerid, CRF_BG6[playerid], 10.000000, 0.699998);
		PlayerTextDrawColor(playerid, CRF_BG6[playerid], -1);
		PlayerTextDrawSetOutline(playerid, CRF_BG6[playerid], 0);
		PlayerTextDrawSetProportional(playerid, CRF_BG6[playerid], 1);
		PlayerTextDrawSetShadow(playerid, CRF_BG6[playerid], 0);
		PlayerTextDrawSetSelectable(playerid, CRF_BG6[playerid], 0);

		CRF_MET_STR[playerid] = CreatePlayerTextDraw(playerid, 444.000000, 259.000000, "CRF_MET_STR");
		PlayerTextDrawBackgroundColor(playerid, CRF_MET_STR[playerid], 255);
		PlayerTextDrawFont(playerid, CRF_MET_STR[playerid], 2);
		PlayerTextDrawLetterSize(playerid, CRF_MET_STR[playerid], 0.200000, 1.000000);
		PlayerTextDrawColor(playerid, CRF_MET_STR[playerid], -1);
		PlayerTextDrawSetOutline(playerid, CRF_MET_STR[playerid], 0);
		PlayerTextDrawSetProportional(playerid, CRF_MET_STR[playerid], 1);
		PlayerTextDrawSetShadow(playerid, CRF_MET_STR[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, CRF_MET_STR[playerid], 0);

		CRF_WOD_STR[playerid] = CreatePlayerTextDraw(playerid, 444.000000, 269.000000, "CRF_WOD_STR");
		PlayerTextDrawBackgroundColor(playerid, CRF_WOD_STR[playerid], 255);
		PlayerTextDrawFont(playerid, CRF_WOD_STR[playerid], 2);
		PlayerTextDrawLetterSize(playerid, CRF_WOD_STR[playerid], 0.200000, 1.000000);
		PlayerTextDrawColor(playerid, CRF_WOD_STR[playerid], -1);
		PlayerTextDrawSetOutline(playerid, CRF_WOD_STR[playerid], 0);
		PlayerTextDrawSetProportional(playerid, CRF_WOD_STR[playerid], 1);
		PlayerTextDrawSetShadow(playerid, CRF_WOD_STR[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, CRF_WOD_STR[playerid], 0);

		CRF_CRF_STR[playerid] = CreatePlayerTextDraw(playerid, 444.000000, 279.000000, "CRF_CRF_STR");
		PlayerTextDrawBackgroundColor(playerid, CRF_CRF_STR[playerid], 255);
		PlayerTextDrawFont(playerid, CRF_CRF_STR[playerid], 2);
		PlayerTextDrawLetterSize(playerid, CRF_CRF_STR[playerid], 0.200000, 1.000000);
		PlayerTextDrawColor(playerid, CRF_CRF_STR[playerid], -1);
		PlayerTextDrawSetOutline(playerid, CRF_CRF_STR[playerid], 0);
		PlayerTextDrawSetProportional(playerid, CRF_CRF_STR[playerid], 1);
		PlayerTextDrawSetShadow(playerid, CRF_CRF_STR[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, CRF_CRF_STR[playerid], 0);

		CRF_BG7[playerid] = CreatePlayerTextDraw(playerid, 477.000000, 108.000000, ".");
		PlayerTextDrawBackgroundColor(playerid, CRF_BG7[playerid], -1);
		PlayerTextDrawFont(playerid, CRF_BG7[playerid], 2);
		PlayerTextDrawLetterSize(playerid, CRF_BG7[playerid], 9.299999, 29.000000);
		PlayerTextDrawColor(playerid, CRF_BG7[playerid], -1);
		PlayerTextDrawSetOutline(playerid, CRF_BG7[playerid], 0);
		PlayerTextDrawSetProportional(playerid, CRF_BG7[playerid], 1);
		PlayerTextDrawSetShadow(playerid, CRF_BG7[playerid], 0);
		PlayerTextDrawSetSelectable(playerid, CRF_BG7[playerid], 0);

		CRF_CRF_BTN[playerid] = CreatePlayerTextDraw(playerid, 486.000000, 308.000000, "Craft");
		PlayerTextDrawBackgroundColor(playerid, CRF_CRF_BTN[playerid], 255);
		PlayerTextDrawFont(playerid, CRF_CRF_BTN[playerid], 3);
		PlayerTextDrawLetterSize(playerid, CRF_CRF_BTN[playerid], 0.409999, 1.900000);
		PlayerTextDrawColor(playerid, CRF_CRF_BTN[playerid], -1);
		PlayerTextDrawSetOutline(playerid, CRF_CRF_BTN[playerid], 0);
		PlayerTextDrawSetProportional(playerid, CRF_CRF_BTN[playerid], 1);
		PlayerTextDrawSetShadow(playerid, CRF_CRF_BTN[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, CRF_CRF_BTN[playerid], 1);
		
		//----------------------------------------------------------------------------------------------------------------------------------------------
		ExamWrong[playerid] = 0;
		AutoPM[playerid][0] = 0;
		AjailReason[playerid][0] = 0;
		HoldingObject[playerid] = 0;
		PNewReg[playerid] = 0;
        ResetPlayer(playerid);
		PlayerClimbingRope[playerid] = 0;
		Masked[playerid] = 0;
		AwaitingHelper[playerid] = 0;
		AwaitingAdmin[playerid] = 0;
		AwaitingReport[playerid] = 0;
		PlayerSitting[playerid] = 0;
		HoldingTray[playerid] = 0;
		NewRegQuestion[playerid] = 0;
		NewRegAwaiting[playerid] = 0;
		AntiPayCheckSpam[playerid] = 0;
		HackerKick[playerid] = 0;
        SetPlayerColor(playerid, GREY);
		TrackPMs[playerid] = 0;
		PMsTracked[playerid] = 0;
		TrashAmount[playerid] = 0;
		AdminCodeTry[playerid] = 0;
		AdminCommandTry[playerid] = 0;
		INV_SEL_ITM[playerid] = 0;
		INV_SEL_WEP[playerid] = 0;
		PFishing[playerid] = 0;
		PFishingT[playerid] = 0;
		PFishingCP[playerid] = 0;
		PFishingCT[playerid] = 0;
		pSmokeAnim[playerid] = 0;
		pCraftWindow[playerid] = 0;
		CRF_ITM1[playerid] = 0;
		CRF_ITM1A[playerid] = 0;
		CRF_ITM2[playerid] = 0;
		CRF_ITM2A[playerid] = 0;
		CRF_ITM3[playerid] = 0;
		CRF_ITM3A[playerid] = 0;
		CRF_ITM4[playerid] = 0;
		CRF_ITM4A[playerid] = 0;
		CRF_ITM5[playerid] = 0;
		CRF_ITM5A[playerid] = 0;
		CRF_ITM6[playerid] = 0;
		CRF_ITM6A[playerid] = 0;
		CRF_ITM7[playerid] = 0;
		CRF_ITM7A[playerid] = 0;
		CRF_ITM8[playerid] = 0;
		CRF_ITM8A[playerid] = 0;
		CRF_ITM9[playerid] = 0;
		CRF_ITM9A[playerid] = 0;
		CRF_ITM10[playerid] = 0;
		CRF_ITM10A[playerid] = 0;
        if(!IsValidName(playerid))
        {
		    SendClientMessage(playerid, GREY, "You have a Non-Roleplay name, please use Firstname_Lastname format.");
		    INI_Remove("Accounts/None.ini");
		    Kick(playerid);
	    }
        else if(fexist(Accounts(playerid)))
        {
			new CIP[21], OIP[21];
			GetPlayerIp(playerid, CIP, sizeof(CIP));
			INI_Open(Accounts(playerid));
			INI_ReadString(PlayerStat[playerid][LastIP],"LastIP",21);
			if(!strcmp(CIP,OIP,false)) //Auto IP LOGIN
			{
				ClearChatForPlayer(playerid);
				SendClientMessage(playerid, GREEN, "--------------------------------------------------------------------------------");
				SendClientMessage(playerid, WHITE, "                Welcome back to High Desert Roleplay                      ");
				SendClientMessage(playerid, WHITE, "          Don't forget to visit our website www.hd-rp.net .                ");
				SendClientMessage(playerid, WHITE, "                       Version: 0.3.1 [BETA]                  ");
				SendClientMessage(playerid, GREEN, "--------------------------------------------------------------------------------");
				new str[128];
				SendClientMessage(playerid, RED, "Your IP had matched the previous IP logged into this account and you had been logged in automaticly.");
				SendClientMessage(playerid, GREEN, str);
				format(str, sizeof(str), "~w~Welcome Back ~n~~y~ %s", GetOOCName(playerid));
				GameTextForPlayer(playerid, str, 3000, 1);
				SendClientMessage(playerid, GREEN, SERVER_MOTD);
				PlayerStat[playerid][BPNMB] = 0;
				PlayerStat[playerid][AdminLogged] = 0;
				PlayerPayDayT[playerid] = SetTimerEx("PlayerPayDay", 60000, true, "i", playerid);
				if(PlayerStat[playerid][GangID] >= 1)
				{
					format(str, sizeof(str), "Gang MOTD: %s", GangStat[PlayerStat[playerid][GangID]][MOTD]);
					SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
				}
				PlayerStat[playerid][Logged] = 1;
				LoadPlayerData(playerid);
				INI_Save();
				INI_Close();
				return 1;
			}
			else
			{
				GetPlayerIp(playerid, PlayerStat[playerid][LastIP], 21);
				ClearChatForPlayer(playerid);
				SendClientMessage(playerid, GREEN, "--------------------------------------------------------------------------------");
				SendClientMessage(playerid, WHITE, "                Welcome back to High Desert Roleplay                      ");
				SendClientMessage(playerid, WHITE, "            Type the account's password below to login.                  ");
				SendClientMessage(playerid, WHITE, "          Don't forget to visit our website www.hd-rp.net .                ");
				SendClientMessage(playerid, WHITE, "                       Version: 0.3.1 [BETA]                  ");
				SendClientMessage(playerid, GREEN, "--------------------------------------------------------------------------------");
				SetPlayerCameraPos(playerid, 295.3590, 1490.8636, 24.1869);
				SetPlayerCameraLookAt(playerid, 294.6416, 1490.1674, 24.0369);
				ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT,"Login","Welcome to High Desert Roleplay.\nInput your password below to login.","Login","Quit");
			}
		}
        else
        {
            GetPlayerIp(playerid, PlayerStat[playerid][LastIP], 21);

            ClearChatForPlayer(playerid);

            SendClientMessage(playerid, GREEN, "--------------------------------------------------------------------------------");
            SendClientMessage(playerid, WHITE, "                 Welcome back to High Desert Roleplay                      ");
            SendClientMessage(playerid, WHITE, "           Type a password below to register a new account.               ");
            SendClientMessage(playerid, WHITE, "          Don't forget to visit our website www.hd-rp.net .                  ");
            SendClientMessage(playerid, WHITE, "                      Version: 0.3.1 [BETA]                 ");
            SendClientMessage(playerid, GREEN, "--------------------------------------------------------------------------------");
			SetPlayerCameraPos(playerid, 295.3590, 1490.8636, 24.1869);
			SetPlayerCameraLookAt(playerid, 294.6416, 1490.1674, 24.0369);
		    ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT,"Registering","Welcome to High Desert Roleplay.\nInput your password below to register a new account.","Register","Quit");
		}
        SetPlayerColor(playerid, GREY);
    }
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	new Float:DisconnectHealth;
	AutoPM[playerid][0] = 0;
	AjailReason[playerid][0] = 0;
	PlayerStat[playerid][JobID4CHP] = 0;
	PlayerStat[playerid][JobID4BOX] = 0;
	PlayerStat[playerid][HDuty] = 0;
	PlayerStat[playerid][BPUSE] = 0;
	PlayerStat[playerid][BPDIF] = 0;
	PlayerStat[playerid][BPACD] = 0;
	PlayerStat[playerid][BPANM] = 0;
	AdminCodeTry[playerid] = 0;
	AdminCommandTry[playerid] = 0;
	PlayerStat[playerid][BPBAR] = 0;
	HoldingTray[playerid] = 0;
	HoldingObject[playerid] = 0;
	AwaitingHelper[playerid] = 0;
	AwaitingAdmin[playerid] = 0;
	AwaitingReport[playerid] = 0;
	PlayerSitting[playerid] = 0;
	HoldingTray[playerid] = 0;
	AntiPayCheckSpam[playerid] = 0;
	TrackPMs[playerid] = 0;
	PMsTracked[playerid] = 0;
	HackerKick[playerid] = 0;
	ExamWrong[playerid] = 0;
	TrashAmount[playerid] = 0;
	INV_SEL_ITM[playerid] = 0;
	INV_SEL_WEP[playerid] = 0;
	PFishing[playerid] = 0;
	PFishingT[playerid] = 0;
	PFishingCP[playerid] = 0;
	PFishingCT[playerid] = 0;
	pSmokeAnim[playerid] = 0;
	pCraftWindow[playerid] = 0;
	CRF_ITM1[playerid] = 0;
	CRF_ITM1A[playerid] = 0;
	CRF_ITM2[playerid] = 0;
	CRF_ITM2A[playerid] = 0;
	CRF_ITM3[playerid] = 0;
	CRF_ITM3A[playerid] = 0;
	CRF_ITM4[playerid] = 0;
	CRF_ITM4A[playerid] = 0;
	CRF_ITM5[playerid] = 0;
	CRF_ITM5A[playerid] = 0;
	CRF_ITM6[playerid] = 0;
	CRF_ITM6A[playerid] = 0;
	CRF_ITM7[playerid] = 0;
	CRF_ITM7A[playerid] = 0;
	CRF_ITM8[playerid] = 0;
	CRF_ITM8A[playerid] = 0;
	CRF_ITM9[playerid] = 0;
	CRF_ITM9A[playerid] = 0;
	CRF_ITM10[playerid] = 0;
	CRF_ITM10A[playerid] = 0;
	if(PlayerClimbingRope[playerid] == 1)
	{
		RopeUsed = 0;
	}
	HiddenAdmin[playerid] = 0;
	PlayerClimbingRope[playerid] = 0;
	if(UsingDisher[playerid] >= 1)
	{
		if(UsingDisher[playerid] == 1)
		{
			Sink1Used = 0;
		}
		else
		{
			Sink2Used = 0;
		}
	}
	UsingDisher[playerid] = 0;
	if(PlayerStat[playerid][ADuty] == 1)
	{
		SetPlayerHealth(playerid, DutyHealth[playerid]);
		SetPlayerArmour(playerid, DutyArmour[playerid]);
		PlayerStat[playerid][Armour] = DutyArmour[playerid];
		PlayerStat[playerid][Health] = DutyHealth[playerid];
		PlayerStat[playerid][ADuty] = 0;
	}
	if(Masked[playerid] == 1)
	{
		Delete3DTextLabel(MaskID[playerid]);
		Masked[playerid] = 0;
	}
    if(!IsPlayerNPC(playerid) && PlayerStat[playerid][Logged] == 1)
	{
		new str[128];
        switch(reason)
	    {
		    case 0:
			{
			    format(str, sizeof(str), "%s has left the server (timeout).", GetOOCName(playerid));
			    SendNearByMessage(playerid, WHITE, str, 6);
			}
            case 1:
			{
				format(str, sizeof(str), "%s has left the server (leaving).", GetOOCName(playerid));
				SendNearByMessage(playerid, WHITE, str, 6);
			}
            case 2:
            {
				format(str, sizeof(str), "%s has left the server (kicked/banned).", GetOOCName(playerid));
				SendNearByMessage(playerid, WHITE, str, 6);
            }
		}
		if(PlayerStat[playerid][Logged] == 1)
		{
			for(new d = 0; d < MAX_ATTACHED_OBJECTS; d++)
            {
                if(IsPlayerAttachedObjectSlotUsed(playerid, d))
	            {
	                RemovePlayerAttachedObject(playerid, d);
	            }
	        }
	        if(PlayerStat[playerid][Cuffed] == 1)
		    {
				PlayerStat[playerid][AdminPrisoned] = 1;
				PlayerStat[playerid][AdminPrisonedTime] = 1080;
				PlayerStat[playerid][LogoutCuffs] = 1;
			}
			if(PlayerStat[playerid][BeingSpeced] == 1)
            {
                TogglePlayerSpectating(PlayerStat[playerid][BeingSpecedBy], false);
            }
			PlayerStat[playerid][JobID4CHP] = 0;
			PlayerStat[playerid][JobID4BOX] = 0;
			PlayerStat[playerid][ADuty] = 0;
			PlayerStat[playerid][HDuty] = 0;
			PlayerStat[playerid][BPUSE] = 0;
			PlayerStat[playerid][BPDIF] = 0;
			PlayerStat[playerid][BPCD] = 0;
			PlayerStat[playerid][BPACD] = 0;
			PlayerStat[playerid][BPANM] = 0;
			PlayerStat[playerid][BPBAR] = 0;
			HiddenAdmin[playerid] = 0;
			GetPlayerHealth(playerid, Float:DisconnectHealth);
			if(PlayerAFK[playerid] == 0)
			{
				PlayerStat[playerid][Health] = Float:DisconnectHealth;
			}
			PNewReg[playerid] = 0;
			AFKTime[playerid] = 0;
			AFKTimeKeeper[playerid] = 0;
			AwaitingHelper[playerid] = 0;
			AwaitingAdmin[playerid] = 0;
			AwaitingReport[playerid] = 0;	
			PlayerStat[playerid][DeathWeapon] = 0;
			PlayerStat[playerid][DeathAmmo] = 0;
			KillTimer(PlayerPayDayT[playerid]);
	    }

	}
	SavePlayerData(playerid);
	if(PlayerStat[playerid][FullyRegistered] == 0)
	{
		new str1[128];
		format(str1, sizeof(str1), "Accounts/%s.ini", GetOOCName(playerid));
		fremove(str1);
	}
    return 1;
}


public OnPlayerSpawn(playerid)
{
	SetWeather(12);
	CloseInventory(playerid);
	INV_SEL_ITM[playerid] = 0;
	pSmokeAnim[playerid] = 0;
	pCraftWindow[playerid] = 0;
	CRF_ITM1[playerid] = 0;
	CRF_ITM1A[playerid] = 0;
	CRF_ITM2[playerid] = 0;
	CRF_ITM2A[playerid] = 0;
	CRF_ITM3[playerid] = 0;
	CRF_ITM3A[playerid] = 0;
	CRF_ITM4[playerid] = 0;
	CRF_ITM4A[playerid] = 0;
	CRF_ITM5[playerid] = 0;
	CRF_ITM5A[playerid] = 0;
	CRF_ITM6[playerid] = 0;
	CRF_ITM6A[playerid] = 0;
	CRF_ITM7[playerid] = 0;
	CRF_ITM7A[playerid] = 0;
	CRF_ITM8[playerid] = 0;
	CRF_ITM8A[playerid] = 0;
	CRF_ITM9[playerid] = 0;
	CRF_ITM9A[playerid] = 0;
	CRF_ITM10[playerid] = 0;
	CRF_ITM10A[playerid] = 0;
	INV_SEL_WEP[playerid] = 0;
	PFishing[playerid] = 0;
	PFishingT[playerid] = 0;
	PFishingCP[playerid] = 0;
	PFishingCT[playerid] = 0;
	if(PlayerStat[playerid][Logged] == 0)
	{
		SendClientMessage(playerid, GREY, "You have to be logged in before spawning.");
		Kick(playerid);
	}
	if(PlayerStat[playerid][Logged] == 1)
	{
		SetPlayerSkin(playerid, PlayerStat[playerid][LastSkin]);
	}
	new Float:PrisonCheckX, Float:PrisonCheckY, Float:PrisonCheckZ, str[128];
	GetPlayerPos(playerid, PrisonCheckX, PrisonCheckY, PrisonCheckZ);
    if(PNewReg[playerid] == 0)
	{
		SetPlayerColor(playerid, WHITE);
	}
	AFKTime[playerid] = 0;
	PlayerInCell[playerid] = 0;
	HiddenAdmin[playerid] = 0;
	if(PlayerStat[playerid][Dead] == 0)
	{
		SetPlayerHealth(playerid, PlayerStat[playerid][Health]);
		SetPlayerArmour(playerid, PlayerStat[playerid][Armour]);
	}
	if(PrisonCheckZ >= 900)
	{
		SetPlayerTime(playerid, 7, 0);
		InPrison[playerid] = 1;
		TogglePlayerControllable(playerid, false);
		SetTimerEx("LoadingObjects", 4000, false, "d", playerid);
	}
	if(PlayerStat[playerid][AnimsPreloaded] == 0)
	{
	    PreloadAnimLib(playerid,"BOMBER");
	   	PreloadAnimLib(playerid,"RAPPING");
	    PreloadAnimLib(playerid,"SHOP");
	   	PreloadAnimLib(playerid,"BEACH");
	   	PreloadAnimLib(playerid,"SMOKING");
	    PreloadAnimLib(playerid,"FOOD");
	    PreloadAnimLib(playerid,"ON_LOOKERS");
	    PreloadAnimLib(playerid,"DEALER");
		PreloadAnimLib(playerid,"CRACK");
		PreloadAnimLib(playerid,"CARRY");
		PreloadAnimLib(playerid,"COP_AMBIENT");
		PreloadAnimLib(playerid,"PARK");
		PreloadAnimLib(playerid,"INT_HOUSE");
		PreloadAnimLib(playerid,"FOOD");
		PreloadAnimLib(playerid,"PED");
		PreloadAnimLib(playerid,"KNIFE");
		PreloadAnimLib(playerid,"GHANDS");
		PreloadAnimLib(playerid,"GANGS");
		PreloadAnimLib(playerid,"GRAVEYARD");
		PreloadAnimLib(playerid,"FIGHT_B");
		PreloadAnimLib(playerid,"FIGHT_D");
		PlayerStat[playerid][AnimsPreloaded] = 1;
	}
	if(PlayerStat[playerid][WeaponSlot0] >= 1 || PlayerStat[playerid][WeaponSlot1] >= 1 || PlayerStat[playerid][WeaponSlot2] >= 1)
	{
		if(PlayerStat[playerid][WeaponSlot0] >= 1)
		{
			if(PlayerStat[playerid][WeaponSlot0] == 3)
			{
				SetPlayerAttachedObject(playerid, 6, 334, 8, -0.084999, 0.04399, 0.12200, -19.5, 88.0, -73.8);
			}
			if(PlayerStat[playerid][WeaponSlot0] == 5)
			{
				SetPlayerAttachedObject(playerid, 6, 336, 1, -0.02899, -0.15900, 0.000, 9.6999, 44.099, 0.000);
			}
			if(PlayerStat[playerid][WeaponSlot0] == 31)
			{
				SetPlayerAttachedObject(playerid, 6, 356, 1, 0.005, -0.14600, 0.06499, -2.4999, 38.0999, 2.2000);
			}
			if(PlayerStat[playerid][WeaponSlot0] == 25)
			{
				SetPlayerAttachedObject(playerid, 6, 349, 1, -0.07400, -0.165, 0.0, 0.0, 0.0, 0.0);
			}
		}
		if(PlayerStat[playerid][WeaponSlot1] >= 1)
		{
			if(PlayerStat[playerid][WeaponSlot1] == 3)
			{
				SetPlayerAttachedObject(playerid, 7, 334, 8, -0.084999, 0.04399, 0.12200, -19.5, 88.0, -73.8);
			}
			if(PlayerStat[playerid][WeaponSlot1] == 5)
			{
				SetPlayerAttachedObject(playerid, 7, 336, 1, -0.02899, -0.15900, 0.000, 9.6999, 44.099, 0.000);
			}
			if(PlayerStat[playerid][WeaponSlot1] == 31)
			{
				SetPlayerAttachedObject(playerid, 7, 356, 1, 0.005, -0.14600, 0.06499, -2.4999, 38.0999, 2.2000);
			}
			if(PlayerStat[playerid][WeaponSlot1] == 25)
			{
				SetPlayerAttachedObject(playerid, 7, 349, 1, -0.07400, -0.165, 0.0, 0.0, 0.0, 0.0);
			}
		}
		if(PlayerStat[playerid][WeaponSlot2] >= 1)
		{
			if(PlayerStat[playerid][WeaponSlot2] == 3)
			{
				SetPlayerAttachedObject(playerid, 8, 334, 8, -0.084999, 0.04399, 0.12200, -19.5, 88.0, -73.8);
			}
			if(PlayerStat[playerid][WeaponSlot2] == 5)
			{
				SetPlayerAttachedObject(playerid, 8, 336, 1, -0.02899, -0.15900, 0.000, 9.6999, 44.099, 0.000);
			}
			if(PlayerStat[playerid][WeaponSlot2] == 31)
			{
				SetPlayerAttachedObject(playerid, 8, 356, 1, 0.005, -0.14600, 0.06499, -2.4999, 38.0999, 2.2000);
			}
			if(PlayerStat[playerid][WeaponSlot2] == 25)
			{
				SetPlayerAttachedObject(playerid, 8, 349, 1, -0.07400, -0.165, 0.0, 0.0, 0.0, 0.0);
			}
		}
	}
	SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, 1);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 1);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_DESERT_EAGLE, 1);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_SHOTGUN, 999);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_SPAS12_SHOTGUN, 999);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, 1);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_MP5, 999);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_AK47, 999);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_M4, 999);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_SNIPERRIFLE, 999);
	SetPlayerScore(playerid, PlayerStat[playerid][PlayingHours]);
	if(PlayerStat[playerid][Dead] == 1)
	{
		SetPlayerPos(playerid,PlayerStat[playerid][DeathPosX], PlayerStat[playerid][DeathPosY], PlayerStat[playerid][DeathPosZ]);
        SetPlayerCameraPos(playerid,PlayerStat[playerid][DeathPosX], PlayerStat[playerid][DeathPosY], PlayerStat[playerid][DeathPosZ]+2.4);
        SetPlayerCameraLookAt(playerid,PlayerStat[playerid][DeathPosX], PlayerStat[playerid][DeathPosY], PlayerStat[playerid][DeathPosZ]);
		TogglePlayerControllable(playerid, 0);
		PlayerStat[playerid][Taser] = 0;
        SetHealth(playerid, 100.0);
        SetArmour(playerid, 0.0);
		SetPlayerSkin(playerid, PlayerStat[playerid][LastSkin]);
 		PlayerStat[playerid][DeathT] = 40;
        PlayerStat[playerid][BleedingToDeath] = 100;
		if(PlayerStat[playerid][DeathWeapon] >= 1)
		{
			ServerWeapon(playerid, PlayerStat[playerid][DeathWeapon], PlayerStat[playerid][DeathAmmo]);
		}
		PlayerStat[playerid][DeathWeapon] = 0;
		PlayerStat[playerid][DeathAmmo] = 0;
		ApplyAnimation(playerid, "KNIFE", "KILL_Knife_Ped_Die", 4.1, 0, 0, 0, 1, 0);
        SendClientMessage(playerid, RED, "You have blacked out. You are bleeding to death.");
        SendClientMessage(playerid, RED, "You can accept your death using /accept death.");
        SendClientMessage(playerid, RED, "If you were deathmatched, report the player using /report or on the forums.");
    }
    if(PlayerStat[playerid][InHospital] == 1)
	{
        new Random = random(sizeof(HospitalSpawns));
        SetPlayerPos(playerid, HospitalSpawns[Random][0], HospitalSpawns[Random][1], HospitalSpawns[Random][2]);
		SetPlayerCameraPos(playerid,1144.3436,-1308.6213,1024.00);
		SetPlayerCameraLookAt(playerid, 1138.2471,-1302.6396,1024.6106);
        SetHealth(playerid, 1.0);
        SetArmour(playerid, 0.0);
        TogglePlayerControllable(playerid, 0);
        SetPlayerInterior(playerid, 0);
        SetPlayerVirtualWorld(playerid, 0);
        ApplyAnimation(playerid, "PED", "FLOOR_hit_f", 4.1, 0, 1, 1, 1, 0, 1);
        PlayerStat[playerid][HospitalTime] = 49;
    }
    if(PlayerStat[playerid][InIsolatedCell] == 1)
	{
        SetPlayerPos(playerid, -209.4500,-201.2415,2.8665);
        SetPlayerVirtualWorld(playerid, playerid+0);
    }
    if(PlayerStat[playerid][AdminPrisoned] == 1)
	{
		if(PlayerStat[playerid][LogoutCuffs] == 1)
		{	
			format(str, sizeof(str), "%s has been admin jailed by Jesus Christ for 1080 seconds. Reason:[Loging out with cuffs].", GetOOCName(playerid));
			SendClientMessageToAll(RED, str);
			PlayerStat[playerid][LogoutCuffs] = 0;
		}
		SetPlayerPos(playerid, 32.2658,33.1848,3.1172);
        SetPlayerVirtualWorld(playerid, 5555);
        SetPlayerInterior(playerid, 0);
        TogglePlayerControllable(playerid, 0);
		TogglePlayerControllable(playerid, 0);
    }
    if(PlayerStat[playerid][Specing] == 1)
    {
        SetPlayerPos(playerid, Spec[playerid][SpecX], Spec[playerid][SpecY], Spec[playerid][SpecZ]);
        SetPlayerInterior(playerid,Spec[playerid][SpecInt]);
        SetPlayerVirtualWorld(playerid,Spec[playerid][SpecVW]);
        PlayerStat[playerid][Specing] = 0;
        PlayerStat[PlayerStat[playerid][SpecingID]][BeingSpeced] = 1;
        PlayerStat[PlayerStat[playerid][SpecingID]][BeingSpecedBy] = -1;
        PlayerStat[playerid][SpecingID] = -1;
    }
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    if(PlayerStat[playerid][UsingLoopingAnims] == 1)
	{
	    StopLoopingAnimation(playerid);
	}
	CloseInventory(playerid);
	INV_SEL_ITM[playerid] = 0;
	pSmokeAnim[playerid] = 0;
	pCraftWindow[playerid] = 0;
	CRF_ITM1[playerid] = 0;
	CRF_ITM1A[playerid] = 0;
	CRF_ITM2[playerid] = 0;
	CRF_ITM2A[playerid] = 0;
	CRF_ITM3[playerid] = 0;
	CRF_ITM3A[playerid] = 0;
	CRF_ITM4[playerid] = 0;
	CRF_ITM4A[playerid] = 0;
	CRF_ITM5[playerid] = 0;
	CRF_ITM5A[playerid] = 0;
	CRF_ITM6[playerid] = 0;
	CRF_ITM6A[playerid] = 0;
	CRF_ITM7[playerid] = 0;
	CRF_ITM7A[playerid] = 0;
	CRF_ITM8[playerid] = 0;
	CRF_ITM8A[playerid] = 0;
	CRF_ITM9[playerid] = 0;
	CRF_ITM9A[playerid] = 0;
	CRF_ITM10[playerid] = 0;
	CRF_ITM10A[playerid] = 0;
	INV_SEL_WEP[playerid] = 0;
	PFishing[playerid] = 0;
	PFishingT[playerid] = 0;
	PFishingCP[playerid] = 0;
	PFishingCT[playerid] = 0;
	PlayerStat[playerid][BPUSE] = 0;
	PlayerStat[playerid][BPDIF] = 0;
	PlayerStat[playerid][BPACD] = 0;
	PlayerStat[playerid][BPANM] = 0;
	PlayerStat[playerid][BPBAR] = 0;
	HoldingObject[playerid] = 0;
	PlayerSitting[playerid] = 0;
	HoldingTray[playerid] = 0;
	TrashAmount[playerid] = 0;
	if(PlayerClimbingRope[playerid] == 1)
	{
		RopeUsed = 0;
	}
	PlayerClimbingRope[playerid] = 0;
	if(UsingDisher[playerid] >= 1)
	{
		if(UsingDisher[playerid] == 1)
		{
			Sink1Used = 0;
		}
		else
		{
			Sink2Used = 0;
		}
	}
	UsingDisher[playerid] = 0;
	PlayerStat[playerid][DeathWeapon] = GetPlayerWeapon(playerid);
	PlayerStat[playerid][DeathAmmo] = GetPlayerAmmo(playerid);
	ResetWeapons(playerid); //NIGGA
	new Float: PosX, Float: PosY, Float: PosZ;
	GetPlayerPos(playerid, PosX, PosY, PosZ);
	PlayerStat[playerid][DeathPosX] = PosX;
	PlayerStat[playerid][DeathPosY] = PosY;
	PlayerStat[playerid][DeathPosZ] = PosZ;
	PlayerStat[playerid][Dead] = 1;
	PlayerStat[playerid][Deaths] += 1;
	PlayerStat[killerid][Kills] += 1;
	new deathreason[32];
	new str[128];
	switch (reason)
	{
	    case 0: format(deathreason, sizeof(deathreason), "Fists");
        case 1: format(deathreason, sizeof(deathreason), "Brass Knuckles");
        case 2: format(deathreason, sizeof(deathreason), "Golf Stick");
        case 3: format(deathreason, sizeof(deathreason), "Nite Stick");
        case 4: format(deathreason, sizeof(deathreason), "Knife");
        case 5: format(deathreason, sizeof(deathreason), "Baseball Bat");
        case 6: format(deathreason, sizeof(deathreason), "Shovel");
        case 7: format(deathreason, sizeof(deathreason), "Pool Cue");
        case 8: format(deathreason, sizeof(deathreason), "Katana");
        case 9: format(deathreason, sizeof(deathreason), "Chainsaw");
        case 10: format(deathreason, sizeof(deathreason), "Dildo");
        case 11: format(deathreason, sizeof(deathreason), "Small Vibrator");
        case 12: format(deathreason, sizeof(deathreason), "Large Vibrator");
        case 13: format(deathreason, sizeof(deathreason), "Vibrator");
        case 14: format(deathreason, sizeof(deathreason), "Flowers");
        case 15: format(deathreason, sizeof(deathreason), "Cane");
        case 16: format(deathreason, sizeof(deathreason), "Grenade");
        case 17: format(deathreason, sizeof(deathreason), "Smoke Grenade");
        case 18: format(deathreason, sizeof(deathreason), "Molotov Cocktail");
        case 19: format(deathreason, sizeof(deathreason), "Vehicle Weapon");
        case 20: format(deathreason, sizeof(deathreason), "Hydra Flare");
        case 21: format(deathreason, sizeof(deathreason), "Jetpack");
        case 22: format(deathreason, sizeof(deathreason), "9mm Pistol");
        case 23: format(deathreason, sizeof(deathreason), "Silenced 9mm Pistol");
        case 24: format(deathreason, sizeof(deathreason), "Desert Eagle");
        case 25: format(deathreason, sizeof(deathreason), "Shotgun");
        case 26: format(deathreason, sizeof(deathreason), "Sawnoff Shotgun");
        case 27: format(deathreason, sizeof(deathreason), "Combat Shotgun");
        case 28: format(deathreason, sizeof(deathreason), "Micro SMG");
        case 29: format(deathreason, sizeof(deathreason), "MP5");
        case 30: format(deathreason, sizeof(deathreason), "AK47");
        case 31: format(deathreason, sizeof(deathreason), "M4");
        case 32: format(deathreason, sizeof(deathreason), "Tec-9");
        case 33: format(deathreason, sizeof(deathreason), "Rifle");
        case 34: format(deathreason, sizeof(deathreason), "Sniper Rifle");
        case 35: format(deathreason, sizeof(deathreason), "Rocket Launcherr");
        case 36: format(deathreason, sizeof(deathreason), "Rocket Launcher");
        case 37: format(deathreason, sizeof(deathreason), "Flamethrower");
        case 38: format(deathreason, sizeof(deathreason), "Minigun");
        case 39: format(deathreason, sizeof(deathreason), "Satchels");
        case 40: format(deathreason, sizeof(deathreason), "Detonator");
        case 41: format(deathreason, sizeof(deathreason), "Spraycan");
        case 42: format(deathreason, sizeof(deathreason), "Fire Extinguisher");
        case 43: format(deathreason, sizeof(deathreason), "Camera");
        case 44: format(deathreason, sizeof(deathreason), "Nightvision Goggles");
        case 45: format(deathreason, sizeof(deathreason), "Infrared Goggles");
        case 46: format(deathreason, sizeof(deathreason), "Parachute");
        case 47: format(deathreason, sizeof(deathreason), "Unknown");
        case 48: format(deathreason, sizeof(deathreason), "Unknown");
        case 49:
		{
            format(deathreason, sizeof(deathreason), "Car Ram");
	    	format(str, sizeof(str), "ANTICHEAT: %s (ID: %d) has car rammed %s (ID: %d) to death.", GetOOCName(killerid), killerid, GetOOCName(playerid), playerid);
	    	SendAdminMessage(RED, str);
			AnticheatLog(str);
	    }
        case 50:
		{
            new VehicleID;
            GetPlayerVehicleID(VehicleID);
            if(GetVehicleModel(VehicleID) == 545)
            {
                format(deathreason, sizeof(deathreason), "Heli Blade");
	    	    format(str, sizeof(str), "ANTICHEAT: %s (ID: %d) has heli bladed %s (ID: %d) to death.", GetOOCName(killerid), killerid, GetOOCName(playerid), playerid);
	    	    SendAdminMessage(RED, str);
	    	    AnticheatLog(str);
	    	}
	    	else
	    	{
	    	    if(GetPlayerWeapon(killerid) != 32 || GetPlayerWeapon(killerid) != 28 || GetPlayerWeapon(killerid) != 29)
	    	    {
	    			format(deathreason, sizeof(deathreason), "Car Park");
	    	        format(str, sizeof(str), "ANTICHEAT: %s (ID: %d) has car parked %s (ID: %d) to death.", GetOOCName(killerid), killerid, GetOOCName(playerid), playerid);
	    	        SendAdminMessage(RED, str);
	    	        AnticheatLog(str);
	    		}
	    		else
	    		{
	    			format(deathreason, sizeof(deathreason), "Drive By Shooting");
	    	        format(str, sizeof(str), "ANTICHEAT: %s (ID: %d) has drive shot %s (ID: %d) to death.", GetOOCName(killerid), killerid, GetOOCName(playerid), playerid);
	    	        SendAdminMessage(RED, str);
	    	        AnticheatLog(str);
	    		}
	    	}
	    }
        case 51: format(deathreason, sizeof(deathreason), "Explosion");
        case 52: format(deathreason, sizeof(deathreason), "Unknown");
        case 53: format(deathreason, sizeof(deathreason), "Unknown");
        case 54: format(deathreason, sizeof(deathreason), "Unknown");
        case 55: format(deathreason, sizeof(deathreason), "Unknown");
        case 255: format(deathreason, sizeof(deathreason), "Unknown");
    }
	format(str, sizeof(str), "[KILL]%s was killed by %s, Weapon: %s", GetOOCName(playerid), GetOOCName(killerid), deathreason);
	SendAdminMessage(RED, str);
	format(str, sizeof(str), "%s was killed by %s, Weapon: %s", GetOOCName(playerid), GetOOCName(killerid), deathreason);
	DeathLog(str);
	if(PlayerStat[playerid][BeingSpeced] == 1)
    {
        TogglePlayerSpectating(PlayerStat[playerid][BeingSpecedBy], false);
    }
	if(PlayerStat[playerid][InIsolatedCell] == 1 || PlayerStat[playerid][AdminPrisoned] == 1)
	{
	    PlayerStat[playerid][Dead] = 0;
	}
    if(PlayerStat[playerid][CleaningTables] == 1)
	{
		ToggleCheckpoints(playerid);
		PlayerStat[playerid][CleaningTables] = 0;
    }
    if(PlayerStat[playerid][BeingDragged] == 1)
	{
		PlayerStat[playerid][BeingDraggedBy] = -1;
		PlayerStat[playerid][BeingDragged] = 0;
    }
	RemoveBox(playerid);
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	new str[128], weaponname[128];
	new weaponid = GetPlayerWeapon(playerid);
	new ammo = GetPlayerAmmo(playerid);
	if(weaponid == 0 && PlayerStat[playerid][WeaponPocketCD] == 0)
	{
		new WeaponsSlot1, Slot1Ammo, WeaponsSlot2, Slot2Ammo, WeaponSlot3, Slot3Ammo, WeaponSlot4, Slot4Ammo, WeaponSlot5, Slot5Ammo, WeaponSlot6, Slot6Ammo, WeaponSlot9, Slot9Ammo, WeaponSlot10, Slot10Ammo;
		GetPlayerWeaponData(playerid, 1, WeaponsSlot1, Slot1Ammo);
		GetPlayerWeaponData(playerid, 2, WeaponsSlot2, Slot2Ammo);
		GetPlayerWeaponData(playerid, 3, WeaponSlot3, Slot3Ammo);
		GetPlayerWeaponData(playerid, 4, WeaponSlot4, Slot4Ammo);
		GetPlayerWeaponData(playerid, 5, WeaponSlot5, Slot5Ammo);
		GetPlayerWeaponData(playerid, 6, WeaponSlot6, Slot6Ammo);
		GetPlayerWeaponData(playerid, 9, WeaponSlot9, Slot9Ammo);
		GetPlayerWeaponData(playerid, 10, WeaponSlot10, Slot10Ammo);
		if(WeaponsSlot1 >= 1 || WeaponsSlot2 >= 1 || WeaponSlot3 >= 1 || WeaponSlot4 >= 1 || WeaponSlot5 >= 1 || WeaponSlot6 >= 1 || WeaponSlot9 >= 1 || WeaponSlot10 >= 1)
		{
			if(WeaponsSlot1 >= 1 && Slot1Ammo >= 1)
			{
				SetPlayerAmmo(playerid, WeaponsSlot1, 0);
				ServerWeapon(playerid, WeaponsSlot1, Slot1Ammo);
			}
			if(WeaponsSlot2 >= 1 && Slot2Ammo >= 1)
			{
				SetPlayerAmmo(playerid, WeaponsSlot2, 0);
				ServerWeapon(playerid, WeaponsSlot2, Slot2Ammo);
			}
			if(WeaponSlot3 >= 1 && Slot3Ammo >= 1)
			{
				SetPlayerAmmo(playerid, WeaponSlot3, 0);
				ServerWeapon(playerid, WeaponSlot3, Slot3Ammo);
			}
			if(WeaponSlot4 >= 1 && Slot4Ammo >= 1)
			{
				SetPlayerAmmo(playerid, WeaponSlot4, 0);
				ServerWeapon(playerid, WeaponSlot4, Slot4Ammo);
			}
			if(WeaponSlot5 >= 1 && Slot5Ammo >= 1)
			{
				SetPlayerAmmo(playerid, WeaponSlot5, 0);
				ServerWeapon(playerid, WeaponSlot5, Slot5Ammo);
			}
			if(WeaponSlot6 >= 1 && Slot6Ammo >= 1)
			{
				SetPlayerAmmo(playerid, WeaponSlot6, 0);
				ServerWeapon(playerid, WeaponSlot6, Slot6Ammo);
			}
			if(WeaponSlot9 >= 1 && Slot9Ammo >= 1)
			{
				SetPlayerAmmo(playerid, WeaponSlot9, 0);
				ServerWeapon(playerid, WeaponSlot9, Slot9Ammo);
			}
			if(WeaponSlot10 >= 1 && Slot10Ammo >= 1)
			{
				SetPlayerAmmo(playerid, WeaponSlot10, 0);
				ServerWeapon(playerid, WeaponSlot10, Slot10Ammo);
			}
		}
	}
	if(weaponid >= 1 && PlayerStat[playerid][PlayingHours] < 5 && HackerKick[playerid] == 0)
	{
		HackerKick[playerid] = 1;
		GetWeaponName(weaponid ,weaponname, sizeof(weaponname));
		format(str, sizeof(str), "[BAN] [Admin: SERVER] [Reason: Weapon Hacking], [WEAPON:%s] [AMMO:%d].", weaponname, ammo);
		PlayerPunishLog(playerid, str);
		format(str, sizeof(str), "[ANTI-CHEAT] %s has been auto banned for holding a %s [AMMO:%d] while having less than 5 playing hours.", GetOOCName(playerid), weaponname, ammo);
		SendAdminMessage(GREEN, str);
		format(str, sizeof(str), "Server Weapon Anti-Cheat.", ammo);
		format(PlayerStat[playerid][BannedReason], 128, "%s", str);
		format(str, sizeof(str), "%s has been banned by Jesus Christ. Reason:[Weapon Anti-Cheat.]", GetOOCName(playerid));
		SendClientMessageToAll(RED, str);
		SendClientMessage(playerid, RED, "=========================================================");
		SendClientMessage(playerid, WHITE, "You have been banned by the server due to weapon hacking.");
		SendClientMessage(playerid, RED, "If you think you have gotten wrongly banned, please post");
		SendClientMessage(playerid, RED, "a ban appeal on our forums at www.HD-RP.net.");
		SendClientMessage(playerid, RED, "=========================================================");
		SetTimerEx("BanPlayer", 500, false, "i", playerid);
	}
	if(weaponid == 38 || weaponid == 37 || weaponid == 36 || weaponid == 35)
	{
		GetWeaponName(weaponid ,weaponname, sizeof(weaponname));
		format(str, sizeof(str), "[BAN] [Admin: SERVER] [Reason: Weapon Hacking], [WEAPON:%s] [AMMO:%d].", weaponname, ammo);
		PlayerPunishLog(playerid, str);
		format(str, sizeof(str), "[ANTI-CHEAT] %s has been auto banned for holding a %s [AMMO:%d].", GetOOCName(playerid), weaponname, ammo);
		SendAdminMessage(GREEN, str);
		format(str, sizeof(str), "Server Weapon Anti-Cheat.", ammo);
		format(PlayerStat[playerid][BannedReason], 128, "%s", str);
		format(str, sizeof(str), "%s has been banned by Jesus Christ. Reason:[Weapon Anti-Cheat.]", GetOOCName(playerid));
		SendClientMessageToAll(RED, str);
		SendClientMessage(playerid, RED, "=========================================================");
		SendClientMessage(playerid, WHITE, "You have been banned by the server due to weapon hacking.");
		SendClientMessage(playerid, RED, "If you think you have gotten wrongly banned, please post");
		SendClientMessage(playerid, RED, "a ban appeal on our forums at www.HD-RP.net.");
		SendClientMessage(playerid, RED, "=========================================================");
		SetTimerEx("BanPlayer", 1200, false, "i", playerid);
	}
	if(PlayerAFK[playerid] == 1)
	{
		KillTimer(AFKTimeKeeper[playerid]);
		PlayerAFK[playerid] = 0;
		AFKTime[playerid] = 0;
		SetPlayerHealth(playerid, PlayerStat[playerid][Health]);
		SetPlayerArmour(playerid, PlayerStat[playerid][Armour]);
	}
	CheckWeapons(playerid);
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
    IRC_GroupSayEx(gGroupID, IRC_AECHO_CHANNEL, "7[chat] 3%s (%d): %s", pNick(playerid), playerid, text);
	new str[128];
	if(PNewReg[playerid] == 1 && NewRegAwaiting[playerid] == 0)
	{
		if(strlen(text) < 10)
		{
			SendClientMessage(playerid, GREY, "Your answer has to be at least 10 characters long.");
			return 0;
		}
		if(NewRegQuestion[playerid] == 1)
		{
			INI_Open(Accounts(playerid));
			INI_WriteString("Answer1", text);
			INI_Save();
			INI_Close();
			format(str, sizeof(str), "Answer: %s", text);
			SendClientMessage(playerid, LIGHT_BLUE, str);
			SendClientMessage(playerid, LIGHT_GREEN, "Question number 2:");
			SendClientMessage(playerid, WHITE, "Question: What procedure should you take before engaging in sexually explicit content like rape?");
			format(PlayerStat[playerid][Answer1], 128, "%s", text);
			NewRegQuestion[playerid] = 2;
			return 0;
		}
		if(NewRegQuestion[playerid] == 2)
		{
			INI_Open(Accounts(playerid));
			INI_WriteString("Answer2", text);
			INI_Save();
			INI_Close();
			format(str, sizeof(str), "Answer: %s", text);
			SendClientMessage(playerid, LIGHT_BLUE, str);
			SendClientMessage(playerid, LIGHT_GREEN, "Question number 3:");
			SendClientMessage(playerid, WHITE, "Question: Explain Metagaming.");
			format(PlayerStat[playerid][Answer2], 128, "%s", text);
			NewRegQuestion[playerid] = 3;
			return 0;
		}
		if(NewRegQuestion[playerid] == 3)
		{
			INI_Open(Accounts(playerid));
			INI_WriteString("Answer3", text);
			INI_Save();
			INI_Close();
			format(str, sizeof(str), "Answer: %s", text);
			SendClientMessage(playerid, LIGHT_BLUE, str);
			SendClientMessage(playerid, LIGHT_GREEN, "Question number 4:");
			SendClientMessage(playerid, WHITE, "Question: Can you rob or scam players below 10 playing hours?");
			format(PlayerStat[playerid][Answer3], 128, "%s", text);
			NewRegQuestion[playerid] = 4;
			return 0;
		}
		if(NewRegQuestion[playerid] == 4)
		{
			INI_Open(Accounts(playerid));
			INI_WriteString("Answer4", text);
			INI_Save();
			INI_Close();
			format(str, sizeof(str), "Answer: %s", text);
			SendClientMessage(playerid, LIGHT_BLUE, str);
			SendClientMessage(playerid, LIGHT_GREEN, "Question number 5:");
			SendClientMessage(playerid, WHITE, "Question: Explain Powergaming.");
			format(PlayerStat[playerid][Answer4], 128, "%s", text);
			NewRegQuestion[playerid] = 5;
			return 0;
		}
		if(NewRegQuestion[playerid] == 5)
		{
			INI_Open(Accounts(playerid));
			INI_WriteString("Answer5", text);
			INI_Save();
			INI_Close();
			format(str, sizeof(str), "Answer: %s", text);
			SendClientMessage(playerid, LIGHT_BLUE, str);
			SendClientMessage(playerid, LIGHT_GREEN, "Thank you, your registration is complete. Please wait patiently while our staff is looking at it.");
			AwaitingApplications++;
			format(str, sizeof(str), "[APPLICATION] Player %s has completed the application, write /reviewapp [%d] in order to see it.", GetOOCName(playerid), playerid);
			SendAdminMessage(LIGHT_BLUE, str);
			format(PlayerStat[playerid][Answer5], 128, "%s", text);
			NewRegAwaiting[playerid] = 1;
			return 0;
		}
	}
    if(PlayerStat[playerid][Logged] == 0)
	{
		SendClientMessage(playerid, GREY, "You must be logged in.");
		return 0;
	}
	if(Server[CurrentGMX] >= 1)
	{
		SendClientMessage(playerid, GREY, "Please wait untill the server has fully restarted.");
		return 0;
	}
	if(PlayerStat[playerid][FullyRegistered] == 0)
	{
		if(PNewReg[playerid] == 1 && NewRegAwaiting[playerid] == 1)
		{
			format(str, sizeof(str), "You can't chat while waiting for your application to be reviewed.", PlayerStat[playerid][MuteTime]);
			SendClientMessage(playerid, GREY, str);
			return 0;
		}
		SendClientMessage(playerid, GREY, "You must enter your character information to chat.");
		return 0;
	}
	if(PlayerStat[playerid][Spawned] == 0)
	{
		SendClientMessage(playerid, GREY, "You must be spawned to chat.");
		return 0;
	}
	if(PlayerStat[playerid][Muted] == 1)
	{
		format(str, sizeof(str), "You can't chat while you're muted, you must wait %d seconds.", PlayerStat[playerid][MuteTime]);
		SendClientMessage(playerid, GREY, str);
		return 0;
	}
	else
	{
		if(PlayerStat[playerid][Dead] == 1)
		{
			format(str, sizeof(str), "[LOW]%s says : %s", GetICName(playerid), text);
		    SendNearByMessage(playerid, GREY, str, 5);
			ICLog(str);
			return 0;
		}
		if(PlayerStat[playerid][Tased] == 1)
		{
			format(str, sizeof(str), "[LOW]%s says : %s", GetICName(playerid), text);
		    SendNearByMessage(playerid, GREY, str, 5);
			ICLog(str);
			return 0;
		}
		if(PlayerStat[playerid][InHospital] >= 1)
		{
			SendClientMessage(playerid, RED, "You can't speak while you are recovering.");
			return 0;
		}
		if(PlayerStat[playerid][Dead] == 0 || PlayerStat[playerid][InHospital] == 0)
		{
			format(str, sizeof(str), "%s says : %s", GetICName(playerid), text);
			SendNearByChatMessage(playerid, str);
			ICLog(str);
			new Length = strlen(text);
        	new TalkTime = Length*120;
			ApplyAnimation(playerid, "PED","IDLE_CHAT", 4.1, 1, 1, 1, 1, 1);
        	KillTimer(Server[StopTalkingAnimation]);
        	Server[StopTalkingAnimation] = SetTimerEx("StopTalkingAnim", TalkTime, 0, "d", playerid);
			return 0;
		}
		if(PlayerStat[playerid][BPUSE] == 1)
		{
		    SendClientMessage(playerid, GREY, "You can't talk while lifting weights.");
			return 0;
		}
	}
	return 0;
}

forward AwaitingApplicationsReminder();
public AwaitingApplicationsReminder()
{
	if(AwaitingApplications >= 1)
	{
		new str[128], d, i;
		i = 0;
		d = 0;
		loop_start:
		if(IsPlayerConnected(i) == 1)
		{
			if(i >= 100)
			{
				goto script_continue;
			}
			else if(i <= 100)
			{
				if(NewRegAwaiting[i] == 1)
				{
					d++;
					i++;
					goto loop_start;
				}
				else
				{
					i++;
					goto loop_start;
				}
			}
		}
		script_continue:
		if(d >= 1)
		{
			format(str, sizeof(str), "[APPLICATIONS] There is currently %d awaiting application(s), please review them by typing /checkapplications.", d);
			SendAdminHelperMessage(GREEN, str);
		}
		else
		{
			AwaitingApplications = 0;
			i = 0;
			d = 0;
			return 1;
		}
	}
	return 1;
}

public StopTalkingAnim(playerid)
{
	ClearAnimations(playerid);
	StopLoopingAnimation(playerid);
	return 1;
}

forward DeathAnimation(playerid);
stock DeathAnimation(playerid)
{
	ApplyAnimation(playerid, "PED", "KO_shot_front", 4.1, 1, 1, 1, 1, 0, 0);
	return 1;
}

forward KickPlayer(playerid);
public KickPlayer(playerid)
{
	Kick(playerid);
	return 1;
}

forward BanPlayer(playerid);
public BanPlayer(playerid)
{
	Ban(playerid);
	return 1;
}

forward TrashCanTrashCreator();
public TrashCanTrashCreator()
{
	new str[128];
	if(Trash1Trash <= 48)
	{
		Trash1Trash += 2;
		Delete3DTextLabel(Trash1Label);
		format(str, sizeof(str), "Trash Can\n[%d] / [50]", Trash1Trash);
		Trash1Label = Create3DTextLabel(str, WHITE, 440.2632, 1571.0500, 1000.6298, 8.0, 0, 0);
	}
	if(Trash2Trash <= 48)
	{
		Trash2Trash += 2;
		Delete3DTextLabel(Trash2Label);
		format(str, sizeof(str), "Trash Can\n[%d] / [50]", Trash2Trash);
		Trash2Label = Create3DTextLabel(str, WHITE, 431.2000, 1604.6610, 1000.6298, 8.0, 0, 0);
	}
	if(Trash3Trash <= 48)
	{
		Trash3Trash += 2;
		Delete3DTextLabel(Trash3Label);
		format(str, sizeof(str), "Trash Can\n[%d] / [50]", Trash3Trash);
		Trash3Label = Create3DTextLabel(str, WHITE, 442.7476, 1591.0435, 1000.6298, 8.0, 0, 0);
	}
	if(Trash4Trash <= 48)
	{
		Trash4Trash += 2;
		Delete3DTextLabel(Trash4Label);
		format(str, sizeof(str), "Trash Can\n[%d] / [50]", Trash4Trash);
		Trash4Label = Create3DTextLabel(str, WHITE, 440.9911, 1643.5480, 1000.6298, 8.0, 0, 0);
	}
	if(Trash5Trash <= 48)
	{
		Trash5Trash += 2;
		Delete3DTextLabel(Trash5Label);
		format(str, sizeof(str), "Trash Can\n[%d] / [50]", Trash5Trash);
		Trash5Label = Create3DTextLabel(str, WHITE, 444.3441, 1646.5009, 1000.7, 8.0, 0, 0);
	}
	if(Trash6Trash <= 48)
	{
		Trash6Trash += 2;
		Delete3DTextLabel(Trash6Label);
		format(str, sizeof(str), "Trash Can\n[%d] / [50]", Trash6Trash);
		Trash6Label = Create3DTextLabel(str, WHITE, 207.7989, 1447.8103, 10.3810, 8.0, 0, 0);
	}
	if(Trash7Trash <= 48)
	{
		Trash7Trash += 2;
		Delete3DTextLabel(Trash7Label);
		format(str, sizeof(str), "Trash Can\n[%d] / [50]", Trash7Trash);
		Trash7Label = Create3DTextLabel(str, WHITE, 273.8112, 1449.6755, 10.3810, 8.0, 0, 0);
	}
	return 1;
}

stock TrashCanTrashUpdate()
{
	new str[128];
	Delete3DTextLabel(Trash1Label);
	format(str, sizeof(str), "Trash Can\n[%d] / [50]", Trash1Trash);
	Trash1Label = Create3DTextLabel(str, WHITE, 440.2632, 1571.0500, 1000.6298, 8.0, 0, 0);
	Delete3DTextLabel(Trash2Label);
	format(str, sizeof(str), "Trash Can\n[%d] / [50]", Trash2Trash);
	Trash2Label = Create3DTextLabel(str, WHITE, 431.2000, 1604.6610, 1000.6298, 8.0, 0, 0);
	Delete3DTextLabel(Trash3Label);
	format(str, sizeof(str), "Trash Can\n[%d] / [50]", Trash3Trash);
	Trash3Label = Create3DTextLabel(str, WHITE, 442.7476, 1591.0435, 1000.6298, 8.0, 0, 0);
	Delete3DTextLabel(Trash4Label);
	format(str, sizeof(str), "Trash Can\n[%d] / [50]", Trash4Trash);
	Trash4Label = Create3DTextLabel(str, WHITE, 440.9911, 1643.5480, 1000.6298, 8.0, 0, 0);
	Delete3DTextLabel(Trash5Label);
	format(str, sizeof(str), "Trash Can\n[%d] / [50]", Trash5Trash);
	Trash5Label = Create3DTextLabel(str, WHITE, 444.3441, 1646.5009, 1000.7, 8.0, 0, 0);
	Delete3DTextLabel(Trash6Label);
	format(str, sizeof(str), "Trash Can\n[%d] / [50]", Trash6Trash);
	Trash6Label = Create3DTextLabel(str, WHITE, 207.7989, 1447.8103, 10.3810, 8.0, 0, 0);
	Delete3DTextLabel(Trash7Label);
	format(str, sizeof(str), "Trash Can\n[%d] / [50]", Trash7Trash);
	Trash7Label = Create3DTextLabel(str, WHITE, 273.8112, 1449.6755, 10.3810, 8.0, 0, 0);
	return 1;
}

forward TableTrashCreator();
public TableTrashCreator()
{
	if(TableTrashCounter == 20) return 1;
	new randomtries;
	randomtries = 0;
	random_again:
	randomtries++;
	new Random = random(20);
	if(randomtries >= 15)
	{
		printf("[SERVER] This is the %d attempt to a random tray.", randomtries);
	}
	if(Random == 0)
	{
		if(Table1Spot0Used == 1) goto random_again;
		Table1Spot0Object1 = CreateDynamicObject(2767, 435.1019, 1642.7490, 1000.8380, 0, 0, 0);
		Table1Spot0Object2 = CreateDynamicObject(2823, 435.0908, 1642.7639, 1000.8605, 0, 0, 0);
		Table1Spot0Used = 1;
		TableTrashCounter++;
	}
	if(Random == 1)
	{
		if(Table1Spot1Used == 1) goto random_again;
		Table1Spot1Object1 = CreateDynamicObject(2767, 436.4199, 1642.7490, 1000.8380, 0, 0, 0);
		Table1Spot1Object2 = CreateDynamicObject(2823, 436.4211, 1642.7639, 1000.8605, 0, 0, 0);
		Table1Spot1Used = 1;
		TableTrashCounter++;
	}
	if(Random == 2)
	{
		if(Table1Spot2Used == 1) goto random_again;
		Table1Spot2Object1 = CreateDynamicObject(2767, 435.0883, 1642.0743, 1000.8380, 0, 0, 0);
		Table1Spot2Object2 = CreateDynamicObject(2823, 435.0771, 1642.0505, 1000.8605, 0, 0, 180.0000);
		Table1Spot2Used = 1;
		TableTrashCounter++;
	}
	if(Random == 3)
	{
		if(Table1Spot3Used == 1) goto random_again;
		Table1Spot3Object1 = CreateDynamicObject(2767, 436.4199, 1642.0743, 1000.8380, 0, 0, 0);
		Table1Spot3Object2 = CreateDynamicObject(2823, 436.4211, 1642.0505, 1000.8605, 0, 0, 180.0000);
		Table1Spot3Used = 1;
		TableTrashCounter++;
	}
	if(Random == 4)
	{
		if(Table2Spot0Used == 1) goto random_again;
		Table2Spot0Object1 = CreateDynamicObject(2767, 435.0883, 1639.5402, 1000.8380, 0, 0, 0);
		Table2Spot0Object2 = CreateDynamicObject(2823, 435.0771, 1639.5615, 1000.8605, 0, 0, 0);
		Table2Spot0Used = 1;
		TableTrashCounter++;
	}
	if(Random == 5)
	{
		if(Table2Spot1Used == 1) goto random_again;
		Table2Spot1Object1 = CreateDynamicObject(2767, 436.4199, 1639.5402, 1000.8380, 0, 0, 0);
		Table2Spot1Object2 = CreateDynamicObject(2823, 436.4211, 1639.5615, 1000.8605, 0, 0, 0);
		Table2Spot1Used = 1;
		TableTrashCounter++;
	}
	if(Random == 6)
	{
		if(Table2Spot2Used == 1) goto random_again;
		Table2Spot2Object1 = CreateDynamicObject(2767, 435.0883, 1638.8573, 1000.8380, 0, 0, 0);
		Table2Spot2Object2 = CreateDynamicObject(2823, 435.0771, 1638.8165, 1000.8605, 0, 0, 180.0000);
		Table2Spot2Used = 1;
		TableTrashCounter++;
	}
	if(Random == 7)
	{
		if(Table2Spot3Used == 1) goto random_again;
		Table2Spot3Object1 = CreateDynamicObject(2767, 436.4199, 1638.8573, 1000.8380, 0, 0, 0);
		Table2Spot3Object2 = CreateDynamicObject(2823, 436.4211, 1638.8165, 1000.8605, 0, 0, 180.0000);
		Table2Spot3Used = 1;
		TableTrashCounter++;
	}
	if(Random == 8)
	{
		if(Table3Spot0Used == 1) goto random_again;
		Table3Spot0Object1 = CreateDynamicObject(2767, 435.0883, 1636.3323, 1000.8380, 0, 0, 0);
		Table3Spot0Object2 = CreateDynamicObject(2823, 435.0771, 1636.3165, 1000.8605, 0, 0, 0);
		Table3Spot0Used = 1;
		TableTrashCounter++;
	}
	if(Random == 9)
	{
		if(Table3Spot1Used == 1) goto random_again;
		Table3Spot1Object1 = CreateDynamicObject(2767, 436.4199, 1636.3323, 1000.8380, 0, 0, 0);
		Table3Spot1Object2 = CreateDynamicObject(2823, 436.4211, 1636.3165, 1000.8605, 0, 0, 0);
		Table3Spot1Used = 1;
		TableTrashCounter++;
	}
	if(Random == 10)
	{
		if(Table3Spot2Used == 1) goto random_again;
		Table3Spot2Object1 = CreateDynamicObject(2767, 435.0883, 1635.6503, 1000.8380, 0, 0, 0);
		Table3Spot2Object2 = CreateDynamicObject(2823, 435.0771, 1635.6365, 1000.8605, 0, 0, 180.0000);
		Table3Spot2Used = 1;
		TableTrashCounter++;
	}
	if(Random == 11)
	{
		if(Table3Spot3Used == 1) goto random_again;
		Table3Spot3Object1 = CreateDynamicObject(2767, 436.4199, 1635.6503, 1000.8380, 0, 0, 0);
		Table3Spot3Object2 = CreateDynamicObject(2823, 436.4211, 1635.6365, 1000.8605, 0, 0, 180.0000);
		Table3Spot3Used = 1;
		TableTrashCounter++;
	}
	if(Random == 12)
	{
		if(Table4Spot0Used == 1) goto random_again;
		Table4Spot0Object1 = CreateDynamicObject(2767, 430.7341, 1638.7535, 1000.8380, 0, 0, 0);
		Table4Spot0Object2 = CreateDynamicObject(2823, 430.7348, 1638.7673, 1000.8605, 0, 0, 0);
		Table4Spot0Used = 1;
		TableTrashCounter++;
	}
	if(Random == 13)
	{
		if(Table4Spot1Used == 1) goto random_again;
		Table4Spot1Object1 = CreateDynamicObject(2767, 432.1181, 1638.7535, 1000.8380, 0, 0, 0);
		Table4Spot1Object2 = CreateDynamicObject(2823, 432.1228, 1638.7673, 1000.8605, 0, 0, 0);
		Table4Spot1Used = 1;
		TableTrashCounter++;
	}
	if(Random == 14)
	{
		if(Table4Spot2Used == 1) goto random_again;
		Table4Spot2Object1 = CreateDynamicObject(2767, 430.7351, 1638.0706, 1000.8380, 0, 0, 0);
		Table4Spot2Object2 = CreateDynamicObject(2823, 430.7348, 1638.0664, 1000.8605, 0, 0, 180.0000);
		Table4Spot2Used = 1;
		TableTrashCounter++;
	}
	if(Random == 15)
	{
		if(Table4Spot3Used == 1) goto random_again;
		Table4Spot3Object1 = CreateDynamicObject(2767, 432.1181, 1638.0706, 1000.8380, 0, 0, 0);
		Table4Spot3Object2 = CreateDynamicObject(2823, 432.1228, 1638.0664, 1000.8605, 0, 0, 180.0000);
		Table4Spot3Used = 1;
		TableTrashCounter++;
	}
	if(Random == 16)
	{
		if(Table5Spot0Used == 1) goto random_again;
		Table5Spot0Object1 = CreateDynamicObject(2767, 430.7341, 1635.6615, 1000.8380, 0, 0, 0);
		Table5Spot0Object2 = CreateDynamicObject(2823, 430.7348, 1635.6733, 1000.8605, 0, 0, 0);
		Table5Spot0Used = 1;
		TableTrashCounter++;
	}
	if(Random == 17)
	{
		if(Table5Spot1Used == 1) goto random_again;
		Table5Spot1Object1 = CreateDynamicObject(2767, 432.1181, 1635.6595, 1000.8380, 0, 0, 0);
		Table5Spot1Object2 = CreateDynamicObject(2823, 432.1228, 1635.6733, 1000.8605, 0, 0, 0);
		Table5Spot1Used = 1;
		TableTrashCounter++;
	}
	if(Random == 18)
	{
		if(Table5Spot2Used == 1) goto random_again;
		Table5Spot2Object1 = CreateDynamicObject(2767, 430.7341, 1634.9775, 1000.8380, 0, 0, 0);
		Table5Spot2Object2 = CreateDynamicObject(2823, 430.7348, 1634.9714, 1000.8605, 0, 0, 180.0000);
		Table5Spot2Used = 1;
		TableTrashCounter++;
	}
	if(Random == 19)
	{
		if(Table5Spot3Used == 1) goto random_again;
		Table5Spot3Object1 = CreateDynamicObject(2767, 432.1181, 1634.9796, 1000.8380, 0, 0, 0);
		Table5Spot3Object2 = CreateDynamicObject(2823, 432.1228, 1634.9714, 1000.8605, 0, 0, 180.0000);
		Table5Spot3Used = 1;
		TableTrashCounter++;
	}
	return 1;
}

forward KitchenKnife();
public KitchenKnife()
{
	if(kitchencounter >= 4)
	{
		if(kitchenknife == 0)
		{
			new Random = random(4);
			if(Random == 3)
			{
				kitchknife = CreateDynamicObject(335, 444.0352, 1647.4424, 1000.3264, 90.0000, 0.000, -47.0000);
				kitchenknife = 1;
				kitchencounter = 0;
				return 1;
			}
		}
	}
	kitchencounter++;
	return 1;
}

stock CountTraysDown()
{
	if(FoodTrayCounter == 0)
	{
		DestroyDynamicObject(FoodTray1);
	}
	if(FoodTrayCounter == 1)
	{
		DestroyDynamicObject(FoodTray2);
	}
	if(FoodTrayCounter == 2)
	{
		DestroyDynamicObject(FoodTray3);
	}
	if(FoodTrayCounter == 3)
	{
		DestroyDynamicObject(FoodTray4);
	}
	if(FoodTrayCounter == 4)
	{
		DestroyDynamicObject(FoodTray5);
	}
	if(FoodTrayCounter == 5)
	{
		DestroyDynamicObject(FoodTray6);
	}
	if(FoodTrayCounter == 6)
	{
		DestroyDynamicObject(FoodTray7);
	}
	if(FoodTrayCounter == 7)
	{
		DestroyDynamicObject(FoodTray8);
	}
	if(FoodTrayCounter == 8)
	{
		DestroyDynamicObject(FoodTray9);
	}
	if(FoodTrayCounter == 9)
	{
		DestroyDynamicObject(FoodTray10);
	}
	if(FoodTrayCounter == 10)
	{
		DestroyDynamicObject(FoodTray11);
	}
	if(FoodTrayCounter >= 11)
	{
		FoodTrayCounter = 11;
	}
	return 1;
}

stock CountTraysUp()
{
	if(FoodTrayCounter == 1)
	{
		FoodTray1 = CreateDynamicObject(2767, 444.48050, 1631.99805, 1000.90668,   0.00000, 0.00000, -90.00000);// [1]
	}
	if(FoodTrayCounter == 2)
	{
		FoodTray2 = CreateDynamicObject(2767, 444.48050, 1631.99805, 1000.91870,   0.00000, 0.00000, -90.00000);// [2]

	}
	if(FoodTrayCounter == 3)
	{
		FoodTray3 = CreateDynamicObject(2767, 444.48050, 1631.99805, 1000.93268,   0.00000, 0.00000, -90.00000);// [3]

	}
	if(FoodTrayCounter == 4)
	{
		FoodTray4 = CreateDynamicObject(2767, 444.48050, 1631.99805, 1000.94672,   0.00000, 0.00000, -90.00000);// [4]

	}
	if(FoodTrayCounter == 5)
	{
		FoodTray5 = CreateDynamicObject(2767, 444.48050, 1631.99805, 1000.95868,   0.00000, 0.00000, -90.00000);// [5]

	}
	if(FoodTrayCounter == 6)
	{
		FoodTray6 = CreateDynamicObject(2767, 444.48050, 1631.99805, 1000.97070,   0.00000, 0.00000, -90.00000);// [6]

	}
	if(FoodTrayCounter == 7)
	{
		FoodTray7 = CreateDynamicObject(2767, 444.48050, 1631.99805, 1000.98273,   0.00000, 0.00000, -90.00000);// [7]

	}
	if(FoodTrayCounter == 8)
	{
		FoodTray8 = CreateDynamicObject(2767, 444.48050, 1631.99805, 1000.99268,   0.00000, 0.00000, -90.00000);// [8]

	}
	if(FoodTrayCounter == 9)
	{
		FoodTray9 = CreateDynamicObject(2767, 444.48050, 1631.99805, 1001.00269,   0.00000, 0.00000, -90.00000);// [9]

	}
	if(FoodTrayCounter == 10)
	{
		FoodTray10 = CreateDynamicObject(2767, 444.48050, 1631.99805, 1001.01270,   0.00000, 0.00000, -90.00000);// [10]

	}
	if(FoodTrayCounter == 11)
	{
		FoodTray11 = CreateDynamicObject(2767, 444.48050, 1631.99805, 1001.02472,   0.00000, 0.00000, -90.00000);// [11]
	}
	if(FoodTrayCounter >= 12)
	{
		FoodTrayCounter = 11;
		return 1;
	}
	return 1;
}

public OnPlayerCommandReceived(playerid, cmdtext[])
{
	new str[128];
	if(PlayerStat[playerid][Logged] == 0)
	{
		SendClientMessage(playerid, GREY, "You must be logged in.");
		return 0;
	}
	if(Server[CurrentGMX] >= 1)
	{
		SendClientMessage(playerid, GREY, "Please wait untill the server has fully restarted.");
		return 0;
	}
	if(PlayerStat[playerid][FullyRegistered] == 0)
	{
		if(PNewReg[playerid] == 1 && NewRegAwaiting[playerid] == 1)
		{
			format(str, sizeof(str), "You can't use commands while waiting for your application to be reviewed.", PlayerStat[playerid][MuteTime]);
			SendClientMessage(playerid, GREY, str);
			return 0;
		}
		SendClientMessage(playerid, GREY, "You must enter your character information before using commands.");
		return 0;
	}
	if(PlayerStat[playerid][Spawned] == 0)
	{
		SendClientMessage(playerid, GREY, "You must be spawned.");
		return 0;
	}
	if(PlayerStat[playerid][Muted] == 1)
	{
		format(str, sizeof(str), "You can't use commands while you're muted, you must wait %d seconds.", PlayerStat[playerid][MuteTime]);
		SendClientMessage(playerid, GREY, str);
		return 0;
	}
	if(PlayerStat[playerid][AdminLogged] == 0 && PlayerStat[playerid][AdminLevel] >= 1)
	{
		format(str, sizeof(str), "/admincode %s", PlayerStat[playerid][AdminCode]);
		if(!strcmp(cmdtext,str, true))
		{
			return 1;
		}
		if(!strcmp(cmdtext,"/admincode", true))
		{
			return 1;
		}
		AdminCommandTry[playerid]++;
		SendClientMessage(playerid, GREY, "You didn't place your security code.");
		if(AdminCommandTry[playerid] >= 3)
		{
			format(str, sizeof(str), "[WARNING] Account %s (Admin Name: %s) has attempted the third command without security login and lost his Administrator powers.", GetOOCName(playerid), GetForumNameNC(playerid));
			SendAdminMessage(RED, str);
			INI_Open(Accounts(playerid));
			INI_WriteInt("AdminLevel", 0); 
			INI_Save();
			INI_Close();
			PlayerStat[playerid][AdminLevel] = 0;
		}
		if(AdminCommandTry[playerid] >= 2)
		{
			format(str, sizeof(str), "[WARNING] Account %s (Admin Name: %s) has attempted the second command without security login.", GetOOCName(playerid), GetForumNameNC(playerid));
			SendAdminMessage(RED, str);
		}
		return 0;
	}
    return 1;
}

COMMAND:help(playerid, params[])
{
    ShowPlayerDialog(playerid, DIALOG_HELP, DIALOG_STYLE_MSGBOX, "Help menu", "{ffffff}There are sevral commands to help you on the server.{0df466}\n/cmds\n/animhelp\n/cellhelp\n/factionhelp\n/ganghelp\n/jobhelp\n{ffffff}You can check online admins and helpers by using the /helpers or /admins command.\nYou can request help from our online helpers by using /helpme command or admin help by /ra.", "OK", "OK");
    return 1;
}

COMMAND:study(playerid)
{
    if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious."); 
	if(IsPlayerInRangeOfPoint(playerid, 1.2, 456.6567, 1615.7222, 1001.0886)) // Metal Working
    {
		ShowPlayerDialog(playerid, DIALOG_EXAM1T1, DIALOG_STYLE_MSGBOX, "Metal Working Book", "Metalworking generally is divided into the following categories, forming, cutting, and, joining.\nEach of these categories contain various processes.\nPrior to most operations, the metal must be marked out and/or measured, depending on the desired finished product.", "NEXT", "OK");
	}
	return 1;
}

COMMAND:exam(playerid)
{
    if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious."); 
	if(IsPlayerInRangeOfPoint(playerid, 4.5, 451.7633, 1621.9839, 1001.4982))
    {
		ShowPlayerDialog(playerid, DIALOG_EXAM0, DIALOG_STYLE_LIST, "Exam", "Information\nMetal Working Exam", "Select", "Quit");
	}
	return 1;
}

COMMAND:ciggy(playerid, params[])
{
    if(PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
    if(PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You are cuffed or being dragged.");
	if(pSmokeAnim[playerid] == 0) return SendClientMessage(playerid, GREY, "You are not smoking.");
	new item[20];
    if(sscanf(params,"s[20]", item))
	{
		SendClientMessage(playerid, GREY, "USAGE: /ciggy [style]");
		SendClientMessage(playerid, GREY, "Styles: Hand, Mouth1, Mouth2, Mouth3, Mouth4, Mouth5.");
	    return 1;
	}
    else if(!strcmp(item, "Hand", true))
    {
		if(pSmokeAnim[playerid] <= 10) return SendClientMessage(playerid, GREY, "You already hold a cigarette/joint in your hand.");
		if(pSmokeAnim[playerid] == 11) // Cigg
		{
			RemovePlayerAttachedObject(playerid, 9);
			SetPlayerAttachedObject(playerid, 0, 19625, 6, 0.1, 0.023, 0.024, 0.0, 2.1, 58.899);
			pSmokeAnim[playerid] = 1;
			return 1;
		}
		if(pSmokeAnim[playerid] == 12) // Joint
		{
			RemovePlayerAttachedObject(playerid, 9);
			SetPlayerAttachedObject(playerid, 0, 3027, 6, 0.09, 0.015, 0.009, 64.399, 91.399, 20.2);
			pSmokeAnim[playerid] = 2;
			return 1;
		}
	}
    else if(!strcmp(item, "Mouth1", true))
    {
		if(pSmokeAnim[playerid] == 1 || pSmokeAnim[playerid] == 11) // Cigg
		{
			if(pSmokeAnim[playerid] == 1)
			{
				RemovePlayerAttachedObject(playerid, 0);
			}
			RemovePlayerAttachedObject(playerid, 9);
			SetPlayerAttachedObject(playerid, 9, 19625, 18, 0.074, -0.016, 0.0, -3.29999, 0.0, 76.199);
			pSmokeAnim[playerid] = 11;
			return 1;
		}
		if(pSmokeAnim[playerid] == 2 || pSmokeAnim[playerid] == 12) // Joint
		{
			if(pSmokeAnim[playerid] == 2)
			{
				RemovePlayerAttachedObject(playerid, 0);
			}
			RemovePlayerAttachedObject(playerid, 9);
			SetPlayerAttachedObject(playerid, 9, 3027, 18, 0.058, -0.045, 0.004, -107.099, 105.5, -23);
			pSmokeAnim[playerid] = 12;
			return 1;
		}
	}
    else if(!strcmp(item, "Mouth2", true))
    {
		if(pSmokeAnim[playerid] == 1 || pSmokeAnim[playerid] == 11) // Cigg
		{
			if(pSmokeAnim[playerid] == 1)
			{
				RemovePlayerAttachedObject(playerid, 0);
			}
			RemovePlayerAttachedObject(playerid, 9);
			SetPlayerAttachedObject(playerid, 9, 19625, 18, 0.074, -0.036, 0.0, -3.29999, 0.0, 76.199);
			pSmokeAnim[playerid] = 11;
			return 1;
		}
		if(pSmokeAnim[playerid] == 2 || pSmokeAnim[playerid] == 12) // Joint
		{
			if(pSmokeAnim[playerid] == 2)
			{
				RemovePlayerAttachedObject(playerid, 0);
			}
			RemovePlayerAttachedObject(playerid, 9);
			SetPlayerAttachedObject(playerid, 9, 3027, 18, 0.058, -0.021, 0.004, -107.099, 105.5, -23);
			pSmokeAnim[playerid] = 12;
			return 1;
		}
	}
    else if(!strcmp(item, "Mouth3", true))
    {
		if(pSmokeAnim[playerid] == 1 || pSmokeAnim[playerid] == 11) // Cigg
		{
			if(pSmokeAnim[playerid] == 1)
			{
				RemovePlayerAttachedObject(playerid, 0);
			}
			RemovePlayerAttachedObject(playerid, 9);
			SetPlayerAttachedObject(playerid, 9, 19625, 18, 0.074, -0.098, 0.0, -3.29999, 0.0, 76.199);
			pSmokeAnim[playerid] = 11;
			return 1;
		}
		if(pSmokeAnim[playerid] == 2 || pSmokeAnim[playerid] == 12) // Joint
		{
			if(pSmokeAnim[playerid] == 2)
			{
				RemovePlayerAttachedObject(playerid, 0);
			}
			RemovePlayerAttachedObject(playerid, 9);
			SetPlayerAttachedObject(playerid, 9, 3027, 18, 0.058, -0.086, 0.004, -107.099, 105.5, -23);
			pSmokeAnim[playerid] = 12;
			return 1;
		}
	}
    else if(!strcmp(item, "Mouth4", true))
    {
		if(pSmokeAnim[playerid] == 1 || pSmokeAnim[playerid] == 11) // Cigg
		{
			if(pSmokeAnim[playerid] == 1)
			{
				RemovePlayerAttachedObject(playerid, 0);
			}
			RemovePlayerAttachedObject(playerid, 9);
			SetPlayerAttachedObject(playerid, 9, 19625, 18, 0.074, -0.031, 0.0, -3.29999, 0.0, 76.199);
			pSmokeAnim[playerid] = 11;
			return 1;
		}
		if(pSmokeAnim[playerid] == 2 || pSmokeAnim[playerid] == 12) // Joint
		{
			if(pSmokeAnim[playerid] == 2)
			{
				RemovePlayerAttachedObject(playerid, 0);
			}
			RemovePlayerAttachedObject(playerid, 9);
			SetPlayerAttachedObject(playerid, 9, 3027, 18, 0.058, -0.045, 0.004, -107.099, 105.5, -23);
			pSmokeAnim[playerid] = 12;
			return 1;
		}
	}
    else if(!strcmp(item, "Mouth5", true))
    {
		if(pSmokeAnim[playerid] == 1 || pSmokeAnim[playerid] == 11) // Cigg
		{
			if(pSmokeAnim[playerid] == 1)
			{
				RemovePlayerAttachedObject(playerid, 0);
			}
			RemovePlayerAttachedObject(playerid, 9);
			SetPlayerAttachedObject(playerid, 9, 19625, 18, 0.074, -0.054, 0.0, -3.29999, 0.0, 76.199);
			pSmokeAnim[playerid] = 11;
			return 1;
		}
		if(pSmokeAnim[playerid] == 2 || pSmokeAnim[playerid] == 12) // Joint
		{
			if(pSmokeAnim[playerid] == 2)
			{
				RemovePlayerAttachedObject(playerid, 0);
			}
			RemovePlayerAttachedObject(playerid, 9);
			SetPlayerAttachedObject(playerid, 9, 3027, 18, 0.058, -0.025, 0.004, -107.099, 105.5, -23);
			pSmokeAnim[playerid] = 12;
			return 1;
		}
	}
    else
	{
		SendClientMessage(playerid, GREY, "USAGE: /ciggy [style]");
		SendClientMessage(playerid, GREY, "Styles: Hand, Mouth1, Mouth2, Mouth3, Mouth4, Mouth5.");
	    return 1;
	}
	return 1;
}

COMMAND:removeo(playerid)
{
	if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1)
	{
		RemovePlayerAttachedObject(playerid, 0);
		pSmokeAnim[playerid] = 0;
		RemovePlayerAttachedObject(playerid, 9);
		SendClientMessage(playerid, CMD_COLOR, "[SERVER]Objects detached.");
		return 1;
	}
	if(pSmokeAnim[playerid] >= 11)
	{
		RemovePlayerAttachedObject(playerid, 9);
	}
	if(pSmokeAnim[playerid] >= 1)
	{
		ApplyAnimation(playerid, "SMOKING", "M_smk_out", 4.1, 0, 0, 0, 0, 3000);
		pSmokeAnim[playerid] = 0;
	}
	RemovePlayerAttachedObject(playerid, 0);
	SendClientMessage(playerid, CMD_COLOR, "[SERVER]Objects detached and removed animation.");
	SetPlayerSpecialAction(playerid,0);
	return 1;
}

COMMAND:whatismypos(playerid)
{
	new Float:posX, Float:posY, Float:posZ, str[128];
	GetPlayerPos(playerid, posX, posY, posZ);
	format(str, sizeof(str), "Your position is: [X:%f] [Y:%f] [Z:%f].", posX, posY, posZ);
	SendClientMessage(playerid, LIGHT_GREEN, str);
	return 1;
}

COMMAND:playsound(playerid, params[])
{
	new quantity;
    if(sscanf(params,"d", quantity))
	{
		SendClientMessage(playerid, GREY, "USAGE: /playsound [soundid]");
	    return 1;
	}
	PlayerPlaySound(playerid, quantity, 0, 0, 0);
	return 1;
}

COMMAND:cmds(playerid, params[])
{
	if(PlayerStat[playerid][AdminLevel] >= 1)
	{
		SendClientMessage(playerid, WHITE, "Commands:");
		SendClientMessage(playerid, WHITE, "/changepw, /me, /do, /c, /ame, /o{ooc}, /b, /low, /w{hisper}, /s{shout}");
		SendClientMessage(playerid, WHITE, "/time, /pm, /togooc, /togpm, /helpme, /report, /ra, /maskreport, (/mreport), /stats");
		SendClientMessage(playerid, WHITE, "/pay, /give, /showprisonid, /job, /accept, /buycell, /coin");
		SendClientMessage(playerid, WHITE, "/locker, /helpers, /admins, /warnings, /pocketweapon, /pullweapon");
		SendClientMessage(playerid, WHITE, "/rolljoint, /usecrack, /liftweights, /removeo, /ciggy.");
		SendClientMessage(playerid, GREEN, "Check your Admin Command with /ah(elp).");
		SendClientMessage(playerid, GREEN, "Check your Helper Commands with /hh(elp).");
		return 1;
	}
	else
	{
		SendClientMessage(playerid, WHITE, "Commands:");
		SendClientMessage(playerid, WHITE, "/changepw, /me, /do, /c, /ame, /o{ooc}, /b, /low, /w{hisper}, /s{shout}");
		SendClientMessage(playerid, WHITE, "/time, /pm, /togooc, /togpm, /helpme, /report, /ra, /maskreport, (/mreport), /stats");
		SendClientMessage(playerid, WHITE, "/pay, /give, /showprisonid, /job, /accept, /buycell, /coin");
		SendClientMessage(playerid, WHITE, "/locker, /helpers, /admins, /warnings, /pocketweapon, /pullweapon");
		SendClientMessage(playerid, WHITE, "/rolljoint, /usecrack, /liftweights, /removeo, /ciggy.");
		return 1;
	}
}

COMMAND:ganghelp(playerid, params[])
{
	if(PlayerStat[playerid][GangRank] >= 5)
	{
	SendClientMessage(playerid, WHITE, "Leaders Commands:");
	SendClientMessage(playerid, WHITE, "/adjustgang, /setgrank, /ginvite, /gkick.");
	SendClientMessage(playerid, WHITE, "Gang Members Commands:");
	SendClientMessage(playerid, WHITE, "/g, /gclothes, /gmembers, /getweap, /getdrugs, /gquit.");
	}
	else if(PlayerStat[playerid][GangRank] >= 1)
	{
	SendClientMessage(playerid, WHITE, "Gang Members Commands:");
	SendClientMessage(playerid, WHITE, "/g, /gclothes, /gmembers, /getweap, /getdrugs, /gquit.");
	}
	else if(PlayerStat[playerid][GangRank] == 0)
	{
	SendClientMessage(playerid, GREY, "You are not in a gang.");
	}
	return 1;
}

COMMAND:factionhelp(playerid, params[])
{
	if(PlayerStat[playerid][FactionID] >= 1)
	{
		if(PlayerStat[playerid][FactionID] == 1)
		{
			if(PlayerStat[playerid][FactionRank] >= 5) //Police
			{
				SendClientMessage(playerid, WHITE, "Leaders Commands:");
				SendClientMessage(playerid, WHITE, "/invite, /setrank, /uninvite.");
				SendClientMessage(playerid, WHITE, "Members Commands:");
				SendClientMessage(playerid, WHITE, "/r, /d, /f, /members, /flocker, /shocker, /frisk, /cuff, /uncuff, /ann.");
				SendClientMessage(playerid, WHITE, "/securitycamera, /drag, /stopdrag, /take, /quitfaction.");
				SendClientMessage(playerid, WHITE, "/drag, /stopdrag, /take, /quitfaction, /door.");
				return 1;
			}
			else if(PlayerStat[playerid][FactionRank] >= 1)
			{
				SendClientMessage(playerid, WHITE, "Members Commands:");
				SendClientMessage(playerid, WHITE, "/r, /d, /f, /members, /flocker, /shocker, /frisk, /cuff, /uncuff, /ann.");
				SendClientMessage(playerid, WHITE, "/securitycamera, /drag, /stopdrag, /take, /quitfaction.");
				SendClientMessage(playerid, WHITE, "/drag, /stopdrag, /take, /quitfaction, /door.");
				return 1;
			}
		}
		else if(PlayerStat[playerid][FactionID] ==2) //Medic
		{
			if(PlayerStat[playerid][FactionRank] >= 5)
			{
				SendClientMessage(playerid, WHITE, "Leaders Commands:");
				SendClientMessage(playerid, WHITE, "/invite, /giverank, /uninvite.");
				SendClientMessage(playerid, WHITE, "Members Commands:");
				SendClientMessage(playerid, WHITE, "/r, /f, /d, /members, /flocker, /heal, /stretcher, /putonstretcher, /takeoffstretcher, /quitfaction.");
				return 1;
			}
			else if(PlayerStat[playerid][FactionRank] >= 1)
			{
				SendClientMessage(playerid, WHITE, "Members Commands:");
				SendClientMessage(playerid, WHITE, "/r, /f, /d, /members, /flocker, /heal, /stretcher, /putonstretcher, /takeoffstretcher, /quitfaction.");
				return 1;
			}
		}
	}
	else
	{
		SendClientMessage(playerid, GREY, "You are not in a faction.");
	}
	return 1;
}

COMMAND:animhelp(playerid, params[])
{
	SendClientMessage(playerid, WHITE, "Animations list:");
	SendClientMessage(playerid, WHITE, "/handsup, /hide, /aim, /lookout, /bomb, /laugh, /slapass, /win, /lose");
	SendClientMessage(playerid, WHITE, "/walk, /gsign, /ghand, /chant, /sit, /lay, /vomit, /eatstand, /crossarms");
	SendClientMessage(playerid, WHITE, "/wave, /taichi, /deal, /crack, /leansmoke, /fucku, /dance, /idle, /stretch");
	SendClientMessage(playerid, WHITE, "/rap, /shakehand, /piss, /gwalk /angry, /follow /injured");
	SendClientMessage(playerid, WHITE, "/grkick /gpunch.");
	return 1;
}

// --==============================================| Marco's Training Program ;) |=====================================--
COMMAND:climbrope(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 0.5, 224.1172, 1472.6801, 10.6878))
	{
		if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
		if(PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You are cuffed or being dragged.");
		if(RopeUsed == 1) return SendClientMessage(playerid, GREY, "Someone is using the rope already, wait for him to finish.");
		SetPlayerPos(playerid, 224.1172, 1472.6801, 11.2878);
		SetPlayerCameraPos(playerid, 224.5748, 1470.6572, 11.6830);
		SetPlayerCameraLookAt(playerid, 224.5472, 1471.6603, 11.6080);
		SetCameraBehindPlayer(playerid);
		TogglePlayerControllable(playerid, false);
		ApplyAnimation(playerid, "PED", "abseil", 4.1, 1, 0, 0, 0, 0);
		PlayerClimbingRope[playerid] = 1;
		RopeUsed = 1;
		SendClientMessage(playerid, WHITE, "Hit SPRINT KEY (SPACE) to climb up and CROUCH KEY (C) to climb down.");
		return 1;
	}
	else
	{
		SendClientMessage(playerid, GREY, "You are not close to any rope.");
		return 1;
	}
}


COMMAND:liftweights(playerid, params[])
{
		if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
		if(PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You are cuffed or being dragged.");
		if(HoldingObject[playerid] >= 1) return SendClientMessage(playerid, GREY, "You can't lift weights while holding something in your hand(s).");
		if(IsPlayerInRangeOfPoint(playerid, 1.5, 226.0457, 1475.5425, 10.6878) && BenchPress1Used == 0)
		{
			if(PlayerStat[playerid][BPCD] >= 1) return SendClientMessage(playerid, GREY, "You are still tierd from the last exercise.");
			new str[128];
			BenchPress1Used = 1;
            TextDrawShowForPlayer(playerid, Text:BENCH_INFO);
            PlayerStat[playerid][BPBAR] = 1;
            TextDrawShowForPlayer(playerid, Text:BENCH_NAME);
            SetPlayerAttachedObject(playerid, 1,2913, 6, 0, 0, 0, 0, 0, 0, 1, 1, 1);
			TogglePlayerControllable(playerid, 0);
			PlayerStat[playerid][BPNMB] = 1;
			SetPlayerCameraPos(playerid, 225.8729, 1473.0784, 12.8462);
			SetPlayerCameraLookAt(playerid, 225.8489, 1474.0782, 12.1712);
			SetPlayerPos(playerid,  226.0457, 1475.5425, 10.6878);
			SetPlayerFacingAngle(playerid, 359.4156);
			ApplyAnimation(playerid,"BENCHPRESS","gym_bp_geton", 4.1, 0, 0, 0, 1, 15, 0);
			format(str, sizeof(str), "* %s sits down on the bench and starts lifting weights.", GetICName(playerid));
		    SendNearByMessage(playerid, ACTION_COLOR, str, 5);
		    PlayerStat[playerid][BPUSE] = 1;
			SendClientMessage(playerid, WHITE, "Tap the [F] (Secondary vehicle key) as fast as you can to lift the weights.");
		}
		else if(IsPlayerInRangeOfPoint(playerid, 1.5, 222.9836, 1475.5223, 10.6878) && BenchPress2Used == 0)
		{
			if(PlayerStat[playerid][BPCD] >= 1) return SendClientMessage(playerid, GREY, "You are still tierd from the last exercise.");
			new str[128];
			BenchPress2Used = 1;
            TextDrawShowForPlayer(playerid, Text:BENCH_INFO);
            PlayerStat[playerid][BPBAR] = 1;
            TextDrawShowForPlayer(playerid, Text:BENCH_NAME);
            SetPlayerAttachedObject(playerid, 1,2913, 6, 0, 0, 0, 0, 0, 0, 1, 1, 1);
			PlayerStat[playerid][BPNMB] = 2;
			SetPlayerCameraPos(playerid, 222.7480, 1473.0494, 12.8462);
			SetPlayerCameraLookAt(playerid, 222.7619, 1474.0496, 12.1462);
			TogglePlayerControllable(playerid, 0);
			SetPlayerPos(playerid,  222.9836,1475.5223,10.6878);
			SetPlayerFacingAngle(playerid, 359.4156);
			ApplyAnimation(playerid,"BENCHPRESS","gym_bp_geton", 4.1, 0, 0, 0, 1, 15, 0);
			format(str, sizeof(str), "* %s sits down on the bench and starts lifting weights.", GetICName(playerid));
		    SendNearByMessage(playerid, ACTION_COLOR, str, 5);
		    PlayerStat[playerid][BPUSE] = 1;
			SendClientMessage(playerid, WHITE, "Tap the [F] (Secondary vehicle key) as fast as you can to lift the weights.");
		}
		else if(IsPlayerInRangeOfPoint(playerid, 1.5, 219.8431,1475.5273,10.6878) && BenchPress3Used == 0)
		{
			if(PlayerStat[playerid][BPCD] >= 1) return SendClientMessage(playerid, GREY, "You are still tierd from the last exercise.");
			new str[128];
			BenchPress3Used = 1;
            TextDrawShowForPlayer(playerid, Text:BENCH_INFO);
            PlayerStat[playerid][BPBAR] = 1;
            TextDrawShowForPlayer(playerid, Text:BENCH_NAME);
            SetPlayerAttachedObject(playerid, 1,2913, 6, 0, 0, 0, 0, 0, 0, 1, 1, 1);
			PlayerStat[playerid][BPNMB] = 3;
			SetPlayerCameraPos(playerid, 219.4293, 1473.0771, 12.8462);
			SetPlayerCameraLookAt(playerid, 219.4812, 1474.0759, 12.1162);
			TogglePlayerControllable(playerid, 0);
			SetPlayerPos(playerid,  219.8431,1475.5273,10.6878);
			SetPlayerFacingAngle(playerid, 359.4156);
			ApplyAnimation(playerid,"BENCHPRESS","gym_bp_geton", 4.1, 0, 0, 0, 1, 15, 0);
			format(str, sizeof(str), "* %s sits down on the bench and starts lifting weights.", GetICName(playerid));
		    SendNearByMessage(playerid, ACTION_COLOR, str, 5);
		    PlayerStat[playerid][BPUSE] = 1;
			SendClientMessage(playerid, WHITE, "Tap the [F] (Secondary vehicle key) as fast as you can to lift the weights.");
		}
		else if(IsPlayerInRangeOfPoint(playerid, 2.3, 226.0457, 1475.5425, 10.6878) && BenchPress1Used == 1)
		{
			SendClientMessage(playerid, GREY, "This bench is already in use.");
		}
		else if(IsPlayerInRangeOfPoint(playerid, 2.3, 222.9836, 1475.5223, 10.6878) && BenchPress2Used == 1)
		{
		    SendClientMessage(playerid, GREY, "This bench is already in use.");
		}
		else if(IsPlayerInRangeOfPoint(playerid, 2.3, 219.8431,1475.5273,10.6878) && BenchPress3Used == 1)
		{
		    SendClientMessage(playerid, GREY, "This bench is already in use.");
		}
		else
		{
		    SendClientMessage(playerid, GREY, "You are not near any benches to lift weights.");
		}
		return 1;
}


// --==================================================================================================================--

COMMAND:jobhelp(playerid, params[])
{
	if(PlayerStat[playerid][JobID] >= 1)
	{
		if(PlayerStat[playerid][JobID] == 1) // Garbage Picker
		{
		SendClientMessage(playerid, WHITE, "Job Commands:");
		SendClientMessage(playerid, WHITE, "Garbage Man: /job, /throwtrash, /picktrash.");
		}
		else if(PlayerStat[playerid][JobID] == 2) // Table Cleaner
		{
		SendClientMessage(playerid, WHITE, "Job Commands:");
		SendClientMessage(playerid, WHITE, "Table Cleaner: /job, /picktray /puttray /washtray.");
		}
		else if(PlayerStat[playerid][JobID] == 3) // Laundry Worker
		{
		SendClientMessage(playerid, WHITE, "Job Commands:");
		SendClientMessage(playerid, WHITE, "Landry Worker: /job, /putlaundry, /picklaundry.");
		}
		else if(PlayerStat[playerid][JobID] == 4) // Warehouse Worker
		{
		SendClientMessage(playerid, WHITE, "Job Commands:");
		SendClientMessage(playerid, WHITE, "Warehouse Worker: /job, /takebox, /putbox.");
		}
	}
	else
	{
		SendClientMessage(playerid, GREY, "You currently not hired by any job.");
	}
	return 1;
}

COMMAND:cellhelp(playerid, params[])
{
	SendClientMessage(playerid, WHITE, "Cell Commands:");
	SendClientMessage(playerid, WHITE, "/buycell, /sellcell, /lockcell, /cellstats /buycelllevel, /celldeposit, /cellwithdraw, /storeweapon, /takeweapon.");
	return 1;
}

COMMAND:changepw(playerid, params[])
{
    ShowPlayerDialog(playerid, DIALOG_NEWPW, DIALOG_STYLE_INPUT, "New Password", "Please input your new password below.", "Change", "Cancel");
    return 1;
}

COMMAND:stats(playerid, params[])
{
	ShowStatsForPlayer(playerid, playerid);
    return 1;
}

COMMAND:warnings(playerid, params[])
{
	ShowWarnings(playerid, playerid);
    return 1;
}

COMMAND:pay(playerid, params[])
{
    if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
    if(PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You are cuffed or being dragged.");
	if(PlayerStat[playerid][PlayingHours] < 5) return SendClientMessage(playerid, GREY, "You need 5 playing hours in order to use this command.");
	new targetid, money, str[128];
	if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You can't use this command right now.");
    if(sscanf(params,"ud", targetid, money))return SendClientMessage(playerid, GREY, "USAGE: /pay [playerid] [money]");
    if(targetid == playerid) return SendClientMessage(playerid, GREY, "You can't give money to yourself.");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
    if(!IsPlayerInRangeOfPlayer(5, playerid, targetid)) return SendClientMessage(playerid, GREY, "Target ID is too far away.");
    if(money < 1) return SendClientMessage(playerid, GREY, "You can't pay under $1.");
    if(money > 5000) return SendClientMessage(playerid, GREY, "You can't pay over $5000.");
    if(PlayerStat[playerid][Money] < money) return SendClientMessage(playerid, GREY, "You don't have enough money.");
    GiveMoney(playerid, -money);
    GiveMoney(targetid, money);
	format(str, sizeof(str), "* %s takes out $%d from his pocket and hands them to %s.", GetICName(playerid), money, GetICName(targetid));
    SendNearByMessage(playerid, ACTION_COLOR, str, 5);
    return 1;
}

COMMAND:time(playerid, params[])
{
	new str[128];
	new Hour, Minute, Second;
	gettime(Hour, Minute, Second);
	if(PlayerStat[playerid][InIsolatedCell] == 1)
	{
        format(str, sizeof(str), "~w~%02d~g~:~w~%02d~g~:~w~%02d~n~~w~In Isolated Cell for ~g~%d", Hour, Minute, Second, PlayerStat[playerid][InIsolatedCellTime]);
	    GameTextForPlayer(playerid, str, 3000, 1);
    }
    else if(PlayerStat[playerid][AdminPrisoned] == 1)
	{
        format(str, sizeof(str), "~w~%02d~g~:~w~%02d~g~:~w~%02d~n~~w~In Admin Prison for ~g~%d", Hour, Minute, Second, PlayerStat[playerid][AdminPrisonedTime]);
	    GameTextForPlayer(playerid, str, 3000, 1);
    }
    else
	{
        format(str, sizeof(str), "~w~%02d~g~:~w~%02d~g~:~w~%02d", Hour, Minute, Second);
	    GameTextForPlayer(playerid, str, 3000, 1);
		ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_watch", 4.1, 0, 0, 0, 0, 0);
    }
    return 1;
}

COMMAND:showprisonid(playerid, params[])
{
	new targetid, text1[80], text2[80], text3[80], text4[80], str[128];
	if(sscanf(params,"u", targetid))return SendClientMessage(playerid, GREY, "USAGE: /showprisonid [playerid].");
	if(PlayerStat[targetid][Dead] == 1 || PlayerStat[targetid][AdminPrisoned] == 1 || PlayerStat[targetid][InHospital] == 1 || PlayerStat[targetid][Tased] == 1) return SendClientMessage(playerid, GREY, "This player is invalid due to his status.");
	if(!(IsPlayerInRangeOfPlayer(2.0, targetid, playerid))) return SendClientMessage(playerid, GREY, "You are too far from this player.");
	if(targetid == playerid) return SendClientMessage(playerid, GREY, "You can't show your ID to yourself, use /stats instead.");
	format(str, sizeof(str), "* %s shows his prison ID to %s.", GetICName(playerid), GetICName(targetid));
    SendNearByMessage(playerid, ACTION_COLOR, str, 12);
    ICLog(str);
	new playerskin = GetPlayerSkin(playerid);
	PlayerTextDrawShow(targetid, PRNID01[targetid]);
	PlayerTextDrawShow(targetid, PRNID02[targetid]);
	PlayerTextDrawShow(targetid, PRNID03[targetid]);
	PlayerTextDrawShow(targetid, PRNID04[targetid]);
	PlayerTextDrawShow(targetid, PRNID05[targetid]);
	PlayerTextDrawShow(targetid, PRNID10[targetid]);
	PlayerTextDrawShow(targetid, PRNID12[targetid]);
	format(text1, sizeof(text1), "%s", GetOOCName(playerid));
	PlayerTextDrawSetString(targetid, PRNID06[targetid], text1);
	PlayerTextDrawShow(targetid, PRNID06[targetid]);
	format(text2, sizeof(text2), "Prisoner: #1", GetJob(playerid));
	PlayerTextDrawSetString(targetid, PRNID07[targetid], text2);
	PlayerTextDrawShow(targetid, PRNID07[targetid]);
	format(text3, sizeof(text3), "Occupation: %s", GetJob(playerid));
	PlayerTextDrawSetString(targetid, PRNID08[targetid], text3);
	PlayerTextDrawShow(targetid, PRNID08[targetid]);
	if(PlayerStat[playerid][HasCell] == 1)
	{
		format(text4, sizeof(text4), "Cell Owner: Yes", GetJob(playerid));
		PlayerTextDrawSetString(targetid, PRNID09[targetid], text4);
		PlayerTextDrawShow(targetid, PRNID09[targetid]);
	}
	else
	{
		format(text4, sizeof(text4), "Cell Owner: No", GetJob(playerid));
		PlayerTextDrawSetString(targetid, PRNID09[targetid], text4);
		PlayerTextDrawShow(targetid, PRNID09[targetid]);
	}
	PlayerTextDrawSetPreviewModel(targetid, PRNID11[targetid], playerskin);
	PlayerTextDrawShow(targetid, PRNID11[targetid]);
	SendClientMessage(targetid, WHITE, "Write /mouse if your cursor disappeared.");
	SelectTextDraw(targetid, 0xA3B4C5FF);
    return 1;
}

COMMAND:accept(playerid, params[])
{
    if(PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You can't use this command right now.");
    if(isnull(params)) return SendClientMessage(playerid, GREY, "USAGE: /accept gang, death, faction, handshake.");
	else if(!strcmp(params, "gang", true))
	{
        if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
		new str[128];
		if(PlayerStat[playerid][BeingInvitedToGang] == 0) return SendClientMessage(playerid, GREY, "Nobody invited you to join a gang.");
		PlayerStat[playerid][GangID] = PlayerStat[playerid][BeingInvitedToGang];
		PlayerStat[playerid][GangRank] = 1;
		format(str, sizeof(str), "%s has accepted to join %s, Welcome!", GetOOCName(playerid), GangStat[PlayerStat[playerid][GangID]][GangName]);
        SendGangMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
        GangStat[PlayerStat[playerid][GangID]][Members] += 1;
        format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
        if(INI_Open(GangStat[PlayerStat[playerid][GangID]][GangFile]))
        {
            INI_WriteInt("Members", GangStat[PlayerStat[playerid][GangID]][Members]);
            INI_Save();
            INI_Close();
        }
	}
	else if(!strcmp(params, "faction", true))
	{
        if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
		new str[128];
		if(PlayerStat[playerid][BeingInvitedToFaction] == 0) return SendClientMessage(playerid, GREY, "Nobody invited you to join a faction.");
		PlayerStat[playerid][FactionID] = PlayerStat[playerid][BeingInvitedToFaction];
		PlayerStat[playerid][FactionRank] = 1;
        if(PlayerStat[playerid][FactionID] == 1)
	    {
	        format(str, sizeof(str), "%s has accepted to join the Department of Corrections, welcome!", GetOOCName(playerid));
	        SendFactionMessage(playerid, LIGHT_GREEN, str);
			SendClientMessage(playerid, LIGHT_GREEN, "You have accepted the invite to the Department of Corrections, welcome!");
			PlayerStat[playerid][BeingInvitedToFaction] = 0;
	    }
        else if(PlayerStat[playerid][FactionID] == 2)
	    {
	        format(str, sizeof(str), "%s has accepted to join the Prison Emergency Medical Team, welcome!", GetOOCName(playerid));
	        SendFactionMessage(playerid, LIGHT_GREEN, str);
			SendClientMessage(playerid, LIGHT_GREEN, "You have accepted the invite to the Emergency Medical Team, welcome!");
			PlayerStat[playerid][BeingInvitedToFaction] = 0;
	    }
	}
	else if(!strcmp(params, "death", true))
	{
		if(PlayerStat[playerid][DeathT] >= 1)
		{
			SendClientMessage(playerid, GREY, "You still can't accept your death.");
		}
		else
		{
			new str[128];
			if(PlayerStat[playerid][Dead] == 0) return SendClientMessage(playerid, GREY, "You are not dead to accept it.");
			format(str, sizeof(str), "%s has accepted death.", GetOOCName(playerid));
			SendNearByMessage(playerid, WHITE, str, 8);
			PlayerStat[playerid][InHospital] = 1;
	    	PlayerStat[playerid][HospitalTime] = 49;
	    	PlayerStat[playerid][Dead] = 0;
	    	new Random = random(sizeof(HospitalSpawns));
        	SetPlayerPos(playerid, HospitalSpawns[Random][0], HospitalSpawns[Random][1], HospitalSpawns[Random][2]);
			SetPlayerCameraPos(playerid,1144.3436,-1308.6213,1024.00);
	    	SetPlayerCameraLookAt(playerid, 1138.2471,-1302.6396,1024.6106);
			SetHealth(playerid, 1.0);
        	SetArmour(playerid, 0.0);
    		SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			TogglePlayerControllable(playerid, 0);
			SendClientMessage(playerid, RED, "You have accepted death, and been moved inside the prison clinic.");
			SendClientMessage(playerid, RED, "You will be released when you have recovered.");
			ApplyAnimation(playerid, "PED", "FLOOR_hit_f", 4.1, 0, 1, 1, 1, 0, 1);
		}
	}
	else if(!strcmp(params, "handshake", true))
	{
        if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
        if(PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You are cuffed or being dragged.");
		if(PlayerStat[playerid][HandShakeTarget] == -1) return SendClientMessage(playerid, GREY, "Nobody requested to shake hands with you");
		if(IsPlayerInRangeOfPlayer(2.0, PlayerStat[playerid][HandShakeTarget], playerid))
		{
			switch(PlayerStat[playerid][HandShakeStyle])
			{
				case 1:
				{
			        PutPlayerInFrontOfPlayer(playerid, PlayerStat[playerid][HandShakeTarget]);
			        ApplyAnimation(playerid, "GANGS", "hndshkaa", 4.0, 0, 0, 0, 0, 0);
			        ApplyAnimation(PlayerStat[playerid][HandShakeTarget], "GANGS", "hndshkaa", 4.0, 0, 0, 0, 0, 0);
					SendClientMessage(playerid, WHITE, "Handshake accepted.");
					SendClientMessage(PlayerStat[playerid][HandShakeTarget], WHITE, "Handshake accepted.");
					PlayerStat[playerid][HandShakeTarget] = -1;
				}
				case 2:
				{
			        PutPlayerInFrontOfPlayer(playerid, PlayerStat[playerid][HandShakeTarget]);
			        ApplyAnimation(playerid, "GANGS", "hndshkba", 4.0, 0, 0, 0, 0, 0);
			        ApplyAnimation(PlayerStat[playerid][HandShakeTarget], "GANGS", "hndshkba", 4.0, 0, 0, 0, 0, 0);
					SendClientMessage(playerid, WHITE, "Handshake accepted.");
					SendClientMessage(PlayerStat[playerid][HandShakeTarget], WHITE, "Handshake accepted.");
					PlayerStat[playerid][HandShakeTarget] = -1;
				}
				case 3:
				{
			        PutPlayerInFrontOfPlayer(playerid, PlayerStat[playerid][HandShakeTarget]);
			        ApplyAnimation(playerid, "GANGS", "hndshkca", 4.0, 0, 0, 0, 0, 0);
			        ApplyAnimation(PlayerStat[playerid][HandShakeTarget], "GANGS", "hndshkca", 4.0, 0, 0, 0, 0, 0);
					SendClientMessage(playerid, WHITE, "Handshake accepted.");
					SendClientMessage(PlayerStat[playerid][HandShakeTarget], WHITE, "Handshake accepted.");
					PlayerStat[playerid][HandShakeTarget] = -1;
				}
				case 4:
				{
			        PutPlayerInFrontOfPlayer(playerid, PlayerStat[playerid][HandShakeTarget]);
			        ApplyAnimation(playerid, "GANGS", "hndshkcb", 4.0, 0, 0, 0, 0, 0);
			        ApplyAnimation(PlayerStat[playerid][HandShakeTarget], "GANGS", "hndshkcb", 4.0, 0, 0, 0, 0, 0);
					SendClientMessage(playerid, WHITE, "Handshake accepted.");
					SendClientMessage(PlayerStat[playerid][HandShakeTarget], WHITE, "Handshake accepted.");
					PlayerStat[playerid][HandShakeTarget] = -1;
				}
				case 5:
				{
			        PutPlayerInFrontOfPlayer(playerid, PlayerStat[playerid][HandShakeTarget]);
			        ApplyAnimation(playerid, "GANGS", "hndshkda", 4.0, 0, 0, 0, 0, 0);
			        ApplyAnimation(PlayerStat[playerid][HandShakeTarget], "GANGS", "hndshkda", 4.0, 0, 0, 0, 0, 0);
					SendClientMessage(playerid, WHITE, "Handshake accepted.");
					SendClientMessage(PlayerStat[playerid][HandShakeTarget], WHITE, "Handshake accepted.");
					PlayerStat[playerid][HandShakeTarget] = -1;
				}
				case 6:
				{
			        PutPlayerInFrontOfPlayer(playerid, PlayerStat[playerid][HandShakeTarget]);
			        ApplyAnimation(playerid, "GANGS", "hndshkea", 4.0, 0, 0, 0, 0, 0);
			        ApplyAnimation(PlayerStat[playerid][HandShakeTarget], "GANGS", "hndshkea", 4.0, 0, 0, 0, 0, 0);
					SendClientMessage(playerid, WHITE, "Handshake accepted.");
					SendClientMessage(PlayerStat[playerid][HandShakeTarget], WHITE, "Handshake accepted.");
					PlayerStat[playerid][HandShakeTarget] = -1;
				}
				case 7:
				{
			        PutPlayerInFrontOfPlayer(playerid, PlayerStat[playerid][HandShakeTarget]);
			        ApplyAnimation(playerid, "GANGS", "hndshkfa", 4.0, 0, 0, 0, 0, 0);
			        ApplyAnimation(PlayerStat[playerid][HandShakeTarget], "GANGS", "hndshkfa", 4.0, 0, 0, 0, 0, 0);
					SendClientMessage(playerid, WHITE, "Handshake accepted.");
					SendClientMessage(PlayerStat[playerid][HandShakeTarget], WHITE, "Handshake accepted.");
					PlayerStat[playerid][HandShakeTarget] = -1;
				}
				case 8:
				{
			        PutPlayerInFrontOfPlayer(playerid, PlayerStat[playerid][HandShakeTarget]);
			        ApplyAnimation(playerid, "GANGS", "hndshkfa_swt", 4.0, 0, 0, 0, 0, 0);
			        ApplyAnimation(PlayerStat[playerid][HandShakeTarget], "GANGS", "hndshkfa_swt", 4.0, 0, 0, 0, 0, 0);
					SendClientMessage(playerid, WHITE, "Handshake accepted.");
					SendClientMessage(PlayerStat[playerid][HandShakeTarget], WHITE, "Handshake accepted.");
					PlayerStat[playerid][HandShakeTarget] = -1;
				}
				case 9:
				{
			        PutPlayerInFrontOfPlayer(playerid, PlayerStat[playerid][HandShakeTarget]);
			        ApplyAnimation(playerid, "GANGS", "prtial_hndshk_01", 4.0, 0, 0, 0, 0, 0);
			        ApplyAnimation(PlayerStat[playerid][HandShakeTarget], "GANGS", "prtial_hndshk_01", 4.0, 0, 0, 0, 0, 0);
					SendClientMessage(playerid, WHITE, "Handshake accepted.");
					SendClientMessage(PlayerStat[playerid][HandShakeTarget], WHITE, "Handshake accepted.");
					PlayerStat[playerid][HandShakeTarget] = -1;
				}
			}
		}
	}
	else return SendClientMessage(playerid, GREY, "Invalid option.");
    return 1;
}

COMMAND:locker(playerid, params[])
{
    if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
    if(PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You are cuffed or being dragged.");
	if(IsPlayerInRangeOfPoint(playerid, 2, 412.0197,1562.7104,1001.0000))
	{
		ShowPlayerDialog(playerid, DIALOG_LOCKER, DIALOG_STYLE_LIST, "Locker Menu", "Balance\nWithdraw\nDeposit", "Select", "Quit");
	}
	else return SendClientMessage(playerid, GREY, "You are not at the prison locker.");
    return 1;
}

COMMAND:buyclothes(playerid, params[])
{
    if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
    if(PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You are cuffed or being dragged.");
	if(IsPlayerInRangeOfPoint(playerid, 1, 234.2097, 1430.4180, 14.9918))
	{
		CurrentSkin[playerid] = GetPlayerSkin(playerid);
		ShowPlayerDialog(playerid, DIALOG_CLOTHES1, DIALOG_STYLE_INPUT, "Clothes Menu", "Input a Skin ID below.", "Select", "Quit");
	}
	else return SendClientMessage(playerid, GREY, "You need to be at the prison shop to buy some new clothes");
    return 1;
}

COMMAND:pullweapon(playerid, params[])
{
    if(PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You are cuffed or being dragged.");
	new cWeapon = GetPlayerWeapon(playerid);
	if(cWeapon >= 1 || PlayerStat[playerid][WeaponPocketCD] >= 1) return SendClientMessage(playerid, GREY, "You already have a weapon in your hands.");
	new slotid;
    if(sscanf(params,"d", slotid)) return SendClientMessage(playerid, GREY, "USAGE: /pullweapon [SLOTID 1-3]");
	switch(slotid)
	{
		case 1:
		{
			if(PlayerStat[playerid][WeaponSlot0] == 0) return SendClientMessage(playerid, GREY, "You don't have a weapon in that slot.");
			ServerWeapon(playerid, PlayerStat[playerid][WeaponSlot0], PlayerStat[playerid][WeaponSlot0Ammo]);
			INI_Open(Accounts(playerid));
			INI_WriteInt("WeaponSlot0", 0); 
			INI_WriteInt("WeaponSlot0Ammo", 0);
			INI_Save();
			INI_Close();
			PlayerStat[playerid][WeaponSlot0] = 0;
			PlayerStat[playerid][WeaponSlot0Ammo] = 0;
			PlayerStat[playerid][WeaponPocketCD] = 4;
			SendClientMessage(playerid, WHITE, "You have withdrawn a weapon from slot 1.");
			RemovePlayerAttachedObject(playerid, 6);
		}
		case 2:
		{
			if(PlayerStat[playerid][WeaponSlot1] == 0) return SendClientMessage(playerid, GREY, "You don't have a weapon in that slot.");
			ServerWeapon(playerid, PlayerStat[playerid][WeaponSlot1], PlayerStat[playerid][WeaponSlot1Ammo]);
			INI_Open(Accounts(playerid));
			INI_WriteInt("WeaponSlot1", 0); 
			INI_WriteInt("WeaponSlot1Ammo", 0);
			INI_Save();
			INI_Close();
			PlayerStat[playerid][WeaponSlot1] = 0;
			PlayerStat[playerid][WeaponSlot1Ammo] = 0;
			PlayerStat[playerid][WeaponPocketCD] = 4;
			SendClientMessage(playerid, WHITE, "You have withdrawn a weapon from slot 2.");
			RemovePlayerAttachedObject(playerid, 7);
		}
		case 3:
		{
			if(PlayerStat[playerid][DonLV] <= 2) return SendClientMessage(playerid, GREY, "You have to be a golden donator (level 3) in order to pocket and pull weapons from this slot.");
			if(PlayerStat[playerid][WeaponSlot2] == 0) return SendClientMessage(playerid, GREY, "You don't have a weapon in that slot.");
			ServerWeapon(playerid, PlayerStat[playerid][WeaponSlot2], PlayerStat[playerid][WeaponSlot2Ammo]);
			INI_Open(Accounts(playerid));
			INI_WriteInt("WeaponSlot2", 0); 
			INI_WriteInt("WeaponSlot2Ammo", 0);
			INI_Save();
			INI_Close();
			PlayerStat[playerid][WeaponSlot2] = 0;
			PlayerStat[playerid][WeaponSlot2Ammo] = 0;
			PlayerStat[playerid][WeaponPocketCD] = 4;
			SendClientMessage(playerid, WHITE, "You have withdrawn a weapon from slot 3.");
			RemovePlayerAttachedObject(playerid, 8);
		}
	}
	return 1;
}

COMMAND:pocketweapon(playerid)
{
    if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
    if(PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You are cuffed or being dragged.");
	new cWeapon = GetPlayerWeapon(playerid);
	if(cWeapon == 0) return SendClientMessage(playerid, GREY, "You are not holding any weapon.");
	if(PlayerStat[playerid][WeaponPocketCD] >= 1) return SendClientMessage(playerid, RED, "[ANTI-CHEAT] Wait few more seconds to pocket your gun.");
	if(PlayerStat[playerid][WeaponSlot0] == 0)
	{
		PlayerStat[playerid][WeaponPocketCD] = 5;
		PlayerStat[playerid][WeaponSlot0] = GetPlayerWeapon(playerid);
		PlayerStat[playerid][WeaponSlot0Ammo] = GetPlayerAmmo(playerid);
		SetPlayerAmmo(playerid, cWeapon, 0);
		ResetWeapons(playerid);
		SendClientMessage(playerid, WHITE, "You have pocketed your weapon in slot 1.");
		if(cWeapon == 3)
		{
			SetPlayerAttachedObject(playerid, 6, 334, 8, -0.084999, 0.04399, 0.12200, -19.5, 88.0, -73.8);
		}
		if(cWeapon == 5)
		{
			SetPlayerAttachedObject(playerid, 6, 336, 1, -0.02899, -0.15900, 0.000, 9.6999, 44.099, 0.000);
		}
		if(cWeapon == 31)
		{
			SetPlayerAttachedObject(playerid, 6, 356, 1, 0.005, -0.14600, 0.06499, -2.4999, 38.0999, 2.2000);
		}
		if(cWeapon == 25)
		{
			SetPlayerAttachedObject(playerid, 6, 349, 1, -0.07400, -0.165, 0.0, 0.0, 0.0, 0.0);
		}
		
	}
	else if(PlayerStat[playerid][WeaponSlot1] == 0)
	{
		PlayerStat[playerid][WeaponPocketCD] = 5;
		PlayerStat[playerid][WeaponSlot1] = GetPlayerWeapon(playerid);
		PlayerStat[playerid][WeaponSlot1Ammo] = GetPlayerAmmo(playerid);
		SetPlayerAmmo(playerid, cWeapon, 0);
		ResetWeapons(playerid);
		SendClientMessage(playerid, WHITE, "You have pocketed your weapon in slot 2.");
		if(cWeapon == 3)
		{
			SetPlayerAttachedObject(playerid, 7, 334, 8, -0.084999, 0.04399, 0.12200, -19.5, 88.0, -73.8);
		}
		if(cWeapon == 5)
		{
			SetPlayerAttachedObject(playerid, 7, 336, 1, -0.02899, -0.15900, 0.000, 9.6999, 44.099, 0.000);
		}
		if(cWeapon == 31)
		{
			SetPlayerAttachedObject(playerid, 7, 356, 1, 0.005, -0.14600, 0.06499, -2.4999, 38.0999, 2.2000);
		}
		if(cWeapon == 25)
		{
			SetPlayerAttachedObject(playerid, 7, 349, 1, -0.07400, -0.165, 0.0, 0.0, 0.0, 0.0);
		}
	}
	else if(PlayerStat[playerid][WeaponSlot2] == 0 && PlayerStat[playerid][DonLV] == 3)
	{
		PlayerStat[playerid][WeaponPocketCD] = 5;
		PlayerStat[playerid][WeaponSlot2] = GetPlayerWeapon(playerid);
		PlayerStat[playerid][WeaponSlot2Ammo] = GetPlayerAmmo(playerid);
		SetPlayerAmmo(playerid, cWeapon, 0);
		ResetWeapons(playerid);
		SendClientMessage(playerid, WHITE, "You have pocketed your weapon in slot 3.");
		PlayerStat[playerid][WeaponPocketCD] = 4;
		if(cWeapon == 3)
		{
			SetPlayerAttachedObject(playerid, 8, 334, 8, -0.084999, 0.04399, 0.12200, -19.5, 88.0, -73.8);
		}
		if(cWeapon == 5)
		{
			SetPlayerAttachedObject(playerid, 8, 336, 1, -0.02899, -0.15900, 0.000, 9.6999, 44.099, 0.000);
		}
		if(cWeapon == 31)
		{
			SetPlayerAttachedObject(playerid, 8, 356, 1, 0.005, -0.14600, 0.06499, -2.4999, 38.0999, 2.2000);
		}
		if(cWeapon == 25)
		{
			SetPlayerAttachedObject(playerid, 8, 349, 1, -0.07400, -0.165, 0.0, 0.0, 0.0, 0.0);
		}
	}
	else return SendClientMessage(playerid, GREY, "There is no available spot to pocket the weapon.");
	return 1;
}

COMMAND:smuggleknife(playerid)
{
    if(kitchenknife == 0) return SendClientMessage(playerid, GREY, "There is no kitchen knife to smuggle.");
	if(PlayerStat[playerid][DonLV] < 2) return SendClientMessage(playerid, GREY, "Only silver (level 2) donators and above can smuggle kitchen knives.");
	if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
    if(PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You are cuffed or being dragged.");
	if(PlayerStat[playerid][Money] <= 699) return SendClientMessage(playerid, GREY, "It costs 700$ to bribe the kitchen worker that he didn't see you smuggle it.");
	GiveMoney(playerid, -700);
	DestroyDynamicObject(kitchknife);
	kitchenknife = 0;
	SendClientMessage(playerid, WHITE, "You have taken the kitchen knife and bribed the kitchen worker.");
	ServerWeapon(playerid, 4, 1);
	PlayerStat[playerid][WeaponPocketCD] = 4;
	return 1;
}

/*COMMAND:fish(playerid)
{
    if(PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
    if(PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You are cuffed or being dragged.");
	new Float:PosX, Float:PosY, Float:PosZ, Float:PosA;
	GetPlayerPos(playerid, PosX, PosY, PosZ);
	GetPlayerFacingAngle(playerid, PosA);
	if(PosZ >= 994.87 || PosZ <= 994.80) return SendClientMessage(playerid, GREY, "You can't fish here.");
	if(PosY >= 1627.3511 || PosY <= 1626.5) return SendClientMessage(playerid, GREY, "You can't fish here.");
	if(PosX >= 472.4 || PosX <= 447.5) return SendClientMessage(playerid, GREY, "You can't fish here.");
	if(PosA >= 220 || PosA <= 135) return SendClientMessage(playerid, GREY, "You are not facing the water.");
	SendClientMessage(playerid, GREY, "Use /stopfish to stop fishing, if you stop in the middle of fishing you will lose the bait.");
	SendClientMessage(playerid, WHITE, "#FishGang");
	ClearAnimations(playerid);
	PFishing[playerid] = 1;
	PFishingT[playerid] = 0;
	PFishingCP[playerid] = 0;
	PFishingCT[playerid] = 0;
	TogglePlayerControllable(playerid, false);
	ApplyAnimation(playerid, "SAMP", "FishingIdle", 4.1, 1, 1, 1, 1, 0);
	return 1;
}

COMMAND:stopfish(playerid)
{
    if(PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
    if(PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You are cuffed or being dragged.");
	if(PFishing[playerid] == 1)
	{
		PFishing[playerid] = 0;
		PFishingT[playerid] = 0;
		PFishingCP[playerid] = 0;
		PFishingCT[playerid] = 0;
		SendClientMessage(playerid, WHITE, "You have stopped fishing");
		TogglePlayerControllable(playerid, true);
		ClearAnimations(playerid);
		return 1;
	}
	SendClientMessage(playerid, GREY, "You are not fishing");
	return 1;
}*/

COMMAND:give(playerid, params[])
{
    if(PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
    if(PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You are cuffed or being dragged.");
	new targetid, item[20], quantity, str[128];
    if(sscanf(params,"us[20]d", targetid, item, quantity))
	{
		SendClientMessage(playerid, GREY, "USAGE: /give [playerid] [item] [quantity]");
		SendClientMessage(playerid, GREY, "Items: Pot, Joint, Crack, Weapon, Paper, Lighter, Dice.");
	    return 1;
	}
	if(playerid == targetid) return SendClientMessage(playerid, GREY, "You can't use this command on yourself.");
	if(!IsPlayerInRangeOfPlayer(5, playerid, targetid)) return SendClientMessage(playerid, GREY, "Player is too far away.");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Player not found.");
    else if(!strcmp(item, "pot", true))
    {
		if(quantity > PlayerStat[playerid][Pot]) return SendClientMessage(playerid, GREY, "You don't have that much.");
		else
		{
            if(PlayerStat[targetid][Pot] == 5) return SendClientMessage(playerid, GREY, "Player can't carry anymore items.");
    	    if(PlayerStat[targetid][Pot] + quantity > 5) return SendClientMessage(playerid, GREY, "Player can't carry anymore items.");
			PlayerStat[playerid][Pot] -= quantity;
			PlayerStat[targetid][Pot] += quantity;
			format(str, sizeof(str), "%s takes out something and hands it to %s", GetICName(playerid), GetICName(targetid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 8);
			format(str, sizeof(str), "You have received %d grams of pot from %s.", quantity, GetICName(playerid));
			SendClientMessage(targetid, GREY, str);
			format(str, sizeof(str), "You gave %d grams of pot to %s.", quantity, GetICName(targetid));
			SendClientMessage(playerid, GREY, str);
		}
    }
    else if(!strcmp(item, "crack", true))
    {
		if(quantity > PlayerStat[playerid][Crack]) return SendClientMessage(playerid, GREY, "You don't have that much.");
		else
		{
            if(PlayerStat[targetid][Crack] == 4) return SendClientMessage(playerid, GREY, "Player can't carry anymore items.");
    	    if(PlayerStat[targetid][Crack] + quantity > 4) return SendClientMessage(playerid, GREY, "Player can't carry anymore items.");
			PlayerStat[playerid][Crack] -= quantity;
			PlayerStat[targetid][Crack] += quantity;
			format(str, sizeof(str), "%s takes out something and hands it to %s", GetICName(playerid), GetICName(targetid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 8);
			format(str, sizeof(str), "You have received %d grams of crack from %s.", quantity, GetICName(playerid));
			SendClientMessage(targetid, GREY, str);
			format(str, sizeof(str), "You gave %d grams of crack to %s.", quantity, GetICName(targetid));
			SendClientMessage(playerid, GREY, str);
		}
    }
    else if(!strcmp(item, "weapon", true))
    {
		new weaponname[60];
		new targetweap = GetPlayerWeapon(targetid);
		new weaponid = GetPlayerWeapon(playerid);
		new ammo = GetPlayerAmmo(playerid);
		if(PlayerStat[targetid][PlayingHours] < 5) return SendClientMessage(playerid, GREY, "This player doesn't have enough playing hours to carry a weapon.");
		if(weaponid == 0) return SendClientMessage(playerid, GREY, "Invalid weapon.");
		if(targetweap >= 1 || PlayerStat[playerid][WeaponPocketCD] >= 1) return SendClientMessage(playerid, GREY, "This player is already holding a weapon in his hands.");
		ServerWeapon(targetid, weaponid, ammo);
		ResetPlayerWeapons(playerid);
		PlayerStat[playerid][Slot1] = 0;
		LoadPlayerWeapons(playerid);
		format(str, sizeof(str), "%s takes out something and hands it to %s", GetICName(playerid), GetICName(targetid));
		SendNearByMessage(playerid, ACTION_COLOR, str, 8);
		GetWeaponName(weaponid ,weaponname, sizeof(weaponname));
		format(str, sizeof(str), "You have received a %s from %s.", weaponname, GetICName(playerid));
		SendClientMessage(targetid, GREY, str);
		format(str, sizeof(str), "You gave a %s to %s.", weaponname, GetICName(targetid));
		SendClientMessage(playerid, GREY, str);
		format(str, sizeof(str), "%s gave a %s (Ammo:%d) to %s.", GetOOCName(playerid), weaponname, ammo, GetOOCName(targetid));
		WeaponLog(str);

    }
    else if(!strcmp(item, "Paper", true))
    {
		if(quantity > PlayerStat[playerid][Paper]) return SendClientMessage(playerid, GREY, "You don't have that much.");
		else
		{
            if(PlayerStat[targetid][Paper] >= 25) return SendClientMessage(playerid, GREY, "Player can't carry anymore items.");
    	    if(PlayerStat[targetid][Paper] + quantity > 25) return SendClientMessage(playerid, GREY, "Player can't carry anymore items.");
			PlayerStat[playerid][Paper] -= quantity;
			PlayerStat[targetid][Paper] += quantity;
			format(str, sizeof(str), "%s takes out something from his pocket and hands it to %s", GetICName(playerid), GetICName(targetid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 8);
			format(str, sizeof(str), "You have received %d pieces of paper from %s.", quantity, GetICName(playerid));
			SendClientMessage(targetid, GREY, str);
			format(str, sizeof(str), "You gave %d pieces of paper to %s.", quantity, GetICName(targetid));
			SendClientMessage(playerid, GREY, str);
		}
    }
    else if(!strcmp(item, "Joint", true))
    {
		if(quantity > PlayerStat[playerid][Joint]) return SendClientMessage(playerid, GREY, "You don't have that much.");
		else
		{
            if(PlayerStat[targetid][Joint] >= 1) return SendClientMessage(playerid, GREY, "Player can't carry any more items.");
    	    if(PlayerStat[targetid][Joint] + quantity > 1) return SendClientMessage(playerid, GREY, "Player can't carry more then 1 joint.");
			PlayerStat[playerid][Joint] -= quantity;
			PlayerStat[targetid][Joint] += quantity;
			format(str, sizeof(str), "%s takes out something from his pocket and hands it to %s", GetICName(playerid), GetICName(targetid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 8);
			format(str, sizeof(str), "You have received %d joints from %s.", quantity, GetICName(playerid));
			SendClientMessage(targetid, GREY, str);
			format(str, sizeof(str), "You gave %d joints to %s.", quantity, GetICName(targetid));
			SendClientMessage(playerid, GREY, str);
		}
    }
    else if(!strcmp(item, "lighter", true))
    {
		if(quantity > PlayerStat[playerid][Lighter]) return SendClientMessage(playerid, GREY, "You don't have that much.");
		else
		{
            if(PlayerStat[targetid][Lighter] >= 3) return SendClientMessage(playerid, GREY, "Player can't carry anymore items.");
    	    if(PlayerStat[targetid][Lighter] + quantity > 3) return SendClientMessage(playerid, GREY, "Player can't carry anymore items.");
			PlayerStat[playerid][Lighter] -= quantity;
			PlayerStat[targetid][Lighter] += quantity;
			format(str, sizeof(str), "%s takes out something from his pocket and hands it to %s", GetICName(playerid), GetICName(targetid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 8);
			format(str, sizeof(str), "You have received %d lighter(s) from %s.", quantity, GetICName(playerid));
			SendClientMessage(targetid, GREY, str);
			format(str, sizeof(str), "You gave %d lighter(s) to %s.", quantity, GetICName(targetid));
			SendClientMessage(playerid, GREY, str);
		}
    }
	else if(!strcmp(item, "Dice", true))
    {
		if(PlayerStat[playerid][Dices] < 1) return SendClientMessage(playerid, GREY, "You don't have a dices.");
		if(PlayerStat[targetid][Dices] + quantity > 5) return SendClientMessage(playerid, GREY, "Player can't carry anymore items.");
		PlayerStat[playerid][Dices] -= quantity;
		PlayerStat[targetid][Dices] += quantity;
		format(str, sizeof(str), "%s takes out something from his pocket and hands it to %s", GetICName(playerid), GetICName(targetid));
		SendNearByMessage(playerid, ACTION_COLOR, str, 8);
		format(str, sizeof(str), "You have received %d dice(s) from %s.", quantity, GetICName(playerid));
		SendClientMessage(targetid, GREY, str);
		format(str, sizeof(str), "You gave %d dice(s) to %s.", quantity, GetICName(targetid));
		SendClientMessage(playerid, GREY, str);
	}
	else return SendClientMessage(playerid, GREY, "Invalid Item.");
    return 1;
}

COMMAND:takemeal(playerid, params[])
{
	new str[128];
    if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
    if(PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You are cuffed or being dragged.");
	if(IsPlayerInRangeOfPoint(playerid, 2.5, 442.9503, 1629.7429, 1001.6893) && HoldingTray[playerid] == 0)
	{
		if(PlayerStat[playerid][Money] <= 9) return SendClientMessage(playerid, LIGHT_RED, "You don't have 10 dollars to pay for the prison meal.");
		if(FoodTrayCounter == 0) return SendClientMessage(playerid, WHITE, "There are no washed trays to put the food on.");
		new Float:cHealth, Float:cX, Float:cY, Float:cZ;
		FoodTrayCounter--;
		CountTraysDown();
		GiveMoney(playerid, -10);
		format(str, sizeof(str), "* %s eats a meal from the cafeteria.", GetICName(playerid));
		ApplyActorAnimation(ACTKitchen1, "DEALER", "DEALER_DEAL", 4.1, 0, 0, 0, 0, 0);
		GetPlayerHealth(playerid, cHealth);
		if(cHealth <= 65)
		{
			SetPlayerHealth(playerid, cHealth + 35);
		}
		else
		{
			SetPlayerHealth(playerid, 100);
		}
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 3.0, 0, 0, 0, 0, 0);
		GetPlayerPos(playerid, cX, cY, cZ);
		SendNearByMessage(playerid, ACTION_COLOR, str, 7);
		PlayNearBySound(playerid, 32200, cX, cY, cZ, 12);
	}
	else return SendClientMessage(playerid, GREY, "You are not at the cafeteria.");
    return 1;
}

COMMAND:washtray(playerid)
{
	new str[128], Float:RadioX, Float:RadioY, Float:RadioZ;
	if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
    if(PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You are cuffed or being dragged.");
	if(PlayerStat[playerid][JobID] == 2 && PlayerStat[playerid][AbleToCleanTables] == 1)
	{
		if(HoldingObject[playerid] == 2767) return SendClientMessage(playerid, GREY, "You can't wash this tray again.");
		if(!(HoldingObject[playerid] == 2823)) return SendClientMessage(playerid, GREY, "You can wash only dirty trays.");
		if(IsPlayerInRangeOfPoint(playerid, 1.04, 446.4695,1646.5646,1001.4623)) //WASHING SPOT [1]
		{
			if(Sink1Used == 1) return SendClientMessage(playerid, GREY, "Somebody is already washing dishes in that sink.");
			GetPlayerPos(playerid, RadioX, RadioY, RadioZ);
			TogglePlayerControllable(playerid, false);
			UsingDisher[playerid] = 1;
			Sink1Used = 1;
			format(str, sizeof(str), "* %s begins washing the tray in the sink.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			SetPlayerSpecialAction(playerid,0);
			HoldingTray[playerid] = 0;
			RemovePlayerAttachedObject(playerid, 1);
			RemovePlayerAttachedObject(playerid, 2);
			SetPlayerCameraPos(playerid, 446.4630, 1642.2726, 1002.6846);
			SetPlayerCameraLookAt(playerid, 446.4364, 1643.2673, 1002.4454);
			PlayNearBySound(playerid, 1144, RadioX, RadioY, RadioZ, 12);
			SetTimerEx("WaterSplashSound", 4000, false, "i", playerid);
			SetTimerEx("WashingTray", 8000, false, "i", playerid);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 1.04, 448.4959,1646.5646,1001.4623)) //WASHING SPOT [2]
		{
			if(Sink2Used == 1) return SendClientMessage(playerid, GREY, "Somebody is already washing dishes in that sink.");
			GetPlayerPos(playerid, RadioX, RadioY, RadioZ);
			TogglePlayerControllable(playerid, false);
			UsingDisher[playerid] = 2;
			Sink2Used = 1;
			SetPlayerSpecialAction(playerid,0);
			HoldingTray[playerid] = 0;
			RemovePlayerAttachedObject(playerid, 1);
			RemovePlayerAttachedObject(playerid, 2);
			format(str, sizeof(str), "* %s begins washing the tray in the sink.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			SetPlayerCameraPos(playerid, 448.3281, 1642.3224, 1002.6846);
			SetPlayerCameraLookAt(playerid, 448.3016, 1643.3171, 1002.4454);
			PlayNearBySound(playerid, 1144, RadioX, RadioY, RadioZ, 12);
			SetTimerEx("WaterSplashSound", 4000, false, "i", playerid);
			SetTimerEx("WashingTray", 8000, false, "i", playerid);
		}
		else
		{
			SendClientMessage(playerid, GREY, "You are not close enough to a sink in order to wash the dishes.");
		}
	}
	else return SendClientMessage(playerid, GREY, "You are not employed as a table cleaner or you currently can't wash the tray.");
	return 1;
}

COMMAND:eat(playerid, params[])
{
    if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
    if(PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You are cuffed or being dragged.");
	if(HoldingObject[playerid] >= 1) return SendClientMessage(playerid, GREY, "You can't eat while holding something in your hands.");
	new item[20];
    if(sscanf(params,"s[20]", item))
	{
		SendClientMessage(playerid, GREY, "USAGE: /eat [item]");
		SendClientMessage(playerid, GREY, "Items: sandwich.");
	    return 1;
	}
    else if(!strcmp(item, "sandwich", true))
	{
		return 1;
	}
	return 1;
}

COMMAND:puttray(playerid)
{
	if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
    if(PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You are cuffed or being dragged.");
	if(!(PlayerStat[playerid][JobID] == 2)) return SendClientMessage(playerid, GREY, "You have to be a table cleaner to use this command.");
	if(HoldingObject[playerid] == 2767)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.0, 445.3628,1632.0188,1001.0000))
		{
			FoodTrayCounter++;
			HoldingObject[playerid] = 0;
			HoldingTray[playerid] = 0;
			CountTraysUp();
			RemovePlayerAttachedObject(playerid, 1);
			RemovePlayerAttachedObject(playerid, 2);
			SetPlayerSpecialAction(playerid,0);
			PlayerStat[playerid][Paycheck] += 18;
			SendClientMessage(playerid, WHITE, "You have returned the tray into its place and earned 18$ to your paycheck.");
		}
		else
		{
			SendClientMessage(playerid, GREY, "You are not near the washed tray(s) pile.");
			return 1;
		}
	}
	else
	{
		SendClientMessage(playerid, GREY, "You are not holding a washed tray.");
	}
	return 1;
}

COMMAND:picklaundry(playerid)
{
	if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
    if(PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You are cuffed or being dragged.");
	if(PlayerStat[playerid][JobID] != 3) return SendClientMessage(playerid, GREY, "You have to be a laundry worker to use this command.");
	if(HoldingObject[playerid] >= 1) return SendClientMessage(playerid, GREY, "You are already holding something in your hand.");
	if(IsPlayerInRangeOfPoint(playerid, 3.5, 441.5202, 1667.2112, 1000.9258))
	{
		new str[128];
		ApplyAnimation(playerid, "CARRY", "liftup", 4.0, 0, 0, 0, 0, 0);
		format(str, sizeof(str), "* %s picks a stash of dirty laundry.", GetICName(playerid));
		SendNearByMessage(playerid, ACTION_COLOR, str, 8);
		SetPlayerSpecialAction(playerid, 25);
		new Random = random(3);
		if(Random == 0)
		{
			SetPlayerAttachedObject(playerid, 1, 2844, 6, 0.728, -0.0619, -0.320, -106.100, -2.299, 151.300);
		}
		if(Random == 1)
		{
			SetPlayerAttachedObject(playerid, 1, 2819, 6, 0.777, 0.000, 0.00, -105.099, -0.799, 101.6999);
		}
		if(Random == 2)
		{
			SetPlayerAttachedObject(playerid, 1, 2843, 6, -0.516, 0.137, 0.186, -116.5, -4.899, -7.7999);
		}
		HoldingObject[playerid] = 2844;
		SendClientMessage(playerid, WHITE, "Go and wash the diry laundry in the washing machine.");
	}
	else
	{
		SendClientMessage(playerid, WHITE, "You are not near the dirty laundry pile.");
	}
	return 1;
}

COMMAND:putlaundry(playerid)
{
	if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
    if(PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You are cuffed or being dragged.");
	if(PlayerStat[playerid][JobID] != 3) return SendClientMessage(playerid, GREY, "You have to be a laundry worker to use this command.");
	if(HoldingObject[playerid] == 0) return SendClientMessage(playerid, GREY, "You don't hold anything in your hands.");
	new str[128], Float:RadioX, Float:RadioY, Float:RadioZ;
	if(IsPlayerInRangeOfPoint(playerid, 1.5, 443.9777, 1670.3749, 1000.9990))
	{
		if(HoldingObject[playerid] != 2844) return SendClientMessage(playerid, GREY, "You are not holding dirty laundry in your hands.");
		GetPlayerPos(playerid, RadioX, RadioY, RadioZ);
		TogglePlayerControllable(playerid, false);
		ApplyAnimation(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0);
		RemovePlayerAttachedObject(playerid, 1);
		format(str, sizeof(str), "* %s places the dirty laundry inside the washing machine.", GetICName(playerid));
		SendNearByMessage(playerid, ACTION_COLOR, str, 8);
		SetPlayerSpecialAction(playerid, 0);
		HoldingObject[playerid] = 0;
		PlayNearBySound(playerid, 1020, RadioX, RadioY, RadioZ, 12);
		SetTimerEx("WashingLaundry", 8000, false, "i", playerid);
		return 1;
	}
	if(IsPlayerInRangeOfPoint(playerid, 1.5, 446.6522, 1667.9740, 1000.9990))
	{
		if(HoldingObject[playerid] != 2844) return SendClientMessage(playerid, GREY, "You are not holding dirty laundry in your hands.");
		GetPlayerPos(playerid, RadioX, RadioY, RadioZ);
		TogglePlayerControllable(playerid, false);
		ApplyAnimation(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0);
		RemovePlayerAttachedObject(playerid, 1);
		format(str, sizeof(str), "* %s places the dirty laundry inside the washing machine.", GetICName(playerid));
		SendNearByMessage(playerid, ACTION_COLOR, str, 8);
		SetPlayerSpecialAction(playerid, 0);
		HoldingObject[playerid] = 0;
		PlayNearBySound(playerid, 1020, RadioX, RadioY, RadioZ, 12);
		SetTimerEx("WashingLaundry", 8000, false, "i", playerid);
		return 1;
	}
	if(IsPlayerInRangeOfPoint(playerid, 2, 445.2638, 1663.8988, 1000.9990))
	{
		if(HoldingObject[playerid] == 2844) return SendClientMessage(playerid, GREY, "You can't put dirty clothes here.");
		if(HoldingObject[playerid] != 2384) return SendClientMessage(playerid, GREY, "This item can't be placed here.");
		ApplyAnimation(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0);
		RemovePlayerAttachedObject(playerid, 1);
		format(str, sizeof(str), "* %s places the washed laundry in the stack.", GetICName(playerid));
		SendNearByMessage(playerid, ACTION_COLOR, str, 8);
		SetPlayerSpecialAction(playerid, 0);
		HoldingObject[playerid] = 0;
		SendClientMessage(playerid, LIGHT_GREEN, "You have earned 7$ to your paycheck.");
		PlayerStat[playerid][Paycheck] += 7;
		return 1;
	}
	if(IsPlayerInRangeOfPoint(playerid, 2, 443.3646, 1663.9672, 1000.9990))
	{
		if(HoldingObject[playerid] == 2844) return SendClientMessage(playerid, GREY, "You can't put dirty clothes here.");
		if(HoldingObject[playerid] != 2386) return SendClientMessage(playerid, GREY, "This item can't be placed here.");
		ApplyAnimation(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0);
		RemovePlayerAttachedObject(playerid, 1);
		format(str, sizeof(str), "* %s places the washed laundry in the stack.", GetICName(playerid));
		SendNearByMessage(playerid, ACTION_COLOR, str, 8);
		SetPlayerSpecialAction(playerid, 0);
		HoldingObject[playerid] = 0;
		SendClientMessage(playerid, LIGHT_GREEN, "You have earned 7$ to your paycheck.");
		PlayerStat[playerid][Paycheck] += 7;
		return 1;
	}
	if(IsPlayerInRangeOfPoint(playerid, 2.5, 437.5423, 1669.6832, 1001.4434))
	{
		if(HoldingObject[playerid] == 2844) return SendClientMessage(playerid, GREY, "You can't put dirty clothes here.");
		if(HoldingObject[playerid] != 2389) return SendClientMessage(playerid, GREY, "This item can't be placed here.");
		ApplyAnimation(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0);
		RemovePlayerAttachedObject(playerid, 1);
		format(str, sizeof(str), "* %s places the washed laundry in the stack.", GetICName(playerid));
		SendNearByMessage(playerid, ACTION_COLOR, str, 8);
		SetPlayerSpecialAction(playerid, 0);
		HoldingObject[playerid] = 0;
		SendClientMessage(playerid, LIGHT_GREEN, "You have earned 7$ to your paycheck.");
		PlayerStat[playerid][Paycheck] += 7;
		return 1;
	}
	if(IsPlayerInRangeOfPoint(playerid, 2, 441.5526, 1663.9672, 1001.0000))
	{
		if(HoldingObject[playerid] == 2844) return SendClientMessage(playerid, GREY, "You can't put dirty clothes here.");
		if(HoldingObject[playerid] != 2396) return SendClientMessage(playerid, GREY, "This item can't be placed here.");
		ApplyAnimation(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0);
		RemovePlayerAttachedObject(playerid, 1);
		format(str, sizeof(str), "* %s places the washed laundry in the stack.", GetICName(playerid));
		SendNearByMessage(playerid, ACTION_COLOR, str, 8);
		SetPlayerSpecialAction(playerid, 0);
		HoldingObject[playerid] = 0;
		SendClientMessage(playerid, LIGHT_GREEN, "You have earned 7$ to your paycheck.");
		PlayerStat[playerid][Paycheck] += 7;
		return 1;
	}
	else
	{
		SendClientMessage(playerid, GREY, "You are not near a washing machine or a laundry stack.");
	}
	return 1;
}

COMMAND:picktrash(playerid)
{
	if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
    if(PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You are cuffed or being dragged.");
	if(PlayerStat[playerid][JobID] != 1) return SendClientMessage(playerid, GREY, "You have to be a garbage cleaner to use this command.");
	if(HoldingObject[playerid] >= 1) return SendClientMessage(playerid, GREY, "You are already holding something in your hand.");
	if(PlayerStat[playerid][PlasticBags] == 0) return SendClientMessage(playerid, GREY, "You dont have any plastic bags.");
	new str[128], Float:RadioX, Float:RadioY, Float:RadioZ;	
	if(IsPlayerInRangeOfPoint(playerid, 1.2, 440.2632, 1571.0500, 1000.6298)) // Trash1
	{
		if(Trash1Trash <= 9) return SendClientMessage(playerid, GREY, "There isn't enough trash to pick it up.");
		GetPlayerPos(playerid, RadioX, RadioY, RadioZ);
		PlayNearBySound(playerid, 5600, RadioX, RadioY, RadioZ, 12);
		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
		PlayerStat[playerid][PlasticBags] -= 1;
		TrashAmount[playerid] = Trash1Trash;
		Trash1Trash = 0;
		Delete3DTextLabel(Trash1Label);
		format(str, sizeof(str), "Trash Can\n[%d] / [50]", Trash1Trash);
		Trash1Label = Create3DTextLabel(str, WHITE, 440.2632, 1571.0500, 1000.6298, 8.0, 0, 0);
		format(str, sizeof(str), "* %s picks the trash bag from the bin, and replaces it with a new one.", GetICName(playerid));
		SendNearByMessage(playerid, ACTION_COLOR, str, 7);
		if(TrashAmount[playerid] <= 39)
		{
			SetPlayerAttachedObject(playerid, 1, 1265, 6, 0.194998, -0.013000, 0.106999, -103.40, -44.99974, 84.79957, 0.6, 0.6, 0.6);
			HoldingObject[playerid] = 1265;
		}
		else
		{
			SetPlayerAttachedObject(playerid, 1, 1264, 6, 0.435998, -0.1850, -0.103999, -109.8, -71.50, 110.30);
			HoldingObject[playerid] = 1264;
		}
		return 1;
	}
	if(IsPlayerInRangeOfPoint(playerid, 1.2, 431.2000, 1604.6610, 1000.6298)) // Trash2
	{
		if(Trash2Trash <= 9) return SendClientMessage(playerid, GREY, "There isn't enough trash to pick it up.");
		GetPlayerPos(playerid, RadioX, RadioY, RadioZ);
		PlayNearBySound(playerid, 5600, RadioX, RadioY, RadioZ, 12);
		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
		PlayerStat[playerid][PlasticBags] -= 1;
		TrashAmount[playerid] = Trash2Trash;
		Trash2Trash = 0;
		Delete3DTextLabel(Trash2Label);
		format(str, sizeof(str), "Trash Can\n[%d] / [50]", Trash2Trash);
		Trash2Label = Create3DTextLabel(str, WHITE, 440.2632, 1571.0500, 1000.6298, 8.0, 0, 0);
		format(str, sizeof(str), "* %s picks the trash bag from the bin, and replaces it with a new one.", GetICName(playerid));
		SendNearByMessage(playerid, ACTION_COLOR, str, 7);
		if(TrashAmount[playerid] <= 39)
		{
			SetPlayerAttachedObject(playerid, 1, 1265, 6, 0.194998, -0.013000, 0.106999, -103.40, -44.99974, 84.79957, 0.6, 0.6, 0.6);
			HoldingObject[playerid] = 1265;
		}
		else
		{
			SetPlayerAttachedObject(playerid, 1, 1264, 6, 0.435998, -0.1850, -0.103999, -109.8, -71.50, 110.30);
			HoldingObject[playerid] = 1264;
		}
		return 1;
	}
	if(IsPlayerInRangeOfPoint(playerid, 1.2, 442.7476, 1591.0435, 1000.6298)) // Trash3
	{
		if(Trash3Trash <= 9) return SendClientMessage(playerid, GREY, "There isn't enough trash to pick it up.");
		GetPlayerPos(playerid, RadioX, RadioY, RadioZ);
		PlayNearBySound(playerid, 5600, RadioX, RadioY, RadioZ, 12);
		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
		PlayerStat[playerid][PlasticBags] -= 1;
		TrashAmount[playerid] = Trash3Trash;
		Trash3Trash = 0;
		Delete3DTextLabel(Trash3Label);
		format(str, sizeof(str), "Trash Can\n[%d] / [50]", Trash3Trash);
		Trash3Label = Create3DTextLabel(str, WHITE, 440.2632, 1571.0500, 1000.6298, 8.0, 0, 0);
		format(str, sizeof(str), "* %s picks the trash bag from the bin, and replaces it with a new one.", GetICName(playerid));
		SendNearByMessage(playerid, ACTION_COLOR, str, 7);
		if(TrashAmount[playerid] <= 39)
		{
			SetPlayerAttachedObject(playerid, 1, 1265, 6, 0.194998, -0.013000, 0.106999, -103.40, -44.99974, 84.79957, 0.6, 0.6, 0.6);
			HoldingObject[playerid] = 1265;
		}
		else
		{
			SetPlayerAttachedObject(playerid, 1, 1264, 6, 0.435998, -0.1850, -0.103999, -109.8, -71.50, 110.30);
			HoldingObject[playerid] = 1264;
		}
		return 1;
	}
	if(IsPlayerInRangeOfPoint(playerid, 1.2, 440.9911, 1643.5480, 1000.6298)) // Trash4
	{
		if(Trash4Trash <= 9) return SendClientMessage(playerid, GREY, "There isn't enough trash to pick it up.");
		GetPlayerPos(playerid, RadioX, RadioY, RadioZ);
		PlayNearBySound(playerid, 5600, RadioX, RadioY, RadioZ, 12);
		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
		PlayerStat[playerid][PlasticBags] -= 1;
		TrashAmount[playerid] = Trash4Trash;
		Trash4Trash = 0;
		Delete3DTextLabel(Trash4Label);
		format(str, sizeof(str), "Trash Can\n[%d] / [50]", Trash4Trash);
		Trash4Label = Create3DTextLabel(str, WHITE, 440.2632, 1571.0500, 1000.6298, 8.0, 0, 0);
		format(str, sizeof(str), "* %s picks the trash bag from the bin, and replaces it with a new one.", GetICName(playerid));
		SendNearByMessage(playerid, ACTION_COLOR, str, 7);
		if(TrashAmount[playerid] <= 39)
		{
			SetPlayerAttachedObject(playerid, 1, 1265, 6, 0.194998, -0.013000, 0.106999, -103.40, -44.99974, 84.79957, 0.6, 0.6, 0.6);
			HoldingObject[playerid] = 1265;
		}
		else
		{
			SetPlayerAttachedObject(playerid, 1, 1264, 6, 0.435998, -0.1850, -0.103999, -109.8, -71.50, 110.30);
			HoldingObject[playerid] = 1264;
		}
		return 1;
	}
	if(IsPlayerInRangeOfPoint(playerid, 1.2, 444.3441, 1646.5009, 1000.7)) // Trash5
	{
		if(Trash5Trash <= 9) return SendClientMessage(playerid, GREY, "There isn't enough trash to pick it up.");
		GetPlayerPos(playerid, RadioX, RadioY, RadioZ);
		PlayNearBySound(playerid, 5600, RadioX, RadioY, RadioZ, 12);
		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
		PlayerStat[playerid][PlasticBags] -= 1;
		TrashAmount[playerid] = Trash5Trash;
		Trash5Trash = 0;
		Delete3DTextLabel(Trash5Label);
		format(str, sizeof(str), "Trash Can\n[%d] / [50]", Trash5Trash);
		Trash5Label = Create3DTextLabel(str, WHITE, 440.2632, 1571.0500, 1000.6298, 8.0, 0, 0);
		format(str, sizeof(str), "* %s picks the trash bag from the bin, and replaces it with a new one.", GetICName(playerid));
		SendNearByMessage(playerid, ACTION_COLOR, str, 7);
		if(TrashAmount[playerid] <= 39)
		{
			SetPlayerAttachedObject(playerid, 1, 1265, 6, 0.194998, -0.013000, 0.106999, -103.40, -44.99974, 84.79957, 0.6, 0.6, 0.6);
			HoldingObject[playerid] = 1265;
		}
		else
		{
			SetPlayerAttachedObject(playerid, 1, 1264, 6, 0.435998, -0.1850, -0.103999, -109.8, -71.50, 110.30);
			HoldingObject[playerid] = 1264;
		}
		return 1;
	}
	if(IsPlayerInRangeOfPoint(playerid, 1.2, 207.7989, 1447.8103, 10.3810)) // Trash6
	{
		if(Trash6Trash <= 9) return SendClientMessage(playerid, GREY, "There isn't enough trash to pick it up.");
		GetPlayerPos(playerid, RadioX, RadioY, RadioZ);
		PlayNearBySound(playerid, 5600, RadioX, RadioY, RadioZ, 12);
		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
		PlayerStat[playerid][PlasticBags] -= 1;
		TrashAmount[playerid] = Trash6Trash;
		Trash6Trash = 0;
		Delete3DTextLabel(Trash6Label);
		format(str, sizeof(str), "Trash Can\n[%d] / [50]", Trash6Trash);
		Trash6Label = Create3DTextLabel(str, WHITE, 440.2632, 1571.0500, 1000.6298, 8.0, 0, 0);
		format(str, sizeof(str), "* %s picks the trash bag from the bin, and replaces it with a new one.", GetICName(playerid));
		SendNearByMessage(playerid, ACTION_COLOR, str, 7);
		if(TrashAmount[playerid] <= 39)
		{
			SetPlayerAttachedObject(playerid, 1, 1265, 6, 0.194998, -0.013000, 0.106999, -103.40, -44.99974, 84.79957, 0.6, 0.6, 0.6);
			HoldingObject[playerid] = 1265;
		}
		else
		{
			SetPlayerAttachedObject(playerid, 1, 1264, 6, 0.435998, -0.1850, -0.103999, -109.8, -71.50, 110.30);
			HoldingObject[playerid] = 1264;
		}
	}
	if(IsPlayerInRangeOfPoint(playerid, 1.2, 273.8112, 1449.6755, 10.3810)) // Trash7
	{
		if(Trash7Trash <= 9) return SendClientMessage(playerid, GREY, "There isn't enough trash to pick it up.");
		GetPlayerPos(playerid, RadioX, RadioY, RadioZ);
		PlayNearBySound(playerid, 5600, RadioX, RadioY, RadioZ, 12);
		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
		PlayerStat[playerid][PlasticBags] -= 1;
		TrashAmount[playerid] = Trash7Trash;
		Trash7Trash = 0;
		Delete3DTextLabel(Trash7Label);
		format(str, sizeof(str), "Trash Can\n[%d] / [50]", Trash7Trash);
		Trash7Label = Create3DTextLabel(str, WHITE, 440.2632, 1571.0500, 1000.6298, 8.0, 0, 0);
		format(str, sizeof(str), "* %s picks the trash bag from the bin, and replaces it with a new one.", GetICName(playerid));
		SendNearByMessage(playerid, ACTION_COLOR, str, 7);
		if(TrashAmount[playerid] <= 39)
		{
			SetPlayerAttachedObject(playerid, 1, 1265, 6, 0.194998, -0.013000, 0.106999, -103.40, -44.99974, 84.79957, 0.6, 0.6, 0.6);
			HoldingObject[playerid] = 1265;
		}
		else
		{
			SetPlayerAttachedObject(playerid, 1, 1264, 6, 0.435998, -0.1850, -0.103999, -109.8, -71.50, 110.30);
			HoldingObject[playerid] = 1264;
		}
		return 1;
	}
	else return SendClientMessage(playerid, GREY, "You are not near any trash can.");
}

COMMAND:throwtrash(playerid)
{
	if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
    if(PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You are cuffed or being dragged.");
	if(PlayerStat[playerid][JobID] != 1) return SendClientMessage(playerid, GREY, "You have to be a garbage cleaner to use this command.");
	if(HoldingObject[playerid] == 0) return SendClientMessage(playerid, GREY, "You are not holding anything.");
	new str[128];
	if(IsPlayerInRangeOfPoint(playerid, 0.8, 211.0933, 1437.4363, 10.8826)) // TrashBig1
	{
		HoldingObject[playerid] = 0;
		RemovePlayerAttachedObject(playerid, 1);
		format(str, sizeof(str), "* %s throws the trash bag inside the big dumpster.", GetICName(playerid));
		SendNearByMessage(playerid, ACTION_COLOR, str, 7);
		if(TrashAmount[playerid] <= 15)
		{
			PlayerStat[playerid][Paycheck] += 13;
			SendClientMessage(playerid, WHITE, "You have disposed a trash bag and earned 13$ to your paycheck.");
			TrashAmount[playerid] = 0;
			return 1;
		}
		else if(TrashAmount[playerid] <= 25)
		{
			PlayerStat[playerid][Paycheck] += 18;
			SendClientMessage(playerid, WHITE, "You have disposed a trash bag and earned 18$ to your paycheck.");
			TrashAmount[playerid] = 0;
			return 1;
		}
		else if(TrashAmount[playerid] <= 45)
		{
			PlayerStat[playerid][Paycheck] += 30;
			SendClientMessage(playerid, WHITE, "You have disposed a trash bag and earned 30$ to your paycheck.");
			TrashAmount[playerid] = 0;
			return 1;
		}
		else if(TrashAmount[playerid] == 50)
		{
			PlayerStat[playerid][Paycheck] += 35;
			SendClientMessage(playerid, WHITE, "You have disposed a trash bag and earned 35$ to your paycheck.");
			TrashAmount[playerid] = 0;
			return 1;
		}
	}
	else if(IsPlayerInRangeOfPoint(playerid, 0.8, 213.8933, 1437.4363, 10.8826)) // TrashBig1
	{
		HoldingObject[playerid] = 0;
		RemovePlayerAttachedObject(playerid, 1);
		format(str, sizeof(str), "* %s throws the trash bag inside the big dumpster.", GetICName(playerid));
		SendNearByMessage(playerid, ACTION_COLOR, str, 7);
		if(TrashAmount[playerid] <= 15)
		{
			PlayerStat[playerid][Paycheck] += 13;
			SendClientMessage(playerid, WHITE, "You have disposed a trash bag and earned 13$ to your paycheck.");
			TrashAmount[playerid] = 0;
			return 1;
		}
		else if(TrashAmount[playerid] <= 25)
		{
			PlayerStat[playerid][Paycheck] += 18;
			SendClientMessage(playerid, WHITE, "You have disposed a trash bag and earned 18$ to your paycheck.");
			TrashAmount[playerid] = 0;
			return 1;
		}
		else if(TrashAmount[playerid] <= 45)
		{
			PlayerStat[playerid][Paycheck] += 30;
			SendClientMessage(playerid, WHITE, "You have disposed a trash bag and earned 30$ to your paycheck.");
			TrashAmount[playerid] = 0;
			return 1;
		}
		else if(TrashAmount[playerid] == 50)
		{
			PlayerStat[playerid][Paycheck] += 35;
			SendClientMessage(playerid, WHITE, "You have disposed a trash bag and earned 35$ to your paycheck.");
			TrashAmount[playerid] = 0;
			return 1;
		}
	}
	else if(IsPlayerInRangeOfPoint(playerid, 0.8, 216.5873, 1437.4363, 10.8826)) // TrashBig1
	{
		format(str, sizeof(str), "* %s throws the trash bag inside the big dumpster.", GetICName(playerid));
		SendNearByMessage(playerid, ACTION_COLOR, str, 7);
		HoldingObject[playerid] = 0;
		RemovePlayerAttachedObject(playerid, 1);
		if(TrashAmount[playerid] <= 15)
		{
			PlayerStat[playerid][Paycheck] += 13;
			SendClientMessage(playerid, WHITE, "You have disposed a trash bag and earned 13$ to your paycheck.");
			TrashAmount[playerid] = 0;
			return 1;
		}
		else if(TrashAmount[playerid] <= 25)
		{
			PlayerStat[playerid][Paycheck] += 18;
			SendClientMessage(playerid, WHITE, "You have disposed a trash bag and earned 18$ to your paycheck.");
			TrashAmount[playerid] = 0;
			return 1;
		}
		else if(TrashAmount[playerid] <= 45)
		{
			PlayerStat[playerid][Paycheck] += 30;
			SendClientMessage(playerid, WHITE, "You have disposed a trash bag and earned 30$ to your paycheck.");
			TrashAmount[playerid] = 0;
			return 1;
		}
		else if(TrashAmount[playerid] == 50)
		{
			PlayerStat[playerid][Paycheck] += 35;
			SendClientMessage(playerid, WHITE, "You have disposed a trash bag and earned 35$ to your paycheck.");
			TrashAmount[playerid] = 0;
			return 1;
		}
	}
	else
	{
		SendClientMessage(playerid, GREY, "You are not near any big dumpsters.");
	}
	return 1;
}

COMMAND:picktray(playerid)
{
	if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
    if(PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You are cuffed or being dragged.");
	new str[128];
	if(PlayerStat[playerid][JobID] == 2 && PlayerStat[playerid][AbleToCleanTables] == 1)
	{
		if(HoldingObject[playerid] >= 1) return SendClientMessage(playerid, GREY, "You are currently holding another object in your hands.");
		if(IsPlayerInRangeOfPoint(playerid, 1.1, 435.1019, 1642.7490, 1000.8380)) //Table1Spot0
		{
			if(Table1Spot0Used == 0) return SendClientMessage(playerid, GREY, "There is no tray to pick up.");
			HoldingObject[playerid] = 2823;
			DestroyDynamicObject(Table1Spot0Object1);
			DestroyDynamicObject(Table1Spot0Object2);
			Table1Spot0Used = 0;
			TableTrashCounter--;
			SetPlayerSpecialAction(playerid, 25);
			SetPlayerAttachedObject(playerid, 1, 2767, 6, 0.194999, 0.03100, -0.171000, -109.8, -11.700, 96.9);
			SetPlayerAttachedObject(playerid, 2, 2823, 6, 0.175998, 0.04999, -0.16299, -109.90009, -11.800010, -110.599998);
			format(str, sizeof(str), "* %s picks a dirty tray from the table.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			return 1;
		}
		if(IsPlayerInRangeOfPoint(playerid, 1.1, 436.4199, 1642.7490, 1000.8380)) //Table1Spot1
		{
			if(Table1Spot1Used == 0) return SendClientMessage(playerid, GREY, "There is no tray to pick up.");
			HoldingObject[playerid] = 2823;
			DestroyDynamicObject(Table1Spot1Object1);
			DestroyDynamicObject(Table1Spot1Object2);
			Table1Spot1Used = 0;
			TableTrashCounter--;
			SetPlayerSpecialAction(playerid, 25);
			SetPlayerAttachedObject(playerid, 1, 2767, 6, 0.194999, 0.03100, -0.171000, -109.8, -11.700, 96.9);
			SetPlayerAttachedObject(playerid, 2, 2823, 6, 0.175998, 0.04999, -0.16299, -109.90009, -11.800010, -110.599998);
			format(str, sizeof(str), "* %s picks a dirty tray from the table.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			return 1;
		}
		if(IsPlayerInRangeOfPoint(playerid, 1.1, 435.0883, 1642.0743, 1000.8380)) //Table1Spot2
		{
			if(Table1Spot2Used == 0) return SendClientMessage(playerid, GREY, "There is no tray to pick up.");
			HoldingObject[playerid] = 2823;
			DestroyDynamicObject(Table1Spot2Object1);
			DestroyDynamicObject(Table1Spot2Object2);
			Table1Spot2Used = 0;
			TableTrashCounter--;
			SetPlayerSpecialAction(playerid, 25);
			SetPlayerAttachedObject(playerid, 1, 2767, 6, 0.194999, 0.03100, -0.171000, -109.8, -11.700, 96.9);
			SetPlayerAttachedObject(playerid, 2, 2823, 6, 0.175998, 0.04999, -0.16299, -109.90009, -11.800010, -110.599998);
			format(str, sizeof(str), "* %s picks a dirty tray from the table.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			return 1;
		}
		if(IsPlayerInRangeOfPoint(playerid, 1.1, 436.4199, 1642.0743, 1000.8380)) //Table1Spot3
		{
			if(Table1Spot3Used == 0) return SendClientMessage(playerid, GREY, "There is no tray to pick up.");
			HoldingObject[playerid] = 2823;
			DestroyDynamicObject(Table1Spot3Object1);
			DestroyDynamicObject(Table1Spot3Object2);
			Table1Spot3Used = 0;
			TableTrashCounter--;
			SetPlayerSpecialAction(playerid, 25);
			SetPlayerAttachedObject(playerid, 1, 2767, 6, 0.194999, 0.03100, -0.171000, -109.8, -11.700, 96.9);
			SetPlayerAttachedObject(playerid, 2, 2823, 6, 0.175998, 0.04999, -0.16299, -109.90009, -11.800010, -110.599998);
			format(str, sizeof(str), "* %s picks a dirty tray from the table.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			return 1;
		}
		if(IsPlayerInRangeOfPoint(playerid, 1.1, 435.0883, 1639.5402, 1000.8380)) //Table2Spot0 [4]
		{
			if(Table2Spot0Used == 0) return SendClientMessage(playerid, GREY, "There is no tray to pick up.");
			HoldingObject[playerid] = 2823;
			DestroyDynamicObject(Table2Spot0Object1);
			DestroyDynamicObject(Table2Spot0Object2);
			Table2Spot0Used = 0;
			TableTrashCounter--;
			SetPlayerSpecialAction(playerid, 25);
			SetPlayerAttachedObject(playerid, 1, 2767, 6, 0.194999, 0.03100, -0.171000, -109.8, -11.700, 96.9);
			SetPlayerAttachedObject(playerid, 2, 2823, 6, 0.175998, 0.04999, -0.16299, -109.90009, -11.800010, -110.599998);
			format(str, sizeof(str), "* %s picks a dirty tray from the table.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			return 1;
		}
		if(IsPlayerInRangeOfPoint(playerid, 1.1, 436.4199, 1639.5402, 1000.8380)) //Table2Spot1 [5]
		{
			if(Table2Spot1Used == 0) return SendClientMessage(playerid, GREY, "There is no tray to pick up.");
			HoldingObject[playerid] = 2823;
			DestroyDynamicObject(Table2Spot1Object1);
			DestroyDynamicObject(Table2Spot1Object2);
			Table2Spot1Used = 0;
			TableTrashCounter--;
			SetPlayerSpecialAction(playerid, 25);
			SetPlayerAttachedObject(playerid, 1, 2767, 6, 0.194999, 0.03100, -0.171000, -109.8, -11.700, 96.9);
			SetPlayerAttachedObject(playerid, 2, 2823, 6, 0.175998, 0.04999, -0.16299, -109.90009, -11.800010, -110.599998);
			format(str, sizeof(str), "* %s picks a dirty tray from the table.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			return 1;
		}
		if(IsPlayerInRangeOfPoint(playerid, 1.1, 435.0883, 1638.8573, 1000.8380)) //Table2Spot2
		{
			if(Table2Spot2Used == 0) return SendClientMessage(playerid, GREY, "There is no tray to pick up.");
			HoldingObject[playerid] = 2823;
			DestroyDynamicObject(Table2Spot2Object1);
			DestroyDynamicObject(Table2Spot2Object2);
			Table2Spot2Used = 0;
			TableTrashCounter--;
			SetPlayerSpecialAction(playerid, 25);
			SetPlayerAttachedObject(playerid, 1, 2767, 6, 0.194999, 0.03100, -0.171000, -109.8, -11.700, 96.9);
			SetPlayerAttachedObject(playerid, 2, 2823, 6, 0.175998, 0.04999, -0.16299, -109.90009, -11.800010, -110.599998);
			format(str, sizeof(str), "* %s picks a dirty tray from the table.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			return 1;
		}
		if(IsPlayerInRangeOfPoint(playerid, 1.1, 436.4199, 1638.8573, 1000.8380)) //Table2Spot3 [7]
		{
			if(Table2Spot3Used == 0) return SendClientMessage(playerid, GREY, "There is no tray to pick up.");
			HoldingObject[playerid] = 2823;
			DestroyDynamicObject(Table2Spot3Object1);
			DestroyDynamicObject(Table2Spot3Object2);
			Table2Spot3Used = 0;
			TableTrashCounter--;
			SetPlayerSpecialAction(playerid, 25);
			SetPlayerAttachedObject(playerid, 1, 2767, 6, 0.194999, 0.03100, -0.171000, -109.8, -11.700, 96.9);
			SetPlayerAttachedObject(playerid, 2, 2823, 6, 0.175998, 0.04999, -0.16299, -109.90009, -11.800010, -110.599998);
			format(str, sizeof(str), "* %s picks a dirty tray from the table.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			return 1;
		}
		if(IsPlayerInRangeOfPoint(playerid, 1.1, 435.0883, 1636.3323, 1000.8380)) //Table3Spot0 [8]
		{
			if(Table3Spot0Used == 0) return SendClientMessage(playerid, GREY, "There is no tray to pick up.");
			HoldingObject[playerid] = 2823;
			DestroyDynamicObject(Table3Spot0Object1);
			DestroyDynamicObject(Table3Spot0Object2);
			Table3Spot0Used = 0;
			TableTrashCounter--;
			SetPlayerSpecialAction(playerid, 25);
			SetPlayerAttachedObject(playerid, 1, 2767, 6, 0.194999, 0.03100, -0.171000, -109.8, -11.700, 96.9);
			SetPlayerAttachedObject(playerid, 2, 2823, 6, 0.175998, 0.04999, -0.16299, -109.90009, -11.800010, -110.599998);
			format(str, sizeof(str), "* %s picks a dirty tray from the table.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			return 1;
		}
		if(IsPlayerInRangeOfPoint(playerid, 1.1, 436.4199, 1636.3323, 1000.8380)) //Table3Spot1 [9]
		{
			if(Table3Spot1Used == 0) return SendClientMessage(playerid, GREY, "There is no tray to pick up.");
			HoldingObject[playerid] = 2823;
			DestroyDynamicObject(Table3Spot1Object1);
			DestroyDynamicObject(Table3Spot1Object2);
			Table3Spot1Used = 0;
			TableTrashCounter--;
			SetPlayerSpecialAction(playerid, 25);
			SetPlayerAttachedObject(playerid, 1, 2767, 6, 0.194999, 0.03100, -0.171000, -109.8, -11.700, 96.9);
			SetPlayerAttachedObject(playerid, 2, 2823, 6, 0.175998, 0.04999, -0.16299, -109.90009, -11.800010, -110.599998);
			format(str, sizeof(str), "* %s picks a dirty tray from the table.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			return 1;
		}
		if(IsPlayerInRangeOfPoint(playerid, 1.1, 435.0883, 1635.6503, 1000.8380)) //Table3Spot2 [10]
		{
			if(Table3Spot2Used == 0) return SendClientMessage(playerid, GREY, "There is no tray to pick up.");
			HoldingObject[playerid] = 2823;
			DestroyDynamicObject(Table3Spot2Object1);
			DestroyDynamicObject(Table3Spot2Object2);
			Table3Spot2Used = 0;
			TableTrashCounter--;
			SetPlayerSpecialAction(playerid, 25);
			SetPlayerAttachedObject(playerid, 1, 2767, 6, 0.194999, 0.03100, -0.171000, -109.8, -11.700, 96.9);
			SetPlayerAttachedObject(playerid, 2, 2823, 6, 0.175998, 0.04999, -0.16299, -109.90009, -11.800010, -110.599998);
			format(str, sizeof(str), "* %s picks a dirty tray from the table.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			return 1;
		}
		if(IsPlayerInRangeOfPoint(playerid, 1.1, 436.4199, 1635.6503, 1000.8380)) //Table3Spot3 [11]
		{
			if(Table3Spot3Used == 0) return SendClientMessage(playerid, GREY, "There is no tray to pick up.");
			HoldingObject[playerid] = 2823;
			DestroyDynamicObject(Table3Spot3Object1);
			DestroyDynamicObject(Table3Spot3Object2);
			Table3Spot3Used = 0;
			TableTrashCounter--;
			SetPlayerSpecialAction(playerid, 25);
			SetPlayerAttachedObject(playerid, 1, 2767, 6, 0.194999, 0.03100, -0.171000, -109.8, -11.700, 96.9);
			SetPlayerAttachedObject(playerid, 2, 2823, 6, 0.175998, 0.04999, -0.16299, -109.90009, -11.800010, -110.599998);
			format(str, sizeof(str), "* %s picks a dirty tray from the table.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			return 1;
		}
		if(IsPlayerInRangeOfPoint(playerid, 1.1, 430.7341, 1638.7535, 1000.8380)) //Table4Spot0 [12]
		{
			if(Table4Spot0Used == 0) return SendClientMessage(playerid, GREY, "There is no tray to pick up.");
			HoldingObject[playerid] = 2823;
			DestroyDynamicObject(Table4Spot0Object1);
			DestroyDynamicObject(Table4Spot0Object2);
			Table4Spot0Used = 0;
			TableTrashCounter--;
			SetPlayerSpecialAction(playerid, 25);
			SetPlayerAttachedObject(playerid, 1, 2767, 6, 0.194999, 0.03100, -0.171000, -109.8, -11.700, 96.9);
			SetPlayerAttachedObject(playerid, 2, 2823, 6, 0.175998, 0.04999, -0.16299, -109.90009, -11.800010, -110.599998);
			format(str, sizeof(str), "* %s picks a dirty tray from the table.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			return 1;
		}
		if(IsPlayerInRangeOfPoint(playerid, 1.1, 432.1181, 1638.7535, 1000.8380)) //Table4Spot1 [13]
		{
			if(Table4Spot1Used == 0) return SendClientMessage(playerid, GREY, "There is no tray to pick up.");
			HoldingObject[playerid] = 2823;
			DestroyDynamicObject(Table4Spot1Object1);
			DestroyDynamicObject(Table4Spot1Object2);
			Table4Spot1Used = 0;
			TableTrashCounter--;
			SetPlayerSpecialAction(playerid, 25);
			SetPlayerAttachedObject(playerid, 1, 2767, 6, 0.194999, 0.03100, -0.171000, -109.8, -11.700, 96.9);
			SetPlayerAttachedObject(playerid, 2, 2823, 6, 0.175998, 0.04999, -0.16299, -109.90009, -11.800010, -110.599998);
			format(str, sizeof(str), "* %s picks a dirty tray from the table.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			return 1;
		}
		if(IsPlayerInRangeOfPoint(playerid, 1.1, 430.7351, 1638.0706, 1000.8380)) //Table4Spot2 [14]
		{
			if(Table4Spot2Used == 0) return SendClientMessage(playerid, GREY, "There is no tray to pick up.");
			HoldingObject[playerid] = 2823;
			DestroyDynamicObject(Table4Spot2Object1);
			DestroyDynamicObject(Table4Spot2Object2);
			Table4Spot2Used = 0;
			TableTrashCounter--;
			SetPlayerSpecialAction(playerid, 25);
			SetPlayerAttachedObject(playerid, 1, 2767, 6, 0.194999, 0.03100, -0.171000, -109.8, -11.700, 96.9);
			SetPlayerAttachedObject(playerid, 2, 2823, 6, 0.175998, 0.04999, -0.16299, -109.90009, -11.800010, -110.599998);
			format(str, sizeof(str), "* %s picks a dirty tray from the table.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			return 1;
		}
		if(IsPlayerInRangeOfPoint(playerid, 1.1, 432.1181, 1638.0706, 1000.8380)) //Table4Spot3 [15]
		{
			if(Table4Spot3Used == 0) return SendClientMessage(playerid, GREY, "There is no tray to pick up.");
			HoldingObject[playerid] = 2823;
			DestroyDynamicObject(Table4Spot3Object1);
			DestroyDynamicObject(Table4Spot3Object2);
			Table4Spot3Used = 0;
			TableTrashCounter--;
			SetPlayerSpecialAction(playerid, 25);
			SetPlayerAttachedObject(playerid, 1, 2767, 6, 0.194999, 0.03100, -0.171000, -109.8, -11.700, 96.9);
			SetPlayerAttachedObject(playerid, 2, 2823, 6, 0.175998, 0.04999, -0.16299, -109.90009, -11.800010, -110.599998);
			format(str, sizeof(str), "* %s picks a dirty tray from the table.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			return 1;
		}
		if(IsPlayerInRangeOfPoint(playerid, 1.1, 430.7341, 1635.6615, 1000.8380)) //Table5Spot0 [16]
		{
			if(Table5Spot0Used == 0) return SendClientMessage(playerid, GREY, "There is no tray to pick up.");
			HoldingObject[playerid] = 2823;
			DestroyDynamicObject(Table5Spot0Object1);
			DestroyDynamicObject(Table5Spot0Object2);
			Table5Spot0Used = 0;
			TableTrashCounter--;
			SetPlayerSpecialAction(playerid, 25);
			SetPlayerAttachedObject(playerid, 1, 2767, 6, 0.194999, 0.03100, -0.171000, -109.8, -11.700, 96.9);
			SetPlayerAttachedObject(playerid, 2, 2823, 6, 0.175998, 0.04999, -0.16299, -109.90009, -11.800010, -110.599998);
			format(str, sizeof(str), "* %s picks a dirty tray from the table.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			return 1;
		}
		if(IsPlayerInRangeOfPoint(playerid, 1.1, 432.1181, 1635.6595, 1000.8380)) //Table5Spot1 [17]
		{
			if(Table5Spot1Used == 0) return SendClientMessage(playerid, GREY, "There is no tray to pick up.");
			HoldingObject[playerid] = 2823;
			DestroyDynamicObject(Table5Spot1Object1);
			DestroyDynamicObject(Table5Spot1Object2);
			Table5Spot1Used = 0;
			TableTrashCounter--;
			SetPlayerSpecialAction(playerid, 25);
			SetPlayerAttachedObject(playerid, 1, 2767, 6, 0.194999, 0.03100, -0.171000, -109.8, -11.700, 96.9);
			SetPlayerAttachedObject(playerid, 2, 2823, 6, 0.175998, 0.04999, -0.16299, -109.90009, -11.800010, -110.599998);
			format(str, sizeof(str), "* %s picks a dirty tray from the table.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			return 1;
		}
		if(IsPlayerInRangeOfPoint(playerid, 1.1, 430.7341, 1634.9775, 1000.8380)) //Table5Spot2 [18]
		{
			if(Table5Spot2Used == 0) return SendClientMessage(playerid, GREY, "There is no tray to pick up.");
			HoldingObject[playerid] = 2823;
			DestroyDynamicObject(Table5Spot2Object1);
			DestroyDynamicObject(Table5Spot2Object2);
			Table5Spot2Used = 0;
			TableTrashCounter--;
			SetPlayerSpecialAction(playerid, 25);
			SetPlayerAttachedObject(playerid, 1, 2767, 6, 0.194999, 0.03100, -0.171000, -109.8, -11.700, 96.9);
			SetPlayerAttachedObject(playerid, 2, 2823, 6, 0.175998, 0.04999, -0.16299, -109.90009, -11.800010, -110.599998);
			format(str, sizeof(str), "* %s picks a dirty tray from the table.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			return 1;
		}
		if(IsPlayerInRangeOfPoint(playerid, 1.1, 432.1181, 1634.9796, 1000.8380)) //Table5Spot3 [19]
		{
			if(Table5Spot3Used == 0) return SendClientMessage(playerid, GREY, "There is no tray to pick up.");
			HoldingObject[playerid] = 2823;
			DestroyDynamicObject(Table5Spot3Object1);
			DestroyDynamicObject(Table5Spot3Object2);
			Table5Spot3Used = 0;
			TableTrashCounter--;
			SetPlayerSpecialAction(playerid, 25);
			SetPlayerAttachedObject(playerid, 1, 2767, 6, 0.194999, 0.03100, -0.171000, -109.8, -11.700, 96.9);
			SetPlayerAttachedObject(playerid, 2, 2823, 6, 0.175998, 0.04999, -0.16299, -109.90009, -11.800010, -110.599998);
			format(str, sizeof(str), "* %s picks a dirty tray from the table.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			return 1;
		}
		SendClientMessage(playerid, GREY, "There is no tray to pick up.");
	}
	else return SendClientMessage(playerid, GREY, "You are not employed as a table cleaner or you currently can't pick the tray.");
	return 1;
}

/*COMMAND:givemeal(playerid, params[])
{
	new targetid, str[128];
	if(HoldingTray[playerid] == 0) return SendClientMessage(playerid, GREY, "You got no food tray in your hands.");
	if(sscanf(params,"u", targetid))return SendClientMessage(playerid, GREY, "USAGE: /givemeal [playerid]");
	if(HoldingTray[targetid] == 1) return SendClientMessage(playerid, GREY, "Player is already holding a tray.");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(playerid == targetid) return SendClientMessage(playerid, GREY, "You can't use this command on yourself.");
	if(!IsPlayerInRangeOfPlayer(1, playerid, targetid)) return SendClientMessage(playerid, GREY, "Player is too far away.");
	if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
    if(PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You are cuffed or being dragged.");
	if(PlayerStat[targetid][Dead] == 1 || PlayerStat[targetid][InHospital] == 1) return SendClientMessage(playerid, GREY, "The player is unconscious.");
    if(PlayerStat[targetid][BeingDragged] == 1 || PlayerStat[targetid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "The player is cuffed or being dragged.");
	HoldingTray[targetid] = 1;
	HoldingTray[playerid] = 0;
	SetPlayerSpecialAction(targetid, 25);
	SetPlayerSpecialAction(playerid,0);
	RemovePlayerAttachedObject(playerid, 8);
	SetPlayerAttachedObject(targetid, 8, 2212, 6, 0.1, 0.16, 0.1, -129, 22.0000, -25);
	format(str, sizeof(str), "* %s gives the food tray to %s.", GetICName(playerid), GetICName(targetid));
	SendNearByMessage(playerid, ACTION_COLOR, str, 7);
	return 1;
}*/

COMMAND:useticket(playerid)
{
	if(PlayerStat[playerid][AdminPrisoned] >= 1 || PlayerStat[playerid][Logged] == 0 || PlayerStat[playerid][Spawned] == 0) return SendClientMessage(playerid, GREY, "You can't use this command right now.");
	ShowPlayerDialog(playerid, DIALOG_TICKET, DIALOG_STYLE_INPUT, "Use A Ticket", "If you have been given a ticket code please type it in here.", "Enter", "Cancel");
	return 1;
}

COMMAND:fightstyle(playerid)
{
    if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
    if(PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You are cuffed or being dragged.");
	if(IsPlayerInRangeOfPoint(playerid, 2, 442.3324,1544.3494,1001.0271))
	{
		new Float:RadioX, Float:RadioY, Float:RadioZ;
		GetPlayerPos(playerid, RadioX, RadioY, RadioZ);
		if(PlayerStat[playerid][DonLV] == 3)
		{
			ShowPlayerDialog(playerid, DIALOG_GYM, DIALOG_STYLE_LIST, "Fighting Styles", "Regular Fighting 50$\nBoxing 200$\nKung-Fu 200$\nKnee-Head 350$\nGrab-Kick 350$\nElbow 350$", "Select", "Quit");
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_GYM, DIALOG_STYLE_LIST, "Fighting Styles", "Regular Fighting 100$\nBoxing 400$\nKung-Fu 400$\nKnee-Head 700$\nGrab-Kick 700$\nElbow 700$", "Select", "Quit");
		}
		PlayNearBySound(playerid, 4800, RadioX, RadioY, RadioZ, 10);
		
	}
	else return SendClientMessage(playerid, GREY, "You are not at the prison gym.");
	return 1;
}

COMMAND:buy(playerid, params[])
{
    if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
    if(PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You are cuffed or being dragged.");
	if(IsPlayerInRangeOfPoint(playerid, 2, 416.2987, 1637.5026, 1001.3114))
	{
		ShowPlayerDialog(playerid, DIALOG_STORE, DIALOG_STYLE_LIST, "Prison Store", "Sandwich 5$\nSprunk 3$\nLighter 10$\nIN4LIFE Cigarettes Pack 25$\nZigZag Rolling Papers [SINGLE] 5$\nZigZag Rolling Papers [5 PACK] 20$\nPlastic Bag 2$\nPlastic Bags [5 PACK] 10$\nDice 2$", "Select", "Quit");
	}
	else return SendClientMessage(playerid, GREY, "You are not at the prison 24/7 store.");
    return 1;
}

//-----------------------------------------------------------------------[Chat and RP Commands]------------------------------------------------------------------------------

COMMAND:me(playerid, params[])
{
	new message[128], str[128];
    if(sscanf(params,"s[128]", message))return SendClientMessage(playerid, GREY, "USAGE: /me [action]");
	format(str, sizeof(str), "* %s %s", GetICName(playerid), message);
    SendNearByMessage(playerid, ACTION_COLOR, str, 12);
    ICLog(str);
    return 1;
}

COMMAND:c(playerid, params[])
{
	new text[128], str[128];
    if(sscanf(params,"s[128]", text))return SendClientMessage(playerid, GREY, "USAGE: /c{hat} [text]");
	format(str, sizeof(str), "%s says : %s", GetICName(playerid), text);
	SendNearByChatMessage(playerid, str);
    ICLog(str);
    return 1;
}

COMMAND:do(playerid, params[])
{
	new message[128], str[128];
    if(sscanf(params,"s[128]", message))return SendClientMessage(playerid, GREY, "USAGE: /do [action]");
	format(str, sizeof(str), "* %s ((%s))",message, GetICName(playerid));
    SendNearByMessage(playerid, ACTION_COLOR, str, 12);
    ICLog(str);
    return 1;
}

COMMAND:o(playerid, params[])
{
	new message[250], str[180];
    if(sscanf(params,"s[128]", message))return SendClientMessage(playerid, GREY, "USAGE: /o{oc} [message]");
    if(PlayerStat[playerid][TogOOC] == 1) return SendClientMessage(playerid, GREY, "You disabled OOC chat so you can't send this message.");
    if(ServerStat[OOCStatus] == 0 && PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, GREY, "OOC chat is disabled by an admin.");
    for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i) && PlayerStat[i][TogOOC] == 0)
		{
		    if(PlayerStat[playerid][Aname] == 0)
			{
				format(str, sizeof(str), "(({0080FF}[GLOBAL OOC]{FFFFFF} %s (ID: %d): %s ))", GetOOCName(playerid), playerid, message);
				SendClientMessage(i,WHITE, str);
				format(str, sizeof(str), "(([GLOBAL OOC] %s (ID: %d): %s ))", GetOOCName(playerid), playerid, message);
				OOCLog(str);
			}
			else if(PlayerStat[playerid][Aname] >= 1 && HiddenAdmin[playerid] == 0)
			{
				format(str, sizeof(str), "(({0080FF}[GLOBAL OOC]{FFFFFF} %s: %s ))", GetForumNameNC(playerid), message);
				SendClientMessage(i,WHITE, str);
				format(str, sizeof(str), "(([GLOBAL OOC] %s: %s ))", GetForumNameNC(playerid), message);
				OOCLog(str);
			}
			else if(PlayerStat[playerid][Aname] >= 1 && HiddenAdmin[playerid] == 1)
			{
				format(str, sizeof(str), "(({0080FF}[GLOBAL OOC]{FFFFFF} Hidden: %s ))", message);
				SendClientMessage(i,WHITE, str);
				format(str, sizeof(str), "(([GLOBAL OOC] %s: %s ))", GetForumNameNC(playerid), message);
				OOCLog(str);
			}
		}
	}
    return 1;
}

COMMAND:ooc(playerid, params[])
{
	new message[250], str[180];
    if(sscanf(params,"s[128]", message))return SendClientMessage(playerid, GREY, "USAGE: /ooc [message]");
    if(PlayerStat[playerid][TogOOC] == 1) return SendClientMessage(playerid, GREY, "You disabled OOC chat so you can't send this message.");
    if(ServerStat[OOCStatus] == 0 && PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, GREY, "OOC chat is disabled by an admin.");
    for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i) && PlayerStat[i][TogOOC] == 0)
		{
		    if(PlayerStat[playerid][Aname] == 0)
			{
				format(str, sizeof(str), "(({0080FF}[GLOBAL OOC]{FFFFFF} %s (ID: %d): %s ))", GetOOCName(playerid), playerid, message);
				SendClientMessage(i,WHITE, str);
				format(str, sizeof(str), "(([GLOBAL OOC] %s (ID: %d): %s ))", GetOOCName(playerid), playerid, message);
				OOCLog(str);
			}
			else if(PlayerStat[playerid][Aname] >= 1 && HiddenAdmin[playerid] == 0)
			{
				format(str, sizeof(str), "(({0080FF}[GLOBAL OOC]{FFFFFF} %s: %s ))", GetForumNameNC(playerid), message);
				SendClientMessage(i,WHITE, str);
				format(str, sizeof(str), "(([GLOBAL OOC] %s: %s ))", GetForumNameNC(playerid), message);
				OOCLog(str);
			}
			else if(PlayerStat[playerid][Aname] >= 1 && HiddenAdmin[playerid] == 1)
			{
				format(str, sizeof(str), "(({0080FF}[GLOBAL OOC]{FFFFFF} Hidden: %s ))", message);
				SendClientMessage(i,WHITE, str);
				format(str, sizeof(str), "(([GLOBAL OOC] %s: %s ))", GetForumNameNC(playerid), message);
				OOCLog(str);
			}
		}
	}
    return 1;
}

COMMAND:b(playerid, params[])
{
	new message[128], str[128];
    if(sscanf(params,"s[128]", message))return SendClientMessage(playerid, GREY, "USAGE: /b [message]");
	if(PlayerStat[playerid][ADuty] == 1 && PlayerStat[playerid][AdminLevel] >= 1)
	{
		if(HiddenAdmin[playerid] == 1)
		{
			format(str, sizeof(str), "{FF6600}(([666]Hidden_Admin: {FF1919}%s {FF6600}))", message);
			SendNearByMessage(playerid,  WHITE, str, 12);
			format(str, sizeof(str), "(([%s as hidden]Hidden_Admin: %s ))", GetForumNameNC(playerid), message);
			OOCLog(str);	
			return 1;
		}
		if(PlayerStat[playerid][AdminLevel] >= 4)
		{
			format(str, sizeof(str), "(([%d]%s: %s ))", playerid, GetForumNameNC(playerid), message);
			SendNearByMessage(playerid, OWNER_RED, str, 12);
			OOCLog(str);	
			return 1;
		}
		format(str, sizeof(str), "(([%d]%s: %s ))", playerid, GetForumNameNC(playerid), message);
		SendNearByMessage(playerid, GREEN, str, 12);
		OOCLog(str);	
		return 1;
	}
	format(str, sizeof(str), "(([%d]%s: %s ))", playerid, GetICName(playerid), message);
    SendNearByMessage(playerid, GREY, str, 10);
    OOCLog(str);
    return 1;
}

COMMAND:low(playerid, params[])
{
	if(PlayerStat[playerid][BleedingToDeath] >= 1) goto low_cmd;
    if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
	low_cmd:
	new message[128], str[128];
    if(sscanf(params,"s[128]", message))return SendClientMessage(playerid, GREY, "USAGE: /l{ow} [message]");
    if(strlen(message) < 1) return SendClientMessage(playerid, GREY, "Message is too short.");
    if(strlen(message) > 100) return SendClientMessage(playerid, GREY, "Message is too long.");
	format(str, sizeof(str), "[LOW]%s says : %s", GetICName(playerid),  message);
    SendNearByMessage(playerid, GREY, str, 5);
    ICLog(str);
    return 1;
}

COMMAND:l(playerid, params[])
{
    if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
	new message[128], str[128];
    if(sscanf(params,"s[128]", message))return SendClientMessage(playerid, GREY, "USAGE: /l{ow} [message]");
    if(strlen(message) < 1) return SendClientMessage(playerid, GREY, "Message is too short.");
    if(strlen(message) > 100) return SendClientMessage(playerid, GREY, "Message is too long.");
	format(str, sizeof(str), "[LOW]%s says : %s", GetICName(playerid),  message);
    SendNearByMessage(playerid, GREY, str, 5);
    ICLog(str);
    return 1;
}

COMMAND:s(playerid, params[])
{
    if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
	new message[128], str[128];
    if(sscanf(params,"s[128]", message))return SendClientMessage(playerid, GREY, "USAGE: /s{hout} [message]");
    if(strlen(message) < 1) return SendClientMessage(playerid, GREY, "Message is too short.");
    if(strlen(message) > 100) return SendClientMessage(playerid, GREY, "Message is too long.");
	format(str, sizeof(str), "%s shouts : %s!", GetICName(playerid), message);
    SendNearByMessage(playerid, WHITE, str, 16);
    ICLog(str);
    return 1;
}

COMMAND:shout(playerid, params[])
{
    if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
	new message[128], str[128];
    if(sscanf(params,"s[128]", message))return SendClientMessage(playerid, GREY, "USAGE: /s{hout} [message]");
    if(strlen(message) < 1) return SendClientMessage(playerid, GREY, "Message is too short.");
    if(strlen(message) > 100) return SendClientMessage(playerid, GREY, "Message is too long.");
	format(str, sizeof(str), "%s shouts : %s!", GetICName(playerid), message);
    SendNearByMessage(playerid, WHITE, str, 16);
    ICLog(str);
	ApplyAnimation(playerid, "RIOT", "RIOT_shout", 4.1, 0, 0, 0, 0, 0);
    return 1;
}

COMMAND:w(playerid, params[])
{
    if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
	new targetid, message[128], str[200];
    if(sscanf(params,"us[128]", targetid, message))return SendClientMessage(playerid, GREY, "USAGE: /w{hisper} [playerid] [message]");
    if(targetid == playerid) return SendClientMessage(playerid, GREY, "You can't send a whisper to yourself.");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
    if(!IsPlayerInRangeOfPlayer(3, playerid, targetid)) return SendClientMessage(playerid, GREY, "Target ID is too far away.");
    if(strlen(message) < 1) return SendClientMessage(playerid, GREY, "Message is too short.");
    if(strlen(message) > 100) return SendClientMessage(playerid, GREY, "Message is too long.");
	format(str, sizeof(str), "%s whispers to you: %s", GetICName(playerid), message);
    SendClientMessage(targetid, YELLOW, str);
	format(str, sizeof(str), "%s whispers to %s: %s", GetICName(playerid), GetICName(targetid), message);
	ICLog(str);
    format(str, sizeof(str), "you whispered to %s: %s", GetICName(targetid), message);
    SendClientMessage(playerid, YELLOW, str);
    format(str, sizeof(str), "* %s whispers something to %s.",GetICName(playerid), GetICName(targetid));
    SetPlayerChatBubble(playerid, str, ACTION_COLOR, 15, 10000);
    return 1;
}

COMMAND:whisper(playerid, params[])
{
    if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
	new targetid, message[128], str[200];
    if(sscanf(params,"us[128]", targetid, message))return SendClientMessage(playerid, GREY, "USAGE: /w{hisper} [playerid] [message]");
    if(targetid == playerid) return SendClientMessage(playerid, GREY, "You can't send a whisper to yourself.");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
    if(!IsPlayerInRangeOfPlayer(3, playerid, targetid)) return SendClientMessage(playerid, GREY, "Target ID is too far away.");
    if(strlen(message) < 1) return SendClientMessage(playerid, GREY, "Message is too short.");
    if(strlen(message) > 100) return SendClientMessage(playerid, GREY, "Message is too long.");
	format(str, sizeof(str), "%s whispers to you: %s", GetICName(playerid), message);
    SendClientMessage(targetid, YELLOW, str);
	format(str, sizeof(str), "%s whispers to %s: %s", GetICName(playerid), GetICName(targetid), message);
	ICLog(str);
    format(str, sizeof(str), "you whispered to %s: %s", GetICName(targetid), message);
    SendClientMessage(playerid, YELLOW, str);
    format(str, sizeof(str), "* %s whispers something to %s.",GetICName(playerid), GetICName(targetid));
    SetPlayerChatBubble(playerid, str, ACTION_COLOR, 15, 10000);
    return 1;
}

COMMAND:pm(playerid, params[])
{
	new targetid, message[128], str[128], i;
	i = 0;
    if(sscanf(params,"us[128]", targetid, message))return SendClientMessage(playerid, GREY, "USAGE: /pm [playerid] [message]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
    if(targetid == playerid) return SendClientMessage(playerid, GREY, "You can't send a PM to yourself.");
    if(PlayerStat[playerid][TogPM] == 1) return SendClientMessage(playerid, GREY, "You have disabled PMs (/togpm to enable them).");
    if(PlayerStat[playerid][AdminLevel] < 1 && PlayerStat[targetid][TogPM] == 1) return SendClientMessage(playerid, GREY, "The player has disabled PMs.");
	if(PlayerStat[playerid][AdminLevel] < 1 && AutoPM[targetid][0] != 0)
	{
		format(str, sizeof(str), "(([%d]AutoPM from %s: %s))", targetid, GetOOCName(targetid), AutoPM[targetid]);
		SendClientMessage(playerid, YELLOW, str);
		return 1;
	}
    if(Server[PMsStatus] == 0) return SendClientMessage(playerid, GREY, "PMs are disabled by an admin.");
    if(strlen(message) < 1) return SendClientMessage(playerid, GREY, "Message is too short.");
    if(strlen(message) > 100) return SendClientMessage(playerid, GREY, "Message is too long.");
	format(str, sizeof(str), "(([%d]PM from %s: %s))", playerid, GetOOCName(playerid), message);
    SendClientMessage(targetid, YELLOW, str);
	if(PMsTracked[targetid] == 1)
	{
		loop_start1:
		if(IsPlayerConnected(i) == 1)
		{
			if(i > MAX_PLAYERS)
			{
				goto script_continue;
			}
			if(TrackPMs[i] == targetid)
			{
				format(str, sizeof(str), "((PM from %s to %s: %s))", GetOOCName(playerid), GetOOCName(targetid), message);
				SendClientMessage(i, YELLOW, str);
				PlayerPlaySound(i, 1085, 0, 0 ,0);
				i++;
				goto loop_start1;
			}
			else
			{
				i++;
				goto loop_start1;
			}
		}
		else
		{
			i++;
			goto loop_start1;
		}
	}
	if(PMsTracked[playerid] == 1)
	{
		loop_start2:
		if(IsPlayerConnected(i) == 1)
		{
			if(i > MAX_PLAYERS)
			{
				goto script_continue;
			}
			if(TrackPMs[i] == playerid)
			{
				format(str, sizeof(str), "((PM from %s to %s: %s))", GetOOCName(playerid), GetOOCName(targetid), message);
				SendClientMessage(i, YELLOW, str);
				PlayerPlaySound(i, 1085, 0, 0 ,0);
				i++;
				goto loop_start2;
			}
			else
			{
				i++;
				goto loop_start2;
			}
		}
		else
		{
			i++;
			goto loop_start2;
		}
	}
	script_continue:
	PlayerPlaySound(targetid, 1085, 0, 0 ,0);
	format(str, sizeof(str), "(([%d]PM to %s: %s))", targetid, GetOOCName(targetid), message);
	PlayerPlaySound(playerid, 1137, 0, 0 ,0);
    SendClientMessage(playerid, YELLOW, str);
	format(str, sizeof(str), "%s PM'd %s: %s", GetOOCName(playerid), GetOOCName(targetid), message);
    PMLog(str);
    return 1;
}

COMMAND:ame(playerid, params[])
{
	new message[128], str[128];
    if(sscanf(params,"s[128]", message))return SendClientMessage(playerid, GREY, "USAGE: /a{bove}me [action]");
	format(str, sizeof(str), "* %s %s", GetICName(playerid), message);
    SetPlayerChatBubble(playerid, str, ACTION_COLOR, 15, 10000);
	format(str, sizeof(str), "> %s", message);
	SendClientMessage(playerid, ACTION_COLOR, str);
	format(str, sizeof(str), "* %s %s", GetICName(playerid), message);
    ICLog(str);
    return 1;
}

COMMAND:togooc(playerid, params[])
{
	if(PlayerStat[playerid][TogOOC] == 0)
	{
        SendClientMessage(playerid, GREY, "You have disabled OOC chat.");
        PlayerStat[playerid][TogOOC] = 1;
	}
    else
	{
        SendClientMessage(playerid, GREY, "You have enabled OOC chat.");
		PlayerStat[playerid][TogOOC] = 0;
	}
    return 1;
}

COMMAND:togpm(playerid, params[])
{
	if(PlayerStat[playerid][DonLV] < 1) return SendClientMessage(playerid, GREY, "You need to be a bronze donator in order to use /togpm");
	if(PlayerStat[playerid][TogPM] == 0)
	{
        SendClientMessage(playerid, GREY, "You have disabled PMs.");
        PlayerStat[playerid][TogPM] = 1;
	}
    else
	{
        SendClientMessage(playerid, GREY, "You have enabled PMs.");
		PlayerStat[playerid][TogPM] = 0;
	}
    return 1;
}

COMMAND:autopm(playerid, params[])
{
	if(PlayerStat[playerid][DonLV] < 2) return SendClientMessage(playerid, GREY, "You need to be a silver donator in order to use /autopm");
	new str[128], message[128];
	if(sscanf(params,"s[128]", message))return SendClientMessage(playerid, GREY, "USAGE: /autopm [message]");
	format(str, sizeof(str), "%s", message);
	AutoPM[playerid] = str;
	SendClientMessage(playerid, CMD_COLOR, "You have set an auto PM.");
    return 1;
}

COMMAND:autopmoff(playerid, params[])
{
	if(PlayerStat[playerid][DonLV] < 2) return SendClientMessage(playerid, GREY, "You need to be a silver donator in order to use /autopm");
	AutoPM[playerid][0] = 0;
	SendClientMessage(playerid, WHITE, "You no longer send automatic PM's.");
    return 1;
}

COMMAND:mask(playerid)
{
	if(PlayerStat[playerid][DonLV] < 2) return SendClientMessage(playerid, GREY, "You need to be a SILVER donor to use this command.");
	new i;
	if(Masked[playerid] == 0)
	{
		new string[27], Float:Xpos, Float:Ypos, Float:Zpos, str[27], stringush[128];
		GetPlayerPos(playerid, Xpos, Ypos, Zpos);
        GetPlayerName(playerid, string, sizeof(string));
        strmid(UnmaskedName[playerid], string, 0, strlen(string), 64);
		new Digits = random(9999);
		MaskName[playerid] = Digits;
		format(stringush, sizeof(stringush), "%s is now known as Masked %d.", GetOOCName(playerid), Digits);
		MaskNameLog(stringush);
		format(string, sizeof(string), "Masked %d", Digits);
		strmid(MaskedName[playerid], string, 0, strlen(string), 64);
		MaskID[playerid] = Create3DTextLabel(string, 0xFFFFFFFF, Xpos, Ypos, Zpos + 1.34, 20.0, 0);
		Attach3DTextLabelToPlayer(MaskID[playerid], playerid, 0.0, 0.0, 0.14);
		PlayerMask(playerid, 1);
		Masked[playerid] = 1;
		SendClientMessage(playerid, CMD_COLOR, "[CMD] You have placed your mask on.");
		i = 0;
		create_mask:
		if(i > MAX_PLAYERS) return 1;
		if(IsPlayerConnected(i) && PlayerStat[i][ADuty] == 1)
		{
			MaskRealName[playerid] = CreatePlayer3DTextLabel(i, str, LIGHT_RED, 0, 0, 0.17, 25, playerid);
			i++;
			goto create_mask;
		}
		else
		{
			i++;
			goto create_mask;
		}
		return 1;
	}
	else
	{
		SetPlayerName(playerid, UnmaskedName[playerid]);
		SendClientMessage(playerid, CMD_COLOR, "[CMD] You have taken your mask off.");
		Delete3DTextLabel(MaskID[playerid]);
		PlayerMask(playerid, 0);
		MaskName[playerid] = 0;
		Masked[playerid] = 0;
		i = 0;
		delete_mask:
		if(i > MAX_PLAYERS) return 1;
		if(IsPlayerConnected(i) && PlayerStat[i][ADuty] == 1)
		{
			DeletePlayer3DTextLabel(i, MaskRealName[playerid]);
			i++;
			goto delete_mask;
		}
		else
		{
			i++;
			goto delete_mask;
		}
		return 1;
	}
}

//-----------------------------------------------------------------------[Helper Commands]------------------------------------------------------------------------------


COMMAND:helpme(playerid, params[])
{
	new message[128], str[128];
	if(PlayerStat[playerid][hMuted] == 1) return SendClientMessage(playerid, GREY, "You are muted from sending help requests.");
    if(sscanf(params,"s[128]", message))return SendClientMessage(playerid, GREY, "USAGE: /helpme [message]");
    if(PlayerStat[playerid][HelpmeReloadTime] > 1) return SendClientMessage(playerid, GREY, "You must wait 60 seconds before sending another help request.");
	format(str, sizeof(str), "[HELPME] %s (ID: %d): {FFFFFF}%s", GetOOCName(playerid), playerid, message);
	SendHelpMeMessage(GREEN, str);
	format(str, sizeof(str), "[HELPME] Type /accepthelpme (/ahm) %d to accept it.", playerid);
	SendHelpMeMessage(GREEN, str);
	AwaitingHelper[playerid] = 1;
	format(str, sizeof(str), "[HELPME] %s: %s", GetOOCName(playerid), message);
	HelpmeLog(str);
	SendClientMessage(playerid, LIGHT_GREEN, "You have successfully sent a help request, please be patient.");
	PlayerStat[playerid][HelpmeReloadTime] = 60;
    return 1;
}


COMMAND:hc(playerid, params[])
{
	new message[128], str[128];
	if(PlayerStat[playerid][HelperLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
    if(sscanf(params,"s[128]", message))return SendClientMessage(playerid, GREY, "USAGE: /h{elper}c{hat} [message]");
    for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i) && PlayerStat[i][HelperLevel] >= 1)
		{
		    format(str, sizeof(str), "(( Level %d Helper %s: %s ))", PlayerStat[playerid][HelperLevel], GetOOCName(playerid), message);
		    SendClientMessage(i, GREEN, str);
		}
	}
    return 1;
}

COMMAND:helperchat(playerid, params[])
{
	new message[128], str[128];
	if(PlayerStat[playerid][HelperLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
    if(sscanf(params,"s[128]", message))return SendClientMessage(playerid, GREY, "USAGE: /h{elper}c{hat} [message]");
    for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i) && PlayerStat[i][HelperLevel] >= 1)
		{
		    format(str, sizeof(str), "(( Level %d Helper %s: %s ))", PlayerStat[playerid][HelperLevel], GetOOCName(playerid), message);
		    SendClientMessage(i, GREEN, str);
		}
	}
    return 1;
}

COMMAND:fixplayer(playerid, params[])
{
	new targetid, str[128];
	if(PlayerStat[playerid][HelperLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
    if(sscanf(params,"u", targetid))return SendClientMessage(playerid, GREY, "USAGE: /fixplayer [playerid]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
    SetPlayerInterior(targetid, 0);
    SetPlayerVirtualWorld(targetid, 0);
    format(str, sizeof(str), "Helper %s has changed your interior to 0 and your virtual world to 0 and fixed your variables.", GetOOCName(playerid));
    SendClientMessage(targetid, GREEN, str);
    format(str, sizeof(str), "You have successfully changed %s's interior and virtual world to 0 and fixed his variables.", GetOOCName(targetid));
    SendClientMessage(playerid, GREEN, str);
	PlayerStat[targetid][JobID4BOX] = 0;
	HoldingObject[targetid] = 0;
	HoldingTray[targetid] = 0;
	SetPlayerSpecialAction(targetid,SPECIAL_ACTION_NONE);
	ClearAnimations(targetid);
	for(new i=0; i<MAX_ATTACHED_OBJECTS; i++)
	if(IsPlayerAttachedObjectSlotUsed(targetid, i)) RemovePlayerAttachedObject(targetid, i);
    return 1;
}

COMMAND:hpm(playerid, params[])
{
	new targetid, message[128], str[128], i;
	i = 0;
	if(PlayerStat[playerid][HelperLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
    if(sscanf(params,"us[128]", targetid, message))return SendClientMessage(playerid, GREY, "USAGE: /h{elper}p{riavte}m{essage} [playerid] [message]");
    if(targetid == playerid) return SendClientMessage(playerid, GREY, "You can't send a helper message to yourself.");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
    if(strlen(message) < 1) return SendClientMessage(playerid, GREY, "Message is too short.");
    if(strlen(message) > 100) return SendClientMessage(playerid, GREY, "Message is too long.");
    format(str, sizeof(str), "(([HELPER MESSAGE]%s: %s))", GetForumName(playerid), message);
    SendClientMessage(targetid, GREEN, str);
	format(str, sizeof(str), "(([HELPER MESSAGE]Sent to %s: %s))", GetOOCName(targetid), message);
    SendClientMessage(playerid, GREEN, str);
	format(str, sizeof(str), "%s HPM'd %s: %s", GetOOCName(playerid), GetOOCName(targetid), message);
    PMLog(str);
	if(PMsTracked[targetid] == 1)
	{
		loop_start1:
		if(IsPlayerConnected(i) == 1)
		{
			if(i > MAX_PLAYERS)
			{
				goto loop_stop;
			}
			if(TrackPMs[i] == targetid)
			{
				format(str, sizeof(str), "((HPM from %s to %s: %s))", GetOOCName(playerid), GetOOCName(targetid), message);
				SendClientMessage(i, YELLOW, str);
				PlayerPlaySound(i, 1085, 0, 0 ,0);
				i++;
				goto loop_start1;
			}
			else
			{
				i++;
				goto loop_start1;
			}
		}
		else
		{
			i++;
			goto loop_start1;
		}
	}
	if(PMsTracked[playerid] == 1)
	{
		loop_start2:
		if(IsPlayerConnected(i) == 1)
		{
			if(i > MAX_PLAYERS)
			{
				goto loop_stop;
			}
			if(TrackPMs[i] == playerid)
			{
				format(str, sizeof(str), "((HPM from %s to %s: %s))", GetOOCName(playerid), GetOOCName(targetid), message);
				SendClientMessage(i, YELLOW, str);
				PlayerPlaySound(i, 1085, 0, 0 ,0);
				i++;
				goto loop_start2;
			}
			else
			{
				i++;
				goto loop_start2;
			}
		}
		else
		{
			i++;
			goto loop_start2;
		}
	}
	loop_stop:
    return 1;
}

COMMAND:helperprivatemessage(playerid, params[])
{
	new targetid, message[128], str[128];
	if(PlayerStat[playerid][HelperLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
    if(sscanf(params,"us[128]", targetid, message))return SendClientMessage(playerid, GREY, "USAGE: /helperprivatemessage [playerid] [message]");
    if(targetid == playerid) return SendClientMessage(playerid, GREY, "You can't send a helper message to yourself.");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
    if(strlen(message) < 1) return SendClientMessage(playerid, GREY, "Message is too short.");
    if(strlen(message) > 100) return SendClientMessage(playerid, GREY, "Message is too long.");
    format(str, sizeof(str), "[HELPER MESSAGE]%s: %s", GetForumName(playerid), message);
    SendClientMessage(targetid, GREEN, str);
	format(str, sizeof(str), "[HELPER MESSAGE]Sent to %s: %s", GetOOCName(targetid), message);
    SendClientMessage(playerid, GREEN, str);
    return 1;
}

COMMAND:accepthelpme(playerid, params[])
{
	new targetid, str[128];
	if(PlayerStat[playerid][AdminLevel] >= 1) goto Admin_Accepting_Helpme;
	if(PlayerStat[playerid][HelperLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command");
	else if(PlayerStat[playerid][HelperLevel] > 1)
	{
		if(sscanf(params,"u", targetid))return SendClientMessage(playerid, GREY, "USAGE: /accepthelpme [playerid]");
		if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
		if(AwaitingHelper[targetid] == 0) return SendClientMessage(playerid, CMD_COLOR, "This player didn't request help.");
		AwaitingHelper[targetid] = 0;
		format(str, sizeof(str), "[HELPME] Helper %s has accepted %s help me.", GetForumNameNC(playerid), GetOOCName(targetid)); 
		SendHelperMessage(GREEN, str);
		SendClientMessage(playerid, CMD_COLOR, "Use /hpm to Helper Message the user.");
		PlayerStat[playerid][HelpmesAnswered]++;
		format(str, sizeof(str), "Helper %s has accepted your previous helpme.", GetForumNameNC(playerid));
		SendClientMessage(targetid, LIGHT_GREEN, str);
		return 1;
	}
	Admin_Accepting_Helpme:
	if(sscanf(params,"u", targetid))return SendClientMessage(playerid, GREY, "USAGE: /accepthelpme [playerid]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(AwaitingHelper[targetid] == 0) return SendClientMessage(playerid, CMD_COLOR, "This player didn't request help.");
	AwaitingHelper[targetid] = 0;
	format(str, sizeof(str), "[HELPME] Admin %s has accepted %s help me.", GetForumNameNC(playerid), GetOOCName(targetid)); 
	SendAdminMessage(GREEN, str);
	SendClientMessage(playerid, CMD_COLOR, "Use /hpm to Helper Message the user or /apm to Admin Message the user.");
	PlayerStat[playerid][HelpmesAnswered]++;
	format(str, sizeof(str), "Admin %s has accepted your previous helpme.", GetForumNameNC(playerid));
	SendClientMessage(targetid, LIGHT_GREEN, str);
	return 1;
}

COMMAND:answerapp(playerid, params[])
{
	new targetid, str[128], status[10];
	if(PlayerStat[playerid][HelperLevel] >= 1) goto Helper;
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command");
	Helper:
	if(sscanf(params,"us[8]", targetid, status))
	{
		SendClientMessage(playerid, GREY, "USAGE: /answerapp [playerid] [accept/deny/stop]");
	    return 1;
	}
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(PNewReg[targetid] == 0 && NewRegAwaiting[targetid] == 0) return SendClientMessage(playerid, CMD_COLOR, "This player didn't post an application.");
	if(NewRegAwaiting[targetid] == 0) return SendClientMessage(playerid, CMD_COLOR, "This player didn't post an application.");
	if(ApplicationsAllowed == 0) return SendClientMessage(playerid, CMD_COLOR, "Applications are currently closed and cannot be accepted/denied.");
    else if(!strcmp(status, "accept", true) && ApplicationsAllowed == 1)
	{
		INI_Open(Accounts(targetid));
        INI_WriteInt("FullyRegistered", 1); 
		INI_WriteInt("LastSkin", GetPlayerSkin(targetid));
		INI_Save();
		INI_Close();
		NewRegAwaiting[targetid] = 0;
		NewRegQuestion[targetid] = 0;
		PNewReg[targetid] = 2;
		LoadPlayerData(targetid);
		PlayerStat[targetid][FullyRegistered] = 1;
		SavePlayerData(targetid);
		format(str, sizeof(str), "You have accepted %s application.", GetOOCName(targetid));
		SendClientMessage(playerid, CMD_COLOR, str);
		SendClientMessage(targetid, CMD_COLOR, "Your application has been ACCEPTED, welcome to the server.");
		AwaitingApplications -= 1;
		format(str, sizeof(str), "[APPLICATIONS] %s %s has accepted %s into the server.", Getalvl(playerid), GetForumNameNC(playerid), GetOOCName(targetid));
		SendAdminMessage(RED, str);
	}
    else if(!strcmp(status, "deny", true) && ApplicationsAllowed == 1)
	{
		format(str, sizeof(str), "You have declined %s application.", GetOOCName(targetid));
		SendClientMessage(playerid, CMD_COLOR, str);
		format(str, sizeof(str), "[APPLICATIONS] %s %s has declined %s application.", Getalvl(playerid), GetForumNameNC(playerid), GetOOCName(targetid));
		SendAdminMessage(RED, str);
		SendClientMessage(targetid, CMD_COLOR, "Your application has been DECLINED. Please take a second look at the rules on www.hd-rp.net.");
		SetTimerEx("KickPlayer", 1000, false, "i", targetid);
		AwaitingApplications -= 1;
	}
    else if(!strcmp(status, "stop", true) && ApplicationsAllowed == 1)
	{
		format(str, sizeof(str), "You stopped viewing %s application.", GetOOCName(targetid));
		SendClientMessage(playerid, CMD_COLOR, str);
		format(str, sizeof(str), "[APPLICATIONS] %s %s has stopped viewing %s application.", Getalvl(playerid), GetForumNameNC(playerid), GetOOCName(targetid));
		SendAdminMessage(RED, str);
	}
	return 1;
}

COMMAND:checkapps(playerid, params[])
{
	new str[128];
	if(PlayerStat[playerid][HelperLevel] >= 1) goto Helper;
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command");
	Helper:
	if(AwaitingApplications == 0) return SendClientMessage(playerid, CMD_COLOR, "There is no awaiting applications.");
	new i, d;
	i = 0;
	d = 0;
	SendClientMessage(playerid, GREEN, "_________________________________________________________________________");
	loop_start:
	if(IsPlayerConnected(i) == 1)
	{
		if(i >= 101)
		{
			goto end_loop;
		}
		if(PNewReg[i] == 1 && NewRegAwaiting[i] == 1)
		{
			format(str, sizeof(str), "Awaiting application by: %s, [ID: %d].", GetOOCName(i), i);
			SendClientMessage(playerid, WHITE, str);
			i++;
			d++;
			goto loop_start;
		}
		else
		{
			i++;
			if(i > 100)
			{
				goto end_loop;
			}
			else
			{
				goto loop_start;
			}
		}	
	}
	else
	{
		i++;
		if(i > 100)
		{
			goto end_loop;
		}
		else
		{
			goto loop_start;
		}
	}
	end_loop:
	if(d == 0)
	{
		SendClientMessage(playerid, CMD_COLOR, "There is no awaiting applications.");
	}
	SendClientMessage(playerid, GREEN, "_________________________________________________________________________");
	SendClientMessage(playerid, CMD_COLOR, "Please review those applications by writing /reviewapp [id].");
	return 1;
}

COMMAND:checkapplications(playerid, params[])
{
	new str[128];
	if(PlayerStat[playerid][HelperLevel] >= 1) goto Helper;
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command");
	Helper:
	if(AwaitingApplications == 0) return SendClientMessage(playerid, CMD_COLOR, "There is no awaiting applications.");
	new i, d;
	i = 0;
	d = 0;
	SendClientMessage(playerid, GREEN, "_________________________________________________________________________");
	loop_start:
	if(IsPlayerConnected(i) == 1)
	{
		if(i >= 101)
		{
			goto end_loop;
		}
		if(PNewReg[i] == 1 && NewRegAwaiting[i] == 1)
		{
			format(str, sizeof(str), "Awaiting application by: %s, [ID: %d].", GetOOCName(i), i);
			SendClientMessage(playerid, WHITE, str);
			i++;
			d++;
			goto loop_start;
		}
		else
		{
			i++;
			if(i > 100)
			{
				goto end_loop;
			}
			else
			{
				goto loop_start;
			}
		}	
	}
	else
	{
		i++;
		if(i > 100)
		{
			goto end_loop;
		}
		else
		{
			goto loop_start;
		}
	}
	end_loop:
	if(d == 0)
	{
		SendClientMessage(playerid, CMD_COLOR, "There is no awaiting applications.");
	}
	SendClientMessage(playerid, GREEN, "_________________________________________________________________________");
	SendClientMessage(playerid, CMD_COLOR, "Please review those applications by writing /reviewapp [id].");
	return 1;
}

COMMAND:reviewapp(playerid, params[])
{
	new targetid, str[128];
	if(PlayerStat[playerid][HelperLevel] >= 1) goto Helper;
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command");
	Helper:
	if(sscanf(params,"u", targetid))return SendClientMessage(playerid, GREY, "USAGE: /reviewapp [playerid]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(PNewReg[targetid] == 0 && NewRegAwaiting[targetid] == 0) return SendClientMessage(playerid, CMD_COLOR, "This player didn't post an application.");
	format(str, sizeof(str), "[APPLICATIONS] Admin %s is now reviewing %s [ID:%d] application.", GetForumNameNC(playerid), GetOOCName(targetid), targetid);
	SendAdminMessage(RED, str);
	SendClientMessage(playerid, GREEN, "_________________________________________________________________________");
	SendClientMessage(playerid, LIGHT_GREEN, "Question number 1:");
	SendClientMessage(playerid, LIGHT_BLUE, "Question: Define and explain Roleplay.");
	format(str, sizeof(str), "Answer: %s", PlayerStat[targetid][Answer1]);
	SendClientMessage(playerid, WHITE, str);
	SendClientMessage(playerid, LIGHT_GREEN, "Question number 2:");
	SendClientMessage(playerid, LIGHT_BLUE, "Question: What procedure should you take before engaging in sexually explicit content like rape?");
	format(str, sizeof(str), "Answer: %s", PlayerStat[targetid][Answer2]);
	SendClientMessage(playerid, WHITE, str);
	SendClientMessage(playerid, LIGHT_GREEN, "Question number 3:");
	SendClientMessage(playerid, LIGHT_BLUE, "Question: Explain Metagaming.");
	format(str, sizeof(str), "Answer: %s", PlayerStat[targetid][Answer3]);
	SendClientMessage(playerid, WHITE, str);
	SendClientMessage(playerid, LIGHT_GREEN, "Question number 4:");
	SendClientMessage(playerid, LIGHT_BLUE, "Question: Can you rob or scam players below 10 playing hours?");
	format(str, sizeof(str), "Answer: %s", PlayerStat[targetid][Answer4]);
	SendClientMessage(playerid, WHITE, str);
	SendClientMessage(playerid, LIGHT_GREEN, "Question number 5:");
	SendClientMessage(playerid, LIGHT_BLUE, "Question: Explain Powergaming.");
	format(str, sizeof(str), "Answer: %s", PlayerStat[targetid][Answer5]);
	SendClientMessage(playerid, WHITE, str);
	SendClientMessage(playerid, GREEN, "_________________________________________________________________________");
	format(str, sizeof(str), "Please review this application seriously and when you are finish /answerapp [%d] [accept/deny].", targetid, targetid);
	SendClientMessage(playerid, CMD_COLOR, str);
	return 1;
}

COMMAND:arp(playerid, params[])
{
	new targetid, str[128];
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command");
	if(sscanf(params,"u", targetid))return SendClientMessage(playerid, GREY, "USAGE: /arp [playerid]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(AwaitingReport[targetid] == 0) return SendClientMessage(playerid, CMD_COLOR, "This player didn't made a report.");
	AwaitingReport[targetid] = 0;
	format(str, sizeof(str), "[REPORT] Admin %s has accepted %s report.", GetForumNameNC(playerid), GetOOCName(targetid)); 
	SendAdminMessage(GREEN, str);
	SendClientMessage(playerid, CMD_COLOR, "Use /apm to Admin Message the user.");
	format(str, sizeof(str), "Admin %s has accepted your previous report.", GetForumNameNC(playerid));
	SendClientMessage(targetid, LIGHT_GREEN, str);
	return 1;
}

COMMAND:acceptreport(playerid, params[])
{
	new targetid, str[128];
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command");
	if(sscanf(params,"u", targetid))return SendClientMessage(playerid, GREY, "USAGE: /arp [playerid]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(AwaitingReport[targetid] == 0) return SendClientMessage(playerid, CMD_COLOR, "This player didn't made a report.");
	AwaitingReport[targetid] = 0;
	format(str, sizeof(str), "[REPORT] Admin %s has accepted %s report.", GetForumNameNC(playerid), GetOOCName(targetid)); 
	SendAdminMessage(GREEN, str);
	SendClientMessage(playerid, CMD_COLOR, "Use /apm to Admin Message the user.");
	format(str, sizeof(str), "Admin %s has accepted your previous report.", GetForumNameNC(playerid));
	SendClientMessage(targetid, LIGHT_GREEN, str);
	return 1;
}

COMMAND:ahm(playerid, params[])
{
	new targetid, str[128];
	if(PlayerStat[playerid][AdminLevel] >= 1) goto Admin_Accepting_Helpme;
	if(PlayerStat[playerid][HelperLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command");
	else if(PlayerStat[playerid][HelperLevel] > 1)
	{
		if(sscanf(params,"u", targetid))return SendClientMessage(playerid, GREY, "USAGE: /accepthelpme [playerid]");
		if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
		if(AwaitingHelper[targetid] == 0) return SendClientMessage(playerid, CMD_COLOR, "This player didn't request help.");
		AwaitingHelper[targetid] = 0;
		format(str, sizeof(str), "[HELPME] Helper %s has accepted %s help me.", GetForumNameNC(playerid), GetOOCName(targetid)); 
		SendHelperMessage(GREEN, str);
		SendClientMessage(playerid, CMD_COLOR, "Use /hpm to Helper Message the user.");
		PlayerStat[playerid][HelpmesAnswered]++;
		format(str, sizeof(str), "Helper %s has accepted your previous helpme.", GetForumNameNC(playerid));
		SendClientMessage(targetid, LIGHT_GREEN, str);
		return 1;
	}
	Admin_Accepting_Helpme:
	if(sscanf(params,"u", targetid))return SendClientMessage(playerid, GREY, "USAGE: /accepthelpme [playerid]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(AwaitingHelper[targetid] == 0) return SendClientMessage(playerid, CMD_COLOR, "This player didn't request help.");
	AwaitingHelper[targetid] = 0;
	format(str, sizeof(str), "[HELPME] Admin %s has accepted %s help me.", GetForumNameNC(playerid), GetOOCName(targetid)); 
	SendAdminMessage(GREEN, str);
	SendClientMessage(playerid, CMD_COLOR, "Use /hpm to Helper Message the user or /apm to Admin Message the user.");
	PlayerStat[playerid][HelpmesAnswered]++;
	format(str, sizeof(str), "Admin %s has accepted your previous helpme.", GetForumNameNC(playerid));
	SendClientMessage(targetid, LIGHT_GREEN, str);
	return 1;
}

COMMAND:acceptrequest(playerid, params[])
{
	new targetid, str[128];
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command");
	if(sscanf(params,"u", targetid))return SendClientMessage(playerid, GREY, "USAGE: /acceptrequest [playerid]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(AwaitingAdmin[targetid] == 0) return SendClientMessage(playerid, CMD_COLOR, "This player didn't request Admin help.");
	AwaitingAdmin[targetid] = 0;
	format(str, sizeof(str), "[Admin Request] Admin %s has accepted %s request.", GetForumNameNC(playerid), GetOOCName(targetid)); 
	SendHelperMessage(GREEN, str);
	SendClientMessage(playerid, CMD_COLOR, "Use /am to Admin Message the user."); 
	format(str, sizeof(str), "Admin %s has accepted the previous Admin Request by ((ID:%d | %s)).", GetForumNameNC(playerid), targetid, GetOOCName(targetid));
	SendAdminMessage(LIGHT_GREEN, str);
	format(str, sizeof(str), "Admin %s has accepted your previous Admin Request.", GetForumNameNC(playerid), targetid, GetOOCName(targetid));
	SendClientMessage(targetid, LIGHT_GREEN, str);
	return 1;
}

//-----------------------------------------------------------------------[Gangs Commands]------------------------------------------------------------------------------

COMMAND:g(playerid, params[])
{
	new message[128], str[128];
	if(PlayerStat[playerid][GangID] < 1) return SendClientMessage(playerid, GREY, "You must be in a gang to use this command.");
    if(sscanf(params,"s[128]", message))return SendClientMessage(playerid, GREY, "USAGE: /g{ang} [message]");
	switch(PlayerStat[playerid][GangRank])
	{
	    case 1:
        {
            format(str, sizeof(str), "(( %s (1) %s: %s ))", GangStat[PlayerStat[playerid][GangID]][Rank1], GetOOCName(playerid), message);
        }
        case 2:
        {
            format(str, sizeof(str), "(( %s (2) %s: %s ))", GangStat[PlayerStat[playerid][GangID]][Rank2], GetOOCName(playerid), message);
        }
        case 3:
        {
            format(str, sizeof(str), "(( %s (3) %s: %s ))", GangStat[PlayerStat[playerid][GangID]][Rank3], GetOOCName(playerid), message);
        }
        case 4:
        {
            format(str, sizeof(str), "(( %s (4) %s: %s ))", GangStat[PlayerStat[playerid][GangID]][Rank4], GetOOCName(playerid), message);
        }
        case 5:
        {
            format(str, sizeof(str), "(( %s (5) %s: %s ))", GangStat[PlayerStat[playerid][GangID]][Rank5], GetOOCName(playerid), message);
        }
        case 6:
        {
            format(str, sizeof(str), "(( %s (6) %s: %s ))", GangStat[PlayerStat[playerid][GangID]][Rank6], GetOOCName(playerid), message);
        }
	}
	SendGangMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
    return 1;
}

COMMAND:gang(playerid, params[])
{
	new message[128], str[128];
	if(PlayerStat[playerid][GangID] < 1) return SendClientMessage(playerid, GREY, "You must be in a gang to use this command.");
    if(sscanf(params,"s[128]", message))return SendClientMessage(playerid, GREY, "USAGE: /g{ang} [message]");
	switch(PlayerStat[playerid][GangRank])
	{
	    case 1:
        {
            format(str, sizeof(str), "(( %s (1) %s: %s ))", GangStat[PlayerStat[playerid][GangID]][Rank1], GetOOCName(playerid), message);
        }
        case 2:
        {
            format(str, sizeof(str), "(( %s (2) %s: %s ))", GangStat[PlayerStat[playerid][GangID]][Rank2], GetOOCName(playerid), message);
        }
        case 3:
        {
            format(str, sizeof(str), "(( %s (3) %s: %s ))", GangStat[PlayerStat[playerid][GangID]][Rank3], GetOOCName(playerid), message);
        }
        case 4:
        {
            format(str, sizeof(str), "(( %s (4) %s: %s ))", GangStat[PlayerStat[playerid][GangID]][Rank4], GetOOCName(playerid), message);
        }
        case 5:
        {
            format(str, sizeof(str), "(( %s (5) %s: %s ))", GangStat[PlayerStat[playerid][GangID]][Rank5], GetOOCName(playerid), message);
        }
        case 6:
        {
            format(str, sizeof(str), "(( %s (6) %s: %s ))", GangStat[PlayerStat[playerid][GangID]][Rank6], GetOOCName(playerid), message);
        }
	}
	SendGangMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
    return 1;
}

COMMAND:adjustgang(playerid, params[])
{
	if(PlayerStat[playerid][GangID] < 1) return SendClientMessage(playerid, GREY, "You must be in a gang to use this command.");
	if(PlayerStat[playerid][GangRank] < 5) return SendClientMessage(playerid, GREY, "You must be rank 5/6 to use this command.");
	ShowPlayerDialog(playerid, DIALOG_ADJUSTGANG, DIALOG_STYLE_LIST, "What are you going to adjust?", "Gang Name\nGang MOTD\nRank 1 name\nRank 2 name\nRank 3 name\nRank 4 name\nRank 5 name\nRank 6 name\nColor\nRank 1 Skin\nRank 2 Skin\nRank 3 Skin\nRank 4 Skin\nRank 5 Skin\nRank 6 Skin\nFemale Skin", "Select", "Quit");
    return 1;
}

COMMAND:giverank(playerid, params[])
{
	new targetid, rank, str[128];
	if(PlayerStat[playerid][GangID] < 1) return SendClientMessage(playerid, GREY, "You must be in a gang to use this command.");
	if(PlayerStat[playerid][GangRank] < 5) return SendClientMessage(playerid, GREY, "You must be rank 5/6 to use this command.");
    if(sscanf(params,"ud", targetid, rank))return SendClientMessage(playerid, GREY, "USAGE: /giverank [playerid] [rank]");
    if(playerid == targetid) return SendClientMessage(playerid, GREY, "You can't change your rank.");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
    if(PlayerStat[playerid][GangID] != PlayerStat[targetid][GangID]) return SendClientMessage(playerid, GREY, "Target ID isn't in your gang.");
    if(PlayerStat[playerid][GangRank] <= PlayerStat[targetid][GangRank]) return SendClientMessage(playerid, GREY, "Target ID has same or higher rank.");
    PlayerStat[targetid][GangRank] = rank;
    format(str, sizeof(str), "%s has gave rank %d to %s.", GetOOCName(playerid), rank, GetOOCName(targetid));
    SendGangMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
    return 1;
}

COMMAND:ginvite(playerid, params[])
{
	new targetid, str[128];
	if(PlayerStat[playerid][GangID] < 1) return SendClientMessage(playerid, GREY, "You must be in a gang to use this command.");
	if(PlayerStat[playerid][GangRank] < 5) return SendClientMessage(playerid, GREY, "You must be rank 5/6 to use this command.");
    if(sscanf(params,"u", targetid))return SendClientMessage(playerid, GREY, "USAGE: /ginvite [playerid]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
    if(PlayerStat[targetid][GangID] >= 1 || PlayerStat[targetid][FactionID] >= 1) return SendClientMessage(playerid, GREY, "Target ID is already in a Gang/Faction.");
    PlayerStat[targetid][BeingInvitedToGang] = PlayerStat[playerid][GangID];
	format(str, sizeof(str), "%s has invited you to join %s, type /accept gang to join.", GetOOCName(playerid), GangStat[PlayerStat[playerid][GangID]][GangName]);
	SendClientMessage(targetid, GREEN, str);
    format(str, sizeof(str), "%s has invited %s to join %s.", GetOOCName(playerid), GetOOCName(targetid), GangStat[PlayerStat[playerid][GangID]][GangName]);
    SendGangMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
    return 1;
}

COMMAND:gkick(playerid, params[])
{
	new targetid, str[128];
	if(PlayerStat[playerid][GangID] < 1) return SendClientMessage(playerid, GREY, "You must be in a gang to use this command.");
	if(PlayerStat[playerid][GangRank] < 5) return SendClientMessage(playerid, GREY, "You must be rank 5/6 to use this command.");
    if(sscanf(params,"u", targetid))return SendClientMessage(playerid, GREY, "USAGE: /gkick [playerid]");
    if(playerid == targetid) return SendClientMessage(playerid, GREY, "You can't kick yourself, use /gquit.");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
    if(PlayerStat[playerid][GangID] != PlayerStat[targetid][GangID]) return SendClientMessage(playerid, GREY, "Target ID isn't in your gang.");
    if(PlayerStat[playerid][GangRank] <= PlayerStat[targetid][GangRank]) return SendClientMessage(playerid, GREY, "Target ID has same or higher rank.");
    format(str, sizeof(str), "%s has kicked %s from the gang.", GetOOCName(playerid), GetOOCName(targetid));
    SendGangMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
    GangStat[PlayerStat[playerid][GangID]][Members] -= 1;
    PlayerStat[playerid][GangID] = 0;
	PlayerStat[playerid][GangRank] = 0;
	format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
    if(INI_Open(GangStat[PlayerStat[playerid][GangID]][GangFile]))
    {
        INI_WriteInt("Members", GangStat[PlayerStat[playerid][GangID]][Members]);
        INI_Save();
        INI_Close();
    }
    return 1;
}

/*
CREATED & SCRIPTED & MAPPED BY MARCO - http://forum.sa-mp.com/member.php?u=181058
*/

COMMAND:gquit(playerid, params[])
{
	new str[128];
	if(PlayerStat[playerid][GangID] < 1) return SendClientMessage(playerid, GREY, "You must be in a gang to use this command.");
    format(str, sizeof(str), "%s has quited the gang.", GetOOCName(playerid));
    SendGangMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
	GangStat[PlayerStat[playerid][GangID]][Members] -= 1;
	format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
    if(INI_Open(GangStat[PlayerStat[playerid][GangID]][GangFile]))
    {
        INI_WriteInt("Members", GangStat[PlayerStat[playerid][GangID]][Members]);
        INI_Save();
        INI_Close();
    }
    PlayerStat[playerid][GangID] = 0;
	PlayerStat[playerid][GangRank] = 0;
    return 1;
}

COMMAND:gclothes(playerid, params[])
{
    if(PlayerStat[playerid][GangID] < 1) return SendClientMessage(playerid, GREY, "You must be in a gang to use this command.");
	if(IsPlayerInRangeOfPoint(playerid, 3, -8.2989,-386.4499,6.4286))
	{
		if(PlayerStat[playerid][Gender] == 0) return SetSkin(playerid, GangStat[PlayerStat[playerid][GangID]][fSkin]);
		else if(PlayerStat[playerid][GangRank] == 1) return SetSkin(playerid, GangStat[PlayerStat[playerid][GangID]][Skin1]);
		else if(PlayerStat[playerid][GangRank] == 2) return SetSkin(playerid, GangStat[PlayerStat[playerid][GangID]][Skin2]);
		else if(PlayerStat[playerid][GangRank] == 3) return SetSkin(playerid, GangStat[PlayerStat[playerid][GangID]][Skin3]);
		else if(PlayerStat[playerid][GangRank] == 4) return SetSkin(playerid, GangStat[PlayerStat[playerid][GangID]][Skin4]);
		else if(PlayerStat[playerid][GangRank] == 5) return SetSkin(playerid, GangStat[PlayerStat[playerid][GangID]][Skin5]);
		else if(PlayerStat[playerid][GangRank] == 6) return SetSkin(playerid, GangStat[PlayerStat[playerid][GangID]][Skin6]);
	}
	else return SendClientMessage(playerid, GREY, "You are not at the prison showers.");
    return 1;
}

COMMAND:gmembers(playerid, params[])
{
	new str[128];
	if(PlayerStat[playerid][GangID] < 1) return SendClientMessage(playerid, GREY, "You must be in a gang to use this command.");
	SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], "Online Gang Members:");
	for(new i = 0; i < MAX_PLAYERS; i++)
    {
		if(IsPlayerConnected(i) && PlayerStat[playerid][GangID] == PlayerStat[i][GangID])
		{
            format(str, sizeof(str), "%s, Rank %d.", GetOOCName(i), PlayerStat[i][GangRank]);
            SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
        }
    }
    SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], "--------------------------------");
    return 1;
}

COMMAND:blackmarket(playerid, params[])
{
	if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
    if(PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You are cuffed or being dragged.");
	if(IsPlayerInRangeOfPoint(playerid, 1.5, 480.9567,1564.3361,996.6711))
	{
		ShowPlayerDialog(playerid, DIALOG_BM0, DIALOG_STYLE_LIST, "Black Market", "Purchase Items\nSell items", "Select", "Cancel");
	}
	else
	{
		SendClientMessage(playerid, GREY, "You are not near the black market smuggler.");
	}
	return 1;
}

COMMAND:getdrugs(playerid, params[])
{
    if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
    if(PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You are cuffed or being dragged.");
	if(PlayerStat[playerid][GangID] < 1) return SendClientMessage(playerid, GREY, "You must be a member of an official gang to buy here.");
	if(PlayerStat[playerid][GangRank] < 2) return SendClientMessage(playerid, GREY, "You must be rank 2+ to use this command.");
	if(PlayerStat[playerid][PlayingHours] < 3) return SendClientMessage(playerid, GREY, "You need to have at least 3 playing hours to use this command.");
	if(PlayerStat[playerid][GetDrugsReloadTime] > 1) return SendClientMessage(playerid, GREY, "You must wait 15 minutes before getting drugs again.");
    if(isnull(params)) return SendClientMessage(playerid, GREY, "USAGE: /getdrugs [pot/crack]");
	else if(!strcmp(params, "pot", true))
	{
	    if(IsPlayerInRangeOfPoint(playerid, 1.0, 2178.0469,1592.6830,1000.0))
	    {
		    if(PlayerStat[playerid][Money] < 750) return SendClientMessage(playerid, GREY, "You can't afford this.");
		    if(PlayerStat[playerid][Pot] == 5) return SendClientMessage(playerid, GREY, "You can't hold more than 5g of pot.");
    	    if(PlayerStat[playerid][Pot] + 3 > 5) return SendClientMessage(playerid, GREY, "You can't hold more than 5g of pot.");
            PlayerStat[playerid][Pot] += 3;
			ApplyAnimation(playerid, "DEALER", "DRUGS_BUY ", 4.0, 0, 0, 0, 3, 1);
            GiveMoney(playerid, -750);
            SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], "You have bought 3grams of pot for 750.");
            PlayerStat[playerid][GetDrugsReloadTime] = 900;
        }
        else return SendClientMessage(playerid, GREY, "You are not at the Secrect Room.");
    }
    else if(!strcmp(params, "crack", true))
	{
	    if(IsPlayerInRangeOfPoint(playerid, 1.0, 2178.0469,1592.6830,1000.0))
	    {
            if(PlayerStat[playerid][Crack] == 4) return SendClientMessage(playerid, GREY, "You can't hold more than 4g of crack.");
    	    if(PlayerStat[playerid][Crack] + 2 > 4) return SendClientMessage(playerid, GREY, "You can't hold more than 4g of crack.");
		    if(PlayerStat[playerid][Money] < 1500) return SendClientMessage(playerid, GREY, "You can't afford this.");
            PlayerStat[playerid][Crack] += 2;
			ApplyAnimation(playerid, "DEALER", "DRUGS_BUY ", 4.0, 0, 0, 0, 3, 1);
            GiveMoney(playerid, -1500);
            SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], "You have bought 2grams of crack for 1500.");
            PlayerStat[playerid][GetDrugsReloadTime] = 900;
        }
        else return SendClientMessage(playerid, GREY, "You are not at the sneaking point.");
    }
    else return SendClientMessage(playerid, GREY, "Invalid option.");
    return 1;
}

COMMAND:getweap(playerid, params[])
{
    if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
    if(PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You are cuffed or being dragged.");
	new weapid;
	if(PlayerStat[playerid][GangID] < 1) return SendClientMessage(playerid, GREY, "You must be a member of an official gang to buy here.");
	if(PlayerStat[playerid][GangRank] < 4) return SendClientMessage(playerid, GREY, "You must be rank 4+ to use this command.");
	if(PlayerStat[playerid][PlayingHours] < 5) return SendClientMessage(playerid, GREY, "You need to have at least 5 playing hours to use this command.");
	if(PlayerStat[playerid][GetWeapReloadTime] > 1) return SendClientMessage(playerid, GREY, "The dealer can't sell you anymore weapons now, come back later..");
    if(sscanf(params,"d", weapid))
	{
		if(PlayerStat[playerid][DonLV] == 3)
		{
  		SendClientMessage(playerid, GREY, "USAGE: /getweap [weaponid]");
	    SendClientMessage(playerid, GREY, "Weapon IDs: 1- Brass Knuckles ($540), 2- Knife ($1800), 3- Baseball Bat ($1350), 4- Colt.45 (5400$).");
		}
		else if(PlayerStat[playerid][DonLV] <= 2)
		{
	    SendClientMessage(playerid, GREY, "USAGE: /getweap [weaponid]");
	    SendClientMessage(playerid, GREY, "Weapon IDs: 1- Brass Knuckles ($540), 2- Knife ($1800), 3- Baseball Bat ($1350).");
		}
	}
	else if(IsPlayerInRangeOfPoint(playerid, 1.0, 2178.0469,1592.6830,1000.0))
	{
	    if(0 < weapid < 6)
	    {
		    if(weapid == 1)
	    	{
			    if(PlayerStat[playerid][Money] < 540) return SendClientMessage(playerid, GREY, "You can't afford this.");
			    ServerWeapon(playerid, 1, 1);
			    GiveMoney(playerid, -540);
				ApplyAnimation(playerid, "DEALER", "DRUGS_BUY ", 4.0, 0, 0, 0, 3, 1);
			    SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], "You bought a Brass Knuckles for $540.");
			    PlayerStat[playerid][GetWeapReloadTime] = 1020;
    	  	}
    	  	if(weapid == 2)
	    	{
			    if(PlayerStat[playerid][Money] < 1800) return SendClientMessage(playerid, GREY, "You can't afford this.");
			    ServerWeapon(playerid, 4, 1);
			    GiveMoney(playerid, -1800);
				ApplyAnimation(playerid, "DEALER", "DRUGS_BUY ", 4.0, 0, 0, 0, 3, 1);
			    SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], "You bought a Knife for $1800.");
			    PlayerStat[playerid][GetWeapReloadTime] = 2700;
    	  	}
    	  	if(weapid == 3)
	    	{
			    if(PlayerStat[playerid][Money] < 1350) return SendClientMessage(playerid, GREY, "You can't afford this.");
			    ServerWeapon(playerid, 5, 1);
			    GiveMoney(playerid, -1350);
				ApplyAnimation(playerid, "DEALER", "DRUGS_BUY ", 4.0, 0, 0, 0, 3, 1);
			    SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], "You bought a Baseball Bat for $1350.");
			    PlayerStat[playerid][GetWeapReloadTime] = 1800;
    	  	}
    	  	if(weapid == 4)
	    	{
				if(PlayerStat[playerid][DonLV] < 3) return SendClientMessage(playerid, GREY, "You are not a GOLD donator.");
				if(PlayerStat[playerid][Money] < 5400) return SendClientMessage(playerid, GREY, "You can't afford this.");
				ServerWeapon(playerid, 22, 51);
				ApplyAnimation(playerid, "DEALER", "DRUGS_BUY ", 4.0, 0, 0, 0, 3, 1);
			    GiveMoney(playerid, -5400);
			    SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], "You bought a Colt. 45 with 50 ammo for 5400$.");
			    PlayerStat[playerid][GetWeapReloadTime] = 13000;
    	  	}
        }
	    else return SendClientMessage(playerid, GREY, "Invalid Weapon ID");
	}
	else return SendClientMessage(playerid, GREY, "You can't get weapons in this location.");
    return 1;
}
COMMAND:rolljoint(playerid, params[])
{
	if(PlayerStat[playerid][Pot] >= 1 && PlayerStat[playerid][Paper] >= 1)
 	{
		if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
		if(PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You are cuffed or being dragged.");
		if(GetFreeSlot(playerid) == 0 || MatchItem(playerid, 5, 5) == 1) return SendClientMessage(playerid, GREY, "You don't have a free inventory slot to roll a joint.");
		if(PlayerStat[playerid][JRCD] >= 1) return SendClientMessage(playerid, GREY, "You can't roll a joint right now.");
		new string[124];
		if(MatchItem(playerid, 5, 5) == 1) return SendClientMessage(playerid, GREY, "You already have the maximum amount of joints on you.");
		format(string, sizeof(string), "* %s takes out a Rizla and a small baggie, placing tabaco into the Rizla followed by some pot from the baggie.", GetICName(playerid));
		SendNearByMessage(playerid, ACTION_COLOR, string, 10);
		format(string, sizeof(string), "* %s rolls the Rizla into itself and then licks the tip, rolls it together.", GetICName(playerid));
		SendNearByMessage(playerid, ACTION_COLOR, string, 10);
		TogglePlayerControllable(playerid, 0);
		SetTimer("RollingJoint", 5000, false);
		PlayerStat[playerid][JRACD] += 7;
		PlayerStat[playerid][JRCD] += 335;
		SendClientMessage(playerid, GREY, "((You can move in 5 seconds, this is to stop any kind on nonRP))");
		PlayerStat[playerid][Paper]--;
		GiveItem(playerid, 5, 1);
		PlayerStat[playerid][Pot]--;
	}
	else
	{
		SendClientMessage(playerid, GREY, "You are lacking the required ingredients to roll the joint.");
	}
	return 1;
}

COMMAND:usecrack(playerid, params[])
{
	if(PlayerStat[playerid][Crack] >= 1)
	{
    	if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
    	if(PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You are cuffed or being dragged.");
		if(PlayerStat[playerid][CUCD] >= 1) return SendClientMessage(playerid, GREY, "You are still high from the last crack use.");
	    new string[124], Float:CArmour;
	    GetPlayerArmour(playerid, CArmour);
		format(string, sizeof(string), "* %s takes out a bag and sniffs inside the bag.", GetICName(playerid));
    	SendNearByMessage(playerid, ACTION_COLOR, string, 10);
    	SetPlayerDrunkLevel (playerid, 5000);
		SetTimer("CurrentlyHigh", 180000, false);
		PlayerStat[playerid][CUCD] += 350;
    	PlayerStat[playerid][Crack]--;
		if(CArmour >= 45) return 1;
		SetPlayerArmour(playerid, CArmour + 7.0);
		GetPlayerArmour(playerid, CArmour);
		if(CArmour >= 46)
		{
			SetPlayerArmour(playerid, 45);
			return 1;
		}
		return 1;
    }
    return 1;
}

//-----------------------------------------------------------------------[Faction Commands]------------------------------------------------------------------------------

COMMAND:r(playerid, params[])
{
    if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
	new message[128], str[128], Float:radioX, Float:radioY, Float:radioZ;
	if(PlayerStat[playerid][FactionID] < 1) return SendClientMessage(playerid, GREY, "You are not in faction.");
    if(sscanf(params,"s[128]", message))return SendClientMessage(playerid, GREY, "USAGE: /r{adio} [message]");
	GetPlayerPos(playerid, radioX, radioY, radioZ);
    if(PlayerStat[playerid][FactionID] == 1)
    {
		if(PlayerStat[playerid][FactionRank] < 2) return SendClientMessage(playerid, GREY, "You need to be rank 2 and above to use the radio.");
		format(str, sizeof(str), "[Radio] %s: %s", GetICName(playerid), message);
		PlayNearBySound(playerid, 45400, radioX, radioY, radioZ, 8);
        SendFactionMessage(playerid, GUARDS_RADIO, str);
		format(str, sizeof(str), "[Radio] %s: %s", GetICName(playerid), message);
		SendNearByMessage(playerid, GREY, str, 8);
	}
	else if(PlayerStat[playerid][FactionID] == 2)
    {
		format(str, sizeof(str), "[Radio] %s: %s", GetICName(playerid), message);
		PlayNearBySound(playerid, 45400, radioX, radioY, radioZ, 8);
        SendFactionMessage(playerid, DOCTORS_RADIO , str);
		format(str, sizeof(str), "[Radio] %s: %s", GetICName(playerid), message);
		SendNearByMessage(playerid, GREY, str, 8);
	}
    return 1;
}

COMMAND:d(playerid, params[])
{
	new message[128], str[128], Float:radioX, Float:radioY, Float:radioZ;
	if(PlayerStat[playerid][FactionID] < 1) return SendClientMessage(playerid, GREY, "You must be in a faction to use this command.");
    if(sscanf(params,"s[128]", message))return SendClientMessage(playerid, GREY, "USAGE: /d{ispatch} [message]");
	GetPlayerPos(playerid, radioX, radioY, radioZ);
	if(PlayerStat[playerid][FactionID] == 1)
	{
		if(PlayerStat[playerid][FactionRank] < 2) return SendClientMessage(playerid, GREY, "You need to be rank 2 and above to use the radio.");
		format(str, sizeof(str), "[Police Dispatch] %s: %s", GetICName(playerid), message);
		SendDispatchMessage(playerid, DISPATCH_COLOR, str);
		format(str, sizeof(str), "[Radio] %s: %s", GetICName(playerid), message);
		SendNearByMessage(playerid, GREY, str, 8);
		PlayNearBySound(playerid, 45400, radioX, radioY, radioZ, 8);
		return 1;
	}
	if(PlayerStat[playerid][FactionID] == 2)
	{
		format(str, sizeof(str), "[Doctor Dispatch] %s: %s", GetICName(playerid), message);
		SendDispatchMessage(playerid, DISPATCH_COLOR, str);
		format(str, sizeof(str), "[Radio] %s: %s", GetICName(playerid), message);
		SendNearByMessage(playerid, GREY, str, 8);
		PlayNearBySound(playerid, 45400, radioX, radioY, radioZ, 8);
		return 1;
	}
	return 1;
}

COMMAND:dispatch(playerid, params[])
{
	new message[128], str[128], Float:radioX, Float:radioY, Float:radioZ;
	if(PlayerStat[playerid][FactionID] < 1) return SendClientMessage(playerid, GREY, "You must be in a faction to use this command.");
    if(sscanf(params,"s[128]", message))return SendClientMessage(playerid, GREY, "USAGE: /dispatch [message]");
	GetPlayerPos(playerid, radioX, radioY, radioZ);
	if(PlayerStat[playerid][FactionID] == 1)
	{
		if(PlayerStat[playerid][FactionRank] < 2) return SendClientMessage(playerid, GREY, "You need to be rank 2 and above to use the radio.");
		format(str, sizeof(str), "[Police Dispatch] %s: %s", GetICName(playerid), message);
		SendDispatchMessage(playerid, DISPATCH_COLOR, str);
		format(str, sizeof(str), "[Radio] %s: %s", GetICName(playerid), message);
		SendNearByMessage(playerid, GREY, str, 8);
		PlayNearBySound(playerid, 45400, radioX, radioY, radioZ, 8);
		return 1;
	}
	if(PlayerStat[playerid][FactionID] == 2)
	{
		format(str, sizeof(str), "[Doctor Dispatch] %s: %s", GetICName(playerid), message);
		SendDispatchMessage(playerid, DISPATCH_COLOR, str);
		format(str, sizeof(str), "[Radio] %s: %s", GetICName(playerid), message);
		SendNearByMessage(playerid, GREY, str, 8);
		PlayNearBySound(playerid, 45400, radioX, radioY, radioZ, 8);
		return 1;
	}
	return 1;
}

COMMAND:faction(playerid, params[])
{
	new message[128], str[128];
	if(PlayerStat[playerid][FactionID] < 1) return SendClientMessage(playerid, GREY, "You must be in a faction to use this command.");
    if(sscanf(params,"s[128]", message))return SendClientMessage(playerid, GREY, "USAGE: /f{action} [message]");
	if(PlayerStat[playerid][FactionID] == 1)
	{
		switch(PlayerStat[playerid][FactionRank])
		{
			case 1:
			{
				SendClientMessage(playerid, CMD_COLOR, "You are not able to use this command, as you are a Cadet.");
				return 1;
			}
			case 2:
			{
				format(str, sizeof(str), "(( Correction Officer (1) %s: %s ))", GetOOCName(playerid), message);
			}
			case 3:
			{
				format(str, sizeof(str), "(( S.Correction Officer (2) %s: %s ))", GetOOCName(playerid), message);
			}
			case 4:
			{
				format(str, sizeof(str), "(( Corporal (3) %s: %s ))", GetOOCName(playerid), message);
			}
			case 5:
			{
				format(str, sizeof(str), "(( Sergeant (4) %s: %s ))", GetOOCName(playerid), message);
			}
			case 6:
			{
				format(str, sizeof(str), "((Staff Sergeant (5) %s: %s ))", GetOOCName(playerid), message);
			}
			case 7:
			{
				format(str, sizeof(str), "((Lieutenant (6) %s: %s ))", GetOOCName(playerid), message);
			}
			case 8:
			{
				format(str, sizeof(str), "((Captain (7) %s: %s ))", GetOOCName(playerid), message);
			}
			case 9:
			{
				format(str, sizeof(str), "((Executive Assistant (8) %s: %s ))", GetOOCName(playerid), message);
			}
			case 10:
			{
				format(str, sizeof(str), "(( Deputy Warden (8) %s: %s ))", GetOOCName(playerid), message);
			}
			case 11:
			{
				format(str, sizeof(str), "((Warden (10) %s: %s ))", GetOOCName(playerid), message);
			}
		}
		SendFactionMessage(playerid, LIGHT_GREEN, str);
		return 1;
	}
	if(PlayerStat[playerid][FactionID] == 2)
	{
		switch(PlayerStat[playerid][FactionRank])
		{
			case 1:
			{
				format(str, sizeof(str), "(( Paramedic (1) %s: %s ))", GetOOCName(playerid), message);
			}
			case 2:
			{
				format(str, sizeof(str), "(( Paramedic (2) %s: %s ))", GetOOCName(playerid), message);
			}
			case 3:
			{
				format(str, sizeof(str), "(( Doctor (3) %s: %s ))", GetOOCName(playerid), message);
			}
			case 4:
			{
				format(str, sizeof(str), "(( Doctor (4) %s: %s ))", GetOOCName(playerid), message);
			}
			case 5:
			{
				format(str, sizeof(str), "(( Co-Head Doctor (5) %s: %s ))", GetOOCName(playerid), message);
			}
			case 6:
			{
				format(str, sizeof(str), "(( Head Doctor (6) %s: %s ))", GetOOCName(playerid), message);
			}
		}
		SendFactionMessage(playerid, LIGHT_GREEN, str);
		return 1;
	}
	return 1;
}

COMMAND:f(playerid, params[])
{
	new message[128], str[128];
	if(PlayerStat[playerid][FactionID] < 1) return SendClientMessage(playerid, GREY, "You must be in a faction to use this command.");
    if(sscanf(params,"s[128]", message))return SendClientMessage(playerid, GREY, "USAGE: /f{action} [message]");
	if(PlayerStat[playerid][FactionID] == 1)
	{
		switch(PlayerStat[playerid][FactionRank])
		{
			case 1:
			{
				SendClientMessage(playerid, CMD_COLOR, "You are not able to use this command, as you are a Cadet.");
				return 1;
			}
			case 2:
			{
				format(str, sizeof(str), "(( Correction Officer (1) %s: %s ))", GetOOCName(playerid), message);
			}
			case 3:
			{
				format(str, sizeof(str), "(( S.Correction Officer (2) %s: %s ))", GetOOCName(playerid), message);
			}
			case 4:
			{
				format(str, sizeof(str), "(( Corporal (3) %s: %s ))", GetOOCName(playerid), message);
			}
			case 5:
			{
				format(str, sizeof(str), "(( Sergeant (4) %s: %s ))", GetOOCName(playerid), message);
			}
			case 6:
			{
				format(str, sizeof(str), "((Staff Sergeant (5) %s: %s ))", GetOOCName(playerid), message);
			}
			case 7:
			{
				format(str, sizeof(str), "((Lieutenant (6) %s: %s ))", GetOOCName(playerid), message);
			}
			case 8:
			{
				format(str, sizeof(str), "((Captain (7) %s: %s ))", GetOOCName(playerid), message);
			}
			case 9:
			{
				format(str, sizeof(str), "((Deputy Warden (8) %s: %s ))", GetOOCName(playerid), message);
			}
			case 10:
			{
				format(str, sizeof(str), "((Executive Assistant (9) %s: %s ))", GetOOCName(playerid), message);
			}
			case 11:
			{
				format(str, sizeof(str), "((Warden (10) %s: %s ))", GetOOCName(playerid), message);
			}
		}
		SendFactionMessage(playerid, LIGHT_GREEN, str);
		return 1;
	}
	if(PlayerStat[playerid][FactionID] == 2)
	{
		switch(PlayerStat[playerid][FactionRank])
		{
			case 1:
			{
				format(str, sizeof(str), "(( Paramedic (1) %s: %s ))", GetOOCName(playerid), message);
			}
			case 2:
			{
				format(str, sizeof(str), "(( Paramedic (2) %s: %s ))", GetOOCName(playerid), message);
			}
			case 3:
			{
				format(str, sizeof(str), "(( Doctor (3) %s: %s ))", GetOOCName(playerid), message);
			}
			case 4:
			{
				format(str, sizeof(str), "(( Doctor (4) %s: %s ))", GetOOCName(playerid), message);
			}
			case 5:
			{
				format(str, sizeof(str), "(( Co-Head Doctor (5) %s: %s ))", GetOOCName(playerid), message);
			}
			case 6:
			{
				format(str, sizeof(str), "(( Head Doctor (6) %s: %s ))", GetOOCName(playerid), message);
			}
		}
		SendFactionMessage(playerid, LIGHT_GREEN, str);
		return 1;
	}
	return 1;
}

COMMAND:radio(playerid, params[])
{
    if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
	new message[128], str[128], Float:radioX, Float:radioY, Float:radioZ;
	if(PlayerStat[playerid][FactionID] < 1) return SendClientMessage(playerid, GREY, "You are not in faction.");
    if(sscanf(params,"s[128]", message))return SendClientMessage(playerid, GREY, "USAGE: /radio [message]");
	GetPlayerPos(playerid, radioX, radioY, radioZ);
    if(PlayerStat[playerid][FactionID] == 1)
    {
		if(PlayerStat[playerid][FactionRank] < 2) return SendClientMessage(playerid, GREY, "You need to be rank 2 and above to use the radio.");
		format(str, sizeof(str), "[Radio] %s: %s", GetICName(playerid), message);
		PlayNearBySound(playerid, 45400, radioX, radioY, radioZ, 8);
        SendFactionMessage(playerid, GUARDS_RADIO, str);
		format(str, sizeof(str), "[Radio] %s: %s", GetICName(playerid), message);
		SendNearByMessage(playerid, GREY, str, 8);
	}
	else if(PlayerStat[playerid][FactionID] == 2)
    {
		format(str, sizeof(str), "[Radio] %s: %s", GetICName(playerid), message);
		PlayNearBySound(playerid, 45400, radioX, radioY, radioZ, 8);
        SendFactionMessage(playerid, DOCTORS_RADIO , str);
		format(str, sizeof(str), "[Radio] %s: %s", GetICName(playerid), message);
		SendNearByMessage(playerid, GREY, str, 8);
	}
    return 1;
}

COMMAND:checkdiff(playerid, params[])
{
	if(PlayerStat[playerid][BPUSE] == 1)
	{
    	new str[128];
		format(str, sizeof(str), "Your bench press difficulty level is [%d / 100].", PlayerStat[playerid][BPDIF]);
		SendClientMessage(playerid, GREY, str);
	}
	else
	{
	    SendClientMessage(playerid, GREY, "You are currently not bench pressing.");
	}

}

COMMAND:setrank(playerid, params[])
{
	new targetid, rank, str[128];
	if(PlayerStat[playerid][FactionID] < 1) return SendClientMessage(playerid, GREY, "You are not a Prison Guard/Doctor.");
	if(PlayerStat[playerid][FactionID] == 2) goto Medic_Rank;
	if(PlayerStat[playerid][FactionRank] < 10 && PlayerStat[playerid][FactionID] == 1) return SendClientMessage(playerid, GREY, "You must be rank 9 or above to use this command.");
	goto DOC_Rank;
	Medic_Rank:
	if(PlayerStat[playerid][FactionRank] < 5) return SendClientMessage(playerid, GREY, "You must be rank 5/6 to use this command.");
	DOC_Rank:
    if(sscanf(params,"ud", targetid, rank))return SendClientMessage(playerid, GREY, "USAGE: /setrank [playerid] [rank]");
    if(playerid == targetid) return SendClientMessage(playerid, GREY, "You can't change your rank.");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
    if(PlayerStat[playerid][FactionID] != PlayerStat[targetid][FactionID]) return SendClientMessage(playerid, GREY, "Target ID isn't a member of your faction.");
    if(PlayerStat[playerid][FactionRank] <= PlayerStat[targetid][FactionRank]) return SendClientMessage(playerid, GREY, "Target ID has same or higher rank.");
    if(rank >= 6) return SendClientMessage(playerid ,GREY, "Rank cannot be higher then 5.");
	if(rank < 1) return SendClientMessage(playerid ,GREY, "Rank cannot be lower then 1.");
	PlayerStat[targetid][FactionRank] = rank;
    format(str, sizeof(str), "%s has gave rank %d to %s.", GetOOCName(playerid), rank, GetOOCName(targetid));
    if(PlayerStat[playerid][FactionID] == 1) return SendFactionMessage(playerid, GUARDS_RADIO, str);
    else if(PlayerStat[playerid][FactionID] == 2) return SendFactionMessage(playerid, DOCTORS_RADIO , str);
    return 1;
}

COMMAND:setgrank(playerid, params[])
{
	new targetid, rank, str[128];
	if(PlayerStat[playerid][GangID] < 1) return SendClientMessage(playerid, GREY, "You are not in a gang.");
	if(PlayerStat[playerid][GangRank] < 5) return SendClientMessage(playerid, GREY, "You must be rank 5/6 to use this command.");
    if(sscanf(params,"ud", targetid, rank))return SendClientMessage(playerid, GREY, "USAGE: /setgrank [playerid] [rank]");
    if(playerid == targetid) return SendClientMessage(playerid, GREY, "You can't change your rank.");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
    if(PlayerStat[playerid][GangID] != PlayerStat[targetid][GangID]) return SendClientMessage(playerid, GREY, "Target ID isn't a member of your gang.");
    if(PlayerStat[playerid][GangRank] <= PlayerStat[targetid][GangRank]) return SendClientMessage(playerid, GREY, "Target ID has same or higher rank.");
	if(PlayerStat[playerid][GangRank] == 5 && rank >= 5) return SendClientMessage(playerid, GREY, "You can't promote/demote a user to a higher/lower level then 4.");
    PlayerStat[targetid][GangRank] = rank;
    format(str, sizeof(str), "%s has gave rank %d to %s.", GetOOCName(playerid), rank, GetOOCName(targetid));
	SendClientMessage(targetid, WHITE, str);
	format(str, sizeof(str), "You have gave rank %d to %s.", rank, GetOOCName(targetid));
	SendClientMessage(playerid, WHITE, str);
	
    return 1;
}

COMMAND:invite(playerid, params[])
{
	new targetid, str[128];
	if(PlayerStat[playerid][FactionID] < 1) return SendClientMessage(playerid, GREY, "You are not a Prison Guard/Doctor.");
	if(PlayerStat[playerid][FactionID] == 2) goto Medic_Invite;
	if(PlayerStat[playerid][FactionRank] < 7 && PlayerStat[playerid][FactionID] == 1) return SendClientMessage(playerid, GREY, "You must be rank 6 to use this command.");
	goto DOC_Invite;
    Medic_Invite:
	if(PlayerStat[playerid][FactionRank] < 5 && PlayerStat[playerid][FactionID] == 2) return SendClientMessage(playerid, GREY, "You must be rank 5 or above to use this command.");
	DOC_Invite:
	if(sscanf(params,"u", targetid))return SendClientMessage(playerid, GREY, "USAGE: /invite [playerid]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
    if(PlayerStat[targetid][GangID] >= 1 || PlayerStat[targetid][FactionID] >= 1) return SendClientMessage(playerid, GREY, "Target ID is already in a Gang/Faction.");
    PlayerStat[targetid][BeingInvitedToFaction] = PlayerStat[playerid][FactionID];
    if(PlayerStat[playerid][FactionID] == 1)
	{
        format(str, sizeof(str), "%s has invited %s to join the Department of Corrections.", GetOOCName(playerid), GetOOCName(targetid));
	    SendFactionMessage(playerid, GUARDS_RADIO, str);
	    SendClientMessage(targetid, GUARDS_RADIO, "You have been invited to join the Department of Corrections, type /accept faction to accept.");
	}
    else if(PlayerStat[playerid][FactionID] == 2)
	{
        format(str, sizeof(str), "%s has invited %s to join the San Andreas Prison Infirmary.", GetOOCName(playerid), GetOOCName(targetid));
	    SendFactionMessage(playerid, DOCTORS_RADIO , str);
	    SendClientMessage(targetid, DOCTORS_RADIO , "You have been invited to join the San Andreas Prison Infirmary, type /accept faction to accept.");
	}
    return 1;
}

COMMAND:uninvite(playerid, params[])
{
	new targetid, str[128];
	if(PlayerStat[playerid][FactionID] < 1) return SendClientMessage(playerid, GREY, "You are not a Prison Guard/Doctor.");
	if(PlayerStat[playerid][FactionRank] < 5) return SendClientMessage(playerid, GREY, "You must be rank 5/6 to use this command.");
    if(sscanf(params,"u", targetid))return SendClientMessage(playerid, GREY, "USAGE: /uninvite [playerid]");
    if(playerid == targetid) return SendClientMessage(playerid, GREY, "You can't kick yourself, use /quitfaction.");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
    if(PlayerStat[playerid][FactionID] != PlayerStat[targetid][FactionID]) return SendClientMessage(playerid, GREY, "Target ID isn't in your faction.");
    if(PlayerStat[playerid][FactionRank] <= PlayerStat[targetid][FactionRank]) return SendClientMessage(playerid, GREY, "Target ID has same or higher rank.");
    PlayerStat[playerid][FactionID] = 0;
	PlayerStat[playerid][FactionRank] = 0;
	SendClientMessage(targetid, RED, "You have been kicked from your faction.");
	if(PlayerStat[playerid][FactionID] == 1)
	{
        format(str, sizeof(str), "%s has kicked %s from the Department of Corrections.", GetOOCName(playerid), GetOOCName(targetid));
	    SendFactionMessage(playerid, GUARDS_RADIO, str);
	}
    else if(PlayerStat[playerid][FactionID] == 2)
	{
        format(str, sizeof(str), "%s has kicked %s from the San Andreas Prison Infirmary.", GetOOCName(playerid), GetOOCName(targetid));
	    SendFactionMessage(playerid, DOCTORS_RADIO , str);
	}
    return 1;
}

COMMAND:quitfaction(playerid, params[])
{
	new str[128];
	if(PlayerStat[playerid][FactionID] < 1) return SendClientMessage(playerid, GREY, "You are not a Prison Guard/Doctor.");
	PlayerStat[playerid][FactionID] = 0;
	PlayerStat[playerid][FactionRank] = 0;
	SendClientMessage(playerid, RED, "You have quited your faction.");
    if(PlayerStat[playerid][FactionID] == 1)
	{
        format(str, sizeof(str), "%s has quited the Department of Corrections faction.", GetOOCName(playerid));
	    SendFactionMessage(playerid, LIGHT_GREEN, str);
	}
    else if(PlayerStat[playerid][FactionID] == 2)
	{
        format(str, sizeof(str), "%s has quited the San Andreas Prison Infirmary faction.", GetOOCName(playerid));
	    SendFactionMessage(playerid, LIGHT_GREEN , str);
	}
    return 1;
}

COMMAND:members(playerid, params[])
{
	new str[128];
	if(PlayerStat[playerid][FactionID] < 1) return SendClientMessage(playerid, GREY, "You are not a Prison Guard/Doctor.");
	SendClientMessage(playerid, GREEN, "Online Faction Members:");
	for(new i = 0; i < MAX_PLAYERS; i++)
    {
		if(IsPlayerConnected(i) && PlayerStat[playerid][FactionID] == PlayerStat[i][FactionID])
		{
            format(str, sizeof(str), "%s, Rank %d.", GetOOCName(i), PlayerStat[i][FactionRank]);
            SendClientMessage(playerid, GREEN, str);
        }
    }
    SendClientMessage(playerid, GREEN, "--------------------------------");
    return 1;
}
COMMAND:gateopen(playerid, params[])
{
    if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
	if(PlayerStat[playerid][FactionID] < 1) return SendClientMessage(playerid, GREY, "You are not a Prison Guard/Doctor.");
	if(IsPlayerInRangeOfPoint(playerid, 5, -21.93213, -338.94623, 7.83163) && gatestatus == 0)
    {
		new str[128];
		gatestatus = 1;
		MoveObject(gate, -21.93213, -338.94623, -4.83163, 1);
		format(str, sizeof(str), "* %s opens the prison gate.", GetICName(playerid));
  		SendNearByMessage(playerid, ACTION_COLOR, str, 3);

	}
	return 1;
}

COMMAND:gateclose(playerid, params[])
{
    if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
	if(PlayerStat[playerid][FactionID] < 1) return SendClientMessage(playerid, GREY, "You are not a Prison Guard/Doctor.");
	if(IsPlayerInRangeOfPoint(playerid, 5, -21.93213, -338.94623, 7.83163) && gatestatus == 1)
    {
		new str[128];
		gatestatus = 0;
		MoveObject(gate, -21.93213, -338.94623, 7.83163, 1);
		format(str, sizeof(str), "* %s closes the prison gate.", GetICName(playerid));
  		SendNearByMessage(playerid, ACTION_COLOR, str, 3);

	}

	return 1;
}

/*COMMAND:gateopen(playerid, params[])
{
    if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
	if(PlayerStat[playerid][FactionID] < 1) return SendClientMessage(playerid, GREY, "You are not a Prison Guard/Doctor.");
	if(IsPlayerInRangeOfPoint(playerid, 5, -21.93213, -338.94623, 7.83163) && gatestatus == 0)
    {
		new str[128];
		gatestatus = 1;
		MoveObject(gate, -21.93213, -338.94623, -4.83163, 1);
		format(str, sizeof(str), "* %s opens the prison gate.", GetICName(playerid));
  		SendNearByMessage(playerid, ACTION_COLOR, str, 3);

	}
	return 1;
}*/

COMMAND:door(playerid, params[])
{
    if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious."); 
	if(PlayerStat[playerid][ADuty] == 1) goto Admin_Door;
	if(PlayerStat[playerid][FactionID] < 1) return SendClientMessage(playerid, GREY, "You are not a Prison Guard/Doctor.");
	Admin_Door:
	new str[128];
	if(IsPlayerInRangeOfPoint(playerid, 2.2, 442.7601, 1562.0801, 1000.6356))
    {
		if(gymdoor == 1)
		{
			MoveDynamicObject(gydoor, 444.2495, 1562.1702, 1001.2301, 1.5, 0.00000000, 0.00000000, 180.00000000);
			if(PlayerStat[playerid][ADuty] == 1) goto Door_Status1;
			format(str, sizeof(str), "* %s pushes the door open.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			Door_Status1:
			gymdoor = 0;
			return 1;
		}
		if(gymdoor == 0)
		{
			MoveDynamicObject(gydoor, 442.7635, 1562.1702, 1001.2301, 1.5, 0.00000000, 0.00000000, 180.00000000);
			if(PlayerStat[playerid][ADuty] == 1) goto Door_Status2;
			format(str, sizeof(str), "* %s pushes the door closed and locks it.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			Door_Status2:
			gymdoor = 1;
			return 1;
		}
	}
	if(IsPlayerInRangeOfPoint(playerid, 2.2, 445.9820, 1494.4187, 1001.2433))
    {
		if(isoldoor0 == 1)
		{
			MoveDynamicObject(isodoor0, 445.9820, 1493.0267, 1001.2433, 1.5, 0.0000, 0.0000, -90.000);
			if(PlayerStat[playerid][ADuty] == 1) goto Door_Status13;
			format(str, sizeof(str), "* %s pushes the door open.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			Door_Status13:
			isoldoor0 = 0;
			return 1;
		}
		if(isoldoor0 == 0)
		{
			MoveDynamicObject(isodoor0, 445.9820, 1494.4187, 1001.2433, 1.5, 0.0000, 0.0000, -90.000);
			if(PlayerStat[playerid][ADuty] == 1) goto Door_Status14;
			format(str, sizeof(str), "* %s pushes the door closed and locks it.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			Door_Status14:
			isoldoor0 = 1;
			return 1;
		}
	}
	if(IsPlayerInRangeOfPoint(playerid, 2.2, 462.0121, 1495.5077, 1001.2293))
    {
		if(isoldoor1 == 1)
		{
			MoveDynamicObject(isodoor1, 462.0121, 1496.9117, 1001.2293, 1.5, 0.0000, 0.0000, 90.000);
			if(PlayerStat[playerid][ADuty] == 1) goto Door_Status15;
			format(str, sizeof(str), "* %s pushes the door open.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			Door_Status15:
			isoldoor1 = 0;
			return 1;
		}
		if(isoldoor1 == 0)
		{
			MoveDynamicObject(isodoor1, 462.0121, 1495.5077, 1001.2293, 1.5, 0.0000, 0.0000, 90.000);
			if(PlayerStat[playerid][ADuty] == 1) goto Door_Status16;
			format(str, sizeof(str), "* %s pushes the door closed and locks it.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			Door_Status16:
			isoldoor1 = 1;
			return 1;
		}
	}
	if(IsPlayerInRangeOfPoint(playerid, 2.2, 462.0121, 1492.4537, 1001.2293))
    {
		if(isoldoor2 == 1)
		{
			MoveDynamicObject(isodoor2, 462.0121, 1493.8577, 1001.2293, 1.5, 0.0000, 0.0000, 90.000);
			if(PlayerStat[playerid][ADuty] == 1) goto Door_Status17;
			format(str, sizeof(str), "* %s pushes the door open.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			Door_Status17:
			isoldoor2 = 0;
			return 1;
		}
		if(isoldoor2 == 0)
		{
			MoveDynamicObject(isodoor2, 462.0121, 1492.4537, 1001.2293, 1.5, 0.0000, 0.0000, 90.000);
			if(PlayerStat[playerid][ADuty] == 1) goto Door_Status18;
			format(str, sizeof(str), "* %s pushes the door closed and locks it.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			Door_Status18:
			isoldoor2 = 1;
			return 1;
		}
	}
	if(IsPlayerInRangeOfPoint(playerid, 2.2, 462.0121, 1489.8448, 1001.2293))
    {
		if(isoldoor3 == 1)
		{
			MoveDynamicObject(isodoor3, 462.0121, 1488.4088, 1001.2293, 1.5, 0.0000, 0.0000, -90.000);
			if(PlayerStat[playerid][ADuty] == 1) goto Door_Status19;
			format(str, sizeof(str), "* %s pushes the door open.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			Door_Status19:
			isoldoor3 = 0;
			return 1;
		}
		if(isoldoor3 == 0)
		{
			MoveDynamicObject(isodoor3, 462.0121, 1489.8448, 1001.2293, 1.5, 0.0000, 0.0000, -90.000);
			if(PlayerStat[playerid][ADuty] == 1) goto Door_Status20;
			format(str, sizeof(str), "* %s pushes the door closed and locks it.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			Door_Status20:
			isoldoor3 = 1;
			return 1;
		}
	}
	if(IsPlayerInRangeOfPoint(playerid, 2.2, 462.0121, 1487.4608, 1001.2293))
    {
		if(isoldoor4 == 1)
		{
			MoveDynamicObject(isodoor4, 462.0121, 1486.0568, 1001.2293, 1.5, 0.0000, 0.0000, -90.000);
			if(PlayerStat[playerid][ADuty] == 1) goto Door_Status21;
			format(str, sizeof(str), "* %s pushes the door open.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			Door_Status21:
			isoldoor4 = 0;
			return 1;
		}
		if(isoldoor4 == 0)
		{
			MoveDynamicObject(isodoor4, 462.0121, 1487.4608, 1001.2293, 1.5, 0.0000, 0.0000, -90.000);
			if(PlayerStat[playerid][ADuty] == 1) goto Door_Status22;
			format(str, sizeof(str), "* %s pushes the door closed and locks it.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			Door_Status22:
			isoldoor4 = 1;
			return 1;
		}
	}
	if(IsPlayerInRangeOfPoint(playerid, 2.2, 461.9917, 1498.6859, 1004.7656))
    {
		if(isoldoor5 == 1)
		{
			MoveDynamicObject(isodoor5, 461.9917, 1500.1929, 1004.7656, 1.5, 0.0000, 0.0000, 90.000);
			if(PlayerStat[playerid][ADuty] == 1) goto Door_Status23;
			format(str, sizeof(str), "* %s pushes the door open.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			Door_Status23:
			isoldoor5 = 0;
			return 1;
		}
		if(isoldoor5 == 0)
		{
			MoveDynamicObject(isodoor5, 461.9917, 1498.6859, 1004.7656, 1.5, 0.0000, 0.0000, 90.000);
			if(PlayerStat[playerid][ADuty] == 1) goto Door_Status24;
			format(str, sizeof(str), "* %s pushes the door closed and locks it.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			Door_Status24:
			isoldoor5 = 1;
			return 1;
		}
	}
	if(IsPlayerInRangeOfPoint(playerid, 2.2, 461.9917, 1493.1759, 1004.7656))
    {
		if(isoldoor6 == 1)
		{
			MoveDynamicObject(isodoor6, 461.9917, 1494.6139, 1004.7656, 1.5, 0.0000, 0.0000, 90.000);
			if(PlayerStat[playerid][ADuty] == 1) goto Door_Status25;
			format(str, sizeof(str), "* %s pushes the door open.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			Door_Status25:
			isoldoor6 = 0;
			return 1;
		}
		if(isoldoor6 == 0)
		{
			MoveDynamicObject(isodoor6, 461.9917, 1493.1759, 1004.7656, 1.5, 0.0000, 0.0000, 90.000);
			if(PlayerStat[playerid][ADuty] == 1) goto Door_Status26;
			format(str, sizeof(str), "* %s pushes the door closed and locks it.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			Door_Status26:
			isoldoor6 = 1;
			return 1;
		}
	}
	if(IsPlayerInRangeOfPoint(playerid, 2.2, 461.9917, 1487.6239, 1004.7656))
    {
		if(isoldoor7 == 1)
		{
			MoveDynamicObject(isodoor7, 461.9917, 1489.0879, 1004.7656, 1.5, 0.0000, 0.0000, 90.000);
			if(PlayerStat[playerid][ADuty] == 1) goto Door_Status27;
			format(str, sizeof(str), "* %s pushes the door open.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			Door_Status27:
			isoldoor7 = 0;
			return 1;
		}
		if(isoldoor7 == 0)
		{
			MoveDynamicObject(isodoor7, 461.9917, 1487.6239, 1004.7656, 1.5, 0.0000, 0.0000, 90.000);
			if(PlayerStat[playerid][ADuty] == 1) goto Door_Status28;
			format(str, sizeof(str), "* %s pushes the door closed and locks it.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			Door_Status28:
			isoldoor7 = 1;
			return 1;
		}
	}
	if(IsPlayerInRangeOfPoint(playerid, 2.2, 437.9291, 1624.5547, 1001.2432))
    {
		if(librarydoor == 1)
		{
			MoveDynamicObject(librardoor, 439.0195, 1625.5581, 1001.2432, 1.5, 0.00, 0.00, 42.0000);
			if(PlayerStat[playerid][ADuty] == 1) goto Door_Status29;
			format(str, sizeof(str), "* %s pushes the door open.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			Door_Status29:
			librarydoor = 0;
			return 1;
		}
		if(librarydoor == 0)
		{
			MoveDynamicObject(librardoor, 437.9291, 1624.5547, 1001.2432, 1.5, 0.00, 0.00, 42.0000);
			if(PlayerStat[playerid][ADuty] == 1) goto Door_Status30;
			format(str, sizeof(str), "* %s pushes the door closed and locks it.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			Door_Status30:
			librarydoor = 1;
			return 1;
		}
	}
	if(IsPlayerInRangeOfPoint(playerid, 2.2, 436.9162, 1655.3450, 1001.2527))
    {
		if(blockcdoor == 1)
		{
			MoveDynamicObject(blockcdor, 436.9162, 1653.8390, 1001.2527, 1.5, 0.00, 0.00, 90.0000);
			if(PlayerStat[playerid][ADuty] == 1) goto Door_Status31;
			format(str, sizeof(str), "* %s pushes the door open.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			Door_Status31:
			blockcdoor = 0;
			return 1;
		}
		if(blockcdoor == 0)
		{
			MoveDynamicObject(blockcdor, 436.9162, 1655.3450, 1001.2527, 1.5, 0.00, 0.00, 90.0000);
			if(PlayerStat[playerid][ADuty] == 1) goto Door_Status32;
			format(str, sizeof(str), "* %s pushes the door closed and locks it.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			Door_Status32:
			blockcdoor = 1;
			return 1;
		}
	}
	if(IsPlayerInRangeOfPoint(playerid, 1.5, 430.6795, 1600.2559, 1001.2301))
    {
		if(blockadoor == 1)
		{
			MoveDynamicObject(blockador, 430.6795, 1598.7889, 1001.2301, 1.5, 0.00000000, 0.00000000, 90.00000000);
			if(PlayerStat[playerid][ADuty] == 1) goto Door_Status10;
			format(str, sizeof(str), "* %s pushes the door open.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			Door_Status10:
			blockadoor = 0;
			return 1;
		}
		if(blockadoor == 0)
		{
			MoveDynamicObject(blockador, 430.6795, 1600.2559, 1001.2301, 1.5, 0.00000000, 0.00000000, 90.00000000);
			if(PlayerStat[playerid][ADuty] == 1) goto Door_Status9;
			format(str, sizeof(str), "* %s pushes the door closed and locks it.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			Door_Status9:
			blockadoor = 1;
			return 1;
		}
	}
	if(IsPlayerInRangeOfPoint(playerid, 1.5, 434.3550, 1600.2580, 1001.230))
    {
		if(blockbdoor == 1)
		{
			MoveDynamicObject(blockbdor, 434.3550, 1598.7830, 1001.230, 1.5, 0.00000000, 0.00000000, 90.00000000);
			if(PlayerStat[playerid][ADuty] == 1) goto Door_Status11;
			format(str, sizeof(str), "* %s pushes the door open.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			Door_Status11:
			blockbdoor = 0;
			return 1;
		}
		if(blockbdoor == 0)
		{
			MoveDynamicObject(blockbdor, 434.3550, 1600.2580, 1001.230, 1.5, 0.00000000, 0.00000000, 90.00000000);
			if(PlayerStat[playerid][ADuty] == 1) goto Door_Status12;
			format(str, sizeof(str), "* %s pushes the door closed and locks it.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			Door_Status12:
			blockbdoor = 1;
			return 1;
		}
	}
	if(IsPlayerInRangeOfPoint(playerid, 2.5, 198.6041, 1462.0718, 10.8194))
    {
		if(yardoor1 == 1)
		{
			MoveDynamicObject(yarddoor1, 198.6041, 1462.0718, 10.8194, 1.5, 0.00000000, 0.00000000, 0.00000000);
			if(PlayerStat[playerid][ADuty] == 1) goto Yard_Status1;
			format(str, sizeof(str), "* %s pushes the door closed and locks it.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			Yard_Status1:
			yardoor1 = 0;
			return 1;
		}
		if(yardoor1 == 0)
		{
			MoveDynamicObject(yarddoor1, 197.7702, 1462.9354, 10.8194, 1.5, 0.00000000, 0.00000000, 90.00000000);
			if(PlayerStat[playerid][ADuty] == 1) goto Yard_Status2;
			format(str, sizeof(str), "* %s pushes the door open.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			Yard_Status2:
			yardoor1 = 1;
			return 1;
		}
	}
	if(IsPlayerInRangeOfPoint(playerid, 2.2, 444.8387, 1525.3693, 1001.2167))
    {
		if(PlayerStat[playerid][FactionID] == 2) return SendClientMessage(playerid, WHITE, "This is an DoC authorized zone only, if you need to enter please ask a DoC guard to open the door for you.");
		if(docdoor == 1)
		{
			MoveDynamicObject(docdoor1, 443.7176, 1526.2751, 1001.2167, 1.5, 0.000, 0.000, -40.0000);
			if(PlayerStat[playerid][ADuty] == 1) goto Door_Status5;
			format(str, sizeof(str), "* %s pushes the door open.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			Door_Status5:
			docdoor = 0;
			return 1;
		}
		if(docdoor == 0)
		{
			MoveDynamicObject(docdoor1, 444.8387, 1525.3693, 1001.2167, 1.5, 0.000, 0.000, -40.0000);
			if(PlayerStat[playerid][ADuty] == 1) goto Door_Status6;
			format(str, sizeof(str), "* %s pushes the door closed and locks it.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			Door_Status6:
			docdoor = 1;
			return 1;
		}
	}
	if(IsPlayerInRangeOfPoint(playerid, 2.2, 455.6743, 1525.2963, 997.0681))
    {
		if(PlayerStat[playerid][FactionID] == 2 && PlayerStat[playerid][FactionRank] > 1) return SendClientMessage(playerid, WHITE, "This is an DoC authorized zone only, if you need to enter please ask a DoC guard to open the door for you.");
		if(docdoorarm == 1)
		{
			MoveDynamicObject(docdoor2, 455.6743, 1524.0213, 997.0681, 1.0, 0.000, 0.000, 90.0000);
			if(PlayerStat[playerid][ADuty] == 1) goto Door_Status7;
			format(str, sizeof(str), "* %s pushes the door open.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			Door_Status7:
			docdoorarm = 0;
			return 1;
		}
		if(docdoorarm == 0)
		{
			MoveDynamicObject(docdoor2, 455.6743, 1525.2963, 997.0681, 1.0, 0.000, 0.000, 90.0000);
			if(PlayerStat[playerid][ADuty] == 1) goto Door_Status8;
			format(str, sizeof(str), "* %s pushes the door closed and locks it.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			Door_Status8:
			docdoorarm = 1;
			return 1;
		}
	}
	if(IsPlayerInRangeOfPoint(playerid, 2.2, 435.0880, 1561.6533, 1000.7861))
    {
		if(staffdoor == 1)
		{
			MoveDynamicObject(stafdoor1, 437.9250, 1561.6997, 999.9951, 1.5, 0.00000000, 0.00000000, 180.00000000);
			MoveDynamicObject(stafdoor2, 432.2829, 1561.6705, 999.9951, 1.5, 0.00000000, 0.00000000, 0.00000000);
			if(PlayerStat[playerid][ADuty] == 1) goto Door_Status3;
			format(str, sizeof(str), "* %s pushes the door open.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			Door_Status3:
			staffdoor = 0;
			return 1;
		}
		if(staffdoor == 0)
		{
			MoveDynamicObject(stafdoor1, 436.6110, 1561.6997, 999.9951, 1.5, 0.00000000, 0.00000000, 180.00000000);
			MoveDynamicObject(stafdoor2, 433.6059, 1561.6705, 999.9951, 1.5, 0.00000000, 0.00000000, 0.00000000);
			if(PlayerStat[playerid][ADuty] == 1) goto Door_Status4;
			format(str, sizeof(str), "* %s pushes the door closed and locks it.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, str, 7);
			Door_Status4:
			staffdoor = 1;
			return 1;
		}
	}
	else
	{
		SendClientMessage(playerid, GREY, "You are not near any door.");
	}
	return 1;
}

/*COMMAND:door(playerid, params[]) // DOOR COMMAND
{
    if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
	if(PlayerStat[playerid][FactionID] < 1) return SendClientMessage(playerid, GREY, "You are not a Prison Guard/Doctor.");
	if(IsPlayerInRangeOfPoint(playerid, 2.2, 1808.69995117,-1546.09997559,5699.39990234))
    {
		new str[128];
		if(Server[DoorStatus1] == 0)
		{
		   SetDynamicObjectRot(door[0], 0.00000000,0.00000000,0.00000000 + 87);
		   Server[DoorStatus1] = 1;
		   format(str, sizeof(str), "* %s pushes the door open.", GetICName(playerid));
		   SendNearByMessage(playerid, ACTION_COLOR, str, 3);
		}
		else if(Server[DoorStatus1] == 1)
		{
		   SetDynamicObjectRot(door[0], 0.00000000,0.00000000,0.00000000);
		   Server[DoorStatus1] = 0;
		   format(str, sizeof(str), "* %s pulls the handle to close the door.", GetICName(playerid));
		   SendNearByMessage(playerid, ACTION_COLOR, str, 3);
    }
    }
    else if(IsPlayerInRangeOfPoint(playerid, 2.2, 1811.69995117,-1546.09997559,5699.39990234))
    {
		new str[128];
		if(Server[DoorStatus2] == 0)
		{
		   SetDynamicObjectRot(door[1], 0.00000000,0.00000000,179.99450684 + 87);
		   Server[DoorStatus2] = 1;
		   format(str, sizeof(str), "* %s pushes the door open", GetICName(playerid));
		   SendNearByMessage(playerid, ACTION_COLOR, str, 3);
		}
		else if(Server[DoorStatus2] == 1)
		{
		   SetDynamicObjectRot(door[1], 0.00000000,0.00000000,179.99450684);
		   Server[DoorStatus2] = 0;
		   format(str, sizeof(str), "* %s pulls the handle to close the door.", GetICName(playerid));
		   SendNearByMessage(playerid, ACTION_COLOR, str, 3);
     }
     }
     else if(IsPlayerInRangeOfPoint(playerid, 2.2, 1813.69995117,-1539.30004883,12.19999981))
     {
		new str[128];
		if(Server[DoorStatus3] == 0)
		{
		   MoveDynamicObject(door[2], 1813.69995117,-1539.00004883 -5,12.19999981, 3.0, 0.00000000,0.00000000,88.00000000);
		   Server[DoorStatus3] = 1;
		   format(str, sizeof(str), "* %s scans his keycard on the machine", GetICName(playerid));
		   SendNearByMessage(playerid, ACTION_COLOR, str, 3);
		}
		else if(Server[DoorStatus3] == 1)
		{
		   MoveDynamicObject(door[2], 1813.69995117,-1539.00004883,12.19999981, 3.0, 0.00000000,0.00000000,88.00000000);
		   Server[DoorStatus3] = 0;
		   format(str, sizeof(str), "* Door closing", GetICName(playerid));
		   SendNearByMessage(playerid, ACTION_COLOR, str, 3);
     }
     }
 	 else return SendClientMessage(playerid, GREY, "You are not near any door right now.");
    return 1;
}*/

COMMAND:flocker(playerid, params[])
{
    if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
	if(PlayerStat[playerid][FactionID] < 1) return SendClientMessage(playerid, GREY, "You are not a Prison Guard/Doctor.");
	if(PlayerStat[playerid][FactionID] == 1)
	{
        if(IsPlayerInRangeOfPoint(playerid, 2.0, 459.4351, 1518.0682, 997.0270))
        {
	        ShowPlayerDialog(playerid, DIALOG_GLOCKER, DIALOG_STYLE_LIST, "Prison Guards Locker", "Duty\nEquip\nUniform\nDeposit All Weapons", "Select", "Quit");
	    }
	    else return SendClientMessage(playerid, GREY, "You are not at your Faction Lockers room.");
	}
	else if(PlayerStat[playerid][FactionID] == 2)
	{
        if(IsPlayerInRangeOfPoint(playerid, 2.0, 1803.8667,-1529.2509,5700.4287))
        {
	        ShowPlayerDialog(playerid, DIALOG_DLOCKER, DIALOG_STYLE_LIST, "Prison Guards Locker", "Duty\nUniform", "Select", "Quit");
	    }
	    else return SendClientMessage(playerid, GREY, "You are not at your Faction Lockers room.");
	}
    return 1;
}

COMMAND:shocker(playerid, params[])
{
    if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
	if(PlayerStat[playerid][FactionID] != 1) return SendClientMessage(playerid, GREY, "You are not a Prison Guard.");
	if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You can't use your shocker right now.");
	new str[128];
	if(PlayerStat[playerid][Taser] == 0)
	{
        PlayerStat[playerid][Taser] = 1;
        SetPlayerAttachedObject(playerid, INDEX_TASER, 18642, 6, 0.06, 0.01, 0.08, 180.0, 0.0, 0.0);
        format(str, sizeof(str), "* %s unhoslter his shocker.", GetICName(playerid));
        SendNearByMessage(playerid, ACTION_COLOR, str, 6);
	}
	else if(PlayerStat[playerid][Taser] == 1)
	{
        PlayerStat[playerid][Taser] = 0;
        RemovePlayerAttachedObject(playerid, INDEX_TASER);
        format(str, sizeof(str), "* %s hoslter his shocker.", GetICName(playerid));
        SendNearByMessage(playerid, ACTION_COLOR, str, 6);
	}
    return 1;
}

COMMAND:frisk(playerid, params[])
{
    if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
	new targetid, str[128], weapname1[60], weapname2[60], weapname3[60];
	if(PlayerStat[playerid][FactionID] != 1) return SendClientMessage(playerid, GREY, "You are not a Prison Guard.");
	if(sscanf(params,"u", targetid))return SendClientMessage(playerid, GREY, "USAGE: /frisk [playerid]");
	if(targetid == playerid) return SendClientMessage(playerid, GREY, "You can't frisk yourself.");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(IsPlayerInRangeOfPlayer(2.0, playerid, targetid))
	{
		new Weapon1 = PlayerStat[targetid][WeaponSlot0];
		new Weapon2 = PlayerStat[targetid][WeaponSlot1];
		new Weapon3 = PlayerStat[targetid][WeaponSlot2];
		GetWeaponName(Weapon1 ,weapname1, sizeof(weapname1));
		GetWeaponName(Weapon2, weapname2, sizeof(weapname2));
		GetWeaponName(Weapon3, weapname3, sizeof(weapname3));
		if(Weapon1 == 0) { weapname1 = "None"; }
		if(Weapon2 == 0) { weapname2 = "None"; }
		if(Weapon3 == 0) { weapname3 = "None"; }
		SendClientMessage(playerid, GREY, "------------------------------------------------------");
		ShowPlayerWeaponsNames(playerid, targetid);
	    format(str, sizeof(str), "$%d Money", PlayerStat[targetid][Money]);
	    SendClientMessage(playerid, WHITE, str);
	    format(str, sizeof(str), "%d Pot ", PlayerStat[targetid][Pot]);
	    SendClientMessage(playerid, WHITE, str);
	    format(str, sizeof(str), "%d Crack ", PlayerStat[targetid][Crack]);
	    SendClientMessage(playerid, WHITE, str);
	    format(str, sizeof(str), "Weapon1: %s || Weapon2: %s || Weapon3: %s", weapname1, weapname2, weapname3);
	    SendClientMessage(playerid, WHITE, str);
	    SendClientMessage(playerid, GREY, "------------------------------------------------------");
	    format(str, sizeof(str), "* %s has frisked %s for any illegal items.", GetICName(playerid), GetICName(targetid));
	    SendNearByMessage(playerid, ACTION_COLOR, str, 8);
    }
    else return SendClientMessage(playerid, GREY, "Target ID is too far away.");
    return 1;
}

COMMAND:cuff(playerid, params[])
{
    if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
	new targetid, str[128];
	if(PlayerStat[playerid][FactionID] != 1) return SendClientMessage(playerid, GREY, "You are not a Prison Guard.");
	if(sscanf(params,"u", targetid))return SendClientMessage(playerid, GREY, "USAGE: /cuff [playerid]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(targetid == playerid) return SendClientMessage(playerid, GREY, "You can't cuff yourself.");
	if(PlayerStat[targetid][FactionID] == 1) return SendClientMessage(playerid, GREY, "You can't cuff a prison guard.");
	if(IsPlayerInRangeOfPlayer(3.0, playerid, targetid))
	{
		if(PlayerStat[targetid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "Target ID is already cuffed.");
		PlayerStat[targetid][Cuffed] = 1;
		PlayerStat[targetid][Tased] = 0;
		SetPlayerSpecialAction(targetid,SPECIAL_ACTION_CUFFED);
		format(str, sizeof(str), "* %s has cuffed %s.", GetICName(playerid), GetICName(targetid));
		SendNearByMessage(playerid, ACTION_COLOR, str, 5);
    }
    else return SendClientMessage(playerid, GREY, "Target ID is too far away.");
    return 1;
}

COMMAND:bandage(playerid, params[])
{
    if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
	new targetid, str[128];
	if(PlayerStat[playerid][FactionID] == 0) return SendClientMessage(playerid, GREY, "You can't use this command.");
	if(sscanf(params,"u", targetid))return SendClientMessage(playerid, GREY, "USAGE: /bandage [playerid]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(PlayerStat[targetid][BleedingWound] == 0) return SendClientMessage(playerid, GREY, "Target ID is not bleeding.");
	ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
	SetTimerEx("ClearBleedingWound", 5000, false, "dd", playerid, targetid);
	format(str, sizeof(str), "* %s started to bandage %s wound.", GetICName(playerid), GetICName(targetid));
	SendNearByMessage(playerid, ACTION_COLOR, str, 7);
	return 1;
}

COMMAND:uncuff(playerid, params[])
{
	new targetid, str[128];
	if(PlayerStat[playerid][FactionID] != 1) return SendClientMessage(playerid, GREY, "You are not a Prison Guard.");
	if(sscanf(params,"u", targetid))return SendClientMessage(playerid, GREY, "USAGE: /uncuff [playerid]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(IsPlayerInRangeOfPlayer(3.0, playerid, targetid))
	{
		if(PlayerStat[targetid][Cuffed] == 0) return SendClientMessage(playerid, GREY, "Target ID isn't cuffed.");
		PlayerStat[targetid][Cuffed] = 0;
		TogglePlayerControllable(targetid, 1);
		SetPlayerSpecialAction(targetid,SPECIAL_ACTION_NONE);
		format(str, sizeof(str), "* %s has uncuffed %s.", GetICName(playerid), GetICName(targetid));
		SendNearByMessage(playerid, ACTION_COLOR, str, 5);
    }
    else return SendClientMessage(playerid, GREY, "Target ID is too far away.");
    return 1;
}

COMMAND:ann(playerid, params[])
{
	new message[128], str[128];
	if(PlayerStat[playerid][FactionID] != 1) return SendClientMessage(playerid, GREY, "You are not a Prison Guard.");
	if(PlayerStat[playerid][FactionRank] < 4) return SendClientMessage(playerid, GREY, "Only rank 4+ can use this command.");
	if(sscanf(params,"s[128]", message))return SendClientMessage(playerid, GREY, "USAGE: /ann{ounce} [message]");
	if(strlen(message) < 1) return SendClientMessage(playerid, GREY, "Message is too short.");
    if(strlen(message) > 128) return SendClientMessage(playerid, GREY, "Message is too long.");
    SendClientMessageToAll(GUARDS_RADIO, "______________________________________________________________________________________");
    SendClientMessageToAll(GUARDS_RADIO, "_____________________________Prison Guards Announcement:_____________________________");
	format(str, sizeof(str), "%s %s: %s", GetFactionRank(playerid), GetICName(playerid), message);
    SendClientMessageToAll(WHITE, str);
    SendClientMessageToAll(GUARDS_RADIO, "______________________________________________________________________________________");
    return 1;
}

COMMAND:announce(playerid, params[])
{
	new message[128], str[128];
	if(PlayerStat[playerid][FactionID] != 1) return SendClientMessage(playerid, GREY, "You are not a Prison Guard.");
	if(PlayerStat[playerid][FactionRank] < 4) return SendClientMessage(playerid, GREY, "Only rank 4+ can use this command.");
	if(sscanf(params,"s[128]", message))return SendClientMessage(playerid, GREY, "USAGE: /ann{ounce} [message]");
	if(strlen(message) < 1) return SendClientMessage(playerid, GREY, "Message is too short.");
    if(strlen(message) > 128) return SendClientMessage(playerid, GREY, "Message is too long.");
    SendClientMessageToAll(GUARDS_RADIO, "------------------------------------------------------------------------------------------------------------------------");
    SendClientMessageToAll(GUARDS_RADIO, "Prison Guards Announcement:");
	format(str, sizeof(str), "%s %s: %s", GetFactionRank(playerid), GetICName(playerid), message);
    SendClientMessageToAll(WHITE, str);
    SendClientMessageToAll(GUARDS_RADIO, "------------------------------------------------------------------------------------------------------------------------");
    return 1;
}

COMMAND:drag(playerid, params[])
{
    if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
	new targetid, str[128];
	if(PlayerStat[playerid][FactionID] != 1) return SendClientMessage(playerid, GREY, "You are not a Prison Guard.");
	if(sscanf(params,"u", targetid))return SendClientMessage(playerid, GREY, "USAGE: /drag [playerid]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(PlayerStat[targetid][Cuffed] == 0) return SendClientMessage(playerid, GREY, "Target ID isn't cuffed.");
	if(IsPlayerInRangeOfPlayer(2.0, playerid, targetid))
	{
		if(PlayerStat[targetid][BeingDragged] == 1) return SendClientMessage(playerid, GREY, "Target ID is already being Dragged by someone else.");
		PlayerStat[targetid][BeingDraggedBy] = playerid;
		PlayerStat[targetid][BeingDragged] = 1;
		TogglePlayerControllable(targetid, 0);
		format(str, sizeof(str), "* %s starts dragging %s.", GetICName(playerid), GetICName(targetid));
		SendNearByMessage(playerid, ACTION_COLOR, str, 3);
    }
    else return SendClientMessage(playerid, GREY, "Target ID is too far away.");
    return 1;
}

COMMAND:take(playerid, params[])
{
    if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
	new targetid, item[20], str[128];
	if(PlayerStat[playerid][FactionID] != 1) return SendClientMessage(playerid, GREY, "You are not a Prison Guard");
	if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1)
	{
        SendClientMessage(playerid, GREY, "You can't use this command right now.");
	}
	if(sscanf(params,"us[20]", targetid, item))return SendClientMessage(playerid, GREY, "USAGE: /take [playerid] [item]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(IsPlayerInRangeOfPlayer(2.0, playerid, targetid))
	{
		if(!strcmp(item, "weapons", true))
		{
			ResetWeaponsFully(targetid);
			format(str, sizeof(str), "* %s has taken %s's weapons.", GetICName(playerid), GetICName(targetid));
		    SendNearByMessage(playerid, ACTION_COLOR, str, 3);
		    format(str, sizeof(str), "You have successsfully taken %s's weapons.", GetICName(targetid));
		    SendClientMessage(playerid, WHITE, str);
		    format(str, sizeof(str), "Prison guard %s took your weapons.", GetICName(playerid));
		    SendClientMessage(targetid, WHITE, str);
		}
		else if(!strcmp(item, "pot", true))
		{
			PlayerStat[targetid][Pot] = 0;
			format(str, sizeof(str), "* %s has taken %s's pot.", GetICName(playerid), GetICName(targetid));
		    SendNearByMessage(playerid, ACTION_COLOR, str, 3);
		    format(str, sizeof(str), "You have successsfully taken %s's pot.", GetICName(targetid));
		    SendClientMessage(playerid, WHITE, str);
		    format(str, sizeof(str), "Prison guard %s took your pot.", GetICName(playerid));
		    SendClientMessage(targetid, WHITE, str);
		}
		else if(!strcmp(item, "crack", true))
		{
			PlayerStat[targetid][Crack] = 0;
			format(str, sizeof(str), "* %s has taken %s's crack.", GetICName(playerid), GetICName(targetid));
		    SendNearByMessage(playerid, ACTION_COLOR, str, 3);
		    format(str, sizeof(str), "You have successsfully taken %s's crack.", GetICName(targetid));
		    SendClientMessage(playerid, WHITE, str);
		    format(str, sizeof(str), "Prison guard %s took your crack.", GetICName(playerid));
		    SendClientMessage(targetid, WHITE, str);
		}
    }
    else return SendClientMessage(playerid, GREY, "Target ID is too far away.");
    return 1;
}

COMMAND:stopdrag(playerid, params[])
{
	new targetid, str[128];
    if(PlayerStat[playerid][FactionID] != 1) return SendClientMessage(playerid, GREY, "You are not a Prison Guard");
	if(sscanf(params,"u", targetid))return SendClientMessage(playerid, GREY, "USAGE: /drag [playerid]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(PlayerStat[targetid][BeingDragged] == 0) return SendClientMessage(playerid, GREY, "Target ID isn't being dragged.");
	if(IsPlayerInRangeOfPlayer(2.0, playerid, targetid))
	{
		if(PlayerStat[targetid][BeingDraggedBy] != playerid) return SendClientMessage(playerid, GREY, "Target ID is already being Dragged by someone else.");
		PlayerStat[targetid][BeingDraggedBy] = -1;
		PlayerStat[targetid][BeingDragged] = 0;
		TogglePlayerControllable(targetid, 1);
		format(str, sizeof(str), "* %s stops dragging %s.", GetICName(playerid), GetICName(targetid));
		SendNearByMessage(playerid, ACTION_COLOR, str, 3);
    }
    else return SendClientMessage(playerid, GREY, "Target ID is too far away.");
    return 1;
}

/*COMMAND:isolate(playerid, params[])
{
    if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
	new targetid, time, str[128];
	if(PlayerStat[playerid][FactionID] != 1) return SendClientMessage(playerid, GREY, "You are not a Prison Guard.");
	if(sscanf(params,"ud", targetid, time))return SendClientMessage(playerid, GREY, "USAGE: /isolate [playerid] [time]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(IsPlayerInRangeOfPoint(targetid, 2.0, -200.2844,-208.5212,2.9520))
	{
        if(IsPlayerInRangeOfPlayer(2.0, playerid, targetid))
        {
		    if(PlayerStat[targetid][Cuffed] == 0) return SendClientMessage(playerid, GREY, "Target ID must be cuffed.");
		    if(PlayerStat[targetid][BeingDragged] == 1) return SendClientMessage(playerid, GREY, "Target ID mustn't be dragged.");
		    if(PlayerStat[targetid][InIsolatedCell] == 1) return SendClientMessage(playerid, GREY, "Target ID is already in an isolated cell.");
		    if(time > 5000) return SendClientMessage(playerid, GREY, "The time musn't be over 5000 seconds.");
		    if(time < 360) return SendClientMessage(playerid, GREY, "The time musn't be under 360 seconds.");
		    PlayerStat[targetid][InIsolatedCell] = 1;
            SetPlayerPos(targetid, -209.4500,-201.2415,2.8665);
            SetPlayerVirtualWorld(playerid, playerid+0);
            SetPlayerInterior(playerid, 0);
            PlayerStat[targetid][Cuffed] = 1;
            TogglePlayerControllable(targetid, 1);
            PlayerStat[targetid][InIsolatedCellTime] = time;
            format(str, sizeof(str), "* %s pushes %s inside the isolated cell and locks the gate.", GetICName(playerid), GetICName(targetid));
            SendNearByMessage(playerid, ACTION_COLOR, str, 5);
            format(str, sizeof(str), "You have been moved to the isolated cell by %s for %d.", GetICName(playerid), time);
            SendClientMessage(targetid, WHITE, str);
            format(str, sizeof(str), "You have moved %s to the isolated cell for %d.", GetICName(targetid), time);
            SendClientMessage(playerid, WHITE, str);
		}
		else return SendClientMessage(playerid, GREY, "Target ID is too far away.");
    }
    else return SendClientMessage(playerid, GREY, "Target ID must be near an isolated cell.");
    return 1;
}*/

COMMAND:securitycamera(playerid, params[])
{
	if(PlayerStat[playerid][FactionID] != 1) return SendClientMessage(playerid, GREY, "You are not a Prison Guard.");
	if(IsPlayerInRangeOfPoint(playerid, 8.0, -25.6415,-374.0972,14.9761))
	{
		if(PlayerStat[playerid][SecurityCameraStatus] == 1)
		{
		   PlayerStat[playerid][SecurityCameraStatus] = 0;
		   TogglePlayerControllable(playerid, 1);
		   SetCameraBehindPlayer(playerid);
		   GameTextForPlayer(playerid, "~r~Security Camera Disabled.", 3000, 4);
		   PlayerStat[playerid][SecurityCameraNumber] = 0;
		   TextDrawHideForPlayer(playerid, SecurityCameraTextDraw);
		}
		else if(PlayerStat[playerid][SecurityCameraStatus] == 0)
		{
		   PlayerStat[playerid][SecurityCameraStatus] = 1;
		   TogglePlayerControllable(playerid, 0);
		   SetPlayerCameraPos(playerid, -19.8700,-335.8774,10.7141);
		   SetPlayerCameraLookAt(playerid, 7.8794,-371.8924,6.4286);
		   PlayerStat[playerid][SecurityCameraNumber] = 1;
		   GameTextForPlayer(playerid, "~g~Security Camera Enabled.", 3000, 4);
           TextDrawShowForPlayer(playerid, SecurityCameraTextDraw);
		}
    }
    else return SendClientMessage(playerid, GREY, "You are not at the Control Room.");
    return 1;
}



COMMAND:heal(playerid, params[])
{
    if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
	new targetid, money, str[128];
    if(PlayerStat[playerid][FactionID] != 2) return SendClientMessage(playerid, GREY, "You are not a Prison Doctor.");
    if(PlayerStat[playerid][DoctorDuty] == 0) return SendClientMessage(playerid, GREY, "You are not on duty.");
    if(sscanf(params,"ud", targetid, money))return SendClientMessage(playerid, GREY, "USAGE: /heal [playerid] [money]");
    if(targetid == playerid) return SendClientMessage(playerid, GREY, "You can't heal yourself.");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(money > 200) return SendClientMessage(playerid, GREY, "The money mustn't be over $200.");
	if(money < 20) return SendClientMessage(playerid, GREY, "The money mustn't be under $20.");
	if(IsPlayerInRangeOfPlayer(2.0, playerid, targetid))
	{
		if(money > PlayerStat[targetid][Money]) return SendClientMessage(playerid, GREY, "Target ID can't afford this.");
		if(PlayerStat[targetid][InHospital] == 1) return SendClientMessage(playerid, GREY, "Target ID is already being threated in the prison clinic.");
		if(PlayerStat[targetid][Dead] == 1)
		{
            TogglePlayerControllable(targetid, 1);
            ClearAnimations(targetid);
            PlayerStat[targetid][Dead] = 0;
            PlayerStat[targetid][BleedingToDeath] = 0;
            SetHealth(targetid, 100);
            GivePlayerMoney(targetid, -money);
            GivePlayerMoney(playerid, money);
            format(str, sizeof(str), "%s has healed %s using their medical tools", GetICName(playerid), GetICName(targetid));
            SendNearByMessage(playerid, ACTION_COLOR, str, 3);
            format(str, sizeof(str), "You have successfully healed %s for $%d.", GetICName(targetid), money);
            SendClientMessage(playerid, DOCTORS_RADIO , str);
            format(str, sizeof(str), "%s has healed you for $%d.", GetICName(targetid), money);
            SendClientMessage(targetid, DOCTORS_RADIO , str);
            SetCameraBehindPlayer(targetid);
        }
		else
		{
            SetHealth(targetid, 100);
            GivePlayerMoney(targetid, -money);
            GivePlayerMoney(playerid, money);
            format(str, sizeof(str), "* %s has healed %s using their medical tools", GetICName(playerid), GetICName(targetid));
            SendNearByMessage(playerid, ACTION_COLOR, str, 3);
            format(str, sizeof(str), "You have successfully healed %s for $%d.", GetICName(targetid), money);
            SendClientMessage(playerid, DOCTORS_RADIO , str);
            format(str, sizeof(str), "%s has healed you for $%d.", GetICName(targetid), money);
            SendClientMessage(targetid, DOCTORS_RADIO , str);
        }
    }
    else return SendClientMessage(playerid, GREY, "Target ID is too far away.");
    return 1;
}


//-----------------------------------------------------------------------[Cells Commands]------------------------------------------------------------------------------


COMMAND:buycell(playerid, params[])
{
	new str[128];
    if(PlayerStat[playerid][HasCell] == 1) return SendClientMessage(playerid, GREY, "You already own a cell, type /sellcell or /sellcellto to sell it.");
    for(new c = 0; c < MAX_CELLS; c++)
    {
		if(IsPlayerInRangeOfPoint(playerid, 1.0, CellStat[c][ExteriorX], CellStat[c][ExteriorY], CellStat[c][ExteriorZ]))
	    {
            if(CellStat[c][Owned] == 1) return SendClientMessage(playerid, GREY, "This cell isn't available.");
            {
				if(PlayerStat[playerid][Money] >= CellStat[c][CellPrice])
				{
					CellStat[c][Owned] = 1;
					PlayerStat[playerid][HasCell] = 1;
					PlayerStat[playerid][Cell] = c;
					GiveMoney(playerid, - CellStat[c][CellPrice]);
					format(CellStat[c][CellOwner], 60, "%s", GetICName(playerid));
					format(str, sizeof(str), "Cell ID %d\nOwner: %s", c, CellStat[c][CellOwner]);
                    Update3DTextLabelText(CellStat[c][TextLabel], WHITE, str);
                    DestroyDynamicPickup(CellStat[c][PickupID]);
                    CellStat[c][PickupID] = CreateDynamicPickup(1272, 23, CellStat[c][ExteriorX], CellStat[c][ExteriorY], CellStat[c][ExteriorZ], 0, -1, -1, 100.0);
					format(str, sizeof(str), "Congratulations!, you are now the owner of this cell (ID: %d).", c);
					SendClientMessage(playerid, GREEN, str);
					SaveCell(c);
				}
				else
				{
                    format(str, sizeof(str), "You can't afford $%d to buy this cell.", CellStat[c][CellPrice]);
					SendClientMessage(playerid, GREY, str);
				}
            }
        }
    }
    return 1;
}

COMMAND:sellcell(playerid, params[])
{
	new Confirmation[7], str[128];
    if(PlayerStat[playerid][HasCell] == 0) return SendClientMessage(playerid, GREY, "You don't own a cell.");
    if(sscanf(params,"s[128]", Confirmation))return SendClientMessage(playerid, GREY, "Are you SURE you want to sell your cell? if yes, type this: /sellcell confirm");
    else if(!strcmp(Confirmation, "confirm", true))
    {
        CellStat[PlayerStat[playerid][Cell]][Owned] = 0;
		GiveMoney(playerid, CellStat[PlayerStat[playerid][Cell]][CellPrice]/50);
		format(CellStat[PlayerStat[playerid][Cell]][CellOwner], 60, "Nobody");
		format(str, sizeof(str), "Cell ID %d\nOwner: %s\nThis Cell is available for $%d.", PlayerStat[playerid][Cell], CellStat[PlayerStat[playerid][Cell]][CellOwner], CellStat[PlayerStat[playerid][Cell]][CellPrice]);
        Update3DTextLabelText(CellStat[PlayerStat[playerid][Cell]][TextLabel], WHITE, str);
        DestroyDynamicPickup(CellStat[PlayerStat[playerid][Cell]][PickupID]);
        CellStat[PlayerStat[playerid][Cell]][PickupID] = CreateDynamicPickup(1273, 23, CellStat[PlayerStat[playerid][Cell]][ExteriorX], CellStat[PlayerStat[playerid][Cell]][ExteriorY], CellStat[PlayerStat[playerid][Cell]][ExteriorZ], 0, -1, -1, 100.0);
		format(str, sizeof(str), "You have sueccessfully sold your cell (ID: %d).", PlayerStat[playerid][Cell]);
		SendClientMessage(playerid, GREEN, str);
		CellStat[PlayerStat[playerid][Cell]][CellLevel] = 0;
		CellStat[PlayerStat[playerid][Cell]][CellPot] = 0;
		CellStat[PlayerStat[playerid][Cell]][CellCrack] = 0;
		CellStat[PlayerStat[playerid][Cell]][CellWeap1] = 0;
		CellStat[PlayerStat[playerid][Cell]][CellWeap2] = 0;
		SaveCell(PlayerStat[playerid][Cell]);
		PlayerStat[playerid][HasCell] = 0;
		PlayerStat[playerid][Cell] = -1;
	}
    return 1;
}

COMMAND:lockcell(playerid, params[])
{
    if(PlayerStat[playerid][HasCell] == 0) return SendClientMessage(playerid, GREY, "You don't own a cell.");
	if(IsPlayerInRangeOfPoint(playerid, 1.0, CellStat[PlayerStat[playerid][Cell]][ExteriorX], CellStat[PlayerStat[playerid][Cell]][ExteriorY], CellStat[PlayerStat[playerid][Cell]][ExteriorZ]))
	{
	    if(CellStat[PlayerStat[playerid][Cell]][Locked] == 1)
	    {
	        CellStat[PlayerStat[playerid][Cell]][Locked] = 0;
		    GameTextForPlayer(playerid, "~g~ Cell Unlocked", 3000, 4);
	    }
	    else if(CellStat[PlayerStat[playerid][Cell]][Locked] == 0)
	    {
		    CellStat[PlayerStat[playerid][Cell]][Locked] = 1;
		    GameTextForPlayer(playerid, "~r~ Cell Locked", 3000, 4);
	    }
	}
	else return SendClientMessage(playerid, GREY, "You are not near your cell.");
    return 1;
}

COMMAND:buycelllevel(playerid, params[])
{
	new Confirmation[7], str[128];
    if(PlayerStat[playerid][HasCell] == 0) return SendClientMessage(playerid, GREY, "You don't own a cell.");
    if(sscanf(params,"s[128]", Confirmation))
    {
        if(CellStat[PlayerStat[playerid][Cell]][CellLevel] == 1)
		{
			SendClientMessage(playerid, GREY, "Cell level 2 will cost you $7500, type /buycelllevel confirm to continue.");
		}
		else if(CellStat[PlayerStat[playerid][Cell]][CellLevel] == 2)
		{
			SendClientMessage(playerid, GREY, "Cell level 3 will cost you $10.000, type /buycelllevel confirm to continue.");
		}
		else if(CellStat[PlayerStat[playerid][Cell]][CellLevel] == 3) return SendClientMessage(playerid, GREY, "You have the max cell level (3), you can't upgrade no more.");
	}
    else if(!strcmp(Confirmation, "confirm", true))
    {
		if(CellStat[PlayerStat[playerid][Cell]][CellLevel] == 1)
		{
            if(PlayerStat[playerid][Money] >= 7500)
			{
			   CellStat[PlayerStat[playerid][Cell]][CellLevel] = 2;
			   GiveMoney(playerid, -7500);
			   SaveCell(PlayerStat[playerid][Cell]);
			   format(str, sizeof(str), "You have upgraded your cell level (ID: %d) to 2!", PlayerStat[playerid][Cell]);
			   SendClientMessage(playerid, GREEN, str);
			}
			else return SendClientMessage(playerid, GREY, "You can't afford this.");
		}
		else if(CellStat[PlayerStat[playerid][Cell]][CellLevel] == 2)
		{
            if(PlayerStat[playerid][Money] >= 10000)
			{
			   CellStat[PlayerStat[playerid][Cell]][CellLevel] = 3;
			   GiveMoney(playerid, -10000);
			   SaveCell(PlayerStat[playerid][Cell]);
			   format(str, sizeof(str), "You have upgraded your cell level (ID: %d) to 3!", PlayerStat[playerid][Cell]);
			   SendClientMessage(playerid, GREEN, str);
			}
			else return SendClientMessage(playerid, GREY, "You can't afford this.");
		}
		else if(CellStat[PlayerStat[playerid][Cell]][CellLevel] == 3) return SendClientMessage(playerid, GREY, "You have the max cell level (3), you can't upgrade no more.");
	}
    return 1;
}

COMMAND:storeweapon(playerid, params[])
{
	new str[128];
	if(PlayerStat[playerid][HasCell] == 0) return SendClientMessage(playerid, GREY, "You don't own a cell.");
    for(new c = 0; c < MAX_CELLS; c++)
    {
    	if(IsPlayerInRangeOfPoint(playerid, 5.0, CellStat[c][InteriorX], CellStat[c][InteriorY], CellStat[c][InteriorZ]) && c == PlayerStat[playerid][Cell]) 
		{
			if(GetWeaponSlot(playerid, GetPlayerWeapon(playerid)) == 0) return SendClientMessage(playerid, GREY, "Invalid weapon.");
			if(GetWeaponSlot(playerid, GetPlayerWeapon(playerid)) >= 21) return SendClientMessage(playerid, GREY, "You can't store this weapon because the guards will find it.");
			if(CellStat[PlayerStat[playerid][Cell]][CellLevel] == 1) return SendClientMessage(playerid, GREY, "Your cell level must be 2 or more to store weapons in it.");
			if(GetWeaponSlot(playerid, GetPlayerWeapon(playerid)) == 1)
			{
				if(CellStat[PlayerStat[playerid][Cell]][CellLevel] == 1 && CellStat[PlayerStat[playerid][Cell]][CellWeap1] != 0) return SendClientMessage(playerid, GREY, "Your cell level is 1 so you can't have more than one weapons inside your cell.");
				if(CellStat[PlayerStat[playerid][Cell]][CellLevel] == 2 && CellStat[PlayerStat[playerid][Cell]][CellWeap1] != 0) return SendClientMessage(playerid, GREY, "Your cell level is 2 so you can't have more than two weapons inside your cell.");
				if(CellStat[PlayerStat[playerid][Cell]][CellLevel] == 3 && CellStat[PlayerStat[playerid][Cell]][CellWeap1] != 0 && CellStat[PlayerStat[playerid][Cell]][CellWeap2] != 0) return SendClientMessage(playerid, GREY, "Your cell level is 3 so you can't have more than three weapons inside your cell.");
				new weaponid, ammo, weaponname[60];
				GetPlayerWeaponData(playerid, 1, weaponid, ammo);
				ResetPlayerWeapons(playerid);
				PlayerStat[playerid][Slot1] = 0;
				LoadPlayerWeapons(playerid);
				format(str, sizeof(str), "%s takes out something and hides it somewhere in the cell.", GetICName(playerid));
				SendNearByMessage(playerid, ACTION_COLOR, str, 3);
				if(CellStat[PlayerStat[playerid][Cell]][CellWeap1] == 0)
				{
					CellStat[PlayerStat[playerid][Cell]][CellWeap1] = weaponid;
					GetWeaponName(weaponid ,weaponname, sizeof(weaponname));
					format(str, sizeof(str), "You have deposited a %s inside your cell.", weaponname);
					SendClientMessage(playerid, GREY, str);
					SaveCell(PlayerStat[playerid][Cell]);
					return 1;
				}
				else
				{
					CellStat[PlayerStat[playerid][Cell]][CellWeap2] = weaponid;
					GetWeaponName(weaponid ,weaponname, sizeof(weaponname));
					format(str, sizeof(str), "You have deposited a %s inside your cell.", weaponname);
					SendClientMessage(playerid, GREY, str);
					SaveCell(PlayerStat[playerid][Cell]);
					return 1;
				}
			}
			if(GetWeaponSlot(playerid, GetPlayerWeapon(playerid)) == 2)
			{
				if(CellStat[PlayerStat[playerid][Cell]][CellLevel] == 2 && CellStat[PlayerStat[playerid][Cell]][CellWeap1] != 0) return SendClientMessage(playerid, GREY, "Your cell level is 2 so you can't have more than one weapons inside your cell.");
				if(CellStat[PlayerStat[playerid][Cell]][CellLevel] == 3 && CellStat[PlayerStat[playerid][Cell]][CellWeap1] != 0 && CellStat[PlayerStat[playerid][Cell]][CellWeap2] != 0) return SendClientMessage(playerid, GREY, "Your cell level is 3 so you can't have more than two weapons inside your cell.");
				new weaponid, ammo, weaponname[60];
				GetPlayerWeaponData(playerid, 2, weaponid, ammo);
				ResetPlayerWeapons(playerid);
				PlayerStat[playerid][Slot2] = 0;
				LoadPlayerWeapons(playerid);
				format(str, sizeof(str), "%s takes out something and hides it somewhere in the cell.", GetICName(playerid));
				SendNearByMessage(playerid, ACTION_COLOR, str, 3);
				if(CellStat[PlayerStat[playerid][Cell]][CellWeap1] == 0)
				{
					CellStat[PlayerStat[playerid][Cell]][CellWeap1] = weaponid;
					GetWeaponName(weaponid ,weaponname, sizeof(weaponname));
					format(str, sizeof(str), "You have deposited a %s inside your cell.", weaponname);
					SendClientMessage(playerid, GREY, str);
					SaveCell(PlayerStat[playerid][Cell]);
					return 1;
				}
				else
				{
					CellStat[PlayerStat[playerid][Cell]][CellWeap2] = weaponid;
					GetWeaponName(weaponid ,weaponname, sizeof(weaponname));
					format(str, sizeof(str), "You have deposited a %s inside your cell.", weaponname);
					SendClientMessage(playerid, GREY, str);
					SaveCell(PlayerStat[playerid][Cell]);
					return 1;
				}
			}
			if(GetWeaponSlot(playerid, GetPlayerWeapon(playerid)) == 3)
			{
				if(CellStat[PlayerStat[playerid][Cell]][CellLevel] == 2 && CellStat[PlayerStat[playerid][Cell]][CellWeap1] != 0) return SendClientMessage(playerid, GREY, "Your cell level is 2 so you can't have more than one weapons inside your cell.");
				if(CellStat[PlayerStat[playerid][Cell]][CellLevel] == 3 && CellStat[PlayerStat[playerid][Cell]][CellWeap1] != 0 && CellStat[PlayerStat[playerid][Cell]][CellWeap2] != 0) return SendClientMessage(playerid, GREY, "Your cell level is 3 so you can't have more than two weapons inside your cell.");
				new weaponid, ammo, weaponname[60];
				GetPlayerWeaponData(playerid, 3, weaponid, ammo);
				ResetPlayerWeapons(playerid);
				PlayerStat[playerid][Slot3] = 0;
				LoadPlayerWeapons(playerid);
				format(str, sizeof(str), "%s takes out something and hides it somewhere in the cell.", GetICName(playerid));
				SendNearByMessage(playerid, ACTION_COLOR, str, 3);
				if(CellStat[PlayerStat[playerid][Cell]][CellWeap1] == 0)
				{
					CellStat[PlayerStat[playerid][Cell]][CellWeap1] = weaponid;
					GetWeaponName(weaponid ,weaponname, sizeof(weaponname));
					format(str, sizeof(str), "You have deposited a %s inside your cell.", weaponname);
					SendClientMessage(playerid, GREY, str);
					SaveCell(PlayerStat[playerid][Cell]);
					return 1;
				}
				else
				{
					CellStat[PlayerStat[playerid][Cell]][CellWeap2] = weaponid;
					GetWeaponName(weaponid ,weaponname, sizeof(weaponname));
					format(str, sizeof(str), "You have deposited a %s inside your cell.", weaponname);
					SendClientMessage(playerid, GREY, str);
					SaveCell(PlayerStat[playerid][Cell]);
					return 1;
				}
			}
			if(GetWeaponSlot(playerid, GetPlayerWeapon(playerid)) == 4)
			{
				if(CellStat[PlayerStat[playerid][Cell]][CellLevel] == 2 && CellStat[PlayerStat[playerid][Cell]][CellWeap1] != 0) return SendClientMessage(playerid, GREY, "Your cell level is 2 so you can't have more than one weapons inside your cell.");
				if(CellStat[PlayerStat[playerid][Cell]][CellLevel] == 3 && CellStat[PlayerStat[playerid][Cell]][CellWeap1] != 0 && CellStat[PlayerStat[playerid][Cell]][CellWeap2] != 0) return SendClientMessage(playerid, GREY, "Your cell level is 3 so you can't have more than two weapons inside your cell.");
				new weaponid, ammo, weaponname[60];
				GetPlayerWeaponData(playerid, 4, weaponid, ammo);
				ResetPlayerWeapons(playerid);
				PlayerStat[playerid][Slot4] = 0;
				LoadPlayerWeapons(playerid);
				format(str, sizeof(str), "%s takes out something and hides it somewhere in the cell.", GetICName(playerid));
				SendNearByMessage(playerid, ACTION_COLOR, str, 3);
				if(CellStat[PlayerStat[playerid][Cell]][CellWeap1] == 0)
				{
					CellStat[PlayerStat[playerid][Cell]][CellWeap1] = weaponid;
					GetWeaponName(weaponid ,weaponname, sizeof(weaponname));
					format(str, sizeof(str), "You have deposited a %s inside your cell.", weaponname);
					SendClientMessage(playerid, GREY, str);
					SaveCell(PlayerStat[playerid][Cell]);
					return 1;
				}
				else
				{
					CellStat[PlayerStat[playerid][Cell]][CellWeap2] = weaponid;
					GetWeaponName(weaponid ,weaponname, sizeof(weaponname));
					format(str, sizeof(str), "You have deposited a %s inside your cell.", weaponname);
					SendClientMessage(playerid, GREY, str);
					SaveCell(PlayerStat[playerid][Cell]);
					return 1;
				}
			}
			if(GetWeaponSlot(playerid, GetPlayerWeapon(playerid)) == 5)
			{
				if(CellStat[PlayerStat[playerid][Cell]][CellLevel] == 2 && CellStat[PlayerStat[playerid][Cell]][CellWeap1] != 0) return SendClientMessage(playerid, GREY, "Your cell level is 2 so you can't have more than one weapons inside your cell.");
				if(CellStat[PlayerStat[playerid][Cell]][CellLevel] == 3 && CellStat[PlayerStat[playerid][Cell]][CellWeap1] != 0 && CellStat[PlayerStat[playerid][Cell]][CellWeap2] != 0) return SendClientMessage(playerid, GREY, "Your cell level is 3 so you can't have more than two weapons inside your cell.");
				new weaponid, ammo, weaponname[60];
				GetPlayerWeaponData(playerid, 5, weaponid, ammo);
				ResetPlayerWeapons(playerid);
				PlayerStat[playerid][Slot5] = 0;
				LoadPlayerWeapons(playerid);
				format(str, sizeof(str), "%s takes out something and hides it somewhere in the cell.", GetICName(playerid));
				SendNearByMessage(playerid, ACTION_COLOR, str, 3);
				if(CellStat[PlayerStat[playerid][Cell]][CellWeap1] == 0)
				{
					CellStat[PlayerStat[playerid][Cell]][CellWeap1] = weaponid;
					GetWeaponName(weaponid ,weaponname, sizeof(weaponname));
					format(str, sizeof(str), "You have deposited a %s inside your cell.", weaponname);
					SendClientMessage(playerid, GREY, str);
					SaveCell(PlayerStat[playerid][Cell]);
					return 1;
				}
				else
				{
					CellStat[PlayerStat[playerid][Cell]][CellWeap2] = weaponid;
					GetWeaponName(weaponid ,weaponname, sizeof(weaponname));
					format(str, sizeof(str), "You have deposited a %s inside your cell.", weaponname);
					SendClientMessage(playerid, GREY, str);
					SaveCell(PlayerStat[playerid][Cell]);
					return 1;
				}
			}
			if(GetWeaponSlot(playerid, GetPlayerWeapon(playerid)) == 6)
			{
				if(CellStat[PlayerStat[playerid][Cell]][CellLevel] == 2 && CellStat[PlayerStat[playerid][Cell]][CellWeap1] != 0) return SendClientMessage(playerid, GREY, "Your cell level is 2 so you can't have more than one weapons inside your cell.");
				if(CellStat[PlayerStat[playerid][Cell]][CellLevel] == 3 && CellStat[PlayerStat[playerid][Cell]][CellWeap1] != 0 && CellStat[PlayerStat[playerid][Cell]][CellWeap2] != 0) return SendClientMessage(playerid, GREY, "Your cell level is 3 so you can't have more than two weapons inside your cell.");
				new weaponid, ammo, weaponname[60];
				GetPlayerWeaponData(playerid, 6, weaponid, ammo);
				ResetPlayerWeapons(playerid);
				PlayerStat[playerid][Slot6] = 0;
				LoadPlayerWeapons(playerid);
				format(str, sizeof(str), "%s takes out something and hides it somewhere in the cell.", GetICName(playerid));
				SendNearByMessage(playerid, ACTION_COLOR, str, 3);
				if(CellStat[PlayerStat[playerid][Cell]][CellWeap1] == 0)
				{
					CellStat[PlayerStat[playerid][Cell]][CellWeap1] = weaponid;
					GetWeaponName(weaponid ,weaponname, sizeof(weaponname));
					format(str, sizeof(str), "You have deposited a %s inside your cell.", weaponname);
					SendClientMessage(playerid, GREY, str);
					SaveCell(PlayerStat[playerid][Cell]);
					return 1;
				}
				else
				{
					CellStat[PlayerStat[playerid][Cell]][CellWeap2] = weaponid;
					GetWeaponName(weaponid ,weaponname, sizeof(weaponname));
					format(str, sizeof(str), "You have deposited a %s inside your cell.", weaponname);
					SendClientMessage(playerid, GREY, str);
					SaveCell(PlayerStat[playerid][Cell]);
					return 1;
				}
			}
			if(GetWeaponSlot(playerid, GetPlayerWeapon(playerid)) == 7)
			{
				if(CellStat[PlayerStat[playerid][Cell]][CellLevel] == 2 && CellStat[PlayerStat[playerid][Cell]][CellWeap1] != 0) return SendClientMessage(playerid, GREY, "Your cell level is 2 so you can't have more than one weapons inside your cell.");
				if(CellStat[PlayerStat[playerid][Cell]][CellLevel] == 3 && CellStat[PlayerStat[playerid][Cell]][CellWeap1] != 0 && CellStat[PlayerStat[playerid][Cell]][CellWeap2] != 0) return SendClientMessage(playerid, GREY, "Your cell level is 3 so you can't have more than two weapons inside your cell.");
				new weaponid, ammo, weaponname[60];
				GetPlayerWeaponData(playerid, 7, weaponid, ammo);
				ResetPlayerWeapons(playerid);
				PlayerStat[playerid][Slot7] = 0;
				LoadPlayerWeapons(playerid);
				format(str, sizeof(str), "%s takes out something and hides it somewhere in the cell.", GetICName(playerid));
				SendNearByMessage(playerid, ACTION_COLOR, str, 3);
				if(CellStat[PlayerStat[playerid][Cell]][CellWeap1] == 0)
				{
					CellStat[PlayerStat[playerid][Cell]][CellWeap1] = weaponid;
					GetWeaponName(weaponid ,weaponname, sizeof(weaponname));
					format(str, sizeof(str), "You have deposited a %s inside your cell.", weaponname);
					SendClientMessage(playerid, GREY, str);
					SaveCell(PlayerStat[playerid][Cell]);
					return 1;
				}
				else
				{
					CellStat[PlayerStat[playerid][Cell]][CellWeap2] = weaponid;
					GetWeaponName(weaponid ,weaponname, sizeof(weaponname));
					format(str, sizeof(str), "You have deposited a %s inside your cell.", weaponname);
					SendClientMessage(playerid, GREY, str);
					SaveCell(PlayerStat[playerid][Cell]);
					return 1;
				}
			}
			if(GetWeaponSlot(playerid, GetPlayerWeapon(playerid)) == 8)
			{
				if(CellStat[PlayerStat[playerid][Cell]][CellLevel] == 2 && CellStat[PlayerStat[playerid][Cell]][CellWeap1] != 0) return SendClientMessage(playerid, GREY, "Your cell level is 2 so you can't have more than one weapons inside your cell.");
				if(CellStat[PlayerStat[playerid][Cell]][CellLevel] == 3 && CellStat[PlayerStat[playerid][Cell]][CellWeap1] != 0 && CellStat[PlayerStat[playerid][Cell]][CellWeap2] != 0) return SendClientMessage(playerid, GREY, "Your cell level is 3 so you can't have more than two weapons inside your cell.");
				new weaponid, ammo, weaponname[60];
				GetPlayerWeaponData(playerid, 8, weaponid, ammo);
				ResetPlayerWeapons(playerid);
				PlayerStat[playerid][Slot8] = 0;
				LoadPlayerWeapons(playerid);
				format(str, sizeof(str), "%s takes out something and hides it somewhere in the cell.", GetICName(playerid));
				SendNearByMessage(playerid, ACTION_COLOR, str, 3);
				if(CellStat[PlayerStat[playerid][Cell]][CellWeap1] == 0)
				{
					CellStat[PlayerStat[playerid][Cell]][CellWeap1] = weaponid;
					GetWeaponName(weaponid ,weaponname, sizeof(weaponname));
					format(str, sizeof(str), "You have deposited a %s inside your cell.", weaponname);
					SendClientMessage(playerid, GREY, str);
					SaveCell(PlayerStat[playerid][Cell]);
					return 1;
				}
				else
				{
					CellStat[PlayerStat[playerid][Cell]][CellWeap2] = weaponid;
					GetWeaponName(weaponid ,weaponname, sizeof(weaponname));
					format(str, sizeof(str), "You have deposited a %s inside your cell.", weaponname);
					SendClientMessage(playerid, GREY, str);
					SaveCell(PlayerStat[playerid][Cell]);
					return 1;
				}
			}
			if(GetWeaponSlot(playerid, GetPlayerWeapon(playerid)) == 9)
			{
				if(CellStat[PlayerStat[playerid][Cell]][CellLevel] == 2 && CellStat[PlayerStat[playerid][Cell]][CellWeap1] != 0) return SendClientMessage(playerid, GREY, "Your cell level is 2 so you can't have more than one weapons inside your cell.");
				if(CellStat[PlayerStat[playerid][Cell]][CellLevel] == 3 && CellStat[PlayerStat[playerid][Cell]][CellWeap1] != 0 && CellStat[PlayerStat[playerid][Cell]][CellWeap2] != 0) return SendClientMessage(playerid, GREY, "Your cell level is 3 so you can't have more than two weapons inside your cell.");
				new weaponid, ammo, weaponname[60];
				GetPlayerWeaponData(playerid, 9, weaponid, ammo);
				ResetPlayerWeapons(playerid);
				PlayerStat[playerid][Slot9] = 0;
				LoadPlayerWeapons(playerid);
				format(str, sizeof(str), "%s takes out something and hides it somewhere in the cell.", GetICName(playerid));
				SendNearByMessage(playerid, ACTION_COLOR, str, 3);
				if(CellStat[PlayerStat[playerid][Cell]][CellWeap1] == 0)
				{
					CellStat[PlayerStat[playerid][Cell]][CellWeap1] = weaponid;
					GetWeaponName(weaponid ,weaponname, sizeof(weaponname));
					format(str, sizeof(str), "You have deposited a %s inside your cell.", weaponname);
					SendClientMessage(playerid, GREY, str);
					SaveCell(PlayerStat[playerid][Cell]);
					return 1;
				}
				else
				{
					CellStat[PlayerStat[playerid][Cell]][CellWeap2] = weaponid;
					GetWeaponName(weaponid ,weaponname, sizeof(weaponname));
					format(str, sizeof(str), "You have deposited a %s inside your cell.", weaponname);
					SendClientMessage(playerid, GREY, str);
					SaveCell(PlayerStat[playerid][Cell]);
					return 1;
				}
			}
			if(GetWeaponSlot(playerid, GetPlayerWeapon(playerid)) == 10)
			{
				if(CellStat[PlayerStat[playerid][Cell]][CellLevel] == 2 && CellStat[PlayerStat[playerid][Cell]][CellWeap1] != 0) return SendClientMessage(playerid, GREY, "Your cell level is 2 so you can't have more than one weapons inside your cell.");
				if(CellStat[PlayerStat[playerid][Cell]][CellLevel] == 3 && CellStat[PlayerStat[playerid][Cell]][CellWeap1] != 0 && CellStat[PlayerStat[playerid][Cell]][CellWeap2] != 0) return SendClientMessage(playerid, GREY, "Your cell level is 3 so you can't have more than two weapons inside your cell.");
				new weaponid, ammo, weaponname[60];
				GetPlayerWeaponData(playerid, 10, weaponid, ammo);
				ResetPlayerWeapons(playerid);
				PlayerStat[playerid][Slot10] = 0;
				LoadPlayerWeapons(playerid);
				format(str, sizeof(str), "%s takes out something and hides it somewhere in the cell.", GetICName(playerid));
				SendNearByMessage(playerid, ACTION_COLOR, str, 3);
				if(CellStat[PlayerStat[playerid][Cell]][CellWeap1] == 0)
				{
					CellStat[PlayerStat[playerid][Cell]][CellWeap1] = weaponid;
					GetWeaponName(weaponid ,weaponname, sizeof(weaponname));
					format(str, sizeof(str), "You have deposited a %s inside your cell.", weaponname);
					SendClientMessage(playerid, GREY, str);
					SaveCell(PlayerStat[playerid][Cell]);
					return 1;
				}
				else
				{
					CellStat[PlayerStat[playerid][Cell]][CellWeap2] = weaponid;
					GetWeaponName(weaponid ,weaponname, sizeof(weaponname));
					format(str, sizeof(str), "You have deposited a %s inside your cell.", weaponname);
					SendClientMessage(playerid, GREY, str);
					SaveCell(PlayerStat[playerid][Cell]);
					return 1;
				}
			}
			if(GetWeaponSlot(playerid, GetPlayerWeapon(playerid)) == 11)
			{
				if(CellStat[PlayerStat[playerid][Cell]][CellLevel] == 2 && CellStat[PlayerStat[playerid][Cell]][CellWeap1] != 0) return SendClientMessage(playerid, GREY, "Your cell level is 2 so you can't have more than one weapons inside your cell.");
				if(CellStat[PlayerStat[playerid][Cell]][CellLevel] == 3 && CellStat[PlayerStat[playerid][Cell]][CellWeap1] != 0 && CellStat[PlayerStat[playerid][Cell]][CellWeap2] != 0) return SendClientMessage(playerid, GREY, "Your cell level is 3 so you can't have more than two weapons inside your cell.");
				new weaponid, ammo, weaponname[60];
				GetPlayerWeaponData(playerid, 11, weaponid, ammo);
				ResetPlayerWeapons(playerid);
				PlayerStat[playerid][Slot11] = 0;
				LoadPlayerWeapons(playerid);
				format(str, sizeof(str), "%s takes out something and hides it somewhere in the cell.", GetICName(playerid));
				SendNearByMessage(playerid, ACTION_COLOR, str, 3);
				if(CellStat[PlayerStat[playerid][Cell]][CellWeap1] == 0)
				{
					CellStat[PlayerStat[playerid][Cell]][CellWeap1] = weaponid;
					GetWeaponName(weaponid ,weaponname, sizeof(weaponname));
					format(str, sizeof(str), "You have deposited a %s inside your cell.", weaponname);
					SendClientMessage(playerid, GREY, str);
					SaveCell(PlayerStat[playerid][Cell]);
					return 1;
				}
				else
				{
					CellStat[PlayerStat[playerid][Cell]][CellWeap2] = weaponid;
					GetWeaponName(weaponid ,weaponname, sizeof(weaponname));
					format(str, sizeof(str), "You have deposited a %s inside your cell.", weaponname);
					SendClientMessage(playerid, GREY, str);
					SaveCell(PlayerStat[playerid][Cell]);
					return 1;
				}
			}
		}
    }
	SendClientMessage(playerid, GREY, "You are not near any cell.");
	return 1;
}

COMMAND:unlockcell(playerid, params[])
{
    new str[128];
	if(PlayerStat[playerid][FactionID] == 1)
	{
		if(PlayerStat[playerid][FactionRank] <= 5) return SendClientMessage(playerid, GREY, "Only rank 5 guards can unlock cells.");
		for(new c = 0; c < MAX_CELLS; c++)
		{
			if(IsPlayerInRangeOfPoint(playerid, 1.5, CellStat[c][ExteriorX], CellStat[c][ExteriorY], CellStat[c][ExteriorZ]))
			{
				if(CellStat[c][Locked] == 1)
				{
					CellStat[c][Locked] = 0;
					GameTextForPlayer(playerid, "~g~ Cell Unlocked", 3000, 4);
					format(str, sizeof(str), "%s takes out a master cell key and unlocks the cell.", GetICName(playerid));
					SendNearByMessage(playerid, ACTION_COLOR, str, 5);
				}
				SendClientMessage(playerid, GREY, "The cell is already unlocked.");
				return 1;
			}
		}
		SendClientMessage(playerid, GREY, "You are not near a cell.");
	}
	else
	{
		SendClientMessage(playerid, GREY, "Only guards can unlock cells.");
	}
    return 1;
}

COMMAND:cellcheck(playerid, params[])
{
    new str[128], weapname1[60], weapname2[60];
	if(PlayerStat[playerid][FactionID] == 1)
	{
		if(PlayerStat[playerid][FactionRank] <= 7) return SendClientMessage(playerid, GREY, "Only rank 8 guards can check cells.");
		for(new c = 0; c < MAX_CELLS; c++)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.5, CellStat[c][InteriorX], CellStat[c][InteriorY], CellStat[c][InteriorZ]))
			{
				new Weapon1 = CellStat[c][CellWeap1];
				new Weapon2 = CellStat[c][CellWeap2];
				GetWeaponName(Weapon1 ,weapname1, sizeof(weapname1));
				GetWeaponName(Weapon2, weapname2, sizeof(weapname2));
				if(Weapon1 == 0) { weapname1 = "None"; }
				if(Weapon2 == 0) { weapname2 = "None"; }
				SendClientMessage(playerid, GREY, "------------------------------------------------------------------------------------------------");
				format(str, sizeof(str), "Cell ID %d Stats:", c);
				SendClientMessage(playerid, GREY, str);
				format(str, sizeof(str), "Price: %d, Owner: %s, Level: %d.", CellStat[c][CellPrice], CellStat[c][CellOwner], CellStat[c][CellLevel]);
				SendClientMessage(playerid, GREY, str);
				format(str, sizeof(str), "Pot: %d, Crack: %d, Weapon 1: %s, Weapon 2: %s", CellStat[c][CellPot], CellStat[c][CellCrack], weapname1, weapname2);
				SendClientMessage(playerid, GREY, str);
				SendClientMessage(playerid, GREY, "------------------------------------------------------------------------------------------------");
			}
		}
	}
	else
	{
		SendClientMessage(playerid, GREY, "Only guards can check cells.");
	}
    return 1;
}

COMMAND:cellstats(playerid, params[])
{
	if(PlayerStat[playerid][HasCell] == 0) return SendClientMessage(playerid, GREY, "You don't own a cell.");
    new str[128], weapname1[60], weapname2[60];
	for(new c = 0; c < MAX_CELLS; c++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 5, CellStat[c][InteriorX], CellStat[c][InteriorY], CellStat[c][InteriorZ]) && c == PlayerStat[playerid][Cell])
		{
			new Weapon1 = CellStat[PlayerStat[playerid][Cell]][CellWeap1];
			new Weapon2 = CellStat[PlayerStat[playerid][Cell]][CellWeap2];
			GetWeaponName(Weapon1 ,weapname1, sizeof(weapname1));
			GetWeaponName(Weapon2, weapname2, sizeof(weapname2));
			if(Weapon1 == 0) { weapname1 = "None"; }
			if(Weapon2 == 0) { weapname2 = "None"; }
			SendClientMessage(playerid, LIGHT_GREEN, "______________________________________CELL STATS____________________________________");
			SendClientMessage(playerid, LIGHT_GREEN, "Your cell stats:");
			format(str, sizeof(str), "Price: %d, Level: %d.", CellStat[c][CellPrice], CellStat[c][CellLevel]);
			SendClientMessage(playerid, WHITE, str);
			format(str, sizeof(str), "Pot: %d, Crack: %d, Weapon 1: %s, Weapon 2: %s", CellStat[c][CellPot], CellStat[c][CellCrack], weapname1, weapname2);
			SendClientMessage(playerid, WHITE, str);
			SendClientMessage(playerid, LIGHT_GREEN, "_________________________________________________________________________________________________");
			return 1;
		}
	}
	SendClientMessage(playerid, GREY, "You are not near your cell.");
    return 1;
}

COMMAND:celldeposit(playerid, params[])
{
	if(PlayerStat[playerid][HasCell] == 0) return SendClientMessage(playerid, GREY, "You don't own a cell.");
	if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
	if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You can't deposit drugs due to your condition.");
	new str[128], quantity, option[6];
	for(new c = 0; c < MAX_CELLS; c++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, CellStat[c][InteriorX], CellStat[c][InteriorY], CellStat[c][InteriorZ]) && c == PlayerStat[playerid][Cell])
		{
			if(sscanf(params,"s[6]d", option, quantity)) return SendClientMessage(playerid, GREY, "USAGE: /celldeposit [pot/crack] [quantity]");
			else if(!strcmp(option, "pot", true))
			{
				if(PlayerStat[playerid][Pot] < quantity) return SendClientMessage(playerid, GREY, "You don't have that much.");
				if(CellStat[PlayerStat[playerid][Cell]][CellLevel] == 1)
				{
					if(0 < quantity <= 10)
					{
						if(CellStat[PlayerStat[playerid][Cell]][CellPot] + quantity > 10) return SendClientMessage(playerid, GREY, "Your cell level is 1 so you can't have more than 10 grams of pot in your cell.");
						PlayerStat[playerid][Pot] -= quantity;
						CellStat[PlayerStat[playerid][Cell]][CellPot] += quantity;
						format(str, sizeof(str), "%s takes out something and hides it somewhere in the cell.", GetICName(playerid));
						SendNearByMessage(playerid, ACTION_COLOR, str, 5);
						format(str, sizeof(str), "You have successfully deposited %d grams of pot inside your cell.", quantity);
						SendClientMessage(playerid, GREEN, str);
						SaveCell(PlayerStat[playerid][Cell]);
						return 1;
					}
					else return SendClientMessage(playerid, GREY, "Your cell level is 1 so you can't deposit more than 10 grams of pot.");
				}
				if(CellStat[PlayerStat[playerid][Cell]][CellLevel] == 2 || CellStat[PlayerStat[playerid][Cell]][CellLevel] == 3)
				{
					if(0 < quantity <= 20)
					{
						if(CellStat[PlayerStat[playerid][Cell]][CellPot] + quantity > 20) return SendClientMessage(playerid, GREY, "Your cell level is 2 or 3 so you can't have more than 20 grams of pot in your cell.");
						PlayerStat[playerid][Pot] -= quantity;
						CellStat[PlayerStat[playerid][Cell]][CellPot] += quantity;
						format(str, sizeof(str), "%s takes out something and hides it somewhere in the cell.", GetICName(playerid));
						SendNearByMessage(playerid, ACTION_COLOR, str, 5);
						format(str, sizeof(str), "You have successfully deposited %d grams of pot inside your cell.", quantity);
						SendClientMessage(playerid, GREEN, str);
						SaveCell(PlayerStat[playerid][Cell]);
						return 1;
					}
					else return SendClientMessage(playerid, GREY, "Your cell level is 2 or 3 so you can't deposit more than 20 grams of pot.");
				}
			}
			else if(!strcmp(option, "crack", true))
			{
				if(PlayerStat[playerid][Crack] < quantity) return SendClientMessage(playerid, GREY, "You don't have that much.");
				if(CellStat[PlayerStat[playerid][Cell]][CellLevel] == 1)
				{
					if(0 < quantity <= 7)
					{
						if(CellStat[PlayerStat[playerid][Cell]][CellCrack] + quantity > 7) return SendClientMessage(playerid, GREY, "Your cell level is 1 so you can't have more than 7 grams of crack in your cell.");
						PlayerStat[playerid][Crack] -= quantity;
						CellStat[PlayerStat[playerid][Cell]][CellCrack] += quantity;
						format(str, sizeof(str), "%s takes out something and hides it somewhere in the cell.", GetICName(playerid));
						SendNearByMessage(playerid, ACTION_COLOR, str, 5);
						format(str, sizeof(str), "You have successfully deposited %d grams of crack inside your cell.", quantity);
						SendClientMessage(playerid, GREEN, str);
						SaveCell(PlayerStat[playerid][Cell]);
						return 1;
					}
					else return SendClientMessage(playerid, GREY, "Your cell level is 1 so you can't deposit more than 7 grams of crack.");
				}
				if(CellStat[PlayerStat[playerid][Cell]][CellLevel] == 2 || CellStat[PlayerStat[playerid][Cell]][CellLevel] == 3)
				{
					if(0 < quantity <= 12)
					{
						if(CellStat[PlayerStat[playerid][Cell]][CellCrack] + quantity > 12) return SendClientMessage(playerid, GREY, "Your cell level is 2 or 3 so you can't have more than 12 grams of crack in your cell.");
						PlayerStat[playerid][Crack] -= quantity;
						CellStat[PlayerStat[playerid][Cell]][CellCrack] += quantity;
						format(str, sizeof(str), "%s takes out something and hides it somewhere in the cell.", GetICName(playerid));
						SendNearByMessage(playerid, ACTION_COLOR, str, 5);
						format(str, sizeof(str), "You have successfully deposited %d grams of crack inside your cell.", quantity);
						SendClientMessage(playerid, GREEN, str);
						SaveCell(PlayerStat[playerid][Cell]);
						return 1;
					}
					else return SendClientMessage(playerid, GREY, "Your cell level is 2 or 3 so you can't deposit more than 12 grams of crack in your cell.");
				}
			}
			else return SendClientMessage(playerid, GREY, "Invalid option.");
		}
	}
	SendClientMessage(playerid, GREY, "You are not near your cell.");
    return 1;
}

COMMAND:cellwithdraw(playerid, params[])
{
	if(PlayerStat[playerid][HasCell] == 0) return SendClientMessage(playerid, GREY, "You don't own a cell.");
	if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
	if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You can't deposit drugs due to your condition.");
	new str[128], quantity, option[6];
    if(sscanf(params,"s[6]d", option, quantity)) return SendClientMessage(playerid, GREY, "USAGE: /cellwithdraw [pot/crack] [quantity]");
	for(new c = 0; c < MAX_CELLS; c++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, CellStat[c][InteriorX], CellStat[c][InteriorY], CellStat[c][InteriorZ]) && c == PlayerStat[playerid][Cell])
		{
			if(!strcmp(option, "pot", true))
			{
				if(!IsPlayerInRangeOfPoint(playerid, 1.0, CellStat[c][ExteriorX], CellStat[c][ExteriorY], CellStat[c][ExteriorZ]) && GetPlayerVirtualWorld(playerid) == 0) return SendClientMessage(playerid, GREY, "You are not near your cell.");
				if(CellStat[PlayerStat[playerid][Cell]][CellPot] < quantity) return SendClientMessage(playerid, GREY, "You don't have that much in your cell.");
				if(PlayerStat[playerid][Pot] == 5) return SendClientMessage(playerid, GREY, "You can't hold more than 5g of pot.");
				if(PlayerStat[playerid][Pot] + quantity > 5) return SendClientMessage(playerid, GREY, "You can't hold more than 5g of pot.");
				else
				{
					PlayerStat[playerid][Pot] += quantity;
					CellStat[PlayerStat[playerid][Cell]][CellPot] -= quantity;
					format(str, sizeof(str), "%s takes something from his cell.", GetICName(playerid));
					SendNearByMessage(playerid, ACTION_COLOR, str, 3);
					format(str, sizeof(str), "You have successfully withdrawed %d grams of pot from your cell.", quantity);
					SendClientMessage(playerid, GREEN, str);
					SaveCell(PlayerStat[playerid][Cell]);
					return 1;
				}
			}
			else if(!strcmp(option, "crack", true))
			{
				if(!IsPlayerInRangeOfPoint(playerid, 1.0, CellStat[c][ExteriorX], CellStat[c][ExteriorY], CellStat[c][ExteriorZ]) && GetPlayerVirtualWorld(playerid) == 0) return SendClientMessage(playerid, GREY, "You are not near your cell.");
				if(CellStat[PlayerStat[playerid][Cell]][CellCrack] < quantity) return SendClientMessage(playerid, GREY, "You don't have that much in your cell.");
				if(PlayerStat[playerid][Crack] == 4) return SendClientMessage(playerid, GREY, "You can't hold more than 4g of crack.");
				if(PlayerStat[playerid][Crack] + quantity > 4) return SendClientMessage(playerid, GREY, "You can't hold more than 4g of crack.");
				else
				{
					format(str, sizeof(str), "%s takes something from his cell.", GetICName(playerid));
					SendNearByMessage(playerid, ACTION_COLOR, str, 3);
					PlayerStat[playerid][Crack] += quantity;
					CellStat[PlayerStat[playerid][Cell]][CellCrack] -= quantity;
					format(str, sizeof(str), "You have successfully withdrawed %d grams of crack from your cell.", quantity);
					SendClientMessage(playerid, GREEN, str);
					SaveCell(PlayerStat[playerid][Cell]);
					return 1;
				}
			}
			else return SendClientMessage(playerid, GREY, "Invalid option.");
		}
	}
    return 1;
}

COMMAND:takeweapon(playerid, params[])
{
	if(PlayerStat[playerid][HasCell] == 0) return SendClientMessage(playerid, GREY, "You don't own a cell.");
	if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
	if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You can't deposit drugs due to your condition.");
	new str[128], slot;
    if(sscanf(params,"d", slot)) return SendClientMessage(playerid, GREY, "USAGE: /takeweapon [weaponslot]");
	for(new c = 0; c < MAX_CELLS; c++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, CellStat[c][InteriorX], CellStat[c][InteriorY], CellStat[c][InteriorZ]) && c == PlayerStat[playerid][Cell])
		{
			if(slot == 1)
			{
				if(CellStat[PlayerStat[playerid][Cell]][CellWeap1] != 0)
				{
					new weaponname[60];
					ServerWeapon(playerid, CellStat[PlayerStat[playerid][Cell]][CellWeap1], 1);
					format(str, sizeof(str), "%s takes something from his cell.", GetICName(playerid));
					SendNearByMessage(playerid, ACTION_COLOR, str, 3);
					GetWeaponName(CellStat[PlayerStat[playerid][Cell]][CellWeap1] ,weaponname, sizeof(weaponname));
					format(str, sizeof(str), "You have withdrawed a %s inside of your cell.", weaponname);
					SendClientMessage(playerid, GREY, str);
					CellStat[PlayerStat[playerid][Cell]][CellWeap1] = 0;
					SaveCell(PlayerStat[playerid][Cell]);
					if(GetWeaponSlot(playerid, GetPlayerWeapon(playerid)) == 1) return PlayerStat[playerid][Slot1] == CellStat[PlayerStat[playerid][Cell]][CellWeap1];
					if(GetWeaponSlot(playerid, GetPlayerWeapon(playerid)) == 2) return PlayerStat[playerid][Slot2] == CellStat[PlayerStat[playerid][Cell]][CellWeap1];
					if(GetWeaponSlot(playerid, GetPlayerWeapon(playerid)) == 3) return PlayerStat[playerid][Slot3] == CellStat[PlayerStat[playerid][Cell]][CellWeap1];
					if(GetWeaponSlot(playerid, GetPlayerWeapon(playerid)) == 4) return PlayerStat[playerid][Slot4] == CellStat[PlayerStat[playerid][Cell]][CellWeap1];
					if(GetWeaponSlot(playerid, GetPlayerWeapon(playerid)) == 5) return PlayerStat[playerid][Slot5] == CellStat[PlayerStat[playerid][Cell]][CellWeap1];
					if(GetWeaponSlot(playerid, GetPlayerWeapon(playerid)) == 6) return PlayerStat[playerid][Slot6] == CellStat[PlayerStat[playerid][Cell]][CellWeap1];
					if(GetWeaponSlot(playerid, GetPlayerWeapon(playerid)) == 7) return PlayerStat[playerid][Slot7] == CellStat[PlayerStat[playerid][Cell]][CellWeap1];
					if(GetWeaponSlot(playerid, GetPlayerWeapon(playerid)) == 8) return PlayerStat[playerid][Slot8] == CellStat[PlayerStat[playerid][Cell]][CellWeap1];
					if(GetWeaponSlot(playerid, GetPlayerWeapon(playerid)) == 9) return PlayerStat[playerid][Slot9] == CellStat[PlayerStat[playerid][Cell]][CellWeap1];
					if(GetWeaponSlot(playerid, GetPlayerWeapon(playerid)) == 10) return PlayerStat[playerid][Slot10] == CellStat[PlayerStat[playerid][Cell]][CellWeap1];
					if(GetWeaponSlot(playerid, GetPlayerWeapon(playerid)) == 11) return PlayerStat[playerid][Slot11] == CellStat[PlayerStat[playerid][Cell]][CellWeap1];
					return 1;
				}
				else return SendClientMessage(playerid, GREY, "There is no weapon stored in the first weapon slot of your cell.");
			}
			else if(slot == 2)
			{
				if(CellStat[PlayerStat[playerid][Cell]][CellWeap2] != 0)
				{
					new weaponname[60];
					ServerWeapon(playerid, CellStat[PlayerStat[playerid][Cell]][CellWeap2], 1);
					format(str, sizeof(str), "%s takes something from his cell.", GetICName(playerid));
					SendNearByMessage(playerid, ACTION_COLOR, str, 3);
					GetWeaponName(CellStat[PlayerStat[playerid][Cell]][CellWeap2] ,weaponname, sizeof(weaponname));
					format(str, sizeof(str), "You have withdrawed a %s inside of your cell.", weaponname);
					SendClientMessage(playerid, GREY, str);
					CellStat[PlayerStat[playerid][Cell]][CellWeap2] = 0;
					SaveCell(PlayerStat[playerid][Cell]);
					if(GetWeaponSlot(playerid, GetPlayerWeapon(playerid)) == 1) return PlayerStat[playerid][Slot1] == CellStat[PlayerStat[playerid][Cell]][CellWeap2];
					if(GetWeaponSlot(playerid, GetPlayerWeapon(playerid)) == 2) return PlayerStat[playerid][Slot2] == CellStat[PlayerStat[playerid][Cell]][CellWeap2];
					if(GetWeaponSlot(playerid, GetPlayerWeapon(playerid)) == 3) return PlayerStat[playerid][Slot3] == CellStat[PlayerStat[playerid][Cell]][CellWeap2];
					if(GetWeaponSlot(playerid, GetPlayerWeapon(playerid)) == 4) return PlayerStat[playerid][Slot4] == CellStat[PlayerStat[playerid][Cell]][CellWeap2];
					if(GetWeaponSlot(playerid, GetPlayerWeapon(playerid)) == 5) return PlayerStat[playerid][Slot5] == CellStat[PlayerStat[playerid][Cell]][CellWeap2];
					if(GetWeaponSlot(playerid, GetPlayerWeapon(playerid)) == 6) return PlayerStat[playerid][Slot6] == CellStat[PlayerStat[playerid][Cell]][CellWeap2];
					if(GetWeaponSlot(playerid, GetPlayerWeapon(playerid)) == 7) return PlayerStat[playerid][Slot7] == CellStat[PlayerStat[playerid][Cell]][CellWeap2];
					if(GetWeaponSlot(playerid, GetPlayerWeapon(playerid)) == 8) return PlayerStat[playerid][Slot8] == CellStat[PlayerStat[playerid][Cell]][CellWeap2];
					if(GetWeaponSlot(playerid, GetPlayerWeapon(playerid)) == 9) return PlayerStat[playerid][Slot9] == CellStat[PlayerStat[playerid][Cell]][CellWeap2];
					if(GetWeaponSlot(playerid, GetPlayerWeapon(playerid)) == 10) return PlayerStat[playerid][Slot10] == CellStat[PlayerStat[playerid][Cell]][CellWeap2];
					if(GetWeaponSlot(playerid, GetPlayerWeapon(playerid)) == 11) return PlayerStat[playerid][Slot11] == CellStat[PlayerStat[playerid][Cell]][CellWeap2];
					return 1;
				}
				else return SendClientMessage(playerid, GREY, "There is no weapon stored in the second weapon slot of your cell.");
			}
		}
	}
	SendClientMessage(playerid, GREY, "You don't own a cell.");
    return 1;
}

//-----------------------------------------------------------------------[Admin Commands]------------------------------------------------------------------------------
COMMAND:ahelp(playerid, params[])
{
	if(PlayerStat[playerid][AdminLevel] == 1)
	{
		SendClientMessage(playerid, GREEN, "---------------------------------------------------[Junior Administrator]-----------------------------------------------------");
		SendClientMessage(playerid, WHITE, "/aduty /a /ha /gotoprison /(un)mute /getmaskname /kick /arevive /spec(off) /(un)freeze /slap /check /checkinv /checkwarnings.");
		SendClientMessage(playerid, WHITE, "/checkcell /checkweapons /am /reportmute /goto /get /setinterior /setvirtualworld /go /send /(un)ajail /gotocell /set /answerapp.");
		SendClientMessage(playerid, WHITE, "/checkapps /reviewapp /acceptreport");
		SendClientMessage(playerid, GREEN, "------------------------------------------------------------------------------------------------------------------------------------------------");
	}
	else if(PlayerStat[playerid][AdminLevel] == 2)
	{
		SendClientMessage(playerid, GREEN, "----------------------------------------------------[Administrator]----------------------------------------------------");
		SendClientMessage(playerid, WHITE, "/aduty /a /ha /gotoprison /(un)mute /getmaskname /kick /arevive /spec(off) /(un)freeze /slap /check /checkinv /checkwarnings.");
		SendClientMessage(playerid, WHITE, "/checkcell /checkweapons /am /reportmute /goto /get /setinterior /setvirtualworld /go /send /(un)ajail /gotocell /set /answerapp.");
		SendClientMessage(playerid, WHITE, "/checkapps /reviewapp /acceptreport /skick /fixjob /toggleooc /ban /warn /setweather");
		SendClientMessage(playerid, GREEN, "------------------------------------------------------------------------------------------------------------------------------------------------");
	}
	else if(PlayerStat[playerid][AdminLevel] == 3)
	{
		SendClientMessage(playerid, GREEN, "------------------------------------------------------[Senior Administrator]------------------------------------------------------");
		SendClientMessage(playerid, WHITE, "/aduty /a /ha /gotoprison /(un)mute /getmaskname /kick /arevive /spec(off) /(un)freeze /slap /check /checkinv /checkwarnings.");
		SendClientMessage(playerid, WHITE, "/checkcell /checkweapons /am /reportmute /goto /get /setinterior /setvirtualworld /go /send /(un)ajail /gotocell /set /answerapp.");
		SendClientMessage(playerid, WHITE, "/checkapps /reviewapp /acceptreport /skick /fixjob /toggleooc /ban /warn /setweather /(stop)trackpms /respawnvehicles /hiddenadmin");
		SendClientMessage(playerid, WHITE, "/gotopos /banip /offlineban /offlineajail");
		SendClientMessage(playerid, GREEN, "------------------------------------------------------------------------------------------------------------------------------------------------");
	}
	else if(PlayerStat[playerid][AdminLevel] == 4 && PlayerStat[playerid][HelperLevel] == 2)
	{
		SendClientMessage(playerid, GREEN, "-------------------------------------------[Lead Administrator | Head of Helpers]---------------------------------------");
		SendClientMessage(playerid, WHITE, "/aduty /a /ha /gotoprison /(un)mute /getmaskname /kick /arevive /spec(off) /(un)freeze /slap /check /checkinv /checkwarnings.");
		SendClientMessage(playerid, WHITE, "/checkcell /checkweapons /am /reportmute /goto /get /setinterior /setvirtualworld /go /send /(un)ajail /gotocell /set /answerapp.");
		SendClientMessage(playerid, WHITE, "/checkapps /reviewapp /acceptreport /skick /fixjob /toggleooc /(un)ban /warn /setweather /(stop)trackpms /respawnvehicles /hiddenadmin");
		SendClientMessage(playerid, WHITE, "/gotopos /(un)banip /offlineban /offlineajail /giveitem /giveweapon /makegangleader /forcepc /resetgang /applications");
		SendClientMessage(playerid, WHITE, "Please refer to using /hhelp for your Head of Helpers commands.");
		SendClientMessage(playerid, GREEN, "------------------------------------------------------------------------------------------------------------------------------------------------");
		return 1;
	}
	else if(PlayerStat[playerid][AdminLevel] == 4)
	{
		SendClientMessage(playerid, GREEN, "-------------------------------------------------------[Lead Administrator]-------------------------------------------------------");
		SendClientMessage(playerid, WHITE, "/aduty /a /ha /gotoprison /(un)mute /getmaskname /kick /arevive /spec(off) /(un)freeze /slap /check /checkinv /checkwarnings.");
		SendClientMessage(playerid, WHITE, "/checkcell /checkweapons /am /reportmute /goto /get /setinterior /setvirtualworld /go /send /(un)ajail /gotocell /set /answerapp.");
		SendClientMessage(playerid, WHITE, "/checkapps /reviewapp /acceptreport /skick /fixjob /toggleooc /(un)ban /warn /setweather /(stop)trackpms /respawnvehicles /hiddenadmin");
		SendClientMessage(playerid, WHITE, "/gotopos /(un)banip /offlineban /offlineajail /giveitem /giveweapon /makegangleader /forcepc /resetgang /applications");
		SendClientMessage(playerid, GREEN, "------------------------------------------------------------------------------------------------------------------------------------------------");
	}
	else if(PlayerStat[playerid][AdminLevel] == 5)
	{
		SendClientMessage(playerid, GREEN, "-------------------------------------------------------[Community Director]-------------------------------------------------------");
		SendClientMessage(playerid, WHITE, "/aduty /a /ha /gotoprison /(un)mute /getmaskname /kick /arevive /spec(off) /(un)freeze /slap /check /checkinv /checkwarnings.");
		SendClientMessage(playerid, WHITE, "/checkcell /checkweapons /am /reportmute /goto /get /setinterior /setvirtualworld /go /send /(un)ajail /gotocell /set /answerapp.");
		SendClientMessage(playerid, WHITE, "/checkapps /reviewapp /acceptreport /skick /fixjob /toggleooc /(un)ban /warn /setweather /(stop)trackpms /respawnvehicles /hiddenadmin");
		SendClientMessage(playerid, WHITE, "/gotopos /(un)banip /offlineban /offlineajail /giveitem /giveweapon /makegangleader /forcepc /resetgang /applications");
		SendClientMessage(playerid, WHITE, "/setdonator /cc /spawncar /explode /makehelepr /makeleader /createcell(2) /setcelllevel /gmx /reloadmap /makeadmin /hostname");
		SendClientMessage(playerid, WHITE, "/setaname /removeaccount");
		SendClientMessage(playerid, GUARDS_RADIO, "FUN COMMANDS:");
		SendClientMessage(playerid, WHITE, "/playmusicp /playmusica.");
		SendClientMessage(playerid, GREEN, "------------------------------------------------------------------------------------------------------------------------------------------------");
	}
	else if(PlayerStat[playerid][AdminLevel] == 0)
	{
		SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	}
    return 1;
}

COMMAND:ah(playerid, params[])
{
	if(PlayerStat[playerid][AdminLevel] == 1)
	{
		SendClientMessage(playerid, GREEN, "---------------------------------------------------[Junior Administrator]-----------------------------------------------------");
		SendClientMessage(playerid, WHITE, "/aduty /a /ha /gotoprison /(un)mute /getmaskname /kick /arevive /spec(off) /(un)freeze /slap /check /checkinv /checkwarnings.");
		SendClientMessage(playerid, WHITE, "/checkcell /checkweapons /am /reportmute /goto /get /setinterior /setvirtualworld /go /send /(un)ajail /gotocell /set /answerapp.");
		SendClientMessage(playerid, WHITE, "/checkapps /reviewapp /acceptreport");
		SendClientMessage(playerid, GREEN, "------------------------------------------------------------------------------------------------------------------------------------------------");
	}
	else if(PlayerStat[playerid][AdminLevel] == 2)
	{
		SendClientMessage(playerid, GREEN, "----------------------------------------------------[Administrator]----------------------------------------------------");
		SendClientMessage(playerid, WHITE, "/aduty /a /ha /gotoprison /(un)mute /getmaskname /kick /arevive /spec(off) /(un)freeze /slap /check /checkinv /checkwarnings.");
		SendClientMessage(playerid, WHITE, "/checkcell /checkweapons /am /reportmute /goto /get /setinterior /setvirtualworld /go /send /(un)ajail /gotocell /set /answerapp.");
		SendClientMessage(playerid, WHITE, "/checkapps /reviewapp /acceptreport /skick /fixjob /toggleooc /ban /warn /setweather");
		SendClientMessage(playerid, GREEN, "------------------------------------------------------------------------------------------------------------------------------------------------");
	}
	else if(PlayerStat[playerid][AdminLevel] == 3)
	{
		SendClientMessage(playerid, GREEN, "------------------------------------------------------[Senior Administrator]------------------------------------------------------");
		SendClientMessage(playerid, WHITE, "/aduty /a /ha /gotoprison /(un)mute /getmaskname /kick /arevive /spec(off) /(un)freeze /slap /check /checkinv /checkwarnings.");
		SendClientMessage(playerid, WHITE, "/checkcell /checkweapons /am /reportmute /goto /get /setinterior /setvirtualworld /go /send /(un)ajail /gotocell /set /answerapp.");
		SendClientMessage(playerid, WHITE, "/checkapps /reviewapp /acceptreport /skick /fixjob /toggleooc /ban /warn /setweather /(stop)trackpms /respawnvehicles /hiddenadmin");
		SendClientMessage(playerid, WHITE, "/gotopos /banip /offlineban /offlineajail");
		SendClientMessage(playerid, GREEN, "------------------------------------------------------------------------------------------------------------------------------------------------");
	}
	else if(PlayerStat[playerid][AdminLevel] == 4 && PlayerStat[playerid][HelperLevel] == 2)
	{
		SendClientMessage(playerid, GREEN, "-------------------------------------------[Lead Administrator | Head of Helpers]---------------------------------------");
		SendClientMessage(playerid, WHITE, "/aduty /a /ha /gotoprison /(un)mute /getmaskname /kick /arevive /spec(off) /(un)freeze /slap /check /checkinv /checkwarnings.");
		SendClientMessage(playerid, WHITE, "/checkcell /checkweapons /am /reportmute /goto /get /setinterior /setvirtualworld /go /send /(un)ajail /gotocell /set /answerapp.");
		SendClientMessage(playerid, WHITE, "/checkapps /reviewapp /acceptreport /skick /fixjob /toggleooc /(un)ban /warn /setweather /(stop)trackpms /respawnvehicles /hiddenadmin");
		SendClientMessage(playerid, WHITE, "/gotopos /(un)banip /offlineban /offlineajail /giveitem /giveweapon /makegangleader /forcepc /resetgang /applications");
		SendClientMessage(playerid, WHITE, "Please refer to using /hhelp for your Head of Helpers commands.");
		SendClientMessage(playerid, GREEN, "------------------------------------------------------------------------------------------------------------------------------------------------");
		return 1;
	}
	else if(PlayerStat[playerid][AdminLevel] == 4)
	{
		SendClientMessage(playerid, GREEN, "-------------------------------------------------------[Lead Administrator]-------------------------------------------------------");
		SendClientMessage(playerid, WHITE, "/aduty /a /ha /gotoprison /(un)mute /getmaskname /kick /arevive /spec(off) /(un)freeze /slap /check /checkinv /checkwarnings.");
		SendClientMessage(playerid, WHITE, "/checkcell /checkweapons /am /reportmute /goto /get /setinterior /setvirtualworld /go /send /(un)ajail /gotocell /set /answerapp.");
		SendClientMessage(playerid, WHITE, "/checkapps /reviewapp /acceptreport /skick /fixjob /toggleooc /(un)ban /warn /setweather /(stop)trackpms /respawnvehicles /hiddenadmin");
		SendClientMessage(playerid, WHITE, "/gotopos /(un)banip /offlineban /offlineajail /giveitem /giveweapon /makegangleader /forcepc /resetgang /applications");
		SendClientMessage(playerid, GREEN, "------------------------------------------------------------------------------------------------------------------------------------------------");
	}
	else if(PlayerStat[playerid][AdminLevel] == 5)
	{
		SendClientMessage(playerid, GREEN, "-------------------------------------------------------[Community Director]-------------------------------------------------------");
		SendClientMessage(playerid, WHITE, "/aduty /a /ha /gotoprison /(un)mute /getmaskname /kick /arevive /spec(off) /(un)freeze /slap /check /checkinv /checkwarnings.");
		SendClientMessage(playerid, WHITE, "/checkcell /checkweapons /am /reportmute /goto /get /setinterior /setvirtualworld /go /send /(un)ajail /gotocell /set /answerapp.");
		SendClientMessage(playerid, WHITE, "/checkapps /reviewapp /acceptreport /skick /fixjob /toggleooc /(un)ban /warn /setweather /(stop)trackpms /respawnvehicles /hiddenadmin");
		SendClientMessage(playerid, WHITE, "/gotopos /(un)banip /offlineban /offlineajail /giveitem /giveweapon /makegangleader /forcepc /resetgang /applications");
		SendClientMessage(playerid, WHITE, "/setdonator /cc /spawncar /explode /makehelepr /makeleader /createcell(2) /setcelllevel /gmx /reloadmap /makeadmin /hostname");
		SendClientMessage(playerid, WHITE, "/setaname /removeaccount");
		SendClientMessage(playerid, GUARDS_RADIO, "FUN COMMANDS:");
		SendClientMessage(playerid, WHITE, "/playmusicp /playmusica.");
		SendClientMessage(playerid, GREEN, "------------------------------------------------------------------------------------------------------------------------------------------------");
	}
	else if(PlayerStat[playerid][AdminLevel] == 0)
	{
		SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	}
    return 1;
}

COMMAND:hhelp(playerid, params[])
{
	if(PlayerStat[playerid][HelperLevel] == 1)
	{
		SendClientMessage(playerid, GREEN, "----------------------[Helper]----------------------");
		SendClientMessage(playerid, WHITE, "/hduty /hc /ha /unfreeze /hset /hpm /accepthelpme /answerapp /checkapps /rewviewapp");
		SendClientMessage(playerid, GREEN, "-----------------------------------------------------");
	}
	else if(PlayerStat[playerid][HelperLevel] == 2)
	{
		SendClientMessage(playerid, GREEN, "--------------------[Head of Helpers]--------------------");
		SendClientMessage(playerid, WHITE, "/hduty /hc /ha /unfreeze /hset /hpm /accepthelpme /makehelper /checkhelpmes.");
		SendClientMessage(playerid, GREEN, "-----------------------------------------------------");
	}
	else if(PlayerStat[playerid][HelperLevel] == 0)
	{
		SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	}
    return 1;
}

COMMAND:hh(playerid, params[])
{
	if(PlayerStat[playerid][HelperLevel] == 1)
	{
		SendClientMessage(playerid, GREEN, "----------------------[Helper]----------------------");
		SendClientMessage(playerid, WHITE, "/hc /ha /hduty /fixplayer /hpm /unfreeze /hset /accepthelpme.");
		SendClientMessage(playerid, GREEN, "-----------------------------------------------------");
	}
	else if(PlayerStat[playerid][HelperLevel] == 2)
	{
		SendClientMessage(playerid, GREEN, "--------------------[Head of Helpers]--------------------");
		SendClientMessage(playerid, WHITE, "/hc /ha /hduty /fixplayer /hpm /unfreeze /hset /accepthelpme /makehelper /checkhelpmes.");
		SendClientMessage(playerid, GREEN, "-----------------------------------------------------");
	}
	else if(PlayerStat[playerid][HelperLevel] == 0)
	{
		SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	}
    return 1;
}

COMMAND:ra(playerid, params[])
{
	new message[128], str[128];
	if(PlayerStat[playerid][ReportMuted] == 1) return SendClientMessage(playerid, GREY, "You are muted from sending reports/requests.");
    if(sscanf(params,"s[128]", message))return SendClientMessage(playerid, GREY, "USAGE: /r{equest}a{dmin} [message]");
    if(PlayerStat[playerid][ReportReloadTime] > 1) return SendClientMessage(playerid, GREY, "You must wait 25 seconds before sending another report.");
	format(str, sizeof(str), "[Admin Request] %s (ID: %d): %s", GetOOCName(playerid), playerid, message);
	SendAdminMessage(LIGHT_GREEN, str);
	format(str, sizeof(str), "[Admin Request] Type /acceptrequest %d to accept the admin request.", playerid);
	SendAdminMessage(LIGHT_GREEN, str);
	PlayerStat[playerid][ReportReloadTime] = 25;
	AwaitingAdmin[playerid] = 1;
	format(str, sizeof(str), "[Admin Request] %s: %s", GetOOCName(playerid), message);
	ReportLog(str);
	SendClientMessage(playerid, RED, "You have successfully sent an admin request to the online admins.");
    return 1;
}

COMMAND:requestadmin(playerid, params[])
{
	new message[128], str[128];
	if(PlayerStat[playerid][ReportMuted] == 1) return SendClientMessage(playerid, GREY, "You are muted from sending reports/requests.");
    if(sscanf(params,"s[128]", message))return SendClientMessage(playerid, GREY, "USAGE: /requestadmin [message]");
    if(PlayerStat[playerid][ReportReloadTime] > 1) return SendClientMessage(playerid, GREY, "You must wait 25 seconds before sending another report.");
	format(str, sizeof(str), "[Admin Request] %s (ID: %d): %s", GetOOCName(playerid), playerid, message);
	SendAdminMessage(LIGHT_GREEN, str);
	format(str, sizeof(str), "[Admin Request] Type /acceptrequest %d to accept the admin request.", playerid);
	SendAdminMessage(LIGHT_GREEN, str);
	PlayerStat[playerid][ReportReloadTime] = 25;
	AwaitingAdmin[playerid] = 1;
	format(str, sizeof(str), "[Admin Request] %s: %s", GetOOCName(playerid), message);
	ReportLog(str);
	SendClientMessage(playerid, RED, "You have successfully sent an admin request to the online admins.");
    return 1;
}

COMMAND:maskreport(playerid, params[])
{
	new str[128], maskid, reason[128], targetid;
	if(PlayerStat[playerid][ReportMuted] == 1) return SendClientMessage(playerid, GREY, "You are muted from sending reports.");
	if(PlayerStat[playerid][ReportReloadTime] > 1) return SendClientMessage(playerid, GREY, "You must wait 60 seconds before sending another report.");
	if(sscanf(params,"ds[128]", maskid, reason)) return SendClientMessage(playerid, GREY, "USAGE: /maskreport [playerid] [reason]");
	if(maskid < 0 || maskid >= 10000) return SendClientMessage(playerid, GREY, "Invalid Mask ID");
	targetid = 0;
	look_for_mask:
	if(targetid > MAX_PLAYERS) return SendClientMessage(playerid, LIGHT_RED, "Invalid/Unknown Mask ID.");
	if(IsPlayerConnected(targetid) && Masked[targetid] == 1 && MaskName[targetid] == maskid)
	{
		if(playerid == targetid) return SendClientMessage(playerid, GREY, "You can't use this command on yourself.");
		format(str, sizeof(str), "[REPORT] %s (ID: %d) reported %s (ID: %d).", GetOOCName(playerid), playerid, GetOOCName(targetid), targetid);
		SendAdminMessage(GREEN, str);
		format(str, sizeof(str), "[REPORT] reason: {FFFFFF}%s.", reason);
		SendAdminMessage(GREEN, str);
		format(str, sizeof(str), "[REPORT] Type /acceptreport %d (/arp %d) to accept it.", playerid, playerid);
		SendAdminMessage(GREEN, str);
		AwaitingReport[playerid] = 1;
		format(str, sizeof(str), "[REPORT] %s reported %s: %s.", GetOOCName(playerid), GetOOCName(targetid), reason);
		ReportLog(str);
		SendClientMessage(playerid, LIGHT_GREEN, "You have successfully sent a report, please be patient.");
		PlayerStat[playerid][ReportReloadTime] = 60;
		return 1;
	}
	else
	{
		targetid++;
		goto look_for_mask;
	}
	return 1;
}

COMMAND:mreport(playerid, params[])
{
	new str[128], maskid, reason[128], targetid;
	if(PlayerStat[playerid][ReportMuted] == 1) return SendClientMessage(playerid, GREY, "You are muted from sending reports.");
	if(PlayerStat[playerid][ReportReloadTime] > 1) return SendClientMessage(playerid, GREY, "You must wait 60 seconds before sending another report.");
	if(sscanf(params,"ds[128]", maskid, reason)) return SendClientMessage(playerid, GREY, "USAGE: /mreport [playerid] [reason]");
	if(maskid < 0 || maskid >= 10000) return SendClientMessage(playerid, GREY, "Invalid Mask ID");
	targetid = 0;
	look_for_mask:
	if(targetid > MAX_PLAYERS) return SendClientMessage(playerid, LIGHT_RED, "Invalid/Unknown Mask ID.");
	if(IsPlayerConnected(targetid) && Masked[targetid] == 1 && MaskName[targetid] == maskid)
	{
		if(playerid == targetid) return SendClientMessage(playerid, GREY, "You can't use this command on yourself.");
		format(str, sizeof(str), "[REPORT] %s (ID: %d) reported %s (ID: %d).", GetOOCName(playerid), playerid, GetOOCName(targetid), targetid);
		SendAdminMessage(GREEN, str);
		format(str, sizeof(str), "[REPORT] reason: {FFFFFF}%s.", reason);
		SendAdminMessage(GREEN, str);
		format(str, sizeof(str), "[REPORT] Type /acceptreport %d (/arp %d) to accept it.", playerid, playerid);
		SendAdminMessage(GREEN, str);
		AwaitingReport[playerid] = 1;
		format(str, sizeof(str), "[REPORT] %s reported %s: %s.", GetOOCName(playerid), GetOOCName(targetid), reason);
		ReportLog(str);
		SendClientMessage(playerid, LIGHT_GREEN, "You have successfully sent a report, please be patient.");
		PlayerStat[playerid][ReportReloadTime] = 60;
		return 1;
	}
	else
	{
		targetid++;
		goto look_for_mask;
	}
	return 1;
}

COMMAND:report(playerid, params[])
{
	new str[128], targetid, reason[128];
	if(PlayerStat[playerid][ReportMuted] == 1) return SendClientMessage(playerid, GREY, "You are muted from sending reports.");
	if(sscanf(params,"us[128]", targetid, reason)) return SendClientMessage(playerid, GREY, "USAGE: /report [playerid] [reason]");
	if(playerid == targetid) return SendClientMessage(playerid, GREY, "You can't use this command on yourself.");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(PlayerStat[playerid][ReportReloadTime] > 1) return SendClientMessage(playerid, GREY, "You must wait 60 seconds before sending another report.");
	format(str, sizeof(str), "[REPORT] %s (ID: %d) reported %s (ID: %d).", GetOOCName(playerid), playerid, GetOOCName(targetid), targetid);
	SendAdminMessage(GREEN, str);
	format(str, sizeof(str), "[REPORT] reason: {FFFFFF}%s.", reason);
	SendAdminMessage(GREEN, str);
	format(str, sizeof(str), "[REPORT] Type /acceptreport %d (/arp %d) to accept it.", playerid, playerid);
	SendAdminMessage(GREEN, str);
	AwaitingReport[playerid] = 1;
	format(str, sizeof(str), "[REPORT] %s reported %s: %s.", GetOOCName(playerid), GetOOCName(targetid), reason);
	ReportLog(str);
	SendClientMessage(playerid, LIGHT_GREEN, "You have successfully sent a report, please be patient.");
	PlayerStat[playerid][ReportReloadTime] = 60;
    return 1;
}

COMMAND:helpers(playerid, params[])
{
	new str[128], amount;
	amount = 0;
	SendClientMessage(playerid, GREY, "________________________________________");
	SendClientMessage(playerid, GREEN, "	                   Online Helpers:");
	for(new i = 0; i < MAX_PLAYERS; i++)
    {
		if(IsPlayerConnected(i) && PlayerStat[i][HelperLevel] >= 1 && HiddenAdmin[i] == 0 && PlayerStat[i][Spawned] == 1)
		{
			if(PlayerStat[i][HelperLevel] == 2)
			{
				format(str, sizeof(str), "(%s), Level %d %s.", GetForumName(i), PlayerStat[i][HelperLevel], Gethlvl(i));
				SendClientMessage(playerid, WHITE, str);
				amount++;
			}
			else
			{
				format(str, sizeof(str), "%s[ID:%d] (%s), Level %d %s [%s].", GetOOCName(i), i, GetForumName(i), PlayerStat[i][HelperLevel], Gethlvl(i), GetHDuty(i));
				SendClientMessage(playerid, WHITE, str);
				amount++;
			}

			
        }
    }
	if(amount <= 0)
	{
		SendClientMessage(playerid, CMD_COLOR, "There are no online helpers.");
	}
    SendClientMessage(playerid, GREY, "________________________________________");
	SendClientMessage(playerid, LIGHT_BLUE, "If you need any assistance please use /helpme.");
    return 1;
}

COMMAND:admins(playerid, params[])
{
	new str[128], amount;
	amount = 0;
	SendClientMessage(playerid, GREY, "________________________________________");
	SendClientMessage(playerid, GREEN, "	                   Online Admins:");
	for(new i = 0; i < MAX_PLAYERS; i++)
    {
		if(IsPlayerConnected(i) && PlayerStat[i][AdminLevel] >= 1 && HiddenAdmin[i] == 0 && PlayerStat[i][Spawned] == 1)
		{
            format(str, sizeof(str), "%s, Level %d %s [%s].", GetForumName(i), PlayerStat[i][AdminLevel], Getalvl(i), GetADuty(i));
            SendClientMessage(playerid, WHITE, str);
			amount++;
        }
    }
	if(amount <= 0)
	{
		SendClientMessage(playerid, CMD_COLOR, "There are no online admins, please screen-shot any rule breakers and report them via forums.");
	}
    SendClientMessage(playerid, GREY, "________________________________________");
	if(amount >= 1)
	{
		SendClientMessage(playerid, LIGHT_BLUE, "If you need any Admin assistance please use /ra to request an admin or report the player via /report.");
	}
    return 1;
}

//-----------------------------------------------------------------------[Level 1]------------------------------------------------------------------------------

COMMAND:admincode(playerid, params[])
{
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown Command.");
	if(PlayerStat[playerid][AdminLogged] == 1) return SendClientMessage(playerid, GREY, "You are already logged in as an Administrator.");
	new code[128], str[128];
	if(sscanf(params,"s[128]", code)) return SendClientMessage(playerid, GREY, "USAGE: /admincode [code]");
	else if(!strcmp(code,PlayerStat[playerid][AdminCode], false))
	{
		SendClientMessage(playerid, LIGHT_GREEN, "You have logged in as an administrator.");
		PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
		PlayerStat[playerid][AdminLogged] = 1;
		format(str, sizeof(str), "[SERVER] %s %s has logged in.", Getalvl(playerid), GetForumNameNC(playerid));
		SendAdminMessage(LIGHT_GREEN, str);
		PlayAdminSound(1062);
		return 1;
	}
	SendClientMessage(playerid, WHITE, "SERVER: Bad code.");
	AdminCodeTry[playerid]++;
	if(AdminCodeTry[playerid] >= 3)
	{
		format(str, sizeof(str), "[WARNING] Account %s (Admin Name: %s) has attempted the third administrator login and failed, his powers have been taken.", GetOOCName(playerid), GetForumNameNC(playerid));
		SendAdminMessage(RED, str);
		INI_Open(Accounts(playerid));
        INI_WriteInt("AdminLevel", 0); 
		INI_Save();
		INI_Close();
		PlayerStat[playerid][AdminLevel] = 0;
	}
	if(AdminCodeTry[playerid] >= 2)
	{
		format(str, sizeof(str), "[WARNING] Account %s (Admin Name: %s) has attempted the second administrator login and failed.", GetOOCName(playerid), GetForumNameNC(playerid));
		SendAdminMessage(RED, str);
		PlayAdminSound(1058);
	}
	return 1;
}

COMMAND:a(playerid, params[])
{
	new message[128], str[128];
	if(PlayerStat[playerid][HelperLevel] == 1) return SendClientMessage(playerid, WHITE, "Please use /ha to speak with an Administrator.");
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown Command.");
    if(sscanf(params,"s[128]", message))return SendClientMessage(playerid, GREY, "USAGE: /a{dminchat} [message]");
	format(str, sizeof(str), "(( %s %s: %s ))", Getalvl(playerid), GetForumNameNC(playerid), message);
	SendAdminMessage(LIGHT_GREEN, str);
    return 1;
}

COMMAND:ha(playerid, params[])
{
	new message[128], str[128];
	if(PlayerStat[playerid][HelperLevel] >= 1) goto Helper;
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown Command.");
	Helper:
    if(sscanf(params,"s[128]", message))return SendClientMessage(playerid, GREY, "USAGE: /h{elper}a{dminchat} [message]");
	format(str, sizeof(str), "(( %s %s: %s ))", Getalvl(playerid), GetForumNameNC(playerid), message);
	SendAdminHelperMessage(DARK_GREEN, str);
    return 1;
}

COMMAND:adminchat(playerid, params[])
{
	new message[128], str[128];
	if(PlayerStat[playerid][HelperLevel] == 1) return SendClientMessage(playerid, WHITE, "Please use /ha to speak with an Administrator.");
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown Command.");
    if(sscanf(params,"s[128]", message))return SendClientMessage(playerid, GREY, "USAGE: /adminchat [message]");
	format(str, sizeof(str), "(( %s %s: %s ))", Getalvl(playerid), GetForumNameNC(playerid), message);
	SendAdminMessage(LIGHT_GREEN, str);
    return 1;
}
COMMAND:gotoprison(playerid, params[])
{
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	SetPlayerPos(playerid, 441.0681,1602.0961,1001.0000);
	return 1;
}
COMMAND:mute(playerid, params[])
{
	new str[128], targetid, time;
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	if(sscanf(params,"ud", targetid, time))return SendClientMessage(playerid, GREY, "USAGE: /mute [playerid] [time(in seconds)]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(PlayerStat[targetid][Muted] == 1) return SendClientMessage(playerid, GREY, "Target ID is already muted.");
	if(PlayerStat[targetid][AdminLevel] == 5) return SendClientMessage(playerid, GREY, "You can't mute god.... can't you ;)?");
	if(PlayerStat[targetid][AdminLevel] > PlayerStat[playerid][AdminLevel]) return SendClientMessage(playerid, GREY, "Target ID has a higher admin level.");
	if(60 <= time <= 999)
	{
		PlayerStat[targetid][Muted] = 1;
		PlayerStat[targetid][MuteTime] = time;
		format(str, sizeof(str), "Admin %s has muted %s for %d seconds.", GetForumNameNC(playerid), GetOOCName(targetid), time);
		SendClientMessageToAll(RED, str);
		AdminActionLog(str);
		format(str, sizeof(str), "You will be unable to chat for %d seconds.", time);
		SendClientMessage(targetid, WHITE, str);
		format(str, sizeof(str), "You have successfully muted %s for %d seconds.", GetOOCName(targetid), time);
		SendClientMessage(playerid, WHITE, str);
	}
	else return SendClientMessage(playerid, GREY, "The mute time must be between 60 and 999 seconds.");
    return 1;
}

COMMAND:getmaskname(playerid, params[])
{
	new str[128], targetid, maskid;
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	if(sscanf(params,"d", maskid)) return SendClientMessage(playerid, GREY, "USAGE: /getmaskname Masked[DIGITS].");
	if(maskid <= 1 || maskid >= 10000) return SendClientMessage(playerid, GREY, "[CMD] Invalid Mask ID");
	targetid = 0;
	look_for_mask:
	if(targetid > MAX_PLAYERS) return SendClientMessage(playerid, LIGHT_RED, "[CMD] Invalid/Unknown Mask ID.");
	if(IsPlayerConnected(targetid) && Masked[targetid] == 1 && PlayerStat[targetid][Aname] <= 998 && MaskName[targetid] == maskid)
	{
		format(str, sizeof(str), "[CMD] Mask ID%d belongs currently to %s.", maskid, GetOOCName(targetid));
		SendClientMessage(playerid, CMD_COLOR, str);
		return 1;
	}
	else
	{
		targetid++;
		goto look_for_mask;
	}
	return 1;
}

COMMAND:stoptrackpms(playerid)
{
	new i;
	if(PlayerStat[playerid][AdminLevel] < 3) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	i = 0;
	loop_start:
	if(i > MAX_PLAYERS) goto loop_stop_none;
	if(TrackPMs[playerid] == TrackPMs[i])
	{
		goto loop_stop;
	}
	else
	{
		i++;
		goto loop_start;
	}
	loop_stop:
	TrackPMs[playerid] = 0;
	SendClientMessage(playerid, CMD_COLOR, "You no longer tracking PM's.");
	goto ret;
	loop_stop_none:
	PMsTracked[TrackPMs[playerid]] = 0;
	SendClientMessage(playerid, CMD_COLOR, "You no longer tracking PM's.");
	TrackPMs[playerid] = 0;
	ret:
	return 1;
}

COMMAND:mouse(playerid)
{
	SelectTextDraw(playerid, 0xA3B4C5FF);
	return 1;
}

COMMAND:trackpms(playerid, params[])
{
	new str[128], targetid;
	if(PlayerStat[playerid][AdminLevel] < 3) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	if(sscanf(params,"u", targetid)) return SendClientMessage(playerid, CMD_COLOR, "/trackpms [targetid]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found");
	if(playerid == targetid) return SendClientMessage(playerid, GREY, "You can't use this command on yourself.");
	TrackPMs[playerid] = targetid;
	PMsTracked[targetid] = 1;
	format(str, sizeof(str), "[CMD] Admin %s is now tracking %s PM's.", GetForumNameNC(playerid), GetOOCName(targetid));
	SendAdminMessage(RED, str);
	format(str, sizeof(str), "Admin %s is now tracking %s PM's.", GetForumNameNC(playerid), GetOOCName(targetid));
	AdminActionLog(str);
	return 1;
}

COMMAND:kick(playerid, params[])
{
	new str[128], targetid, reason[128];
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	if(sscanf(params,"us[128]", targetid, reason)) return SendClientMessage(playerid, GREY, "USAGE: /kick [playerid] [reason]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(playerid == targetid) return SendClientMessage(playerid, GREY, "You can't use this command on yourself.");
	if(PlayerStat[targetid][AdminLevel] > PlayerStat[playerid][AdminLevel]) return SendClientMessage(playerid, GREY, "Target ID has a higher admin level.");
	PlayerStat[targetid][TimesKicked]++;
	format(str, sizeof(str), "Admin %s has kicked %s Reason:[%s].", GetForumNameNC(playerid), GetOOCName(targetid), reason);
	SendClientMessageToAll(RED, str);
	AdminActionLog(str);
	format(str, sizeof(str), "[KICK] [Admin: %s] [Reason: %s].", GetForumNameNC(playerid), reason);
	PlayerPunishLog(targetid, str);
	Kick(targetid);
    return 1;
}

COMMAND:arevive(playerid, params[])
{
	new str[128], targetid, Float:targetX, Float:targetY, Float:targetZ;
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown Command.");
	if(sscanf(params,"u", targetid)) return SendClientMessage(playerid, GREY, "USAGE: /a{admin}revive [playerid]");
	if(playerid == targetid && PlayerStat[playerid][AdminLevel] <= 2)
	{
		if(PlayerStat[playerid][AdminLevel] <= 2) return SendClientMessage(playerid, GREY, "You can't use this command on yourself.");
	}
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(PlayerStat[targetid][AdminLevel] > PlayerStat[playerid][AdminLevel]) return SendClientMessage(playerid, GREY, "Target ID has a higher admin level.");
	if(PlayerStat[targetid][Dead] == 0) return SendClientMessage(playerid, GREY, "Target ID is not dead.");
	GetPlayerPos(targetid, targetX, targetY, targetZ);
	SetPlayerHealth(targetid, 15);
	PlayerStat[targetid][Dead] = 0;
	PlayerStat[targetid][DeathT] = 0;
	PlayerStat[targetid][BleedingToDeath] = 0;
	PlayerStat[targetid][Health] = 15;
	format(str, sizeof(str), "** %s has used %s god powers to bring %s back to life. **", GetForumNameNC(playerid), GetGenderHisHer(playerid), GetICName(targetid));
	PlayNearBySound(playerid, 5203, targetX, targetY, targetZ, 10);
	SendNearByMessage(playerid, ACTION_COLOR, str, 8);
	SetCameraBehindPlayer(targetid);
	TogglePlayerControllable(targetid, 1);
	format(str, sizeof(str), "[CMD] Admin %s has revived %s back to life.", GetForumNameNC(playerid), GetOOCName(targetid));
	SendAdminMessage(RED, str);
	format(str, sizeof(str), "Admin %s revived %s back to life.", GetForumNameNC(playerid), GetOOCName(targetid));
	AdminActionLog(str);
	return 1;
}

COMMAND:adminrevive(playerid, params[])
{
	new str[128], targetid, Float:targetX, Float:targetY, Float:targetZ;
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown Command.");
	if(sscanf(params,"u", targetid)) return SendClientMessage(playerid, GREY, "USAGE: /adminrevive [playerid]");
	if(playerid == targetid && PlayerStat[playerid][AdminLevel] <= 2)
	{
		if(PlayerStat[playerid][AdminLevel] <= 2) return SendClientMessage(playerid, GREY, "You can't use this command on yourself.");
	}
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(PlayerStat[targetid][AdminLevel] > PlayerStat[playerid][AdminLevel]) return SendClientMessage(playerid, GREY, "Target ID has a higher admin level.");
	if(PlayerStat[targetid][Dead] == 0) return SendClientMessage(playerid, GREY, "Target ID is not dead.");
	GetPlayerPos(targetid, targetX, targetY, targetZ);
	SetPlayerHealth(targetid, 15);
	PlayerStat[targetid][Dead] = 0;
	PlayerStat[targetid][DeathT] = 0;
	PlayerStat[targetid][BleedingToDeath] = 0;
	PlayerStat[targetid][Health] = 15;
	format(str, sizeof(str), "** %s has used his god powers to bring %s back to life. **", GetForumNameNC(playerid), GetICName(targetid));
	PlayNearBySound(playerid, 5203, targetX, targetY, targetZ, 10);
	SendNearByMessage(playerid, ACTION_COLOR, str, 8);
	SetCameraBehindPlayer(targetid);
	TogglePlayerControllable(targetid, 1);
	format(str, sizeof(str), "[CMD] Admin %s has revived %s back to life.", GetForumNameNC(playerid), GetOOCName(targetid));
	SendAdminMessage(RED, str);
	format(str, sizeof(str), "Admin %s revived %s back to life.", GetForumNameNC(playerid), GetOOCName(targetid));
	AdminActionLog(str);
	return 1;
}

/*
CREATED & SCRIPTED & MAPPED BY MARCO - http://forum.sa-mp.com/member.php?u=181058
*/

COMMAND:skick(playerid, params[])
{
	new str[128], targetid, reason[128];
	if(PlayerStat[playerid][AdminLevel] < 2) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	if(sscanf(params,"us[128]", targetid, reason)) return SendClientMessage(playerid, GREY, "USAGE: /s{ilent}kick [playerid] [reason]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(PlayerStat[targetid][AdminLevel] > PlayerStat[playerid][AdminLevel]) return SendClientMessage(playerid, GREY, "Target ID has a higher admin level.");
	PlayerStat[targetid][TimesKicked]++;
	format(str, sizeof(str), "Admin %s has silent kicked %s Reason:[%s].", GetForumNameNC(playerid), GetOOCName(targetid), reason);
	AdminActionLog(str);
	format(str, sizeof(str), "[CMD]Admin %s has silent kicked %s Reason:[%s].", GetForumNameNC(playerid), GetOOCName(targetid), reason);
	SendAdminMessage(RED, str);
	format(str, sizeof(str), "[SILENT-KICK] [Admin: %s] [Reason: %s].", GetForumNameNC(playerid), reason);
	PlayerPunishLog(targetid, str);
	Kick(targetid);
    return 1;
}

/*
CREATED & SCRIPTED & MAPPED BY MARCO - http://forum.sa-mp.com/member.php?u=181058
*/

COMMAND:aduty(playerid, params[])
{
	new str[27], i;
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	if(PlayerStat[playerid][ADuty] == 1)
	{
		PlayerStat[playerid][ADuty] = 0;
	    SetPlayerColor(playerid, WHITE);
	    SendClientMessage(playerid, RED, "You are no longer on duty.");
		SetPlayerHealth(playerid, DutyHealth[playerid]);
		SetPlayerArmour(playerid, DutyArmour[playerid]);
		PlayerStat[playerid][Armour] = DutyArmour[playerid];
		PlayerStat[playerid][Health] = DutyHealth[playerid];
		i = 0;
		delete_mask:
		if(i > MAX_PLAYERS) return 1;
		if(IsPlayerConnected(i) && Masked[i] == 1)
		{
			DeletePlayer3DTextLabel(playerid, MaskRealName[i]);
			i++;
			goto delete_mask;
		}
		else
		{
			i++;
			goto delete_mask;
		}
		return 1;
	}
	else
	{
	   if(PlayerStat[playerid][AdminLevel] >= 4)
	    {
			PlayerStat[playerid][ADuty] = 1;
			SetPlayerColor(playerid, OWNER_RED);
			GetPlayerHealth(playerid, DutyHealth[playerid]);
			GetPlayerArmour(playerid, DutyArmour[playerid]);
			PlayerStat[playerid][Armour] = DutyArmour[playerid];
			PlayerStat[playerid][Health] = DutyHealth[playerid];
			SetPlayerHealth(playerid, 100);
			SetPlayerArmour(playerid, 100);
			SendClientMessage(playerid, RED, "You are now on duty as an {FF3300}High Administration{FF1919} staff member.");
			i = 0;
			create_mask_names:
			if(i > 100) return 1;
			if(IsPlayerConnected(i) && Masked[i] == 1)
			{	
				format(str, sizeof(str), "%s", GetOOCName(i));
				MaskRealName[i] = CreatePlayer3DTextLabel(playerid, str, LIGHT_RED, 0, 0, 0.17, 25, i);
				i++;
				goto create_mask_names;
			}
			else
			{
				i++;
				goto create_mask_names;
			}
			return 1;
		}
		else
		{
			PlayerStat[playerid][ADuty] = 1;
			SetPlayerColor(playerid, GREEN);
			GetPlayerHealth(playerid, DutyHealth[playerid]);
			GetPlayerArmour(playerid, DutyArmour[playerid]);
			PlayerStat[playerid][Armour] = DutyArmour[playerid];
			PlayerStat[playerid][Health] = DutyHealth[playerid];
			SetPlayerHealth(playerid, 100);
			SetPlayerArmour(playerid, 100);
			SendClientMessage(playerid, RED, "You are now on duty as an {00FF00}Administrator{FF1919}.");
			i = 0;
			create_mask_names2:
			if(i > 100) return 1;
			if(IsPlayerConnected(i) && Masked[i] == 1)
			{	
				format(str, sizeof(str), "%s", GetOOCName(i));
				MaskRealName[i] = CreatePlayer3DTextLabel(playerid, str, LIGHT_RED, 0, 0, 0.17, 25, i);
				i++;
				goto create_mask_names2;
			}
			else
			{
				i++;
				goto create_mask_names2;
			}
			return 1;
		}
	}
}

COMMAND:hduty(playerid, params[])
{
	if(PlayerStat[playerid][HelperLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	if(PlayerStat[playerid][HDuty] == 1)
	{
	    PlayerStat[playerid][HDuty] = 0;
	    SetPlayerColor(playerid, WHITE);
	    SendClientMessage(playerid, RED, "You are no longer on duty.");
		return 1;
	}
	else
	{
	    PlayerStat[playerid][HDuty] = 1;
	    SetPlayerColor(playerid, LIGHT_BLUE);
	    SendClientMessage(playerid, RED, "You are now on duty as a {008fff}Helper{FF1919}.");
		return 1;
	}
}

COMMAND:fixjob(playerid, params[])
{
    new str[128], targetid;
	if(PlayerStat[playerid][AdminLevel] < 2) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
    if(sscanf(params,"u", targetid)) return SendClientMessage(playerid, GREY, "USAGE: /fixjob [playerid]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
    PlayerStat[targetid][JobID1ReloadTime] = 0;
    PlayerStat[targetid][JobID2ReloadTime] = 0;
    PlayerStat[targetid][JobID3ReloadTime] = 0;
    PlayerStat[targetid][JobID4ReloadTime] = 0;
    PlayerStat[targetid][JobID4CHP] = 0;
    PlayerStat[targetid][JobID4BOX] = 0;
	SendClientMessage(targetid, WHITE, "Your job variables have been fixed by an admin.");
	format(str, sizeof(str), "You have successfully fixed %s job variables.", GetOOCName(targetid));
	SendClientMessage(playerid, WHITE, str);
	format(str, sizeof(str), "Admin %s fixed %s job variables.", GetOOCName(playerid), GetOOCName(targetid));
	AdminActionLog(str);
	if(PlayerStat[targetid][JobID] == 0) // Unemployed
	{
    	PlayerStat[targetid][AbleToCollectGarbage] = 0;
    	PlayerStat[targetid][AbleToCleanTables] = 0;
    	PlayerStat[targetid][AbleToCollectFood] = 0;
	}
	else if(PlayerStat[targetid][JobID] == 1) // Garbage
	{
    	PlayerStat[targetid][AbleToCollectGarbage] = 1;
    	PlayerStat[targetid][AbleToCleanTables] = 0;
    	PlayerStat[targetid][AbleToCollectFood] = 0;
	}
	else if(PlayerStat[targetid][JobID] == 2) // Table
	{
    	PlayerStat[targetid][AbleToCollectGarbage] = 0;
    	PlayerStat[targetid][AbleToCleanTables] = 1;
    	PlayerStat[targetid][AbleToCollectFood] = 0;
	}
	else if(PlayerStat[targetid][JobID] == 3) // Food
	{
    	PlayerStat[targetid][AbleToCollectGarbage] = 0;
    	PlayerStat[targetid][AbleToCleanTables] = 0;
    	PlayerStat[targetid][AbleToCollectFood] = 1;
	}
	else if(PlayerStat[targetid][JobID] == 4) // Warehouse
	{
    	PlayerStat[targetid][AbleToCollectGarbage] = 0;
    	PlayerStat[targetid][AbleToCleanTables] = 0;
    	PlayerStat[targetid][AbleToCollectFood] = 0;
	}
	return 1;
}

COMMAND:spec(playerid, params[])
{
    new str[128], targetid;
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
    if(sscanf(params,"u", targetid)) return SendClientMessage(playerid, GREY, "USAGE: /spec [playerid]");
    if(targetid == playerid) return SendClientMessage(playerid ,GREY, "You can't spec yourself.");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(PlayerStat[playerid][Specing] == 1)
	{
		PlayerStat[PlayerStat[playerid][SpecingID]][BeingSpeced] = 0;
		PlayerStat[PlayerStat[playerid][SpecingID]][BeingSpecedBy] = -1;
	}
    GetPlayerPos(playerid, Spec[playerid][SpecX], Spec[playerid][SpecY], Spec[playerid][SpecZ]);
    Spec[playerid][SpecInt] = GetPlayerInterior(targetid);
    Spec[playerid][SpecVW] = GetPlayerVirtualWorld(targetid);
    TogglePlayerSpectating(playerid, true);
    if(IsPlayerInAnyVehicle(targetid))
    {
        SetPlayerInterior(playerid, GetPlayerInterior(targetid));
        SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(targetid));
        PlayerSpectateVehicle(playerid, GetPlayerVehicleID(targetid));
    }
    else
    {
        SetPlayerInterior(playerid,GetPlayerInterior(targetid));
        SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(targetid));
        PlayerSpectatePlayer(playerid,targetid);
    }
    format(str, sizeof(str), "~w~ You are now ~g~ Specing\n ~r~ %s", GetOOCName(targetid));
    GameTextForPlayer(playerid, str, 3000, 4);
    format(str, sizeof(str), "Money: %d, Health: %f, Armour: %f.", PlayerStat[targetid][Money], PlayerStat[targetid][Health], PlayerStat[targetid][Armour]);
    SendClientMessage(playerid, RED, str);
    PlayerStat[playerid][Specing] = 1;
    PlayerStat[playerid][SpecingID] = targetid;
    PlayerStat[targetid][BeingSpeced] = 1;
    PlayerStat[targetid][BeingSpecedBy] = playerid;
    return 1;
}

COMMAND:specoff(playerid, params[])
{
    new str[128];
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
    if(PlayerStat[playerid][Specing] == 0) return SendClientMessage(playerid, GREY, "You are not specing anyone.");
    TogglePlayerSpectating(playerid, false);
    TogglePlayerControllable(playerid, false);
    SetTimerEx("LoadingObjects", 4000, false, "d", playerid);
    format(str, sizeof(str), "~w~ You are no longer ~g~ Specing\n ~r~ %s", GetOOCName(PlayerStat[playerid][SpecingID]));
    GameTextForPlayer(playerid, str, 3000, 4);
    return 1;
}

COMMAND:unmute(playerid, params[])
{
	new str[128], targetid;
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	if(sscanf(params,"u", targetid))return SendClientMessage(playerid, GREY, "USAGE: /unmute [playerid]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(PlayerStat[targetid][Muted] == 0) return SendClientMessage(playerid, GREY, "Target ID isn't muted.");
	PlayerStat[targetid][Muted] = 0;
	PlayerStat[targetid][MuteTime] = 0;
	format(str, sizeof(str), "Admin %s has unmuted %s.", GetOOCName(playerid), GetOOCName(targetid));
	SendClientMessageToAll(RED, str);
	AdminActionLog(str);
	SendClientMessage(targetid, WHITE, "You have been unmuted by an admin.");
	format(str, sizeof(str), "You have successfully unmuted %s.", GetOOCName(targetid));
	SendClientMessage(playerid, WHITE, str);
    return 1;
}

COMMAND:freeze(playerid, params[])
{
	new targetid, str[128];
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	if(sscanf(params,"u", targetid))return SendClientMessage(playerid, GREY, "USAGE: /freeze [playerid]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(PlayerStat[targetid][AdminLevel] > PlayerStat[playerid][AdminLevel]) return SendClientMessage(playerid, GREY, "Target ID has a higher admin level.");
	SendClientMessage(playerid, WHITE, "You have freezed the player.");
	TogglePlayerControllable(targetid, 0);
	format(str, sizeof(str), "Admin %s has freezed %s.", GetOOCName(playerid), GetOOCName(targetid));
	AdminActionLog(str);
	GameTextForPlayer(targetid, "~r~ FREEZED", 3000, 4);
    return 1;
}

COMMAND:unfreeze(playerid, params[])
{
	new targetid, str[128];
	if(PlayerStat[playerid][HelperLevel] == 1) goto Helper_Unfreeze;
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	Helper_Unfreeze:
	if(sscanf(params,"u", targetid))return SendClientMessage(playerid, GREY, "USAGE: /unfreeze [playerid]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	TogglePlayerControllable(targetid, 1);
	format(str, sizeof(str), "%s %s has unfreezed %s.", GetForumNameNC(playerid), GetOOCName(targetid));
	AdminActionLog(str);
	format(str, sizeof(str), "[CMD]%s %s has unfreezed %s.", Getalvl(playerid), GetForumNameNC(playerid), GetOOCName(targetid));
	SendAdminMessage(RED, str);
	GameTextForPlayer(targetid, "~g~ UNFREEZED", 3000, 4);
    return 1;
}

COMMAND:slap(playerid, params[])
{
	new str[128], targetid, Float:CHealth;
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	if(sscanf(params,"u", targetid))return SendClientMessage(playerid, GREY, "USAGE: /slap [playerid]");
	if(!IsPlayerConnected(targetid) || PlayerStat[targetid][Logged] == 0) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(PlayerStat[targetid][AdminLevel] > PlayerStat[playerid][AdminLevel]) return SendClientMessage(playerid, GREY, "Target ID has a higher admin level.");
	new Float: PosX, Float: PosY, Float: PosZ;
	GetPlayerHealth(targetid, CHealth);
	GetPlayerPos(targetid, PosX, PosY, PosZ);
	SetPlayerPos(targetid, PosX, PosY, PosZ + 5.0);
	SetHealth(targetid, CHealth - 5.0);
	format(str, sizeof(str), "You have slapped %s.", GetOOCName(targetid));
	SendClientMessage(playerid, WHITE, str);
	GetPlayerHealth(targetid, CHealth);
	PlayerStat[targetid][Health] = CHealth;
	format(str, sizeof(str), "Admin %s has slapped %s.", GetForumNameNC(playerid), GetOOCName(targetid));
	AdminActionLog(str);
	PlayNearBySound(targetid, 1190, PosX, PosY, PosZ, 10);
	GameTextForPlayer(targetid, "~r~ SLAPPED", 3000, 4);
    return 1;
}

COMMAND:check(playerid, params[])
{
    new targetid;
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
    if(sscanf(params,"u", targetid)) return SendClientMessage(playerid, GREY, "USAGE: /check [playerid]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
    ShowStatsForPlayer(targetid, playerid);
    return 1;
}

COMMAND:checkinv(playerid, params[])
{
    new targetid;
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	if(sscanf(params,"u", targetid)) return SendClientMessage(playerid, GREY, "USAGE: /checkinv [playerid]");
	if(playerid == targetid) return SendClientMessage(playerid, RED, "To see your own inventory click Y.");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
    ShowTargetInventory(playerid, targetid);
	SelectTextDraw(playerid, 0xA3B4C5FF);
    return 1;
}

COMMAND:checkhelpmes(playerid, params[])
{
    new targetid, str[128];
	if(PlayerStat[playerid][HelperLevel] < 2 && PlayerStat[playerid][AdminLevel] < 4) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
    if(sscanf(params,"u", targetid)) return SendClientMessage(playerid, GREY, "USAGE: /checkhelpmes [playerid]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
    format(str, sizeof(str), "Helper %s has accepted %d helpme's.", GetForumNameNC(targetid), PlayerStat[targetid][HelpmesAnswered]);
	SendClientMessage(playerid, CMD_COLOR, str);
    return 1;
}

COMMAND:setdonator(playerid, params[])
{
    new targetid, amount;
	if(PlayerStat[playerid][AdminLevel] < 5) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
    if(sscanf(params,"ud", targetid, amount)) return SendClientMessage(playerid, GREY, "USAGE: /setdonator [playerid] [level]");
	if(amount > 3) return SendClientMessage(playerid, GREY, "[CMD] Donator level can't be higher then 3.");
	if(amount < 0) return SendClientMessage(playerid, GREY, "[CMD] Donator level can't be lower then 0.");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(PlayerStat[targetid][DonLV] == amount) return SendClientMessage(playerid, GREY, "Player is already has that donator level.");
	PlayerStat[targetid][DonLV] = amount;
	if(PlayerStat[targetid][DonLV] == 1) SendClientMessage(playerid, BRONZE, "Player is now a Bronze donator.");
	if(PlayerStat[targetid][DonLV] == 2) SendClientMessage(playerid, SILVER, "Player is now a Silver donator.");
	if(PlayerStat[targetid][DonLV] == 3) SendClientMessage(playerid, GOLD, "Player is now a Gold donator.");
	if(PlayerStat[targetid][DonLV] == 0) SendClientMessage(playerid, GOLD, "Player is no longer a donator.");
	return 1;

}


COMMAND:checkwarnings(playerid, params[])
{
    new targetid;
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
    if(sscanf(params,"u", targetid)) return SendClientMessage(playerid, GREY, "USAGE: /checkwarnings [playerid]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
    ShowWarnings(playerid, targetid);
    return 1;
}

COMMAND:checkcell(playerid, params[])
{
    new cellid, str[128], weapname1[60], weapname2[60];
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
    if(sscanf(params,"d", cellid)) return SendClientMessage(playerid, GREY, "USAGE: /checkcell [cellid]");
    if(cellid > Server[LoadedCells]) return SendClientMessage(playerid, GREY, "Invalid Cell ID.");
    SendClientMessage(playerid, GREY, "------------------------------------------------------------------------------------------------");
	new Weapon1 = CellStat[cellid][CellWeap1];
	new Weapon2 = CellStat[cellid][CellWeap2];
	GetWeaponName(Weapon1 ,weapname1, sizeof(weapname1));
	GetWeaponName(Weapon2, weapname2, sizeof(weapname2));
	if(Weapon1 == 0) { weapname1 = "None"; }
	if(Weapon2 == 0) { weapname2 = "None"; }
	format(str, sizeof(str), "Cell ID %d Stats:", cellid);
	SendClientMessage(playerid, GREY, str);
	format(str, sizeof(str), "Price: %d, Owner: %s, Level: %d.", CellStat[cellid][CellPrice], CellStat[cellid][CellOwner], CellStat[cellid][CellLevel]);
	SendClientMessage(playerid, GREY, str);
	format(str, sizeof(str), "Pot: %d, Crack: %d, Weapon 1: %s, Weapon 2: %s", CellStat[cellid][CellPot], CellStat[cellid][CellCrack], weapname1, weapname2);
	SendClientMessage(playerid, GREY, str);
    SendClientMessage(playerid, GREY, "------------------------------------------------------------------------------------------------");
    return 1;
}

COMMAND:checkweapons(playerid, params[])
{
    new str[128], targetid, weapname1[60], weapname2[60], weapname3[60];
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	if(sscanf(params,"u", targetid)) return SendClientMessage(playerid, GREY, "USAGE: /checkweapons [targetid]");
	new Weapon1 = PlayerStat[targetid][WeaponSlot0];
	new Weapon2 = PlayerStat[targetid][WeaponSlot1];
	new Weapon3 = PlayerStat[targetid][WeaponSlot2];
	GetWeaponName(Weapon1 ,weapname1, sizeof(weapname1));
	GetWeaponName(Weapon2, weapname2, sizeof(weapname2));
	GetWeaponName(Weapon3, weapname3, sizeof(weapname3));
	if(Weapon1 == 0) { weapname1 = "None"; }
	if(Weapon2 == 0) { weapname2 = "None"; }
	if(Weapon3 == 0) { weapname3 = "None"; }
	format(str, sizeof(str), "%s Weapons are:", GetOOCName(targetid));
	SendClientMessage(playerid, WHITE, str);
	format(str, sizeof(str), "Weapon1: %s [AMMO: %d]|| Weapon2: %s [AMMO: %d]|| Weapon3: %s [AMMO: %d]", weapname1, PlayerStat[targetid][WeaponSlot0Ammo], weapname2, PlayerStat[targetid][WeaponSlot1Ammo], weapname3, PlayerStat[targetid][WeaponSlot2Ammo]);
	SendClientMessage(playerid, WHITE, str);
    return 1;
}

COMMAND:am(playerid, params[])
{
    new str[128], targetid, message[128], i;
	i = 0;
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
    if(sscanf(params,"us[128]", targetid, message)) return SendClientMessage(playerid, GREY, "USAGE: /a{dmin}m{essage} [playerid] [message]");
	if(playerid == targetid) return SendClientMessage(playerid, GREY, "You can't admin message yourself.");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(HiddenAdmin[playerid] == 0)
	{
		format(str, sizeof(str), "((Admin Message from %s: %s))", GetForumNameNC(playerid), message);
		SendClientMessage(targetid, LIGHT_RED, str);
		format(str, sizeof(str), "((Admin Message to %s: %s))", GetOOCName(targetid), message);
		SendClientMessage(playerid, LIGHT_RED, str);
		format(str, sizeof(str), "%s APM'd %s: %s", GetOOCName(playerid), GetOOCName(targetid), message);
		PMLog(str);
		if(PMsTracked[targetid] == 1)
		{
			loop_start1:
			if(IsPlayerConnected(i) == 1)
			{
				if(i > MAX_PLAYERS)
				{
					goto loop_stop;
				}
				if(TrackPMs[i] == targetid)
				{
					format(str, sizeof(str), "((APM from %s to %s: %s))", GetOOCName(playerid), GetOOCName(targetid), message);
					SendClientMessage(i, YELLOW, str);
					PlayerPlaySound(i, 1085, 0, 0 ,0);
					i++;
					goto loop_start1;
				}
				else
				{
					i++;
					goto loop_start1;
				}
			}
			else
			{
				i++;
				goto loop_start1;
			}
		}
		if(PMsTracked[playerid] == 1)
		{
			loop_start2:
			if(IsPlayerConnected(i) == 1)
			{
				if(i > MAX_PLAYERS)
				{
					goto loop_stop;
				}
				if(TrackPMs[i] == playerid)
				{
					format(str, sizeof(str), "((APM from %s to %s: %s))", GetOOCName(playerid), GetOOCName(targetid), message);
					SendClientMessage(i, YELLOW, str);
					PlayerPlaySound(i, 1085, 0, 0 ,0);
					i++;
					goto loop_start2;
				}
				else
				{
					i++;
					goto loop_start2;
				}
			}
			else
			{
				i++;
				goto loop_start2;
			}
		}
		loop_stop:
		return 1;
	}
	if(HiddenAdmin[playerid] == 1)
	{
		format(str, sizeof(str), "((Admin Message from Hidden: %s))", message);
		SendClientMessage(targetid, LIGHT_RED, str);
		format(str, sizeof(str), "((Admin Message to %s: %s))", GetOOCName(targetid), message);
		SendClientMessage(playerid, LIGHT_RED, str);
		format(str, sizeof(str), "%s APM'd as Hidden %s: %s", GetOOCName(playerid), GetOOCName(targetid), message);
		PMLog(str);
		if(PMsTracked[targetid] == 1)
		{
			loop_start1:
			if(IsPlayerConnected(i) == 1)
			{
				if(i > MAX_PLAYERS)
				{
					goto loop_stop;
				}
				if(TrackPMs[i] == targetid)
				{
					format(str, sizeof(str), "((HAPM from %s to %s: %s))", GetOOCName(playerid), GetOOCName(targetid), message);
					SendClientMessage(i, YELLOW, str);
					PlayerPlaySound(i, 1085, 0, 0 ,0);
					i++;
					goto loop_start1;
				}
				else
				{
					i++;
					goto loop_start1;
				}
			}
			else
			{
				i++;
				goto loop_start1;
			}
		}
		if(PMsTracked[playerid] == 1)
		{
			loop_start2:
			if(IsPlayerConnected(i) == 1)
			{
				if(i > MAX_PLAYERS)
				{
					goto loop_stop;
				}
				if(TrackPMs[i] == playerid)
				{
					format(str, sizeof(str), "((HAPM from %s to %s: %s))", GetOOCName(playerid), GetOOCName(targetid), message);
					SendClientMessage(i, YELLOW, str);
					PlayerPlaySound(i, 1085, 0, 0 ,0);
					i++;
					goto loop_start2;
				}
				else
				{
					i++;
					goto loop_start2;
				}
			}
			else
			{
				i++;
				goto loop_start2;
			}
		}
		loop_stop:
		return 1;
	}
	return 1;
}

COMMAND:apm(playerid, params[])
{
    new str[128], targetid, message[128], i;
	i = 0;
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
    if(sscanf(params,"us[128]", targetid, message)) return SendClientMessage(playerid, GREY, "USAGE: /a{dmin}m{essage} [playerid] [message]");
	if(playerid == targetid) return SendClientMessage(playerid, GREY, "You can't admin message yourself.");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(HiddenAdmin[playerid] == 0)
	{
		format(str, sizeof(str), "((Admin Message from %s: %s))", GetForumNameNC(playerid), message);
		SendClientMessage(targetid, LIGHT_RED, str);
		format(str, sizeof(str), "((Admin Message to %s: %s))", GetOOCName(targetid), message);
		SendClientMessage(playerid, LIGHT_RED, str);
		format(str, sizeof(str), "%s APM'd %s: %s", GetOOCName(playerid), GetOOCName(targetid), message);
		PMLog(str);
		if(PMsTracked[targetid] == 1)
		{
			loop_start1:
			if(IsPlayerConnected(i) == 1)
			{
				if(i > MAX_PLAYERS)
				{
					goto loop_stop;
				}
				if(TrackPMs[i] == targetid)
				{
					format(str, sizeof(str), "((APM from %s to %s: %s))", GetOOCName(playerid), GetOOCName(targetid), message);
					SendClientMessage(i, YELLOW, str);
					PlayerPlaySound(i, 1085, 0, 0 ,0);
					i++;
					goto loop_start1;
				}
				else
				{
					i++;
					goto loop_start1;
				}
			}
			else
			{
				i++;
				goto loop_start1;
			}
		}
		if(PMsTracked[playerid] == 1)
		{
			loop_start2:
			if(IsPlayerConnected(i) == 1)
			{
				if(i > MAX_PLAYERS)
				{
					goto loop_stop;
				}
				if(TrackPMs[i] == playerid)
				{
					format(str, sizeof(str), "((APM from %s to %s: %s))", GetOOCName(playerid), GetOOCName(targetid), message);
					SendClientMessage(i, YELLOW, str);
					PlayerPlaySound(i, 1085, 0, 0 ,0);
					i++;
					goto loop_start2;
				}
				else
				{
					i++;
					goto loop_start2;
				}
			}
			else
			{
				i++;
				goto loop_start2;
			}
		}
		loop_stop:
		return 1;
	}
	if(HiddenAdmin[playerid] == 1)
	{
		format(str, sizeof(str), "((Admin Message from Hidden: %s))", message);
		SendClientMessage(targetid, LIGHT_RED, str);
		format(str, sizeof(str), "((Admin Message to %s: %s))", GetOOCName(targetid), message);
		SendClientMessage(playerid, LIGHT_RED, str);
		format(str, sizeof(str), "%s APM'd as Hidden %s: %s", GetOOCName(playerid), GetOOCName(targetid), message);
		PMLog(str);
		if(PMsTracked[targetid] == 1)
		{
			loop_start1:
			if(IsPlayerConnected(i) == 1)
			{
				if(i > MAX_PLAYERS)
				{
					goto loop_stop;
				}
				if(TrackPMs[i] == targetid)
				{
					format(str, sizeof(str), "((HAPM from %s to %s: %s))", GetOOCName(playerid), GetOOCName(targetid), message);
					SendClientMessage(i, YELLOW, str);
					PlayerPlaySound(i, 1085, 0, 0 ,0);
					i++;
					goto loop_start1;
				}
				else
				{
					i++;
					goto loop_start1;
				}
			}
			else
			{
				i++;
				goto loop_start1;
			}
		}
		if(PMsTracked[playerid] == 1)
		{
			loop_start2:
			if(IsPlayerConnected(i) == 1)
			{
				if(i > MAX_PLAYERS)
				{
					goto loop_stop;
				}
				if(TrackPMs[i] == playerid)
				{
					format(str, sizeof(str), "((HAPM from %s to %s: %s))", GetOOCName(playerid), GetOOCName(targetid), message);
					SendClientMessage(i, YELLOW, str);
					PlayerPlaySound(i, 1085, 0, 0 ,0);
					i++;
					goto loop_start2;
				}
				else
				{
					i++;
					goto loop_start2;
				}
			}
			else
			{
				i++;
				goto loop_start2;
			}
		}
		loop_stop:
		return 1;
	}
	return 1;
}

COMMAND:reportmute(playerid, params[])
{
    new str[128], targetid;
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
    if(sscanf(params,"u", targetid)) return SendClientMessage(playerid, GREY, "USAGE: /reportmute [playeid] (You can use this command to unmute a player from using report too).");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
    if(PlayerStat[targetid][ReportMuted] == 1)
    {
		PlayerStat[targetid][ReportMuted] = 0;
        format(str, sizeof(str), "You have been unmuted from sending reports by %s.", GetOOCName(playerid));
	    SendClientMessage(targetid, RED, str);
	    format(str, sizeof(str), "You have successfully unmuted %s from sending reports.", GetOOCName(targetid));
	    SendClientMessage(playerid, RED, str);
	    format(str, sizeof(str), "Admin %s has report muted %s.", GetOOCName(playerid), GetOOCName(targetid));
	    AdminActionLog(str);
	}
	else if(PlayerStat[targetid][ReportMuted] == 0)
    {
		PlayerStat[targetid][ReportMuted] = 1;
        format(str, sizeof(str), "You have been muted from sending reports by %s.", GetOOCName(playerid));
	    SendClientMessage(targetid, RED, str);
	    format(str, sizeof(str), "You have successfully muted %s from sending reports.", GetOOCName(targetid));
	    SendClientMessage(playerid, RED, str);
	    format(str, sizeof(str), "Admin %s has report unmuted %s.", GetOOCName(playerid), GetOOCName(targetid));
	    AdminActionLog(str);
	}
    return 1;
}

//-----------------------------------------------------------------------[Level 2]------------------------------------------------------------------------------

COMMAND:toggleooc(playerid, params[])
{
    new str[128];
	if(PlayerStat[playerid][AdminLevel] < 2) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	if(ServerStat[OOCStatus] == 1)
	{
        SendClientMessageToAll(RED, "OOC chat has been disabled by an admin.");
        ServerStat[OOCStatus] = 0;
        format(str, sizeof(str), "Admin %s has disabled OOC chat.", GetOOCName(playerid));
	    AdminActionLog(str);
	}
    else
	{
        SendClientMessageToAll(RED, "OOC chat has been enabled by an admin.");
        ServerStat[OOCStatus] = 1;
        format(str, sizeof(str), "Admin %s has enabled OOC chat.", GetOOCName(playerid));
	    AdminActionLog(str);
	}
    return 1;
}

COMMAND:respawnvehicles(playerid, params[])
{
    new str[128];
	if(PlayerStat[playerid][AdminLevel] < 3) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	for(new v=0; v < MAX_VEHICLES; v++)
    {
        if(!IsVehicleOccupied(v))
        {
            SetVehicleToRespawn(v);
        }
    }
    format(str, sizeof(str), "Unoccupied vehicles respawned by %s.", GetOOCName(playerid));
    SendClientMessageToAll(RED, str);
    return 1;
}

COMMAND:hiddenadmin(playerid)
{
	if(PlayerStat[playerid][AdminLevel] < 3) return SendClientMessage(playerid, WHITE, "SEVER: Unknown command.");
	if(HiddenAdmin[playerid] == 0)
	{
	    PlayerStat[playerid][ADuty] = 0;
	    SetPlayerColor(playerid, WHITE);
		HiddenAdmin[playerid] = 1;
		SendClientMessage(playerid, GREEN, "You are now hidden as an Administrator, don't forget to change your name.");
		return 1;
	}
	else if(HiddenAdmin[playerid] == 1)
	{
		HiddenAdmin[playerid] = 0;
		SendClientMessage(playerid, GREEN, "You are no longer hidden as an Administrator, don't forget to change your name back.");
		return 1;
	}
	return 1;
}

COMMAND:ban(playerid, params[])
{
	new str[128], targetid, reason[60];
	if(PlayerStat[playerid][AdminLevel] < 2) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	if(sscanf(params,"us[60]", targetid, reason))return SendClientMessage(playerid, GREY, "USAGE: /ban [playerid] [reason]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(playerid == targetid) return SendClientMessage(playerid, GREY, "You can't use this command on yourself.");
	if(PlayerStat[targetid][AdminLevel] > PlayerStat[playerid][AdminLevel]) return SendClientMessage(playerid, GREY, "Target ID has a higher admin level.");
	PlayerStat[targetid][Banned] = 1;
	PlayerStat[targetid][TimesBanned]++;
	new Day, Month, Year;
	getdate(Year, Month, Day);
	format(str, sizeof(str), "Admin %s has banned %s Reason:[%s].", GetForumNameNC(playerid), GetOOCName(targetid), reason);
	SendClientMessageToAll(RED, str);
	format(str, sizeof(str), "Admin %s has banned %s Reason:[%s].", GetForumNameNC(playerid), GetOOCName(targetid), reason);
	AdminActionLog(str);
	format(str, sizeof(str), "[CMD] Admin %s has banned %s Reason:[%s].", GetForumNameNC(playerid), GetOOCName(targetid), reason);
	SendAdminMessage(RED, str);
	format(PlayerStat[targetid][BannedReason], 128, "%s", reason);
	format(str, sizeof(str), "%s Banned by Admin %s.", GetOOCName(targetid), GetForumNameNC(playerid));
	BanLog(str);
	format(str, sizeof(str), "[BAN] [Admin: %s] [Reason: %s].", GetForumNameNC(playerid), reason);
	PlayerPunishLog(targetid, str);
    Kick(targetid);
    return 1;
}

COMMAND:warn(playerid, params[])
{
	new str[160], targetid, reason[128];
	if(PlayerStat[playerid][AdminLevel] < 2) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	if(sscanf(params,"us[60]", targetid, reason))return SendClientMessage(playerid, GREY, "USAGE: /warn [playerid] [reason]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(playerid == targetid) return SendClientMessage(playerid, GREY, "You can't use this command on yourself.");
	if(PlayerStat[targetid][AdminLevel] > PlayerStat[playerid][AdminLevel]) return SendClientMessage(playerid, GREY, "Target ID has a higher admin level.");
	if(PlayerStat[targetid][Warnings] == 0)
	{
	    PlayerStat[targetid][Warnings]++;
	    format(str, sizeof(str), "[CMD] Admin %s has warned %s, Reason: %s (Current Warnings: %d).", GetForumNameNC(playerid), GetOOCName(targetid), reason, PlayerStat[targetid][Warnings]);
	    SendAdminMessage(RED, str);
		format(str, sizeof(str), "Admin %s has warned %s, Reason: %s (Current Warnings: %d).", GetForumNameNC(playerid), GetOOCName(targetid), reason, PlayerStat[targetid][Warnings]);
	    AdminActionLog(str);
		format(str, sizeof(str), "You have been warned by admin %s. Reason: %s [CURRENT WARNINGS:%d].", GetForumNameNC(playerid), reason, PlayerStat[targetid][Warnings]);
		SendClientMessage(targetid, RED, str);
		format(str, sizeof(str), "[WARNING] [Admin: %s] [Reason: %s].", GetForumNameNC(playerid), reason);
		PlayerPunishLog(targetid, str);
	    format(PlayerStat[targetid][Warn1], 128, "%s", reason);
	}
	else if(PlayerStat[targetid][Warnings] == 1)
	{
	    PlayerStat[targetid][Warnings]++;
	    format(str, sizeof(str), "[CMD] Admin %s has warned %s, Reason: %s (Current Warnings: %d).", GetForumNameNC(playerid), GetOOCName(targetid), reason, PlayerStat[targetid][Warnings]);
	    SendAdminMessage(RED, str);
		format(str, sizeof(str), "Admin %s has warned %s, Reason: %s (Current Warnings: %d).", GetForumNameNC(playerid), GetOOCName(targetid), reason, PlayerStat[targetid][Warnings]);
	    AdminActionLog(str);
		format(str, sizeof(str), "You have been warned by admin %s. Reason: %s [CURRENT WARNINGS:%d].", GetForumNameNC(playerid), reason, PlayerStat[targetid][Warnings]);
		SendClientMessage(targetid, RED, str);
		format(str, sizeof(str), "[WARNING] [Admin: %s] [Reason: %s].", GetForumNameNC(playerid), reason);
		PlayerPunishLog(targetid, str);
	    format(PlayerStat[targetid][Warn2], 128, "%s", reason);
	}
	else if(PlayerStat[targetid][Warnings] == 2)
	{
	    PlayerStat[targetid][Warnings] = 0;
	    format(PlayerStat[targetid][Warn1], 128, "None");
	    format(PlayerStat[targetid][Warn2], 128, "None");
		PlayerStat[targetid][AdminPrisoned] = 1;
		PlayerStat[targetid][AdminPrisonedTime] = 901;
		SetPlayerPos(targetid, 32.2658,33.1848,3.1172);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid, 0);
		TogglePlayerControllable(targetid, 0);
		PlayerStat[targetid][Muted] = 1;
		PlayerStat[targetid][MuteTime] = 901;
	    new Day, Month, Year;
	    getdate(Year, Month, Day);
		format(str, sizeof(str), "Admin %s has warned %s. Reason: %s.", GetForumNameNC(playerid), GetOOCName(targetid), reason);
		AdminActionLog(str);
		format(str, sizeof(str), "[CMD] Admin %s has warned %s. Reason: %s.", GetForumNameNC(playerid), GetOOCName(targetid), reason);
		SendAdminMessage(RED, str);
		format(str, sizeof(str), "You have been warned by admin %s. Reason: %s [CURRENT WARNINGS:%d].", GetForumNameNC(playerid), reason, PlayerStat[targetid][Warnings]);
		SendClientMessage(targetid, RED, str);
	    format(str, sizeof(str), "Admin %s has admin jailed %s. Reason: [%s] (Third Warning).", GetForumNameNC(playerid), GetOOCName(targetid), reason);
 	    SendClientMessageToAll(RED, str);
		format(str, sizeof(str), "[THIRD WARNING ADMIN JAIL] [Admin: %s] [Reason: %s].", GetForumNameNC(playerid), reason);
		PlayerPunishLog(targetid, str);
	    AdminActionLog(str);
	}
    return 1;
}

COMMAND:goto(playerid, params[])
{
	new str[128], targetid;
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	if(sscanf(params,"u", targetid))return SendClientMessage(playerid, GREY, "USAGE: /goto [playerid]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(playerid == targetid) return SendClientMessage(playerid, GREY, "You can't teleport to yourself.");
	new Float: PosX, Float: PosY, Float: PosZ;
	GetPlayerPos(targetid, PosX, PosY, PosZ);
	SetPlayerPos(playerid, PosX, PosY, PosZ + 0.5);
	SetPlayerInterior(playerid, GetPlayerInterior(targetid));
	SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(targetid));
	format(str, sizeof(str), "You have teleported to %s.", GetOOCName(targetid));
	SendClientMessage(playerid, WHITE, str);
    return 1;
}

COMMAND:get(playerid, params[])
{
	new str[128], targetid;
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	if(sscanf(params,"u", targetid))return SendClientMessage(playerid, GREY, "USAGE: /get [playerid]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(playerid == targetid) return SendClientMessage(playerid, GREY, "You can't get yourself.");
	new Float: PosX, Float: PosY, Float: PosZ;
	GetPlayerPos(playerid, PosX, PosY, PosZ);
	SetPlayerPos(targetid, PosX, PosY, PosZ + 0.5);
    format(str, sizeof(str), "You have teleported %s to you.", GetOOCName(targetid));
	SendClientMessage(playerid, GREEN, str);
    SendClientMessage(targetid, WHITE, "You have been teleported by an admin.");
	SetPlayerInterior(targetid, GetPlayerInterior(playerid));
	SetPlayerVirtualWorld(targetid, GetPlayerVirtualWorld(playerid));
    return 1;
}

COMMAND:setinterior(playerid, params[])
{
	new targetid, interior, str[128];
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	if(sscanf(params,"ud", targetid , interior))return SendClientMessage(playerid, GREY, "USAGE: /setinterior [playerid] [interiorid]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	SetPlayerInterior(targetid, interior);
	format(str, sizeof(str), "Your interior has been set to ~r~ %d ~w~ by an admin", interior);
	GameTextForPlayer(targetid, str, 3000, 4);
	format(str, sizeof(str), "Admin %s has set %s's interior to %d", GetForumNameNC(playerid), GetOOCName(targetid), interior);
	AdminActionLog(str);
    return 1;
}

COMMAND:setvirtualworld(playerid, params[])
{
	new targetid, virtualworld, str[128];
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	if(sscanf(params,"ud", targetid , virtualworld))return SendClientMessage(playerid, GREY, "USAGE: /setvirtualworld [playerid] [virtualworld]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	SetPlayerVirtualWorld(targetid, virtualworld);
	format(str, sizeof(str), "Your virtual world has been set to ~r~ %d ~w~ by an admin", virtualworld);
	GameTextForPlayer(targetid, str, 3000, 4);
	format(str, sizeof(str), "Admin %s has set %s's virtual world to %d", GetForumNameNC(playerid), GetOOCName(targetid),virtualworld);
	AdminActionLog(str);
    return 1;
}

COMMAND:go(playerid, params[])
{
	new type;
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	if(sscanf(params,"d", type))
	{
	    SendClientMessage(playerid, GREY, "USAGE: /go [place 1-8]");
	    SendClientMessage(playerid, GREY, "PLACES: 1- Prison Gate, 2- Basket Ball Field, 3- Sewer, 4- Cafetiria.");
	    SendClientMessage(playerid, GREY, "5- Prison Guards HQ, 6- Prison Clinic, 7- Control Room, 8- Los Santos.");
		return 1;
	}
	if(1 <= type <= 8)
	{
	    Teleport(playerid, type);
	}
	else return SendClientMessage(playerid, GREY, "Invalid Teleport Type.");
    return 1;
}

COMMAND:send(playerid, params[])
{
	new type, targetid;
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	if(sscanf(params,"ud", targetid, type))
	{
	    SendClientMessage(playerid, GREY, "USAGE: /send [playerid] [place 1-8]");
	    SendClientMessage(playerid, GREY, "PLACES: 1- Prison Gate, 2- Basket Ball Field, 3- Sewer, 4- Cafetiria.");
	    SendClientMessage(playerid, GREY, "5- Prison Guards HQ, 6- Prison Clinic, 7- Control Room, 8- Los Santos.");
		return 1;
	}
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(playerid == targetid) return SendClientMessage(playerid, GREY, "You can't send yourself, use /go instead.");
	if(1 <= type <= 8)
	{
	    Teleport(targetid, type);
	}
	else return SendClientMessage(playerid, GREY, "Invalid Teleport Type.");
    return 1;
}

COMMAND:unajail(playerid, params[])
{
	new targetid, reason[128], str[128], str2[80];
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	if(sscanf(params,"us[128]", targetid, reason))return SendClientMessage(playerid, GREY, "USAGE: /unajail [playerid] [reason]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(targetid == playerid) return SendClientMessage(playerid, WHITE, "You can't Admin Jail yourself.");
	if(PlayerStat[targetid][AdminPrisoned] == 0) return SendClientMessage(playerid, CMD_COLOR, "[CMD]Player is not A-Jailed.");
	if(PlayerStat[targetid][AdminLevel] >= PlayerStat[playerid][AdminLevel]) return SendClientMessage(playerid, RED, "You can't Un-Admin Jail a higher/same level admin as you.");
	format(str2, sizeof(str2), "You have been Un-Admin Jailed by Administrator %s.", GetForumNameNC(playerid));
	SendClientMessage(targetid, RED, str2);
	format(str2, sizeof(str2), "[CMD]You have been Un-Admin user %s.", GetOOCName(targetid));
	SendClientMessage(playerid, RED, str2);
	PlayerStat[targetid][AdminPrisoned] = 0;
	PlayerStat[targetid][AdminPrisonedTime] = 0;
    SetPlayerPos(targetid, 441.0681,1602.0961,1001.0000);
    SetPlayerVirtualWorld(targetid, 0);
    SetPlayerInterior(targetid, 0);
    TogglePlayerControllable(targetid, 1);
	PlayerStat[targetid][Muted] = 0;
	PlayerStat[targetid][MuteTime] = 0;
    format(str, sizeof(str), "Admin %s has Un-Admin Jailed %s. Reason: [%s.]", GetForumNameNC(playerid), GetICName(targetid), reason);
    SendClientMessageToAll(RED, str);
    AdminActionLog(str);
	format(str, sizeof(str), "[ADMIN UN-JAIL] [Admin: %s] [Reason: %s].", GetForumNameNC(playerid), reason);
	PlayerPunishLog(targetid, str);
    return 1;
}

COMMAND:ajails(playerid, params[])
{
	new str[128];
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	SendClientMessage(playerid, GREEN, "_________________Active A-Jails_________________");
	new i;
	i = 0;
	loop_start:
	if(i >= 101)
	{
		SendClientMessage(playerid, GREEN, "_______________________________________________");
		return 1;
	}
	if(IsPlayerConnected(i))
	{
		if(PlayerStat[i][Logged] == 0)
		{
			i++;
			goto loop_start;
		}
		if(PlayerStat[i][AdminPrisoned] == 1)
		{
			format(str, sizeof(str), "%s | Time left: %d | Reason: %s", GetOOCName(i), PlayerStat[i][AdminPrisonedTime], AjailReason[i]);
			SendClientMessage(playerid, CMD_COLOR, str);
			i++;
			goto loop_start;
		}
	}
	i++;
	goto loop_start;
}

COMMAND:ajail(playerid, params[])
{
	new targetid, time, reason[128], str[128], str2[80];
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	if(sscanf(params,"uds[128]", targetid, time, reason))return SendClientMessage(playerid, GREY, "USAGE: /ajail [playerid] [time] [reason]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(targetid == playerid) return SendClientMessage(playerid, WHITE, "You can't Admin Jail yourself.");
	if(PlayerStat[targetid][AdminLevel] >= PlayerStat[playerid][AdminLevel]) return SendClientMessage(playerid, RED, "You can't Admin Jail a higher/same level admin as you.");
	format(str2, sizeof(str2), "You have been Admin Jailed for %d seconds.", time);
	SendClientMessage(targetid, RED, str2);
	format(str2, sizeof(str2), "You have Admin Jailed %s for %d seconds.", GetOOCName(targetid), time);
	SendClientMessage(playerid, RED, str2);
	PlayerStat[targetid][AdminPrisoned] = 1;
	PlayerStat[targetid][AdminPrisonedTime] = time;
    SetPlayerPos(targetid, 32.2658,33.1848,3.1172);
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerInterior(playerid, 0);
    TogglePlayerControllable(targetid, 0);
	PlayerStat[targetid][Muted] = 1;
	PlayerStat[targetid][MuteTime] = time;
	AjailReason[playerid] = reason;
    format(str, sizeof(str), "Admin %s has Admin Jailed %s. Reason: [%s.]", GetForumNameNC(playerid), GetICName(targetid), reason);
    SendClientMessageToAll(RED, str);
    AdminActionLog(str);
	format(str, sizeof(str), "[ADMIN JAIL] [Admin: %s] [Reason: %s].", GetForumNameNC(playerid), reason);
	PlayerPunishLog(targetid, str);
    return 1;
}

//-----------------------------------------------------------------------[Level 3]------------------------------------------------------------------------------

COMMAND:cc(playerid, params[])
{
    new str[128];
	if(PlayerStat[playerid][AdminLevel] < 5) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	ClearChat();
	SendClientMessageToAll(RED, "Chat has been cleared by an admin");
	format(str, sizeof(str), "Admin %s has cleared the chat.", GetForumNameNC(playerid));
	AdminActionLog(str);
    return 1;
}

COMMAND:spawncar(playerid, params[])
{
	if(PlayerStat[playerid][AdminLevel] < 5) return SendClientMessage(playerid, WHITE, "SERVER: Unknown comamnd.");
	new carid, color1, color2, Float:playerx, Float:playery, Float:playerz, Float:playera;
	GetPlayerPos(playerid, playerx, playery, playerz);
	GetPlayerFacingAngle(playerid, playera);
	if(sscanf(params,"ddd", carid, color1, color2))return SendClientMessage(playerid, GREY, "USAGE: /spawncar [carid] [color1] [color2]");
	AddStaticVehicle(carid, playerx, playery + 0.3, playerz, playera, color1, color2);
	return 1;
}

COMMAND:giveitem(playerid, params[])
{
 	new itemid, targetid, str[128], ammo;
	if(PlayerStat[playerid][AdminLevel] < 4) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	if(sscanf(params,"udi", targetid, itemid, ammo))return SendClientMessage(playerid, GREY, "USAGE: /giveitem [playerid] [itemid] [amount]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(itemid == 0 || itemid > 10) return SendClientMessage(playerid, GREY, "Item ID not found.");
	if(GetFreeSlot(targetid) == 0) return SendClientMessage(playerid, GREY, "Player inventory is full.");
	GiveItem(targetid, itemid, ammo);
    format(str, sizeof(str), "You gave %s a %s (Amount: %d).", GetOOCName(targetid), GetItemName(itemid), ammo);
    SendClientMessage(playerid, GREEN, str);
    format(str, sizeof(str), "You have received a %s (Amount: %d) from an admin.", GetItemName(itemid), ammo);
    SendClientMessage(targetid, RED, str);
    format(str, sizeof(str), "Admin %s gave a %s (Amount: %d) to %s.", GetForumNameNC(playerid), GetItemName(itemid), ammo, GetOOCName(targetid));
	AdminActionLog(str);
	format(str, sizeof(str), "[CMD] Admin %s gave a %s (Amount: %d) to %s.", GetForumNameNC(playerid), GetItemName(itemid), ammo, GetOOCName(targetid));
	SendAdminMessage(RED, str);
	return 1;
}
	
COMMAND:giveweapon(playerid, params[])
{
 	new weaponid, targetid, weaponname[60], str[128], ammo;
	if(PlayerStat[playerid][AdminLevel] < 4) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	if(sscanf(params,"udi", targetid, weaponid, ammo))return SendClientMessage(playerid, GREY, "USAGE: /giveweapon [playerid] [weaponid] [ammo]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(PlayerStat[targetid][PlayingHours] < 5) return SendClientMessage(playerid, GREY, "This player doesn't have 5 playing hours to carry a weapon.");
	new targetweap = GetPlayerWeapon(targetid);
	if(targetweap >= 1 || PlayerStat[playerid][WeaponPocketCD] >= 1) return SendClientMessage(playerid, GREY, "This player is already holding a weapon.");
	if(weaponid == 41) goto ignore_check;
	if(weaponid >= 35) return SendClientMessage(playerid, GREY, "This is a forbidden weapon to have.");
	ignore_check:
	ServerWeapon(targetid, weaponid, ammo);
	GetWeaponName(weaponid, weaponname, sizeof(weaponname));
    format(str, sizeof(str), "You gave %s an %s (Ammo: %d).", GetOOCName(targetid), weaponname, ammo);
    SendClientMessage(playerid, GREEN, str);
    format(str, sizeof(str), "You have received an %s (Ammo: %d) from an admin.", weaponname, ammo);
    SendClientMessage(targetid, RED, str);
    format(str, sizeof(str), "Admin %s gave an %s (Ammo: %d) to %s.", GetForumNameNC(playerid), weaponname, ammo, GetOOCName(targetid));
	AdminActionLog(str);
	format(str, sizeof(str), "[CMD] Admin %s gave an %s (Ammo: %d) to %s.", GetForumNameNC(playerid), weaponname, ammo, GetOOCName(targetid));
	SendAdminMessage(RED, str);
	format(str, sizeof(str), "Admin %s gave an %s (Ammo: %d) to %s.", GetForumNameNC(playerid), weaponname, ammo, GetOOCName(targetid));
	WeaponLog(str);
    return 1;
}

COMMAND:gotocell(playerid, params[])
{
    new cellid, str[128];
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
    if(sscanf(params,"d", cellid)) return SendClientMessage(playerid, GREY, "USAGE: /gotocell [cellid]");
    if(cellid > Server[LoadedCells]) return SendClientMessage(playerid, GREY, "Invalid Cell ID.");
    SetPlayerPos(playerid, CellStat[cellid][ExteriorX], CellStat[cellid][ExteriorY], CellStat[cellid][ExteriorZ]);
	format(str, sizeof(str), "Teleported to cell ID: %d.", cellid);
	SendClientMessage(playerid, GREY, str);
    return 1;
}

COMMAND:explode(playerid,params[])
{
    new targetid, str[128];
    if(PlayerStat[playerid][AdminLevel] < 5) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
    if(sscanf(params,"u", targetid))return SendClientMessage(playerid, GREY, "USAGE: /explode [playerid]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
    new Float: PosX, Float: PosY, Float: PosZ;
    GetPlayerPos(targetid ,PosX, PosY, PosZ);
    CreateExplosion(PosX, PosY, PosZ, 0, 5.0);
    GameTextForPlayer(targetid , "BOOM!", 3000, 3);
    format(str, sizeof(str), "Admin %s has exploded %s.", GetForumNameNC(playerid), GetOOCName(targetid));
	AdminActionLog(str);
    return 1;
}

COMMAND:setweather(playerid,params[])
{
    new weather, str[128];
    if(PlayerStat[playerid][AdminLevel] < 2) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
    if(sscanf(params,"d", weather))return SendClientMessage(playerid, GREY, "USAGE: /setweather [weatherid]");
    SetWeather(weather);
	format(str, sizeof(str), "Weather ID changed to %d", weather);
	GameTextForPlayer(playerid, str, 3000, 4);
	format(str, sizeof(str), "Admin %s has changed the weather to %d.", GetOOCName(playerid), weather);
	AdminActionLog(str);
    return 1;
}

COMMAND:gotopos(playerid,params[])
{
    new Float: PosX, Float: PosY, Float: PosZ, Interior, str[128];
    if(PlayerStat[playerid][AdminLevel] < 3) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
    if(sscanf(params,"fffd" ,PosX, PosY, PosZ, Interior))return SendClientMessage(playerid, GREY, "USAGE: /gotopos [PosX] [PosY] [PosZ] [Interior]");
    SetPlayerPos(playerid ,PosX, PosY, PosZ);
	SetPlayerInterior(playerid, Interior);
	format(str, sizeof(str), "Teleported to X: %f, Y: %f, Z: %f and Interior: %d.", PosX, PosY, PosZ, Interior);
	SendClientMessage(playerid, RED, str);
    return 1;
}

COMMAND:banip(playerid,params[])
{
    new str[128], ip[21];
    if(PlayerStat[playerid][AdminLevel] < 3) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
   	IRC_GroupSayEx(gGroupID, IRC_AECHO_CHANNEL, "%s has just banned IP: %d", pName[playerid], ip);
   	IRC_GroupSayEx(gGroupID, IRC_ECHO_CHANNEL, "%s has just banned IP: %d", pName[playerid], ip);
    if(sscanf(params,"s[21]", ip))return SendClientMessage(playerid, GREY, "USAGE: /banip [ip]");
    if(strlen(ip) >= 5)
    {
	    format(str, sizeof(str), "banip %s", ip);
		SendRconCommand(str);
	    format(str, sizeof(str), "You have successfully banned the IP '%s'", ip);
	    SendClientMessage(playerid, RED, str);
		format(str, sizeof(str), "[CMD] Admin %s have banned the IP '%s'", GetForumNameNC(playerid), ip);
		SendAdminMessage(RED, str);
	    format(str, sizeof(str), "Admin %s has banned IP '%s'.", GetForumNameNC(playerid), ip);
	    AdminActionLog(str);
	    format(str, sizeof(str), "IP Banned: [%s] by Admin %s.", ip, GetForumNameNC(playerid));
	    BanLog(str);
	}
    return 1;
}

COMMAND:offlineban(playerid, params[])
{
	new str[128], account[30], file[128];
	if(PlayerStat[playerid][AdminLevel] < 3) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
    if(sscanf(params,"s[30]", account))return SendClientMessage(playerid, GREY, "USAGE: /offlineban [playeraccount]");
   	IRC_GroupSayEx(gGroupID, IRC_AECHO_CHANNEL, "%s has just offline-banned player: %s", pName[playerid], account);
   	IRC_GroupSayEx(gGroupID, IRC_ECHO_CHANNEL, "%s has just offline-banned player: %s", pName[playerid], account);
    format(file, sizeof(file), "Accounts/%s.ini", account);
    if(fexist(file))
    {
		if(INI_Open(file))
		{
			if(INI_ReadInt("Banned") == 0)
			{
                if(INI_ReadInt("AdminLevel") > PlayerStat[playerid][AdminLevel]) return SendClientMessage(playerid, GREY, "Account has an higher admin level.");
                INI_WriteInt("Banned", 1);
                INI_WriteInt("TimesBanned", INI_ReadInt("TimesBanned")+1);
		        format(str, sizeof(str), "You have successfully banned account '%s'.", account);
		        SendClientMessage(playerid, RED, str);
                new Day, Month, Year;
            	getdate(Year, Month, Day);
  		        format(str, sizeof(str), "Admin %s has offline banned account '%s', Date: %04d/%02d/%02d.", GetForumNameNC(playerid), account, Year, Month, Day);
 	            SendClientMessageToAll(RED, str);
	            AdminActionLog(str);
	            format(str, sizeof(str), "%s Banned.", account);
	            BanLog(str);

	            INI_Save();
	            INI_Close();
            }
            else return SendClientMessage(playerid, GREY, "This account is already banned.");
        }
	}
	else return SendClientMessage(playerid, GREY, "This account does not exist.");
    return 1;
}

COMMAND:offlineajail(playerid, params[])
{
	new str[128], account[30], file[128], reason[128], time;
	if(PlayerStat[playerid][AdminLevel] < 3) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
    if(sscanf(params,"s[30]ds[128]", account, time, reason))return SendClientMessage(playerid, GREY, "USAGE: /offlineajail [playeraccount] [time] [reason]");
    format(file, sizeof(file), "Accounts/%s.ini", account);
    if(fexist(file))
    {
		if(INI_Open(file))
		{
            if(INI_ReadInt("AdminLevel") > PlayerStat[playerid][AdminLevel]) return SendClientMessage(playerid, GREY, "Account has an higher admin level.");
            INI_WriteInt("AdminPrisoned", 1);
            INI_WriteInt("AdminPrisonedTime", time);
            INI_WriteInt("VW", 5555);
            new Day, Month, Year;
            getdate(Year, Month, Day);
			format(str, sizeof(str), "Admin %s has Offline Admin Jailed %s. Reason: [%s.]", GetForumNameNC(playerid), account, reason);
			SendClientMessageToAll(RED, str);
	        AdminActionLog(str);
			format(str, sizeof(str), "[OFFLINE ADMIN JAIL] [Admin: %s] [Reason: %s].", GetForumNameNC(playerid), reason);
			OfflinePlayerPunishLog(account, str);
	        INI_Save();
	        INI_Close();
        }
	}
	else return SendClientMessage(playerid, GREY, "This account does not exist.");
    return 1;
}

/*COMMAND:fchangename(playerid, params[])
{
	new str[128], targetid, file[128], newname[MAX_PLAYER_NAME];
	if(PlayerStat[playerid][AdminLevel] < 4) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
    if(sscanf(params,"us[MAX_PLAYER_NAME]", targetid, newname))return SendClientMessage(playerid, GREY, "USAGE: /f{ree}changename [playerid] [newname]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(PlayerStat[targetid][AdminLevel] > PlayerStat[playerid][AdminLevel]) return SendClientMessage(playerid, GREY, "Target ID has a higher admin level.");
    format(file, sizeof(file), "Accounts/%s.ini", newname);
    if(!fexist(file))
    {
		if(INI_Open(file))
		{
            if(strlen(newname) >= 3 && strlen(newname) < MAX_PLAYER_NAME)
            {
                format(str, sizeof(str), "Admin %s has changed the name of %s to %s.", GetOOCName(playerid),  GetOOCName(targetid), newname);
 	            SendClientMessageToAll(RED, str);
	            AdminActionLog(str);

				INI_Remove(file);
				SetPlayerName(targetid, newname);
				SavePlayerData(targetid);

				if(PlayerStat[targetid][HasCell] == 1)
				{
					format(CellStat[PlayerStat[targetid][Cell]][CellOwner], MAX_PLAYER_NAME, "%s", newname);
					SaveCell(PlayerStat[targetid][Cell]);
				}
	        }
	        else
	        {
                format(str, sizeof(str), "The new name must be between 3 and %d characters.", MAX_PLAYER_NAME);
                SendClientMessage(playerid, GREY, str);
            }
        }
	}
	else return SendClientMessage(playerid, GREY, "That name is already registered.");
    return 1;
}

COMMAND:sfchangename(playerid, params[])
{
	new str[128], targetid, file[128], newname[MAX_PLAYER_NAME];
	if(PlayerStat[playerid][AdminLevel] < 4) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
    if(sscanf(params,"us[MAX_PLAYER_NAME]", targetid, newname))return SendClientMessage(playerid, GREY, "USAGE: /s{ilent}f{ree}changename [playerid] [newname]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(PlayerStat[targetid][AdminLevel] > PlayerStat[playerid][AdminLevel]) return SendClientMessage(playerid, GREY, "Target ID has a higher admin level.");
    format(file, sizeof(file), "Accounts/%s.ini", newname);
    if(!fexist(file))
    {
		if(INI_Open(file))
		{
            if(strlen(newname) >= 3 && strlen(newname) < MAX_PLAYER_NAME)
            {
//                format(str, sizeof(str), "Admin %s has changed the name of %s to %s.", GetOOCName(playerid),  GetOOCName(targetid), newname);
 	            SendClientMessageToAll(RED, str);
	            AdminActionLog(str);

				INI_Remove(file);
				SetPlayerName(targetid, newname);
				SavePlayerData(targetid);

				if(PlayerStat[targetid][HasCell] == 1)
				{
					format(CellStat[PlayerStat[targetid][Cell]][CellOwner], MAX_PLAYER_NAME, "%s", newname);
					SaveCell(PlayerStat[targetid][Cell]);
				}
	        }
	        else
	        {
                format(str, sizeof(str), "The new name must be between 3 and %d characters.", MAX_PLAYER_NAME);
                SendClientMessage(playerid, GREY, str);
            }
        }
	}
	else return SendClientMessage(playerid, GREY, "That name is already registered.");
    return 1;
}*/

COMMAND:hset(playerid, params[])
{
    new targetid, item[30], quantity, str[128];
    if(PlayerStat[playerid][HelperLevel] == 1)
    {
		if(sscanf(params,"us[20]d", targetid, item, quantity))
		{
			SendClientMessage(playerid, GREY, "USAGE: /hset [playerid] [item] [quantity]");
			SendClientMessage(playerid, GREY, "Items: Age, Skin, Male/Female.");
			SendClientMessage(playerid, GREY, "NOTE: Near Male/Female write any number to execute the command.");
			return 1;
		}
		if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
		else if(!strcmp(item, "age", true))
		{
			if(18 <= quantity <= 70)
			{
				PlayerStat[targetid][Age] = quantity;
				format(str, sizeof(str), "You have changed %s's age to %d years.", GetOOCName(targetid), quantity);
				SendClientMessage(playerid, RED, str);
				format(str, sizeof(str), "A helper has set your age to %d years old.", quantity);
				SendClientMessage(targetid, RED, str);
				format(str, sizeof(str), "Helper %s has set %s age to %d years old.", GetForumNameNC(playerid), GetOOCName(targetid), quantity);
				AdminActionLog(str);
				return 1;
			}
			else
			{
				SendClientMessage(playerid, GREY, "Age must be between 18 and 70.");
				return 1;
			}
		}
		else if(!strcmp(item, "male", true))
		{
			PlayerStat[playerid][Gender] = 1;
			format(str, sizeof(str), "You have changed %s's gender to Male.", GetOOCName(targetid));
			SendClientMessage(playerid, RED, str);
			SendClientMessage(targetid, RED, "Helper has set your gender to Male.");
			format(str, sizeof(str), "Helper %s has set %s sex to male.", GetForumNameNC(playerid), GetOOCName(targetid));
			AdminActionLog(str);
			return 1;
		}
		else if(!strcmp(item, "female", true))
		{
			PlayerStat[playerid][Gender] = 0;
			format(str, sizeof(str), "You have changed %s's gender to Female.", GetOOCName(targetid));
			SendClientMessage(playerid, RED, str);
			SendClientMessage(targetid, RED, "Helper has set your gender to Female.");
			format(str, sizeof(str), "Helper %s has set %s sex to female.", GetForumNameNC(playerid), GetOOCName(targetid));
			AdminActionLog(str);
			return 1;
		}
		else if(!strcmp(item, "skin", true))
		{
			SetSkin(targetid, quantity);
			format(str, sizeof(str), "You have changed %s's skin to %d.", GetOOCName(targetid), quantity);
			SendClientMessage(playerid, RED, str);
			format(str, sizeof(str), "Helper has set your skin to %d.", quantity);
			SendClientMessage(targetid, RED, str);
			format(str, sizeof(str), "[CMD] Helper %s has set %s [ID:%d] skin to %d.", GetForumNameNC(playerid), GetOOCName(targetid), targetid, quantity);
			AdminActionLog(str);
			SendAdminMessage(RED, str);
			return 1;
		}
	}
	else if(PlayerStat[playerid][AdminLevel] >= 1)
	{
	    SendClientMessage(playerid, GREY, "Use /set instead, as you are an admin.");
		return 1;
	}
	else if(PlayerStat[playerid][HelperLevel] > 1 && PlayerStat[playerid][HelperLevel] < 3)
	{
	    SendClientMessage(playerid, GREY, "You need to be a level 3 Helper to use this command.");
		return 1;
	}
	else if(PlayerStat[playerid][AdminLevel] == 0)
	{
	    SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
		return 1;
	}
	else if(PlayerStat[playerid][HelperLevel] == 0)
	{
	    SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
		return 1;
	}
    return 1;
}
COMMAND:set(playerid, params[])
{
    new targetid, item[30], quantity, str[128];
    if(PlayerStat[playerid][AdminLevel] >= 1)
    {
		if(sscanf(params,"us[20]d", targetid, item, quantity))
		{
			if(PlayerStat[playerid][AdminLevel] >= 4)
			{
				SendClientMessage(playerid, GREY, "USAGE: /set [playerid] [item] [quantity]");
				SendClientMessage(playerid, GREY, "Items: Pot, Crack, Money, Age, Skin, Playinghours, Job, LockerMoney, Health, Armour, Male/Female, Bench");
				SendClientMessage(playerid, GREY, "gangrank, facrank.");
				return 1;
			}
			else if(PlayerStat[playerid][AdminLevel] == 1)
			{
				SendClientMessage(playerid, GREY, "USAGE: /set [playerid] [item] [quantity]");
				SendClientMessage(playerid, GREY, "Items: Age, Skin, Male/Female.");
				return 1;
			}
			else if(PlayerStat[playerid][AdminLevel] == 2)
			{
				SendClientMessage(playerid, GREY, "USAGE: /set [playerid] [item] [quantity]");
				SendClientMessage(playerid, GREY, "Items: Age, Skin, Male/Female, job.");
				return 1;
			}
			else if(PlayerStat[playerid][AdminLevel] == 3)
			{
				SendClientMessage(playerid, GREY, "USAGE: /set [playerid] [item] [quantity]");
				SendClientMessage(playerid, GREY, "Items: Age, Skin, Male/Female, Crack, Pot, Job, Health, Armour, Bench.");
				return 1;
			}
			return 1;
		}
		if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
		else if(!strcmp(item, "pot", true))
		{
			if(PlayerStat[playerid][AdminLevel] >= 3)
			{
				PlayerStat[targetid][Pot] = quantity;
				format(str, sizeof(str), "You have changed %s's pot to %d grams.", GetOOCName(targetid), quantity);
				SendClientMessage(playerid, RED, str);
				format(str, sizeof(str), "An admin has set your pot to %d grams.", quantity);
				SendClientMessage(targetid, RED, str);
				format(str, sizeof(str), "Admin %s has set %s pot to %d grams.", GetForumNameNC(playerid), GetOOCName(targetid), quantity);
				AdminActionLog(str);
				format(str, sizeof(str), "[CMD] Admin %s has set %s pot to %d grams.", GetForumNameNC(playerid), GetOOCName(targetid), quantity);
				SendAdminMessage(RED, str);
				return 1;
			}
			else
			{
				SendClientMessage(playerid, GREY, "You can't set this item for a user.");
				return 1;
			}
		}
		else if(!strcmp(item, "crack", true))
		{
			if(PlayerStat[playerid][AdminLevel] >= 3)
			{
				PlayerStat[targetid][Crack] = quantity;
				format(str, sizeof(str), "You have changed %s's crack to %d grams.", GetOOCName(targetid), quantity);
				SendClientMessage(playerid, RED, str);
				format(str, sizeof(str), "An admin has set your crack to %d grams.", quantity);
				SendClientMessage(targetid, RED, str);
				format(str, sizeof(str), "Admin %s has set %s crack to %d grams.", GetForumNameNC(playerid), GetOOCName(targetid), quantity);
				AdminActionLog(str);
				format(str, sizeof(str), "[CMD] Admin %s has set %s crack to %d grams.", GetForumNameNC(playerid), GetOOCName(targetid), quantity);
				SendAdminMessage(RED, str);
				return 1;
			}
			else
			{
				SendClientMessage(playerid, GREY, "You can't set this item for a user.");
				return 1;
			}
		}
		else if(!strcmp(item, "money", true))
		{
			if(PlayerStat[playerid][AdminLevel] >= 4)
			{
				SetMoney(targetid, quantity);
				format(str, sizeof(str), "You have changed %s's money to $%d.", GetOOCName(targetid), quantity);
				SendClientMessage(playerid, RED, str);
				format(str, sizeof(str), "An admin has set your money to $%d.", quantity);
				SendClientMessage(targetid, RED, str);
				format(str, sizeof(str), "Admin %s has set %s money to %d$.", GetForumNameNC(playerid), GetOOCName(targetid), quantity);
				AdminActionLog(str);
				format(str, sizeof(str), "[CMD] Admin %s has set %s money to %d$.", GetForumNameNC(playerid), GetOOCName(targetid), quantity);
				SendAdminMessage(RED, str);
				return 1;
				
			}
			else
			{
				SendClientMessage(playerid, GREY, "You can't set this item for a user.");
				return 1;
			}
		}
		else if(!strcmp(item, "age", true))
		{
			if(18 <= quantity <= 70)
			{
				PlayerStat[targetid][Age] = quantity;
				format(str, sizeof(str), "You have changed %s's age to %d years.", GetOOCName(targetid), quantity);
				SendClientMessage(playerid, RED, str);
				format(str, sizeof(str), "An admin has set your age to %d years old.", quantity);
				SendClientMessage(targetid, RED, str);
				format(str, sizeof(str), "Admin %s has set %s age to %d years old.", GetForumNameNC(playerid), GetOOCName(targetid), quantity);
				AdminActionLog(str);
				return 1;
			}
			else return SendClientMessage(playerid, GREY, "Age must be between 18 and 70.");
		}
		else if(!strcmp(item, "skin", true))
		{
			SetSkin(targetid, quantity);
			format(str, sizeof(str), "You have changed %s's skin to %d.", GetOOCName(targetid), quantity);
			SendClientMessage(playerid, RED, str);
			format(str, sizeof(str), "An admin has set your skin to %d.", quantity);
			SendClientMessage(targetid, RED, str);
			format(str, sizeof(str), "Admin %s has set %s skin to %d.", GetForumNameNC(playerid), GetOOCName(targetid), quantity);
			AdminActionLog(str);
			return 1;
		}
		else if(!strcmp(item, "playinghours", true))
		{
			if(PlayerStat[playerid][AdminLevel] >= 4)
			{
				PlayerStat[targetid][PlayingHours] = quantity;
				format(str, sizeof(str), "You have changed %s's playing hours to %d.", GetOOCName(targetid), quantity);
				SendClientMessage(playerid, RED, str);
				format(str, sizeof(str), "An admin has set your playing hours to %d.", quantity);
				SendClientMessage(targetid, RED, str);
				SetPlayerScore(targetid, quantity);
				format(str, sizeof(str), "Admin %s has set %s playing hours to %dPH.", GetForumNameNC(playerid), GetOOCName(targetid), quantity);
				AdminActionLog(str);
				format(str, sizeof(str), "[CMD] Admin %s has set %s playing hours to %dPH.", GetForumNameNC(playerid), GetOOCName(targetid), quantity);
				SendAdminMessage(RED, str);
				return 1;
			}
			else
			{
				SendClientMessage(playerid, GREY, "You can't set this item for a user.");
				return 1;
			}
		}
		else if(!strcmp(item, "job", true))
		{
			if(PlayerStat[playerid][AdminLevel] >= 2)
			{
				if(1 <= quantity <= 4)
				{
					PlayerStat[targetid][JobID] = quantity;
					format(str, sizeof(str), "You have changed %s's job ID to %d.", GetOOCName(targetid), quantity);
					SendClientMessage(playerid, RED, str);
					format(str, sizeof(str), "An admin has set your job ID to %d.", quantity);
					SendClientMessage(targetid, RED, str);
					format(str, sizeof(str), "Admin %s has set %s job ID to %d.", GetForumNameNC(playerid), GetOOCName(targetid), quantity);
					AdminActionLog(str);
					format(str, sizeof(str), "[CMD] Admin %s has set %s job ID %d.", GetForumNameNC(playerid), GetOOCName(targetid), quantity);
					SendAdminMessage(RED, str);
					return 1;
				}
				else return SendClientMessage(playerid, GREY, "The Job ID must be between 1 and 4.");
			}
			else
			{
				SendClientMessage(playerid, GREY, "You can't set this item for a user.");
				return 1;
			}
		}
		else if(!strcmp(item, "lockermoney", true))
		{
			if(PlayerStat[playerid][AdminLevel] >= 4)
			{
				PlayerStat[targetid][LockerMoney] = quantity;
				format(str, sizeof(str), "You have changed %s's locker money to $%d.", GetOOCName(targetid), quantity);
				SendClientMessage(playerid, RED, str);
				format(str, sizeof(str), "An admin has set your locker money to $%d.", quantity);
				SendClientMessage(targetid, RED, str);
				format(str, sizeof(str), "Admin %s has set %s locker money to %d$.", GetForumNameNC(playerid), GetOOCName(targetid), quantity);
				AdminActionLog(str);
				format(str, sizeof(str), "[CMD] Admin %s has set %s locker money to %d$.", GetForumNameNC(playerid), GetOOCName(targetid), quantity);
				SendAdminMessage(RED, str);
				return 1;
			}
			else
			{
				SendClientMessage(playerid, GREY, "You can't use this command.");
				return 1;
			}
		}
		else if(!strcmp(item, "health", true))
		{
			if(PlayerStat[playerid][AdminLevel] >= 3)
			{
				SetHealth(targetid, quantity);
				format(str, sizeof(str), "You have changed %s's health to %d.", GetOOCName(targetid), quantity);
				SendClientMessage(playerid, RED, str);
				format(str, sizeof(str), "An admin has set your health to %d.", quantity);
				SendClientMessage(targetid, RED, str);
				format(str, sizeof(str), "Admin %s has set %s health to %d.", GetForumNameNC(playerid), GetOOCName(targetid), quantity);
				AdminActionLog(str);
				format(str, sizeof(str), "[CMD] Admin %s has set %s health to %d.", GetForumNameNC(playerid), GetOOCName(targetid), quantity);
				SendAdminMessage(RED, str);
				return 1;
			}
			else
			{
				SendClientMessage(playerid, GREY, "You can't set this item for a user.");
				return 1;
			}
		}
		else if(!strcmp(item, "armour", true))
		{
			if(PlayerStat[playerid][AdminLevel] >= 3)
			{
				SetArmour(targetid, quantity);
				PlayerStat[targetid][Armour] = quantity;
				format(str, sizeof(str), "You have changed %s's armour to %d.", GetOOCName(targetid), quantity);
				SendClientMessage(playerid, RED, str);
				format(str, sizeof(str), "An admin has set your armour to %d.", quantity);
				SendClientMessage(targetid, RED, str);
				format(str, sizeof(str), "Admin %s has set %s armour to %d.", GetForumNameNC(playerid), GetOOCName(targetid), quantity);
				AdminActionLog(str);
				format(str, sizeof(str), "[CMD] Admin %s has set %s armour to %d.", GetForumNameNC(playerid), GetOOCName(targetid), quantity);
				SendAdminMessage(RED, str);
				return 1;
			}
			else
			{
				SendClientMessage(playerid, GREY, "You can't set this item for a user.");
				return 1;
			}
		}
		else if(!strcmp(item, "male", true))
		{
			PlayerStat[targetid][Gender] = 1;
			format(str, sizeof(str), "You have changed %s's gender to Male.", GetOOCName(targetid));
			SendClientMessage(playerid, RED, str);
			format(str, sizeof(str), "Admin %s has set %s gender to 'Male'.", GetForumNameNC(playerid), GetOOCName(targetid));
			AdminActionLog(str);
			return 1;
		}
		else if(!strcmp(item, "female", true))
		{
			PlayerStat[targetid][Gender] = 0;
			format(str, sizeof(str), "You have changed %s's gender to Female.", GetOOCName(targetid));
			SendClientMessage(playerid, RED, str);
			format(str, sizeof(str), "Admin %s has set %s gender to 'Female'.", GetForumNameNC(playerid), GetOOCName(targetid));
			AdminActionLog(str);
			return 1;
		}
		else if(!strcmp(item, "bench", true))
		{
			if(PlayerStat[playerid][AdminLevel] >= 3)
			{
				if(0 <= quantity <= 100)
				{
					PlayerStat[targetid][StatPWR] = quantity;
					format(str, sizeof(str), "You have changed %s's bench power to %d.", GetOOCName(targetid), quantity);
					SendClientMessage(playerid, RED, str);
					format(str, sizeof(str), "An admin has set your bench power to %d.", quantity);
					SendClientMessage(targetid, RED, str);
					format(str, sizeof(str), "Admin %s has set %s bench power to %d.", GetForumNameNC(playerid), GetOOCName(targetid), quantity);
					AdminActionLog(str);
					return 1;
				}
				else return SendClientMessage(playerid, GREY, "Bench power is between 0 to 100.");
			}
			else
			{
				SendClientMessage(playerid, GREY, "You can't set this item for a user.");
				return 1;
			}
		}
		else if(!strcmp(item, "gangrank", true))
		{
			if(PlayerStat[playerid][AdminLevel] >= 4)
			{
				if(1 <= quantity <= 6)
				{
					if(PlayerStat[targetid][GangID] <= 0) return SendClientMessage(playerid, CMD_COLOR, "This player is not in a gang.");
					PlayerStat[targetid][GangRank] = quantity;
					format(str, sizeof(str), "You have changed %s's gang rank to %d.", GetOOCName(targetid), quantity);
					SendClientMessage(playerid, RED, str);
					format(str, sizeof(str), "An admin has set your gang rank to %d.", quantity);
					SendClientMessage(targetid, RED, str);
					format(str, sizeof(str), "Admin %s has set %s gang rank to %d.", GetForumNameNC(playerid), GetOOCName(targetid), quantity);
					AdminActionLog(str);
					return 1;
				}
				else return SendClientMessage(playerid, GREY, "Gang Rank is between 1 to 6.");
			}
			else
			{
				SendClientMessage(playerid, GREY, "You can't set this item for a user.");
				return 1;
			}
		}
		else if(!strcmp(item, "facrank", true))
		{
			if(PlayerStat[playerid][AdminLevel] >= 4)
			{
				if(1 <= quantity <= 11 && PlayerStat[targetid][FactionID] == 1)
				{
					PlayerStat[targetid][FactionRank] = quantity;
					format(str, sizeof(str), "You have changed %s's faction rank to %d.", GetOOCName(targetid), quantity);
					SendClientMessage(playerid, RED, str);
					format(str, sizeof(str), "An admin has set your faction rank to %d.", quantity);
					SendClientMessage(targetid, RED, str);
					format(str, sizeof(str), "Admin %s has set %s faction rank to %d.", GetForumNameNC(playerid), GetOOCName(targetid), quantity);
					AdminActionLog(str);
					return 1;
				}
				if(1 <= quantity <= 6 && PlayerStat[targetid][FactionID] == 2)
				{
					PlayerStat[targetid][FactionRank] = quantity;
					format(str, sizeof(str), "You have changed %s's faction rank to %d.", GetOOCName(targetid), quantity);
					SendClientMessage(playerid, RED, str);
					format(str, sizeof(str), "An admin has set your faction rank to %d.", quantity);
					SendClientMessage(targetid, RED, str);
					format(str, sizeof(str), "Admin %s has set %s faction rank to %d.", GetForumNameNC(playerid), GetOOCName(targetid), quantity);
					AdminActionLog(str);
					return 1;
				}
				else return SendClientMessage(playerid, GREY, "Faction Rank: DoC - 1 to 11. EMT - 1 to 6.");
			}
			else
			{
				SendClientMessage(playerid, GREY, "You can't set this item for a user.");
				return 1;
			}
		}
}
	else if(PlayerStat[playerid][HelperLevel] == 1)
	{
	    SendClientMessage(playerid, GREY, "Please use /hset insdead, as you are a helper.");
		return 1;
	}
	else if(PlayerStat[playerid][AdminLevel] == 0)
	{
	    SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
		return 1;
	}
	else if(PlayerStat[playerid][HelperLevel] <= 2)
	{
	    SendClientMessage(playerid, GREY, "You can't use this command.");
		return 1;
	}
	else if(PlayerStat[playerid][HelperLevel] == 0)
	{
	    SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
		return 1;
	}
    return 1;
}

//-----------------------------------------------------------------------[Level 4]------------------------------------------------------------------------------

COMMAND:makehelper(playerid, params[])
{
	new targetid, hlevel, str[128];
	if(PlayerStat[playerid][AdminLevel] == 5) goto cmd_start_owner;
	if(PlayerStat[playerid][HelperLevel] < 2) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
    if(sscanf(params,"ud", targetid, hlevel))return SendClientMessage(playerid, GREY, "USAGE: /makehelper [playerid] [helperlevel(0-1)]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
    if(hlevel < 0 || hlevel > 1) return SendClientMessage(playerid, GREY, "Invalid helper level.");
    if(PlayerStat[targetid][HelperLevel] <= hlevel)
	{
        format(str, sizeof(str), "Admin %s has promoted %s to a helper.", GetForumNameNC(playerid), GetOOCName(targetid));
        SendClientMessageToAll(GREEN, str);
        AdminActionLog(str);
        PlayerStat[targetid][HelperLevel] = hlevel;
		return 1;
    }
    if(PlayerStat[targetid][HelperLevel] > hlevel)
	{
        if(hlevel == 0)
		{
			format(str, sizeof(str), "Admin %s has demoted %s from being a helper.", GetForumNameNC(playerid), GetOOCName(targetid));
			SendClientMessageToAll(GREEN, str);
		}
        AdminActionLog(str);
        PlayerStat[targetid][HelperLevel] = hlevel;
		return 1;
    }
	cmd_start_owner:
    if(sscanf(params,"ud", targetid, hlevel))return SendClientMessage(playerid, GREY, "USAGE: /makehelper [playerid] [helperlevel(0-2)]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
    if(hlevel < 0 || hlevel > 2) return SendClientMessage(playerid, GREY, "Invalid helper level.");
    if(PlayerStat[targetid][HelperLevel] <= hlevel)
	{
        format(str, sizeof(str), "Admin %s has promoted %s to level %d helper.", GetForumNameNC(playerid), GetOOCName(targetid), hlevel);
        SendClientMessageToAll(GREEN, str);
        AdminActionLog(str);
        PlayerStat[targetid][HelperLevel] = hlevel;
		return 1;
    }
    if(PlayerStat[targetid][HelperLevel] > hlevel)
	{
        format(str, sizeof(str), "Admin %s has demoted %s to level %d helper.", GetForumNameNC(playerid), GetOOCName(targetid), hlevel);
        SendClientMessageToAll(GREEN, str);
        AdminActionLog(str);
        PlayerStat[targetid][HelperLevel] = hlevel;
		return 1;
    }
	return 1;
}

COMMAND:makegangleader(playerid, params[])
{
	new targetid, Gang, str[128];
	if(PlayerStat[playerid][AdminLevel] < 4) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
    if(sscanf(params,"ud", targetid, Gang))return SendClientMessage(playerid, GREY, "USAGE: /makegangleader [playerid] [gangid]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
    if(Gang <= 0) return SendClientMessage(playerid, GREY, "Invalid Gang ID.");
    if(Gang >= 7) return SendClientMessage(playerid, GREY, "Invalid Gang ID.");
    format(str, sizeof(str), "[CMD] Admin %s has made %s leader of Gang ID %d.", GetOOCName(playerid), GetOOCName(targetid), Gang);
    SendAdminMessage(RED, str);
    AdminActionLog(str);
    PlayerStat[targetid][GangID] = Gang;
    PlayerStat[targetid][GangRank] = 6;
    PlayerStat[targetid][FactionID] = 0;
    PlayerStat[targetid][FactionRank] = 0;
    format(GangStat[PlayerStat[targetid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[targetid][GangID]);
    format(GangStat[PlayerStat[targetid][GangID]][Leader], 60, "%s", GetOOCName(targetid));
    if(INI_Open(GangStat[PlayerStat[targetid][GangID]][GangFile])) return INI_WriteString("Leader", GangStat[PlayerStat[targetid][GangID]][Leader]);
    return 1;
}

COMMAND:forcepc(playerid, params[])
{
	new str[128], targetid;
	if(PlayerStat[playerid][AdminLevel] < 4) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	if(sscanf(params,"u", targetid))return SendClientMessage(playerid, GREY, "USAGE: /forcep(ay)c(heck) [playerid]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
	if(PlayerStat[targetid][Logged] == 0) return SendClientMessage(playerid, GREY, "Target ID not logged in.");
	format(str, sizeof(str), "Admin %s has forced your paycheck.", GetForumNameNC(playerid));
	SendClientMessage(targetid, GREEN, str);
	format(str, sizeof(str), "You have forced a paycheck on %s.", GetOOCName(targetid));
	SendClientMessage(targetid, GREEN, str);
	format(str, sizeof(str), "[CMD] Admin %s has forced paycheck on %s.", GetForumNameNC(playerid), GetOOCName(targetid));
	SendAdminMessage(RED, str);
	AdminActionLog(str);
	PlayerStat[targetid][PlayingMinutes] = 60;
	SetTimerEx("PlayerPayDay", 1000, false, "i", targetid);
	return 1;
}

COMMAND:resetgang(playerid, params[])
{
	new Gang, str[128];
	if(PlayerStat[playerid][AdminLevel] < 4) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
    if(sscanf(params,"d", Gang))return SendClientMessage(playerid, GREY, "USAGE: /resetgang [gangid]");
    if(Gang <= 0) return SendClientMessage(playerid, GREY, "Invalid Gang ID.");
    if(Gang >= 7) return SendClientMessage(playerid, GREY, "Invalid Gang ID.");
    format(GangStat[Gang][GangFile], 60, "Gangs/Gang %d.ini", Gang);
    if(INI_Open(GangStat[Gang][GangFile]))
    {
		format(GangStat[Gang][Leader], 60, "Nobody");
		format(GangStat[Gang][GangName], 60, "Nothing");
		format(GangStat[Gang][Rank1], 60, "None");
		format(GangStat[Gang][Rank2], 60, "None");
		format(GangStat[Gang][Rank3], 60, "None");
		format(GangStat[Gang][Rank4], 60, "None");
		format(GangStat[Gang][Rank5], 60, "None");
		format(GangStat[Gang][Rank6], 60, "None");
		format(GangStat[Gang][MOTD], 128, "Default MOTD.");
		GangStat[Gang][Skin1] = 50;
		GangStat[Gang][Skin2] = 50;
		GangStat[Gang][Skin3] = 50;
		GangStat[Gang][Skin4] = 50;
		GangStat[Gang][Skin5] = 50;
		GangStat[Gang][Skin6] = 50;
		GangStat[Gang][fSkin] = 50;
		GangStat[Gang][Members] = 0;

		SaveGang(Gang);

		format(str, sizeof(str), "[CMD] Admin %s has reset Gang ID %d.", GetOOCName(playerid), Gang);
        SendAdminMessage(RED, str);
        AdminActionLog(str);

		for(new i = 0; i < MAX_PLAYERS; i++)
	    {
			if(IsPlayerConnected(i) && PlayerStat[i][GangID] == Gang)
			{
				SendClientMessage(i, RED, "You have been kicked from your gang by an admin");
			    PlayerStat[playerid][GangID] = 0;
                PlayerStat[playerid][GangRank] = 0;
            }
        }
	}
    return 1;
}

COMMAND:makeleader(playerid, params[])
{
	new targetid, Faction, str[128];
	if(PlayerStat[playerid][AdminLevel] < 5) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
    if(sscanf(params,"ud", targetid, Faction))return SendClientMessage(playerid, GREY, "USAGE: /makeleader [playerid] [factionid]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
    if(Faction <= 0) return SendClientMessage(playerid, GREY, "Invalid Faction ID.");
    if(Faction >= 3) return SendClientMessage(playerid, GREY, "Invalid Faction ID.");
    if(Faction == 1)
    {
        format(str, sizeof(str), "[CMD] Admin %s has made %s leader of the Department of Corrections.", GetForumNameNC(playerid), GetOOCName(targetid));
        SendAdminMessage(RED, str);
		format(str, sizeof(str), "Admin %s has made %s leader of the Department of Corrections.", GetForumNameNC(playerid), GetOOCName(targetid));
        AdminActionLog(str);
        PlayerStat[targetid][GangID] = 0;
        PlayerStat[targetid][GangRank] = 0;
        PlayerStat[targetid][FactionID] = 1;
        PlayerStat[targetid][FactionRank] = 11;
    }
    else if(Faction == 2)
    {
        format(str, sizeof(str), "[CMD] Admin %s has made %s leader of the San Andreas Prison Infirmary.", GetForumNameNC(playerid), GetOOCName(targetid));
        SendAdminMessage(RED, str);
		format(str, sizeof(str), "Admin %s has made %s leader of the San Andreas Prison Infirmary.", GetForumNameNC(playerid), GetOOCName(targetid));
        AdminActionLog(str);
        PlayerStat[targetid][GangID] = 0;
        PlayerStat[targetid][GangRank] = 0;
        PlayerStat[targetid][FactionID] = 2;
        PlayerStat[targetid][FactionRank] = 6;
    }
    return 1;
}

COMMAND:createcell(playerid, params[])
{
    new Price, str[128];
	if(PlayerStat[playerid][AdminLevel] < 5) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
    if(sscanf(params,"d", Price))return SendClientMessage(playerid, GREY, "USAGE: /createcell [price] (Stand up infront of a 'SOUTH' cell in cellblock A.)");
    if(Server[LoadedCells] > MAX_CELLS) return SendClientMessage(playerid, GREY, "You can't create cells anymore (Max Number of Cells is 100)");
	new Float: PosX, Float: PosY, Float: PosZ;
	GetPlayerPos(playerid, PosX, PosY, PosZ);
	CreateCell(Price, PosX, PosY, PosZ, PosX -0.7574, PosY, PosZ); // +0.3
	SendClientMessage(playerid, GREY, "You have successfully created a cell.");
	format(str, sizeof(str), "Admin %s has created a new cell.", GetForumNameNC(playerid));
	AdminActionLog(str);
	return 1;
}

/*COMMAND:fixcell(playerid)
{
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	for(new c = 0; c < MAX_CELLS; c++)
	{
		new
				Float:pAng
		;
		GetPlayerFacingAngle(playerid, pAng);
		if(IsPlayerInRangeOfPoint(playerid, 0.3, CellStat[c][ExteriorX], CellStat[c][ExteriorY], CellStat[c][ExteriorZ]) && GetPlayerVirtualWorld(playerid) == 0)
		{
			new Float: PosX, Float: PosY, Float: PosZ;
			GetPlayerPos(playerid, PosX, PosY, PosZ);
			CellStat[c][InteriorY] = PosX -0.7574;
			SaveCell(c);
			SendClientMessage(playerid, WHITE, "Cell has been fixed.");
		}
	}
	return 1;
}

COMMAND:fixcell2(playerid)
{
	if(PlayerStat[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	for(new c = 0; c < MAX_CELLS; c++)
	{
		new
				Float:pAng
		;
		GetPlayerFacingAngle(playerid, pAng);
		if(IsPlayerInRangeOfPoint(playerid, 0.3, CellStat[c][ExteriorX], CellStat[c][ExteriorY], CellStat[c][ExteriorZ]) && GetPlayerVirtualWorld(playerid) == 0)
		{
			new Float: PosX, Float: PosY, Float: PosZ;
			GetPlayerPos(playerid, PosX, PosY, PosZ);
			CellStat[c][InteriorY] = PosX +0.7574;
			SaveCell(c);
			SendClientMessage(playerid, WHITE, "Cell has been fixed.");
		}
	}
	return 1;
}*/

COMMAND:createcell2(playerid, params[])
{
    new Price, str[128];
	if(PlayerStat[playerid][AdminLevel] < 5) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
    if(sscanf(params,"d", Price))return SendClientMessage(playerid, GREY, "USAGE: /createcell [price] (Stand up infront of a 'NORTH' cell in cellblock A.)");
    if(Server[LoadedCells] > MAX_CELLS) return SendClientMessage(playerid, GREY, "You can't create cells anymore (Max Number of Cells is 100)");
	new Float: PosX, Float: PosY, Float: PosZ;
	GetPlayerPos(playerid, PosX, PosY, PosZ);
	CreateCell(Price, PosX, PosY, PosZ, PosX +0.7574, PosY, PosZ); // -1.8898
	SendClientMessage(playerid, GREY, "You have successfully created a cell.");
	format(str, sizeof(str), "Admin %s has created a new cell.", GetForumNameNC(playerid));
	AdminActionLog(str);
	return 1;
}

CMD:ga(playerid, params[])
{
	new str[24], Float:FA;
	GetPlayerFacingAngle(playerid, FA);
	format(str, sizeof(str), "Your facing angle is %0.2f.", FA);
	SendClientMessage(playerid, WHITE, str);
	return 1;
}

COMMAND:setcelllevel(playerid, params[])
{
    new cellid, Level, str[128];
	if(PlayerStat[playerid][AdminLevel] < 5) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
    if(sscanf(params,"dd", cellid, Level)) return SendClientMessage(playerid, GREY, "USAGE: /setcelllevel [cellid] [level]");
    if(0 <= cellid <= MAX_CELLS)
    {
		CellStat[cellid][CellLevel] = Level;
		format(str, sizeof(str), "You have successfully changed Cell ID %d Level to %d", cellid, Level);
		SendClientMessage(playerid, GREY, str);
		format(str, sizeof(str), "Admin %s has changed Cell ID %d Level to %d.", GetForumNameNC(playerid), cellid, Level);
        AdminActionLog(str);
	}
    return 1;
}

COMMAND:gmx(playerid, params[])
{
	if(PlayerStat[playerid][AdminLevel] < 5) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	new str[128];
	format(str, sizeof(str), "Admin %s has restarted the server.", GetForumNameNC(playerid));
	AdminActionLog(str);
	Server[CurrentGMX] = 5;
    GameTextForAll("~r~ Server Restart ~w~ in ~g~ 5 ~w~ seconds!", 3000, 5);
    return 1;
}

COMMAND:reloadmap(playerid)
{
	if(PlayerStat[playerid][AdminLevel] < 5) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	new str[128];
	format(str, sizeof(str), "Admin %s has reloaded the map.", GetForumNameNC(playerid));
	AdminActionLog(str);
	GameTextForAll("~r~ Map restart, map will be loaded in ~w~ in ~g~ 5 ~w~ seconds!", 3000, 5);
	SendRconCommand("unloadfs MAP");
	SetTimer("RestartMap", 5000, false);
	return 1;
	
}

COMMAND:unban(playerid, params[])
{
	new str[128], account[30], file[128];
	if(PlayerStat[playerid][AdminLevel] < 4) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
    if(sscanf(params,"s[30]", account))return SendClientMessage(playerid, GREY, "USAGE: /unban [playeraccount]");
    format(file, sizeof(file), "Accounts/%s.ini", account);
    if(fexist(file))
    {
		if(INI_Open(file))
		{
			if(INI_ReadInt("Banned") == 1)
			{
                INI_WriteInt("Banned", 0);
				INI_WriteString("BannedReason", "None");
		        format(str, sizeof(str), "You have successfully unbanned account '%s'.", account);
		        SendClientMessage(playerid, RED, str);
		        format(str, sizeof(str), "[CMD] Admin %s has unbanned '%s'.", GetForumNameNC(playerid), account);
				SendAdminMessage(RED, str);
				format(str, sizeof(str), "Admin %s has unbanned '%s'.", GetForumNameNC(playerid), account);
                AdminActionLog(str);
				format(str, sizeof(str), "[UNBANNED] [Admin: %s].", GetForumNameNC(playerid));
				OfflinePlayerPunishLog(account, str);
                format(str, sizeof(str), "%s Unbanned.", account);
	            BanLog(str);

	            INI_Save();
	            INI_Close();
            }
            else return SendClientMessage(playerid, GREY, "This account isn't banned.");
        }
	}
	else return SendClientMessage(playerid, GREY, "This account does not exist.");
    return 1;
}

COMMAND:unbanip(playerid,params[])
{
    new str[128], ip[21];
    if(PlayerStat[playerid][AdminLevel] < 4) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
    if(sscanf(params,"s[21]", ip))return SendClientMessage(playerid, GREY, "USAGE: /unbanip [ip]");
    if(strlen(ip) >= 5)
    {
	    format(str, sizeof(str), "unbanip %s", ip);
		SendRconCommand(str);
	    format(str, sizeof(str), "You have successfully unbanned the ip '%s'", ip);
	    SendClientMessage(playerid, RED, str);
	    format(str, sizeof(str), "Admin %s has unbanned ip '%s'.", GetForumNameNC(playerid), ip);
	    AdminActionLog(str);
		format(str, sizeof(str), "[CMD] Admin %s has unbanned ip '%s'.", GetForumNameNC(playerid), ip);
		SendAdminMessage(RED, str);
	    format(str, sizeof(str), "IP Unbanned: %s.", ip);
	    BanLog(str);
	}
    return 1;
}

//-----------------------------------------------------------------------[Level 5]------------------------------------------------------------------------------

COMMAND:makeadmin(playerid, params[])
{
	new targetid, alevel, str[128];
	if(PlayerStat[playerid][AdminLevel] < 5) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
    if(sscanf(params,"ud", targetid, alevel))return SendClientMessage(playerid, GREY, "USAGE: /makeadmin [playerid] [adminlevel]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
    if(alevel < 0 || alevel > 5) return SendClientMessage(playerid, GREY, "Invalid admin level.");
    if(PlayerStat[targetid][AdminLevel] <= alevel)
	{
        format(str, sizeof(str), "Admin %s has promoted %s to level %d admin.", GetForumNameNC(playerid), GetForumNameNC(targetid), alevel);
        SendClientMessageToAll(RED, str);
        AdminActionLog(str);
        PlayerStat[targetid][AdminLevel] = alevel;
    }
    if(PlayerStat[targetid][AdminLevel] > alevel)
	{
        format(str, sizeof(str), "Admin %s has demoted %s to level %d admin.", GetForumNameNC(playerid), GetForumNameNC(targetid), alevel);
        SendClientMessageToAll(RED, str);
        AdminActionLog(str);
        PlayerStat[targetid][AdminLevel] = alevel;
    }
    return 1;
}

COMMAND:playmusicp(playerid, params[])
{
	new link[128], targetid, str[128];
	if(PlayerStat[playerid][AdminLevel] < 5) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	if(sscanf(params,"us[128]", targetid, link))return SendClientMessage(playerid, GREY, "USAGE: /playmusicp{layer} [playerid] [link]");
	format(str, sizeof(str), "%s", link);
	PlayAudioStreamForPlayer(targetid, str, 0, 0, 0, 0, 0);
	format(str, sizeof(str), "Admin %s is now playing music for you, write /musicoff to shut it down.", GetForumNameNC(playerid));
	SendClientMessage(targetid, GUARDS_RADIO, str);
	SendClientMessage(playerid, CMD_COLOR, "You are now playing music for the player.");
	return 1;
}

COMMAND:playmusica(playerid, params[])
{
	new link[128], str[128];
	if(PlayerStat[playerid][AdminLevel] < 5) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	if(sscanf(params,"s[128]", link))return SendClientMessage(playerid, GREY, "USAGE: /playmusica{ll} [link]");
	new i;
	i = 0;
	loop_start:
	if(i > 100) goto stop_loop;
	if(IsPlayerConnected(i) && PlayerStat[i][Logged] == 1)
	{
		format(str, sizeof(str), "%s", link);
		PlayAudioStreamForPlayer(i, str, 0, 0, 0, 0, 0);
		i++;
		format(str, sizeof(str), "Admin %s is now playing music for you, write /musicoff to shut it down.", GetForumNameNC(playerid));
		SendClientMessage(i, GUARDS_RADIO, str);
		goto loop_start;
	}
	else
	{
		i++;
		goto loop_start;
	}
	stop_loop:
	return 1;
}

COMMAND:musicoff(playerid)
{
	SendClientMessage(playerid, WHITE, "Music is turned off.");
	StopAudioStreamForPlayer(playerid);
	return 1;
}

COMMAND:hostname(playerid, params[])
{
	new str[128], newhost[50];
	if(PlayerStat[playerid][AdminLevel] < 5) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
    if(sscanf(params,"s[50]", newhost))return SendClientMessage(playerid, GREY, "USAGE: /hostname [newhostname]");
    if(5 < strlen(newhost) < 50)
	{
        format(str, sizeof(str), "Admin %s has changed the server hostname to %s.", GetForumNameNC(playerid), newhost);
        SendClientMessageToAll(RED, str);
        AdminActionLog(str);
        format(str, sizeof(str), "hostname %s", newhost);
        SendRconCommand(str);
    }
    else return SendClientMessage(playerid, GREY, "The hostname must be between 5 and 50 characters.");
    return 1;
}

COMMAND:applications(playerid, params[])
{
	if(PlayerStat[playerid][AdminLevel] < 4) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
	new status[8], str[128];
    if(sscanf(params,"s[8]", status))
	{
		SendClientMessage(playerid, GREY, "USAGE: /applications [on/off]");
	    return 1;
	}
    else if(!strcmp(status, "on", true) && ApplicationsAllowed == 1)
	{
		SendClientMessage(playerid, GREY, "Applications are already on.");
	    return 1;
	}
    else if(!strcmp(status, "off", true) && ApplicationsAllowed == 0)
	{
		SendClientMessage(playerid, GREY, "Applications are already off.");
	    return 1;
	}
    else if(!strcmp(status, "on", true))
	{
		SendClientMessage(playerid, CMD_COLOR, "Applications are now on.");
		ApplicationsAllowed = 1;
	    format(str, sizeof(str), "Admin %s has allowed new applicants registration.", GetForumNameNC(playerid));
	    AdminActionLog(str);
		format(str, sizeof(str), "[CMD] Admin %s has allowed new applicants registration.", GetForumNameNC(playerid));
		SendAdminMessage(RED, str);
	}
    else if(!strcmp(status, "off", true))
	{
		SendClientMessage(playerid, CMD_COLOR, "Applications are now off.");
		ApplicationsAllowed = 0;
	    format(str, sizeof(str), "Admin %s has disallowed new applicants registration.", GetForumNameNC(playerid));
	    AdminActionLog(str);
		format(str, sizeof(str), "[CMD] Admin %s has disallowed new applicants registration.", GetForumNameNC(playerid));
		SendAdminMessage(RED, str);
	}
	return 1;
}

COMMAND:setaname(playerid, params[])
{
	new targetid, AdminName, str[128];
	if(PlayerStat[playerid][AdminLevel] < 5) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
    if(sscanf(params,"ud", targetid, AdminName))return SendClientMessage(playerid, GREY, "USAGE: /setaname [playerid] [ID]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found.");
    PlayerStat[targetid][Aname] = AdminName;
	format(str, sizeof(str), "Admin %s has set your Forum Name to %s.", GetForumNameNC(playerid), GetForumNameNC(targetid));
    SendClientMessage(targetid, RED, str);
    format(str, sizeof(str), "You have changed %s Forum Name to [ID:%d] %s.", GetOOCName(targetid), AdminName, GetForumNameNC(targetid));
    SendClientMessage(playerid, RED, str);
	format(str, sizeof(str), "Admin %s have changed %s Forum Name to [ID:%d] %s.", GetForumNameNC(playerid), GetOOCName(targetid), AdminName, GetForumNameNC(targetid));
    AdminActionLog(str);
    return 1;
}

COMMAND:removeaccount(playerid, params[])
{
	new str[128], account[30], file[128];
	if(PlayerStat[playerid][AdminLevel] < 5) return SendClientMessage(playerid, WHITE, "SERVER: Unknown command.");
    if(sscanf(params,"s[30]", account))return SendClientMessage(playerid, GREY, "USAGE: /removeaccount [playeraccount]");
    format(file, sizeof(file), "Accounts/%s.ini", account);
    if(fexist(file))
    {
		INI_Remove(file);
		format(str, sizeof(str), "You have successfully removed account '%s'.", account);
		SendClientMessage(playerid, RED, str);
		format(str, sizeof(str), "Admin %s has deleted account '%s'.", GetForumNameNC(playerid), account);
        AdminActionLog(str);
	}
	else return SendClientMessage(playerid, GREY, "This account does not exist.");
    return 1;
}

//-----------------------------------------------------------------------[Animations]---------------------------------------------------------------------------------

COMMAND:handsup(playerid, params[])
{
    if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1)
	{
        SendClientMessage(playerid, GREY, "You can't use this animation right now.");
		return 1;
	}
	if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
	SetPlayerSpecialAction(playerid,SPECIAL_ACTION_HANDSUP);
    return 1;
}

COMMAND:hide(playerid, params[])
{
    if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1)
	{
        SendClientMessage(playerid, GREY, "You can't use this animation right now.");
		return 1;
	}
	ApplyLoopingAnimation(playerid, "ped", "cower", 3.0, 1, 0, 0, 0, 0);
    return 1;
}

COMMAND:aim(playerid, params[])
{
    if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1)
	{
        SendClientMessage(playerid, GREY, "You can't use this animation right now.");
		return 1;
    }
	ApplyLoopingAnimation(playerid, "SHOP", "ROB_Loop_Threat", 4.0, 1, 0, 0, 0, 0);
    return 1;
}

COMMAND:lookout(playerid, params[])
{
    if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1)
	{
        SendClientMessage(playerid, GREY, "You can't use this animation right now.");
		return 1;
	}
	if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
	ApplyAnimation(playerid, "SHOP", "ROB_Shifty", 4.0, 0, 0, 0, 0, 0);
    return 1;
}

COMMAND:bomb(playerid, params[])
{
    if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1)
	{
        SendClientMessage(playerid, GREY, "You can't use this animation right now.");
		return 1;
	}
	if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
	ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0);
    return 1;
}

COMMAND:laugh(playerid, params[])
{
    if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1)
	{
        SendClientMessage(playerid, GREY, "You can't use this animation right now.");
		return 1;
	}
	if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
	ApplyAnimation(playerid, "RAPPING", "Laugh_01", 4.0, 0, 0, 0, 0, 0);
    return 1;
}

COMMAND:vomit(playerid, params[])
{
    if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1)
	{
        SendClientMessage(playerid, GREY, "You can't use this animation right now.");
		return 1;
	}
	if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
	ApplyAnimation(playerid, "FOOD", "EAT_Vomit_P", 3.0, 0, 0, 0, 0, 0);
    return 1;
}

COMMAND:eatstand(playerid, params[])
{
    if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1)
	{
        SendClientMessage(playerid, GREY, "You can't use this animation right now.");
		return 1;
	}
	if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
	ApplyAnimation(playerid, "FOOD", "EAT_Burger", 3.0, 0, 0, 0, 0, 0);
    return 1;
}

COMMAND:walk(playerid, params[])
{
	new style;
    if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1)
	{
        SendClientMessage(playerid, GREY, "You can't use this animation right now.");
		return 1;
	}
	if(sscanf(params,"d", style))return SendClientMessage(playerid, GREY, "USAGE: /walk [style 1-9]");
	switch(style)
	{
		case 1: ApplyLoopingAnimation(playerid, "PED", "WOMAN_walksexy", 4.1, 1, 1, 1, 1, 1);
		case 2: ApplyLoopingAnimation(playerid, "PED", "WOMAN_walkold", 4.1, 1, 1, 1, 1, 1);
		case 3: ApplyLoopingAnimation(playerid, "PED", "WOMAN_walknorm", 4.1, 1, 1, 1, 1, 1);
		case 4: ApplyLoopingAnimation(playerid, "PED", "WOMAN_runfatold", 4.1, 1, 1, 1, 1, 1);
		case 5: ApplyLoopingAnimation(playerid, "PED", "woman_runpanic", 4.1, 1, 1, 1, 1, 1);
		case 6: ApplyLoopingAnimation(playerid, "PED", "WALK_drunk", 4.1, 1, 1, 1, 1, 1);
		case 7: ApplyLoopingAnimation(playerid, "PED", "WALK_fat", 4.1, 1, 1, 1, 1, 1);
		case 8: ApplyLoopingAnimation(playerid, "PED", "WALK_fatold", 4.1, 1, 1, 1, 1, 1);
		case 9: ApplyLoopingAnimation(playerid, "PED", "WALK_csaw", 4.1, 1, 1, 1, 1, 1);
	}
    return 1;
}

COMMAND:dice(playerid)
{
	if(PlayerStat[playerid][Dices] < 1) return SendClientMessage(playerid, GREY, "You don't have a dice.");
	if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1) return SendClientMessage(playerid, GREY, "You can't use your dice now.");
	Random0:
	new Random = random(7);
	new str[128];
	if(Random == 0)
	{
		goto Random0;
	}
	format(str, sizeof(str), "* %s rolls the dice on the floor and lands it on %d", GetICName(playerid), Random);
    SendNearByMessage(playerid, ACTION_COLOR, str, 12);
    ICLog(str);
	return 1;
}

COMMAND:coin(playerid)
{
	if(PlayerStat[playerid][Money] < 1) return SendClientMessage(playerid, GREY, "You don't have a coin.");
	if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1) return SendClientMessage(playerid, GREY, "You can't flip a coin now.");
	new Random = random(2);
	new str[128];
	if(Random == 0)
	{
		format(str, sizeof(str), "* %s throws a coin in the air, landing it on heads.", GetICName(playerid));
	}
	if(Random == 1)
	{
		format(str, sizeof(str), "* %s throws a coin in the air, landing it on tails.", GetICName(playerid));
	}
    SendNearByMessage(playerid, ACTION_COLOR, str, 12);
    ICLog(str);
	return 1;
}

COMMAND:gwalk(playerid, params[])
{
	new style;
    if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1)
	{
        SendClientMessage(playerid, GREY, "You can't use this animation right now.");
		return 1;
	}
	if(sscanf(params,"d", style))return SendClientMessage(playerid, GREY, "USAGE: /gwalk [style 1-2]");
	switch(style)
	{
		case 1: ApplyLoopingAnimation(playerid, "PED", "WALK_gang1", 4.1, 1, 1, 1, 1, 1);
		case 2: ApplyLoopingAnimation(playerid, "PED", "WALK_gang2", 4.1, 1, 1, 1, 1, 1);
	}
    return 1;
}

COMMAND:crossarms(playerid, params[])
{
    if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1)
	{
        SendClientMessage(playerid, GREY, "You can't use this animation right now.");
		return 1;
	}
	ApplyLoopingAnimation(playerid, "COP_AMBIENT", "Coplook_loop", 4.0, 1, 0, 0, 0, 0);
    return 1;
}

COMMAND:sit(playerid, params[])
{
	new style;
    if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1)
	{
        SendClientMessage(playerid, GREY, "You can't use this animation right now.");
		return 1;
	}
	if(sscanf(params,"d", style))return SendClientMessage(playerid, GREY, "USAGE: /sit [style 1-2]");
	switch(style)
	{
		case 1: ApplyLoopingAnimation(playerid, "PED", "SEAT_idle", 4.0, 1, 0, 0, 0, 0);
		case 2: ApplyLoopingAnimation(playerid, "BEACH", "ParkSit_M_loop", 4.0, 1, 0, 0, 0, 0);
	}
	PlayerSitting[playerid] = 1;
    return 1;
}

COMMAND:lay(playerid, params[])
{
    if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1)
	{
        SendClientMessage(playerid, GREY, "You can't use this animation right now.");
		return 1;
	}
	ApplyLoopingAnimation(playerid,"BEACH", "bather", 4.0, 1, 0, 0, 0, 0);
    return 1;
}

COMMAND:injured(playerid, params[])
{
    if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1)
	{
        SendClientMessage(playerid, GREY, "You can't use this animation right now.");
		return 1;
	}
	new style;
	if(sscanf(params,"d", style))return SendClientMessage(playerid, GREY, "USAGE: /injured [style 1-2]");
	switch(style)
	{
		case 1: ApplyLoopingAnimation(playerid,"SWEET", "LaFin_Sweet", 4.1, 0, 0, 0, 1, 0);
		case 2: ApplyLoopingAnimation(playerid,"SWEET", "Sweet_injuredloop ", 4.1, 1, 0, 0, 0, 0);
	}
	
    return 1;
}

COMMAND:cry(playerid, params[])
{
    if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1)
	{
        SendClientMessage(playerid, GREY, "You can't use this animation right now.");
		return 1;
	}
	new style;
	if(sscanf(params,"d", style))return SendClientMessage(playerid, GREY, "USAGE: /cry [style 1-2]");
	switch(style)
	{
		case 1: ApplyLoopingAnimation(playerid,"GRAVEYARD", "mrnF_loop", 4.1, 1, 0, 0, 0, 0);
		case 2: ApplyLoopingAnimation(playerid,"SWEET", "Sweet_injuredloop ", 4.1, 1, 0, 0, 0, 0);
	}
	
    return 1;
}

COMMAND:gpunch(playerid, params[])
{
    if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1)
	{
        SendClientMessage(playerid, GREY, "You can't use this animation right now.");
		return 1;
	}
	ApplyAnimation(playerid,"FIGHT_B", "FightB_G", 4.1, 0, 0, 0, 0, 0);
    return 1;
}

COMMAND:grkick(playerid, params[])
{
    if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1)
	{
        SendClientMessage(playerid, GREY, "You can't use this animation right now.");
		return 1;
	}
	ApplyAnimation(playerid,"FIGHT_D", "FightD_G", 4.1, 0, 0, 0, 0, 0);
    return 1;
}

COMMAND:angry(playerid, params[])
{
    if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1)
	{
        SendClientMessage(playerid, GREY, "You can't use this animation right now.");
		return 1;
	}
	ApplyAnimation(playerid,"RIOT", "RIOT_ANGRY", 4.1, 0, 0, 0, 0, 0);
    return 1;
}

COMMAND:slapass(playerid, params[])
{
    if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1)
	{
        SendClientMessage(playerid, GREY, "You can't use this animation right now.");
		return 1;
	}
	ApplyAnimation(playerid,"SWEET", "sweet_ass_slap", 4.1, 0, 0, 0, 0, 0);
    return 1;
}

COMMAND:stretch(playerid, params[])
{
    if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1)
	{
        SendClientMessage(playerid, GREY, "You can't use this animation right now.");
		return 1;
	}
	ApplyAnimation(playerid,"PLAYIDLES", "stretch", 4.1, 0, 0, 0, 0, 0);
    return 1;
}

COMMAND:idle(playerid, params[])
{
    new style;
    if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1)
	{
        SendClientMessage(playerid, GREY, "You can't use this animation right now.");
	}
	if(sscanf(params,"d", style))return SendClientMessage(playerid, GREY, "USAGE: /idle [style 1-3]");
	switch(style)
	{
		case 1: ApplyLoopingAnimation(playerid, "PLAYIDLES", "shift", 4.1, 1, 0, 0, 0, 0);
		case 2: ApplyLoopingAnimation(playerid, "PLAYIDLES", "shldr", 4.1, 1, 0, 0, 0, 0);
		case 3: ApplyLoopingAnimation(playerid, "PLAYIDLES", "strleg", 4.1, 1, 0, 0, 0, 0);
	}
    return 1;
}

COMMAND:ghand(playerid, params[])
{
    new style;
    if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1)
	{
        SendClientMessage(playerid, GREY, "You can't use this animation right now.");
	}
	if(sscanf(params,"d", style))return SendClientMessage(playerid, GREY, "USAGE: /ghand [style 1-5]");
	switch(style)
	{
		case 1: ApplyLoopingAnimation(playerid, "GHANDS", "gsign1LH", 4.1, 0, 0, 0, 0, 0);
		case 2: ApplyLoopingAnimation(playerid, "GHANDS", "gsign2LH", 4.1, 0, 0, 0, 0, 0);
		case 3: ApplyLoopingAnimation(playerid, "GHANDS", "gsign3LH", 4.1, 0, 0, 0, 0, 0);
		case 4: ApplyLoopingAnimation(playerid, "GHANDS", "gsign4LH", 4.1, 0, 0, 0, 0, 0);
		case 5: ApplyLoopingAnimation(playerid, "GHANDS", "gsign5LH", 4.1, 0, 0, 0, 0, 0);
	}
    return 1;
}

COMMAND:chant(playerid, params[])
{
    if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1)
	{
        SendClientMessage(playerid, GREY, "You can't use this animation right now.");
	}
	ApplyLoopingAnimation(playerid, "RIOT", "RIOT_CHANT", 4.1, 1, 0, 0, 0, 0);
    return 1;
}

COMMAND:follow(playerid, params[])
{
    new style;
    if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1)
	{
        SendClientMessage(playerid, GREY, "You can't use this animation right now.");
	}
	if(sscanf(params,"d", style))return SendClientMessage(playerid, GREY, "USAGE: /follow [style 1-2]");
	switch(style)
	{
		case 1: ApplyLoopingAnimation(playerid, "RIOT", "RIOT_challenge", 4.1, 0, 0, 0, 0, 0);
		case 2: ApplyAnimation(playerid, "GHANDS", "gsign2LH", 4.1, 0, 0, 0, 0, 0);
	}
    return 1;
}

COMMAND:gsign(playerid, params[])
{
    new style;
    if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1)
	{
        SendClientMessage(playerid, GREY, "You can't use this animation right now.");
	}
	if(sscanf(params,"d", style))return SendClientMessage(playerid, GREY, "USAGE: /gsign [style 1-4]");
	switch(style)
	{
		case 1: ApplyLoopingAnimation(playerid, "GHANDS", "gsign1", 4.1, 0, 0, 0, 0, 0);
		case 2: ApplyLoopingAnimation(playerid, "GHANDS", "gsign2", 4.1, 0, 0, 0, 0, 0);
		case 3: ApplyLoopingAnimation(playerid, "GHANDS", "gsign3", 4.1, 0, 0, 0, 0, 0);
		case 4: ApplyLoopingAnimation(playerid, "GHANDS", "gsign4", 4.1, 0, 0, 0, 0, 0);
	}
    return 1;
}

COMMAND:wave(playerid, params[])
{
    if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1)
	{
        SendClientMessage(playerid, GREY, "You can't use this animation right now.");
	}
	ApplyLoopingAnimation(playerid, "ON_LOOKERS", "wave_loop", 1, 1, 0, 0, 0, 0);
    return 1;
}

COMMAND:taichi(playerid, params[])
{
    if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1)
	{
        SendClientMessage(playerid, GREY, "You can't use this animation right now.");
	}
	ApplyLoopingAnimation(playerid,"PARK","Tai_Chi_Loop", 4.0, 1, 0, 0, 0, 0);
    return 1;
}

COMMAND:deal(playerid, params[])
{
    if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1)
	{
        SendClientMessage(playerid, GREY, "You can't use this animation right now.");
	}
	if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
	ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.0, 0, 0, 0, 0, 0);
    return 1;
}

COMMAND:crack(playerid, params[])
{
    if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1)
	{
        SendClientMessage(playerid, GREY, "You can't use this animation right now.");
	}
	ApplyLoopingAnimation(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0);
    return 1;
}

COMMAND:leansmoke(playerid, params[])
{
    new style;
    if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1)
	{
        SendClientMessage(playerid, GREY, "You can't use this animation right now.");
	}
	if(sscanf(params,"d", style))return SendClientMessage(playerid, GREY, "USAGE: /leansmoke [style 1-2]");
	switch(style)
	{
		case 1: ApplyLoopingAnimation(playerid,"SMOKING", "M_smklean_loop", 4.0, 1, 0, 0, 0, 0);
		case 2: ApplyLoopingAnimation(playerid, "SMOKING", "F_smklean_loop", 4.0, 1, 0, 0, 0, 0);
	}
    return 1;
}

COMMAND:fucku(playerid, params[])
{
    if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1)
	{
        SendClientMessage(playerid, GREY, "You can't use this animation right now.");
	}
	if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
	ApplyAnimation(playerid,"PED","fucku", 4.0, 0, 0, 0, 0, 0);
    return 1;
}

COMMAND:soundtest(playerid, params[])
{
	new sound;
	if(sscanf(params,"d", sound))return SendClientMessage(playerid, GREY, "USAGE: /soundtest [soundid]");
	PlayerPlaySound(playerid, sound, 0, 0, 0);
	return 1;
}

COMMAND:animtest(playerid, params[])
{
	new libn[20], anim[20];
	if(sscanf(params,"s[20]s[20]", libn, anim))return SendClientMessage(playerid, GREY, "USAGE: /animtest [libid] [animname]");
	ApplyAnimation(playerid, libn, anim, 4.1, 0, 0, 0, 0, 0);
	return 1;
}

COMMAND:dance(playerid, params[])
{
	new style;
    if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1)
	{
        SendClientMessage(playerid, GREY, "You can't use this animation right now.");
		return 1;
	}
	if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
	if(sscanf(params,"d", style))return SendClientMessage(playerid, GREY, "USAGE: /dance [style 1-6]");
	switch(style)
	{
		case 1: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE1);
		case 2: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE2);
		case 3: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE3);
		case 4: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE4);
		case 5: ApplyLoopingAnimation(playerid, "DANCING", "bd_clap", 4.1, 1, 0, 0, 0, 0);
		case 6: ApplyLoopingAnimation(playerid, "DANCING", "dance_loop", 4.1, 1, 0, 0, 0, 0);
	}
    return 1;
}

COMMAND:superdance5(playerid)
{
    if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1)
	{
        SendClientMessage(playerid, GREY, "You can't use this animation right now.");
		return 1;
	}
	ApplyLoopingAnimation(playerid,"DANCING","bd_clap1", 4.1, 1, 0, 0, 0, 0);
    return 1;
}

COMMAND:win(playerid, params[])
{
    if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1)
	{
        SendClientMessage(playerid, GREY, "You can't use this animation right now.");
		return 1;
	}
	ApplyAnimation(playerid,"OTB","wtchrace_win", 4.1, 0, 0, 0, 0, 0);
    return 1;
}

COMMAND:lose(playerid, params[])
{
    if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1)
	{
        SendClientMessage(playerid, GREY, "You can't use this animation right now.");
		return 1;
	}
	ApplyAnimation(playerid,"OTB","wtchrace_lose", 4.1, 0, 0, 0, 0, 0);
    return 1;
}

COMMAND:rap(playerid, params[])
{
	new style;
    if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1)
	{
        SendClientMessage(playerid, GREY, "You can't use this animation right now.");
	}
	if(sscanf(params,"d", style))return SendClientMessage(playerid, GREY, "USAGE: /rap [style 1-3]");
	switch(style)
	{
		case 1: ApplyLoopingAnimation(playerid, "RAPPING", "RAP_A_Loop", 4.0, 1, 0, 0, 0, 0);
		case 2: ApplyLoopingAnimation(playerid, "RAPPING", "RAP_B_Loop", 4.0, 1, 0, 0, 0, 0);
		case 3: ApplyLoopingAnimation(playerid, "RAPPING", "RAP_C_Loop", 4.0, 1, 0, 0, 0, 0);
	}
    return 1;
}

COMMAND:piss(playerid, params[])
{
    if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][Dead] == 1)
	{
        SendClientMessage(playerid, GREY, "You can't use this animation right now.");
	}
	if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
	SetPlayerSpecialAction(playerid, 68);
    return 1;
}

COMMAND:shakehand(playerid, params[])
{
    if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
	new targetid, style, str[128];
    if(PlayerStat[playerid][Tased] == 1 || PlayerStat[playerid][Cuffed] == 1)
	{
        SendClientMessage(playerid, GREY, "You can't use this animation right now.");
	}
	if(sscanf(params,"ud", targetid, style))return SendClientMessage(playerid, GREY, "USAGE: /shakehand [playerid] [style 1-9]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, GREY, "Target ID not found");
	if(IsPlayerInRangeOfPlayer(2.0, playerid, targetid))
	{
		if(1 <= style <= 9)
		{
            PlayerStat[targetid][HandShakeStyle] = style;
		    PlayerStat[targetid][HandShakeTarget] = playerid;
            format(str, sizeof(str), "%s is requesting to shake your hand, type /accept handshake to shake hands.", GetICName(playerid));
            SendClientMessage(targetid, GREY, str);
            format(str, sizeof(str), "You have requested to shake %s's hand.", GetICName(targetid));
            SendClientMessage(playerid, GREY, str);
		}
		else return SendClientMessage(playerid, GREY, "Invalid Style");
	}
	else return SendClientMessage(playerid, GREY, "Target ID is too far away");
    return 1;
}

//-----------------------------------------------------------------------[Jobs Commands]------------------------------------------------------------------------------
COMMAND:job(playerid, params[])
{
    if(isnull(params)) return SendClientMessage(playerid, GREY, "USAGE: /job [join/quit]");
	else if(!strcmp(params, "join", true))
	{
		if(PlayerStat[playerid][FactionID] >= 1) return SendClientMessage(playerid, GREY, "Guards/Medics cannot join prisoner jobs.");
    	if(IsPlayerInRangeOfPoint(playerid, 3.0, 215.9945, 1440.0245, 9.9381))
    	{
	    	if(PlayerStat[playerid][JobID] >= 1) return SendClientMessage(playerid, GREY, "You already have a job (use /job quit to leave it).");
	    	SendClientMessage(playerid, GOLD, "You have joined the Garbage Man job, use /jobhelp to find the commands of this job.");
	     	PlayerStat[playerid][JobID] = 1;
	     	PlayerStat[playerid][AbleToCollectGarbage] = 1;
            PlayerStat[playerid][JobID1ReloadTime] = 0;
     	}
    	else if(IsPlayerInRangeOfPoint(playerid, 3.0, 442.9026,1640.4260,1001.9429))
    	{
    		if(PlayerStat[playerid][JobID] >= 1) return SendClientMessage(playerid, GREY, "You already have a job (use /job quit to leave it).");
     		SendClientMessage(playerid, GOLD, "You have joined the Table Cleaner job, use /jobhelp to find the commands of this job.");
     		PlayerStat[playerid][JobID] = 2;
     		PlayerStat[playerid][AbleToCleanTables] = 1;
            PlayerStat[playerid][JobID2ReloadTime] = 0;
    	}
    	else if(IsPlayerInRangeOfPoint(playerid, 3.0, 1094.9459,2117.4058,11.5))
    	{
    		if(PlayerStat[playerid][JobID] >= 1) return SendClientMessage(playerid, GREY, "You already have a job (use /job quit to leave it).");
     		SendClientMessage(playerid, GOLD, "You have joined the Warehouse Worker job, use /jobhelp to find the commands of this job.");
     		PlayerStat[playerid][JobID] = 4;
            PlayerStat[playerid][JobID4ReloadTime] = 0;
            PlayerStat[playerid][JobID4CHP] = 0;
    	}
    	else if(IsPlayerInRangeOfPoint(playerid, 3.0, 440.4420, 1666.7238, 1001.0000))
    	{
	    	if(PlayerStat[playerid][JobID] >= 1) return SendClientMessage(playerid, GREY, "You already have a job (use /job quit to leave it).");
	    	SendClientMessage(playerid, GOLD, "You have joined the Laundry Worker job, use /jobhelp to find the commands of this job.");
	    	PlayerStat[playerid][JobID] = 3;
    	}
	    else return SendClientMessage(playerid, GREY, "You are not near any Job right now.");
	}
	else if(!strcmp(params, "quit", true))
	{
		new str[128];
		if(PlayerStat[playerid][JobID] < 1) return SendClientMessage(playerid, GREY, "You don't have a job to quit.");
		if(PlayerStat[playerid][DonLV] >= 1) goto leave_job_bronze;
		if(PlayerStat[playerid][HoursInJob] <= 4)
		{
		    format(str, sizeof(str), "You must get 5 pay-checks before leaving your job. you currently have (%d)." , PlayerStat[playerid][HoursInJob]);
		    SendClientMessage(playerid, GREY, str);
		}
		else
		{
			leave_job_bronze:
		    SendClientMessage(playerid, GOLD, "You have successfully left your job.");
		    PlayerStat[playerid][HoursInJob] = 0;
		    PlayerStat[playerid][JobID] = 0;
		}
	}
	else return SendClientMessage(playerid, GREY, "Invalid option.");
    return 1;
}

COMMAND:takebox(playerid, params[])
{
	if(PlayerStat[playerid][JobID] == 4)
	{
        new str[128];
		if(IsPlayerInRangeOfPoint(playerid, 2.0, 1071.9346,2117.6206,11.3))
		{
			if(PlayerStat[playerid][JobID4ReloadTime] >= 1) return SendClientMessage(playerid, GREY, "You can't pick up any boxes right now.");
			if(PlayerStat[playerid][JobID4BOX] == 1) return SendClientMessage(playerid, GREY, "You already carry a box.");
			DisablePlayerCheckpoint(playerid);
			SendClientMessage(playerid, WHITE, "You have picked up a box.");
			PlayerStat[playerid][JobID4BOX] = 1;
		 	SetPlayerAttachedObject(playerid, INDEX_LIGHT,1271, 6, 0.1, 0.22, -0.2, 0, 1, 0, 0.5, 0.5, 0.5);
		 	ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 1, 1, 1, 1, 1);
			PlayerStat[playerid][JobID4CHP] += 1;
        	format(str, sizeof(str), "* %s bends and picks a box up.", GetICName(playerid));
        	SendNearByMessage(playerid, ACTION_COLOR, str, 5);
			if(PlayerStat[playerid][JobID4CHP] == 1)
			{
                SetPlayerCheckpoint(playerid, 1063.1855, 2121.4922, 10.0, 2.5);
			}
			else if(PlayerStat[playerid][JobID4CHP] == 2)
			{
                SetPlayerCheckpoint(playerid, 1072.1123, 2079.8716, 10.0, 2.5);
			}
			else if(PlayerStat[playerid][JobID4CHP] == 3)
			{
                SetPlayerCheckpoint(playerid, 1066.3882, 2100.9395, 10.0, 2.5);
			}
			else if(PlayerStat[playerid][JobID4CHP] == 4)
			{
                SetPlayerCheckpoint(playerid, 1062.6729, 2106.6743, 10.0, 2.5);
			}
			else if(PlayerStat[playerid][JobID4CHP] == 5)
			{
                SetPlayerCheckpoint(playerid, 1091.3585, 2099.3767, 14.8446, 2.5);
			}
		}
		else
		{
	    	SendClientMessage(playerid, GREY, "Theres no boxes to pick.");
		}
	}
	else
	{
	    SendClientMessage(playerid, GREY, "You are not a warehouse worker.");
	}
	return 1;
}

COMMAND:putbox(playerid, params[])
{
	if(PlayerStat[playerid][JobID] == 4)
	{
        new str[128];
		if(PlayerStat[playerid][JobID4BOX] == 0) return SendClientMessage(playerid, GREY, "You are not holding any boxes.");
		if(IsPlayerInRangeOfPoint(playerid, 2.0, 1063.1855,2121.4922,11.3)) // 1
		{
			if(PlayerStat[playerid][JobID4CHP] == 1)
			{
            	DisablePlayerCheckpoint(playerid);
				RemoveBox(playerid);
		 		ApplyAnimation(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0);
            	SetPlayerCheckpoint(playerid, 1071.9346, 2117.6206, 10.0, 2.0);
        		format(str, sizeof(str), "* %s bends and places the box down.", GetICName(playerid));
        		SendNearByMessage(playerid, ACTION_COLOR, str, 5);
			}
			else
			{
			    SendClientMessage(playerid, GREY, "You can't put thix box down here.");
			}
		}
		else if(IsPlayerInRangeOfPoint(playerid, 2.0, 1072.1123,2079.8716,11.3)) // 2
		{
			if(PlayerStat[playerid][JobID4BOX] == 0) return SendClientMessage(playerid, GREY, "You are not holding any boxes.");
			if(PlayerStat[playerid][JobID4CHP] == 2)
			{
            	DisablePlayerCheckpoint(playerid);
				RemoveBox(playerid);
		 		ApplyAnimation(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0);
            	SetPlayerCheckpoint(playerid, 1071.9346, 2117.6206, 10.0, 2.0);
        		format(str, sizeof(str), "* %s bends and places the box down.", GetICName(playerid));
        		SendNearByMessage(playerid, ACTION_COLOR, str, 5);
			}
			else
			{
			    SendClientMessage(playerid, GREY, "You can't put thix box down here.");
			}
		}
		else if(IsPlayerInRangeOfPoint(playerid, 2.0, 1066.3882,2100.9395,11.3)) // 3
		{
			if(PlayerStat[playerid][JobID4BOX] == 0) return SendClientMessage(playerid, GREY, "You are not holding any boxes.");
			if(PlayerStat[playerid][JobID4CHP] == 3)
			{
            	DisablePlayerCheckpoint(playerid);
				RemoveBox(playerid);
		 		ApplyAnimation(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0);
            	SetPlayerCheckpoint(playerid, 1071.9346, 2117.6206, 10.0, 2.0);
        		format(str, sizeof(str), "* %s bends and places the box down.", GetICName(playerid));
        		SendNearByMessage(playerid, ACTION_COLOR, str, 5);
			}
			else
			{
			    SendClientMessage(playerid, GREY, "You can't put thix box down here.");
			}
		}
		else if(IsPlayerInRangeOfPoint(playerid, 2.0, 1062.6729,2106.6743,11.3)) // 4
		{
			if(PlayerStat[playerid][JobID4BOX] == 0) return SendClientMessage(playerid, GREY, "You are not holding any boxes.");
			if(PlayerStat[playerid][JobID4CHP] == 4)
			{
				DisablePlayerCheckpoint(playerid);
				RemoveBox(playerid);
		 		ApplyAnimation(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0);
            	SetPlayerCheckpoint(playerid, 1071.9346, 2117.6206, 10.00, 2.0);
        		format(str, sizeof(str), "* %s bends and places the box down.", GetICName(playerid));
        		SendNearByMessage(playerid, ACTION_COLOR, str, 5);
			}
			else
			{
			    SendClientMessage(playerid, GREY, "You can't put thix box down here.");
			}
		}
		else if(IsPlayerInRangeOfPoint(playerid, 2.0, 1091.3585,2099.3767,16.2446)) // Final Warehouse Job Checkpoint
		{
			if(PlayerStat[playerid][JobID4BOX] == 0) return SendClientMessage(playerid, GREY, "You are not holding any boxes.");
			if(PlayerStat[playerid][JobID4CHP] == 5)
			{
            	DisablePlayerCheckpoint(playerid);
				RemoveBox(playerid);
		 		ApplyAnimation(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0);
				SendClientMessage(playerid, WHITE, "You have placed the fianl box, 30$ has been added to your next paycheck.");
        		format(str, sizeof(str), "* %s bends and places the box down.", GetICName(playerid));
        		SendNearByMessage(playerid, ACTION_COLOR, str, 5);
          		PlayerStat[playerid][JobID4ReloadTime] = 1200;
          		PlayerStat[playerid][Paycheck] += 30;
          		PlayerStat[playerid][JobID4CHP] = 0;
			}
			else
			{
	    		SendClientMessage(playerid, GREY, "You can't put the box down here.");
			}
		}
	}
	else
	{
	    SendClientMessage(playerid, GREY, "You are not a warehouse worker.");
	}
	return 1;
}

/*COMMAND:stopwork(playerid, params[])
{
	if(PlayerStat[playerid][CollectingGarbage] == 1)
	{
		TogglePlayerDynamicCP(playerid, GarbageCheckpoint, 0);
		PlayerStat[playerid][CollectingGarbage] = 0;
		RemovePlayerAttachedObject(playerid, INDEX_GARBAGE);
		SendClientMessage(playerid, GREY, "Picking Garbage bags Canceled.");
    }
    else if(PlayerStat[playerid][CleaningTables] == 1)
	{
		ToggleCheckpoints(playerid);
		PlayerStat[playerid][CleaningTables] = 0;
		// NIGGA
		SendClientMessage(playerid, GREY, "Cleaning Tables Canceled.");
    }
    else return SendClientMessage(playerid, GREY, "You can't use this command while not working.");
    return 1;
}


COMMAND:pickgarbage(playerid, params[])
{
    if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
	if(PlayerStat[playerid][JobID] != 1) return SendClientMessage(playerid, GREY, "You are not a Garbage Man.");
	if(PlayerStat[playerid][CollectingGarbage] == 1) return SendClientMessage(playerid, GREY, "You already picked a garbage bag.");
	if(IsPlayerAttachedObjectSlotUsed(playerid, 3)) return SendClientMessage(playerid, GREY, "You can't use this command while holding something else.");

	new Float: Bag1X, Float: Bag1Y, Float: Bag1Z;
	new Float: Bag2X, Float: Bag2Y, Float: Bag2Z;
	new Float: Bag3X, Float: Bag3Y, Float: Bag3Z;
	new Float: Bag4X, Float: Bag4Y, Float: Bag4Z;
	new Float: Bag5X, Float: Bag5Y, Float: Bag5Z;
	new Float: Bag6X, Float: Bag6Y, Float: Bag6Z;
	new Float: Bag7X, Float: Bag7Y, Float: Bag7Z;
	new Float: Bag8X, Float: Bag8Y, Float: Bag8Z;
	new Float: Bag9X, Float: Bag9Y, Float: Bag9Z;

	GetDynamicObjectPos(Bag1, Bag1X, Bag1Y, Bag1Z);
	GetDynamicObjectPos(Bag2, Bag2X, Bag2Y, Bag2Z);
	GetDynamicObjectPos(Bag3, Bag3X, Bag3Y, Bag3Z);
	GetDynamicObjectPos(Bag4, Bag4X, Bag4Y, Bag4Z);
	GetDynamicObjectPos(Bag5, Bag5X, Bag5Y, Bag5Z);
	GetDynamicObjectPos(Bag6, Bag6X, Bag6Y, Bag6Z);
	GetDynamicObjectPos(Bag7, Bag7X, Bag7Y, Bag7Z);
	GetDynamicObjectPos(Bag8, Bag8X, Bag8Y, Bag8Z);
	GetDynamicObjectPos(Bag9, Bag9X, Bag9Y, Bag9Z);

	if(PlayerStat[playerid][AbleToCollectGarbage] == 1)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.0, Bag1X, Bag1Y, Bag1Z) && GarbageBag1Used == 0)
		{
			new str[128];
		    TogglePlayerDynamicCP(playerid, GarbageCheckpoint, 1);
		    PlayerStat[playerid][CollectingGarbage] = 1;
		    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0,0,0,0,0,0);
		    PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);
            SetPlayerAttachedObject(playerid, INDEX_GARBAGE, 1264, 5, 0.259646, -0.083203, -0.004445, 51.872596, 290.377227, 328.842437, 1.000000, 1.000000, 1.000000);
			DestroyDynamicObject(Bag1);
			GarbageBag1Used = 1;
			format(str, sizeof(str), "* %s takes the garbage bag from the ground, holding it with his left hand.", GetICName(playerid));
            SendNearByMessage(playerid, ACTION_COLOR, str, 5);
            SendClientMessage(playerid, GOLD, "Follow the checkpoint.");
            PlayerStat[playerid][AbleToCollectGarbage] = 1;
            PlayerStat[playerid][JobID1ReloadTime] = 60;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 2.0, Bag2X, Bag2Y, Bag2Z) && GarbageBag2Used == 0)
		{
			new str[128];
		    TogglePlayerDynamicCP(playerid, GarbageCheckpoint, 1);
		    PlayerStat[playerid][CollectingGarbage] = 1;
		    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0,0,0,0,0,0);
		    PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);
			SetPlayerAttachedObject(playerid, INDEX_GARBAGE, 1264, 5, 0.259646, -0.083203, -0.004445, 51.872596, 290.377227, 328.842437, 1.000000, 1.000000, 1.000000);
			DestroyDynamicObject(Bag2);
			GarbageBag2Used = 1;
			format(str, sizeof(str), "* %s takes the garbage bag from the ground, holding it with his left hand.", GetICName(playerid));
            SendNearByMessage(playerid, ACTION_COLOR, str, 5);
            SendClientMessage(playerid, GOLD, "Follow the checkpoint.");
            PlayerStat[playerid][AbleToCollectGarbage] = 1;
            PlayerStat[playerid][JobID1ReloadTime] = 60;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 2.0, Bag3X, Bag3Y, Bag3Z) && GarbageBag3Used == 0)
		{
			new str[128];
		    TogglePlayerDynamicCP(playerid, GarbageCheckpoint, 1);
		    PlayerStat[playerid][CollectingGarbage] = 1;
		    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0,0,0,0,0,0);
		    PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);
			SetPlayerAttachedObject(playerid, INDEX_GARBAGE, 1264, 5, 0.259646, -0.083203, -0.004445, 51.872596, 290.377227, 328.842437, 1.000000, 1.000000, 1.000000);
			DestroyDynamicObject(Bag3);
			GarbageBag3Used = 1;
			format(str, sizeof(str), "* %s takes the garbage bag from the ground, holding it with his left hand.", GetICName(playerid));
            SendNearByMessage(playerid, ACTION_COLOR, str, 5);
            SendClientMessage(playerid, GOLD, "Follow the checkpoint.");
            PlayerStat[playerid][AbleToCollectGarbage] = 1;
            PlayerStat[playerid][JobID1ReloadTime] = 60;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 2.0, Bag4X, Bag4Y, Bag4Z) && GarbageBag4Used == 0)
		{
			new str[128];
		    TogglePlayerDynamicCP(playerid, GarbageCheckpoint, 1);
		    PlayerStat[playerid][CollectingGarbage] = 1;
		    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0,0,0,0,0,0);
		    PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);
			SetPlayerAttachedObject(playerid, INDEX_GARBAGE, 1264, 5, 0.259646, -0.083203, -0.004445, 51.872596, 290.377227, 328.842437, 1.000000, 1.000000, 1.000000);
			DestroyDynamicObject(Bag4);
			GarbageBag4Used = 1;
			format(str, sizeof(str), "* %s takes the garbage bag from the ground, holding it with his left hand.", GetICName(playerid));
            SendNearByMessage(playerid, ACTION_COLOR, str, 5);
            SendClientMessage(playerid, GOLD, "Follow the checkpoint.");
            PlayerStat[playerid][AbleToCollectGarbage] = 1;
            PlayerStat[playerid][JobID1ReloadTime] = 60;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 2.0, Bag5X, Bag5Y, Bag5Z) && GarbageBag5Used == 0)
		{
			new str[128];
		    TogglePlayerDynamicCP(playerid, GarbageCheckpoint, 1);
		    PlayerStat[playerid][CollectingGarbage] = 1;
		    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0,0,0,0,0,0);
		    PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);
			SetPlayerAttachedObject(playerid, INDEX_GARBAGE, 1264, 5, 0.259646, -0.083203, -0.004445, 51.872596, 290.377227, 328.842437, 1.000000, 1.000000, 1.000000);
			DestroyDynamicObject(Bag5);
			GarbageBag5Used = 1;
			format(str, sizeof(str), "* %s takes the garbage bag from the ground, holding it with his left hand.", GetICName(playerid));
            SendNearByMessage(playerid, ACTION_COLOR, str, 5);
            SendClientMessage(playerid, GOLD, "Follow the checkpoint.");
            PlayerStat[playerid][AbleToCollectGarbage] = 1;
            PlayerStat[playerid][JobID1ReloadTime] = 60;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 2.0, Bag6X, Bag6Y, Bag6Z) && GarbageBag6Used == 0)
		{
			new str[128];
		    TogglePlayerDynamicCP(playerid, GarbageCheckpoint, 1);
		    PlayerStat[playerid][CollectingGarbage] = 1;
		    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0,0,0,0,0,0);
		    PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);
			SetPlayerAttachedObject(playerid, INDEX_GARBAGE, 1264, 5, 0.259646, -0.083203, -0.004445, 51.872596, 290.377227, 328.842437, 1.000000, 1.000000, 1.000000);
			DestroyDynamicObject(Bag6);
			GarbageBag6Used = 1;
			format(str, sizeof(str), "* %s takes the garbage bag from the ground, holding it with his left hand.", GetICName(playerid));
            SendNearByMessage(playerid, ACTION_COLOR, str, 5);
            SendClientMessage(playerid, GOLD, "Follow the checkpoint.");
            PlayerStat[playerid][AbleToCollectGarbage] = 1;
            PlayerStat[playerid][JobID1ReloadTime] = 60;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 2.0, Bag7X, Bag7Y, Bag7Z) && GarbageBag7Used == 0)
		{
			new str[128];
		    TogglePlayerDynamicCP(playerid, GarbageCheckpoint, 1);
		    PlayerStat[playerid][CollectingGarbage] = 1;
		    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0,0,0,0,0,0);
		    PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);
			SetPlayerAttachedObject(playerid, INDEX_GARBAGE, 1264, 5, 0.259646, -0.083203, -0.004445, 51.872596, 290.377227, 328.842437, 1.000000, 1.000000, 1.000000);
			DestroyDynamicObject(Bag7);
			GarbageBag7Used = 1;
			format(str, sizeof(str), "* %s takes the garbage bag from the ground, holding it with his left hand.", GetICName(playerid));
            SendNearByMessage(playerid, ACTION_COLOR, str, 5);
            SendClientMessage(playerid, GOLD, "Follow the checkpoint.");
            PlayerStat[playerid][AbleToCollectGarbage] = 1;
            PlayerStat[playerid][JobID1ReloadTime] = 60;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 2.0, Bag8X, Bag8Y, Bag8Z) && GarbageBag8Used == 0)
		{
			new str[128];
		    TogglePlayerDynamicCP(playerid, GarbageCheckpoint, 1);
		    PlayerStat[playerid][CollectingGarbage] = 1;
		    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0,0,0,0,0,0);
		    PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);
			SetPlayerAttachedObject(playerid, INDEX_GARBAGE, 1264, 5, 0.259646, -0.083203, -0.004445, 51.872596, 290.377227, 328.842437, 1.000000, 1.000000, 1.000000);
			DestroyDynamicObject(Bag8);
			GarbageBag8Used = 1;
			format(str, sizeof(str), "* %s takes the garbage bag from the ground, holding it with his left hand.", GetICName(playerid));
            SendNearByMessage(playerid, ACTION_COLOR, str, 5);
            SendClientMessage(playerid, GOLD, "Follow the checkpoint.");
            PlayerStat[playerid][AbleToCollectGarbage] = 1;
            PlayerStat[playerid][JobID1ReloadTime] = 60;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 2.0, Bag9X, Bag9Y, Bag9Z) && GarbageBag9Used == 0)
		{
			new str[128];
		    TogglePlayerDynamicCP(playerid, GarbageCheckpoint, 1);
		    PlayerStat[playerid][CollectingGarbage] = 1;
		    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0,0,0,0,0,0);
		    PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);
			SetPlayerAttachedObject(playerid, INDEX_GARBAGE, 1264, 5, 0.259646, -0.083203, -0.004445, 51.872596, 290.377227, 328.842437, 1.000000, 1.000000, 1.000000);
			DestroyDynamicObject(Bag9);
			GarbageBag9Used = 1;
			format(str, sizeof(str), "* %s takes the garbage bag from the ground, holding it with his left hand.", GetICName(playerid));
            SendNearByMessage(playerid, ACTION_COLOR, str, 5);
            SendClientMessage(playerid, GOLD, "Follow the checkpoint.");
            PlayerStat[playerid][AbleToCollectGarbage] = 1;
            PlayerStat[playerid][JobID1ReloadTime] = 60;
		}
		else return SendClientMessage(playerid, GREY, "You are not near any Garbage bags.");
	}
	else return SendClientMessage(playerid, GREY, "You must wait 1 minute before picking up garbage bags again.");
    return 1;
}

COMMAND:cleantables(playerid, params[])
{
    if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
	if(PlayerStat[playerid][JobID] != 2) return SendClientMessage(playerid, GREY, "You are not a Table Cleaner.");
	if(PlayerStat[playerid][CleaningTables] == 1) return SendClientMessage(playerid, GREY, "You are already cleaning.");
	if(PlayerStat[playerid][AbleToCleanTables] == 1)
	{
		TogglePlayerDynamicCP(playerid, TableCheckpoint1, 1);
		SendClientMessage(playerid, GOLD, "Reach all the checkpoints to clean the tables.");
		PlayerStat[playerid][CleaningTables] = 1;
	}
	else return SendClientMessage(playerid, GREY, "You are too tierd to work right now.");
    return 1;
}*/


public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
    if(checkpointid == TableCheckpoint1)
    {
        new str[128];
        ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.0,0,0,0,0,0);
        PlayerPlaySound(playerid, 1056, 0.0, 0.0, 0.0);
        TogglePlayerDynamicCP(playerid, TableCheckpoint1, 0);
        TogglePlayerDynamicCP(playerid, TableCheckpoint2, 1);
        SendClientMessage(playerid, GOLD, "Go to next checkpoint.");
        format(str, sizeof(str), "* %s takes some cleaning tools and start cleaning the tables.", GetICName(playerid));
        SendNearByMessage(playerid, ACTION_COLOR, str, 5);
    }
    else if(checkpointid == TableCheckpoint2)
    {
        ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.0,0,0,0,0,0);
        PlayerPlaySound(playerid, 1056, 0.0, 0.0, 0.0);
        TogglePlayerDynamicCP(playerid, TableCheckpoint2, 0);
        TogglePlayerDynamicCP(playerid, TableCheckpoint3, 1);
        SendClientMessage(playerid, GOLD, "Go to next checkpoint.");
    }
    else if(checkpointid == TableCheckpoint3)
    {
        ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.0,0,0,0,0,0);
        PlayerPlaySound(playerid, 1056, 0.0, 0.0, 0.0);
        TogglePlayerDynamicCP(playerid, TableCheckpoint3, 0);
        TogglePlayerDynamicCP(playerid, TableCheckpoint4, 1);
        SendClientMessage(playerid, GOLD, "Go to next checkpoint.");
    }
    else if(checkpointid == TableCheckpoint4)
    {
        ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.0,0,0,0,0,0);
        PlayerPlaySound(playerid, 1056, 0.0, 0.0, 0.0);
        PlayerPlaySound(playerid, 1056, 0.0, 0.0, 0.0);
        TogglePlayerDynamicCP(playerid, TableCheckpoint4, 0);
        TogglePlayerDynamicCP(playerid, TableCheckpoint5, 1);
        SendClientMessage(playerid, GOLD, "Go to next checkpoint.");
    }
    else if(checkpointid == TableCheckpoint5)
    {
        ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.0,0,0,0,0,0);
        PlayerPlaySound(playerid, 1056, 0.0, 0.0, 0.0);
        TogglePlayerDynamicCP(playerid, TableCheckpoint5, 0);
        TogglePlayerDynamicCP(playerid, TableCheckpoint6, 1);
        SendClientMessage(playerid, GOLD, "Go to next checkpoint.");
    }
    else if(checkpointid == TableCheckpoint6)
    {
        ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.0,0,0,0,0,0);
        PlayerPlaySound(playerid, 1056, 0.0, 0.0, 0.0);
        TogglePlayerDynamicCP(playerid, TableCheckpoint6, 0);
        TogglePlayerDynamicCP(playerid, TableCheckpoint7, 1);
        SendClientMessage(playerid, GOLD, "Go to next checkpoint.");
    }
    else if(checkpointid == TableCheckpoint7)
    {
        ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.0,0,0,0,0,0);
        PlayerPlaySound(playerid, 1056, 0.0, 0.0, 0.0);
        TogglePlayerDynamicCP(playerid, TableCheckpoint7, 0);
        TogglePlayerDynamicCP(playerid, TableCheckpoint8, 1);
        SendClientMessage(playerid, GOLD, "Go to next checkpoint.");
    }
    else if(checkpointid == TableCheckpoint8)
    {
        ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.0,0,0,0,0,0);
        PlayerPlaySound(playerid, 1056, 0.0, 0.0, 0.0);
        TogglePlayerDynamicCP(playerid, TableCheckpoint8, 0);
        TogglePlayerDynamicCP(playerid, TableCheckpoint9, 1);
        SendClientMessage(playerid, GOLD, "Go to next checkpoint.");
    }
    else if(checkpointid == TableCheckpoint9)
    {
        ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.0,0,0,0,0,0);
        PlayerPlaySound(playerid, 1056, 0.0, 0.0, 0.0);
        TogglePlayerDynamicCP(playerid, TableCheckpoint9, 0);
        TogglePlayerDynamicCP(playerid, TableCheckpoint10, 1);
        SendClientMessage(playerid, GOLD, "Go to next checkpoint.");
    }
    else if(checkpointid == TableCheckpoint10)
    {
        ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.0,0,0,0,0,0);
        PlayerPlaySound(playerid, 1056, 0.0, 0.0, 0.0);
        TogglePlayerDynamicCP(playerid, TableCheckpoint10, 0);
        TogglePlayerDynamicCP(playerid, TableCheckpoint11, 1);
        SendClientMessage(playerid, GOLD, "Go to next checkpoint.");
    }
    else if(checkpointid == TableCheckpoint11)
    {
        ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.0,0,0,0,0,0);
        PlayerPlaySound(playerid, 1056, 0.0, 0.0, 0.0);
        TogglePlayerDynamicCP(playerid, TableCheckpoint11, 0);
        TogglePlayerDynamicCP(playerid, TableCheckpoint12, 1);
        SendClientMessage(playerid, GOLD, "Go to next checkpoint.");
    }
    else if(checkpointid == TableCheckpoint12)
    {
        ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.0,0,0,0,0,0);
        PlayerPlaySound(playerid, 1056, 0.0, 0.0, 0.0);
        TogglePlayerDynamicCP(playerid, TableCheckpoint12, 0);
        TogglePlayerDynamicCP(playerid, TableCheckpoint13, 1);
        SendClientMessage(playerid, GOLD, "Go to next checkpoint.");
    }
    else if(checkpointid == TableCheckpoint13)
    {
        ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.0,0,0,0,0,0);
        PlayerPlaySound(playerid, 1056, 0.0, 0.0, 0.0);
        TogglePlayerDynamicCP(playerid, TableCheckpoint13, 0);
        TogglePlayerDynamicCP(playerid, TableCheckpoint14, 1);
        SendClientMessage(playerid, GOLD, "Go to next checkpoint.");
    }
    else if(checkpointid == TableCheckpoint14)
    {
        new str[128];
        ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.0,0,0,0,0,0);
        PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
        TogglePlayerDynamicCP(playerid, TableCheckpoint14, 0);
        SendClientMessage(playerid, GOLD, "Table Cleaner mission completed, you will receive + $22 in your next paycheck.");
        format(str, sizeof(str), "* %s puts the rubbish in the bin and puts back the cleaning tools.", GetICName(playerid));
        SendNearByMessage(playerid, ACTION_COLOR, str, 5);
        PlayerStat[playerid][CleaningTables] = 0;
        PlayerStat[playerid][AbleToCleanTables] = 0;
        PlayerStat[playerid][JobID2ReloadTime] = 780;
        PlayerStat[playerid][Paycheck] += 22;
    }
    return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_DRIVER && oldstate == PLAYER_STATE_ONFOOT)
	{
		new VehicleID;
	    VehicleID = GetPlayerVehicleID(playerid);
        if(PlayerStat[playerid][FactionID] != 1 && 0 <= VehicleID <= 5)
        {
			SendClientMessage(playerid, GREY, "This vehicle is only usable by the Department of Corrections.");
			RemovePlayerFromVehicle(playerid);
		}
	}
	if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
    {
        new VehicleID;
        VehicleID = GetPlayerVehicleID(playerid);
        if(PlayerStat[playerid][BeingSpeced] == 1)
        {
            PlayerSpectateVehicle(PlayerStat[playerid][BeingSpecedBy], VehicleID);
        }
    }
	if(newstate == PLAYER_STATE_ONFOOT)
    {
        if(PlayerStat[playerid][BeingSpeced] == 1)
        {
            PlayerSpectatePlayer(PlayerStat[playerid][BeingSpecedBy], playerid);
        }
    }
	return 1;
}

forward CurrentlyHigh(playerid);
public CurrentlyHigh(playerid)
{
	SetPlayerDrunkLevel(playerid, 5000);
	return 1;
}

forward BPANCD(playerid);
public BPANCD(playerid)
{
	ApplyAnimation(playerid,"BENCHPRESS","gym_bp_celebrate", 4.1, 0, 0, 0, 0, 0, 0);
	SetTimerEx("LoadingObjects", 4000, false, "i", playerid);
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	new str1[128];
    if((newkeys & KEY_SECONDARY_ATTACK) && !(oldkeys & KEY_SECONDARY_ATTACK && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT))
    {
	 	if(IsPlayerInRangeOfPoint(playerid, 1.0, 1780.1748,-1569.1857,1734.9430))
		{
		    SetPlayerPos(playerid, 1824.9733,-1575.2510,1738.7667);
		    SetCameraBehindPlayer(playerid);
		    TogglePlayerControllable(playerid,0);
		    SetTimerEx("FreezeTimer", 1500, false, "i", playerid);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 1.0, 1824.9733,-1575.2510,1738.7667))
		{
		    SetPlayerPos(playerid, 1780.1748,-1569.1857,1734.9430);
		    SetCameraBehindPlayer(playerid);
		    TogglePlayerControllable(playerid,0);
		    SetTimerEx("FreezeTimer", 1500, false, "i", playerid);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 1.0, 270.9733, 1412.3020, 10.8753)) // PRISON ENTRANCE GATE INSIDE BUTTON
		{
			if(prisongateclickable == 0) return SendClientMessage(playerid, RED, "The door is already moving, please wait for it to finish.");
			if(prisongate == 1)
			{
				MoveDynamicObject(prsgate, 272.7830, 1408.4099, 10.5006, 1.2, 0.00000000, 0.00000000, 90.00000000);
				format(str1, sizeof(str1), "* %s clicks on the button.", GetICName(playerid));
				SendNearByMessage(playerid, ACTION_COLOR, str1, 7);
				prisongate = 0;
				prisongateclickable = 0;
				SetTimer("GateCoolDown", 6000, false);
				return 1;
			}
			if(prisongate == 0)
			{
				MoveDynamicObject(prsgate, 272.7830, 1413.3369, 10.5006, 1.2, 0.00000000, 0.00000000, 90.00000000);
				format(str1, sizeof(str1), "* %s clicks on the button.", GetICName(playerid));
				SendNearByMessage(playerid, ACTION_COLOR, str1, 7);
				prisongate = 1;
				prisongateclickable = 0;
				SetTimer("GateCoolDown", 6000, false);
				return 1;
			}
		}
		else if(IsPlayerInRangeOfPoint(playerid, 1.0, 1756.0867, -1576.2657, 1734.9430))
		{
		    SetPlayerPos(playerid, 1813.7130,-1584.5688,5700.5);
		    SetCameraBehindPlayer(playerid);
		    TogglePlayerControllable(playerid,0);
		    SetTimerEx("FreezeTimer", 1500, false, "i", playerid);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 1.0, 285.8455, 1482.0536, 10.9282)) // Yard Tower Down
		{
		    SetPlayerPos(playerid, 283.6684,1481.7646,21.0);
			SetPlayerCameraPos(playerid, 283.1094, 1481.9843, 21.7290);
			SetPlayerCameraLookAt(playerid, 282.1105, 1481.9359, 21.7641);
		    SetCameraBehindPlayer(playerid);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 1.0, 283.5919, 1481.7888, 21.7554)) // Yard Tower Up
		{
		    SetPlayerPos(playerid, 285.8455, 1482.0536, 10.9282);
			SetPlayerCameraPos(playerid, 286.1919, 1482.2061, 12.3222);
			SetPlayerCameraLookAt(playerid, 287.1910, 1482.2507, 12.4223);
		    SetCameraBehindPlayer(playerid);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 1.0, 1259.6346,-785.4714,92.0313)) // Secret House Enter
		{
		    SetPlayerPos(playerid, 2468.8425,-1698.3463,1013.5078);
		    SetCameraBehindPlayer(playerid);
		    TogglePlayerControllable(playerid,0);
			SetPlayerInterior(playerid, 2);
		    SetTimerEx("FreezeTimer", 1000, false, "i", playerid);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 1.0, 2468.8425,-1698.3463,1013.5078)) // Secret House Exit
		{
		    SetPlayerPos(playerid, 1259.6346,-785.4714,92.0313);
		    SetCameraBehindPlayer(playerid);
		    TogglePlayerControllable(playerid,0);
			SetPlayerInterior(playerid, 0);
		    SetTimerEx("FreezeTimer", 1000, false, "i", playerid);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 1.0, 249.3878, 1420.4248, 15.7631)) // Yard Dispatch UP
		{
			SetPlayerPos(playerid, 254.2451, 1415.1108, 11.9);
			SetPlayerCameraPos(playerid, 254.2451, 1415.1108, 12.1272);
			SetPlayerCameraLookAt(playerid, 254.2313, 1414.1096, 12.0773); 
			SetCameraBehindPlayer(playerid);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 1.0, 240.3986, 1438.1689, 14.9021)) // Clothes Shop IN
		{
			SetPlayerPos(playerid, 242.2591, 1442.2692, 13.4563);
			SetPlayerCameraPos(playerid, 242.4198, 1442.2195, 14.3190);
			SetPlayerCameraLookAt(playerid, 242.8102, 1443.1481, 14.1440); 
			SetCameraBehindPlayer(playerid); 
		}
		else if(IsPlayerInRangeOfPoint(playerid, 1.0, 241.9591, 1441.8044, 13.5197)) // Clothes Shop Out
		{
			SetPlayerCameraPos(playerid, 240.2325, 1437.6237, 14.5545);
			SetPlayerPos(playerid, 240.6641, 1437.3568, 15.3621);
			SetPlayerCameraLookAt(playerid, 240.7117, 1436.3506, 15.2971); 
			SetCameraBehindPlayer(playerid); 
		}
		else if(IsPlayerInRangeOfPoint(playerid, 1.0, 254.0630, 1416.0303, 10.6396)) // Yard Dispatch DOWN
		{
			SetPlayerPos(playerid, 250.1447, 1420.3680, 15.9); 
			SetPlayerCameraPos(playerid, 250.8242, 1420.3939, 16.0343);
			SetPlayerCameraLookAt(playerid, 251.8226, 1420.4691, 16.1143);  
			SetCameraBehindPlayer(playerid); 
		}
		else if(IsPlayerInRangeOfPoint(playerid, 1.0, 214.7496, 1442.9059, 10.8026)) // Entrance to Garbage Room
		{
			SetPlayerPos(playerid, 210.8077, 1440.1125, 11.3300);
			SetCameraBehindPlayer(playerid); 
		}
		else if(IsPlayerInRangeOfPoint(playerid, 1.0, 210.8880, 1440.8680, 10.8026)) // Garbage Room exit
		{
			SetPlayerPos(playerid, 214.8418,1443.5507,10.6898);
			SetCameraBehindPlayer(playerid); 
		}
		else if(IsPlayerInRangeOfPoint(playerid, 1.0, 414.3888, 1629.6929, 1001.9136)) // Prisoners EXIT (exterior)
		{
			new Hour;
			gettime(Hour);
			InPrison[playerid] = 0;
			SetPlayerTime(playerid, Hour, 0);
			SetPlayerPos(playerid, 208.2047, 1450.0817, 11.4875); // Exterior exit.
			SetPlayerCameraLookAt(playerid, 209.1378, 1450.1448, 12.6788);// Exterior camera forward.
			SetPlayerInterior(playerid, 0);
			SetCameraBehindPlayer(playerid);
			GameTextForPlayer(playerid, "~w~ Prison Exterior", 3000, 1);
			TogglePlayerControllable(playerid, 0);
	        SetTimerEx("LoadingObjects", 1000, false, "d", playerid);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 1.0, 207.5492, 1450.0723, 11.6758)) // PRISON ENTER
		{
			SetPlayerTime(playerid, 7, 0);
			InPrison[playerid] = 1;
			SetPlayerPos(playerid, 415.0369,1629.6537,1001.1000);
			SetPlayerCameraLookAt(playerid, 416.2823, 1629.8152, 1002.0388);
		    SetCameraBehindPlayer(playerid);
			GameTextForPlayer(playerid, "~w~ Prison", 3000, 1);
			TogglePlayerControllable(playerid, 0);
			SetTimerEx("LoadingObjects", 4000, false, "d", playerid);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 1.0, 1806.2899,-1584.4418,5700.4287))
		{
			SetPlayerPos(playerid,-70.2152,-223.5770,-50.9922);
			SetPlayerInterior(playerid, 0);
			SetPlayerFacingAngle(playerid, 10.1974);
			SetCameraBehindPlayer(playerid);
			GameTextForPlayer(playerid, "~w~ Prison Cafeteria", 3000, 1);
			TogglePlayerControllable(playerid, 0);
	        SetTimerEx("LoadingObjects", 1000, false, "d", playerid);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 1.0, -70.2152,-223.5770,-50.9922))
		{
			SetPlayerPos(playerid,1806.2899,-1584.4418,5700.5);
			SetPlayerInterior(playerid, 0);
			SetPlayerFacingAngle(playerid, 271.2604);
			SetCameraBehindPlayer(playerid);
			GameTextForPlayer(playerid, "~w~ Prison Hall", 3000, 1);
			TogglePlayerControllable(playerid, 0);
	        SetTimerEx("LoadingObjects", 1000, false, "d", playerid);
		}


		else if(IsPlayerInRangeOfPoint(playerid, 1.0, 1809.5706,-1514.6727,5700.4287))
		{
		    SetPlayerPos(playerid, -49.5983,-270.4516,6.6332);
			SetPlayerInterior(playerid, 0);
			SetPlayerFacingAngle(playerid, 180.0);
			SetCameraBehindPlayer(playerid);
			GameTextForPlayer(playerid, "~w~ Prison Exit", 3000, 1);
			TogglePlayerControllable(playerid, 0);
	        SetTimerEx("LoadingObjects", 1000, false, "d", playerid);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 1.0, -49.5983,-270.4516,6.6332))
		{
		    SetPlayerPos(playerid, 1809.5706,-1514.6727,5700.5);
			SetPlayerInterior(playerid, 0);
			SetPlayerFacingAngle(playerid, 180.0);
			SetCameraBehindPlayer(playerid);
			GameTextForPlayer(playerid, "~w~ Prison Exit", 3000, 1);
			TogglePlayerControllable(playerid, 0);
	        SetTimerEx("LoadingObjects", 1000, false, "d", playerid);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 1.0, 1813.2740,-1545.1818,5700.4287))
		{
		    SetPlayerPos(playerid, 1148.3007,-1318.3501,1023.7019);
			SetPlayerInterior(playerid, 0);
			SetPlayerFacingAngle(playerid, 3.1547);
			SetCameraBehindPlayer(playerid);
			GameTextForPlayer(playerid, "~r~ San Andreas Prison Infirmary", 3000, 1);
			TogglePlayerControllable(playerid, 0);
	        SetTimerEx("LoadingObjects", 1000, false, "d", playerid);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 1.0, 1148.3007,-1318.3501,1023.7019))
		{
		    SetPlayerPos(playerid, 1813.2740,-1545.1818,5700.5);
			SetPlayerInterior(playerid, 0);
			SetPlayerFacingAngle(playerid, 358.8218);
			SetCameraBehindPlayer(playerid);
			GameTextForPlayer(playerid, "~w~ Prison Hall", 3000, 1);
			TogglePlayerControllable(playerid, 0);
	        SetTimerEx("LoadingObjects", 1000, false, "d", playerid);
		}


		else if(IsPlayerInRangeOfPoint(playerid, 1.0, 145.8062,-227.4600,-69.0000))
		{
		    SetPlayerPos(playerid, -5.1320,-325.3992,5.4297);
			SetPlayerInterior(playerid, 0);
			SetPlayerFacingAngle(playerid, 180.0);
			SetCameraBehindPlayer(playerid);
			GameTextForPlayer(playerid, "~w~ Prison Exterior", 3000, 1);
			TogglePlayerControllable(playerid, 0);
	        SetTimerEx("LoadingObjects", 1000, false, "d", playerid);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 1.0, -27.0908,-379.4108,14.9761))
		{
		    SetPlayerPos(playerid, -30.7525,-361.3723,5.4297);
			SetPlayerInterior(playerid, 0);
			SetPlayerFacingAngle(playerid, 354.4699);
			SetCameraBehindPlayer(playerid);
			GameTextForPlayer(playerid, "~w~ Prison Exterior", 3000, 1);
			TogglePlayerControllable(playerid, 0);
	        SetTimerEx("LoadingObjects", 1000, false, "d", playerid);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 1.0, 1814.1007,-1535.8702,5700.4287))
		{
		    SetPlayerPos(playerid, -193.3490,-202.5885,2.8724);
			SetPlayerInterior(playerid, 0);
			SetPlayerFacingAngle(playerid, 347.6959);
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, 0);
	        SetTimerEx("LoadingObjects", 1000, false, "d", playerid);
		}
		else if(IsPlayerInRangeOfPoint(playerid, -1, -13.0525,-335.8676,5.4297)) // Marcos Clothing Shop Entrance
		{
			SetPlayerPos(playerid, 203.6200,-49.8000,1002.4700);
			SetPlayerInterior(playerid, 1);
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, 0);
	        SetTimerEx("LoadingObjects", 1500, false, "d", playerid);
		}
		else if(IsPlayerInRangeOfPoint(playerid, -1, 203.6700,-50.4200,1002.5300)) // Marcos Clothing Shop Exit
		{
			SetPlayerPos(playerid, -13.0525,-335.8676,5.4297);
			SetPlayerInterior(playerid, 0);
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, 0);
	        SetTimerEx("LoadingObjects", 1500, false, "d", playerid);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 1.0, -7.7378,-394.2699,6.3441)) // HIDEOUT ENTER
		{
		    SetPlayerPos(playerid, 2208.3000, 1588.5797, 1000.7447);
			SetPlayerInterior(playerid, 1);
			SetPlayerFacingAngle(playerid, 350.4207);
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, 0);
	        SetTimerEx("LoadingObjects", 1000, false, "d", playerid);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 1.0, 2208.3633,1589.1337,999.1660)) // HIDEOUT EXIT
		{
		    SetPlayerPos(playerid, -8.1257,-392.8860,8.8107);
			SetPlayerInterior(playerid, 0);
			SetPlayerFacingAngle(playerid, 350.4207);
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, 0);
	        SetTimerEx("LoadingObjects", 1000, false, "d", playerid);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 1.0, -5.1428,-325.2578,5.5)) // General Store ENTER
		{
		    SetPlayerPos(playerid,  663.0330,-573.1599,16.5);
			SetPlayerInterior(playerid, 0);
			SetPlayerCameraLookAt(playerid, 664.1710, -573.4674, 17.0136);
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, 0);
	        SetTimerEx("LoadingObjects", 1000, false, "d", playerid);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 1.0, 662.1767,-573.5,16.5)) // General Store Exit
		{
			SetPlayerPos(playerid, -5.1428,-325.2578,5.5);
			SetPlayerInterior(playerid, 0);
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, 0);
	        SetTimerEx("LoadingObjects", 1000, false, "d", playerid);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 1.0, -10.5172,-269.4385,5.2)) // Warehouse enter
		{
		    SetPlayerPos(playerid,  1057.0293,2079.5742,12.1231);
			SetPlayerInterior(playerid, 0);
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, 0);
	        SetTimerEx("LoadingObjects", 1000, false, "d", playerid);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 1.0, 1056.4078,2079.5029,11.2)) // Warehouse exit
		{
		    SetPlayerPos(playerid,  -10.5409,-270.0620,6.2);
			SetPlayerInterior(playerid, 0);
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, 0);
	        SetTimerEx("LoadingObjects", 1000, false, "d", playerid);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 1.0, -193.3490,-202.5885,2.8724))
		{
		    SetPlayerPos(playerid, 1814.1007,-1535.8702,5700.5);
			SetPlayerInterior(playerid, 0);
			SetPlayerFacingAngle(playerid, 350.4207);
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, 0);
	        SetTimerEx("LoadingObjects", 1000, false, "d", playerid);
		}
		else if(PlayerStat[playerid][BPUSE] == 1) // WEIGHTS LIFTER
		{
			if(PlayerStat[playerid][StatPWR] <= 4) // Newbie lifter
			{
		    	if(PlayerStat[playerid][BPACD] == 0)
		    	{
		            if(PlayerStat[playerid][BPANM] == 1)
		            {
		                    ApplyAnimation(playerid,"BENCHPRESS","gym_bp_up_A", 4.1, 0, 0, 0, 1, 15, 0); // 5
		                    PlayerStat[playerid][BPANM] = 2;
		                    PlayerStat[playerid][BPDIF] += 8;
		                    PlayerStat[playerid][BPACD] = 2;
		            }
		            else
		            {
    						ApplyAnimation(playerid,"BENCHPRESS","gym_bp_up_B", 4.1, 0, 0, 0, 1, 15, 0); // 6
		                    PlayerStat[playerid][BPANM] = 1;
		                    PlayerStat[playerid][BPDIF] += 7;
		                    PlayerStat[playerid][BPACD] = 2;
		            }
		    	}
		    	else
		    	{
		        	SendClientMessage(playerid, GREY, "You need to wait few seconds between every bench-press.");
		    	}
			}
			else if(PlayerStat[playerid][StatPWR] <= 15) // Advanced lifter
			{
		    	if(PlayerStat[playerid][BPACD] == 0)
		    	{
		            if(PlayerStat[playerid][BPANM] == 1)
		            {
    						ApplyAnimation(playerid,"BENCHPRESS","gym_bp_up_B", 4.1, 0, 0, 0, 1, 15, 0); // 6
		                    PlayerStat[playerid][BPANM] = 2;
		                    PlayerStat[playerid][BPDIF] += 10;
		                    PlayerStat[playerid][BPACD] = 2;
		            }
		            else
		            {
		                    ApplyAnimation(playerid,"BENCHPRESS","gym_bp_up_A", 4.1, 0, 0, 0, 1, 15, 0); // 5
		                    PlayerStat[playerid][BPANM] = 1;
		                    PlayerStat[playerid][BPDIF] += 9;
		                    PlayerStat[playerid][BPACD] = 2;
		            }
		    	}
		    	else
		    	{
		        	SendClientMessage(playerid, GREY, "You need to wait few seconds between every bench-press.");
		    	}
			}
			else if(PlayerStat[playerid][StatPWR] >= 16) // Pro lifter
			{
		    	if(PlayerStat[playerid][BPACD] == 0)
		    	{
		            if(PlayerStat[playerid][BPANM] == 1)
		            {
							ApplyAnimation(playerid,"BENCHPRESS","gym_bp_up_smooth", 4.1, 0, 0, 0, 1, 15, 0); // 7
		                    PlayerStat[playerid][BPANM] = 2;
		                    PlayerStat[playerid][BPDIF] += 12;
		                    PlayerStat[playerid][BPACD] = 1;
		            }
		            else
		            {
    						ApplyAnimation(playerid,"BENCHPRESS","gym_bp_up_B", 4.1, 0, 0, 0, 1, 15, 0); // 6
		                    PlayerStat[playerid][BPANM] = 1;
		                    PlayerStat[playerid][BPDIF] += 11;
		                    PlayerStat[playerid][BPACD] = 1;
		            }
		    	}
		    	else
		    	{
		        	SendClientMessage(playerid, GREY, "You need to wait few secpmds between every bench-press.");
		    	}
			}

		/*
		CREATED & SCRIPTED & MAPPED BY MARCO - http://forum.sa-mp.com/member.php?u=181058
		*/
		}
		for(new c = 0; c < MAX_CELLS; c++)
        {
	        new
	                Float:pAng
	        ;
	        GetPlayerFacingAngle(playerid, pAng);
		    if(IsPlayerInRangeOfPoint(playerid, 0.3, CellStat[c][ExteriorX], CellStat[c][ExteriorY], CellStat[c][ExteriorZ]) && GetPlayerVirtualWorld(playerid) == 0)
	    	{
		    	if(CellStat[c][Locked] == 0)
		    	{
	     			SetPlayerPos(playerid, CellStat[c][InteriorX], CellStat[c][InteriorY] ,CellStat[c][InteriorZ]);
		   	    	SetPlayerInterior(playerid, 0);
			    	SetCameraBehindPlayer(playerid);
			    	SetPlayerVirtualWorld(playerid, 0);
			    	TogglePlayerControllable(playerid, 0);
	            	SetTimerEx("LoadingObjects", 1000, false, "d", playerid);
					PlayerInCell[playerid] = 1;
	            }
	            else return GameTextForPlayer(playerid, "~r~ Locked", 3000, 4);
	        }
	        else if(IsPlayerInRangeOfPoint(playerid, 0.3, CellStat[c][InteriorX], CellStat[c][InteriorY], CellStat[c][InteriorZ]) && GetPlayerVirtualWorld(playerid) == 0)
	    	{
	     		SetPlayerPos(playerid, CellStat[c][ExteriorX], CellStat[c][ExteriorY], CellStat[c][ExteriorZ]);
		   	    SetPlayerInterior(playerid, 0);
			    SetCameraBehindPlayer(playerid);
			    SetPlayerVirtualWorld(playerid, 0);
			    TogglePlayerControllable(playerid, 0);
	            SetTimerEx("LoadingObjects", 1000, false, "d", playerid);
				PlayerInCell[playerid] = 0;
	        }
        }
    }
    if(newkeys & KEY_JUMP && !(oldkeys & KEY_JUMP) && GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CUFFED) ApplyAnimation(playerid, "GYMNASIUM", "gym_jog_falloff",4.1,0,1,1,0,0);

	if(newkeys & KEY_YES)
	{
		ShowInventory(playerid);
		SendClientMessage(playerid, WHITE, "Write /mouse if your cursor disappeared.");
		SelectTextDraw(playerid, 0xA3B4C5FF);
		return 1;
	}
	
	if(PlayerStat[playerid][JobID4BOX] == 1)
			{
      			RemoveBox(playerid);
				ApplyAnimation(playerid, "PED", "FALL_collapse", 4.1, 0, 0, 0, 0, 20, 0);
      			SendClientMessage(playerid, GREY, "You have fell and the box has broke. (( If you are stuck type /dance 3 and click F. ))");
      			PlayerStat[playerid][JobID4ReloadTime] = 300;
				PlayerStat[playerid][JobID4CHP] = 0;
            	DisablePlayerCheckpoint(playerid);
			}

    if(newkeys & KEY_FIRE)
	{
		new str[128];
		new weapon = GetPlayerWeapon(playerid);
		if(PlayerStat[playerid][JobID4BOX] == 1)
		{
			RemoveBox(playerid);
			DisablePlayerCheckpoint(playerid);
			ApplyAnimation(playerid, "PED", "FALL_collapse", 4.1, 0, 0, 0, 0, 20, 0);
			SendClientMessage(playerid, GREY, "You have fell and the box has broke.");
      		PlayerStat[playerid][JobID4ReloadTime] = 300;
          	PlayerStat[playerid][JobID4CHP] = 0;
          	DisablePlayerCheckpoint(playerid);
			return 1;
		}
		if(PlayerStat[playerid][FactionID] == 1 && PlayerStat[playerid][Taser] == 1 && weapon <= 1)
		{
			new TargetID = GetClosestPlayer(playerid);
			if(PlayerStat[playerid][Tased] == 1) return 1;
			ApplyAnimation(playerid,"KNIFE","knife_3",4.1,0,1,1,0,0,1);
			if(IsPlayerConnected(TargetID) && PlayerStat[TargetID][Tased] == 0 && playerid != TargetID)
			{
				if(IsPlayerInRangeOfPlayer(2.2, playerid, TargetID))
				{
					new Float:hitX, Float:hitY, Float:hitZ;
					GetPlayerPos(playerid, hitX, hitY, hitZ);
					SetHealth(TargetID, PlayerStat[playerid][Health] - 5.0);
					PlayerStat[TargetID][Tased] = 1;
					TogglePlayerControllable(TargetID, 0);
					ApplyLoopingAnimation(TargetID, "PED", "FLOOR_hit_f", 4.1,1,1,1,1,1);
					SetTimerEx("RemoveTaseEffect", 10000, false, "d", TargetID);
					SendClientMessage(TargetID, RED, "You've been Tased for 10 seconds!");
					format(str, sizeof(str), "* %s has tased %s, with their taser.", GetICName(playerid), GetICName(TargetID));
					PlayNearBySound(playerid, 6003, hitX, hitY, hitZ, 20);
					SendNearByMessage(playerid, ACTION_COLOR, str, 3);
				}
			}
        }
		if(pSmokeAnim[playerid] >= 1 && pSmokeAnim[playerid] <= 10)
		{
			if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return 1;
			if(PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1) return 1;
			new Random = random(2);
			if(Random == 0)
			{
				ApplyAnimation(playerid, "SMOKING", "M_smk_drag", 4.1, 0, 0, 0, 0, 3000);
			}
			if(Random == 1)
			{
				ApplyAnimation(playerid, "GANGS", "smkcig_prtl", 4.1, 0, 1, 1, 1, 1);
			}
			return 1;
		}
	}
	if((newkeys & KEY_SPRINT) && !(oldkeys & KEY_SPRINT))
	{
		if(PlayerStat[playerid][JobID4BOX] == 1)
		{
			RemoveBox(playerid);
			ApplyAnimation(playerid, "PED", "FALL_collapse", 4.1, 0, 0, 0, 0, 20, 0);
   			SendClientMessage(playerid, GREY, "You have fell and the box has broke. (( If you are stuck type /dance 3 and click F. ))");
      		PlayerStat[playerid][JobID4ReloadTime] = 300; 
          	PlayerStat[playerid][JobID4CHP] = 0;
          	DisablePlayerCheckpoint(playerid);
		}

		if(PlayerStat[playerid][UsingLoopingAnims] == 1)
		{
			if(PlayerStat[playerid][Tased] == 1) return 1;
			StopLoopingAnimation(playerid);
			PlayerSitting[playerid] = 0;
		}
		
		if(PlayerClimbingRope[playerid] == 1)
		{
			new Float:ropex, Float:ropey, Float:ropez;
			GetPlayerPos(playerid, ropex, ropey, ropez);
			if(ropez >= 13.8878) return SendClientMessage(playerid, GREY, "There is no more rope to climb.");
			SetPlayerPos(playerid, ropex, ropey, ropez+0.05);
			ApplyAnimation(playerid, "PED", "abseil", 4.1, 1, 0, 0, 0, 0);
		}
    }
	if((newkeys & KEY_CROUCH) && !(oldkeys & KEY_CROUCH) && PlayerClimbingRope[playerid] == 1)
	{
		new Float:ropex, Float:ropey, Float:ropez;
		new sttr[128];
		GetPlayerPos(playerid, ropex, ropey, ropez);
		if(ropez <= 11.1)
		{
			SetPlayerPos(playerid, 224.1172, 1472.6801, 10.6878);
			format(sttr, sizeof(sttr), "* %s has climbed off the rope.", GetICName(playerid));
			SendNearByMessage(playerid, ACTION_COLOR, sttr, 12);
			TogglePlayerControllable(playerid, true);
			PlayerClimbingRope[playerid] = 0;
			RopeUsed = 0;
		}
		else
		{
			SetPlayerPos(playerid, ropex, ropey, ropez-0.2);
			ApplyAnimation(playerid, "PED", "abseil", 4.1, 1, 0, 0, 0, 0);
		}
		
	}
    if(PlayerStat[playerid][SecurityCameraStatus] == 1)
	{
		if((newkeys & KEY_CROUCH) && !(oldkeys & KEY_CROUCH))
		{
	        switch(PlayerStat[playerid][SecurityCameraNumber])
            {
		        case 1:
                {
                    PlayerStat[playerid][SecurityCameraNumber] = 2;
		            SetPlayerCameraPos(playerid, -18.6784,-313.4670,12.4705);
		            SetPlayerCameraLookAt(playerid, -2.5277,-272.5368,5.4297);
		        }
		        case 2:
			    {
                    PlayerStat[playerid][SecurityCameraNumber] = 3;
		            SetPlayerCameraPos(playerid, 7.6225,-266.9129,13.2895);
		            SetPlayerCameraLookAt(playerid, -2.8579,-241.3183,6.4515);
		        }
		        case 3:
			    {
                    PlayerStat[playerid][SecurityCameraNumber] = 4;
		            SetPlayerCameraPos(playerid, -17.0114,-233.6622,10.5035);
		            SetPlayerCameraLookAt(playerid, -46.4276,-222.7070,5.4297);
		        }
		        case 4:
			    {
                    PlayerStat[playerid][SecurityCameraNumber] = 1;
		            SetPlayerCameraPos(playerid, -19.8700,-335.8774,10.7141);
		            SetPlayerCameraLookAt(playerid, 7.8794,-371.8924,6.4286);
		        }
            }
		}
    }
	return 1;
}


public RemoveTaseEffect(playerid)
{
	if(PlayerStat[playerid][Tased] == 0) return 0;
    TogglePlayerControllable(playerid, 1);
    ClearAnimations(playerid);
	PlayerStat[playerid][Tased] = 0;
	StopLoopingAnimation(playerid);
	return 1;
}

stock MatchItem(playerid, item, amount)
{
	if(amount == 0)
	{
		if(item == PlayerStat[playerid][INV_SLOT1])
		{
			return 1;
		}
		if(item == PlayerStat[playerid][INV_SLOT2])
		{
			return 1;
		}
		if(item == PlayerStat[playerid][INV_SLOT3])
		{
			return 1;
		}
		if(item == PlayerStat[playerid][INV_SLOT4])
		{
			return 1;
		}
		if(item == PlayerStat[playerid][INV_SLOT5])
		{
			return 1;
		}
		if(item == PlayerStat[playerid][INV_SLOT6])
		{
			return 1;
		}
		if(item == PlayerStat[playerid][INV_SLOT7])
		{
			return 1;
		}
		if(item == PlayerStat[playerid][INV_SLOT8])
		{
			return 1;
		}
		if(item == PlayerStat[playerid][INV_SLOT9])
		{
			return 1;
		}
		if(item == PlayerStat[playerid][INV_SLOT10])
		{
			return 1;
		}
		else
		{
			return 0;
		}
	}
	else
	{
		if(item == PlayerStat[playerid][INV_SLOT1] && amount == PlayerStat[playerid][INV_SLOT1A])
		{
			return 1;
		}
		if(item == PlayerStat[playerid][INV_SLOT2] && amount == PlayerStat[playerid][INV_SLOT2A])
		{
			return 1;
		}
		if(item == PlayerStat[playerid][INV_SLOT3] && amount == PlayerStat[playerid][INV_SLOT3A])
		{
			return 1;
		}
		if(item == PlayerStat[playerid][INV_SLOT4] && amount == PlayerStat[playerid][INV_SLOT4A])
		{
			return 1;
		}
		if(item == PlayerStat[playerid][INV_SLOT5] && amount == PlayerStat[playerid][INV_SLOT5A])
		{
			return 1;
		}
		if(item == PlayerStat[playerid][INV_SLOT6] && amount == PlayerStat[playerid][INV_SLOT6A])
		{
			return 1;
		}
		if(item == PlayerStat[playerid][INV_SLOT7] && amount == PlayerStat[playerid][INV_SLOT7A])
		{
			return 1;
		}
		if(item == PlayerStat[playerid][INV_SLOT8] && amount == PlayerStat[playerid][INV_SLOT8A])
		{
			return 1;
		}
		if(item == PlayerStat[playerid][INV_SLOT9] && amount == PlayerStat[playerid][INV_SLOT9A])
		{
			return 1;
		}
		if(item == PlayerStat[playerid][INV_SLOT10] && amount == PlayerStat[playerid][INV_SLOT10A])
		{
			return 1;
		}
		else
		{
			return 0;
		}
	}
}

stock DropItem(playerid, item)
{
	if(item == 0) return 0;
	new str[124];
	if(IsPlayerInRangeOfPoint(playerid, 1.2, 440.2632, 1571.0500, 1000.6298)) // Trash1
	{
		if(Trash1Trash >= 50) return SendClientMessage(playerid, GREY, "This trash can is full.");
		Trash1Trash++;
		goto item_c;
	}
	if(IsPlayerInRangeOfPoint(playerid, 1.2, 431.2000, 1604.6610, 1000.6298)) // Trash2
	{
		if(Trash2Trash >= 50) return SendClientMessage(playerid, GREY, "This trash can is full.");
		Trash2Trash++;
		goto item_c;
	}
	if(IsPlayerInRangeOfPoint(playerid, 1.2, 442.7476, 1591.0435, 1000.6298)) // Trash3
	{
		if(Trash3Trash >= 50) return SendClientMessage(playerid, GREY, "This trash can is full.");
		Trash3Trash++;
		goto item_c;
	}
	if(IsPlayerInRangeOfPoint(playerid, 1.2, 440.9911, 1643.5480, 1000.6298)) // Trash4
	{
		if(Trash4Trash >= 50) return SendClientMessage(playerid, GREY, "This trash can is full.");
		Trash4Trash++;
		goto item_c;
	}
	if(IsPlayerInRangeOfPoint(playerid, 1.2, 444.3441, 1646.5009, 1000.7)) // Trash5
	{
		if(Trash5Trash >= 50) return SendClientMessage(playerid, GREY, "This trash can is full.");
		Trash5Trash++;
		goto item_c;
	}
	if(IsPlayerInRangeOfPoint(playerid, 1.2, 207.7989, 1447.8103, 10.3810)) // Trash6
	{
		if(Trash6Trash >= 50) return SendClientMessage(playerid, GREY, "This trash can is full.");
		Trash6Trash++;
		goto item_c;
	}
	if(IsPlayerInRangeOfPoint(playerid, 1.2, 273.8112, 1449.6755, 10.3810)) // Trash7
	{
		if(Trash7Trash >= 50) return SendClientMessage(playerid, GREY, "This trash can is full.");
		Trash7Trash++;
		goto item_c;
	}
	else
	{
		SendClientMessage(playerid, GREY, "You are not near any trash can.");
		return 1;
	}
	item_c:
	TrashCanTrashUpdate();
	if(item == PlayerStat[playerid][INV_SLOT1])
	{
		SendClientMessage(playerid, CMD_COLOR, "-> you threw something in the trash can.");
		format(str, sizeof(str), "* %s throws something into the trashcan.",GetICName(playerid));
		SetPlayerChatBubble(playerid, str, ACTION_COLOR, 15, 10000);
		PlayerStat[playerid][INV_SLOT1] = 0;
		PlayerStat[playerid][INV_SLOT1A] = 0;
		PlayerTextDrawHide(playerid, INV_SLOT1_IMG[playerid]);
		PlayerTextDrawHide(playerid, INV_AMO1_STR[playerid]);
		PlayerTextDrawHide(playerid, INV_PRV_IMG[playerid]);
		PlayerTextDrawHide(playerid, INV_PRV_STR[playerid]);
		return 1;
	}
	if(item == PlayerStat[playerid][INV_SLOT2])
	{
		SendClientMessage(playerid, CMD_COLOR, "-> you threw something in the trash can.");
		format(str, sizeof(str), "* %s throws something into the trashcan.",GetICName(playerid));
		SetPlayerChatBubble(playerid, str, ACTION_COLOR, 15, 10000);
		PlayerStat[playerid][INV_SLOT2] = 0;
		PlayerStat[playerid][INV_SLOT2A] = 0;
		PlayerTextDrawHide(playerid, INV_SLOT2_IMG[playerid]);
		PlayerTextDrawHide(playerid, INV_AMO2_STR[playerid]);
		PlayerTextDrawHide(playerid, INV_PRV_IMG[playerid]);
		PlayerTextDrawHide(playerid, INV_PRV_STR[playerid]);
		return 1;
	}
	if(item == PlayerStat[playerid][INV_SLOT3])
	{
		SendClientMessage(playerid, CMD_COLOR, "-> you threw something in the trash can.");
		format(str, sizeof(str), "* %s throws something into the trashcan.",GetICName(playerid));
		SetPlayerChatBubble(playerid, str, ACTION_COLOR, 15, 10000);
		PlayerStat[playerid][INV_SLOT3] = 0;
		PlayerStat[playerid][INV_SLOT3A] = 0;
		PlayerTextDrawHide(playerid, INV_SLOT3_IMG[playerid]);
		PlayerTextDrawHide(playerid, INV_AMO3_STR[playerid]);
		PlayerTextDrawHide(playerid, INV_PRV_IMG[playerid]);
		PlayerTextDrawHide(playerid, INV_PRV_STR[playerid]);
		return 1;
	}
	if(item == PlayerStat[playerid][INV_SLOT4])
	{
		SendClientMessage(playerid, CMD_COLOR, "-> you threw something in the trash can.");
		format(str, sizeof(str), "* %s throws something into the trashcan.",GetICName(playerid));
		SetPlayerChatBubble(playerid, str, ACTION_COLOR, 15, 10000);
		PlayerStat[playerid][INV_SLOT4] = 0;
		PlayerStat[playerid][INV_SLOT4A] = 0;
		PlayerTextDrawHide(playerid, INV_SLOT4_IMG[playerid]);
		PlayerTextDrawHide(playerid, INV_AMO4_STR[playerid]);
		PlayerTextDrawHide(playerid, INV_PRV_IMG[playerid]);
		PlayerTextDrawHide(playerid, INV_PRV_STR[playerid]);
		return 1;
	}
	if(item == PlayerStat[playerid][INV_SLOT5])
	{
		SendClientMessage(playerid, CMD_COLOR, "-> you threw something in the trash can.");
		format(str, sizeof(str), "* %s throws something into the trashcan.",GetICName(playerid));
		SetPlayerChatBubble(playerid, str, ACTION_COLOR, 15, 10000);
		PlayerStat[playerid][INV_SLOT5] = 0;
		PlayerStat[playerid][INV_SLOT5A] = 0;
		PlayerTextDrawHide(playerid, INV_SLOT5_IMG[playerid]);
		PlayerTextDrawHide(playerid, INV_AMO5_STR[playerid]);
		PlayerTextDrawHide(playerid, INV_PRV_IMG[playerid]);
		PlayerTextDrawHide(playerid, INV_PRV_STR[playerid]);
		return 1;
	}
	if(item == PlayerStat[playerid][INV_SLOT6])
	{
		SendClientMessage(playerid, CMD_COLOR, "-> you threw something in the trash can.");
		format(str, sizeof(str), "* %s throws something into the trashcan.",GetICName(playerid));
		SetPlayerChatBubble(playerid, str, ACTION_COLOR, 15, 10000);
		PlayerStat[playerid][INV_SLOT6] = 0;
		PlayerStat[playerid][INV_SLOT6A] = 0;
		PlayerTextDrawHide(playerid, INV_SLOT6_IMG[playerid]);
		PlayerTextDrawHide(playerid, INV_AMO6_STR[playerid]);
		PlayerTextDrawHide(playerid, INV_PRV_IMG[playerid]);
		PlayerTextDrawHide(playerid, INV_PRV_STR[playerid]);
		return 1;
	}
	if(item == PlayerStat[playerid][INV_SLOT7])
	{
		SendClientMessage(playerid, CMD_COLOR, "-> you threw something in the trash can.");
		format(str, sizeof(str), "* %s throws something into the trashcan.",GetICName(playerid));
		SetPlayerChatBubble(playerid, str, ACTION_COLOR, 15, 10000);
		PlayerStat[playerid][INV_SLOT7] = 0;
		PlayerStat[playerid][INV_SLOT7A] = 0;
		PlayerTextDrawHide(playerid, INV_SLOT7_IMG[playerid]);
		PlayerTextDrawHide(playerid, INV_AMO7_STR[playerid]);
		PlayerTextDrawHide(playerid, INV_PRV_IMG[playerid]);
		PlayerTextDrawHide(playerid, INV_PRV_STR[playerid]);
		return 1;
	}
	if(item == PlayerStat[playerid][INV_SLOT8])
	{
		SendClientMessage(playerid, CMD_COLOR, "-> you threw something in the trash can.");
		format(str, sizeof(str), "* %s throws something into the trashcan.",GetICName(playerid));
		SetPlayerChatBubble(playerid, str, ACTION_COLOR, 15, 10000);
		PlayerStat[playerid][INV_SLOT8] = 0;
		PlayerStat[playerid][INV_SLOT8A] = 0;
		PlayerTextDrawHide(playerid, INV_SLOT8_IMG[playerid]);
		PlayerTextDrawHide(playerid, INV_AMO8_STR[playerid]);
		PlayerTextDrawHide(playerid, INV_PRV_IMG[playerid]);
		PlayerTextDrawHide(playerid, INV_PRV_STR[playerid]);
		return 1;
	}
	if(item == PlayerStat[playerid][INV_SLOT9])
	{
		SendClientMessage(playerid, CMD_COLOR, "-> you threw something in the trash can.");
		format(str, sizeof(str), "* %s throws something into the trashcan.",GetICName(playerid));
		SetPlayerChatBubble(playerid, str, ACTION_COLOR, 15, 10000);
		PlayerStat[playerid][INV_SLOT9] = 0;
		PlayerStat[playerid][INV_SLOT9A] = 0;
		PlayerTextDrawHide(playerid, INV_SLOT9_IMG[playerid]);
		PlayerTextDrawHide(playerid, INV_AMO9_STR[playerid]);
		PlayerTextDrawHide(playerid, INV_PRV_IMG[playerid]);
		PlayerTextDrawHide(playerid, INV_PRV_STR[playerid]);
		return 1;
	}
	if(item == PlayerStat[playerid][INV_SLOT10])
	{
		SendClientMessage(playerid, CMD_COLOR, "-> you threw something in the trash can.");
		format(str, sizeof(str), "* %s throws something into the trashcan.",GetICName(playerid));
		SetPlayerChatBubble(playerid, str, ACTION_COLOR, 15, 10000);
		PlayerStat[playerid][INV_SLOT10] = 0;
		PlayerStat[playerid][INV_SLOT10A] = 0;
		PlayerTextDrawHide(playerid, INV_SLOT10_IMG[playerid]);
		PlayerTextDrawHide(playerid, INV_AMO10_STR[playerid]);
		PlayerTextDrawHide(playerid, INV_PRV_IMG[playerid]);
		PlayerTextDrawHide(playerid, INV_PRV_STR[playerid]);
		return 1;
	}	
	return 1;
}

stock UseItem(playerid, item)
{
	new str[128], text1[128], Float:CHealth;
	GetPlayerHealth(playerid, CHealth);
	if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
	if(PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You are cuffed or being dragged.");

	//----------------------- [ ITEM CHECK ] ----------------------------
	if(item == 4 && PlayerStat[playerid][CSCD] >= 1)
	{
		SendClientMessage(playerid, RED, "You need to wait some time before lighting another cigarette.");
		return 1;
	}
	if(item == 4 || item == 5)
	{
		if(pSmokeAnim[playerid] >= 1) return SendClientMessage(playerid, RED, "You are already smoking something.");
	}
	if(item == 5 && PlayerStat[playerid][JSCD] >= 1)
	{
		SendClientMessage(playerid, RED, "You are still high from smoking the previous joint.");
		return 1;
	}
	if(item == 1 || item == 2)
	{
		if(CHealth >= 100) return SendClientMessage(playerid, RED, "Your health is too full to use this item.");
	}
	//-------------------------------------------------------------------
		
	//----------------------- [ UN-USABLE ITEMS ] -----------------------
	if(item == 3 && PlayerStat[playerid][CSCD] <= 0)
	{
		SendClientMessage(playerid, RED, "You can't use this item on nothing.");
		return 1;
	}
	if(item == 6 || item == 7 || item == 8 || item == 9 || item == 10)
	{
		SendClientMessage(playerid, RED, "This item is used for crafting.");
		return 1;
	}
	//-------------------------------------------------------------------
	
	//----------------------- [ ITEM MATCH ] ----------------------------
	if(item == 4 && MatchItem(playerid, 3, 0) == 0)
	{
		SendClientMessage(playerid, RED, "You don't have a lighter.");
		return 1;
	}
	if(item == 5 && MatchItem(playerid, 3, 0) == 0)
	{
		SendClientMessage(playerid, RED, "You don't have a lighter.");
		return 1;
	}
	//-------------------------------------------------------------------
	if(item == PlayerStat[playerid][INV_SLOT1])
	{
		PlayerStat[playerid][INV_SLOT1A]--;
		ItemUsed(playerid, item);
		if(PlayerStat[playerid][INV_SLOT1A] <= 0)
		{
			PlayerStat[playerid][INV_SLOT1] = 0;
			PlayerStat[playerid][INV_SLOT1A] = 0;
			PlayerTextDrawHide(playerid, INV_SLOT1_IMG[playerid]);
			PlayerTextDrawHide(playerid, INV_AMO1_STR[playerid]);
			PlayerTextDrawHide(playerid, INV_PRV_IMG[playerid]);
			PlayerTextDrawHide(playerid, INV_PRV_STR[playerid]);
			INV_SEL_ITM[playerid] = 0;
			return 1;
		}
		format(text1, sizeof(text1), "%d", PlayerStat[playerid][INV_SLOT1A]);
		PlayerTextDrawSetString(playerid, INV_AMO1_STR[playerid], text1);
		return 1;
	}
	if(item == PlayerStat[playerid][INV_SLOT2])
	{
		PlayerStat[playerid][INV_SLOT2A]--;
		ItemUsed(playerid, item);
		if(PlayerStat[playerid][INV_SLOT2A] <= 0)
		{
			PlayerStat[playerid][INV_SLOT2] = 0;
			PlayerStat[playerid][INV_SLOT2A] = 0;
			PlayerTextDrawHide(playerid, INV_SLOT2_IMG[playerid]);
			PlayerTextDrawHide(playerid, INV_AMO2_STR[playerid]);
			PlayerTextDrawHide(playerid, INV_PRV_IMG[playerid]);
			PlayerTextDrawHide(playerid, INV_PRV_STR[playerid]);
			INV_SEL_ITM[playerid] = 0;
			return 1;
		}
		format(text1, sizeof(text1), "%d", PlayerStat[playerid][INV_SLOT2A]);
		PlayerTextDrawSetString(playerid, INV_AMO2_STR[playerid], text1);
		return 1;
	}
	if(item == PlayerStat[playerid][INV_SLOT3])
	{
		PlayerStat[playerid][INV_SLOT3A]--;
		ItemUsed(playerid, item);
		if(PlayerStat[playerid][INV_SLOT3A] <= 0)
		{
			PlayerStat[playerid][INV_SLOT3] = 0;
			PlayerStat[playerid][INV_SLOT3A] = 0;
			PlayerTextDrawHide(playerid, INV_SLOT3_IMG[playerid]);
			PlayerTextDrawHide(playerid, INV_AMO3_STR[playerid]);
			PlayerTextDrawHide(playerid, INV_PRV_IMG[playerid]);
			PlayerTextDrawHide(playerid, INV_PRV_STR[playerid]);
			INV_SEL_ITM[playerid] = 0;
			return 1;
		}
		format(text1, sizeof(text1), "%d", PlayerStat[playerid][INV_SLOT3A]);
		PlayerTextDrawSetString(playerid, INV_AMO3_STR[playerid], text1);
		return 1;
	}
	if(item == PlayerStat[playerid][INV_SLOT4])
	{
		PlayerStat[playerid][INV_SLOT4A]--;
		ItemUsed(playerid, item);
		if(PlayerStat[playerid][INV_SLOT4A] <= 0)
		{
			PlayerStat[playerid][INV_SLOT4] = 0;
			PlayerStat[playerid][INV_SLOT4A] = 0;
			PlayerTextDrawHide(playerid, INV_SLOT4_IMG[playerid]);
			PlayerTextDrawHide(playerid, INV_AMO4_STR[playerid]);
			PlayerTextDrawHide(playerid, INV_PRV_IMG[playerid]);
			PlayerTextDrawHide(playerid, INV_PRV_STR[playerid]);
			INV_SEL_ITM[playerid] = 0;
			return 1;
		}
		format(text1, sizeof(text1), "%d", PlayerStat[playerid][INV_SLOT4A]);
		PlayerTextDrawSetString(playerid, INV_AMO4_STR[playerid], text1);
		return 1;
	}
	if(item == PlayerStat[playerid][INV_SLOT5])
	{
		PlayerStat[playerid][INV_SLOT5A]--;
		ItemUsed(playerid, item);
		if(PlayerStat[playerid][INV_SLOT5A] <= 0)
		{
			PlayerStat[playerid][INV_SLOT5] = 0;
			PlayerStat[playerid][INV_SLOT5A] = 0;
			PlayerTextDrawHide(playerid, INV_SLOT5_IMG[playerid]);
			PlayerTextDrawHide(playerid, INV_AMO5_STR[playerid]);
			PlayerTextDrawHide(playerid, INV_PRV_IMG[playerid]);
			PlayerTextDrawHide(playerid, INV_PRV_STR[playerid]);
			INV_SEL_ITM[playerid] = 0;
			return 1;
		}
		format(text1, sizeof(text1), "%d", PlayerStat[playerid][INV_SLOT5A]);
		PlayerTextDrawSetString(playerid, INV_AMO5_STR[playerid], text1);
		return 1;
	}
	if(item == PlayerStat[playerid][INV_SLOT6])
	{
		PlayerStat[playerid][INV_SLOT6A]--;
		ItemUsed(playerid, item);
		if(PlayerStat[playerid][INV_SLOT6A] <= 0)
		{
			PlayerStat[playerid][INV_SLOT6] = 0;
			PlayerStat[playerid][INV_SLOT6A] = 0;
			PlayerTextDrawHide(playerid, INV_SLOT6_IMG[playerid]);
			PlayerTextDrawHide(playerid, INV_AMO6_STR[playerid]);
			PlayerTextDrawHide(playerid, INV_PRV_IMG[playerid]);
			PlayerTextDrawHide(playerid, INV_PRV_STR[playerid]);
			INV_SEL_ITM[playerid] = 0;
			return 1;
		}
		format(text1, sizeof(text1), "%d", PlayerStat[playerid][INV_SLOT6A]);
		PlayerTextDrawSetString(playerid, INV_AMO6_STR[playerid], text1);
		return 1;
	}
	if(item == PlayerStat[playerid][INV_SLOT7])
	{
		PlayerStat[playerid][INV_SLOT7A]--;
		ItemUsed(playerid, item);
		if(PlayerStat[playerid][INV_SLOT7A] <= 0)
		{
			PlayerStat[playerid][INV_SLOT7] = 0;
			PlayerStat[playerid][INV_SLOT7A] = 0;
			PlayerTextDrawHide(playerid, INV_SLOT7_IMG[playerid]);
			PlayerTextDrawHide(playerid, INV_AMO7_STR[playerid]);
			PlayerTextDrawHide(playerid, INV_PRV_IMG[playerid]);
			PlayerTextDrawHide(playerid, INV_PRV_STR[playerid]);
			INV_SEL_ITM[playerid] = 0;
			return 1;
		}
		format(text1, sizeof(text1), "%d", PlayerStat[playerid][INV_SLOT7A]);
		PlayerTextDrawSetString(playerid, INV_AMO7_STR[playerid], text1);
		return 1;
	}
	if(item == PlayerStat[playerid][INV_SLOT8])
	{
		PlayerStat[playerid][INV_SLOT8A]--;
		ItemUsed(playerid, item);
		if(PlayerStat[playerid][INV_SLOT8A] <= 0)
		{
			PlayerStat[playerid][INV_SLOT8] = 0;
			PlayerStat[playerid][INV_SLOT8A] = 0;
			PlayerTextDrawHide(playerid, INV_SLOT8_IMG[playerid]);
			PlayerTextDrawHide(playerid, INV_AMO8_STR[playerid]);
			PlayerTextDrawHide(playerid, INV_PRV_IMG[playerid]);
			PlayerTextDrawHide(playerid, INV_PRV_STR[playerid]);
			INV_SEL_ITM[playerid] = 0;
			return 1;
		}
		format(text1, sizeof(text1), "%d", PlayerStat[playerid][INV_SLOT8A]);
		PlayerTextDrawSetString(playerid, INV_AMO8_STR[playerid], text1);
		return 1;
	}
	if(item == PlayerStat[playerid][INV_SLOT9])
	{
		PlayerStat[playerid][INV_SLOT9A]--;
		ItemUsed(playerid, item);
		if(PlayerStat[playerid][INV_SLOT9A] <= 0)
		{
			PlayerStat[playerid][INV_SLOT9] = 0;
			PlayerStat[playerid][INV_SLOT9A] = 0;
			PlayerTextDrawHide(playerid, INV_SLOT9_IMG[playerid]);
			PlayerTextDrawHide(playerid, INV_AMO9_STR[playerid]);
			PlayerTextDrawHide(playerid, INV_PRV_IMG[playerid]);
			PlayerTextDrawHide(playerid, INV_PRV_STR[playerid]);
			INV_SEL_ITM[playerid] = 0;
			return 1;
		}
		format(text1, sizeof(text1), "%d", PlayerStat[playerid][INV_SLOT9A]);
		PlayerTextDrawSetString(playerid, INV_AMO9_STR[playerid], text1);
		return 1;
	}
	if(item == PlayerStat[playerid][INV_SLOT10])
	{
		PlayerStat[playerid][INV_SLOT10A]--;
		ItemUsed(playerid, item);
		if(PlayerStat[playerid][INV_SLOT10A] <= 0)
		{
			PlayerStat[playerid][INV_SLOT10] = 0;
			PlayerStat[playerid][INV_SLOT10A] = 0;
			PlayerTextDrawHide(playerid, INV_SLOT10_IMG[playerid]);
			PlayerTextDrawHide(playerid, INV_AMO10_STR[playerid]);
			PlayerTextDrawHide(playerid, INV_PRV_IMG[playerid]);
			PlayerTextDrawHide(playerid, INV_PRV_STR[playerid]);
			INV_SEL_ITM[playerid] = 0;
			return 1;
		}
		format(text1, sizeof(text1), "%d", PlayerStat[playerid][INV_SLOT10A]);
		PlayerTextDrawSetString(playerid, INV_AMO10_STR[playerid], text1);
		return 1;
	}
	else
	{
		format(str, sizeof(str), "[ERROR] Item ID %d was used and couldn't be found in the inventory.", item);
		printf("%s",str);
		SendAdminMessage(RED, str);
	}
	return 1;
}

stock ItemUsed(playerid, item)
{
	new Float:CHealth, str[128], Float:CArmour, Float:cX, Float:cY, Float:cZ;
	if(item == 1) // Sandwich
	{
		GetPlayerHealth(playerid, CHealth);
		if(CHealth <= 75)
		{
			SetPlayerHealth(playerid, CHealth+15);
		}
		else if(CHealth >= 76)
		{
			SetPlayerHealth(playerid, 100);
		}
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 3.0, 0, 0, 0, 0, 0);
		GetPlayerPos(playerid, cX, cY, cZ);
		PlayNearBySound(playerid, 32200, cX, cY, cZ, 12);
		return 1;
	}
	if(item == 2) // Sprunk
	{
		GetPlayerHealth(playerid, CHealth);
		if(CHealth <= 93)
		{
			SetPlayerHealth(playerid, CHealth+7);
		}
		else if(CHealth >= 94)
		{
			SetPlayerHealth(playerid, 100);
		}
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_SPRUNK);
		return 1;
	}
	if(item == 3) // Lighter
	{
		return 1;
	}
	if(item == 4) // Cigar
	{
		PlayerStat[playerid][CSCD] = 60;
		SetPlayerAttachedObject(playerid, 0, 19625, 6, 0.1, 0.023, 0.024, 0.0, 2.1, 58.899);
		UseItem(playerid, 3);
		pSmokeAnim[playerid] = 1;
		ApplyAnimation(playerid, "SMOKING", "M_smk_in", 4.1, 0, 0, 0, 0, 3000);
		format(str, sizeof(str), "%s withdraws a cigarette pack and a lighter from his pocket, and lights his cigarette.", GetICName(playerid));
		SendNearByMessage(playerid, ACTION_COLOR, str, 7);
		return 1;
	}
	if(item == 5) // Joint
	{
		GetPlayerArmour(playerid, CArmour);
		format(str, sizeof(str), "* %s takes out a lighter and a joint, lighting up the joint and smokes it.", GetICName(playerid));
		SendNearByMessage(playerid, ACTION_COLOR, str, 10);
		SetPlayerDrunkLevel (playerid, 4500);
		SetTimer("CurrentlyHigh", 150000, false);
		PlayerStat[playerid][CUCD] += 100;
		SetPlayerAttachedObject(playerid, 0, 3027, 6, 0.09, 0.015, 0.009, 64.399, 91.399, 20.2);
		UseItem(playerid, 3);
		pSmokeAnim[playerid] = 2;
		ApplyAnimation(playerid, "SMOKING", "M_smk_in", 4.1, 0, 0, 0, 0, 3000);
		PlayerStat[playerid][JSCD] = 2700;
		if(CArmour <= 44)
		{
			SetPlayerArmour(playerid, CArmour + 4.0);
			GetPlayerArmour(playerid, CArmour);
			if(CArmour >= 46)
			{
				SetPlayerArmour(playerid, 45);
			}
		}
		return 1;
	}
	if(item == 6) // Cloth Piece
	{
		return 1;
	}
	if(item == 7) // Wood Piece
	{
		return 1;
	}
	if(item == 8) // Metal Sheet
	{
		return 1;
	}
	if(item == 9) // Refined Metal
	{
		return 1;
	}
	if(item == 10) // Gun Piece
	{
		return 1;
	}
	else
	{
		format(str, sizeof(str), "[ERROR] Item ID %d was sent to be used.", item);
		printf("%s",str);
		SendAdminMessage(RED, str);
	}
	return 1;
}

stock MaxItemStack(camount, gamount, item)
{
	if(item == 1) // Sandwich - Max 1
	{
		return 1;
	}
	if(item == 2) // Sprunk - Max 1
	{
		return 1;
	}
	if(item == 3) // Lighter - Max 10
	{
		if(camount+gamount <= 10)
		{
			return 0;
		}
		return 1;
	}
	if(item == 4) // Cigarette Pack - Max 10
	{
		if(camount+gamount <= 10)
		{
			return 0;
		}
		return 1;
	}
	if(item == 5) // Joint - Max 5
	{
		if(camount+gamount <= 5)
		{
			return 0;
		}
		return 1;
	}
	if(item == 6) // Cloth Piece - Max 15
	{
		if(camount+gamount <= 15)
		{
			return 0;
		}
		return 1;
	}
	if(item == 7) // Wood Piece - Max 5
	{
		if(camount+gamount <= 5)
		{
			return 0;
		}
		return 1;
	}
	if(item == 8) // Metal Sheet - Max 5
	{
		if(camount+gamount <= 5)
		{
			return 0;
		}
		return 1;
	}
	if(item == 9) // Refined Metal - Max 5
	{
		if(camount+gamount <= 5)
		{
			return 0;
		}
		return 1;
	}
	if(item == 10) // Gun Piece - Max 15
	{
		if(camount+gamount <= 15)
		{
			return 0;
		}
		return 1;
	}
	return 1;
}

stock GiveItem(playerid, item, amount)
{
	if(MatchItem(playerid, item, 0) == 1)
	{
		if(item == PlayerStat[playerid][INV_SLOT1] && MaxItemStack(PlayerStat[playerid][INV_SLOT1A], amount, item) == 0)
		{
			PlayerStat[playerid][INV_SLOT1A] += amount;
			if(PlayerStat[playerid][INV_SLOT1A] <= 0)
			{
				PlayerStat[playerid][INV_SLOT1] = 0;
				PlayerStat[playerid][INV_SLOT1A] = 0;
			}
			return 1;
		}
		if(item == PlayerStat[playerid][INV_SLOT2] && MaxItemStack(PlayerStat[playerid][INV_SLOT2A], amount, item) == 0)
		{
			PlayerStat[playerid][INV_SLOT2A] += amount;
			if(PlayerStat[playerid][INV_SLOT2A] <= 0)
			{
				PlayerStat[playerid][INV_SLOT2] = 0;
				PlayerStat[playerid][INV_SLOT2A] = 0;
			}
			return 1;
		}
		if(item == PlayerStat[playerid][INV_SLOT3] && MaxItemStack(PlayerStat[playerid][INV_SLOT3A], amount, item) == 0)
		{
			PlayerStat[playerid][INV_SLOT3A] += amount;
			if(PlayerStat[playerid][INV_SLOT3A] <= 0)
			{
				PlayerStat[playerid][INV_SLOT3] = 0;
				PlayerStat[playerid][INV_SLOT3A] = 0;
			}
			return 1;
		}
		if(item == PlayerStat[playerid][INV_SLOT4] && MaxItemStack(PlayerStat[playerid][INV_SLOT4A], amount, item) == 0)
		{
			PlayerStat[playerid][INV_SLOT4A] += amount;
			if(PlayerStat[playerid][INV_SLOT4A] <= 0)
			{
				PlayerStat[playerid][INV_SLOT4] = 0;
				PlayerStat[playerid][INV_SLOT4A] = 0;
			}
			return 1;
		}
		if(item == PlayerStat[playerid][INV_SLOT5] && MaxItemStack(PlayerStat[playerid][INV_SLOT5A], amount, item) == 0)
		{
			PlayerStat[playerid][INV_SLOT5A] += amount;
			if(PlayerStat[playerid][INV_SLOT5A] <= 0)
			{
				PlayerStat[playerid][INV_SLOT5] = 0;
				PlayerStat[playerid][INV_SLOT5A] = 0;
			}
			return 1;
		}
		if(item == PlayerStat[playerid][INV_SLOT6] && MaxItemStack(PlayerStat[playerid][INV_SLOT6A], amount, item) == 0)
		{
			PlayerStat[playerid][INV_SLOT6A] += amount;
			if(PlayerStat[playerid][INV_SLOT6A] <= 0)
			{
				PlayerStat[playerid][INV_SLOT6] = 0;
				PlayerStat[playerid][INV_SLOT6A] = 0;
			}
			return 1;
		}
		if(item == PlayerStat[playerid][INV_SLOT7] && MaxItemStack(PlayerStat[playerid][INV_SLOT7A], amount, item) == 0)
		{
			PlayerStat[playerid][INV_SLOT7A] += amount;
			if(PlayerStat[playerid][INV_SLOT7A] <= 0)
			{
				PlayerStat[playerid][INV_SLOT7] = 0;
				PlayerStat[playerid][INV_SLOT7A] = 0;
			}
			return 1;
		}
		if(item == PlayerStat[playerid][INV_SLOT8] && MaxItemStack(PlayerStat[playerid][INV_SLOT8A], amount, item) == 0)
		{
			PlayerStat[playerid][INV_SLOT8A] += amount;
			if(PlayerStat[playerid][INV_SLOT8A] <= 0)
			{
				PlayerStat[playerid][INV_SLOT8] = 0;
				PlayerStat[playerid][INV_SLOT8A] = 0;
			}
			return 1;
		}
		if(item == PlayerStat[playerid][INV_SLOT9] && MaxItemStack(PlayerStat[playerid][INV_SLOT9A], amount, item) == 0)
		{
			PlayerStat[playerid][INV_SLOT9A] += amount;
			if(PlayerStat[playerid][INV_SLOT9A] <= 0)
			{
				PlayerStat[playerid][INV_SLOT9] = 0;
				PlayerStat[playerid][INV_SLOT9A] = 0;
			}
			return 1;
		}
		if(item == PlayerStat[playerid][INV_SLOT10] && MaxItemStack(PlayerStat[playerid][INV_SLOT10A], amount, item) == 0)
		{
			PlayerStat[playerid][INV_SLOT10A] += amount;
			if(PlayerStat[playerid][INV_SLOT10A] <= 0)
			{
				PlayerStat[playerid][INV_SLOT10] = 0;
				PlayerStat[playerid][INV_SLOT10A] = 0;
			}
			return 1;
		}
		else
		{
			goto nue_item;
		}
	}
	else
	{
		nue_item:
		if(PlayerStat[playerid][INV_SLOT1] == 0)
		{
			PlayerStat[playerid][INV_SLOT1] = item;
			PlayerStat[playerid][INV_SLOT1A] = amount;
			return 1;
		}
		if(PlayerStat[playerid][INV_SLOT2] == 0)
		{
			PlayerStat[playerid][INV_SLOT2] = item;
			PlayerStat[playerid][INV_SLOT2A] = amount;
			return 1;
		}
		if(PlayerStat[playerid][INV_SLOT3] == 0)
		{
			PlayerStat[playerid][INV_SLOT3] = item;
			PlayerStat[playerid][INV_SLOT3A] = amount;
			return 1;
		}
		if(PlayerStat[playerid][INV_SLOT4] == 0)
		{
			PlayerStat[playerid][INV_SLOT4] = item;
			PlayerStat[playerid][INV_SLOT4A] = amount;
			return 1;
		}
		if(PlayerStat[playerid][INV_SLOT5] == 0)
		{
			PlayerStat[playerid][INV_SLOT5] = item;
			PlayerStat[playerid][INV_SLOT5A] = amount;
			return 1;
		}
		if(PlayerStat[playerid][INV_SLOT6] == 0 && PlayerStat[playerid][DonLV] >= 1)
		{
			PlayerStat[playerid][INV_SLOT6] = item;
			PlayerStat[playerid][INV_SLOT6A] = amount;
			return 1;
		}
		if(PlayerStat[playerid][INV_SLOT7] == 0 && PlayerStat[playerid][DonLV] >= 2)
		{
			PlayerStat[playerid][INV_SLOT7] = item;
			PlayerStat[playerid][INV_SLOT7A] = amount;
			return 1;
		}
		if(PlayerStat[playerid][INV_SLOT8] == 0 && PlayerStat[playerid][DonLV] >= 2)
		{
			PlayerStat[playerid][INV_SLOT8] = item;
			PlayerStat[playerid][INV_SLOT8A] = amount;
			return 1;
		}
		if(PlayerStat[playerid][INV_SLOT9] == 0 && PlayerStat[playerid][DonLV] == 3)
		{
			PlayerStat[playerid][INV_SLOT9] = item;
			PlayerStat[playerid][INV_SLOT9A] = amount;
			return 1;
		}
		if(PlayerStat[playerid][INV_SLOT10] == 0 && PlayerStat[playerid][DonLV] == 3)
		{
			PlayerStat[playerid][INV_SLOT10] = item;
			PlayerStat[playerid][INV_SLOT10A] = amount;
			return 1;
		}
		else
		{
			SendClientMessage(playerid, RED, "You got no free slot in your inventory.");
			return 1;
		}
	}
	return 1;
}

stock GetFreeSlot(playerid)
{
	if(PlayerStat[playerid][INV_SLOT1] == 0)
	{
		return 1;
	}
	if(PlayerStat[playerid][INV_SLOT2] == 0)
	{
		return 1;
	}
	if(PlayerStat[playerid][INV_SLOT3] == 0)
	{
		return 1;
	}
	if(PlayerStat[playerid][INV_SLOT4] == 0)
	{
		return 1;
	}
	if(PlayerStat[playerid][INV_SLOT5] == 0)
	{
		return 1;
	}
	if(PlayerStat[playerid][INV_SLOT6] == 0 && PlayerStat[playerid][DonLV] >= 1)
	{
		return 1;
	}
	if(PlayerStat[playerid][INV_SLOT7] == 0 && PlayerStat[playerid][DonLV] >= 2)
	{
		return 1;
	}
	if(PlayerStat[playerid][INV_SLOT8] == 0 && PlayerStat[playerid][DonLV] >= 2)
	{
		return 1;
	}
	if(PlayerStat[playerid][INV_SLOT9] == 0 && PlayerStat[playerid][DonLV] == 3)
	{
		return 1;
	}
	if(PlayerStat[playerid][INV_SLOT10] == 0 && PlayerStat[playerid][DonLV] == 3)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

stock GetItemModel(item)
{
	new str[128];
	if(item == 1)
	{
		return 2769;
	}
	if(item == 2)
	{
		return 2601;
	}
	if(item == 3)
	{
		return 327;
	}
	if(item == 4)
	{
		return 19897;
	}
	if(item == 5)
	{
		return 3027;
	}
	if(item == 6) // Cloth
	{
		return 19775;
	}
	if(item == 7) // Wood
	{
		return 19370;
	}
	if(item == 8) // Metal
	{
		return 19843;
	}
	if(item == 9) // RMetal
	{
		return 19846;
	}
	if(item == 10) // GunP
	{
		return 19773;
	}
	else
	{
		format(str, sizeof(str),"[ERROR] Item ID [%d] was sent to get a model ID.", item);
		printf("%s", str);
		SendAdminMessage(RED, str);
	}
	return 1;
}

stock GetItemName(item)
{
	new str[128];
	if(item == 1)
	{
		str = "Sandwich";
		return str;
	}
	if(item == 2)
	{
		str = "Sprunk Can";
		return str;
	}
	if(item == 3)
	{
		str = "Lighter";
		return str;
	}
	if(item == 4)
	{
		str = "IN4LIFE Pack";
		return str;
	}
	if(item == 5)
	{
		str = "Joint";
		return str;
	}
	if(item == 6) // Cloth
	{
		str = "Cloth Piece";
		return str;
	}
	if(item == 7) // Wood
	{
		str = "Wood Piece";
		return str;
	}
	if(item == 8) // Metal
	{
		str = "Metal Sheet";
		return str;
	}
	if(item == 9) // RMetal
	{
		str = "Refined Metal";
		return str;
	}
	if(item == 10) // GunP
	{
		str = "Gun Piece";
		return str;
	}
	else
	{
		format(str, sizeof(str),"[ERROR] Item ID [%d] was sent to get named.", item);
		printf("%s", str);
		SendAdminMessage(RED, str);
		str = "Unknown Item";
		return str;
	}
}

stock GetWeapModel(weapon)
{
	new str[128];
	if(weapon == 1) // KNUCKLE
	{
		return 331;
	}
	if(weapon == 3) // NightStick
	{
		return 334;
	}
	if(weapon == 4) // Knife
	{
		return 335;
	}
	if(weapon == 5) // Baseball Bat
	{
		return 336;
	}
	if(weapon == 6) // Shovel
	{
		return 337;
	}
	if(weapon == 22) 
	{
		return 346;
	}
	if(weapon == 23)
	{
		return 347;
	}
	if(weapon == 24)
	{
		return 348;
	}
	if(weapon == 25)
	{
		return 349;
	}
	if(weapon == 26)
	{
		return 350;
	}
	if(weapon == 27)
	{
		return 351;
	}
	if(weapon == 28)
	{
		return 352;
	}
	if(weapon == 29)
	{
		return 353;
	}
	if(weapon == 31)
	{
		return 356;
	}
	if(weapon == 33)
	{
		return 357;
	}
	if(weapon == 34)
	{
		return 358;
	}
	else
	{
		format(str, sizeof(str),"[ERROR] Weapon ID [%d] was sent to get a model ID.", weapon);
		printf("%s", str);
		SendAdminMessage(RED, str);
	}
	return 1;
}

stock ShowTargetInventory(playerid, targetid)
{	
	new text1[124], weaponname[60];
	PlayerTextDrawShow(playerid, INV_BG1[targetid]);
	PlayerTextDrawShow(playerid, INV_BG2[targetid]);
	PlayerTextDrawShow(playerid, INV_BG3[targetid]);
	PlayerTextDrawShow(playerid, INV_BG4[targetid]);
	PlayerTextDrawShow(playerid, INV_BG5[targetid]);
	PlayerTextDrawShow(playerid, INV_BG6[targetid]);
	PlayerTextDrawShow(playerid, INV_BG7[targetid]);
	PlayerTextDrawShow(playerid, INV_BG8[targetid]);
	PlayerTextDrawShow(playerid, INV_BG9[targetid]);
	PlayerTextDrawShow(playerid, INV_BG10[targetid]);
	PlayerTextDrawShow(playerid, INV_BG11[targetid]);
	PlayerTextDrawShow(playerid, INV_BG12[targetid]);
	PlayerTextDrawShow(playerid, INV_BG13[targetid]);
	PlayerTextDrawShow(playerid, INV_BG14[targetid]);
	PlayerTextDrawShow(playerid, INV_BG15[targetid]);
	PlayerTextDrawShow(playerid, INV_BG16[targetid]);
	PlayerTextDrawShow(playerid, INV_BG17[targetid]);
	PlayerTextDrawShow(playerid, INV_BG18[targetid]);
	PlayerTextDrawShow(playerid, INV_BG19[targetid]);
	PlayerTextDrawShow(playerid, INV_BG20[targetid]);
	PlayerTextDrawShow(playerid, INV_BG21[targetid]);
	PlayerTextDrawShow(playerid, INV_BG22[targetid]);
	PlayerTextDrawShow(playerid, INV_BG23[targetid]);
	format(text1, sizeof(text1), "%s", GetOOCName(targetid));
	PlayerTextDrawSetString(playerid, INV_NAM_STR[targetid], text1);
	PlayerTextDrawShow(playerid, INV_NAM_STR[targetid]);
	PlayerTextDrawShow(playerid, INV_CLO_BUT[targetid]);
	if(PlayerStat[targetid][WeaponSlot0] != 0)
	{
		PlayerTextDrawSetPreviewModel(playerid, ITM1_PIC_WEP[targetid], GetWeapModel(PlayerStat[targetid][WeaponSlot0]));
		PlayerTextDrawShow(playerid, ITM1_PIC_WEP[targetid]);
		GetWeaponName(PlayerStat[targetid][WeaponSlot0], weaponname, sizeof(weaponname));
		format(text1, sizeof(text1), "%s", weaponname);
		PlayerTextDrawSetString(playerid, ITM1_STR_NAME[targetid], text1);
		PlayerTextDrawShow(playerid, ITM1_STR_NAME[targetid]);
		format(text1, sizeof(text1), "%d", PlayerStat[targetid][WeaponSlot0Ammo]);
		PlayerTextDrawSetString(playerid, ITM1_STR_AMMO[targetid], text1);
		PlayerTextDrawShow(playerid, ITM1_STR_AMMO[targetid]);
	}
	if(PlayerStat[targetid][WeaponSlot1] != 0)
	{
		PlayerTextDrawSetPreviewModel(playerid, ITM2_PIC_WEP[targetid], GetWeapModel(PlayerStat[targetid][WeaponSlot1]));
		PlayerTextDrawShow(playerid, ITM2_PIC_WEP[targetid]);
		GetWeaponName(PlayerStat[targetid][WeaponSlot1], weaponname, sizeof(weaponname));
		format(text1, sizeof(text1), "%s", weaponname);
		PlayerTextDrawSetString(playerid, ITM2_STR_NAME[targetid], text1);
		PlayerTextDrawShow(playerid, ITM2_STR_NAME[targetid]);
		format(text1, sizeof(text1), "%d", PlayerStat[targetid][WeaponSlot1Ammo]);
		PlayerTextDrawSetString(playerid, ITM2_STR_AMMO[targetid], text1);
		PlayerTextDrawShow(playerid, ITM2_STR_AMMO[targetid]);
	}
	if(PlayerStat[targetid][WeaponSlot2] != 0)
	{
		PlayerTextDrawSetPreviewModel(playerid, ITM3_PIC_WEP[targetid], GetWeapModel(PlayerStat[targetid][WeaponSlot2]));
		PlayerTextDrawShow(playerid, ITM3_PIC_WEP[targetid]);
		GetWeaponName(PlayerStat[targetid][WeaponSlot2], weaponname, sizeof(weaponname));
		format(text1, sizeof(text1), "%s", weaponname);
		PlayerTextDrawSetString(playerid, ITM3_STR_NAME[targetid], text1);
		PlayerTextDrawShow(playerid, ITM3_STR_NAME[targetid]);
		format(text1, sizeof(text1), "%d", PlayerStat[targetid][WeaponSlot2Ammo]);
		PlayerTextDrawSetString(playerid, ITM3_STR_AMMO[targetid], text1);
		PlayerTextDrawShow(playerid, ITM3_STR_AMMO[targetid]);
	}
	if(PlayerStat[targetid][INV_SLOT1] != 0)
	{
		PlayerTextDrawSetPreviewModel(playerid, INV_SLOT1_IMG[targetid], GetItemModel(PlayerStat[targetid][INV_SLOT1]));
		PlayerTextDrawShow(playerid, INV_SLOT1_IMG[targetid]);
		format(text1, sizeof(text1), "%d", PlayerStat[targetid][INV_SLOT1A]);
		PlayerTextDrawSetString(playerid, INV_AMO1_STR[targetid], text1);
		PlayerTextDrawShow(playerid, INV_AMO1_STR[targetid]);
	}
	if(PlayerStat[targetid][INV_SLOT2] != 0)
	{
		PlayerTextDrawSetPreviewModel(playerid, INV_SLOT2_IMG[targetid], GetItemModel(PlayerStat[targetid][INV_SLOT2]));
		PlayerTextDrawShow(playerid, INV_SLOT2_IMG[targetid]);
		format(text1, sizeof(text1), "%d", PlayerStat[targetid][INV_SLOT2A]);
		PlayerTextDrawSetString(playerid, INV_AMO2_STR[targetid], text1);
		PlayerTextDrawShow(playerid, INV_AMO2_STR[targetid]);
	}
	if(PlayerStat[targetid][INV_SLOT3] != 0)
	{
		PlayerTextDrawSetPreviewModel(playerid, INV_SLOT3_IMG[targetid], GetItemModel(PlayerStat[targetid][INV_SLOT3]));
		PlayerTextDrawShow(playerid, INV_SLOT3_IMG[targetid]);
		format(text1, sizeof(text1), "%d", PlayerStat[targetid][INV_SLOT3A]);
		PlayerTextDrawSetString(playerid, INV_AMO3_STR[targetid], text1);
		PlayerTextDrawShow(playerid, INV_AMO3_STR[targetid]);
	}
	if(PlayerStat[targetid][INV_SLOT4] != 0)
	{
		PlayerTextDrawSetPreviewModel(playerid, INV_SLOT4_IMG[targetid], GetItemModel(PlayerStat[targetid][INV_SLOT4]));
		PlayerTextDrawShow(playerid, INV_SLOT4_IMG[targetid]);
		format(text1, sizeof(text1), "%d", PlayerStat[targetid][INV_SLOT4A]);
		PlayerTextDrawSetString(playerid, INV_AMO4_STR[targetid], text1);
		PlayerTextDrawShow(playerid, INV_AMO4_STR[targetid]);
	}
	if(PlayerStat[targetid][INV_SLOT5] != 0)
	{
		PlayerTextDrawSetPreviewModel(playerid, INV_SLOT5_IMG[targetid], GetItemModel(PlayerStat[targetid][INV_SLOT5]));
		PlayerTextDrawShow(playerid, INV_SLOT5_IMG[targetid]);
		format(text1, sizeof(text1), "%d", PlayerStat[targetid][INV_SLOT5A]);
		PlayerTextDrawSetString(playerid, INV_AMO5_STR[targetid], text1);
		PlayerTextDrawShow(playerid, INV_AMO5_STR[targetid]);
	}
	if(PlayerStat[targetid][INV_SLOT6] != 0)
	{
		PlayerTextDrawSetPreviewModel(playerid, INV_SLOT6_IMG[targetid], GetItemModel(PlayerStat[targetid][INV_SLOT6]));
		PlayerTextDrawShow(playerid, INV_SLOT6_IMG[targetid]);
		format(text1, sizeof(text1), "%d", PlayerStat[targetid][INV_SLOT6A]);
		PlayerTextDrawSetString(playerid, INV_AMO6_STR[targetid], text1);
		PlayerTextDrawShow(playerid, INV_AMO6_STR[targetid]);
	}
	if(PlayerStat[targetid][INV_SLOT7] != 0)
	{
		PlayerTextDrawSetPreviewModel(playerid, INV_SLOT7_IMG[targetid], GetItemModel(PlayerStat[targetid][INV_SLOT7]));
		PlayerTextDrawShow(playerid, INV_SLOT7_IMG[targetid]);
		format(text1, sizeof(text1), "%d", PlayerStat[targetid][INV_SLOT7A]);
		PlayerTextDrawSetString(playerid, INV_AMO7_STR[targetid], text1);
		PlayerTextDrawShow(playerid, INV_AMO7_STR[targetid]);
	}
	if(PlayerStat[targetid][INV_SLOT8] != 0)
	{
		PlayerTextDrawSetPreviewModel(playerid, INV_SLOT8_IMG[targetid], GetItemModel(PlayerStat[targetid][INV_SLOT8]));
		PlayerTextDrawShow(playerid, INV_SLOT8_IMG[targetid]);
		format(text1, sizeof(text1), "%d", PlayerStat[targetid][INV_SLOT8A]);
		PlayerTextDrawSetString(playerid, INV_AMO8_STR[targetid], text1);
		PlayerTextDrawShow(playerid, INV_AMO8_STR[targetid]);
	}
	if(PlayerStat[targetid][INV_SLOT9] != 0)
	{
		PlayerTextDrawSetPreviewModel(playerid, INV_SLOT9_IMG[targetid], GetItemModel(PlayerStat[targetid][INV_SLOT9]));
		PlayerTextDrawShow(playerid, INV_SLOT9_IMG[targetid]);
		format(text1, sizeof(text1), "%d", PlayerStat[targetid][INV_SLOT9A]);
		PlayerTextDrawSetString(playerid, INV_AMO9_STR[targetid], text1);
		PlayerTextDrawShow(playerid, INV_AMO9_STR[targetid]);
	}
	if(PlayerStat[targetid][INV_SLOT10] != 0)
	{
		PlayerTextDrawSetPreviewModel(playerid, INV_SLOT10_IMG[targetid], GetItemModel(PlayerStat[targetid][INV_SLOT10]));
		PlayerTextDrawShow(playerid, INV_SLOT10_IMG[targetid]);
		format(text1, sizeof(text1), "%d", PlayerStat[targetid][INV_SLOT10A]);
		PlayerTextDrawSetString(playerid, INV_AMO10_STR[targetid], text1);
		PlayerTextDrawShow(playerid, INV_AMO10_STR[targetid]);
	}
	format(text1, sizeof(text1), "Weed: %d I Crack: %d", PlayerStat[targetid][Pot], PlayerStat[targetid][Crack]);
	PlayerTextDrawSetString(playerid, INV_STAT1_STR[targetid], text1);
	PlayerTextDrawShow(playerid, INV_STAT1_STR[targetid]);
	format(text1, sizeof(text1), "Rolling Papers: %d", PlayerStat[targetid][Paper]);
	PlayerTextDrawSetString(playerid, INV_STAT2_STR[targetid], text1);
	PlayerTextDrawShow(playerid, INV_STAT2_STR[targetid]);
	return 1;
}

stock ShowCrafting(playerid)
{	
	new text1[124];
	CRF_ITM1[playerid] = 0;
	CRF_ITM1A[playerid] = 0;
	CRF_ITM2[playerid] = 0;
	CRF_ITM2A[playerid] = 0;
	CRF_ITM3[playerid] = 0;
	CRF_ITM3A[playerid] = 0;
	CRF_ITM4[playerid] = 0;
	CRF_ITM4A[playerid] = 0;
	CRF_ITM5[playerid] = 0;
	CRF_ITM5A[playerid] = 0;
	CRF_ITM6[playerid] = 0;
	CRF_ITM6A[playerid] = 0;
	CRF_ITM7[playerid] = 0;
	CRF_ITM7A[playerid] = 0;
	CRF_ITM8[playerid] = 0;
	CRF_ITM8A[playerid] = 0;
	CRF_ITM9[playerid] = 0;
	CRF_ITM9A[playerid] = 0;
	CRF_ITM10[playerid] = 0;
	CRF_ITM10A[playerid] = 0;
	PlayerTextDrawShow(playerid, CRF_BG1[playerid]);
	PlayerTextDrawShow(playerid, CRF_BG2[playerid]);
	PlayerTextDrawShow(playerid, CRF_BG3[playerid]);
	PlayerTextDrawShow(playerid, CRF_BG4[playerid]);
	PlayerTextDrawShow(playerid, CRF_BG5[playerid]);
	PlayerTextDrawShow(playerid, CRF_BG6[playerid]);
	PlayerTextDrawShow(playerid, CRF_BG7[playerid]);
	PlayerTextDrawShow(playerid, CRF_CRF_BTN[playerid]);
	format(text1, sizeof(text1), "Metal Working: %d", PlayerStat[playerid][MetSkill]);
	PlayerTextDrawSetString(playerid, CRF_MET_STR[playerid], text1);
	PlayerTextDrawShow(playerid, CRF_MET_STR[playerid]);
	format(text1, sizeof(text1), "Wood Working: %d", PlayerStat[playerid][WodSkill]);
	PlayerTextDrawSetString(playerid, CRF_WOD_STR[playerid], text1);
	PlayerTextDrawShow(playerid, CRF_WOD_STR[playerid]);
	format(text1, sizeof(text1), "Crafting Skill: %d", PlayerStat[playerid][CrfSkill]);
	PlayerTextDrawSetString(playerid, CRF_CRF_STR[playerid], text1);
	PlayerTextDrawShow(playerid, CRF_CRF_STR[playerid]);
	return 1;
}

stock ShowInventory(playerid)
{	
	new text1[124], weaponname[60];
	PlayerTextDrawShow(playerid, INV_BG1[playerid]);
	PlayerTextDrawShow(playerid, INV_BG2[playerid]);
	PlayerTextDrawShow(playerid, INV_BG3[playerid]);
	PlayerTextDrawShow(playerid, INV_BG4[playerid]);
	PlayerTextDrawShow(playerid, INV_BG5[playerid]);
	PlayerTextDrawShow(playerid, INV_BG6[playerid]);
	PlayerTextDrawShow(playerid, INV_BG7[playerid]);
	PlayerTextDrawShow(playerid, INV_BG8[playerid]);
	PlayerTextDrawShow(playerid, INV_BG9[playerid]);
	PlayerTextDrawShow(playerid, INV_BG10[playerid]);
	PlayerTextDrawShow(playerid, INV_BG11[playerid]);
	PlayerTextDrawShow(playerid, INV_BG12[playerid]);
	PlayerTextDrawShow(playerid, INV_BG13[playerid]);
	PlayerTextDrawShow(playerid, INV_BG14[playerid]);
	PlayerTextDrawShow(playerid, INV_BG15[playerid]);
	PlayerTextDrawShow(playerid, INV_BG16[playerid]);
	PlayerTextDrawShow(playerid, INV_BG17[playerid]);
	PlayerTextDrawShow(playerid, INV_BG18[playerid]);
	PlayerTextDrawShow(playerid, INV_BG19[playerid]);
	PlayerTextDrawShow(playerid, INV_BG20[playerid]);
	PlayerTextDrawShow(playerid, INV_BG21[playerid]);
	PlayerTextDrawShow(playerid, INV_BG22[playerid]);
	PlayerTextDrawShow(playerid, INV_BG23[playerid]);
	format(text1, sizeof(text1), "%s", GetOOCName(playerid));
	PlayerTextDrawSetString(playerid, INV_NAM_STR[playerid], text1);
	PlayerTextDrawShow(playerid, INV_NAM_STR[playerid]);
	PlayerTextDrawShow(playerid, INV_CLO_BUT[playerid]);
	PlayerTextDrawShow(playerid, INV_USE_BTN[playerid]);
	PlayerTextDrawShow(playerid, INV_DROP_BTN[playerid]);
	PlayerTextDrawShow(playerid, INV_CRAFT_BTN[playerid]);
	if(PlayerStat[playerid][WeaponSlot0] != 0)
	{
		PlayerTextDrawSetPreviewModel(playerid, ITM1_PIC_WEP[playerid], GetWeapModel(PlayerStat[playerid][WeaponSlot0]));
		PlayerTextDrawShow(playerid, ITM1_PIC_WEP[playerid]);
		GetWeaponName(PlayerStat[playerid][WeaponSlot0], weaponname, sizeof(weaponname));
		format(text1, sizeof(text1), "%s", weaponname);
		PlayerTextDrawSetString(playerid, ITM1_STR_NAME[playerid], text1);
		PlayerTextDrawShow(playerid, ITM1_STR_NAME[playerid]);
		format(text1, sizeof(text1), "%d", PlayerStat[playerid][WeaponSlot0Ammo]);
		PlayerTextDrawSetString(playerid, ITM1_STR_AMMO[playerid], text1);
		PlayerTextDrawShow(playerid, ITM1_STR_AMMO[playerid]);
	}
	if(PlayerStat[playerid][WeaponSlot1] != 0)
	{
		PlayerTextDrawSetPreviewModel(playerid, ITM2_PIC_WEP[playerid], GetWeapModel(PlayerStat[playerid][WeaponSlot1]));
		PlayerTextDrawShow(playerid, ITM2_PIC_WEP[playerid]);
		GetWeaponName(PlayerStat[playerid][WeaponSlot1], weaponname, sizeof(weaponname));
		format(text1, sizeof(text1), "%s", weaponname);
		PlayerTextDrawSetString(playerid, ITM2_STR_NAME[playerid], text1);
		PlayerTextDrawShow(playerid, ITM2_STR_NAME[playerid]);
		format(text1, sizeof(text1), "%d", PlayerStat[playerid][WeaponSlot1Ammo]);
		PlayerTextDrawSetString(playerid, ITM2_STR_AMMO[playerid], text1);
		PlayerTextDrawShow(playerid, ITM2_STR_AMMO[playerid]);
	}
	if(PlayerStat[playerid][WeaponSlot2] != 0)
	{
		PlayerTextDrawSetPreviewModel(playerid, ITM3_PIC_WEP[playerid], GetWeapModel(PlayerStat[playerid][WeaponSlot2]));
		PlayerTextDrawShow(playerid, ITM3_PIC_WEP[playerid]);
		GetWeaponName(PlayerStat[playerid][WeaponSlot2], weaponname, sizeof(weaponname));
		format(text1, sizeof(text1), "%s", weaponname);
		PlayerTextDrawSetString(playerid, ITM3_STR_NAME[playerid], text1);
		PlayerTextDrawShow(playerid, ITM3_STR_NAME[playerid]);
		format(text1, sizeof(text1), "%d", PlayerStat[playerid][WeaponSlot2Ammo]);
		PlayerTextDrawSetString(playerid, ITM3_STR_AMMO[playerid], text1);
		PlayerTextDrawShow(playerid, ITM3_STR_AMMO[playerid]);
	}
	if(PlayerStat[playerid][INV_SLOT1] != 0)
	{
		PlayerTextDrawSetPreviewModel(playerid, INV_SLOT1_IMG[playerid], GetItemModel(PlayerStat[playerid][INV_SLOT1]));
		PlayerTextDrawShow(playerid, INV_SLOT1_IMG[playerid]);
		format(text1, sizeof(text1), "%d", PlayerStat[playerid][INV_SLOT1A]);
		PlayerTextDrawSetString(playerid, INV_AMO1_STR[playerid], text1);
		PlayerTextDrawShow(playerid, INV_AMO1_STR[playerid]);
	}
	if(PlayerStat[playerid][INV_SLOT2] != 0)
	{
		PlayerTextDrawSetPreviewModel(playerid, INV_SLOT2_IMG[playerid], GetItemModel(PlayerStat[playerid][INV_SLOT2]));
		PlayerTextDrawShow(playerid, INV_SLOT2_IMG[playerid]);
		format(text1, sizeof(text1), "%d", PlayerStat[playerid][INV_SLOT2A]);
		PlayerTextDrawSetString(playerid, INV_AMO2_STR[playerid], text1);
		PlayerTextDrawShow(playerid, INV_AMO2_STR[playerid]);
	}
	if(PlayerStat[playerid][INV_SLOT3] != 0)
	{
		PlayerTextDrawSetPreviewModel(playerid, INV_SLOT3_IMG[playerid], GetItemModel(PlayerStat[playerid][INV_SLOT3]));
		PlayerTextDrawShow(playerid, INV_SLOT3_IMG[playerid]);
		format(text1, sizeof(text1), "%d", PlayerStat[playerid][INV_SLOT3A]);
		PlayerTextDrawSetString(playerid, INV_AMO3_STR[playerid], text1);
		PlayerTextDrawShow(playerid, INV_AMO3_STR[playerid]);
	}
	if(PlayerStat[playerid][INV_SLOT4] != 0)
	{
		PlayerTextDrawSetPreviewModel(playerid, INV_SLOT4_IMG[playerid], GetItemModel(PlayerStat[playerid][INV_SLOT4]));
		PlayerTextDrawShow(playerid, INV_SLOT4_IMG[playerid]);
		format(text1, sizeof(text1), "%d", PlayerStat[playerid][INV_SLOT4A]);
		PlayerTextDrawSetString(playerid, INV_AMO4_STR[playerid], text1);
		PlayerTextDrawShow(playerid, INV_AMO4_STR[playerid]);
	}
	if(PlayerStat[playerid][INV_SLOT5] != 0)
	{
		PlayerTextDrawSetPreviewModel(playerid, INV_SLOT5_IMG[playerid], GetItemModel(PlayerStat[playerid][INV_SLOT5]));
		PlayerTextDrawShow(playerid, INV_SLOT5_IMG[playerid]);
		format(text1, sizeof(text1), "%d", PlayerStat[playerid][INV_SLOT5A]);
		PlayerTextDrawSetString(playerid, INV_AMO5_STR[playerid], text1);
		PlayerTextDrawShow(playerid, INV_AMO5_STR[playerid]);
	}
	if(PlayerStat[playerid][INV_SLOT6] != 0)
	{
		PlayerTextDrawSetPreviewModel(playerid, INV_SLOT6_IMG[playerid], GetItemModel(PlayerStat[playerid][INV_SLOT6]));
		PlayerTextDrawShow(playerid, INV_SLOT6_IMG[playerid]);
		format(text1, sizeof(text1), "%d", PlayerStat[playerid][INV_SLOT6A]);
		PlayerTextDrawSetString(playerid, INV_AMO6_STR[playerid], text1);
		PlayerTextDrawShow(playerid, INV_AMO6_STR[playerid]);
	}
	if(PlayerStat[playerid][INV_SLOT7] != 0)
	{
		PlayerTextDrawSetPreviewModel(playerid, INV_SLOT7_IMG[playerid], GetItemModel(PlayerStat[playerid][INV_SLOT7]));
		PlayerTextDrawShow(playerid, INV_SLOT7_IMG[playerid]);
		format(text1, sizeof(text1), "%d", PlayerStat[playerid][INV_SLOT7A]);
		PlayerTextDrawSetString(playerid, INV_AMO7_STR[playerid], text1);
		PlayerTextDrawShow(playerid, INV_AMO7_STR[playerid]);
	}
	if(PlayerStat[playerid][INV_SLOT8] != 0)
	{
		PlayerTextDrawSetPreviewModel(playerid, INV_SLOT8_IMG[playerid], GetItemModel(PlayerStat[playerid][INV_SLOT8]));
		PlayerTextDrawShow(playerid, INV_SLOT8_IMG[playerid]);
		format(text1, sizeof(text1), "%d", PlayerStat[playerid][INV_SLOT8A]);
		PlayerTextDrawSetString(playerid, INV_AMO8_STR[playerid], text1);
		PlayerTextDrawShow(playerid, INV_AMO8_STR[playerid]);
	}
	if(PlayerStat[playerid][INV_SLOT9] != 0)
	{
		PlayerTextDrawSetPreviewModel(playerid, INV_SLOT9_IMG[playerid], GetItemModel(PlayerStat[playerid][INV_SLOT9]));
		PlayerTextDrawShow(playerid, INV_SLOT9_IMG[playerid]);
		format(text1, sizeof(text1), "%d", PlayerStat[playerid][INV_SLOT9A]);
		PlayerTextDrawSetString(playerid, INV_AMO9_STR[playerid], text1);
		PlayerTextDrawShow(playerid, INV_AMO9_STR[playerid]);
	}
	if(PlayerStat[playerid][INV_SLOT10] != 0)
	{
		PlayerTextDrawSetPreviewModel(playerid, INV_SLOT10_IMG[playerid], GetItemModel(PlayerStat[playerid][INV_SLOT10]));
		PlayerTextDrawShow(playerid, INV_SLOT10_IMG[playerid]);
		format(text1, sizeof(text1), "%d", PlayerStat[playerid][INV_SLOT10A]);
		PlayerTextDrawSetString(playerid, INV_AMO10_STR[playerid], text1);
		PlayerTextDrawShow(playerid, INV_AMO10_STR[playerid]);
	}
	format(text1, sizeof(text1), "Weed: %d I Crack: %d", PlayerStat[playerid][Pot], PlayerStat[playerid][Crack]);
	PlayerTextDrawSetString(playerid, INV_STAT1_STR[playerid], text1);
	PlayerTextDrawShow(playerid, INV_STAT1_STR[playerid]);
	format(text1, sizeof(text1), "Rolling Papers: %d", PlayerStat[playerid][Paper]);
	PlayerTextDrawSetString(playerid, INV_STAT2_STR[playerid], text1);
	PlayerTextDrawShow(playerid, INV_STAT2_STR[playerid]);
	return 1;
}

stock CloseCrafting(playerid)
{	
	PlayerTextDrawHide(playerid, CRF_BG1[playerid]);
	PlayerTextDrawHide(playerid, CRF_BG2[playerid]);
	PlayerTextDrawHide(playerid, CRF_BG3[playerid]);
	PlayerTextDrawHide(playerid, CRF_ITM1_STR[playerid]);
	PlayerTextDrawHide(playerid, CRF_ITM2_STR[playerid]);
	PlayerTextDrawHide(playerid, CRF_ITM3_STR[playerid]);
	PlayerTextDrawHide(playerid, CRF_ITM4_STR[playerid]);
	PlayerTextDrawHide(playerid, CRF_ITM5_STR[playerid]);
	PlayerTextDrawHide(playerid, CRF_ITM6_STR[playerid]);
	PlayerTextDrawHide(playerid, CRF_ITM7_STR[playerid]);
	PlayerTextDrawHide(playerid, CRF_ITM8_STR[playerid]);
	PlayerTextDrawHide(playerid, CRF_ITM9_STR[playerid]);
	PlayerTextDrawHide(playerid, CRF_ITM10_STR[playerid]);
	PlayerTextDrawHide(playerid, CRF_BG4[playerid]);
	PlayerTextDrawHide(playerid, CRF_BG5[playerid]);
	PlayerTextDrawHide(playerid, CRF_BG6[playerid]);
	PlayerTextDrawHide(playerid, CRF_MET_STR[playerid]);
	PlayerTextDrawHide(playerid, CRF_WOD_STR[playerid]);
	PlayerTextDrawHide(playerid, CRF_CRF_STR[playerid]);
	PlayerTextDrawHide(playerid, CRF_BG7[playerid]);
	PlayerTextDrawHide(playerid, CRF_CRF_BTN[playerid]);
	return 1;
}

stock CloseInventory(playerid)
{	
	PlayerTextDrawHide(playerid, INV_BG1[playerid]);
	PlayerTextDrawHide(playerid, INV_BG2[playerid]);
	PlayerTextDrawHide(playerid, INV_BG3[playerid]);
	PlayerTextDrawHide(playerid, INV_BG4[playerid]);
	PlayerTextDrawHide(playerid, INV_BG5[playerid]);
	PlayerTextDrawHide(playerid, ITM1_STR_NAME[playerid]);
	PlayerTextDrawHide(playerid, ITM1_PIC_WEP[playerid]);
	PlayerTextDrawHide(playerid, ITM1_STR_AMMO[playerid]);
	PlayerTextDrawHide(playerid, INV_BG6[playerid]);
	PlayerTextDrawHide(playerid, INV_BG7[playerid]);
	PlayerTextDrawHide(playerid, ITM2_STR_NAME[playerid]);
	PlayerTextDrawHide(playerid, ITM2_PIC_WEP[playerid]);
	PlayerTextDrawHide(playerid, ITM2_STR_AMMO[playerid]);
	PlayerTextDrawHide(playerid, INV_BG8[playerid]);
	PlayerTextDrawHide(playerid, INV_BG9[playerid]);
	PlayerTextDrawHide(playerid, ITM3_STR_NAME[playerid]);
	PlayerTextDrawHide(playerid, ITM3_PIC_WEP[playerid]);
	PlayerTextDrawHide(playerid, ITM3_STR_AMMO[playerid]);
	PlayerTextDrawHide(playerid, INV_NAM_STR[playerid]);
	PlayerTextDrawHide(playerid, INV_CLO_BUT[playerid]);
	PlayerTextDrawHide(playerid, INV_BG10[playerid]);
	PlayerTextDrawHide(playerid, INV_BG11[playerid]);
	PlayerTextDrawHide(playerid, INV_BG12[playerid]);
	PlayerTextDrawHide(playerid, INV_BG13[playerid]);
	PlayerTextDrawHide(playerid, INV_BG14[playerid]);
	PlayerTextDrawHide(playerid, INV_BG15[playerid]);
	PlayerTextDrawHide(playerid, INV_BG16[playerid]);
	PlayerTextDrawHide(playerid, INV_BG17[playerid]);
	PlayerTextDrawHide(playerid, INV_BG18[playerid]);
	PlayerTextDrawHide(playerid, INV_BG19[playerid]);
	PlayerTextDrawHide(playerid, INV_SLOT1_IMG[playerid]);
	PlayerTextDrawHide(playerid, INV_SLOT2_IMG[playerid]);
	PlayerTextDrawHide(playerid, INV_SLOT3_IMG[playerid]);
	PlayerTextDrawHide(playerid, INV_SLOT4_IMG[playerid]);
	PlayerTextDrawHide(playerid, INV_SLOT5_IMG[playerid]);
	PlayerTextDrawHide(playerid, INV_SLOT6_IMG[playerid]);
	PlayerTextDrawHide(playerid, INV_SLOT7_IMG[playerid]);
	PlayerTextDrawHide(playerid, INV_SLOT8_IMG[playerid]);
	PlayerTextDrawHide(playerid, INV_SLOT9_IMG[playerid]);
	PlayerTextDrawHide(playerid, INV_SLOT10_IMG[playerid]);
	PlayerTextDrawHide(playerid, INV_AMO1_STR[playerid]);
	PlayerTextDrawHide(playerid, INV_AMO2_STR[playerid]);
	PlayerTextDrawHide(playerid, INV_AMO3_STR[playerid]);
	PlayerTextDrawHide(playerid, INV_AMO4_STR[playerid]);
	PlayerTextDrawHide(playerid, INV_AMO5_STR[playerid]);
	PlayerTextDrawHide(playerid, INV_AMO6_STR[playerid]);
	PlayerTextDrawHide(playerid, INV_AMO7_STR[playerid]);
	PlayerTextDrawHide(playerid, INV_AMO8_STR[playerid]);
	PlayerTextDrawHide(playerid, INV_AMO9_STR[playerid]);
	PlayerTextDrawHide(playerid, INV_AMO10_STR[playerid]);
	PlayerTextDrawHide(playerid, INV_BG20[playerid]);
	PlayerTextDrawHide(playerid, INV_BG21[playerid]);
	PlayerTextDrawHide(playerid, INV_BG22[playerid]);
	PlayerTextDrawHide(playerid, INV_BG23[playerid]);
	PlayerTextDrawHide(playerid, INV_USE_BTN[playerid]);
	PlayerTextDrawHide(playerid, INV_DROP_BTN[playerid]);
	PlayerTextDrawHide(playerid, INV_CRAFT_BTN[playerid]);
	PlayerTextDrawHide(playerid, INV_PRV_IMG[playerid]);
	PlayerTextDrawHide(playerid, INV_PRV_STR[playerid]);
	PlayerTextDrawHide(playerid, INV_STAT1_STR[playerid]);
	PlayerTextDrawHide(playerid, INV_STAT2_STR[playerid]);
	PlayerTextDrawHide(playerid, INV_STAT3_STR[playerid]);
	return 1;
}

stock BleedingWoundTimer(playerid);
public BleedingWoundTimer(playerid)
{
	if(PlayerStat[playerid][BleedingWound] == 0)
	{
		KillTimer(BleedingWoundTimer(playerid));
		return 1;
	}
	new Float: cHealth;
	GetPlayerHealth(playerid, cHealth);
	if(PlayerStat[playerid][BleedingWound] == 20)
	{
		SetPlayerHealth(playerid, 0);
		SendClientMessage(playerid, RED, "You have lost too much blood from bleeding and you fainted away.");
		PlayerStat[playerid][BleedingWound] = 0;
		PlayerPlaySound(playerid, 5204, 0, 0, 0);
		KillTimer(BleedingWoundTimer(playerid));
		return 1;
	}
	if(PlayerStat[playerid][BleedingWound] == 1)
	{
		SetPlayerHealth(playerid, cHealth - 5.0);
		SendClientMessage(playerid, RED, "You have a stab wound which is bleeding, get help from a guard or an EMT to stop the bleeding.");
	}
	if(PlayerStat[playerid][BleedingWound] == 2)
	{
		SetPlayerHealth(playerid, cHealth - 7.0);
		SendClientMessage(playerid, RED, "You have a stab wound which is bleeding, get help from a guard or an EMT to stop the bleeding.");
	}
	if(PlayerStat[playerid][BleedingWound] >= 3)
	{
		SetPlayerHealth(playerid, cHealth - 9.0);
		SendClientMessage(playerid, RED, "You have a stab wound which is bleeding heavily, get help from a guard or an EMT to stop the bleeding.");
	}
	PlayerPlaySound(playerid, 5204, 0, 0, 0);
	return 1;
}

forward ClearBleedingWound(playerid, targetid);
public ClearBleedingWound(playerid, targetid)
{
	ClearAnimations(playerid);
	PlayerStat[targetid][BleedingWound] = 0;
	KillTimer(BleedingWoundTimer(targetid));
	SendClientMessage(playerid, RED, "You have bandaged the wound.");
	SendClientMessage(targetid, RED, "Your wound have been bandaged and the bleeding has stopped.");
	return 1;
}

forward ClothesPlayerAnimations(playerid);
public ClothesPlayerAnimations(playerid)
{
	ClearAnimations(playerid);
	SetPlayerFacingAngle(playerid, 270);
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	new str[150], pip[16], playerid;
    if(!success)
	{
        for(new i=0; i<MAX_PLAYERS; i++)
        {
			GetPlayerIp(i, pip, sizeof(pip));
			if(!strcmp(ip, pip, true)) 
            {
				playerid = i;
				goto send_message;
			}
		}
		send_message:
		format(str, sizeof(str), "Player: %s has attempted and failed to RCON login |[IP:%s][Password:%s]|.", GetOOCName(playerid), ip, password);
		AdminActionLog(str);
		format(str, sizeof(str), "[WARNING] Player: %s has failed to RCON Login [IP:%s].", GetOOCName(playerid), ip);
		SendAdminMessage(RED, str);
	}
	return 1;
}

public OneSecondUpdate()
{
    for(new i = 0; i<MAX_PLAYERS; i++)
	{
        if(PlayerStat[i][Logged] == 1 && PlayerStat[i][Spawned] == 1)
		{
            if(Server[CurrentGMX] >= 1)
		    {
                Server[CurrentGMX]--;
                if(Server[CurrentGMX] <= 0)
				{
					SaveShops();
					SaveServerInfo();
                    GameTextForPlayer(i, "~w~ Server Restart", 10000, 4);
					SendRconCommand("gmx");
				}
		    }
		    if(PlayerStat[i][BPCD] >= 1)
		    {
		        PlayerStat[i][BPCD]--;
		    }
		    if(PlayerStat[i][BPACD] >= 1)
		    {
		        PlayerStat[i][BPACD]--;
		    }
		    if(PlayerStat[i][BPBAR] == 1)
		    {
    			TextDrawHideForPlayer(i, Text:BENCH);
				new newtext[41];
				format(newtext, sizeof(newtext), "%d / 100", PlayerStat[i][BPDIF]);
				TextDrawSetString(BENCH, newtext);
				TextDrawShowForPlayer(i, Text:BENCH);
			}
			if(PlayerClimbingRope[i] == 1)
			{
				new Float:ropex, Float:ropey, Float:ropez;
				new sttr[128];
				GetPlayerPos(i, ropex, ropey, ropez);
				SetPlayerPos(i, ropex, ropey, ropez-0.15);
				ApplyAnimation(i, "PED", "abseil", 4.1, 1, 0, 0, 0, 0);
				if(ropez <= 10.89)
				{
					SetPlayerPos(i, 224.1172, 1472.6801, 10.6878);
					format(sttr, sizeof(sttr), "* %s has fell from the rope.", GetICName(i));
					SendNearByMessage(i, ACTION_COLOR, sttr, 12);
					TogglePlayerControllable(i, true);
					PlayerClimbingRope[i] = 0;
					RopeUsed = 0;
				}
			}
			if(PlayerStat[i][WeaponPocketCD] >= 1)
			{
				PlayerStat[i][WeaponPocketCD]--;
			}
		    if(PlayerStat[i][BPUSE] == 1)
		    {
				if(PlayerStat[i][BPDIF] >= 100)
				{
					PlayerStat[i][BPBAR] = 0;
					SendClientMessage(i, GREEN, "You have made a successful exercise.");
					RemovePlayerAttachedObject(i, 1);
                    TextDrawHideForPlayer(i, Text:BENCH);
                    TextDrawHideForPlayer(i, Text:BENCH_NAME);
                    TextDrawHideForPlayer(i, Text:BENCH_INFO);
					new Float: fHealth;
            		GetPlayerHealth(i, fHealth);
					if(fHealth <= 80)
					{
						SetPlayerHealth(i, fHealth + 20);
					}
					else
					{
						SetPlayerHealth(i, 100);
					}
					PlayerStat[i][StatPWR] += 1;
					PlayerStat[i][BPDIF] = 0;
					PlayerStat[i][BPANM] = 1;
					PlayerStat[i][BPCD] = 1800;
					PlayerStat[i][BPACD] = 0;
					PlayerStat[i][BPUSE] = 0;
    				ApplyAnimation(i,"BENCHPRESS","gym_bp_getoff", 4.0, 0, 0, 0, 0, 0, 0);
					SetCameraBehindPlayer(i);
                    SetTimerEx("BPANCD", 3000, false, "i", i);
        			if(PlayerStat[i][BPNMB] == 1)
                    {
                        BenchPress1Used = 0;
                        PlayerStat[i][BPNMB] = 0;
                    }
                    else if(PlayerStat[i][BPNMB] == 2)
                    {
                        BenchPress2Used = 0;
                        PlayerStat[i][BPNMB] = 0;
                    }
                    else if(PlayerStat[i][BPNMB] == 3)
                    {
                        BenchPress3Used = 0;
                        PlayerStat[i][BPNMB] = 0;
                    }
				}
				else if(PlayerStat[i][BPDIF] <= -50)
				{
					PlayerStat[i][BPBAR] = 0;
					RemovePlayerAttachedObject(i, 1);
					SendClientMessage(i, GREEN, "You have dropped the weight on yourself, causing a hard injury.");
                    TextDrawHideForPlayer(i, Text:BENCH);
                    TextDrawHideForPlayer(i, Text:BENCH_NAME);
                    TextDrawHideForPlayer(i, Text:BENCH_INFO);
					new Float: fHealth;
            		GetPlayerHealth(i, fHealth);
					SetPlayerHealth(i, fHealth - 20);
					PlayerStat[i][BPDIF] = 0;
					PlayerStat[i][BPANM] = 1;
					PlayerStat[i][BPCD] = 3600;
					PlayerStat[i][BPACD] = 0;
					PlayerStat[i][BPUSE] = 0;
    				ApplyAnimation(i,"BENCHPRESS","gym_bp_getoff", 4.1, 0, 0, 0, 0, 0, 0);
    				SetCameraBehindPlayer(i);
					SetTimerEx("LoadingObjects", 4000, false, "d", i);
        			if(PlayerStat[i][BPNMB] == 1)
                    {
                        BenchPress1Used = 0;
                        PlayerStat[i][BPNMB] = 0;
                    }
                    else if(PlayerStat[i][BPNMB] == 2)
                    {
                        BenchPress2Used = 0;
                        PlayerStat[i][BPNMB] = 0;
                    }
                    else if(PlayerStat[i][BPNMB] == 3)
                    {
                        BenchPress3Used = 0;
                        PlayerStat[i][BPNMB] = 0;
                    }
				}
				else
				{
					if(PlayerStat[i][StatPWR] <= 4) // Beginer Lifer 
					{
					    PlayerStat[i][BPDIF] -= 2;
					}
					else if(PlayerStat[i][StatPWR] >= 4 && PlayerStat[i][StatPWR] <= 15) // Medium Lifter
					{
					    PlayerStat[i][BPDIF] -= 5;
					}
					else if(PlayerStat[i][StatPWR] >= 16) // Pro Lifter
					{
					    PlayerStat[i][BPDIF] -= 8;
					}
    				
				}
		    }
			if(PlayerStat[i][JRACD] >= 1)
			{
			    PlayerStat[i][JRACD]--;
			    if(PlayerStat[i][JRACD] <= 0)
			    {
			        TogglePlayerControllable(i,1);
			    }
			}
		    if(PlayerStat[i][BeingSpeced] == 1)
            {
				if(GetPlayerInterior(i) != GetPlayerInterior(PlayerStat[i][SpecingID]))
				{
                    SetPlayerInterior(i,GetPlayerInterior(PlayerStat[i][SpecingID]));
                }
                if(GetPlayerVirtualWorld(i) != GetPlayerVirtualWorld(PlayerStat[i][SpecingID]))
				{
                    SetPlayerVirtualWorld(i,GetPlayerVirtualWorld(PlayerStat[i][SpecingID]));
                }
            }
		    if(PlayerStat[i][Muted] == 1 && PNewReg[i] == 0)
		    {
                PlayerStat[i][MuteTime]--;
                if(PlayerStat[i][MuteTime] <= 0)
                {
                    PlayerStat[i][Muted] = 0;
                    SendClientMessage(i, GREY, "You are no longer muted.");
                }
		    }
		    if(PlayerStat[i][BeingDragged] == 1)
		    {
				new Float: PosX, Float: PosY, Float: PosZ;
				if(!IsPlayerConnected(PlayerStat[i][BeingDraggedBy]))
				{
                    PlayerStat[i][BeingDraggedBy] = -1;
                    PlayerStat[i][BeingDragged] = 0;
                    SendClientMessage(i, WHITE, "The player who was dragging you disconnected, ask an admin to unfreeze you.");
                }
                GetPlayerPos(PlayerStat[i][BeingDraggedBy], PosX, PosY, PosZ);
                SetPlayerPos(i, PosX-0.08, PosY-0.08, PosZ);
                SetPlayerVirtualWorld(i, GetPlayerVirtualWorld(PlayerStat[i][BeingDraggedBy]));
			    SetPlayerInterior(i, GetPlayerInterior(PlayerStat[i][BeingDraggedBy]));
		    }
		    if(PlayerStat[i][InIsolatedCell] == 1)
		    {
				PlayerStat[i][InIsolatedCellTime]--;
                if(PlayerStat[i][InIsolatedCellTime] <= 0)
				{
                    PlayerStat[i][InIsolatedCell] = 0;
                    SetPlayerPos(i, 1809.9412,-1547.3850,5700.5);
					SetPlayerFacingAngle(i, 179.0250);
					SetCameraBehindPlayer(i);
					SetPlayerVirtualWorld(i, 0);
					SetPlayerInterior(i, 0);
                    SendClientMessage(i, WHITE, "You are no longer in an Isolated Cell.");
                }
		    }
		    if(PlayerStat[i][AdminPrisoned] == 1)
		    {
				PlayerStat[i][AdminPrisonedTime]--;
                if(PlayerStat[i][AdminPrisonedTime] <= 0)
				{
					PlayerStat[i][AdminPrisoned] = 0;
					SetPlayerPos(i, 431.9070,1562.9177,1001.1500);
					SetPlayerFacingAngle(i, 4);
					SetCameraBehindPlayer(i);
					SetPlayerVirtualWorld(i, 0);
					SetPlayerInterior(i, 0);
					SetTimerEx("FreezeTimer", 2500, false, "i", i);
					SendClientMessage(i, WHITE, "You are no longer Admin Jailed.");
					SendClientMessage(i, WHITE, "Try to be a better person.");
					AjailReason[i][0] = 0;
				}
			}
		}
	}
	return 1;
}

forward TenSecondsUpdate();
public TenSecondsUpdate()
{
    for(new i = 0; i<MAX_PLAYERS; i++)
	{
		if(PlayerStat[i][Logged] == 1 && PlayerStat[i][Spawned] == 1)
		{
			if(PlayerStat[i][BleedingToDeath] >= 1 && PlayerStat[i][Dead] == 1)
			{
				if(PlayerStat[i][BleedingToDeath] <= 1)
				{
					PlayerStat[i][InHospital] = 1;
					PlayerStat[i][Muted] = 50;
					PlayerStat[i][HospitalTime] = 60;
					PlayerStat[i][Dead] = 0;
					ResetWeaponsFully(i);
					new Random = random(sizeof(HospitalSpawns));
					SetPlayerPos(i, HospitalSpawns[Random][0], HospitalSpawns[Random][1], HospitalSpawns[Random][2]);
					SetPlayerCameraPos(i,1144.3436,-1308.6213,1024.00);
					SetPlayerCameraLookAt(i, 1138.2471,-1302.6396,1024.6106);
					SetHealth(i, 1.0);
					SetArmour(i, 0.0);
					PlayerStat[i][Armour] = 0;
					SetPlayerInterior(i, 0);
					SetPlayerVirtualWorld(i, 0);
					TogglePlayerControllable(i, 0);
					SendClientMessage(i, RED, "You have been moved inside the prison clinic.");
					SendClientMessage(i, RED, "You will be released when you have recovered.");
					ApplyAnimation(i, "PED", "FLOOR_hit_f", 4.1, 0, 1, 1, 1, 0, 1);
				}
				PlayerStat[i][BleedingToDeath] -= 10;
				SetHealth(i, PlayerStat[i][Health]-10.0);
			}
			if(PlayerStat[i][UsingPotReloadTime] >= 1)
			{
				PlayerStat[i][UsingPotReloadTime] -= 10;
				if(PlayerStat[i][UsingPotReloadTime] <= 0)
				{
					PlayerStat[i][UsingPotReloadTime] = 0;
				}
			}
			if(PlayerStat[i][InHospital] == 1)
		    {
                if(PlayerStat[i][HospitalTime] <= 1)
				{
					PlayerStat[i][InHospital] = 0;
					PlayerStat[i][HospitalTime] = 1;
  			 		PlayerStat[i][Pot] = 0;
		  			PlayerStat[i][Crack] = 0;
					PlayerStat[i][Muted] = 0;
					SetPlayerPos(i, 431.9070,1562.9177,1001.1500);
					SetPlayerFacingAngle(i, 4);
                    SetTimerEx("LoadingObjects", 4000, false, "d", i);
					SetCameraBehindPlayer(i);
					SetPlayerInterior(i, 0);
					SetPlayerVirtualWorld(i, 0);
					SendClientMessage(i, GREEN, "=====================================================");
					SendClientMessage(i, PINK, "_______________-Saint Mary Clinic Recipt-_______________");
					if(PlayerStat[i][DonLV] >= 3)
					{
						SendClientMessage(i, EMERALD, "Health treatment have been payed by your insurance | You are now fully recoverd.");
					}
					else
					{
						SendClientMessage(i, EMERALD, "Total health treatment: 150$ | You are now fully recoverd.");
						GiveMoney(i, -150);
					}
					SendClientMessage(i, EMERALD, "Your drugs and weapons have been confiscated and passed to the police.");
					SendClientMessage(i, EMERALD, "You have been released after the doctor have examined you as healthy.");
					SendClientMessage(i, GREEN, "=====================================================");

				}
				PlayerStat[i][HospitalTime] -= 10;
				SetHealth(i, PlayerStat[i][Health]+10.0);
			}
			if(PlayerStat[i][UsingCrackReloadTime] >= 1)
			{
				PlayerStat[i][UsingCrackReloadTime] -= 10;
				if(PlayerStat[i][UsingCrackReloadTime] <= 0)
				{
					PlayerStat[i][UsingCrackReloadTime] = 0;
				}
			}
			if(PlayerStat[i][DeathT] >= 1)
			{
			    PlayerStat[i][DeathT] -= 10;
       			if(PlayerStat[i][DeathT] <= 0)
			 	{
					SendClientMessage(i, GREY, "You now able to accept your death.");
					PlayerStat[i][DeathT] = 0;
				}
			}
		    if(PlayerStat[i][GetDrugsReloadTime] >= 1)
		    {
                PlayerStat[i][GetDrugsReloadTime] -= 10;
				if(PlayerStat[i][GetDrugsReloadTime] <= 0)
				{
					PlayerStat[i][GetDrugsReloadTime] = 0;
				}
		    }
		    if(PlayerStat[i][GetWeapReloadTime] >= 1)
		    {
                PlayerStat[i][GetWeapReloadTime] -= 10;
                if(PlayerStat[i][GetWeapReloadTime] <= 0)
				{
					SendClientMessage(i, GREY, "You can get weapons from the secret room again.");
					PlayerStat[i][GetWeapReloadTime] = 0;
				}
		    }
		    if(PlayerStat[i][ReportReloadTime] >= 1)
		    {
                PlayerStat[i][ReportReloadTime] -= 10;
				if(PlayerStat[i][ReportReloadTime] <= 0)
				{
					PlayerStat[i][ReportReloadTime] = 0;
				}
		    }
		    if(PlayerStat[i][HelpmeReloadTime] >= 1)
		    {
                PlayerStat[i][HelpmeReloadTime] -= 10;
				if(PlayerStat[i][HelpmeReloadTime] <= 0)
				{
					PlayerStat[i][HelpmeReloadTime] = 0;
				}
		    }
			if(PlayerStat[i][JRCD] >= 1)
			{
			    PlayerStat[i][JRCD] -= 10;
			}
			 
			if(PlayerStat[i][CSCD] >= 1)
			{
			    PlayerStat[i][CSCD] -= 10;
			}
			 
			if(PlayerStat[i][JSCD] >= 1)
			{
			    PlayerStat[i][JSCD] -= 10;
			}
			if(PlayerStat[i][CUCD] >= 1)
			{
			    PlayerStat[i][CUCD] -= 10;
			}
			if(pSmokeAnim[i] >= 1 && pSmokeAnim[i] <= 10)
			{
				new Random = random(3);
				if(Random == 2)
				{
					ApplyAnimation(i, "SMOKING", "M_smk_tap", 4.1, 0, 0, 0, 0, 3000);
				}
			}
/*			if(PFishing[i] == 1)
			{
				if(PFishingT[i] >= 7)
				{
					new Random = random(10);
					if(Random <= 4)
					{
						PFishingT[i]++;
					}
					if(Random == 5 || Random == 6)
					{
						SendClientMessage(i, GREEN, "Caught fish.");
						PFishingT[i] = 0;
					}
					if(Random >= 7)
					{
						SendClientMessage(i, GREEN, "Caught boot.");
						PFishingT[i] = 0;
					}
				}
				if(PFishingT[i] >= 2 && PFishingT[i] <= 6)
				{
					new Random = random(15);
					if(Random <= 9)
					{
						PFishingT[i]++;
					}
					if(Random == 10 || Random == 11)
					{
						SendClientMessage(i, GREEN, "Caught fish.");
						PFishingT[i] = 0;
					}
					if(Random >= 12)
					{
						SendClientMessage(i, GREEN, "Caught boot.");
						PFishingT[i] = 0;
					}
				}
				else if(PFishingT[i] <= 1)
				{
					PFishingT[i]++;
				}
			}*/
		}
	}
	return 1;
}

forward ActorReStream();
public ActorReStream()
{
	DestroyActor(ACTKitchen1);
	DestroyActor(ACTShop1);
	DestroyActor(ACTShop2);
	DestroyActor(ACTGuard1);
	DestroyActor(ACTGuard2);
	DestroyActor(ACTGym1);
	DestroyActor(ACTBMDealer);
	DestroyActor(ACTBMSmuggler);
	ACTKitchen1 = CreateActor(168, 445.3616, 1629.5665, 1001.0000, 88.4959);
	ACTShop1 = CreateActor(14, 416.2832, 1639.6379, 1001.0000, 178.7367);
	ACTShop2 = CreateActor(214, 243.4666, 1432.8695, 14.5545, 84.3280);
	ACTGuard1 = CreateActor(71, 271.1217, 1411.4755, 10.4565, 90);
	ACTGuard2 = CreateActor(71, 190.2659, 1464.9944, 10.5859, 271.8518);
	ACTGym1 = CreateActor(80, 442.3324, 1544.3494, 1001.0271, 252.9043);
	ACTBMSmuggler = CreateActor(249, 480.9567,1564.3361,996.6711,354.5759);
	ACTBMDealer = CreateActor(304, 444.6044,1645.3818,994.8571,180.3842);
	ApplyActorAnimation(ACTGuard2, "COP_AMBIENT", "Coplook_loop", 4.0, 1, 0, 0, 0, 0);
	ApplyActorAnimation(ACTGuard1, "COP_AMBIENT", "null", 4.0, 1, 0, 0, 0, 0);
	ApplyActorAnimation(ACTKitchen1, "COP_AMBIENT", "null", 4.0, 1, 0, 0, 0, 0);
	ApplyActorAnimation(ACTShop1, "COP_AMBIENT", "null", 4.0, 1, 0, 0, 0, 0);
	ApplyActorAnimation(ACTShop2, "COP_AMBIENT", "null", 4.0, 1, 0, 0, 0, 0);
	ApplyActorAnimation(ACTGym1, "GYMNASIUM", "gym_shadowbox", 4.0, 1, 0, 0, 0, 0);
	ApplyActorAnimation(ACTBMDealer, "DEALER", "DEALER_IDLE_03", 4.0, 1, 0, 0, 0, 0);
	ApplyActorAnimation(ACTBMSmuggler, "DEALER", "DEALER_IDLE", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

forward PlayerPayDay(playerid);
public PlayerPayDay(playerid)
{
	if(PlayerStat[playerid][Logged] == 1 && PlayerStat[playerid][Spawned] == 1 && PlayerAFK[playerid] == 0)
	{
		new Float:cHealth;
		GetPlayerHealth(playerid, cHealth);
		if(PlayerStat[playerid][PlayingMinutes] >= 60)
		{
			new str[128], intr;
			PlayerPlaySound(playerid, 1183, 0, 0, 0);
			SetTimerEx("StopPlayingAllSounds", 6000, false, "i", playerid);
			SendClientMessage(playerid, WHITE, "____________________________________________________________");
			SendClientMessage(playerid, LIGHT_BLUE, "    State of Nevada, Las Venturas | High Desert State Prison ");
			SendClientMessage(playerid, EMERALD, "                                     Pay Check");
			format(str, sizeof(str), "Old balance: %d$.", PlayerStat[playerid][LockerMoney]);
			SendClientMessage(playerid, WHITE, str);
			if(PlayerStat[playerid][Paycheck] == 0)
			{
				PlayerStat[playerid][LockerMoney] += 50;
				SendClientMessage(playerid, LIGHT_GREEN, "Paycheck: 50$.");
				if(PlayerStat[playerid][HasCell] > 1 && PlayerStat[playerid][DonLV] < 1)
				{
					SendClientMessage(playerid, LIGHT_RED, "Cell Tax: -25$.");
					PlayerStat[playerid][LockerMoney] -= 25;
				}
				if(PlayerStat[playerid][AdminLevel] >= 1)
				{
					if(PlayerStat[playerid][AdminLevel] > 3)
					{
						SendClientMessage(playerid, LIGHT_RED, "Senior Administrators Paycheck: 650$");
						PlayerStat[playerid][LockerMoney] += 650;
					}
					else
					{
						SendClientMessage(playerid, LIGHT_RED, "Junior Administrators Paycheck: 350$");
						PlayerStat[playerid][LockerMoney] += 350;
					}
				}
				if(PlayerStat[playerid][HelperLevel] == 1 && PlayerStat[playerid][AdminLevel] == 0)
				{
					SendClientMessage(playerid, LIGHT_RED, "Helpers Paycheck: 150$");
					PlayerStat[playerid][LockerMoney] += 150;
				}
				if(PlayerStat[playerid][DonLV] >= 1) // Interest Rate || VAR - intr
				{
					intr = PlayerStat[playerid][LockerMoney];
					if(PlayerStat[playerid][DonLV] == 1)
					{
						intr *= 1;
						intr /= 500;
						format(str, sizeof(str), "Interest Rate [0.2#]: %d$.", intr);
						SendClientMessage(playerid, GOLD, str);
					}
					if(PlayerStat[playerid][DonLV] == 2)
					{
						intr *= 2;
						intr /= 500;
						format(str, sizeof(str), "Interest Rate [0.4#]: %d$.", intr);
						SendClientMessage(playerid, GOLD, str);
					}
					if(PlayerStat[playerid][DonLV] == 3)
					{
						intr *= 3;
						intr /= 500;
						format(str, sizeof(str), "Interest Rate [0.6#]: %d$.", intr);
						SendClientMessage(playerid, GOLD, str);
					}
					PlayerStat[playerid][LockerMoney] += intr;
				}
				format(str, sizeof(str), "New balance: %d$.", PlayerStat[playerid][LockerMoney]);
				SendClientMessage(playerid, WHITE, str);
				SendClientMessage(playerid, WHITE, "____________________________________________________________");
				PlayerStat[playerid][PlayingHours] += 1;
				PlayerStat[playerid][PlayingMinutes] = 0;
				SetPlayerScore(playerid, PlayerStat[playerid][PlayingHours]);
			}
			else
			{
				format(str, sizeof(str), "Paycheck: %d$.", PlayerStat[playerid][Paycheck]);
				SendClientMessage(playerid, LIGHT_GREEN, str);
				if(PlayerStat[playerid][HasCell] > 1 && PlayerStat[playerid][DonLV] < 1)
				{
					SendClientMessage(playerid, LIGHT_RED, "Cell Tax: -15$.");
					PlayerStat[playerid][LockerMoney] -= 15;
				}
				if(PlayerStat[playerid][AdminLevel] >= 1)
				{
					if(PlayerStat[playerid][AdminLevel] > 3)
					{
						SendClientMessage(playerid, LIGHT_RED, "Senior Administrators Paycheck: 650$");
						PlayerStat[playerid][LockerMoney] += 650;
					}
					else
					{
						SendClientMessage(playerid, LIGHT_RED, "Junior Administrators Paycheck: 350$");
						PlayerStat[playerid][LockerMoney] += 350;
					}
				}
				if(PlayerStat[playerid][HelperLevel] == 1 && PlayerStat[playerid][AdminLevel] == 0)
				{
					SendClientMessage(playerid, LIGHT_RED, "Helpers Paycheck: 150$");
					PlayerStat[playerid][LockerMoney] += 150;
				}
				if(PlayerStat[playerid][DonLV] >= 1) // Interest Rate || VAR - intr
				{
					intr = PlayerStat[playerid][LockerMoney];
					if(PlayerStat[playerid][DonLV] == 1)
					{
						intr *= 1;
						intr /= 500;
						format(str, sizeof(str), "Interest Rate [0.2#]: %d$.", intr);
						SendClientMessage(playerid, GOLD, str);
					}
					if(PlayerStat[playerid][DonLV] == 2)
					{
						intr *= 2;
						intr /= 500;
						format(str, sizeof(str), "Interest Rate [0.4#]: %d$.", intr);
						SendClientMessage(playerid, GOLD, str);
					}
					if(PlayerStat[playerid][DonLV] == 3)
					{
						intr *= 3;
						intr /= 500;
						format(str, sizeof(str), "Interest Rate [0.6#]: %d$.", intr);
						SendClientMessage(playerid, GOLD, str);
					}
					PlayerStat[playerid][LockerMoney] += intr;
				}
				PlayerStat[playerid][LockerMoney] += PlayerStat[playerid][Paycheck];
				format(str, sizeof(str), "New balance: %d$.", PlayerStat[playerid][LockerMoney]);
				SendClientMessage(playerid, WHITE, str);
				SendClientMessage(playerid, WHITE, "____________________________________________________________");
				PlayerStat[playerid][PlayingHours] += 1;
				SetPlayerScore(playerid, PlayerStat[playerid][PlayingHours]);
				PlayerStat[playerid][PlayingMinutes] = 0;
				PlayerStat[playerid][Paycheck] = 0;
				if(PlayerStat[playerid][JobID] >= 1)
				{
					PlayerStat[playerid][HoursInJob]++;
				}
			}
		}
		else
		{
			SetPlayerHealth(playerid, cHealth -1.0);
			PlayerStat[playerid][PlayingMinutes]++;
			PlayerPlaySound(playerid, -1, 0, 0, 0);
		}
	}
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_REGISTER)
    {
        if(!response)
        {
            SendClientMessage(playerid, GREY, "You didn't register.");
		    Kick(playerid);
		}
        else if(response)
        {
            if(!strlen(inputtext))
            {
				SendClientMessage(playerid, GREY, "You can't have an empty password.");
				ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "Registering","You have entered an invalid password.\nPlease input a password below to register an account.","Register","Quit");
			}
			else if(strlen(inputtext) < 3)
			{
                SendClientMessage(playerid, GREY, "Your password mustn't be under 3 characters.");
                ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "Registering","You have entered an invalid password.\nPlease input a password below to register an account.","Register","Quit");
			}
			else if(strlen(inputtext) > 20)
			{
                SendClientMessage(playerid, GREY, "Your password mustn't be more than 20 characters.");
                ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "Registering","You have entered an invalid password.\nPlease input a password below to register an account.","Register","Quit");
			}
            else if(INI_Open(Accounts(playerid)))
			{
				new str[128];
				INI_WriteString("Password", inputtext);
				INI_Save();
				INI_Close();
                SendClientMessage(playerid, GREY, "You have successfully created an account and auto logged in.");
                format(str, sizeof(str), "%s", PlayerStat[playerid][Password]);
                NewPlayerData(playerid);
				PlayerStat[playerid][Logged] = 1;
				TogglePlayerControllable(playerid, false);
				SetPlayerInterior(playerid, 0);
                SetPlayerVirtualWorld(playerid, playerid+0);
				SetPlayerTime(playerid, 7, 0);
				PNewReg[playerid] = 1;
				NewRegQuestion[playerid] = 1;
	            ShowPlayerDialog(playerid, DIALOG_GENDER, DIALOG_STYLE_LIST, "Are you a male or a female?","Male\nFemale","Next","Quit");
            }
        }
    }
    if(dialogid == DIALOG_NEWPW)
    {
        if(!response) return 1;
        else if(response)
        {
            if(!strlen(inputtext))
            {
				SendClientMessage(playerid, GREY, "You can't have an empty password.");
				ShowPlayerDialog(playerid, DIALOG_NEWPW, DIALOG_STYLE_INPUT, "New Password", "Please input your new password below.", "Change", "Cancel");
			}
			else if(strlen(inputtext) < 3)
			{
                SendClientMessage(playerid, GREY, "Your new password mustn't be under 3 characters.");
                ShowPlayerDialog(playerid, DIALOG_NEWPW, DIALOG_STYLE_INPUT, "New Password", "Please input your new password below.", "Change", "Cancel");
			}
			else if(strlen(inputtext) > 20)
			{
                SendClientMessage(playerid, GREY, "Your new password mustn't be more than 20 characters.");
                ShowPlayerDialog(playerid, DIALOG_NEWPW, DIALOG_STYLE_INPUT, "New Password", "Please input your new password below.", "Change", "Cancel");
			}
            else if(INI_Open(Accounts(playerid)))
			{
				new str[128];
				INI_WriteString("Password", inputtext);
				INI_Save();
				INI_Close();
		        format(str, sizeof(str), "You have successfully changed your password to %s.",inputtext);
                SendClientMessage(playerid, GREY, str);
            }
        }
    }
    if(dialogid == 5353){
    //The player has pressed "OK"(because it's de only avaliable button.)
    }
    if(dialogid == DIALOG_ACCENT)
    {
        if(!response) return 1;
        else if(response)
        {
            if(!strlen(inputtext))
            {
				SendClientMessage(playerid, GREY, "You must enter an accent");
				ShowPlayerDialog(playerid, DIALOG_ACCENT, DIALOG_STYLE_INPUT, "Accent", "Please input your new accent below.", "Change", "Cancel");
			}
			else if(strlen(inputtext) < 5)
			{
                SendClientMessage(playerid, GREY, "Your new accent mustn't be under 5 characters.");
                ShowPlayerDialog(playerid, DIALOG_ACCENT, DIALOG_STYLE_INPUT, "Accent", "Please input your new accent below.", "Change", "Cancel");
			}
			else if(strlen(inputtext) > 15)
			{
                SendClientMessage(playerid, GREY, "Your new accent mustn't be more than 15 characters.");
                ShowPlayerDialog(playerid, DIALOG_ACCENT, DIALOG_STYLE_INPUT, "Accent", "Please input your new accent below.", "Change", "Cancel");
			}
            else if(INI_Open(Accounts(playerid)))
			{
				new str[128];
				INI_WriteString("Accent", inputtext);
				INI_Save();
				INI_Close();
				format(PlayerStat[playerid][Accent], 128, "%s", inputtext);
		        format(str, sizeof(str), "You have successfully changed your accent to %s.",inputtext);
                SendClientMessage(playerid, GREY, str);
            }
        }
    }
    /*if(dialogid == DIALOG_QUIZ1)
    {
        if(!response)
        {
            SendClientMessage(playerid, GREY, "You must answer the quiz.");
		    Kick(playerid);
		}
        else if(response)
        {
            if(!strlen(inputtext))
            {
				SendClientMessage(playerid, GREY, "Please input the answer below.");
				ShowPlayerDialog(playerid, DIALOG_QUIZ1, DIALOG_STYLE_INPUT, "First question.","What is DM?","Next","Quit");
			}
			else if(!strcmp(inputtext, "Deathmatch", true) || !strcmp(inputtext, "Death match", true) || !strcmp(inputtext, "Death matching", true) || !strcmp(inputtext, "Deathmatching", true))
			{
                SendClientMessage(playerid, GREY, "Correct answer!");
                ShowPlayerDialog(playerid, DIALOG_QUIZ2, DIALOG_STYLE_INPUT, "Roleplay Quiz 2","What is MG?","Next","Quit");
			}
            else
			{
				SendClientMessage(playerid, GREY, "Incorrect answer, kicked.");
				Kick(playerid);
            }
        }
    }
    if(dialogid == DIALOG_QUIZ2)
    {
        if(!response)
        {
            SendClientMessage(playerid, GREY, "You must answer the quiz.");
		    Kick(playerid);
		}
        else if(response)
        {
            if(!strlen(inputtext))
            {
				SendClientMessage(playerid, GREY, "Please input the answer below.");
				ShowPlayerDialog(playerid, DIALOG_QUIZ2, DIALOG_STYLE_INPUT, "Second Question.","What is MG?","Next","Quit");
			}
			else if(!strcmp(inputtext, "Metagame", true) || !strcmp(inputtext, "Meta game", true) || !strcmp(inputtext, "Meta Gaming", true) || !strcmp(inputtext, "Metagaming", true))
			{
                SendClientMessage(playerid, GREY, "Correct answer!");
                ShowPlayerDialog(playerid, DIALOG_QUIZ3, DIALOG_STYLE_INPUT, "Third question.","What is PG?","Next","Quit");
			}
            else
			{
				SendClientMessage(playerid, GREY, "Incorrect answer, kicked.");
				Kick(playerid);
            }
        }
    }
    if(dialogid == DIALOG_QUIZ3)
    {
        if(!response)
        {
            SendClientMessage(playerid, GREY, "You must answer the quiz.");
		    Kick(playerid);
		}
        else if(response)
        {
            if(!strlen(inputtext))
            {
				SendClientMessage(playerid, GREY, "Please input the answer below.");
				ShowPlayerDialog(playerid, DIALOG_QUIZ3, DIALOG_STYLE_INPUT, "Question 3","What is PG?","Next","Quit");
			}
			else if(!strcmp(inputtext, "Powergame", true) || !strcmp(inputtext, "Power Game", true) || !strcmp(inputtext, "Power gaming", true) || !strcmp(inputtext, "Powergaming", true))
			{
                SendClientMessage(playerid, GREY, "Correct answer!");
                ShowPlayerDialog(playerid, DIALOG_QUIZ4, DIALOG_STYLE_INPUT, "Question 4","What is IC?","Next","Quit");
			}
            else
			{
				SendClientMessage(playerid, GREY, "Incorrect answer, kicked.");
				Kick(playerid);
            }
        }
    }
    if(dialogid == DIALOG_QUIZ4)
    {
        if(!response)
        {
            SendClientMessage(playerid, GREY, "You must answer the quiz.");
		    Kick(playerid);
		}
        else if(response)
        {
            if(!strlen(inputtext))
            {
				SendClientMessage(playerid, GREY, "Please input the answer below.");
				ShowPlayerDialog(playerid, DIALOG_QUIZ4, DIALOG_STYLE_INPUT, "Fourth question.","What is IC?","Next","Quit");
			}
			else if(!strcmp(inputtext, "In Character", true))
			{
                SendClientMessage(playerid, GREY, "Correct answer!");
                ShowPlayerDialog(playerid, DIALOG_QUIZ5, DIALOG_STYLE_INPUT, "Fifth question.","What is OOC?","Next","Quit");
			}
            else
			{
				SendClientMessage(playerid, GREY, "Incorrect answer, kicked.");
				Kick(playerid);
            }
        }
    }
    if(dialogid == DIALOG_QUIZ5)
    {
        if(!response)
        {
            SendClientMessage(playerid, GREY, "You must answer the quiz.");
		    Kick(playerid);
		}
        else if(response)
        {
            if(!strlen(inputtext))
            {
				SendClientMessage(playerid, GREY, "Please input the answer below.");
				ShowPlayerDialog(playerid, DIALOG_QUIZ5, DIALOG_STYLE_INPUT, "Fifth question.","What is OOC?","Next","Quit");
			}
			else if(!strcmp(inputtext, "Out Of Character", true))
			{
                SendClientMessage(playerid, GREY, "Correct answer!");
                ShowPlayerDialog(playerid, DIALOG_QUIZ6, DIALOG_STYLE_INPUT, "Sixth question.","What is RK?","Next","Quit");
			}
            else
			{
				SendClientMessage(playerid, GREY, "Incorrect answer, kicked.");
				Kick(playerid);
            }
        }
    }
    if(dialogid == DIALOG_QUIZ6)
    {
        if(!response)
        {
            SendClientMessage(playerid, GREY, "You must answer the quiz.");
		    Kick(playerid);
		}
        else if(response)
        {
            if(!strlen(inputtext))
            {
				SendClientMessage(playerid, GREY, "Please input the answer below.");
				ShowPlayerDialog(playerid, DIALOG_QUIZ6, DIALOG_STYLE_INPUT, "Sixth question.","What is PG?","Next","Quit");
			}
			else if(!strcmp(inputtext, "Revenge Kill", true) || !strcmp(inputtext, "Revenge Killing", true))
			{
                SendClientMessage(playerid, GREY, "Correct answer!");
                ShowPlayerDialog(playerid, DIALOG_QUIZ7, DIALOG_STYLE_INPUT, "Seventh question.","What is CK?","Next","Quit");
			}
            else
			{
				SendClientMessage(playerid, GREY, "Incorrect answer, kicked.");
				Kick(playerid);
            }
        }
    }
    if(dialogid == DIALOG_QUIZ7)
    {
        if(!response)
        {
            SendClientMessage(playerid, GREY, "You must answer the quiz.");
		    Kick(playerid);
		}
        else if(response)
        {
            if(!strlen(inputtext))
            {
				SendClientMessage(playerid, GREY, "Please input the answer below.");
				ShowPlayerDialog(playerid, DIALOG_QUIZ7, DIALOG_STYLE_INPUT, "Seventh question.","What is CK?","Next","Quit");
			}
			else if(!strcmp(inputtext, "Character Kill", true) || !strcmp(inputtext, "Character Killing", true))
			{
                SendClientMessage(playerid, GREY, "Correct answer! Now specify your gender.");
                ShowPlayerDialog(playerid, DIALOG_GENDER, DIALOG_STYLE_LIST, "Are you a male or a female?","Male\n","Next","Quit");
			}
            else
			{
				SendClientMessage(playerid, GREY, "Incorrect answer, kicked.");
				Kick(playerid);
            }
        }
    }*/
    if(dialogid == DIALOG_GENDER)
    {
        if(!response)
        {
            SendClientMessage(playerid, GREY, "Please select 'Male' or 'Female' ");
            ShowPlayerDialog(playerid, DIALOG_GENDER, DIALOG_STYLE_LIST, "Are you a male or a female?","Male\nFemale","Next","Quit");
		}
        else if(response)
        {
            switch(listitem)
        	{
        	    case 0:
        	    {
					INI_Open(Accounts(playerid));
					INI_WriteInt("Gender", 1);
					INI_WriteInt("LastSkin", 50);
					INI_Save();
					INI_Close();
        	        PlayerStat[playerid][Gender] = 1;
        	        PlayerStat[playerid][LastSkin] = 50;
					SendClientMessage(playerid, GREY, "So, you are a male.");
        	        ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "How old are you?", "Input your age below.", "Next", "Quit");
        	        PlayerStat[playerid][Gender] = 1;
        	    }
        	    case 1:
        	    {
					INI_Open(Accounts(playerid));
					INI_WriteInt("Gender", 0);
					INI_WriteInt("LastSkin", 191);
					INI_Save();
					INI_Close();
        	        PlayerStat[playerid][LastSkin] = 191;
					PlayerStat[playerid][Gender] = 0;
					SendClientMessage(playerid, GREY, "So, you are a female.");
        	        ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "How old are you?", "Input your age below.", "Next", "Quit");
        	    }
        	}
        }
    }
    if(dialogid == DIALOG_AGE)
    {
        if(!response)
        {
            SendClientMessage(playerid, GREY, "You need to type your age and press on 'Next'");
            ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "How old are you?", "Input your age below.", "Next", "Quit");
		}
        else if(response)
		{
            if(!strlen(inputtext))
            {
				SendClientMessage(playerid, GREY, "You must enter your age below.");
				ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "How old are you?", "Input your age below.", "Next", "Quit");
			}
			else if(strval(inputtext) < 18)
			{
                SendClientMessage(playerid, GREY, "Your age musn't be under 18.");
                ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "How old are you?", "Input your age below.", "Next", "Quit");
			}
			else if(strval(inputtext) > 70)
			{
                SendClientMessage(playerid, GREY, "Your age mustn't be over 70.");
                ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "How old are you?", "Input your age below.", "Next", "Quit");
			}
            else if(INI_Open(Accounts(playerid)))
			{
                new str[128];
                INI_WriteInt("Age", strval(inputtext));
                INI_Save();
                INI_Close();
		        PlayerStat[playerid][Age] = strval(inputtext);
		        format(str, sizeof(str), "And you are %d. Why are you in prison?", PlayerStat[playerid][Age]);
		        SendClientMessage(playerid, GREY, str);
		        ShowPlayerDialog(playerid, DIALOG_REASONS, DIALOG_STYLE_INPUT, "Why were you imprisoned?", "Type the reason below and press on Done.", "Done", "Quit");
            }
        }
    }
    if(dialogid == DIALOG_REASONS)
    {
        if(!response)
        {
            SendClientMessage(playerid, GREY, "You need to select one of these reasons 'Done'.");
            ShowPlayerDialog(playerid, DIALOG_REASONS, DIALOG_STYLE_INPUT, "Why were you imprisoned?", "Type the reason below and press on Done.", "Done", "Quit");
		}
		else if(response)
		{
            if(!strlen(inputtext))
            {
				SendClientMessage(playerid, GREY, "You must enter the reason below.");
				ShowPlayerDialog(playerid, DIALOG_REASONS, DIALOG_STYLE_INPUT, "Why were you imprisoned?", "Type the reason below and press on Done.", "Done", "Quit");
			}
			else if(strlen(inputtext) < 4)
			{
                SendClientMessage(playerid, GREY, "The reason can't be under 4 characters.");
                ShowPlayerDialog(playerid, DIALOG_REASONS, DIALOG_STYLE_INPUT, "Why were you imprisoned?", "Type the reason below and press on Done.", "Done", "Quit");
			}
			else if(strlen(inputtext) > 20)
			{
                SendClientMessage(playerid, GREY, "The reason can't be more than 20 characters.");
                ShowPlayerDialog(playerid, DIALOG_REASONS, DIALOG_STYLE_INPUT, "Why were you imprisoned?", "Type the reason below and press on Done.", "Done", "Quit");
			}
            else if(INI_Open(Accounts(playerid)))
			{
                INI_WriteString("Reason", inputtext); 
				INI_Save();
				INI_Close();
				PNewReg[playerid] = 1;
				NewRegQuestion[playerid] = 1;
				LoadPlayerData(playerid);
				SetPlayerColor(playerid, PURPLE);
            }
        }
    }
    if(dialogid == DIALOG_LOGIN)
    {
        if(!response)
        {
            SendClientMessage(playerid, GREY, "You didn't log in.");
		    Kick(playerid);
		}
        if(response)
        {
            if(!strlen(inputtext))
            {
			   SendClientMessage(playerid, GREY, "You have been kicked for not entering the correct password.");
			   Kick(playerid);
            }
            if(INI_Open(Accounts(playerid)))
		    {
                INI_ReadString(PlayerStat[playerid][Password],"Password",20);
		        if(strcmp(inputtext,PlayerStat[playerid][Password],false))
				{
				   if(PlayerStat[playerid][WrongPw] == 1)
				   {
                       SendClientMessage(playerid, GREY, "You have been kicked for not entering the correct password.");
				       Kick(playerid);
				   }
				   else
				   {
//					   ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, "Log In","You have entered an incorrect password.\nPlease input this account password to log in.","Login","Quit");
                       SendClientMessage(playerid, GREY, "You have been kicked for typing the wrong password.");
					   Kick(playerid);
				   }
                }
                else
				{

				    new str[128];
//				    format(str, sizeof(str), "Welcome Back %s, your last login was on %d/%d/%d at %d:%d:%d.", GetOOCName(playerid), PlayerStat[playerid][LastLoginYear], PlayerStat[playerid][LastLoginMonth], PlayerStat[playerid][LastLoginDay], PlayerStat[playerid][LastLoginHour], PlayerStat[playerid][LastLoginMinute], PlayerStat[playerid][LastLoginSecond]);
					SendClientMessage(playerid, GREEN, str);
				    format(str, sizeof(str), "~w~Welcome Back ~n~~y~ %s", GetOOCName(playerid));
	                GameTextForPlayer(playerid, str, 3000, 1);
				    SendClientMessage(playerid, GREEN, SERVER_MOTD);
					PlayerStat[playerid][BPNMB] = 0;
					PlayerStat[playerid][AdminLogged] = 0;
					PlayerPayDayT[playerid] = SetTimerEx("PlayerPayDay", 60000, true, "i", playerid);
                    if(PlayerStat[playerid][GangID] >= 1)
					{
                        format(str, sizeof(str), "Gang MOTD: %s", GangStat[PlayerStat[playerid][GangID]][MOTD]);
				        SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
				    }
				    PlayerStat[playerid][Logged] = 1;
				    LoadPlayerData(playerid);
				    INI_Save();
                    INI_Close();

				}
            }
        }
	}
	if(dialogid == DIALOG_EXAM1T1)
	{
		if(!response) return 1;
		else if(response)
		{
			ShowPlayerDialog(playerid, DIALOG_EXAM1T2, DIALOG_STYLE_MSGBOX, "Metal Working Book", "Marking out (also known as layout) is the process of transferring a design or pattern to a workpiece and is the first step in the handcraft of metalworking.\nMost calipers have two sets of flat, parallel edges used for inner or outer diameter measurements.\nThese calipers can be accurate to within one-thousandth of an inch (25.4 mic-m).", "NEXT", "OK");
		}
	}
	if(dialogid == DIALOG_EXAM1T2)
	{
		if(!response) return 1;
		else if(response)
		{
			ShowPlayerDialog(playerid, DIALOG_EXAM1T3, DIALOG_STYLE_MSGBOX, "Metal Working Book", "Different types of calipers have different mechanisms for displaying the distance measured.\nCutting is a collection of processes wherein material is brought to a specified geometry by removing\n excess material using various kinds of tooling to leave a finished part that meets specifications.\nThe net result of cutting is two products, the waste or excess material, and the finished part.", "OK", "OK");
		}
	}
	if(dialogid == DIALOG_EXAM1T3)
	{
		if(!response) return 1;
		else if(response)
		{
			return 1;
		}
	}
    if(dialogid == DIALOG_HELP)
    {
        if(!response) return 1;
        else if(response)
        {
            switch(listitem)
        	{
				case 0:
				{
                    ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "General Commands", "/changepw, /me, /do, /o{ooc}, /b, /low, /w{hisper}, /s{shout}\n/time, /pm, /togooc, /togpm, /helpme, /report, /accent, /stats, \n/pay, /kill, /give, /showprisonid, /job, /accept, I/buycellI, \n/locker, /dtop, /helpers, /admins, /warnings.", "O", "K");
				}
				case 1:
				{
                    if(PlayerStat[playerid][GangID] <= 0) return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Gang Commands", "You are not a member of a gang.", "O", "K");
                    else
                    {
                        if(PlayerStat[playerid][GangRank] >= 5) return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Gang Commands", "Leaders Commands: /adjustgang, /setrank, /ginvite, /gkick.\nMembers Commands: /g, /gclothes, /gmembers, /getweap, /getdrugs, /gquit.", "O", "K");
                        else return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Gang Commands", "Members Commands: /g, /gclothes, /gmembers, /getweap, /getdrugs, /gquit.", "O", "K");
                    }
				}
				case 2:
				{
                    if(PlayerStat[playerid][FactionID] == 0) return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, " ", "You are not a member of a faction.", "O", "K");
                    else if(PlayerStat[playerid][FactionID] == 1)
                    {
                        if(PlayerStat[playerid][FactionRank] >= 5) return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Factions Commands", "Leaders Commands: /invite, /setrank, /uninvite." "/uncuff, /ann. \n /securitycamera, /drag, /stopdrag, /take, /quitfaction. \n " "/r, /members, /flocker, /shocker, /frisk, /cuff, /uncuff, /ann.\n /drag, /stopdrag, /take, /quitfaction, /door (The doors to cell area).", "Next", "");
                    }
                    else if(PlayerStat[playerid][FactionID] == 2)
                    {
                        if(PlayerStat[playerid][FactionRank] >= 5) return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Faction Commands", "Leaders Commands: /invite, /giverank, /uninvite.\nMembers Commands: /r, /members, /flocker, /heal, /drag, /stopdrag, /quitfaction.", "O", "K");
                        else return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Faction Commands", "Members Commands: /r, /members, /flocker, /heal, /stretcher, /putonstretcher, /takeoffstretcher, /quitfaction.", "O", "K");
                    }
				}
				case 3:
				{
                    if(PlayerStat[playerid][HasCell] == 1) return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Cells Commands", "/buycell, /sellcell, /lockcell, /buycelllevel, /celldeposit, /cellwithdraw, /storeweapon, /takeweapon.", "O", "K");
                    else return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Cells Commands", "You don't own a cell", "O", "K");
				}
				case 4:
				{
					if(PlayerStat[playerid][JobID] == 0) return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Job Commands", "You don't have a job.", "O", "K");
                    if(PlayerStat[playerid][JobID] == 1) return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Job Commands", "Garbage Man: /job, /stopwork, /pickgarbage.", "O", "K");
                    if(PlayerStat[playerid][JobID] == 2) return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Job Commands", "Table Cleaner: /job, /stopwork, /cleantables.", "O", "K");
                    if(PlayerStat[playerid][JobID] == 3) return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Job Commands", "Food Supplier: /job, /stopwork, /collectfood.", "O", "K");
				}
				case 5:
				{
                    ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Animations", "/handsup, /hide, /aim, /lookout, /bomb, /laugh\n/pedmove, /gsign, /sit, /lay, /vomit, /eat, /crossarms\n/wave, /taichi, /deal, /crack, /smoke, /f**ku, /dance\n/rap, /shakehand, /piss.", "O", "K");
				}
				case 6:
				{
					if(PlayerStat[playerid][AdminLevel] >= 1) return ShowPlayerDialog(playerid, DIALOG_ADMINCMDS, DIALOG_STYLE_LIST, "Choose an admin level", "Level 1 Admin\nLevel 2 Admin\nLevel 3 Admin\nLevel 4 Admin\nLevel 5 Admin", "Select", "Quit");
					else return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Admin Commands", "You are not an admin.", "O", "K");
				}
				case 7:
				{
                   if(PlayerStat[playerid][HelperLevel] >= 1) return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Helper Commands", "/hc, /fixplayer, /hmute, /hm.", "O", "K");
                   else return ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Helper Commands", "You are not a helper.", "O", "K");
				}
        	}
        }
    }

    if(dialogid == DIALOG_LOCKER)
    {
        if(!response) return 1;
        else if(response)
        {
            switch(listitem)
        	{
				case 0:
				{
					new str[128];
					format(str, sizeof(str), "Your current Prison Locker Balance is: $%d.",PlayerStat[playerid][LockerMoney]);
					ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Locker Balance", str, "OK", "");
					format(str, sizeof(str), "* %s opens the locker and checks their balance.", GetICName(playerid));
                    SendNearByMessage(playerid, ACTION_COLOR, str, 5);
				}
				case 1:
				{
                    ShowPlayerDialog(playerid, DIALOG_WITHDRAW, DIALOG_STYLE_INPUT, "Locker withdraw", "Please input the amount of money you wish to withdraw.", "Withdraw", "Quit");
				}
				case 2:
				{
                    ShowPlayerDialog(playerid, DIALOG_DEPOSIT, DIALOG_STYLE_INPUT, "Locker deposit", "Please input the amount of money you wish to deposit.", "Deposit", "Quit");
				}
			}
        }
    }
	if(dialogid ==DIALOG_TICKET)
	{
		if(!response)return 1;
		if(response) // Ticket Worked PlayerPlaySound(playerid, 4201, 0, 0, 0);
		{
			if(!strcmp(inputtext, "zz4nfl112nr1", true))
			{
				new value[10];
				new File:lFile = fopen("Server/code1.txt", io_read);
				if(lFile)
				{
					while(fread(lFile, value))
					fclose(lFile);
					goto found1;
				}
				else
				{
					SendClientMessage(playerid, GREY, "You have entered an invalid ticket code.");
					return 1;
				}
				found1:
				PlayerPlaySound(playerid, 4201, 0, 0, 0);
				fremove("Server/code1.txt");
				INI_Open(Accounts(playerid));
				INI_WriteInt("DonLV", 3);
				INI_Save();
				INI_Close();
				PlayerStat[playerid][DonLV] = 3;
				PlayerStat[playerid][LockerMoney] += 2500;
				SendClientMessage(playerid, LIGHT_GREEN, "_______________________________________________________________________");
				SendClientMessage(playerid, PINK, "You have used the code and you have got the following items:");
				SendClientMessage(playerid, WHITE, "Donator level 3.");
				SendClientMessage(playerid, WHITE, "Money (inside the locker): 2500$.");
				SendClientMessage(playerid, WHITE, "For safely reasons, we advise you to relog.");
				SendClientMessage(playerid, LIGHT_GREEN, "_______________________________________________________________________");
				return 1;
			}
			if(!strcmp(inputtext, "8ne5elbt547i", true))
			{
				new value[10];
				new File:lFile = fopen("Server/code2.txt", io_read);
				if(lFile)
				{
					while(fread(lFile, value))
					fclose(lFile);
					goto found2;
				}
				else
				{
					SendClientMessage(playerid, GREY, "You have entered an invalid ticket code.");
					return 1;
				}
				found2:
				PlayerPlaySound(playerid, 4201, 0, 0, 0);
				fremove("Server/code2.txt");
				INI_Open(Accounts(playerid));
				INI_WriteInt("DonLV", 2);
				INI_Save();
				INI_Close();
				PlayerStat[playerid][DonLV] = 2;
				PlayerStat[playerid][LockerMoney] += 5000;
				SendClientMessage(playerid, LIGHT_GREEN, "_______________________________________________________________________");
				SendClientMessage(playerid, PINK, "You have used the code and you have got the following items:");
				SendClientMessage(playerid, WHITE, "Donator level 2.");
				SendClientMessage(playerid, WHITE, "Money (inside the locker): 5000$.");
				SendClientMessage(playerid, WHITE, "For safely reasons, we advise you to relog.");
				SendClientMessage(playerid, LIGHT_GREEN, "_______________________________________________________________________");
				return 1;
			}
			if(!strcmp(inputtext, "suup974qxiz", true))
			{
				new value[10];
				new File:lFile = fopen("Server/code3.txt", io_read);
				if(lFile)
				{
					while(fread(lFile, value))
					fclose(lFile);
					goto found3;
				}
				else
				{
					SendClientMessage(playerid, GREY, "You have entered an invalid ticket code.");
					return 1;
				}
				found3:
				PlayerPlaySound(playerid, 4201, 0, 0, 0);
				fremove("Server/code3.txt");
				INI_Open(Accounts(playerid));
				INI_WriteInt("DonLV", 1);
				INI_Save();
				INI_Close();
				PlayerStat[playerid][DonLV] = 1;
				PlayerStat[playerid][LockerMoney] += 7500;
				SendClientMessage(playerid, LIGHT_GREEN, "_______________________________________________________________________");
				SendClientMessage(playerid, PINK, "You have used the code and you have got the following items:");
				SendClientMessage(playerid, WHITE, "Donator level 1.");
				SendClientMessage(playerid, WHITE, "Money (inside the locker): 7500$.");
				SendClientMessage(playerid, WHITE, "For safely reasons, we advise you to relog.");
				SendClientMessage(playerid, LIGHT_GREEN, "_______________________________________________________________________");
				return 1;
			}
			if(!strcmp(inputtext, "shmu7daeqa", true))
			{
				new value[10];
				new File:lFile = fopen("Server/code4.txt", io_read);
				if(lFile)
				{
					while(fread(lFile, value))
					fclose(lFile);
					goto found4;
				}
				else
				{
					SendClientMessage(playerid, GREY, "You have entered an invalid ticket code.");
					return 1;
				}
				found4:
				PlayerPlaySound(playerid, 4201, 0, 0, 0);
				fremove("Server/code4.txt");
				PlayerStat[playerid][LockerMoney] += 2500;
				SendClientMessage(playerid, LIGHT_GREEN, "_______________________________________________________________________");
				SendClientMessage(playerid, PINK, "You have used the code and you have got the following items:");
				SendClientMessage(playerid, WHITE, "Money (inside the locker): 2500$.");
				SendClientMessage(playerid, WHITE, "For safely reasons, we advise you to relog.");
				SendClientMessage(playerid, LIGHT_GREEN, "_______________________________________________________________________");
				return 1;
			}
			else
			{
				SendClientMessage(playerid, GREY, "You have entered an invalid ticket code.");
			}
		}
	}
    if(dialogid == DIALOG_WITHDRAW)
    {
        if(!response) return 1;
        if(response)
        {
            if(!strval(inputtext))
            {
                SendClientMessage(playerid, GREY, "You have entered an invalid amount of money.");
            }
            else
		    {
		        if(PlayerStat[playerid][LockerMoney] >= strval(inputtext))
				{
					   new str[128];
					   format(str, sizeof(str), "You have successfully withdrawed %d from your locker.", strval(inputtext));
                       SendClientMessage(playerid, GREY, str);
                       PlayerStat[playerid][LockerMoney] -= strval(inputtext);
                       GiveMoney(playerid, strval(inputtext));
                       format(str, sizeof(str), "* %s opens their locker and takes some cash out of it.", GetICName(playerid), strval(inputtext));
                       SendNearByMessage(playerid, ACTION_COLOR, str, 5);
                }
                else
				{
				    SendClientMessage(playerid, GREY, "You don't have that much in your locker.");
				}
            }
        }
	}
	if(dialogid == DIALOG_DEPOSIT)
    {
        if(!response) return 1;
        if(response)
        {
            if(!strval(inputtext))
            {
                SendClientMessage(playerid, GREY, "You have entered an Invalid amount of money.");
            }
            else
		    {
		        if(PlayerStat[playerid][Money] >= strval(inputtext))
				{
					   new str[128];
					   format(str, sizeof(str), "You have successfully deposit %d in your locker.", strval(inputtext));
                       SendClientMessage(playerid, GREY, str);
                       PlayerStat[playerid][LockerMoney] += strval(inputtext);
                       GiveMoney(playerid, -strval(inputtext));
                       format(str, sizeof(str), "* %s opens their locker and puts some cash in it.", GetICName(playerid), strval(inputtext));
                       SendNearByMessage(playerid, ACTION_COLOR, str, 5);
                }
                else
				{
				    SendClientMessage(playerid, GREY, "You don't have that much.");
				}
            }
        }
	}
	if(dialogid == DIALOG_CLOTHES1)
    {
        if(!response) return 1;
        if(response)
        {
            if(!strval(inputtext))
            {
                SendClientMessage(playerid, GREY, "You have entered an Invalid Skin ID.");
            }
            else if(strval(inputtext))
		    {
		        if(0 < strval(inputtext) < 299)
				{
					if(strval(inputtext) == 70 || strval(inputtext) == 71 ||  strval(inputtext) == 280) return SendClientMessage(playerid, GREY, "This Skin ID is only used by Prison Guards/Doctors.");
					if(strval(inputtext) == 281 ||  strval(inputtext) == 282 ||  strval(inputtext) == 288) return SendClientMessage(playerid, GREY, "This Skin ID is only used by Prison Guards/Doctors.");
					if(strval(inputtext) == 283 || strval(inputtext) == 284 || strval(inputtext) == 285) return SendClientMessage(playerid, GREY, "This Skin ID is only used by Prison Guards/Doctors.");
		 			if(strval(inputtext) == 286 || strval(inputtext) == 287  || strval(inputtext) == 288) return SendClientMessage(playerid, GREY, "This Skin ID is only used by Prison Guards/Doctors.");
					if(strval(inputtext) == 295   ||  strval(inputtext) == 274 ||  strval(inputtext) == 275 ||  strval(inputtext) == 276 ||  strval(inputtext) == 277 ||  strval(inputtext) == 278 ||  strval(inputtext) == 279) return SendClientMessage(playerid, GREY, "This Skin ID is only used by Pirson Guards/Doctors.");
					if(strval(inputtext) == 284 || strval(inputtext) == 260 || strval(inputtext) == 257 || strval(inputtext) == 209 || strval(inputtext) == 205 || strval(inputtext) == 204 || strval(inputtext) == 203) return SendClientMessage(playerid, GREY, "This clothing is forbidden in prison by the prison rules.");
					if(strval(inputtext) == 178 || strval(inputtext) == 167 || strval(inputtext) == 155 || strval(inputtext) == 149 || strval(inputtext) == 145 || strval(inputtext) == 140 || strval(inputtext) == 139) return SendClientMessage(playerid, GREY, "This clothing is forbidden in prison by the prison rules.");
					if(strval(inputtext) == 138 || strval(inputtext) == 99 || strval(inputtext) == 92 || strval(inputtext) == 87 || strval(inputtext) == 81 || strval(inputtext) == 80 || strval(inputtext) == 63 || strval(inputtext) == 27) return SendClientMessage(playerid, GREY, "This clothing is forbidden in prison by the prison rules.");
     				SetSkin(playerid, strval(inputtext));
					SendClientMessage(playerid, WHITE, "Write /mouse if your cursor disappeared.");
					SetTimerEx("ClothesPlayerAnimations", 3100, false, "i", playerid);
					TogglePlayerControllable(playerid, false);
					SetPlayerFacingAngle(playerid, 180);
					ApplyAnimation(playerid, "CLOTHES", "CLO_Pose_Torso", 4.0, 0, 0, 0, 0, 0);
					SelectTextDraw(playerid, 0xA3B4C5FF);
					PlayerTextDrawShow(playerid, ClothesShop1[playerid]);
					PlayerTextDrawShow(playerid, ClothesShop2[playerid]);
					PlayerTextDrawShow(playerid, ClothesShop3[playerid]);
					PlayerTextDrawShow(playerid, ClothesShop4[playerid]);
					PlayerTextDrawShow(playerid, ClothesShop5[playerid]);
					PlayerTextDrawShow(playerid, ClothesShop6[playerid]);
					PlayerTextDrawShow(playerid, ClothesShop7[playerid]);
					SetPlayerCameraPos(playerid, 237.9080, 1431.5597, 15.6856);
					SetPlayerCameraLookAt(playerid, 236.9017, 1431.5409, 15.5406);
				}
	     		else
				{
   					SendClientMessage(playerid, GREY, "Skins IDs are between 0 and 299.");
				}
            }
        }
	}
	if(dialogid == DIALOG_ADJUSTGANG)
    {
        if(!response) return 1;
        else if(response)
        {
            switch(listitem)
        	{
				case 0:
				{
					ShowPlayerDialog(playerid, DIALOG_GANGNAME, DIALOG_STYLE_INPUT, "Gang Name", "Please input your new gang name below.", "Done", "Quit");
				}
				case 1:
				{
					ShowPlayerDialog(playerid, DIALOG_GANGMOTD, DIALOG_STYLE_INPUT, "Gang MOTD", "Please input your new gang MOTD below.", "Done", "Quit");
				}
				case 2:
				{
					ShowPlayerDialog(playerid, DIALOG_RANK1NAME, DIALOG_STYLE_INPUT, "Rank 1 Name", "Please input the new rank 1 name below.", "Done", "Quit");
				}
				case 3:
				{
					ShowPlayerDialog(playerid, DIALOG_RANK2NAME, DIALOG_STYLE_INPUT, "Rank 2 Name", "Please input the new rank 2 name below.", "Done", "Quit");
				}
				case 4:
				{
					ShowPlayerDialog(playerid, DIALOG_RANK3NAME, DIALOG_STYLE_INPUT, "Rank 3 Name", "Please input the new rank 3 name below.", "Done", "Quit");
				}
				case 5:
				{
					ShowPlayerDialog(playerid, DIALOG_RANK4NAME, DIALOG_STYLE_INPUT, "Rank 4 Name", "Please input the new rank 4 name below.", "Done", "Quit");
				}
				case 6:
				{
					ShowPlayerDialog(playerid, DIALOG_RANK5NAME, DIALOG_STYLE_INPUT, "Rank 5 Name", "Please input the new rank 5 name below.", "Done", "Quit");
				}
				case 7:
				{
					ShowPlayerDialog(playerid, DIALOG_RANK6NAME, DIALOG_STYLE_INPUT, "Rank 6 Name", "Please input the new rank 6 name below.", "Done", "Quit");
				}
				case 8:
				{
					ShowPlayerDialog(playerid, DIALOG_GANGCOLOR, DIALOG_STYLE_LIST, "Gang Color", "Green\nRed\nLight Blue\nYellow\nBrown\nBlack\nOrange", "Done", "Quit");
				}
				case 9:
				{
					ShowPlayerDialog(playerid, DIALOG_RANK1SKIN, DIALOG_STYLE_INPUT, "Rank 1 Skin", "Input the new rank 1 skin ID below.", "Done", "Quit");
				}
				case 10:
				{
					ShowPlayerDialog(playerid, DIALOG_RANK2SKIN, DIALOG_STYLE_INPUT, "Rank 2 Skin", "Input the new rank 2 skin ID below.", "Done", "Quit");
				}
				case 11:
				{
					ShowPlayerDialog(playerid, DIALOG_RANK3SKIN, DIALOG_STYLE_INPUT, "Rank 3 Skin", "Input the new rank 3 skin ID below.", "Done", "Quit");
				}
				case 12:
				{
					ShowPlayerDialog(playerid, DIALOG_RANK4SKIN, DIALOG_STYLE_INPUT, "Rank 4 Skin", "Input the new rank 4 skin ID below.", "Done", "Quit");
				}
				case 13:
				{
					ShowPlayerDialog(playerid, DIALOG_RANK5SKIN, DIALOG_STYLE_INPUT, "Rank 5 Skin", "Input the new rank 5 skin ID below.", "Done", "Quit");
				}
				case 14:
				{
					ShowPlayerDialog(playerid, DIALOG_RANK6SKIN, DIALOG_STYLE_INPUT, "Rank 6 Skin", "Input the new rank 6 skin ID below.", "Done", "Quit");
				}
				case 15:
				{
					ShowPlayerDialog(playerid, DIALOG_FEMALESKIN, DIALOG_STYLE_INPUT, "Female Skin", "Input the new female skin ID below.", "Done", "Quit");
				}
			}
        }
    }
    if(dialogid == DIALOG_GANGNAME)
    {
        if(!response) return 1;
        else if(response)
        {
            if(!strlen(inputtext))
            {
				SendClientMessage(playerid, GREY, "Invalid Gang Name.");
			}
			else if(strlen(inputtext) < 5)
			{
                SendClientMessage(playerid, GREY, "Your new gang name mustn't be under 3 characters.");
			}
			else if(strlen(inputtext) > 20)
			{
                SendClientMessage(playerid, GREY, "Your new gang name mustn't be more than 20 characters.");
			}
            else
			{
                format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                if(INI_Open(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                {
				    new str[128];
				    format(str, sizeof(str), "You have successfully changed your gang name to %s", inputtext);
                    SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
                    format(GangStat[PlayerStat[playerid][GangID]][GangName], 128, "%s", inputtext);
                    INI_WriteString("Name", GangStat[PlayerStat[playerid][GangID]][GangName]);
                    INI_Save();
                    INI_Close();
                }
            }
        }
	}
	if(dialogid == DIALOG_GANGMOTD)
    {
        if(!response) return 1;
        else if(response)
        {
            if(!strlen(inputtext))
            {
				SendClientMessage(playerid, GREY, "Invalid Gang MOTD.");
			}
			else if(strlen(inputtext) > 70)
			{
                SendClientMessage(playerid, GREY, "Your new gang MOTD must be under 70 characters.");
			}
            else
			{
                format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                if(INI_Open(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                {
				    new str[128];
				    format(str, sizeof(str), "New gang MOTD: to %s", inputtext);
                    SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
                    format(GangStat[PlayerStat[playerid][GangID]][MOTD], 128, "%s", inputtext);
                    INI_WriteString("MOTD", GangStat[PlayerStat[playerid][GangID]][MOTD]);
                    INI_Save();
                    INI_Close();
                }
            }
        }
	}
	if(dialogid == DIALOG_RANK1NAME)
    {
        if(!response) return 1;
        else if(response)
        {
            if(!strlen(inputtext))
            {
				SendClientMessage(playerid, GREY, "Invalid Rank name.");
			}
			else if(strlen(inputtext) < 3)
			{
                SendClientMessage(playerid, GREY, "The new rank 1 name mustn't be under 3 characters.");
			}
			else if(strlen(inputtext) > 10)
			{
                SendClientMessage(playerid, GREY, "The new rank 1 name mustn't be more than 10 characters.");
			}
            else
			{
                format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                if(INI_Open(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                {
				    new str[128];
				    format(str, sizeof(str), "You have successfully changed the rank 1 name to %s", inputtext);
                    SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
                    format(GangStat[PlayerStat[playerid][GangID]][Rank1], 128, "%s", inputtext);
                    INI_WriteString("Rank1", GangStat[PlayerStat[playerid][GangID]][Rank1]);
                    INI_Save();
                    INI_Close();
                }
            }
        }
	}
	if(dialogid == DIALOG_RANK2NAME)
    {
        if(!response) return 1;
        else if(response)
        {
            if(!strlen(inputtext))
            {
				SendClientMessage(playerid, GREY, "Invalid Rank name.");
			}
			else if(strlen(inputtext) < 3)
			{
                SendClientMessage(playerid, GREY, "The new rank 2 name mustn't be under 3 characters.");
			}
			else if(strlen(inputtext) > 10)
			{
                SendClientMessage(playerid, GREY, "The new rank 2 name mustn't be more than 10 characters.");
			}
            else
			{
                format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                if(INI_Open(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                {
				    new str[128];
				    format(str, sizeof(str), "You have successfully changed the rank 2 name to %s", inputtext);
                    SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
                    format(GangStat[PlayerStat[playerid][GangID]][Rank2], 128, "%s", inputtext);
                    INI_WriteString("Rank2", GangStat[PlayerStat[playerid][GangID]][Rank2]);
                    INI_Save();
                    INI_Close();
                }
            }
        }
	}
	if(dialogid == DIALOG_RANK3NAME)
    {
        if(!response) return 1;
        else if(response)
        {
            if(!strlen(inputtext))
            {
				SendClientMessage(playerid, GREY, "Invalid Rank name.");
			}
			else if(strlen(inputtext) < 3)
			{
                SendClientMessage(playerid, GREY, "The new rank 3 name mustn't be under 3 characters.");
			}
			else if(strlen(inputtext) > 10)
			{
                SendClientMessage(playerid, GREY, "the new rank 3 name mustn't be more than 10 characters.");
			}
            else
			{
                format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                if(INI_Open(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                {
				    new str[128];
				    format(str, sizeof(str), "You have successfully changed the rank 3 name to %s", inputtext);
                    SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
                    format(GangStat[PlayerStat[playerid][GangID]][Rank3], 128, "%s", inputtext);
                    INI_WriteString("Rank3", GangStat[PlayerStat[playerid][GangID]][Rank3]);
                    INI_Save();
                    INI_Close();
                }
            }
        }
	}
	if(dialogid == DIALOG_RANK4NAME)
    {
        if(!response) return 1;
        else if(response)
        {
            if(!strlen(inputtext))
            {
				SendClientMessage(playerid, GREY, "Invalid Rank name.");
			}
			else if(strlen(inputtext) < 3)
			{
                SendClientMessage(playerid, GREY, "The new rank 4 name mustn't be under 3 characters.");
			}
			else if(strlen(inputtext) > 10)
			{
                SendClientMessage(playerid, GREY, "The new rank 4 name mustn't be more than 10 characters.");
			}
            else
			{
                format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                if(INI_Open(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                {
				    new str[128];
				    format(str, sizeof(str), "You have successfully changed the rank 4 name to %s", inputtext);
                    SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
                    format(GangStat[PlayerStat[playerid][GangID]][Rank4], 128, "%s", inputtext);
                    INI_WriteString("Rank4", GangStat[PlayerStat[playerid][GangID]][Rank4]);
                    INI_Save();
                    INI_Close();
                }
            }
        }
	}
	if(dialogid == DIALOG_RANK5NAME)
    {
        if(!response) return 1;
        else if(response)
        {
            if(!strlen(inputtext))
            {
				SendClientMessage(playerid, GREY, "Invalid Rank name.");
			}
			else if(strlen(inputtext) < 3)
			{
                SendClientMessage(playerid, GREY, "The new rank 5 name mustn't be under 3 characters.");
			}
			else if(strlen(inputtext) > 10)
			{
                SendClientMessage(playerid, GREY, "The new rank 5 name mustn't be more than 10 characters.");
			}
            else
			{
                format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                if(INI_Open(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                {
				    new str[128];
				    format(str, sizeof(str), "You have successfully changed the rank 5 name to %s", inputtext);
                    SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
                    format(GangStat[PlayerStat[playerid][GangID]][Rank5], 128, "%s", inputtext);
                    INI_WriteString("Rank5", GangStat[PlayerStat[playerid][GangID]][Rank5]);
                    INI_Save();
                    INI_Close();
                }
            }
        }
	}
	if(dialogid == DIALOG_RANK6NAME)
    {
        if(!response) return 1;
        else if(response)
        {
            if(!strlen(inputtext))
            {
				SendClientMessage(playerid, GREY, "Invalid Rank name.");
			}
			else if(strlen(inputtext) < 3)
			{
                SendClientMessage(playerid, GREY, "The new rank 6 name mustn't be under 3 characters.");
			}
			else if(strlen(inputtext) > 10)
			{
                SendClientMessage(playerid, GREY, "The new rank 6 name mustn't be more than 10 characters.");
			}
            else
			{
                format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                if(INI_Open(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                {
				    new str[128];
				    format(str, sizeof(str), "You have successfully changed the rank 6 name to %s", inputtext);
                    SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
                    format(GangStat[PlayerStat[playerid][GangID]][Rank6], 128, "%s", inputtext);
                    INI_WriteString("Rank6", GangStat[PlayerStat[playerid][GangID]][Rank6]);
                    INI_Save();
                    INI_Close();
                }
            }
        }
	}
	if(dialogid == DIALOG_GANGCOLOR)
    {
        if(!response) return 1;
        else if(response)
        {
            switch(listitem)
        	{
				case 0:
				{
					format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                    if(INI_Open(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                    {
                        GangStat[PlayerStat[playerid][GangID]][Color] = 0x33AA33AA;
                        INI_WriteInt("Color", GangStat[PlayerStat[playerid][GangID]][Color]);
                        INI_Save();
                        INI_Close();
                        SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], "You have successfully changed the gang color to Green");
                    }
				}
	        	case 1:
				{
					format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                    if(INI_Open(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                    {
                        GangStat[PlayerStat[playerid][GangID]][Color] = 0xAA3333AA;
                        INI_WriteInt("Color", GangStat[PlayerStat[playerid][GangID]][Color]);
                        INI_Save();
                        INI_Close();
                        SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], "You have successfully changed the gang color to Red");
                    }
				}
				case 2:
				{
					format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                    if(INI_Open(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                    {
                        GangStat[PlayerStat[playerid][GangID]][Color] = 0x33CCFFAA;
                        INI_WriteInt("Color", GangStat[PlayerStat[playerid][GangID]][Color]);
                        INI_Save();
                        INI_Close();
                        SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], "You have successfully changed the gang color to Light Blue");
                    }
				}
				case 3:
				{
					format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                    if(INI_Open(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                    {
                        GangStat[PlayerStat[playerid][GangID]][Color] = 0xFFFF00AA;
                        INI_WriteInt("Color", GangStat[PlayerStat[playerid][GangID]][Color]);
                        INI_Save();
                        INI_Close();
                        SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], "You have successfully changed the gang color to Yellow");
                    }
				}
				case 4:
				{
					format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                    if(INI_Open(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                    {
                        GangStat[PlayerStat[playerid][GangID]][Color] = 0xA52A2AAA;
                        INI_WriteInt("Color", GangStat[PlayerStat[playerid][GangID]][Color]);
                        INI_Save();
                        INI_Close();
                        SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], "You have successfully changed the gang color to Brown");
                    }
				}
				case 5:
				{
					format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                    if(INI_Open(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                    {
                        GangStat[PlayerStat[playerid][GangID]][Color] = 0x000000AA;
                        INI_WriteInt("Color", GangStat[PlayerStat[playerid][GangID]][Color]);
                        INI_Save();
                        INI_Close();
                        SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], "You have successfully changed the gang color to Black");
                    }
				}
                case 6:
				{
					format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                    if(INI_Open(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                    {
                        GangStat[PlayerStat[playerid][GangID]][Color] = 0xFF9900AA;
                        INI_WriteInt("Color", GangStat[PlayerStat[playerid][GangID]][Color]);
                        INI_Save();
                        INI_Close();
                        SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], "You have successfully changed the gang color to Orange");
                    }
				}
			}
        }
    }
    if(dialogid == DIALOG_RANK1SKIN)
    {
        if(!response) return 1;
        if(response)
        {
            if(!strval(inputtext))
            {
                SendClientMessage(playerid, GREY, "You have entered an Invalid Skin ID.");
            }
            else if(strval(inputtext))
		    {
		        if(0 < strval(inputtext) < 299)
				{
					new str[128];
                    format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                    if(INI_Open(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                    {
                        GangStat[PlayerStat[playerid][GangID]][Skin1] = strval(inputtext);
                        INI_WriteInt("Skin1", GangStat[PlayerStat[playerid][GangID]][Skin1]);
                        INI_Save();
                        INI_Close();
                        format(str, sizeof(str), "You have successfully changed rank 1 skin to %d", GangStat[PlayerStat[playerid][GangID]][Skin1]);
                        SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
                    }
                }
                else
				{
				    SendClientMessage(playerid, GREY, "Skins IDs are between 0 and 299.");
				}
            }
        }
	}
	if(dialogid == DIALOG_RANK2SKIN)
    {
        if(!response) return 1;
        if(response)
        {
            if(!strval(inputtext))
            {
                SendClientMessage(playerid, GREY, "You have entered an Invalid Skin ID.");
            }
            else if(strval(inputtext))
		    {
		        if(0 < strval(inputtext) < 299)
				{
					new str[128];
					format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                    if(INI_Open(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                    {
                        GangStat[PlayerStat[playerid][GangID]][Skin2] = strval(inputtext);
                        INI_WriteInt("Skin2", GangStat[PlayerStat[playerid][GangID]][Skin2]);
                        INI_Save();
                        INI_Close();
                        format(str, sizeof(str), "You have successfully changed rank 2 skin to %d", GangStat[PlayerStat[playerid][GangID]][Skin2]);
                        SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
                    }
                }
                else
				{
				    SendClientMessage(playerid, GREY, "Skins IDs are between 0 and 299.");
				}
            }
        }
	}
	if(dialogid == DIALOG_RANK3SKIN)
    {
        if(!response) return 1;
        if(response)
        {
            if(!strval(inputtext))
            {
                SendClientMessage(playerid, GREY, "You have entered an Invalid Skin ID.");
            }
            else if(strval(inputtext))
		    {
		        if(0 < strval(inputtext) < 299)
				{
					new str[128];
					format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                    if(INI_Open(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                    {
                        GangStat[PlayerStat[playerid][GangID]][Skin3] = strval(inputtext);
                        INI_WriteInt("Skin3", GangStat[PlayerStat[playerid][GangID]][Skin3]);
                        INI_Save();
                        INI_Close();
                        format(str, sizeof(str), "You have successfully changed rank 3 skin to %d", GangStat[PlayerStat[playerid][GangID]][Skin3]);
                        SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
                    }
                }
                else
				{
				    SendClientMessage(playerid, GREY, "Skins IDs are between 0 and 299.");
				}
            }
        }
	}
	if(dialogid == DIALOG_RANK4SKIN)
    {
        if(!response) return 1;
        if(response)
        {
            if(!strval(inputtext))
            {
                SendClientMessage(playerid, GREY, "You have entered an Invalid Skin ID.");
            }
            else if(strval(inputtext))
		    {
		        if(0 < strval(inputtext) < 299)
				{
					new str[128];
					format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                    if(INI_Open(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                    {
                        GangStat[PlayerStat[playerid][GangID]][Skin4] = strval(inputtext);
                        INI_WriteInt("Skin4", GangStat[PlayerStat[playerid][GangID]][Skin4]);
                        INI_Save();
                        INI_Close();
                        format(str, sizeof(str), "You have successfully changed rank 4 skin to %d", GangStat[PlayerStat[playerid][GangID]][Skin4]);
                        SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
                    }
                }
                else
				{
				    SendClientMessage(playerid, GREY, "Skins IDs are between 0 and 299.");
				}
            }
        }
	}
	if(dialogid == DIALOG_RANK5SKIN)
    {
        if(!response) return 1;
        if(response)
        {
            if(!strval(inputtext))
            {
                SendClientMessage(playerid, GREY, "You have entered an Invalid Skin ID.");
            }
            else if(strval(inputtext))
		    {
		        if(0 < strval(inputtext) < 299)
				{
					new str[128];
					format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                    if(INI_Open(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                    {
                        GangStat[PlayerStat[playerid][GangID]][Skin5] = strval(inputtext);
                        INI_WriteInt("Skin5", GangStat[PlayerStat[playerid][GangID]][Skin5]);
                        INI_Save();
                        INI_Close();
                        format(str, sizeof(str), "You have successfully changed rank 5 skin to %d", GangStat[PlayerStat[playerid][GangID]][Skin5]);
                        SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
                    }
                }
                else
				{
				    SendClientMessage(playerid, GREY, "Skins IDs are between 0 and 299.");
				}
            }
        }
	}
	if(dialogid == DIALOG_RANK6SKIN)
    {
        if(!response) return 1;
        if(response)
        {
            if(!strval(inputtext))
            {
                SendClientMessage(playerid, GREY, "You have entered an Invalid Skin ID.");
            }
            else if(strval(inputtext))
		    {
		        if(0 < strval(inputtext) < 299)
				{
					new str[128];
					format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                    if(INI_Open(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                    {
                        GangStat[PlayerStat[playerid][GangID]][Skin6] = strval(inputtext);
                        INI_WriteInt("Skin6", GangStat[PlayerStat[playerid][GangID]][Skin6]);
                        INI_Save();
                        INI_Close();
                        format(str, sizeof(str), "You have successfully changed rank 6 skin to %d", GangStat[PlayerStat[playerid][GangID]][Skin6]);
                        SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
                    }
                }
                else
				{
				    SendClientMessage(playerid, GREY, "Skins IDs are between 0 and 299.");
				}
            }
        }
    }
    if(dialogid == DIALOG_FEMALESKIN)
    {
        if(!response) return 1;
        if(response)
        {
            if(!strval(inputtext))
            {
                SendClientMessage(playerid, GREY, "You have entered an Invalid Skin ID.");
            }
            else if(strval(inputtext))
		    {
		        if(0 < strval(inputtext) < 299)
				{
					new str[128];
					format(GangStat[PlayerStat[playerid][GangID]][GangFile], 60, "Gangs/Gang %d.ini", PlayerStat[playerid][GangID]);
                    if(INI_Open(GangStat[PlayerStat[playerid][GangID]][GangFile]))
                    {
                        GangStat[PlayerStat[playerid][GangID]][fSkin] = strval(inputtext);
                        INI_WriteInt("fSkin", GangStat[PlayerStat[playerid][GangID]][fSkin]);
                        INI_Save();
                        INI_Close();
                        format(str, sizeof(str), "You have successfully changed the female skin to %d", GangStat[PlayerStat[playerid][GangID]][fSkin]);
                        SendClientMessage(playerid, GangStat[PlayerStat[playerid][GangID]][Color], str);
                    }
                }
                else
				{
				    SendClientMessage(playerid, GREY, "Skins IDs are between 0 and 299.");
				}
            }
        }
	}
	if(dialogid == DIALOG_GLOCKER)
    {
        if(!response) return 1;
        else if(response)
        {
            switch(listitem)
        	{
				case 0:
				{
					if(PlayerStat[playerid][GuardDuty] == 0)
					{
						CurrentSkin[playerid] = GetPlayerSkin(playerid);
						PlayerStat[playerid][GuardDuty] = 1;
						SendClientMessage(playerid, GUARDS_RADIO, "You are now on duty.");
						SetPlayerColor(playerid, BLUE);
					}
					else if(PlayerStat[playerid][GuardDuty] == 1)
					{
						PlayerStat[playerid][GuardDuty] = 0;
						SendClientMessage(playerid, RED, "You are now off duty.");
						SetPlayerColor(playerid, WHITE);
						SetArmour(playerid, 0);
						PlayerStat[playerid][WeaponPocketCD] = 4;
						ResetWeapons(playerid);
						SetPlayerSkin(playerid, CurrentSkin[playerid]);
						RemovePlayerAttachedObject(playerid, 1);
						RemovePlayerAttachedObject(playerid, 2);
					}
				}
				case 1:
				{
                    ShowPlayerDialog(playerid, DIALOG_EQUIPMENT, DIALOG_STYLE_LIST, "Equipment", "{FF1919}Riot Equipment [Level 2]\nKevlar Vest [Level 2]\n{FFFFFF}Nite Stick [Level 1]\nMace Spray [Level 1]\n{70C470}Beanbag Shotgun [Level 2]\n{FF1919}Colt. 45 [Level 2]\n{FF1919}Desert Eagle [Level 3]\n{FF1919}MP5 [Level 3]\n{FF1919}M4 [Level 4]\n{FF1919}Bolt Action Rifle [Level 4]\n{FF1919}Sniper Rifle [Level 6]", "Select", "Cancel");
				}
				case 2:
				{
                    if(PlayerStat[playerid][GuardDuty] == 0)
					{
						SendClientMessage(playerid, GREY, "You are not on duty.");
					}
                 	else if(PlayerStat[playerid][FactionRank] >= 1)
					{
						SetSkin(playerid, 71);
					}
				}
				case 3:
				{
					ResetWeaponsFully(playerid);
					PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0);
					SendClientMessage(playerid, LIGHT_GREEN, "All your weapons have been taken.");
				}
			}
        }
    }
    if(dialogid == DIALOG_EXAM0)
    {
        if(!response) return 1;
        else if(response)
        {
            switch(listitem)
        	{
				case 0: //INFORMATION
				{
					ShowPlayerDialog(playerid, DIALOG_EXAM1T3, DIALOG_STYLE_MSGBOX, "Information", "Taking exams is the way to get smarter in prison. Along with reading and learning new things you will have to take an exam\nin order of being able to craft or grow certain items.\nYou can take an exam once every 3 playing hours.\nYou can read the books as much as you like.", "OK", "OK");
				}
				case 1: // Metal Worker Exam
				{
                    ShowPlayerDialog(playerid, DIALOG_EXAM1Q1, DIALOG_STYLE_LIST, "Exam", "{70C470}1. Before starting to work with a metal, what should you do?\n* Operate the metal.\n* Marking out the metal.\n* Heating the metal.\n* Combining the metal.", "Select", "Cancel");
				}
			}
		}
	}
    if(dialogid == DIALOG_EXAM1Q1)
    {
        if(!response) return 1;
        else if(response)
        {
            switch(listitem)
        	{
				case 0: //QUESTION CLICK
				{
                    ShowPlayerDialog(playerid, DIALOG_EXAM1Q1, DIALOG_STYLE_LIST, "Exam", "{70C470}1. Before starting to work with a metal, what should you do?\n* Operate the metal.\n* Marking out the metal.\n* Heating the metal.\n* Combining the metal.", "Select", "Cancel");
				}
				case 1: //ANSWER 1
				{
					ExamWrong[playerid] = 1;
                    ShowPlayerDialog(playerid, DIALOG_EXAM1Q2, DIALOG_STYLE_LIST, "Exam", "{70C470}2. What's the name of the tool that measure the distance between two points?\n* Length meter.\n* Clippers.\n* Lengher.\n* Calipers.", "Select", "Cancel");
				}
				case 2: //ANSWER 2
				{
                    ShowPlayerDialog(playerid, DIALOG_EXAM1Q2, DIALOG_STYLE_LIST, "Exam", "{70C470}2. What's the name of the tool that measure the distance between two points?\n* Length meter.\n* Clippers.\n* Lengher.\n* Calipers.", "Select", "Cancel");
				}
				case 3: //ANSWER 3
				{
					ExamWrong[playerid] = 1;
                    ShowPlayerDialog(playerid, DIALOG_EXAM1Q2, DIALOG_STYLE_LIST, "Exam", "{70C470}2. What's the name of the tool that measure the distance between two points?\n* Length meter.\n* Clippers.\n* Lengher.\n* Calipers.", "Select", "Cancel");
				}
				case 4: //ANSWER 4
				{
					ExamWrong[playerid] = 1;
                    ShowPlayerDialog(playerid, DIALOG_EXAM1Q2, DIALOG_STYLE_LIST, "Exam", "{70C470}2. What's the name of the tool that measure the distance between two points?\n* Length meter.\n* Clippers.\n* Lengher.\n* Calipers.", "Select", "Cancel");
				}
			}
		}
	}
    if(dialogid == DIALOG_EXAM1Q2)
    {
        if(!response) return 1;
        else if(response)
        {
            switch(listitem)
        	{
				case 0: //QUESTION CLICK
				{
                    ShowPlayerDialog(playerid, DIALOG_EXAM1Q2, DIALOG_STYLE_LIST, "Exam", "{70C470}2. What's the name of the tool that measure the distance between two points?\n* Length meter.\n* Clippers.\n* Lengher.\n* Calipers.", "Select", "Cancel");
				}
				case 1: //ANSWER 1
				{
					ExamWrong[playerid] = 1;
                    ShowPlayerDialog(playerid, DIALOG_EXAM1Q3, DIALOG_STYLE_LIST, "Exam", "{70C470}3. How accurate the tool of measurement?\n* 25.4 micro meter.\n* 12.7 micro meter.\n* 24.2 micro meter.\n* 31.6 micro meter.", "Select", "Cancel");
				}
				case 2: //ANSWER 2
				{
					ExamWrong[playerid] = 1;
                    ShowPlayerDialog(playerid, DIALOG_EXAM1Q3, DIALOG_STYLE_LIST, "Exam", "{70C470}3. How accurate the tool of measurement?\n* 25.4 micro meter.\n* 12.7 micro meter.\n* 24.2 micro meter.\n* 31.6 micro meter.", "Select", "Cancel");
				}
				case 3: //ANSWER 3
				{
					ExamWrong[playerid] = 1;
                    ShowPlayerDialog(playerid, DIALOG_EXAM1Q3, DIALOG_STYLE_LIST, "Exam", "{70C470}3. How accurate the tool of measurement?\n* 25.4 micro meter.\n* 12.7 micro meter.\n* 24.2 micro meter.\n* 31.6 micro meter.", "Select", "Cancel");
				}
				case 4: //ANSWER 4
				{
                    ShowPlayerDialog(playerid, DIALOG_EXAM1Q3, DIALOG_STYLE_LIST, "Exam", "{70C470}3. How accurate the tool of measurement?\n* 25.4 micro meter.\n* 12.7 micro meter.\n* 24.2 micro meter.\n* 31.6 micro meter.", "Select", "Cancel");
				}
			}
		}
	}
    if(dialogid == DIALOG_EXAM1Q3)
    {
        if(!response) return 1;
        else if(response)
        {
            switch(listitem)
        	{
				case 0: //QUESTION CLICK
				{
                    ShowPlayerDialog(playerid, DIALOG_EXAM1Q3, DIALOG_STYLE_LIST, "Exam", "{70C470}3. How accurate the tool of measurement?\n* 25.4 micro meter.\n* 12.7 micro meter.\n* 24.2 micro meter.\n* 31.6 micro meter.", "Select", "Cancel");
				}
				case 1: //ANSWER 1
				{
                    ShowPlayerDialog(playerid, DIALOG_EXAM1Q4, DIALOG_STYLE_LIST, "Exam", "{70C470}4. What would you do after you finished the layout?\n* Begin drawing.\n* Begin heating the metal.\n* Begin cutting/drilling.\n* Begin applying oil.", "Select", "Cancel");
				}
				case 2: //ANSWER 2
				{
					ExamWrong[playerid] = 1;
                    ShowPlayerDialog(playerid, DIALOG_EXAM1Q4, DIALOG_STYLE_LIST, "Exam", "{70C470}4. What would you do after you finished the layout?\n* Begin drawing.\n* Begin heating the metal.\n* Begin cutting/drilling.\n* Begin applying oil.", "Select", "Cancel");
				}
				case 3: //ANSWER 3
				{
					ExamWrong[playerid] = 1;
                    ShowPlayerDialog(playerid, DIALOG_EXAM1Q4, DIALOG_STYLE_LIST, "Exam", "{70C470}4. What would you do after you finished the layout?\n* Begin drawing.\n* Begin heating the metal.\n* Begin cutting/drilling.\n* Begin applying oil.", "Select", "Cancel");
				}
				case 4: //ANSWER 4
				{
					ExamWrong[playerid] = 1;
                    ShowPlayerDialog(playerid, DIALOG_EXAM1Q4, DIALOG_STYLE_LIST, "Exam", "{70C470}4. What would you do after you finished the layout?\n* Begin drawing.\n* Begin heating the metal.\n* Begin cutting/drilling.\n* Begin applying oil.", "Select", "Cancel");
				}
			}
		}
	}
    if(dialogid == DIALOG_EXAM1Q4)
    {
        if(!response) return 1;
        else if(response)
        {
            switch(listitem)
        	{
				case 0: //QUESTION CLICK
				{
                    ShowPlayerDialog(playerid, DIALOG_EXAM1Q4, DIALOG_STYLE_LIST, "Exam", "{70C470}4. What would you do after you finished the layout?\n* Begin drawing.\n* Begin heating the metal.\n* Begin cutting/drilling.\n* Begin applying oil.", "Select", "Cancel");
				}
				case 1: //ANSWER 1
				{
					ExamWrong[playerid] = 1;
				}
				case 2: //ANSWER 2
				{
					ExamWrong[playerid] = 1;
				}
				case 3: //ANSWER 3
				{
					goto contin;
				}
				case 4: //ANSWER 4
				{
					ExamWrong[playerid] = 1;
				}
			}
			contin:
			if(ExamWrong[playerid] == 0)
			{
				SendClientMessage(playerid, GREEN, "You have passed the exam, and you are now able to craft a knuckle.");
				SendClientMessage(playerid, WHITE, "Knuckle Crafting Materials:");
				SendClientMessage(playerid, WHITE, "- 4 pieces of metal.");
				PlayerStat[playerid][MetSkill] = 1;
				ExamWrong[playerid] = 0;
			}
			if(ExamWrong[playerid] == 1)
			{
				SendClientMessage(playerid, RED, "You have failed the test.");
				ExamWrong[playerid] = 0;
			}
			return 1;
		}
	}
    if(dialogid == DIALOG_EQUIPMENT)
    {
        if(!response) return 1;
        else if(response)
        {
            switch(listitem)
        	{
				case 0: //Riot Equipment [Level 3]
				{
					if(PlayerStat[playerid][GuardDuty] == 0) return SendClientMessage(playerid, GREY, "You are not on-duty.");
					if(PlayerStat[playerid][FactionRank] <= 2) return SendClientMessage(playerid, GREY, "Your rank level isn't high enough to use this equipment.");
					SetArmour(playerid, 100);
					SetSkin(playerid, 285);
					SetPlayerAttachedObject(playerid, 1, 18637, 4, 0.3, 0, 0, 0, 170, 270, 1, 1, 1);
					SetPlayerAttachedObject(playerid, 2,18641, 5, 0.1, 0.02, -0.05, 0, 0, 0, 1, 1, 1);
					PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0);
				}
				case 1: //Kevlar Vest [Level 2]
				{
					if(PlayerStat[playerid][GuardDuty] == 0) return SendClientMessage(playerid, GREY, "You are not on-duty.");
					SetPlayerArmour(playerid, 100);
					PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0);
				}
				case 2: //Nite Stick [Level 1]
				{
					new cWeapon = GetPlayerWeapon(playerid);
					if(PlayerStat[playerid][GuardDuty] == 0) return SendClientMessage(playerid, GREY, "You are not on-duty.");
					if(PlayerStat[playerid][PlayingHours] < 5) return SendClientMessage(playerid, GREY, "You can't carry weapons below 5 playing hours.");
					if(cWeapon >= 1 || PlayerStat[playerid][WeaponPocketCD] >= 1) return SendClientMessage(playerid, GREY, "You can't carry two weapons in your hands, pocket the current weapon.");
					ServerWeapon(playerid, 3, 1);
					SetPlayerAmmo(playerid, 3, 1);
					PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0);
				}
				case 3: //Mace Spray [Level 1]
				{
					new cWeapon = GetPlayerWeapon(playerid);
					if(PlayerStat[playerid][GuardDuty] == 0) return SendClientMessage(playerid, GREY, "You are not on-duty.");
					if(PlayerStat[playerid][PlayingHours] < 5) return SendClientMessage(playerid, GREY, "You can't carry weapons below 5 playing hours.");
					if(cWeapon >= 1 || PlayerStat[playerid][WeaponPocketCD] >= 1) return SendClientMessage(playerid, GREY, "You can't carry two weapons in your hands, pocket the current weapon.");
					ServerWeapon(playerid, 41, 500);
					SetPlayerAmmo(playerid, 41, 500);
					PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0);
				}
				case 4: //Beanbag Shotgun [Level 2]
				{
					new cWeapon = GetPlayerWeapon(playerid);
					if(PlayerStat[playerid][GuardDuty] == 0) return SendClientMessage(playerid, GREY, "You are not on-duty.");
					if(PlayerStat[playerid][PlayingHours] < 5) return SendClientMessage(playerid, GREY, "You can't carry weapons below 5 playing hours.");
					if(cWeapon >= 1 || PlayerStat[playerid][WeaponPocketCD] >= 1) return SendClientMessage(playerid, GREY, "You can't carry two weapons in your hands, pocket the current weapon.");
					if(PlayerStat[playerid][FactionRank] <= 1) return SendClientMessage(playerid, GREY, "Your rank level isn't high enough to use this equipment.");
					ServerWeapon(playerid, 25, 70);
					SetPlayerAmmo(playerid, 25, 70);
					PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0);
				}
				case 5: //Colt. 45 [Level 2]
				{
					new cWeapon = GetPlayerWeapon(playerid);
					if(PlayerStat[playerid][GuardDuty] == 0) return SendClientMessage(playerid, GREY, "You are not on-duty.");
					if(PlayerStat[playerid][PlayingHours] < 5) return SendClientMessage(playerid, GREY, "You can't carry weapons below 5 playing hours.");
					if(cWeapon >= 1 || PlayerStat[playerid][WeaponPocketCD] >= 1) return SendClientMessage(playerid, GREY, "You can't carry two weapons in your hands, pocket the current weapon.");
					if(PlayerStat[playerid][FactionRank] <= 1) return SendClientMessage(playerid, GREY, "Your rank level isn't high enough to use this equipment.");
					ServerWeapon(playerid, 22, 100);
					SetPlayerAmmo(playerid, 22, 100);
					PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0);
				}
				case 6: //Desert Eagle [Level 3]
				{
					new cWeapon = GetPlayerWeapon(playerid);
					if(PlayerStat[playerid][GuardDuty] == 0) return SendClientMessage(playerid, GREY, "You are not on-duty.");
					if(PlayerStat[playerid][PlayingHours] < 5) return SendClientMessage(playerid, GREY, "You can't carry weapons below 5 playing hours.");
					if(cWeapon >= 1 || PlayerStat[playerid][WeaponPocketCD] >= 1) return SendClientMessage(playerid, GREY, "You can't carry two weapons in your hands, pocket the current weapon.");
					if(PlayerStat[playerid][FactionRank] <= 2) return SendClientMessage(playerid, GREY, "Your rank level isn't high enough to use this equipment.");
					ServerWeapon(playerid, 24, 70);
					SetPlayerAmmo(playerid, 24, 70);
					PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0);
				}
				case 7: //MP5 [Level 3]
				{
					new cWeapon = GetPlayerWeapon(playerid);
					if(PlayerStat[playerid][GuardDuty] == 0) return SendClientMessage(playerid, GREY, "You are not on-duty.");
					if(PlayerStat[playerid][PlayingHours] < 5) return SendClientMessage(playerid, GREY, "You can't carry weapons below 5 playing hours.");
					if(cWeapon >= 1 || PlayerStat[playerid][WeaponPocketCD] >= 1) return SendClientMessage(playerid, GREY, "You can't carry two weapons in your hands, pocket the current weapon.");
					if(PlayerStat[playerid][FactionRank] <= 2) return SendClientMessage(playerid, GREY, "Your rank level isn't high enough to use this equipment.");
					ServerWeapon(playerid, 29, 200);
					SetPlayerAmmo(playerid, 29, 200);
					PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0);
				}
				case 8: //M4 [Level 4]
				{
					new cWeapon = GetPlayerWeapon(playerid);
					if(PlayerStat[playerid][GuardDuty] == 0) return SendClientMessage(playerid, GREY, "You are not on-duty.");
					if(PlayerStat[playerid][PlayingHours] < 5) return SendClientMessage(playerid, GREY, "You can't carry weapons below 5 playing hours.");
					if(cWeapon >= 1 || PlayerStat[playerid][WeaponPocketCD] >= 1) return SendClientMessage(playerid, GREY, "You can't carry two weapons in your hands, pocket the current weapon.");
					if(PlayerStat[playerid][FactionRank] <= 3) return SendClientMessage(playerid, GREY, "Your rank level isn't high enough to use this equipment.");
					ServerWeapon(playerid, 31, 120);
					SetPlayerAmmo(playerid, 31, 120);
					PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0);
				}
				case 9: //Bolt Action Rifle [Level 4]
				{
					new cWeapon = GetPlayerWeapon(playerid);
					if(PlayerStat[playerid][GuardDuty] == 0) return SendClientMessage(playerid, GREY, "You are not on-duty.");
					if(PlayerStat[playerid][PlayingHours] < 5) return SendClientMessage(playerid, GREY, "You can't carry weapons below 5 playing hours.");
					if(cWeapon >= 1 || PlayerStat[playerid][WeaponPocketCD] >= 1) return SendClientMessage(playerid, GREY, "You can't carry two weapons in your hands, pocket the current weapon.");
					if(PlayerStat[playerid][FactionRank] <= 3) return SendClientMessage(playerid, GREY, "Your rank level isn't high enough to use this equipment.");
					ServerWeapon(playerid, 33, 50);
					SetPlayerAmmo(playerid, 33, 50);
					PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0);
				}
				case 10: //Sniper Rifle [Level 6]
				{
					new cWeapon = GetPlayerWeapon(playerid);
					if(PlayerStat[playerid][GuardDuty] == 0) return SendClientMessage(playerid, GREY, "You are not on-duty.");
					if(PlayerStat[playerid][PlayingHours] < 5) return SendClientMessage(playerid, GREY, "You can't carry weapons below 5 playing hours.");
					if(cWeapon >= 1 || PlayerStat[playerid][WeaponPocketCD] >= 1) return SendClientMessage(playerid, GREY, "You can't carry two weapons in your hands, pocket the current weapon.");
					if(PlayerStat[playerid][FactionRank] <= 5) return SendClientMessage(playerid, GREY, "Your rank level isn't high enough to use this equipment.");
					ServerWeapon(playerid, 34, 50);
					SetPlayerAmmo(playerid, 34, 50);
					PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0);
				}
			}
        }
    }
    if(dialogid == DIALOG_DLOCKER)
    {
        if(!response) return 1;
        else if(response)
        {
            switch(listitem)
        	{
				case 0:
				{
					if(PlayerStat[playerid][DoctorDuty] == 0)
					{
						PlayerStat[playerid][DoctorDuty] = 1;
						SendClientMessage(playerid, DOCTORS_RADIO , "You are now on Duty.");
						SetPlayerColor(playerid, DOCTORS_RADIO );
					}
					else if(PlayerStat[playerid][DoctorDuty] == 1)
					{
						PlayerStat[playerid][DoctorDuty] = 0;
						SendClientMessage(playerid, DOCTORS_RADIO , "You are now off Duty.");
						SetPlayerColor(playerid, WHITE);
						SetArmour(playerid, 0);
						ResetWeapons(playerid);
					}
				}
				case 1:
				{
                    if(PlayerStat[playerid][DoctorDuty] == 0)
					{
						SendClientMessage(playerid, GREY, "You are not on duty.");
					}
                 	else
					{
						SetSkin(playerid, 70);
					    SendClientMessage(playerid, GREY, "You have successfully changed your uniform.");
					}
				}
			}
        }
    }
    if(dialogid == DIALOG_GYM)
    {
        if(!response) return 1;
        else if(response)
        {
            switch(listitem)
        	{
				case 0: // Regular Fighting 100$ | 50$
				{
					new cStyle = GetPlayerFightingStyle(playerid);
					if(cStyle == 4) return SendClientMessage(playerid, GREY, "You already know this fighting style.");
					if(PlayerStat[playerid][DonLV] == 3)
					{
						if(PlayerStat[playerid][Money] < 50) return SendClientMessage(playerid, GREY, "You don't have enough money.");
						SetPlayerFightingStyle(playerid, 4);
						PlayerStat[playerid][FightStyle] = 4;
						GiveMoney(playerid, -50);
						SendClientMessage(playerid, LIGHT_GREEN, "You have learned the regularly fight style.");
						PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0);
					}
					else
					{
						if(PlayerStat[playerid][Money] < 100) return SendClientMessage(playerid, GREY, "You don't have enough money.");
						SetPlayerFightingStyle(playerid, 4);
						PlayerStat[playerid][FightStyle] = 4;
						GiveMoney(playerid, -100);
						SendClientMessage(playerid, LIGHT_GREEN, "You have learned the regularly fight style.");
						PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0);
					}
				}
				case 1: // Boxing 400$ | 200$
				{
					new cStyle = GetPlayerFightingStyle(playerid);
					if(PlayerStat[playerid][StatPWR] <= 4)
					{
						new Float:posX, Float:posY, Float:posZ;
						GetPlayerPos(playerid, posX, posY, posZ);
						PlayNearBySound(playerid, 4802, posX, posY, posZ, 10);
						SendClientMessage(playerid, GREY, "You need to be stronger to learn this fightstyle, go workout on the bench presses.");
						return 1;
					}
					if(cStyle == 5) return SendClientMessage(playerid, GREY, "You already know this fighting style.");
					if(PlayerStat[playerid][DonLV] == 3)
					{
						if(PlayerStat[playerid][Money] < 200) return SendClientMessage(playerid, GREY, "You don't have enough money.");
						SetPlayerFightingStyle(playerid, 5);
						PlayerStat[playerid][FightStyle] = 5;
						GiveMoney(playerid, -200);
						SendClientMessage(playerid, LIGHT_GREEN, "You have learned the boxing fight style.");
						PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0);
					}
					else
					{
						if(PlayerStat[playerid][Money] < 400) return SendClientMessage(playerid, GREY, "You don't have enough money.");
						SetPlayerFightingStyle(playerid, 5);
						PlayerStat[playerid][FightStyle] = 5;
						GiveMoney(playerid, -400);
						SendClientMessage(playerid, LIGHT_GREEN, "You have learned the boxing fight style.");
						PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0);
					}
				}
				case 2: // Kung-Fu 400$ | 200$
				{
					new cStyle = GetPlayerFightingStyle(playerid);
					if(PlayerStat[playerid][StatPWR] <= 4)
					{
						new Float:posX, Float:posY, Float:posZ;
						GetPlayerPos(playerid, posX, posY, posZ);
						PlayNearBySound(playerid, 4802, posX, posY, posZ, 10);
						SendClientMessage(playerid, GREY, "You need to be stronger to learn this fightstyle, go workout on the bench presses.");
						return 1;
					}
					if(cStyle == 6) return SendClientMessage(playerid, GREY, "You already know this fighting style.");
					if(PlayerStat[playerid][DonLV] == 3)
					{
						if(PlayerStat[playerid][Money] < 200) return SendClientMessage(playerid, GREY, "You don't have enough money.");
						SetPlayerFightingStyle(playerid, 6);
						PlayerStat[playerid][FightStyle] = 6;
						GiveMoney(playerid, -200);
						SendClientMessage(playerid, LIGHT_GREEN, "You have learned the Kung-Fu fight style.");
						PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0);
					}
					else
					{
						if(PlayerStat[playerid][Money] < 400) return SendClientMessage(playerid, GREY, "You don't have enough money.");
						SetPlayerFightingStyle(playerid, 6);
						PlayerStat[playerid][FightStyle] = 6;
						GiveMoney(playerid, -400);
						SendClientMessage(playerid, LIGHT_GREEN, "You have learned the Kung-Fu fight style.");
						PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0);
					}
				}
				case 3: // Knee-Head 700$ | 350$
				{
					new cStyle = GetPlayerFightingStyle(playerid);
					if(PlayerStat[playerid][StatPWR] <= 14)
					{
						new Float:posX, Float:posY, Float:posZ;
						GetPlayerPos(playerid, posX, posY, posZ);
						PlayNearBySound(playerid, 4802, posX, posY, posZ, 10);
						SendClientMessage(playerid, GREY, "You need to be stronger to learn this fightstyle, go workout on the bench presses.");
						return 1;
					}
					if(cStyle == 7) return SendClientMessage(playerid, GREY, "You already know this fighting style.");
					if(PlayerStat[playerid][DonLV] == 3)
					{
						if(PlayerStat[playerid][Money] < 350) return SendClientMessage(playerid, GREY, "You don't have enough money.");
						SetPlayerFightingStyle(playerid, 7);
						PlayerStat[playerid][FightStyle] = 7;
						GiveMoney(playerid, -350);
						SendClientMessage(playerid, LIGHT_GREEN, "You have learned the Knee-Head fight style.");
						PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0);
					}
					else
					{
						if(PlayerStat[playerid][Money] < 700) return SendClientMessage(playerid, GREY, "You don't have enough money.");
						SetPlayerFightingStyle(playerid, 7);
						PlayerStat[playerid][FightStyle] = 7;
						GiveMoney(playerid, -700);
						SendClientMessage(playerid, LIGHT_GREEN, "You have learned the Knee-Head fight style.");
						PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0);
					}
				}
				case 4: // Grab-Kick 700$ | 350$
				{
					new cStyle = GetPlayerFightingStyle(playerid);
					if(PlayerStat[playerid][StatPWR] <= 14)
					{
						new Float:posX, Float:posY, Float:posZ;
						GetPlayerPos(playerid, posX, posY, posZ);
						PlayNearBySound(playerid, 4802, posX, posY, posZ, 10);
						SendClientMessage(playerid, GREY, "You need to be stronger to learn this fightstyle, go workout on the bench presses.");
						return 1;
					}
					if(cStyle == 15) return SendClientMessage(playerid, GREY, "You already know this fighting style.");
					if(PlayerStat[playerid][DonLV] == 3)
					{
						if(PlayerStat[playerid][Money] < 350) return SendClientMessage(playerid, GREY, "You don't have enough money.");
						SetPlayerFightingStyle(playerid, 15);
						PlayerStat[playerid][FightStyle] = 15;
						GiveMoney(playerid, -350);
						SendClientMessage(playerid, LIGHT_GREEN, "You have learned the Grab-Kick fight style.");
						PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0);
					}
					else
					{
						if(PlayerStat[playerid][Money] < 700) return SendClientMessage(playerid, GREY, "You don't have enough money.");
						SetPlayerFightingStyle(playerid, 15);
						PlayerStat[playerid][FightStyle] = 15;
						GiveMoney(playerid, -700);
						SendClientMessage(playerid, LIGHT_GREEN, "You have learned the Grab-Kick fight style.");
						PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0);
					}
				}
				case 5: // Elbow 700$ | 350$
				{
					new cStyle = GetPlayerFightingStyle(playerid);
					if(PlayerStat[playerid][StatPWR] <= 14)
					{
						new Float:posX, Float:posY, Float:posZ;
						GetPlayerPos(playerid, posX, posY, posZ);
						PlayNearBySound(playerid, 4802, posX, posY, posZ, 10);
						SendClientMessage(playerid, GREY, "You need to be stronger to learn this fightstyle, go workout on the bench presses.");
						return 1;
					}
					if(cStyle == 16) return SendClientMessage(playerid, GREY, "You already know this fighting style.");
					if(PlayerStat[playerid][DonLV] == 3)
					{
						if(PlayerStat[playerid][Money] < 350) return SendClientMessage(playerid, GREY, "You don't have enough money.");
						SetPlayerFightingStyle(playerid, 16);
						PlayerStat[playerid][FightStyle] = 16;
						GiveMoney(playerid, -350);
						SendClientMessage(playerid, LIGHT_GREEN, "You have learned the elbow fight style.");
						PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0);
					}
					else
					{
						if(PlayerStat[playerid][Money] < 700) return SendClientMessage(playerid, GREY, "You don't have enough money.");
						SetPlayerFightingStyle(playerid, 16);
						PlayerStat[playerid][FightStyle] = 16;
						GiveMoney(playerid, -700);
						SendClientMessage(playerid, LIGHT_GREEN, "You have learned the elbow fight style.");
						PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0);
					}
				}
			}
			
		}
	}
    if(dialogid == DIALOG_STORE)
    {
        if(!response) return 1;
        else if(response)
        {
            switch(listitem)
        	{
				case 0:
				{
    				if(PlayerStat[playerid][Money] < 5) return SendClientMessage(playerid, GREY, "You don't have enough money.");
					if(GetFreeSlot(playerid) == 0)
					{
						SendClientMessage(playerid, RED, "You got no free slot in your inventory.");
						return 1;
					}
					GiveItem(playerid, 1, 1);
					GiveMoney(playerid, -5);
					SendClientMessage(playerid, GREY, "You bought a sandwich from the store for 5$.");
				}
				case 1:
				{
    				if(PlayerStat[playerid][Money] < 3) return SendClientMessage(playerid, GREY, "You don't have enough money.");
					if(GetFreeSlot(playerid) == 0)
					{
						SendClientMessage(playerid, RED, "You got no free slot in your inventory.");
						return 1;
					}
					GiveItem(playerid, 2, 1);
					GiveMoney(playerid, -3);
					SendClientMessage(playerid, GREY, "You bought a cold sprunk from the store for 3$.");
				}
				case 2:
				{
    				if(PlayerStat[playerid][Money] < 10) return SendClientMessage(playerid, GREY, "You don't have enough money.");
					if(GetFreeSlot(playerid) == 0)
					{
						SendClientMessage(playerid, RED, "You got no free slot in your inventory.");
						return 1;
					}
					GiveItem(playerid, 3, 10);
					GiveMoney(playerid, -10);
					SendClientMessage(playerid, GREY, "You bought a lighter from the prison store for $10.");
				}
				case 3:
				{
    				if(PlayerStat[playerid][Money] < 25) return SendClientMessage(playerid, GREY, "You don't have enough money.");
					if(GetFreeSlot(playerid) == 0)
					{
						SendClientMessage(playerid, RED, "You got no free slot in your inventory.");
						return 1;
					}
					GiveItem(playerid, 4, 10);
					SendClientMessage(playerid, GREY, "You bought 10 cigarretes from the prison store for $25.");
				}
				case 4:
				{
    				if(PlayerStat[playerid][Money] < 5) return SendClientMessage(playerid, GREY, "You don't have enough money.");
					if(PlayerStat[playerid][Paper] >= 25) return SendClientMessage(playerid, GREY, "You can't hold more then 25 Zigzag Rolling Papers.");
					PlayerStat[playerid][Paper]++;
					GiveMoney(playerid, -5);
					SendClientMessage(playerid, GREY, "You bought a piece of ZigZag Rolling Paper from the prison store for $5.");
				}
				case 5:
				{
    				if(PlayerStat[playerid][Money] < 20) return SendClientMessage(playerid, GREY, "You don't have enough money.");
					if(PlayerStat[playerid][Paper] >= 21) return SendClientMessage(playerid, GREY, "You can't hold more then 25 Zigzag Rolling Papers.");
					PlayerStat[playerid][Paper] += 5;
					GiveMoney(playerid, -20);
					SendClientMessage(playerid, GREY, "You bought a pack of ZigZag Rolling Paper from the prison store for $20.");
				}
				case 6:
				{
    				if(PlayerStat[playerid][Money] < 2) return SendClientMessage(playerid, GREY, "You don't have enough money.");
					if(PlayerStat[playerid][PlasticBags] >= 10) return SendClientMessage(playerid, GREY, "You can't hold more then 10 plastic bags.");
					PlayerStat[playerid][PlasticBags]++;
					GiveMoney(playerid, -2);
					SendClientMessage(playerid, GREY, "You bought a plastic bag from the prison store for $2.");
				}
				case 7:
				{
    				if(PlayerStat[playerid][Money] < 10) return SendClientMessage(playerid, GREY, "You don't have enough money.");
					if(PlayerStat[playerid][PlasticBags] >= 6) return SendClientMessage(playerid, GREY, "You can't hold more then 10 plastic bags.");
					PlayerStat[playerid][PlasticBags] += 5;
					GiveMoney(playerid, -10);
					SendClientMessage(playerid, GREY, "You bought a pack of plastic bags from the prison store for $10.");
				}
				case 8:
				{
    				if(PlayerStat[playerid][Money] < 2) return SendClientMessage(playerid, GREY, "You don't have enough money.");
					if(PlayerStat[playerid][Dices] >= 5) return SendClientMessage(playerid, GREY, "You can't hold more then 5 dices.");
					PlayerStat[playerid][Dices]++;
					GiveMoney(playerid, -2);
					SendClientMessage(playerid, GREY, "You bought a dice from the prison store for $2.");
				}
			}
        }
    }
    if(dialogid == DIALOG_BM0)
    {
		new str1[124];
        if(!response) return 1;
        else if(response)
        {
            switch(listitem)
        	{
				case 0:
				{
					format(str1, sizeof(str1), "Item\tBuy Price\tAmount\nCloth Piece\t$40\t%d\nWood Piece\t$80\t%d\nMetal Piece\t$100\t%d\nRefined Metal\t$600\t%d\nGun Piece\t$1500\t%d\n", SellerStat[1][Cloth], SellerStat[1][Wood], SellerStat[1][Metal], SellerStat[1][RMetal], SellerStat[1][GunP]);
					ShowPlayerDialog(playerid, DIALOG_BM1, DIALOG_STYLE_TABLIST_HEADERS, "Purchase", str1, "Buy", "Cancel");
				}
				case 1:
				{
					format(str1, sizeof(str1), "Item\tSell Price\tCurrent Amount\nCloth Piece\t$4\t%d\nWood Piece\t$6\t%d\nMetal Piece\t$8\t%d\nRefined Metal\t$40\t%d\nGun Piece\t$180\t%d\n", SellerStat[1][Cloth], SellerStat[1][Wood], SellerStat[1][Metal], SellerStat[1][RMetal], SellerStat[1][GunP]);
					ShowPlayerDialog(playerid, DIALOG_BM2, DIALOG_STYLE_TABLIST_HEADERS, "Sell", str1, "Buy", "Cancel");	
				}
			}
		}
	}
    if(dialogid == DIALOG_BM1) // Buying
    {
        if(!response) return 1;
        else if(response)
        {
            switch(listitem)
        	{
				case 0: // CLOTH
				{
					if(SellerStat[1][Cloth] == 0) return SendClientMessage(playerid, GREY, "This item has sold out, wait for other players to sell this item to the smuggler.");
					if(PlayerStat[playerid][Money] < 40) return SendClientMessage(playerid, GREY, "You don't have enough money.");
					if(GetFreeSlot(playerid) == 0) return SendClientMessage(playerid, GREY, "You don't have a free slot.");
					GiveItem(playerid, 6, 1);
					GiveMoney(playerid, -40);
					SellerStat[1][Cloth]--;
					SendClientMessage(playerid, WHITE, "You have purchased a cloth piece.");
				}
				case 1: // WOOD
				{
					if(SellerStat[1][Wood] == 0) return SendClientMessage(playerid, GREY, "This item has sold out, wait for other players to sell this item to the smuggler.");
					if(PlayerStat[playerid][Money] < 80) return SendClientMessage(playerid, GREY, "You don't have enough money.");
					if(GetFreeSlot(playerid) == 0) return SendClientMessage(playerid, GREY, "You don't have a free slot.");
					GiveItem(playerid, 7, 1);
					GiveMoney(playerid, -80);
					SellerStat[1][Wood]--;
					SendClientMessage(playerid, WHITE, "You have purchased a wood piece.");
				}
				case 2: // METAL
				{
					if(SellerStat[1][Metal] == 0) return SendClientMessage(playerid, GREY, "This item has sold out, wait for other players to sell this item to the smuggler.");
					if(PlayerStat[playerid][Money] < 100) return SendClientMessage(playerid, GREY, "You don't have enough money.");
					if(GetFreeSlot(playerid) == 0) return SendClientMessage(playerid, GREY, "You don't have a free slot.");
					GiveItem(playerid, 8, 1);
					GiveMoney(playerid, -100);
					SellerStat[1][Metal]--;
					SendClientMessage(playerid, WHITE, "You have purchased a metal sheet.");
				}
				case 3: // RMETAL
				{
					if(SellerStat[1][RMetal] == 0) return SendClientMessage(playerid, GREY, "This item has sold out, wait for other players to sell this item to the smuggler.");
					if(PlayerStat[playerid][Money] < 600) return SendClientMessage(playerid, GREY, "You don't have enough money.");
					if(GetFreeSlot(playerid) == 0) return SendClientMessage(playerid, GREY, "You don't have a free slot.");
					GiveItem(playerid, 9, 1);
					GiveMoney(playerid, -600);
					SellerStat[1][RMetal]--;
					SendClientMessage(playerid, WHITE, "You have purchased a refined metal.");
				}
				case 4: // GUNP
				{
					if(SellerStat[1][GunP] == 0) return SendClientMessage(playerid, GREY, "This item has sold out, wait for other players to sell this item to the smuggler.");
					if(PlayerStat[playerid][Money] < 1500) return SendClientMessage(playerid, GREY, "You don't have enough money.");
					if(GetFreeSlot(playerid) == 0) return SendClientMessage(playerid, GREY, "You don't have a free slot.");
					GiveItem(playerid, 10, 1);
					GiveMoney(playerid, -1500);
					SellerStat[1][GunP]--;
					SendClientMessage(playerid, WHITE, "You have purchased a gun piece.");
				}
			}
		}
	}
    if(dialogid == DIALOG_BM2) // Selling
    {
        if(!response) return 1;
        else if(response)
        {
            switch(listitem)
        	{
				case 0: // CLOTH
				{
					if(MatchItem(playerid, 6, 0) == 0) return SendClientMessage(playerid, GREY, "You don't have this item in your inventory.");
					GiveItem(playerid, 6, -1);
					GiveMoney(playerid, 4);
					SellerStat[1][Cloth]++;
					SendClientMessage(playerid, WHITE, "You have sold a cloth piece to the black market smuggler.");
				}
				case 1: // WOOD
				{
					if(MatchItem(playerid, 7, 0) == 0) return SendClientMessage(playerid, GREY, "You don't have this item in your inventory.");
					GiveItem(playerid, 7, -1);
					GiveMoney(playerid, 6);
					SellerStat[1][Wood]++;
					SendClientMessage(playerid, WHITE, "You have sold a wood piece to the black market smuggler.");
				}
				case 2: // METAL
				{
					if(MatchItem(playerid, 8, 0) == 0) return SendClientMessage(playerid, GREY, "You don't have this item in your inventory.");
					GiveItem(playerid, 8, -1);
					GiveMoney(playerid, 8);
					SellerStat[1][Metal]++;
					SendClientMessage(playerid, WHITE, "You have sold a metal sheet to the black market smuggler.");
				}
				case 3: // RMETAL
				{
					if(MatchItem(playerid, 9, 0) == 0) return SendClientMessage(playerid, GREY, "You don't have this item in your inventory.");
					GiveItem(playerid, 9, -1);
					GiveMoney(playerid, 40);
					SellerStat[1][RMetal]++;
					SendClientMessage(playerid, WHITE, "You have sold refined metal to the black market smuggler.");
				}
				case 4: // GUNP
				{
					if(MatchItem(playerid, 10, 0) == 0) return SendClientMessage(playerid, GREY, "You don't have this item in your inventory.");
					GiveItem(playerid, 10, -1);
					GiveMoney(playerid, 180);
					SellerStat[1][GunP]++;
					SendClientMessage(playerid, WHITE, "You have sold a gun piece to the black market smuggler.");
				}
			}
		}
	}
	return 1;
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	if(_:playertextid != INVALID_TEXT_DRAW) // If the player clicked a valid textdraw, continue with the coding. (_:var removes the Text: tag, to avoid tag mismatch)
	{
		new WeaponName[128];
		if(playertextid == ClothesShop4[playerid])
		{
			if(PlayerStat[playerid][Money] < 60) return SendClientMessage(playerid, GREY, "You don't have enough money.");
			new skin = GetPlayerSkin(playerid);
			PlayerStat[playerid][LastSkin] = skin;
			CurrentSkin[playerid] = skin;
			if(PlayerStat[playerid][DonLV] >= 2)
			{
				SendClientMessage(playerid, GREY, "You have successfully changed your clothes for free.");
			}
			else
			{
				SendClientMessage(playerid, GREY, "You have successfully changed your clothes for $60.");
				GiveMoney(playerid, -60);
			}
			PlayerTextDrawHide(playerid, ClothesShop1[playerid]);
			PlayerTextDrawHide(playerid, ClothesShop2[playerid]);
			PlayerTextDrawHide(playerid, ClothesShop3[playerid]);
			PlayerTextDrawHide(playerid, ClothesShop4[playerid]);
			PlayerTextDrawHide(playerid, ClothesShop5[playerid]);
			PlayerTextDrawHide(playerid, ClothesShop6[playerid]);
			PlayerTextDrawHide(playerid, ClothesShop7[playerid]);
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 10.0);
			CancelSelectTextDraw(playerid);
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, true);
			return 1;
		}
		if(playertextid == ClothesShop5[playerid])
		{
			SetPlayerSkin(playerid, CurrentSkin[playerid]);
			PlayerStat[playerid][LastSkin] = CurrentSkin[playerid];
			INI_Open(Accounts(playerid));
			INI_WriteInt("LastSkin", CurrentSkin[playerid]);
			INI_Save();
			INI_Close();
			PlayerTextDrawHide(playerid, ClothesShop1[playerid]);
			PlayerTextDrawHide(playerid, ClothesShop2[playerid]);
			PlayerTextDrawHide(playerid, ClothesShop3[playerid]);
			PlayerTextDrawHide(playerid, ClothesShop4[playerid]);
			PlayerTextDrawHide(playerid, ClothesShop5[playerid]);
			PlayerTextDrawHide(playerid, ClothesShop6[playerid]);
			PlayerTextDrawHide(playerid, ClothesShop7[playerid]);
			PlayerPlaySound(playerid, 1053, 0.0, 0.0, 10.0);
			CancelSelectTextDraw(playerid);
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, true);
			return 1;
		}
		if(playertextid == PRNID12[playerid])
		{
			PlayerTextDrawHide(playerid, PRNID01[playerid]);
			PlayerTextDrawHide(playerid, PRNID02[playerid]);
			PlayerTextDrawHide(playerid, PRNID03[playerid]);
			PlayerTextDrawHide(playerid, PRNID04[playerid]);
			PlayerTextDrawHide(playerid, PRNID05[playerid]);
			PlayerTextDrawHide(playerid, PRNID06[playerid]);
			PlayerTextDrawHide(playerid, PRNID07[playerid]);
			PlayerTextDrawHide(playerid, PRNID08[playerid]);
			PlayerTextDrawHide(playerid, PRNID09[playerid]);
			PlayerTextDrawHide(playerid, PRNID10[playerid]);
			PlayerTextDrawHide(playerid, PRNID11[playerid]);
			PlayerTextDrawHide(playerid, PRNID12[playerid]);
			CancelSelectTextDraw(playerid);
			return 1;
		}
		if(playertextid == ITM1_PIC_WEP[playerid])
		{
			PlayerPlaySound(playerid, 1027, 0.0, 0.0, 0.0);
			if(PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You are cuffed or being dragged.");
			new cWeapon = GetPlayerWeapon(playerid);
			if(cWeapon >= 1 || PlayerStat[playerid][WeaponPocketCD] >= 1) return SendClientMessage(playerid, GREY, "You already have a weapon in your hands.");
			if(INV_SEL_WEP[playerid] < 12 || INV_SEL_WEP[playerid] >= 13)
			{
				if(INV_SEL_WEP[playerid] <= 10 || INV_SEL_WEP[playerid] >= 13)
				{
					PlayerTextDrawSetPreviewModel(playerid, INV_PRV_IMG[playerid], GetWeapModel(PlayerStat[playerid][WeaponSlot0]));
					PlayerTextDrawShow(playerid, INV_PRV_IMG[playerid]);
					GetWeaponName(PlayerStat[playerid][WeaponSlot0], WeaponName, sizeof(WeaponName));
					PlayerTextDrawSetString(playerid, INV_PRV_STR[playerid], WeaponName);
					PlayerTextDrawShow(playerid, INV_PRV_STR[playerid]);
					INV_SEL_WEP[playerid] = 10;
				}
				INV_SEL_WEP[playerid]++;
				INV_SEL_ITM[playerid] = 0;
			}
			else if(INV_SEL_WEP[playerid] == 12)
			{
				if(PlayerStat[playerid][WeaponSlot0] == 0) return SendClientMessage(playerid, GREY, "You don't have a weapon in that slot.");
				ServerWeapon(playerid, PlayerStat[playerid][WeaponSlot0], PlayerStat[playerid][WeaponSlot0Ammo]);
				INI_Open(Accounts(playerid));
				INI_WriteInt("WeaponSlot0", 0); 
				INI_WriteInt("WeaponSlot0Ammo", 0);
				INI_Save();
				INI_Close();
				PlayerStat[playerid][WeaponSlot0] = 0;
				PlayerStat[playerid][WeaponSlot0Ammo] = 0;
				PlayerStat[playerid][WeaponPocketCD] = 4;
				SendClientMessage(playerid, WHITE, "You have withdrawn a weapon from slot 1.");
				RemovePlayerAttachedObject(playerid, 6);
				PlayerTextDrawHide(playerid, ITM1_PIC_WEP[playerid]);
				PlayerTextDrawHide(playerid, ITM1_STR_AMMO[playerid]);
				PlayerTextDrawHide(playerid, ITM1_STR_NAME[playerid]);
				PlayerTextDrawHide(playerid, INV_PRV_IMG[playerid]);
				PlayerTextDrawHide(playerid, INV_PRV_STR[playerid]);
				INV_SEL_ITM[playerid] = 0;
				INV_SEL_WEP[playerid] = 0;
			}
		}
		if(playertextid == ITM2_PIC_WEP[playerid])
		{
			PlayerPlaySound(playerid, 1027, 0.0, 0.0, 0.0);
			if(PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You are cuffed or being dragged.");
			new cWeapon = GetPlayerWeapon(playerid);
			if(cWeapon >= 1 || PlayerStat[playerid][WeaponPocketCD] >= 1) return SendClientMessage(playerid, GREY, "You already have a weapon in your hands.");
			if(INV_SEL_WEP[playerid] < 22 || INV_SEL_WEP[playerid] >= 23)
			{
				if(INV_SEL_WEP[playerid] <= 20 || INV_SEL_WEP[playerid] >= 23)
				{
					PlayerTextDrawSetPreviewModel(playerid, INV_PRV_IMG[playerid], GetWeapModel(PlayerStat[playerid][WeaponSlot1]));
					PlayerTextDrawShow(playerid, INV_PRV_IMG[playerid]);
					GetWeaponName(PlayerStat[playerid][WeaponSlot1], WeaponName, sizeof(WeaponName));
					PlayerTextDrawSetString(playerid, INV_PRV_STR[playerid], WeaponName);
					PlayerTextDrawShow(playerid, INV_PRV_STR[playerid]);
					INV_SEL_WEP[playerid] = 20;
				}
				INV_SEL_WEP[playerid]++;
				INV_SEL_ITM[playerid] = 0;
			}
			else if(INV_SEL_WEP[playerid] == 22)
			{
				if(PlayerStat[playerid][WeaponSlot1] == 0) return SendClientMessage(playerid, GREY, "You don't have a weapon in that slot.");
				ServerWeapon(playerid, PlayerStat[playerid][WeaponSlot1], PlayerStat[playerid][WeaponSlot1Ammo]);
				INI_Open(Accounts(playerid));
				INI_WriteInt("WeaponSlot1", 0); 
				INI_WriteInt("WeaponSlot1Ammo", 0);
				INI_Save();
				INI_Close();
				PlayerStat[playerid][WeaponSlot1] = 0;
				PlayerStat[playerid][WeaponSlot1Ammo] = 0;
				PlayerStat[playerid][WeaponPocketCD] = 4;
				SendClientMessage(playerid, WHITE, "You have withdrawn a weapon from slot 2.");
				RemovePlayerAttachedObject(playerid, 7);
				PlayerTextDrawHide(playerid, ITM2_PIC_WEP[playerid]);
				PlayerTextDrawHide(playerid, ITM2_STR_AMMO[playerid]);
				PlayerTextDrawHide(playerid, ITM2_STR_NAME[playerid]);
				PlayerTextDrawHide(playerid, INV_PRV_IMG[playerid]);
				PlayerTextDrawHide(playerid, INV_PRV_STR[playerid]);
				INV_SEL_ITM[playerid] = 0;
				INV_SEL_WEP[playerid] = 0;
			}
		}
		if(playertextid == ITM3_PIC_WEP[playerid])
		{
			PlayerPlaySound(playerid, 1027, 0.0, 0.0, 0.0);
			if(PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You are cuffed or being dragged.");
			new cWeapon = GetPlayerWeapon(playerid);
			if(cWeapon >= 1 || PlayerStat[playerid][WeaponPocketCD] >= 1) return SendClientMessage(playerid, GREY, "You already have a weapon in your hands.");
			if(INV_SEL_WEP[playerid] < 32 || INV_SEL_WEP[playerid] >= 33)
			{
				if(INV_SEL_WEP[playerid] <= 30 || INV_SEL_WEP[playerid] >= 33)
				{
					PlayerTextDrawSetPreviewModel(playerid, INV_PRV_IMG[playerid], GetWeapModel(PlayerStat[playerid][WeaponSlot2]));
					PlayerTextDrawShow(playerid, INV_PRV_IMG[playerid]);
					GetWeaponName(PlayerStat[playerid][WeaponSlot2], WeaponName, sizeof(WeaponName));
					PlayerTextDrawSetString(playerid, INV_PRV_STR[playerid], WeaponName);
					PlayerTextDrawShow(playerid, INV_PRV_STR[playerid]);
					INV_SEL_WEP[playerid] = 30;
				}
				INV_SEL_WEP[playerid]++;
				INV_SEL_ITM[playerid] = 0;
			}
			else if(INV_SEL_WEP[playerid] == 32)
			{
				if(PlayerStat[playerid][DonLV] <= 2) return SendClientMessage(playerid, GREY, "You have to be a golden donator (level 3) in order to pocket and pull weapons from this slot.");
				if(PlayerStat[playerid][WeaponSlot2] == 0) return SendClientMessage(playerid, GREY, "You don't have a weapon in that slot.");
				ServerWeapon(playerid, PlayerStat[playerid][WeaponSlot2], PlayerStat[playerid][WeaponSlot2Ammo]);
				INI_Open(Accounts(playerid));
				INI_WriteInt("WeaponSlot2", 0); 
				INI_WriteInt("WeaponSlot2Ammo", 0);
				INI_Save();
				INI_Close();
				PlayerStat[playerid][WeaponSlot2] = 0;
				PlayerStat[playerid][WeaponSlot2Ammo] = 0;
				PlayerStat[playerid][WeaponPocketCD] = 4;
				SendClientMessage(playerid, WHITE, "You have withdrawn a weapon from slot 3.");
				RemovePlayerAttachedObject(playerid, 8);
				PlayerTextDrawHide(playerid, ITM3_PIC_WEP[playerid]);
				PlayerTextDrawHide(playerid, ITM3_STR_AMMO[playerid]);
				PlayerTextDrawHide(playerid, ITM3_STR_NAME[playerid]);
				PlayerTextDrawHide(playerid, INV_PRV_IMG[playerid]);
				PlayerTextDrawHide(playerid, INV_PRV_STR[playerid]);
				INV_SEL_ITM[playerid] = 0;
				INV_SEL_WEP[playerid] = 0;
			}
		}
		if(playertextid == INV_USE_BTN[playerid])
		{
			if(INV_SEL_ITM[playerid] >= 1)
			{
				PlayerPlaySound(playerid, 	1054, 0.0, 0.0, 0.0);
				UseItem(playerid, INV_SEL_ITM[playerid]);
			}
			return 1;
		}
		if(playertextid == INV_DROP_BTN[playerid])
		{
			if(INV_SEL_ITM[playerid] >= 1)
			{
				PlayerPlaySound(playerid, 	1054, 0.0, 0.0, 0.0);
				DropItem(playerid, INV_SEL_ITM[playerid]);
				INV_SEL_ITM[playerid] = 0;
				INV_SEL_WEP[playerid] = 0;
			}
			return 1;
		}
		if(playertextid == INV_CRAFT_BTN[playerid])
		{
			INV_SEL_WEP[playerid] = 0;
			PlayerPlaySound(playerid, 6400, 0.0, 0.0, 0.0);
			if(pCraftWindow[playerid] == 0)
			{
				ShowCrafting(playerid);
				pCraftWindow[playerid] = 1;
				return 1;
			}
			if(pCraftWindow[playerid] == 1)
			{
				CloseCrafting(playerid);
				pCraftWindow[playerid] = 0;
			}
			return 1;
		}
		if(playertextid == CRF_CRF_BTN[playerid])
		{
			INV_SEL_WEP[playerid] = 0;
			SendClientMessage(playerid, WHITE, "Clicked on craft.");
			return 1;
		}
		if(playertextid == INV_SLOT1_IMG[playerid])
		{
			INV_SEL_WEP[playerid] = 0;
			PlayerPlaySound(playerid, 1027, 0.0, 0.0, 0.0);
			PlayerTextDrawSetPreviewModel(playerid, INV_PRV_IMG[playerid], GetItemModel(PlayerStat[playerid][INV_SLOT1]));
			PlayerTextDrawShow(playerid, INV_PRV_IMG[playerid]);
			PlayerTextDrawSetString(playerid, INV_PRV_STR[playerid], GetItemName(PlayerStat[playerid][INV_SLOT1]));
			PlayerTextDrawShow(playerid, INV_PRV_STR[playerid]);
			INV_SEL_ITM[playerid] = PlayerStat[playerid][INV_SLOT1];
			return 1;
		}
		if(playertextid == INV_SLOT2_IMG[playerid])
		{
			INV_SEL_WEP[playerid] = 0;
			PlayerPlaySound(playerid, 1027, 0.0, 0.0, 0.0);
			PlayerTextDrawSetPreviewModel(playerid, INV_PRV_IMG[playerid], GetItemModel(PlayerStat[playerid][INV_SLOT2]));
			PlayerTextDrawShow(playerid, INV_PRV_IMG[playerid]);
			PlayerTextDrawSetString(playerid, INV_PRV_STR[playerid], GetItemName(PlayerStat[playerid][INV_SLOT2]));
			PlayerTextDrawShow(playerid, INV_PRV_STR[playerid]);
			INV_SEL_ITM[playerid] = PlayerStat[playerid][INV_SLOT2];
			return 1;
		}
		if(playertextid == INV_SLOT3_IMG[playerid])
		{
			INV_SEL_WEP[playerid] = 0;
			PlayerPlaySound(playerid, 1027, 0.0, 0.0, 0.0);
			PlayerTextDrawSetPreviewModel(playerid, INV_PRV_IMG[playerid], GetItemModel(PlayerStat[playerid][INV_SLOT3]));
			PlayerTextDrawShow(playerid, INV_PRV_IMG[playerid]);
			PlayerTextDrawSetString(playerid, INV_PRV_STR[playerid], GetItemName(PlayerStat[playerid][INV_SLOT3]));
			PlayerTextDrawShow(playerid, INV_PRV_STR[playerid]);
			INV_SEL_ITM[playerid] = PlayerStat[playerid][INV_SLOT3];
			return 1;
		}
		if(playertextid == INV_SLOT4_IMG[playerid])
		{
			INV_SEL_WEP[playerid] = 0;
			PlayerPlaySound(playerid, 1027, 0.0, 0.0, 0.0);
			PlayerTextDrawSetPreviewModel(playerid, INV_PRV_IMG[playerid], GetItemModel(PlayerStat[playerid][INV_SLOT4]));
			PlayerTextDrawShow(playerid, INV_PRV_IMG[playerid]);
			PlayerTextDrawSetString(playerid, INV_PRV_STR[playerid], GetItemName(PlayerStat[playerid][INV_SLOT4]));
			PlayerTextDrawShow(playerid, INV_PRV_STR[playerid]);
			INV_SEL_ITM[playerid] = PlayerStat[playerid][INV_SLOT4];
			return 1;
		}
		if(playertextid == INV_SLOT5_IMG[playerid])
		{
			INV_SEL_WEP[playerid] = 0;
			PlayerPlaySound(playerid, 1027, 0.0, 0.0, 0.0);
			PlayerTextDrawSetPreviewModel(playerid, INV_PRV_IMG[playerid], GetItemModel(PlayerStat[playerid][INV_SLOT5]));
			PlayerTextDrawShow(playerid, INV_PRV_IMG[playerid]);
			PlayerTextDrawSetString(playerid, INV_PRV_STR[playerid], GetItemName(PlayerStat[playerid][INV_SLOT5]));
			PlayerTextDrawShow(playerid, INV_PRV_STR[playerid]);
			INV_SEL_ITM[playerid] = PlayerStat[playerid][INV_SLOT5];
			return 1;
		}
		if(playertextid == INV_SLOT6_IMG[playerid])
		{
			INV_SEL_WEP[playerid] = 0;
			PlayerPlaySound(playerid, 1027, 0.0, 0.0, 0.0);
			PlayerTextDrawSetPreviewModel(playerid, INV_PRV_IMG[playerid], GetItemModel(PlayerStat[playerid][INV_SLOT6]));
			PlayerTextDrawShow(playerid, INV_PRV_IMG[playerid]);
			PlayerTextDrawSetString(playerid, INV_PRV_STR[playerid], GetItemName(PlayerStat[playerid][INV_SLOT6]));
			PlayerTextDrawShow(playerid, INV_PRV_STR[playerid]);
			INV_SEL_ITM[playerid] = PlayerStat[playerid][INV_SLOT6];
			return 1;
		}
		if(playertextid == INV_SLOT7_IMG[playerid])
		{
			INV_SEL_WEP[playerid] = 0;
			PlayerPlaySound(playerid, 1027, 0.0, 0.0, 0.0);
			PlayerTextDrawSetPreviewModel(playerid, INV_PRV_IMG[playerid], GetItemModel(PlayerStat[playerid][INV_SLOT7]));
			PlayerTextDrawShow(playerid, INV_PRV_IMG[playerid]);
			PlayerTextDrawSetString(playerid, INV_PRV_STR[playerid], GetItemName(PlayerStat[playerid][INV_SLOT7]));
			PlayerTextDrawShow(playerid, INV_PRV_STR[playerid]);
			INV_SEL_ITM[playerid] = PlayerStat[playerid][INV_SLOT7];
			return 1;
		}
		if(playertextid == INV_SLOT8_IMG[playerid])
		{
			INV_SEL_WEP[playerid] = 0;
			PlayerPlaySound(playerid, 1027, 0.0, 0.0, 0.0);
			PlayerTextDrawSetPreviewModel(playerid, INV_PRV_IMG[playerid], GetItemModel(PlayerStat[playerid][INV_SLOT8]));
			PlayerTextDrawShow(playerid, INV_PRV_IMG[playerid]);
			PlayerTextDrawSetString(playerid, INV_PRV_STR[playerid], GetItemName(PlayerStat[playerid][INV_SLOT8]));
			PlayerTextDrawShow(playerid, INV_PRV_STR[playerid]);
			INV_SEL_ITM[playerid] = PlayerStat[playerid][INV_SLOT8];
			return 1;
		}
		if(playertextid == INV_SLOT9_IMG[playerid])
		{
			INV_SEL_WEP[playerid] = 0;
			PlayerPlaySound(playerid, 1027, 0.0, 0.0, 0.0);
			PlayerTextDrawSetPreviewModel(playerid, INV_PRV_IMG[playerid], GetItemModel(PlayerStat[playerid][INV_SLOT9]));
			PlayerTextDrawShow(playerid, INV_PRV_IMG[playerid]);
			PlayerTextDrawSetString(playerid, INV_PRV_STR[playerid], GetItemName(PlayerStat[playerid][INV_SLOT9]));
			PlayerTextDrawShow(playerid, INV_PRV_STR[playerid]);
			INV_SEL_ITM[playerid] = PlayerStat[playerid][INV_SLOT9];
			return 1;
		}
		if(playertextid == INV_SLOT10_IMG[playerid])
		{
			INV_SEL_WEP[playerid] = 0;
			PlayerPlaySound(playerid, 1027, 0.0, 0.0, 0.0);
			PlayerTextDrawSetPreviewModel(playerid, INV_PRV_IMG[playerid], GetItemModel(PlayerStat[playerid][INV_SLOT10]));
			PlayerTextDrawShow(playerid, INV_PRV_IMG[playerid]);
			PlayerTextDrawSetString(playerid, INV_PRV_STR[playerid], GetItemName(PlayerStat[playerid][INV_SLOT10]));
			PlayerTextDrawShow(playerid, INV_PRV_STR[playerid]);
			INV_SEL_ITM[playerid] = PlayerStat[playerid][INV_SLOT10];
			return 1;
		}
		if(playertextid == INV_CLO_BUT[playerid])
		{
			INV_SEL_WEP[playerid] = 0;
			PlayerPlaySound(playerid, 1055, 0.0, 0.0, 0.0);
			CloseInventory(playerid);
			CloseCrafting(playerid);
			pCraftWindow[playerid] = 0;
			INV_SEL_ITM[playerid] = 0;
			CancelSelectTextDraw(playerid);
			return 1;
		}
	}
	return 1;
}

public Teleport(playerid, type)
{
    new Hour, Minute, Second;
    gettime(Hour, Minute, Second);
    switch(type)
    {
	    case 1:
		{
			SetPlayerTime(playerid, Hour, 0);
			InPrison[playerid] = 0;
		    SetPlayerPos(playerid, 287.3577, 1410.1254, 10.3931);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			TogglePlayerControllable(playerid, 0);
			GameTextForPlayer(playerid, "~w~ Prison Gate", 3000, 4);
			SetTimerEx("LoadingObjects", 1500, false, "d", playerid);
		}
		case 2:
		{
			SetPlayerTime(playerid, Hour, 0);
			InPrison[playerid] = 0;
		    SetPlayerPos(playerid, 268.0754, 1474.0994, 11.6881);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			TogglePlayerControllable(playerid, 0);
			GameTextForPlayer(playerid, "~w~ Basket Ball Field", 3000, 4);
			SetTimerEx("LoadingObjects", 1500, false, "d", playerid);
		}
		case 3:
		{
		    SetPlayerPos(playerid, 469.05, 1621.814, 994.856);
			SetPlayerInterior(playerid, 0);
			SetPlayerTime(playerid, 7, 0);
			InPrison[playerid] = 1;
			SetPlayerVirtualWorld(playerid, 0);
			TogglePlayerControllable(playerid, 0);
			GameTextForPlayer(playerid, "~w~ Prison Sewer", 3000, 4);
			SetTimerEx("LoadingObjects", 2500, false, "d", playerid);
		}
        case 4:
        {
			SetPlayerInterior(playerid, 0);
			SetPlayerTime(playerid, 7, 0);
			InPrison[playerid] = 1;
		    SetPlayerPos(playerid, 439.8091, 1640.0763, 1001.0000);
			SetPlayerVirtualWorld(playerid, 0);
			TogglePlayerControllable(playerid, 0);
			GameTextForPlayer(playerid, "~w~ Cafeteria", 3000, 4);
			SetTimerEx("LoadingObjects", 2500, false, "d", playerid);
		}
        case 5:
		{
			SetPlayerInterior(playerid, 0);
			SetPlayerTime(playerid, 7, 0);
			InPrison[playerid] = 1;
		    SetPlayerPos(playerid, 477.1134, 1524.9293, 1003.8422);
			SetPlayerVirtualWorld(playerid, 0);
			TogglePlayerControllable(playerid, 0);
			GameTextForPlayer(playerid, "~w~ Prison Guards HQ", 3000, 4);
			SetTimerEx("LoadingObjects", 3000, false, "d", playerid);
		}
		case 6:
		{
			SetPlayerTime(playerid, 7, 0);
			InPrison[playerid] = 1;
			SetPlayerPos(playerid, 419.0964, 1554.5037, 1001.0000);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			TogglePlayerControllable(playerid, 0);
			GameTextForPlayer(playerid, "~w~ Prison Clinic", 3000, 4);
			SetTimerEx("LoadingObjects", 3000, false, "d", playerid);
		}
		case 7:
		{
			SetPlayerTime(playerid, Hour, 0);
			InPrison[playerid] = 0;
			SetPlayerPos(playerid, 252.0012, 1421.1416, 16.4757);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			TogglePlayerControllable(playerid, 0);
			GameTextForPlayer(playerid, "~w~ Yard Control Room", 3000, 4);
			SetTimerEx("LoadingObjects", 2000, false, "d", playerid);
		}
		case 8:
		{
			SetPlayerTime(playerid, Hour, 0);
			InPrison[playerid] = 0;
			SetPlayerPos(playerid, 1536.2251,-1675.9830,13.3828);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			TogglePlayerControllable(playerid, 0);
			GameTextForPlayer(playerid, "You have been sent to Los Santos.", 3000, 4);
			SetTimerEx("LoadingObjects", 1000, false, "d", playerid);
		}
    }
    return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}


//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

public NewPlayerData(playerid)
{
    if(INI_Open(Accounts(playerid)))
    {
        new Hour, Minute, Second;
	   	new Day, Month, Year;
        gettime(Hour, Minute, Second);
        getdate(Year, Month, Day);
        GetPlayerIp(playerid, PlayerStat[playerid][LastIP], 21);

        PlayerStat[playerid][LastLoginSecond] = Second;
        PlayerStat[playerid][LastLoginMinute] = Minute;
        PlayerStat[playerid][LastLoginHour] = Hour;
        PlayerStat[playerid][LastLoginDay] = Day;
        PlayerStat[playerid][LastLoginMonth] = Month;
        PlayerStat[playerid][LastLoginYear] = Year;

        INI_WriteInt("FullyRegistered",0);

        INI_WriteInt("Age",0);
        INI_WriteInt("Gender",1);
        INI_WriteInt("PlayingHours",0);
        INI_WriteString("LastIP",PlayerStat[playerid][LastIP]);
		INI_WriteInt("PlayingMinutes",0);

        INI_WriteInt("Money",350);
        INI_WriteInt("Paycheck",0);
        INI_WriteInt("LockerMoney",1000);
        INI_WriteInt("LastSkin",50);
        INI_WriteString("Reason","Nothing");
        INI_WriteString("Accent","American");

        INI_WriteFloat("LastX",1807.8798);
        INI_WriteFloat("LastY",-1573.3700);
        INI_WriteFloat("LastZ",1738.7667);
        INI_WriteFloat("LastA",270.7746);
        INI_WriteInt("LastInt",0);
        INI_WriteInt("LastVW",0);

        INI_WriteInt("TogOOC",0);
        INI_WriteInt("TogPM",0);

        INI_WriteInt("JobID",0);
        INI_WriteInt("HoursInJob",0);
        INI_WriteInt("AbleToCollectGarbage",1);
        INI_WriteInt("AbleToCleanTables",1);
        INI_WriteInt("AbleToCollectFood",1);
        INI_WriteInt("JobID1ReloadTime",0);
        INI_WriteInt("JobID2ReloadTime",0);
        INI_WriteInt("JobID3ReloadTime",0);
        INI_WriteInt("JobID4ReloadTime",0);
        INI_WriteInt("JobID4CHP",0);
        INI_WriteInt("JobID4BOX",0);

        INI_WriteInt("AdminLevel",0);
		INI_WriteString("AdminCode","aijfaisjfaisfaisfafnskanf123123");
		INI_WriteInt("AdminLogged",0);
        INI_WriteInt("Muted",0);
        INI_WriteInt("MuteTime",0);
        INI_WriteInt("AdminPrisoned",0);
		INI_WriteInt("AdminPrisonedTime",0);
		INI_WriteInt("Banned",0);
		INI_WriteInt("TimesKicked",0);
		INI_WriteInt("TimesBanned",0);
        INI_WriteInt("Warnings",0);
        INI_WriteString("Warn1","None");
        INI_WriteString("Warn2","None");
		INI_WriteString("BannedReason","None");
		INI_WriteInt("HelpmesAnswered",0);

        INI_WriteInt("HelperLevel",0);
        INI_WriteInt("hMuted",0);
        INI_WriteInt("HelpmeReloadTime", 0);


		INI_WriteInt("LastLoginSecond",PlayerStat[playerid][LastLoginSecond]);
        INI_WriteInt("LastLoginMinute",PlayerStat[playerid][LastLoginMinute]);
        INI_WriteInt("LastLoginHour",PlayerStat[playerid][LastLoginHour]);
        INI_WriteInt("LastLoginDay",PlayerStat[playerid][LastLoginDay]);
        INI_WriteInt("LastLoginMonth",PlayerStat[playerid][LastLoginMonth]);
        INI_WriteInt("LastLoginYear",PlayerStat[playerid][LastLoginYear]);

        INI_WriteInt("GangID",0);
		INI_WriteInt("GangRank",0);
		INI_WriteInt("GetWeapReloadTime", 0);
        INI_WriteInt("GetDrugsReloadTime", 0);
        INI_WriteInt("Pot", 0);
        INI_WriteInt("Crack", 0);
        INI_WriteInt("Slot0", 0);
        INI_WriteInt("Slot1", 0);
        INI_WriteInt("Slot2", 0);
        INI_WriteInt("Slot3", 0);
		INI_WriteInt("Slot4", 0);
		INI_WriteInt("Slot5", 0);
		INI_WriteInt("Slot6", 0);
		INI_WriteInt("Slot7", 0);
		INI_WriteInt("Slot8", 0);
		INI_WriteInt("Slot9", 0);
		INI_WriteInt("Slot10", 0);
		INI_WriteInt("Slot11", 0);
		INI_WriteInt("UsingCrackReloadTime",0);
		INI_WriteInt("UsingPotReloadTime",0);

        INI_WriteInt("FactionID",0);
		INI_WriteInt("FactionRank",0);
		INI_WriteInt("Cuffed",0);
		INI_WriteInt("Tased",0);
		INI_WriteInt("InIsolatedCell",0);
		INI_WriteInt("InIsolatedCellTime",0);

		INI_WriteFloat("Health",100);
		INI_WriteFloat("Armour",0);
		INI_WriteFloat("DeathPosX",0.0);
		INI_WriteFloat("DeathPosY",0.0);
		INI_WriteFloat("DeathPosZ",0.0);
		INI_WriteInt("DeathWeapon",0);
		INI_WriteInt("DeathAmmo",0);
		INI_WriteInt("Dead",0);
		INI_WriteInt("InHospital",0);
		INI_WriteInt("Deaths",0);
		INI_WriteInt("Kills",0);
		
		INI_WriteInt("StatPWR",0);
		INI_WriteInt("StatINT",0);

		INI_WriteInt("Lighter",0);
		INI_WriteInt("Paper",0);
		INI_WriteInt("Cigars",0);
		INI_WriteInt("Dices",0);
		INI_WriteInt("PlasticBags",0);

        INI_WriteInt("HasCell", 0);
		INI_WriteInt("Cell",-1);
		INI_WriteInt("DonLV",0);
		INI_WriteInt("Aname",0);
		INI_WriteInt("DeathT",0);
		INI_WriteInt("ADuty",0);
		INI_WriteInt("HDuty",0);
		INI_WriteInt("Joint",0);
		INI_WriteInt("JRACD",0);
		INI_WriteInt("JRCD",0);
		INI_WriteInt("JSCD",0);
		INI_WriteInt("CUCD",0);
		INI_WriteInt("CSCD",0);
		INI_WriteInt("BPUSE",0);
		INI_WriteInt("BPDIF",0);
		INI_WriteInt("BPCD",0);
		INI_WriteInt("BPACD",0);
		INI_WriteInt("BPANM",1);
		INI_WriteInt("BPNMB",0);
		INI_WriteInt("BPBAR",0);
		INI_WriteInt("LogoutCuffs",0);
		INI_WriteInt("BleedingWound",0);
		INI_WriteString("Answer1","None");
		INI_WriteString("Answer2","None");
		INI_WriteString("Answer3","None");
		INI_WriteString("Answer4","None");
		INI_WriteString("Answer5","None");
		INI_WriteInt("NameChangeTicket",0);
		INI_WriteInt("WeaponSlot0", 0);
		INI_WriteInt("WeaponSlot1", 0);
		INI_WriteInt("WeaponSlot2", 0);
		INI_WriteInt("WeaponSlot0Ammo", 0);
		INI_WriteInt("WeaponSlot1Ammo", 0);
		INI_WriteInt("WeaponSlot2Ammo", 0);
		INI_WriteInt("WeaponPocketCD", 0);
		INI_WriteInt("FightStyle",4);
		INI_WriteInt("INV_SLOT1", 0);
		INI_WriteInt("INV_SLOT1A", 0);
		INI_WriteInt("INV_SLOT2", 0);
		INI_WriteInt("INV_SLOT2A", 0);
		INI_WriteInt("INV_SLOT3", 0);
		INI_WriteInt("INV_SLOT3A", 0);
		INI_WriteInt("INV_SLOT4", 0);
		INI_WriteInt("INV_SLOT4A", 0);
		INI_WriteInt("INV_SLOT5", 0);
		INI_WriteInt("INV_SLOT5A", 0);
		INI_WriteInt("INV_SLOT6", 0);
		INI_WriteInt("INV_SLOT6A", 0);
		INI_WriteInt("INV_SLOT7", 0);
		INI_WriteInt("INV_SLOT7A", 0);
		INI_WriteInt("INV_SLOT8", 0);
		INI_WriteInt("INV_SLOT8A", 0);
		INI_WriteInt("INV_SLOT9", 0);
		INI_WriteInt("INV_SLOT9A", 0);
		INI_WriteInt("INV_SLOT10", 0);
		INI_WriteInt("INV_SLOT10A", 0);
		INI_WriteInt("MetSkill", 0);
		INI_WriteInt("WodSkill", 0);
		INI_WriteInt("CrfSkill", 0);
		INI_WriteInt("MetSkillXP", 0);
		INI_WriteInt("WodSkillXP", 0);
		INI_WriteInt("CrfSkillXP", 0);

        INI_Save();
        INI_Close();
    }
	return 1;
}

public StopAudio()
{
	new playerid;
    StopAudioStreamForPlayer(playerid);
    return 1;
}

forward DisableAnim(playerid);
public DisableAnim()
{
	new targetid;
	ClearAnimations(targetid);
    return 1;
}

forward AntiPayCheckSpamT(playerid);
public AntiPayCheckSpamT(playerid)
{
	AntiPayCheckSpam[playerid] = 0;
	return 1;
}

forward GateCoolDown();
public GateCoolDown()
{
	prisongateclickable = 1;
	return 1;
}

forward StopPlayingAllSounds(playerid);
public StopPlayingAllSounds(playerid)
{
	PlayerPlaySound(playerid, 0, 0, 0, 0);
	PlayerPlaySound(playerid, 1098, 0, 0, 0);
	return 1;
}

public SavePlayerData(playerid)
{
	new Float:DArmour, Float:DHealth;
	GetPlayerHealth(playerid, Float:DHealth);
	GetPlayerArmour(playerid, Float:DArmour);
	if(PlayerStat[playerid][Logged] == 1)
	{
		if(INI_Open(Accounts(playerid)))
		{
            INI_WriteInt("Age",PlayerStat[playerid][Age]);
            INI_WriteInt("Gender",PlayerStat[playerid][Gender]);
            INI_WriteInt("PlayingHours",PlayerStat[playerid][PlayingHours]);
            INI_WriteString("LastIP",PlayerStat[playerid][LastIP]);
            INI_WriteInt("Money",PlayerStat[playerid][Money]);
			
            INI_WriteInt("Paycheck",PlayerStat[playerid][Paycheck]);
            INI_WriteInt("LockerMoney",PlayerStat[playerid][LockerMoney]);
			INI_WriteInt("PlayingMinutes",PlayerStat[playerid][PlayingMinutes]);
            INI_WriteInt("LastSkin",PlayerStat[playerid][LastSkin]);
            INI_WriteString("Reason",PlayerStat[playerid][Reason]);
            INI_WriteString("Accent",PlayerStat[playerid][Accent]);

            GetPlayerPos(playerid, PlayerStat[playerid][LastX], PlayerStat[playerid][LastY], PlayerStat[playerid][LastZ]);
		    GetPlayerFacingAngle(playerid, PlayerStat[playerid][LastA]);
		    PlayerStat[playerid][LastInt] = GetPlayerInterior(playerid);
		    PlayerStat[playerid][LastVW] = GetPlayerVirtualWorld(playerid);

            INI_WriteFloat("LastX",PlayerStat[playerid][LastX]);
            INI_WriteFloat("LastY",PlayerStat[playerid][LastY]);
            INI_WriteFloat("LastZ",PlayerStat[playerid][LastZ]);
            INI_WriteFloat("LastA",PlayerStat[playerid][LastA]);
            INI_WriteInt("LastInt",PlayerStat[playerid][LastInt]);
            INI_WriteInt("LastVW",PlayerStat[playerid][LastVW]);

            INI_WriteInt("FullyRegistered",PlayerStat[playerid][FullyRegistered]);
            INI_WriteInt("TogOOC",PlayerStat[playerid][TogOOC]);
            INI_WriteInt("TogPM",PlayerStat[playerid][TogPM]);

            INI_WriteInt("JobID",PlayerStat[playerid][JobID]);
            INI_WriteInt("HoursInJob",PlayerStat[playerid][HoursInJob]);
            INI_WriteInt("AbleToCollectGarbage",PlayerStat[playerid][AbleToCollectGarbage]);
            INI_WriteInt("AbleToCleanTables",PlayerStat[playerid][AbleToCleanTables]);
            INI_WriteInt("AbleToCollectFood",PlayerStat[playerid][AbleToCollectFood]);
            INI_WriteInt("JobID1ReloadTime",PlayerStat[playerid][JobID1ReloadTime]);
            INI_WriteInt("JobID2ReloadTime",PlayerStat[playerid][JobID2ReloadTime]);
            INI_WriteInt("JobID3ReloadTime",PlayerStat[playerid][JobID3ReloadTime]);
            INI_WriteInt("JobID4ReloadTime",PlayerStat[playerid][JobID4ReloadTime]);
            INI_WriteInt("JobID4CHP",PlayerStat[playerid][JobID4CHP]);
			INI_WriteInt("JobID4BOX",PlayerStat[playerid][JobID4BOX]);

            INI_WriteInt("AdminLevel",PlayerStat[playerid][AdminLevel]);
			INI_WriteString("AdminCode",PlayerStat[playerid][AdminCode]);
			INI_WriteInt("AdminLogged",0);
            INI_WriteInt("Muted",PlayerStat[playerid][Muted]);
            INI_WriteInt("MuteTime",PlayerStat[playerid][MuteTime]);
            INI_WriteInt("AdminPrisoned",PlayerStat[playerid][AdminPrisoned]);
		    INI_WriteInt("AdminPrisonedTime",PlayerStat[playerid][AdminPrisonedTime]);
			INI_WriteInt("Banned",PlayerStat[playerid][Banned]);
			INI_WriteInt("TimesKicked",PlayerStat[playerid][TimesKicked]);
		    INI_WriteInt("TimesBanned",PlayerStat[playerid][TimesBanned]);
            INI_WriteInt("Warnings",PlayerStat[playerid][Warnings]);
            INI_WriteString("Warn1",PlayerStat[playerid][Warn1]);
            INI_WriteString("Warn2",PlayerStat[playerid][Warn2]);
			INI_WriteString("BannedReason",PlayerStat[playerid][BannedReason]);
			INI_WriteInt("HelpmesAnswered",PlayerStat[playerid][HelpmesAnswered]);

            INI_WriteInt("HelperLevel",PlayerStat[playerid][HelperLevel]);
            INI_WriteInt("hMuted",PlayerStat[playerid][hMuted]);
            INI_WriteInt("HelpmeReloadTime", PlayerStat[playerid][HelpmeReloadTime]);

            INI_WriteInt("LastLoginSecond",PlayerStat[playerid][LastLoginSecond]);
            INI_WriteInt("LastLoginMinute",PlayerStat[playerid][LastLoginMinute]);
            INI_WriteInt("LastLoginHour",PlayerStat[playerid][LastLoginHour]);
            INI_WriteInt("LastLoginDay",PlayerStat[playerid][LastLoginDay]);
            INI_WriteInt("LastLoginMonth",PlayerStat[playerid][LastLoginMonth]);
            INI_WriteInt("LastLoginYear",PlayerStat[playerid][LastLoginYear]);

            INI_WriteInt("GangID",PlayerStat[playerid][GangID]);
            INI_WriteInt("GangRank",PlayerStat[playerid][GangRank]);
            INI_WriteInt("GetWeapReloadTime", PlayerStat[playerid][GetWeapReloadTime]);
            INI_WriteInt("GetDrugsReloadTime", PlayerStat[playerid][GetDrugsReloadTime]);
            INI_WriteInt("Pot", PlayerStat[playerid][Pot]);
            INI_WriteInt("Crack", PlayerStat[playerid][Crack]);
            INI_WriteInt("Slot0", PlayerStat[playerid][Slot0]);
            INI_WriteInt("Slot1", PlayerStat[playerid][Slot1]);
            INI_WriteInt("Slot2", PlayerStat[playerid][Slot2]);
            INI_WriteInt("Slot3", PlayerStat[playerid][Slot3]);
		    INI_WriteInt("Slot4", PlayerStat[playerid][Slot4]);
		    INI_WriteInt("Slot5", PlayerStat[playerid][Slot5]);
		    INI_WriteInt("Slot6", PlayerStat[playerid][Slot6]);
	    	INI_WriteInt("Slot7", PlayerStat[playerid][Slot7]);
    		INI_WriteInt("Slot8", PlayerStat[playerid][Slot8]);
     		INI_WriteInt("Slot9", PlayerStat[playerid][Slot9]);
    		INI_WriteInt("Slot10", PlayerStat[playerid][Slot10]);
    		INI_WriteInt("Slot11", PlayerStat[playerid][Slot11]);
    		INI_WriteInt("UsingCrackReloadTime",PlayerStat[playerid][UsingCrackReloadTime]);
	     	INI_WriteInt("UsingPotReloadTime",PlayerStat[playerid][UsingPotReloadTime]);


            INI_WriteInt("FactionID",PlayerStat[playerid][FactionID]);
	     	INI_WriteInt("FactionRank",PlayerStat[playerid][FactionRank]);
	     	INI_WriteInt("Tased",PlayerStat[playerid][Tased]);
		    INI_WriteInt("InIsolatedCell",PlayerStat[playerid][InIsolatedCell]);
		    INI_WriteInt("InIsolatedCellTime",PlayerStat[playerid][InIsolatedCellTime]);
		    INI_WriteInt("Cuffed",PlayerStat[playerid][Cuffed]);

	     	INI_WriteFloat("Health",Float:DHealth);
		    INI_WriteFloat("Armour",Float:DArmour);
		    INI_WriteFloat("DeathPosX",PlayerStat[playerid][DeathPosX]);
		    INI_WriteFloat("DeathPosY",PlayerStat[playerid][DeathPosY]);
		    INI_WriteFloat("DeathPosZ",PlayerStat[playerid][DeathPosZ]);
			INI_WriteInt("DeathWeapon",0);
			INI_WriteInt("DeathAmmo",0);
		    INI_WriteInt("Dead",PlayerStat[playerid][Dead]);
		    INI_WriteInt("InHospital",PlayerStat[playerid][InHospital]);
		    INI_WriteInt("Deaths",PlayerStat[playerid][Deaths]);
		    INI_WriteInt("Kills",PlayerStat[playerid][Kills]);
			
			INI_WriteInt("StatPWR",PlayerStat[playerid][StatPWR]);
			INI_WriteInt("StatINT",PlayerStat[playerid][StatINT]);

		    INI_WriteInt("Lighter",PlayerStat[playerid][Lighter]);
		    INI_WriteInt("Paper",PlayerStat[playerid][Lighter]);
	     	INI_WriteInt("Cigars",PlayerStat[playerid][Cigars]);
			INI_WriteInt("Dices",PlayerStat[playerid][Dices]);
			INI_WriteInt("PlasticBags",PlayerStat[playerid][PlasticBags]);

	     	INI_WriteInt("HasCell", PlayerStat[playerid][HasCell]);
	     	INI_WriteInt("Cell",PlayerStat[playerid][Cell]);
	     	INI_WriteInt("DonLV",PlayerStat[playerid][DonLV]);
	     	INI_WriteInt("DeathT",PlayerStat[playerid][DeathT]);
	     	INI_WriteInt("Aname",PlayerStat[playerid][Aname]);
			INI_WriteInt("ADuty",PlayerStat[playerid][ADuty]);
			INI_WriteInt("HDuty",PlayerStat[playerid][HDuty]);
			INI_WriteInt("Joint",PlayerStat[playerid][Joint]);
			INI_WriteInt("JRACD",PlayerStat[playerid][JRACD]);
			INI_WriteInt("JRCD",PlayerStat[playerid][JRCD]);
			INI_WriteInt("JSCD",PlayerStat[playerid][JSCD]);
			INI_WriteInt("CUCD",PlayerStat[playerid][CUCD]);
			INI_WriteInt("CSCD",PlayerStat[playerid][CSCD]);
			INI_WriteInt("BPUSE",PlayerStat[playerid][BPUSE]);
			INI_WriteInt("BPDIF",PlayerStat[playerid][BPDIF]);
			INI_WriteInt("BPCD",PlayerStat[playerid][BPCD]);
			INI_WriteInt("BPACD",PlayerStat[playerid][BPACD]);
			INI_WriteInt("BPANM",PlayerStat[playerid][BPANM]);
			INI_WriteInt("BPNMB",PlayerStat[playerid][BPNMB]);
			INI_WriteInt("BPBAR",PlayerStat[playerid][BPBAR]);
			INI_WriteInt("LogoutCuffs",PlayerStat[playerid][LogoutCuffs]);
			INI_WriteInt("BleedingWound",PlayerStat[playerid][BleedingWound]);
			INI_WriteInt("NameChangeTicket",PlayerStat[playerid][NameChangeTicket]);
			INI_WriteString("Answer1",PlayerStat[playerid][Answer1]);
			INI_WriteString("Answer2",PlayerStat[playerid][Answer2]);
			INI_WriteString("Answer3",PlayerStat[playerid][Answer3]);
			INI_WriteString("Answer4",PlayerStat[playerid][Answer4]);
			INI_WriteString("Answer5",PlayerStat[playerid][Answer5]);
			INI_WriteInt("WeaponSlot0",PlayerStat[playerid][WeaponSlot0]);
			INI_WriteInt("WeaponSlot1",PlayerStat[playerid][WeaponSlot1]);
			INI_WriteInt("WeaponSlot2",PlayerStat[playerid][WeaponSlot2]);
			INI_WriteInt("WeaponSlot0Ammo",PlayerStat[playerid][WeaponSlot0Ammo]);
			INI_WriteInt("WeaponSlot1Ammo",PlayerStat[playerid][WeaponSlot1Ammo]);
			INI_WriteInt("WeaponSlot2Ammo",PlayerStat[playerid][WeaponSlot2Ammo]);
			INI_WriteInt("WeaponPocketCD",PlayerStat[playerid][WeaponPocketCD]);
			INI_WriteInt("FightStyle",PlayerStat[playerid][FightStyle]);
			INI_WriteInt("INV_SLOT1",PlayerStat[playerid][INV_SLOT1]);
			INI_WriteInt("INV_SLOT1A",PlayerStat[playerid][INV_SLOT1A]);
			INI_WriteInt("INV_SLOT2",PlayerStat[playerid][INV_SLOT2]);
			INI_WriteInt("INV_SLOT2A",PlayerStat[playerid][INV_SLOT2A]);
			INI_WriteInt("INV_SLOT3",PlayerStat[playerid][INV_SLOT3]);
			INI_WriteInt("INV_SLOT3A",PlayerStat[playerid][INV_SLOT3A]);
			INI_WriteInt("INV_SLOT4",PlayerStat[playerid][INV_SLOT4]);
			INI_WriteInt("INV_SLOT4A",PlayerStat[playerid][INV_SLOT4A]);
			INI_WriteInt("INV_SLOT5",PlayerStat[playerid][INV_SLOT5]);
			INI_WriteInt("INV_SLOT5A",PlayerStat[playerid][INV_SLOT5A]);
			INI_WriteInt("INV_SLOT6",PlayerStat[playerid][INV_SLOT6]);
			INI_WriteInt("INV_SLOT6A",PlayerStat[playerid][INV_SLOT6A]);
			INI_WriteInt("INV_SLOT7",PlayerStat[playerid][INV_SLOT7]);
			INI_WriteInt("INV_SLOT7A",PlayerStat[playerid][INV_SLOT7A]);
			INI_WriteInt("INV_SLOT8",PlayerStat[playerid][INV_SLOT8]);
			INI_WriteInt("INV_SLOT8A",PlayerStat[playerid][INV_SLOT8A]);
			INI_WriteInt("INV_SLOT9",PlayerStat[playerid][INV_SLOT9]);
			INI_WriteInt("INV_SLOT9A",PlayerStat[playerid][INV_SLOT9A]);
			INI_WriteInt("INV_SLOT10",PlayerStat[playerid][INV_SLOT10]);
			INI_WriteInt("INV_SLOT10A",PlayerStat[playerid][INV_SLOT10A]);
			INI_WriteInt("MetSkill",PlayerStat[playerid][MetSkill]);
			INI_WriteInt("WodSkill",PlayerStat[playerid][WodSkill]);
			INI_WriteInt("CrfSkill",PlayerStat[playerid][CrfSkill]);
			INI_WriteInt("MetSkillXP",PlayerStat[playerid][MetSkillXP]);
			INI_WriteInt("WodSkillXP",PlayerStat[playerid][WodSkillXP]);
			INI_WriteInt("CrfSkillXP",PlayerStat[playerid][CrfSkillXP]);
			

            INI_Save();
            INI_Close();
        }
    }
	else
	{
		print("Error #996");
	}
	return 1;
}

public LoadPlayerData(playerid)
{
    if(INI_Open(Accounts(playerid)))
	{
        if(PlayerStat[playerid][Logged] == 0)
        {
		    return 0;
	    }

        PlayerStat[playerid][Banned] = INI_ReadInt("Banned");
        PlayerStat[playerid][FullyRegistered] = INI_ReadInt("FullyRegistered");

        if(PlayerStat[playerid][Banned] == 1)
        {
		    SendClientMessage(playerid, WHITE, "You are banned from this server.");
	        Kick(playerid);
	    }

        else if(PlayerStat[playerid][FullyRegistered] == 0 && PNewReg[playerid] == 0)
	    {
		    TogglePlayerControllable(playerid, false);

			SendClientMessage(playerid, GREY, "You are not fully registered, You must answer a Roleplay Quiz then specify your gender and age.");
            ShowPlayerDialog(playerid, DIALOG_GENDER, DIALOG_STYLE_LIST, "Are you a male or a female?","Male\nFemale","Next","Quit");
            SetPlayerInterior(playerid, 0);
			SetPlayerTime(playerid, 7, 0);
			InPrison[playerid] = 1;
            SetSpawnInfo(playerid, 0, 0, 416.6970,1567.0526,1001.0000 , 0, 0, 0, 0, 0, 0, 0);
            SetPlayerVirtualWorld(playerid, 0);
            SpawnPlayer(playerid);
            SetPlayerCameraPos(playerid, 1752.4188, -1527.8185, 20.2753);
            SetPlayerCameraLookAt(playerid, 1753.0366, -1528.6036, 19.8853);
	    }
	    else
		{

            PlayerStat[playerid][Age] = INI_ReadInt("Age");
            PlayerStat[playerid][Gender] = INI_ReadInt("Gender");
            PlayerStat[playerid][PlayingHours] = INI_ReadInt("PlayingHours");

            PlayerStat[playerid][Money] = INI_ReadInt("Money");
            PlayerStat[playerid][Paycheck] = INI_ReadInt("Paycheck");
            PlayerStat[playerid][LockerMoney] = INI_ReadInt("LockerMoney");
            PlayerStat[playerid][LastSkin] = INI_ReadInt("LastSkin");
            INI_ReadString(PlayerStat[playerid][Reason],"Reason",20);
            INI_ReadString(PlayerStat[playerid][Accent],"Accent",20);

            PlayerStat[playerid][LastX] = INI_ReadFloat("LastX");
            PlayerStat[playerid][LastY] = INI_ReadFloat("LastY");
            PlayerStat[playerid][LastZ] = INI_ReadFloat("LastZ");
            PlayerStat[playerid][LastA] = INI_ReadFloat("LastA");
            PlayerStat[playerid][LastInt] = INI_ReadInt("LastInt");
            PlayerStat[playerid][LastVW] = INI_ReadInt("LastVW");
			PlayerStat[playerid][PlayingMinutes] = INI_ReadInt("PlayingMinutes");

            PlayerStat[playerid][TogOOC] = INI_ReadInt("TogOOC");
            PlayerStat[playerid][TogPM] = INI_ReadInt("TogPM");

            PlayerStat[playerid][JobID] = INI_ReadInt("JobID");
            PlayerStat[playerid][HoursInJob] = INI_ReadInt("HoursInJob");
            PlayerStat[playerid][AbleToCollectGarbage] = INI_ReadInt("AbleToCollectGarbage");
			PlayerStat[playerid][AbleToCleanTables] = INI_ReadInt("AbleToCleanTables");
            PlayerStat[playerid][AbleToCollectFood] = INI_ReadInt("AbleToCollectFood");
            PlayerStat[playerid][JobID1ReloadTime] = INI_ReadInt("JobID1ReloadTime");
            PlayerStat[playerid][JobID2ReloadTime] = INI_ReadInt("JobID2ReloadTime");
            PlayerStat[playerid][JobID3ReloadTime] = INI_ReadInt("JobID3ReloadTime");
            PlayerStat[playerid][JobID4ReloadTime] = INI_ReadInt("JobID4ReloadTime");
            PlayerStat[playerid][JobID4CHP] = INI_ReadInt("JobID4CHP");
            PlayerStat[playerid][JobID4BOX] = INI_ReadInt("JobID4BOX");

            PlayerStat[playerid][AdminLevel] = INI_ReadInt("AdminLevel");
			INI_ReadString(PlayerStat[playerid][AdminCode],"AdminCode",128);
			PlayerStat[playerid][AdminLogged] = INI_ReadInt("AdminLogged");
            PlayerStat[playerid][Muted] = INI_ReadInt("Muted");
            PlayerStat[playerid][MuteTime] = INI_ReadInt("MuteTime");
            PlayerStat[playerid][AdminPrisoned] = INI_ReadInt("AdminPrisoned");
            PlayerStat[playerid][AdminPrisonedTime] = INI_ReadInt("AdminPrisonedTime");
            PlayerStat[playerid][TimesBanned] = INI_ReadInt("TimesBanned");
            PlayerStat[playerid][TimesKicked] = INI_ReadInt("TimesKicked");
            PlayerStat[playerid][Warnings] = INI_ReadInt("Warnings");
            INI_ReadString(PlayerStat[playerid][Warn1],"Warn1",128);
            INI_ReadString(PlayerStat[playerid][Warn2],"Warn2",128);
			INI_ReadString(PlayerStat[playerid][BannedReason],"BannedReason",128);
			PlayerStat[playerid][HelpmesAnswered] = INI_ReadInt("HelpmesAnswered");

            PlayerStat[playerid][HelperLevel] = INI_ReadInt("HelperLevel");
            PlayerStat[playerid][hMuted] = INI_ReadInt("hMuted");
            PlayerStat[playerid][HelpmeReloadTime] = INI_ReadInt("HelpmeReloadTime");

            PlayerStat[playerid][LastLoginSecond] = INI_ReadInt("LastLoginSecond");
            PlayerStat[playerid][LastLoginMinute] = INI_ReadInt("LastLoginMinute");
            PlayerStat[playerid][LastLoginHour] = INI_ReadInt("LastLoginHour");
            PlayerStat[playerid][LastLoginDay] = INI_ReadInt("LastLoginDay");
            PlayerStat[playerid][LastLoginMonth] = INI_ReadInt("LastLoginMonth");
            PlayerStat[playerid][LastLoginYear] = INI_ReadInt("LastLoginYear");

            PlayerStat[playerid][GangID] = INI_ReadInt("GangID");
            PlayerStat[playerid][GangRank] = INI_ReadInt("GangRank");
            PlayerStat[playerid][GetWeapReloadTime] = INI_ReadInt("GetWeapReloadTime");
            PlayerStat[playerid][GetDrugsReloadTime] = INI_ReadInt("GetDrugsReloadTime");
            PlayerStat[playerid][Pot] = INI_ReadInt("Pot");
            PlayerStat[playerid][Crack] = INI_ReadInt("Crack");
            PlayerStat[playerid][Slot0] = INI_ReadInt("Slot0");
            PlayerStat[playerid][Slot1] = INI_ReadInt("Slot1");
            PlayerStat[playerid][Slot2] = INI_ReadInt("Slot2");
            PlayerStat[playerid][Slot3] = INI_ReadInt("Slot3");
            PlayerStat[playerid][Slot4] = INI_ReadInt("Slot4");
            PlayerStat[playerid][Slot5] = INI_ReadInt("Slot5");
            PlayerStat[playerid][Slot6] = INI_ReadInt("Slot6");
            PlayerStat[playerid][Slot7] = INI_ReadInt("Slot7");
			PlayerStat[playerid][Slot8] = INI_ReadInt("Slot8");
            PlayerStat[playerid][Slot9] = INI_ReadInt("Slot9");
            PlayerStat[playerid][Slot10] = INI_ReadInt("Slot10");
            PlayerStat[playerid][Slot11] = INI_ReadInt("Slot11");
            PlayerStat[playerid][UsingCrackReloadTime] = INI_ReadInt("UsingCrackReloadTime");
            PlayerStat[playerid][UsingPotReloadTime] = INI_ReadInt("UsingPotReloadTime");

            PlayerStat[playerid][FactionID] = INI_ReadInt("FactionID");
            PlayerStat[playerid][FactionRank] = INI_ReadInt("FactionRank");
            PlayerStat[playerid][Cuffed] = INI_ReadInt("Cuffed");
            PlayerStat[playerid][Tased] = INI_ReadInt("Tased");
            PlayerStat[playerid][InIsolatedCell] = INI_ReadInt("InIsolatedCell");
            PlayerStat[playerid][InIsolatedCellTime] = INI_ReadInt("InIsolatedCellTime");

            PlayerStat[playerid][Health] = INI_ReadFloat("Health");
            PlayerStat[playerid][Armour] = INI_ReadFloat("Armour");
            PlayerStat[playerid][DeathPosX] = INI_ReadFloat("DeathPosX");
            PlayerStat[playerid][DeathPosY] = INI_ReadFloat("DeathPosY");
            PlayerStat[playerid][DeathPosZ] = INI_ReadFloat("DeathPosZ");
			PlayerStat[playerid][DeathWeapon] = INI_ReadInt("DeathWeapon");
			PlayerStat[playerid][DeathAmmo] = INI_ReadInt("DeathAmmo");
            PlayerStat[playerid][Dead] = INI_ReadInt("Dead");
            PlayerStat[playerid][InHospital] = INI_ReadInt("InHospital");
            PlayerStat[playerid][Deaths] = INI_ReadInt("Deaths");
            PlayerStat[playerid][Kills] = INI_ReadInt("Kills");
			
			PlayerStat[playerid][StatPWR] = INI_ReadInt("StatPWR");
			PlayerStat[playerid][StatINT] = INI_ReadInt("StatINT");

            PlayerStat[playerid][Lighter] = INI_ReadInt("Lighter");
            PlayerStat[playerid][Paper] = INI_ReadInt("Paper");
            PlayerStat[playerid][Cigars] = INI_ReadInt("Cigars");
			PlayerStat[playerid][Dices] = INI_ReadInt("Dices");
			PlayerStat[playerid][PlasticBags] = INI_ReadInt("PlasticBags");

            PlayerStat[playerid][HasCell] = INI_ReadInt("HasCell");
            PlayerStat[playerid][Cell] = INI_ReadInt("Cell");
            PlayerStat[playerid][DonLV] = INI_ReadInt("DonLV");
            PlayerStat[playerid][Aname] = INI_ReadInt("Aname");
            PlayerStat[playerid][DeathT] = INI_ReadInt("DeathT");
            PlayerStat[playerid][ADuty] = INI_ReadInt("ADuty");
			PlayerStat[playerid][HDuty] = INI_ReadInt("HDuty");
            PlayerStat[playerid][JRACD] = INI_ReadInt("JRACD");
            PlayerStat[playerid][JRCD] = INI_ReadInt("JRCD");
            PlayerStat[playerid][JSCD] = INI_ReadInt("JSCD");
            PlayerStat[playerid][CUCD] = INI_ReadInt("CUCD");
            PlayerStat[playerid][Joint] = INI_ReadInt("Joint");
            PlayerStat[playerid][CSCD] = INI_ReadInt("CSCD");
            PlayerStat[playerid][BPUSE] = INI_ReadInt("BPUSE");
            PlayerStat[playerid][BPDIF] = INI_ReadInt("BPDIF");
            PlayerStat[playerid][BPCD] = INI_ReadInt("BPCD");
            PlayerStat[playerid][BPACD] = INI_ReadInt("BPACD");
            PlayerStat[playerid][BPANM] = INI_ReadInt("BPANM");
            PlayerStat[playerid][BPNMB] = INI_ReadInt("BPNMB");
            PlayerStat[playerid][BPBAR] = INI_ReadInt("BPBAR");
            PlayerStat[playerid][NameChangeTicket] = INI_ReadInt("NameChangeTicket");
            PlayerStat[playerid][LogoutCuffs] = INI_ReadInt("LogoutCuffs");
			PlayerStat[playerid][BleedingWound] = INI_ReadInt("BleedingWound");
			INI_ReadString(PlayerStat[playerid][Answer1],"Answer1",128);
			INI_ReadString(PlayerStat[playerid][Answer2],"Answer2",128);
			INI_ReadString(PlayerStat[playerid][Answer3],"Answer3",128);
			INI_ReadString(PlayerStat[playerid][Answer4],"Answer4",128);
			INI_ReadString(PlayerStat[playerid][Answer5],"Answer5",128);
			PlayerStat[playerid][WeaponSlot0] = INI_ReadInt("WeaponSlot0");
			PlayerStat[playerid][WeaponSlot1] = INI_ReadInt("WeaponSlot1");
			PlayerStat[playerid][WeaponSlot2] = INI_ReadInt("WeaponSlot2");
			PlayerStat[playerid][WeaponSlot0Ammo] = INI_ReadInt("WeaponSlot0Ammo");
			PlayerStat[playerid][WeaponSlot1Ammo] = INI_ReadInt("WeaponSlot1Ammo");
			PlayerStat[playerid][WeaponSlot2Ammo] = INI_ReadInt("WeaponSlot2Ammo");
			PlayerStat[playerid][WeaponPocketCD] = INI_ReadInt("WeaponPocketCD");
			PlayerStat[playerid][FightStyle] = INI_ReadInt("FightStyle");
			PlayerStat[playerid][INV_SLOT1] = INI_ReadInt("INV_SLOT1");
			PlayerStat[playerid][INV_SLOT1A] = INI_ReadInt("INV_SLOT1A");
			PlayerStat[playerid][INV_SLOT2] = INI_ReadInt("INV_SLOT2");
			PlayerStat[playerid][INV_SLOT2A] = INI_ReadInt("INV_SLOT2A");
			PlayerStat[playerid][INV_SLOT3] = INI_ReadInt("INV_SLOT3");
			PlayerStat[playerid][INV_SLOT3A] = INI_ReadInt("INV_SLOT3A");
			PlayerStat[playerid][INV_SLOT4] = INI_ReadInt("INV_SLOT4");
			PlayerStat[playerid][INV_SLOT4A] = INI_ReadInt("INV_SLOT4A");
			PlayerStat[playerid][INV_SLOT5] = INI_ReadInt("INV_SLOT5");
			PlayerStat[playerid][INV_SLOT5A] = INI_ReadInt("INV_SLOT5A");
			PlayerStat[playerid][INV_SLOT6] = INI_ReadInt("INV_SLOT6");
			PlayerStat[playerid][INV_SLOT6A] = INI_ReadInt("INV_SLOT6A");
			PlayerStat[playerid][INV_SLOT7] = INI_ReadInt("INV_SLOT7");
			PlayerStat[playerid][INV_SLOT7A] = INI_ReadInt("INV_SLOT7A");
			PlayerStat[playerid][INV_SLOT8] = INI_ReadInt("INV_SLOT8");
			PlayerStat[playerid][INV_SLOT8A] = INI_ReadInt("INV_SLOT8A");
			PlayerStat[playerid][INV_SLOT9] = INI_ReadInt("INV_SLOT9");
			PlayerStat[playerid][INV_SLOT9A] = INI_ReadInt("INV_SLOT9A");
			PlayerStat[playerid][INV_SLOT10] = INI_ReadInt("INV_SLOT10");
			PlayerStat[playerid][INV_SLOT10A] = INI_ReadInt("INV_SLOT10A");
			PlayerStat[playerid][MetSkill] = INI_ReadInt("MetSkill");
			PlayerStat[playerid][WodSkill] = INI_ReadInt("WodSkill");
			PlayerStat[playerid][CrfSkill] = INI_ReadInt("CrfSkill");
			PlayerStat[playerid][MetSkillXP] = INI_ReadInt("MetSkillXP");
			PlayerStat[playerid][WodSkillXP] = INI_ReadInt("WodSkillXP");
			PlayerStat[playerid][CrfSkillXP] = INI_ReadInt("CrfSkillXP");


            if(PNewReg[playerid] == 0)
			{
				SetSpawnInfo(playerid, 0, PlayerStat[playerid][LastSkin], 1536.2251, -1675.9830, 13.3828, PlayerStat[playerid][LastA], 0, 0, 0, 0, 0, 0);
				SpawnPlayer(playerid);
				TogglePlayerControllable(playerid, false);
				SetTimerEx("SpawnPlayerNoCrash", 2500, false, "d", playerid);
			}
			else if(PNewReg[playerid] == 2)
			{
				SetSpawnInfo(playerid, 0, PlayerStat[playerid][LastSkin], 1536.2251, -1675.9830, 13.3828, PlayerStat[playerid][LastA], 0, 0, 0, 0, 0, 0);
				SpawnPlayer(playerid);
				TogglePlayerControllable(playerid, false);
				SetTimerEx("SpawnPlayerNoCrash", 2500, false, "d", playerid);
			}
			else if(PNewReg[playerid] == 1)
			{
				SetSpawnInfo(playerid, 0, PlayerStat[playerid][LastSkin], 1536.2251, -1675.9830, 13.3828, PlayerStat[playerid][LastA], 0, 0, 0, 0, 0, 0);
				SpawnPlayer(playerid);
				TogglePlayerControllable(playerid, false);
				SetTimerEx("SpawnPlayerNoCrash", 2500, false, "d", playerid);
			}
            TextDrawShowForPlayer(playerid, ServerNameTextDraw);
			PlayerTextDrawShow(playerid, Serverurl[playerid]);
            PlayerStat[playerid][Spawned] = 1;
            SetMoney(playerid, PlayerStat[playerid][Money]);
            SetPlayerInterior(playerid, PlayerStat[playerid][LastInt]);
            SetPlayerVirtualWorld(playerid, PlayerStat[playerid][LastVW]);
            SetHealth(playerid, PlayerStat[playerid][Health]);
            SetArmour(playerid, PlayerStat[playerid][Armour]);
            SetCameraBehindPlayer(playerid);
            TogglePlayerControllable(playerid, 0);
            SetTimerEx("LoadingObjects", 4000, false, "d", playerid);
			SetPlayerFightingStyle(playerid, PlayerStat[playerid][FightStyle]);

		}
        INI_Save();
        INI_Close();
    }
	return 1;
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
forward SpawnPlayerNoCrash(playerid);
public SpawnPlayerNoCrash(playerid)
{
	if(PNewReg[playerid] == 0)
	{
		SetSpawnInfo(playerid, 0, PlayerStat[playerid][LastSkin], PlayerStat[playerid][LastX], PlayerStat[playerid][LastY], PlayerStat[playerid][LastZ], PlayerStat[playerid][LastA], 0, 0, 0, 0, 0, 0);
		SpawnPlayer(playerid);
		SendClientMessage(playerid, RED, "Remember the server is in BETA phase, if any bugs appear please report them over the forums.");
	}
	else if(PNewReg[playerid] == 2)
	{
		PNewReg[playerid] = 0;
		PlayerStat[playerid][Muted] = 0;
		SetPlayerColor(playerid, WHITE);
		SetSpawnInfo(playerid, 0, PlayerStat[playerid][LastSkin], 416.6970, 1567.0526, 1001.0000, PlayerStat[playerid][LastA], 0, 0, 0, 0, 0, 0);
		SpawnPlayer(playerid);
		SendClientMessage(playerid, RED, "Remember the server is in BETA phase, if any bugs appear please report them over the forums.");
	}
	else if(PNewReg[playerid] == 1)
	{
		PlayerStat[playerid][Muted] = 1;
		SendClientMessage(playerid, WHITE, "                ");
		SendClientMessage(playerid, WHITE, "                ");
		SendClientMessage(playerid, WHITE, "                ");
		SendClientMessage(playerid, WHITE, "                ");
		SendClientMessage(playerid, WHITE, "                ");
		SendClientMessage(playerid, WHITE, "                ");
		SendClientMessage(playerid, WHITE, "                ");
		SendClientMessage(playerid, WHITE, "You are now on the bus to the prison. Before you get there, you will have to answer a few questions regarding roleplay.");
		SendClientMessage(playerid, WHITE, "If you're not familliar with the questions' subject, you should read the guide and server rules on our forums at:");
		SendClientMessage(playerid, LIGHT_GREEN, "                               www.hd-rp.net/forums/");
		SendClientMessage(playerid, WHITE, "Your quiz's answers will be sent to a registrator and he will examine them carefully before making the decision to accept your application.");
		SendClientMessage(playerid, LIGHT_GREEN, "Question number 1:");
		SendClientMessage(playerid, WHITE, "Question: Explain what roleplaying is.");
		SetSpawnInfo(playerid, 0, 35, 387.1792, 1547.7211, 16.9794, PlayerStat[playerid][LastA], 0, 0, 0, 0, 0, 0);
		SpawnPlayer(playerid);
		return 1;
	}
	return 1;
}

public LoadPlayerWeapons(playerid) // Loading weapons when player spawns.
{
//	ServerWeapon(playerid, PlayerStat[playerid][Slot0]);
//	ServerWeapon(playerid, PlayerStat[playerid][Slot1]);
//	ServerWeapon(playerid, PlayerStat[playerid][Slot2]);
//	ServerWeapon(playerid, PlayerStat[playerid][Slot3]);
//	ServerWeapon(playerid, PlayerStat[playerid][Slot4]);
//	ServerWeapon(playerid, PlayerStat[playerid][Slot5]);
//	ServerWeapon(playerid, PlayerStat[playerid][Slot6]);
//	ServerWeapon(playerid, PlayerStat[playerid][Slot7]);
//	ServerWeapon(playerid, PlayerStat[playerid][Slot8]);
//	ServerWeapon(playerid, PlayerStat[playerid][Slot9]);
//	ServerWeapon(playerid, PlayerStat[playerid][Slot10]);
//	ServerWeapon(playerid, PlayerStat[playerid][Slot11]);
	return 1;
}

public ResetWeapons(playerid)
{
	PlayerStat[playerid][Slot0] = 0;
	PlayerStat[playerid][Slot1] = 0;
	PlayerStat[playerid][Slot2] = 0;
	PlayerStat[playerid][Slot3] = 0;
	PlayerStat[playerid][Slot4] = 0;
	PlayerStat[playerid][Slot5] = 0;
	PlayerStat[playerid][Slot6] = 0;
	PlayerStat[playerid][Slot7] = 0;
	PlayerStat[playerid][Slot8] = 0;
	PlayerStat[playerid][Slot9] = 0;
	PlayerStat[playerid][Slot10] = 0;
	PlayerStat[playerid][Slot11] = 0;
	ResetPlayerWeapons(playerid);
	return 1;
}

forward ResetWeaponsFully(playerid);
public ResetWeaponsFully(playerid)
{
	PlayerStat[playerid][Slot0] = 0;
	PlayerStat[playerid][Slot1] = 0;
	PlayerStat[playerid][Slot2] = 0;
	PlayerStat[playerid][Slot3] = 0;
	PlayerStat[playerid][Slot4] = 0;
	PlayerStat[playerid][Slot5] = 0;
	PlayerStat[playerid][Slot6] = 0;
	PlayerStat[playerid][Slot7] = 0;
	PlayerStat[playerid][Slot8] = 0;
	PlayerStat[playerid][Slot9] = 0;
	PlayerStat[playerid][Slot10] = 0;
	PlayerStat[playerid][Slot11] = 0;
	PlayerStat[playerid][WeaponSlot0] = 0;
	PlayerStat[playerid][WeaponSlot1] = 0;
	PlayerStat[playerid][WeaponSlot2] = 0;
	PlayerStat[playerid][WeaponSlot0Ammo] = 0;
	PlayerStat[playerid][WeaponSlot1Ammo] = 0;
	PlayerStat[playerid][WeaponSlot2Ammo] = 0;
	RemovePlayerAttachedObject(playerid, 6);
	RemovePlayerAttachedObject(playerid, 7);
	RemovePlayerAttachedObject(playerid, 8);
	ResetPlayerWeapons(playerid);
	return 1;
}

public ShowPlayerWeaponsNames(playerid, targetid)
{
	new str[128], WeaponName[128];
	if(PlayerStat[targetid][Slot0] > 0)
	{
	    GetWeaponName(PlayerStat[targetid][Slot0], WeaponName, sizeof(WeaponName));
	    format(str, sizeof(str), "%s", WeaponName);
	    SendClientMessage(playerid, WHITE, str);
	}
	if(PlayerStat[targetid][Slot1] > 0)
	{
	    GetWeaponName(PlayerStat[targetid][Slot1], WeaponName, sizeof(WeaponName));
	    format(str, sizeof(str), "%s", WeaponName);
	    SendClientMessage(playerid, WHITE, str);
	}
	if(PlayerStat[targetid][Slot2] > 0)
	{
	    GetWeaponName(PlayerStat[targetid][Slot2], WeaponName, sizeof(WeaponName));
	    format(str, sizeof(str), "%s", WeaponName);
	    SendClientMessage(playerid, WHITE, str);
	}
	if(PlayerStat[targetid][Slot3] > 0)
	{
	    GetWeaponName(PlayerStat[targetid][Slot3], WeaponName, sizeof(WeaponName));
	    format(str, sizeof(str), "%s", WeaponName);
	    SendClientMessage(playerid, WHITE, str);
	}
	if(PlayerStat[targetid][Slot4] > 0)
	{
	    GetWeaponName(PlayerStat[targetid][Slot4], WeaponName, sizeof(WeaponName));
	    format(str, sizeof(str), "%s", WeaponName);
	    SendClientMessage(playerid, WHITE, str);
	}
	if(PlayerStat[targetid][Slot5] > 0)
	{
	    GetWeaponName(PlayerStat[targetid][Slot5], WeaponName, sizeof(WeaponName));
	    format(str, sizeof(str), "%s", WeaponName);
	    SendClientMessage(playerid, WHITE, str);
	}
	if(PlayerStat[targetid][Slot6] > 0)
	{
	    GetWeaponName(PlayerStat[targetid][Slot6], WeaponName, sizeof(WeaponName));
	    format(str, sizeof(str), "%s", WeaponName);
	    SendClientMessage(playerid, WHITE, str);
	}
	if(PlayerStat[targetid][Slot7] > 0)
	{
	    GetWeaponName(PlayerStat[targetid][Slot7], WeaponName, sizeof(WeaponName));
	    format(str, sizeof(str), "%s", WeaponName);
	    SendClientMessage(playerid, WHITE, str);
	}
	if(PlayerStat[targetid][Slot8] > 0)
	{
	    GetWeaponName(PlayerStat[targetid][Slot8], WeaponName, sizeof(WeaponName));
	    format(str, sizeof(str), "%s", WeaponName);
	    SendClientMessage(playerid, WHITE, str);
	}
	if(PlayerStat[targetid][Slot9] > 0)
	{
	    GetWeaponName(PlayerStat[targetid][Slot9], WeaponName, sizeof(WeaponName));
	    format(str, sizeof(str), "%s", WeaponName);
	    SendClientMessage(playerid, WHITE, str);
	}
	if(PlayerStat[targetid][Slot10] > 0)
	{
	    GetWeaponName(PlayerStat[targetid][Slot10], WeaponName, sizeof(WeaponName));
	    format(str, sizeof(str), "%s", WeaponName);
	    SendClientMessage(playerid, WHITE, str);
	}
	if(PlayerStat[targetid][Slot11] > 0)
	{
	    GetWeaponName(PlayerStat[targetid][Slot11], WeaponName, sizeof(WeaponName));
	    format(str, sizeof(str), "%s", WeaponName);
	    SendClientMessage(playerid, WHITE, str);
	}
	return 1;
}

public GiveWeapon(playerid, weaponid)
{
	switch(weaponid)
	{
	    case 0, 1:
	    {
	        PlayerStat[playerid][Slot0] = weaponid;
	        ServerWeapon(playerid, PlayerStat[playerid][Slot0], 99999);
	    }
	    case 2, 3, 4, 5, 6, 7, 8, 9:
	    {
	        PlayerStat[playerid][Slot1] = weaponid;
	        ServerWeapon(playerid, PlayerStat[playerid][Slot1], 99999);
	    }
	    case 22, 23, 24:
	    {
	        PlayerStat[playerid][Slot2] = weaponid;
	        ServerWeapon(playerid, PlayerStat[playerid][Slot2], 99999);
	    }
	    case 25, 26, 27:
	    {
	        PlayerStat[playerid][Slot3] = weaponid;
	        ServerWeapon(playerid, PlayerStat[playerid][Slot3], 99999);
	    }
	    case 28, 29, 32:
	    {
	        PlayerStat[playerid][Slot4] = weaponid;
	        ServerWeapon(playerid, PlayerStat[playerid][Slot4], 99999);
	    }
        case 30, 31:
	    {
	        PlayerStat[playerid][Slot5] = weaponid;
	        ServerWeapon(playerid, PlayerStat[playerid][Slot5], 99999);
	    }
	    case 33, 34:
	    {
	        PlayerStat[playerid][Slot6] = weaponid;
	        ServerWeapon(playerid, PlayerStat[playerid][Slot6], 99999);
	    }
	    case 35, 36, 37, 38:
	    {
	        PlayerStat[playerid][Slot7] = weaponid;
	        ServerWeapon(playerid, PlayerStat[playerid][Slot7], 99999);
	    }
	    case 16, 17, 18, 39:
	    {
	        PlayerStat[playerid][Slot8] = weaponid;
	        ServerWeapon(playerid, PlayerStat[playerid][Slot8], 99999);
	    }
	    case 41, 42, 43:
	    {
	        PlayerStat[playerid][Slot9] = weaponid;
	        ServerWeapon(playerid, PlayerStat[playerid][Slot9], 99999);
	    }
	    case 10, 11, 12, 13, 14, 15:
	    {
	        PlayerStat[playerid][Slot10] = weaponid;
	        ServerWeapon(playerid, PlayerStat[playerid][Slot10], 99999);
	    }
	    case 44, 45, 46:
	    {
	        PlayerStat[playerid][Slot11] = weaponid;
	        ServerWeapon(playerid, PlayerStat[playerid][Slot11], 99999);
	    }
	}
	return 1;
}

public GetWeaponSlot(playerid, weaponid)
{
	new slot;
	switch(weaponid)
	{
	    case 0, 1: slot = 0;
	    case 2, 3, 4, 5, 6, 7, 8, 9: slot = 1;
	    case 22, 23, 24: slot = 2;
	    case 25, 26, 27: slot = 3;
	    case 28, 29, 32: slot = 4;
	    case 30, 31: slot = 5;
	    case 33, 34: slot = 6;
	    case 35, 36, 37, 38: slot = 7;
	    case 16, 17, 18, 39: slot = 8;
	    case 41, 42, 43: slot = 9;
	    case 10, 11, 12, 13, 14, 15: slot = 10;
	    case 44, 45, 46: slot = 11;
	}
	return slot;
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

public LoadingObjects(playerid)
{
    if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1 || PlayerStat[playerid][AdminPrisoned] == 1) return 0;
	TogglePlayerControllable(playerid, 1);
	return 1;
}

public SendNearByMessage(playerid, color, str[], Float:radius)
{
	new Float: PosX, Float: PosY, Float: PosZ;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(playerid) && PlayerStat[playerid][Spawned] == 1)
	   	{
	   		GetPlayerPos(playerid, PosX, PosY, PosZ);
	   		if(IsPlayerInRangeOfPoint(i, radius, PosX, PosY, PosZ))
	   		{
			    if(GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i) && GetPlayerInterior(playerid) == GetPlayerInterior(i))
	    	    {
	    			SendClientMessage(i, color, str);
	    		}
	    	}
		}
	}
	return 1;
}

public SendNearByChatMessage(playerid, str[]);
public SendNearByChatMessage(playerid, str[])
{
	new Float: PosX, Float: PosY, Float: PosZ;
	new i;
	i = 0;
	loop_start:
	if(i > MAX_PLAYERS) return 1;
	if(IsPlayerConnected(i) && PlayerStat[i][Spawned] == 1)
	{
		GetPlayerPos(playerid, PosX, PosY, PosZ);
		if(IsPlayerInRangeOfPoint(i, 8, PosX, PosY, PosZ))
		{
			if(GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i) && GetPlayerInterior(playerid) == GetPlayerInterior(i))
			{
				SendClientMessage(i, WHITE, str);
				i++;
				goto loop_start;
			}
		}
		if(IsPlayerInRangeOfPoint(i, 10, PosX, PosY, PosZ))
		{
			if(GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i) && GetPlayerInterior(playerid) == GetPlayerInterior(i))
			{
				SendClientMessage(i, LIGHT_GREY, str);
				i++;
				goto loop_start;
			}
		}
		if(IsPlayerInRangeOfPoint(i, 12, PosX, PosY, PosZ))
		{
			if(GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i) && GetPlayerInterior(playerid) == GetPlayerInterior(i))
			{
				SendClientMessage(i, DARK_GREY, str);
				i++;
				goto loop_start;
			}
		}
		else
		{
			i++;
			goto loop_start;
		}
	}
	else
	{
		i++;
		goto loop_start;
	}
	return 1;
}

forward CreateShellcasing(str, playerid, ammo, Float:playerx, Float:playery, Float:playerz);
public CreateShellcasing(str, playerid, ammo, Float:playerx, Float:playery, Float:playerz)
{

	return 1;
}


forward PlayNearBySound(playerid, soundid, Float:soundX, Float:soundY, Float:soundZ, Float:radius);
public PlayNearBySound(playerid, soundid, Float:soundX, Float:soundY, Float:soundZ, Float:radius)
{
	new Float: PosX, Float: PosY, Float: PosZ;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i) && PlayerStat[i][Spawned] == 1)
	   	{
	   		GetPlayerPos(i, PosX, PosY, PosZ);
	   		if(IsPlayerInRangeOfPoint(i, radius, PosX, PosY, PosZ))
	   		{
			    if(GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i) && GetPlayerInterior(playerid) == GetPlayerInterior(i))
	    	    {
	    			PlayerPlaySound(i, soundid, soundX, soundY, soundZ);
	    		}
	    	}
		}
	}
	return 1;
}

public SendHelperMessage(color, str[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
        if(IsPlayerConnected(i) && PlayerStat[i][HelperLevel] >= 1 && PlayerStat[i][Logged] && 1)
        {
            SendClientMessage(i, color, str);
            AdminActionLog(str);
        }
    }
	return 1;
}

forward SendHelpMeMessage(color, str[]);
public SendHelpMeMessage(color, str[])
{
	new OnlineHelpers;
	OnlineHelpers = 0;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
        if(IsPlayerConnected(i) && PlayerStat[i][HelperLevel] >= 1 && PlayerStat[i][HDuty] == 1 && PlayerStat[i][Logged] == 1)
        {
            SendClientMessage(i, color, str);
			OnlineHelpers++;
        }
    }
	if(OnlineHelpers <= 0)
	{
		SendAdminMessage(color, str);
	}
	return 1;
}

stock PlayAdminSound(soundid)
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
        if(IsPlayerConnected(i) && PlayerStat[i][Logged] == 1 && PlayerStat[i][AdminLevel] >= 1 && PlayerStat[i][AdminLogged] == 1)
        {
            PlayerPlaySound(i, soundid, 0, 0, 0);
			SetTimerEx("StopPlayingAllSounds", 6000, false, "i", i);
        }
    }
	return 1;
}

public SendAdminMessage(color, str[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
        if(IsPlayerConnected(i) && PlayerStat[i][Logged] == 1 && PlayerStat[i][AdminLevel] >= 1 && PlayerStat[i][AdminLogged] == 1)
        {
            SendClientMessage(i, color, str);
        }
    }
	return 1;
}

forward SendAdminHelperMessage(color, str[]);
public SendAdminHelperMessage(color, str[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
        if(IsPlayerConnected(i) && PlayerStat[i][Logged] == 1 && PlayerStat[i][AdminLevel] >= 1 || PlayerStat[i][HelperLevel] >= 1)
        {
            SendClientMessage(i, color, str);
        }
    }
	return 1;
}

public SendGangMessage(playerid, color, str[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i) && PlayerStat[playerid][GangID] == PlayerStat[i][GangID])
		{
            SendClientMessage(i, color, str);
            GangChatLog(str);
        }
    }
	return 1;
}

public SendFactionMessage(playerid, color, str[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i) && PlayerStat[playerid][FactionID] == PlayerStat[i][FactionID] && PlayerStat[i][FactionRank] > 1)
		{
            SendClientMessage(i, color, str);
            FactionChatLog(str);
        }
    }
	return 1;
}

forward SendDispatchMessage(playerid, color, str[]);
public SendDispatchMessage(playerid, color, str[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i) && PlayerStat[i][FactionID] >= 1 && PlayerStat[i][FactionRank] > 1)
		{
            SendClientMessage(i, color, str);
            FactionChatLog(str);
        }
    }
	return 1;
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

public RemoveDrugEffect(playerid)
{
	SetPlayerDrunkLevel(playerid, 0);
	SetPlayerWeather(playerid, 1);
    return 1;
}

public ToggleCheckpoints(playerid)
{
    TogglePlayerDynamicCP(playerid, TableCheckpoint1, 0);
    TogglePlayerDynamicCP(playerid, TableCheckpoint2, 0);
    TogglePlayerDynamicCP(playerid, TableCheckpoint3, 0);
    TogglePlayerDynamicCP(playerid, TableCheckpoint4, 0);
    TogglePlayerDynamicCP(playerid, TableCheckpoint5, 0);
    TogglePlayerDynamicCP(playerid, TableCheckpoint6, 0);
    TogglePlayerDynamicCP(playerid, TableCheckpoint7, 0);
    TogglePlayerDynamicCP(playerid, TableCheckpoint8, 0);
    TogglePlayerDynamicCP(playerid, TableCheckpoint9, 0);
    TogglePlayerDynamicCP(playerid, TableCheckpoint10, 0);
    TogglePlayerDynamicCP(playerid, TableCheckpoint11, 0);
    TogglePlayerDynamicCP(playerid, TableCheckpoint12, 0);
    TogglePlayerDynamicCP(playerid, TableCheckpoint13, 0);
    TogglePlayerDynamicCP(playerid, TableCheckpoint14, 0);
	return 1;
}

stock RemoveBox(playerid)
{
	PlayerStat[playerid][JobID4BOX] = 0;
	ClearAnimations(playerid);
	for(new i=0; i<MAX_ATTACHED_OBJECTS; i++)
	if(IsPlayerAttachedObjectSlotUsed(playerid, i)) RemovePlayerAttachedObject(playerid, i);
}

stock GetGenderHisHer(playerid)
{
	new HisHer[10];
	if(PlayerStat[playerid][Gender] == 1)
	{
		HisHer = "his";
	}
	if(PlayerStat[playerid][Gender] == 0)
	{
		HisHer = "her";
	}
	return HisHer;
}

public WaterSplashSound(playerid)
{
	new Float:RadioX, Float:RadioY, Float:RadioZ;
	GetPlayerPos(playerid, RadioX, RadioY, RadioZ);
	PlayNearBySound(playerid, 1144, RadioX, RadioY, RadioZ, 12);
	return 1;
}

public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	new str[128];
    if(response)
    {
        SendClientMessage(playerid, GREEN, "Attached object edition saved.");
		format(str, sizeof(str), "OFF-X: %f | OFF-Y: %f | OFF-Z: %f", fOffsetX, fOffsetY, fOffsetZ);
		SendClientMessage(playerid, WHITE, str);
		format(str, sizeof(str), "ROT-X: %f | ROT-Y: %f | ROT-Z: %f", fRotX, fRotY, fRotZ);
		SendClientMessage(playerid, WHITE, str);
    }
    return 1;
}

public WashingTray(playerid)
{
	new Float:RadioX, Float:RadioY, Float:RadioZ;
	GetPlayerPos(playerid, RadioX, RadioY, RadioZ);
	SendClientMessage(playerid, GREY, "You have finished washing the tray, continue and place the tray in the stack.");
	HoldingObject[playerid] = 2767;
	HoldingTray[playerid] = 1;
	SetPlayerAttachedObject(playerid, 1, HoldingObject[playerid], 6, 0.071, -0.005999, -0.164999, 245, 0, -90);
	SetPlayerSpecialAction(playerid, 25);
	TogglePlayerControllable(playerid, true);
	PlayerPlaySound(playerid, 1058, RadioX, RadioY, RadioZ);
	SetCameraBehindPlayer(playerid);
	if(UsingDisher[playerid] == 1)
	{
		Sink1Used = 0;
		UsingDisher[playerid] = 0;
		return 1;
	}
	if(UsingDisher[playerid] == 2)
	{
		Sink2Used = 0;
		UsingDisher[playerid] = 0;
		return 1;
	}
	else
	{
		print("Error #999 happened, please take a minute thanking Jesus.");
	}
	return 1;
}

forward WashingLaundry(playerid);
public WashingLaundry(playerid)
{
	new Float:RadioX, Float:RadioY, Float:RadioZ;
	GetPlayerPos(playerid, RadioX, RadioY, RadioZ);
	SendClientMessage(playerid, GREY, "Place the washed clothes in the right stack.");
	new Random = random(4);
	if(Random == 0) // BLUE
	{
		HoldingObject[playerid] = 2386;
		SetPlayerAttachedObject(playerid, 1, HoldingObject[playerid], 6, 0.0230, 0.090, -0.1730, -106.199, -8.399, -6.699);
	}
	if(Random == 1) // WHITE
	{
		HoldingObject[playerid] = 2384;
		SetPlayerAttachedObject(playerid, 1, HoldingObject[playerid], 6, 0.0230, 0.090, -0.1730, -106.199, -8.399, -6.699);
		
	}
	if(Random == 2) // RED
	{
		HoldingObject[playerid] = 2389;
		SetPlayerAttachedObject(playerid, 1, 2389, 6, 0.02799, 0.05100, -0.27700, -13.4, 172.5, -6, 0.7, 0.7, 0.7);
	}
	if(Random == 3) // Black Red
	{
		HoldingObject[playerid] = 2396;
		SetPlayerAttachedObject(playerid, 1, 2396, 6, 0.02799, 0.05100, -0.27700, -13.4, 172.5, -6, 0.7, 0.7, 0.7);
	}
	SetPlayerSpecialAction(playerid, 25);
	TogglePlayerControllable(playerid, true);
	PlayNearBySound(playerid, 1021, RadioX, RadioY, RadioZ, 12);
	SetCameraBehindPlayer(playerid);
	return 1;
}

stock GetOOCName(playerid)
{
    new OOCName[MAX_PLAYER_NAME];
    if(IsPlayerConnected(playerid))
    {
		GetPlayerName(playerid, OOCName, sizeof(OOCName));
	}
	else
	{
	    OOCName = "None";
	}

	return OOCName;
}
stock IsIRCChannel(channel[])
{
	if(!strcmp(channel, IRC_ECHO_CHANNEL, true)) return 1;
	else if(!strcmp(channel, IRC_AECHO_CHANNEL, true)) return 1;
	else if(!strcmp(channel, IRC_CHANNEL, true)) return 1;
	return 0;
}
stock pNick(playerid) return pName[playerid];
stock GetPlayerIpEx(playerid) return PlayerIP[playerid];
stock GetDeathReason(killerid, reason)
{
	new ReasonMsg[32], pstate = GetPlayerState(killerid), model = GetVehicleModel(GetPlayerVehicleID(killerid));
	if(killerid != INVALID_PLAYER_ID)
	{
		switch(reason)
		{
			case 0: ReasonMsg = "Unarmed";
			case 1: ReasonMsg = "Brass Knuckles";
			case 2: ReasonMsg = "Golf Club";
			case 3: ReasonMsg = "Night Stick";
			case 4: ReasonMsg = "Knife";
			case 5: ReasonMsg = "Baseball Bat";
			case 6: ReasonMsg = "Shovel";
			case 7: ReasonMsg = "Pool Cue";
			case 8: ReasonMsg = "Katana";
			case 9: ReasonMsg = "Chainsaw";
			case 10: ReasonMsg = "Dildo";
			case 11: ReasonMsg = "Dildo";
			case 12: ReasonMsg = "Vibrator";
			case 13: ReasonMsg = "Vibrator";
			case 14: ReasonMsg = "Flowers";
			case 15: ReasonMsg = "Cane";
			case 22: ReasonMsg = "Pistol";
			case 23: ReasonMsg = "Silenced Pistol";
			case 24: ReasonMsg = "Desert Eagle";
			case 25: ReasonMsg = "Shotgun";
			case 26: ReasonMsg = "Sawn-off Shotgun";
			case 27: ReasonMsg = "Combat Shotgun";
			case 28: ReasonMsg = "MAC-10";
			case 29: ReasonMsg = "MP5";
			case 30: ReasonMsg = "AK-47";
			case 31:
			{
				if(pstate == PLAYER_STATE_DRIVER)
				{
					switch(model)
					{
						case 447: ReasonMsg = "Sea Sparrow Machine Gun";
						default: ReasonMsg = "M4";
					}
				}
				else ReasonMsg = "M4";
			}
			case 32: ReasonMsg = "TEC-9";
			case 33: ReasonMsg = "Rifle";
			case 34: ReasonMsg = "Sniper Rifle";
			case 37: ReasonMsg = "Fire";
			case 38:
			{
				if(pstate == PLAYER_STATE_DRIVER)
				{
					switch(model)
					{
						case 425: ReasonMsg = "Hunter Machine Gun";
						default: ReasonMsg = "Minigun";
					}
				}
				else ReasonMsg = "Minigun";
			}
			case 41: ReasonMsg = "Spraycan";
			case 42: ReasonMsg = "Fire Extinguisher";
			case 49: ReasonMsg = "Vehicle Collision";
			case 50:
			{
				if(pstate == PLAYER_STATE_DRIVER)
				{
					switch(model)
					{
						case 417, 425, 447, 465, 469, 487, 488, 497, 501, 548, 563: ReasonMsg = "Helicopter Blades";
						default: ReasonMsg = "Vehicle Collision";
					}
				}
				else ReasonMsg = "Vehicle Collision";
			}
			case 51:
			{
				if(pstate == PLAYER_STATE_DRIVER)
				{
					switch(model)
					{
						case 425: ReasonMsg = "Hunter Rockets";
						case 432: ReasonMsg = "Rhino Turret";
						case 520: ReasonMsg = "Hydra Rockets";
						default: ReasonMsg = "Explosion";
					}
				}
				else ReasonMsg = "Explosion";
			}
			default: ReasonMsg = "Unknown";
		}
	}
	if(killerid == INVALID_PLAYER_ID)
	{
		switch (reason)
		{
			case 53: ReasonMsg = "Drowned";
			case 54: ReasonMsg = "Collision";
			default: ReasonMsg = "Died";
		}
	}
	return ReasonMsg;
}

stock GetICName(playerid)
{
    new ICName[MAX_PLAYER_NAME+1];
	if(Masked[playerid] == 1)
	{
		format(ICName, sizeof(ICName), "%s", MaskedName[playerid]);
		return ICName;
	}
    if(IsPlayerConnected(playerid))
    {
		GetPlayerName(playerid, ICName, sizeof(ICName));
		for(new i = 0; i < MAX_PLAYER_NAME; i++)
		{
			if(ICName[i] == '_') ICName[i] = ' ';
		}
	}
	else
	{
	    ICName = "None";
	}
	return ICName;
}


stock GetGender(playerid)
{
	new PlayerGender[60];
    if(PlayerStat[playerid][Gender] == 1)
    {
        PlayerGender = "Male";
	}
	else
	{
	    PlayerGender = "Female";
	}

	return PlayerGender;
}

stock GetJob(playerid)
{
	new Job[60];
    if(PlayerStat[playerid][JobID] >= 1)
    {
       if(PlayerStat[playerid][JobID] == 1) Job = "Garbage Man";
       if(PlayerStat[playerid][JobID] == 2) Job = "Table Cleaner";
       if(PlayerStat[playerid][JobID] == 3) Job = "Laundry Worker";
       if(PlayerStat[playerid][JobID] == 4) Job = "Warehouse Worker";
	}
	else
	{
	    Job = "None";
	}
	return Job;
}

stock GetGangRank(playerid)
{
	new Rank[60];
    if(PlayerStat[playerid][GangID] >= 1)
    {
       if(PlayerStat[playerid][GangRank] == 1) format(Rank, sizeof(Rank), "%s", GangStat[PlayerStat[playerid][GangID]][Rank1]);
       if(PlayerStat[playerid][GangRank] == 2) format(Rank, sizeof(Rank), "%s", GangStat[PlayerStat[playerid][GangID]][Rank2]);
       if(PlayerStat[playerid][GangRank] == 3) format(Rank, sizeof(Rank), "%s", GangStat[PlayerStat[playerid][GangID]][Rank3]);
       if(PlayerStat[playerid][GangRank] == 4) format(Rank, sizeof(Rank), "%s", GangStat[PlayerStat[playerid][GangID]][Rank4]);
       if(PlayerStat[playerid][GangRank] == 5) format(Rank, sizeof(Rank), "%s", GangStat[PlayerStat[playerid][GangID]][Rank5]);
       if(PlayerStat[playerid][GangRank] == 6) format(Rank, sizeof(Rank), "%s", GangStat[PlayerStat[playerid][GangID]][Rank6]);
	}
	else
	{
	    Rank = "None";
	}
	return Rank;
}

stock GetGangName(playerid)
{
	new Gang[60];
    if(PlayerStat[playerid][GangID] >= 1)
    {
       format(Gang, sizeof(Gang), "%s", GangStat[PlayerStat[playerid][GangID]][GangName]);
	}
	else
	{
	    Gang = "None";
	}
	return Gang;
}

stock GetDonationLevel(playerid)
{
	new Donation[60];
	if(PlayerStat[playerid][DonLV] == 0) Donation = "None";
    if(PlayerStat[playerid][DonLV] == 1) Donation = "Bronze";
    if(PlayerStat[playerid][DonLV] == 2) Donation = "Silver";
    if(PlayerStat[playerid][DonLV] == 3) Donation = "Gold";
	return Donation;
}

stock GetForumName(playerid)
{
	new AdminName[128];
    if(PlayerStat[playerid][Aname] >= 1)
    {
       if(PlayerStat[playerid][Aname] == 1) AdminName = "{FF1919}Marco{FFFFFF}";
	   if(PlayerStat[playerid][Aname] == 2) AdminName = "{FF1919}Jacob{FFFFFF}";
       if(PlayerStat[playerid][Aname] == 3) AdminName = "{70C470}Thekillergreece{FFFFFF}";
	   if(PlayerStat[playerid][Aname] == 4) AdminName = "{70C470}Ecko{FFFFFF}";
	   if(PlayerStat[playerid][Aname] == 5) AdminName = "{70C470}Nace{FFFFFF}";
	   if(PlayerStat[playerid][Aname] == 6) AdminName = "{70C470}Zeeko{FFFFFF}";
	   if(PlayerStat[playerid][Aname] == 7) AdminName = "{70C470}Bernard{FFFFFF}";
	   if(PlayerStat[playerid][Aname] == 8) AdminName = "{FF1919}Bronny{FFFFFF}";
	   if(PlayerStat[playerid][Aname] == 9) AdminName = "{00FFFF}Kiddo{FFFFFF}";
	   if(PlayerStat[playerid][Aname] == 10) AdminName = "{00FFFF}David{FFFFFF}";
	   if(PlayerStat[playerid][Aname] == 11) AdminName = "{00FFFF}Dorito{FFFFFF}";
	   if(PlayerStat[playerid][Aname] == 12) AdminName = "{00FFFF}Wizardry{FFFFFF}";
	   if(PlayerStat[playerid][Aname] == 13) AdminName = "{00FFFF}Xray{FFFFFF}";
	   if(PlayerStat[playerid][Aname] == 999) AdminName = "{00FFFF}Hidden{FFFFFF}";
	}
	else
	{
	    AdminName = "{00FFFF}Unset{FFFFFF}";
	}
	return AdminName;
}

stock GetForumNameNC(playerid)
{
	new AdminName[60];
    if(PlayerStat[playerid][Aname] >= 1)
    {
       if(PlayerStat[playerid][Aname] == 1) AdminName = "Marco";
       if(PlayerStat[playerid][Aname] == 2) AdminName = "Jacob";
	   if(PlayerStat[playerid][Aname] == 3) AdminName = "Thekillergreece";
	   if(PlayerStat[playerid][Aname] == 4) AdminName = "Ecko";
	   if(PlayerStat[playerid][Aname] == 5) AdminName = "Nace";
	   if(PlayerStat[playerid][Aname] == 6) AdminName = "Zeeko";
	   if(PlayerStat[playerid][Aname] == 7) AdminName = "Bernard";
	   if(PlayerStat[playerid][Aname] == 8) AdminName = "Bronny";
	   if(PlayerStat[playerid][Aname] == 9) AdminName = "Kiddo";
	   if(PlayerStat[playerid][Aname] == 10) AdminName = "David";
	   if(PlayerStat[playerid][Aname] == 11) AdminName = "Dorito";
	   if(PlayerStat[playerid][Aname] == 12) AdminName = "Wizardry";
	   if(PlayerStat[playerid][Aname] == 13) AdminName = "Xray";
	   if(PlayerStat[playerid][Aname] == 999) AdminName = "Hidden";
	}
	else
	{
	    AdminName = GetOOCName(playerid);
	}
	return AdminName;
}

stock GetADuty(playerid)
{
	new AdminDuty[60];
    if(PlayerStat[playerid][ADuty] == 1)
    {
       if(PlayerStat[playerid][ADuty] == 1) AdminDuty = "{00FF00}On Duty{FFFFFF}";
	}
	else
	{
	    AdminDuty = "Off Duty";
	}
	return AdminDuty;
}

stock GetHDuty(playerid)
{
	new HelperDuty[60];
    if(PlayerStat[playerid][HDuty] == 1)
    {
       if(PlayerStat[playerid][HDuty] == 1) HelperDuty = "{00FF00}On Duty{FFFFFF}";
	}
	else
	{
	    HelperDuty = "Off Duty";
	}
	return HelperDuty;
}

stock Gethlvl(playerid)
{
	new HelperNLevel[60];
    if(PlayerStat[playerid][HelperLevel] >= 1)
    {
       if(PlayerStat[playerid][HelperLevel] == 1) HelperNLevel = "Helper"; 
       if(PlayerStat[playerid][HelperLevel] == 2) HelperNLevel = "Head of Helpers";
	}
	else
	{
	    HelperNLevel = "Not Helper";
	}
	return HelperNLevel;
}

stock Getalvl(playerid)
{
	new AdminNLevel[60];
    if(PlayerStat[playerid][AdminLevel] >= 1 || PlayerStat[playerid][HelperLevel] == 1)
    {
		if(PlayerStat[playerid][HelperLevel] == 1) AdminNLevel = "Helper";
		if(PlayerStat[playerid][AdminLevel] == 1) AdminNLevel = "Junior Admin";
		if(PlayerStat[playerid][AdminLevel] == 2) AdminNLevel = "Administrator";
		if(PlayerStat[playerid][AdminLevel] == 3) AdminNLevel = "Senior Administrator";
		if(PlayerStat[playerid][AdminLevel] == 4) AdminNLevel = "Lead Administrator";
		if(PlayerStat[playerid][AdminLevel] == 5) AdminNLevel = "Community Director"; 
	}
	else
	{
	    AdminNLevel = "Not Admin";
	}
	return AdminNLevel;
}

stock GetFactionName(playerid)
{
	new Faction[60];
    if(PlayerStat[playerid][FactionID] >= 1)
    {
       if(PlayerStat[playerid][FactionID] == 1) format(Faction, sizeof(Faction), "Department of Corrections");
       if(PlayerStat[playerid][FactionID] == 2) format(Faction, sizeof(Faction), "Prison Infirmary");
	}
	else
	{
	    Faction = "None";
	}
	return Faction;
}

stock GetFactionRank(playerid)
{
	new Rank[60];
    if(PlayerStat[playerid][FactionID] >= 1)
    {
       if(PlayerStat[playerid][FactionID] == 1)
       {
           if(PlayerStat[playerid][FactionRank] == 1) format(Rank, sizeof(Rank), "Cadet");
           if(PlayerStat[playerid][FactionRank] == 2) format(Rank, sizeof(Rank), "Correction Officer");
           if(PlayerStat[playerid][FactionRank] == 3) format(Rank, sizeof(Rank), "S.Correction Officer");
           if(PlayerStat[playerid][FactionRank] == 4) format(Rank, sizeof(Rank), "Corporal");
           if(PlayerStat[playerid][FactionRank] == 5) format(Rank, sizeof(Rank), "Sergeant");
           if(PlayerStat[playerid][FactionRank] == 6) format(Rank, sizeof(Rank), "Staff Sergeant");
		   if(PlayerStat[playerid][FactionRank] == 7) format(Rank, sizeof(Rank), "Lieutenant");
		   if(PlayerStat[playerid][FactionRank] == 8) format(Rank, sizeof(Rank), "Captain");
		   if(PlayerStat[playerid][FactionRank] == 9) format(Rank, sizeof(Rank), "Executive Assistant");
		   if(PlayerStat[playerid][FactionRank] == 10) format(Rank, sizeof(Rank), "Deputy Warden");
		   if(PlayerStat[playerid][FactionRank] == 11) format(Rank, sizeof(Rank), "Warden");

       }
       else if(PlayerStat[playerid][FactionID] == 2) //NIGGA
       {
           if(PlayerStat[playerid][FactionRank] == 1) format(Rank, sizeof(Rank), "Cadet");
           if(PlayerStat[playerid][FactionRank] == 2) format(Rank, sizeof(Rank), "Officer");
           if(PlayerStat[playerid][FactionRank] == 3) format(Rank, sizeof(Rank), "Sergeant");
           if(PlayerStat[playerid][FactionRank] == 4) format(Rank, sizeof(Rank), "Lieutenant");
           if(PlayerStat[playerid][FactionRank] == 5) format(Rank, sizeof(Rank), "Commander");
           if(PlayerStat[playerid][FactionRank] == 6) format(Rank, sizeof(Rank), "Warden");
       }
	}
	else
	{
	    Rank = "None";
	}
	return Rank;
}

stock IsValidName(playerid)
{
    new CheckName[MAX_PLAYER_NAME];
    if(IsPlayerConnected(playerid))
    {
        GetPlayerName(playerid, CheckName, sizeof(CheckName));
        for(new i = 0; i < MAX_PLAYER_NAME; i++)
        {
            if (CheckName[i] == '_') return 1;
            if (CheckName[i] == ']' || CheckName[i] == '[') return 0;
        }
    }
    return 0;
}

stock Accounts(playerid)
{
  new PlayerAcc[128];
  format(PlayerAcc,128,"Accounts/%s.ini",GetOOCName(playerid));
  return PlayerAcc;
}

stock GiveMoney(playerid, money)
{
    PlayerStat[playerid][Money] += money;
    GivePlayerMoney(playerid, money);
    return 1;
}

stock SetMoney(playerid, money)
{
    PlayerStat[playerid][Money] = money;
    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid, money);
    return 1;
}

stock SetAAname(playerid, AdminName)
{
    PlayerStat[playerid][Aname] = AdminName;
    return 1;
}

stock ResetMoney(playerid, money)
{
    PlayerStat[playerid][Money] = 0;
    ResetPlayerMoney(playerid);
    return 1;
}

stock SetSkin(playerid, skin)
{
    PlayerStat[playerid][LastSkin] = skin;
    SetPlayerSkin(playerid, skin);
    return 1;
}

stock SetHealth(playerid, Float: health)
{
    PlayerStat[playerid][Health] = health;
    SetPlayerHealth(playerid, health);
    return 1;
}

stock SetArmour(playerid, Float: armour)
{
    PlayerStat[playerid][Armour] = armour;
    SetPlayerArmour(playerid, armour);
    return 1;
}

stock IsPlayerInRangeOfPlayer(Float:radius,playerid,targetid)
{
	if(IsPlayerConnected(playerid) && IsPlayerConnected(targetid))
	{
		new Float:posx, Float:posy, Float:posz;
		GetPlayerPos(playerid, posx, posy, posz);
		if(IsPlayerInRangeOfPoint(targetid,radius,posx,posy,posz))
		{
		    return 1;
  		}
	}
	return 0;
}

stock IsPlayerInCell(playerid)
{
	if(IsPlayerConnected(playerid) && PlayerStat[playerid][HasCell] == 1 && GetPlayerVirtualWorld(playerid) == CellStat[PlayerStat[playerid][Cell]][VW])
	{
		if(IsPlayerInRangeOfPoint(playerid,10.0,CellStat[PlayerStat[playerid][Cell]][InteriorX],CellStat[PlayerStat[playerid][Cell]][InteriorY],CellStat[PlayerStat[playerid][Cell]][InteriorZ]))
		{
		    return 1;
  		}
	}
	return 0;
}

stock CreateCell(Cost, Float:Exteriorx, Float:Exteriory, Float:Exteriorz, Float:Interiorx, Float:Interiory, Float:Interiorz)
{
	new CellID, CellFile[20];
	CellID = Server[LoadedCells]+1;
    format(CellFile, 20, "Cells/Cell %d.ini", CellID);
    if(INI_Open(CellFile))
	{
		new str[128];
        CellStat[CellID][CellPrice] = Cost;
        format(CellStat[CellID][CellOwner], 60, "Nobody");
        CellStat[CellID][Owned] = 0;

        CellStat[CellID][VW] = 0;
        CellStat[CellID][Locked] = 1;

        CellStat[CellID][ExteriorX] = Exteriorx;
        CellStat[CellID][ExteriorY] = Exteriory;
        CellStat[CellID][ExteriorZ] = Exteriorz;
        CellStat[CellID][InteriorX] = Interiorx;
        CellStat[CellID][InteriorY] = Interiory;
        CellStat[CellID][InteriorZ] = Interiorz;

        CellStat[CellID][CellLevel] = 1;
        CellStat[CellID][CellPot] = 0;
        CellStat[CellID][CellCrack] = 0;
        CellStat[CellID][CellWeap1] = 0;
        CellStat[CellID][CellWeap2] = 0;

        INI_WriteInt("Price",CellStat[CellID][CellPrice]);
        INI_WriteString("Owner",CellStat[CellID][CellOwner]);
        INI_WriteInt("Owned",CellStat[CellID][Owned]);

        INI_WriteInt("VW",CellStat[CellID][VW]);
        INI_WriteInt("Locked",CellStat[CellID][Locked]);

        INI_WriteFloat("ExteriorX",CellStat[CellID][ExteriorX]);
        INI_WriteFloat("ExteriorY",CellStat[CellID][ExteriorY]);
        INI_WriteFloat("ExteriorZ",CellStat[CellID][ExteriorZ]);
		INI_WriteFloat("InteriorX",CellStat[CellID][InteriorX]);
        INI_WriteFloat("InteriorY",CellStat[CellID][InteriorY]);
        INI_WriteFloat("InteriorZ",CellStat[CellID][InteriorZ]);

        INI_WriteInt("Level",CellStat[CellID][CellLevel]);
        INI_WriteInt("Pot",CellStat[CellID][CellPot]);
        INI_WriteInt("Crack",CellStat[CellID][CellCrack]);
        INI_WriteInt("Weap1",CellStat[CellID][CellWeap1]);
        INI_WriteInt("Weap2",CellStat[CellID][CellWeap2]);

        INI_Save();
        INI_Close();

        format(str, sizeof(str), "Cell ID %d\nOwner: %s\nThis Cell is available for $%d.", CellID, CellStat[CellID][CellOwner], CellStat[CellID][CellPrice]);
        CellStat[CellID][TextLabel] = Create3DTextLabel(str, WHITE, CellStat[CellID][ExteriorX], CellStat[CellID][ExteriorY], CellStat[CellID][ExteriorZ] + 0.75, 3.5, 0, 0);
        CellStat[CellID][PickupID] = CreateDynamicPickup(1273, 23, CellStat[CellID][ExteriorX], CellStat[CellID][ExteriorY], CellStat[CellID][ExteriorZ] + 0.75, 0);

        Server[LoadedCells]++;
    }
	return 1;
}

stock SaveCell(CellID)
{
	new CellFile[20];
    format(CellFile, 20, "Cells/Cell %d.ini", CellID);
    if(INI_Open(CellFile))
	{
        INI_WriteInt("Price",CellStat[CellID][CellPrice]);
        INI_WriteString("Owner",CellStat[CellID][CellOwner]);
        INI_WriteInt("Owned",CellStat[CellID][Owned]);

        INI_WriteInt("VW",CellStat[CellID][VW]);
        INI_WriteInt("Locked",CellStat[CellID][Locked]);

        INI_WriteFloat("ExteriorX",CellStat[CellID][ExteriorX]);
        INI_WriteFloat("ExteriorY",CellStat[CellID][ExteriorY]);
        INI_WriteFloat("ExteriorZ",CellStat[CellID][ExteriorZ]);
        INI_WriteFloat("InteriorX",CellStat[CellID][InteriorX]);
        INI_WriteFloat("InteriorY",CellStat[CellID][InteriorY]);
        INI_WriteFloat("InteriorZ",CellStat[CellID][InteriorZ]);

        INI_WriteInt("Level",CellStat[CellID][CellLevel]);
        INI_WriteInt("Pot",CellStat[CellID][CellPot]);
        INI_WriteInt("Crack",CellStat[CellID][CellCrack]);
        INI_WriteInt("Weap1",CellStat[CellID][CellWeap1]);
        INI_WriteInt("Weap2",CellStat[CellID][CellWeap2]);
        INI_Save();
        INI_Close();
    }
	return 1;
}

stock SaveGang(gangid)
{
    format(GangStat[gangid][GangFile], 20, "Gangs/Gang %d.ini", gangid);
    if(INI_Open(GangStat[gangid][GangFile]))
    {

        INI_WriteString("Leader", GangStat[gangid][Leader]);
		INI_WriteString("Name", GangStat[gangid][GangName]);
		INI_WriteString("MOTD", GangStat[gangid][MOTD]);

		INI_WriteString("Rank1", GangStat[gangid][Rank1]);
		INI_WriteString("Rank2", GangStat[gangid][Rank2]);
		INI_WriteString("Rank3", GangStat[gangid][Rank3]);
		INI_WriteString("Rank4", GangStat[gangid][Rank4]);
		INI_WriteString("Rank5", GangStat[gangid][Rank5]);
		INI_WriteString("Rank6", GangStat[gangid][Rank6]);

		INI_WriteInt("Skin1", GangStat[gangid][Skin1]);
		INI_WriteInt("Skin2", GangStat[gangid][Skin2]);
		INI_WriteInt("Skin3", GangStat[gangid][Skin3]);
		INI_WriteInt("Skin4", GangStat[gangid][Skin4]);
		INI_WriteInt("Skin5", GangStat[gangid][Skin5]);
		INI_WriteInt("Skin6", GangStat[gangid][Skin6]);
		INI_WriteInt("fSkin", GangStat[gangid][fSkin]);

		INI_WriteInt("Members", GangStat[gangid][Members]);

		INI_WriteInt("Color", GangStat[gangid][Color]);

		INI_Save();
		INI_Close();
    }
	return 1;
}

public PreloadAnimLib(playerid, animlib[])
{
	ApplyAnimation(playerid,animlib,"null",0.0,0,0,0,0,0);
	return 1;
}


public ApplyLoopingAnimation(playerid,animlib[],animname[], Float:Speed, looping, lockx, locky, lockz, lp)
{
    if(IsPlayerInAnyVehicle(playerid))
	{
	    SendClientMessage(playerid, GREY, "You can not use animations in a vehicle.");
	}
	if(PlayerStat[playerid][Dead] == 1 || PlayerStat[playerid][InHospital] == 1) return SendClientMessage(playerid, GREY, "You are unconscious.");
	if(PlayerStat[playerid][BeingDragged] == 1 || PlayerStat[playerid][Cuffed] == 1) return SendClientMessage(playerid, GREY, "You are cuffed or being dragged.");
	else
	{
        ApplyAnimation(playerid, animlib, animname, Speed, looping, lockx, locky, lockz, lp);
        PlayerStat[playerid][UsingLoopingAnims] = 1;
        TextDrawShowForPlayer(playerid, AnimationTextDraw);
    }
	return 1;
}

public StopLoopingAnimation(playerid)
{
    PlayerStat[playerid][UsingLoopingAnims] = 0;
    ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
    TextDrawHideForPlayer(playerid, AnimationTextDraw);
	return 1;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if(playerid == hitid) return 0;
	new Float: fHealth;
	if(weaponid == 24 && PlayerStat[hitid][ADuty] == 0)
    {
		if(playerid == hitid) return 0;
		GetPlayerHealth(hitid, fHealth);
		SetHealth(hitid, fHealth - 25.0);
    }
	if(weaponid == 22 && PlayerStat[hitid][ADuty] == 0)
    {
		if(playerid == hitid) return 0;
		GetPlayerHealth(hitid, fHealth);
		SetHealth(hitid, fHealth - 20.0);
    }
    if(weaponid == 31 && PlayerStat[hitid][ADuty] == 0)
    {
		if(playerid == hitid) return 0;
		GetPlayerHealth(hitid, fHealth);
		SetHealth(hitid, fHealth - 60.0);
    }
    if(weaponid == 30 && PlayerStat[hitid][ADuty] == 0)
    {
		if(playerid == hitid) return 0;
		GetPlayerHealth(hitid, fHealth);
		SetHealth(hitid, fHealth - 70.0);
    }
    if(weaponid == 29 && PlayerStat[hitid][ADuty] == 0)
    {
		if(playerid == hitid) return 0;
		GetPlayerHealth(hitid, fHealth);
		SetHealth(hitid, fHealth - 35.0);
    }
    if(weaponid == 25 && PlayerStat[hitid][ADuty] == 0)
    {
		if(playerid == hitid) return 0;
		GetPlayerHealth(hitid, fHealth);
		TogglePlayerControllable(hitid, false);
		SetHealth(hitid, fHealth + 4.0);
		PlayerStat[hitid][Tased] = 1;
		ApplyAnimation(hitid, "PED", "FLOOR_hit_f", 4.1, 0, 0, 0, 1, 0);
		SetTimerEx("RemoveTaseEffect", 10000, false, "d", hitid);
		SendClientMessage(hitid, RED, "You've been hit by a beanbag bullet, and you are paralyzed for 10 seconds!");
    }
	return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid, bodypart)
{
	new Float: fHealth;
	new Float: cArmor;
	GetPlayerArmour(playerid, cArmor);
	if(weaponid >= 0 && PlayerAFK[playerid] == 1)
	{	
		GetPlayerHealth(playerid, fHealth);
		SetPlayerHealth(playerid, fHealth - 0.0);
		return 1;
	}
	if(weaponid >= 0 && PNewReg[playerid] == 1)
	{	
		GetPlayerHealth(playerid, fHealth);
		SetPlayerHealth(playerid, fHealth - 0.0);
		SetPlayerHealth(playerid, 100);
		return 1;
	}
	if(weaponid >= 0 && PNewReg[playerid] == 0 && PNewReg[issuerid] == 1)
	{
		new str1[128];
		format(str1, sizeof(str1), "[WARNING] Player %s [ID:%d] (awaiting registration) has managed to attack %s [ID:%d].", GetOOCName(issuerid), issuerid, GetOOCName(playerid), playerid);
		SendAdminMessage(RED, str1);
	}
	if(PlayerStat[playerid][ADuty] == 1 && PlayerStat[playerid][AdminLevel] >= 1)
	{
		SetHealth(playerid, 100);
		SetArmour(playerid, 100);
	}
    if(weaponid == 0 && PlayerStat[playerid][ADuty] == 0)
    {
		if(playerid == issuerid) return 1;
        if(PlayerStat[issuerid][StatPWR] >= 16)
		{
            	GetPlayerHealth(playerid, fHealth);
				SetHealth(playerid, fHealth - 8.0);
				return 1;
		}
		else if(PlayerStat[issuerid][StatPWR] >= 5)
		{
            	GetPlayerHealth(playerid, fHealth);
				SetHealth(playerid, fHealth - 6.0);
				return 1;
		}
		else if(PlayerStat[issuerid][StatPWR] <= 4)
		{
            	GetPlayerHealth(playerid, fHealth);
				SetHealth(playerid, fHealth - 4.0);
				return 1;
		}
    }
	if(issuerid != INVALID_PLAYER_ID) // If not self-inflicted
	{
		if(bodypart == 9 && weaponid == 34 && PlayerStat[playerid][ADuty] == 0)
		{
			SetPlayerHealth(playerid, 0);
		}
		if(weaponid == 1 && cArmor <= 0) // Knuckle
		{
			GetPlayerHealth(playerid, fHealth);
			SetPlayerHealth(playerid, fHealth - 4.0);
		}
		if(weaponid == 3 && cArmor <= 0) // Nite Stick
		{
			GetPlayerHealth(playerid, fHealth);
			SetPlayerHealth(playerid, fHealth - 8.0);
		}
		if(weaponid == 4) //Knife
		{
			GetPlayerHealth(playerid, fHealth);
			SetPlayerHealth(playerid, fHealth - 13.0);
			new Random1 = random(5);
			if(!(Random1 == 3))
			{
				PlayerStat[playerid][BleedingWound]++;
			}
			if(PlayerStat[playerid][BleedingWound] >= 1)
			{
				new Random2 = random(2);
				if(Random2 == 2)
				{
					SetTimerEx("BleedingWoundTimer", 10000, true, "i", playerid);
				}
			}
		}
		if(weaponid == 5) // Bat
		{
			GetPlayerHealth(playerid, fHealth);
			SetPlayerHealth(playerid, fHealth - 6.0);
		}
		if(weaponid == 15 && cArmor <= 0) // Stick
		{
			GetPlayerHealth(playerid, fHealth);
			SetPlayerHealth(playerid, fHealth - 3.0);
		}
	}
	return 1;
}

stock GMX()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		SavePlayerData(i);
	}
	for(new c = 0; c < Server[LoadedCells]; c++)
	{
		SaveCell(c);
	}
	for(new g = 1; g < MAX_GANGS; g++)
	{
		SaveGang(g);
	}
    return 1;
}

public ShowStatsForPlayer(playerid, targetid)
{
	new Float:CUArmour, Float:CUHealth;
	GetPlayerArmour(playerid, CUArmour);
	GetPlayerHealth(playerid, CUHealth);
	new str[180];
	if(PlayerStat[playerid][DonLV] == 0)
	{
	SendClientMessage(targetid, GREEN, "__________________________________________________________________________________________________________________________________________________________________________________________________________");
	format(str, 180, "Name: %s | IP: %s | Gender: %s | Age: %d | In Prison For: %s .", GetICName(playerid), PlayerStat[playerid][LastIP], GetGender(playerid), PlayerStat[playerid][Age], PlayerStat[playerid][Reason]);
	SendClientMessage(targetid, GREY, str);
	format(str, 180, "Helper Level: %d | Admin Level: %d | Times Kicked: %d | Times Banned: %d | Warnings: %d (/warnings for more info).", PlayerStat[playerid][HelperLevel], PlayerStat[playerid][AdminLevel], PlayerStat[playerid][TimesKicked], PlayerStat[playerid][TimesBanned], PlayerStat[playerid][Warnings]);
	SendClientMessage(targetid, GREY, str);
    format(str, 180, "Money: $%d | Locker Money: $%d | Next Paycheck: $%d | Current Job: %s | Hours Passed in Job: %d | Donation: None.", PlayerStat[playerid][Money], PlayerStat[playerid][LockerMoney], PlayerStat[playerid][Paycheck], GetJob(playerid), PlayerStat[playerid][HoursInJob]);
	SendClientMessage(targetid, GREY, str);
	format(str, 180, "Playing Hours: %d | Gang: %s (ID: %d) | Gang Rank: %s (%d) | Faction: %s | Faction Rank: %s.", PlayerStat[playerid][PlayingHours], GetGangName(playerid), PlayerStat[playerid][GangID], GetGangRank(playerid), PlayerStat[playerid][GangRank], GetFactionName(playerid), GetFactionRank(playerid)); 
	SendClientMessage(targetid, GREY, str);
	format(str, 180, "Payday minutes: %d | Pot: %d | Crack: %d | Kills: %d | Deaths: %d  | Health : %f | Armour: %f.", PlayerStat[playerid][PlayingMinutes], PlayerStat[playerid][Pot], PlayerStat[playerid][Crack], PlayerStat[playerid][Kills], PlayerStat[playerid][Deaths], CUHealth, CUArmour);
	SendClientMessage(targetid, GREY, str);
	SendClientMessage(targetid, GREEN, "__________________________________________________________________________________________________________________________________________________________________________________________________________");
	}
	if(PlayerStat[playerid][DonLV] == 1)
	{
	SendClientMessage(targetid, GREEN, "__________________________________________________________________________________________________________________________________________________________________________________________________________");
	format(str, 180, "Name: %s | IP: %s | Gender: %s | Age: %d | In Prison For: %s | Interior: %d | Virtual World: %d.", GetICName(playerid), PlayerStat[playerid][LastIP], GetGender(playerid), PlayerStat[playerid][Age], PlayerStat[playerid][Reason], GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
	SendClientMessage(targetid, GREY, str);
	format(str, 180, "Helper Level: %d | Admin Level: %d | Times Kicked: %d | Times Banned: %d | Warnings: %d (/warnings for more info).", PlayerStat[playerid][HelperLevel], PlayerStat[playerid][AdminLevel], PlayerStat[playerid][TimesKicked], PlayerStat[playerid][TimesBanned], PlayerStat[playerid][Warnings]);
	SendClientMessage(targetid, GREY, str);
    format(str, 180, "Money: $%d | Locker Money: $%d | Next Paycheck: $%d | Current Job: %s | Hours Passed in Job: %d | Donation: Bronze.", PlayerStat[playerid][Money], PlayerStat[playerid][LockerMoney], PlayerStat[playerid][Paycheck], GetJob(playerid), PlayerStat[playerid][HoursInJob]);
	SendClientMessage(targetid, GREY, str);
	format(str, 180, "Playing Hours: %d | Gang: %s (ID: %d) | Gang Rank: %s (%d) | Faction: %s | Faction Rank: %s.", PlayerStat[playerid][PlayingHours], GetGangName(playerid), PlayerStat[playerid][GangID], GetGangRank(playerid), PlayerStat[playerid][GangRank], GetFactionName(playerid), GetFactionRank(playerid));
	SendClientMessage(targetid, GREY, str);
	format(str, 180, "Payday minutes: %d | Pot: %d | Crack: %d | Kills: %d | Deaths: %d  | Health : %f | Armour: %f.", PlayerStat[playerid][PlayingMinutes], PlayerStat[playerid][Pot], PlayerStat[playerid][Crack], PlayerStat[playerid][Kills], PlayerStat[playerid][Deaths], CUHealth, CUArmour);
	SendClientMessage(targetid, GREY, str);
	SendClientMessage(targetid, GREEN, "__________________________________________________________________________________________________________________________________________________________________________________________________________");	}
	else if(PlayerStat[playerid][DonLV] == 2)
 	{
	SendClientMessage(targetid, GREEN, "__________________________________________________________________________________________________________________________________________________________________________________________________________");
	format(str, 180, "Name: %s | IP: %s | Gender: %s | Age: %d | In Prison For: %s | Interior: %d | Virtual World: %d.", GetICName(playerid), PlayerStat[playerid][LastIP], GetGender(playerid), PlayerStat[playerid][Age], PlayerStat[playerid][Reason], GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
	SendClientMessage(targetid, SILVER, str);
	format(str, 180, "Helper Level: %d | Admin Level: %d | Times Kicked: %d | Times Banned: %d | Warnings: %d (/warnings for more info).", PlayerStat[playerid][HelperLevel], PlayerStat[playerid][AdminLevel], PlayerStat[playerid][TimesKicked], PlayerStat[playerid][TimesBanned], PlayerStat[playerid][Warnings]);
	SendClientMessage(targetid, SILVER, str);
    format(str, 180, "Money: $%d | Locker Money: $%d | Next Paycheck: $%d | Current Job: %s | Hours Passed in Job: %d | Donation: Silver.", PlayerStat[playerid][Money], PlayerStat[playerid][LockerMoney], PlayerStat[playerid][Paycheck], GetJob(playerid), PlayerStat[playerid][HoursInJob]);
	SendClientMessage(targetid, SILVER, str);
	format(str, 180, "Playing Hours: %d | Gang: %s (ID: %d) | Gang Rank: %s (%d) | Faction: %s | Faction Rank: %s.", PlayerStat[playerid][PlayingHours], GetGangName(playerid), PlayerStat[playerid][GangID], GetGangRank(playerid), PlayerStat[playerid][GangRank], GetFactionName(playerid), GetFactionRank(playerid));
	SendClientMessage(targetid, SILVER, str);
	format(str, 128, "Payday minutes: %d | Pot: %d | Crack: %d | Kills: %d | Deaths: %d  | Health : %f | Armour: %f.", PlayerStat[playerid][PlayingMinutes], PlayerStat[playerid][Pot], PlayerStat[playerid][Crack], PlayerStat[playerid][Kills], PlayerStat[playerid][Deaths], CUHealth, CUArmour);
	SendClientMessage(targetid, SILVER, str);
	SendClientMessage(targetid, GREEN, "__________________________________________________________________________________________________________________________________________________________________________________________________________");	}
	else if(PlayerStat[playerid][DonLV] == 3)
 	{
	SendClientMessage(targetid, GREEN, "__________________________________________________________________________________________________________________________________________________________________________________________________________");
	format(str, 180, "Name: %s | IP: %s | Gender: %s | Age: %d | In Prison For: %s | Interior: %d | Virtual World: %d.", GetICName(playerid), PlayerStat[playerid][LastIP], GetGender(playerid), PlayerStat[playerid][Age], PlayerStat[playerid][Reason], GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
	SendClientMessage(targetid, GOLD, str);
	format(str, 180, "Helper Level: %d | Admin Level: %d | Times Kicked: %d | Times Banned: %d | Warnings: %d (/warnings for more info).", PlayerStat[playerid][HelperLevel], PlayerStat[playerid][AdminLevel], PlayerStat[playerid][TimesKicked], PlayerStat[playerid][TimesBanned], PlayerStat[playerid][Warnings]);
	SendClientMessage(targetid, GOLD, str);
    format(str, 180, "Money: $%d | Locker Money: $%d | Next Paycheck: $%d | Current Job: %s | Hours Passed in Job: %d | Donation: Golden.", PlayerStat[playerid][Money], PlayerStat[playerid][LockerMoney], PlayerStat[playerid][Paycheck], GetJob(playerid), PlayerStat[playerid][HoursInJob]);
	SendClientMessage(targetid, GOLD, str);
	format(str, 180, "Playing Hours: %d | Gang: %s (ID: %d) | Gang Rank: %s (%d) | Faction: %s | Faction Rank: %s.", PlayerStat[playerid][PlayingHours], GetGangName(playerid), PlayerStat[playerid][GangID], GetGangRank(playerid), PlayerStat[playerid][GangRank], GetFactionName(playerid), GetFactionRank(playerid));
	SendClientMessage(targetid, GOLD, str);
	format(str, 180, "Payday minutes: %d | Pot: %d | Crack: %d | Kills: %d | Deaths: %d  | Health : %f | Armour: %f.", PlayerStat[playerid][PlayingMinutes], PlayerStat[playerid][Pot], PlayerStat[playerid][Crack], PlayerStat[playerid][Kills], PlayerStat[playerid][Deaths], CUHealth, CUArmour);
	SendClientMessage(targetid, GOLD, str);
	SendClientMessage(targetid, GREEN, "__________________________________________________________________________________________________________________________________________________________________________________________________________");
	}
}

stock ShowWarnings(playerid, targetid)
{
	new str[128];
	SendClientMessage(playerid, GREEN, "-------------------------------------------------------------------");
    format(str, sizeof(str), "%s's Warnings:", GetOOCName(targetid));
    SendClientMessage(playerid, GREY, str);
    format(str, sizeof(str), "First Warning: %s.", PlayerStat[targetid][Warn1]);
    SendClientMessage(playerid, RED, str);
    format(str, sizeof(str), "Second Warning: %s.", PlayerStat[targetid][Warn2]);
    SendClientMessage(playerid, RED, str);
    SendClientMessage(playerid, RED, "Third Warning: None.");
    SendClientMessage(playerid, GREEN, "-------------------------------------------------------------------");
    return 1;
}

stock PutPlayerInFrontOfPlayer(playerid, targetid)
{
	new Float: A;
	GetPlayerFacingAngle(playerid, A);
	SetPlayerFacingAngle(targetid, A+180);
	return 1;
}

stock GetClosestPlayer(playerid) // Dunno who created this.
{
    new Float:cdist, targetid = -1;
    for(new i; i<MAX_PLAYERS; i++)
    {
        if (IsPlayerConnected(i) && playerid != i && (targetid < 0 || cdist > GetDistanceBetweenPlayers(playerid, i)))
        {
            targetid = i;
            cdist = GetDistanceBetweenPlayers(playerid, i);
        }
    }
    return targetid;
}

public Float:GetDistanceBetweenPlayers(p1,p2) // Dunno who did this too...
{
	new Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2;
	if(!IsPlayerConnected(p1) || !IsPlayerConnected(p2))
	{
		return -1.00;
	}
	GetPlayerPos(p1,x1,y1,z1);
	GetPlayerPos(p2,x2,y2,z2);
	return floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
}

forward RestartMap();
public RestartMap()
{
	SendRconCommand("loadfs MAP");
	return 1;
}

forward ResetPlayer(playerid);
public ResetPlayer(playerid)
{
    PlayerStat[playerid][Spawned] = 0;
	PlayerStat[playerid][Logged] = 0;
    PlayerStat[playerid][WrongPw] = 0;
	PlayerStat[playerid][FullyRegistered] = 0;
    PlayerStat[playerid][CollectingGarbage] = 0;
    PlayerStat[playerid][CleaningTables] = 0;
    PlayerStat[playerid][GuardDuty] = 0;
    PlayerStat[playerid][DoctorDuty] = 0;
    PlayerStat[playerid][Taser] =0;
    PlayerStat[playerid][BeingDragged] = 0;
    PlayerStat[playerid][BeingDraggedBy] = -1;
    PlayerStat[playerid][AnimsPreloaded] = 0;
    PlayerStat[playerid][UsingLoopingAnims] = 0;
    PlayerStat[playerid][SecurityCameraStatus] = 0;
	PlayerStat[playerid][BeingSpeced] = 0;
	PlayerStat[playerid][BeingSpecedBy] = -1;
	PlayerStat[playerid][LockerMoney] = 0;
	PlayerStat[playerid][Paycheck] = 0;
	PlayerStat[playerid][Money] = 0;
	PlayerStat[playerid][Age] = 0;
	PlayerStat[playerid][Gender] = 0;
	PlayerStat[playerid][LastIP] = 0;
	PlayerStat[playerid][PlayingHours] = 0;
	PlayerStat[playerid][PlayingMinutes] = 0;
	PlayerStat[playerid][SpecingID] = 0;
	PlayerStat[playerid][Specing] = 0;
	PlayerStat[playerid][LastSkin] = 0;
	PlayerStat[playerid][Reason] = 0;
	PlayerStat[playerid][Accent] = 0;
	PlayerStat[playerid][LastX] = 0;
	PlayerStat[playerid][LastY] = 0;
	PlayerStat[playerid][LastZ] = 0;
	PlayerStat[playerid][LastA] = 0;
	PlayerStat[playerid][LastInt] = 0;
	PlayerStat[playerid][LastVW] = 0;
	PlayerStat[playerid][FullyRegistered] = 0;
	PlayerStat[playerid][TogOOC] = 0;
	PlayerStat[playerid][TogPM] = 0;
	PlayerStat[playerid][JobID] = 0;
	PlayerStat[playerid][HoursInJob] = 0;
	PlayerStat[playerid][AbleToCollectGarbage] = 0;
	PlayerStat[playerid][AbleToCleanTables] = 0;
	PlayerStat[playerid][AbleToCollectFood] = 0;
	PlayerStat[playerid][JobID1ReloadTime] = 0;
	PlayerStat[playerid][JobID2ReloadTime] = 0;
	PlayerStat[playerid][JobID3ReloadTime] = 0;
	PlayerStat[playerid][JobID4ReloadTime] = 0;
	PlayerStat[playerid][JobID4CHP] = 0;
	PlayerStat[playerid][JobID4BOX] = 0;
	PlayerStat[playerid][AdminLevel] = 0;
	PlayerStat[playerid][AdminCode] = 0;
	PlayerStat[playerid][AdminLogged] = 0;
	PlayerStat[playerid][Muted] = 0;
	PlayerStat[playerid][MuteTime] = 0;
	PlayerStat[playerid][AdminPrisoned] = 0;
	PlayerStat[playerid][AdminPrisonedTime] = 0;
	PlayerStat[playerid][Banned] = 0;
	PlayerStat[playerid][TimesKicked] = 0;
	PlayerStat[playerid][TimesBanned] = 0;
	PlayerStat[playerid][Warnings] = 0;
	PlayerStat[playerid][Warn1] = 0;
	PlayerStat[playerid][Warn2] = 0;
	PlayerStat[playerid][BannedReason] = 0;
	PlayerStat[playerid][HelpmesAnswered] = 0;
	PlayerStat[playerid][HelperLevel] = 0;
	PlayerStat[playerid][hMuted] = 0;
	PlayerStat[playerid][HelpmeReloadTime] = 0;
	PlayerStat[playerid][GangID] = 0;
	PlayerStat[playerid][GangRank] = 0;
	PlayerStat[playerid][GetWeapReloadTime] = 0;
	PlayerStat[playerid][GetDrugsReloadTime] = 0;
	PlayerStat[playerid][Pot] = 0;
	PlayerStat[playerid][Crack] = 0;
	PlayerStat[playerid][Slot0] = 0;
	PlayerStat[playerid][Slot1] = 0;
	PlayerStat[playerid][Slot2] = 0;
	PlayerStat[playerid][Slot3] = 0;
	PlayerStat[playerid][Slot4] = 0;
	PlayerStat[playerid][Slot5] = 0;
	PlayerStat[playerid][Slot6] = 0;
	PlayerStat[playerid][Slot7] = 0;
	PlayerStat[playerid][Slot8] = 0;
	PlayerStat[playerid][Slot9] = 0;
	PlayerStat[playerid][Slot10] = 0;
	PlayerStat[playerid][Slot11] = 0;
	PlayerStat[playerid][UsingCrackReloadTime] = 0;
	PlayerStat[playerid][UsingPotReloadTime] = 0;
	PlayerStat[playerid][FactionID] = 0;
	PlayerStat[playerid][FactionRank] = 0;
	PlayerStat[playerid][Health] = 0;
	PlayerStat[playerid][Armour] = 0;
	PlayerStat[playerid][DeathPosX] = 0;
	PlayerStat[playerid][DeathPosY] = 0;
	PlayerStat[playerid][DeathPosZ] = 0;
	PlayerStat[playerid][DeathWeapon] = 0;
	PlayerStat[playerid][DeathAmmo] = 0;
	PlayerStat[playerid][Dead] = 0;
	PlayerStat[playerid][InHospital] = 0;
	PlayerStat[playerid][Deaths] = 0;
	PlayerStat[playerid][Kills] = 0;
	PlayerStat[playerid][StatPWR] = 0;
	PlayerStat[playerid][StatINT] = 0;
	PlayerStat[playerid][Lighter] = 0;
	PlayerStat[playerid][Lighter] = 0;
	PlayerStat[playerid][Cigars] = 0;
	PlayerStat[playerid][Dices] = 0;
	PlayerStat[playerid][PlasticBags] = 0;
	PlayerStat[playerid][HasCell] = 0;
	PlayerStat[playerid][Cell] = -1;
	PlayerStat[playerid][DonLV] = 0;
	PlayerStat[playerid][DeathT] = 0;
	PlayerStat[playerid][Aname] = 0;
	PlayerStat[playerid][ADuty] = 0;
	PlayerStat[playerid][HDuty] = 0;
	PlayerStat[playerid][Joint] = 0;
	PlayerStat[playerid][JRACD] = 0;
	PlayerStat[playerid][JRCD] = 0;
	PlayerStat[playerid][JSCD] = 0;
	PlayerStat[playerid][CUCD] = 0;
	PlayerStat[playerid][CSCD] = 0;
	PlayerStat[playerid][BPUSE] = 0;
	PlayerStat[playerid][BPDIF] = 0;
	PlayerStat[playerid][BPCD] = 0;
	PlayerStat[playerid][BPACD] = 0;
	PlayerStat[playerid][BPANM] = 0;
	PlayerStat[playerid][BPNMB] = 0;
	PlayerStat[playerid][BPBAR] = 0;
	PlayerStat[playerid][LogoutCuffs] = 0;
	PlayerStat[playerid][BleedingWound] = 0;
	PlayerStat[playerid][NameChangeTicket] = 0;
	PlayerStat[playerid][Answer1] = 0;
	PlayerStat[playerid][Answer2] = 0;
	PlayerStat[playerid][Answer3] = 0;
	PlayerStat[playerid][Answer4] = 0;
	PlayerStat[playerid][Answer5] = 0;
	PlayerStat[playerid][WeaponSlot0] = 0;
	PlayerStat[playerid][WeaponSlot1] = 0;
	PlayerStat[playerid][WeaponSlot2] = 0;
	PlayerStat[playerid][WeaponSlot0Ammo] = 0;
	PlayerStat[playerid][WeaponSlot1Ammo] = 0;
	PlayerStat[playerid][WeaponSlot2Ammo] = 0;
	PlayerStat[playerid][WeaponPocketCD] = 0;
	PlayerStat[playerid][FightStyle] = 0;
	PlayerStat[playerid][INV_SLOT1] = 0;
	PlayerStat[playerid][INV_SLOT1A] = 0;
	PlayerStat[playerid][INV_SLOT2] = 0;
	PlayerStat[playerid][INV_SLOT2A] = 0;
	PlayerStat[playerid][INV_SLOT3] = 0;
	PlayerStat[playerid][INV_SLOT3A] = 0;
	PlayerStat[playerid][INV_SLOT4] = 0;
	PlayerStat[playerid][INV_SLOT4A] = 0;
	PlayerStat[playerid][INV_SLOT5] = 0;
	PlayerStat[playerid][INV_SLOT5A] = 0;
	PlayerStat[playerid][INV_SLOT6] = 0;
	PlayerStat[playerid][INV_SLOT6A] = 0;
	PlayerStat[playerid][INV_SLOT7] = 0;
	PlayerStat[playerid][INV_SLOT7A] = 0;
	PlayerStat[playerid][INV_SLOT8] = 0;
	PlayerStat[playerid][INV_SLOT8A] = 0;
	PlayerStat[playerid][INV_SLOT9] = 0;
	PlayerStat[playerid][INV_SLOT9A] = 0;
	PlayerStat[playerid][INV_SLOT10] = 0;
	PlayerStat[playerid][INV_SLOT10A] = 0;
	PlayerStat[playerid][MetSkill] = 0;
	PlayerStat[playerid][WodSkill] = 0;
	PlayerStat[playerid][CrfSkill] = 0;
	PlayerStat[playerid][MetSkillXP] = 0;
	PlayerStat[playerid][WodSkillXP] = 0;
	PlayerStat[playerid][CrfSkillXP] = 0;
    ToggleCheckpoints(playerid);
    return 1;
}

stock ClearChat()
{
    for (new c = 0; c < 150; c++)
    {
        SendClientMessageToAll(WHITE, " ");
    }
}

stock ClearChatForPlayer(playerid)
{
    for (new c = 0; c < 150; c++)
    {
        SendClientMessage(playerid, WHITE, " ");
    }
}

stock IsVehicleOccupied(vehicleid)
{
    for(new i=0; i  <MAX_PLAYERS; i++)
    {
        if(IsPlayerInVehicle(i, vehicleid)) return 1;
    }
    return 0;
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

stock ICLog(str[])
{
    new File:lFile = fopen("Logs/ICLog.txt", io_append);
    new logData[178];
    new Hour, Minute, Second;
    new Day, Month, Year;

    gettime(Hour, Minute, Second);
    getdate(Year, Month, Day);

    format(logData, sizeof(logData),"[%02d/%02d/%02d %02d:%02d:%02d] %s \r\n", Day, Month, Year, Hour, Minute, Second, str);
    fwrite(lFile, logData);

    fclose(lFile);
    return 1;
}

forward WeaponLog(str[]);
stock WeaponLog(str[])
{
    new File:lFile = fopen("Logs/WeaponLog.txt", io_append);
    new logData[178];
    new Hour, Minute, Second;
    new Day, Month, Year;

    gettime(Hour, Minute, Second);
    getdate(Year, Month, Day);

    format(logData, sizeof(logData),"[%02d/%02d/%02d %02d:%02d:%02d] %s \r\n", Day, Month, Year, Hour, Minute, Second, str);
    fwrite(lFile, logData);

    fclose(lFile);
    return 1;
}

forward MaskNameLog(str[]);
stock MaskNameLog(str[])
{
    new File:lFile = fopen("Logs/MaskNameLog.txt", io_append);
    new logData[178];
    new Hour, Minute, Second;
    new Day, Month, Year;

    gettime(Hour, Minute, Second);
    getdate(Year, Month, Day);

    format(logData, sizeof(logData),"[%02d/%02d/%02d %02d:%02d:%02d] %s \r\n", Day, Month, Year, Hour, Minute, Second, str);
    fwrite(lFile, logData);

    fclose(lFile);
    return 1;
}

stock OOCLog(str[])
{
    new File:lFile = fopen("Logs/OOCLog.txt", io_append);
    new logData[178];
    new Hour, Minute, Second;
    new Day, Month, Year;

    gettime(Hour, Minute, Second);
    getdate(Year, Month, Day);

    format(logData, sizeof(logData),"[%02d/%02d/%02d %02d:%02d:%02d] %s \r\n", Day, Month, Year, Hour, Minute, Second, str);
    fwrite(lFile, logData);

    fclose(lFile);
    return 1;
}

stock PMLog(str[])
{
    new File:lFile = fopen("Logs/PM Log.txt", io_append);
    new logData[178];
    new Hour, Minute, Second;
    new Day, Month, Year;

    gettime(Hour, Minute, Second);
    getdate(Year, Month, Day);

    format(logData, sizeof(logData),"[%02d/%02d/%02d %02d:%02d:%02d] %s \r\n", Day, Month, Year, Hour, Minute, Second, str);
    fwrite(lFile, logData);

    fclose(lFile);
    return 1;
}

stock ReportLog(str[])
{
    new File:lFile = fopen("Logs/Report Log.txt", io_append);
    new logData[178];
    new Hour, Minute, Second;
    new Day, Month, Year;

    gettime(Hour, Minute, Second);
    getdate(Year, Month, Day);

    format(logData, sizeof(logData),"[%02d/%02d/%02d %02d:%02d:%02d] %s \r\n", Day, Month, Year, Hour, Minute, Second, str);
    fwrite(lFile, logData);

    fclose(lFile);
    return 1;
}

stock HelpmeLog(str[])
{
    new File:lFile = fopen("Logs/Helpme Log.txt", io_append);
    new logData[178];
    new Hour, Minute, Second;
    new Day, Month, Year;

    gettime(Hour, Minute, Second);
    getdate(Year, Month, Day);

    format(logData, sizeof(logData),"[%02d/%02d/%02d %02d:%02d:%02d] %s \r\n", Day, Month, Year, Hour, Minute, Second, str);
    fwrite(lFile, logData);

    fclose(lFile);
    return 1;
}

stock GangChatLog(str[])
{
    new File:lFile = fopen("Logs/Gang Chat Log.txt", io_append);
    new logData[178];
    new Hour, Minute, Second;
    new Day, Month, Year;

    gettime(Hour, Minute, Second);
    getdate(Year, Month, Day);

    format(logData, sizeof(logData),"[%02d/%02d/%02d %02d:%02d:%02d] %s \r\n", Day, Month, Year, Hour, Minute, Second, str);
    fwrite(lFile, logData);

    fclose(lFile);
    return 1;
}

stock FactionChatLog(str[])
{
    new File:lFile = fopen("Logs/Faction Chat Log.txt", io_append);
    new logData[178];
    new Hour, Minute, Second;
    new Day, Month, Year;

    gettime(Hour, Minute, Second);
    getdate(Year, Month, Day);

    format(logData, sizeof(logData),"[%02d/%02d/%02d %02d:%02d:%02d] %s \r\n", Day, Month, Year, Hour, Minute, Second, str);
    fwrite(lFile, logData);

    fclose(lFile);
    return	 1;
}

forward PlayerMask(playerid, masked);
stock PlayerMask(playerid, masked)
{
	if(masked == 1)
	{
		for(new i = 0; i < MAX_PLAYER_NAME; i++)
		{
			ShowPlayerNameTagForPlayer(i, playerid, false);
		}
	}
	if(masked == 0)
	{
		new i;
		i = 0;
		loop_start:
		if(i > MAX_PLAYERS) return 1;
		ShowPlayerNameTagForPlayer(i, playerid, true);
		i++;
		goto loop_start;
	}
	return 1;
}

stock DeathLog(str[])
{
    new File:lFile = fopen("Logs/Death Log.txt", io_append);
    new logData[178];
    new Hour, Minute, Second;
    new Day, Month, Year;

    gettime(Hour, Minute, Second);
    getdate(Year, Month, Day);

    format(logData, sizeof(logData),"[%02d/%02d/%02d %02d:%02d:%02d] %s \r\n", Day, Month, Year, Hour, Minute, Second, str);
    fwrite(lFile, logData);

    fclose(lFile);
    return 1;
}

stock AnticheatLog(str[])
{
    new File:lFile = fopen("Logs/Anticheat Log.txt", io_append);
    new logData[178];
    new Hour, Minute, Second;
    new Day, Month, Year;

    gettime(Hour, Minute, Second);
    getdate(Year, Month, Day);

    format(logData, sizeof(logData),"[%02d/%02d/%02d %02d:%02d:%02d] %s \r\n", Day, Month, Year, Hour, Minute, Second, str);
    fwrite(lFile, logData);

    fclose(lFile);
    return 1;
}

forward PlayerPunishLog(playerid, str[]);
stock PlayerPunishLog(playerid, str[])
{
	new file[128];
	format(file, sizeof(file), "PlayerUCP/%s.txt", GetOOCName(playerid));
    new File:lFile = fopen(file, io_append);
    new logData[178];
    new Hour, Minute, Second;
    new Day, Month, Year;

    gettime(Hour, Minute, Second);
    getdate(Year, Month, Day);

    format(logData, sizeof(logData),"[%02d/%02d/%02d %02d:%02d:%02d] %s \r\n", Day, Month, Year, Hour, Minute, Second, str);
    fwrite(lFile, logData);

    fclose(lFile);
    return 1;
}

forward OfflinePlayerPunishLog(str1[], str[]);
stock OfflinePlayerPunishLog(str1[], str[])
{
	new file[128];
	format(file, sizeof(file), "PlayerUCP/%s.txt", str1);
    new File:lFile = fopen(file, io_append);
    new logData[178];
    new Hour, Minute, Second;
    new Day, Month, Year;

    gettime(Hour, Minute, Second);
    getdate(Year, Month, Day);

    format(logData, sizeof(logData),"[%02d/%02d/%02d %02d:%02d:%02d] %s \r\n", Day, Month, Year, Hour, Minute, Second, str);
    fwrite(lFile, logData);

    fclose(lFile);
    return 1;
}

stock AdminActionLog(str[])
{
    new File:lFile = fopen("Logs/Admin Actions Log.txt", io_append);
    new logData[178];
    new Hour, Minute, Second;
    new Day, Month, Year;

    gettime(Hour, Minute, Second);
    getdate(Year, Month, Day);

    format(logData, sizeof(logData),"[%02d/%02d/%02d %02d:%02d:%02d] %s \r\n", Day, Month, Year, Hour, Minute, Second, str);
    fwrite(lFile, logData);

    fclose(lFile);
    return 1;
}

stock BanLog(str[])
{
    new File:lFile = fopen("Logs/Ban Log.txt", io_append);
    new logData[178];
    new Hour, Minute, Second;
    new Day, Month, Year;

    gettime(Hour, Minute, Second);
    getdate(Year, Month, Day);

    format(logData, sizeof(logData),"[%02d/%02d/%02d %02d:%02d:%02d] %s \r\n", Day, Month, Year, Hour, Minute, Second, str);
    fwrite(lFile, logData);

    fclose(lFile);
    return 1;
}

CheckWeapons(playerid)
{
    new weaponid = GetPlayerWeapon(playerid);//This will cause the "weaponid not defined" Error

    if(weaponid >= 1 && weaponid <= 15)
    {
        if(weaponid == Weapons[playerid][Melee])
        {
        return 1;
        }
            else
            {
			new str[128];
            format(str, sizeof(str), "(( Player %s (ID: %d): %s has spawned a weapon and kicked.  ))", GetOOCName(playerid), playerid);
            SendAdminMessage(RED, str);
            SendClientMessage(playerid, 0xFF0000FF, "No Hacking!");
            Kick(playerid);
            }
    }

	if( weaponid >= 16 && weaponid <= 18 || weaponid == 39 ) // Checking Thrown
	{
        if(weaponid == Weapons[playerid][Thrown])
        {
        return 1;
        }
        	else
			{
			new str[128];
            format(str, sizeof(str), "(( Player %s (ID: %d): %s has spawned a weapon and kicked.  ))", GetOOCName(playerid), playerid);
            SendAdminMessage(RED, str);
		 	SendClientMessage(playerid, 0xFF0000FF, "No Hacking!");
 		 	Kick(playerid);
        	}
 	}
    if( weaponid >= 22 && weaponid <= 24 ) // Checking Pistols
	{
        if(weaponid == Weapons[playerid][Pistols])
        {
        return 1;
        }
        	else
        	{
        	new str[128];
            format(str, sizeof(str), "(( Player %s (ID: %d): %s has spawned a weapon and kicked.  ))", GetOOCName(playerid), playerid);
            SendAdminMessage(RED, str);
        	SendClientMessage(playerid, 0xFF0000FF, "No Hacking!");
        	Kick(playerid);
        	}
    }
    if( weaponid >= 25 && weaponid <= 27 ) // Checking Shotguns
    {
        if(weaponid == Weapons[playerid][Shotguns])
        {
        return 1;
        }
            else
            {
            new str[128];
            format(str, sizeof(str), "(( Player %s (ID: %d): %s has spawned a weapon and kicked.  ))", GetOOCName(playerid), playerid);
            SendAdminMessage(RED, str);
            SendClientMessage(playerid, 0xFF0000FF, "No Hacking!");
            Kick(playerid);
            }
    }
    if( weaponid == 28 || weaponid == 29 || weaponid == 32 ) // Checking Sub Machine Guns
    {
        if(weaponid == Weapons[playerid][SubMachine])
        {
        return 1;
        }
            else
            {
            new str[128];
            format(str, sizeof(str), "(( Player %s (ID: %d): %s has spawned a weapon and kicked.  ))", GetOOCName(playerid), playerid);
            SendAdminMessage(RED, str);
            SendClientMessage(playerid, 0xFF0000FF, "No Hacking!");
            Kick(playerid);
            }
    }

    if( weaponid == 30 || weaponid == 31 ) // Checking Assault
    {
        if(weaponid == Weapons[playerid][Assault])
        {
        return 1;
        }
            else
            {
            new str[128];
            format(str, sizeof(str), "(( Player %s (ID: %d): %s has spawned a weapon and kicked.  ))", GetOOCName(playerid), playerid);
            SendAdminMessage(RED, str);
            SendClientMessage(playerid, 0xFF0000FF, "No Hacking!");
            Kick(playerid);
            }
    }
    if( weaponid == 33 || weaponid == 34 ) // Checking Rifles
    {
        if(weaponid == Weapons[playerid][Rifles])
        {
        return 1;
        }
            else
            {
            new str[128];
            format(str, sizeof(str), "(( Player %s (ID: %d): %s has spawned a weapon and kicked.  ))", GetOOCName(playerid), playerid);
            SendAdminMessage(RED, str);
            SendClientMessage(playerid, 0xFF0000FF, "No Hacking!");
            Kick(playerid);
            }
    }
    if( weaponid >= 35 && weaponid <= 38 ) // Checking Heavy
    {
        if(weaponid == Weapons[playerid][Heavy])
        {
        return 1;
        }
            else
            {
            new str[128];
            format(str, sizeof(str), "(( Player %s (ID: %d): %s has spawned a weapon and kicked.  ))", GetOOCName(playerid), playerid);
            SendAdminMessage(RED, str);
            SendClientMessage(playerid, 0xFF0000FF, "No Hacking!");
            Kick(playerid);
            }
    }
    else { return 1; }

	return 1;
}


public OnPlayerPause(playerid)
{
	new Float:PauseHealth, Float:PauseArmour;
	GetPlayerHealth(playerid, PauseHealth);
	GetPlayerArmour(playerid, PauseArmour);
	AFKTime[playerid] = 0;
	PlayerStat[playerid][Health] = Float:PauseHealth;
	PlayerStat[playerid][Armour] = Float:PauseArmour;
	PlayerAFK[playerid] = 1;
	SetPlayerHealth(playerid, 9999999);
	AFKTimeKeeper[playerid] = SetTimerEx("AFKTimer", 1000, true, "i", playerid);
	return 1;
}

public OnPlayerResume(playerid, time)
{
	KillTimer(AFKTimeKeeper[playerid]);
	PlayerAFK[playerid] = 0;
	AFKTime[playerid] = 0;
	SetPlayerHealth(playerid, PlayerStat[playerid][Health]);
	SetPlayerArmour(playerid, PlayerStat[playerid][Armour]);
	return 1;
}

forward AFKTimer(playerid);
public AFKTimer(playerid)
{
	if(PlayerAFK[playerid] == 1)
	{
		new str[80];
		AFKTime[playerid]++;
		format(str, sizeof(str), "AFK - %d seconds.", AFKTime[playerid]);
		SetPlayerChatBubble(playerid, str, WHITE, 15, 1300);
	}
	if(PlayerAFK[playerid] == 0)
	{
		KillTimer(AFKTimeKeeper[playerid]);
	}
	return 1;
}

ServerWeapon(playerid, weaponid, ammo)
{
if(weaponid >= 1 && weaponid <= 15)
    {
    Weapons[playerid][Melee] = weaponid;
    GivePlayerWeapon(playerid, weaponid, ammo);
    return 1;
    }

if( weaponid >= 16 && weaponid <= 18 || weaponid == 39 ) // Checking Thrown
    {
    Weapons[playerid][Thrown] = weaponid;
    GivePlayerWeapon(playerid, weaponid, ammo);
    return 1;
    }
if( weaponid >= 22 && weaponid <= 24 ) // Checking Pistols
    {
    Weapons[playerid][Pistols] = weaponid;
    GivePlayerWeapon(playerid, weaponid, ammo);
    return 1;
    }

if( weaponid >= 25 && weaponid <= 27 ) // Checking Shotguns
    {
    Weapons[playerid][Shotguns] = weaponid;
    GivePlayerWeapon(playerid, weaponid, ammo);
    return 1;
    }
if( weaponid == 28 || weaponid == 29 || weaponid == 32 ) // Checking Sub Machine Guns
    {
    Weapons[playerid][SubMachine] = weaponid;
    GivePlayerWeapon(playerid, weaponid, ammo);
    return 1;
    }

if( weaponid == 30 || weaponid == 31 ) // Checking Assault
    {
    Weapons[playerid][Assault] = weaponid;
    GivePlayerWeapon(playerid, weaponid, ammo);
    return 1;
    }

if( weaponid == 33 || weaponid == 34 ) // Checking Rifles
    {
    Weapons[playerid][Rifles] = weaponid;
    GivePlayerWeapon(playerid, weaponid, ammo);
    return 1;
    }
if( weaponid >= 35 && weaponid <= 38 ) // Checking Heavy
    {
    Weapons[playerid][Heavy] = weaponid;
    GivePlayerWeapon(playerid, weaponid, ammo);
    return 1;
    }
return 1;
}

/*
CREATED & SCRIPTED & MAPPED BY MARCO - http://forum.sa-mp.com/member.php?u=181058
*/
