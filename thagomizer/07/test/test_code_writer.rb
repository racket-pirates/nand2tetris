gem "minitest"
require 'minitest/autorun'
require_relative '../lib/code_writer'

class TestCodeWriter < Minitest::Test
  def setup
    @cw = CodeWriter.new
    @cw.file_name = "test"
  end

  def test_write_push_constant
    # push constant 7
    @cw.write_push_pop(:c_push, "constant", 7)

    asm = @cw.asm
    assert_equal 8, asm.length
    assert_equal "// push constant 7", asm[0]
    assert_equal "@7",                 asm[1]
    assert_equal "D=A",                asm[2]
    assert_equal "@SP",                asm[3]
    assert_equal "A=M",                asm[4]
    assert_equal "M=D",                asm[5]
    assert_equal "@SP",                asm[6]
    assert_equal "M=M+1",              asm[7]
  end

  def test_write_push_local
    # push local 7
    @cw.write_push_pop(:c_push, "local", 7)

    asm = @cw.asm
    assert_equal 11, asm.length
    assert_equal "// push local 7",    asm[0]
    assert_equal "@7",                 asm[1]
    assert_equal "D=A",                asm[2]
    assert_equal "@LCL",               asm[3]
    assert_equal "A=M+D",              asm[4]
    assert_equal "D=M",                asm[5]
    assert_equal "@SP",                asm[6]
    assert_equal "A=M",                asm[7]
    assert_equal "M=D",                asm[8]
    assert_equal "@SP",                asm[9]
    assert_equal "M=M+1",              asm[10]
  end

  def test_write_push_argument
    # push argument 8
    @cw.write_push_pop(:c_push, "argument", 8)

    asm = @cw.asm
    assert_equal 11, asm.length
    assert_equal "// push argument 8", asm[0]
    assert_equal "@8",                 asm[1]
    assert_equal "D=A",                asm[2]
    assert_equal "@ARG",               asm[3]
    assert_equal "A=M+D",              asm[4]
    assert_equal "D=M",                asm[5]
    assert_equal "@SP",                asm[6]
    assert_equal "A=M",                asm[7]
    assert_equal "M=D",                asm[8]
    assert_equal "@SP",                asm[9]
    assert_equal "M=M+1",              asm[10]
  end

  def test_write_push_this
    # push argument 5
    @cw.write_push_pop(:c_push, "this", 5)

    asm = @cw.asm
    assert_equal 11, asm.length
    assert_equal "// push this 5",     asm[0]
    assert_equal "@5",                 asm[1]
    assert_equal "D=A",                asm[2]
    assert_equal "@THIS",              asm[3]
    assert_equal "A=M+D",              asm[4]
    assert_equal "D=M",                asm[5]
    assert_equal "@SP",                asm[6]
    assert_equal "A=M",                asm[7]
    assert_equal "M=D",                asm[8]
    assert_equal "@SP",                asm[9]
    assert_equal "M=M+1",              asm[10]
  end

  def test_write_push_that
    # push argument 6
    @cw.write_push_pop(:c_push, "that", 6)

    asm = @cw.asm
    assert_equal 11, asm.length
    assert_equal "// push that 6",     asm[0]
    assert_equal "@6",                 asm[1]
    assert_equal "D=A",                asm[2]
    assert_equal "@THAT",              asm[3]
    assert_equal "A=M+D",              asm[4]
    assert_equal "D=M",                asm[5]
    assert_equal "@SP",                asm[6]
    assert_equal "A=M",                asm[7]
    assert_equal "M=D",                asm[8]
    assert_equal "@SP",                asm[9]
    assert_equal "M=M+1",              asm[10]
  end

  def test_write_push_temp
    # push temp 2
    @cw.write_push_pop(:c_push, "temp", 2)

    asm = @cw.asm
    assert_equal 8, asm.length
    assert_equal "// push temp 2",     asm[0]
    assert_equal "@R7",                asm[1]
    assert_equal "D=M",                asm[2]
    assert_equal "@SP",                asm[3]
    assert_equal "A=M",                asm[4]
    assert_equal "M=D",                asm[5]
    assert_equal "@SP",                asm[6]
    assert_equal "M=M+1",              asm[7]
  end

  def test_write_push_pointer
    # push pointer 1
    @cw.write_push_pop(:c_push, "pointer", 1)

    asm = @cw.asm
    assert_equal 8, asm.length
    assert_equal "// push pointer 1",  asm[0]
    assert_equal "@4",                 asm[1]
    assert_equal "D=M",                asm[2]
    assert_equal "@SP",                asm[3]
    assert_equal "A=M",                asm[4]
    assert_equal "M=D",                asm[5]
    assert_equal "@SP",                asm[6]
    assert_equal "M=M+1",              asm[7]
  end

  def test_write_push_static
    # push static 3
    @cw.write_push_pop(:c_push, "static", 3)

    asm = @cw.asm
    assert_equal 8, asm.length
    assert_equal "// push static 3",  asm[0]
    assert_equal "@test.3",           asm[1]
    assert_equal "D=M",               asm[2]
    assert_equal "@SP",               asm[3]
    assert_equal "A=M",               asm[4]
    assert_equal "M=D",               asm[5]
    assert_equal "@SP",               asm[6]
    assert_equal "M=M+1",             asm[7]
  end

  def test_write_pop_local
    # pop local 4
    @cw.write_push_pop(:c_pop, "local", 4)

    asm = @cw.asm
    assert_equal 13, asm.length
    assert_equal "// pop local 4", asm[0]
    assert_equal "@4",             asm[1]
    assert_equal "D=A",            asm[2]
    assert_equal "@LCL",           asm[3]
    assert_equal "D=M+D",          asm[4]
    assert_equal "@R13",           asm[5]
    assert_equal "M=D",            asm[6]
    assert_equal "@SP",            asm[7]
    assert_equal "AM=M-1",         asm[8]
    assert_equal "D=M",            asm[9]
    assert_equal "@R13",           asm[10]
    assert_equal "A=M",            asm[11]
    assert_equal "M=D",            asm[12]
  end

  def test_write_pop_argument
    # pop argument 1
    @cw.write_push_pop(:c_pop, "argument", 1)

    asm = @cw.asm
    assert_equal 13, asm.length
    assert_equal "// pop argument 1", asm[0]
    assert_equal "@1",                asm[1]
    assert_equal "D=A",               asm[2]
    assert_equal "@ARG",              asm[3]
    assert_equal "D=M+D",             asm[4]
    assert_equal "@R13",              asm[5]
    assert_equal "M=D",               asm[6]
    assert_equal "@SP",               asm[7]
    assert_equal "AM=M-1",            asm[8]
    assert_equal "D=M",               asm[9]
    assert_equal "@R13",              asm[10]
    assert_equal "A=M",               asm[11]
    assert_equal "M=D",               asm[12]
  end

  def test_write_pop_this
    # pop this 2
    @cw.write_push_pop(:c_pop, "this", 2)

    asm = @cw.asm
    assert_equal 13, asm.length
    assert_equal "// pop this 2",     asm[0]
    assert_equal "@2",                asm[1]
    assert_equal "D=A",               asm[2]
    assert_equal "@THIS",             asm[3]
    assert_equal "D=M+D",             asm[4]
    assert_equal "@R13",              asm[5]
    assert_equal "M=D",               asm[6]
    assert_equal "@SP",               asm[7]
    assert_equal "AM=M-1",            asm[8]
    assert_equal "D=M",               asm[9]
    assert_equal "@R13",              asm[10]
    assert_equal "A=M",               asm[11]
    assert_equal "M=D",               asm[12]
  end

  def test_write_pop_that
    # pop that 3
    @cw.write_push_pop(:c_pop, "that", 3)

    asm = @cw.asm
    assert_equal 13, asm.length
    assert_equal "// pop that 3",     asm[0]
    assert_equal "@3",                asm[1]
    assert_equal "D=A",               asm[2]
    assert_equal "@THAT",             asm[3]
    assert_equal "D=M+D",             asm[4]
    assert_equal "@R13",              asm[5]
    assert_equal "M=D",               asm[6]
    assert_equal "@SP",               asm[7]
    assert_equal "AM=M-1",            asm[8]
    assert_equal "D=M",               asm[9]
    assert_equal "@R13",              asm[10]
    assert_equal "A=M",               asm[11]
    assert_equal "M=D",               asm[12]
  end

  def test_write_pop_temp
    # pop temp 7
    @cw.write_push_pop(:c_pop, "temp", 7)

    asm = @cw.asm
    assert_equal 6, asm.length
    assert_equal "// pop temp 7",     asm[0]
    assert_equal "@SP",               asm[1]
    assert_equal "AM=M-1",            asm[2]
    assert_equal "D=M",               asm[3]
    assert_equal "@R12",              asm[4]
    assert_equal "M=D",               asm[5]
  end

  def test_write_pop_pointer_0
    # pop pointer 0
    @cw.write_push_pop(:c_pop, "pointer", 0)

    asm = @cw.asm
    assert_equal 6, asm.length
    assert_equal "// pop pointer 0",  asm[0]
    assert_equal "@SP",               asm[1]
    assert_equal "AM=M-1",            asm[2]
    assert_equal "D=M",               asm[3]
    assert_equal "@3",                asm[4]
    assert_equal "M=D",               asm[5]
  end

  def test_write_pop_static_4
    # pop pointer 4
    @cw.write_push_pop(:c_pop, "static", 4)

    asm = @cw.asm
    assert_equal 6, asm.length
    assert_equal "// pop static 4",   asm[0]
    assert_equal "@SP",               asm[1]
    assert_equal "AM=M-1",            asm[2]
    assert_equal "D=M",               asm[3]
    assert_equal "@test.4",           asm[4]
    assert_equal "M=D",               asm[5]
  end

  def test_write_arithmetic_add
    @cw.write_arithmetic("add")

    asm = @cw.asm
    assert_equal 13, asm.length
    assert_equal "// add", asm[0]
    assert_equal "@SP",    asm[1]
    assert_equal "AM=M-1", asm[2]
    assert_equal "D=M",    asm[3]
    assert_equal "@SP",    asm[4]
    assert_equal "AM=M-1", asm[5]
    assert_equal "A=M",    asm[6]
    assert_equal "D=A+D",  asm[7]
    assert_equal "@SP",    asm[8]
    assert_equal "A=M",    asm[9]
    assert_equal "M=D",    asm[10]
    assert_equal "@SP",    asm[11]
    assert_equal "M=M+1",  asm[12]
  end

  def test_write_arithmetic_sub
    @cw.write_arithmetic("sub")

    asm = @cw.asm
    assert_equal 13, asm.length
    assert_equal "// sub", asm[0]
    assert_equal "@SP",    asm[1]
    assert_equal "AM=M-1", asm[2]
    assert_equal "D=M",    asm[3]
    assert_equal "@SP",    asm[4]
    assert_equal "AM=M-1", asm[5]
    assert_equal "A=M",    asm[6]
    assert_equal "D=A-D",  asm[7]
    assert_equal "@SP",    asm[8]
    assert_equal "A=M",    asm[9]
    assert_equal "M=D",    asm[10]
    assert_equal "@SP",    asm[11]
    assert_equal "M=M+1",  asm[12]
  end

  def test_write_arithmetic_neg
    @cw.write_arithmetic("neg")

    asm = @cw.asm
    assert_equal 4, asm.length
    assert_equal "// neg", asm[0]
    assert_equal "@SP",    asm[1]
    assert_equal "A=M-1",  asm[2]
    assert_equal "M=-M",   asm[3]
  end

  def test_write_arithmetic_eq
    @cw.write_arithmetic("eq")

    asm = @cw.asm
    assert_equal 21, asm.length
    assert_equal "// eq",       asm[0]
    assert_equal "@SP",         asm[1]
    assert_equal "AM=M-1",      asm[2]
    assert_equal "D=M",         asm[3]
    assert_equal "@SP",         asm[4]
    assert_equal "AM=M-1",      asm[5]
    assert_equal "A=M",         asm[6]
    assert_equal "D=A-D",       asm[7]
    assert_equal "@TRUE0001",   asm[8]
    assert_equal "D;JEQ",       asm[9]

    assert_equal "D=0",         asm[10]
    assert_equal "@PUSHD0002",  asm[11]
    assert_equal "0;JMP",       asm[12]

    assert_equal "(TRUE0001)",  asm[13]
    assert_equal "D=-1",        asm[14]

    assert_equal "(PUSHD0002)", asm[15]
    assert_equal "@SP",         asm[16]
    assert_equal "A=M",         asm[17]
    assert_equal "M=D",         asm[18]
    assert_equal "@SP",         asm[19]
    assert_equal "M=M+1",       asm[20]
  end

  def test_write_arithmetic_gt
    @cw.write_arithmetic("gt")

    asm = @cw.asm
    assert_equal 21, asm.length
    assert_equal "// gt",       asm[0]
    assert_equal "@SP",         asm[1]
    assert_equal "AM=M-1",      asm[2]
    assert_equal "D=M",         asm[3]
    assert_equal "@SP",         asm[4]
    assert_equal "AM=M-1",      asm[5]
    assert_equal "A=M",         asm[6]
    assert_equal "D=A-D",       asm[7]
    assert_equal "@TRUE0001",   asm[8]
    assert_equal "D;JGT",       asm[9]

    assert_equal "D=0",         asm[10]
    assert_equal "@PUSHD0002",  asm[11]
    assert_equal "0;JMP",       asm[12]

    assert_equal "(TRUE0001)",  asm[13]
    assert_equal "D=-1",        asm[14]

    assert_equal "(PUSHD0002)", asm[15]
    assert_equal "@SP",         asm[16]
    assert_equal "A=M",         asm[17]
    assert_equal "M=D",         asm[18]
    assert_equal "@SP",         asm[19]
    assert_equal "M=M+1",       asm[20]
  end

  def test_write_arithmetic_lt
    @cw.write_arithmetic("lt")

    asm = @cw.asm
    assert_equal 21, asm.length
    assert_equal "// lt",       asm[0]
    assert_equal "@SP",         asm[1]
    assert_equal "AM=M-1",      asm[2]
    assert_equal "D=M",         asm[3]
    assert_equal "@SP",         asm[4]
    assert_equal "AM=M-1",      asm[5]
    assert_equal "A=M",         asm[6]
    assert_equal "D=A-D",       asm[7]
    assert_equal "@TRUE0001",   asm[8]
    assert_equal "D;JLT",       asm[9]

    assert_equal "D=0",         asm[10]
    assert_equal "@PUSHD0002",  asm[11]
    assert_equal "0;JMP",       asm[12]

    assert_equal "(TRUE0001)",  asm[13]
    assert_equal "D=-1",        asm[14]

    assert_equal "(PUSHD0002)", asm[15]
    assert_equal "@SP",         asm[16]
    assert_equal "A=M",         asm[17]
    assert_equal "M=D",         asm[18]
    assert_equal "@SP",         asm[19]
    assert_equal "M=M+1",       asm[20]
  end

  def test_write_arithmetic_not
    @cw.write_arithmetic("not")

    asm = @cw.asm
    assert_equal 4, asm.length
    assert_equal "// not", asm[0]
    assert_equal "@SP",    asm[1]
    assert_equal "A=M-1",  asm[2]
    assert_equal "M=!M",   asm[3]
  end

  def test_write_arithmetic_and
    @cw.write_arithmetic("and")

    asm = @cw.asm
    assert_equal 13, asm.length
    assert_equal "// and", asm[0]
    assert_equal "@SP",    asm[1]
    assert_equal "AM=M-1", asm[2]
    assert_equal "D=M",    asm[3]
    assert_equal "@SP",    asm[4]
    assert_equal "AM=M-1", asm[5]
    assert_equal "A=M",    asm[6]
    assert_equal "D=D&A",  asm[7]
    assert_equal "@SP",    asm[8]
    assert_equal "A=M",    asm[9]
    assert_equal "M=D",    asm[10]
    assert_equal "@SP",    asm[11]
    assert_equal "M=M+1",    asm[12]
  end

  def test_write_arithmetic_or
    @cw.write_arithmetic("or")

    asm = @cw.asm
    assert_equal 13, asm.length
    assert_equal "// or", asm[0]
    assert_equal "@SP",    asm[1]
    assert_equal "AM=M-1", asm[2]
    assert_equal "D=M",    asm[3]
    assert_equal "@SP",    asm[4]
    assert_equal "AM=M-1", asm[5]
    assert_equal "A=M",    asm[6]
    assert_equal "D=D|A",  asm[7]
    assert_equal "@SP",    asm[8]
    assert_equal "A=M",    asm[9]
    assert_equal "M=D",    asm[10]
    assert_equal "@SP",    asm[11]
    assert_equal "M=M+1",    asm[12]
  end
end
