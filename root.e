note
	description	: "Tests for W13-3311-assign2"
	date: ""
	revision: ""

class
	ROOT
inherit
	ES_SUITE

create
	make

feature -- Initialization


	make
			-- Run application.
		do
			name := "This is our test suite"
			-- new tests
--			add_test (create{CURRENCY_TESTS}.make)
--			add_test (create{MAP_TESTS}.make)
--			add_test (create {WALLET_TEST}.make)
			add_test (create {TEST_ROOTS}.make)


			-- old stuff
--			add_test (create{FLOAT_TESTS}.make)
--			add_test (create{MONEY_TESTS}.make)
--			set_html_name ("W13-3311 assign2 test report.htm")
			show_errors
			show_browser
			run_espec
		end

end -- class ROOT

