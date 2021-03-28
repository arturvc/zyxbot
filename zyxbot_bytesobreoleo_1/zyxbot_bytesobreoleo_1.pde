int e = 3; 
int oX = 10 * e;
int oY = 20 * e;
float x0, y0, x1, y1, x2, y2, x3, y3;
int z = -10;
int zTinta = -15;
int zLivre = 0;

int feedZ = 200;
int feed = 4000;

int oLinhas = 6; // distancia entre as linhas

float pontos[][];
int segmentos = 5; // na verdade número de pontos, o número de segmentos é (segmentos -1).

float ruidoY = 3; // Ruído do Y.

float ruidoZ = 0; // Ruido do Z

int tL = 300 * e; // Largura da tela
int tA = 200 * e; // Altura da tela

int r = 5;  // Raio da ellipse de representação.

int tintas[][] = { 
  {30, 245}, 
  {70, 245}, 
  {110, 245}, 
  {150, 245}, 
  {190, 245}
};

int balde;

int tintasRaio = 38;

String txt1;
String txt2;
String[] txtFinal ={};


void setup() {
  size(960, 810);
  frameRate(5);
  textSize(20);
  strokeWeight(2);

  pontos = new float[2][segmentos];
}

void draw() {
  background(50);

  noStroke();
  fill(255);
  rect(oX, oY, 300 * e, 200 * e);
  //text(mouseX/e  + ", " + mouseY/e * -1, 250 * e, 240 * e);

  for (int i = 0; i < tintas.length; i++) {
    fill(200);
    ellipse(tintas[i][0] * e, tintas[i][1] * e, tintasRaio * e, tintasRaio * e);
    fill(255, 50, 0);
    textAlign(CENTER);
    //text(tintas[i][0] + ", " + tintas[i][1] * -1, tintas[i][0] * e, tintas[i][1] * e);
  }

  textAlign(LEFT);


  stroke(0, 0, 0);
  noFill(); 
  //fill(0, 255, 0);


  for (int j = 0; j < tA + oLinhas; j+=oLinhas * e) {
    beginShape();
    stroke(50, 100, 250);

    for (int i = 0; i < segmentos; i++) { 
      if (i == 0) {
        pontos[0][i] = oX;
        pontos[1][i] = oY + j;
      } else if (i == segmentos -1) {
        pontos[0][i] = oX + tL;
        pontos[1][i] = oY + j;
      } else if (i < segmentos/2) {
        pontos[0][i] = random(pontos[0][i-1], oX + tL * 0.6);
        pontos[1][i] = oY + j+ random(-ruidoY* e, ruidoY* e);
      } else {
        pontos[0][i] = random(pontos[0][i-1], oX + tL);
        pontos[1][i] = oY + j+ random(-ruidoY* e, ruidoY * e);
      }

      pontos[1][i] = constrain(pontos[1][i], oY, oY + tA);
      vertex(pontos[0][i], pontos[1][i]);
      ellipse(pontos[0][i], pontos[1][i], r, r);
    }
    endShape();


    txtFinal = append(txtFinal, "(LINHA " + j +")");

    for (int k = 0; k < segmentos; k++) {
      pontos[0][k] = pontos[0][k] / e;
      pontos[1][k] = pontos[1][k] / -e;
    }
    for (int k = 0; k < segmentos; k++) {
      balde = int(random(0, 5));
      if (k + 1 <= segmentos -1) {
        txtFinal = append(txtFinal, "(CARREGAR TINTA)");
        txtFinal = append(txtFinal, "G00 Z" + zLivre +  " (Subiu!)");
        txtFinal = append(txtFinal, "G00 X" + tintas[balde][0] + " Y" + tintas[balde][1] * -1 + " (Indo para o balde de tinta " + balde + ")");
        carregar(balde);

        txtFinal = append(txtFinal, "G00 Z" + zLivre +  " (Subiu!)");
        txtFinal = append(txtFinal, "(PINTAR!)");
        txtFinal = append(txtFinal, "G00 X" + pontos[0][k] + " Y" + pontos[1][k] + " (Pronto!)");
        txtFinal = append(txtFinal, "G01 Z" + (z - random(0, ruidoZ)) + " F" + feedZ +  " (Desceu...)");
        txtFinal = append(txtFinal, "G01 X" + pontos[0][k+1] + " Y" + pontos[1][k+1] + " Z" + (z - random(0, ruidoZ)) + " F" + feed  + " (Foi..)");
        txtFinal = append(txtFinal, "G01 X" + pontos[0][k] + " Y" + pontos[1][k] + " Z" + (z - random(0, ruidoZ)) + " F" + feed + " (... voltou!)");
        txtFinal = append(txtFinal, "G00 Z" + zLivre +  " (Subiu!)");
      } else {
        //txtFinal = append(txtFinal, "G00 Z" + zLivre +  " (Subiu!)");
        txtFinal = append(txtFinal, "");
      }
    }
  }

  saveStrings("bytesobreoleo.ngc", txtFinal);

  noLoop();
}


//      txtFinal = append(txtFinal, txtPintar[k]);



void carregar(int num) {
  txtFinal = append(txtFinal, "G01 Z" + zTinta + " F" + feedZ +  " (Desceu...)");

  beginShape();
  for (int i = 0; i < 3; i++) {
    float ruidoX = random(-11, 11);
    float ruidoY = random(-11, 11);
    vertex ((tintas[num][0] + ruidoX) * e, (tintas[num][1]  + ruidoY) * e);
    txtFinal = append(txtFinal, "G01 X" + (tintas[num][0] + ruidoX) + " Y" + (tintas[num][1] * -1 + ruidoY) + " F" + feed);
  }
  endShape();
}
