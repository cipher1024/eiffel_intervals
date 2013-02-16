note
	description: "Summary description for {NUMBER_INTERVAL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

expanded class
	NUMBER_INTERVAL [G -> {NUMERIC, COMPARABLE rename default_create as foo, out as bar end } create default_create end  ]

inherit
	PART_COMPARABLE
		redefine
			default_create,
			out
		end

	NUMERIC
		undefine
			default_create,
			out
		end

create
	default_create,
	make

feature {NONE} -- Initialization

	default_create
		local
			x: G
		do
			create x
			make (x.zero, x.zero)
		end

	make (a_first, a_last: G)
		require
			a_first <= a_last
		do
			first := a_first
			last := a_last
		end

feature -- Access

	first, last: G

	middle: G
		local
			two: G
		do
			create two
			two := two.one + two.one
			Result := (first + last) / two
		end

feature -- Comparison

	is_less alias "<" (other: NUMBER_INTERVAL [G]): BOOLEAN
		do
			Result := last <= other.first
		end

	has (x: G): BOOLEAN
		do
			Result := first <= x and x <= last
		end

	included_in (other: NUMBER_INTERVAL [G]): BOOLEAN
		do
			Result := other.first <= first and last <= other.last
		end

	intersects (other: NUMBER_INTERVAL [G]): BOOLEAN
		do
			Result := first.max (other.first) <= last.min (other.last)
		end

feature -- Basic operation

	new_interval (a_first, a_last: G): NUMBER_INTERVAL [G]
		require
			a_first <= a_last
		do
			create Result.make (a_first, a_last)
		end

	maximum (a: ARRAY [G]): G
		require
			not a.empty
		local
			i: INTEGER
		do
			from
				i := a.lower
				Result := a [i]
			invariant
				Result = maximum (a.subarray (a.lower, i))
			until
				i = a.upper
			loop
				i := i + 1
				Result := Result.max (a [i])
			end
		end

	minimum (a: ARRAY [G]): G
		require
			not a.empty
		local
			i: INTEGER
		do
			from
				i := a.lower
				Result := a [i]
			invariant
				Result = minimum (a.subarray (a.lower, i))
			until
				i = a.upper
			loop
				i := i + 1
				Result := Result.min (a [i])
			end
		end

	product alias "*" (other: NUMBER_INTERVAL [G]): NUMBER_INTERVAL [G]
		local
			a,b,c,d: G
			ar: ARRAY [G]
		do
			a := first ; b := last
			c := other.first ; d := other.last
			ar := << a*c, a*d, b*c, b*d >>
			Result := new_interval (minimum (ar), maximum (ar))
		end

	plus alias "+" (other: NUMBER_INTERVAL [G]): NUMBER_INTERVAL [G]
		local
			a,b,c,d: G
		do
			a := first ; b := last
			c := other.first ; d := other.last
			Result := new_interval (a+c, b+d)
		end

	minus alias "-" (other: NUMBER_INTERVAL [G]): NUMBER_INTERVAL [G]
		local
			a,b,c,d: G
		do
			a := first ; b := last
			c := other.first ; d := other.last
			Result := new_interval (a-d, b-c)
		end

	quotient alias "/" (other: NUMBER_INTERVAL [G]): NUMBER_INTERVAL [G]
		local
			a,b,c,d: G
			ar: ARRAY [G]
		do
			a := first ; b := last
			c := other.first ; d := other.last
			ar := << a/c, a/d, b/c, b/d >>
			Result := new_interval (minimum (ar), maximum (ar))
		end

	divisible (other: NUMBER_INTERVAL [G]): BOOLEAN
		local
			x: G
		do
			create x
			Result := x.zero < first or last < x.zero
		end

	opposite alias "-": NUMBER_INTERVAL [G]
		do
			Result := new_interval (-last, -first)
		end

	identity alias "+": NUMBER_INTERVAL [G]
		do
			Result := Current
		end

	one: NUMBER_INTERVAL [G]
		local
			x: G
		do
			create x
			Result := new_interval (x.one, x.one)
		end

	zero: NUMBER_INTERVAL [G]
		do
		end

	exponentiable (other: NUMERIC): BOOLEAN
		do
			Result := False
		end

	left_half: NUMBER_INTERVAL [G]
		do
			create Result.make (first, middle)
		end

	right_half: NUMBER_INTERVAL [G]
		do
			create Result.make (middle, last)
		end

	imprecision: G
		do
			Result := last - first
		end

feature -- Element change

	set (a_first, a_last: G)
		require
			a_first <= a_last
		do
			make (a_first, a_last)
		end

feature -- Output

	out: STRING
		do
			Result := "[ " + first.out + ",  " + last.out + " ]"
		end

invariant
	first <= last
end
