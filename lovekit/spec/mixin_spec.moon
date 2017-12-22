
import restore from require "spec.helpers"
import insert from table

local mixin

describe "mixins", ->
  setup ->
    _G.love = setmetatable {}, __index: =>
    import mixin from require "lovekit.mixins"

  teardown restore

  it "should mixin mixins", ->
    log = {}

    class Mixin
      new: =>
        insert log, "initializing Mixin"
        @thing = { "hello" }

      poop: =>

      add_one: (num) =>
        insert log, "Before add_one (Mixin), #{num}"

    class Mixin2
      new: =>
        insert log, "initializing Mixin2"

      add_one: (num) =>
        insert log, "Before add_one (Mixin2), #{num}"

    class One
      mixin Mixin
      mixin Mixin2

      add_one: (num) =>
        num + 1

      new: =>
        insert log, "initializing One"

    o = One!
    assert.equal o\add_one(12), 13
    assert.same log, {
      "initializing One"
      "initializing Mixin"
      "initializing Mixin2"
      "Before add_one (Mixin2), 12"
      "Before add_one (Mixin), 12"
    }


  it "should handle mixin method conflict", ->
    items = {}

    class MyMixin
      @merge_methods: (name, existing, new) =>
        (...) =>
          table.insert items, "Before"
          existing @, ...
          table.insert items, "After"

      thinger: (...) =>
        error "implement in receiver"

    class MyThing
      mixin MyMixin

      thinger: ->
        table.insert items, "Cows"

    thing = MyThing!
    thing\thinger!

    assert.same {"Before", "Cows", "After"}, items

