# This file is part of libnoise-dotnet.
# libnoise-dotnet is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# libnoise-dotnet is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Lesser General Public License for more details.

# You should have received a copy of the GNU Lesser General Public License
# along with libnoise-dotnet. If not, see <http://www.gnu.org/licenses/>.

# Simplex Noise in 2D, 3D, and 4D. Based on the example code of this paper:
# http://staffwww.itn.liu.se/~stegu/simplexnoise/simplexnoise.pdf

# From Stefan Gustavson, Linkping University, Sweden (stegu at itn dot liu dot se)
# From Karsten Schmidt (slight optimizations & restructuring)

# Some changes by Sebastian Lague for use in a tutorial series.

# * Noise module that outputs 3-dimensional Simplex Perlin noise.
# * This algorithm has a computational cost of O(n+1) where n is the dimension.
# * This noise module outputs values that usually range from
# * -1.0 to +1.0, but there are no guarantees that all output values will exist within that range.

extends Resource

class_name MyNoise

# Initial permutation table
const SOURCE = [
	151, 160, 137, 91, 90, 15, 131, 13, 201, 95, 96, 53, 194, 233, 7, 225, 140, 36, 103, 30, 69, 142,
	8, 99, 37, 240, 21, 10, 23, 190, 6, 148, 247, 120, 234, 75, 0, 26, 197, 62, 94, 252, 219, 203,
	117, 35, 11, 32, 57, 177, 33, 88, 237, 149, 56, 87, 174, 20, 125, 136, 171, 168, 68, 175, 74, 165,
	71, 134, 139, 48, 27, 166, 77, 146, 158, 231, 83, 111, 229, 122, 60, 211, 133, 230, 220, 105, 92, 41,
	55, 46, 245, 40, 244, 102, 143, 54, 65, 25, 63, 161, 1, 216, 80, 73, 209, 76, 132, 187, 208, 89,
	18, 169, 200, 196, 135, 130, 116, 188, 159, 86, 164, 100, 109, 198, 173, 186, 3, 64, 52, 217, 226, 250,
	124, 123, 5, 202, 38, 147, 118, 126, 255, 82, 85, 212, 207, 206, 59, 227, 47, 16, 58, 17, 182, 189,
	28, 42, 223, 183, 170, 213, 119, 248, 152, 2, 44, 154, 163, 70, 221, 153, 101, 155, 167, 43, 172, 9,
	129, 22, 39, 253, 19, 98, 108, 110, 79, 113, 224, 232, 178, 185, 112, 104, 218, 246, 97, 228, 251, 34,
	242, 193, 238, 210, 144, 12, 191, 179, 162, 241, 81, 51, 145, 235, 249, 14, 239, 107, 49, 192, 214, 31,
	181, 199, 106, 157, 184, 84, 204, 176, 115, 121, 50, 45, 127, 4, 150, 254, 138, 236, 205, 93, 222, 114,
	67, 29, 24, 72, 243, 141, 128, 195, 78, 66, 215, 61, 156, 180
]

const RANDOM_SIZE = 256
const SQRT3 = 1.7320508075688772935
const SQRT5 = 2.2360679774997896964
var _random = []

# Skewing and unskewing factors for 2D, 3D, and 4D, some pre-multiplied.
const F2 = 0.5 * (SQRT3 - 1.0)
const G2 = (3.0 - SQRT3) / 6.0
const G22 = G2 * 2.0 - 1.0

const F3 = 1.0 / 3.0
const G3 = 1.0 / 6.0

const F4 = (SQRT5 - 1.0) / 4.0
const G4 = (5.0 - SQRT5) / 20.0
const G42 = G4 * 2.0
const G43 = G4 * 3.0
const G44 = G4 * 4.0 - 1.0

const GRAD3 = [
	[1, 1, 0], [-1, 1, 0], [1, -1, 0],
	[-1, -1, 0], [1, 0, 1], [-1, 0, 1],
	[1, 0, -1], [-1, 0, -1], [0, 1, 1],
	[0, -1, 1], [0, 1, -1], [0, -1, -1]
]

# Constructor for Noise class
func _init(seed=0):
	randomiz(seed)

# Method to randomize based on a seed
func randomiz(seed: int):
	_random.clear()

	if seed != 0:
		# Shuffle the array using the given seed
		# Unpack the seed into 4 bytes then perform a bitwise XOR operation
		# with each byte
		var f = unpack_little_uint32(seed)

		for i in range(SOURCE.size()):
			_random.append(SOURCE[i] ^ f[0])
			_random[i] ^= f[1]
			_random[i] ^= f[2]
			_random[i] ^= f[3]
			_random.append(_random[i])  # _random[i + RANDOM_SIZE] = _random[i] in C#

	else:
		for i in range(RANDOM_SIZE):
			_random.append(SOURCE[i])
			_random.append(_random[i])  # _random[i + RANDOM_SIZE] = _random[i] in C#

