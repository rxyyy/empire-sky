cos = math.cos
sin = math.sin
max = math.max
min = math.min
degToPi = math.pi / 180

function getPositionFromElementOffset(element, offx, offy, offz)
	local x, y, z = getElementPosition(element)
	local rx, ry, rz = getElementRotation(element)
	local rx, ry, rz = rx * degToPi, ry * degToPi, rz * degToPi
	local rxCos, ryCos, rzCos, rxSin, rySin, rzSin = cos(rx), cos(ry), cos(rz), sin(rx), sin(ry), sin(rz)
	m11, m12, m13, m21, m22, m23, m31, m32, m33 = rzCos * ryCos - rzSin * rxSin * rySin, ryCos * rzSin +
	rzCos * rxSin * rySin, -rxCos * rySin, -rxCos * rzSin, rzCos * rxCos, rxSin, rzCos * rySin + ryCos * rzSin * rxSin,
		rzSin * rySin - rzCos * ryCos * rxSin, rxCos * ryCos
	return offx * m11 + offy * m21 + offz * m31 + x, offx * m12 + offy * m22 + offz * m32 + y,
		offx * m13 + offy * m23 + offz * m33 + z
end
