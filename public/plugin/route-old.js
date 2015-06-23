(function() {
  define(function() {
    var StateComposite, StateMenager;
    StateComposite = (function() {
      function StateComposite() {
        this.states = [];
      }

      StateComposite.prototype.add = function(state) {
        return this.states.push(state);
      };

      return StateComposite;

    })();
    return StateMenager = (function() {
      var StateFactory, _parseNested, _parsePriority, _stateFactory;

      StateFactory = (function() {
        var NestedStateLoader, StateLoader;

        function StateFactory() {}

        StateLoader = (function() {
          function StateLoader(path) {
            var deferred;
            deferred = $.Deferred();
            require([path], (function(_this) {
              return function(View) {
                return setTimeout(function() {
                  return deferred.resolve(View);
                }, 0);
              };
            })(this));
            this.promise = deferred.promise();
          }

          return StateLoader;

        })();

        NestedStateLoader = (function() {
          function NestedStateLoader(path, parent) {
            var deferred;
            deferred = $.Deferred();
            require([path], (function(_this) {
              return function(View) {
                return setTimeout(function() {
                  return parent.promise.then(function() {
                    return deferred.resolve(View);
                  });
                }, path === "page/product/list/view" ? 0 : 0);
              };
            })(this));
            this.promise = deferred.promise();
          }

          return NestedStateLoader;

        })();

        StateFactory.prototype.create = function(name, parent) {
          if (!parent) {
            return new StateLoader(name);
          } else {
            return new NestedStateLoader(name, parent);
          }
        };

        return StateFactory;

      })();

      _stateFactory = new StateFactory;

      _parseNested = function(fullname) {
        var current, i, len, name, names, result;
        names = fullname.split(".");
        result = [];
        current = [];
        for (i = 0, len = names.length; i < len; i++) {
          name = names[i];
          if (!(name)) {
            continue;
          }
          current.push(name);
          result.push(current.join("."));
        }
        return result;
      };

      _parsePriority = function(previousPriority, currentPriority) {
        var animationState, currentPriorityHorisontal, currentPriorityVertical, prePriorityHorisontal, prePriorityVertical;
        prePriorityVertical = previousPriority[0];
        prePriorityHorisontal = previousPriority[1];
        currentPriorityVertical = currentPriority[0];
        currentPriorityHorisontal = currentPriority[1];
        if (prePriorityVertical < currentPriorityVertical) {
          return animationState = 0;
        } else if (prePriorityVertical > currentPriorityVertical) {
          return animationState = 1;
        } else if (prePriorityVertical === currentPriorityVertical) {
          if (prePriorityHorisontal < currentPriorityHorisontal) {
            return animationState = 2;
          } else if (prePriorityHorisontal > currentPriorityHorisontal) {
            return animationState = 3;
          }
        }
      };

      function StateMenager(config) {
        this.config = config;
        this.cache = {};
        this.selector = {};
        this.lastState = [];
      }

      StateMenager.prototype.load = function(setting) {
        var i, index, j, last, len, len1, names, param, parentAnimationOnStart, stateName, update;
        names = _parseNested(setting.state);
        param = setting.param;
        update = setting.update;
        last = null;
        parentAnimationOnStart = false;
        for (i = 0, len = names.length; i < len; i++) {
          stateName = names[i];
          if (stateName) {
            (function(_this) {
              return (function(stateName, current, currentConfig) {
                if (!current) {
                  return last = _this.cache[stateName] = _stateFactory.create(currentConfig.path, last);
                }
              });
            })(this)(stateName, this.cache[stateName], this.config.route[stateName]);
          }
        }
        for (index = j = 0, len1 = names.length; j < len1; index = ++j) {
          stateName = names[index];
          if (stateName) {
            (function(_this) {
              return (function(stateName, current, currentConfig, animate, isFirst) {
                var animationState, pre, preAnimate, preConfig, preStateName;
                if (!_this.selector[currentConfig.selector]) {
                  if (animate.allwaysStart || !parentAnimationOnStart) {
                    current.promise.then(function(init) {
                      current.view = currentConfig.init(init(param));
                      return animate.animation.first(current.view);
                    });
                    parentAnimationOnStart = true;
                  } else {
                    current.promise.then(function(init) {
                      return current.view = currentConfig.init(init(param));
                    });
                  }
                  current.state = "first";
                  return _this.selector[currentConfig.selector] = stateName;
                } else if (_this.selector[currentConfig.selector] !== stateName) {
                  preStateName = _this.selector[currentConfig.selector];
                  pre = _this.cache[preStateName];
                  preConfig = _this.config.route[preStateName];
                  preAnimate = _this.config[preConfig.selector];
                  pre.state = "replaced";
                  animationState = _parsePriority(preConfig.priority, currentConfig.priority);
                  switch (animationState) {
                    case 0:
                      preAnimate.animation.centerTop(pre.view, (function(destroy, view) {
                        return function() {
                          return destroy(view);
                        };
                      })(preConfig.destroy, pre.view));
                      break;
                    case 1:
                      preAnimate.animation.centerBottom(pre.view, (function(destroy, view) {
                        return function() {
                          return destroy(view);
                        };
                      })(preConfig.destroy, pre.view));
                      break;
                    case 2:
                      preAnimate.animation.centerLeft(pre.view, (function(destroy, view) {
                        return function() {
                          return destroy(view);
                        };
                      })(preConfig.destroy, pre.view));
                      break;
                    case 3:
                      preAnimate.animation.centerRight(pre.view, (function(destroy, view) {
                        return function() {
                          return destroy(view);
                        };
                      })(preConfig.destroy, pre.view));
                  }
                  current.promise.then(function(init) {
                    current.view = currentConfig.init(init(param));
                    switch (animationState) {
                      case 0:
                        return animate.animation.bottomCenter(current.view, (function(destroy, view) {
                          return function() {
                            return destroy(view);
                          };
                        })(currentConfig.destroy, current.view));
                      case 1:
                        return animate.animation.topCenter(current.view, (function(destroy, view) {
                          return function() {
                            return destroy(view);
                          };
                        })(currentConfig.destroy, current.view));
                      case 2:
                        return animate.animation.rightCenter(current.view, (function(destroy, view) {
                          return function() {
                            return destroy(view);
                          };
                        })(currentConfig.destroy, current.view));
                      case 3:
                        return animate.animation.leftCenter(current.view, (function(destroy, view) {
                          return function() {
                            return destroy(view);
                          };
                        })(currentConfig.destroy, current.view));
                    }
                  });
                  if (!(animate.allwaysStart || parentAnimationOnStart)) {
                    parentAnimationOnStart = true;
                  }
                  current.state = "replicate";
                  return _this.selector[currentConfig.selector] = stateName;
                } else if (_this.selector[currentConfig.selector] === setting.state && update) {
                  return currentConfig.update(current.view, update);
                }
              });
            })(this)(stateName, this.cache[stateName], this.config.route[stateName], this.config[this.config.route[stateName].selector], index === 0);
          }
        }
        return this.lastState = names;
      };

      return StateMenager;

    })();
  });

}).call(this);
