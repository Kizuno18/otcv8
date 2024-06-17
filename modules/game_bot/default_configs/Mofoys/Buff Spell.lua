setDefaultTab("Tools")
UI.Label("Buff Spell:")
UI.TextEdit(storage.hasPartyBuff or "utito tempo san", function(widget, newText)
  storage.hasPartyBuff = newText
end)

macro(250, "Buff Spell", function()
  if not hasPartyBuff() then
    say(storage.hasPartyBuff)
  end
end)