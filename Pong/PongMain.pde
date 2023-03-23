/*
Pong Clone
ICS3U
Kronberg P1
Author Harrison Ford-Schultz
Date 23/1/23
*/

// importing all needed built in libraries 
import java.io.*;
import java.net.URL;
import javax.sound.sampled.*;
import javax.swing.*;
import java.util.*;

int screen; 
int screenwidth = 1000;
int screenheight = 1000;
int playareawidth = screenwidth - 100;
int playareaheight = screenheight - 150;
int ballsize = 18;

float tickrate;


String name = "", filestring = "", finalname = "";

ArrayList<PVector> ball = new ArrayList<PVector>();
PVector balllocation = new PVector(284,303);
PVector ballvelocity = new PVector(2,5);

PVector paddlelocation = new PVector(100,100);

float previousmouseY;
float paddlex = 65;
float paddley;
float paddlewidth = 15;
float paddleheight = 80;
float paddlevelocity = 0;
float paddlevelocitymultiplier; 

float aipaddlex = playareawidth + 20;
float aipaddlelocation = playareaheight /2 ; 
float aivelocity = 8;
float aisnapY;

boolean lastbool;
boolean lastbool1;

float wavey;

int ballloopcounter; 

boolean [] deflectanimation = new boolean [2];

int i = 0; 
int j = 0; 

int [] score = new int [2];
boolean [] scorereset = new boolean [2];
boolean playerwins, aiwins = false;
int playerwinscounter, aiwinscounter = 0; 
int totalwins;

boolean doubledeflectprevention = true;
boolean [] optionsinputcheck1 = new boolean [2];
boolean [] optionsinputcheck2 = new boolean [2];

int sizex;
int sizey;

String input1 = "";
String input2 = "";
String caret = "";
String caret2 = "";

int finalinput1;
int finalinput2;

long startTime = System.currentTimeMillis();
long elapsedTime = 0L;
long elapsedTimesec = 0L;

int NAMINGCEREMONY = -1;
int MENU = 0;
int GAME = 1;
int OPTIONS = 2; 
int GAMEOVER = 3;

class PVector {
  float x;
  float y;
  PVector(float x_, float y_) {
    x = x_;
    y = y_;
  }
  void add(PVector v) {
    x = x + v.x;
    y = y + v.y;
  }
}

void setup(){
  size(1000, 1000);

  ball.add(new PVector(playareawidth / 2, playareaheight / 2));
  screen = NAMINGCEREMONY;
  smooth(2);
  frameRate(120);
}
void draw() {
  // gets elapsed time since program start in milliseconds and seconds 
  elapsedTime = int(System.currentTimeMillis() - startTime);
  elapsedTimesec = elapsedTime / 1000; 
  
  // checking what screen is = to and shows on display the current screen 
  if (screen == NAMINGCEREMONY){
    namecheck();
  }
  else if(screen == MENU){
    mainmenu();
  }
  else if(screen == GAME){
    gamescreen();
  }
  else if(screen == OPTIONS){
    optionsmenu();
  }
  else if(screen == GAMEOVER){
    gameoverscreen();
    }
  }

void playerpaddle(){
  strokeWeight(2);
  fill(255);
  
  paddlevelocity = mouseY - paddley; 
  paddlevelocitymultiplier = paddlevelocity / 100;
  
  
  paddley = mouseY;
 
  if(mouseybordercheck() == true) {
      rect(paddlex,mouseY,paddlewidth,paddleheight);
      previousmouseY = mouseY;
  }else{
      rect(paddlex,previousmouseY,paddlewidth,paddleheight);
  }

  if(paddlex < balllocation.x + 18 && 
    paddlex + paddlewidth > balllocation.x &&
    mouseY < balllocation.y + 18 && 
    paddleheight + mouseY > balllocation.y) {
    //Bouncing the ball back and applyng multipliers to speed of ball
    ballvelocity.x = ballvelocity.x * -1;
    
    println(paddlevelocity);
    println(ballvelocity.y);
    if(paddlevelocity > 0 && ballvelocity.y < 0){
      ballvelocity.x = ballvelocity.x * 1.1 + paddlevelocitymultiplier;
      ballvelocity.y = ballvelocity.y * -1.05 - paddlevelocitymultiplier;
    }else if(paddlevelocity < 0 && ballvelocity.y > 0){
      ballvelocity.x = ballvelocity.x * 1.1 - paddlevelocitymultiplier;
      ballvelocity.y = ballvelocity.y * -1.05 + paddlevelocitymultiplier;
    }else if(paddlevelocity == 0){
        ballvelocity.x = ballvelocity.x * 1.1;
        ballvelocity.y = ballvelocity.y * 1.05;
    }
     
    balllocation.x += 10;
    playMusic((dataPath("")+ "\\paddle.wav"));
    doubledeflectprevention = false;
    }
}

