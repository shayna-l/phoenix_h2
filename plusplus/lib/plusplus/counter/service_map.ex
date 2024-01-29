defmodule Plusplus.ServiceMap do
  alias Plusplus.CounterMap

  # client
  def start(input) do
    spawn(fn  ->
      input
      |> CounterMap.new()
      |> loop()
    end)
  end

  def inc(pid) do
    send(pid, :inc)
  end

  def dec(pid) do
    send(pid, :dec)
  end

  def show(pid) do
    send(pid, {:show, self()})
    receive do
      {:show, msg} -> msg
    end
  end

  # server
  def listen(count) do
    receive do
      # {:message_type, value} ->
      #   code
      :inc ->
        CounterMap.inc(count)
      :dec ->
        CounterMap.dec(count)
      {:show, from_pid} ->
        send(from_pid, {:show, CounterMap.show(count)})
        count
    end
  end

  def loop(count) do
    count
    |> listen()
    |> loop()
  end
end
