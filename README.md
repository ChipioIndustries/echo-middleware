# EchoMiddleware

Provides a signal that broadcasts actions that are dispatched to the Rodux store.

## API

### middleware

The `middleware` function is passed to the Rodux store constructor. It should not be called by anything else.

### actionDispatched

The `actionDispatched` signal fires when an action is dispatched to any Rodux store the `middleware` is used in. Any connected functions will run before the store updates.

## Usage

Within a single script:

```lua
local Rodux = require(script.Parent.Rodux)
local reducer = require(script.Parent.Reducer)
local EchoMiddleware = require(script.Parent.EchoMiddleware)

local middleware = EchoMiddleware.new()

local function onActionDispatched(action)
	print(action.type)
end

middleware.actionDispatched:connect(middleware)

local store = Rodux.Store.new(reducer, {}, {
	middleware.middleware;
})
```

Split between modules:

### MyEchoMiddleware.lua

```lua
local EchoMiddleware = require(script.Parent.EchoMiddleware)
local MyEchoMiddleware = EchoMiddleware.new()
return MyEchoMiddleware
```

### StoreService.lua

```lua
local Rodux = require(script.Parent.Rodux)
local reducer = require(script.Parent.Reducer)
local MyEchoMiddleware = require(script.Parent.MyEchoMiddleware)

local store = Rodux.Store.new(reducer, {}, {
	MyEchoMiddleware.middleware;
})

return store
```

### SomeOtherScript.lua

```lua
local MyEchoMiddleware = require(script.Parent.MyEchoMiddleware)

local SomeOtherScript = {}

function SomeOtherScript.logAction(action)
	print(action.type)
end

MyEchoMiddleware.actionDispatched:connect(SomeOtherScript.logAction)

return SomeOtherScript
```