import controlP5.*; //import ControlP5 library
import processing.serial.*;


Serial port;
boolean fetchedValues = false;



// Variables for receiving serial data
char[] receivedChars;
String receivedString = "";
char[] tempChars;        // temporary array for use when parsing

// variables to hold the parsed data
String commandFromData;
int integerFromData = 0;
float floatFromData = 0.0;

boolean newData = false;



ControlP5 cp5; //create ControlP5 object
PFont fontWhite;
PFont fontBlack;

int redColor = color(255, 0, 0);
int charcoal = color(30);
int white = color(255);


int darkBlue   = color(0, 0, 43);
int greyBlue   = color(50, 70, 130);
int mediumBlue = color(0, 0, 130);
int royalBlue  = color(0, 0, 210);
int brightBlue = color(15, 230, 255);
int skyBlue    = color(15, 230, 255);


int titleColor = white;
int sliderColor = greyBlue;
int runBatchColor = skyBlue;
int emergencyStopColor = redColor;
int selfCleanColor = greyBlue;
int dropDownColor = greyBlue;

Textarea myTextarea;

int c = 0;

Println console;
Boolean consoleStart;

int windowWidth = 700;
int windowHeight= 950;


// Tab setting
int tabHeight = 40;
int tabWidth = (700 / 3);

//slider settings
int slidersHandeSize = 10;
int slidersLeft = 50;
int slidersWidth = 380;
int slidersHeight = 40;
int slidersSpacing = 70;
int slidersOffsetV = 160;

int slidersLablesLeft = 50;
int slidersLableOffsetV = 170;

int testButtonWidth = 70;
int testButtonHeight = 40;


String unitOfMeasureName = "LITERS";
int unitOfMeasureCode = 0;


float batchQuantitySliderValue = 10.0; // cups of material total
float previousBatchQuantitySliderValue = batchQuantitySliderValue;
int batchQuantityDefault = 10; //

float rateOfProductionSliderValue = 7.0; // cups per minute to produce desired quantity
float previousRateOfProductionSliderValue = rateOfProductionSliderValue;
int rateOfProductionDefault = 7;

int ratiosRange = 30;
float mixRatioDryPartSliderValue = 16.0;  //cups of dry mix 
float previousMixRatioDryPartSliderValue = mixRatioDryPartSliderValue;
int mixRatioDryPartDefault = 16;

float mixRatioWetPartSliderValue = 13.0;   //cups of water
float previousMixRatioWetPartSliderValue = mixRatioWetPartSliderValue;
int mixRatioWetPartDefault = 13;   //cups of water

float dryPer100RotationsSliderValue = 6.0; // cups of dry mix per 100 rotations (with vibration)
float previousDryPer100RotationsSliderValue = dryPer100RotationsSliderValue;
int dryPer100RotationsDefault = 6;

float wetPer100RotationsSliderValue = 2.75; // cups of water per 100 rotations
float previousWetPer100RotationsSliderValue = wetPer100RotationsSliderValue;
float wetPer100RotationsDefault = 2.75;

float sharedAccelerationTimeSliderValue = 5.0;  // seconds  Time to top speed
float previousSharedAccelerationTimeSliderValue = sharedAccelerationTimeSliderValue;
int sharedAccelerationTimeDefault = 5;

DropdownList portsDropdown;
StringList portsStringList;

DropdownList presetsDropdown;
StringList presetsStringList = new StringList("Preset 1","Preset 2","Preset 3","Preset 4","Preset 5","Preset 6","Preset 7","Preset 8","Preset 9","Preset 10","Preset 11","Preset 12","Preset 13","Preset 14","Preset 15");
ControlGroup messageBox;
int messageBoxResult = -1;
String messageBoxString = "";
float t;

String previousTabName;
String pendingCommand;
String confirmationText;


