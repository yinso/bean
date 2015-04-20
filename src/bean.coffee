
fs = require 'fs'
path = require 'path'
coffee = require 'coffee-script'
jsyaml = require 'js-yaml'

readFile = (filePath, cb) ->
  fs.readFile filePath, 'utf8', (err, data) ->
    if err
      cb err
    else
      try
        cb null, compile(filePath, data)
      catch e
        cb e

readFileSync = (filePath) ->
  data = fs.readFileSync filePath, 'utf8'
  config = compile filePath, data
  config

compile = (filePath, data) ->
  ext = path.extname(filePath)
  if ext == '.yml' or ext == '.yaml'
    compileYaml data
  else
    compileCoffee data 

compileYaml = (data) ->
  try
    jsyaml.safeLoad(data)
  catch e
    console.error {error: e}
    throw error: e

compileCoffee = (data) ->  
  try
    evaled = coffee.eval(data)
    if evaled instanceof Function
      evaled()
    else
      evaled
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
        result = JSON.stringify(compile(filePath, data.toString()), null, 2)
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
  readFile: readFile
  readFileSync: readFileSync
  compile: compile
