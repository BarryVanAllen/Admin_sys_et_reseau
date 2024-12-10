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
        for (int j = 0; j < NB_PILOTES - i - 1; j++) {
            if (pilotes[j].temps_meilleur_tour > pilotes[j + 1].temps_meilleur_tour) {
                Pilote temp = pilotes[j];
                pilotes[j] = pilotes[j + 1];
                pilotes[j + 1] = temp;
            }
        }
    }
    
    afficher_resultats(pilotes, type_session);
}

void simulations_qualifications(Pilote pilotes[]) {
    float base_temps = 75.0;  // Temps de base plus rapide
    
    // Q1 : Élimination des 5 derniers
    for (int i = 0; i < NB_PILOTES; i++) {
        int difficulte = rand() % 8;
        pilotes[i].temps_meilleur_tour = generer_temps_tour(base_temps, difficulte);
    }
    
    // Tri des pilotes par temps
    for (int i = 0; i < NB_PILOTES - 1; i++) {
        for (int j = 0; j < NB_PILOTES - i - 1; j++) {
            if (pilotes[j].temps_meilleur_tour > pilotes[j + 1].temps_meilleur_tour) {
                Pilote temp = pilotes[j];
                pilotes[j] = pilotes[j + 1];
                pilotes[j + 1] = temp;
            }
        }
    }
    
    // Attribution des positions de grille
    for (int i = 0; i < NB_PILOTES; i++) {
        pilotes[i].position_grille = i + 1;
    }
    
    afficher_resultats(pilotes, "Qualifications");
}

void simulation_course(Pilote pilotes[]) {
    // Simulation basique de la course
    for (int i = 0; i < NB_PILOTES; i++) {
        int variation_course = rand() % 5;
        pilotes[i].temps_meilleur_tour += variation_course;
    }
    
    // Tri final basé sur les temps de course
    for (int i = 0; i < NB_PILOTES - 1; i++) {
        for (int j = 0; j < NB_PILOTES - i - 1; j++) {
            if (pilotes[j].temps_meilleur_tour > pilotes[j + 1].temps_meilleur_tour) {
                Pilote temp = pilotes[j];
                pilotes[j] = pilotes[j + 1];
                pilotes[j + 1] = temp;
            }
        }
    }
    
    afficher_resultats(pilotes, "Course Finale");
}

SDL_Window* creer_fenetre() {
    SDL_Window* fenetre = SDL_CreateWindow(
        "Simulation Weekend Formule 1", 
        SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 
        800, 600, 
        SDL_WINDOW_SHOWN
    );
    return fenetre;
}

void afficher_resultats(Pilote pilotes[], char* titre) {
    SDL_Window* fenetre = SDL_CreateWindow(
        titre, 
        SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 
        800, 600, 
        SDL_WINDOW_SHOWN
    );
    
    SDL_Renderer* renderer = SDL_CreateRenderer(fenetre, -1, SDL_RENDERER_ACCELERATED);
    SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255);
    SDL_RenderClear(renderer);
    
    TTF_Font* font = TTF_OpenFont("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 20);
    
    SDL_Color couleur_texte = {0, 0, 0, 255};
    char buffer[200];
    
    for (int i = 0; i < NB_PILOTES; i++) {
        snprintf(buffer, sizeof(buffer), 
            "%d. %s : %.3f s", 
            i + 1, 
            pilotes[i].nom, 
            pilotes[i].temps_meilleur_tour
        );
        
        SDL_Surface* surface = TTF_RenderText_Solid(font, buffer, couleur_texte);
        SDL_Texture* texture = SDL_CreateTextureFromSurface(renderer, surface);
        
        SDL_Rect position;
        position.x = 50;
        position.y = 50 + (i * 30);
        SDL_QueryTexture(texture, NULL, NULL, &position.w, &position.h);
        
        SDL_RenderCopy(renderer, texture, NULL, &position);
        
        SDL_FreeSurface(surface);
        SDL_DestroyTexture(texture);
    }
    
    SDL_RenderPresent(renderer);
    
    // Attendre un moment avant de fermer
    SDL_Delay(5000);
    
    SDL_DestroyRenderer(renderer);
    TTF_CloseFont(font);
    SDL_DestroyWindow(fenetre);
}
