note
	description: "Summary description for {ROOT_OF_NUMBERS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ROOT_OF_NUMBERS

inherit
	NUM_FUNCTION [REAL_64]

create
	make

feature

	make (v: REAL_64)
		do
			number := v
			range_tolerance := 0.0001
		end

	item (x: NUMBER_INTERVAL [REAL_64]): NUMBER_INTERVAL [REAL_64]
		local
			c: NUMBER_INTERVAL [REAL_64]
		do
			create c.make (number, number)
			Result := c - x * x
		end

	number: REAL_64

	range_imprecision: REAL_64 = 0.0

	as_int (v: REAL_64): INTEGER
		do
			Result := v.floor
		end

	log2 (v: REAL_64): REAL_64
		local
			m: DOUBLE_MATH
		do
			create m
			Result := m.log_2 (v)
		end

end