void setup(){ //same as arduino program

  size(700, 950);    //window size, (width, height)  
  textSize(20); 


  cp5 = new ControlP5(this);
  fontWhite = createFont("Arial", 24, true);    // custom fonts for buttons and title
  fontBlack = createFont("Arial",30);
  ControlFont sliderLabel = new ControlFont(fontBlack, 24);  
     
  // create a control-font 
  PFont pfont = createFont("Arial", 24, true);
  ControlFont font = new ControlFont(pfont, 24);   
     
     
  noStroke();    
  
  portsStringList = new StringList();
     
  Tab defaultTab = cp5.getTab("default")
     //.activateEvent(true)
     .setLabel("   Batch   ")
     .setHeight(40)
     .setId(1)
     ;

  defaultTab.getCaptionLabel().setFont(font);


  Tab connectionTab = cp5.addTab("Connection")
     //.activateEvent(true)
     .setLabel("   Connection   ")
     .setHeight(40)
     .setId(2)
     ;
  
  connectionTab.getCaptionLabel().setFont(font);
  
     
  Tab calibrationTab = cp5.addTab("Calibration")
     //.activateEvent(true)
     .setLabel("   Calibration   ")
     .setHeight(40)
     .setId(3)
     ;

  calibrationTab.getCaptionLabel().setFont(font);
  
  Tab presetsTab = cp5.addTab("Presets")
     //.activateEvent(true)
     .setLabel("   Presets   ")
     .setHeight(40)
     .setId(4)
     ;

  presetsTab.getCaptionLabel().setFont(font);
  
  Tab confirmTab = cp5.addTab("Confrim")
   //.activateEvent(true)
   .setLabel("   Confrim   ")
   .setHeight(40)
   .setId(5)
   ;
  
  // Name field for each Preset
  cp5.addTextfield("settingsNameField")
    .setId(20)
    .setPosition(slidersLeft,(slidersSpacing * 1) +slidersOffsetV)
    .setSize(200,40)
    .setFont(fontWhite)
    .setColorBackground(sliderColor)
    .setCaptionLabel("")
    ;
    
  cp5.addButton("setName")
    .setCaptionLabel("Update Name")
    .setPosition(slidersLeft + 395,(slidersSpacing * 1) +slidersOffsetV)
    .setSize(190, testButtonHeight)      //(width, height)
    .setFont(fontWhite)
    .setColorBackground(runBatchColor)
   ;  


  cp5.addSlider("batchQuantitySlider")
     .setCaptionLabel("BATCH SIZE " + unitOfMeasureName)
     .setPosition(slidersLeft,(slidersSpacing * 2) +slidersOffsetV)
     .setSize(slidersWidth,slidersHeight)
     .setRange(1,30).setNumberOfTickMarks(30)
     .setValue(batchQuantityDefault)
     .setColorBackground(sliderColor)
     .setSliderMode(Slider.FLEXIBLE).setFont(fontWhite).setHandleSize(slidersHandeSize)
     ;                  

  cp5.addSlider("rateOfProductionSlider")
     .setCaptionLabel(unitOfMeasureName + " PER MIN")
     .setPosition(slidersLeft,(slidersSpacing * 3) +slidersOffsetV)
     .setSize(slidersWidth,slidersHeight)
     .setRange(1,20).setNumberOfTickMarks(20)
     .setValue(rateOfProductionDefault)
     .setColorBackground(sliderColor)
     .setSliderMode(Slider.FLEXIBLE).setFont(fontWhite).setHandleSize(slidersHandeSize)
     ;
       
     
  cp5.addSlider("mixRatioDryPartSlider")
     .setCaptionLabel("Mix Ratio Dry")
     .setPosition(slidersLeft,(slidersSpacing * 1) +slidersOffsetV)
     .setSize(slidersWidth,slidersHeight)
     .setRange(1,ratiosRange).setNumberOfTickMarks(ratiosRange)
     .setValue(mixRatioDryPartDefault)
     .setColorBackground(sliderColor)
     .setSliderMode(Slider.FLEXIBLE).setFont(fontWhite).setHandleSize(slidersHandeSize)
     ;
     
    
  cp5.addSlider("mixRatioWetPartSlider")
     .setCaptionLabel("Mix Ratio Wet")
     .setPosition(slidersLeft,(slidersSpacing * 2) +slidersOffsetV)
     .setSize(slidersWidth,slidersHeight)
     .setRange(1,ratiosRange).setNumberOfTickMarks(ratiosRange)
     .setValue(mixRatioWetPartDefault)     
     .setColorBackground(sliderColor)
     .setSliderMode(Slider.FLEXIBLE).setFont(fontWhite).setHandleSize(slidersHandeSize)
     ;    
  

     
  cp5.addButton("runDry100")     
    .setCaptionLabel("Test")
    .setPosition(slidersLeft,(slidersSpacing * 3) +slidersOffsetV)
    .setSize(testButtonWidth, testButtonHeight)      //(width, height)
    .setFont(fontWhite)
    .setColorBackground(runBatchColor)
   ;
   
   cp5.addSlider("dryPer100RotationsSlider")
     .setCaptionLabel("DRY/100 ROTATIONS")
     .setPosition(slidersLeft + testButtonWidth +5,(slidersSpacing * 3) +slidersOffsetV)
     .setSize(slidersWidth - (testButtonWidth +5),slidersHeight)
     .setRange(0,10)
     .setValue(dryPer100RotationsDefault) 
     .setColorBackground(sliderColor)
     .setSliderMode(Slider.FLEXIBLE).setFont(fontWhite).setHandleSize(slidersHandeSize)
     ;
     
    
     
   cp5.addButton("runWet100")     
    .setCaptionLabel("Test")
    .setPosition(slidersLeft,(slidersSpacing * 4) + slidersOffsetV)
    .setSize(testButtonWidth, testButtonHeight)      //(width, height)
    .setFont(fontWhite)
    .setColorBackground(runBatchColor)
   ;
   
  cp5.addSlider("wetPer100RotationsSlider")
     .setCaptionLabel("WET/100 ROTATIONS")
     .setPosition(slidersLeft + testButtonWidth + 5 ,(slidersSpacing * 4) +slidersOffsetV)
     .setSize(slidersWidth - (testButtonWidth + 5),slidersHeight)
     .setRange(0,5)
     .setValue(wetPer100RotationsDefault)  
     .setColorBackground(sliderColor)
     .setSliderMode(Slider.FLEXIBLE).setFont(fontWhite).setHandleSize(slidersHandeSize)
     ;
     
     
  cp5.addSlider("sharedAccelerationTimeSlider")
     .setCaptionLabel("Acceleration Time")
     .setPosition(slidersLeft,(slidersSpacing * 5) +slidersOffsetV)
     .setSize(slidersWidth,slidersHeight)
     .setRange(2,10).setNumberOfTickMarks(9)
     .setValue(sharedAccelerationTimeDefault)   
     .setColorBackground(sliderColor)
     .setSliderMode(Slider.FLEXIBLE).setFont(fontWhite).setHandleSize(slidersHandeSize)
     ;
     

   cp5.addTextlabel("StructreBotTitle")
    .setText("StructureBot")
    .setPosition(154, 62)
    .setColorValue(titleColor)
    .setFont(fontBlack)
    ; 
    
 cp5.addTextlabel("MixerControlTitle")
    .setText("Mixer Control")
    .setPosition(333, 62)
    .setColorValue(titleColor)
    .setFont(fontBlack)
    ; 
  
  cp5.addButton("runBatch")    
  .setCaptionLabel(" RUN BATCH ")
    .setPosition(50, 123)  //x and y coordinates of upper left corner of button
    .setSize(170, 70)      //(width, height)
    .setFont(fontWhite)
    .setColorBackground(runBatchColor)
  ;
  
  cp5.addButton("emergecyStop")     
    .setCaptionLabel(" EMERGENCY STOP ")
    .setPosition(420,123)  //x and y coordinates of upper left corner of button
    .setSize(250, 70)      //(width, height)
    .setFont(fontWhite)
    .setColorBackground(emergencyStopColor)
  ;
  
   cp5.addButton("selfClean")    
    .setCaptionLabel(" SELF CLEAN ")
    .setPosition(slidersLablesLeft, (slidersSpacing *4) +slidersLableOffsetV)
    .setSize(190, 70)      //(width, height)
    .setColorBackground(selfCleanColor)
    .setFont(fontWhite)
  ;
  
  
    portsDropdown = cp5.addDropdownList("portsDropdown")
      .setLabel(" Ports ")
      .setPosition(slidersLeft,(slidersSpacing * 1) +slidersOffsetV +10)
      .setBackgroundColor(dropDownColor)
      .setHeight(400)
      .setWidth(190)
      .setItemHeight(55)
      .setBarHeight(55)
      .setFont(fontWhite)
      ;   
  
  presetsDropdown = cp5.addDropdownList("presetsDropdown")
      .setLabel(" Presets ")
      .setPosition(slidersLeft,(slidersSpacing * 1) +slidersOffsetV +10)
      .setBackgroundColor(dropDownColor)
      .setHeight(300)
      .setWidth(260)
      .setItemHeight(55)
      .setBarHeight(55)
      .setFont(fontWhite)
      ; 
      
    int i = 0;
    for(String presetName : presetsStringList){
      presetsDropdown.addItem(presetName, i);
      i++;
    }
    
  cp5.addButton("loadSettingsFromPreset")
    .setCaptionLabel("Load Selected Preset")
    .setPosition(332,245)
    .setSize(360, testButtonHeight)
    .setFont(fontWhite)
    .setColorBackground(runBatchColor)
    .setBroadcast(false)  // we disable before setting a value 
    .setValue(1)
    .setBroadcast(true)
    ;
          
   cp5.addButton("saveSettingsToPreset")
    .setCaptionLabel("Save To Selected Preset")
    .setPosition(332,295)
    .setSize(360, testButtonHeight)
    .setFont(fontWhite)
    .setColorBackground(runBatchColor)
    .setBroadcast(false)  // we disable before setting a value 
    .setValue(1)
    .setBroadcast(true)
    ;
    
  cp5.addButton("saveSettingsToCurrent")
    .setCaptionLabel("Save Settings To Current")
    .setPosition(332,345)
    .setSize(360, testButtonHeight)
    .setFont(fontWhite)
    .setColorBackground(runBatchColor)
    .setBroadcast(false)  // we disable before setting a value 
    .setValue(1)
    .setBroadcast(true)
    ;
    
  cp5.addTextlabel("confirmMessage")
    .setText("Are you sure you want to overwrite this preset?")  
    .setPosition(200,282)
    .setSize(300, 85) 
    .setMultiline(true)
    .setFont(fontWhite)
    ;
 
  
  cp5.addButton("buttonOK")
    .setCaptionLabel("OK")
    .setPosition(165,405)
    .setSize(testButtonWidth +15, testButtonHeight + 15)  
    .setFont(fontWhite)
    .setColorBackground(runBatchColor)
    ;
    
  cp5.addButton("buttonCancel")
    .setCaptionLabel("Cancel")
    .setPosition(385,405)
    .setSize(150, testButtonHeight + 15) 
    .setFont(fontWhite)
    .setColorBackground(runBatchColor)
    ;
    
  
  
  cp5.enableShortcuts();
  frameRate(10);
  
  myTextarea = cp5.addTextarea("txt")
                  .setPosition(50, 580)
                  .setSize(600, 320)
                  .setFont(createFont("Arial", 18))
                  //.setLineHeight(22)
                  .setColor(color(0))
                  .setColorBackground(color(220))
                  .setColorForeground(color(90))
                  .moveTo("global");
                  ;
                  

  console = cp5.addConsole(myTextarea);//
  
  println("StructureBot Mixer Control ready to go:  " + hour() + ":" + minute() + ":" + second());    

  
 
  // Batch controls
  cp5.getController("batchQuantitySlider").moveTo("default");
  cp5.getController("rateOfProductionSlider").moveTo("default");
  cp5.getController("selfClean").moveTo("default");
  
  // Connection controls
  cp5.getController("portsDropdown").moveTo("Connection");
  
  // Calibration Controls  
  //cp5.getController("settingsNameField").moveTo("Calibration");
  cp5.getController("sharedAccelerationTimeSlider").moveTo("Calibration");
  cp5.getController("mixRatioDryPartSlider").moveTo("Calibration");
  cp5.getController("mixRatioWetPartSlider").moveTo("Calibration");
  cp5.getController("dryPer100RotationsSlider").moveTo("Calibration");
  cp5.getController("runDry100").moveTo("Calibration"); 
  cp5.getController("wetPer100RotationsSlider").moveTo("Calibration");
  cp5.getController("runWet100").moveTo("Calibration"); 
  
  // Presets Controls
  cp5.getController("presetsDropdown").moveTo("Presets");  
  cp5.getController("loadSettingsFromPreset").moveTo("Presets"); 
  cp5.getController("saveSettingsToCurrent").moveTo("Presets"); 
  cp5.getController("saveSettingsToPreset").moveTo("Presets"); 
  
  cp5.getController("buttonOK").moveTo("Confirm"); 
  cp5.getController("buttonCancel").moveTo("Confirm"); 
  cp5.getController("confirmMessage").moveTo("Confirm"); 
  

  // Global controls
  cp5.getController("runBatch").moveTo("global");
  cp5.getController("emergecyStop").moveTo("global");
  cp5.getController("StructreBotTitle").moveTo("global");
  cp5.getController("MixerControlTitle").moveTo("global");

  
  int idx = 0;
  if(Serial.list().length >0){
      for(String portName : Serial.list()){
          portsDropdown.addItem(portName, idx);
          portsStringList.append(portName);
          try{
              if(Serial.list().length == 1){
                  println("Found one port: " + portName + ". Connecting.");
                  port = new Serial(this, portName, 9600); 
                  print("Successful.");
              }
              else {
                println("No ports found.");
              }
          }
          catch(Exception ex){
            println(ex.getMessage());
            println("Connect was unsuccessful. Check the USB cable.  Then select port.");
          }
          finally{
            idx++;
          }      
       } 
    }  
  
  consoleStart = false;    
}



