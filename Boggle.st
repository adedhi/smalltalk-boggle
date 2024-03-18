'From Pharo10.0.0 of 15 March 2023 [Build information: Pharo-10.0.0+build.538.sha.179ef655ae2b150009a860b127aa3605366659ca (64 Bit)] on 19 February 2024 at 1:55:04.202 pm'!
Object subclass: #Boggle
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'CPS506'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Boggle class
	instanceVariableNames: ''!

!Boggle class methodsFor: 'as yet unclassified' stamp: 'AdeshvirDhillon 2/18/2024 18:01'!
search: board for: words
		
	| word_dict first_char dict_arr board_size board_full_size found_dict curr_char temp_dict_arr new_dict_arr search_result |
	
	board_size := (board size).
	board_full_size := board_size * board_size.
	word_dict := Dictionary new.
	words do:
		[:word |
			((word size) <= board_full_size)
				ifTrue:[
					first_char := (word at: 1).
					dict_arr := word_dict at: first_char ifAbsent: [dict_arr := OrderedCollection new].
					dict_arr addLast: word.
					word_dict at: first_char put: dict_arr.].].
	
	found_dict := Dictionary new.
	
	1 to: board_size do:[
		:i |
			1 to: board_size do:[
				:j |
					curr_char := ((board at: i) at: j).
					(word_dict includesKey: curr_char)
						ifTrue:[
							temp_dict_arr := word_dict at: curr_char.
							new_dict_arr := OrderedCollection new.
							temp_dict_arr do:[
								:word |
									search_result := (self find: (word copyFrom: 2 to: (word size)) in: board at: (i@j) visited: (OrderedCollection new)).
									(search_result isKindOf: OrderedCollection)
										ifTrue:[
											found_dict at: word put: (search_result asArray).]
										ifFalse:[
											new_dict_arr addLast: word.].].
							word_dict at: curr_char put: new_dict_arr.].].].
	
	^found_dict.
	

						
						
! !

!Boggle class methodsFor: 'as yet unclassified' stamp: 'AdeshvirDhillon 2/15/2024 15:30'!
find: word in: board at: point visited: visited_points 
			
	| i j board_size next_char next_word search_result |
	
	visited_points addLast: point. "visited_points is shared by all calls to this method, so if an invalid point is added and not removed, it will remain in visited_points"
	(word size == 0)
		ifTrue:
			[^visited_points].
	
	i := point x.
	j := point y.
	board_size := (board size).
	next_char := (word at: 1).
	next_word := (word copyFrom: 2 to: (word size)).
	
	(i > 1) "Top Left, Top, Top Right"
		ifTrue:[
			(j > 1 and: ((visited_points includes: (i-1)@(j-1)) not)) "Top Left"
				ifTrue:[
					(((board at: (i - 1)) at: (j - 1)) == next_char)
						ifTrue:[
							search_result := (self find: next_word in: board at: (i-1)@(j-1) visited: visited_points).
							(search_result isKindOf: OrderedCollection)
								ifTrue:[
									^search_result].].].
			((((board at: (i - 1)) at: j) == next_char) and: ((visited_points includes: (i-1)@j) not)) "Top"
				ifTrue:[
					search_result := (self find: next_word in: board at: (i-1)@j visited: visited_points).
					(search_result isKindOf: OrderedCollection)
						ifTrue:[
							^search_result].].
			((j < board_size) and: ((visited_points includes: (i-1)@(j+1)) not)) "Top Right"
				ifTrue:[
					(((board at: (i - 1)) at: (j + 1)) == next_char)
						ifTrue:[
							search_result := (self find: next_word in: board at: (i-1)@(j+1) visited: visited_points).
							(search_result isKindOf: OrderedCollection)
								ifTrue:[
									^search_result].].].].
				
	(i < board_size) "Bottom Left, Bottom, Bottom Right"
		ifTrue:[
			(j > 1 and: ((visited_points includes: (i+1)@(j-1)) not)) "Bottom Left"
				ifTrue:[
					(((board at: (i + 1)) at: (j - 1)) == next_char)
						ifTrue:[
							search_result := (self find: next_word in: board at: (i+1)@(j-1) visited: visited_points).
							(search_result isKindOf: OrderedCollection)
								ifTrue:[
									^search_result].].].
			(((board at: (i + 1)) at: j) == next_char and: ((visited_points includes: (i+1)@j) not)) "Bottom"
				ifTrue:[
					search_result := (self find: next_word in: board at: (i+1)@j visited: visited_points).
					(search_result isKindOf: OrderedCollection)
						ifTrue:[
							^search_result].].
			(j < board_size and: ((visited_points includes: (i+1)@(j+1)) not)) "Bottom Right"
				ifTrue:[
					(((board at: (i + 1)) at: (j + 1)) == next_char)
						ifTrue:[
							search_result := (self find: next_word in: board at: (i+1)@(j+1) visited: visited_points).
							(search_result isKindOf: OrderedCollection)
								ifTrue:[
									^search_result].].].].
	(j > 1) "Left"
		ifTrue:[
			(((board at: i) at: (j - 1)) == next_char  and: ((visited_points includes: i@(j-1)) not))
				ifTrue:[
					search_result := (self find: next_word in: board at: i@(j-1) visited: visited_points).
					(search_result isKindOf: OrderedCollection)
						ifTrue:[
							^search_result].].].
	
	(j < board_size) "Right"
		ifTrue:[
			(((board at: i) at: (j + 1)) == next_char  and: ((visited_points includes: i@(j+1)) not))
				ifTrue:[
					search_result := (self find: next_word in: board at: i@(j+1) visited: visited_points).
					(search_result isKindOf: OrderedCollection)
						ifTrue:[
							^search_result].].].
	
	visited_points = visited_points removeLast.
	^false.
! !
