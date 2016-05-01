# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :deltek,
  wsdl: "http://yourhost.com/Vision/VisionWS.asmx?wsdl",
  username: "yourusername",
  password: "yourpassword",
  database_name: "yourdatabase"
