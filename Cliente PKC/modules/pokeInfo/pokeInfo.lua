--- Developed By OrochiElf (Tony Araújo) ~~ www.facebook.com/tony.araujjo ~~
PokeInfoWindow = nil

function init()
	PokeInfoWindow = g_ui.displayUI('pokeInfo.otui')
	PokeInfoWindow:setup()
	PokeInfoWindow:hide()

	connect(g_game, 'onTextMessage', serverComunication)
	connect(g_game, { onGameEnd = hide } )
end

function terminate()
	disconnect(g_game, { onGameEnd = hide })
	disconnect(g_game, 'onTextMessage', serverComunication)

	PokeInfoWindow:destroy()
end

function hide()
	PokeInfoWindow:hide()
end

function serverComunication(mode, text)
	if not g_game.isOnline() then
		return
	end

	if mode == MessageModes.Failure then
		local param = text:explode("@")

		if text:find("%PokeClose") then
			PokeInfoWindow:hide()
			return
		elseif text:find("%PokeHealth") then
			local param = text:explode("@")
			PokeInfoWindow:recursiveGetChildById("pokeHealth"):setText(math.ceil((100 / tonumber(param[3])) * tonumber(param[2])) .. "%")
			PokeInfoWindow:recursiveGetChildById("pokeHealth"):setValue((100 / tonumber(param[3])) * tonumber(param[2]))
			return
		elseif text:find("%PokeWindow") then
			local param = text:explode("@")

			local portrait = g_game.getLocalPlayer():getOutfit()
			portrait.type = tonumber(param[2])
			PokeInfoWindow:recursiveGetChildById("pokePortrait"):setOutfit(portrait)
			PokeInfoWindow:recursiveGetChildById("pokeName"):setText(param[3])
			PokeInfoWindow:recursiveGetChildById("pokeHealth"):setText(math.ceil((100 / tonumber(param[5])) * tonumber(param[4])) .. "%")
			PokeInfoWindow:recursiveGetChildById("pokeHealth"):setPercent((100 / tonumber(param[5])) * tonumber(param[4]))
			PokeInfoWindow:show()
			return
		end
	end
end

