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
	list: ARRAYED_LIST [STRING]

	make
			-- Run application.
		do
			create listener.make
			listener.load("Equipos", "Equipos.csv")
			create list.make_from_iterable(<<"equipo", "marca">>)
			listener.json_from_columns ("Equipos", "Equipos2", list)
			--listener.json_from_matching("Equipos", "Equipos2", "alojamiento", "%"" + "Edificio A1" + "%"")
		end

end
