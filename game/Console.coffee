{Dictionary} = require './Dictionary'
{Grid} = require './Grid'
{Player} = require './Player'
{OWL2} = require './OWL2'

stdin = process.stdin
stdin.setEncoding 'utf8'

inputCallback = null
stdin.on 'data',(input) -> inputCallback input

grid = new Grid
dictionary = new Dictionary(OWL2, grid)
player = new Player('player 1', dictionary)


printGrid = ->
	#rows = for x in [0...GRID_SIZE]
	#	for y in [0...GRID_SIZE]
	#		grid[y][x]

	rowStrings = (' ' + row.join(' | ') for row in grid.rows())
	rowSeparator = ('-' for i in [1...grid.size*4]).join('')
	console.log '\n' + rowStrings.join("\n#{rowSeparator}\n") + '\n'
	

isInteger = (x) ->
	x is Math.round(x)

strToCoordinates = (input) ->
	halves = input.split(',')
	if halves.length is 2
		x = parseFloat halves[0]
		y = parseFloat halves[1]
		if !isInteger(x) or !isInteger(y)
			console.log "Each coordinate must be integer."
		else if not player.dictionary.grid.inRange x-1, y-1
			console.log "Each coordinate must between 1 to #{GRID_SIZE}."
		else
			{x, y}
	else
		console.log "input must be of the form `x,y`."


promptForTile1 = ->
	printGrid()
	console.log "please enter coordinates for the first tile."
	inputCallback = (input) ->
		try
			{x, y} = strToCoordinates input
		catch e
			console.log e
			return
			
		promptForTile2 x, y


promptForTile2 = (x1,y1)->
	console.log "please enter coordinates for the second tile."
	inputCallback = (input) ->
		try
			{x: x2, y: y2} = strToCoordinates input
		catch e
			console.log e
			return
		
		if x1 is x2 and y1 is y2
			console.log "The second tile must by different from the first."
		else
			console.log "Swapping (#{x1}, #{y1}) with (#{x2},#{y2}) ..."
			x1--;x2--;y1--;y2--;
			#grid.swap({x1,y1,x2,y2})
			#[grid.rows[x1][y1], grid[x2][y2]] = [grid[x2][y2],grid[x1][y1]]
			#score  = player.makeMove {x1,y1,x2,y2}
			{moveScore, newWords} = player.makeMove {x1,y1,x2,y2}
			unless moveScore is 0
				console.log """
					You formed the following word(s):
					#{newWords.join(', ')}
			
				"""
				#score += moveScore
			#moveCount++
			console.log "your score after #{player.moveCount}  moves: #{player.score}"
			promptForTile1()


console.log "welcome to 10x10"
promptForTile1()