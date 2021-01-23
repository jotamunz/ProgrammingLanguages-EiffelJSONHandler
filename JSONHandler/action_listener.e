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
				Io.put_string (json.to_string)
				Io.new_line
			else
				Io.put_string ("Specified name already exists")
			end
		end

	save (name: STRING; path: STRING; csv: BOOLEAN)

		local
			json: JSON_FILE

		do
			create json.make
			json := json_hash.at (name)
			if attached json then
				if csv then
					file_manager.write_file (path, json.to_csv_string)
				else
					file_manager.write_file (path, json.body_to_string)
				end
			else
				Io.put_string ("Specified name doesnt exist")
			end
		end

end