void draw(){  //same as loop in arduino
  background(darkBlue);  //(0, 0, 62) darkBlue Background  
 
  if(consoleStart == false){
    println("Initialize console.");
    consoleStart = true;
  }
  
  if(fetchedValues == false && port != null && port.available() > 0){
    // Get initial values from Arduino
    println("Fetching settings from mixer.");
    port.write("<GET_ALL_SETTINGS,0,0.0>");
    fetchedValues = true;
  }
  
  recvWithStartEndMarkers();
  
  if (newData == true) {    
    parseData();
    processData();
    newData = false;
  }
  
}


void recvWithStartEndMarkers() {
    boolean recvInProgress = false;
    byte ndx = 0;
    char startMarker = '<';
    char endMarker = '>';
    char rc;

    while (port != null && port.available() > 0 && newData == false) {
        rc = port.readChar();
        
        if (recvInProgress == true) {
            if (rc != endMarker) {
                receivedString = receivedString + rc;
            }
            else {
                recvInProgress = false;
                newData = true;
            }
        }

        else if (rc == startMarker) {
            recvInProgress = true;
            receivedString = "";
        }
    }
}

void parseData() {      // split the data into its parts
 
    String[] dataParts = receivedString.split(",");

    commandFromData = dataParts[0];      // get the first part - the string
    if(dataParts.length > 1){ 
      try{floatFromData = Integer.parseInt(dataParts[2]); }// Try converting this part to an integer
      catch(NumberFormatException nfe){}  
    }

    if(dataParts.length > 2){  
      try{floatFromData = Float.parseFloat(dataParts[2]); }// Try converting this part to a float
      catch(NumberFormatException nfe){}
    }

}

