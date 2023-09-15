defmodule Pluggy.Template do
  # def srender(file, data \\ [], layout \\ true) do
  #   {:ok, template} = File.read("templates/#{file}.slime")

  #   case layout do
  #     true ->
  #       {:ok, layout} = File.read("templates/layout.slime")
  #       Slime.render(layout, template: Slime.render(template, data))

  #     false ->
  #       Slime.render(template, data)
  #   end
  # end

  def render(file, data \\ []) do
    EEx.eval_file("templates/layout.eex",
      template: EEx.eval_file("templates/#{file}.eex", data)
    )
  end

  def render_no_template(file, data \\ []) do
    EEx.eval_file("templates/#{file}.eex", data)
  end
end
