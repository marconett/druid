local data = require("druid.data")
local settings = require("druid.settings")
local helper = require("druid.helper.helper")

local M = {}
M.interest = {
	data.TRANSLATABLE,
	data.LAYOUT_CHANGED
}


function M.init(instance, node, value, is_locale)
	instance.node = helper.get_node(node)
	instance.last_color = gui.get_color(instance.node)
	if is_locale then
		instance.text_id = value
		instance:translate()
	else
		instance:set_to(value or 0)
	end
	return instance
end


function M.translate(instance)
	if instance.text_id then
		instance:set_to(settings.get_text(instance.text_id))
	end
end


--- Set text to text field
-- @param set_to - set value to text field
function M.set_to(instance, set_to)
	instance.last_value = set_to
	gui.set_text(instance.node, set_to)
end


--- Set color
-- @param color
function M.set_color(instance, color)
	instance.last_color = color
	gui.set_color(instance.node, color)
end


--- Set alpha
-- @param alpha, number [0-1]
function M.set_alpha(instance, alpha)
	instance.last_color.w = alpha
	gui.set_color(instance.node, instance.last_color)
end


--- Set scale
-- @param scale
function M.set_scale(instance, scale)
	instance.last_scale = scale
	gui.set_scale(instance.node, scale)
end


--- Called when layout updated (rotate for example)
function M.on_layout_updated(instance)
	if instance.last_color then
		M.set_color(instance, instance.last_color)
	end
	if instance.last_scale then
		M.set_scale(instance, instance.last_scale)
	end
end


return M