class Player extends Fz2D.Group
  Button = Fz2D.Input.Mouse.Button
  Key = Fz2D.Input.Keyboard.Key

  constructor: (w, h, sprites, world, push) ->
    super(0, 0, w, h)
    @world = world
    @push = push

    @random = new Fz2D.Random()

    @brick_template = new Brick(sprites.getTexture('brick_32'))

    @bridge = new Fz2D.Group(0, 0, w, h)
    @bricks = new Fz2D.Group(0, 0, w, h)

    count = 13
    wall_count = 18
    bridge_y = 2

    @bottom = 600

    xw = @brick_template.w * count
    xl = (w - xw) >> 1
    xr = xl + xw
    yb = @bottom - @brick_template.h

    wol = xl - (@brick_template.w * 4)
    wor = xr + (@brick_template.w * 3)
    @byo = yb - (@brick_template.h * bridge_y)

    # left and right walls
    for i in [0..wall_count-1]
      y = yb - i * @brick_template.h
      @world.add(@add(@brick_template.clone(wol, y)))
      @world.add(@add(@brick_template.clone(wor, y)))

    # middle foundation
    for i in [0..count-1]
      @world.add(@add(@brick_template.clone(xl + i * @brick_template.w, yb)))

    # middle bridge
    for i in [1..count + 6]
      @world.add(@bridge.add(@brick_template.clone(wol + i * @brick_template.w, @byo)))

    @add(@bridge)
    @add(@bricks)

    @total = count * (wall_count - 3)

    @dir = (@random.nextBool() * 2) - 1
    @brick = @world.add(@add(@brick_template.clone()))
    @brick.exists = false
      
    @gameover = 0
    @height_timer = 0

  reset: () ->
    super
    @hud.remaining.setText(@total.toString())

    @bridge.each((b) =>
      b.y = @byo
      @world.reset(b)
    )

    @bricks.each((b) =>
      b.exists = false
      @world.kill(b)
    )

    @spawn()

  spawn: () ->
    @dir = -@dir

    if @dir == 1
      @source = @bridge.first()
      @target = @bridge.last()
    else
      @source = @bridge.last()
      @target = @bridge.first()

    @brick.reset(@source.x, @source.y + @source.h)
    @world.reset(@brick)

  drop: () ->
    if @hud.remaining.is(0)
      return
    else
      @hud.remaining.dec()

    @push.play()
    @height_timer = 0

    x = @brick.x
    y = @brick.y

    @spawn()

    brick = @bricks.recycle()
    if brick
      brick.reset(x, y, 0.0)
      @world.reset(brick)
    else
      brick = @bricks.add(@brick_template.clone(x, y))
      brick.density = 15.0
      brick.onkill = =>
        @hud.placed.dec()
        @hud.fallen.inc()

      @world.add(brick)

    @hud.placed.inc()

  move: (dt) ->
    @brick.x += (((dt * 0.1) | 0) * @dir)

    if @dir == 1
      if @brick.x >= @target.x
        @brick.x = @target.x
        @target = @bridge.first()
        @dir = -@dir
    else if @dir == -1
      if @brick.x <= @target.x
        @brick.x = @target.x
        @target = @bridge.last()
        @dir = -@dir

    @world.reset(@brick)

  lift: () ->
    b = @bridge.first()
    return if b.y < b.h

    @bridge.each((b) =>
      b.y -= b.h
      @world.reset(b)
    )

    @brick.y -= b.h
    @world.reset(@brick)

  update: (timer, input) ->
    super

    @_calc_height()

    if @hud.remaining.is(0)
      @brick.exists = false

      if ++@gameover > 100
        @height_timer = 0
        @_calc_height()
        @gameover = 0
        @alive = false
        @hud.reset()
      
      return

    @move(timer.dt)

    if input.mouse.pressed[Button.RIGHT] or input.keys.pressed[Key.SPACE]
      @lift()
    else if input.mouse.pressed[Button.LEFT]
      @drop()

  _calc_height: () ->
    if ++@height_timer < 120
      return

    @height_timer = 0
      
    y = @bottom

    @bricks.each((b) ->
      y = Math.min(y, b.y)
    )

    y = Math.max(0, (Math.ceil((@bottom - y) / @brick.h) - 2))

    @hud.raised.setText(y)
