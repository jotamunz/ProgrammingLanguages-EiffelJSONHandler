note
	description: "Summary description for {FILE_MANAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FILE_MANAGER

create
	make

feature -- Initialization

	make

		do

		end

feature {NONE} -- Private

feature -- Public

	read_file_lines (string_path: STRING): ARRAYED_LIST [STRING]

		local
			file: PLAIN_TEXT_FILE
			path: PATH
			lines: ARRAYED_LIST [STRING]
			line: STRING

		do
			create path.make_from_string (string_path)
			create file.make_with_path (path)
			create lines.make (0)

			from
				file.open_read
			until
				file.exhausted
			loop
				file.read_line
				create line.make_from_string (file.last_string)
				lines.extend (line)
			end
			file.close
			result := lines
		end

	split_semicolon (line: STRING): ARRAYED_LIST [STRING]

		local
			line_splitted: ARRAYED_LIST [STRING]

		do
			create line_splitted.make_from_iterable (line.split (';'))
			result := line_splitted
		end

	split_semicolon_multiple (lines: ARRAYED_LIST [STRING]): ARRAYED_LIST [ARRAYED_LIST [STRING]]

		local
			lines_splitted: ARRAYED_LIST [ARRAYED_LIST [STRING]]

		do
			create lines_splitted.make (0)
			across lines as line
			loop
				lines_splitted.extend (split_semicolon(line.item))
			end
			result := lines_splitted
		end

	write_file (string_path: STRING; text: STRING)

		local
			file: PLAIN_TEXT_FILE
			path: PATH

		do
			create path.make_from_string (string_path)
			create file.make_with_path (path)
			file.open_write
			file.put_string (text)
			file.close
		end
		
end
