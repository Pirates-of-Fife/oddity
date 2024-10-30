extends Resource

class_name SimplexNoise

# Initial permutation table
static var source = [
	151, 160, 137, 91, 90, 15, 131, 13, 201, 95, 96, 53, 194, 233, 7, 225, 
	140, 36, 103, 30, 69, 142, 8, 99, 37, 240, 21, 10, 23, 190, 6, 148, 
	247, 120, 234, 75, 0, 26, 197, 62, 94, 252, 219, 203, 117, 35, 11, 32, 
	57, 177, 33, 88, 237, 149, 56, 87, 174, 20, 125, 136, 171, 168, 68, 175, 
	74, 165, 71, 134, 139, 48, 27, 166, 77, 146, 158, 231, 83, 111, 229, 122, 
	60, 211, 133, 230, 220, 105, 92, 41, 55, 46, 245, 40, 244, 102, 143, 54, 
	65, 25, 63, 161, 1, 216, 80, 73, 209, 76, 132, 187, 208, 89, 18, 169, 
	200, 196, 135, 130, 116, 188, 159, 86, 164, 100, 109, 198, 173, 186, 
	3, 64, 52, 217, 226, 250, 124, 123, 5, 202, 38, 147, 118, 126, 255, 82, 
	85, 212, 207, 206, 59, 227, 47, 16, 58, 17, 182, 189, 28, 42, 223, 183, 
	170, 213, 119, 248, 152, 2, 44, 154, 163, 70, 221, 153, 101, 155, 167, 
	43, 172, 9, 129, 22, 39, 253, 19, 98, 108, 110, 79, 113, 224, 232, 178, 
	185, 112, 104, 218, 246, 97, 228, 251, 34, 242, 193, 238, 210, 144, 12, 
	191, 179, 162, 241, 81, 51, 145, 235, 249, 14, 239, 107, 49, 192, 214, 
	31, 181, 199, 106, 157, 184, 84, 204, 176, 115, 121, 50, 45, 127, 4, 
	150, 254, 138, 236, 205, 93, 222, 114, 67, 29, 24, 72, 243, 141, 128, 
	195, 78, 66, 215, 61, 156, 180
]

const RANDOM_SIZE = 256
const SQRT3 = 1.7320508075688772935
const SQRT5 = 2.2360679774997896964

var _random = []
const F3 = 1.0 / 3.0
const G3 = 1.0 / 6.0

# Gradient vectors for 3D (pointing to mid points of all edges of a unit cube)
static var grad3 = [
	Vector3(1, 1, 0), Vector3(-1, 1, 0), Vector3(1, -1, 0),
	Vector3(-1, -1, 0), Vector3(1, 0, 1), Vector3(-1, 0, 1),
	Vector3(1, 0, -1), Vector3(-1, 0, -1), Vector3(0, 1, 1),
	Vector3(0, -1, 1), Vector3(0, 1, -1), Vector3(0, -1, -1)
]

func _init(seed: int = 0):
	_random = source.duplicate()  # Initialize the random array
	randomize()  # No parameters needed here

# Generates value, typically in range [-1, 1]
func evaluate(point: Vector3) -> float:
	var x = point.x
	var y = point.y
	var z = point.z
	var n0 = 0.0
	var n1 = 0.0
	var n2 = 0.0
	var n3 = 0.0

	# Skew the input space to determine which simplex cell we're in
	var s = (x + y + z) * F3
	var i = fast_floor(x + s)
	var j = fast_floor(y + s)
	var k = fast_floor(z + s)

	var t = (i + j + k) * G3

	# The x,y,z distances from the cell origin
	var x0 = x - (i - t)
	var y0 = y - (j - t)
	var z0 = z - (k - t)

	# Determine which simplex we are in.
	var i1 = 0
	var j1 = 0
	var k1 = 0
	var i2 = 0
	var j2 = 0
	var k2 = 0

	if (x0 >= y0):
		if (y0 >= z0):
			i1 = 1
			j1 = 0
			k1 = 0
			i2 = 1
			j2 = 1
			k2 = 0
		elif (x0 >= z0):
			i1 = 1
			j1 = 0
			k1 = 0
			i2 = 1
			j2 = 0
			k2 = 1
		else:
			i1 = 0
			j1 = 0
			k1 = 1
			i2 = 1
			j2 = 0
			k2 = 1
	else:
		if (y0 < z0):
			i1 = 0
			j1 = 0
			k1 = 1
			i2 = 0
			j2 = 1
			k2 = 1
		elif (x0 < z0):
			i1 = 0
			j1 = 1
			k1 = 0
			i2 = 0
			j2 = 1
			k2 = 1
		else:
			i1 = 0
			j1 = 1
			k1 = 0
			i2 = 1
			j2 = 1
			k2 = 0

	# Offsets for second corner in (x,y,z) coords
	var x1 = x0 - i1 + G3
	var y1 = y0 - j1 + G3
	var z1 = z0 - k1 + G3

	# Offsets for third corner in (x,y,z)
	var x2 = x0 - i2 + F3
	var y2 = y0 - j2 + F3
	var z2 = z0 - k2 + F3

	# Offsets for last corner in (x,y,z)
	var x3 = x0 - 0.5
	var y3 = y0 - 0.5
	var z3 = z0 - 0.5

	# Work out the hashed gradient indices of the four simplex corners
	var ii = i & 0xff
	var jj = j & 0xff
	var kk = k & 0xff

	# Calculate the contribution from the four corners
	var t0 = 0.6 - x0 * x0 - y0 * y0 - z0 * z0
	if (t0 > 0):
		t0 *= t0
		var gi0 = _random[ii + _random[jj + _random[kk]] % 12]
		n0 = t0 * t0 * dot(grad3[gi0], x0, y0, z0)

	var t1 = 0.6 - x1 * x1 - y1 * y1 - z1 * z1
	if (t1 > 0):
		t1 *= t1
		var gi1 = _random[ii + i1 + _random[jj + j1 + _random[kk + k1]] % 12]
		n1 = t1 * t1 * dot(grad3[gi1], x1, y1, z1)

	var t2 = 0.6 - x2 * x2 - y2 * y2 - z2 * z2
	if (t2 > 0):
		t2 *= t2
		var gi2 = _random[ii + i2 + _random[jj + j2 + _random[kk + k2]] % 12]
		n2 = t2 * t2 * dot(grad3[gi2], x2, y2, z2)

	var t3 = 0.6 - x3 * x3 - y3 * y3 - z3 * z3
	if (t3 > 0):
		t3 *= t3
		var gi3 = _random[ii + 1 + _random[jj + 1 + _random[kk + 1]] % 12]
		n3 = t3 * t3 * dot(grad3[gi3], x3, y3, z3)

	# Add contributions from each corner to get the final noise value
	return (n0 + n1 + n2 + n3) * 16.0

# Hash function to create pseudo-random values
func hash(value: int) -> int:
	value = (value << 13) ^ value
	return (value * (value * value * 15731 + 789221) + 1376312589) & 0x7fffffff

# Fast floor function
func fast_floor(value: float) -> int:
	var int_value = int(value)
	return int_value - (1 if value < int_value else 0)

# Dot product for Vector3
func dot(v: Vector3, x: float, y: float, z: float) -> float:
	return v.x * x + v.y * y + v.z * z
