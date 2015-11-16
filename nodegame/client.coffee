$(document).ready ->
	$('#grid li').on 'click', tileClick
	socket = new io.Socket()
	socket.connect()
	socket.on 'connect', -> showMessage 'waitForConnection'
	socket.on 'message', handleMessage


handleMessage = (message) ->
	{type, content} = typeAndContent message
	switch type
		when 'welcome'
			{players, currPlayerNum, tiles, yourNum: myNum} = JSON.parse content
			startGame players, currPlayerNum
		when 'moveResult'
			{player, swapCoordinates, moveScore, newWords} = JSON.parse content
			showMoveResult  player, swapCoordinates, moveScore, newWords


startGame = (players, currPlayerNum)->
	for player in players
		$("#p#{player.num}name").html player.name
		$("#p#{player.num}score").html player.score

	drawTiles()
	if myNum is currPlayerNum
		startTurn()
	else
		endTurn()


showMoveResult = (player, swapCoordinates, moveScore, newWords) ->
	$("#p#{player.num}score").html player.score
	notice = $('<p class="notice"></p>')
	if moveScore is 0
		notice.html "#{player.name} formed no words this turn."
	else
		notice.html """
			#{player.name} formed the following #{newWords.length} word(s):<br />
			<b>#{newWords.join(', ')}</b><br />
			earning <b>#{moveScore / newWords.length} x #{newWords.length}
			= #{moveScore}</b> points!
		"""
	showThenFade notice
	swapTiles swapCoordinates
	if player.num is not myNum then startTurn()