note
	description: "Summary description for {TEST_ROOTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_ROOTS

inherit
	ES_TEST

create
	make

feature

	make
		do
			add_boolean_case (agent t1)
			add_violation_case (agent t2)
		end

feature

	t1: BOOLEAN
		local
			f: ROOT_OF_NUMBERS
			x, y: NUMBER_INTERVAL [REAL_64]
			ls: LIST [NUMBER_INTERVAL [REAL_64]]
			fmt: FORMAT_DOUBLE
		do
			create fmt.make (10, 10)
			create f.make (2.0)
			y.set (0.0, 2.0)
			x := f.root (y, .1)
			io.put_string (x.out)
			io.new_line

			f.set_range_tolerance (.1)
			x := f.root (y, .0001)
			io.put_string (x.out)
			io.new_line

			f.set_range_tolerance (.01)
			x := f.root (y, .01)
			io.put_string (x.out)
			io.new_line

			f.set_range_tolerance (.01)
			y.set (-2, 2)
			x := f.root (y, .01)
			io.put_string (x.out)
			io.new_line

			y.set (-2, 5)
			ls := f.all_roots (y, .000000001)
			io.put_string ("begin  ")
			io.new_line
			across ls as it loop
				io.put_string ("  " + it.item.out)
				io.new_line
				io.put_string ("  " + it.item.repr + " (" + fmt.formatted (it.item.imprecision) + ") ")
				io.new_line
			end
			io.put_string ("end  ")
			io.new_line

			Result := True
		end

	t2
		local
			f: ROOT_OF_NUMBERS
			x, y: NUMBER_INTERVAL [REAL_64]
		do
			create f.make (2.0)
			y.set (2.0, 4.0)
			x := f.root (y, .1)
		end

end
