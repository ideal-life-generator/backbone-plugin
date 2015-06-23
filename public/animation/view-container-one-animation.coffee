define [

], (

) ->

  speed = 5

  first: (view) ->
    view.animationParams.opacity = 0 unless view.animationParams.opacity
    view.animationParams.translateZ = -120 unless view.animationParams.translateZ

    animate = new TimelineMax
      paused: on
      onUpdate: ->
        view.$el.css
          opacity: view.animationParams.opacity
          transform: "translateZ(#{view.animationParams.translateZ}px)"

    animate.to view.animationParams, 1.6 / speed,
      opacity: 1
      translateZ: -180

    animate.to view.animationParams, 2 / speed,
      delay: 0.5 / speed
      ease: Sine.easeOut
      translateZ: 0

    animate.play()

  last: (view, done) ->
    view.animationParams.opacity = 1 unless view.animationParams.opacity
    view.animationParams.translateZ = 0 unless view.animationParams.translateZ

    animate = new TimelineMax
      paused: on
      onUpdate: ->
        view.$el.css
          opacity: view.animationParams.opacity
          transform: "translateZ(#{view.animationParams.translateZ}px)"
      onComplete: -> done()

    animate.to view.animationParams, 1.6 / speed,
      opacity: 0.999
      translateZ: -180

    animate.to view.animationParams, 2 / speed,
      delay: 0.5 / speed
      ease: Sine.easeOut
      opacity: 0
      translateZ: -120

    animate.play()

  centerLeft: (view, done) ->
    view.animationParams.opacity = 1 unless view.animationParams.opacity
    view.animationParams.translateZ = 0 unless view.animationParams.translateZ
    view.animationParams.translateX = 0 unless view.animationParams.translateX
    view.animationParams.rotateY = 0 unless view.animationParams.rotateY

    view.$el.css transformOrigin: "100% 0"

    animate = new TimelineMax
      paused: on
      onUpdate: ->
        view.$el.css
          opacity: view.animationParams.opacity
          transform: "translateZ(#{view.animationParams.translateZ}px) translateX(#{view.animationParams.translateX}%) rotateY(#{view.animationParams.rotateY}deg"
      onComplete: -> done()

    animate.to view.animationParams, 1.6 / speed,
      opacity: 0.999
      translateZ: -180

    animate.to view.animationParams, 1.6 / speed,
      ease: Sine.easeInOut
      translateX: -105
      rotateY: 30

    animate.to view.animationParams, 2 / speed,
      delay: 0.5 / speed
      ease: Sine.easeOut
      opacity: 0
      translateZ: 0

    animate.play()

  leftCenter: (view) ->
    view.animationParams.opacity = 0 unless view.animationParams.opacity
    view.animationParams.translateZ = 0 unless view.animationParams.translateZ
    view.animationParams.translateX = -105 unless view.animationParams.translateX
    view.animationParams.rotateY = 30 unless view.animationParams.rotateY

    view.$el.css transformOrigin: "100% 0"

    animate = new TimelineMax
      paused: on
      onUpdate: ->
        view.$el.css
          opacity: view.animationParams.opacity
          transform: "translateZ(#{view.animationParams.translateZ}px) translateX(#{view.animationParams.translateX}%) rotateY(#{view.animationParams.rotateY}deg"

    animate.to view.animationParams, 1.6 / speed,
      opacity: 0.999
      translateZ: -180

    animate.to view.animationParams, 1.6 / speed,
      ease: Sine.easeInOut
      translateX: 0
      rotateY: 0

    animate.to view.animationParams, 2 / speed,
      delay: 0.5 / speed
      ease: Sine.easeOut
      opacity: 1
      translateZ: 0

    animate.play()

  centerRight: (view, done) ->
    view.animationParams.opacity = 1 unless view.animationParams.opacity
    view.animationParams.translateZ = 0 unless view.animationParams.translateZ
    view.animationParams.translateX = 0 unless view.animationParams.translateX
    view.animationParams.rotateY = 0 unless view.animationParams.rotateY

    view.$el.css transformOrigin: "0 0"

    animate = new TimelineMax
      paused: on
      onUpdate: ->
        view.$el.css
          opacity: view.animationParams.opacity
          transform: "translateZ(#{view.animationParams.translateZ}px) translateX(#{view.animationParams.translateX}%) rotateY(#{view.animationParams.rotateY}deg)"
      onComplete: -> done()

    animate.to view.animationParams, 1.6 / speed,
      opacity: 1
      translateZ: -180

    animate.to view.animationParams, 1.6 / speed,
      ease: Sine.easeInOut
      translateX: 105
      rotateY: -30

    animate.to view.animationParams, 2 / speed,
      delay: 0.5 / speed
      ease: Sine.easeOut
      translateZ: 0

    animate.play()

  rightCenter: (view) ->
    view.animationParams.opacity = 0 unless view.animationParams.opacity
    view.animationParams.translateZ = 0 unless view.animationParams.translateZ
    view.animationParams.translateX = 105 unless view.animationParams.translateX
    view.animationParams.rotateY = -30 unless view.animationParams.rotateY

    view.$el.css transformOrigin: "0 0"

    animate = new TimelineMax
      paused: on
      onUpdate: ->
        view.$el.css
          opacity: view.animationParams.opacity
          transform: "translateZ(#{view.animationParams.translateZ}px) translateX(#{view.animationParams.translateX}%) rotateY(#{view.animationParams.rotateY}deg)"

    animate.to view.animationParams, 1.6 / speed,
      opacity: 1
      translateZ: -180

    animate.to view.animationParams, 1.6 / speed,
      ease: Sine.easeInOut
      translateX: 0
      rotateY: 0

    animate.to view.animationParams, 2 / speed,
      delay: 0.5 / speed
      ease: Sine.easeOut
      translateZ: 0

    animate.play()
