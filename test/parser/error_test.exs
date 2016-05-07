defmodule Parser.ErrorTest do 
  use ExUnit.Case
  import ExUnit.CaptureIO

  alias Earmark.Options
  alias Earmark.Parser
  alias Earmark.Block

  test 'Unexpected line' do 
    assert capture_io( :stderr, fn->
      Earmark.to_html "A\nB\n="
    end) == "<no file>:3: warning: Unexpected line =\n"
  end

  test 'Closing Backtick' do 
    assert capture_io( :stderr, fn->
      Earmark.to_html "A\n`B\n"
    end) == "<no file>:2: warning: Closing unclosed backquotes ` at end of input\n"
  end

  test 'Failed to find closing tag' do 
    assert capture_io( :stderr, fn ->
      Earmark.to_html "one\ntwo\n<three>\nfour", %Options{filename: "input_file.md"}
    end) == "input_file.md:3: warning: Failed to find closing <three>\n"
  end
end
