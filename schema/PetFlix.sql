CREATE TABLE membresAsso (
  id_membres INTEGER PRIMARY KEY AUTO_INCREMENT,
  nom VARCHAR(50),
  prenom VARCHAR(50),
  ville VARCHAR(50),
  email VARCHAR(50),
  telephone VARCHAR(50)
);

CREATE TABLE video (
  id_video INTEGER PRIMARY KEY AUTO_INCREMENT,
  titre VARCHAR(50),
  description VARCHAR(255),
  url VARCHAR(255),
  date_ajout DATE
);

CREATE TABLE adoptant (
  id_adoptant INTEGER PRIMARY KEY AUTO_INCREMENT,
  nom VARCHAR(50),
  prenom VARCHAR(50),
  adresse VARCHAR(50),
  email VARCHAR(50)
);

CREATE TABLE animal (
  id_animal INTEGER PRIMARY KEY AUTO_INCREMENT,
  type VARCHAR(50),
  nom VARCHAR(50),
  age INTEGER,
  date_arrive DATE,
  date_adoption DATE,
  id_video INTEGER REFERENCES video(id_video),
  id_membres INTEGER REFERENCES membresAsso(id_membres)
);

CREATE TABLE adoption (
  id_adoption INTEGER PRIMARY KEY AUTO_INCREMENT,
  date_adoption DATE,
  id_animal INTEGER REFERENCES animal(id_animal),
  id_adoptant INTEGER REFERENCES adoptant(id_adoptant)
);

CREATE TABLE controle (
  id_controle INTEGER PRIMARY KEY AUTO_INCREMENT,
  date_controle DATE,
  id_adoption INTEGER REFERENCES adoption(id_adoption)
);
