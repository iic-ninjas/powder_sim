#= require jquery
#= require underscore
#= require_tree .

$(document).ready ->
  app = new Application(boardSize: 120, cellSize: 3, desiredFPS: 8)
  app.run()

class window.Application

  constructor: (@options) ->
    @board = new Board(size: @options.boardSize, cellType: GoLCell)
    @board.build()
    @renderer = new CanvasRenderer(@board, @options.cellSize)

  run: ->
    loops = 0
    skipTicks = 1000 / @options.desiredFPS
    maxFrameSkip = 10
    nextGameTick = new Date().getTime()

    loopFunction = (=>
      loops = 0
      while (new Date().getTime() > nextGameTick) and (loops < maxFrameSkip)
        @board.step()
        nextGameTick += skipTicks
        loops++

      @renderer.draw()

      window.requestAnimFrame(loopFunction, @renderer.canvas)
    )

    window.requestAnimFrame(loopFunction, @renderer.canvas)