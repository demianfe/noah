## A web context protocol that encapsulates the request and response

import httpcore, strutils, uri, asynchttpserver, tables

type    
  WRequest* = ref object
    ## Request encapsulation protocol
    hostname*, body*: string
    protocol*: tuple[orig: string, major, minor: int]
    reqMethod*: HttpMethod
    headers*: HttpHeaders
    url*: Uri
    urlpath*: seq[string]
    paramList*: seq[string]
    paramTable*: Table[string, string]
        
  WResponse* = ref object
    ## Response encapsulation Protocol
    status*: HttpCode
    headers*: HttpHeaders
    body*: string
    
  WebContext* = ref object
    request*: WRequest
    response*: WResponse
    

proc `$`*(r: WRequest): string =
  if r.hostname != "":
    result = "hostname: " & r.hostname
  if $r.reqMethod != "":
    result = result & " , method: " & $r.reqMethod
  if $r.url != "":
    result = result & " , url: " & $r.url
  #if $r.headers != "":
  result = result & " , headers: " & $r.headers
  if $r.protocol != "":
    result = result & " , protocol" & $r.protocol
  if $r.urlpath != "":
    result = result & " , urlpath: " & $r.urlpath
  if $r.paramList != "":
    result = result & " , paramList: " & $r.paramList
  if $r.paramTable != "":
    result = result & " , paramTable: " & $r.paramTable
  if r.body != "":
    result = result & " , body: " & $r.body
    

proc `$`*(r: WResponse): string =
  result = "status: " & $r.status & " ,headers: " & $r.headers &
    " , body: " & r.body

proc `$`*(c: WebContext): string =
  result = "WebContext:"
  if not c.request.isNil:
    result = result & " \nRequest: " & $c.request
  if not c.response.isNil:
    result = result & "\nResponse: " & $c.response


proc copy*(c: WebContext): WebContext =
  result = new WebContext
  var
    req = c.request
    res = c.response
  result.request = req
  result.response = res
  
