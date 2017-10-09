
function OnNettableChanged (table_name, key, data)
{
  $.Msg( "Table ", table_name, " changed: '", key, "' = ", data );
  
  $("#blood").text = data.value + " / 100";
}

CustomNetTables.SubscribeNetTableListener("blood", OnNettableChanged);