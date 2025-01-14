const LibName =
  when defined(MACOSX):
    "liblua5.4.dylib"
  elif defined(UNIX):
    "liblua5.4.so(|.0)"
  else:
    "liblua5.4.dll"

const
  OriginalLuaCopyright* = "Copyright © 1994–2024 Lua.org, PUC-Rio."
  LuaHomepage* = "https://www.lua.org/"
  LuaLicensePage* = "https://www.lua.org/license.html"

type
  LuaState* = pointer
  KContext* = pointer
  Kfunction* = proc(state: LuaState, status: cint, ctx: KContext) {.cdecl.}
  TCFunction* = proc (state: LuaState): cint {.cdecl.}

  ChunkReader* = proc(state: LuaState, ud: pointer, sz: ptr cint): cstring {.cdecl.}
  ChunkWriter* = proc(state: LuaState, p: pointer, sz: cint, ud: pointer): cint {.cdecl.}
  Alloc* = proc(ud, thePtr: pointer, oSize, nSize: cint) {.cdecl.}
  
  LuaType* {.pure.} = enum
      None = -1
      Nil = 0
      Boolean = 1
      LightUserData = 2
      Number = 3
      String = 4
      Table = 5
      Function = 6
      UserData = 7
      Thread = 8
      MinStack = 20

  LuaNumber* = float64
  LuaInteger* = int64

  NativeFunction* = proc(state: LuaState): cint {.cdecl.}

  StatusCode* {.pure.} = enum
      Ok = 0
      Yield = 1
      ErrRun = 2
      ErrSyntax = 3
      ErrMem = 4
      ErrErr = 5
    
const
  MultiReturn* = -1
  RegistryIndex* = -10000
  EnvironmentIndex* = -10001
  GlobalStackIndex* = -10002


{.pragma: plua, importc: "lua_$1".}
{.pragma: pLlua, importc: "luaL_$1".}

{.push callConv: cdecl, dynlib: LibName.}

proc getglobal*(state: LuaState, name: cstring): cint {.plua.}
proc getfield*(state: LuaState, idx: cint, name: cstring): cint {.plua.}
proc gettable*(state: LuaState, idx: cint): cint {.plua.}
proc rawget*(state: LuaState, idx: cint): cint {.plua.}
proc rawgeti*(state: LuaState, idx: cint, n: cint): cint {.plua.}
proc rawgetp*(state: LuaState, idx: cint, p: pointer): cint {.plua.}
proc createtable*(state: LuaState, narr: cint, nrec: cint) {.plua.}
proc newuserdatauv*(state: LuaState, sz: csize_t, nuvalue: cint): pointer {.plua.}
template newuserdata*(state: LuaState, sz: csize_t): pointer = newuserdatauv(state, sz, 1)
proc getmetatable*(state: LuaState, idx: cint): cint {.plua.}
proc getiuservalue*(state: LuaState, idx: cint, n: cint): cint {.plua.}
template getuservalue*(state: LuaState, idx: cint): cint = getiuservalue(state, idx, 1)

proc setglobal*(state: LuaState, name: cstring) {.plua.}
proc setfield*(state: LuaState, idx: cint, name: cstring) {.plua.}
proc settable*(state: LuaState, idx: cint) {.plua.}
proc rawset*(state: LuaState, idx: cint) {.plua.}
proc rawseti*(state: LuaState, idx: cint; n: LuaInteger) {.plua.}
proc rawsetp*(state: LuaState, idx: cint; p: pointer) {.plua.}
proc setmetatable*(state: LuaState, objindex: cint): cint {.plua.}
proc setiuservalue*(state: LuaState, idx: cint, n: cint): cint {.plua.}
template setuservalue*(state: LuaState, idx: cint): cint = setiuservalue(state, idx, 1)


proc isinteger*(state: LuaState, idx: cint): cint {.plua.}
proc isnumber*(state: LuaState, idx: cint): cint {.plua.}
proc isstring*(state: LuaState, idx: cint): cint {.plua.}
proc iscfunction*(state: LuaState, idx: cint): cint {.plua.}
proc isuserdata*(state: LuaState, idx: cint): cint {.plua.}

proc tonumberx*(state: LuaState, idx: cint, isnum: ptr cint): LuaNumber {.plua.}
template tonumber*(state: LuaState, idx: cint): LuaNumber = tonumberx(state, idx, nil)