void hardaipaddle(){
  
  if(aipaddlelocation > balllocation.y){
    aipaddlelocation -= aivelocity;
    
  }else if(aipaddlelocation < balllocation.y){
    aipaddlelocation += aivelocity;
  }
  
  strokeWeight(2);
  fill(255);
  
  if(aipaddlelocation < playareaheight - 5 && aipaddlelocation > 75) {
      rect(aipaddlex,aipaddlelocation,paddlewidth,paddleheight);
  }else if(aipaddlelocation > 75){
      aisnapY = playareaheight - 5;
      rect(aipaddlex,aisnapY,paddlewidth,paddleheight);
  }else if(aipaddlelocation < playareaheight - 5){
      aisnapY = 75;
      rect(aipaddlex,aisnapY,paddlewidth,paddleheight);
  }

  if (aipaddlex < balllocation.x + 18 && 
    aipaddlex + paddlewidth > balllocation.x &&
    aipaddlelocation < balllocation.y + 18 && 
    paddleheight + aipaddlelocation > balllocation.y) {
    //Bouncing the ball back and applyng multipliers to speed of ball
    ballvelocity.x = ballvelocity.x * -1;
    ballvelocity.x = ballvelocity.x * 1.1;
    ballvelocity.y = ballvelocity.y * 1.05;
    balllocation.x -= 10;
    playMusic((dataPath("")+ "\\paddle.wav"));
    doubledeflectprevention = false;
  }
}

