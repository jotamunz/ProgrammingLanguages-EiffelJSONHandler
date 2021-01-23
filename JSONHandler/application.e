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
			listener.load("Equipos", "Equipos.csv")
			listener.save ("Equipos", "Equipos2.txt", True)
		end

end