void processData() {
    //print("Command: ");
    //print(commandFromData);
    //print(" Integer ");
    //print(integerFromData);
    //print(" Float ");
    //println(floatFromData);
    
    
  if(commandFromData.startsWith("Success:")){
      println(commandFromData); 
  }
  
  else if(commandFromData.startsWith("Error")){
      println(commandFromData); 
  }

  else if(commandFromData.equalsIgnoreCase("unitOfMeasure_SET")){ 
    unitOfMeasureName = getUnitOfMeasureNameFromCode(integerFromData);
    println("Set Unit of Measure set to " + unitOfMeasureName); 
  } 
  
  else if(commandFromData.equalsIgnoreCase("materialToProduce_SET")){ 
    cp5.getController("batchQuantitySlider").setValue(floatFromData);
    println("Set Batch Quantity to " + floatFromData); 
  } 
  
  else if(commandFromData.equalsIgnoreCase("rateOfProduction_SET")){ 
    cp5.getController("rateOfProductionSlider").setValue(floatFromData);
    println("Set Rate of Production to " + floatFromData); 
    return;
  } 
  
  else if(commandFromData.equalsIgnoreCase("mixRatioDryPart_SET")){ 
    cp5.getController("mixRatioDryPartSlider").setValue(floatFromData);
    println("Set Mix Ratio Dry Part to " + floatFromData); 
  } 
  
  else if(commandFromData.equalsIgnoreCase("mixRatioWetPart_SET")){ 
    cp5.getController("mixRatioWetPartSlider").setValue(floatFromData);
    println("Set Mix Ratio Wet Part to " + floatFromData); 
  } 
  
  else if(commandFromData.equalsIgnoreCase("dryPer100Rotations_SET")){ 
    cp5.getController("dryPer100RotationsSlider").setValue(floatFromData);
    println("Set Dry Part per 100 Rotations to " + floatFromData); 
  } 
  
  else if(commandFromData.equalsIgnoreCase("wetPer100Rotations_SET")){ 
    cp5.getController("wetPer100RotationsSlider").setValue(floatFromData);
    println("Set Wet Part per 100 Rotations to " + floatFromData); 
  } 
  
  else if(commandFromData.equalsIgnoreCase("sharedAccelerationTime_SET")){ 
    cp5.getController("sharedAccelerationTimeSlider").setValue(floatFromData);
    println("Set AccelerationTime to " + floatFromData); 
  }
  
  else if(commandFromData.startsWith("settingsName_SET")){
    if(commandFromData.length() > 17){
      String name = commandFromData.substring(17);
      cp5.get(Textfield.class,"settingsNameField").setText(name);
      println("Set Name to " + name); 
    }
    else{
      println("No Name detected."); 
    }
  }
  
  //if(commandFromData.equalsIgnoreCase("timeToClean_SET")){ 
  //  cp5.getController("mixRatioDryPartSlider").setValue(floatFromData);
  //  println("Set MixRatioDryPart to " + floatFromData); 
  //}   
    
}

