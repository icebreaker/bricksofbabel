class Hud extends Fz2D.Group
  Button = Fz2D.Input.Mouse.Button

  constructor: (w, h, sprites) ->
    super(0, 0, w, h)

    font_32 = new Fz2D.Font(sprites.getTexture('font_32'), 32)
    font_16 = new Fz2D.Font(sprites.getTexture('font_16'), 16)

    text = "Bricks of Babel"
    size = font_32.measureText(text)

    @title = @add(new Fz2D.Gui.Label(text, (w - size.w) >> 1, 100, font_32))

    text = "LMB - drop / RMB - move up"
    size = font_16.measureText(text)
    @help = @add(new Fz2D.Gui.Label(text, (w - size.w) >> 1, 200, font_16))

    text = "Press LMB to play"
    size = font_16.measureText(text)
    @play = @add(new Fz2D.Gui.Label(text, (w - size.w) >> 1, 300, font_16))
    @play.blink = 500

    text = "Game Over"
    size = font_32.measureText(text)

    @gameover = @add(new Fz2D.Gui.Label(text, (w - size.w) >> 1, 200, font_32))
    @gameover.kill()

    y = @add(new Fz2D.Entity(sprites.getTexture('remaining'), 24, 24)).y
    @remaining = @add(new Fz2D.Gui.Label("0", 4 * 32, y + 16, font_32))
    @remaining.setFormat('03')

    y = @add(new Fz2D.Entity(sprites.getTexture('placed'), 24, 24 + 64 + 32)).y
    @placed = @add(new Fz2D.Gui.Label("0", 4 * 32, y + 16, font_32))
    @placed.setFormat('03')

    y = @add(new Fz2D.Entity(sprites.getTexture('fallen'), 24, 24 + 3 * 64)).y
    @fallen = @add(new Fz2D.Gui.Label("0", 4 * 32, y + 16, font_32))
    @fallen.setFormat('03')

    y = @add(new Fz2D.Entity(sprites.getTexture('raised'), 24, 24 + 4 * 64 + 32)).y
    @raised = @add(new Fz2D.Gui.Label("0", 4 * 32, y + 16, font_32))
    @raised.setFormat('03')

  kill: () ->
    @alive = false
    @title.kill()
    @help.kill()
    @play.kill()
    @gameover.kill()

    @remaining.setText('0')
    @placed.setText('0')
    @fallen.setText('0')
    @raised.setText('0')

    @player.reset()

  reset: () ->
    super
    @gameover.reset()
    @play.reset()

  update: (timer, input) ->
    super

    if input.mouse.pressed[Button.LEFT]
      @kill()
