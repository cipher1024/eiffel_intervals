note
	description: "Summary description for {NUM_FUNCTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	NUM_FUNCTION [G -> {NUMERIC, COMPARABLE rename default_create as foo end } create default_create end  ]

feature -- Access

	item (x: NUMBER_INTERVAL [G]): NUMBER_INTERVAL [G]
		deferred
		ensure
			x.imprecision = x.zero implies Result.imprecision <= range_imprecision
		end

	range_imprecision: G
		deferred
		end

feature -- Status report

	range_tolerance: G assign set_range_tolerance

feature -- Status setting

	set_range_tolerance (x: G)
		require
			range_imprecision < x
		do
			range_tolerance := x
		ensure
			range_tolerance = x
		end

feature -- Basic operation

	as_int (x: G): INTEGER
		deferred
		end

	log2 (x: G): G
		deferred
		end

	root (x: NUMBER_INTERVAL [G]; e: G): NUMBER_INTERVAL [G]
		require
			item (x).has (e.zero)
			e.zero < e
		local
			left, right: NUMBER_INTERVAL [G]
			v: INTEGER
			imp1, imp2: G
		do
			from
				Result := x
				v := as_int (log2 (Result.imprecision / e)).max (
					as_int (log2 (item (Result).imprecision / range_tolerance))) + 2
				right := item (Result)
				imp1 := Result.imprecision
				imp2 := right.imprecision
			invariant
				Result.included_in (x)
				item (Result).has (e.zero)
				as_int (log2 (Result.imprecision / e)) + 1 <= v
				as_int (log2 (item (Result).imprecision / range_tolerance)) + 1 <= v
			until
					Result.imprecision <= e
				and item (Result).imprecision <= range_tolerance
			loop
				left := Result.left_half
				right := item (left)
				if item (left).has (e.zero) then
					Result := left
				else
					Result := Result.right_half
				end
				v := v - 1
				right := item (Result)
				imp1 := Result.imprecision
				imp2 := right.imprecision
			variant
				v
			end
		ensure
			Result.included_in (x)
			Result.imprecision <= e
			item (Result).has (e.zero)
			item (Result).imprecision <= range_tolerance
		end

	all_roots (x: NUMBER_INTERVAL [G]; e: G): LIST [NUMBER_INTERVAL [G]]
		require
			item (x).has (e.zero)
			e.zero < e
		local
			left, right: NUMBER_INTERVAL [G]
			v: INTEGER
			imp1, imp2, p, two: G
			other, tmp: LIST [NUMBER_INTERVAL [G]]
			ls: ARRAYED_LIST [NUMBER_INTERVAL [G]]

		do
			from
				create ls.make (1)
				Result := ls
				create ls.make (1)
				other := ls

				p := x.imprecision
				two := p.one + p.one

				Result.extend (x)
				v := as_int (log2 (p / e)) + 1
			invariant
				across Result as y all y.item.included_in (x) end
				across Result as y all item (y.item).has (e.zero) end
				as_int (log2 (p / e)) + 1 <= v
				across Result as y all y.item.imprecision <= p end
				other.is_empty
			until
				p <= e
			loop
				across Result as y loop
					left := y.item.left_half
					right := y.item.right_half
					check item (left).has (e.zero) or item (right).has (e.zero) end
					if item (left).has (e.zero) then
						other.extend (left)
					end
					if item (right).has (e.zero) then
						other.extend (right)
					end
				end
				v := v - 1
				p := p / two
				tmp := Result
				Result := other
				other := tmp
				other.wipe_out
			variant
				v
			end
		ensure
			across Result as y all y.item.included_in (x) end
			across Result as y all item (y.item).has (e.zero) end
			across Result as y all y.item.imprecision <= e end
--			item (Result).imprecision <= range_tolerance
		end

invariant
	range_imprecision < range_tolerance

end
