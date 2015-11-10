fs = require('fs')
stat = require('node-static')
url = require('url')
httpProxy = require('http-proxy')

walletPath = process.env.WALLET_PATH
shellblockdUrl = process.env.SHELLBLOCKD_URL
port = 8080


if fs.existsSync(walletPath)
  console.log "Serving wallet from '#{walletPath}'."
  console.log "Connecting to Shellblockd at '#{shellblockdUrl}'."

  fileServer = new stat.Server(walletPath)
  proxy = httpProxy.createProxyServer()
  proxy.on 'error', (error, req, res) ->
    console.log 'proxy error', error
    if !res.headersSent
      res.writeHead 500, 'content-type': 'application/json'

    json = error: 'proxy_error', reason: error.message
    res.end JSON.stringify(json)

  require('http').createServer((req, res) ->
    console.log "'#{req.url}'"
    if req.url == '/servers.json'
      res.end JSON.stringify(servers: [])
    else if req.url.match(/^\/_api/)
      req.url = req.url.replace(/^\/_api/, '/api')
      req.url += '/' if req.url == '/api'
      console.log "proxying to '#{shellblockdUrl}#{req.url}'"
      proxy.web req, res, target: shellblockdUrl
    else
      req.addListener('end', ->
        fileServer.serve(req, res)
      ).resume()
  ).listen(port)
  console.log "Listening at http://0.0.0.0:#{port}"
else
  console.log "Wallet path not found '#{walletPath}', set via WALLET_PATH."
  process.exit 1

