define ->

  class StateComposite
    constructor: ->
      @states = [ ]

    add: (state) ->
      @states.push state


   
  class StateMenager

    class StateFactory
  
      class StateLoader
        constructor: (path) ->
          deferred = $.Deferred()
          require [ path ], (View) =>
            setTimeout =>
              deferred.resolve View
            , 0

          @promise = deferred.promise()
      
      class NestedStateLoader
        constructor: (path, parent) ->
          deferred = $.Deferred()
          require [ path ], (View) =>
            setTimeout =>
              parent.promise.then =>
                deferred.resolve View
            , if path is "page/product/list/view" then 0 else 0

          @promise = deferred.promise()
    
      create: (name, parent) ->
        unless parent
          new StateLoader name
        else
          new NestedStateLoader name, parent

    _stateFactory = new StateFactory

    _parseNested = (fullname) ->
      names = fullname.split "."
      result = [ ]
      current = [ ]
      for name in names when name
        current.push name
        result.push current.join "."
      result

    _parsePriority = (previousPriority, currentPriority) ->

      prePriorityVertical = previousPriority[0]
      prePriorityHorisontal = previousPriority[1]
      currentPriorityVertical = currentPriority[0]
      currentPriorityHorisontal = currentPriority[1]

      if prePriorityVertical < currentPriorityVertical
        animationState = 0
      else if prePriorityVertical > currentPriorityVertical
        animationState = 1
      else if prePriorityVertical is currentPriorityVertical
        if prePriorityHorisontal < currentPriorityHorisontal
          animationState = 2
        else if prePriorityHorisontal > currentPriorityHorisontal
          animationState = 3

    constructor: (@config) ->
      @cache = { }
      @selector = { }
      @lastState = [ ]

    load: (setting) ->

      names = _parseNested setting.state
      param = setting.param
      update = setting.update
      last = null

      parentAnimationOnStart = off

      for stateName in names when stateName

        do (stateName, current = @cache[stateName], currentConfig = @config.route[stateName]) =>

          unless current
            last = @cache[stateName] = _stateFactory.create currentConfig.path, last

      for stateName, index in names when stateName

        do (stateName, current = @cache[stateName], currentConfig = @config.route[stateName], animate = @config[@config.route[stateName].selector], isFirst = index is 0) =>

          unless @selector[currentConfig.selector]

            if animate.allwaysStart or not parentAnimationOnStart
              current.promise.then (init) ->
                current.view = currentConfig.init init param
                animate.animation.first current.view
              parentAnimationOnStart = on
            else
              current.promise.then (init) ->
                current.view = currentConfig.init init param

            current.state = "first"
            @selector[currentConfig.selector] = stateName

          else if @selector[currentConfig.selector] isnt stateName

            preStateName = @selector[currentConfig.selector]
            pre = @cache[preStateName]
            preConfig = @config.route[preStateName]
            preAnimate = @config[preConfig.selector]
            pre.state = "replaced"

            animationState = _parsePriority preConfig.priority, currentConfig.priority

            switch animationState
              when 0 then preAnimate.animation.centerTop pre.view, do (destroy = preConfig.destroy, view = pre.view) -> -> destroy view
              when 1 then preAnimate.animation.centerBottom pre.view, do (destroy = preConfig.destroy, view = pre.view) -> -> destroy view
              when 2 then preAnimate.animation.centerLeft pre.view, do (destroy = preConfig.destroy, view = pre.view) -> -> destroy view
              when 3 then preAnimate.animation.centerRight pre.view, do (destroy = preConfig.destroy, view = pre.view) -> -> destroy view
            
            current.promise.then (init) =>
              current.view = currentConfig.init init param
              switch animationState
                when 0 then animate.animation.bottomCenter current.view, do (destroy = currentConfig.destroy, view = current.view) -> -> destroy view
                when 1 then animate.animation.topCenter current.view, do (destroy = currentConfig.destroy, view = current.view) -> -> destroy view
                when 2 then animate.animation.rightCenter current.view, do (destroy = currentConfig.destroy, view = current.view) -> -> destroy view
                when 3 then animate.animation.leftCenter current.view, do (destroy = currentConfig.destroy, view = current.view) -> -> destroy view

            parentAnimationOnStart = on unless animate.allwaysStart or parentAnimationOnStart

            current.state = "replicate"
            @selector[currentConfig.selector] = stateName

          else if @selector[currentConfig.selector] is setting.state and update

            currentConfig.update current.view, update

      # 1) включенна анимация:
      #   1) последний раз:
      #     1) включить анимацию для родительского вида и всех дочерних
      #   2) с заменой:
      #     1) для замены уже будет запущенна и всех дочерних мы выполняем последний раз
      # 2) выключенна анимация:
      #   1) последний раз:
      #     1) анимация выполняется для первого, далее в неё передается массив калбеков на удаление для дочерних
      #   2) с заменой:
      #     1) анимация для замены будет запущенна, а для дочерних надо будет сделать каллбеки и передать в первую

      # for stateName, currentConfig of @config.route when names.indexOf(stateName) is -1

      #   do (stateName, current = @cache[stateName], currentConfig, animate = @config[currentConfig.selector]) =>

      #     selectorName = @selector[currentConfig.selector]

      #     if current and current.view and selectorName
      #       if selectorName is stateName
      #         animate.animation.last current.view, do (destroy = currentConfig.destroy, view = current.view) -> -> currentConfig.destroy view
      #         current.view = null
      #         current.state = ""
      #         @selector[currentConfig.selector] = null
      #       else if current.state is "replaced"
      #         current.view = null
      #         current.state = ""

      @lastState = names