note
	description: "Summary description for {ACTION_LISTENER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ACTION_LISTENER

create
	make

feature -- Initialization

	json_hash: HASH_TABLE [JSON_FILE, STRING]
	file_manager: FILE_MANAGER

	make

		do
			create json_hash.make(0)
			create File_manager.make
		end

feature {NONE} -- Private

feature -- Public

	load (name: STRING; path: STRING)

		local
			json: JSON_FILE
			file_lines: ARRAYED_LIST [STRING]
			header: ARRAYED_LIST [STRING]
			types: ARRAYED_LIST [STRING]
			body: ARRAYED_LIST [ARRAYED_LIST [STRING]]

		do
			if not json_hash.has (name) then
				create file_lines.make_from_iterable (file_manager.read_file_lines (path))
				create header.make_from_iterable (File_manager.split_semicolon (file_lines.at (1)))
				create types.make_from_iterable (File_manager.split_semicolon (file_lines.at (2)))
				file_lines.remove_i_th (1)
				file_lines.remove_i_th (1)
				create body.make_from_iterable (File_manager.split_semicolon_multiple (file_lines))
				create json.make_from_list (name, header, types, body)
				json_hash.put (json, name)
				json.print_all
			else
				Io.put_string ("This name already exists")
			end
		end

end
