define ->

  ###

  Модель роутинга:

  ###

  ###

  1) Главный контролирующий загрузки и анимации объект:
    1) Берет объект каллбеков загрузки и пользуется им;
    2) Берет объект каллбеков анимаций и пользуется им;

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

      get: -> @view

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

      _updatedParams = do ->
        params = { }
        (stateName, stateParams) ->
          stateParamsJson = JSON.stringify stateParams
          if params[stateName] isnt stateParamsJson
            params[stateName] = stateParamsJson
            on

      _differentActive = (config, findedStateName) ->
        findedSelector = findedStateName.slice findedStateName, findedStateName.lastIndexOf ":"
        return on for stateName, stateIndex of config when findedStateName isnt stateName and stateName.indexOf(findedSelector) isnt -1 and stateName.indexOf(">", findedSelector.length) is -1 and stateIndex is "first" or stateIndex is "new" or stateIndex is "hold" or stateIndex is "update"

      _isReplecement = (config, findedStateName) ->
        findedSelector = findedStateName.slice findedStateName, findedStateName.lastIndexOf ":"
        return on for stateName, stateIndex of config when findedStateName isnt stateName and stateName.indexOf(findedSelector) isnt -1 and stateName.indexOf(">", findedSelector.length) is -1 and stateIndex is "new"

      constructor: (statesConfig) ->
        @config = { }
        @config[stateName] = "unused" for stateName, stateConfig of statesConfig

      update: (requiredStates) ->
        for requiredStateName, requiredStateParams of requiredStates
          differentActive = _differentActive @config, requiredStateName
          updatedParams = _updatedParams requiredStateName, requiredStateParams
          currentStateParam = @config[requiredStateName]
          if currentStateParam is "unused" and not differentActive
            @config[requiredStateName] = "first"
          else if differentActive
            @config[requiredStateName] = "new"
          else if not differentActive
            if updatedParams
              @config[requiredStateName] = "update"
            else
              @config[requiredStateName] = "visible"

        for stateName, stateStatus of @config when not requiredStates[stateName]
          differentActive = _differentActive @config, stateName
          if differentActive and stateStatus is "first" or stateStatus is "new" or stateStatus is "update" or stateStatus is "hold"
            if _isReplecement  @config, stateName
              @config[stateName] = "old"
            else
              @config[stateName] = "last"
          else if @config[stateName] is "old" or @config[stateName] is "last"
            @config[stateName] = "invisible"

        @config


    ###

    4) Выстраивается два объекта каллбеков с зависимостями:
      1) Зависимости при загрузке от родительского;
      2) Зависимости от анимации родительского;

    ###

    class LoadManager
      constructor: (config) ->

    ###

    5) Анимационный движок:
      1) Хранит функции анимаций;
      2) Выполняет анимацию в зависимости от priority;
      3) Проверяет свойства alwaysRun и запускает анимации для дочерних;
      4) Проверяет свойство inOrder и проводит анимации в порядке;

    ###

    class AnimationsController
      lastAnimation = { }
      constructor: (config) ->
        @animations = config.animations
        @priorities = config.priorities

        return (animationName, requiredStateName, viewElement, done) ->
          idName = requiredStateName
          for own stateName, animationParams of @ when requiredStateName is stateName
            switch animationName
  
              when "first"
                animationParams.first viewElement, done
                lastAnimation[stateName] = "first"
  
              when "old"
                animationParams.first viewElement, done
                lastAnimation[stateName] = "old"

    constructor: (statesConfig, animationsConfig) ->
      @statesCollection = new StatesCollection statesConfig
      @routerCoordinator = new RouterCoordinator statesConfig
      @animationsController = new AnimationsController animationsConfig

    go: (requiredStates) ->
      newStateCoordinates = @routerCoordinator.update requiredStates
      console.log newStateCoordinates
      # @animationsController "first", "id-1:plugin>id-2:main", @statesCollection.find("id-1:plugin>id-2:main"), ->