void ball(boolean[] resetbool){
  if(lastbool || lastbool1 == true){
    delay(500);
  }
  
  lastbool = resetbool[0];
  lastbool1 = resetbool[1];
  
  if(resetbool[0] == true){
      reset();
      resetbool[0] = false; 
      scorereset[0] = false;
      if(random(1) > .5){
        ballvelocity.x = ballvelocity.x * -1;
      }
  }else if(resetbool[1] == true){
      reset();
      resetbool[1] = false; 
      scorereset[1] = false;
      if(random(1) > .5){
        ballvelocity.x = ballvelocity.x * -1;
      }
  }

  // Add the current speed to the location.
  balllocation.add(ballvelocity);

  // Ball bounce off borders
  if ((balllocation.y > playareaheight + 75 - ballsize) || (balllocation.y < 80)) {
    ballvelocity.y = ballvelocity.y * -1;
    doubledeflectprevention = true;
  }
  fill(255);

  // Draw ball
  for (PVector balllocation : ball) {
    rect(balllocation.x, balllocation.y, ballsize, ballsize);
  }
  ball.add(new PVector(balllocation.x,balllocation.y));
  ball.remove(0);
}
  
 void namecheck(){
    background(50);
    fill(255);
    
    textSize(40);
    textAlign(LEFT, CENTER);
    text("Please Enter Your Name: ", 50,25,900,300);
    textSize(30);
    text(filestring, 50 ,75,450,300);
    
 }
  
 void mainmenu(){
    background(50);
    fill(255);
    
    textSize(40);
    textAlign(LEFT, CENTER);
    if(totalwins == 0){
      text("Welcome To Ping, " + finalname + ".", 50 ,25,900,300);
    }else if(totalwins > 0){
      text("Welcome To Ping, " + finalname + "." + " You have " + totalwins + " total wins", 50 ,25,900,300);
    }
    textSize(30);
    text("Press Space to Play", 50 ,150,450,300);
    text("Alt for Options", 50 ,225,450,300);
    text("Shift for Exit", 50 ,300,450,300);
 }
 
 void gamescreen(){
    background(55);
    // Play area and middle line
    fill(0);
    rect(50,75,playareawidth,playareaheight);
    stroke(255);
    strokeWeight(5);
    for(int i = 90; i <= playareaheight + 70; i+=20) {
        line(playareawidth / 2 + 50,i-10,playareawidth / 2 + 50,i);
    }
    
    playerpaddle();
    hardaipaddle();
    ball(score());
    wavecheck();
    gameovercheck();
 }
 
 void optionsmenu(){
    background(50);
    fill(255);
    textSize(40);
    textAlign(LEFT, CENTER);
    text("Options - CTRL to Exit",50,5,1000,300);

    textSize(30);
    text("Width of Play Area. Max 900", 50,80,450,300);
    if(mouseX > 0 && mouseX < 250 && mouseY > 250 && mouseY < 280){
        fill(255,0,0);
        optionsinputcheck1[1] = true;
    }
    text("Input: ", 50,110,450,300);
    fill(255);
    text(input1, 130,110,450,300);
    
    text("Height of Play Area. Max 850", 50,170,450,300);
    if(mouseX > 0 && mouseX < 315 && mouseY > 340 && mouseY < 370){ 
        fill(255,0,0);
        optionsinputcheck2[1] = true;
    }
    text("Input: ", 50,200,450,300);
    fill(255);
    text(input2, 130,200,450,300);

    if(screen == OPTIONS && optionsinputcheck1[0] == true && optionsinputcheck1[1] == true && elapsedTimesec % 2 == 0){
        textAlign(LEFT, CENTER);
        text(input1 + "|", 130,110,450,300);
    }
    if(screen == OPTIONS && optionsinputcheck2[0] == true && optionsinputcheck2[1] == true && elapsedTimesec % 2 == 0){
        textAlign(LEFT, CENTER);
        text(input2 + "|", 130,200,450,300);
    }
   
 }
 
 void gameoverscreen(){
    fill(0);
    rect(0,0,screenwidth,screenheight);
    
    fill(255);
    textSize(80);
    textAlign(CENTER, CENTER);
    
    if(score[0] == 11){
      text("Game Over!" + " user " + name + " WINS!", (screenwidth/2)-225 ,0,450,300);
      playerwinscounter++;
    }
    else{
      text("Game Over!" + " AI " + "WINS!", (screenwidth/2)-225 ,0,450,300);
    }
      
    textSize(30);
    text("Please press Space to replay or Shift to exit", (screenwidth / 2)-225, 0 + 150,900,300);
 }


boolean[] score(){
    if(balllocation.x < paddlex){
        score[1] += 1;
        scorereset[0] = true;
    }

    if(balllocation.x > aipaddlex){
        score[0] += 1;
        scorereset[1] = true;
    }

    textSize(64);
    text(score[0], playareawidth / 2, 140);

    textSize(64);
    text(score[1], playareawidth / 2 +100, 140);

    return scorereset;
}

void gameovercheck(){
    if(score[0] == 11 || score[1] == 11){
      screen = GAMEOVER;
    if(score[0] == 1){ 
      playerwins = true; 
      playerwinscounter += 1;
    }
    else {
      aiwins = true;
      aiwinscounter += 1; 
    }
  }
}


