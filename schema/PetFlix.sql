-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost
-- Généré le : ven. 29 mars 2024 à 08:31
-- Version du serveur : 10.4.27-MariaDB
-- Version de PHP : 8.0.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `PetFlix`
--

-- --------------------------------------------------------

--
-- Structure de la table `adoptant`
--

CREATE TABLE `adoptant` (
  `id_adoptant` int(11) NOT NULL,
  `nom` varchar(50) NOT NULL,
  `prenom` varchar(50) NOT NULL,
  `adresse` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `adoptant`
--

INSERT INTO `adoptant` (`id_adoptant`, `nom`, `prenom`, `adresse`, `email`) VALUES
(1, 'Martin', 'Paul', '12 rue des Fleurs', 'martin@example.com'),
(2, 'Dubois', 'Sophie', '8 avenue des Champs', 'dubois@example.com');

-- --------------------------------------------------------

--
-- Structure de la table `adoption`
--

CREATE TABLE `adoption` (
  `id_adoption` int(11) NOT NULL,
  `date_adoption` date NOT NULL,
  `id_animal` int(11) NOT NULL,
  `id_adoptant` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `adoption`
--

INSERT INTO `adoption` (`id_adoption`, `date_adoption`, `id_animal`, `id_adoptant`) VALUES
(3, '2024-03-01', 1, 1);

-- --------------------------------------------------------

--
-- Structure de la table `animal`
--

CREATE TABLE `animal` (
  `id_animal` int(11) NOT NULL,
  `type` varchar(50) NOT NULL,
  `nom` varchar(50) NOT NULL,
  `age` int(11) DEFAULT NULL,
  `date_arrive` datetime NOT NULL,
  `date_adoption` datetime DEFAULT NULL,
  `id_video` int(11) DEFAULT NULL,
  `id_membres` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `animal`
--

INSERT INTO `animal` (`id_animal`, `type`, `nom`, `age`, `date_arrive`, `date_adoption`, `id_video`, `id_membres`) VALUES
(1, 'Chat', 'Minou', 2, '2023-12-24 00:00:00', '2024-03-01 11:38:09', 1, 1),
(2, 'Chien', 'Max', 5, '2023-06-01 00:00:00', '2023-10-17 11:39:17', 2, 2),
(4, 'Chat', 'Felix', 3, '2024-03-24 16:41:42', NULL, 1, 2);

-- --------------------------------------------------------

--
-- Structure de la table `controle`
--

CREATE TABLE `controle` (
  `id_controle` int(11) NOT NULL,
  `date_controle` date NOT NULL,
  `id_adoption` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `controle`
--

INSERT INTO `controle` (`id_controle`, `date_controle`, `id_adoption`) VALUES
(1, '2024-07-17', 3);

-- --------------------------------------------------------

--
-- Structure de la table `membresAsso`
--

CREATE TABLE `membresAsso` (
  `id_membres` int(11) NOT NULL,
  `nom` varchar(50) NOT NULL,
  `prenom` varchar(50) NOT NULL,
  `ville` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `telephone` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `membresAsso`
--

INSERT INTO `membresAsso` (`id_membres`, `nom`, `prenom`, `ville`, `email`, `telephone`) VALUES
(1, 'Dupont', 'Jean', 'Paris', 'dupont@example.com', '0123456789'),
(2, 'Durand', 'Marie', 'Lyon', 'durand@example.com', '0987654321'),
(8, 'Doe', 'John', 'New York', 'john@example.com', '1234567890');

-- --------------------------------------------------------

--
-- Structure de la table `video`
--

CREATE TABLE `video` (
  `id_video` int(11) NOT NULL,
  `titre` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `date_ajout` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `video`
--

INSERT INTO `video` (`id_video`, `titre`, `description`, `url`, `date_ajout`) VALUES
(1, 'Chatons mignons à adopter', 'Découvrez ces adorables chatons qui attendent un nouveau foyer.', 'https://youtu.be/4O7D-n5eqdE', '2023-11-14'),
(2, 'Un chien affectueux cherche sa famille', 'Ce chien adorable et affectueux recherche une famille aimante pour le reste de sa vie.', 'https://www.youtube.com/watch?v=HbFg1dm6v4Y', '2023-11-15'),
(3, 'Border collie et son chat roux', 'Border collie et son chat roux', 'https://www.youtube.com/watch?v=wwZexYjfZIk', '2023-11-16'),
(4, 'Chaton joueur', 'Un chaton joueur qui adore les câlins.', 'https://www.youtube.com/watch?v=abcdefg', '2024-03-24');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `adoptant`
--
ALTER TABLE `adoptant`
  ADD PRIMARY KEY (`id_adoptant`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Index pour la table `adoption`
--
ALTER TABLE `adoption`
  ADD PRIMARY KEY (`id_adoption`),
  ADD KEY `id_animal` (`id_animal`),
  ADD KEY `id_adoptant` (`id_adoptant`);

--
-- Index pour la table `animal`
--
ALTER TABLE `animal`
  ADD PRIMARY KEY (`id_animal`),
  ADD KEY `id_video` (`id_video`),
  ADD KEY `id_membres` (`id_membres`);

--
-- Index pour la table `controle`
--
ALTER TABLE `controle`
  ADD PRIMARY KEY (`id_controle`),
  ADD KEY `id_adoption` (`id_adoption`);

--
-- Index pour la table `membresAsso`
--
ALTER TABLE `membresAsso`
  ADD PRIMARY KEY (`id_membres`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Index pour la table `video`
--
ALTER TABLE `video`
  ADD PRIMARY KEY (`id_video`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `adoptant`
--
ALTER TABLE `adoptant`
  MODIFY `id_adoptant` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `adoption`
--
ALTER TABLE `adoption`
  MODIFY `id_adoption` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `animal`
--
ALTER TABLE `animal`
  MODIFY `id_animal` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `controle`
--
ALTER TABLE `controle`
  MODIFY `id_controle` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `membresAsso`
--
ALTER TABLE `membresAsso`
  MODIFY `id_membres` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT pour la table `video`
--
ALTER TABLE `video`
  MODIFY `id_video` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `adoption`
--
ALTER TABLE `adoption`
  ADD CONSTRAINT `adoption_ibfk_1` FOREIGN KEY (`id_animal`) REFERENCES `animal` (`id_animal`),
  ADD CONSTRAINT `adoption_ibfk_2` FOREIGN KEY (`id_adoptant`) REFERENCES `adoptant` (`id_adoptant`);

--
-- Contraintes pour la table `animal`
--
ALTER TABLE `animal`
  ADD CONSTRAINT `animal_ibfk_1` FOREIGN KEY (`id_video`) REFERENCES `video` (`id_video`),
  ADD CONSTRAINT `animal_ibfk_2` FOREIGN KEY (`id_membres`) REFERENCES `membresAsso` (`id_membres`);

--
-- Contraintes pour la table `controle`
--
ALTER TABLE `controle`
  ADD CONSTRAINT `controle_ibfk_1` FOREIGN KEY (`id_adoption`) REFERENCES `adoption` (`id_adoption`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
