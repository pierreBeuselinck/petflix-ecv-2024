CREATE TABLE `animal` (
  `id_animal` integer PRIMARY KEY,
  `type` varchar(255),
  `nom` varchar(255),
  `age` integer,
  `date_arrive` datetime,
  `date_adoption` datetime,
  `id_video` integer,
  `id_membres` integer
);

CREATE TABLE `membresAsso` (
  `id_membres` integer PRIMARY KEY,
  `nom` varchar(255),
  `prenom` varchar(255),
  `ville` varchar(255),
  `email` email,
  `telephone` tel
);

CREATE TABLE `video` (
  `id_video` integer PRIMARY KEY,
  `titre` varchar(255),
  `description` varchar(255),
  `url` varchar(255),
  `date_ajout` datetime
);

CREATE TABLE `adoptant` (
  `id_adoptant` integer PRIMARY KEY,
  `nom` varchar(255),
  `prenom` varchar(255),
  `adresse` varchar(255),
  `email` email
);

CREATE TABLE `adoption` (
  `id_adoption` integer PRIMARY KEY,
  `date_adoption` datetime,
  `id_animal` integer,
  `id_adoptant` integer
);

CREATE TABLE `controle` (
  `id_controle` integer PRIMARY KEY,
  `date_controle` datetime,
  `id_adoption` integer
);

ALTER TABLE `animal` ADD FOREIGN KEY (`id_video`) REFERENCES `video` (`id_video`);

ALTER TABLE `animal` ADD FOREIGN KEY (`id_membres`) REFERENCES `membresAsso` (`id_membres`);

ALTER TABLE `adoption` ADD FOREIGN KEY (`id_animal`) REFERENCES `animal` (`id_animal`);

ALTER TABLE `adoption` ADD FOREIGN KEY (`id_adoptant`) REFERENCES `adoptant` (`id_adoptant`);

ALTER TABLE `controle` ADD FOREIGN KEY (`id_adoption`) REFERENCES `adoption` (`id_adoption`);
