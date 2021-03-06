--- Druid checkbox component
-- @module druid.checkbox

--- Component events
-- @table Events
-- @tfield druid_event on_change_state On change state callback

--- Component fields
-- @table Fields
-- @tfield node node Visual node
-- @tfield[opt=node] node click_node Button trigger node
-- @tfield druid.button button Button component from click_node

local const = require("druid.const")
local Event = require("druid.event")
local component = require("druid.component")

local Checkbox = component.create("checkbox", { const.ON_LAYOUT_CHANGE })


local function on_click(self)
	self:set_state(not self.state)
end


--- Component style params.
-- You can override this component styles params in druid styles table
-- or create your own style
-- @table Style
-- @tfield function on_change_state (self, node, state)
function Checkbox:on_style_change(style)
	self.style = {}

	self.style.on_change_state = style.on_change_state or function(_, node, state)
		gui.set_enabled(node, state)
	end
end


--- Component init function
-- @function checkbox:init
-- @tparam node node Gui node
-- @tparam function callback Checkbox callback
-- @tparam[opt=node] node click node Trigger node, by default equals to node
function Checkbox:init(node, callback, click_node)
	self.druid = self:get_druid()
	self.node = self:get_node(node)
	self.click_node = self:get_node(click_node)

	self.button = self.druid:new_button(self.click_node or self.node, on_click)
	self:set_state(false, true)

	self.on_change_state = Event(callback)
end


function Checkbox:on_layout_change()
	self:set_state(self.state, true)
end


--- Set checkbox state
-- @function checkbox:set_state
-- @tparam bool state Checkbox state
-- @tparam bool is_silent Don't trigger on_change_state if true
function Checkbox:set_state(state, is_silent)
	self.state = state
	self.style.on_change_state(self, self.node, state)

	if not is_silent then
		self.on_change_state:trigger(self:get_context(), state)
	end
end


--- Return checkbox state
-- @function checkbox:get_state
-- @treturn bool Checkbox state
function Checkbox:get_state()
	return self.state
end


return Checkbox
