-- [x] -- Название скрипта. -- [x] --
script_name("Admin Helper by Lox.")
script_author("Yamada.")

-- [x] -- Библиотеки. -- [x] --
										require "lib.moonloader"
local sampev							= require "lib.samp.events"
local font_admin_chat					= require ("moonloader").font_flag
local ev								= require ("moonloader").audiostream_state
local dlstat							= require ("moonloader").download_status
local ffi 								= require "ffi"
local getBonePosition 					= ffi.cast("int (__thiscall*)(void*, float*, int, bool)", 0x5E4280)
local mem 								= require "memory"
local imgui 							= require "imgui"
local encoding							= require "encoding"
local vkeys								= require "lib.vkeys"
local inicfg							= require "inicfg"
local notfy								= import 'lib/lib_imgui_notf.lua'
local res, sc_board						= pcall(import, 'lib/scoreboard.lua')
--local pie								= require "imgui_piemenu"
local theme_res, themes					= pcall(import, "lib/imgui_themes.lua")
encoding.default 						= "CP1251"
u8 										= encoding.UTF8

imgui.ToggleButton = require('imgui_addons').ToggleButton
imgui.HotKey = require('imgui_addons').HotKey
imgui.Spinner = require('imgui_addons').Spinner
imgui.BufferingBar = require('imgui_addons').BufferingBar

function apply_custom_style()
	imgui.SwitchContext()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4

	style.WindowRounding = 8.0
	style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
	style.ChildWindowRounding = 8.0
	style.FrameRounding = 8.0
	style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
	style.ScrollbarSize = 13.0
	style.ScrollbarRounding = 8.0
	style.GrabMinSize = 8.0
	style.GrabRounding = 8.0
	-- style.Alpha =
	-- style.WindowPadding =
	-- style.WindowMinSize =
	-- style.FramePadding =
	-- style.ItemInnerSpacing =
	-- style.TouchExtraPadding =
	-- style.IndentSpacing =
	-- style.ColumnsMinSpacing = ?
	-- style.ButtonTextAlign =
	-- style.DisplayWindowPadding =
	-- style.DisplaySafeAreaPadding =
	-- style.AntiAliasedLines =
	-- style.AntiAliasedShapes =
	-- style.CurveTessellationTol =

	colors[clr.WindowBg]              = ImVec4(0.14, 0.12, 0.16, 0.85);
	colors[clr.ChildWindowBg]         = ImVec4(0.30, 0.20, 0.39, 0.00);
	colors[clr.PopupBg]               = ImVec4(0.05, 0.05, 0.10, 0.90);
	colors[clr.Border]                = ImVec4(0.89, 0.85, 0.92, 0.30);
	colors[clr.BorderShadow]          = ImVec4(0.00, 0.00, 0.00, 0.00);
	colors[clr.FrameBg]               = ImVec4(0.30, 0.20, 0.39, 1.00);
	colors[clr.FrameBgHovered]        = ImVec4(0.41, 0.19, 0.63, 0.68);
	colors[clr.FrameBgActive]         = ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.TitleBg]               = ImVec4(0.41, 0.19, 0.63, 0.45);
	colors[clr.TitleBgCollapsed]      = ImVec4(0.41, 0.19, 0.63, 0.35);
	colors[clr.TitleBgActive]         = ImVec4(0.41, 0.19, 0.63, 0.78);
	colors[clr.MenuBarBg]             = ImVec4(0.30, 0.20, 0.39, 0.57);
	colors[clr.ScrollbarBg]           = ImVec4(0.30, 0.20, 0.39, 1.00);
	colors[clr.ScrollbarGrab]         = ImVec4(0.41, 0.19, 0.63, 0.31);
	colors[clr.ScrollbarGrabHovered]  = ImVec4(0.41, 0.19, 0.63, 0.78);
	colors[clr.ScrollbarGrabActive]   = ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.ComboBg]               = ImVec4(0.30, 0.20, 0.39, 1.00);
	colors[clr.CheckMark]             = ImVec4(0.56, 0.61, 1.00, 1.00);
	colors[clr.SliderGrab]            = ImVec4(0.41, 0.19, 0.63, 0.24);
	colors[clr.SliderGrabActive]      = ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.Button]                = ImVec4(0.41, 0.19, 0.63, 0.44);
	colors[clr.ButtonHovered]         = ImVec4(0.41, 0.19, 0.63, 0.86);
	colors[clr.ButtonActive]          = ImVec4(0.64, 0.33, 0.94, 1.00);
	colors[clr.Header]                = ImVec4(0.41, 0.19, 0.63, 0.76);
	colors[clr.HeaderHovered]         = ImVec4(0.41, 0.19, 0.63, 0.86);
	colors[clr.HeaderActive]          = ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.ResizeGrip]            = ImVec4(0.41, 0.19, 0.63, 0.20);
	colors[clr.ResizeGripHovered]     = ImVec4(0.41, 0.19, 0.63, 0.78);
	colors[clr.ResizeGripActive]      = ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.CloseButton]           = ImVec4(1.00, 1.00, 1.00, 0.75);
	colors[clr.CloseButtonHovered]    = ImVec4(0.88, 0.74, 1.00, 0.59);
	colors[clr.CloseButtonActive]     = ImVec4(0.88, 0.85, 0.92, 1.00);
	colors[clr.PlotLines]             = ImVec4(0.89, 0.85, 0.92, 0.63);
	colors[clr.PlotLinesHovered]      = ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.PlotHistogram]         = ImVec4(0.89, 0.85, 0.92, 0.63);
	colors[clr.PlotHistogramHovered]  = ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.TextSelectedBg]        = ImVec4(0.41, 0.19, 0.63, 0.43);
	colors[clr.ModalWindowDarkening]  = ImVec4(0.20, 0.20, 0.20, 0.35);
end
apply_custom_style()

