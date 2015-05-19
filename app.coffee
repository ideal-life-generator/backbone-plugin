define [
  "global/render.template"
  "global/loader.view"
  "plugin/phone.mask"
  "component/field/first.name"
  "component/field/last.name"
  "component/field/mobile"
  "component/field/age"
  "component/field/gender"
  "plugin/route"
], (
  RenderTemplate
  LoaderView
  PhoneMask
  FirstName
  LastName
  Mobile
  Age
  Gender
  Route
) ->

  $(->

    route = new Route
      "product":
        path: "page/product/view"
        initialize: (ProductView) ->
          console.log "product initialize"
          new ProductView
        first: (productView) ->
          console.log "product first"
          $(".product-view-container").append(productView.$el)
          TweenLite.to productView.$el, 0.6, css: opacity: 1
        last: (productView) ->
          console.log "product list last"
          TweenLite.to productView.$el, 1,
            css: opacity: 0
            onComplete: -> productView.remove()
        show: (productView) ->
          console.log "product show"
          TweenLite.fromTo productView.$el, 1,
              display: "block"
            ,
              css: opacity: 1
        hide: (productView) ->
          console.log "product hide"
          TweenLite.to productView.$el, 1,
            css: opacity: 0
            onComplete: ->
              productView.$el.css({ display: "none" })
      "product.list":
        path: "page/product/list/view"
        initialize: (ProductListView) ->
          console.log "product list initialize"
          new ProductListView
        first: (productListView) ->
          console.log "product list first"
          $(".list-view-container").append(productListView.$el)
          TweenLite.to productListView.$el, 1, css: opacity: 1
        last: (productListView) ->
          console.log "product list last"
          TweenLite.to productListView.$el, 1,
            css: opacity: 0
            onComplete: -> productListView.remove()
        show: (productListView) ->
          console.log "product list show"
          TweenLite.fromTo productListView.$el, 1,
              display: "block"
            ,
              css: opacity: 1
        hide: (productListView) ->
          console.log "product list hide"
          TweenLite.to productListView.$el, 1,
            css: opacity: 0
            onComplete: ->
              productListView.$el.css({ display: "none" })
      "product.list.info":
        path: "page/product/list/info/view"
        initialize: (ProductListInfoView, params) ->
          console.log "product list info initialize"
          productListInfoView = new ProductListInfoView
          productListInfoView.$el.append("<h3>#{params['info-id']}</h3>")
          productListInfoView
        first: (productListInfoView) ->
          console.log "product list info first"
          $(".info-view-container").append(productListInfoView.$el)
          TweenLite.to productListInfoView.$el, 1, css: opacity: 1
        last: (productListInfoView) ->
          console.log "product list info last"
          TweenLite.to productListInfoView.$el, 1,
            css: opacity: 0
            onComplete: -> productListInfoView.remove()
        show: (productListInfoView) ->
          console.log "product list info show"
          TweenLite.fromTo productListInfoView.$el, 1,
              display: "block"
            ,
              css: opacity: 1
        hide: (productListInfoView) ->
          console.log "product list info hide"
          TweenLite.to productListInfoView.$el, 1,
            css: opacity: 0
            onComplete: ->
              productListInfoView.$el.css({ display: "none" })
      "contact":
        path: "page/contact/view"
        initialize: (ContactView) ->
          console.log "contact initialize"
          new ContactView
        first: (contactView) ->
          console.log "contact first"
          $(".product-view-container").append(contactView.$el)
          TweenLite.to contactView.$el, 0.6, css: opacity: 1
        last: (contactView) ->
          console.log "contact list last"
          TweenLite.to contactView.$el, 1,
            css: opacity: 0
            onComplete: -> contactView.remove()
        show: (contactView) ->
          console.log "contact show"
          TweenLite.fromTo contactView.$el, 1,
              display: "block"
            ,
              css: opacity: 1
        hide: (contactView) ->
          console.log "contact hide"
          TweenLite.to contactView.$el, 1,
            css: opacity: 0
            onComplete: ->
              contactView.$el.css({ display: "none" })

    PageRoute = Backbone.Router.extend
      routes:
        "product": ->
          route.load
            state: "product"
        "product/list": ->
          route.load
            state: "product.list"
        "product/list/info-:id": (id) ->
          route.load
            state: "product.list.info"
            init:
              "product.list.info":
                "info-id": id
        "contact": ->
          route.load
            state: "contact"

    new PageRoute

    persons = [
        id: 0, first_name: "Vladislav", last_name: "Tkachenko", phone: "+380936124991", gender: "male", age: "27"
      ,
        id: 1, first_name: "Kristina", last_name: "Tkachenko", phone: "", gender: "female", age: "21"
    ]

    UserModel = Backbone.Model.extend
      url: "/documents/7/notes/101"
      defaults: ->
        first_name: new String
        last_name: new String
        phone: new String
        age: new String
        gender: new String

    UserView = Backbone.View.extend
      tagName: "div"
      className: "my-tr"
      template: _.template "
        <div class=\"my-td\">
          <span>{first_name}</span>
        </div>
        <div class=\"my-td\">
          <span>{last_name}</span>
        </div>
        <div class=\"my-td\">
          <span>{phone}</span>
        </div>
        <div class=\"my-td\">
          <span>{age}</span>
        </div>
        <div class=\"my-td\">
          <span>{gender}</span>
        </div>
        <div class=\"my-td\">
          <button class=\"button tiny radius expand\">
             Delete
          </button>
        </div>
      "
      events:
        "click button": ->
          @model.destroy()

      render: ->
        @$el.append @template @model.toJSON()

      initialize: ->
        @listenTo @model, "destroy", @remove
        @render()

    UsersCollection = Backbone.Collection.extend
      model: UserModel
      comparatorProp: "first_name"

      comparator: (user) ->
        user.get @comparatorProp
          .toLowerCase()

      setComparator: (propName) ->
        @comparatorProp = propName
        @sort()

    UsersView = Backbone.View.extend
      el: "#user-list"
      collection: new UsersCollection persons

      events:
        "click #first-name-header": ->
          @collection.setComparator "first_name"
        "click #last-name-header": ->
          @collection.setComparator "last_name"
        "click #phone-header": ->
          @collection.setComparator "phone"
        "click #age-header": ->
          @collection.setComparator "age"
        "click #gender-header": ->
          @collection.setComparator "gender"
        "click #create-user-header": ((params) =>
          ->
            if @creationMenuActive
              @creationMenuActive = off
              params.height = @$creationMenuWrap.height()
              TweenLite.to params, 0.3,
                onStart: =>
                  @$creationMenuWrap.css perspective: "1600px", transformStyle: "preserve-3d"
                height: 0
                opacity: 0
                translateY: -47
                translateZ: -23.5
                rotateX: 90
                ease: Power0.easeInOut
                onUpdate: =>
                  @$creationMenuWrap.css height: "#{params.height}px"
                  @$creationMenu.css opacity: params.opacity, transform: "translateY(#{params.translateY}%) translateZ(#{params.translateZ}px) rotateX(#{params.rotateX}deg)"
                onComplete: =>
                  @$creationMenuWrap.css perspective: "", transformStyle: ""
                  @$creationMenu.css opacity:"", transform: ""
            else
              @creationMenuActive = on
              TweenLite.to params, 0.3,
                onStart: =>
                  @$creationMenuWrap.css perspective: "1600px", transformStyle: "preserve-3d"
                height: @$creationMenu.height()
                opacity: 1
                translateY: 0
                translateZ: 0
                rotateX: 0
                ease: Power0.easeInOut
                onUpdate: =>
                  @$creationMenuWrap.css height: "#{params.height}px"
                  @$creationMenu.css opacity: params.opacity, transform: "translateY(#{params.translateY}%) translateZ(#{params.translateZ}px) rotateX(#{params.rotateX}deg)"
                onComplete: =>
                  @$creationMenuWrap.css perspective: "", transformStyle: "", height: "100%"
                  @$creationMenu.css transform: ""
                  @firstName.$el.focus()
        )(height: 0, opacity: 0, translateY: -47, translateZ: -23.5, rotateX: 90)

        "click #add-user": ->
          firstName = @firstName.getValue()
          lastName = @lastName.getValue()
          mobile = @mobile.getValue()
          age = @age.getValue()
          gender = @gender.getValue()
          if firstName and lastName and mobile and age and gender
            @collection.create
              first_name: firstName
              last_name: lastName
              phone: mobile
              age: age
              gender: gender

      addUser: (user) ->
        userView = new UserView model: user
        @$list.prepend userView.$el

      render: ->
        @$list.empty()
        @collection.each (user) ->
          userView = new UserView model: user
          @$list.append userView.$el
        , @

      initialize: ->
        @$list = @$el.find("#list")
        @$creationMenu = @$el.find("#creation-menu")
        @$creationMenuWrap = @$creationMenu.parent("#creation-menu-wrap")

        @firstName = new FirstName el: $("#first-name")
        @lastName = new LastName el: $("#last-name")
        @mobile = new Mobile el: $("#phone")
        @age = new Age el: $("#age")
        @gender = new Gender el: $("#gender")

        @listenTo @collection, "sort", @render
        @listenTo @collection, "add", @addUser
        @render()

    new UsersView
  
    Backbone.history.start()
  
  )