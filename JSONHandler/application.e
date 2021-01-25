note
	description: "JSONHandler application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS_32

create
	make

feature {NONE} -- Initialization

	listener: ACTION_LISTENER

	make
			-- Run application.
		do
			create listener.make
			listener.run
		end

end
