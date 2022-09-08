return function()
	describe("EchoMiddleware.lua", function()
		local EchoMiddleware = require(script.Parent)
		describe("EchoMiddleware.new()", function()
			it("should return a new EchoMiddleware instance", function()
				local newEchoMiddleware = EchoMiddleware.new()
				expect(newEchoMiddleware).to.be.a("table")
			end)
			it("should create a standalone middleware function", function()
				local newEchoMiddleware = EchoMiddleware.new()
				expect(newEchoMiddleware.middleware).to.be.ok()
			end)
		end)
		describe("_createDispatch", function()
			it("should return a dispatch function", function()
				local newEchoMiddleware = EchoMiddleware.new()
				local result = newEchoMiddleware:_createDispatch()
				expect(result).to.be.a("function")
			end)
		end)
		describe("middleware", function()
			it("should return a dispatch function", function()
				local newEchoMiddleware = EchoMiddleware.new()
				local result = newEchoMiddleware.middleware()
				expect(result).to.be.a("function")
			end)
			describe("dispatch", function()
				it("should fire the actionDispatched signal", function()
					local newEchoMiddleware = EchoMiddleware.new()
					local dispatch = newEchoMiddleware.middleware(function() end)
					local didFire = false
					local expectedAction = {
						type = "hi"
					}
					local function onFired(action)
						didFire = true
						expect(action).to.equal(expectedAction)
					end
					local connection = newEchoMiddleware.actionDispatched:connect(onFired)
					dispatch(expectedAction)
					expect(didFire).to.equal(true)
					connection:disconnect()
				end)
				it("should call the dispatch passed to middleware", function()
					local newEchoMiddleware = EchoMiddleware.new()
					local wasCalled = false
					local expectedAction = {
						type = "hi"
					}
					local function callback(action)
						expect(action).to.equal(expectedAction)
						wasCalled = true
					end
					local dispatch = newEchoMiddleware.middleware(callback)
					dispatch(expectedAction)
					expect(wasCalled).to.equal(true)
				end)
			end)
		end)
	end)
end