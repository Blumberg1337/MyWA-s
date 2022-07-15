-- trigger data (copy text inside of quotes)
requiredForActivation = "Custom Function"
dynamicInformation = "Dynamic Information from first active trigger"

custom = function(t)
  -- set the trigger listening to the custom event 'TRINKET_TIMERS_INITIALIZED' here to avoid manipulation of the weakaura
  return t[4]
end
