class Button
{
  private int buttonX, buttonY, buttonWidth, buttonHeight;
  private String strButtonText, strModeIfClicked;
  final color highlight = color(225);
  final color nonHighlight = color(255);

  Button() {
  }
  Button (String buttonText, int buttonX, int buttonY, int buttonWidth, int buttonHeight, String strModeIfClicked)
  {
    this.buttonX = buttonX;
    this.buttonY = buttonY;
    this.buttonWidth = buttonWidth;
    this.buttonHeight = buttonHeight;
    this.strButtonText = buttonText;
    this.strModeIfClicked = strModeIfClicked;
  }
  
  Button (String buttonText, int buttonX, int buttonY, int buttonWidth, int buttonHeight)
  {
    this.buttonX = buttonX;
    this.buttonY = buttonY;
    this.buttonWidth = buttonWidth;
    this.buttonHeight = buttonHeight;
    this.strButtonText = buttonText;
  }

  public boolean checkIfClicked(int clickedX, int clickedY)
  {
    if (clickedX >= buttonX && clickedX <= buttonX+buttonWidth && clickedY >= buttonY && clickedY <= buttonY+buttonHeight) return true;
    return false;
  }

  public String modeIfClicked()
  {
    return strModeIfClicked;
  }

  public void draw(int currentMouseX, int currentMouseY)
  {
    textSize(42);
    if (mouseOver(currentMouseX, currentMouseY))
    {
      fill(highlight);
    } else
    {
      fill(nonHighlight);
    }
    stroke(#75B746);
    rect(buttonX, buttonY, buttonWidth, buttonHeight);
    fill(0, 0, 0, 200);
    text(strButtonText, buttonX, buttonY, buttonWidth, buttonHeight);
  }

  public void draw(int currentMouseX, int currentMouseY, String mode)
  {
    textSize(22);
    fill(0);
    if (mouseOver(currentMouseX, currentMouseY))
    {
      text(mode, buttonX, buttonY+45, buttonWidth, buttonHeight);
    }
  }

  private boolean mouseOver(int currentMouseX, int currentMouseY)
  {
    if (currentMouseX >= buttonX && currentMouseX <= buttonX+buttonWidth && currentMouseY >= buttonY && currentMouseY <= buttonY+buttonHeight)
    {
      return true;
    } else
    {
      return false;
    }
  }
}