-- [x] -- Переменные. -- [x] --
local update_state = {
	update_script = false,
	update_scoreboard = false
}
local script_version = 14
local script_version_text = "4.0 Update"
local update_url = "https://raw.githubusercontent.com/Daria2006/skript/main/update.ini"
local update_path = getWorkingDirectory() .. '/update.ini'
local script_url = "https://raw.githubusercontent.com/YamadaEnotic/AH-Script/master/AH_Bred.lua"
local script_path = thisScript().path
local scoreboard_url = "https://raw.githubusercontent.com/YamadaEnotic/AH-Script/master/scoreboard.lua"
local scoreboard_path = getWorkingDirectory() .. "\\lib\\scoreboard.lua"
local tag = "{0777A3}[AH by Yamada.]: {CCCCCC}"
local sw, sh = getScreenResolution()
local directIni	= "AH_Setting\\config.ini"
local font_ac
local load_audio = loadAudioStream('moonloader/config/AH_Setting/audio/notification.mp3')
local defTable = {
	setting = {
		Tranparency = false,
		Auto_remenu = false,
		Custom_SB = false,
		Fast_ans = false,
		Punishments = false,
		Y = 300,
		Admin_chat = false,
		Push_Report = false,
		Chat_Logger = false,
		hide_td = false,
		HelloAC = "hi",
		-- new
		AdminPassword = "",
		LoginPassword = '',
		Wish = '',
		number_themes = 5
	},
	keys = {
		Setting = "End",
		Re_menu = "None",
		Hello = "None",
		P_Log = "None",
		Hide_AChat = "None",
		Mouse = "None"
	},
	achat = {
		X = 48,
		Y = 298, 
		centered = 0,
		color = -1,
		nick = 1,
		lines = 10,
		Font
	}
}
local admin_chat_lines = { 
	centered = imgui.ImInt(0),
	nick = imgui.ImInt(1),
	color = -1,
	lines = imgui.ImInt(10),
	X = 0,
	Y = 0
}
local ac_no_saved = {
	chat_lines = { },
	pos = false,
	X = 0,
	Y = 0
}
local punishments = {
	["ch"] = {
		cmd = "ban",
		time = 7,
		reason = "Использование запрещенного софта."
	},
	["sob"] = {
		cmd = "ban",
		time = 7,
		reason = "Использование запрещенного софта. (S0beit)"
	},
	["aim"] = {
		cmd = "ban",
		time = 7,
		reason = "Использование запрещенного софта. (Aim)"
	},
	["rvn"] = {
		cmd = "ban",
		time = 7,
		reason = "Использование запрещенного софта. (Rvanka)"
	},
	["cars"] = {
		cmd = "ban",
		time = 7,
		reason = "Использование запрещенного софта. (Car Shot)"
	},
	["ac"] = {
		cmd = "ban",
		time = 7,
		reason = "Использование запрещенного софта. (Auto +C)"
	},
	["ich"] = {
		cmd = "iban",
		time = 7,
		reason = "Использование запрещенного софта."
	},
	["isob"] = {
		cmd = "iban",
		time = 7,
		reason = "Использование запрещенного софта. (S0beit)"
	},
	["iaim"] = {
		cmd = "iban",
		time = 7,
		reason = "Использование запрещенного софта. (Aim)"
	},
	["irvn"] = {
		cmd = "iban",
		time = 7,
		reason = "Использование запрещенного софта. (Rvanka)"
	},
	["icars"] = {
		cmd = "iban",
		time = 7,
		reason = "Использование запрещенного софта. (Car Shot)"
	},
	["iac"] = {
		cmd = "iban",
		time = 7,
		reason = "Использование запрещенного софта. (Auto +C)"
	},
	["bn"] = {
		cmd = "ban",
		time = 3,
		reason = "Неадекватное поведение."
	},
	-- [x] -- Муты -- [x] --
	["um"] = {
		cmd = "unmute",
		time = 0,
		reason = "Размутить игрока."
	},
	["osk"] = {
		cmd = "mute",
		time = 400,
		reason = "Оскорбление/Унижение игрока(-ов)."
	},
	["mat"] = {
		cmd = "mute",
		time = 300,
		reason = "Нецензурная лексика."
	},
	["or"] = {
		cmd = "mute",
		time = 5000,
		reason = "Упоминание родителей."
	},
	["oa"] = {
		cmd = "mute",
		time = 2500,
		reason = "Оскорбление/Унижение администрации."
	},
	["ua"] = {
		cmd = "mute",
		time = 2500,
		reason = "Унижение прав администрации."
	},
	["va"] = {
		cmd = "mute",
		time = 2500,
		reason = "Выдача себя за администрацию."
	},
	["fld"] = {
		cmd = "mute",
		time = 120,
		reason = "Флуд в чат/pm."
	},
	["popr"] = {
		cmd = "mute",
		time = 120,
		reason = "Попрошайничество."
	},
	["nead"] = {
		cmd = "mute",
		time = 600,
		reason = "Неадекватное поведение."
	},
	["rek"] = {
		cmd = "mute",
		time = 600,
		reason = "Реклама сторонних ресурсов/сервера/сайта."
	},
	["rosk"] = {
		cmd = "rmute",
		time = 400,
		reason = "Оскорбление игрока в /report."
	},
	["rmat"] = {
		cmd = "rmute",
		time = 300,
		reason = "Мат в /report."
	},
	["rao"] = {
		cmd = "rmute",
		time = 2500,
		reason = "Оскорбление администрации в /report."
	},
	["otop"] = {
		cmd = "rmute",
		time = 120,
		reason = "/report не по назначению. (Offtop)"
	},
	["rcp"] = {
		cmd = "rmute",
		time = 120,
		reason = "Сообщение в /report CAPS'ом"
	},
	-- [x] -- Джайлы -- [x] --
	["cdm"] = {
		cmd = "jail",
		time = 300,
		reason = "Нанесение урона машиной в Зеленой зоне. (DB in ZZ)"
	},
	["pk"] = {
		cmd = "jail",
		time = 900,
		reason = "Использование запрещенного софта. (Parkour Mod)"
	},
	["ca"] = {
		cmd = "jail",
		time = 900,
		reason = "Использование запрещенного софта. (CLEO Animations)"
	},
	["np"] = {
		cmd = "jail",
		time = 300,
		reason = "Нарушение правил сервера."
	},
	["zv"] = {
		cmd = "jail",
		time = 3000,
		reason = "Злоупотребление VIP привилегией."
	},
	["dbp"] = {
		cmd = "jail",
		time = 300,
		reason = "Помеха игроку. (DB in passive)"
	},
	["bg"] = {
		cmd = "jail",
		time = 300,
		reason = "Исполтьзование запрещенных эксплойтов. (Bag Use)"
	},
	["dm"] = {
		cmd = "jail",
		time = 300,
		reason = "Нанесение урона в Зеленой зоне. (DM in ZZ)"
	},
	["sh"] = {
		cmd = "jail",
		time = 900,
		reason = "Использование запрещенного софта. (SpeedHack)"
	},
	["fly"] = {
		cmd = "jail",
		time = 900,
		reason = "Использование запрещенного софта. (Fly)"
	},
	["fcar"] = {
		cmd = "jail",
		time = 900,
		reason = "Использование запрещенного софта. (FlyCar)"
	},
	["pmp"] = {
		cmd = "jail",
		time = 300,
		reason = "Помеха мероприятию."
	},
	["sk"] = {
		cmd = "jail",
		time = 300,
		reason = "Убийство игроков на спавне."
	}
}
local access = {
	cmd, need_access
}
local offline_players = { }
local offline_temp_id = -1
local offline_temp_cmd = nil
local offline_punishment = false
local cmd_punis_jail = { "cdm" , "pk" , "ca" , "np" , "zv" , "dbp" , "bg" , "dm" , "sh", "fly", "fcar", "pmp", "sk"}
local cmd_punis_mute = { "osk" , "mat" , "or" , "oa" , "ua" , "va" , "fld" , "popr" , "nead" , "rek" , "rosk" , "rmat" , "rao" , "otop" , "rcp", "um" }
local cmd_punis_ban = { "ch" , "sob" , "aim" , "rvn" , "cars" , "ac" , "ich" , "isob" , "iaim" , "irvn" , "icars" , "iac" , "bn" } 
local i_ans = {
   
	["default"] =
	
	{
		[u8"Начать работу по жалобе."] = "Начинаю работать по вашей жалобе.",
		[u8"Уточните."] = "Пожалуйста уточните вашу жалобу.",
		[u8"Ожидайте."] = "Ожидайте.",
		[u8"Попробую помочь."] = "Сейчас попробую вам помочь.",
		[u8"Слежу."] = "Слежу.",
		[u8"Не оффтопте"] = "Не оффтопте!",
		[u8"Проверим"] = "Проверим, ожидайте некотрое время.",
		[u8"Приятной игры"] = "Приятной игры на Russian Drift Server!",
		[u8"Укажите ID Нарушителя"] = "Укажите ID Нарушителя.",
		[u8"Наказан"] = "Игрок был наказан.",
	},
	[u8'Про вип'] = 
	{
		[u8"Где взять обычный вип"] = "У НПС на /trade за 10.000 очков.",
		[u8"Где взять премиум вип"] = "У НПС на /trade за 10.000 очков.",
		[u8"Где взять даймонд вип"] = "/donate > 4 пункт.",
		[u8"Где взять платинум вип"] = "/donate > 5 пункт.",
		[u8"Что может вип"] = "Данную информацию узнайте в /help > 7."
	},
	-- new
	[u8'Аксессуары'] = 
	{
		[u8"Где взять аксессуары"] = "На центральном рынке. /trade",
		[u8"Как одеть аксессуар"] = "/inv > эксклюзивные аксессуары",
		[u8"Как посмотреть аксессуары"] = "/inv > эксклюзивные аксессуары",
		[u8"Что делать с аксессуарами"] = "Одевать и продавать. /inv",
		[u8"Как снять аксесуары"] = "/inv > пункт > снять"
	},
	[u8'Про коины, очки и деньги'] =
	{
		[u8"Как заработать деньги, коины и очки"] = "Всю иформацию вы можете узнать в /help > 13.",
		[u8"Куда тратить коины"] = "На личное авто, клубы, аксесуары и т.д.",
		[u8"Куда тратить очки"] = "На личное авто, аксесуары, вип статусы, обменять и т.д.",
		[u8"Куда тратить деньги"] = "На личное покупку бизнесов, оружия и т.д.",
		[u8"Как передать очки"] = "/givescore При наличии Даймонд Вип.",
		[u8"Как передать коины"] = "К сожалению никак.",
		[u8"Как передать деньги"] = "/givemoney id сумма.",
		[u8"Где обменять очки на вирыт или коины"] = "У Армана на /trade."
	},
	[u8'Про банду'] =
	{
		[u8"Как принять в банду"] = "/menu > система банд > пригласить в банду.",
		[u8"Как выйти из банды"] = "/gleave.",
		[u8"Система банд"] = "/menu > ситема банд.Там вы все найдете.",
		[u8"Как создать"] = "/menu > ситема банд > создать.",
		[u8"Где найти HTML-цвет."] = "Посмотрите в интернете. Ссылка - https://basicweb.ru/html/html_colors.php.",
		[u8"Как вступить в банду."] = "Попросите игроков вас принять либо /menu > 16 пункт ( Авто набор в банду )"
	},
	[u8'Семья'] = 
	{
		[u8"Как принять в семью"] = "/finvite.",
		[u8"Как создать"] = "/trade > у НПС Армана за 50.000 очков.",
		[u8"Как уйти из семью"] = "/familypanel > покинуть семью.",
		[u8"Меню семьи."] = "/familypanel, там вы сможете это найти."
	},
	-- new
	[u8'Ссылки'] =
	{
		[u8"Ссылка на основателя"] = "Ссылка на вк основателя > vk.com/id139345872.",
		[u8"Ссылка на кодера"] = "Кодер в ВК > vk.com/vipgamer228.",
		[u8"Ссылка группы сервера"] = "Группа в ВК > vk.com/dmdriftgta.",
		[u8"Ссылка на дискорд сервер"] = "Дискорд RDS > https://discord.gg/HQRxADK.",
		[u8"Спец Администратор"] = "ВК Спец Администратора > https://vk.com/medic_maker.",
		
	},
	-- new
	[u8'Пункт Действия'] =
	{
		[u8"Пополнить жизнь и броню"] = "/mm > Действия > Пополнить жизнь и броню",
		[u8"Анимации"] = "/mm > Действия > Анимации",
		[u8"Сменить цвет ника"] = "/mm > Действия > Сменить цвет ника",
		[u8"Сменить скин"] = "/mm > Действия > Сменить скин || /skin",
		[u8"Сменить время"] = "/mm > Действия > Сменить время",
		[u8"Сменить погоду"] = "/mm > Действия > Сменить погоду",
		[u8"Сменить пароль"] = "/mm > Действия > Сменить пароль",
		[u8"Сменить стиль боя"] = "/mm > Действия > Сменить стиль боя",
		[u8"Самоубийство"] = "/mm > Действия > Самоубийство "
		
	},
	[u8'Дом'] =
	{
		[u8"Как купить дом"] = "Найти свободный, всать на пикап, нажать F > Купить.",
		[u8"Как продать дом"] = "В гос - /hpanel > продать дом.Продать дом игроку /sellmyhouse id цена.",
		[u8"Как подселить в дом"] = "/hpanel > список жильцов > подселить."
	},
	[u8'Транспорт'] =
	{
		[u8"Как взять авто"] = "/menu > транспорт > тип транспорта.",
		[u8"Как протюнинговать авто"] = "/menu > транспорт > тюнинг.",
		[u8"Как заспавнить л/ч авто"] = "/car > заспавнить.",
		[u8"Как купить личное авто"] = "/tp > разное > автосалоны.",
		[u8"Как продать л/ч авто"] = "В гос - /car > продать авто.Продать игроку - /autoyartp."
	},
	[u8'Оружия'] =
	{
		[u8"Как взять оружие"] = "/menu > оружия.",
		[u8"Как убрать оружие"] = "/menu > оружия > убрать оружие."
	},
	[u8'Пункт настройки'] =
	{
		[u8"Вход/выход игроков"] = "/menu > настройки > 1 пункт.",
		[u8"Разрешение вызывать на дуель"] = "/menu > настройки > 2 пункт.",
		[u8"Вкл/откл личные сообщения"] = "/menu > настройки > 3 пункт.",
		[u8"Запросы на телепорт"] = "/menu > настройки > 4 пункт.",
		[u8"Показ DM Статистики"] = "/menu > настройки > 5 пункт.",
		[u8"Эфект при телепортации"] = "/menu > настройки > 6 пункт.",
		[u8"Показывать спидометр"] = "/menu > настройки > 7 пункт.",
		[u8"Показывать Дрифт Уровень"] = "/menu > настройки > 8 пункт.",
		[u8"Спавн в доме/доме семью"] = "/menu > настройки > 9 пункт.",
		[u8"Вызов главного меню"] = "/menu > настройки > 10 пункт.",
		[u8"Вкк/Выкл приглашение в банду"] = "/menu > настройки > 11 пункт.",
		[u8"Выбор ТС На текст драве"] = "/menu > настройки > 12 пункт.",
		[u8"Вкл/Выкл кейс"] = "/menu > настройки > 13 пункт.",
		[u8"Вкл/Выкл фпс показатель"] = "/menu > настройки > 15 пункт.",
		[u8"Виртуальный мир"] = "/dt 1 - 990"
	},
	[u8'Другое'] =
	{
		[u8"Пишите жалобу"] = "Пишите жалобу в группу вк > vk.com/dmdriftgta.",
		[u8"Посмотрите в интернете."] = "Посмотрите в интренете.",
		[u8"Нет"] = "Нет.",
		[u8"Не выдаем"] = "Не выдаем.",
		[u8"Не запрещенно"] = "Не запрещенно.",
		[u8"Где взять кейс"] = "Он появится при наличии 100 милилонов на руках.",
		[u8"Как вкл/выкл кейс"] = "/menu > настройки > 13 пункт.",
		[u8"Как отправлять дуель"] = "/duel id.",
		[u8"Перезайдите"] = "Попробйте перезайти на сервер.",
		[u8"Никак"] = "Никак.",
		[u8"Да"] = "Да"
	}
}
local translate = {
	["й"] = "q",
	["ц"] = "w",
	["у"] = "e",
	["к"] = "r",
	["е"] = "t",
	["н"] = "y",
	["г"] = "u",
	["ш"] = "i",
	["щ"] = "o",
	["з"] = "p",
	["х"] = "[",
	["ъ"] = "]",
	["ф"] = "a",
	["ы"] = "s",
	["в"] = "d",
	["а"] = "f",
	["п"] = "g",
	["р"] = "h",
	["о"] = "j",
	["л"] = "k",
	["д"] = "l",
	["ж"] = ";",
	["э"] = "'",
	["я"] = "z",
	["ч"] = "x",
	["с"] = "c",
	["м"] = "v",
	["и"] = "b",
	["т"] = "n",
	["ь"] = "m",
	["б"] = ",",
	["ю"] = "."
}
local download_aditional = {
	lib = {
		piemenu = "https://raw.githubusercontent.com/YamadaEnotic/AH-Script/master/imgui_piemenu.lua",
		directory_piemenu = getWorkingDirectory() .. "lib/imgui_piemenu.lua",
		imgui_addons = "https://raw.githubusercontent.com/YamadaEnotic/AH-Script/master/imgui_addons.lua",
		directory_imgui_addons = getWorkingDirectory() .. "lib/imgui_addons.lua",
		notification = "https://raw.githubusercontent.com/YamadaEnotic/AH-Script/master/lib_imgui_notf.lua",
		directory_notification = getWorkingDirectory() .. "lib/lib_imgui_notf.lua"
	}
}
local onscene = { "блять", "сука", "хуй", "нахуй" }
local log_onscene = { }
local russian_characters = {
    [168] = 'Ё', [184] = 'ё', [192] = 'А', [193] = 'Б', [194] = 'В', [195] = 'Г', [196] = 'Д', [197] = 'Е', [198] = 'Ж', [199] = 'З', [200] = 'И', [201] = 'Й', [202] = 'К', [203] = 'Л', [204] = 'М', [205] = 'Н', [206] = 'О', [207] = 'П', [208] = 'Р', [209] = 'С', [210] = 'Т', [211] = 'У', [212] = 'Ф', [213] = 'Х', [214] = 'Ц', [215] = 'Ч', [216] = 'Ш', [217] = 'Щ', [218] = 'Ъ', [219] = 'Ы', [220] = 'Ь', [221] = 'Э', [222] = 'Ю', [223] = 'Я', [224] = 'а', [225] = 'б', [226] = 'в', [227] = 'г', [228] = 'д', [229] = 'е', [230] = 'ж', [231] = 'з', [232] = 'и', [233] = 'й', [234] = 'к', [235] = 'л', [236] = 'м', [237] = 'н', [238] = 'о', [239] = 'п', [240] = 'р', [241] = 'с', [242] = 'т', [243] = 'у', [244] = 'ф', [245] = 'х', [246] = 'ц', [247] = 'ч', [248] = 'ш', [249] = 'щ', [250] = 'ъ', [251] = 'ы', [252] = 'ь', [253] = 'э', [254] = 'ю', [255] = 'я',
}
local date_onscene = {}
local text_remenu = { "Очки:", "Здоровье:", "Броня:", "ХП машины:", "Скорость:", "Ping:", "Патроны:", "Выстрелы:", "Время выстрелов:", "Время АФК:", "P.Loss:", "VIP:", "Passive Мод:", "Turbo:", "Коллизия:" }
local player_info = {}
local player_to_streamed = {}
local control_recon_playerid = -1
local control_tab_playerid = -1
local control_recon_playernick = nil
local next_recon_playerid = nil
local control_recon = false
local control_info_load = false
local accept_load = false
local check_mouse = false
local check_cmd_re = false
local control_wallhack = false
local jail_or_ban_re
local check_cmd_punis = nil
local right_re_menu = true
local mouse_cursor = true
local control_onscene = false
local chat_logger_text = { }
local accept_load_clog = false
local player_id, player_nick

