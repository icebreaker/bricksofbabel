class Brick extends Fz2D.Entity
  constructor: (texture, x, y, @density=0.0) ->
    super(texture, x, y)
    
  onkill: () ->
    # empty

  clone: (x, y) ->
    new Brick(@texture, x || @x, y || @y, @density)

  kill: () ->
    super
    @onkill()
