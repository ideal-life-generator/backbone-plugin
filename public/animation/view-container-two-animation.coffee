define [

], (

) ->

  speed = 5

  first: (view) ->
    view.animationParams.opacity = 0
    view.animationParams.scaleX = 0.9
    view.animationParams.scaleY = 0.9

    animate = new TimelineMax
      paused: on
      onUpdate: ->
        view.$el.css
          opacity: view.animationParams.opacity
          transform: "scale(#{view.animationParams.scaleX}, #{view.animationParams.scaleY})"

    animate.to view.animationParams, 1 / speed,
      opacity: 1
      scaleX: 1
      scaleY: 1

    animate.play()

  last: (view) ->
    view.animationParams.opacity = 1
    view.animationParams.scaleX = 1
    view.animationParams.scaleY = 1

    animate = new TimelineMax
      paused: on
      onUpdate: ->
        view.$el.css
          opacity: view.animationParams.opacity
          transform: "scale(#{view.animationParams.scaleX}, #{view.animationParams.scaleY})"

    animate.to view.animationParams, 1 / speed,
      opacity: 0
      scaleX: 0.9
      scaleY: 0.9

    animate.play()

  centerTop: (view, done) ->
    view.animationParams.opacity = 1
    view.animationParams.translateY = 0
    view.animationParams.rotateX = 0

    animate = new TimelineMax
      paused: on
      onUpdate: ->
        view.$el.css
          opacity: view.animationParams.opacity
          transform: "translateY(#{view.animationParams.translateY}%) rotateX(#{view.animationParams.rotateX}deg)"
      onComplete: -> done()

    animate.to view.animationParams, 1.6 / speed,
      ease: Sine.easeOut
      opacity: 0
      translateY: -100
      rotateX: 90

    animate.play()

  topCenter: (view) ->
    view.animationParams.opacity = 0
    view.animationParams.translateY = -100
    view.animationParams.rotateX = 90

    animate = new TimelineMax
      paused: on
      onUpdate: ->
        view.$el.css
          opacity: view.animationParams.opacity
          transform: "translateY(#{view.animationParams.translateY}%) rotateX(#{view.animationParams.rotateX}deg)"

    animate.to view.animationParams, 1.6 / speed,
      ease: Sine.easeOut
      opacity: 1
      translateY: 0
      rotateX: 0

    animate.play()

  centerBottom: (view, done) ->
    view.animationParams.opacity = 1
    view.animationParams.translateY = 0
    view.animationParams.rotateX = 0

    animate = new TimelineMax
      paused: on
      onUpdate: ->
        view.$el.css
          opacity: view.animationParams.opacity
          transform: "translateY(#{view.animationParams.translateY}%) rotateX(#{view.animationParams.rotateX}deg)"
      onComplete: -> done()

    animate.to view.animationParams, 1.6 / speed,
      ease: Sine.easeOut
      opacity: 0
      translateY: 100
      rotateX: -90

    animate.play()

  bottomCenter: (view) ->
    view.animationParams.opacity = 0
    view.animationParams.translateY = 100
    view.animationParams.rotateX = -90

    animate = new TimelineMax
      paused: on
      onUpdate: ->
        view.$el.css
          opacity: view.animationParams.opacity
          transform: "translateY(#{view.animationParams.translateY}%) rotateX(#{view.animationParams.rotateX}deg)"

    animate.to view.animationParams, 1.6 / speed,
      ease: Sine.easeOut
      opacity: 1
      translateY: 0
      rotateX: 0

    animate.play()

  centerLeft: (view, done) ->
    view.animationParams.opacity = 1
    view.animationParams.translateX = 0
    view.animationParams.rotateY = 0

    animate = new TimelineMax
      paused: on
      onUpdate: ->
        view.$el.css
          opacity: view.animationParams.opacity
          transform: "translateX(#{view.animationParams.translateX}%) rotateY(#{view.animationParams.rotateY}deg)"
      onComplete: -> done()

    animate.to view.animationParams, 1.6 / speed,
      ease: Sine.easeOut
      opacity: 0
      translateX: -100
      rotateY: -90

    animate.play()

  leftCenter: (view, done) ->
    view.animationParams.opacity = 0
    view.animationParams.translateX = -100
    view.animationParams.rotateY = -90

    animate = new TimelineMax
      paused: on
      onUpdate: ->
        view.$el.css
          opacity: view.animationParams.opacity
          transform: "translateX(#{view.animationParams.translateX}%) rotateY(#{view.animationParams.rotateY}deg)"

    animate.to view.animationParams, 1.6 / speed,
      ease: Sine.easeOut
      opacity: 1
      translateX: 0
      rotateY: 0

    animate.play()

  centerRight: (view, done) ->
    view.animationParams.opacity = 1
    view.animationParams.translateX = 0
    view.animationParams.rotateY = 0

    animate = new TimelineMax
      paused: on
      onUpdate: ->
        view.$el.css
          opacity: view.animationParams.opacity
          transform: "translateX(#{view.animationParams.translateX}%) rotateY(#{view.animationParams.rotateY}deg)"
      onComplete: -> done()

    animate.to view.animationParams, 1.6 / speed,
      ease: Sine.easeOut
      opacity: 0
      translateX: 100
      rotateY: 90

    animate.play()

  rightCenter: (view, done) ->
    view.animationParams.opacity = 0
    view.animationParams.translateX = 100
    view.animationParams.rotateY = 90

    animate = new TimelineMax
      paused: on
      onUpdate: ->
        view.$el.css
          opacity: view.animationParams.opacity
          transform: "translateX(#{view.animationParams.translateX}%) rotateY(#{view.animationParams.rotateY}deg)"

    animate.to view.animationParams, 1.6 / speed,
      ease: Sine.easeOut
      opacity: 1
      translateX: 0
      rotateY: 0

    animate.play()