void mousePressed(){
  if(doubledeflectprevention == true){
    if(paddlex + 20 < balllocation.x + 18 && 
      paddlex + 20 + paddlewidth > balllocation.x &&
      paddleheight + mouseY + 20 > balllocation.y){
        
      if (mouseButton == LEFT) {
        
      // Bouncing the ball back and applyng multipliers to speed of ball
      ballvelocity.x = ballvelocity.x * -1; 
      if(paddlevelocity > 0 && ballvelocity.y < 0){
        ballvelocity.x = ballvelocity.x * 1.5 + paddlevelocitymultiplier;
        ballvelocity.y = ballvelocity.y * -1.05 - paddlevelocitymultiplier;
      }else if(paddlevelocity < 0 && ballvelocity.y > 0){
        ballvelocity.x = ballvelocity.x * 1.5 - paddlevelocitymultiplier;
        ballvelocity.y = ballvelocity.y * -1.05 + paddlevelocitymultiplier;
      }else if(paddlevelocity == 0){
        ballvelocity.x = ballvelocity.x * 1.5;
        ballvelocity.y = ballvelocity.y * 1.05;
      }
      
      playMusic((dataPath("")+ "\\deflect.wav"));
      deflectanimation[0] = true; 
      
    }
    else if (mouseButton == RIGHT) {
      
      // Bouncing the ball back and applyng multipliers to speed of ball
      ballvelocity.x = ballvelocity.x * -1; 
      if(paddlevelocity > 0 && ballvelocity.y < 0){
        ballvelocity.x = ballvelocity.x * 1.05 + paddlevelocitymultiplier;
        ballvelocity.y = ballvelocity.y * -1.35 - paddlevelocitymultiplier;
      }else if(paddlevelocity < 0 && ballvelocity.y > 0){
        ballvelocity.x = ballvelocity.x * 1.05 - paddlevelocitymultiplier;
        ballvelocity.y = ballvelocity.y * -1.35 + paddlevelocitymultiplier;
      }else if(paddlevelocity == 0){
        ballvelocity.x = ballvelocity.x * 1.05;
        ballvelocity.y = ballvelocity.y * 1.35;
      }
      
      playMusic((dataPath("")+ "\\lightdeflect.wav"));
      deflectanimation[1] = true; 
    }
       
      balllocation.x += 10;
      }
  }
  // checks for if the mouse if hovering over one of the input fields in the options menu
  if(mouseX > 0 && mouseX < 250 && mouseY > 250 && mouseY < 280){
      optionsinputcheck1[0] = true;
      optionsinputcheck2[0] = false;
      optionsinputcheck2[1] = false;
  }
  if(mouseX > 0 && mouseX < 315 && mouseY > 340 && mouseY < 370){
      optionsinputcheck1[0] = false;
      optionsinputcheck1[1] = false;
      optionsinputcheck2[0] = true;
  }
}

