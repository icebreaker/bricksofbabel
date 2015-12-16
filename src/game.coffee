class Game extends Fz2D.Game
  w: window.innerWidth
  h: window.innerHeight
  bg: '#D59C25'
  fg: '#5d2607'

  assets:
    sprites: 'sprites.atlas'
    sounds:
      city: 'city.ogg'
      push: 'push.ogg'
  
  plugins: [
    Fz2D.Plugins.GoogleAnalytics,
    Fz2D.Plugins.GitHub,
    Fz2D.Plugins.Stats,
    Fz2D.Plugins.Box2D
  ]

  github:
    username: 'icebreaker'
    repository: 'bricksofbabel'

  ga:
    id: 'UA-3042007-2'

  onload: (game) ->
    game.input.mouse.hide() if Fz2D.production?
    
    sounds = game.assets.sounds

    sounds.city.setVolume(70)
    sounds.city.play(true)

    sounds.push.setVolume(80)

    hud = new Hud(game.w, game.h, game.assets.sprites)
    player = new Player(game.w, game.h, game.assets.sprites, game.world, sounds.push)

    # BAD, BAD, BAD, BAD
    hud.player = player

    player.hud = hud
    player.alive = false

    game.scene.add(player)
    game.scene.add(hud)

Game.run()
