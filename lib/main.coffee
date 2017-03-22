helpers = null

module.exports =
  config:
    exePath:
      type: 'string'
      default: 'dolo-lint'
    maxLineLength:
      type: 'integer'
      default: 0
    ignoreErrorCodes:
      type: 'array'
      default: []
      description: 'Highlights errors for dolo files.'

  activate: ->
    require('atom-package-deps').install('linter-dolo')

  provideLinter: ->
    provider =
      name: 'dolo-lint'
      grammarScopes: ['source.yaml']
      scope: 'file' # or 'project'
      lintOnFly: true # must be false for scope: 'project'
      lint: (textEditor)->
        helpers ?= require('atom-linter')
        filePath = textEditor.getPath()
        parameters = ['--format=json']
        parameters.push('-')
        return helpers.exec(atom.config.get('linter-dolo.exePath'), parameters, {stdin: textEditor.getText()}).then (result) ->
          toReturn = []
          tt = JSON.parse(result)
          for el in JSON.parse(result)
              toReturn.push({
                type: el['type']
                text: el['text']
                filePath
                range: el['range']
              })
          return toReturn
        #   regex = /stdin:\((\d+), (\d+), (\d+), (\d+)\):(.*)/g

        #   while (match = regex.exec(result)) isnt null
        #     line_0 = parseInt(match[1]) or 0
        #     col_0 = parseInt(match[2]) or 0
        #     line_1 = parseInt(match[3]) or 0
        #     col_1 = parseInt(match[4]) or 0
        #     toReturn.push({
        #       type: msgtype
        #       text: match[5]
        #       filePath
        #       range: [[line_0, col_0], [line_1, col_1]]
        #     })
        #   console.log(result)
        #   toReturn = [
        #     {
        #         type: 'error'
        #         text:"My custom error"
        #         filePath
        #         range: [[11,5],[11,11]]
        #     },
        #     {
        #         type: 'warning'
        #         text:"My custom warning"
        #         filePath
        #         range: [[18,5],[18,11]]
        #     },
        #     {
        #         text:"My cusom info"
        #         type: 'info'
        #         filePath
        #         range: [[26,5],[26,11]]
        #         fix: {
        #                   range: Range,
        #                   newText: "he"
        #         #   oldText?: string
        #             }
        #     }
        #   ]
        #   return toReturn
