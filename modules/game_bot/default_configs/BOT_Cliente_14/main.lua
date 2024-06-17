-- main tab
VERSION = "14.0"

UI.Label("BOT Cliente: " .. VERSION)

UI.Separator()



UI.Separator()


UI.Button("Forum", function()
  g_platform.openUrl("https://www.demolidores.com.br/?subtopic=forum")
end)

UI.Button("Help & Tutorials", function()
  g_platform.openUrl("https://www.demolidores.com.br/?subtopic=demowiki")
end)
