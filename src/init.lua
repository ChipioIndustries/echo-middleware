local Signal = require(script.Parent.Signal)
local makeStandalone = require(script.Parent.makeStandalone)

local EchoMiddleware = {}
EchoMiddleware.__index = EchoMiddleware

function EchoMiddleware.new()
	local self = setmetatable({
		actionDispatched = Signal.new();
	}, EchoMiddleware)

	self.middleware = makeStandalone(self._createDispatch, self)

	return self
end

function EchoMiddleware:_createDispatch(nextDispatch, _store)
	local function dispatch(action)
		self.actionDispatched:fire(action)
		nextDispatch(action)
	end
	return dispatch
end

return EchoMiddleware