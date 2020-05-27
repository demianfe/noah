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
  req.paramList = @[]
  req.paramTable = initTable[string, string]()
  let bpath = split($req.url, "?")
  if bpath.len > 0:
    req.urlpath = split(bpath[0], "/")
    req.urlpath.delete(0)
  else: 
    req.urlpath = @[]
  if bpath.len > 1:
    let params = split(bpath[1], "&")
    for p in params:
      if p.contains("="):
        let line = p.split("=")
        req.paramTable[line[0]] = line[1]
      else:
        req.paramList.add(p)
  
  result.request = req
  result.response = res
  
# proc toString*(h: HttpHeaders): string =
#   result = ""
#   if h.len > 0:
#     for key, val in h.pairs:
#       echo key, ": ",  val
#       var values = ""
#       if val.len > 0:
#         for v in val:
#           values.add(v & ",")
#         values.delete(values.len - 1, values.len)
#       result.add(key & ": " & val & "\n")

proc prepareHeaders(headers: HttpHeaders): string =
  var indx = 0 
  if headers != nil and headers.len > 0:
    for k, v in headers.table:
      var h = k & ": " & v.join("; ")
      if indx < headers.table.len - 1:
        h = h & "\c\L"
      result = result & h
      indx += 1
