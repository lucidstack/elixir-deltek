defmodule Deltek.Template do
  def start_link(file, model) do
    GenServer.start_link(__MODULE__, {file, model}, name: get_server_name(model))
  end

  def eval(context, model) do
    model
    |> get_server_name
    |> GenServer.call({:eval, context})
  end

  # Genserver implementation
  ########################
  def init({file, model}) do
    {:ok, %{template: File.read!(file), model: model}}
  end

  def handle_call({:eval, context}, _from, %{template: t} = state) do
    {:reply, EEx.eval_string(t, context), state}
  end

  # Private implementation
  ########################
  defp get_server_name(model) do
    String.to_atom("#{model}_template")
  end
end


