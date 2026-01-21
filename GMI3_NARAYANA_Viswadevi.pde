/////////////////////////////////////////////////////
//
// Démineur
// DM "UED 131 - Programmation impérative" 2023-2024
// NOM         : NARAYANASSAMYCHETTIAR
// Prénom      : Viswadevi
// N° étudiant : 20231925
// Collaboration avec :
//
/////////////////////////////////////////////////////
//
// Initialisation de la fenêtre graphique
//
int cote, bandeau, colonnes, lignes, etat;
// ETAT
final int INIT = 0, STARTED = 1, OVER = 2;

// ETAT_BLOC
final int BLOC = 0, EMPTY = 1, FLAG = 2;

int etat_bloc;
int start, time ;

PFont font;
PFont font2;
// nombre de mine (donc le nombre de drapeau qu'on peut mettre)
int nbr_de_mines = 100;

// Tab à 2 dimensions : état de bloc
int[][] paves;
// Tab à 2 dimensions :position des bombes dans la grille
boolean[][] bombes;
// Tab à 2 dimensions : état de bloc
int[][] nb_bombes;

void settings() {
  cote = 20;
  bandeau=50;
  colonnes=30;
  lignes=16;
  size (cote*colonnes, cote* lignes+bandeau);
}

//
// Initialisation du programme
//
void setup() {
  init();
  etat = INIT;
  etat_bloc = BLOC;
}

//
// Initialisation du jeu
//
void init() {
  etat_bloc = BLOC;

  paves = new int[colonnes][lignes];
  // Initialisation de tous les blocs dans l'état BLOC
  for (int i=0; i<paves.length; i++) {
    for (int j=0; j<paves[i].length; j++) {
      paves[i][j] = BLOC;
    }
  }

  bombes  = new boolean[colonnes][lignes];
  // Initialisation de toutes les valeurs du tableau bombes à false
  for (int i=0; i<bombes.length; i++) { 
    for (int j=0; j<bombes[i].length; j++) {
      bombes[i][j] = false;
    }
  }
  //Placement des 100 bombes aléatoirement
  for (int i=0; i<nbr_de_mines; i++) {
    int x = int (random(colonnes));
    int y = int(random(lignes));
    if (bombes[x][y]!=true) {
      bombes[x][y] = true;
    } else
      i--;
  }
  // Initialisation de toutes les valeurs à 0
  nb_bombes = new int[colonnes][lignes];
  for (int i=0; i<nb_bombes.length; i++) {
    for (int j=0; j<nb_bombes[i].length; j++) {
      nb_bombes[i][j] = 0;
    }
  }
  nbr_de_mines =100;
}


//
// boucle de rendu
// - met à jour le temps écoulé depuis le début de la résolution
// - appelle la fonction d'affichage
//
void draw() {
  display();
  drawTime();
  drawScore ();
  if (etat == INIT || etat == STARTED) {
    drawHappyFace ();
  } else if (etat == OVER) {
    drawSadFace ();
  }
}

//
// calcule le nombre de bombes dans les 8 cases voisines
// (x, y) = coordonnées de la case
//

int voisins(int x, int y) {
  int n = 0;

  // Les blocs voisins
  for (int i = x - 1; i <= x + 1; i++) {
    for (int j = y - 1; j <= y + 1; j++) {
      // Vérifie si la case est à l'interieur de la grille
      if (i >= 0 && i < 30 && j >= 0 && j < 16) {
        // Exclusion du bloc central
        if (!(i == x && j == y)) {
          if (bombes[i][j]) {
            n++;
          }
        }
      }
    }
  }

  return n;
}

//
// affiche un bloc
// (x, y) = coordonnées du bloc
// (w, h) = dimensions du bloc
//
void drawBloc(int x, int y) {
  pushMatrix();
  translate(x, y+bandeau);
  noStroke ();
  // carré
  fill (192);
  rect (2, 2, 16, 16);

  fill (255);
  //horizontal
  rect(0, 0, 19, 1);
  rect(0, 0, 18, 2);
  //vertical
  rect(0, 0, 1, 19);
  rect(0, 0, 2, 18);

  fill (128);
  //horizontal
  rect (18, 1, 1, 19);
  rect (19, 0, 1, 20);
  //vertical
  rect (1, 18, 19, 1);
  rect (0, 19, 20, 1);
  popMatrix();
}

//
// affiche un drapeau dans la case
// (x, y) = coordonnées de la case
//
void drawFlag(int x, int y) {
  pushMatrix();
  translate(x, y+bandeau);
  noStroke ();
  fill(0);
  //barre
  rect (10, 4, 1, 13);
  //base
  rect (6, 13, 9, 1);
  rect (6, 14, 9, 1);
  rect(4, 15, 13, 1);
  rect(4, 16, 13, 1);

  fill (255, 0, 0);
  rect(9, 4, 1, 1);
  rect(7, 5, 3, 1);
  rect(5, 6, 5, 1);
  rect(7, 7, 3, 1);
  rect(9, 8, 1, 1);
  popMatrix();
}