# Evaluate function for noise generation
func evaluate(point: Vector3) -> float:
	var x = point.x
	var y = point.y
	var z = point.z
	var n0 = 0.0
	var n1 = 0.0
	var n2 = 0.0
	var n3 = 0.0
	var i1 = 0
	var j1 = 0
	var k1 = 0
	var i2 = 0
	var j2 = 0
	var k2 = 0
	
	# Skew the input space to determine which simplex cell we're in
	var s = (x + y + z) * F3

	# For 3D
	var i = fast_floor(x + s)
	var j = fast_floor(y + s)
	var k = fast_floor(z + s)

	var t = (i + j + k) * G3

	# The x, y, z distances from the cell origin
	var x0 = x - (i - t)
	var y0 = y - (j - t)
	var z0 = z - (k - t)

	# Offsets for second corner of simplex in (i, j, k)
	#var i1, j1, k1
	# Logic for calculating i1, j1, k1 goes here

	if x0 >= y0:
		if y0 >= z0:
			# X Y Z order
			i1 = 1
			j1 = 0
			k1 = 0
			i2 = 1
			j2 = 1
			k2 = 0
		elif x0 >= z0:
			# X Z Y order
			i1 = 1
			j1 = 0
			k1 = 0
			i2 = 1
			j2 = 0
			k2 = 1
		else:
			# Z X Y order
			i1 = 0
			j1 = 0
			k1 = 1
			i2 = 1
			j2 = 0
			k2 = 1
	else:
		if y0 < z0:
			# Z Y X order
			i1 = 0
			j1 = 1
			k1 = 0
			i2 = 0
			j2 = 1
			k2 = 1
		elif x0 < z0:
			# Y Z X order
			i1 = 0
			j1 = 1
			k1 = 0
			i2 = 1
			j2 = 1
			k2 = 0
		else:
			# Y X Z order
			i1 = 0
			j1 = 0
			k1 = 1
			i2 = 0
			j2 = 1
			k2 = 1

	# A step for corner selection
	var x1 = x0 - i1 + G3
	var y1 = y0 - j1 + G3
	var z1 = z0 - k1 + G3
	var x2 = x0 - i2 + G3 * 2.0
	var y2 = y0 - j2 + G3 * 2.0
	var z2 = z0 - k2 + G3 * 2.0

	# Hash coordinates of the three simplex corners
	var ii = i & 255
	var jj = j & 255
	var kk = k & 255

	var gi0 = _random[ii + _random[jj + _random[kk]]] % 12
	var gi1 = _random[ii + i1 + _random[jj + j1 + _random[kk + k1]]] % 12
	var gi2 = _random[ii + i2 + _random[jj + j2 + _random[kk + k2]]] % 12

	# Contribution from the three corners
	var t0 = 0.5 - x0 * x0 - y0 * y0 - z0 * z0
	if t0 < 0.0:
		n0 = 0.0
	else:
		t0 *= t0
		n0 = t0 * t0 * grad(gi0, x0, y0, z0)  # (dot(GRAD3[gi0], x0, y0, z0))

	var t1 = 0.5 - x1 * x1 - y1 * y1 - z1 * z1
	if t1 < 0.0:
		n1 = 0.0
	else:
		t1 *= t1
		n1 = t1 * t1 * grad(gi1, x1, y1, z1)  # (dot(GRAD3[gi1], x1, y1, z1))

	var t2 = 0.5 - x2 * x2 - y2 * y2 - z2 * z2
	if t2 < 0.0:
		n2 = 0.0
	else:
		t2 *= t2
		n2 = t2 * t2 * grad(gi2, x2, y2, z2)  # (dot(GRAD3[gi2], x2, y2, z2))

	# Returning the sum of the contributions
	return 32.0 * (n0 + n1 + n2)

# Gradient calculation
func grad(hash: int, x: float, y: float, z: float) -> float:
	var h = hash & 15  # Convert low 4 bits of hash code
	
	var u: float
	if h < 8:
		u = x
	else:
		u = y

	var v: float
	if h < 4:
		v = y
	elif h == 12 or h == 14:
		v = x
	else:
		v = 0.0
	
	var result = 0.0
	if (h & 1) == 0:
		result += u
	else:
		result -= u
	
	if (h & 2) == 0:
		result += v
	else:
		result -= v

	return result

# Fast floor function
func fast_floor(x: float) -> int:
	var xi = int(x)
	if xi > x:
		return xi - 1
	else:
		return xi


# Unpack function for seed manipulation
func unpack_little_uint32(value: int) -> Array:
	return [
		(value & 0xFF),
		(value >> 8) & 0xFF,
		(value >> 16) & 0xFF,
		(value >> 24) & 0xFF
	]