//lets add some functions to our buttons
//so when you press any button, it sends characters over the serial port

void buttonOK() {
  cp5.getTab(previousTabName).bringToFront();
  if(port != null){port.write(pendingCommand);}
  pendingCommand = "";
  println("Command executed.");
}


void buttonCancel() {    
  cp5.getTab(previousTabName).bringToFront();
  pendingCommand = "";
  println("Command cancelled.");
}

void setName() {   
  String name = cp5.get(Textfield.class,"settingsNameField").getText();
  if(name.length()> 20){name = name.substring(1,20);}
  println("settingsName: "+name);
  if(port != null){port.write("<SET_NAME:" + name + ",0,0.0>");}
}

void batchQuantitySlider(float batchQuantitySliderValue) {
  if (batchQuantitySliderValue != previousBatchQuantitySliderValue) {
    println("batchQuantitySliderValue "+batchQuantitySliderValue);
    if(port != null){port.write("<SET_BATCH_QUANTITY,0," + batchQuantitySliderValue +">");}
    previousBatchQuantitySliderValue = batchQuantitySliderValue;
  }
}

void rateOfProductionSlider(float rateOfProductionSliderValue) {
  if (rateOfProductionSliderValue != previousRateOfProductionSliderValue) {
    println("rateOfProductionSliderValue "+rateOfProductionSliderValue);
    if(port != null){port.write("<SET_RATE_OF_PRODUCTION,0," + rateOfProductionSliderValue +">");}
    previousRateOfProductionSliderValue = rateOfProductionSliderValue;
  }
}

