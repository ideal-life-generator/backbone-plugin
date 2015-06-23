define ->

  ###

  Модель роутинга:

  ###

  class Router

    ###

    2) На основе конфига создается классы с видами:
      1) Хранятся в общем объекте коллекции под уникальным именем;

    ###

    class State
      constructor: (@url, @position, @init, @update, @destroy) ->
        @instance = null
        @view = null

      get: (callback) -> 
        if @instance
          callback @instance
        else
          require [ @url ], (instance) =>
            if @url is "view/plugin/plugin-view"
              setTimeout =>
                callback @instance = instance
              , 300
            else if @url is "view/plugin/main/main-view"
              setTimeout =>
                callback @instance = instance
              , 900
            else if @url is "view/contact/contact-view"
              setTimeout =>
                callback @instance = instance
              , 600
            else
              callback @instance = instance

    class StatesCollection
      constructor: (statesConfig) ->
        for stateName, stateConfig of statesConfig
          @[stateName] = new State stateConfig.url, stateConfig.position, stateConfig.init, stateConfig.update, stateConfig.destroy

      find: (requiredStateName) ->
        return stateConfig for own stateName, stateConfig of @ when requiredStateName is stateName

    ###

    3) Объект предоставляющий текущее состояние роутера:
      1) Хранит и обновляет текущее состояние роутера; 

    ###

    class RouterCoordinator

      constructor: (statesConfig) ->

    ###

    4) Выстраивается два объекта каллбеков с зависимостями:
      1) Зависимости при загрузке от родительского;
      2) Зависимости от анимации родительского;

    ###

    class LoadManager

      class Observer
        constructor: ->
          @loads = [ ]

        add: (callback) ->
          @loads.push callback

        run: ->
          callback() for callback in @loads
          @loads.length = 0

      constructor: (config) ->
        @status = { }
        @observers = { }
        @observers[name] = new Observer for name, params of config

      onready: (routeName, callback) ->
        parentIndex = routeName.lastIndexOf ">"
        if parentIndex isnt -1
          parent = routeName.slice 0, parentIndex
          if @status[parent] is "loaded"
            @status[routeName] = "loaded"
            callback()
            @observers[routeName].run()
          else
            @observers[parent].add =>
              callback()
              @observers[routeName].run()
        else
          @status[routeName] = "loaded"
          callback()
          @observers[routeName].run()

    ###

    5) Анимационный движок:
      1) Хранит функции анимаций;
      2) Выполняет анимацию в зависимости от priority;
      3) Проверяет свойства alwaysRun и запускает анимации для дочерних;
      4) Проверяет свойство inOrder и проводит анимации в порядке;

    ###

    class AnimationsController
      constructor: (config) ->

    ###

    1) Главный контролирующий загрузки и анимации объект:
      1) Берет объект каллбеков загрузки и пользуется им;
      2) Берет объект каллбеков анимаций и пользуется им;

    ###

    class RouterController
      constructor: (routesConfig) ->
        @states = new StatesCollection routesConfig
        @loadManager = new LoadManager routesConfig

      perform: (routes, params) ->
        for routeName, routeParam of routes
          do (routeName, routeParam) =>
            switch routeParam
              when "first"
                currentState = @states.find routeName
                currentState.get (instance) =>
                  currentState.view = currentState.init instance params[routeName]
                  @loadManager.onready routeName, =>
                    console.log "#loaded", routeName, currentState.view
              when "update"
                2 
              when "new"
                3
              when "last"
                4
              when "old"
                5

    constructor: (statesConfig, animationsConfig) ->
      @routerController = new RouterController statesConfig

    go: (requiredStates) ->
      # newStateCoordinates = @routerCoordinator.update requiredStates

      ###
      "id-1:plugin": "first", "id-1:plugin>id-2:main".slice("id-1:plugin>id-2:main".lastIndexOf(">", "id-1:plugin>id-2:main".lastIndexOf(">")-1)+1): "first", "id-1:plugin>id-2:list": "unused", "id-1:plugin>id-2:main>id-3:info": "first", "id-1:contact": "unused"
      "id-1:plugin": "update", "id-1:plugin>id-2:main": "last", "id-1:plugin>id-2:list": "unused", "id-1:plugin>id-2:main>id-3:info": "last", "id-1:contact": "unused"
      ###

      @routerController.perform 
          "id-1:plugin": "first"
          "id-1:plugin>id-2:main": "first"
        ,
          requiredStates

      @routerController.perform 
          "id-1:plugin": "first"
          "id-1:plugin>id-2:list": "first"
        ,
          requiredStates