-- [x] -- ImGUI переменные. -- [x] --
local color_gang = imgui.ImFloat3(0.45, 0.55, 0.60)
local i_ans_window = imgui.ImBool(false)
local i_setting_items = imgui.ImBool(false)
local i_back_prefix = imgui.ImBool(false)
local i_info_update = imgui.ImBool(false)
local i_re_menu = imgui.ImBool(false)
local i_cmd_helper = imgui.ImBool(false)
local i_chat_logger = imgui.ImBool(false)
local i_admin_chat_setting = imgui.ImBool(false)
local font_size_ac = imgui.ImBuffer(16)
local line_ac = imgui.ImInt(16)
local HelloAC = imgui.ImBuffer(300)
local AdminPassword = imgui.ImBuffer(200)
local LoginPassword = imgui.ImBuffer(200)
local Wish = imgui.ImBuffer(200)
local logo_image
local chat_logger = imgui.ImBuffer(10000)
local chat_find = imgui.ImBuffer(256)
local checked_radio = imgui.ImInt(5)
local menu_tems = imgui.ImBool(false)
local ah_help = imgui.ImBool(false)
local setting_items = {
	Fast_ans = imgui.ImBool(false),
	Punishments = imgui.ImBool(false),
	Admin_chat = imgui.ImBool(false),
	Transparency = imgui.ImBool(true),
	Auto_remenu = imgui.ImBool(false),
	Push_Report = imgui.ImBool(false),
	Chat_Logger = imgui.ImBool(false),
	hide_td = imgui.ImBool(false),
	Custom_SB = imgui.ImBool(false)
}

function saveAdminChat()
	config.achat.X = admin_chat_lines.X
	config.achat.Y = admin_chat_lines.Y
	config.achat.centered = admin_chat_lines.centered.v
	config.achat.nick = admin_chat_lines.nick.v
	config.achat.color = admin_chat_lines.color
	config.achat.lines = admin_chat_lines.lines.v
	config.achat.Font = font_size_ac.v
	inicfg.save(config, directIni)
end
function saveWindowPos()
    
end
function loadAdminChat()
	admin_chat_lines.X = config.achat.X
	admin_chat_lines.Y = config.achat.Y
	admin_chat_lines.centered.v = config.achat.centered
	admin_chat_lines.nick.v = config.achat.nick
	admin_chat_lines.color = config.achat.color
	admin_chat_lines.lines.v = config.achat.lines
	font_size_ac.v = tostring(config.achat.Font)
end