void mixRatioDryPartSlider(float mixRatioDryPartSliderValue) {
  if (mixRatioDryPartSliderValue != previousMixRatioDryPartSliderValue) {
    println("mixRatioDryPartSliderValue "+mixRatioDryPartSliderValue);
    if(port != null){port.write("<SET_MIX_RATIO_DRY_PART,0," + mixRatioDryPartSliderValue +">");}
    previousMixRatioDryPartSliderValue = mixRatioDryPartSliderValue;
  }
}

void mixRatioWetPartSlider(float mixRatioWetPartSliderValue) {
  if (mixRatioWetPartSliderValue != previousMixRatioWetPartSliderValue) {
    println("mixRatioWetPartSliderValue "+mixRatioWetPartSliderValue);
    if(port != null){port.write("<SET_MIX_RATIO_WET_PART,0," + mixRatioWetPartSliderValue +">");}
    previousMixRatioWetPartSliderValue = mixRatioWetPartSliderValue;
  }
}

void dryPer100RotationsSlider(float dryPer100RotationsSliderValue) {
  if (dryPer100RotationsSliderValue != previousDryPer100RotationsSliderValue) {
    println("dryPer100RotationsSliderValue "+dryPer100RotationsSliderValue);
    if(port != null){port.write("<SET_DRY_100_ROTATIONS,0," + dryPer100RotationsSliderValue +">");}
    previousDryPer100RotationsSliderValue = dryPer100RotationsSliderValue;
  }
}

void wetPer100RotationsSlider(float wetPer100RotationsSliderValue) {
    if (wetPer100RotationsSliderValue != previousWetPer100RotationsSliderValue) {
    println("wetPer100RotationsSliderValue "+wetPer100RotationsSliderValue);
    if(port != null){port.write("<SET_WET_100_ROTATIONS,0," + wetPer100RotationsSliderValue +">");}
    previousWetPer100RotationsSliderValue = wetPer100RotationsSliderValue;
  }
}

