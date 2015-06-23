(function() {
  var hasProp = {}.hasOwnProperty;

  define(function() {

    /*
    
    Модель роутинга:
     */
    var Router;
    return Router = (function() {

      /*
      
      2) На основе конфига создается классы с видами:
        1) Хранятся в общем объекте коллекции под уникальным именем;
       */
      var AnimationsController, LoadManager, RouterController, RouterCoordinator, State, StatesCollection;

      State = (function() {
        function State(url, position, init, update, destroy) {
          this.url = url;
          this.position = position;
          this.init = init;
          this.update = update;
          this.destroy = destroy;
          this.instance = null;
          this.view = null;
        }

        State.prototype.get = function(callback) {
          if (this.instance) {
            return callback(this.instance);
          } else {
            return require([this.url], (function(_this) {
              return function(instance) {
                if (_this.url === "view/plugin/plugin-view") {
                  return setTimeout(function() {
                    return callback(_this.instance = instance);
                  }, 300);
                } else if (_this.url === "view/plugin/main/main-view") {
                  return setTimeout(function() {
                    return callback(_this.instance = instance);
                  }, 900);
                } else if (_this.url === "view/contact/contact-view") {
                  return setTimeout(function() {
                    return callback(_this.instance = instance);
                  }, 600);
                } else {
                  return callback(_this.instance = instance);
                }
              };
            })(this));
          }
        };

        return State;

      })();

      StatesCollection = (function() {
        function StatesCollection(statesConfig) {
          var stateConfig, stateName;
          for (stateName in statesConfig) {
            stateConfig = statesConfig[stateName];
            this[stateName] = new State(stateConfig.url, stateConfig.position, stateConfig.init, stateConfig.update, stateConfig.destroy);
          }
        }

        StatesCollection.prototype.find = function(requiredStateName) {
          var stateConfig, stateName;
          for (stateName in this) {
            if (!hasProp.call(this, stateName)) continue;
            stateConfig = this[stateName];
            if (requiredStateName === stateName) {
              return stateConfig;
            }
          }
        };

        return StatesCollection;

      })();


      /*
      
      3) Объект предоставляющий текущее состояние роутера:
        1) Хранит и обновляет текущее состояние роутера;
       */

      RouterCoordinator = (function() {
        function RouterCoordinator(statesConfig) {}

        return RouterCoordinator;

      })();


      /*
      
      4) Выстраивается два объекта каллбеков с зависимостями:
        1) Зависимости при загрузке от родительского;
        2) Зависимости от анимации родительского;
       */

      LoadManager = (function() {
        var Observer;

        Observer = (function() {
          function Observer() {
            this.loads = [];
          }

          Observer.prototype.add = function(callback) {
            return this.loads.push(callback);
          };

          Observer.prototype.run = function() {
            var callback, i, len, ref;
            ref = this.loads;
            for (i = 0, len = ref.length; i < len; i++) {
              callback = ref[i];
              callback();
            }
            return this.loads.length = 0;
          };

          return Observer;

        })();

        function LoadManager(config) {
          var name, params;
          this.status = {};
          this.observers = {};
          for (name in config) {
            params = config[name];
            this.observers[name] = new Observer;
          }
        }

        LoadManager.prototype.onready = function(routeName, callback) {
          var parent, parentIndex;
          parentIndex = routeName.lastIndexOf(">");
          if (parentIndex !== -1) {
            parent = routeName.slice(0, parentIndex);
            if (this.status[parent] === "loaded") {
              this.status[routeName] = "loaded";
              callback();
              return this.observers[routeName].run();
            } else {
              return this.observers[parent].add((function(_this) {
                return function() {
                  callback();
                  return _this.observers[routeName].run();
                };
              })(this));
            }
          } else {
            this.status[routeName] = "loaded";
            callback();
            return this.observers[routeName].run();
          }
        };

        return LoadManager;

      })();


      /*
      
      5) Анимационный движок:
        1) Хранит функции анимаций;
        2) Выполняет анимацию в зависимости от priority;
        3) Проверяет свойства alwaysRun и запускает анимации для дочерних;
        4) Проверяет свойство inOrder и проводит анимации в порядке;
       */

      AnimationsController = (function() {
        function AnimationsController(config) {}

        return AnimationsController;

      })();


      /*
      
      1) Главный контролирующий загрузки и анимации объект:
        1) Берет объект каллбеков загрузки и пользуется им;
        2) Берет объект каллбеков анимаций и пользуется им;
       */

      RouterController = (function() {
        function RouterController(routesConfig) {
          this.states = new StatesCollection(routesConfig);
          this.loadManager = new LoadManager(routesConfig);
        }

        RouterController.prototype.perform = function(routes, params) {
          var results, routeName, routeParam;
          results = [];
          for (routeName in routes) {
            routeParam = routes[routeName];
            results.push((function(_this) {
              return function(routeName, routeParam) {
                var currentState;
                switch (routeParam) {
                  case "first":
                    currentState = _this.states.find(routeName);
                    return currentState.get(function(instance) {
                      currentState.view = currentState.init(instance(params[routeName]));
                      return _this.loadManager.onready(routeName, function() {
                        return console.log("#loaded", routeName, currentState.view);
                      });
                    });
                  case "update":
                    return 2;
                  case "new":
                    return 3;
                  case "last":
                    return 4;
                  case "old":
                    return 5;
                }
              };
            })(this)(routeName, routeParam));
          }
          return results;
        };

        return RouterController;

      })();

      function Router(statesConfig, animationsConfig) {
        this.routerController = new RouterController(statesConfig);
      }

      Router.prototype.go = function(requiredStates) {

        /*
        "id-1:plugin": "first", "id-1:plugin>id-2:main".slice("id-1:plugin>id-2:main".lastIndexOf(">", "id-1:plugin>id-2:main".lastIndexOf(">")-1)+1): "first", "id-1:plugin>id-2:list": "unused", "id-1:plugin>id-2:main>id-3:info": "first", "id-1:contact": "unused"
        "id-1:plugin": "update", "id-1:plugin>id-2:main": "last", "id-1:plugin>id-2:list": "unused", "id-1:plugin>id-2:main>id-3:info": "last", "id-1:contact": "unused"
         */
        this.routerController.perform({
          "id-1:plugin": "first",
          "id-1:plugin>id-2:main": "first"
        }, requiredStates);
        return this.routerController.perform({
          "id-1:plugin": "first",
          "id-1:plugin>id-2:list": "first"
        }, requiredStates);
      };

      return Router;

    })();
  });

}).call(this);
