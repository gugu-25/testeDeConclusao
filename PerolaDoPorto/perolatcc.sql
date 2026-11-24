CREATE DATABASE IF NOT EXISTS `perolatcc_novo`
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE `perolatcc_novo`;
SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

CREATE TABLE IF NOT EXISTS `cliente` (
  `idCliente` int(11) NOT NULL AUTO_INCREMENT,
  `nomeRazao` varchar(60) NOT NULL,
  `cpfCnpj` varchar(45) NOT NULL,
  `rgIe` varchar(45) DEFAULT NULL,
  `dataNascAbertura` date DEFAULT NULL,
  `numero` varchar(45) DEFAULT NULL,
  `tipo` int(11) NOT NULL,
  `status` int(11) NOT NULL,
  PRIMARY KEY (`idCliente`),
  UNIQUE KEY `cpfCnpj` (`cpfCnpj`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estrutura da tabela `diaria`
--

CREATE TABLE IF NOT EXISTS `diaria` (
  `idDiaria` int(11) NOT NULL AUTO_INCREMENT,
  `valorDiaria` double NOT NULL,
  `descricao` varchar(100) DEFAULT NULL,
  `statusHospedagem` int(11) NOT NULL,
  `valorTotal` double NOT NULL,
  `statusPagamento` int(11) NOT NULL,
  `feitoEm` date NOT NULL,
  `pagoEm` date DEFAULT NULL,
  `usuario_idUsuario` int(11) NOT NULL,
  `cliente_idCliente` int(11) NOT NULL,
  `pendencias_idPendencias` int(11) DEFAULT NULL,
  PRIMARY KEY (`idDiaria`),
  KEY `usuario_idUsuario` (`usuario_idUsuario`),
  KEY `cliente_idCliente` (`cliente_idCliente`),
  KEY `pendencias_idPendencias` (`pendencias_idPendencias`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estrutura da tabela `diaria_quarto`
--

CREATE TABLE IF NOT EXISTS `diaria_quarto` (
  `diaria_idDiaria` int(11) NOT NULL,
  `quarto_idQuarto` int(11) NOT NULL,
  `valorAtual` double NOT NULL,
  `checkIn` date NOT NULL,
  `checkOut` date DEFAULT NULL,
  PRIMARY KEY (`diaria_idDiaria`,`quarto_idQuarto`),
  KEY `quarto_idQuarto` (`quarto_idQuarto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estrutura da tabela `diaria_quarto_servico`
--

CREATE TABLE IF NOT EXISTS `diaria_quarto_servico` (
  `diaria_idDiaria` int(11) NOT NULL,
  `quarto_idQuarto` int(11) NOT NULL,
  `servico_idServico` int(11) NOT NULL,
  `valorServicoAtual` double NOT NULL,
  `tipoContratacao` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`diaria_idDiaria`,`quarto_idQuarto`,`servico_idServico`),
  KEY `servico_idServico` (`servico_idServico`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estrutura da tabela `menu`
--

CREATE TABLE IF NOT EXISTS `menu` (
  `idMenu` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(45) NOT NULL,
  `link` varchar(100) NOT NULL,
  `icone` varchar(45) DEFAULT NULL,
  `exibir` int(11) NOT NULL,
  PRIMARY KEY (`idMenu`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estrutura da tabela `menu_perfil`
--

CREATE TABLE IF NOT EXISTS `menu_perfil` (
  `menu_idMenu` int(11) NOT NULL,
  `perfil_idPerfil` int(11) NOT NULL,
  `menusVinculados` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`menusVinculados`)),
  `menusNaoVinculados` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`menusNaoVinculados`)),
  PRIMARY KEY (`menu_idMenu`,`perfil_idPerfil`),
  KEY `perfil_idPerfil` (`perfil_idPerfil`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estrutura da tabela `pendencias`
--

CREATE TABLE IF NOT EXISTS `pendencias` (
  `idPendencias` int(11) NOT NULL AUTO_INCREMENT,
  `descricao` varchar(100) DEFAULT NULL,
  `valor` double NOT NULL,
  `dataRegistro` date NOT NULL,
  `status` int(11) NOT NULL,
  `diaria_quarto_servico_diaria_quarto_diaria_idDiaria` int(11) DEFAULT NULL,
  `diaria_quarto_servico_diaria_quarto_idQuarto` int(11) DEFAULT NULL,
  `diaria_quarto_servico_servico_idServico` int(11) DEFAULT NULL,
  PRIMARY KEY (`idPendencias`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estrutura da tabela `perfil`
--

CREATE TABLE IF NOT EXISTS `perfil` (
  `idPerfil` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(45) NOT NULL,
  `status` int(11) NOT NULL,
  PRIMARY KEY (`idPerfil`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estrutura da tabela `quarto`
--

CREATE TABLE IF NOT EXISTS `quarto` (
  `idQuarto` int(11) NOT NULL AUTO_INCREMENT,
  `numero` int(11) NOT NULL,
  `tipo` int(11) NOT NULL,
  `descricao` varchar(100) DEFAULT NULL,
  `valor` double NOT NULL,
  `status` int(11) NOT NULL,
  PRIMARY KEY (`idQuarto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estrutura da tabela `servico`
--

CREATE TABLE IF NOT EXISTS `servico` (
  `idServico` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(45) NOT NULL,
  `valor` double NOT NULL,
  `status` int(11) NOT NULL,
  PRIMARY KEY (`idServico`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estrutura da tabela `usuario`
--

CREATE TABLE IF NOT EXISTS `usuario` (
  `idUsuario` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(45) NOT NULL,
  `login` varchar(45) NOT NULL,
  `senha` varchar(45) NOT NULL,
  `dataNasc` date DEFAULT NULL,
  `status` int(11) NOT NULL,
  `perfil_idPerfil` int(11) NOT NULL,
  PRIMARY KEY (`idUsuario`),
  UNIQUE KEY `login` (`login`),
  KEY `perfil_idPerfil` (`perfil_idPerfil`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Chaves estrangeiras são adicionadas apenas quando ainda não existem,
-- para permitir executar novamente o script sem duplicar restrições.
SET @constraint_exists = (
  SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS
  WHERE CONSTRAINT_SCHEMA = DATABASE()
    AND TABLE_NAME = 'diaria'
    AND CONSTRAINT_NAME = 'diaria_ibfk_1'
);
SET @sql = IF(@constraint_exists = 0,
  'ALTER TABLE `diaria`
     ADD CONSTRAINT `diaria_ibfk_1` FOREIGN KEY (`usuario_idUsuario`) REFERENCES `usuario` (`idUsuario`),
     ADD CONSTRAINT `diaria_ibfk_2` FOREIGN KEY (`cliente_idCliente`) REFERENCES `cliente` (`idCliente`),
     ADD CONSTRAINT `diaria_ibfk_3` FOREIGN KEY (`pendencias_idPendencias`) REFERENCES `pendencias` (`idPendencias`)',
  'SELECT 1');
PREPARE schema_stmt FROM @sql;
EXECUTE schema_stmt;
DEALLOCATE PREPARE schema_stmt;

SET @constraint_exists = (
  SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS
  WHERE CONSTRAINT_SCHEMA = DATABASE()
    AND TABLE_NAME = 'pendencias'
    AND CONSTRAINT_NAME = 'pendencias_ibfk_1'
);
SET @sql = IF(@constraint_exists = 0,
  'ALTER TABLE `pendencias`
     ADD CONSTRAINT `pendencias_ibfk_1`
     FOREIGN KEY (`diaria_quarto_servico_diaria_quarto_diaria_idDiaria`, `diaria_quarto_servico_diaria_quarto_idQuarto`, `diaria_quarto_servico_servico_idServico`)
     REFERENCES `diaria_quarto_servico` (`diaria_idDiaria`, `quarto_idQuarto`, `servico_idServico`)',
  'SELECT 1');
PREPARE schema_stmt FROM @sql;
EXECUTE schema_stmt;
DEALLOCATE PREPARE schema_stmt;

SET @constraint_exists = (
  SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS
  WHERE CONSTRAINT_SCHEMA = DATABASE()
    AND TABLE_NAME = 'diaria_quarto'
    AND CONSTRAINT_NAME = 'diaria_quarto_ibfk_1'
);
SET @sql = IF(@constraint_exists = 0,
  'ALTER TABLE `diaria_quarto`
     ADD CONSTRAINT `diaria_quarto_ibfk_1` FOREIGN KEY (`diaria_idDiaria`) REFERENCES `diaria` (`idDiaria`) ON DELETE CASCADE,
     ADD CONSTRAINT `diaria_quarto_ibfk_2` FOREIGN KEY (`quarto_idQuarto`) REFERENCES `quarto` (`idQuarto`) ON DELETE CASCADE',
  'SELECT 1');
PREPARE schema_stmt FROM @sql;
EXECUTE schema_stmt;
DEALLOCATE PREPARE schema_stmt;

SET @constraint_exists = (
  SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS
  WHERE CONSTRAINT_SCHEMA = DATABASE()
    AND TABLE_NAME = 'diaria_quarto_servico'
    AND CONSTRAINT_NAME = 'diaria_quarto_servico_ibfk_1'
);
SET @sql = IF(@constraint_exists = 0,
  'ALTER TABLE `diaria_quarto_servico`
     ADD CONSTRAINT `diaria_quarto_servico_ibfk_1` FOREIGN KEY (`diaria_idDiaria`, `quarto_idQuarto`) REFERENCES `diaria_quarto` (`diaria_idDiaria`, `quarto_idQuarto`) ON DELETE CASCADE,
     ADD CONSTRAINT `diaria_quarto_servico_ibfk_2` FOREIGN KEY (`servico_idServico`) REFERENCES `servico` (`idServico`) ON DELETE CASCADE',
  'SELECT 1');
PREPARE schema_stmt FROM @sql;
EXECUTE schema_stmt;
DEALLOCATE PREPARE schema_stmt;

SET @constraint_exists = (
  SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS
  WHERE CONSTRAINT_SCHEMA = DATABASE()
    AND TABLE_NAME = 'menu_perfil'
    AND CONSTRAINT_NAME = 'menu_perfil_ibfk_1'
);
SET @sql = IF(@constraint_exists = 0,
  'ALTER TABLE `menu_perfil`
     ADD CONSTRAINT `menu_perfil_ibfk_1` FOREIGN KEY (`menu_idMenu`) REFERENCES `menu` (`idMenu`) ON DELETE CASCADE,
     ADD CONSTRAINT `menu_perfil_ibfk_2` FOREIGN KEY (`perfil_idPerfil`) REFERENCES `perfil` (`idPerfil`) ON DELETE CASCADE',
  'SELECT 1');
PREPARE schema_stmt FROM @sql;
EXECUTE schema_stmt;
DEALLOCATE PREPARE schema_stmt;

SET @constraint_exists = (
  SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS
  WHERE CONSTRAINT_SCHEMA = DATABASE()
    AND TABLE_NAME = 'usuario'
    AND CONSTRAINT_NAME = 'usuario_ibfk_1'
);
SET @sql = IF(@constraint_exists = 0,
  'ALTER TABLE `usuario`
     ADD CONSTRAINT `usuario_ibfk_1` FOREIGN KEY (`perfil_idPerfil`) REFERENCES `perfil` (`idPerfil`)',
  'SELECT 1');
PREPARE schema_stmt FROM @sql;
EXECUTE schema_stmt;
DEALLOCATE PREPARE schema_stmt;

--
-- Perfis e permissões iniciais definidos pelos casos de uso do TCC.
-- Os registros de permissão ficam ocultos na navegação; somente os módulos
-- marcados com exibir=1 aparecem como itens do menu.
--
INSERT INTO `perfil` (`nome`, `status`)
SELECT 'Auxiliar de limpeza', 1
WHERE NOT EXISTS (SELECT 1 FROM `perfil` WHERE `nome` = 'Auxiliar de limpeza');

INSERT INTO `perfil` (`nome`, `status`)
SELECT 'Atendente', 1
WHERE NOT EXISTS (SELECT 1 FROM `perfil` WHERE `nome` = 'Atendente');

INSERT INTO `perfil` (`nome`, `status`)
SELECT 'Gerente', 1
WHERE NOT EXISTS (SELECT 1 FROM `perfil` WHERE `nome` = 'Gerente');

INSERT INTO `perfil` (`nome`, `status`)
SELECT 'Administrador', 1
WHERE NOT EXISTS (SELECT 1 FROM `perfil` WHERE `nome` = 'Administrador');

INSERT INTO `menu` (`nome`, `link`, `icone`, `exibir`)
SELECT seed.`nome`, seed.`link`, seed.`icone`, seed.`exibir`
FROM (
    SELECT 'Início' AS `nome`, 'index.jsp' AS `link`, 'home' AS `icone`, 1 AS `exibir`
    UNION ALL SELECT 'Clientes', 'gerenciar_cliente.do?acao=listarTodos', 'users', 1
    UNION ALL SELECT 'Quartos', 'gerenciar_quarto.do?acao=listarTodos', 'bed', 1
    UNION ALL SELECT 'Serviços', 'gerenciar_servico.do?acao=listarTodos', 'star', 1
    UNION ALL SELECT 'Diárias', 'gerenciar_diaria.do?acao=listarTodos', 'calendar', 1
    UNION ALL SELECT 'Pendências', 'gerenciar_pendencias.do?acao=listarTodos', 'alert', 1
    UNION ALL SELECT 'Usuários', 'gerenciar_usuario.do?acao=listarTodos', 'user', 1
    UNION ALL SELECT 'Perfis', 'gerenciar_perfil.do?acao=listarTodos', 'shield', 1
    UNION ALL SELECT 'Menus', 'gerenciar_menu.do?acao=listarTodos', 'menu', 1
    UNION ALL SELECT 'Cadastrar cliente', 'gerenciar_cliente.do?acao=cadastrar', NULL, 0
    UNION ALL SELECT 'Alterar cliente', 'gerenciar_cliente.do?acao=alterar', NULL, 0
    UNION ALL SELECT 'Desativar cliente', 'gerenciar_cliente.do?acao=desativar', NULL, 0
    UNION ALL SELECT 'Cadastrar quarto', 'gerenciar_quarto.do?acao=cadastrar', NULL, 0
    UNION ALL SELECT 'Novo quarto', 'gerenciar_quarto.do?acao=novo', NULL, 0
    UNION ALL SELECT 'Alterar quarto', 'gerenciar_quarto.do?acao=alterar', NULL, 0
    UNION ALL SELECT 'Desativar quarto', 'gerenciar_quarto.do?acao=desativar', NULL, 0
    UNION ALL SELECT 'Cadastrar serviço', 'gerenciar_servico.do?acao=cadastrar', NULL, 0
    UNION ALL SELECT 'Alterar serviço', 'gerenciar_servico.do?acao=alterar', NULL, 0
    UNION ALL SELECT 'Desativar serviço', 'gerenciar_servico.do?acao=desativar', NULL, 0
    UNION ALL SELECT 'Excluir serviço', 'gerenciar_servico.do?acao=excluir', NULL, 0
    UNION ALL SELECT 'Criar diária', 'gerenciar_diaria.do?acao=novaDiaria', NULL, 0
    UNION ALL SELECT 'Gravar diária', 'gerenciar_diaria.do?acao=gravar', NULL, 0
    UNION ALL SELECT 'Alterar diária', 'gerenciar_diaria.do?acao=alterar', NULL, 0
    UNION ALL SELECT 'Desativar diária', 'gerenciar_diaria.do?acao=desativar', NULL, 0
    UNION ALL SELECT 'Adicionar quarto à diária', 'gerenciar_diaria.do?acao=adicionarQuarto', NULL, 0
    UNION ALL SELECT 'Retirar quarto da diária', 'gerenciar_diaria.do?acao=retirarQuarto', NULL, 0
    UNION ALL SELECT 'Gerenciar quartos da diária', 'gerenciar_diaria_quarto.do?acao=gerenciar', NULL, 0
    UNION ALL SELECT 'Vincular quarto à diária', 'gerenciar_diaria_quarto.do?acao=vincular', NULL, 0
    UNION ALL SELECT 'Desvincular quarto da diária', 'gerenciar_diaria_quarto.do?acao=desvincular', NULL, 0
    UNION ALL SELECT 'Gerenciar serviços da diária', 'gerenciar_diaria_quarto_servico.do?acao=gerenciar', NULL, 0
    UNION ALL SELECT 'Vincular serviço à diária', 'gerenciar_diaria_quarto_servico.do?acao=vincular', NULL, 0
    UNION ALL SELECT 'Desvincular serviço da diária', 'gerenciar_diaria_quarto_servico.do?acao=desvincular', NULL, 0
    UNION ALL SELECT 'Cadastrar pendência', 'gerenciar_pendencias.do?acao=cadastrar', NULL, 0
    UNION ALL SELECT 'Alterar pendência', 'gerenciar_pendencias.do?acao=alterar', NULL, 0
    UNION ALL SELECT 'Desativar pendência', 'gerenciar_pendencias.do?acao=desativar', NULL, 0
    UNION ALL SELECT 'Cadastrar usuário', 'gerenciar_usuario.do?acao=cadastrar', NULL, 0
    UNION ALL SELECT 'Alterar usuário', 'gerenciar_usuario.do?acao=alterar', NULL, 0
    UNION ALL SELECT 'Desativar usuário', 'gerenciar_usuario.do?acao=desativar', NULL, 0
    UNION ALL SELECT 'Cadastrar perfil', 'gerenciar_perfil.do?acao=cadastrar', NULL, 0
    UNION ALL SELECT 'Alterar perfil', 'gerenciar_perfil.do?acao=alterar', NULL, 0
    UNION ALL SELECT 'Desativar perfil', 'gerenciar_perfil.do?acao=desativar', NULL, 0
    UNION ALL SELECT 'Cadastrar menu', 'gerenciar_menu.do?acao=cadastrar', NULL, 0
    UNION ALL SELECT 'Alterar menu', 'gerenciar_menu.do?acao=alterar', NULL, 0
    UNION ALL SELECT 'Excluir menu', 'gerenciar_menu.do?acao=excluir', NULL, 0
    UNION ALL SELECT 'Gerenciar menus do perfil', 'gerenciar_menu_perfil.do?acao=gerenciar', NULL, 0
    UNION ALL SELECT 'Vincular menu ao perfil', 'gerenciar_menu_perfil.do?acao=vincular', NULL, 0
    UNION ALL SELECT 'Desvincular menu do perfil', 'gerenciar_menu_perfil.do?acao=desvincular', NULL, 0
) AS seed
WHERE NOT EXISTS (
    SELECT 1 FROM `menu` existing WHERE existing.`link` = seed.`link`
);

-- Reaplica a política de acesso às pendências somente aos três perfis autorizados.
DELETE mp
FROM `menu_perfil` mp
JOIN `menu` m ON m.`idMenu` = mp.`menu_idMenu`
WHERE m.`link` IN (
      'gerenciar_pendencias.do?acao=listarTodos',
      'gerenciar_pendencias.do?acao=cadastrar',
      'gerenciar_pendencias.do?acao=alterar',
      'gerenciar_pendencias.do?acao=desativar'
  );

-- Auxiliar de limpeza: consulta e altera quartos.
INSERT INTO `menu_perfil` (`menu_idMenu`, `perfil_idPerfil`)
SELECT m.`idMenu`, p.`idPerfil`
FROM `menu` m
JOIN `perfil` p ON p.`nome` = 'Auxiliar de limpeza'
WHERE m.`link` IN (
    'index.jsp',
    'gerenciar_quarto.do?acao=listarTodos',
    'gerenciar_quarto.do?acao=alterar'
)
AND NOT EXISTS (
    SELECT 1 FROM `menu_perfil` mp
    WHERE mp.`menu_idMenu` = m.`idMenu` AND mp.`perfil_idPerfil` = p.`idPerfil`
);

-- Atendente: atendimento, consulta de equipe, operação de serviços e pendências.
INSERT INTO `menu_perfil` (`menu_idMenu`, `perfil_idPerfil`)
SELECT m.`idMenu`, p.`idPerfil`
FROM `menu` m
JOIN `perfil` p ON p.`nome` = 'Atendente'
WHERE m.`link` IN (
    'index.jsp',
    'gerenciar_cliente.do?acao=listarTodos',
    'gerenciar_cliente.do?acao=cadastrar',
    'gerenciar_cliente.do?acao=alterar',
    'gerenciar_quarto.do?acao=listarTodos',
    'gerenciar_quarto.do?acao=alterar',
    'gerenciar_servico.do?acao=listarTodos',
    'gerenciar_servico.do?acao=cadastrar',
    'gerenciar_servico.do?acao=alterar',
    'gerenciar_servico.do?acao=desativar',
    'gerenciar_servico.do?acao=excluir',
    'gerenciar_usuario.do?acao=listarTodos',
    'gerenciar_diaria.do?acao=listarTodos',
    'gerenciar_diaria_quarto.do?acao=gerenciar',
    'gerenciar_diaria_quarto.do?acao=desvincular',
    'gerenciar_diaria_quarto_servico.do?acao=gerenciar',
    'gerenciar_diaria_quarto_servico.do?acao=vincular',
    'gerenciar_diaria_quarto_servico.do?acao=desvincular',
    'gerenciar_pendencias.do?acao=listarTodos',
    'gerenciar_pendencias.do?acao=cadastrar',
    'gerenciar_pendencias.do?acao=alterar',
    'gerenciar_pendencias.do?acao=desativar'
)
AND NOT EXISTS (
    SELECT 1 FROM `menu_perfil` mp
    WHERE mp.`menu_idMenu` = m.`idMenu` AND mp.`perfil_idPerfil` = p.`idPerfil`
);

-- Gerente: operações administrativas e manutenção de usuários/perfis.
INSERT INTO `menu_perfil` (`menu_idMenu`, `perfil_idPerfil`)
SELECT m.`idMenu`, p.`idPerfil`
FROM `menu` m
JOIN `perfil` p ON p.`nome` = 'Gerente'
WHERE m.`link` IN (
    'index.jsp',
    'gerenciar_cliente.do?acao=listarTodos',
    'gerenciar_cliente.do?acao=cadastrar',
    'gerenciar_cliente.do?acao=alterar',
    'gerenciar_cliente.do?acao=desativar',
    'gerenciar_quarto.do?acao=listarTodos',
    'gerenciar_quarto.do?acao=novo',
    'gerenciar_quarto.do?acao=cadastrar',
    'gerenciar_quarto.do?acao=alterar',
    'gerenciar_quarto.do?acao=desativar',
    'gerenciar_servico.do?acao=listarTodos',
    'gerenciar_servico.do?acao=cadastrar',
    'gerenciar_servico.do?acao=alterar',
    'gerenciar_servico.do?acao=desativar',
    'gerenciar_servico.do?acao=excluir',
    'gerenciar_usuario.do?acao=listarTodos',
    'gerenciar_usuario.do?acao=cadastrar',
    'gerenciar_usuario.do?acao=alterar',
    'gerenciar_usuario.do?acao=desativar',
    'gerenciar_diaria.do?acao=listarTodos',
    'gerenciar_diaria.do?acao=novaDiaria',
    'gerenciar_diaria.do?acao=gravar',
    'gerenciar_diaria.do?acao=alterar',
    'gerenciar_diaria.do?acao=desativar',
    'gerenciar_diaria.do?acao=adicionarQuarto',
    'gerenciar_diaria.do?acao=retirarQuarto',
    'gerenciar_diaria_quarto.do?acao=gerenciar',
    'gerenciar_diaria_quarto.do?acao=vincular',
    'gerenciar_diaria_quarto.do?acao=desvincular',
    'gerenciar_diaria_quarto_servico.do?acao=gerenciar',
    'gerenciar_diaria_quarto_servico.do?acao=vincular',
    'gerenciar_diaria_quarto_servico.do?acao=desvincular',
    'gerenciar_pendencias.do?acao=listarTodos',
    'gerenciar_pendencias.do?acao=cadastrar',
    'gerenciar_pendencias.do?acao=alterar',
    'gerenciar_pendencias.do?acao=desativar',
    'gerenciar_perfil.do?acao=listarTodos',
    'gerenciar_perfil.do?acao=cadastrar',
    'gerenciar_perfil.do?acao=alterar',
    'gerenciar_perfil.do?acao=desativar'
)
AND NOT EXISTS (
    SELECT 1 FROM `menu_perfil` mp
    WHERE mp.`menu_idMenu` = m.`idMenu` AND mp.`perfil_idPerfil` = p.`idPerfil`
);

-- Administrador: todos os casos de uso, inclusive manutenção de menus e permissões.
INSERT INTO `menu_perfil` (`menu_idMenu`, `perfil_idPerfil`)
SELECT m.`idMenu`, p.`idPerfil`
FROM `menu` m
JOIN `perfil` p ON p.`nome` = 'Administrador'
WHERE m.`link` IN (
    'index.jsp',
    'gerenciar_cliente.do?acao=listarTodos',
    'gerenciar_cliente.do?acao=cadastrar',
    'gerenciar_cliente.do?acao=alterar',
    'gerenciar_cliente.do?acao=desativar',
    'gerenciar_quarto.do?acao=listarTodos',
    'gerenciar_quarto.do?acao=novo',
    'gerenciar_quarto.do?acao=cadastrar',
    'gerenciar_quarto.do?acao=alterar',
    'gerenciar_quarto.do?acao=desativar',
    'gerenciar_servico.do?acao=listarTodos',
    'gerenciar_servico.do?acao=cadastrar',
    'gerenciar_servico.do?acao=alterar',
    'gerenciar_servico.do?acao=desativar',
    'gerenciar_servico.do?acao=excluir',
    'gerenciar_usuario.do?acao=listarTodos',
    'gerenciar_usuario.do?acao=cadastrar',
    'gerenciar_usuario.do?acao=alterar',
    'gerenciar_usuario.do?acao=desativar',
    'gerenciar_diaria.do?acao=listarTodos',
    'gerenciar_diaria.do?acao=novaDiaria',
    'gerenciar_diaria.do?acao=gravar',
    'gerenciar_diaria.do?acao=alterar',
    'gerenciar_diaria.do?acao=desativar',
    'gerenciar_diaria.do?acao=adicionarQuarto',
    'gerenciar_diaria.do?acao=retirarQuarto',
    'gerenciar_diaria_quarto.do?acao=gerenciar',
    'gerenciar_diaria_quarto.do?acao=vincular',
    'gerenciar_diaria_quarto.do?acao=desvincular',
    'gerenciar_diaria_quarto_servico.do?acao=gerenciar',
    'gerenciar_diaria_quarto_servico.do?acao=vincular',
    'gerenciar_diaria_quarto_servico.do?acao=desvincular',
    'gerenciar_pendencias.do?acao=listarTodos',
    'gerenciar_pendencias.do?acao=cadastrar',
    'gerenciar_pendencias.do?acao=alterar',
    'gerenciar_pendencias.do?acao=desativar',
    'gerenciar_perfil.do?acao=listarTodos',
    'gerenciar_perfil.do?acao=cadastrar',
    'gerenciar_perfil.do?acao=alterar',
    'gerenciar_perfil.do?acao=desativar',
    'gerenciar_menu.do?acao=listarTodos',
    'gerenciar_menu.do?acao=cadastrar',
    'gerenciar_menu.do?acao=alterar',
    'gerenciar_menu.do?acao=excluir',
    'gerenciar_menu_perfil.do?acao=gerenciar',
    'gerenciar_menu_perfil.do?acao=vincular',
    'gerenciar_menu_perfil.do?acao=desvincular'
)
AND NOT EXISTS (
    SELECT 1 FROM `menu_perfil` mp
    WHERE mp.`menu_idMenu` = m.`idMenu` AND mp.`perfil_idPerfil` = p.`idPerfil`
);
COMMIT;
