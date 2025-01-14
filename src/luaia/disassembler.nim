import std/bitops

type OpKind* = enum
    Move
    LoadI      LoadF        LoadK    LoadKX
    LoadFalse  LFalseSkip
    LoadTrue   LoadNil
    GetUpVal   SetUpVal

    GetTabUp   GetTable     GetI     GetField
    SetTabUp   SetTable     SetI     SetField
    NewTable

    Self

    AddI       AddK         SubK
    MulK       ModK
    PowK
    DivK       IDivK

    BAndK      BOrK         BXorK

    ShRI
    ShLI

    Add        Sub
    Mul        Mod
    Pow
    Div        IDiv

    BAnd       BOr          BXor
    ShL        ShR

    MMBin      MMBinI       MMBinK

    UnM        BNot         Not
    
    Len

    ConCat

    Close
    TBC
    Jmp
    
    Eq         Lt           Le

    EqK        EqI
    LtI        LeI
    GtI        GeI

    Test
    TestSet

    Call       TailCall

    Return     Return0      Return1

    ForLoop    ForPrep

    TForPrep   TForCall     TForLoop

    SetList

    Closure

    Vararg     VarArgPrep   ExtraArg

type Instruction* = distinct uint32

func op*(i: Instruction): OpKind =
    i.uint32.bitsliced(0..<7).OpKind

func A*(i: Instruction): uint8 =
    i.uint32.bitsliced(7..<15).uint8

func B*(i: Instruction): uint8 =
    i.uint32.bitsliced(16..<24).uint8

func sB*(i: Instruction): int8 =
    i.uint32.bitsliced(16..<24).int8

func Ax*(i: Instruction): uint32 =
    i.uint32.bitsliced(7..<32).uint32

func Bx*(i: Instruction): uint32 =
    i.uint32.bitsliced(15..<32).uint32

func sBx*(i: Instruction): int32 =
    i.uint32.bitsliced(15..<32).int32

func C*(i: Instruction): uint8 =
    i.uint32.bitsliced(24..<32).uint8

func sC*(i: Instruction): int8 =
    i.uint32.bitsliced(24..<32).int8

func sJ*(i: Instruction): int32 =
    i.uint32.bitsliced(7..<32).int32

func k*(i: Instruction): bool =
    i.uint32.testbit(15)


type OpMode* = enum
    iABC iABx iAsBx iAx isJ

const opModes = [
    0b00001000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iAsBx.uint8),
    0b00001000.uint8.bitor(iAsBx.uint8),
    0b00001000.uint8.bitor(iABx.uint8),
    0b00001000.uint8.bitor(iABx.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00000000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00000000.uint8.bitor(iABC.uint8),
    0b00000000.uint8.bitor(iABC.uint8),
    0b00000000.uint8.bitor(iABC.uint8),
    0b00000000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b10000000.uint8.bitor(iABC.uint8),
    0b10000000.uint8.bitor(iABC.uint8),
    0b10000000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABC.uint8),
    0b00000000.uint8.bitor(iABC.uint8),
    0b00000000.uint8.bitor(iABC.uint8),
    0b00000000.uint8.bitor(isJ.uint8),
    0b00010000.uint8.bitor(iABC.uint8),
    0b00010000.uint8.bitor(iABC.uint8),
    0b00010000.uint8.bitor(iABC.uint8),
    0b00010000.uint8.bitor(iABC.uint8),
    0b00010000.uint8.bitor(iABC.uint8),
    0b00010000.uint8.bitor(iABC.uint8),
    0b00010000.uint8.bitor(iABC.uint8),
    0b00010000.uint8.bitor(iABC.uint8),
    0b00010000.uint8.bitor(iABC.uint8),
    0b00010000.uint8.bitor(iABC.uint8),
    0b00011000.uint8.bitor(iABC.uint8),
    0b01101000.uint8.bitor(iABC.uint8),
    0b01101000.uint8.bitor(iABC.uint8),
    0b00100000.uint8.bitor(iABC.uint8),
    0b00000000.uint8.bitor(iABC.uint8),
    0b00000000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABx.uint8),
    0b00001000.uint8.bitor(iABx.uint8),
    0b00000000.uint8.bitor(iABx.uint8),
    0b00000000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABx.uint8),
    0b00100000.uint8.bitor(iABC.uint8),
    0b00001000.uint8.bitor(iABx.uint8),
    0b01001000.uint8.bitor(iABC.uint8),
    0b00101000.uint8.bitor(iABC.uint8),
    0b00000000.uint8.bitor(iAx.uint8)
]

func mode*(i: Instruction): OpMode =
    opModes[i.op.int].masked((0..2).toMask[:uint8]).OpMode

