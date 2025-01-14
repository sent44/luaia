const LibName =
  when defined(MACOSX):
    "liblua5.4.dylib"
  elif defined(UNIX):
    "liblua5.4.so(|.0)"
  else:
    "liblua5.4.dll"

type
    LuaState* = pointer
    KContext* = pointer
    Kfunction* = proc(state: LuaState, status: cint, ctx: KContext)

    ChunkReader* = proc(L: LuaState, ud: pointer, sz: ptr cint): cstring {.cdecl.}
    ChunkWriter* = proc(L: LuaState, p: pointer, sz: cint, ud: pointer): cint {.cdecl.}
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

    Number* = float
    Integer* = cint

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
proc luatype*(state: LuaState, idx: cint): cint {.plua, importc: "lua_type".}
proc dump*(state: LuaState, writer: ChunkWriter, data: pointer, strip: bool): cint {.plua.}
proc tonumberx*(state: LuaState, idx: cint, isnum: ptr cint): Number {.plua.}
template tonumber*(state: LuaState, idx: cint): Number = tonumberx(state, idx, nil)
proc callk*(state: LuaState, nargs: cint, nret: cint, ctx: KContext, k: Kfunction): cint {.plua.}
template call*(state: LuaState, nargs: cint, nret: cint): cint = callk(state, nargs, nret, nil, nil)
proc pcallk*(state: LuaState, nargs: cint, nret: cint, msgh: cint, ctx: KContext, k: Kfunction): cint {.plua.}
template pcall*(state: LuaState, nargs: cint, nret: cint, msgh: cint): cint = pcallk(state, nargs, nret, msgh, nil, nil)
proc close*(state: LuaState) {.plua.}

proc newstate*(): LuaState {.pLlua.}
proc loadstring*(state: LuaState, s: cstring): cint {.pLlua.}
# proc dostring*(state: LuaState,)
proc loadbufferx*(state: LuaState, buff: cstring, size: cint, name: cstring, mode: cstring): cint {.pLlua.}
template loadbuffer*(state: LuaState, buff: cstring, size: cint, name: cstring): cint = loadbufferx(state, buff, size, name, nil)
proc loadfilex*(state: LuaState, filename: cstring, mode: cstring): cint {.pLlua.}
template loadfile*(state: LuaState, filename: cstring): cint = loadfilex(state, filename, nil)

{.pop.}