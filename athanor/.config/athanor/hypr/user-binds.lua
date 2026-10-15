local M = {}

local mainMod = "SUPER"

function M.setup(hl, terminal, fileManager)
	-- Apps
	hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
	hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("firefox --new-window"))
	hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd("firefox --new-window youtube.com"))
	hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(terminal .. " -e btop"))
	-- hl.bind(mainMod .. " + N", function()
	-- 	local state_file = os.getenv("HOME") .. "/.config/hypr/.layout_toggle_state"
	-- 	local current = "dwindle"
	-- 	local f = io.open(state_file, "r")
	-- 	if f then
	-- 		current = f:read("*l") or "dwindle"
	-- 		f:close()
	-- 	end
	-- 	local new_layout = (current == "dwindle") and "scrolling" or "dwindle"
	-- 	local wf = io.open(state_file, "w")
	-- 	if wf then
	-- 		wf:write(new_layout)
	-- 		wf:close()
	-- 	end
	-- 	hl.dispatch(hl.dsp.exec_cmd("hyprctl eval 'hl.config({ general = { layout = \"" .. new_layout .. "\" } })'"))
	-- 	hl.dispatch(hl.dsp.exec_cmd("notify-send -t 2000 'Modo cambiado a " .. new_layout .. "'"))
	-- end)
	--
	-- Focus movement
	-- hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
	-- hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
	-- hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
	-- hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))
	--
	-- -- Window movement
	-- hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
	-- hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
	-- hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
	-- hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))

	-- Window resize
	hl.bind(mainMod .. " + ALT + left", hl.dsp.window.resize({ x = -40, y = 0, relative = true }))
	hl.bind(mainMod .. " + ALT + right", hl.dsp.window.resize({ x = 40, y = 0, relative = true }))
	hl.bind(mainMod .. " + ALT + up", hl.dsp.window.resize({ x = 0, y = -40, relative = true }))
	hl.bind(mainMod .. " + ALT + down", hl.dsp.window.resize({ x = 0, y = 40, relative = true }))
end

return M
