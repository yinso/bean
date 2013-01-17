
fs = require 'fs'
path = require 'path'
coffee = require 'coffee-script'

compile = (data) ->
  try
    evaled = coffee.eval(data)
    result = null
    if evaled instanceof Function
      result = JSON.stringify(evaled(), null, 2)
    else
      result = JSON.stringify(evaled, null, 2)
    result
  catch err
    console.error {error: err}
    throw error: err

makeTargetPath = (filePath) ->
  path.join path.dirname(filePath), path.basename(filePath, path.extname(filePath)) + '.json'

normalizePath = (filePath) ->
  if filePath.match /^\.\.?[\/\\]/
    # relative path
    path.join process.cwd(), filePath
  else
    filePath

main = ({source, noTarget}, cb) ->
  filePath = normalizePath source
  targetPath = makeTargetPath filePath
  
  fs.readFile filePath, (err, data) ->
    if err
      console.error {error: err}
      cb {error: err}
    else
      try
        result = compile(data.toString())
        if noTarget
          cb null, result
        else
          fs.writeFile targetPath, result, (err) ->
            if err
              console.error err
              cb err
            else
              console.log "saved to #{targetPath}"
              cb null, result
      catch e
        console.error e
        cb e

module.exports =
  run: main