proc tointegerx*(state: LuaState, idx: cint, isnum: ptr cint): LuaNumber {.plua.}
template tointeger*(state: LuaState, idx: cint): LuaNumber = tointegerx(state, idx, nil)

proc toboolean*(state: LuaState, idx: cint): cint {.plua.}
proc tolstring*(state: LuaState, idx: cint): cstring {.plua.}
proc rawlen*(state: LuaState; idx: cint): csize_t {.plua.}
proc tocfunction*(state: LuaState, idx: cint): NativeFunction {.plua.}
proc touserdata*(state: LuaState, idx: cint): pointer {.plua.}
proc topointer*(state: LuaState, idx: cint): pointer {.plua.}

proc luatype*(state: LuaState, idx: cint): cint {.plua, importc: "lua_type".}

proc callk*(state: LuaState, nargs: cint, nret: cint, ctx: KContext, k: Kfunction): cint {.plua.}
template call*(state: LuaState, nargs: cint, nret: cint): cint = callk(state, nargs, nret, nil, nil)
proc pcallk*(state: LuaState, nargs: cint, nret: cint, msgh: cint, ctx: KContext, k: Kfunction): cint {.plua.}
template pcall*(state: LuaState, nargs: cint, nret: cint, msgh: cint): cint = pcallk(state, nargs, nret, msgh, nil, nil)

proc absindex*(state: LuaState, idx: cint): cint {.plua.}
proc gettop*(state: LuaState): cint {.plua.}
proc settop*(state: LuaState, idx: cint) {.plua.}
proc pushvalue*(state: LuaState, idx: cint) {.plua.}
proc rotate*(state: LuaState, idx: cint, n: cint) {.plua.}
proc copy*(state: LuaState, fromidx: cint, toidx: cint) {.plua.}
proc checkstack*(state: LuaState, sz: cint): cint {.plua.}
proc xmove*(src: LuaState, dst: LuaState, n: cint) {.plua.}

template pop*(state: LuaState, n: cint) = settop(state, -n-1)
template insert*(state: LuaState, idx: cint) = rotate(state, idx, 1)
template remove*(state: LuaState, idx: cint) =
  rotate(state, idx, -1)
  pop(state, 1)
template replace*(state: LuaState, idx: cint) =
  copy(state, -1, idx)
  pop(state, 1)

proc pushinteger*(state: LuaState, n: LuaInteger) {.plua.}
proc pushnumber*(state: LuaState, n: LuaNumber) {.plua.}
proc pushnil*(state: LuaState) {.plua.}
proc pushlstring*(state: LuaState, s: cstring, len: csize_t): cstring {.plua.}
proc pushstring*(state: LuaState, s: cstring): cstring {.plua.}
proc pushvfstring*(state: LuaState, fmt: cstring): cstring {.plua, varargs.}
proc pushfstring*(state: LuaState, fmt: cstring): cstring {.plua, varargs.}
proc pushcclosure*(state: LuaState, fn: TCFunction; n: cint) {.plua.}
proc pushboolean*(state: LuaState, b: cint) {.plua.}
proc pushlightuserdata*(state: LuaState, p: pointer) {.plua.}
# proc pushthread*(state: LuaState): cint {.plua.}

proc dump*(state: LuaState, writer: ChunkWriter, data: pointer, strip: bool): cint {.plua.}
proc load*(state: LuaState, reader: ChunkReader, data: pointer, name: cstring, mode: cstring): cstring {.plua.}

proc close*(state: LuaState) {.plua.}



proc newstate*(): LuaState {.pLlua.}
proc loadstring*(state: LuaState, s: cstring): cint {.pLlua.}

proc loadbufferx*(state: LuaState, buff: cstring, size: cint, name: cstring, mode: cstring): cint {.pLlua.}
template loadbuffer*(state: LuaState, buff: cstring, size: cint, name: cstring): cint = loadbufferx(state, buff, size, name, nil)

proc loadfilex*(state: LuaState, filename: cstring, mode: cstring): cint {.pLlua.}
template loadfile*(state: LuaState, filename: cstring): cint = loadfilex(state, filename, nil)

template dostring*(state: LuaState, s: cstring): cint =
  result = loadstring(state, s)
  if not result: pcall(state, 0, MultiReturn, 0)

{.pop.}