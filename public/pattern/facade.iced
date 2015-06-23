class QueryFacade
  
  find: (parent, selector) ->

    if $
      $ parent
        .find selector
    else
      parent.querySelectorAll selector


query = new QueryFacade

$ -> console.log query.find document, "a"