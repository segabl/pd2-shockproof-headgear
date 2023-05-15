if not ShockproofHeadgear then
	ShockproofHeadgear = {}
	ShockproofHeadgear.save_path = SavePath .. "shockproof_headgear.json"
	ShockproofHeadgear.settings = io.file_is_readable(ShockproofHeadgear.save_path) and io.load_as_json(ShockproofHeadgear.save_path) or {
		tase = true,
		explosion = false,
		bullet = false
	}
end

if RequiredScript == "lib/managers/menumanager" then

	Hooks:Add("MenuManagerBuildCustomMenus", "MenuManagerBuildCustomMenusShockproofHeadgear", function(_, nodes)

		local menu_id = "shockproof_headgear_menu"
		MenuHelper:NewMenu(menu_id)

		MenuCallbackHandler.ShockproofHeadgear_toggle = function(self, item)
			ShockproofHeadgear.settings[item:name()] = (item:value() == "on")
		end

		MenuCallbackHandler.ShockproofHeadgear_save = function()
			io.save_as_json(ShockproofHeadgear.settings, ShockproofHeadgear.save_path)
		end

		MenuHelper:AddToggle({
			id = "tase",
			title = "ShockproofHeadgear_menu_tase",
			desc = "ShockproofHeadgear_menu_tase_desc",
			callback = "ShockproofHeadgear_toggle",
			value = ShockproofHeadgear.settings.tase,
			menu_id = menu_id,
			priority = 10
		})

		MenuHelper:AddToggle({
			id = "explosion",
			title = "ShockproofHeadgear_menu_explosion",
			desc = "ShockproofHeadgear_menu_explosion_desc",
			callback = "ShockproofHeadgear_toggle",
			value = ShockproofHeadgear.settings.explosion,
			menu_id = menu_id,
			priority = 9
		})

		MenuHelper:AddToggle({
			id = "bullet",
			title = "ShockproofHeadgear_menu_bullet",
			desc = "ShockproofHeadgear_menu_bullet_desc",
			callback = "ShockproofHeadgear_toggle",
			value = ShockproofHeadgear.settings.bullet,
			menu_id = menu_id,
			priority = 8
		})

		nodes[menu_id] = MenuHelper:BuildMenu(menu_id, { back_callback = "ShockproofHeadgear_save" })
		MenuHelper:AddMenuItem(nodes["blt_options"], menu_id, "ShockproofHeadgear_menu_main", "ShockproofHeadgear_menu_main_desc")

		managers.localization:add_localized_strings({
			ShockproofHeadgear_menu_main = "Shockproof Headgear",
			ShockproofHeadgear_menu_main_desc = "Stop enemies from losing their headgear",
			ShockproofHeadgear_menu_tase = "Tase",
			ShockproofHeadgear_menu_tase_desc = "Keep headgear on tase damage",
			ShockproofHeadgear_menu_explosion = "Explosion",
			ShockproofHeadgear_menu_explosion_desc = "Keep headgear on explosion damage",
			ShockproofHeadgear_menu_bullet = "Bullet",
			ShockproofHeadgear_menu_bullet_desc = "Keep headgear on bullet damage"
		})

	end)

elseif RequiredScript == "lib/units/enemies/cop/copdamage" then

	for damage_type, _ in pairs(ShockproofHeadgear.settings) do
		if CopDamage["damage_" .. damage_type] then
			local orig = CopDamage["damage_" .. damage_type]
			CopDamage["damage_" .. damage_type] = function (self, ...)
				if not ShockproofHeadgear.settings[damage_type] then
					return orig(self, ...)
				end

				local _head_gear = self._head_gear
				self._head_gear = nil
				local result = orig(self, ...)
				self._head_gear = _head_gear

				return result
			end
		end

		if CopDamage["sync_damage_" .. damage_type] then
			local orig = CopDamage["sync_damage_" .. damage_type]
			CopDamage["sync_damage_" .. damage_type] = function (self, ...)
				if not ShockproofHeadgear.settings[damage_type] then
					return orig(self, ...)
				end

				local _head_gear = self._head_gear
				self._head_gear = nil
				local result = orig(self, ...)
				self._head_gear = _head_gear

				return result
			end
		end
	end

end
