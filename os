#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <SDL2/SDL.h>
#include <SDL2/SDL_ttf.h>

#define NB_PILOTES 20
#define NB_TOURS_FP1 20
#define NB_TOURS_FP2 20
#define NB_TOURS_FP3 20
#define NB_TOURS_QUALIFICATION 12
#define NB_TOURS_COURSE 53

// Structure pour représenter un pilote
typedef struct {
    char nom[50];
    float temps_meilleur_tour;
    int position_grille;
} Pilote;

// Prototype des fonctions
void initialiser_pilotes(Pilote pilotes[]);
float generer_temps_tour(float base_temps, int difficulte);
void simulations_essais_libres(Pilote pilotes[], char* type_session);
void simulations_qualifications(Pilote pilotes[]);
void simulation_course(Pilote pilotes[]);
void afficher_resultats(Pilote pilotes[], char* titre);
SDL_Window* creer_fenetre();
void afficher_texte(SDL_Renderer* renderer, TTF_Font* font, const char* texte, int x, int y);

int main() {
    srand(time(NULL));
    
    // Initialisation des pilotes
    Pilote pilotes[NB_PILOTES];
    initialiser_pilotes(pilotes);
    
    // Initialisation SDL
    SDL_Init(SDL_INIT_VIDEO);
    TTF_Init();
    SDL_Window* fenetre = creer_fenetre();
    
    // Simulation des essais libres
    printf("--- Essais Libres 1 ---\n");
    simulations_essais_libres(pilotes, "Essais Libres 1");
    
    printf("\n--- Essais Libres 2 ---\n");
    simulations_essais_libres(pilotes, "Essais Libres 2");
    
    printf("\n--- Essais Libres 3 ---\n");
    simulations_essais_libres(pilotes, "Essais Libres 3");
    
    // Simulation des qualifications
    printf("\n--- Qualifications ---\n");
    simulations_qualifications(pilotes);
    
    // Simulation de la course
    printf("\n--- Course ---\n");
    simulation_course(pilotes);
    
    // Fermeture SDL
    SDL_DestroyWindow(fenetre);
    TTF_Quit();
    SDL_Quit();
    
    return 0;
}

void initialiser_pilotes(Pilote pilotes[]) {
    const char* noms_pilotes[] = {
        "Verstappen", "Hamilton", "Pérez", "Russell", "Sainz",
        "Leclerc", "Norris", "Piastri", "Ocon", "Gasly",
        "Alonso", "Stroll", "Bottas", "Zhou", "Magnussen",
        "Sargeant", "Ricciardo", "De Vries", "Tsunoda", "Sargent"
    };
    
    for (int i = 0; i < NB_PILOTES; i++) {
        strcpy(pilotes[i].nom, noms_pilotes[i]);
        pilotes[i].temps_meilleur_tour = 0.0;
        pilotes[i].position_grille = 0;
    }
}

float generer_temps_tour(float base_temps, int difficulte) {
    float variation = (rand() % 500) / 1000.0;  // Variation jusqu'à 0.5 seconde
    float coefficient_difficultee = 1.0 + (difficulte * 0.01);
    return base_temps * coefficient_difficultee + variation;
}

void simulations_essais_libres(Pilote pilotes[], char* type_session) {
    float base_temps = 80.0;  // Temps de base d'un tour
    
    for (int i = 0; i < NB_PILOTES; i++) {
        int difficulte = rand() % 10;  // Difficulté variable
        pilotes[i].temps_meilleur_tour = generer_temps_tour(base_temps, difficulte);
        printf("%s : Meilleur tour en %.3f secondes\n", pilotes[i].nom, pilotes[i].temps_meilleur_tour);
    }
    
    // Tri des pilotes par temps
    for (int i = 0; i < NB_PILOTES - 1; i++) {
... (119 lines left)
