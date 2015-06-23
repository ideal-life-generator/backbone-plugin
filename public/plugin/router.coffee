define ->

  class Route

    _parseNested = (config, selectorCallback, viewCallback, settings) ->
      for own selectorName, selectorViews of config
        selectorCallbackResult = selectorCallback selectorName, selectorViews, settings
        for own viewName, viewSetting of selectorViews
          viewCallback viewName, viewSetting, (config, settings) ->
            _parseNested config, selectorCallback, viewCallback, settings
          , selectorCallbackResult

    _find = (findObject, findSelectorName, findViewName, findCallback) ->
      _parseNested findObject, (selectorName, selectorSettings) ->
        on if findSelectorName is selectorName
      , (viewName, viewSetting, next, selectorCondition) ->
        if selectorCondition and findViewName is viewName
          findCallback viewSetting
        else if viewSetting.childrens
          next viewSetting.childrens

    class State
      constructor: (setting) ->
        @url = setting.url
        @init = setting.init
        @update = setting.update
        @destroy = setting.destroy
        @cache = null
        @view = null

      get: (callback) ->
        unless @view
          require @url, (loadedView) ->
            callback @view = @init loadedView
        else
          callback @view

    class StatesComposition
      add: (nameState, stateObject) ->
        @[nameState] = stateObject

      get: (stateName) ->
        return state for state in @states when state.name is stateName

    class StatesContainer
      constructor: (config) ->
        _parseNested config, (selectorName, selectorSettings, settings) ->
          delete selectorSettings.animations
          settings.container[selectorName] = new StatesComposition
        , (viewName, viewSetting, next, statesComposition) ->
          state = new State viewSetting
          statesComposition.add viewName, state
          if viewSetting.childrens
            state.childrens = { }
            next viewSetting.childrens, container: state.childrens
        ,
          container: @

      # find: (findSelectorName, findViewName) ->
      #   _parseNested @, (selectorName, selectorSettings, settings) ->
      #     on if findSelectorName is selectorName
      #   , (viewName, viewSetting, next, selectorCondition) ->
      #     1

    class StatesCoordinator

      _checkState = (checkedSelectors, checkSelectorName, checkViewName) ->
        for selectorName, selectorViews of checkedSelectors
          for viewName, viewSettings of selectorViews
            return on if checkSelectorName is selectorName and checkViewName is viewName
            if viewSettings.childrens
              return _checkState viewSettings.childrens, checkSelectorName, checkViewName
      
      _findActiveView = (findedSelector) ->
        for own viewName, viewSettings of findedSelector
          if viewSettings.status is "first time" or viewSettings.status is "new"
            return viewName

      _checkReplecement = (checkedSelectors) ->
        for own viewName, viewSettings of checkedSelectors
          if viewSettings.status is "new"
            return viewName

      _checkUpdate =
        do ->
          viewsCache = { }
          (checkedSelectors, checkSelectorName, checkViewName) ->
            for selectorName, selectorViews of checkedSelectors
              for viewName, viewSettings of selectorViews
                if checkSelectorName is selectorName and checkViewName is viewName and viewSettings.update
                  cacheName = "#{checkSelectorName}:#{checkViewName}"
                  oldUpdate = viewsCache[cacheName]
                  newUpdate = viewsCache[cacheName] = JSON.stringify viewSettings.update
                  return on if oldUpdate isnt newUpdate
                if viewSettings.childrens
                  return _checkUpdate viewSettings.childrens, checkSelectorName, checkViewName

      constructor: (config) ->
        _parseNested config, (selectorName, selectorSettings, settings) ->
          settings.container[selectorName] = { }
        , (viewName, viewSetting, next, selectorConteiner) ->
          selectorConteiner[viewName] = status: "unused"
          if viewSetting.childrens
            selectorConteiner[viewName].childrens = { }
            next viewSetting.childrens, container: selectorConteiner[viewName].childrens
        ,
          container: @

      # Пофиксить баг на уровне соответствия вложенных видов

      createCoordinte: (update) ->
        _parseNested @, (selectorName, selectorSettings, settings) ->
          name: selectorName, activeViewName: _findActiveView selectorSettings, selectorName
        , (viewName, viewSetting, next, selectorSettings) ->
          if _checkState(update, selectorSettings.name, viewName)
            updated = _checkUpdate update, selectorSettings.name, viewName
            if viewSetting.status is "unused" and not selectorSettings.activeViewName
              viewSetting.status = "first time"
            else if selectorSettings.activeViewName and selectorSettings.activeViewName isnt viewName
              viewSetting.status = "new"
            else if selectorSettings.activeViewName is viewName
              if updated
                viewSetting.status = "update"
              else
                viewSetting.status = "hold visible"
          if viewSetting.childrens
            next viewSetting.childrens

        _parseNested @, (selectorName, selectorSettings, settings) ->
          name: selectorName, replacementName: _checkReplecement(selectorSettings), activeViewName: _findActiveView selectorSettings, selectorName
        , (viewName, viewSetting, next, selectorSettings) ->
          unless _checkState update, selectorSettings.name, viewName
            if selectorSettings.activeViewName is viewName and viewSetting.status is "first time" or viewSetting.status is "new" or viewSetting.status is "hold"
              if selectorSettings.replacementName and selectorSettings.replacementName isnt viewName
                viewSetting.status = "old"
              else
                viewSetting.status = "last"
            else if viewSetting.status is "old" or viewSetting.status is "last"
              viewSetting.status = "hold invisible"
          if viewSetting.childrens
            next viewSetting.childrens

    constructor: (config) ->
      @states = new StatesContainer config
      @coordinator = new StatesCoordinator config

    go: (requiredState) ->
      @coordinator.createCoordinte requiredState