void sharedAccelerationTimeSlider(float sharedAccelerationTimeSliderValue) {
  if (sharedAccelerationTimeSliderValue != previousSharedAccelerationTimeSliderValue) {
    println("sharedAccelerationTimeSliderValue "+sharedAccelerationTimeSliderValue);
    if(port != null){port.write("<SET_SHARED_ACCELERATION,0," + sharedAccelerationTimeSliderValue +">");}
    previousSharedAccelerationTimeSliderValue = sharedAccelerationTimeSliderValue;
  }
}

void emergecyStop(){
  if(port != null){port.write("<STOP,0,0.0>");}
  println("Stopped batch " + hour() + ":" + minute() + ":" + second());
}

void runBatch(){
  if(port != null){port.write("<RUN_BATCH,0,0.0>");}
   println("Started batch " + hour() + ":" + minute() + ":" + second());
}

void selfClean(){
  if(port != null){port.write("<SELF_CLEAN,0,0.0>");}
   println("Self clean " + hour() + ":" + minute() + ":" + second());
}

void runWet100(){
  println("Running 100 Rotations Wet " + hour() + ":" + minute() + ":" + second());
  if(port != null){port.write("<RUN_WET_100,0,0.0>");}
}

void runDry100(){
  println("Running 100 Rotations Dry " + hour() + ":" + minute() + ":" + second());
  if(port != null){port.write("<RUN_DRY_100,0,0.0>");}
}

void restoreDefaultSettings(){
  println("Restoring Default Settings"  + hour() + ":" + minute() + ":" + second());
  if(port != null){port.write("<RESTORE_DEFAULT_SETTINGS,0,0.0>");}   // 33 chars!
}

void saveSettingsToCurrent(){  
   // Get number of Preset selected
  pendingCommand = "<SAVE_CURRENT_SETTINGS,0,0.0>";
  
  previousTabName = "Presets";
  confirmationText = "Are you sure? This will overwrite the mixer's current settings?";
  println("Save Settings to Mixer Current Settings?"); 
  cp5.getTab("Confirm").bringToFront();
}

void saveSettingsToPreset(){  
   // Get number of Preset selected
  int presetValue = (int) cp5.getController("presetsDropdown").getValue() +1;
  pendingCommand = "<SAVE_TO_PRESET," + presetValue + ",0.0>";
  
  previousTabName = "Presets";
  confirmationText = "Are you sure you want to overwrite this preset?";
  println("Save Settings to Mixer Preset " + presetValue + "?"); 
  cp5.getTab("Confirm").bringToFront();  
}

void loadSettingsFromPreset(){
  int presetValue = (int) cp5.getController("presetsDropdown").getValue() +1;
  pendingCommand = "<LOAD_FROM_PRESET," + presetValue + ",0.0>";
    
  previousTabName = "Presets";
  confirmationText = "Are you sure you want to load this preset on the mixer?";
  println("Loading Settings from Mixer Preset " + presetValue);
  cp5.getTab("Confirm").bringToFront();
  
}


void controlEvent(ControlEvent theEvent) {
  // DropdownList is of type ControlGroup.
  // A controlEvent will be triggered from inside the ControlGroup class.
  // therefore you need to check the originator of the Event with
  // if (theEvent.isGroup())
  // to avoid an error message thrown by controlP5.

  if (theEvent.isGroup()) {
    // check if the Event was triggered from a ControlGroup
    println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());
  } 
  else if (theEvent.isController()) {
    //println("event from controller : "+theEvent.getController().getValue()+" from "+theEvent.getController());
     
    if(theEvent.getController().getName() == "portsDropdown"){
        int dropdownIndex = (int)theEvent.getController().getValue();
        String portName = portsStringList.get(dropdownIndex);
        println("port send from controlEvent");
        println(portName);
        try{
            if(Serial.list().length > 0){
               println("Setting up port.");
               port = new Serial(this, portName, 9600); 
               print("Successful.");
            }
            else {
              println("No ports found.");
            }
        }
        catch(Exception ex){
            println(ex.getMessage());
            println("Connect was unsuccessful. Check the USB cable.  Then select port.");
        }
        finally{
        } 
    }
  }
}

String getUnitOfMeasureNameFromCode(int code){
  if(code == 1){ return "GALLONS";}
  if(code == 2){ return "QUARTS";}
  else { return "LITERS";} // 0 - default
}
