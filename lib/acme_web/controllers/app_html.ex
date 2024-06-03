defmodule AcmeWeb.AppHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use AcmeWeb, :html

  embed_templates "app_html/*"
end