func setAFlag*(i: Instruction): bool =
    opModes[i.op.int].testBit(3)

func tFlag*(i: Instruction): bool =
    opModes[i.op.int].testBit(4)

func itFlag*(i: Instruction): bool =
    opModes[i.op.int].testBit(5)

func otFlag*(i: Instruction): bool =
    opModes[i.op.int].testBit(6)

func mmFlag*(i: Instruction): bool =
    opModes[i.op.int].testBit(7)

func `$`*(i: Instruction): string =
    "#" & $i.op

type InstructionSet* = seq[Instruction]

type ChunkHeader = object
    lua_version: string
    format: int
    instruction_size: int
    integer_size: int
    number_size: int


type LuaVariantKind = enum
    Unknown     = 0   # NOTE: to make nim not angry
    Int         = 3   # (3) | ((0) << 4)
    Float       = 19  # (3) | ((1) << 4)
    ShortString = 4   # (4) | ((0) << 4)
    LongString  = 20  # (4) | ((1) << 4)
    

type LuaVariant = object
    case kind: LuaVariantKind
    of Unknown: discard
    of Int: ival: int64
    of Float: fval: float64
    of ShortString, LongString: sval: string

type UpValue = object
    in_stack: uint8
    index: uint8
    kind: uint8


type FunctionData = object
    source: string
    line_start: int
    line_end: int
    param_len: int
    is_vararg: bool # NOTE: may have more than 2 value so bool might not work
    max_stack_size: int
    instructions: InstructionSet
    constants: seq[LuaVariant]
    upvalues: seq[UpValue]
    functions: seq[FunctionData]
    
    debug_line_info: seq[uint8]
    debug_abs_line_info: seq[tuple[pc: int, line: int]]
    debug_local_vars: seq[tuple[name: string, start_pc: int, end_pc: int]]
    debug_upvalues_names: seq[string]

import std/strutils
# import std/algorithm

func readSize(s: ptr string, i: var int): uint64 =
    var res: int64
    while i < s[].len and not cast[int8](s[][i]).testBit(7):
        res = res shl 7
        res = res or cast[int8](s[][i])
        i += 1
    if i < s[].len:
        var b = cast[int8](s[][i])
        b.clearBit(7)
        res = res shl 7
        res = res or b
        i += 1
    result = cast[uint64](res)

func readString(s: ptr string, i: var int): string =
    let b = cast[int64](s.readSize i)
    if b > 0:
        result = s[][i..i+b-2]
        i += b - 1


func extractFunction(s: ptr string, i: var int, header: ptr ChunkHeader): FunctionData =
    result.source = s.readString i
    
    result.line_start = cast[int64](s.readSize i)
    result.line_end = cast[int64](s.readSize i)
    result.param_len = s[][i].int
    result.is_vararg = s[][i+1].bool
    result.max_stack_size = s[][i+2].int
    i += 3
    
    var b = cast[int64](s.readSize i)
    result.instructions.setLen b
    for j in 0..<b:
        result.instructions[j] = cast[ptr Instruction](s[][i].addr)[]
        i += 4
    
    b = cast[int64](s.readSize i)
    result.constants.setLen b
    let is_int64 = header[].integer_size == 8
    let is_float64 = header[].number_size == 8
    for j in 0..<b:
        var v = LuaVariant(kind: cast[LuaVariantKind](s[][i]))
        i += 1
        
        case v.kind
        of ShortString, LongString:
            v.sval = s.readString i
        of Int: # TODO: maybe add other size
            v.ival = if is_int64: cast[ptr int64](s[][i].addr)[]
            else: cast[ptr int32](s[][i].addr)[]
            i += header[].integer_size
        of Float:
            v.fval = if is_float64: cast[ptr float64](s[][i].addr)[]
            else: cast[ptr float32](s[][i].addr)[]
            i += header[].integer_size
        of Unknown: discard
        result.constants[j] = v
    
    # NOTE: the rest is likely not important, let see

    b = cast[int64](s.readSize i)
    result.upvalues.setLen b
    for j in 0..<b:
        result.upvalues[j].in_stack = s[][i].uint8
        result.upvalues[j].index = s[][i+1].uint8
        result.upvalues[j].kind = s[][i+2].uint8
        i += 3
    
    b = cast[int64](s.readSize i)
    result.functions.setLen b
    for j in 0..<b:
        result.functions[j] = s.extractFunction(i, header)
    
    
    b = cast[int64](s.readSize i)
    result.debug_line_info.setLen b
    for j in 0..<b:
        result.debug_line_info[j] = s[i].uint8
        i += 1
    
    b = cast[int64](s.readSize i)
    result.debug_abs_line_info.setLen b
    for j in 0..<b:
        result.debug_abs_line_info[j].pc = cast[int](s.readSize i)
        result.debug_abs_line_info[j].line = cast[int](s.readSize i)
    
    b = cast[int64](s.readSize i)
    result.debug_local_vars.setLen b
    for j in 0..<b:
        result.debug_local_vars[j].name = s.readString i
        result.debug_local_vars[j].start_pc = cast[int](s.readSize i)
        result.debug_local_vars[j].start_pc = cast[int](s.readSize i)
    
    b = cast[int64](s.readSize i)
    if b != 0: b = result.upvalues.len # NOTE: the original comment from lua source: /* must be this many */
    result.debug_upvalues_names.setLen b
    for j in 0..<b:
         result.debug_upvalues_names[j] = s.readString i
    