//
// affiche une bombe dans la case
// (x, y) = coordonnées de la case
//
void drawBomb(int x, int y) {
  pushMatrix();
  translate(x, y+bandeau);
  noStroke ();
  fill(0);
  //trait diagonal
  rect(6, 6, 1, 1);
  rect(5, 5, 1, 1);

  rect(14, 6, 1, 1);
  rect(15, 5, 1, 1);

  rect(6, 14, 1, 1);
  rect(5, 15, 1, 1);

  rect(14, 14, 1, 1);
  rect(15, 15, 1, 1);

  // trait vertical haut bas
  rect(10, 4, 1, 2);
  rect(10, 15, 1, 2);

  //Saturne
  //haut
  rect(8, 6, 5, 1);
  rect(7, 7, 7, 1);

  //droite
  rect(6, 8, 2, 1);
  rect(6, 9, 1, 1);
  rect(4, 10, 3, 1);
  rect(6, 11, 2, 1);

  //gauche
  rect(10, 8, 5, 1);
  rect(11, 9, 4, 1);
  rect(11, 10, 6, 1);
  rect(10, 11, 5, 1);

  //bas
  rect(6, 12, 9, 1);
  rect(7, 13, 7, 1);
  rect(8, 14, 5, 1);
  popMatrix();
}

//
// affiche dans la case le nombre de mines
//  présentes dans les 8 cases voisines
//
void drawNbBombesACote(int i, int j) {
  font2 = createFont("mine-sweeper.ttf", 13);
  textFont(font2);
  switch(voisins(i, j)) {
  case 1:
    fill(0, 35, 245);
    break;
  case 2:
    fill(55, 125, 35);
    break;
  case 3:
    fill(235, 50, 35);
    break;
  case 4:
    fill(120, 25, 120);
    break;
  case 5:
    fill(115, 20, 10);
    break;
  case 6:
    fill(55, 125, 125);
    break;
  default:
    noFill();
  }
  text(voisins(i, j), i*cote+3, j*cote+bandeau+17);
}

//
// affiche le nombre de mines restant à localiser
//
void drawScore() {
  font = createFont ("DSEG7Classic-Bold.ttf", 30);
  // rectangle noir
  fill(0);
  rect(5, 5, 80, 40);
  // fond des chiffres rouges foncés
  fill(90, 10, 10);
  text ("888", 10, 40);
  textFont (font);
  
  // fond des chiffres rouges clairs
  fill(255, 10, 10);
  if (nbr_de_mines==0) {
    text("000", 10, 40);
  }

  if (nbr_de_mines < 10) {
    text("00" + nbr_de_mines, 10, 40);
  } else if (nbr_de_mines < 100) {
    text("0" + nbr_de_mines, 10, 40);
  }

}

//
// affiche le temps écoulé depuis le début de la résolution
//
void drawTime() {
  font = createFont ("DSEG7Classic-Bold.ttf", 30);
  // rectangle noir
  fill(0);
  rect(width - 85, 5, 80, 40);
  // fond des chiffres rouges foncés
  fill(90, 10, 10);
  text ("888", width - 80, 40);

  // chrono affiché
  textFont (font);
  fill(255, 10, 10);

  if (etat == STARTED) {
    time = int((millis() - start) / 1000);
  }
  
  // fond des chiffres rouges clairs
  if (time==0) {
    text("000", width - 80, 40);
  }
  // Réinitialiser le chrono à 0 quand il atteint la valeur 1000
  if (time > 999) {
    time = 0;
  }

  if (time < 10) {
    text("00" + time, width - 80, 40);
  } else if (time < 100) {
    text("0" + time, width - 80, 40);
  } else {
    text(time, width - 80, 40);
  }
}


//
// dessine un smiley content au centre du bandeau
//
void drawHappyFace() {
  pushMatrix ();
  translate (width/2, 5);
  stroke (0);
  fill(255, 255, 0);
  ellipse(20, 20, 20, 20); // Tête

  fill(0);
  ellipse(16, 17, 2, 2); // Oeil gauche
  ellipse(24, 17, 2, 2); // Oeil droit

  noFill();
  strokeWeight(2);
  arc(20, 22, 10, 6, 0, PI); // Bouche qui sourit
  popMatrix ();
}

//
// dessine un smiley mécontent au centre du bandeau
//
void drawSadFace() {
  translate (width/2, 5);
  stroke (0);
  fill(255, 255, 0);
  ellipse(20, 20, 20, 20); // Tête

  // oeil droit
  rect(15, 16, 0.1, 0.1);
  rect(16, 17, 0.1, 0.1);
  rect(17, 18, 0.1, 0.1);
  rect(17, 16, 0.1, 0.1);
  rect(15, 18, 0.1, 0.1);

  // oeil gauche
  rect(23, 16, 0.1, 0.1);
  rect(24, 17, 0.1, 0.1);
  rect(25, 18, 0.1, 0.1);
  rect(25, 16, 0.1, 0.1);
  rect(23, 18, 0.1, 0.1);

  noFill();
  strokeWeight(2);
  arc(20, 25, 12, 6, PI, TWO_PI); // Bouche est mécontent
}

