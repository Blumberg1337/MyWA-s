-- trigger data (copy text inside of quotes)
iconSettings = {
  color = {
    code = "ffffff",
    alpha = "100"
  },
  desaturate = false,
  iconSource = "Dynamic Information",
  fallbackIcon = "",
  extraOptions = {},
  swipeOverlaySettings = {enableSwipe = false}
}

positionSettings = {
  width = "60",
  height = "60",
  xOffset = "-430",
  yOffset = "-380",
  anchor = "Center",
  anchoredTo = "Screen/Parent Group",
  toScreens = "Center",
  frameStrata = "Inherited"
}

subElements = {
  background,
  text_1 = {
    showText = true,
    color = {
      code = "ffffff",
      alpha = "100"
    },
    displayText = "%n",
    font = "Friz Quadrata TT",
    size = "30",
    anchors = {
      anchor = "automatic",
      toFrames = "Center",
      xOffset = "2",
      yOffset = "0"
    }
  },
  glow_1 = {
    showGlow = true,
    type = "Action Button Glow"
  }
}
