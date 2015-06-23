class SuperHistory
  constructor: ->
    @path = "#"
    @commands = [ ]

  execute: (command) ->
    @path = command.execute @path
    @commands.push command

  undo: ->
    command = @commands.pop()
    @path = command.undo @path

class Deep
  constructor: (@path) ->
    @execute = (path) -> path + "/" + @path
    @undo = (path) -> path.slice 0, path.indexOf(@path)-1


superHistory = new SuperHistory

superHistory.execute new Deep "parent"

superHistory.execute new Deep "child"

superHistory.undo()