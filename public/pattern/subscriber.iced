class Observer

  constructor: ->
    @subscribers = { }

  subscribe: (name, callback) ->
    @subscribers[name] = [ ] unless @subscribers[name]
    @subscribers[name].push callback if @subscribers[name].indexOf(callback) is -1

  unsubscribe: (name, callback) ->
    return unless callbacks = @subscribers[name]
    index = callbacks.indexOf callback
    callbacks.splice index, 1 if index > -1

  publish: (name, data) ->
    return unless callbacks = @subscribers[name]
    subscribeCallback data for subscribeCallback in callbacks

observer = new Observer

observer.subscribe "news", (data) ->
  console.log "user 1 take new #{data.title}"

observer.subscribe "news", (data) ->
  console.log "user 2 take new #{data.title}"

observer.publish "news", title: "Destruction main center"