//
// affiche le démineur
//
void display() {

  // bandeau gris clair
  fill (192);
  rect (0, 0, width, bandeau);
  // smiley dans le bloc
  pushMatrix ();
  translate (width/2, 5);
  noStroke ();
  // carré
  fill (192, 192, 192);
  rect (4, 4, 32, 32);

  fill (255);
  //horizontal
  rect(0, 0, 38, 2);
  rect(0, 0, 36, 4);
  // vertical
  rect(0, 0, 2, 38);
  rect(0, 0, 4, 36);

  fill (128, 128, 128);
  //horizontal
  rect (36, 2, 2, 36);
  rect (38, 0, 2, 40);
  //vertical
  rect (2, 36, 38, 2);
  rect (0, 38, 40, 2);
  popMatrix ();
  // zone gris foncé
  fill (192);
  rect (0, bandeau, width, height-bandeau);

  // Affichage de la grille de blocs
  for (int i = 0; i < colonnes; i++) {
    for (int j = 0; j < lignes; j++) {
      // Affichage d'un bloc si la case est dans l'état BLOC ou FLAG
      if (paves[i][j] == BLOC || paves[i][j] == FLAG)
        drawBloc(i*cote, j*cote);
      // Affichage d'un drapeau sur le bloc si la case est dans l'état FLAG
      if (paves[i][j] == FLAG) {
        //drawBloc(i*cote, j*cote);
        drawFlag(i*cote, j*cote);
      }
      if (paves[i][j] == EMPTY && voisins(i, j)!=0)
        drawNbBombesACote(i, j);
    }
  }
// affiche tous les bombes quand etat=OVER
  if (etat== OVER) {
    for (int v=0; v<bombes.length; v++) {
      for (int w=0; w<bombes[w].length; w++) {
        if (bombes[v][w]) {
          pushMatrix();
          noStroke();
          drawBomb(v * cote, w * cote);
          popMatrix();
        }
        
      }
    }
  }
}

//
// affiche le démineur quand on a perdu
// = on révèle l'emplacement des bombes
// et on affiche le smiley mécontent
//
void displayBombs(int x, int y) {
}

//
// calcule les blocs qui doivent être découverts
// = les blocs vides autour si (x, y) est vide
//
void decouvre(int x, int y) {
  
}

//
// calcule les blocs qui doivent être découverts
// = les blocs vides autour de la case (x, y) portant un numéro,
// dont on a localisé tous les blocs voisins
//
void decouvre2(int x, int y) {
}

//
// met à jour le nombre de drapeaux voisins
// qui ont été localisés et marqués
//
void updateNbDrapeaux(int x, int y) {
}

//
// gère les interactions souris
//
void mouseClicked() {
  // calcul position lignes et colonnes
  int pos_x = (mouseY-bandeau)/cote;
  int pos_y = mouseX/cote;
  
  // ETAT
  // initialiation chrono 1e clic
  // Click dans gris foncé (grille)
  if (etat==INIT && mouseY>bandeau) {
    start = millis();
    etat = STARTED;
  }

  // Click dans smiley
  if (etat==STARTED && mouseX > width/2 && mouseX< width/2+40 && mouseY >5 && mouseY<5+40) {
    etat = INIT ;
    init();
  }

  // Click dans bomb
  if (etat==STARTED && bombes[pos_y][pos_x] && mouseButton==LEFT ) {
    etat = OVER;
  }
  // Click dans smiley
  if (etat==OVER &&  mouseX > width/2 && mouseX< width/2+40 && mouseY >5 && mouseY<5+40) {
    etat = INIT ;
    init();
  }
  print ("etat = "+ etat +" ");



  // ETAT_BLOC
  if (mouseButton==LEFT && etat!=OVER && mouseY>bandeau) {
    if (bombes[pos_y][pos_x] && paves[pos_y][pos_x]!=FLAG) {
      etat = OVER;
      paves[pos_y][pos_x] = EMPTY;
      pushMatrix();
      noStroke();
      fill(192);
      rect(pos_y*cote-1, pos_x*cote+bandeau, 20, 20);
      popMatrix();
      noStroke();
      drawBomb(pos_y*cote, pos_x*cote);
      pushMatrix();
      translate(288, 13);
      drawSadFace();
      popMatrix();
    } else if (etat != OVER && paves[pos_y][pos_x]!=FLAG)
      paves[pos_y][pos_x] = EMPTY;
  }

    if (mouseButton==RIGHT && paves[pos_y][pos_x] == BLOC) {
      paves[pos_y][pos_x] = FLAG;
      nbr_de_mines--;
    } else {
      if (mouseButton==RIGHT && paves[pos_y][pos_x] == FLAG) {
        paves[pos_y][pos_x] = BLOC;
        nbr_de_mines++;
      }
    }
    println ("etat_bloc=", +etat_bloc);
  }
