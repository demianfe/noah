import httpcore, strutils, uri, tables
import asynchttpserver
import webcontext

export webcontext

proc createWebContext*(r: Request): WebContext =
  ## Creates and encapsulates a new WebContext from a
  ## Request   
  result = new WebContext
  var req = new WRequest
  var res  = new WResponse
  req.body = r.body 
  req.hostname = r.hostname
  req.reqMethod = r.reqMethod
  req.url = r.url
  req.headers = r.headers
  req.protocol = r.protocol
  res.status = Http200
  res.headers = r.headers
  res.body = ""
  
  result.request = req
  result.response = res
