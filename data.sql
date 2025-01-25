CREATE TABLE IF NOT EXISTS `fightbans` (
  `Steam` text DEFAULT NULL,
  `isBnaned` int(11) DEFAULT NULL,
  `Expire` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;