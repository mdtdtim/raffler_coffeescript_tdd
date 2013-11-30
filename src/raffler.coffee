window.Raffler =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: -> 
    new Raffler.Routers.Entries
    Backbone.history.start()

class Raffler.Models.Entry extends Backbone.Model
  defaults: 
    name:''
    winner: false

class Raffler.Collections.Entries extends Backbone.Collection
  model:  Raffler.Models.Entry
  localStorage:  new Store("second-backbone-coffee-raffle")

class Raffler.Views.EntriesIndex extends Backbone.View
  template:  _.template($('#item-template').html())
  events:
    'click #new' : 'createEntry'
    'click #draw' : 'drawWinner'
    'click #reset' : 'resetWinners'
    'click li': 'kill'
  initialize: ->
    @collection.on('sync', @render, this)
    @collection.on('add', @render, this)
    @collection.on('change', @render, this)
    @collection.on('destroy', @render, this)
  render: ->
    $(@el).html(@template(entries: @collection.toJSON()))
    this
  drawWinner: ->
    console.log "draw winner 1"
    @collection.drawWinner()
  createEntry: ->
    console.log "create entry"
    @collection.create name: $('#new_entry').val()
  drawWinner: ->
    console.log "draw winner 2"
    winner = @collection.shuffle()[0]
    if winner
      winner.set(winner:true)
      winner.save()
  kill: (ev) ->
    console.log $(ev.target).attr('id')
    item=@collection.find (model) ->
      model.get("id") is $(ev.target).attr('id')
    item.destroy()
  resetWinners: ->
    console.log "resetting winners"
    for winner in @collection.models then do =>
       winner.set(winner:false)
       winner.save()

class Raffler.Routers.Entries extends Backbone.Router
  routes:
    '': 'index'
    'entries/:id': 'show'
  initialize: ->
    @collection = new Raffler.Collections.Entries()
    @collection.fetch()             
  index: ->
    view = new Raffler.Views.EntriesIndex(collection: @collection)
    $('#container').html(view.render().el)
  show:  (id) ->
    console.log "Entry #{id}"

$(document).ready ->
  Raffler.init()