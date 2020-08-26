import httpcore, strutils, uri, tables, options
import httpbeast
import webcontext

export webcontext

proc createWebContext*(r: Request): WebContext =
  ## Creates and encapsulates a new WebContext from a
  ## Request
  result = new WebContext
  var req = new WRequest
  var res  = new WResponse
  req.hostname = r.ip
  req.reqMethod = r.httpMethod.get()
  req.url = Uri(path: r.path.get())
  req.headers = r.headers.get()
  if req.reqMethod != HttpGet:
    req.body = r.body.get()
  #req.protocol = 
  res.status = Http200
  res.headers = req.headers
  res.body = ""  
  result.request = req
  result.response = res

proc prepareHeaders(headers: HttpHeaders): string =
  var indx = 0 
  if headers != nil and headers.len > 0:
    for k, v in headers.table:
      var h = k & ": " & v.join("; ")
      if indx < headers.table.len - 1:
        h = h & "\c\L"
      result = result & h
      indx += 1
  
proc toString*(h: HttpHeaders): string =
  result = prepareHeaders h

proc send*(req: Request, ctxt: WebContext) =
  # wraps httpbeast req.send()
  # FIXME: bogus request using same httpclient kills the service
  let res = ctxt.response
  var h = res.headers
  h["Content-Length"] = $ctxt.response.body.len
  let headers = prepareHeaders(h)
  req.send(res.status, res.body, headers)

