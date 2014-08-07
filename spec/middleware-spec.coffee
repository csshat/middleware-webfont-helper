# require main module (defined as `main` in package.json)
middleware = require '..'

# layer object to test on
layer = {}

# simulate next method of middleware chain
next = null

describe 'Webfont Helper middleware', ->
  beforeEach ->
    layer = { notifications: [] }
    next = jasmine.createSpy()

  it 'should do nothing for a non-text layer', ->
    middleware(layer, { enableTypekit: true, enableGoogleFonts: true }, next)

    waitsFor ->
      next.callCount > 0

    runs ->
      expect(layer).toEqual { notifications: [] }

  it 'should do nothing when font name is missing', ->
    layer.baseTextStyle = font: foo: 'bar'
    middleware(layer, { enableTypekit: true, enableGoogleFonts: true }, next)

    waitsFor ->
      next.callCount > 0

    runs ->
      expect(layer.notifications.length).toEqual 0

  it 'should find typekit font', ->
    layer.baseTextStyle = font: name: 'Proxima Nova'
    middleware(layer, { enableTypekit: true, enableGoogleFonts: false }, next)

    waitsFor ->
      next.callCount > 0

    runs ->
      expect(layer.notifications.length).toEqual 1

  it 'should find typekit font by removing spaces', ->
    layer.baseTextStyle = font: name: 'TisaPro'
    middleware(layer, { enableTypekit: true, enableGoogleFonts: false }, next)

    waitsFor ->
      next.callCount > 0

    runs ->
      expect(layer.notifications.length).toEqual 1

  it 'should normalize typekit font name', ->
    layer.baseTextStyle = font: name: 'Proxima Nova'
    middleware(layer, { enableTypekit: true, enableGoogleFonts: false }, next)

    waitsFor ->
      next.callCount > 0

    runs ->
      expect(layer.baseTextStyle.font.name).toEqual 'proxima-nova'

  it 'should find google font', ->
    layer.baseTextStyle = font: name: 'Droid Sans'
    middleware(layer, { enableTypekit: false, enableGoogleFonts: true }, next)

    waitsFor ->
      next.callCount > 0

    runs ->
      expect(layer.notifications.length).toEqual 1

  it 'should look for fonts in additional text styles', ->
    layer.textStyles = [
      font: name: 'Proxima Nova'
    ]
    middleware(layer, { enableTypekit: true, enableGoogleFonts: true }, next)

    waitsFor ->
      next.callCount > 0

    runs ->
      expect(layer.notifications.length).toEqual 1

  it 'should ignore additional text styles when they have no font property defined', ->
    layer.textStyles = [
      foo: bar: 'baz'
    ]
    middleware(layer, { enableTypekit: true, enableGoogleFonts: true }, next)

    waitsFor ->
      next.callCount > 0

    runs ->
      expect(layer.notifications.length).toEqual 0
