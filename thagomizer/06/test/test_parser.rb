gem "minitest"
require 'minitest/autorun'
require_relative '../lib/parser'
require 'stringio'


class TestParser < Minitest::Test

  def test_has_more_commands_when_more_commands
    source = "Test One\nTest Two"
    parser = Parser.new(StringIO.new(source))

    assert parser.has_more_commands?
  end

  def test_has_more_commands_when_no_more_commands
    source = ""
    parser = Parser.new(StringIO.new(source))

    refute parser.has_more_commands?
  end

  def test_advance
    source = "@3\nD=M"
    parser = Parser.new(StringIO.new(source))

    assert_equal "@3", parser.current_command

    parser.advance

    assert_equal "D=M", parser.current_command
  end

  # command_type

  def test_command_type_a_command_symbol
    source = "@foo"
    parser = Parser.new(StringIO.new(source))

    assert_equal :a_command, parser.command_type
  end

  def test_command_type_a_command_number
    source = "@42"
    parser = Parser.new(StringIO.new(source))

    assert_equal :a_command, parser.command_type
  end

  def test_command_type_c_command_calculation
    source = "AM=M-1"
    parser = Parser.new(StringIO.new(source))

    assert_equal :c_command, parser.command_type
  end

  def test_command_type_c_command_jump
    source = "D;JNE"
    parser = Parser.new(StringIO.new(source))

    assert_equal :c_command, parser.command_type
  end

  def test_command_type_l_command
    source = "(LOOP)"
    parser = Parser.new(StringIO.new(source))

    assert_equal :l_command, parser.command_type
  end

  # symbol

  def test_symbol_a_command_number
    source = "@42"
    parser = Parser.new(StringIO.new(source))

    assert_equal "42", parser.symbol
  end

  def test_symbol_a_command_symbol
    source = "@foo"
    parser = Parser.new(StringIO.new(source))

    assert_equal "foo", parser.symbol
  end

  def test_symbol_l_command
    source = "(LOOP)"
    parser = Parser.new(StringIO.new(source))

    assert_equal "LOOP", parser.symbol
  end

  def test_dest
    source = "D=M\nAMD=3;JMP\nD;JEQ"
    parser = Parser.new(StringIO.new(source))

    assert_equal "D", parser.dest

    parser.advance

    assert_equal "AMD", parser.dest

    parser.advance

    assert_equal nil, parser.dest
  end
end