void keyPressed(){
  if(screen == MENU){
    // if space is pressed on the menu go to game screen
    if(key == ' '){
      screen = GAME;
      reset();
      score[0] = 0;
      score[1] = 0;
      playMusic((dataPath("") + "\\select.wav"));
    }
    // if alt is pressed on the menu go to options screen
     else if(keyCode == ALT){
      screen = OPTIONS;
      playMusic((dataPath("") + "\\select.wav"));
    }
    // if shift is pressed on the menu exit the program
     else if(keyCode == SHIFT){
       playMusic((dataPath("") + "\\ping.wav"));
       exit();
    }
  }
  else if(screen == GAME){
    // if shift is pressed when on the game screen then return to menu
    if(keyCode == SHIFT){
       returnscreen();
       reset();
       playMusic((dataPath("") + "\\ping.wav"));
    }
  }
  else if(screen == OPTIONS && optionsinputcheck1[0] && optionsinputcheck1[1] == true && key != CODED){
      // backspace deletes latest character in current input field
      if(key == BACKSPACE){
        if(input1.length() != 0){
             input1 = input1.substring(0,input1.length()-1);
          }
        if(caret.length() != 0){
             caret = caret.substring(0,caret.length()-1);
          }
      }
      // the enter key sets the value of the variable you changed 
      else if(key == ENTER){
        // check to see if input is valid
        if(finalinput1 > 900 || finalinput1 <= 0){
            finalinput1 = int(input1);
          }
          else {
            playareawidth = 900;
            aipaddlex = playareawidth + 20;
          }
        }
      else{
      // input key pressed into text field 
      input1 = input1 + key; 
      caret = (caret + " ");
      }


  }else if(screen == OPTIONS && optionsinputcheck2[0] && optionsinputcheck2[1] == true && key != CODED){
     // backspace deletes latest character in current input field
     if(key == BACKSPACE){
        if(input2.length() != 0){
           input2 = input2.substring(0,input2.length()-1);
        }
        if(caret2.length() != 0){
           caret2 = caret2.substring(0,caret2.length()-1);
        }
    }
    // the enter key sets the value of the variable you changed 
    else if(key == ENTER){
      // check to see if input is valid
      if( finalinput2 > 850 || finalinput2 <= 0){
        finalinput2 = int(input2);
      }
       else {
         playareaheight = 850;
      }
    }
    // input key pressed into text field 
    else{
    input2 = input2 + key; 
    caret2 = (caret2 + " ");
    }
  }
  else if(screen == OPTIONS){
    // if shift is pressed it returns the user to the menu
    if(keyCode == CONTROL){
          optionsinputcheck1[0] = false;
          optionsinputcheck2[0] = false;
          returnscreen();
          playMusic((dataPath("") + "\\ping.wav"));
      }
  }
  else if(screen == GAMEOVER){
    // if space is pressed then reinitialize the game
    if(key == ' '){
      reset();
      score[0] = 0;
      score[1] = 0;
      screen = GAME;
      playMusic((dataPath("") + "\\select.wav"));
    }
  // if shift is pressed it returns the user to the menu
  else if(keyCode == SHIFT){
        returnscreen();
        playMusic((dataPath("") + "\\select.wav"));
    }
  }
  else if(screen == NAMINGCEREMONY && key != CODED){
      // backspace deletes latest character in current input field
      if(key == BACKSPACE){
        if(filestring.length() != 0){
             filestring = filestring.substring(0,filestring.length()-1);
          }
      }
      // the enter key sets the value of the variable you changed 
      else if(key == ENTER){
        finalname = filestring;
        totalwins = readfiletotalwins(finalname, dataPath("") + "\\totalwins.txt");
        screen = MENU;
      }
      else{
        // input key pressed into text field 
        filestring = filestring + key; 
      }
    }
} 

void returnscreen(){
    if(screen == MENU){
      exit(); 
    }
    else if(screen == GAME){
      screen = MENU;
      if(readfiletotalwins(finalname, dataPath("") + "\\totalwins.txt") == 0){
        writetotalwinsandnametofile(finalname, playerwinscounter, dataPath("") + "\\totalwins.txt");
      }
        
    }
    else if(screen == OPTIONS){
      screen = MENU;
    }
    else if(screen == GAMEOVER){
      screen = MENU;
    }
}

void reset(){
  // sets ~all variables back to default
  balllocation.x = playareawidth / 2;
  balllocation.y = playareaheight / 2;
  ballvelocity.x = 2;
  ballvelocity.y = 5;
  playerwins = false;
  aiwins = false;
}

boolean mouseybordercheck(){
  // is the mouse touching the border?
  if(mouseY < playareaheight - 5 && mouseY > 75){
      return true; 
  }
  return false; 
  
}

void heavywaveanimation(float x, float y, int i){
 if(mouseybordercheck() == true){
    // creates a parabola around the paddle
    noFill();
    strokeWeight(1.5);
    beginShape();
    vertex(x + i, y + 100);
    quadraticVertex(x + 80, y + 40, x + i, y- 20 );
    endShape();
    
    wavey = y;
 }else{ 
    // creates a parabola around the paddle
    noFill();
    strokeWeight(1.5);
    beginShape();
    vertex(x + i, wavey + 100);
    quadraticVertex(x + 80, wavey + 40, x + i, wavey - 20 );
    endShape();
 }
}
void lightwaveanimation(float x, float y, int i){
  if(mouseybordercheck() == true){
    x -= 15;
    // creates an inversed and flipped parabola around the paddle
    noFill();
    strokeWeight(1.5);
    beginShape();
    vertex(x + i, y + 100);
    quadraticVertex(x + 20, y + 40, x + i, y - 20 );
    endShape();
    
    wavey = y;
  }else{ 
    x -= 15;
    // creates an inversed and flipped parabola around the paddle
    noFill();
    strokeWeight(1.5);
    beginShape();
    vertex(x + i, wavey + 100);
    quadraticVertex(x + 20, wavey + 40, x + i, wavey - 20 );
    endShape();
  }
}

