define [
  "global/render.template"
  "global/loader.view"
  "plugin/phone.mask"
  "component/field/first.name"
  "component/field/last.name"
  "component/field/mobile"
  "component/field/age"
  "component/field/gender"
  "plugin/route"
], (
  RenderTemplate
  LoaderView
  PhoneMask
  FirstName
  LastName
  Mobile
  Age
  Gender
  Route
) ->

  $(->

    speed = 5

    animation =
      first: (view) ->
        view.animationParams.opacity = 0
        view.animationParams.translateZ = -120

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

        $(".view-container-one").append(view.$el)

      last: (view) ->

        view.animationParams.opacity = 1
        view.animationParams.translateZ = 0

        animate = new TimelineMax
          paused: on
          onUpdate: ->
            view.$el.css
              opacity: view.animationParams.opacity
              transform: "translateZ(#{view.animationParams.translateZ}px)"
          onComplete: -> view.remove()

        animate.to view.animationParams, 1.6 / speed,
          opacity: 0.999
          translateZ: -180

        animate.to view.animationParams, 2 / speed,
          delay: 0.5 / speed
          ease: Sine.easeOut
          opacity: 0
          translateZ: -120

        animate.play()

      centerLeft: (view) ->
        view.animationParams.opacity = 1
        view.animationParams.translateZ = 0
        view.animationParams.translateX = 0
        view.animationParams.rotateY = 0

        view.$el.css transformOrigin: "100% 0"

        animate = new TimelineMax
          paused: on
          onUpdate: ->
            view.$el.css
              opacity: view.animationParams.opacity
              transform: "translateZ(#{view.animationParams.translateZ}px) translateX(#{view.animationParams.translateX}%) rotateY(#{view.animationParams.rotateY}deg"
          onComplete: -> view.remove()

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
        view.animationParams.opacity = 0
        view.animationParams.translateZ = 0
        view.animationParams.translateX = -105
        view.animationParams.rotateY = 30

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

        $(".view-container-one").append(view.$el)

      centerRight: (view) ->
        view.animationParams.opacity = 1
        view.animationParams.translateZ = 0
        view.animationParams.translateX = 0
        view.animationParams.rotateY = 0

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
          translateX: 105
          rotateY: -30

        animate.to view.animationParams, 2 / speed,
          delay: 0.5 / speed
          ease: Sine.easeOut
          translateZ: 0

        animate.play()

        $(".view-container-one").append(view.$el)

      rightCenter: (view) ->
        view.animationParams.opacity = 0
        view.animationParams.translateZ = 0
        view.animationParams.translateX = 105
        view.animationParams.rotateY = -30

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

        $(".view-container-one").append(view.$el)

    route = new Route
      routes:
        "product":
          path: "page/product/view"
          selector: ".view-container-one"
          priority: "00"
          init: (ProductView, person) ->
            console.log "product initialize"
            productView = new ProductView
            productView.animationParams = { }
            productView.render person
            productView
          animation:
            first: animation.first
            last: animation.last
            centerLeft: animation.centerLeft
            leftCenter: animation.leftCenter
            centerRight: animation.centerRight
            rightCenter: animation.rightCenter
        "contact":
          path: "page/contact/view"
          selector: ".view-container-one"
          priority: "01"
          init: (ContactView) ->
            console.log "contact initialize"
            contactView = new ContactView
            contactView.animationParams = { }
            contactView
          animation:
            first: animation.first
            last: animation.last
            centerLeft: animation.centerLeft
            leftCenter: animation.leftCenter
            centerRight: animation.centerRight
            rightCenter: animation.rightCenter

    PageRoute = Backbone.Router.extend
      routes:
        "product": ->
          route.load
            state: "product"
            param:
              product:
                name: "Vlad"
        "product/list": ->
          route.load
            state: "product.list"
        "product/list/info-:id": (id) ->
          route.load
            state: "product.list.info"
            init:
              "product.list.info":
                "info-id": id
        "contact": ->
          route.load
            state: "contact"
  
    Backbone.history.start()
  
  )