define ->
   
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
      current = [ ]
      for name in names
        current.push name
        current.join "."

    constructor: (@config) ->
      @cache = { }
      @selector = { }

    load: (setting) ->
      # 1) распарсить имя;
      # 2) загрузка по именам происходит:
      #   1) от родителя к дочернему;
      #   2) все виды загружаюися асинхронно и одновременно:
      #     1) под имя содержит его настройки:
      #       1) если ранее под этим же селектором не было вида и вид не инициализирован, то делаем его инициализацию и first ( first );
      #       2) если был вид, но в данный момент он не используется то делаем его ( last ), если селектор текущий - удаляем;
      #       3) если был вид, и мы заменяем его под тем же селектором на новый, то делаем hide и init а после show ( hide, show );
      #       4) если запрашивается тот же вид, под тем же селектором то делаем его обновление ( update );
      #   3) механика инициализации или отображения проиходит от внешнего ко внутреннему;

      names = _parseNested setting.state
      param = setting.param
      last = null

      for stateName in names when stateName

        do (stateName, current = @cache[stateName], currentConfig = @config.routes[stateName]) =>

          if not ( currentConfig and @selector[currentConfig.selector] ) and not ( current and current.view )

            last = current = @cache[stateName] = _stateFactory.create currentConfig.path, last
            current.promise.then (ViewInstance) =>
              current.view = currentConfig.init ViewInstance, ( param[stateName] if param )
              currentConfig.animation.first current.view
              current.status = "first"
            @selector[currentConfig.selector] = stateName

          else if @selector[currentConfig.selector] and @selector[currentConfig.selector] isnt stateName

            preStateName = @selector[currentConfig.selector]
            pre = @cache[preStateName]
            preConfig = @config.routes[preStateName]

            prePriorityVertical = preConfig.priority[0]
            prePriorityHorisontal = preConfig.priority[1]
            currentPriorityVertical = currentConfig.priority[0]
            currentPriorityHorisontal = currentConfig.priority[1]

            if prePriorityVertical < currentPriorityVertical
              animationState = "bottom-top"
            else if prePriorityVertical > currentPriorityVertical
              animationState = "top-bottom"
            else if prePriorityVertical is currentPriorityVertical
              if prePriorityHorisontal < currentPriorityHorisontal
                animationState = "left-right"
              else if prePriorityHorisontal > currentPriorityHorisontal
                animationState = "right-left"

            switch animationState
              when "bottom-top"
                preConfig.animation.centerTop pre.view, preConfig.last
              when "top-bottom"
                preConfig.animation.centerBottom pre.view, preConfig.last
              when "left-right"
                preConfig.animation.centerRight pre.view, preConfig.last
              when "right-left"
                preConfig.animation.centerLeft pre.view, preConfig.last

            pre = null

            last = current = @cache[stateName] = _stateFactory.create currentConfig.path, last
            current.promise.then (ViewInstance) =>
              current.view = currentConfig.init ViewInstance, ( param[stateName] if param )
              switch animationState
                when "bottom-top"
                  currentConfig.animation.bottomCenter current.view, currentConfig.first
                when "top-bottom"
                  currentConfig.animation.topCenter current.view, currentConfig.first
                when "left-right"
                  currentConfig.animation.leftCenter current.view, currentConfig.first
                when "right-left"
                  currentConfig.animation.rightCenter current.view, currentConfig.first
              current.status = "show"

            @selector[currentConfig.selector] = stateName

      for stateName, state of @config.routes when names.indexOf(stateName) is -1

        do (stateName, current = @cache[stateName], currentConfig = @config.routes[stateName]) =>

          selectorName = @selector[currentConfig.selector]

          if current and current.view and selectorName and selectorName is stateName
            currentConfig.animation.last current.view
            current.view = null
            @selector[currentConfig.selector] = null
            current.status = "last"