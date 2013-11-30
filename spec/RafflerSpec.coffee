describe 'Raffler Class', ->
  it "(the class) should exist", ->
    expect(Raffler).toBeDefined()

  it "(the model) should exist",->
    expect(Raffler.Models.Entry).toBeDefined()

  it "(the collection) should exist",->
    expect(Raffler.Collections.Entries).toBeDefined()

  describe "Default values test", ->

    testperson = new Raffler.Models.Entry

    it "should set the default value of winner to false", ->
      expect(testperson.attributes.winner).toEqual false
    
    it "should set the default value of name to blank", ->
      expect(testperson.attributes.name).toEqual ''

  describe "Adding an entry", ->

    it "should increase the number of items in the collection by one", ->
      @collection = new Raffler.Collections.Entries()
      @collection.fetch()
      count = @collection.length

      @collection.create name: 'Tim'
      @collection.fetch()
      count2 = @collection.length
      expect(count2).toEqual count + 1

    it "should render the new number of items on the page", ->
      @collection = new Raffler.Collections.Entries()      
      @collection.fetch()
      count3=@collection.length - 1
      expect($(entry_table).children().length).toEqual count3

  describe "clearing all winners", ->
      it "should clear all previous winners", ->
        $(reset).trigger 'click'
        @collection = new Raffler.Collections.Entries()      
        @collection.fetch()
        expect(@collection.models.winner).not.toEqual true

  describe "Drawing a winner", ->
      it "should randomly select an entry and set the value of winner to true", ->
        $(draw).trigger 'click'
        @collection = new Raffler.Collections.Entries()      
        @collection.fetch()
        expect(@collection.models.winner).not.toEqual false
