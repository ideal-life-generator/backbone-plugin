define ->
   
  class StateMenager

    class StateFactory
  
      class StateLoader
        constructor: (path) ->
          defer = $.Deferred()
          require [ path ], (View) =>
            setTimeout =>
              defer.resolve View
            , 300

          @promise = defer.promise()
      
      class NestedStateLoader
        constructor: (path, parent) ->
          defer = $.Deferred()
          require [ path ], (View) =>
            setTimeout =>
              parent.promise.then =>
                defer.resolve View
            , if path is "page/product/list/view" then 150 else 0

          @promise = defer.promise()
    
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

    load: (setting) ->
      # 1) распарсить имя;
      # 2) загрузка по именам происходит:
      #   1) от родителя к дочернему;
      #   2) все виды загружаюися асинхронно и одновременно:
      #     1) под имя содержит его настройки:
      #       1) если их нет и нет инициализированного вида то инициализировать записать в кеш и показать ( first );
      #       2) если вид не указан но он есть то делаем его hide ( hide );
      #       3) если есть вид и его не требуется инициализировать то просто показать ( show );
      #       4) если есть настройка init то удалить старый вид, выполнить для него remove, и записать в кеше новый, после выполнить операцию show ( first );
      #       5) если есть настройки но нам уже не нужен этот вид то мы отменяем его инициализацию в объекте promise и удаляем из кеша;
      #   3) механика инициализации или отображения проиходит от внешнего ко внутреннему;

      names = _parseNested setting.state
      params = setting.init
      last = null
      names.forEach (name) =>
        do (currentConfig = @config[name], current = @cache[name]) =>
          unless current
            last = current = @cache[name] = _stateFactory.create currentConfig.path, last
            current.promise.then (ViewInstance) =>
              current.instance = ViewInstance
              current.view = currentConfig.initialize ViewInstance, ( params[name] if params )
              currentConfig.first current.view
              current.status = "first"
          else if params and params[name]
            currentConfig.last @cache[name].view
            last = current = @cache[name] = _stateFactory.create currentConfig.path, last
            current.promise.then (ViewInstance) =>
              current.instance = ViewInstance
              current.view = currentConfig.initialize ViewInstance, params[name]
              currentConfig.first current.view
              current.status = "first"
          else if current.status is "hide"
            currentConfig.show current.view
            current.status = "show"

      for name, config of @config
        if names.indexOf(name) is -1
          if @cache[name] and @cache[name].view and ( @cache[name].status is "show" or @cache[name].status is "first" )
            @cache[name].status = "hide"
            @config[name].hide @cache[name].view

# define ->

#   class State
#     constructor: (@name, @path, @initialize, @show, @hide) ->

#     equal: (name) -> @name is name

#     get: (defers) ->
#       @state = "loading"
#       defer = $.Deferred()
#       promise = defer.promise()
#       require [ @path ], (@view) => defer.resolve view
#       if defers
#         $.when.apply $, defers
#           .done =>
#             promise.then (view) =>
#               @state = "used"
#               @show @view = @initialize view
#       else
#         promise.then (view) =>
#           @state = "used"
#           @show @view = @initialize view

#   class States
#     constructor: (configs) ->
#       @states = [ ]
#       @states.push new State name, config.path, config.initialize, config.show, config.hide for name, config of configs

#     get: (name) ->
#       names = @_parseNested name
#       defers = [ ]
#       defersFor = null
#       for name in names
#         do (state = @_get name, defers, defersFor) =>
#           unless state.view
#             defers.push state.get defersFor
#             defersFor = [ ].concat defers
#           else if state.state isnt "used"
#             state.show state.view
#       for state in @states
#         if names.indexOf(state.name) is -1 and state.view
#           state.state = "cache"
#           state.hide state.view

#     _get: (name) ->
#       return state for state in @states when state.equal name

#     _parseNested: (name) ->
#       names = name.split "."
#       current = [ ]
#       for name in names
#         current.push name
#         current.join "."

#     takeView: ->