void wavecheck(){
   // contains frame data for the parabola animations and keeps track of current frame
   if(deflectanimation[0] == true){
      if(i < 50){
        heavywaveanimation(paddlex, mouseY,i);
      }else{
        i = 0;
        deflectanimation[0] = false; 
      }
      if(j == 4){
        i+=10;
        j = 0; 
      }
      j++;
    }
   else if (deflectanimation[1] == true){
      if(i < 50){
        lightwaveanimation(paddlex, mouseY,i);
      }else{
        i = 0;
        deflectanimation[1] = false; 
      }
      if(j == 4){
        i+=10;
        j = 0; 
      }
      j++;
    }
}

void playMusic(String filepath){
     try{
        // access .wav file at filelocation, opens audio stream and plays it. completes when file length is finished 
        File music = new File(filepath);
        AudioInputStream audio = AudioSystem.getAudioInputStream(music);
        Clip audioClip = AudioSystem.getClip();
        audioClip.open(audio);
        
        audioClip.start();
        audio.close();
     }
     catch(Exception e){
         
     }   
}

public int readfiletotalwins(String name, String filepath){
        try {
            // Access file
            File inFile = new File(filepath);
            Scanner inp = new Scanner(inFile);
            
            String text = inp.nextLine();
            
            String [] names; 
            names = text.split(" ");
            String [][] scoresandnames = new String [names.length][2];
            int [] scores = new int [scoresandnames.length];
            int score;
            
            // seperate file into names and scores
            for(int i = 0; i < names.length; i++){
              scoresandnames[i] = names[i].split(":");
              
            }
            for(int i = 0; i <= scoresandnames.length-1; i++){
              names[i] = scoresandnames[i][0];
              scores[i] = int(scoresandnames[i][1]);
            }
            

            for(int i = 0; i < names.length; i++){
              if(name.equals(names[i])){
                score = Integer.parseInt(scoresandnames[i][1]);
                return score;
              }
            }
            
            }catch (FileNotFoundException e){
              System.out.println("Something went wrong.");
              e.printStackTrace();
            }
          return 0;
}
    
public boolean writetotalwinsandnametofile(String name, int score,String filepath){
    try{
        // Accesses output file
        File inFile = new File(filepath);
        Scanner inp = new Scanner(inFile);
        FileWriter outFile = new FileWriter(filepath,true);

        String text = inp.nextLine();
        
        String [] names; 
        names = text.split(" ");
        String [][] scoresandnames = new String [names.length][2];
        int [] scores = new int [scoresandnames.length];
        
        // seperate file into names and scores
        for(int i = 0; i < names.length; i++){
          scoresandnames[i] = names[i].split(":");
        }
        for(int i = 0; i <= scoresandnames.length-1; i++){
          names[i] = scoresandnames[i][0];
          scores[i] = int(scoresandnames[i][1]);
        }
        
        for(int i = 0; i < names.length; i++){
          if(name.equals(names[i])){
              if(score > scores[i]){
                text = text.replace(char(scores[i]), char(score));
              }
              // Clears file and replaces all information with updated version
              PrintWriter pw = new PrintWriter(inFile);
              outFile.write(text);
              outFile.close();
              return true;
            }
        }
        outFile.write(" " + name + ":" + score);
        outFile.close();
        return true;

        } catch(IOException e){
          System.out.println("Something went wrong.");
          e.printStackTrace();
          return true;
        }
}
