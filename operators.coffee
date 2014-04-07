class Operators
	
	constructor: ->
		
		window._$_ = PaperScript._$_
		window.$_ = PaperScript.$_
		
		# First column: method name for numericjs
		# Second column: __name for operator overload function.
		@basicOps = [
			["add", "add"]
			["sub", "subtract"]
			["mul", "multiply"]
			["div", "divide"]
		]
		
		@ops = @basicOps.concat [
			["mod", "modulo"]
			["eq", "equals"]
			["lt", "lt"]
			["gt", "gt"]
			["leq", "leq"]
			["geq", "geq"]
		]
		
		@assignOps = ["addeq", "subeq", "muleq", "diveq", "modeq"]
		
		@arrayOverloads()
		@complexOverloads()
		
	arrayOverloads: ->
		
		A = Array.prototype
		nm = numeric
		
		# Size of 2D array
		A.size = -> [this.length, this[0].length]
		
		# Array method for numericjs function.
		setMethod = (op) ->
			# e.g., A.add = (y) -> nm.add(this, y) 
			A[op] = (y) -> nm[op](this, y)
		
		# Array method for unary numericjs operator or function.
		setUnaryMethod = (op) ->
			# e.g., A.neg = -> nm.neg(this)
			A[op] = -> nm[op](this)
		
		# Method when first operand is scalar.
		# Need +this to convert to primitive value.
		setMethodScalar = (op) ->
			# e.g., N.add = (y) -> nm.add(+this, y) 
			Number.prototype[op] = (y) -> nm[op](+this, y)
			
		# Overload operator.  Set to operator method. 
		overloadOperator = (proto, a, b) ->
			# e.g., A.__add = A.add
			proto["__"+b] = proto[a]
		
		# Regular operations.
		for op in @ops
			[a, b] = op
			setMethod a
			setMethodScalar a
			overloadOperator A, a, b
			overloadOperator Number.prototype, a, b
			
		# Assignment operations.
		# Don't need to overload assignment operators.  Inferred from binary ops.
		setMethod op for op in @assignOps
		
		# Dot product.  No operator overload for A.dot.
		setMethod "dot"
		
		# Negation (unary).
		setUnaryMethod "neg"
		overloadOperator A, "neg", "negate"
		
		# Methods for other functions.
		setUnaryMethod "clone"
		setUnaryMethod "sum"
		
		# Transposes
		A.transpose = ->
			nm.transpose this
		
		Object.defineProperty A, 'T', get: -> this.transpose()
		
	complexOverloads: ->
		
		proto = numeric.T.prototype
		
		proto.size = -> [this.x.length, this.x[0].length]
		
		# Scalar to complex.
		numeric.complex = (x, y=0) -> new numeric.T(x, y)
		
		# Redefine numeric.add (etc.) to check for scalar * numeric.T first.
		# Chain: 1+y (where y is a T) --> N._add --> N.add --> numeric.add (redefined below) --> y.add 1 (T method)
		numericOld = {}  # Store old numeric methods here.
		set = (op, op1) ->
			proto["__"+op1] = proto[op]  # Operator overload
			numericOld[op] = numeric[op]  # Current method
			numeric[op] = (x, y) ->  # New method
				if typeof x is "number" and y instanceof numeric.T
					numeric.complex(x)[op] y  # Convert scalar to complex
				else
					numericOld[op] x, y  # Otherwise, just previous method.
		set(op[0], op[1]) for op in @basicOps
		
		# Negation
		proto.__negate = proto.neg
		
		# Transposes
		Object.defineProperty proto, 'T', get: -> this.transpose()
		Object.defineProperty proto, 'H', get: -> this.transjugate()


window.Operators = Operators
