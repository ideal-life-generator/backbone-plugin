define ->

  _param = (name, value) ->
    if value then "#{name}=#{value}"
    else ""

  _.extend Backbone.Router.prototype,
    parseParam: (props, currentFragment) ->
      params = [ ]
      params.push _param name, value for name, value of props when param = _param name, value
      if params.length then "?#{params.join('&')}" else ""