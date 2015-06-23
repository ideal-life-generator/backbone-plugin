(function() {
  define(function() {
    var _param;
    _param = function(name, value) {
      if (value) {
        return name + "=" + value;
      } else {
        return "";
      }
    };
    return _.extend(Backbone.Router.prototype, {
      parseParam: function(props, currentFragment) {
        var name, param, params, value;
        params = [];
        for (name in props) {
          value = props[name];
          if (param = _param(name, value)) {
            params.push(_param(name, value));
          }
        }
        if (params.length) {
          return "?" + (params.join('&'));
        } else {
          return "";
        }
      }
    });
  });

}).call(this);
