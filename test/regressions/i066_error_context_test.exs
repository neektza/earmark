defmodule Regressions.I066ErrorContextTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "Issue https://github.com/pragdave/earmark/issues/66" do
    assert capture_io( :stderr, fn->
      Earmark.to_html ~s(`Hello\nWorld), %Earmark.Options{filename: "fn"}
    end) == "error: Closing unclosed ` from fn:1 at end of input"
  end
end
