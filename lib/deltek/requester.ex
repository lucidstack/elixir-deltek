defmodule Deltek.Requester do
  use GenServer
  import SweetXml
  alias Deltek.Mapper


  def start_link(action, model), do:
    GenServer.start_link(__MODULE__, {action, model})

  @timeout Application.get_env(:deltek, :timeout, 5000)
  def request(pid, request), do:
    GenServer.call(pid, {:request, request}, @timeout)


  # GenServer implementation
  ##########################
  def init({action, model}), do:
    {:ok, %{action: action, model: model}}

  def handle_call({:request, request}, _from, %{action: action, model: model} = state) do
    action
    |> curl(request)
    |> HtmlEntities.decode
    |> Mapper.to_map(model)
    |> reply(state)
  end


  # Private implementation
  ########################
  @wsdl             Application.get_env(:deltek, :wsdl)
  @soap_action_base "http://tempuri.org/Deltek.Vision.WebServiceAPI/Service1/"
  defp curl(action, request) do
    {response, 0} = System.cmd("curl", [
      "--header", "Content-Type: text/xml",
      "--header", ~s(SOAPAction: "#{@soap_action_base |> Path.join(action)}"),
      "--ntlm", "--negotiate",
      "-u", credentials,
      "-s", "--data", request,
      @wsdl
    ])

    response
  end

  defp credentials do
    username = Application.get_env(:deltek, :username)
    password = Application.get_env(:deltek, :password)
    "#{username}:#{password}"
  end

  defp reply(response, state), do:
    {:reply, response, state}
end