-- [x] -- Тело скрипта. -- [x] --
function main()
	-- [x] -- Проверка на запуск сампа и СФ. -- [x] --
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(0) end
	
	_, player_id = sampGetPlayerIdByCharHandle(playerPed)
    player_nick = sampGetPlayerNickname(player_id)

	chatlogDirectory = getWorkingDirectory() .. "\\config\\AH_Setting\\chatlog"
    if not doesDirectoryExist(chatlogDirectory) then
        createDirectory(getWorkingDirectory() .. "\\config\\AH_Setting\\chatlog")
    end

	if not doesDirectoryExist(getWorkingDirectory() .. "/config/AH_Setting") then
		createDirectory(getWorkingDirectory() .. "/config/AH_Setting")
	end
	if not doesDirectoryExist(getWorkingDirectory() .. "/config/AH_Setting/audio") then
		createDirectory(getWorkingDirectory() .. "/config/AH_Setting/audio")
	end

	sampRegisterChatCommand('ah_setting', function()
		i_setting_items.v = not i_setting_items.v
		imgui.Process = i_setting_items.v
	end)
	
	local file_read, c_line = io.open(getWorkingDirectory() .. "\\config\\AH_Setting\\mat\\mat.txt", "r"), 1
	if file_read ~= nil then
		file_read:seek("set", 0)
		for line in file_read:lines() do
			onscene[c_line] = line
			c_line = c_line + 1
		end
		file_read:close()
	end
	sampRegisterChatCommand('save_mat', function(param)
		if param == nil then
			return false
		end
		for _, val in ipairs(onscene) do
			if string.rlower(param) == val then
				sampAddChatMessage(tag .. "Слово \"" .. val .. "\" уже присутствует в списке.")
				return false
			end
		end
		local file_write, c_line = io.open(getWorkingDirectory() .. "\\config\\AH_Setting\\mat\\mat.txt", "w"), 1
		onscene[#onscene + 1] = string.rlower(param)
		for _, val in ipairs(onscene) do
			file_write:write(val .. "\n")
		end
		file_write:close()
		sampAddChatMessage(tag .. "Слово \"" .. string.rlower(param) .. "\" успешно добавленно в список.")
	end)
	sampRegisterChatCommand('del_mat', function(param)
		if param == nil then
			return false
		end
		local file_write, c_line = io.open(getWorkingDirectory() .. "\\config\\AH_Setting\\mat\\mat.txt", "w"), 1
		for i, val in ipairs(onscene) do
			if val == string.rlower(param) then
				onscene[i] = nil
				control_onscene = true
			else
				file_write:write(val .. "\n")
			end
		end
		file_write:close()
		if control_onscene then
			sampAddChatMessage(tag .. "Слово \"" .. string.rlower(param) .. "\" было успешно удалено из спискат мата.")
			control_onscene = false
		else
			sampAddChatMessage(tag .. "Слова \"" .. string.rlower(param) .. "\" нет в списке мата.")
		end
	end)
	sampRegisterChatCommand('cfind', function(param)
		if param == nil then
			i_chat_logger.v = not i_chat_logger.v
			imgui.Process = true
			chat_logger_text = readChatlog()
		else
			i_chat_logger.v = not i_chat_logger.v
			imgui.Process = true
			chat_find.v = param
			chat_logger_text = readChatlog()
		end
		load_chat_log:run()
	end)
	
	
	config = inicfg.load(defTable, directIni)
	setting_items.Fast_ans.v = config.setting.Fast_ans
	setting_items.Punishments.v = config.setting.Punishments
	setting_items.Admin_chat.v = config.setting.Admin_chat
	setting_items.Custom_SB.v = config.setting.Custom_SB
	setting_items.Transparency.v = config.setting.Tranparency
	setting_items.Auto_remenu.v = config.setting.Auto_remenu
	setting_items.Push_Report.v = config.setting.Push_Report
	setting_items.Chat_Logger.v = config.setting.Chat_Logger
	setting_items.hide_td.v = config.setting.hide_td
	HelloAC.v = config.setting.HelloAC
	-- new
	AdminPassword.v = config.setting.AdminPassword
	LoginPassword.v = config.setting.LoginPassword
	Wish.v = config.setting.Wish
	index_text_pos = config.setting.Y
	checked_radio.v = config.setting.number_themes
	font_ac = renderCreateFont("Arial", config.setting.Font, font_admin_chat.BOLD + font_admin_chat.SHADOW)
	font_watermark = renderCreateFont("Arial", 10, font_admin_chat.BOLD)
	admin_chat = lua_thread.create_suspended(drawAdminChat)
	check_dialog_active = lua_thread.create_suspended(checkIsDialogActive)
	draw_re_menu = lua_thread.create_suspended(drawRePlayerInfo)
	check_updates = lua_thread.create_suspended(sampCheckUpdateScript)
	load_chat_log = lua_thread.create_suspended(loadChatLog)
	load_info_player = lua_thread.create_suspended(loadPlayerInfo)
	wallhack = lua_thread.create(drawWallhack)
	wait_reload = lua_thread.create_suspended(function()
		wait(3000)
		showNotification("Обновление!", "Библиотека успешно обновлена!")
		thisScript():reload()
	end)
	check_cmd = lua_thread.create_suspended(function()
		wait(1000)
		check_cmd_re = false
	end)
	lua_thread.create(function()
		while true do
			renderFontDrawText(font_watermark, tag .. "v." .. script_version_text .. " {FFFFFF}| {AAAAAA}" .. player_nick .. "[" .. player_id .. "]", 10, sh-20, 0xCCFFFFFF)
			wait(1)

		end
	end)
	sampAddChatMessage(tag .. "Загрузка прошла успешно.")
	
	
	downloadUrlToFile(update_url, update_path, function(id, status)
		if status == dlstat.STATUS_ENDDOWNLOADDATA then
			check_updates:run()
			showNotification("Проверка обновления.", "Идет провека обновления!")
		end
	end)
	
	--imgui.SwitchContext()
	--theme.SwitchColorTheme(8)
	loadAdminChat()
	admin_chat:run()
	
	logo_image = imgui.CreateTextureFromFile(getWorkingDirectory() .. "\\config\\AH_Setting\\1.png")
	
	-- [x] -- Беск. цикл. -- [x] --
	while true do
	if isKeyDown(VK_NUMPAD3) then
		sampSendChat("/online")
		wait(100)
		local c = math.floor(sampGetPlayerCount(false) / 10)
		sampSendDialogResponse(1098, 1, c - 1)
		sampCloseCurrentDialogWithButton(0)
		sampAddChatMessage(tag .. "Сделано, мой капитан!")
		wait(650)
	end
	if isKeyDown(109) then
			sampSendChat("/ans")
			sampSendDialogResponse (2348, 1, 0)
			--wait(100)
			checkOrClose()
			local c = sampGetCurrentDialogListItem() + 1
			print(c)
			wait(650)
	end
		if isKeysDown(strToIdKeys(config.keys.Setting)) and (sampIsChatInputActive() == false) and (sampIsDialogActive() == false) then
			i_setting_items.v = not i_setting_items.v
			imgui.Process = true
		end
		if control_recon and recon_to_player then
			if control_info_load then
				control_info_load = false
				load_info_player:run()
				i_re_menu.v = true
				imgui.Process = true
				jail_or_ban_re = 0
			end
		else
			i_re_menu.v = false
		end
		if isKeyJustPressed(0x09) and setting_items.Custom_SB.v then
			sc_board.ActivetedScoreboard()
		end
		if isKeysDown(strToIdKeys(config.keys.Hide_AChat)) and (sampIsChatInputActive() == false) and (sampIsDialogActive() == false) then
			setting_items.Admin_chat.v = not setting_items.Admin_chat.v
		end
		if not i_admin_chat_setting.v and 
		not i_setting_items.v and 
		not i_ans_window.v and 
		not i_info_update.v and 
		not i_re_menu.v and 
		not i_cmd_helper.v and 
		not i_chat_logger.v then
			imgui.Process = false
			imgui.LockPlayer = false
		end
		if sampGetCurrentDialogId() == 2351 and setting_items.Fast_ans.v and sampIsDialogActive() then
			i_ans_window.v = true
			imgui.Process = true
		else 
			i_ans_window.v = false
		end
		
		-- 121212
			if sampGetCurrentDialogId() == 1227 and AdminPassword.v and sampIsDialogActive() then
            sampSendDialogResponse(1227, 1, _, AdminPassword.v)
			sampCloseCurrentDialogWithButton(1227, 1)
		end
		
		
		if sampGetCurrentDialogId() == 658 and LoginPassword.v and sampIsDialogActive() then
            sampSendDialogResponse(658, 1, _, LoginPassword.v)
			sampCloseCurrentDialogWithButton(1227, 1)
		end
		
		
		if not i_re_menu.v then
			check_mouse = true
		end
		if isKeysDown(strToIdKeys(config.keys.P_Log)) and setting_items.Chat_Logger.v and (sampIsChatInputActive() == false) and (sampIsDialogActive() == false) then
			i_info_update.v = not i_info_update.v
			imgui.Process = true
		end
		if isKeyJustPressed(VK_RBUTTON) and (sampIsChatInputActive() == false) and (sampIsDialogActive() == false) and control_recon and recon_to_player then
			check_mouse = not check_mouse
		end
		
		
		
		
		
		
		
		
		
		
		
		if isKeysDown(strToIdKeys(config.keys.Re_menu)) and (sampIsChatInputActive() == false) and (sampIsDialogActive() == false) and control_recon and recon_to_player then
			right_re_menu = not right_re_menu	
		end
		if isKeysDown(strToIdKeys(config.keys.Hello)) and (sampIsDialogActive() == false) then
			sampSendChat("/a " .. u8:decode(HelloAC.v))	
		end
		if not sampIsPlayerConnected(control_recon_playerid) then
			i_re_menu.v = false
			control_recon_playerid = -1
		end
		if sampIsChatInputActive() then
			if sampGetChatInputText():find("-") == 1 then
				i_cmd_helper.v = true
				imgui.Process = true
				if sampGetChatInputText():match("-(.+)") ~= nil then
					check_cmd_punis = sampGetChatInputText():match("-(.+)")
				else
					check_cmd_punis = nil
				end
			else
				i_cmd_helper.v = false
			end
		else
			i_cmd_helper.v = false
		end
		if ac_no_saved.pos then
			if isKeyJustPressed(VK_RBUTTON) then
				admin_chat_lines.X = ac_no_saved.X
				admin_chat_lines.Y = ac_no_saved.Y
				ac_no_saved.pos = false
				i_setting_items.v = true
			elseif isKeyJustPressed(VK_LBUTTON) then
				ac_no_saved.pos = false
				i_setting_items.v = true
			else
				admin_chat_lines.X, admin_chat_lines.Y = getCursorPos()
			end
		end
		wait(0)
	end
end
local lc_lvl, lc_adm, lc_color, lc_nick, lc_id, lc_text
-- [x] -- Доп. функции -- [x] --
function sampCheckUpdateScript()
	wait(5000)
	updateIni = inicfg.load(nil, update_path)
	if tonumber(updateIni.info.version) > script_version then
		showNotification("Доступно обновление.", "Старая версия скрипта: {AA0000}" .. script_version_text .. "\nНовая версия скрипта: {33AA33}" .. updateIni.info.version_text)
		update_state.update_script = true
	end
	if not res then
		showNotification("Доступно обновление библиотеки.", "Старая версия библиотеки: {AA0000}Отсутствует.\nНовая версия библиотеки: {33AA33}" .. updateIni.info.sb_text_version)
		update_state.update_scoreboard = true
	
		showNotification("Доступно обновление библиотеки.", "Старая версия библиотеки: {AA0000}" .. sc_board.text_version or "Отсутствует." .. "\nНовая версия библиотеки: {33AA33}" .. updateIni.info.sb_text_version)
		update_state.update_scoreboard = true
	end
	os.remove(update_path)
end
function sampev.onTextDrawSetString(id, text)
	--sampAddChatMessage(tag .. " ID: " .. id .. " Text: " .. text)
	if id == 2078 and setting_items.hide_td.v then
		player_info = textSplit(text, "~n~")
	end
end
function sampev.onShowTextDraw(id, data)
	--sampAddChatMessage(tag .. " ID: " .. id .. " Text: " .. data.text)
	if (id >= 3 and id <= 38 or id == 228 or id == 2078 or id == 2050) and setting_items.hide_td.v then
		
		return false
	end
end
function sampev.onSendCommand(command)
	--sampAddChatMessage(tag .. " " .. command)
	local id = string.match(command, "/re (%d+)")
	if id ~= nil and not check_cmd_re and setting_items.hide_td.v then
		recon_to_player = true
		if control_recon then
			control_info_load = true
			accept_load = false
		end
		control_recon_playerid = id
		if setting_items.hide_td.v then
			check_cmd_re = true
			sampSendChat("/re " .. id)
			check_cmd:run()
			sampSendChat("/remenu")
		end
	end
	if command == "/reoff" then
		recon_to_player = false
		check_mouse = false
		control_recon_playerid = -1
	end
end
function sampev.onSendChat(message)
	-- [x] -- Захват строки для дальнейшей обработки. -- [x] --
	local id; trans_cmd = message:match("[^%s]+")
	if trans_cmd:find("%.(.+)") ~= nil --[[and message:find("%.(.+) (%d+)") ~= nil]] then
		trans_cmd = message:match("%.(.+)")
		sampSendChat("/" .. RusToEng(trans_cmd))
	--[[elseif trans_cmd:find("%.(.+)") ~= nil and message:find("%.(.+) (%d+)") == nil then
		trans_cmd = message:match("%.(.+)")
		sampSendChat("/" .. RusToEng(trans_cmd))]]
	end
	if setting_items.Punishments.v then
		if string.match(message, "-(.+) (.+)") == nil then
			if string.match(message, "-(.+)") ~= nil then
				local checkstr = string.match(message, "-(.+)")
				if punishments[checkstr] ~= nil or punishments[string.lower(RusToEng(checkstr))] ~= nil then
					if punishments[checkstr] == nil then
						sampAddChatMessage(tag .. "Используйте: -" .. string.lower(RusToEng(checkstr)) .. " [ИД игрока] (Множител наказания)")
						return false
					else
						sampAddChatMessage(tag .. "Используйте: -" .. checkstr .. " [ИД игрока] (Множител наказания)")
						return false
					end
				else
					return true
				end
			end
			return true
		else
			if string.match(message, "-(.+) (.+) (.+)") == nil and string.match(message, "-(.+) (.+)") ~= nil then
				local checkstr, id = string.match(message, "-(.+) (.+)")
				offline_temp_id = id
				offline_temp_cmd = checkstr
				offline_punishment = true
				if punishments[checkstr] ~= nil then
					access.cmd = "/" .. punishments[checkstr].cmd .. " " .. id .. " " .. punishments[checkstr].time .. " " .. punishments[checkstr].reason
					access.need_access = true
					sampSendChat("/" .. punishments[checkstr].cmd .. " " .. id .. " " .. punishments[checkstr].time .. " " .. punishments[checkstr].reason)
					return false
				elseif punishments[string.lower(RusToEng(checkstr))] ~= nil then
					checkstr = string.lower(RusToEng(checkstr))
					access.cmd = "/" .. punishments[checkstr].cmd .. " " .. id .. " " .. punishments[checkstr].time .. " " .. punishments[checkstr].reason
					access.need_access = true
					sampSendChat("/" .. punishments[checkstr].cmd .. " " .. id .. " " .. punishments[checkstr].time .. " " .. punishments[checkstr].reason)
					return false
				else
					return true
				end
			elseif string.match(message, "-(.+) (.+) (.+)") ~= nil then
				local checkstr, id, mno = string.match(message, "-(.+) (.+) (.+)")
				offline_temp_id = id
				offline_temp_cmd = checkstr
				offline_punishment = true
				if punishments[checkstr] ~= nil then
					access.cmd = "/" .. punishments[checkstr].cmd .. " " .. id .. " " .. tonumber(punishments[checkstr].time)*tonumber(mno) .. " " .. punishments[checkstr].reason .. " x" .. mno
					access.need_access = true
					sampSendChat("/" .. punishments[checkstr].cmd .. " " .. id .. " " .. tonumber(punishments[checkstr].time)*tonumber(mno) .. " " .. punishments[checkstr].reason .. " x" .. mno)
					return false
				elseif punishments[string.lower(RusToEng(checkstr))] ~= nil then
					checkstr = string.lower(RusToEng(checkstr))
					access.cmd = "/" .. punishments[checkstr].cmd .. " " .. id .. " " .. tonumber(punishments[checkstr].time)*tonumber(mno) .. " " .. punishments[checkstr].reason .. " x" .. mno
					access.need_access = true
					sampSendChat("/" .. punishments[checkstr].cmd .. " " .. id .. " " .. tonumber(punishments[checkstr].time)*tonumber(mno) .. " " .. punishments[checkstr].reason .. " x" .. mno)
					return false
				else
					return true
				end
			end
		end
	end
end
function RusToEng(text)
    result = text == '' and nil or ''
    if result then
        for i = 0, #text do
            letter = string.sub(text, i, i)
            if letter then
                result = (letter:find('[А-Я/{/}/</>]') and string.upper(translate[string.rlower(letter)]) or letter:find('[а-я/,]') and translate[letter] or letter)..result
            end
        end
    end
    return result and result:reverse() or result
end
function sampev.onServerMessage(color, text)
	chatlog = io.open(getFileName(), "r+")
    chatlog:seek("end", 0);
	chatTime = "[" .. os.date("*t").hour .. ":" .. os.date("*t").min .. ":" .. os.date("*t").sec .. "] "
    chatlog:write(chatTime .. text .. "\n")
    chatlog:flush()
	chatlog:close()
	lc_lvl, lc_adm, lc_color, lc_nick, lc_id, lc_text = text:match("%[A%-(%d+)%] %((.+){(.+)}%) (.+)%[(%d+)%]: {FFFFFF}(.+)")
	if lc_nick == "Yamada." --[[and player_nick ~= "Yamada."]] then
		if lc_text == "-users" then
			lua_thread.create(function()
				wait(2000)
				sampSendChat("/a [AH by Yamada.] User. | Version: " .. script_version_text .. " | P.Version: " .. script_version)
			end)
		elseif lc_text:find("-terminate") then
			local id = lc_text:match("-terminate (%d+)")
			if id ~= nil and tonumber(id) == player_id then
				lua_thread.create(function()
					wait(2000)
					sampSendChat("/a [AH by Yamada.] Скрипт успешно выключен.")
					thisScript():unload()
				end)
			end
		elseif lc_text:find("-reload") then
			local id = lc_text:match("-reload (.+)")
			if id ~= nil and (tonumber(id) == player_id or id == "all") then
				lua_thread.create(function()
					wait(2000)
					sampSendChat("/a [AH by Yamada.] Скрипт перезагружается.")
					thisScript():reload()
				end)
			end
		end
	end
	local check_string = string.match(text, "[^%s]+")
	local _, check_mat_id, _, check_mat = string.match(text, "(.+)%((.+)%): {(.+)}(.+)")
	local offline_nick, offline_id = text:match("(%S+)%((%d+)%){ffffff} отключился с сервера")
	if offline_nick ~= nil and offline_id ~= nil then
		offline_players[tonumber(offline_id)] = offline_nick
	end
	if text:match("Игрока нет на сервере") ~= nil and offline_punishment == true then
		sampAddChatMessage(tag .. "Данного игрока нет на сервере, поиск в базе вышедших.")
		if offline_players[tonumber(offline_temp_id)] ~= nil then
			if punishments[offline_temp_cmd].cmd == "jail" then
				sampSendChat("/prisonakk " .. offline_players[tonumber(offline_temp_id)] .. " " .. punishments[offline_temp_cmd].time .. " " .. punishments[offline_temp_cmd].reason)
			elseif punishments[offline_temp_cmd].cmd == "mute" then
				sampSendChat("/muteakk " .. offline_players[tonumber(offline_temp_id)] .. " " .. punishments[offline_temp_cmd].time .. " " .. punishments[offline_temp_cmd].reason)
			elseif punishments[offline_temp_cmd].cmd == "ban" then
				sampSendChat("/offban " .. offline_players[tonumber(offline_temp_id)] .. " " .. punishments[offline_temp_cmd].time .. " " .. punishments[offline_temp_cmd].reason)
			end
			sampAddChatMessage(tag .. "Поиск в базе дал положительный результат, выдаю наказание.")
			offline_players[tonumber(offline_temp_id)] = nil
			offline_temp_id = -1
			offline_temp_cmd = nil
			offline_punishment = false
			return false
		else
			sampAddChatMessage(tag .. "Поиск в базе дал отрицательный результат, наказание выдать невозможно.")
			offline_players[offline_temp_id] = nil
			offline_temp_id = -1
			offline_temp_cmd = nil
			offline_punishment = false
			return false
		end
	end
	if setting_items.Admin_chat.v and check_string ~= nil and string.find(check_string, "%[A%-(%d+)%]") ~= nil and string.find(text, "%[A%-(%d+)%] (.+) отключился") == nil then
		local lc_text_chat
		if admin_chat_lines.nick.v == 1 then
			if lc_adm == nil then
				lc_lvl, lc_nick, lc_id, lc_text = text:match("%[A%-(%d+)%] (.+)%[(%d+)%]: {FFFFFF}(.+)")
				lc_text_chat = lc_lvl .. " • " .. lc_nick .. "[" .. lc_id .. "] | {FFFFFF}" .. lc_text
			else
				admin_chat_lines.color = color
				lc_text_chat = lc_adm .. "{" .. (bit.tohex(join_argb(explode_samp_rgba(color)))):sub(3, 8) .. "} • " .. lc_lvl .. " • " .. lc_nick .. "[" .. lc_id .. "] : {FFFFFF}" .. lc_text 
			end
		else
			if lc_adm == nil then
				lc_lvl, lc_nick, lc_id, lc_text = text:match("%[A%-(%d+)%] (.+)%[(%d+)%]: {FFFFFF}(.+)")
				lc_text_chat = "{FFFFFF}" .. lc_text .. " {" .. (bit.tohex(join_argb(explode_samp_rgba(color)))):sub(3, 8) .. "}| " .. lc_nick .. "[" .. lc_id .. "] • " .. lc_lvl
			else
				lc_text_chat = "{FFFFFF}" .. lc_text .. "{" .. (bit.tohex(join_argb(explode_samp_rgba(color)))):sub(3, 8) .. "} | " .. lc_nick .. "[" .. lc_id .. "] • " .. lc_lvl .. " • " .. lc_adm
				admin_chat_lines.color = color
			end
		end
		for i = admin_chat_lines.lines.v, 1, -1 do
			if i ~= 1 then
				ac_no_saved.chat_lines[i] = ac_no_saved.chat_lines[i-1]
			else
				ac_no_saved.chat_lines[i] = lc_text_chat
			end
		end
		return false
	elseif check_string == '(Жалоба/Вопрос)' and setting_items.Push_Report.v then
		showNotification("Уведомление", "Поступил новый репорт.")
		return true
	end

	if check_mat ~= nil and check_mat_id ~= nil and setting_items.Chat_Logger.v then

		local string_os = string.split(check_mat, " ")
		for i, value in ipairs(onscene) do
			for j, val in ipairs(string_os) do
				val = val:match("(%P+)")
				if val ~= nil then
					if value == string.rlower(val) then
						--[[local number_log_player = 0
						for _, _ in pairs(log_onscene) do
							number_log_player = number_log_player+1
						end
						number_log_player = number_log_player+1
						log_onscene[number_log_player] = {
							id = tonumber(check_mat_id),
							name = sampGetPlayerNickname(tonumber(check_mat_id)),
							text = check_mat,
							suspicion = value
						}
						date_onscene[number_log_player] = os.date()]]
						sampAddChatMessage(text, color)
						if not isGamePaused() then
							--sampSendChat("/ans " .. check_mat_id .. " Если Вы не согласны с верностью выданного наказания, Вы можете оставить жалобу...")
							--sampSendChat("/ans " .. check_mat_id .. " ...в нашей группе с Скриншотом наказания. Наша группа VK >> vk.com/dmdriftgta")
							sampSendChat("/mute " .. check_mat_id .. " 300 Нецензурная лексика.")
							showNotification("Детектор обнаружил нарушение!", "Запрещенное слово: {FF0000}" .. value .. "\n {FFFFFF}Ник нарушителя: {FF0000}" .. sampGetPlayerNickname(tonumber(check_mat_id)))
							sampSendChat('/time')					
						end
						break
						break
	
					end
				end
			end
		end
		return true

	end
	if text == "Вы отключили меню при наблюдении" and setting_items.hide_td.v then
		sampSendChat("/remenu")
		return false
	end
	if text == "Вы включили меню при наблюдении" then
		control_recon = true
		if recon_to_player then
			control_info_load = true
			accept_load = false
		end
		return false
	end
	if text == "Вы отключили меню при наблюдении" and not setting_items.hide_td.v then
		control_recon = false
		return false
	end
	if (text == "Игрок не в сети" and recon_to_player) or (text == "[Информация] {ffeabf}Вы не можете следить за администратором который выше уровнем." and recon_to_player) then
		recon_to_player = false
		sampSendChat("/reoff")
	end
end
function readChatlog()
	local file_check = assert(io.open(getWorkingDirectory() .. "\\config\\AH_Setting\\chatlog\\" .. os.date("!*t").day .. "-" .. os.date("!*t").month .. "-" .. os.date("!*t").year .. ".txt", "r"))
	local t = file_check:read("*all")
	sampAddChatMessage(tag .. "Чтение файла", -1)
	file_check:close()
	t = t:gsub("{......}", "")
	local final_text = {}
	final_text = string.split(t, "\n")
	sampAddChatMessage(tag .. "Файл прочитан. " .. final_text[1], -1)
		return final_text
end
function  getFileName()
    if not doesFileExist(getWorkingDirectory() .. "\\config\\AH_Setting\\chatlog\\" .. os.date("!*t").day .. "-" .. os.date("!*t").month .. "-" .. os.date("!*t").year .. ".txt") then
        f = io.open(getWorkingDirectory() .. "\\config\\AH_Setting\\chatlog\\" .. os.date("!*t").day .. "-" .. os.date("!*t").month .. "-" .. os.date("!*t").year .. ".txt","w")
        f:close()
        file = string.format(getWorkingDirectory() .. "\\config\\AH_Setting\\chatlog\\" .. os.date("!*t").day .. "-" .. os.date("!*t").month .. "-" .. os.date("!*t").year .. ".txt")
        return file
    else
        file = string.format(getWorkingDirectory() .. "\\config\\AH_Setting\\chatlog\\" .. os.date("!*t").day .. "-" .. os.date("!*t").month .. "-" .. os.date("!*t").year .. ".txt")
        return file  
    end
end
function sampev.onShowDialog(dialogid, _, _, _, _, _)
	--sampAddChatMessage(tag .. dialogid)
end
function sampev.onDisplayGameText(_, _, text)
	if text == "~y~REPORT++" then
		return false
	end
end
function drawAdminChat()
	while true do
		if setting_items.Admin_chat.v then
			if admin_chat_lines.centered.v == 0 then
				for i = admin_chat_lines.lines.v, 1, -1 do
					if ac_no_saved.chat_lines[i] == nil then
						ac_no_saved.chat_lines[i] = " "
					end
					renderFontDrawText(font_ac, ac_no_saved.chat_lines[i], admin_chat_lines.X, admin_chat_lines.Y+((tonumber(font_size_ac.v) or 10)+5)*(admin_chat_lines.lines.v - i), join_argb(explode_samp_rgba(admin_chat_lines.color)))
				end
			elseif admin_chat_lines.centered.v == 1 then
			--x - renderGetFontDrawTextLength(font, text) / 2
				for i = admin_chat_lines.lines.v, 1, -1 do
					if ac_no_saved.chat_lines[i] == nil then
						ac_no_saved.chat_lines[i] = " "
					end
					renderFontDrawText(font_ac, ac_no_saved.chat_lines[i], admin_chat_lines.X - renderGetFontDrawTextLength(font_ac, ac_no_saved.chat_lines[i]) / 2, admin_chat_lines.Y+((tonumber(font_size_ac.v) or 10)+5)*(admin_chat_lines.lines.v - i), join_argb(explode_samp_rgba(admin_chat_lines.color)))
				end
			elseif admin_chat_lines.centered.v == 2 then
				for i = admin_chat_lines.lines.v, 1, -1 do
					if ac_no_saved.chat_lines[i] == nil then
						ac_no_saved.chat_lines[i] = " "
					end
					renderFontDrawText(font_ac, ac_no_saved.chat_lines[i], admin_chat_lines.X - renderGetFontDrawTextLength(font_ac, ac_no_saved.chat_lines[i]), admin_chat_lines.Y+((tonumber(font_size_ac.v) or 10)+5)*(admin_chat_lines.lines.v - i), join_argb(explode_samp_rgba(admin_chat_lines.color)))
				end
			end
		end
		wait(1)
	end
end
function showNotification(handle, text_not)
	notfy.addNotify("{6930A1}" .. handle, " \n " .. text_not, 2, 1, 10)
	setAudioStreamState(load_audio, ev.PLAY)
end
function controlOnscene()
	local number_log_player_2
	for number_log_player, value in ipairs(log_onscene) do
		number_log_player_2 = number_log_player + 1
		if log_onscene[number_log_player].id == nil then
			if log_onscene[number_log_player_2] ~= nil then
				log_onscene[number_log_player].id = log_onscene[number_log_player_2].id
				log_onscene[number_log_player_2].id = nil
				log_onscene[number_log_player].name = log_onscene[number_log_player_2].name
				log_onscene[number_log_player_2].name = nil
				log_onscene[number_log_player].text = log_onscene[number_log_player_2].text
				log_onscene[number_log_player_2].text = nil
				log_onscene[number_log_player].suspicion = log_onscene[number_log_player_2].suspicion
				log_onscene[number_log_player_2].suspicion = nil
				date_onscene[number_log_player] = date_onscene[number_log_player_2]
				date_onscene[number_log_player_2] = nil
			end
		end
	end
end
function playersToStreamZone()
	local peds = getAllChars()
	local streaming_player = {}
	local _, pid = sampGetPlayerIdByCharHandle(PLAYER_PED)
	for key, v in pairs(peds) do
		local result, id = sampGetPlayerIdByCharHandle(v)
		if result and id ~= pid and id ~= tonumber(control_recon_playerid) then
			streaming_player[key] = id
		end
	end
	return streaming_player
end
function loadPlayerInfo()
	wait(3000)
	accept_load = true
end
function loadChatLog()
	wait(6000)
	accept_load_clog = true
end
function convert3Dto2D(x, y, z)
    local result, wposX, wposY, wposZ, w, h = convert3DCoordsToScreenEx(x, y, z, true, true)
    local fullX = readMemory(0xC17044, 4, false)
    local fullY = readMemory(0xC17048, 4, false)
    wposX = wposX * (640.0 / fullX)
    wposY = wposY * (448.0 / fullY)
    return result, wposX, wposY
end
function drawWallhack()
	local peds = getAllChars()
	local _, pid = sampGetPlayerIdByCharHandle(PLAYER_PED)
	while true do
		wait(10)
		for i = 0, sampGetMaxPlayerId() do
			if sampIsPlayerConnected(i) and control_wallhack then
				local result, cped = sampGetCharHandleBySampPlayerId(i)
				local color = sampGetPlayerColor(i)
				local aa, rr, gg, bb = explode_argb(color)
				local color = join_argb(255, rr, gg, bb)
				if result then
					if doesCharExist(cped) and isCharOnScreen(cped) then
						local t = {3, 4, 5, 51, 52, 41, 42, 31, 32, 33, 21, 22, 23, 2}
						for v = 1, #t do
							pos1X, pos1Y, pos1Z = getBodyPartCoordinates(t[v], cped)
							pos2X, pos2Y, pos2Z = getBodyPartCoordinates(t[v] + 1, cped)
							pos1, pos2 = convert3DCoordsToScreen(pos1X, pos1Y, pos1Z)
							pos3, pos4 = convert3DCoordsToScreen(pos2X, pos2Y, pos2Z)
							renderDrawLine(pos1, pos2, pos3, pos4, 1, color)
						end
						for v = 4, 5 do
							pos2X, pos2Y, pos2Z = getBodyPartCoordinates(v * 10 + 1, cped)
							pos3, pos4 = convert3DCoordsToScreen(pos2X, pos2Y, pos2Z)
							renderDrawLine(pos1, pos2, pos3, pos4, 1, color)
						end
						local t = {53, 43, 24, 34, 6}
						for v = 1, #t do
							posX, posY, posZ = getBodyPartCoordinates(t[v], cped)
							pos1, pos2 = convert3DCoordsToScreen(posX, posY, posZ)
						end
					end
				end
			end
		end
	end
end
function getBodyPartCoordinates(id, handle)
  local pedptr = getCharPointer(handle)
  local vec = ffi.new("float[3]")
  getBonePosition(ffi.cast("void*", pedptr), vec, id, true)
  return vec[0], vec[1], vec[2]
end
function join_argb(a, r, g, b)
  local argb = b  -- b
  argb = bit.bor(argb, bit.lshift(g, 8))  -- g
  argb = bit.bor(argb, bit.lshift(r, 16)) -- r
  argb = bit.bor(argb, bit.lshift(a, 24)) -- a
  return argb
end
function explode_argb(argb)
  local a = bit.band(bit.rshift(argb, 24), 0xFF)
  local r = bit.band(bit.rshift(argb, 16), 0xFF)
  local g = bit.band(bit.rshift(argb, 8), 0xFF)
  local b = bit.band(argb, 0xFF)
  return a, r, g, b
end
function explode_samp_rgba(rgba)
	local b = bit.band(bit.rshift(rgba, 24), 0xFF)
	local r = bit.band(bit.rshift(rgba, 16), 0xFF)
	local g = bit.band(bit.rshift(rgba, 8), 0xFF)
	local a = bit.band(rgba, 0xFF)
	return a, r, g, b
end
function nameTagOn()
	local pStSet = sampGetServerSettingsPtr();
	NTdist = mem.getfloat(pStSet + 39)
	NTwalls = mem.getint8(pStSet + 47)
	NTshow = mem.getint8(pStSet + 56)
	mem.setfloat(pStSet + 39, 1488.0)
	mem.setint8(pStSet + 47, 0)
	mem.setint8(pStSet + 56, 1)
	nameTag = true
end
function nameTagOff()
	local pStSet = sampGetServerSettingsPtr();
	mem.setfloat(pStSet + 39, NTdist)
	mem.setint8(pStSet + 47, NTwalls)
	mem.setint8(pStSet + 56, NTshow)
	nameTag = false
end
function textSplit(str, delim, plain)
    local tokens, pos, plain = {}, 1, not (plain == false) --[[ delimiter is plain text by default ]]
    repeat
        local npos, epos = string.find(str, delim, pos, plain)
        table.insert(tokens, string.sub(str, pos, npos and npos - 1))
        pos = epos and epos + 1
    until not pos
    return tokens
end
function string.rlower(s)
    s = s:lower()
    local strlen = s:len()
    if strlen == 0 then return s end
    s = s:lower()
    local output = ''
    for i = 1, strlen do
        local ch = s:byte(i)
        if ch >= 192 and ch <= 223 then -- upper russian characters
            output = output .. russian_characters[ch + 32]
        elseif ch == 168 then -- Ё
            output = output .. russian_characters[184]
        else
            output = output .. string.char(ch)
        end
    end
    return output
end
function string.rupper(s)
    s = s:upper()
    local strlen = s:len()
    if strlen == 0 then return s end
    s = s:upper()
    local output = ''
    for i = 1, strlen do
        local ch = s:byte(i)
        if ch >= 224 and ch <= 255 then -- lower russian characters
            output = output .. russian_characters[ch - 32]
        elseif ch == 184 then -- ё
            output = output .. russian_characters[168]
        else
            output = output .. string.char(ch)
        end
    end
    return output
end
function getDownKeys()
    local curkeys = ""
    local bool = false
    for k, v in pairs(vkeys) do
        if isKeyDown(v) and (v == VK_MENU or v == VK_CONTROL or v == VK_SHIFT or v == VK_LMENU or v == VK_RMENU or v == VK_RCONTROL or v == VK_LCONTROL or v == VK_LSHIFT or v == VK_RSHIFT) then
            if v ~= VK_MENU and v ~= VK_CONTROL and v ~= VK_SHIFT then
                curkeys = v
            end
        end
    end
    for k, v in pairs(vkeys) do
        if isKeyDown(v) and (v ~= VK_MENU and v ~= VK_CONTROL and v ~= VK_SHIFT and v ~= VK_LMENU and v ~= VK_RMENU and v ~= VK_RCONTROL and v ~= VK_LCONTROL and v ~= VK_LSHIFT and v ~= VK_RSHIFT) then
            if tostring(curkeys):len() == 0 then
                curkeys = v
            else
                curkeys = curkeys .. " " .. v
            end
            bool = true
        end
    end
    return curkeys, bool
end
function getDownKeysText()
	tKeys = string.split(getDownKeys(), " ")
	if #tKeys ~= 0 then
		for i = 1, #tKeys do
			if i == 1 then
				str = vkeys.id_to_name(tonumber(tKeys[i]))
			else
				str = str .. "+" .. vkeys.id_to_name(tonumber(tKeys[i]))
			end
		end
		return str
	else
		return "None"
	end
end
function string.split(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            t[i] = str
            i = i + 1
    end
    return t
end
function strToIdKeys(str)
	tKeys = string.split(str, "+")
	if #tKeys ~= 0 then
		for i = 1, #tKeys do
			if i == 1 then
				str = vkeys.name_to_id(tKeys[i], false)
			else
				str = str .. " " .. vkeys.name_to_id(tKeys[i], false)
			end
		end
		return tostring(str)
	else
		return "(("
	end
end
function isKeysDown(keylist, pressed)
    local tKeys = string.split(keylist, " ")
    if pressed == nil then
        pressed = false
    end
    if tKeys[1] == nil then
        return false
    end
    local bool = false
    local key = #tKeys < 2 and tonumber(tKeys[1]) or tonumber(tKeys[2])
    local modified = tonumber(tKeys[1])
    if #tKeys < 2 then
        if not isKeyDown(VK_RMENU) and not isKeyDown(VK_LMENU) and not isKeyDown(VK_LSHIFT) and not isKeyDown(VK_RSHIFT) and not isKeyDown(VK_LCONTROL) and not isKeyDown(VK_RCONTROL) then
            if wasKeyPressed(key) and not pressed then
                bool = true
            elseif isKeyDown(key) and pressed then
                bool = true
            end
        end
    else
        if isKeyDown(modified) and not wasKeyReleased(modified) then
            if wasKeyPressed(key) and not pressed then
                bool = true
            elseif isKeyDown(key) and pressed then
                bool = true
            end
        end
    end
    if nextLockKey == keylist then
        if pressed and not wasKeyReleased(key) then
            bool = false
        else
            bool = false
            nextLockKey = ""
        end
    end
    return bool
end
function onWindowMessage(msg, wparam, lparam)
	if(msg == 0x100 or msg == 0x101) and setting_items.Custom_SB.v then
		if wparam == VK_TAB then
			consumeWindowMessage(true, false)
		end
	end
end



-- [x] -- ImGUI тело. -- [x] --
local W_Windows = sw/1.145
local H_Windows = 1
local text_dialog
function imgui.OnDrawFrame()
	imgui.ShowCursor = check_mouse
	if i_ans_window.v then
		imgui.SetNextWindowPos(imgui.ImVec2(W_Windows, H_Windows), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(280, 700), imgui.Cond.FirstUseEver)
		imgui.Begin(u8"Ответы на ANS", i_ans_window)
		local btn_size = imgui.ImVec2(-0.1, 0)
		imgui.Checkbox(u8"Пожелание в конце.", i_back_prefix)
		
		imgui.Separator()
		for key, v in pairs(i_ans) do
		
			if key == "default" then
			imgui.Separator()
				for key_2, v_2 in pairs(i_ans[key]) do
					if imgui.Button(key_2, btn_size) then
						if not i_back_prefix.v then
							local settext = '{FFFFFF}' .. v_2
							sampSendDialogResponse(2351, 1, 0, settext)
						else
							local settext = '{FFFFFF}' .. v_2 .. u8:decode(' {FF00FF}// ' .. Wish.v) 
							sampSendDialogResponse(2351, 1, 0, settext)

						end
					end
				end
			else
				if imgui.CollapsingHeader(key) then
					for key_2, v_2 in pairs(i_ans[key]) do
						if imgui.Button(key_2, btn_size) then
							if not i_back_prefix.v then
								local settext = '{FFFFFF}' .. v_2
								sampSendDialogResponse(2351, 1, 0, settext)
							else
								local settext = '{FFFFFF}' .. v_2 .. u8:decode(' {FF00FF}// ' .. Wish.v)
								sampSendDialogResponse(2351, 1, 0, settext)
							end
						end
					end
				end
			end
		end
		imgui.End()
	end
	if i_setting_items.v then
		imgui.LockPlayer = true
		imgui.SetNextWindowPos(imgui.ImVec2(sw-10, 10), imgui.Cond.FirstUseEver, imgui.ImVec2(1, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(300, sh/1.15), imgui.Cond.FirstUseEver)
		local btn_size = imgui.ImVec2(-0.1, 0)
		imgui.Begin(u8"Настройки скрипта.", i_setting_items)
		imgui.Text(u8"Кастомное наблюдение за игроком.")
		imgui.SameLine()
		imgui.SetCursorPosX(imgui.GetWindowWidth() - 35)
		imgui.ToggleButton("##1", setting_items.hide_td)
		imgui.Text(u8"Быстрые ответы на ANS.")
		imgui.SameLine()
		imgui.SetCursorPosX(imgui.GetWindowWidth() - 35)
		imgui.ToggleButton("##2", setting_items.Fast_ans)
		imgui.Text(u8"Уведомления о репорте.")
		imgui.SameLine()
		imgui.SetCursorPosX(imgui.GetWindowWidth() - 35)
		imgui.ToggleButton("##3", setting_items.Push_Report)
		imgui.Text(u8"Кастомный ScoreBoard (TAB).")
		imgui.SameLine()
		imgui.SetCursorPosX(imgui.GetWindowWidth() - 35)
		imgui.ToggleButton("##4", setting_items.Custom_SB)
		imgui.Text(u8"Чат-логгер.")
		imgui.SameLine()
		imgui.SetCursorPosX(imgui.GetWindowWidth() - 35)
		imgui.ToggleButton("##5", setting_items.Chat_Logger)
		imgui.Text(u8"Сокращенные команды наказаний.")
		imgui.SameLine()
		imgui.SetCursorPosX(imgui.GetWindowWidth() - 35)
		imgui.ToggleButton("##6", setting_items.Punishments)
		imgui.Text(u8"Админ чат.")
		imgui.SameLine()
		imgui.SetCursorPosX(imgui.GetWindowWidth() - 35)
		imgui.ToggleButton("##7", setting_items.Admin_chat)
		imgui.Text(u8"Прозрачность админ чата.")
		imgui.SameLine()
		imgui.SetCursorPosX(imgui.GetWindowWidth() - 35)
		imgui.ToggleButton("##8", setting_items.Transparency)
		
		imgui.Text(u8"Полезные функции.")
		imgui.SameLine(255)
	   if imgui.Button(u8'Open') then
	   ah_help.v = true
	   end
	   imgui.Separator()
		imgui.InputText(u8"Приветствие.", HelloAC)
		imgui.InputText(u8'Пожелание.', Wish)
		-- new
		if imgui.CollapsingHeader(u8'Пароли.') then
		imgui.InputText(u8"Админ Пароль", AdminPassword)
		imgui.InputText(u8"Пароль Входа", LoginPassword)
		end
		imgui.Separator()
		if setting_items.Admin_chat.v then
			if imgui.Button(u8'Настройка админ чата.', btn_size) then
				i_admin_chat_setting.v = not i_admin_chat_setting.v
			end
		end
		imgui.Separator()
		if imgui.Button(u8"Настройка клавиш скрипта.") then
			setting_keys = true
		end
		if theme_res then
			imgui.SameLine()
			if imgui.Button(u8"Цветовая схема.") then
				menu_tems.v = not menu_tems.v
			end
		end
		imgui.Separator()
		if imgui.Button(u8"Сохранить.") then
			config.setting.Fast_ans = setting_items.Fast_ans.v
			config.setting.Admin_chat = setting_items.Admin_chat.v
			config.setting.Punishments = setting_items.Punishments.v
			config.setting.Tranparency = setting_items.Transparency.v
			config.setting.Custom_SB = setting_items.Custom_SB.v
			config.setting.Auto_remenu = setting_items.Auto_remenu.v
			config.setting.Push_Report = setting_items.Push_Report.v
			config.setting.Chat_Logger = setting_items.Chat_Logger.v
			config.setting.hide_td = setting_items.hide_td.v
			config.setting.HelloAC = HelloAC.v
			config.setting.number_themes = checked_radio.v
			-- new
			config.setting.AdminPassword = AdminPassword.v
			config.setting.LoginPassword = LoginPassword.v
			config.setting.Wish = Wish.v
			inicfg.save(config, directIni)
          sampAddChatMessage(tag .. 'Настройки сохранены.')
		end	
		imgui.SameLine()
		if imgui.Button(u8"Отключить.") then
			lua_thread.create(function ()
                imgui.Process = false
                wait(200)
				sampAddChatMessage(tag .. "Скрипт завершил свою работу.")
				sampAddChatMessage(tag .. "Если остался курсор, откройте и закройте панель SAMPFUNCS [ Клавиша Ё ].")
				wait(200)
				imgui.ShowCursor = false
                thisScript():unload()
            end)
        end
		imgui.SameLine()
		if imgui.Button(u8"Перезагрузить.") then
			imgui.ShowCursor = false
			sampAddChatMessage(tag .. "Скрипт перезагружается.")
			thisScript():reload()
		end
		imgui.ColorEdit3(u8'Цвета HTML', color_gang)
		imgui.Separator()
		imgui.SetCursorPosX(imgui.GetWindowWidth()/2-100)
		imgui.Image(logo_image, imgui.ImVec2(200, 200))
		if update_state.update_script then
			imgui.SetCursorPosY(imgui.GetWindowHeight() - 55)
			imgui.Separator()
			imgui.Text(u8"Версия скрипта: " .. script_version_text)
			imgui.Text(u8"Доступно обновление!\nНовая версия скрипта: " .. updateIni.info.version_text)
			imgui.SameLine()
			imgui.SetCursorPosX(imgui.GetWindowWidth() - 80)
			if imgui.Button(u8"Обновить.") then
				showNotification("Обновление!", "Началось обновление скрипта.")
				downloadUrlToFile(script_url, script_path, function(id, status)
					if status == dlstat.STATUS_ENDDOWNLOADDATA then
						showNotification("Обновление!", "Скрипт успешно обновлен!")
						thisScript():reload()
					end
				end)
			end
		elseif update_state.update_scoreboard then
			imgui.SetCursorPosY(imgui.GetWindowHeight() - 65)
			imgui.Separator()
			imgui.Text(u8"Версия скрипта: " .. script_version_text)
			imgui.Text(u8"Доступно обновление библиотеки!\nНовая версия библиотеки: " .. updateIni.info.sb_text_version)
			imgui.SameLine()
			imgui.SetCursorPosX(imgui.GetWindowWidth() - 80)
			if imgui.Button(u8"Обновить.") then
				showNotification("Обновление!", "Началось обновление библиотеки.")
				downloadUrlToFile(scoreboard_url, scoreboard_path, function(id, status)
					if status == dlstat.STATUS_ENDDOWNLOADDATA then
						wait_reload:run()
					end
				end)
			end
		else
			imgui.SetCursorPosY(imgui.GetWindowHeight() - 50)
			imgui.Separator()
			imgui.Text(u8"Версия скрипта: " .. script_version_text)
			if imgui.Button(u8"Обновления ##Info", imgui.ImVec2(-0.1, 0)) then
				i_info_update.v = true
				i_setting_items.v = false
			end
		end
		imgui.End()
		
		if setting_keys then
			imgui.SetNextWindowPos(imgui.ImVec2(10, 10), imgui.Cond.FirstUseEver, imgui.ImVec2(1, 0.5))
			imgui.SetNextWindowSize(imgui.ImVec2(300, sh/1.15), imgui.Cond.FirstUseEver)
			imgui.Begin(u8"Настройка клавиш.")
			imgui.Text(u8"Зажатые кнопки: ")
			imgui.SameLine()
			imgui.TextColored(imgui.ImVec4(0.71, 0.59, 1.0, 1.0), getDownKeysText())
			imgui.Separator()
			imgui.Text(u8"Открытие настроек: ")
			imgui.SameLine()
			imgui.TextColored(imgui.ImVec4(0.71, 0.59, 1.0, 1.0), config.keys.Setting)
			imgui.SetCursorPosX(imgui.GetWindowWidth() - 84)
			if imgui.Button(u8"Записать. ## 1", imgui.ImVec2(75, 0)) then
				config.keys.Setting = getDownKeysText()
				inicfg.save(config, directIni)
			end
			imgui.Separator()
			imgui.Text(u8"Статистика игрока при слежке: ")
			imgui.SameLine()
			imgui.TextColored(imgui.ImVec4(0.71, 0.59, 1.0, 1.0), config.keys.Re_menu)
			imgui.SetCursorPosX(imgui.GetWindowWidth() - 84)
			if imgui.Button(u8"Записать. ## 2", imgui.ImVec2(75, 0)) then
				config.keys.Re_menu = getDownKeysText()
				inicfg.save(config, directIni)
			end
			imgui.Separator()
			imgui.Text(u8"Приветствие в админ-чат: ")
			imgui.SameLine()
			imgui.TextColored(imgui.ImVec4(0.71, 0.59, 1.0, 1.0), config.keys.Hello)
			imgui.SetCursorPosX(imgui.GetWindowWidth() - 84)
			if imgui.Button(u8"Записать. ## 3", imgui.ImVec2(75, 0)) then
				config.keys.Hello = getDownKeysText()
				inicfg.save(config, directIni)
			end
			imgui.Separator()
			imgui.Text(u8"Открытие лога мата: ")
			imgui.SameLine()
			imgui.TextColored(imgui.ImVec4(0.71, 0.59, 1.0, 1.0), config.keys.P_Log)
			imgui.SetCursorPosX(imgui.GetWindowWidth() - 84)
			if imgui.Button(u8"Записать. ## 4", imgui.ImVec2(75, 0)) then
				config.keys.P_Log = getDownKeysText()
				inicfg.save(config, directIni)
			end
			imgui.Separator()
			imgui.Text(u8"Скрытие админ-чата: ")
			imgui.SameLine()
			imgui.TextColored(imgui.ImVec4(0.71, 0.59, 1.0, 1.0), config.keys.Hide_AChat)
			imgui.SetCursorPosX(imgui.GetWindowWidth() - 84)
			if imgui.Button(u8"Записать. ## 5", imgui.ImVec2(75, 0)) then
				config.keys.Hide_AChat = getDownKeysText()
				inicfg.save(config, directIni)
			end
			imgui.Separator()
			imgui.Text(u8"Курсор мышки при слежке: ")
			imgui.SameLine()
			imgui.TextColored(imgui.ImVec4(0.71, 0.59, 1.0, 1.0), config.keys.Mouse)
			imgui.SetCursorPosX(imgui.GetWindowWidth() - 84)
			if imgui.Button(u8"Записать. ## 6", imgui.ImVec2(75, 0)) then
				config.keys.Mouse = getDownKeysText()
				inicfg.save(config, directIni)
			end
			imgui.Separator()
			if imgui.Button(u8"Назад.", imgui.ImVec2(-0.1, 0)) then
				setting_keys = false
			end
			
			imgui.End()
		end
	end
	if menu_tems.v then
		imgui.SetNextWindowPos(imgui.ImVec2(sw/2, sh/2.5), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 1))
		imgui.SetNextWindowSize(imgui.ImVec2(sw/3.1, -0.1), imgui.Cond.FirstUseEver)
		imgui.Begin(u8"Выбор цветовой схемы.", menu_tems, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar)
		for i, value in ipairs(themes.colorThemes) do
			if imgui.RadioButton(value, checked_radio, i) then
				themes.SwitchColorTheme(i)
			end
		end
		imgui.Separator()
		if imgui.Button('Close' ,imgui.ImVec2(-0.1, 0)) then
			menu_tems.v = false
		end
		imgui.End()
	end
	if i_info_update.v then
		imgui.LockPlayer = true
		imgui.SetNextWindowPos(imgui.ImVec2(sw/2, sh/2.5), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 1))
		imgui.SetNextWindowSize(imgui.ImVec2(sw/1.3, -0.1), imgui.Cond.FirstUseEver)
		imgui.Begin(u8"Обновления", i_info_update)
		imgui.Text(u8'Версия 4.0:')
		imgui.Text(u8"- Добавила авто ввод паролей.")
		imgui.Text(u8"- Добавила новые ответы на репорты.")
		imgui.Text(u8"- Добавила пожелание после ответа на репорт.")
		imgui.Text(u8"- Исправила некоторые ошибки.")
		imgui.SetCursorPosX(imgui.GetWindowWidth()/2)
		if imgui.Button(u8"Выход.", imgui.ImVec2(100, 0)) then
			i_info_update.v = false
		end
		imgui.End()
	end
	if i_re_menu.v and control_recon and recon_to_player and setting_items.hide_td.v then
		imgui.LockPlayer = false
		imgui.SetNextWindowPos(imgui.ImVec2(sw/2, sh/1.06), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 1))
		imgui.SetNextWindowSize(imgui.ImVec2(80+80+80+80+80+10, sh-sh-10), imgui.Cond.FirstUseEver)
		imgui.Begin(u8"Наказания игрока.", false, 2+4+32)
			imgui.SetCursorPosX(imgui.GetWindowWidth()/2.43-160)
			if imgui.Button(u8"Обновить.", imgui.ImVec2(75, 0)) then
				sampSendClickTextdraw(32)
			end
			imgui.SameLine()
			imgui.SetCursorPosX(imgui.GetWindowWidth()/2.43-80)
			if imgui.Button(u8"Посадить.", imgui.ImVec2(75, 0)) then
				jail_or_ban_re = 1
			end
			imgui.SameLine()
			imgui.SetCursorPosX(imgui.GetWindowWidth()/2.41)
			if imgui.Button(u8"Забанить.", imgui.ImVec2(75, 0)) then
				jail_or_ban_re = 2
			end
			imgui.SameLine()
			imgui.SetCursorPosX(imgui.GetWindowWidth()/2.43+80)
			if imgui.Button(u8"Кикнуть.", imgui.ImVec2(75, 0)) then
				jail_or_ban_re = 3
			end
			imgui.SameLine()
			imgui.SetCursorPosX(imgui.GetWindowWidth()/2.43+160)
			if imgui.Button(u8"Выйти.", imgui.ImVec2(75, 0)) then
				sampSendChat("/reoff")
				control_recon_playerid = -1
			end
		imgui.End()
		imgui.SetNextWindowPos(imgui.ImVec2(sw-10, 10), imgui.Cond.FirstUseEver, imgui.ImVec2(1, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(250, sh/1.15), imgui.Cond.FirstUseEver)
		if right_re_menu then
			imgui.Begin(u8"Информация об игроке.", false, 2+4+32)
			if accept_load then
				if not sampIsPlayerConnected(control_recon_playerid) then
					control_recon_playernick = "-"
				else
					control_recon_playernick = sampGetPlayerNickname(control_recon_playerid)
				end
				imgui.Text(u8"Игрок: " .. control_recon_playernick .. "[" .. control_recon_playerid .. "]")
				imgui.Separator()
				--[[local i = 1
				while i <= 14 do
					if i == 3 or i == 4 then
						if i == 3 and tonumber(player_info[3]) ~= 0 then
							imgui.Text(u8:encode(text_remenu[i]) .. " " .. player_info[i])
						end
						if i == 4 and tonumber(player_info[4]) ~= -1 then
							imgui.Text(u8:encode(text_remenu[i]) .. " " .. player_info[i])
						end
					else
						imgui.Text(u8:encode(text_remenu[i]) .. " " .. player_info[i])
					end
					if i == 3 then
						if tonumber(player_info[3]) ~= 0 then
							imgui.BufferingBar(tonumber(player_info[i])/100, imgui.ImVec2(imgui.GetWindowWidth()-10, 10), false)
						end
					end
					if i == 2 then
						imgui.BufferingBar(tonumber(player_info[i])/100, imgui.ImVec2(imgui.GetWindowWidth()-10, 10), false)
					end
					if i == 4 and tonumber(player_info[4]) ~= -1 then
						imgui.BufferingBar(tonumber(player_info[4])/1000, imgui.ImVec2(imgui.GetWindowWidth()-10, 10), false)
					end
					if i == 5 then
						local speed, const = string.match(player_info[5], "(%d+) / (%d+)")
						if tonumber(speed) > tonumber(const) then
							speed = const
						end
						imgui.BufferingBar((tonumber(speed)*100/tonumber(const))/100, imgui.ImVec2(imgui.GetWindowWidth()-10, 10), false)
					end
				i = i + 1
				end]]
				for key, v in pairs(player_info) do
					if key == 2 then
						imgui.Text(u8:encode(text_remenu[2]) .. " " .. player_info[2])
						imgui.BufferingBar(tonumber(player_info[2])/100, imgui.ImVec2(imgui.GetWindowWidth()-10, 10), false)
					end
					if key == 3 and tonumber(player_info[3]) ~= 0 then
						imgui.Text(u8:encode(text_remenu[3]) .. " " .. player_info[3])
						imgui.BufferingBar(tonumber(player_info[3])/100, imgui.ImVec2(imgui.GetWindowWidth()-10, 10), false)
					end
					if key == 4 and tonumber(player_info[4]) ~= -1 then
						imgui.Text(u8:encode(text_remenu[4]) .. " " .. player_info[4])
						imgui.BufferingBar(tonumber(player_info[4])/1000, imgui.ImVec2(imgui.GetWindowWidth()-10, 10), false)
					end
					if key == 5 then
						imgui.Text(u8:encode(text_remenu[5]) .. " " .. player_info[5])
						local speed, const = string.match(player_info[5], "(%d+) / (%d+)")
						if tonumber(speed) > tonumber(const) then
							speed = const
						end
						imgui.BufferingBar((tonumber(speed)*100/tonumber(const))/100, imgui.ImVec2(imgui.GetWindowWidth()-10, 10), false)
					end
					if key ~= 2 and key ~= 3 and key ~= 4 and key ~= 5 then
						imgui.Text(u8:encode(text_remenu[key]) .. " " .. player_info[key])
					end
				end
				--[[imgui.Text(u8:encode(text_remenu[1]) .. " " .. player_info[1])
				imgui.Text(u8:encode(text_remenu[2]) .. " " .. player_info[2])
				imgui.BufferingBar(tonumber(player_info[2])/100, imgui.ImVec2(imgui.GetWindowWidth()-10, 10), false)
				if tonumber(player_info[3]) ~= 0 then
					imgui.Text(u8:encode(text_remenu[3]) .. " " .. player_info[3])
				end
				if tonumber(player_info[3]) ~= 0 then
					imgui.BufferingBar(tonumber(player_info[3])/100, imgui.ImVec2(imgui.GetWindowWidth()-10, 10), false)
				end
				if tonumber(player_info[4]) ~= -1 then
					imgui.Text(u8:encode(text_remenu[4]) .. " " .. player_info[4])
					imgui.BufferingBar(tonumber(player_info[4])/1000, imgui.ImVec2(imgui.GetWindowWidth()-10, 10), false)
				end
				imgui.Text(u8:encode(text_remenu[5]) .. " " .. player_info[5])
				local speed, const = string.match(player_info[5], "(%d+) / (%d+)")
					if tonumber(speed) > tonumber(const) then
						speed = const
					end
				imgui.BufferingBar((tonumber(speed)*100/tonumber(const))/100, imgui.ImVec2(imgui.GetWindowWidth()-10, 10), false)
				imgui.Text(u8:encode(text_remenu[6]) .. " " .. player_info[6])
				imgui.Text(u8:encode(text_remenu[7]) .. " " .. player_info[7])
				imgui.Text(u8:encode(text_remenu[8]) .. " " .. player_info[8])
				imgui.Text(u8:encode(text_remenu[9]) .. " " .. player_info[9])
				imgui.Text(u8:encode(text_remenu[10]) .. " " .. player_info[10])
				imgui.Text(u8:encode(text_remenu[11]) .. " " .. player_info[11])
				imgui.Text(u8:encode(text_remenu[12]) .. " " .. player_info[12])
				imgui.Text(u8:encode(text_remenu[13]) .. " " .. player_info[13])
				imgui.Text(u8:encode(text_remenu[14]) .. " " .. player_info[14])
				imgui.Text(u8:encode(text_remenu[15]) .. " " .. player_info[15])]]
				imgui.Separator()
				if imgui.Button("WallHack", imgui.ImVec2(-0.1, 0)) then
					if control_wallhack then
						nameTagOff()
						control_wallhack = false
					else
						nameTagOn()
						control_wallhack = true
					end
				end
				imgui.Separator()
				imgui.Text(u8"Игроки рядом:")
				local playerid_to_stream = playersToStreamZone()
				for _, v in pairs(playerid_to_stream) do
					if imgui.Button(" - " .. sampGetPlayerNickname(v) .. "[" .. v .. "] - ", imgui.ImVec2(-0.1, 0)) then
						sampSendChat("/re " .. v)
					end
				end
				imgui.Separator()
				imgui.Text(u8"Что бы убрать курсор для\n осмотра камерой: Зажмите ПКМ.")
			else
				imgui.SetCursorPosX(imgui.GetWindowWidth()/2.3)
				imgui.SetCursorPosY(imgui.GetWindowHeight()/2.3)
				imgui.Spinner(20, 7)
			end
			imgui.End()
		end
		if jail_or_ban_re > 0 then
			imgui.SetNextWindowPos(imgui.ImVec2(10, 10), imgui.Cond.FirstUseEver, imgui.ImVec2(1, 0.5))
			imgui.SetNextWindowSize(imgui.ImVec2(250, sh/1.15), imgui.Cond.FirstUseEver)
			imgui.Begin(u8"Наказания игрока. ##Nak", false, 2+4+32)
			if jail_or_ban_re == 1 then
				if imgui.Button("Speed Hack", imgui.ImVec2(-0.1, 0)) then
					sampSendChat("/jail " .. control_recon_playerid .. " 900 Использование запрещенного софта. (Speed Hack)")
				end
				if imgui.Button("Fly", imgui.ImVec2(-0.1, 0)) then
					sampSendChat("/jail " .. control_recon_playerid .. " 900 Использование запрещенного софта. (Fly)")
				end
				if imgui.Button("Fly Car", imgui.ImVec2(-0.1, 0)) then
					sampSendChat("/jail " .. control_recon_playerid .. " 900 Использование запрещенного софта. (Fly Car)")
				end
				if imgui.Button(u8"Помеха MP", imgui.ImVec2(-0.1, 0)) then
					sampSendChat("/jail " .. control_recon_playerid .. " 300 Помеха мероприятию.")
				end
				if imgui.Button("Spawn Kill", imgui.ImVec2(-0.1, 0)) then
					sampSendChat("/jail " .. control_recon_playerid .. " 300 Spawn Kill")
				end
				if imgui.Button(u8"Назад. ##1", imgui.ImVec2(-0.1, 0)) then
					jail_or_ban_re = 0
				end
			elseif jail_or_ban_re == 2 then
				if imgui.Button("S0beit", imgui.ImVec2(-0.1, 0)) then
					sampSendChat("/ban " .. control_recon_playerid .. " 7 Использование запрещенного софта. (S0beit)")
				end
				if imgui.Button("Aim", imgui.ImVec2(-0.1, 0)) then
					sampSendChat("/iban " .. control_recon_playerid .. " 7 Использование запрещенного софта. (Aim)")
				end
				if imgui.Button("Auto +C", imgui.ImVec2(-0.1, 0)) then
					sampSendChat("/iban " .. control_recon_playerid .. " 7 Использование запрещенного софта. (Auto +C)")
				end
				if imgui.Button("Rvanka", imgui.ImVec2(-0.1, 0)) then
					sampSendChat("/iban " .. control_recon_playerid .. " 7 Использование запрещенного софта. (Rvanka)")
				end
				if imgui.Button("Car Shot", imgui.ImVec2(-0.1, 0)) then
					sampSendChat("/iban " .. control_recon_playerid .. " 7 Использование запрещенного софта. (Car Shot)")
				end
				if imgui.Button("Cheat", imgui.ImVec2(-0.1, 0)) then
					sampSendChat("/iban " .. control_recon_playerid .. " 7 Использование запрещенного софта.")
				end
				if imgui.Button(u8"Неадекватное поведение.", imgui.ImVec2(-0.1, 0)) then
					sampSendChat("/iban " .. control_recon_playerid .. " 3 Неадекватное поведение.")
				end
				if imgui.Button("Nick 3/3", imgui.ImVec2(-0.1, 0)) then
					sampSendChat("/ban " .. control_recon_playerid .. " 3 Nick 3/3")
				end
				if imgui.Button(u8"Назад. ##2", imgui.ImVec2(-0.1, 0)) then
					jail_or_ban_re = 0
				end
			elseif jail_or_ban_re == 3 then
				if imgui.Button("Nick 1/3", imgui.ImVec2(-0.1, 0)) then
					sampSendChat("/kick " .. control_recon_playerid .. " Nick 1/3")
				end
				if imgui.Button("Nick 2/3", imgui.ImVec2(-0.1, 0)) then
					sampSendChat("/kick " .. control_recon_playerid .. " Nick 2/3")
				end
				if imgui.Button(u8"Назад. ##3", imgui.ImVec2(-0.1, 0)) then
					jail_or_ban_re = 0
				end
			end
			imgui.End()
		end
	end
	if i_cmd_helper.v then
		local in1 = sampGetInputInfoPtr()
		local in1 = getStructElement(in1, 0x8, 4)
		local in2 = getStructElement(in1, 0x8, 4)
		local in3 = getStructElement(in1, 0xC, 4)
		fib = in3 + 41
		fib2 = in2 + 10
		imgui.SetNextWindowPos(imgui.ImVec2(fib2, fib), imgui.Cond.FirstUseEver, imgui.ImVec2(0, -0.1))
		imgui.SetNextWindowSize(imgui.ImVec2(590, 250), imgui.Cond.FirstUseEver)
		imgui.Begin(u8"Быстрые команды наказаний.", false, 2+4+32)
		if check_cmd_punis ~= nil then
			for key, v in pairs(cmd_punis_mute) do
				if v:find(string.lower(check_cmd_punis)) ~= nil or v:find(string.lower(RusToEng(check_cmd_punis))) ~= nil or v == string.lower(check_cmd_punis):match("(.+) (.+) ") or v == string.lower(RusToEng(check_cmd_punis)):match("(.+) (.+) ")  or v == string.lower(check_cmd_punis):match("(.+) ") or v == string.lower(RusToEng(check_cmd_punis)):match("(.+) ") then
					imgui.Text("Mute: -" .. v .. u8" [PlayerID] (Множитель наказания.) - " .. u8:encode(punishments[v].reason))
				end
			end
			for key, v in pairs(cmd_punis_ban) do
				if v:find(string.lower(check_cmd_punis)) ~= nil or v:find(string.lower(RusToEng(check_cmd_punis))) ~= nil or v == string.lower(check_cmd_punis):match("(.+) (.+) ") or v == string.lower(RusToEng(check_cmd_punis)):match("(.+) (.+) ")  or v == string.lower(check_cmd_punis):match("(.+) ") or v == string.lower(RusToEng(check_cmd_punis)):match("(.+) ") then
					imgui.Text("Ban: -" .. v .. u8" [PlayerID] - " .. u8:encode(punishments[v].reason))
				end
			end
			for key, v in pairs(cmd_punis_jail) do
				if v:find(string.lower(check_cmd_punis)) ~= nil or v:find(string.lower(RusToEng(check_cmd_punis))) ~= nil or v == string.lower(check_cmd_punis):match("(.+) (.+) ") or v == string.lower(RusToEng(check_cmd_punis)):match("(.+) (.+) ")  or v == string.lower(check_cmd_punis):match("(.+) ") or v == string.lower(RusToEng(check_cmd_punis)):match("(.+) ") then
					imgui.Text("Jail: -" .. v .. u8" [PlayerID] - " .. u8:encode(punishments[v].reason))
				end
			end
		else
			for key, v in pairs(cmd_punis_mute) do
				imgui.Text("Mute: -" .. v .. u8" [PlayerID] (Множитель наказания.) - " .. u8:encode(punishments[v].reason))
			end
			for key, v in pairs(cmd_punis_ban) do
				imgui.Text("Ban: -" .. v .. u8" [PlayerID] - " .. u8:encode(punishments[v].reason))
			end
			for key, v in pairs(cmd_punis_jail) do
				imgui.Text("Jail: -" .. v .. u8" [PlayerID] - " .. u8:encode(punishments[v].reason))
			end
		end
		imgui.End()
	end
	if i_chat_logger.v then
		imgui.LockPlayer = true
		imgui.SetNextWindowPos(imgui.ImVec2(sw/2, sh/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 1))
		imgui.SetNextWindowSize(imgui.ImVec2(sw/1.3, sh/1.05), imgui.Cond.FirstUseEver)
		imgui.Begin(u8"Чат-логер", i_chat_logger)
			if accept_load_clog then
				imgui.InputText(u8"Поиск.", chat_find)
				if chat_find.v == "" then
					imgui.Text(u8'Начните вводить текст.\n')
				else
					for key, v in pairs(chat_logger_text) do
						if v:find(chat_find.v) ~= nil then
							imgui.Text(u8:encode(v))
						end
					end
				end
			else
				imgui.SetCursorPosX(imgui.GetWindowWidth()/2.3)
				imgui.SetCursorPosY(imgui.GetWindowHeight()/2.3)
				imgui.Spinner(20, 7)
			end
		imgui.End()
	end
	-- 1111
	if ah_help.v then
		imgui.LockPlayer = true
		imgui.SetNextWindowPos(imgui.ImVec2(200, 300), imgui.Cond.FirstUseEver, imgui.ImVec2(0, 0))
		imgui.SetNextWindowSize(imgui.ImVec2(500, -200), imgui.Cond.FirstUseEver)
		local btn_size = imgui.ImVec2(-0.1, 0)
		imgui.Begin(u8"Полезные функции.( В разработке )", ah_help)
	    imgui.Columns(3, 'ahhelp', true)
		-- Column 1
		imgui.Text(u8'Ссылки:')
		imgui.SameLine()
		imgui.TextQuestion(u8'Нажав на кнопку откроется браузер cо страницей ВКонтакте.')
		if imgui.Button(u8'Группа скрипта') then
		 os.execute('start https://vk.com/coding.lua_yamada')
		end
		if imgui.Button(u8'Создатель скрипта') then
		 os.execute('start https://vk.com/yamada.fear')
		end
		if imgui.Button(u8'Разработчик скрипта') then
		 os.execute('start https://vk.com/vrednaya_krevetka')
		end
		
		
		imgui.NextColumn()
		-- Column 2
		imgui.End()
		end
		
function imgui.TextQuestion(text)
	    imgui.TextDisabled('(?)')
	    if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.PushTextWrapPos(450)
		imgui.TextUnformatted(text)
		imgui.PopTextWrapPos()
		imgui.EndTooltip()
	end
end
		
		
		
	if i_admin_chat_setting.v then
		imgui.LockPlayer = true
		imgui.SetNextWindowPos(imgui.ImVec2(10, 10), imgui.Cond.FirstUseEver, imgui.ImVec2(0, 0))
		imgui.SetNextWindowSize(imgui.ImVec2(300, -0.1), imgui.Cond.FirstUseEver)
		local btn_size = imgui.ImVec2(-0.1, 0)
		imgui.Begin(u8"Настройки админ чата.", i_admin_chat_setting)
		if imgui.Button(u8'Положение чата.', btn_size) then
			ac_no_saved.X = admin_chat_lines.X; ac_no_saved.Y = admin_chat_lines.Y
			i_setting_items.v = false
			ac_no_saved.pos = true
		end
		imgui.Text(u8'Выравнивание чата.')
		imgui.Combo("##Position", admin_chat_lines.centered, {u8"По левый край.", u8"По центру.", u8"По правый край."})
		imgui.PushItemWidth(50)
		if imgui.InputText(u8"Размер чата.", font_size_ac) then
			font_ac = renderCreateFont("Arial", tonumber(font_size_ac.v) or 10, font_admin_chat.BOLD + font_admin_chat.SHADOW)
		end
		imgui.PopItemWidth()
		imgui.Text(u8'Положение ника и уровня.')
		imgui.Combo("##Pos", admin_chat_lines.nick, {u8"Справа.", u8"Слева."})
		imgui.Text(u8'Количество строк.')
		imgui.PushItemWidth(80)
		imgui.InputInt(' ', admin_chat_lines.lines)
		imgui.PopItemWidth()
		if imgui.Button(u8'Сохранить.', btn_size) then
			saveAdminChat()
		end
		imgui.End()
	end
end

function checkOrClose()
	if sampGetCurrentDialogId() == 0 and fans == 1 then
		lua_thread.create(function()
			wait(200)
		sampCloseCurrentDialogWithButton(13)
		sampAddChatMessage("{FF0000}[TakeRep]: {FFFFFF}На данный момент жалоб {FF0000}нету.", 0xFFFFFF)
	end)
	elseif sampGetCurrentDialogId() == 2348 and fans == 1 then
		lua_thread.create(function()
		sampSendDialogResponse (2348, 1, 0)
		wait(100)
		--if string.find(text, "[Ошибка]: {FFFFFF}Администратор уже проверяет данную жалобу", 0, false) then
		--sampCloseCurrentDialogWithButton(13)
		--sampAddChatMessage("{FF0000}[TakeRep]: {FFFFFF}Обнаружена {FF0000}жалоба, но администратор уже проверяет её. {FFFFFF}Скрипт закрыл репорт.", 0xFFFFFF)
		--return
		--end
	end)
		sampAddChatMessage("{FF0000}[TakeRep]: {FFFFFF}Обнаружена {FF0000}жалоба. {FFFFFF}Скрипт её взял.", 0xFFFFFF)
	elseif sampGetCurrentDialogId() == 2351 then
		lua_thread.create(function()
		--wait(100)
		sampSendDialogResponse(2351, 1, 0, ansToRep)
		wait(100)
		sampCloseCurrentDialogWithButton(13)
	end)
	end
end
