# Test operator overloading - display results in browser (see test.html).
tests = ->
	
	nm = numeric
	
	name = "vector + scalar"
	x = [1, 2] + 2
	r = [3, 4]
	testResult name, same(x, r)
	
	name = "scalar + vector"
	x = 2 + [1, 2]
	r = [3, 4]
	testResult name, same(x, r)
	
	name = "vector + vector"
	x = [1, 2] + [3, 4]
	r = [4, 6]
	testResult name, same(x, r)
	
	name = "vector negation"
	v = [1, 2, 3]
	x = -v
	r = [-1, -2, -3]
	testResult name, same(x, r)
	
	name = "vector math"
	v1 = [1, 2, 3]
	v2 = [4, 6, 8]
	x = v2/2 - 2*v1 + 1
	r = [1, 0, -1]
	testResult name, same(x, r)
	
	name = "vector pointwise multiply"
	x = [1, 2, 3]
	y = [4, 5, 6]
	z = x*y
	r = [4, 10, 18]
	testResult name, same(z, r)
	
	name = "matrix math"
	A = [[1, 2, 3], [4, 5, 6]]
	B = 2*A - 1
	r = [[1, 3, 5], [7, 9, 11]]
	testResult name, same(B, r)
	
	name = "complex math"
	complex = nm.complex
	x = complex 1, 2
	j = complex 0, 1
	y = 1 + 2*j*x
	testResult name, (y.x is -3 and y.y is 2)
	
	name = "complex matrix math"
	A = complex [[1, 2], [3, 4]], [[5, 6], [7, 8]]
	B = A + j*A
	testResult name, (same(B.x, [[-4, -4], [-4, -4]]) and same(B.y, [[6, 8], [10, 12]]))

# numericjs functions.
all = numeric.all
same = numeric.same

# Show test result.
testResult = (name, pass) ->
	div = $ "#test_results"
	result = $ "<span>"
		text: if pass then "pass" else "fail"
		css: color: (if pass then "green" else "red")
	div.append(result).append(": #{name}").append("<br>")

# JavaScript post-processing with operator overloading.
new Operators
jsIn = "(#{tests})();"
jsOut = PaperScript.compile jsIn
eval jsOut
