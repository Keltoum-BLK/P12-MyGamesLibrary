# P12-MyGamesLibrary

NOTE D’INTENTION
Parcours développeur iOS

![image](https://user-images.githubusercontent.com/70690676/159730997-c5745f71-70df-450f-a217-630b36494b99.png)

Projet 12 

Pourquoi : 

J’ai décidé de créer une application de catalogue de jeux vidéo. 
My Games Library est une application qui répertorie les jeux vidéo des plateformes Playstation 4, Xbox One et Switch (en V1).

Si j’ai décidé de mettre au point cette application, c’est qu’en tant que joueuse de jeux vidéo, il existe peu de catalogue multiplateforme ou d’application qui proposent d’avoir la liste de sa ludothèque à porter de main. 

J’ai voulu proposer une application qui permet de répertorier ses jeux vidéo et de les avoir sous la main dans le cas où on est à la recherche d’un nouveau jeu mais que nous n’avons pas accès visuellement à notre ludothèque. 

Comment : 

L’application est construite avec un patron de conception en MVC.

Elle utilise CoreData pour la persistance des données et la création d’une base de données pour l’enregistrement des jeux ajoutés au catalogue.

Elle fait aussi appel à deux API :
•	UPCItem : qui récupère les données à partir d’un code barre.
•	RAW.IO : qui est une api de base de données de jeux vidéo.

L’application permet de chercher des jeux vidéo parmi 3 onglets (un onglet par plateforme) mais aussi dans un partie recherche pour rajouter le jeu au catalogue, il suffit d’afficher le jeu et d’appuyer sur le bouton d’ajout.

Dans cette partie, il est possible de rechercher un jeu mais aussi de le rajouter au catalogue et de chercher un jeu par le biais d’un lecteur de code barre intégrer à l’application, qui va aussi vérifier grâce aux informations récupérées si le jeu fait partie notre catalogue. 

Pour l’utilisation du lecteur de code barre, l’application utilise la librairie AVFoundation et aussi PhotosUI de la bibliothèque de librairie de XCode pour créer une fiche de jeu vidéo avec l’ajout d’image avec un picker. 

Dans le cas où le code barre de ne fonctionne pas il est possible de rajouter le jeu au catalogue par le biais d’un formulaire qui prend en compte l’ajout de photo et accessible par la partie recherche.

Dans le catalogue de jeux vidéo les jeux sont séparés par plateforme : Playstation, Xbox et Nintendo.

Dans cette partie l’utilisateur pourra chercher un jeu dans la liste mais aussi supprimer le jeu de la librairie.


