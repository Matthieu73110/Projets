import pygame
from comet import Comet

# Creer une classe pour gérer cet evenement
class CometFallEvent:
    #lors du chargement -> créer un compteur

    def __init__(self, game):
        self.percent = 0
        self.percent_speed = 3
        self.game = game
        self.fall_mode = False

        # definir un groupe de sprite pour stocke nos cometes
        self.all_comets = pygame.sprite.Group()

    def add_percent(self):
        self.percent += self.percent_speed /100

    def is_full_loaded(self):
        return self.percent >= 100

    def reset_percent(self):
        self.percent = 0

    def meteor_fall(self):
        #boucle pour les valeurs entre 1 et 10
        for i in range(1,10):
            # apparaitre une premiere boule de feu
            self.all_comets.add(Comet(self))

    def attempt_fall(self):
        # la jauge d'évenement est totalement chargé
        if self.is_full_loaded() and len(self.game.all_monsters) == 0:
            self.meteor_fall()
            self.fall_mode = True # activer l'evenement

    def update_bar(self, screen):

        #ajouter du pourcentage a la barre
        self.add_percent()

        # barre noir (en arriere plan)
        pygame.draw.rect(screen, (0, 0, 0), [0, screen.get_height() - 20,screen.get_width(),10])
        # barre rouge (jauge event)
        pygame.draw.rect(screen, (187, 11, 11), [0, screen.get_height() - 20, (screen.get_width() / 100) * self.percent, 10])