func disassemble*(s: string): tuple[header: ChunkHeader, function: FunctionData] =
    if s[0..3] != "\x1bLua":
        raise CatchableError.newException("Binary might be corrupt.")
    
    result.header.lua_version = s[4].uint8.toHex
    result.header.format = s[5].int
    
    if s[6..11] != "\x19\x93\r\n\x1a\n":
        raise CatchableError.newException("Binary might be corrupt.")
    
    result.header.instruction_size = s[12].uint.toHex.parseInt
    result.header.integer_size = s[13].uint.toHex.parseInt
    result.header.number_size = s[14].uint.toHex.parseInt

    var i = 15
    if s[i..i+result.header.integer_size-1] != "\x78\x56\x00\x00\x00\x00\x00\x00": # NOTE: hard code for now
        raise CatchableError.newException("Binary might be corrupt.")
    i += result.header.integer_size

    if s[i..i+result.header.number_size-1] != "\x00\x00\x00\x00\x00\x28\x77\x40": # NOTE: hard code for now
        raise CatchableError.newException("Binary might be corrupt.")
    i += result.header.number_size

    i += 1 # NOTE: bypass upvalue size thing since I dont understand

    result.function = s.addr.extractFunction(i, result.header.addr)


    if i != s.len:
        raise CatchableError.newException("Binary might be corrupt.")

func printString*(f: FunctionData): string =
    for ii, i in f.instructions:
        result &= $i.op
        case i.op
        of LoadKX, LoadFalse, LFalseSkip, LoadTrue, Close, TBC, Return1, VarArgPrep:
            # : A
            result &= "\t" & $i.A
        of Move, LoadNil, GetUpVal, SetUpVal, UnM, BNot, Not, Len, ConCat:
            # : A B
            result &= "\t" & $i.A & "\t" & $i.B
        of GetTabUp, GetTable, GetI, GetField, SetTabUp, SetTable, SetI, SetField, Self, AddK, SubK, MulK, ModK, PowK, DivK, IDivK, BandK, Bork, BXorK, Add, Sub, Mul, Mod, Pow, Div, IDiv, BAnd, BOr, BXor, ShL, ShR, MMBin, Call:
            # : A B C
            result &= "\t" & $i.A & "\t" & $i.B & "\t" & $i.C
        of Test:
            # : A k
            result &= "\t" & $i.A & "\t" & $i.k
        of Eq, Lt, Le, EqK, TestSet:
            # : A B k
            result &= "\t" & $i.A & "\t" & $i.B & "\t" & $i.k
        of EqI, LtI, LeI, GtI, GeI:
            # : A sB k
            result &= "\t" & $i.A & "\t" & $i.sB & "\t" & $i.k
        of NewTable, MMBinK, TailCall, Return, SetList:
            # : A B C k
            result &= "\t" & $i.A & "\t" & $i.B & "\t" & $i.C & "\t" & $i.k
        of MMBinI:
            # : A sB C k
            result &= "\t" & $i.A & "\t" & $i.sB & "\t" & $i.C & "\t" & $i.k
        of LoadK, ForLoop, ForPrep, TForPrep, TForLoop, Closure:
            # : A Bx
            result &= "\t" & $i.A & "\t" & $i.Bx
        of LoadI, LoadF:
            # : A sBx
            result &= "\t" & $i.A & "\t" & $i.sBx
        of AddI, ShRI, ShLI:
            # : A B sC
            result &= "\t" & $i.A & "\t" & $i.B & "\t" & $i.sC
        of TForCall, VarArg:
            # : A C
            result &= "\t" & $i.A & "\t" & $i.C
        of ExtraArg:
            #: Ax
            result &= "\t" & $i.Ax
        of Jmp:
            # : sJ
            result &= "\t" & $i.sJ
        of Return0:
            # :
            discard

        result &= "\n"
